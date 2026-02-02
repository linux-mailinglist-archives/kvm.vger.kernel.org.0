Return-Path: <kvm+bounces-69927-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JffDFgmgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69927-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:34:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1361CD2361
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:33:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7480230141C6
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECEF38E139;
	Mon,  2 Feb 2026 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VNVaKBND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C3338E5EF
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071444; cv=none; b=bMT0S1irMkgVn61qCnwxXV0cuTRLAiQ1N9LX7L5ZNoJJj92UhEy5ZoDD26/Q8Drl2dasA3SwbJ2Rbibd83iV0buUm9knJhfm2f2T38/b7fWxZC86vgbXkVUDF2gLR+c4RYO0lTeUtnOv8Ci58VkHoIgyEwU1dsC8IFD4IP39iZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071444; c=relaxed/simple;
	bh=CnMvc8PFIvzj6OX6g2J7JMmAZbEcoz5apL7easkxe4Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=METBxrFvGE6fpseOEqVC5B1xHnrFM7Jev12W7uk6hVy1FjZLuY9I9t0Z0mWtF8Vx+MMjkQYrNtNZh2aTZ+l/NH2+Z0k6Va8zZp9Z9EzJPLtMmVhF6Zy6S91UWZjD3h41gRqndUBtqWC5SrKZ+zyTV50ITDJ/VbeT+QbTCgRw82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VNVaKBND; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c552d1f9eafso10067052a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071442; x=1770676242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=njArHVHLCANBQYObbdX1NH6ZuPlMHP4JPxHwVmZR5sU=;
        b=VNVaKBNDu4xPBGed+Rqi83Bv3ToQLyp8oGa1KScyy2ui4E6cjtMh+lxxVjtzs4yVUo
         jaMuo15AodZKn9S6EhYjJd5hy2l4xWu11+Jbp5bE3Nia/iSmU4UCXzi4uacKXtS9fMss
         VGtKbjgW58u8spCGSbPBrZfvDNGhqyDgb3g1fT6dcr1OdaQ89QkGeJht+tGJ+xBRq722
         IbtRd8OlFOPm31Yv4AH3w/2JJRc/ddspzK8qQf8n7lWO2sFu88PaVs8oArnctLcDrpHs
         sOmR6wnUdXYMlH04LYYm7OoAfVAsWH9NZzhhKVCQFdWrPCi1/dDZ9Tcotvs76ke9/53s
         Ss7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071442; x=1770676242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njArHVHLCANBQYObbdX1NH6ZuPlMHP4JPxHwVmZR5sU=;
        b=u+GaiLX7PAl2BzO8Z4ydP8S4GTaxXNkBHSUmNhVSbTU+R+5iF0zqkAEzOQLh//ci/W
         1ajgBOLxgGrKdjugg5JCD2iNHDCtAFrS3ZXIXnMpN50dluDo+TzvbR9LFyuFa/hLDy2p
         jskr9forge1cD5tIibdGHsdx8mgfH5xpwFi7Py+HVYlDtkdLP2HgzXoEzsPYfXGucXJZ
         8h9XPQfKj3MSlT8IfL6Rei92Ib7AZfCx1dWkb5PQ+gLHWf4PXoYDjQKoMtCERXvoFlfm
         rMGch+71Xc7v+AH01YxW75VWpZlKBMOTZXWnDVWdn1/sAe2++VD8F55MW9VEbgvzZhxZ
         /DeA==
X-Gm-Message-State: AOJu0Yy+6QakjFYTlmRxbZSQq8N7UlQmfDVfDSy/AynWFmQINRCpFDAj
	sRFZdZbVRyJje4gTIY6avNtF8KZRGbQxDzWFCe7QjMOfeoiRRfoe/gleiuOB2CncFzEgJTb+MmD
	YDfE/MFQE8vzdcL/StzqFBlh/N5UsD51GC4Obf2l75N7u+NwohDBJJBEPp/8qU7IB9pI4I2c6vy
	iyM6HW5YIaClppJT8zdlhlEJe3p7s4zfEtMPyWSdCo0yGpYhdnVKiXxhoerlE=
X-Received: from pjst4.prod.google.com ([2002:a17:90b:184:b0:33b:51fe:1a73])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d8b:b0:34f:1623:2354 with SMTP id adf61e73a8af0-392e0115be3mr10998345637.42.1770071442154;
 Mon, 02 Feb 2026 14:30:42 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:50 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <7fee0231e3afa7b41cf4f71d2c462718b5cb9b34.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 12/37] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69927-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1361CD2361
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Make vm_memory_attributes a module parameter so that userspace can disable
the use of memory attributes on the VM level.

To avoid inconsistencies in the way memory attributes are tracked in KVM
and guest_memfd, the vm_memory_attributes module_param is made
read-only (0444).

Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
that might use vm_memory_attributes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 13 +++++++++----
 virt/kvm/kvm_main.c  |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 385f26da48ae..fea786906599 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -82,13 +82,20 @@ config KVM_WERROR
 
 config KVM_VM_MEMORY_ATTRIBUTES
 	select KVM_MEMORY_ATTRIBUTES
-	bool
+	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
+	bool "Enable per-VM memory attributes (for CoCo VMs)"
+	help
+	  Enable support for per-VM memory attributes, which are deprecated in
+	  favor of tracking memory attributes in guest_memfd.  Select this if
+	  you need to run CoCo VMs using a VMM that doesn't support guest_memfd
+	  memory attributes.
+
+	  If unsure, say N.
 
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
-	select KVM_VM_MEMORY_ATTRIBUTES
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
@@ -139,7 +146,6 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_POPULATE
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
@@ -163,7 +169,6 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
-	select KVM_VM_MEMORY_ATTRIBUTES
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	select HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf56cc892e7c..2226b4061bad 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 bool vm_memory_attributes = true;
+module_param(vm_memory_attributes, bool, 0444);
 #endif
 DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
-- 
2.53.0.rc1.225.gd81095ad13-goog


