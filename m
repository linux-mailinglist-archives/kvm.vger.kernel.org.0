Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F8977D8CB
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbjHPDEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbjHPDEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:04:22 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E46C98
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 20:04:20 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1c4f4d67f5bso1891090fac.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 20:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692155060; x=1692759860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PbUwQci3yHdMlV3tff0nEXdq6+hUjlgV0bD2bXxRCQQ=;
        b=J2i4I01D5vunEh4zyxJMzRJ+HML+Fkz7JnIEETKY+Rdt/zTPpOgicvucsCD8X8gvsV
         tlnKJzudFhgeNVYsj7v0OvqpKhGJWsSa4Yb+I5qPeMOyK3SerkSLKqtT2RnUwQFlYDBf
         N230n7WFrQOdvEDbd/bU+hpM/TlLGZSDU0ruqDOMGxgOLatenKp6b5uYNiO4CdWmZPpx
         oB7g+2TFYOx4ejrFxdGOc36iY5hneURiFXprRQXw5haTfcpQZg1CRU2HGQcv8icsu9jF
         tWFrJn2nRaiOD3rgwInjW3KIsOCi/hSOJw0BdaSa/Dwp5vM4dKYtwANLF3SDHqskX6/C
         3Dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692155060; x=1692759860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbUwQci3yHdMlV3tff0nEXdq6+hUjlgV0bD2bXxRCQQ=;
        b=BT50a7AoprLRdNj0jmQFC612d818DUNr+36pdz8T0A4FWRSuzSjunhUhrgzaf0xngp
         9R5xpJZzjMYR9XiFNemAQGFaKzd3poDGa8Cr2P73EktWIZjl5g+yEZFlWKd/K1GVpOyf
         zehbDxObi4L8+mVm7vZeM+skfebZ2mKpn5OrWrdaqXgbaAwr6kBGKsCztajKM+gawbOe
         UFxxVJTt/Yc8vWErx8tfTS1V/hiAVtX4gbhNh39E3U5VggcUloOnG433wj3YiXeJLNPl
         hHLjMBIH8aNZ/PW3eYSI3eYE8bscvyc07W46f72Lutep6BDZI3rhI2RzPV0KbxaLAGd8
         kRXg==
X-Gm-Message-State: AOJu0YxizwzLE5xhz6WSHZGHqwhzG0MAUYVHQyvWsbmtuZt87fPcHw8X
        RO1DZM4QuFb5I4ABNXeyWurwFw==
X-Google-Smtp-Source: AGHT+IFxyrXLX1rtq7cqWcrPo0K9tp7pvjJThOgma4n4YvsV9mSOFbliMSIC2KW8LHl1Gs5xRYhVRw==
X-Received: by 2002:a05:6870:9725:b0:1bf:87af:e6df with SMTP id n37-20020a056870972500b001bf87afe6dfmr622354oaq.55.1692155059803;
        Tue, 15 Aug 2023 20:04:19 -0700 (PDT)
Received: from leoy-huanghe.lan ([150.230.248.162])
        by smtp.gmail.com with ESMTPSA id bo24-20020a17090b091800b00262d6ac0140sm10086730pjb.9.2023.08.15.20.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 20:04:19 -0700 (PDT)
Date:   Wed, 16 Aug 2023 11:04:12 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230816030412.GB135657@leoy-huanghe.lan>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe>
 <87leecq0hj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leecq0hj.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 07:32:40AM +0100, Marc Zyngier wrote:
> On Mon, 14 Aug 2023 08:16:27 +0100,
> Leo Yan <leo.yan@linaro.org> wrote:
> > 
> > On Fri, Aug 11, 2023 at 07:05:20PM +0100, Marc Zyngier wrote:
> > > Huang Shijie reports that, when profiling a guest from the host
> > > with a number of events that exceeds the number of available
> > > counters, the reported counts are wildly inaccurate. Without
> > > the counter oversubscription, the reported counts are correct.
> > > 
> > > Their investigation indicates that upon counter rotation (which
> > > takes place on the back of a timer interrupt), we fail to
> > > re-apply the guest EL0 enabling, leading to the counting of host
> > > events instead of guest events.
> > 
> > Seems to me, it's not clear for why the counter rotation will cause
> > the issue.
> 
> Maybe unclear to you, but rather clear to me (and most people else on
> Cc).

I have to admit this it true.

> > In the example shared by Shijie in [1], the cycle counter is enabled
> > for both host and guest
> 
> No. You're misreading the example. We're profiling the guest from the
> host, and the guest has no PMU access.
> 
> > and cycle counter is a dedicated event
> > which does not share counter with other events.  Even there have
> > counter rotation, it should not impact the cycle counter.
> 
> Who says that we're counting cycles using the cycle counter? This is
> an event like any other, and it can be counted on any counter.

Sorry for noise.

> > I mean if we cannot explain clearly for this part, we don't find the
> > root cause, and this patch (and Shijie's patch) just walks around the
> > issue.
> 
> We have the root cause. You just need to think a bit harder.

Let me elaborate a bit more for my concern.  The question is how we can
know the exactly the host and the guest have the different counter
enabling?

Shijie's patch relies on perf event rotation to trigger syncing for
PMU PMEVTYPER and PMCCFILTR registers.  The perf event rotation will
enable and disable some events, but it doesn't mean the host and the
guest enable different counters.  If we use the perf event rotation to
trigger syncing, there must introduce redundant operations.

In your patch, it resyncs the PMU registers in the function
armv8pmu_start(), this function is invoked not only when start PMU
event, it also is invoked in PMU interrupt handler (see
armv8pmu_handle_irq()), this also will lead to redundant syncing if
we use the perf record command for PMU event sampling:

  perf record -e cycles:G,cycles:H -d -d -- sleep 10

This is why I think we should trigger the syncing in the function
kvm_set_pmu_events(), where we can know exactly the event mismatching
between the host and the guest.  At the beginning it has checked the
difference between the host and the guest by calling
kvm_pmu_switch_needed(attr), thus we don't need to add more condition
checking and directly call kvm_vcpu_pmu_resync_el0().

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 121f1a14c829..99adcdbb6a5d 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -46,6 +46,12 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
                pmu->events_host |= set;
        if (!attr->exclude_guest)
                pmu->events_guest |= set;
+
+       /*
+        * The host and the guest enable different events for EL0,
+        * resync it.
+        */
+       kvm_vcpu_pmu_resync_el0();
 }

Thanks,
Leo
