Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2A61FDAA
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiKGSgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiKGSgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:36:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B89209B5
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667846101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zl0azrdyHDKiWZpM40ALSzaAT6FB2gE2SFyx5QJVKg0=;
        b=b6a6Ps4tDnNEc6e0v1iXA2pBiM6B+lE0ylBldhP87aRYsCqtz+b9gZARVWsKj7XIjXuN92
        t0QEgisK11I4AvJaEGx3IHzsr2NoOgw65S5tQb1rZhSjovXvxgnOFGKFa5KrT/SqzKrZ1b
        rehw1vAwpLK3nPXLhmGgOJ2BMzAAKyc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-OrQ-CWICOfWAHIiPwgij7A-1; Mon, 07 Nov 2022 13:34:52 -0500
X-MC-Unique: OrQ-CWICOfWAHIiPwgij7A-1
Received: by mail-wr1-f69.google.com with SMTP id s11-20020adfbc0b000000b0023659af24a8so3128579wrg.14
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zl0azrdyHDKiWZpM40ALSzaAT6FB2gE2SFyx5QJVKg0=;
        b=6KBVW/20otFjDSPTgWtktEt6h+a4gff7AkC4Du/PZMmjTIGSOBpGSR6pLnUYvuD+mk
         rctcqzXetSGvbZ0nJmuhKyh5GdRZaU1sCK6xMub5WEKm5xVYhK7cyXIyUCe2FE27T8OL
         d+LZvzpDKPdq6PFVsdyRNkwHmAiPVAlzWacOHoLfxkUrtJmqhCgTBuOUhxYBDF2oHSXl
         rxE91/Elt3rleOdnk9tW/8lZiEbFcKud5MFjZMBynwxjN89ZsQuDiWB/FxItWEikeL12
         RRLR07Qx02agvEgSiKpvIwZj0piZ2Qt9mZGCEuQ//3kaUtJUdEBmb3G11qOJuBxeGAeW
         moag==
X-Gm-Message-State: ACrzQf1om7Xad4p//xktZVTqxvuw4U48BSgd3djoJjqiZiCqFxiUNfL7
        sPYznv693p+DniFP/mk14PuhoYb7TvRqMzHtcW53qDfcOxRb4Sy0IsrsPviIbRtZDPZ9Nr/J3Rm
        VGmDoqKihrQIj
X-Received: by 2002:a5d:534b:0:b0:236:73ff:3605 with SMTP id t11-20020a5d534b000000b0023673ff3605mr31484135wrv.521.1667846091159;
        Mon, 07 Nov 2022 10:34:51 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5/xksLQh/5q4wFEeW4DJePZS9PUYu9raRK2L0FoEcMmRjAefxpNBce9eMUD/Z5MUVvupU7tA==
X-Received: by 2002:a5d:534b:0:b0:236:73ff:3605 with SMTP id t11-20020a5d534b000000b0023673ff3605mr31484116wrv.521.1667846090909;
        Mon, 07 Nov 2022 10:34:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000008200b0023662d97130sm7974607wrx.20.2022.11.07.10.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:34:50 -0800 (PST)
Message-ID: <daa5e62d-34b4-6a05-584c-ec5baf9c9216@redhat.com>
Date:   Mon, 7 Nov 2022 19:34:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v3 3/3] KVM: x86/pmu: Limit the maximum number of
 supported AMD GP counters
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220919091008.60695-1-likexu@tencent.com>
 <20220919091008.60695-3-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220919091008.60695-3-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/22 11:10, Like Xu wrote:
> @@ -506,6 +506,7 @@ struct kvm_pmc {
>   #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>   #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
>   #define KVM_PMC_MAX_FIXED	3
> +#define KVM_AMD_PMC_MAX_GENERIC	AMD64_NUM_COUNTERS_CORE
>   struct kvm_pmu {

Even though the BUILD_BUG_ON prevents out-of-bounds accesses, this 
should be hardcoded to 6 to avoid mismatches with msrs_to_save_all[].

> +	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);

This should be KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE, not 
the opposite.

Fixed up and changed the commit message to follow:

     The AMD PerfMonV2 specification allows for a maximum of 16 GP
     counters, but currently only 6 pairs of MSRs are accepted by KVM.

     While AMD64_NUM_COUNTERS_CORE is already equal to 6, increasing
     without adjusting msrs_to_save_all[] could result in out-of-bounds
     accesses.  Therefore introduce a macro (named
     KVM_AMD_PMC_MAX_GENERIC) to refer to the number of counters
     supported by KVM.

Paolo

