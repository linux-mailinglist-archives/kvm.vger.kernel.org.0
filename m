Return-Path: <kvm+bounces-11895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0CF87C9B5
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0A971F22D5A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9927E171A2;
	Fri, 15 Mar 2024 08:11:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E3C1429B;
	Fri, 15 Mar 2024 08:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490270; cv=none; b=kgFu6FfV4OXy9q8SeWccIm35XcQPPTlr+SgOmBkZKvN5r2aaALHzDsUg7pzhsT1I+9cK2eBdhGWzbJRgiE9XdAEnQkGK5k0gu7CIMa5MWW/cs1VHlL9DrKWzP07WMmxn4Uq9Jw+uM4Y5l6TQhwZR4ksMoig7nMteG5jfm3bD7z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490270; c=relaxed/simple;
	bh=pXqz4qetKcexyld6lqrWVua3KVrcp3aKmnVf9vX3cr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kJ72fEkXD1uaf+jxI1QycHm3cVQgC+e+FRv1Sx7lkF6p/WYO7qy+6v12ENfhoJ+ngCKbsWSKNRzJo+ZMeIE6AChCOrZPlp/XlfiapYeyZKcQkOrJU0uHqIi1tTrwEnk1HfUOxb6qHFQDWdWSLSZWxDApEtKky/RmvP52RxzQ1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxeeiZAvRlAmYZAA--.41874S3;
	Fri, 15 Mar 2024 16:11:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfROYAvRlv8haAA--.9838S2;
	Fri, 15 Mar 2024 16:11:04 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v7 7/7] Documentation: KVM: Add hypercall for LoongArch
Date: Fri, 15 Mar 2024 16:11:04 +0800
Message-Id: <20240315081104.2813031-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240315080710.2812974-1-maobibo@loongson.cn>
References: <20240315080710.2812974-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfROYAvRlv8haAA--.9838S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAFWUury5tw15XF47Kw1ktFc_yoWrtr4rpF
	95G3s7Grn7Jry7A347JF1UXryYkryxJF47Ga18Jr1Fqr1Dtr1fJr4UtFyYy3W8G3y8AFy8
	XF1Iqr1j9r1UAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Wrv_ZF1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Ar0_tr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jxxhdUUUUU=

Add documentation topic for using pv_virt when running as a guest
on KVM hypervisor.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 Documentation/virt/kvm/index.rst              |  1 +
 .../virt/kvm/loongarch/hypercalls.rst         | 82 +++++++++++++++++++
 Documentation/virt/kvm/loongarch/index.rst    | 10 +++
 3 files changed, 93 insertions(+)
 create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
 create mode 100644 Documentation/virt/kvm/loongarch/index.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ad13ec55ddfe..9ca5a45c2140 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -14,6 +14,7 @@ KVM
    s390/index
    ppc-pv
    x86/index
+   loongarch/index
 
    locking
    vcpu-requests
diff --git a/Documentation/virt/kvm/loongarch/hypercalls.rst b/Documentation/virt/kvm/loongarch/hypercalls.rst
new file mode 100644
index 000000000000..0f61a49c31a9
--- /dev/null
+++ b/Documentation/virt/kvm/loongarch/hypercalls.rst
@@ -0,0 +1,82 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+The LoongArch paravirtual interface
+===================================
+
+KVM hypercalls use the HVCL instruction with code 0x100, and the hypercall
+number is put in a0 and up to five arguments may be placed in a1-a5, the
+return value is placed in a0.
+
+The code for that interface can be found in arch/loongarch/kvm/*
+
+Querying for existence
+======================
+
+To find out if we're running on KVM or not, cpucfg can be used with index
+CPUCFG_KVM_BASE (0x40000000), cpucfg range between 0x40000000 - 0x400000FF
+is marked as a specially reserved range. All existing and future processors
+will not implement any features in this range.
+
+When Linux is running on KVM, cpucfg with index CPUCFG_KVM_BASE (0x40000000)
+returns magic string "KVM\0"
+
+Once you determined you're running under a PV capable KVM, you can now use
+hypercalls described as follows.
+
+KVM hypercall ABI
+=================
+
+Hypercall ABI on KVM is simple, only one scratch register a0 and at most
+five generic registers used as input parameter. FP register and vector register
+is not used for input register and should not be modified during hypercall.
+Hypercall function can be inlined since there is only one scratch register.
+
+The parameters are as follows:
+
+        ========	=========================	=====================
+	Register	IN			        OUT
+        ========	=========================	=====================
+	a0		function number(Required)       Return code(Required)
+	a1		1st parameter(Optional)		Keep Unmodified
+	a2		2nd parameter(Optional)		Keep Unmodified
+	a3		3rd parameter(Optional)		Keep Unmodified
+	a4		4th parameter(Optional)		Keep Unmodified
+	a5		5th parameter(Optional)		Keep Unmodified
+        ========	=========================	=====================
+
+Return codes can be as follows:
+
+	====		=========================
+	Code		Meaning
+	====		=========================
+	0		Success
+	-1		Hypercall not implemented
+	-2		Hypercall parameter error
+	====		=========================
+
+KVM Hypercalls Documentation
+============================
+
+The template for each hypercall is:
+1. Hypercall name
+2. Purpose
+
+1. KVM_HCALL_FUNC_PV_IPI
+------------------------
+
+:Purpose: Send IPIs to multiple vCPUs.
+
+- a0: KVM_HCALL_FUNC_PV_IPI
+- a1: lower part of the bitmap of destination physical cpu core id
+- a2: higher part of the bitmap of destination physical cpu core id
+- a3: the lowest physical cpu core id in bitmap
+
+The hypercall lets a guest send multicast IPIs, with at most 128
+destinations per hypercall.  The destinations are represented by a bitmap
+contained in the first two arguments (a1 and a2). Bit 0 of a1 corresponds
+to the physical cpu core id in the third argument (a3), bit 1 corresponds
+to the physical cpu core id a3+1, and so on.
+
+Returns success always, it skips current cpu and continues to send ipi to
+next cpu in the bitmap mask if current physical cpu core id is invalid.
diff --git a/Documentation/virt/kvm/loongarch/index.rst b/Documentation/virt/kvm/loongarch/index.rst
new file mode 100644
index 000000000000..83387b4c5345
--- /dev/null
+++ b/Documentation/virt/kvm/loongarch/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+KVM for LoongArch systems
+=========================
+
+.. toctree::
+   :maxdepth: 2
+
+   hypercalls.rst
-- 
2.39.3


