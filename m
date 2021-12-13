Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3A347325A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 17:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbhLMQzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 11:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbhLMQy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 11:54:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD23C0617A1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 08:54:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gt5so12298302pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 08:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AA3cmGxjX7rQ7Nx4YLnLHex97OOC6jIUqWvPUCK4d4I=;
        b=iRjD5da3CL6RA/latOqqXOupbElJzpRlpjwTJ8TqDONfl5WIJDZprRk5SK29fgOSkY
         N9hnANhBHCZMe/K+03c1NveVYvuszrsdJe8Cbq0m4EtExXWlaCP6TFvVryopRMN+Gt2Q
         WW1fsRfVwiK2FDt7ynDhuyeQevMJ9awzfLQtM4ecGk1C7jN0vMMsXBCtykgpWHC45kdm
         1cuQ75hkRoxMYxbJyvnhXXHki5jkQjP9EOTulzyrk2VrDclrhd5tXbiY7FO24+SqKm9D
         EXlTZtDyvrREtrDFhx7DtXnZHgmw4EZMZtwORpWerh3eBwi8HhpDTRQYQBDzwlXcwX93
         e0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AA3cmGxjX7rQ7Nx4YLnLHex97OOC6jIUqWvPUCK4d4I=;
        b=H34dZ5QnZjbFvLKImJfgbq/rjYw3WiQisXwloHSzUE2afzU18+iqGJmSxNyukz9WoV
         8W1c0Or2gf29GxHewFK6b7h2lxkCMkUefZVNjOrRQukIeibTeZVTOWxdtEm9/DAQIk37
         44OJCyFW/PMDzyC98PbnufX1djjsnad1db/SHpkgXlHM/aahhKkYvnyiHKBwqtQeUtqx
         Ytqti3fbLCXgdQstn4KcpUgZfh+ck1xyV8xGxgeacRrFWf3jOM9CfsqRSFzheL5Ypn2a
         dMFebiqDKMu2SZe8OlOEmsFuMaHCzDBKt5KSFn310FZ/vNkRQoiakeDFvgh33Emx4+PU
         YECA==
X-Gm-Message-State: AOAM531efoti0+JZ3ePQu1423HRwYng4qZ25YETo1UZLE5ie/iwwn7g+
        nbAzh4SBQ33igoNaXQGuBgc9RA==
X-Google-Smtp-Source: ABdhPJyTgegmMEhcIYWAwl3DrUFQNFLkahj1X0m9a7EeXwVZUJuv36hfE0mmLT4nhioZz35NV2uMCg==
X-Received: by 2002:a17:90b:34b:: with SMTP id fh11mr45254545pjb.14.1639414497559;
        Mon, 13 Dec 2021 08:54:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l9sm13637501pfu.55.2021.12.13.08.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:54:57 -0800 (PST)
Date:   Mon, 13 Dec 2021 16:54:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Message-ID: <Ybd63U3f9kXrMVEs@google.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com>
 <Ya/5MOYef4L4UUAb@google.com>
 <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
 <YbPBjdAz1GQGr8DT@google.com>
 <42701fedbe10acf164ec56818b941061be6ffd4e.camel@redhat.com>
 <56281d07-de85-69be-8855-71e7219e0227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56281d07-de85-69be-8855-71e7219e0227@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021, Paolo Bonzini wrote:
> On 12/11/21 07:56, Maxim Levitsky wrote:
> > > This apparently wasn't validated against a simple use case, let
> > > alone against things like migration with nested VMs, multliple L2s,
> > > etc...
> > 
> > I did validate the *SREGS2* against all the cases I could (like
> > migration, EPT/NPT disabled/etc. I even started testing SMM to see
> > how it affects PDPTRs, and patched seabios to use PAE paging. I still
> > could have missed something.
> 
> Don't worry, I think Sean was talking about patch 16 and specifically
> digging at me (who deserved it completely).

Yes, patch 16.  My goal wasn't to dig at anyone, I just wanted to dramatically
emphasize how ridiculousy fragile and complex the PDPTR crud is due to the number
of edge cases.
