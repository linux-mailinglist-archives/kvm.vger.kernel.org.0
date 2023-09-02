Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B851179094A
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 21:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjIBTG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Sep 2023 15:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjIBTG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Sep 2023 15:06:56 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FFC1B0
        for <kvm@vger.kernel.org>; Sat,  2 Sep 2023 12:06:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bdbf10333bso1163825ad.1
        for <kvm@vger.kernel.org>; Sat, 02 Sep 2023 12:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693681611; x=1694286411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GC8azV+g6S4yBEuJI4Z8Sej8GtaLMR6+xlm8pK/bqo=;
        b=qtFYVv8pAYZOHQvAg47U979NO+fS1HYIyq4L2jHDG+pLWLS9Qfl6HT6PZhUAeRnLsG
         JaCtgQBtSQPrDuCiOZ7ieyrJ6YBT2qfWkVVIwbPKo0Zc/SWbe2JsXPMHVX/rQO+//dI0
         WyGp+Rt83ZRMKOpEnC7DBkP2ad6+fIt+snWt3rdHYLDSl0xM8yIhpofveUakcb1CHJ+Z
         oJzV7M1U4hAyBJpPgP7sqp+glKlpJAD5T6+pNexD3OWHTELUQdqs/plkWlQx+v/0lLm8
         9gJ1RpXsBmXKJLoMmjXOXpgHCja3deIlgxLIlYbSknjxxGeMw0QBDz0HnQl7Ys6tOh4s
         BzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693681611; x=1694286411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GC8azV+g6S4yBEuJI4Z8Sej8GtaLMR6+xlm8pK/bqo=;
        b=HCI7hVLQ6MNFgM8IVLN0JMr3yuMjV5kY3IA6j7ufFbnMR5eKBuGv1u8/mRZ2MpmDU2
         kDT+lM5tm4h3YVBpaM0Zpf9W1Qhar6NBOXXk5EXHAQHrGewn4bZGjQOZrqc5LcXstykC
         11vLbjzRsNZcKF4BryUPHSXk1AZCFCUS/ZYrYAlf9Z939tMFCaYVLPpte5AJC7DHXwSI
         JBezVbC+uR+e5z+dVaVI4Xn4eFFyUdLFdbUNjMwHJue/6rCYxTfh3D109UUAv2A5g7En
         HuX28psCdnga9KKaj1F0EolJ6qpFwLSg6NBQy3/U6LRFVykNHSZkEdqI2IDuaNnE/Yp5
         cHtw==
X-Gm-Message-State: AOJu0YyMARgl1KNlTLknx2HdfurT1+VfUfHWXWv5YU0D/OqlJ6Z/2QRJ
        MZiZfBBpghGRMbc7iXARHJjCqA==
X-Google-Smtp-Source: AGHT+IEoyxy0c7BjGU4NnIS6hz7kzFtIEAEaDJtxKQlocbzGyI4S+2glZ4qHHtiuXhRoXP5+N9W54Q==
X-Received: by 2002:a17:903:2345:b0:1bf:11ce:c6ae with SMTP id c5-20020a170903234500b001bf11cec6aemr7732376plh.18.1693681610684;
        Sat, 02 Sep 2023 12:06:50 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902bcc300b001b89b7e208fsm4946971pls.88.2023.09.02.12.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Sep 2023 12:06:49 -0700 (PDT)
Date:   Sat, 2 Sep 2023 19:06:46 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
Message-ID: <ZPOHxsdYhWdMRoyT@google.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <20230901185646.2823254-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901185646.2823254-2-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023, Jim Mattson wrote:
> Per the SDM, "When the local APIC handles a performance-monitoring
> counters interrupt, it automatically sets the mask flag in the LVT
> performance counter register."
> 
> Add this behavior to KVM's local APIC emulation, to reduce the
> incidence of "dazed and confused" spurious NMI warnings in Linux
> guests (at least, those that use a PMI handler with "late_ack").
> 
> Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT source")
> Signed-off-by: Jim Mattson <jmattson@google.com>
Tested-by: Mingwei Zhang <mizhang@google.com>

I see consistent number of PMIs and NMIs when running perf on an idle
VM.
> ---
>  arch/x86/kvm/lapic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a983a16163b1..1a79ec54ae1e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2743,6 +2743,8 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
>  		vector = reg & APIC_VECTOR_MASK;
>  		mode = reg & APIC_MODE_MASK;
>  		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
> +		if (lvt_type == APIC_LVTPC)
> +			kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);
>  		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
>  					NULL);
>  	}
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
