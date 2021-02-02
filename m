Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFE030CF2A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhBBWiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbhBBWhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:37:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3F2C0613D6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 14:36:43 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g3so13342801plp.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 14:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oIoSVPmKEl02Ry4qgP49tJ5d1MCtOFHz6Id8es99aQ8=;
        b=NrGjY7tv1aLp8A57+KA0gWARf4pkOWcwXtWLuuy3XjI1mrlAY6O+U1gqDcuT7LE9Y2
         PNdq+knh6vPvHwLSc23PsZkro0J41BgAghcIX7NyCga1GYJ7lqHdADbKKaNcurFrFvth
         iCjYm0lErxUBkiDwJKpj0a8oTtsYwlSqAyfRiKIMFEJ0tWfqBL6N8kVSUrOm/jq5aJkI
         OkIOQiwxgVOB99mD+AgNuMrSHDfs6JJcb0NXj4l98HyUHryOiTsmaZj9+8jl1ygSjsNV
         5qVuBXePJAaWJrQo/PEqwK0EW6xj4gNaz+HIXXSbRh+9oc1kYFfj9DSNtK0LvLh308zN
         xPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oIoSVPmKEl02Ry4qgP49tJ5d1MCtOFHz6Id8es99aQ8=;
        b=WBnO5zg8KngqAdFsA6etdvpIrnmEPKfKRf0xh+W8pAv4Bhcw0eDRM363blmaq4TBb5
         kHbK47DMTyGsQ7l5mbQWopx5v8BXp16+NlxJWtgftYFmY/c978jp2jbAitPsx79tDdhl
         /U9AdXbH6UcYrlObmflzT1X/9aT09MBS17uKEhrziPxJKNvMbBGaPkq4LJuUa/wB0Uo5
         rZP3uKS5oujJ+nJ6tf6DpXQuf+jdL9KJVIxZchofafZ3JGlEhUP+9gZhnNcJ0M/SIokQ
         rO1IoR9E4/8TDsj9FAf/fQjk7AE3wod2H2QNi0vdYRsw36SzlroqwhvZfSxjzNtft+Nn
         /JrQ==
X-Gm-Message-State: AOAM531mWl2VJfU2lmk+7n9MnUTglZ55vM/B5MubCOaLdUmzB1tsFfye
        sLyV9FghtQiREuM5TgKXAJQqqQ==
X-Google-Smtp-Source: ABdhPJzb7AOmzJ3vsd9oEZgebXCp7mHor62Iu3XCT60QLwa6RwOTaru7ziqdbYETgXLnMBoYioMHjA==
X-Received: by 2002:a17:902:eccb:b029:de:8483:505d with SMTP id a11-20020a170902eccbb02900de8483505dmr93607plh.63.1612305402511;
        Tue, 02 Feb 2021 14:36:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id k5sm39512pfi.31.2021.02.02.14.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 14:36:41 -0800 (PST)
Date:   Tue, 2 Feb 2021 14:36:35 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: Use 'unsigned long' for the physical address
 passed to VMSAVE
Message-ID: <YBnT82xRKZkxbsN2@google.com>
References: <20210202223416.2702336-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202223416.2702336-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Sean Christopherson wrote:
> Take an 'unsigned long' instead of 'hpa_t' in the recently added vmsave()
> helper, as loading a 64-bit GPR isn't possible in 32-bit mode.  This is
> properly reflected in the SVM ISA, which explicitly states that VMSAVE,
> VMLOAD, VMRUN, etc... consume rAX based on the effective address size.
> 
> Don't bother with a WARN to detect breakage on 32-bit KVM, the VMCB PA is
> stored as an 'unsigned long', i.e. the bad address is long since gone.
> Not to mention that a 32-bit kernel is completely hosed if alloc_page()
> hands out pages in high memory.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Robert Hu <robert.hu@intel.com>
> Cc: Farrah Chen <farrah.chen@intel.com>
> Cc: Danmei Wei <danmei.wei@intel.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Forgot got the Fixes tag.  Or just squash this.

Fixes: f84a54c04540 ("KVM: SVM: Use asm goto to handle unexpected #UD on SVM instructions")

> ---
>  arch/x86/kvm/svm/svm_ops.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
> index 0c8377aee52c..9f007bc8409a 100644
> --- a/arch/x86/kvm/svm/svm_ops.h
> +++ b/arch/x86/kvm/svm/svm_ops.h
> @@ -51,7 +51,12 @@ static inline void invlpga(unsigned long addr, u32 asid)
>  	svm_asm2(invlpga, "c"(asid), "a"(addr));
>  }
>  
> -static inline void vmsave(hpa_t pa)
> +/*
> + * Despite being a physical address, the portion of rAX that is consumed by
> + * VMSAVE, VMLOAD, etc... is still controlled by the effective address size,
> + * hence 'unsigned long' instead of 'hpa_t'.
> + */
> +static inline void vmsave(unsigned long pa)
>  {
>  	svm_asm1(vmsave, "a" (pa), "memory");
>  }
> -- 
> 2.30.0.365.g02bc693789-goog
> 
