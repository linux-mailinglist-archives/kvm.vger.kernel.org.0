Return-Path: <kvm+bounces-16419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 788B68B9DA7
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A64E1B20E74
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 15:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED13615B551;
	Thu,  2 May 2024 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIOvItjf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF575FEE6;
	Thu,  2 May 2024 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664458; cv=none; b=ZCdOeOxM9vujRMKiJkaxMdXB3dxGIIj+3zUP/1bElvouc33f+bGUvjuP7xmQIgTG7OsIaS9Su/A7wOVY3//VcZwLSqhv1VC1su5tjbmeG2rn4HChz4q1ppWNk0kAZ9c15mlfynjsJQN2e8I70eAgX50YvZaTshgcTvtTBpjXYUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664458; c=relaxed/simple;
	bh=vU1lCApgLRFnEuBLywP7HS3Nr11RFW1hlRlh/WJm3AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PhYIWr4Fcqxo6WZGH33VJvs6SyClKID0QTLHURXQ2WJy2o0erEr1gSE9xYLxiJ/lH5JTCH6gc2G+pNW7qTl+wIf5QlRM9YajzE0mPGQzm37tbVdSMS7XyLMUISbE7AgyhmtArBdNihEHQi/Va9gv5Sdqd9K910n6risx6pzXbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIOvItjf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F310C113CC;
	Thu,  2 May 2024 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714664457;
	bh=vU1lCApgLRFnEuBLywP7HS3Nr11RFW1hlRlh/WJm3AQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WIOvItjf0yHXQbEMwMZwkU6bmA1L/sLjHSJwkOUzdEtMWGQlOFgiVx4O3e1ckQ2v3
	 JgclevQ04quD4rlaYcOEs5LIOR4AEJO3JII9JMEjZ8g4ekq71jGsnF/XZ30D7+Hhcf
	 2u+eEVMg10YV59PN3N/S7vTAgt1euZ/Z+V4aplwfA3F/jeVV928qH0Da9LbTIeeFmy
	 QIUD6CbyFfnPGBbUu6+k8XqaXKdBafffsn3eNzwFL7qGvz1qEo6v1VtXMJGgbqDEYR
	 ycrQg5sSlaPtd+QoF0H+tFOvWWSpCdoimvqZrDNAqWiL9t4VOSQFHMdXsAjMlKBsTq
	 y33JOCd2u48DA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2YYJ-00A2kO-Go;
	Thu, 02 May 2024 16:40:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] KVM: arm64: Move management of __hyp_running_vcpu to load/put on VHE
Date: Thu,  2 May 2024 16:40:30 +0100
Message-Id: <20240502154030.3011995-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The per-CPU host context structure contains a __hyp_running_vcpu that
serves as a replacement for kvm_get_current_vcpu() in contexts where
we cannot make direct use of it (such as in the nVHE hypervisor).
Since there is a lot of common code between nVHE and VHE, the latter
also populates this field even if kvm_get_running_vcpu() always works.

We currently pretty inconsistent when populating __hyp_running_vcpu
to point to the currently running vcpu:

- on {n,h}VHE, we set __hyp_running_vcpu on entry to __kvm_vcpu_run
  and clear it on exit.

- on VHE, we set __hyp_running_vcpu on entry to __kvm_vcpu_run_vhe
  and never clear it, effectively leaving a dangling pointer...

VHE is obviously the odd one here. Although we could make it behave
just like nVHE, this wouldn't match the behaviour of KVM with VHE,
where the load phase is where most of the context-switch gets done.

So move all the __hyp_running_vcpu management to the VHE-specific
load/put phases, giving us a bit more sanity and matching the
behaviour of kvm_get_running_vcpu().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3c339d552591..d7af5f46f22a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -194,6 +194,8 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 {
+	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
+
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
 	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
@@ -203,6 +205,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 {
 	__vcpu_put_deactivate_traps(vcpu);
 	__vcpu_put_switch_sysregs(vcpu);
+
+	host_data_ptr(host_ctxt)->__hyp_running_vcpu = NULL;
 }
 
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
@@ -307,7 +311,6 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	u64 exit_code;
 
 	host_ctxt = host_data_ptr(host_ctxt);
-	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
-- 
2.39.2


