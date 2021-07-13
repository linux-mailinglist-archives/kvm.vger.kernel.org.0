Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F14D3C77FA
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhGMUb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMUbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:31:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC17C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:28:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z2so34720plg.8
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LxJNrLcxo+1XG3xReG2GznPJ80Kx/41M8LyFkMVe9nw=;
        b=LVyHap2ItF10BDhXeoGpLsMsy+Kpnq9zg/VQMqQpe+4mMVxsfeZi19ErCqjwPe5z8q
         HQKrMF+TJEetLHunq9crVxN3cFqO1Vh3hVt9uMxSyRt1oCmdGtQmEYiaPNtMFG1dOLhS
         0PKdV6y+2xXlS371/sZsYdffhk5gU3LcuI8g1Ew7QtwKPbNT0t6ERuHwMATY7aMc44Ah
         +qPzcshSyQD404qt0kkXjBvA+3TvfjlwyceRHG+x/Ys3h6E1VlDvQry4y3lJPZGMrQ2n
         Ura6G70OULrhe4kwCL1L2LDG8QToCyDlW791EVIza0Ew0evTCVTlTbdJYlnyCCpXw2bs
         RTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LxJNrLcxo+1XG3xReG2GznPJ80Kx/41M8LyFkMVe9nw=;
        b=fc836v+r/8WIqmPrie+kUGllb0JyY7QrXILg7tziJI6yg4jnNzJYYCTEDN0YJEddRc
         s1XQOBcJSJQl+DQ/0XIlSmMuLD6af0Gc4w+4JoIf2O+K5jyDQojJtC4k/epZvFfDSqFR
         Y8vHkkjtUT92BB0KFd+NoEV0jtDRNzBUgJ/O1UMvjhUWoT6fJkEAk82MEdzKlnG4lNn5
         YcA5W0hz6l1p+dB2P42T0bpHuY6765eTukEF448gJo9apI6jHWYwUJUCVOBAiFCyBaG/
         ibQye4/VmQ8Nhq06vYvYx85QET6uP5M/uRCB8cuPBlB05x5XuSmmS93nEbJkfkDYfFHS
         jUBQ==
X-Gm-Message-State: AOAM5328PuS0a1MolsV26iGnbRwDJMrhUjUqrgtEGRz6S21WG8gLXcMv
        wU+rrZ5NTLuBeTp01NrrG9KRaw==
X-Google-Smtp-Source: ABdhPJyX+I+K9qk9PMf8bCXNz0VTk1pIktY4RsEHVeMVTqDe/l6s4cyo0FaDlkFoCm8rvOHptNsbJQ==
X-Received: by 2002:a17:902:bcc7:b029:12b:32c5:3d31 with SMTP id o7-20020a170902bcc7b029012b32c53d31mr3245556pls.55.1626208113905;
        Tue, 13 Jul 2021 13:28:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u24sm32501pfm.141.2021.07.13.13.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 13:28:33 -0700 (PDT)
Date:   Tue, 13 Jul 2021 20:28:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 20/69] KVM: x86/mmu: Mark VM as bugged if page
 fault returns RET_PF_INVALID
Message-ID: <YO33bT2q3AfTspcO@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <298980aa5fc5707184ac082287d13a800cd9c25f.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298980aa5fc5707184ac082287d13a800cd9c25f.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

For a changelog:

  Mark a VM as bugged instead of simply warning if the core page fault
  handler unexpectedly returns RET_PF_INVALID.  KVM's (undocumented) API
  for the page fault path does not allow returning RET_PF_INVALID, e.g. a
  fatal condition should be morphed to -errno.

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
