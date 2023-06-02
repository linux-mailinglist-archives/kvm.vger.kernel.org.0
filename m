Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090071F9A4
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 07:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjFBFXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 01:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjFBFXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 01:23:31 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F69197
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 22:23:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ae64580e9fso54415ad.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 22:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685683409; x=1688275409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EWBfi/Bb+FSYA44H8Ltnw7JbedUIicdbUOUcsi8q49A=;
        b=MzsQ9JXxA+Ns/c6gXcSlEu1OaHl6e51nDab4b5pyfBBZP9GjZY4riCHcrZxkF/XWQR
         ExPEH6NfkQtHJOsnmTvOzbAynCRyjq1Cw+vtelzQP0JbIwzR6vNZ2NYwyw7AtYVI1QO0
         gBWL77Fa0gXcQH96Fh5yLRBbx13T1hiVjDUCcjzLl8mzj7HspAtypfI/RL2y6qYxe8wy
         HpEgA4EyBIR/Qdh4IABqoYzitH9WQAzma5RVMzi0dYXnry4FaeKieWLIFpbT54oqHurn
         T7deKT+vjqZWtVnDN4dPRxpto4sXw3MGnlCPxcYH0NuaoPiDux77l1F1xC/ath8of0VA
         5pgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685683409; x=1688275409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWBfi/Bb+FSYA44H8Ltnw7JbedUIicdbUOUcsi8q49A=;
        b=BTqdi4KW2YyJwpJu+9p4otKek/mf0j3ZiGnA8yzvNKgTc616FkDSh4GoceJniCVvy5
         YgNlDZ6U0CtrZiIpDKbRPsioHv4jZBCvDZuI0FVXInZKt8il5i7o/PxJuLuT6Xdi48pq
         KsjMXDXZAF0ujLnYuz4jU1lX6Ja72IF7581pBLLxuPo3FJynsRBN3y/Nr0MzQTxVMSZV
         7dE+uf+DA7oWKgh0OcYOeeR8oKilfGhhAbF0BbR70MHS3ViNaQOjRdrWy+ZXa9vNIGVh
         F4/crAlRFeyxEX+rRrxTdEM0Qa37TPnmAdRrJP60e39TvHZgrTmsTpAQBm8usGe7d7+n
         n0TA==
X-Gm-Message-State: AC+VfDxyhsaYudHpklUwfzdXADxMa93BZooYVkOUkZ3/1SuB1ZXBSMRb
        694j/OSfjWlBRSOFc6FezCvSSA==
X-Google-Smtp-Source: ACHHUZ6Kdt5/EnRTdfnx5csSmnptZPPdGLhCIRaFc/sao752qWqRamocLnyBpxlzHGDZZ4oGqB/bDQ==
X-Received: by 2002:a17:902:fa04:b0:1af:90ce:5261 with SMTP id la4-20020a170902fa0400b001af90ce5261mr130615plb.24.1685683409126;
        Thu, 01 Jun 2023 22:23:29 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001ab25a19cfbsm329441plg.139.2023.06.01.22.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 22:23:27 -0700 (PDT)
Date:   Thu, 1 Jun 2023 22:23:23 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/4] KVM: arm64: PMU: Fix PMUVer handling on
 heterogeneous PMU systems
Message-ID: <20230602052323.shjn3q2rslbuwcmc@google.com>
References: <20230527040236.1875860-1-reijiw@google.com>
 <87zg5njlyn.wl-maz@kernel.org>
 <20230530125324.ijrwrvoll2detpus@google.com>
 <87mt1jkc5q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt1jkc5q.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Jun 01, 2023 at 06:02:41AM +0100, Marc Zyngier wrote:
> Hey Reiji,
> 
> On Tue, 30 May 2023 13:53:24 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, May 29, 2023 at 02:39:28PM +0100, Marc Zyngier wrote:
> > > On Sat, 27 May 2023 05:02:32 +0100,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > > 
> > > > This series fixes issues with PMUVer handling for a guest with
> > > > PMU configured on heterogeneous PMU systems.
> > > > Specifically, it addresses the following two issues.
> > > > 
> > > > [A] The default value of ID_AA64DFR0_EL1.PMUVer of the vCPU is set
> > > >     to its sanitized value.  This could be inappropriate on
> > > >     heterogeneous PMU systems, as arm64_ftr_bits for PMUVer is defined
> > > >     as FTR_EXACT with safe_val == 0 (when ID_AA64DFR0_EL1.PMUVer of all
> > > >     PEs on the host is not uniform, the sanitized value will be 0).
> > > 
> > > Why is this a problem? The CPUs don't implement the same version of
> > > the architecture, we don't get a PMU. Why should we try to do anything
> > > better? I really don't think we should go out or out way and make the
> > > code more complicated for something that doesn't really exist.
> > 
> > Even when the CPUs don't implement the same version of the architecture,
> > if one of them implement PMUv3, KVM advertises KVM_CAP_ARM_PMU_V3,
> > and allows userspace to configure PMU (KVM_ARM_VCPU_PMU_V3) for vCPUs.
> 
> Ah, I see it now. The kernel will register the PMU even if it decides
> that advertising it is wrong, and then we pick it up. Great :-/.
> 
> > In this case, although KVM provides PMU emulations for the guest,
> > the guest's ID_AA64DFR0_EL1.PMUVer will be zero.  Also,
> > KVM_SET_ONE_REG for ID_AA64DFR0_EL1 will never work for vCPUs
> > with PMU configured on such systems (since KVM also doesn't allow
> > userspace to set the PMUVer to 0 for the vCPUs with PMU configured).
> > 
> > I would think either ID_AA64DFR0_EL1.PMUVer for the guest should
> > indicate PMUv3, or KVM should not allow userspace to configure PMU,
> > in this case.
> 
> My vote is on the latter. Even if a PMU is available, we should rely
> on the feature exposed by the kernel to decide whether exposing a PMU
> or not.
> 
> To be honest, this will affect almost nobody (I only know of a single
> one, an obscure ARMv8.0+ARMv8.2 system which is very unlikely to ever
> use KVM). I'm happy to take the responsibility to actively break those.

Thank you for the information! Just curious, how about a mix of
cores with and without PMU ? (with the same ARMv8.x version)
I'm guessing there are very few if any though :) 


> 
> > This series is a fix for the former, mainly to keep the current
> > behavior of KVM_CAP_ARM_PMU_V3 and KVM_ARM_VCPU_PMU_V3 on such
> > systems, since I wasn't sure if such systems don't really exist :)
> > (Also, I plan to implement a similar fix for PMCR_EL0.N on top of
> > those changes)
> > 
> > I could make a fix for the latter instead though. What do you think ?
> 
> I think this would be valuable.

Thank you for the comment! I will go with the latter.


> Also, didn't you have patches for the EL0 side of the PMU? I've been
> trying to look for a new version, but couldn't find it...

While I'm working on fixing the series based on the recent comment from
Oliver (https://lore.kernel.org/all/ZG%2Fw95pYjWnMJB62@linux.dev/),
I have a new PMU EL0 issue, which blocked my testing of the series.
So, I am debugging the new PMU EL0 issue.

It appears that arch_perf_update_userpage() defined in
drivers/perf/arm_pmuv3.c isn't used, and instead, the weak one in
kernel/events/core.c is used.  This prevents cap_user_rdpmc (, etc)
from being set (This prevented my test program from directly
accessing counters).  This seems to be caused by the commit 7755cec63ade
("arm64: perf: Move PMUv3 driver to drivers/perf").

I have not yet figured out why the one in arm_pmuv3.c isn't used
though (The weak one in core.c seems to take precedence over strong
ones under drivers/ somehow...).

Anyway, I worked around the new issue for now, and ran the test for
my series though. I will post the new version of the EL0 series
tomorrow hopefully.

Thank you,
Reiji


> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
