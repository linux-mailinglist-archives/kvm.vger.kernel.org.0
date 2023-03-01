Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B776A6B07
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 11:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCAKpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 05:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCAKpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 05:45:20 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C280302AB;
        Wed,  1 Mar 2023 02:45:19 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id r27so17008903lfe.10;
        Wed, 01 Mar 2023 02:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677667518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgQQZanRv5/alvxkVET4D6uB4QZkFnK7oJuTnwO/hEE=;
        b=P7SSTk6sznBU59W8FIBilggNoPneO/753Y91fiXGPLcnZo+7vSp688RM2AEYDH7KHS
         Oe6Ac54VLqQqTSg9I80HwktZ3FG0ggZw80CfLRhkgsqAsu52TYikxNSjooJzTFicW5sH
         vwKPsN3AjYT+NcKd4RsE3ndx3CMxhQnu9JSc4it/+kxEwrpOrbfsnxRqNHKzgVeCjnB7
         zDkHqnFloq2501FJaTMMlXxulgv8DLgS6APspZ30Pcw4+tXEcrJKn+NK83RWNJxXk3Fj
         9fICn88zqCxqTvwKFaz5Vnv0SqDmkTZFcpqRA5y5uidc8eWLrUwwKEzOm92C5g5/tnIp
         24Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677667518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HgQQZanRv5/alvxkVET4D6uB4QZkFnK7oJuTnwO/hEE=;
        b=CWTHhttSxbdl6xWGD6kz+alZeDel20pxi79JVR7ywUXVpA1nY4y4slvH58AhgvQVw2
         Fh1XDuKc/Em9NdRYajuTxTfxeb6//C5mSDqyi9k5/+brbxRw6mGMdGWJeVOQLbMyVlOO
         amtIj2AK/nEEd8gWfd+tjNwhDSxC+HnyWvdrCkYMI6J7xwkpb0gSk+vIPXgi6uN7EHE3
         YgU40KRaCr6CHwgtVrXg3HrN+RCXSYQDZ89OKwz4EAYLMVjzHsKAdUjyCuwQhZECADNa
         +H2LD8I3TYIEZ22Ri9vHg/BQCWePZJ32XicCyZQ8ZgC1uv+oAnDS9NVjjexVl0YW+sAY
         wzEA==
X-Gm-Message-State: AO0yUKUvBRBOmbw7JfKqsiC2aNToUOXwacLvpsduAd7DljFdI58U4WLf
        8qSMazddDB3uo0e6Vp1KzGo=
X-Google-Smtp-Source: AK7set+HFf00M+CzlupT1bQM2ZRdW6de/txyzQjH6FxzfeDTmSWjvROAUCh9HT5dCKqG75TdwtvY2A==
X-Received: by 2002:ac2:44a9:0:b0:4d2:c70a:fe0a with SMTP id c9-20020ac244a9000000b004d2c70afe0amr1344986lfm.2.1677667517726;
        Wed, 01 Mar 2023 02:45:17 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id r1-20020a19ac41000000b004dc4bb2f4bcsm1663800lfc.276.2023.03.01.02.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 02:45:17 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 12:45:16 +0200
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 51/56] KVM: SVM: Add module parameter to enable
 the SEV-SNP
Message-ID: <20230301124516.000048f5@intel.com>
In-Reply-To: <20230220183847.59159-52-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-52-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:42 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add a module parameter than can be used to enable or disable the SEV-SNP
> feature. Now that KVM contains the support for the SNP set the GHCB
> hypervisor feature flag to indicate that SNP is supported.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 7 ++++---
>  arch/x86/kvm/svm/svm.h | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index bedec90d034f..70d5650d8d95 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -55,14 +55,15 @@ module_param_named(sev, sev_enabled, bool, 0444);
>  /* enable/disable SEV-ES support */
>  static bool sev_es_enabled = true;
>  module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-SNP support */
> +static bool sev_snp_enabled = true;
> +module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false

Guess we also need #define sev_snp_enabled false.

>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> -/* enable/disable SEV-SNP support */
> -static bool sev_snp_enabled;
> -
>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 857b674e68f0..221b38d3c845 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -694,7 +694,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  #define GHCB_VERSION_MAX	2ULL
>  #define GHCB_VERSION_MIN	1ULL
>  
> -#define GHCB_HV_FT_SUPPORTED	0
> +#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)

This is not related to the topic of this patch, should be merged into related
patches.

>  
>  extern unsigned int max_sev_asid;
>  

