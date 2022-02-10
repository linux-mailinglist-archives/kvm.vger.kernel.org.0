Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACA84B1320
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiBJQka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:40:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244456AbiBJQk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:40:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE53FC24
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQktwnLb25W7zp9qT638gEIuprsGbddtTGVXPaavyEg=;
        b=JKntwgS3FJ1PPV6++sRtOPVE39MZExQ6sumHGqzh3lrCrAzwyu80y8KX+l3z14y0a7Iifl
        rkspq6lfw6F2KP88x5xz2W94z/Yi+XFDelK+Y0tjlDuoswURBPy12i9FvrJ2oRBN5GRJsN
        eOM1ZgX/ysJTh8z9cXXADZzUqQ4X780=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-vrq7oIksPsiJCrW2VBCyKw-1; Thu, 10 Feb 2022 11:40:23 -0500
X-MC-Unique: vrq7oIksPsiJCrW2VBCyKw-1
Received: by mail-ed1-f72.google.com with SMTP id dn20-20020a05640222f400b0040f8cdfb542so3651641edb.3
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hQktwnLb25W7zp9qT638gEIuprsGbddtTGVXPaavyEg=;
        b=7LppDUGYlt9Iokek0f4aFxEfrt8yWw1+vs6awNT78z4Eek+j3TCC40RuJP7f/5qdwC
         2eVr3GH5Aa0BOZevSFa5PNUjy8nbv5I/IL61ieXJyhe4gG5+Ve9ot/Q4b0MzEa9acFa6
         R/Dbi2QVe5X6XeHl5/cSdQgFwq97WCR0vLpmiK8p7eOQ4+/Ja0IwgHfYYYHcBDGYBds1
         9xklmPy1LPVjrGnSAuSb6J1mJeuS75yJL7YKHaEEi2F8pBoGnNwAlQlPISY3y+hALPhb
         uNKttxPz3SUVbkfyJ1WekCQP0blUVIzRtII0mJ2y/1GiPUBlq4nf1b7PpbZJ/hBtqnS4
         8/8g==
X-Gm-Message-State: AOAM533isYgKk8EDp0nPSlCTzBiDh3m2Cb6qWkYT9Kb/vluhxYNq2PA5
        ccsMOK3NfFxCYN0/zusGSqk6Q2/SuDmJJDEykFW4CcH1QrdD2AXneSU6EbZJHSnZTidWor64+et
        tvVAz8ynaYJhh
X-Received: by 2002:a17:907:6094:: with SMTP id ht20mr7088349ejc.628.1644511222745;
        Thu, 10 Feb 2022 08:40:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0gudfjML2lGRgr03XTF8GDi70YzDcnIOKGhTO8ZXomriz3h2l9aJCzm9qeQMHPuaA1XRM1g==
X-Received: by 2002:a17:907:6094:: with SMTP id ht20mr7088325ejc.628.1644511222521;
        Thu, 10 Feb 2022 08:40:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id pg20sm4150957ejb.50.2022.02.10.08.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:21 -0800 (PST)
Message-ID: <db7ecc1b-91ff-e0bc-aab4-1d1dbe8b755a@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 5/8] KVM: SVM: Don't kill SEV guest if SMAP
 erratum triggers in usermode
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:56, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit cdf85e0c5dc766fc7fc779466280e454a6d04f87 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


> Inject a #GP instead of synthesizing triple fault to try to avoid killing
> the guest if emulation of an SEV guest fails due to encountering the SMAP
> erratum.  The injected #GP may still be fatal to the guest, e.g. if the
> userspace process is providing critical functionality, but KVM should
> make every attempt to keep the guest alive.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Message-Id: <20220120010719.711476-10-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 980abc437cdaa..f05aa7290267d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4473,7 +4473,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	is_user = svm_get_cpl(vcpu) == 3;
>   	if (smap && (!smep || is_user)) {
>   		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
> -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
> +		/*
> +		 * If the fault occurred in userspace, arbitrarily inject #GP
> +		 * to avoid killing the guest and to hopefully avoid confusing
> +		 * the guest kernel too much, e.g. injecting #PF would not be
> +		 * coherent with respect to the guest's page tables.  Request
> +		 * triple fault if the fault occurred in the kernel as there's
> +		 * no fault that KVM can inject without confusing the guest.
> +		 * In practice, the triple fault is moot as no sane SEV kernel
> +		 * will execute from user memory while also running with SMAP=1.
> +		 */
> +		if (is_user)
> +			kvm_inject_gp(vcpu, 0);
> +		else
> +			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   	}
>   
>   	return false;

