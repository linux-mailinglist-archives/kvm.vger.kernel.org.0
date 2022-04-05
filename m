Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6040D4F5520
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573595AbiDFFac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838504AbiDFAv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:51:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA7E19C80F
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:57:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id g15-20020a17090adb0f00b001caa9a230c7so4035394pjv.5
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=93hqF3zu4zfws/pXFt3afJAAZFw6d9ShnYeFOPkrFgM=;
        b=rLsbGoMaSw/NaYYVVLR3+f4CrDv+UXu6+WPoFRLbCoyBXn9XKGoz3l2vLGcQ68TijN
         +LdId9cQ67lLczOBjrrBvLOQSantj9vPoPKEUpVaqIspK76UFiDz/zCzXqf81M5R2Jt5
         ghI6qqteOKSO7JqMiUPpfrpe4Gly17dh4yIvAqyiIXR5PEUNO8gcDkrcrIiRHdwio3bZ
         3+y0ubNu0Kt66Z+CLfP5a/bgYdsJCG+CUUfr0b8nC1ECsHEv2+ZdAyg4ys/+NyZEHgle
         Nxb4P1JGgpH8YmeMtOFMcOajAHOxRhj8maCFDHH1y++veu5DsG2Acrvt+iRgPpUZ3hr6
         le1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=93hqF3zu4zfws/pXFt3afJAAZFw6d9ShnYeFOPkrFgM=;
        b=7WSpW6W/4HFqMCKnVBjU1JU0PPNGepbQrBKNNYAnjs3srU12GTgroSywf/+Cz2UvBD
         iKZnPJ7DS42rCHezjxAzNiAaJnPlw71NP89Dra8VDFpB5fn4D+EtiYmWK2uesv0sm08t
         lBEOdQRdAB7zSgiv8kDEesRIBDebbHdsdcbAzjVzlPV3YDS5k+mbdrL+wst5FNZ8x+52
         NJlRWVQw0qDGLmiQSBCXVql2S4SgNd0gKeyuKbK5dRlYE5EPRIQlU0iBw9YiZ/TAXqMf
         XXiSxTZ+UWutLguW6YISdfhtdRqCf0yZ1FsJ53tLybLivjhhXy/MiFoOR7ETBFngskNV
         RHQA==
X-Gm-Message-State: AOAM5334T8Wlj8V22L2EcW+GLA/BujfOLPIrPHtj5Vc+L+d0czPTiQpD
        ZrWEjrgURqBZ34K1PCw+FqHiBA==
X-Google-Smtp-Source: ABdhPJxn4xro7q6C8KMaE8ZyoJ8mD8fxSdlsqvJl2vGEL3EncCGEWBOZ3n61hwnzUcjtPHBL57j4AQ==
X-Received: by 2002:a17:902:e750:b0:154:5672:b918 with SMTP id p16-20020a170902e75000b001545672b918mr5529963plf.43.1649199420667;
        Tue, 05 Apr 2022 15:57:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a840d00b001ca89db9e6esm3539167pjn.19.2022.04.05.15.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:57:00 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:56:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] KVM, SEV: Add KVM_EXIT_SYSTEM_EVENT metadata for
 SEV-ES
Message-ID: <YkzJN6kKMenpT0mm@google.com>
References: <20220405183506.2138403-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405183506.2138403-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022, Peter Gonda wrote:
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)

s/EVINAL/EINVAL 

> return code from KVM_RUN. By adding a KVM_EXIT_SYSTEM_EVENT to kvm_run
> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.

Nit, phrase that last part as a command, nowhere in the changelog is it actually
stated that the patch converts to use KVM_EXIT_SYSTEM_EVENT.

And my personal preference is to lead with the "what", especially when there's
already a fair amount of assumed knowledge, e.g. someone that's familiar with
SEV-ES probably already knows the guest can request termination, or at least won't
be surprised by the news, whereas leading with the SEV-ES and GHCB info is just
going to add to the confusion of someone who's clueless about SEV-ES.

  If an SEV-ES guest requests termination, exit to userspace with
  KVM_EXIT_SYSTEM_EVENT and a dedicated SEV_TERM type instead of -EINVAL
  so that userspace can take appropriate action.

  See AMD's GHCB spec section '4.1.13 Termination Request' for more details.

> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Marc Orr <marcorr@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> 
> V4
>  * Switch to using KVM_SYSTEM_EVENT exit reason.
> 
> V3
>  * Add Documentation/ update.
>  * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
>    to KVM_SHUTDOWN_REQ.
> 
> V2
>  * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.
> 
> Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
> reason code set and reason code and then observing the codes from the
> userspace VMM in the kvm_run.system_event fields.
> 
> ---
>  arch/x86/kvm/svm/sev.c   | 7 +++++--
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..039b241a9fb5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,11 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>  		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>  			reason_set, reason_code);
>  
> -		ret = -EINVAL;
> -		break;
> +		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;

Wrong exit reason.

> +		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
> +		vcpu->run->system_event.flags = control->ghcb_gpa;
> +
> +		return 0;
>  	}
>  	default:
>  		/* Error, keep GHCB MSR value as-is */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..d9d24db12930 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -444,6 +444,7 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
> +#define KVM_SYSTEM_EVENT_SEV_TERM       4
>  			__u32 type;
>  			__u64 flags;

@type isn't properly padded, so this needs to be changed when using flags.   And
we definitely want to grab more room than just a single u64.

Per Paolo and I's combined powers[*], use bit 31 of the type to enumerate that ndata
is valid, and then change the sub-struct to:

		struct {
#define KVM_SYSTEM_EVENT_SHUTDOWN       1
#define KVM_SYSTEM_EVENT_RESET          2
#define KVM_SYSTEM_EVENT_CRASH          3
#define KVM_SYSTEM_EVENT_SEV_TERM	4
#define KVM_SYSTEM_EVENT_NDATA_VALID	(1u << 31)
			__u32 type;
			__u32 ndata;
			__u64 data[16];
		} system_event;

[*] https://lore.kernel.org/all/e0285020-49d9-8168-be4d-90940a30a048@redhat.com


>  		} system_event;
> -- 
> 2.35.1.1094.g7c7d902a7c-goog
> 
