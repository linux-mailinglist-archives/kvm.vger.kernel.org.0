Return-Path: <kvm+bounces-24642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A02295880F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45C561C20BBD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85DCD190462;
	Tue, 20 Aug 2024 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XJ4mfzZH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3755118FDD0
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724161006; cv=none; b=qjb814YlUEZjAdEBPO351j/3Jt3b8m34wx1lP28m3nih/TTjfruS8TC9QN/eCq5+K1JzTEXy3S+tW6ylCu9/aZtu3waoG6Q3rHCCXQn/8H2YAy+s/K+d+uJDh42s6ID4LO+zU9Cg2fP+KNcqCojnyZXt8W1dSzTFwExAx0JVKY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724161006; c=relaxed/simple;
	bh=3tgpbVJg3upkWR9TtfZAXyXRS9z5yGT8vUvSs2SIXZ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbbzYh9U/ilaeBRqwNOSholFULIHENYhYhWQ8+O0Ko9kW9cf0cAaRARpZwYcp0kYzNJhZSDRTTV4KnW+rov57R/dtALgqu/BFWKYlS5hj5TVLjFUlgTg8371WkV8i0uO0kAm426AEd6xH8+a/CXgw6iudBshTk92q8nbs9+mvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XJ4mfzZH; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724161005; x=1755697005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s6CYa/JwNx9eNjz8m6bzIpujdl+anAGEZZuMJM21PyI=;
  b=XJ4mfzZHwdqcyiHgChdtHazIX1zdcgNs0GXx0ivkrvzTe5sR2JCNuQuP
   9x/O03o6D7I2CnTsAJ5eNTCEbfP+SqVXrjU5pGFphNMiJ/5qLxMrx8zR0
   Xf/0vGdg6EPzs1Aa2Qs5lSxiWVX3RM5MjsKN4XhxURK6JrJSKQF+QKjTz
   Y=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="117201359"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:36:44 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:47704]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.8.165:2525] with esmtp (Farcaster)
 id df722463-bb18-42ef-baae-5d6705e793b8; Tue, 20 Aug 2024 13:36:43 +0000 (UTC)
X-Farcaster-Flow-ID: df722463-bb18-42ef-baae-5d6705e793b8
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:43 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:39 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>, Paul Durrant
	<paul@xen.org>
Subject: [PATCH v3 5/6] KVM: Documentation: Document v2 of coalesced MMIO API
Date: Tue, 20 Aug 2024 14:33:32 +0100
Message-ID: <20240820133333.1724191-6-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820133333.1724191-1-ilstam@amazon.com>
References: <20240820133333.1724191-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

Document the KVM_CREATE_COALESCED_MMIO_BUFFER and
KVM_REGISTER_COALESCED_MMIO2 ioctls.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 Documentation/virt/kvm/api.rst | 91 ++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b4d1cf2e4628..0b3ca05e380a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4922,6 +4922,8 @@ For the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 :Parameters: struct kvm_coalesced_mmio_zone
 :Returns: 0 on success, < 0 on error
 
+KVM_(UN)REGISTER_COALESCED_MMIO2 can be used instead if available.
+
 Coalesced I/O is a performance optimization that defers hardware
 register write emulation so that userspace exits are avoided.  It is
 typically used to reduce the overhead of emulating frequently accessed
@@ -6427,6 +6429,95 @@ the capability to be present.
 
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


