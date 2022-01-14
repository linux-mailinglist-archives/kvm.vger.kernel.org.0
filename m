Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E948F328
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 00:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiANXld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 18:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiANXlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 18:41:32 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E60C06173E
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 15:41:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so23731628pjj.2
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 15:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S9TVED3i9RC7fwxDgleDKWv058qL2BYSPWiOl9zvsbw=;
        b=ScteoO2OOub3Yzf8DVmrjY0r2ZxfAsN3yS+mdXPRlTPv8RKiFDIG9VXJ8VKKhkiCDF
         pfdQK/2of/ysTOE9A3nA/wDiV2Q9bNVYx7x3aqMoBTzS1mwcqXFxfzsAi7xfTcRnELmS
         +ItjOizd35MBLv89sbf2h7L5k7U112HK6JYv9M4bNdyGTnPo3zT324QSORnkl6jKqbme
         u/x7wYx1i+Em6bRCccHii1VnbKFUzhhMuV2GnhoSXZShUSwlFm+kCrJnn3HBpZm4xB9x
         bBoxP9lwOnYXucs6AvILo1z3LkKfmoP/5sMqQZr7LHH0oZc2bp37II88ADg+K6BHH0Z2
         VFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S9TVED3i9RC7fwxDgleDKWv058qL2BYSPWiOl9zvsbw=;
        b=G0znKWcdv552L9itdDZ6IPoOAiV+F0mcEP57eHbCHQHi5Kt0U09TPct88j809/3bWQ
         IH3kVK8PbwwuNcwhOAaZyGX4R/pqOGwu8v8dOZ3JUzRIiPRfo9aipdzqZW6wQc1gK8RL
         8vq3eREyA00BdtZXIfQbI9bsUQrZEdQTalJKmIJaz9XjNhFz+C+a897xI2aaAox3hTYT
         zpAye3jQq4O6lU3kaSSZBO3YJ5j0EFy9pIghz2p6oT7onsH10kFGLpyB/UJQMHFM1GsQ
         u8M0Jr9oHe5S/Hlb11+eaJGvXQqLI+Ygk8MC1mnPszHaBgLX2vggGh80kZLA9rK+/6ZZ
         AOsw==
X-Gm-Message-State: AOAM533ErzXEzfggG3Y3o/m4dvF/HaMy3siGfbOLqbAXO/6D22l4taIN
        wmey+rtI8pyU1fjZF1r/890wHQ==
X-Google-Smtp-Source: ABdhPJxGmwNrgRndyFyHmuE2as+MBh642DHgDMdx0SvqGtKOMMo7OJGcGLi7dxlvoEAjVi/ZtMaADQ==
X-Received: by 2002:a17:90b:1c10:: with SMTP id oc16mr9261203pjb.50.1642203692160;
        Fri, 14 Jan 2022 15:41:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm14sm8742042pjb.13.2022.01.14.15.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:41:31 -0800 (PST)
Date:   Fri, 14 Jan 2022 23:41:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: x86/mmu: Clear MMU-writable during
 changed_pte notifier
Message-ID: <YeIKKAihn+rwLxcx@google.com>
References: <20220113233020.3986005-1-dmatlack@google.com>
 <20220113233020.3986005-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113233020.3986005-3-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> When handling the changed_pte notifier and the new PTE is read-only,
> clear both the Host-writable and MMU-writable bits in the SPTE. This
> preserves the invariant that MMU-writable is set if-and-only-if
> Host-writable is set.
> 
> No functional change intended. Nothing currently relies on the
> afformentioned invariant and technically the changed_pte notifier is
> dead code.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
