Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B18C626F12
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 11:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiKMK4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 05:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiKMK4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 05:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C2E0C3
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 02:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D2B60B7E
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 10:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63216C433C1;
        Sun, 13 Nov 2022 10:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668337012;
        bh=trm3rGMA5rnXiFoEQpHrSOOXOS+O2YdKgkWR5wd2uEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eG+tavAcGQRly3lVfo/slzAGhIA564/xTuBI16ruL5eug3Vw5HcvzqARORkDpUIx9
         PX/lsQDPIBrITMxho9ssAhANu8EmK/SfqTD4CU0HlCv8lT50Ie7Vfrkmg6F9xImaYd
         bdMoyTyC+zW1/wW8htnGWFbExAkc40B5c+2mq56OOsdqOPj6/ipbYIPTzT96FuH086
         8MI5Fr0OK01OZB+OwxywjeSL9heBXZaeNbQGZ5FGM7CCJN2CqyB1l48BeAnsvnZjit
         uCpica9AfR5T1w6xxFvNYMYcaBxH1/1/4B00bpEd7u1QZJIGnrz6epBqO4qOzVwk6O
         cQreR24V5MByQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouAfS-005mlQ-2P;
        Sun, 13 Nov 2022 10:56:50 +0000
MIME-Version: 1.0
Date:   Sun, 13 Nov 2022 10:56:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
In-Reply-To: <CAAeT=Fzgu1iaMmGXWZcmj9ifmchKXZXG2y7ksvQzoTGAQ=G-jw@mail.gmail.com>
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org>
 <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org>
 <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
 <87pme0fdvp.wl-maz@kernel.org>
 <CAAeT=Fzgu1iaMmGXWZcmj9ifmchKXZXG2y7ksvQzoTGAQ=G-jw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <37d0738282f1a37cdb931686d0b89ac0@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-11-08 05:36, Reiji Watanabe wrote:
> Hi Marc,
> 
>> > BTW, if we have no intention of supporting a mix of vCPUs with and
>> > without PMU, I think it would be nice if we have a clear comment on
>> > that in the code.  Or I'm hoping to disallow it if possible though.
>> 
>> I'm not sure we're in a position to do this right now. The current API
>> has always (for good or bad reasons) been per-vcpu as it is tied to
>> the vcpu initialisation.
> 
> Thank you for your comments!
> Then, when a guest that has a mix of vCPUs with and without PMU,
> userspace can set kvm->arch.dfr0_pmuver to zero or IMPDEF, and the
> PMUVER for vCPUs with PMU will become 0 or IMPDEF as I mentioned.
> For instance, on the host whose PMUVER==1, if vCPU#0 has no 
> PMU(PMUVER==0),
> vCPU#1 has PMU(PMUVER==1), if the guest is migrated to another host 
> with
> same CPU features (PMUVER==1), if SET_ONE_REG of ID_AA64DFR0_EL1 for 
> vCPU#0
> is done after for vCPU#1, kvm->arch.dfr0_pmuver will be set to 0, and
> the guest will see PMUVER==0 even for vCPU1.
> 
> Should we be concerned about this case?

Yeah, this is a real problem. The issue is that we want to keep
track of two separate bits of information:

- what is the revision of the PMU when the PMU is supported?
- what is the PMU unsupported or IMPDEF?

and we use the same field for both, which clearly cannot work
if we allow vcpus with and without PMUs in the same VM.

I've now switched to an implementation where I track both
the architected version as well as the version exposed when
no PMU is supported, see below.

We still cannot track both no-PMU *and* impdef-PMU, nor can we
track multiple PMU revisions. But that's not a thing as far as
I am concerned.

Thanks,

         M.

diff --git a/arch/arm64/include/asm/kvm_host.h 
b/arch/arm64/include/asm/kvm_host.h
index 90c9a2dd3f26..cc44e3bc528d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -163,7 +163,10 @@ struct kvm_arch {

  	u8 pfr0_csv2;
  	u8 pfr0_csv3;
-	u8 dfr0_pmuver;
+	struct {
+		u8 imp:4;
+		u8 unimp:4;
+	} dfr0_pmuver;

  	/* Hypercall features firmware registers' descriptor */
  	struct kvm_smccc_features smccc_feat;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6b3ed524630d..f956aab438c7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -168,7 +168,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long 
type)
  	 * Initialise the default PMUver before there is a chance to
  	 * create an actual PMU.
  	 */
-	kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_pmuver_limit();
+	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();

  	return ret;
  out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 95100896de72..615cb148e22a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1069,14 +1069,9 @@ static bool access_arch_timer(struct kvm_vcpu 
*vcpu,
  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
  {
  	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver;
+		return vcpu->kvm->arch.dfr0_pmuver.imp;

-	/* Special case for IMPDEF PMUs that KVM has exposed in the past... */
-	if (vcpu->kvm->arch.dfr0_pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
-		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
-
-	/* The real "no PMU" */
-	return 0;
+	return vcpu->kvm->arch.dfr0_pmuver.unimp;
  }

  static u8 perfmon_to_pmuver(u8 perfmon)
@@ -1295,7 +1290,10 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu 
*vcpu,
  	if (val)
  		return -EINVAL;

-	vcpu->kvm->arch.dfr0_pmuver = pmuver;
+	if (valid_pmu)
+		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
+	else
+		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;

  	return 0;
  }
@@ -1332,7 +1330,10 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
  	if (val)
  		return -EINVAL;

-	vcpu->kvm->arch.dfr0_pmuver = perfmon_to_pmuver(perfmon);
+	if (valid_pmu)
+		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
+	else
+		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);

  	return 0;
  }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3d526df9f3c5..628775334d5e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -93,7 +93,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
   * Evaluates as true when emulating PMUv3p5, and false otherwise.
   */
  #define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)

  u8 kvm_arm_pmu_get_pmuver_limit(void);

-- 
Jazz is not dead. It just smells funny...
