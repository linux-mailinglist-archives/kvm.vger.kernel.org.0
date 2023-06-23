Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376AE73C232
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjFWVLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjFWVLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 17:11:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BC31706
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 14:11:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-570553a18deso14186587b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 14:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687554708; x=1690146708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpF0hJJdSCbzsXPIoBpV2pAuOEkgh57lqkiUh3PViIQ=;
        b=Z2ZG8+JWQ/AJEglu3wNgXco8+XmzhLq2CVJ2un8X+jEC+3HIrxT1tq0nbdYwA8Yrra
         ndGsZbgjYCE2or+YVhgaK34KNqyP+BZltg/k7bG1CQ7krFyzsAMtsUfExcZONQWH8tM0
         mmLPIUk1rGspZgW4B/QCWLv+rbhntlGzHyylQ58aOfoOqPsqEq+bEIDBtBFYqLsEtSBa
         3MkjAF3TlyU50oTblmp4WpT3CnLH9UMvqJLErd6Jb/WLqZvdTJB1UrgFCezn1PWExIaV
         B4BV0ZalGq26K8w4IDfwQ+48wzsItvYJLFdKx2B6szRpKm6c5CynAEU+NTJptX86hOfq
         ZvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687554708; x=1690146708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpF0hJJdSCbzsXPIoBpV2pAuOEkgh57lqkiUh3PViIQ=;
        b=DcPVN4g7+WBq2A99jZhJhE9zoKs8+F82WxQGgH74pL4ci49xierNfiTCul3unO1KBn
         jl6SIqXKZW81Ty2QCfGNQVToxQOpas1U9fOpyxqFJvu4H7s8pODKRyXHrMDoXYI0P1hW
         yPMhZTJPTPqkcFwtSsg6INCHnN0oL6yPe4+Cq/Glwk8EOBa6AmBpaHOIF7blYLy+mT0o
         aX/FpBZq67SXA1hY5simfYoaxkg/iIu+wAW7U+LoyvWinnePlPB0oLXvYbPDU0w472Iu
         y2qFf4CdslY7CyJza9kKhhRDefv8qGGSeMR9w61jHj42+FmbjzJbRz823ftRuGlU1Viz
         kobg==
X-Gm-Message-State: AC+VfDyJ+9kCmleF8S01+YRvX9frRIUp0ipYciaYmN2TJXn9+uU+j2RM
        cC5MrjcdidzSXde3fpoh1DaSzqMOMMo=
X-Google-Smtp-Source: ACHHUZ5jEXzf8lMdetFcA8JZhGt4cfiznO7FQIC6B5UL1to8romdSXGDf1QhqaDKP3d0XURqDXrADMLBEqA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b710:0:b0:565:9f59:664f with SMTP id
 v16-20020a81b710000000b005659f59664fmr9910110ywh.6.1687554707928; Fri, 23 Jun
 2023 14:11:47 -0700 (PDT)
Date:   Fri, 23 Jun 2023 14:11:46 -0700
In-Reply-To: <20230524155339.415820-5-john.allen@amd.com>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-5-john.allen@amd.com>
Message-ID: <ZJYKksVIORhPtD6T@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: SVM: Save shadow stack host state on VMRUN
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, John Allen wrote:
> When running as an SEV-ES guest, the PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
> and U_CET fields in the VMCB save area are type B, meaning the host
> state is automatically loaded on a VMEXIT, but is not saved on a VMRUN.
> The other shadow stack MSRs, S_CET, SSP, and ISST_ADDR are type A,
> meaning they are loaded on VMEXIT and saved on VMRUN. Manually save the
> type B host MSR values before VMRUN.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c25aeb550cd9..03dd68bddd51 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3028,6 +3028,19 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>  
>  	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>  	hostsa->xss = host_xss;
> +
> +	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> +		/*
> +		 * MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
> +		 * MSR_IA32_PL2_SSP, and MSR_IA32_PL3_SSP are restored on
> +		 * VMEXIT, save the current host values.
> +		 */
> +		rdmsrl(MSR_IA32_U_CET, hostsa->u_cet);
> +		rdmsrl(MSR_IA32_PL0_SSP, hostsa->vmpl0_ssp);
> +		rdmsrl(MSR_IA32_PL1_SSP, hostsa->vmpl1_ssp);
> +		rdmsrl(MSR_IA32_PL2_SSP, hostsa->vmpl2_ssp);
> +		rdmsrl(MSR_IA32_PL3_SSP, hostsa->vmpl3_ssp);

Heh, can you send a patch to fix the names for the PLx_SSP fields?  They should
be ->plN_ssp, not ->vmplN_ssp.

As for the values themselves, the kernel doesn't support Supervisor Shadow Stacks
(SSS), so PL0-2_SSP are guaranteed to be zero.  And if/when SSS support is added,
I doubt the kernel will ever use PL1_SSP or PL2_SSP, so those can probably be
ignored entirely, and PL0_SSP might be constant per task?  In other words, I don't
see any reason to try and track the host values for support that doesn't exist,
just do what VMX does for BNDCFGS and yell if the MSRs are non-zero.  Though for
SSS it probably makes sense for KVM to refuse to load (KVM continues on for BNDCFGS
because it's a pretty safe assumption that the kernel won't regain MPX supported).

E.g. in rough pseudocode

	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
		rdmsrl(MSR_IA32_PLx_SSP, host_plx_ssp);

		if (WARN_ON_ONCE(host_pl0_ssp || host_pl1_ssp || host_pl2_ssp))
			return -EIO;
	}
