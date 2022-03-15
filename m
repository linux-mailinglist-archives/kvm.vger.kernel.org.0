Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760BC4DA46A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351901AbiCOVQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351763AbiCOVQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 984E35B3F9
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647378919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nqgko4+X7obXdoa7eaQfqYGIf0KiC5dkS7hxAlhgNZo=;
        b=F+mk2v5nGXlvquA29xQSy7Emjf5CYN40/3Uq5Uum28wXmSXL8ZFNVXLAIASPoNRvCXwltu
        cuCU3vOoC7K9a5+sIdoJE7pT0pKVmZ3XUxzo6KG7xSPvBm8GD+n93MOMzHj4+D38B+KlYF
        QN5GWBqGIuRYiEFHtYls/Phv70OxyIc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-kyzV5vCyPD-vR2GBlfs8SQ-1; Tue, 15 Mar 2022 17:15:18 -0400
X-MC-Unique: kyzV5vCyPD-vR2GBlfs8SQ-1
Received: by mail-wr1-f69.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so25689wrg.20
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Nqgko4+X7obXdoa7eaQfqYGIf0KiC5dkS7hxAlhgNZo=;
        b=j39Xx4cM0l5FYBYVMF7Se9c35yKC0/d066AL6FKXGOWb3fvcfaGZr7bBFpBqypJHzL
         aR0GlNyNNgOxFG5gWIxWxOmYmcl+55ZXlk+p9sc/eNhiAhMzZrvKD3wmYsFmEb3yfHlQ
         2Mb8+Hl2XvJT/qrhMvmjLVbNpOIcGnAKuQptIxx+5yMOz0yhLIYs8xIy51NCLFs4PxAV
         7epvZbcIstsb4G1yh1AghsRfnIvWoIPcuMyjbYIOJRzv6a7fEpz3Ifo6Xwd0Wts0XJI5
         jz4UgCvc3R63ijNlF0If45k38o/YYOsc0zWWnu3LBT/BFsxc4WWlGD++lumY9DQuCg36
         OUQQ==
X-Gm-Message-State: AOAM530ZKPgFqAKszeJeeidVgK7wSfrFYkpHoN10Xu/+Zlu+Uds12DFY
        14UiF65r2MlOswlA+R/NunEIrv7EfkBFAodnY50w8gbQ4qyxCYWEeGijFd6wcrNlS+CusXud2k0
        06ASGMStg/RJX
X-Received: by 2002:a5d:4bcc:0:b0:1f1:d6f8:89f5 with SMTP id l12-20020a5d4bcc000000b001f1d6f889f5mr21693976wrt.713.1647378917021;
        Tue, 15 Mar 2022 14:15:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+c8XwLFrp7sgj633bf0CiMLTbqJB9Ij/pJZhdyB/wU23pm/001s5ebO1KgLbxBXhgfxeIqA==
X-Received: by 2002:a5d:4bcc:0:b0:1f1:d6f8:89f5 with SMTP id l12-20020a5d4bcc000000b001f1d6f889f5mr21693969wrt.713.1647378916802;
        Tue, 15 Mar 2022 14:15:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 11-20020a05600c22cb00b00382a960b17csm3231184wmg.7.2022.03.15.14.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:15:16 -0700 (PDT)
Message-ID: <d27f5fe3-f01e-c582-a27a-aa2505af1273@redhat.com>
Date:   Tue, 15 Mar 2022 22:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln
 MSRs
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        likexu@tencent.com
Cc:     Lotus Fenn <lotusf@google.com>
References: <20220226234131.2167175-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220226234131.2167175-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/27/22 00:41, Jim Mattson wrote:
> AMD EPYC CPUs never raise a #GP for a WRMSR to a PerfEvtSeln MSR. Some
> reserved bits are cleared, and some are not. Specifically, on
> Zen3/Milan, bits 19 and 42 are not cleared.
> 
> When emulating such a WRMSR, KVM should not synthesize a #GP,
> regardless of which bits are set. However, undocumented bits should
> not be passed through to the hardware MSR. So, rather than checking
> for reserved bits and synthesizing a #GP, just clear the reserved
> bits.
> 
> This may seem pedantic, but since KVM currently does not support the
> "Host/Guest Only" bits (41:40), it is necessary to clear these bits
> rather than synthesizing #GP, because some popular guests (e.g Linux)
> will set the "Host Only" bit even on CPUs that don't support
> EFER.SVME, and they don't expect a #GP.
> 
> For example,
> 
> root@Ubuntu1804:~# perf stat -e r26 -a sleep 1
> 
>   Performance counter stats for 'system wide':
> 
>                   0      r26
> 
>         1.001070977 seconds time elapsed
> 
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379957] unchecked MSR access error: WRMSR to 0xc0010200 (tried to write 0x0000020000130026) at rIP: 0xffffffff9b276a28 (native_write_msr+0x8/0x30)
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379958] Call Trace:
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379963]  amd_pmu_disable_event+0x27/0x90
> 
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Reported-by: Lotus Fenn <lotusf@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/svm/pmu.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index d4de52409335..886e8ac5cfaa 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -262,12 +262,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	/* MSR_EVNTSELn */
>   	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
>   	if (pmc) {
> -		if (data == pmc->eventsel)
> -			return 0;
> -		if (!(data & pmu->reserved_bits)) {
> +		data &= ~pmu->reserved_bits;
> +		if (data != pmc->eventsel)
>   			reprogram_gp_counter(pmc, data);
> -			return 0;
> -		}
> +		return 0;
>   	}
>   
>   	return 1;

Queued, thanks.

Paolo

