Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D388977B495
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjHNIro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbjHNIrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:47:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF48B1715
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 01:47:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6874d1c8610so2535795b3a.0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 01:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692002838; x=1692607638;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PYKwbtaMp//CAdWN8SyKA1nXnFDIlEGRDpnjYmJ1fDk=;
        b=hbNWsFE56i3xCnyaHvsPALp53csD0RhtoCwpRxxt32sYvbBSE/2bfMocn51g2Jia1c
         qkn42mtrWOoO0O1yG3VOBQwxK9Vu28lBnSKHhRVjdBiL/LVFI9FGtKs1I2GLJDDv6wV/
         f4t4pERGpW7VKSxafZihfuu+i2z7f+kT1yJFDVCJHmTWZsIZyZtPUitN3AXfRwT7MwXY
         VRy6LzCpXGsJFWiLV7U0Fi+pHiRlr6Hh8wF0tXLI7KKhuOxg9DkTNod+f5EWCQLK4LHb
         z41SbZDHCfpvnqm9QMPiBBqJso2Q3EYAOwQ5/dutxbBKjdfuzshXL+Fir4BzsXHBcZZ1
         x1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692002838; x=1692607638;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYKwbtaMp//CAdWN8SyKA1nXnFDIlEGRDpnjYmJ1fDk=;
        b=j+/7owEQLCNeDgQc7gZ+BidYy0JEgBiWAKMHUjjX0+AevpbQVuRvt51RPxobWGxeGD
         o7zzKKY/4gfagBp7B8AQqwE9VGRfS+rvTH7gwYUuTJb/HTReY+Ghho7qUJiBoakVwTeh
         PN2MPBVjSVaz5OznE9xRxlpjTfuzlu7Ou4yPNSwqnyc8N34gbfzlixA/hYbm9eORjRCF
         HpofFT3kGkh3NPKQm9koPFtwEzq51vkht785uLMDSUTa569oBQ+RSDAQQ5P643N6Z8ey
         S6rzwESTVaKQrsgL/Wt9bkJbwQicHPR/r3AzOvB4R8847NqCpXSLYAv2XZ4eckw5roxq
         dfsg==
X-Gm-Message-State: AOJu0YwHPtwpagG+PYFATRIiwLpJwJfPDuLXwgISqepOaSPLUV8v3TlA
        alqn7AsLkKuQpLkmSH/rks2+0Q==
X-Google-Smtp-Source: AGHT+IFRlhOXNFSqg0G5udsNG6Ftwgsd0G2n/AiH38qLErUVrfvrIfQjyAOPIm/yELCQLJwhcsm0Xg==
X-Received: by 2002:a05:6a00:3925:b0:668:8596:752f with SMTP id fh37-20020a056a00392500b006688596752fmr8445682pfb.4.1692002838132;
        Mon, 14 Aug 2023 01:47:18 -0700 (PDT)
Received: from leoy-huanghe.lan ([150.230.248.162])
        by smtp.gmail.com with ESMTPSA id t14-20020aa7938e000000b00682ed27f99dsm7368544pfe.46.2023.08.14.01.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 01:47:17 -0700 (PDT)
Date:   Mon, 14 Aug 2023 16:47:10 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Shijie Huang <shijie@amperemail.onmicrosoft.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230814084710.GA69080@leoy-huanghe.lan>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe>
 <5608d22d-47c3-2a03-a3d9-ba8ec51679a3@amperemail.onmicrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5608d22d-47c3-2a03-a3d9-ba8ec51679a3@amperemail.onmicrosoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shijie,

On Mon, Aug 14, 2023 at 04:12:23PM +0800, Shijie Huang wrote:

[...]

> > > Their investigation indicates that upon counter rotation (which
> > > takes place on the back of a timer interrupt), we fail to
> > > re-apply the guest EL0 enabling, leading to the counting of host
> > > events instead of guest events.
> >
> > Seems to me, it's not clear for why the counter rotation will cause
> > the issue.
> > 
> > In the example shared by Shijie in [1], the cycle counter is enabled for
> > both host and guest, and cycle counter is a dedicated event which does
> > not share counter with other events.  Even there have counter rotation,
> > it should not impact the cycle counter.
> 
> Just take a simple case:
> 
>    perf stat -e cycles:G,cycles:H, e2,e3,e4,e5,e6,e7 ....
> 
> 
> Assume we have 8 events, but PMU only privides 7 counters(cycle + 6 normal)

Thanks for the detailed info, now I understand it.

Seems to me, based on Marc's patch, we need to apply below change.  In
below code, we don't need to change the perf core code and we can
resolve it as a common issue for Arm PMU drivers.


diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 121f1a14c829..8f9673cdadec 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -38,14 +38,20 @@ struct kvm_pmu_events *kvm_get_pmu_events(void)
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
+	int resync;
 
 	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
 		return;
 
+	resync = pmu->events_guest != set;
+
 	if (!attr->exclude_host)
 		pmu->events_host |= set;
 	if (!attr->exclude_guest)
 		pmu->events_guest |= set;
+
+	if (resync)
+		kvm_vcpu_pmu_resync_el0();
 }
 
 /*
@@ -60,6 +66,8 @@ void kvm_clr_pmu_events(u32 clr)
 
 	pmu->events_host &= ~clr;
 	pmu->events_guest &= ~clr;
+
+	kvm_vcpu_pmu_resync_el0();
 }

