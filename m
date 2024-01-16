Return-Path: <kvm+bounces-6303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E2B82E791
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 02:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96F5C284D73
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 01:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8309445971;
	Tue, 16 Jan 2024 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k12VwZU7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D845033;
	Tue, 16 Jan 2024 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8811C43141;
	Tue, 16 Jan 2024 01:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705367329;
	bh=3iYdslzpkXnRHuYnBqf0hdYgFBmOQwoJSadwT1oJERA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k12VwZU7Qcpes4QQfnzooOgkWs7kP3Iirws4uXjzRqD/Cbr7It7NGHlHSbCsCx8bD
	 lzh1uwJ8dokhd4EoXVxIUNNWq0nn8NrBh+GqUo2yqTiI7tXTE/woXj5zQhMFHTUH5w
	 Arc0ZwpIOCO28zhpqX8kVChR5S6S+G2dOwfSjvk8yUJQT/A7B5FkECD0i1By4gj3dx
	 BkZt4JqGyuCCduTJFRER+5lv1+mQGmrb/HLgvsZrWcJAS/JYJNvn+h91eVfAQizQNi
	 HwYeNJOvqJMzaknfOgejdIkXvVKNLtcU3dHf9LQADXRnALeUsRcNoXW94Sm+N7aeUM
	 8e5bdc9XlfnFw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	frankja@linux.ibm.com,
	gor@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/8] KVM: s390: fix setting of fpc register
Date: Mon, 15 Jan 2024 20:08:33 -0500
Message-ID: <20240116010842.219925-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240116010842.219925-1-sashal@kernel.org>
References: <20240116010842.219925-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.305
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b988b1bb0053c0dcd26187d29ef07566a565cf55 ]

kvm_arch_vcpu_ioctl_set_fpu() allows to set the floating point control
(fpc) register of a guest cpu. The new value is tested for validity by
temporarily loading it into the fpc register.

This may lead to corruption of the fpc register of the host process:
if an interrupt happens while the value is temporarily loaded into the fpc
register, and within interrupt context floating point or vector registers
are used, the current fp/vx registers are saved with save_fpu_regs()
assuming they belong to user space and will be loaded into fp/vx registers
when returning to user space.

test_fp_ctl() restores the original user space / host process fpc register
value, however it will be discarded, when returning to user space.

In result the host process will incorrectly continue to run with the value
that was supposed to be used for a guest cpu.

Fix this by simply removing the test. There is another test right before
the SIE context is entered which will handles invalid values.

This results in a change of behaviour: invalid values will now be accepted
instead of that the ioctl fails with -EINVAL. This seems to be acceptable,
given that this interface is most likely not used anymore, and this is in
addition the same behaviour implemented with the memory mapped interface
(replace invalid values with zero) - see sync_regs() in kvm-s390.c.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 92041d442d2e..bc700cb9fc53 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2995,10 +2995,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	if (test_fp_ctl(fpu->fpc)) {
-		ret = -EINVAL;
-		goto out;
-	}
 	vcpu->run->s.regs.fpc = fpu->fpc;
 	if (MACHINE_HAS_VX)
 		convert_fp_to_vx((__vector128 *) vcpu->run->s.regs.vrs,
@@ -3006,7 +3002,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	else
 		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
-out:
 	vcpu_put(vcpu);
 	return ret;
 }
-- 
2.43.0


