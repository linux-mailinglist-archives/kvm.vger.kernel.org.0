Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D985851A7
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 16:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiG2OhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 10:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbiG2Og6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 10:36:58 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DF96170E
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:36:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b22so4767385plz.9
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=UJxEn4xcgj+ln1eSjZjkxrNWHJwcAg9c38FMYxFrEw4=;
        b=Llt63vfhKnScgYaIaDCdE5iR4zO0UBwA/DKPfMke+neC1JBL32YFpgFFV6xl2YIt6D
         fcm6DBwAKxLX6EHNmh78ZMFx80I4GGfFe6JJfDxhfXVO1c6tddbnv/YXhxcpuIX8/0D4
         4/bcakY3kMtTIC/8ODy7RFKEIVohnCm6z365lHubhmi8qtrmfvqhHcM7diC782mNi+1R
         gqQ9f7XWkn4RtPUTmWQ7/S+cqhpANz+vlws6uZvuZuv++UlGNRji5n8r13chEsgBU+uW
         MGyZFis7lIMbVuQEusYNn/C2MSgNClRD3tZfS/vGTndVQqch3mYm9u/a8sPDAWoXIb5R
         OzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=UJxEn4xcgj+ln1eSjZjkxrNWHJwcAg9c38FMYxFrEw4=;
        b=yHB8cfZyImLi1t8qrAVpFMRgsxjy+4Ue01M6MtDQgZj6meQ8mwo0Dy690/xon6Qe9D
         eVhzLkbIrQy6FBacTkEq6ZJ3Br4nAcFJbifNUisWZu7xOXluPnPBZEI3L5LiiVad0Xi3
         xDNvZWbghN/A+zrKRV0da+PLIOOvztaonMK25XncwvHmC1aZi8FyfzMO4KDY8jVIcVND
         vJEyRQBwQF6d3fgp9LSYH3BFvkETcqOnaTEPatTFlm22RdX1swx9gapjb/pY4wwp5Kng
         Wtcao6xJrNOWbHXNEHiBxuzdgB3ge/o4m+gnD69FUHnXXiQnUvK3gYKdALjf44CtByL7
         tIWw==
X-Gm-Message-State: ACgBeo3zRHp33ciYaCL91X4r7j7/PM2z0Txcbs7IxYyDrkINwNSNSY8K
        Ha5NUuRBcSfRKjIK5CoFszn7tg==
X-Google-Smtp-Source: AA6agR7gPHWxKhEhDN6n0RS6tuTj1B2aPWI4qV0F7CLKQBg9Ed4eMDHx1ydx99D+k633KKy23icx0A==
X-Received: by 2002:a17:902:f80f:b0:16d:c4af:88aa with SMTP id ix15-20020a170902f80f00b0016dc4af88aamr4254559plb.6.1659105417682;
        Fri, 29 Jul 2022 07:36:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902869200b0016cdbb22c28sm3700309plo.0.2022.07.29.07.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 07:36:57 -0700 (PDT)
Date:   Fri, 29 Jul 2022 14:36:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dmatlack@google.com,
        jmattson@google.com
Subject: Re: [PATCH] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init()
 fails
Message-ID: <YuPwhWi1xWgAwmK4@google.com>
References: <20220729031108.3929138-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729031108.3929138-1-junaids@google.com>
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

On Thu, Jul 28, 2022, Junaid Shahid wrote:
> If vm_init() fails [which can happen, for instance, if a memory
> allocation fails during avic_vm_init()], we need to cleanup some
> state in order to avoid resource leaks.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---
>  arch/x86/kvm/x86.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f389691d8c04..ef5fd2f05c79 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12064,8 +12064,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm_hv_init_vm(kvm);
>  	kvm_xen_init_vm(kvm);
>  
> -	return static_call(kvm_x86_vm_init)(kvm);
> +	ret = static_call(kvm_x86_vm_init)(kvm);
> +	if (ret)
> +		goto out_uninit_mmu;
>  
> +	return 0;
> +
> +out_uninit_mmu:
> +	kvm_mmu_uninit_vm(kvm);

Hrm, this works for now (I think), but I really don't like that kvm_apicv_init(),
kvm_hv_init_vm(), and kvm_xen_init_vm() all do something without that something
being unwound on failure.  E.g. both Hyper-V and Xen have a paired "destroy"
function, it just so happens that their destroy paths are guaranteed nops in this
case.

AFAICT, there are no dependencies on doing vendor init at the end, so what if we
hoist it up so that all paths that can fail are at the top?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5366f884e9a7..7e749be356b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12042,6 +12042,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        if (ret)
                goto out_page_track;
 
+       ret = static_call(kvm_x86_vm_init)(kvm);
+       if (ret)
+               goto out_uninit_mmu;
+
        INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
        INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
        atomic_set(&kvm->arch.noncoherent_dma_count, 0);
@@ -12077,8 +12081,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        kvm_hv_init_vm(kvm);
        kvm_xen_init_vm(kvm);
 
-       return static_call(kvm_x86_vm_init)(kvm);
+       return 0;
 
+out_uninit_mmu:
+       kvm_mmu_uninit_vm(kvm);
 out_page_track:
        kvm_page_track_cleanup(kvm);
 out:


Calling kvm_apicv_init() after avic_vm_init() is somewhat odd.  If we really want
to avoid that, we could add a dedicated kvm_x86_ops to initialize APICv and then
make kvm_x86_ops.vm_init() a void return e.g.

static int kvm_apicv_init(struct kvm *kvm)
{
	unsigned long *inhibits = &kvm->arch.apicv_inhibit_reasons;

	init_rwsem(&kvm->arch.apicv_update_lock);

	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);

	if (!enable_apicv) {
		set_or_clear_apicv_inhibit(inhibits,
					   APICV_INHIBIT_REASON_DISABLE, true);
		return 0;
	}

	return static_call(kvm_x86_apicv_init(kvm));
}
