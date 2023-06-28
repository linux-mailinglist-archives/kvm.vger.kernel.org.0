Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D210C741C18
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 01:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjF1XBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 19:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjF1XA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 19:00:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30456172D
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 16:00:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bd6df68105cso39072276.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 16:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687993257; x=1690585257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gb2MF1v1Rq3zxlmhOpRBTFk6nl/PtNFob1fT2upCoM=;
        b=SkxwSILpqMQiHM5Vz80792QoVEN7jJrfnEi24dfSL0u0c4JaFZvju7B7bvbSIZyCTB
         4RgLk4fWY5C5KV7EYxXd1zZSxdTkSMKtAmeA/IXTNKk4m4i2k08HMAOyj0HOwc576CLS
         /1XWCzO7Z4G+iSNkAQjkXhAr0zi2/Rj4ull0hiluNsTmyeUtfVoEj/2Ient24xztcchb
         ag3RlDV6odx6HOenzEBQ8p7LOCqLx9MsRnkUbWuC591IOLjjzvjd9c7PChjGPuGtVM0l
         yTH6tIcs7JSNptLkuy90ACOAH11NsaOdOFkiNRUTh940HiLqdZ138t8QroqvxRgt5iP4
         cpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687993257; x=1690585257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gb2MF1v1Rq3zxlmhOpRBTFk6nl/PtNFob1fT2upCoM=;
        b=DxqYFjDeS1CSHtbsQC/SxcF1phf68iNWwW0xYepQLU8ngSwg/knWr7liIukciXVl6V
         HXltWSUbnPDsVVkVfQy9hMQYStnpKY7IYx/6TmQEiHdxHGSZUDGh5yVn92XjL3wPB3Zd
         HDpq5y0BwuQ+cFjp/JSQT3xp759GovjapLdLMkLEm4rhTnVrAtWGnGwqVQPvceUXajON
         u0UlUYmgOlDJwaWJ9CXC0kUd3DciA+GZIb14aYmuaw/XqnV7xoHYH1byjPHLJJaQLKvc
         iUYqHhHKfWCbo1cqKnsVS1+uwsrRFWwDu3gjzygCGtkS9g6bxQJBqPT2YGh4y3+yTxi7
         xshA==
X-Gm-Message-State: AC+VfDyUhJ9j/SEMUNmaeLo8mMqQWWHmeh/EdzhFsFrWXHA+D6mxxSWf
        f37yXh/366YL0ZFIv8tRndfbiEyt3dI=
X-Google-Smtp-Source: ACHHUZ4v9Havux+Snzbh1IQI8dw2MyLszJ9oSfFYqWkJPutCtN/qeAmHysjqhzlg1N1d9V4AwuIac5T/eNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:42d5:0:b0:c10:8dd0:d942 with SMTP id
 p204-20020a2542d5000000b00c108dd0d942mr5534065yba.6.1687993257438; Wed, 28
 Jun 2023 16:00:57 -0700 (PDT)
Date:   Wed, 28 Jun 2023 16:00:55 -0700
In-Reply-To: <20230616023945.7570-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230616023101.7019-1-yan.y.zhao@intel.com> <20230616023945.7570-1-yan.y.zhao@intel.com>
Message-ID: <ZJy7pyQYmuYTXC67@google.com>
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Yan Zhao wrote:
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index b35dd0bc9cad..688748e3a4d2 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -25,6 +25,8 @@
>  #define IA32_MTRR_DEF_TYPE_FE		(1ULL << 10)
>  #define IA32_MTRR_DEF_TYPE_TYPE_MASK	(0xff)
>  
> +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> +				   gfn_t gfn_start, gfn_t gfn_end);
>  static bool is_mtrr_base_msr(unsigned int msr)
>  {
>  	/* MTRR base MSRs use even numbers, masks use odd numbers. */
> @@ -341,7 +343,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>  		var_mtrr_range(var_mtrr_msr_to_range(vcpu, msr), &start, &end);
>  	}
>  
> -	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> +	kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(end));
>  }
>  
>  static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> @@ -437,6 +439,11 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu)
>  {
>  	INIT_LIST_HEAD(&vcpu->arch.mtrr_state.head);
> +
> +	if (vcpu->vcpu_id == 0) {

Eww.  This is actually unsafe, because kvm_arch_vcpu_create() is invoked without
holding kvm->lock.  Oh, and vcpu_id is userspace controlled, so it's *very*
unsafe.  Just initialize these in kvm_arch_init_vm().

> +		spin_lock_init(&vcpu->kvm->arch.mtrr_zap_list_lock);
> +		INIT_LIST_HEAD(&vcpu->kvm->arch.mtrr_zap_list);
> +	}
>  }
