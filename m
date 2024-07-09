Return-Path: <kvm+bounces-21190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 782E392BADB
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE55CB26EE8
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA81C15CD58;
	Tue,  9 Jul 2024 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="bEsxCxdN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A84A0A;
	Tue,  9 Jul 2024 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531262; cv=none; b=JyQEBHSRsBzMofe9rUspCMCIlOvc+Mg6ieKgA5jN6c99CrelfV/l+8iGYmWe+Ow1hTyhCgSLwl7ILuaKXz3KDns3W23bQawlTS1JfUXEA25mgM5TnTIzlFgv62J1Ph6kHhtZ6AG08x21wMLDV/XMZJe4VQNlYPgCWDcMntMO/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531262; c=relaxed/simple;
	bh=UJ4B+Q4x+Ego4l6SJ2nX8aLysQrcdIIiRMf9d2sbkio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDJzib2b409ivgk19cd/Osp+R2Er8P56AoIvydj/IOin5qIatooSsavnE2y8cnk4qqxi/Y9S/BwyFGZevp18DWGaX1J3OmI6mXjYaeCOVGIldM0zLfyJU0Wd9Gmx18srxde34d2hgZNysmxCsr5GEnoa0qFWpHhp/r1HzsEREr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=bEsxCxdN; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531260; x=1752067260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=myefINasqoLP8LFmYmmDEFb4CuSNvTYNmrkp8V5RNNQ=;
  b=bEsxCxdN3ru94aKZb0/1q4Gst3DjyxBRIiFbG8KuVk28wAnM/z/Xpc9s
   WRlKtr2wazKJVhx5mHreB1pfy2RkrhEmP1VU1iNKLU6wIwVOL5FOontin
   1XSKRl2kDsQ+Za/E9B8ZDSBLejoVfWuuusJRbh4twHSnA8Yid6P5Mu4ja
   0=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="217222124"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:20:58 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.0.204:19435]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.13.24:2525] with esmtp (Farcaster)
 id 18a4efc4-1b3b-4e58-98d8-17e4bb420299; Tue, 9 Jul 2024 13:20:57 +0000 (UTC)
X-Farcaster-Flow-ID: 18a4efc4-1b3b-4e58-98d8-17e4bb420299
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:20:57 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:20:56 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:20:54 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 1/8] kvm: Allow reading/writing gmem using kvm_{read,write}_guest
Date: Tue, 9 Jul 2024 14:20:29 +0100
Message-ID: <20240709132041.3625501-2-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709132041.3625501-1-roypat@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

If KVM can access guest-private memory without causing a host-kernel
panic (e.g. currently only if the vm type is KVM_SW_PROTECTED_VM), allow
`kvm_{read,write}_guest` to access gfns that are set to "private".  If
KVM cannot access guest-private memory (say, because it is running a TDX
VM), prepare a KVM_EXIT_MEMORY_FAULT (if possible) and return -EFAULT.

KVM can only prepare the memory fault exit inside the
`kvm_vcpu_{read,write}_guest` variant, as it needs a vcpu reference to
assign the exit reason to.

KVM accesses guest-private memory via kernel virtual addresses/the
direct map. In the special case of guest_memfd, it does not have to
worry about gfn->pfn mappings being invalidated, since guest_memfd pages
are immovable.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_host.h |  5 +++
 virt/kvm/kvm_main.c      | 85 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2a6679b46427..8f980aafd5ca 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2407,6 +2407,11 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_can_access_gmem(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c7cbc9ec9ee..b3b3de70a4df 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3286,11 +3286,51 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 	return 0;
 }
 
+static int __kvm_read_guest_private_page(struct kvm *kvm,
+					 struct kvm_memory_slot *memslot, gfn_t gfn,
+					 void *data, int offset, int len)
+{
+	kvm_pfn_t pfn;
+	int r;
+	struct page *page;
+	void *kaddr;
+
+	if (!kvm_can_access_gmem(kvm))
+		return -EFAULT;
+
+	r = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL);
+
+	if (r < 0)
+		return -EFAULT;
+
+	page = pfn_to_page(pfn);
+	lock_page(page);
+	kaddr = page_address(page) + offset;
+	memcpy(data, kaddr, len);
+	unlock_page(page);
+	put_page(page);
+	return 0;
+}
+
+static int __kvm_vcpu_read_guest_private_page(struct kvm_vcpu *vcpu,
+					       struct kvm_memory_slot *memslot, gfn_t gfn,
+					       void *data, int offset, int len)
+{
+	if (!kvm_can_access_gmem(vcpu->kvm)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn + offset, len, false,
+					      false, true);
+		return -EFAULT;
+	}
+	return __kvm_read_guest_private_page(vcpu->kvm, memslot, gfn, data, offset, len);
+}
+
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
+	if (kvm_mem_is_private(kvm, gfn))
+		return __kvm_read_guest_private_page(kvm, slot, gfn, data, offset, len);
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
@@ -3300,6 +3340,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
+	if (kvm_mem_is_private(vcpu->kvm, gfn))
+		return __kvm_vcpu_read_guest_private_page(vcpu, slot, gfn, data, offset, len);
 	return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
@@ -3390,11 +3432,52 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	return 0;
 }
 
+static int __kvm_write_guest_private_page(struct kvm *kvm,
+					  struct kvm_memory_slot *memslot, gfn_t gfn,
+					  const void *data, int offset, int len)
+{
+	kvm_pfn_t pfn;
+	int r;
+	struct page *page;
+	void *kaddr;
+
+	if (!kvm_can_access_gmem(kvm))
+		return -EFAULT;
+
+	r = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL);
+
+	if (r < 0)
+		return -EFAULT;
+
+	page = pfn_to_page(pfn);
+	lock_page(page);
+	kaddr = page_address(page) + offset;
+	memcpy(kaddr, data, len);
+	unlock_page(page);
+	put_page(page);
+
+	return 0;
+}
+
+static int __kvm_vcpu_write_guest_private_page(struct kvm_vcpu *vcpu,
+					       struct kvm_memory_slot *memslot, gfn_t gfn,
+					       const void *data, int offset, int len)
+{
+	if (!kvm_can_access_gmem(vcpu->kvm)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn + offset, len, true,
+					      false, true);
+		return -EFAULT;
+	}
+	return __kvm_write_guest_private_page(vcpu->kvm, memslot, gfn, data, offset, len);
+}
+
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 			 const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
+	if (kvm_mem_is_private(kvm, gfn))
+		return __kvm_write_guest_private_page(kvm, slot, gfn, data, offset, len);
 	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
@@ -3404,6 +3487,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
+	if (kvm_mem_is_private(vcpu->kvm, gfn))
+		return __kvm_vcpu_write_guest_private_page(vcpu, slot, gfn, data, offset, len);
 	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);

base-commit: 771df9ffadb8204e61d3e98f36c5067102aab78f
-- 
2.45.2


