Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA40634B57
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 00:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiKVXrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 18:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiKVXrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 18:47:20 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0B5C72DC
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 15:47:18 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oxcyt-00Ffz4-6M; Wed, 23 Nov 2022 00:47:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=Xgk6qZrJxl5MYPHYCttFcx7gfo/nYAMCcvL62S9z/xc=; b=ieGer5gR/yQNQAe2aUNt4HcW28
        +ej56y1SBJuRcfwP2nHAMZJmmFOnnwEczmxWFzouisuhssnOCn7H+A4xNHaCTqHWA+SEbKq3ovUt7
        GrrdrELNCgEUz67ux8Q7meJQHmZtchfepEjR+g/i/96t6BdRsI9IyC0uFoUDe+yRcMU3vYJ/Wgju+
        PjqZFjuyTFTt73iP/MyFZTr+pCdJwXREKY9RlBu+TU792WM+jzG0PBRlwQnF65KMnp9XKbbgNBmmL
        UYINJmxyfaWunaveGrAdG71mlJPkvQHrXepmcxB6ZPbazb1QBQriidh8nN7YKDHWLkp3YrhIUAM+/
        XaIEa+Gw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oxcys-0002xi-MJ; Wed, 23 Nov 2022 00:47:10 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oxcya-0003R4-4i; Wed, 23 Nov 2022 00:46:52 +0100
Message-ID: <9d5762e7-e325-2f5d-d91f-bbc60fd4d584@rbox.co>
Date:   Wed, 23 Nov 2022 00:46:50 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared runstate
 area
Content-Language: pl-PL, en-GB
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20221119094659.11868-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/22 10:46, David Woodhouse wrote:
> @@ -584,23 +705,57 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
> ...
> +		if (IS_ENABLED(CONFIG_64BIT) && vcpu->kvm->arch.xen.long_mode)
> +			sz = sizeof(struct vcpu_runstate_info);
> +		else
> +			sz = sizeof(struct compat_vcpu_runstate_info);
> +
> +		/* How much fits in the (first) page? */
> +		sz1 = PAGE_SIZE - (data->u.gpa & ~PAGE_MASK);
>  		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
> -				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
> -				     sizeof(struct vcpu_runstate_info));
> -		break;
> +				     NULL, KVM_HOST_USES_PFN, data->u.gpa, sz1);
> +		if (r)
> +			goto deactivate_out;
>  
> +		/* Either map the second page, or deactivate the second GPC */
> +		if (sz1 > sz) {

Out of curiosity: is there a reason behind potentially
kvm_gpc_activate()ing a "len=0" cache? (sz1==sz leads to sz2=0)
I feel I may be missing something, but shouldn't the comparison be >=?

> +			kvm_gpc_deactivate(vcpu->kvm,
> +					   &vcpu->arch.xen.runstate2_cache);
> +		} else {
> +			sz2 = sz - sz1;
> +			BUG_ON((data->u.gpa + sz1) & ~PAGE_MASK);
> +			r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate2_cache,
> +					     NULL, KVM_HOST_USES_PFN,
> +					     data->u.gpa + sz1, sz2);
> +			if (r)
> +				goto deactivate_out;
> +		}
thanks,
Michal

