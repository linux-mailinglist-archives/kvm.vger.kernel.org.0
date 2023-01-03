Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3330965C6B2
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbjACSsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238563AbjACSqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:46:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C1AE60
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:46:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 60-20020a17090a0fc200b002264ebad204so10401448pjz.1
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vUBKTHLzQlFTilTKOe+he3Zfuv35jABiHO+4q1BFtZg=;
        b=RJwTBqwJSPg4pEOztqybJHHSc4f7SGD6gGq+OC5UUmXiVHhPJwAVNmccBXNsJqAstG
         Apu7yf9aRer10XeY/guXR80pyDnU8FMwVRIEFuN6VZQNXqhVgKOw1QXrqngmBOb9JJmm
         pV0UVJzPczypUguvqxu3Vc3NjURZRovXg3jP8D1Xo9F0ke6pKENqWmUgK0c/U9rlpNoN
         i96a0gfA/hwHIUKC7piNN3Z8fks9RhqTbnQY4oaY1u+ECetPDXsEZ3DNxtBd3XVntTjF
         yr2vfrV7pEGsELMQDSqG2P4kqYGmRYt07Zuk0kFId/+L2kHIv7ne4qUxix66oRHrK96q
         Htqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUBKTHLzQlFTilTKOe+he3Zfuv35jABiHO+4q1BFtZg=;
        b=pZQj75YM6DI/QZns3d3ZhhlRpYXhid9YHbBNWmEnW0iCpBfW02Dhw7HJoSQSHx2BM/
         aLtgT04vnw+iQCi7fva58hLxUD4Il2xicI9VfRe4gI91bmmxd4cnuVGN/pljCfXkD06Z
         EVCokVxxyluUsNA5rHp18QZYWHbvM/7lMuPqWhxlxCsR9O9pAHu06ZLPUJSsVYx1I86b
         zfJ1eU0YHQzNJv2AfsPFDyw1TgVVFdjt+DESl/HCGC6RNiQ+kjhtzqoCsUDbgB1VIsfk
         87LvBZb3GAhYywM0xswuaREg+ecdRcr+LWPPSkGVBYzM2YaGZkWIw+BRa8YP31nubYDo
         hkng==
X-Gm-Message-State: AFqh2ko5K3kMJqhB9AMO/QimIfOmLP2uFGjjFDVVgqVYiI8OAk10kgE5
        1GPIgQvDsf3PfN6vc84w4PH6uA==
X-Google-Smtp-Source: AMrXdXtC5icJu1Wu92PpjdTohwtshRtCDMvnGh3zyEu+ZRAb5mZCIiaNOy7D5q29ykTjsiKpcSX1SA==
X-Received: by 2002:a17:90a:f2d6:b0:225:e576:a577 with SMTP id gt22-20020a17090af2d600b00225e576a577mr2107389pjb.0.1672771568240;
        Tue, 03 Jan 2023 10:46:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ms2-20020a17090b234200b002194319662asm21890317pjb.42.2023.01.03.10.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:46:07 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:46:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Message-ID: <Y7R36wsXn3JqwfEv@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230162442.3781098-2-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 30, 2022, Aaron Lewis wrote:
> Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> to be set if they can't all be set.  That way userspace or a guest
> doesn't fail if it attempts to set them in XCR0.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
>     CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c4e8257629165..2431c46d456b4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -855,6 +855,16 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  	return 0;
>  }
>  
> +static u64 sanitize_xcr0(u64 xcr0)
> +{
> +	u64 mask;
> +
> +	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> +	if ((xcr0 & mask) != mask)
> +		xcr0 &= ~mask;
> +
> +	return xcr0;
> +}
> +
>  static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  {
>  	struct kvm_cpuid_entry2 *entry;
> @@ -982,6 +992,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
>  		u64 permitted_xss = kvm_caps.supported_xss;
>  
> +		permitted_xcr0 = sanitize_xcr0(permitted_xcr0);


This isn't 100% correct, all usage needs to be sanitized so that KVM provides a
consistent view.  E.g. KVM_CAP_XSAVE2 would report the wrong size.

	case KVM_CAP_XSAVE2: {
		u64 guest_perm = xstate_get_guest_group_perm();

		r = xstate_required_size(kvm_caps.supported_xcr0 & guest_perm, false);
		if (r < sizeof(struct kvm_xsave))
			r = sizeof(struct kvm_xsave);
		break;
	}

Barring a kernel bug, xstate_get_guest_group_perm() will never report partial
support, so I think the easy solution is to sanitize kvm_caps.suport_xcr0.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2480b8027a45..7ea06c58eaf6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9344,6 +9344,10 @@ int kvm_arch_init(void *opaque)
        if (boot_cpu_has(X86_FEATURE_XSAVE)) {
                host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
                kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
+               if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_BNDREGS) ||
+                   !(kvm_caps.supported_xcr0 & XFEATURE_MASK_BNDCSR))
+                       kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
+                                                    XFEATURE_MASK_BNDCSR);
        }
 
        if (pi_inject_timer == -1)


> +
>  		entry->eax &= permitted_xcr0;
>  		entry->ebx = xstate_required_size(permitted_xcr0, false);
>  		entry->ecx = entry->ebx;
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
