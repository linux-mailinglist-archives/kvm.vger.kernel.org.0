Return-Path: <kvm+bounces-9416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3923A85FDC7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B7CCB2AE47
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E05153511;
	Thu, 22 Feb 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m3PIALxO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844DE153506
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618302; cv=none; b=bqwskrucnJn4HJ6DABp7EA6/f6lV/yAII5EXYvodX/uGr4awA15t5ItTXq0l4tk7L7T4OuyBDZc2NIO5XHh301dYo8OUtU1Xfi9yrJjOoMsm4RhF0/GUTEKKcHU73fVhnWcv4pyprSz/7+oLFgZ8z9Z2Rqd2X5qPO5yZTwjo5jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618302; c=relaxed/simple;
	bh=MBXw36BeBpgzLpaJ6DDMj7mANbp5a67/tbxZ56a4zsI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DgXZiV/fpiziWap1nVc4SZg+8IoIVGp+eUfLxzY3j5l+hjbguqMxISncnMivUQt3/azBBoQjfvBUxnDMWtxZyC8B3sT88m0YTJkA2kEVsskHmL9DCFZr/QBdv6CNu1ZSaTXx/g1XyBEeva2l9PGjPVtmRuBtjVT7HtGjv9OXzW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m3PIALxO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41256717763so31666315e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618299; x=1709223099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3PquBHsQ9j3O8VxfhBiNpCD7E3dPFUw+j7QK93cQQM=;
        b=m3PIALxOp2oDnlFZjlwA+hEhyC0SfgRogqJGpenb1V4CNksVVYP/XDwl2X03T8q6HD
         cUaKKeupSL3tRWUNbuEZRUX9gSN9ru7NDdW5ayoZ2Dfy5tTsH1F0kClUtZfjgLmz0BG1
         HtKNEWpAT7BaniqowB3nmMY5TVD7o1yWSFcbCDECpS5BmqPd80JTjwtuW9/W/T5LUz6h
         w1Peg4SzReMvNvV55s7lsAb7QycKui2bXQN1XpGEjHs2YB2TOolGgrN9ze5DZbqyLkvc
         QkxgwEwq5KY1RYePl7XSWfT1Cpef7W2pxJSsqJg6TxvDkHoNS+UCXoEOVlZW5ywgZ+Tc
         Iv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618299; x=1709223099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3PquBHsQ9j3O8VxfhBiNpCD7E3dPFUw+j7QK93cQQM=;
        b=EtEhkrxtr5lh4FwSADhYcZVddRXkoX2U1AVoHDWGuv60QPydvexwkXxhwBW1sZWCo0
         3q8o9KwuJdVKjKj06Xw1TOJUdNtUUUmo3D/8IbWki7QKtv1DHVGK5/udnlCnVKORLIjO
         /ji3y4zCzpbtaxBchyP6q52281iobJ3iJXRw/thgSQlqIKdrtqYlcEXMzHQONYkyYB/5
         zBH8HbXEV0ZQosLYiyfiC7rO1VMCzwIOtvBckIhMNOWQFsSFlIPpTdG2e8USea1YmBsH
         zHBgcutn2uvLBDwk49PKtGKb63gAML0Z8KvWE66K7wwSi1jTYRv5Xa7Mqps8YBnERA8V
         eMOQ==
X-Gm-Message-State: AOJu0Yxdn3ywtCLuns0kKzFw99fZyX2V7OBPH64kOnqVrHVz0eFWvDK5
	S5GWtRGpbqw77bCjN5lBUYRBCBDamhqG3kCG5HlZcQ4s6SwtBFE3Hcb0+NT6p4MyQWv4zSk8fS9
	gzpDFqCSU3tsLufxfPo2ZlciM95yZEhB1wrx4pHaTeSl7vtfhnW1Z1W8eV3980A+Q7VJMhVoTFM
	uktDLPrHzdj/1rADYtP80xZLE=
X-Google-Smtp-Source: AGHT+IFHt8ljAgUFsumQUx43edqLPoztEr5s7k3xHUmGMWApCiCTFox1L/DuSqvEX2oWzicoQqDqguGfpg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c2aa:0:b0:411:ea5e:615a with SMTP id
 c10-20020a7bc2aa000000b00411ea5e615amr248951wmk.1.1708618298281; Thu, 22 Feb
 2024 08:11:38 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:41 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-21-tabba@google.com>
Subject: [RFC PATCH v1 20/26] KVM: arm64: Track sharing of memory from
 protected guest to host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Track memory being explicitly shared by the guest to the host,
and update the NOT_MAPPABLE attribute accordingly.  This would
allow shared memory to be mapped by the host, and enable us to
ensure that unshared memory is not mappable by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hypercalls.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b08e18128de4..56fb4fa70eec 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -163,6 +163,32 @@ static int kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
 	return 0;
 }
 
+static int kvm_vcpu_handle_xshare(struct kvm_vcpu *vcpu, u32 nr)
+{
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE)) {
+		u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
+		gfn_t gfn = vcpu_get_reg(vcpu, 1) >> PAGE_SHIFT;
+		unsigned long attributes = 0;
+		int ret;
+
+		if (!(mask & BIT(nr)))
+			goto err;
+
+		if (nr == ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
+			attributes = KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE;
+
+		ret = kvm_vm_set_mem_attributes_kernel(vcpu->kvm, gfn, gfn + 1, attributes);
+		if (ret)
+			goto err;
+	}
+
+	return kvm_vcpu_exit_hcall(vcpu, nr, 3);
+
+err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return 1;
+}
+
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
@@ -411,9 +437,9 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		val[0] = SMCCC_RET_SUCCESS;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
-		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE, 3);
+		return kvm_vcpu_handle_xshare(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
-		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE, 3);
+		return kvm_vcpu_handle_xshare(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
-- 
2.44.0.rc1.240.g4c46232300-goog


