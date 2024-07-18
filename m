Return-Path: <kvm+bounces-21871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40656935234
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEB98B21EAE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43610145A09;
	Thu, 18 Jul 2024 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="j3VMF+bp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7F71459EE
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331514; cv=none; b=Ooy0wUykXwI9bsl+H5yjuDDhQ19mpwYZLuGx74WOvbBM+EmPWOFdjrX6EVLAim5olj1tn6IJuBFGZYX+Fg7a+XUadCnv0S+uNivlU9k/kG9LmLsPV43wQH+amVgxBmmtOpHrPsVjr+IOoD1lWI99xXIneRjUNFKlBP18eEkM+Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331514; c=relaxed/simple;
	bh=/7e22EXp8XVRzLR0KH2LciDe99HFOX8TknL+wWWEcG8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E04FJcADTMu7MdBdJgxCbSktn8MXhzkr+E3o2Rz23dyxr6p10B2h+bn/isv5HU/bwhOvgHlTjuQPgwWxxN2IK88Al8AIM3CUMT3GuLJL5q9HWqVGeXvSDGt5TJ1bJI8eFKC02TXmDiult4tTV5foRnJIBKEXGPVevAnfY395JYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=j3VMF+bp; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721331512; x=1752867512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T9lSCusNKYiz1ttl+BOUE+XmPPDtjkquSQIAT/PjGAY=;
  b=j3VMF+bpGedROpkBsO9lkSAoZWVdZ8d/DKYMhfoyqXY1TQki+eIbbiIR
   UUZxlMslMlcaaYWzT3DNaXPKgem40O0cEXX2Vnc5oqnaH7Jj164Cg6bip
   J2HANthKrgzsz+ZNy7nyhNiX/HgpRlxSH4uip8WOFcqzoGcaCibYFP+5y
   g=;
X-IronPort-AV: E=Sophos;i="6.09,218,1716249600"; 
   d="scan'208";a="107367720"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 19:38:32 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:2317]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.109:2525] with esmtp (Farcaster)
 id 2fedb4ac-ae0c-4014-aa5f-4968e0518b8b; Thu, 18 Jul 2024 19:38:30 +0000 (UTC)
X-Farcaster-Flow-ID: 2fedb4ac-ae0c-4014-aa5f-4968e0518b8b
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:38:30 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.17) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:38:26 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <nh-open-source@amazon.com>,
	Ilias Stamatis <ilstam@amazon.com>, Paul Durrant <paul@xen.org>
Subject: [PATCH v2 5/6] KVM: Documentation: Document v2 of coalesced MMIO API
Date: Thu, 18 Jul 2024 20:35:42 +0100
Message-ID: <20240718193543.624039-6-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718193543.624039-1-ilstam@amazon.com>
References: <20240718193543.624039-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

Document the KVM_CREATE_COALESCED_MMIO_BUFFER and
KVM_REGISTER_COALESCED_MMIO2 ioctls.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---

v1->v2:
  - Added a sentence explaining that closing the fd results in
    deregistering the associated regions.
  - Rebased on top of kvm/queue and updated the section numbers.

 Documentation/virt/kvm/api.rst | 91 ++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..bd47cf64595a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4919,6 +4919,8 @@ For the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 :Parameters: struct kvm_coalesced_mmio_zone
 :Returns: 0 on success, < 0 on error
 
+KVM_(UN)REGISTER_COALESCED_MMIO2 can be used instead if available.
+
 Coalesced I/O is a performance optimization that defers hardware
 register write emulation so that userspace exits are avoided.  It is
 typically used to reduce the overhead of emulating frequently accessed
@@ -6418,6 +6420,95 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_CREATE_COALESCED_MMIO_BUFFER
+-------------------------------------
+
+:Capability: KVM_CAP_COALESCED_MMIO2
+:Architectures: all
+:Type: vm ioctl
+:Parameters: none
+:Returns: An fd on success, < 0 on error
+
+Returns an fd, but does not allocate a buffer. Also see
+KVM_REGISTER_COALESCED_MMIO2.
+
+The fd must be first passed to mmap() to allocate a page to be used as a ring
+buffer that is shared between kernel and userspace. The page must be
+interpreted as a struct kvm_coalesced_mmio_ring.
+
+::
+
+  struct kvm_coalesced_mmio_ring {
+  	__u32 first, last;
+  	struct kvm_coalesced_mmio coalesced_mmio[];
+  };
+
+The kernel will increment the last index and userspace is expected to do the
+same with the first index after consuming entries. The upper bound of the
+coalesced_mmio array is defined as KVM_COALESCED_MMIO_MAX.
+
+::
+
+  struct kvm_coalesced_mmio {
+  	__u64 phys_addr;
+  	__u32 len;
+  	union {
+  		__u32 pad;
+  		__u32 pio;
+  	};
+  	__u8  data[8];
+  };
+
+After allocating a buffer with mmap(), the fd must be passed as an argument to
+KVM_REGISTER_COALESCED_MMIO2 to associate an I/O region to which writes are
+coalesced with the ring buffer. Multiple I/O regions can be associated with the
+same ring buffer. Closing the fd after unmapping it automatically deregisters
+all I/O regions associated with it.
+
+poll() is also supported on the fd so that userspace can be notified of I/O
+writes without having to wait until the next exit to userspace.
+
+4.145 KVM_(UN)REGISTER_COALESCED_MMIO2
+-------------------------------------
+
+:Capability: KVM_CAP_COALESCED_MMIO2
+:Architectures: all
+:Type: vm ioctl
+:Parameters: struct kvm_coalesced_mmio_zone2
+:Returns: 0 on success, < 0 on error
+
+Coalesced I/O is a performance optimization that defers hardware register write
+emulation so that userspace exits are avoided. It is typically used to reduce
+the overhead of emulating frequently accessed hardware registers.
+
+When a hardware register is configured for coalesced I/O, write accesses do not
+exit to userspace and their value is recorded in a ring buffer that is shared
+between kernel and userspace.
+
+::
+
+  struct kvm_coalesced_mmio_zone2 {
+  	__u64 addr;
+  	__u32 size;
+  	union {
+  		__u32 pad;
+  		__u32 pio;
+  	};
+  	int buffer_fd;
+  };
+
+KVM_CREATE_COALESCED_MMIO_BUFFER must be used to allocate a buffer fd which
+must be first mmaped before passed to KVM_REGISTER_COALESCED_MMIO2, otherwise
+the ioctl will fail.
+
+Coalesced I/O is used if one or more write accesses to a hardware register can
+be deferred until a read or a write to another hardware register on the same
+device. This last access will cause a vmexit and userspace will process
+accesses from the ring buffer before emulating it. That will avoid exiting to
+userspace on repeated writes.
+
+Alternatively, userspace can call poll() on the buffer fd if it wishes to be
+notified of new I/O writes that way.
 
 5. The kvm_run structure
 ========================
-- 
2.34.1


