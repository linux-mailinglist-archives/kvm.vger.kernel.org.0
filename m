Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA16B51C3
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 21:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCJUYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 15:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCJUYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 15:24:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F7D11AB96
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:23:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id m6-20020a056902118600b00aeb1e3dbd1bso6820090ybu.9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678479834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QXSXJgRCrpwkJlHHpKzimapd3bwWLw9ZQ0Cx2QTM48=;
        b=aA/4NKr5soDDdXyKDCtOxHxgpjVHixZ6FVbP8Tpg8huubDFPc2gKzWh19hIBfBn77p
         vxFBSxX1rQ3GDogZ6UV+qee5xoCwPQPFFMeLnDQh/AeVTfrLLtYXr3t5OXHJ/j05CKee
         n1ZBHPffmhnOAvuvhC3ePTNXEAbcX583BGmD0WvelKRL5gBXoHdcdnM842cHlYHdK6/y
         W1WLMvlu3R0roi3G9klp8qjOJBO3t+s+DVetwMgjcdtWGDS1iVjDTb5GYwhMo2islvOy
         5KAw4M2DG9enxvLJuWZyCcx37gyXAH8bS6H0uCkb7dLVPlYBrTV0a0YAwfmKUKhm6Lyb
         ZBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678479834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QXSXJgRCrpwkJlHHpKzimapd3bwWLw9ZQ0Cx2QTM48=;
        b=TuteGu0r4ZC45pv7uJBDefj4BausHNFGbUmw2petotHmvENx1xorsGrn5ghRvLmpFA
         L3C/hsga8MqhnxjuT20i04jOUyFoUz8jAsDxsa8e2XHyKEOjBZw+V5bYvW8BlxqzxloT
         UTQTZXnihCmsADReXS6+/zUJAhoz3kWEAY1Qibn6AuYFRSKZx4aI00jT2zscDbFPmAS2
         TYRHBGpyfwNEBTBwP0PUtwf0wskAMN8ZtXbR93sti3vsAsWmo34aaa4serPZBCIwNJcz
         b2gHAwM/rBoqeNTr4sA75lGYoo8wjyGiMDz8Gcl4fHhULawUlsA8hG99/QA8cygDuRis
         96DA==
X-Gm-Message-State: AO0yUKXW0bGAzznY7uHt3wk2nivmDXyhluEsMAvthusmJ7JSeneL4g2U
        Cry3/pogsRlV4GZh7/NV2aW90fIzawQ=
X-Google-Smtp-Source: AK7set/cTq+aqXSIhA612cqIyTdcfOVWxIeMIVoVv4q80Uqdr0uTU2VKHi9oDn7oVhwJBJOHCgxBU1JZiI4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9006:0:b0:a09:314f:9f09 with SMTP id
 s6-20020a259006000000b00a09314f9f09mr2191888ybl.6.1678479834418; Fri, 10 Mar
 2023 12:23:54 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:23:52 -0800
In-Reply-To: <20230227084547.404871-5-robert.hu@linux.intel.com>
Mime-Version: 1.0
References: <20230227084547.404871-1-robert.hu@linux.intel.com> <20230227084547.404871-5-robert.hu@linux.intel.com>
Message-ID: <ZAuR2OlRh/IFtCsK@google.com>
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating
 data access in 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Robert Hoo wrote:
> Emulate HW LAM masking when doing data access under 64-bit mode.
> 
> kvm_lam_untag_addr() implements this: per CR4/CR3 LAM bits configuration,
> firstly check the linear addr conforms LAM canonical, i.e. the highest
> address bit matches bit 63. Then mask out meta data per LAM configuration.
> If failed in above process, emulate #GP to guest.
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/kvm/emulate.c | 13 ++++++++
>  arch/x86/kvm/x86.h     | 70 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5cc3efa0e21c..77bd13f40711 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -700,6 +700,19 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  	*max_size = 0;
>  	switch (mode) {
>  	case X86EMUL_MODE_PROT64:
> +		/* LAM applies only on data access */
> +		if (!fetch && guest_cpuid_has(ctxt->vcpu, X86_FEATURE_LAM)) {

Derefencing ctxt->vcpu in the emulator is not allowed.

> +			enum lam_type type;
> +
> +			type = kvm_vcpu_lam_type(la, ctxt->vcpu);
> +			if (type == LAM_ILLEGAL) {
> +				*linear = la;
> +				goto bad;
> +			} else {
> +				la = kvm_lam_untag_addr(la, type);
> +			}
> +		}

This is wildly over-engineered.  Just do the untagging and let __is_canonical_address()
catch any non-canonical bits that weren't stripped.
