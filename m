Return-Path: <kvm+bounces-21289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7297892CDB5
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27951281DFF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B11317E910;
	Wed, 10 Jul 2024 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QV9wJQ+N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7790917E902
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601824; cv=none; b=UPCTzlSDZYZQ3wvW3KkZzbe57BlWTbhRYnOD01XPcXJ1m2iFobW38YYOwfwzTqJxR6s7C2Hjtlgm8MfnGrEUTtZTDN7fCV5kFvfwiMwOoZ+zMpYFGTUQpQSGl6SHMXsAsBeRHedce7szHPqBfZ95+bbkpL77krh9XSkduqUHiM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601824; c=relaxed/simple;
	bh=q5m9uBzKOosJMjy/0qA1tSy4vAXuR+VSAp2IWOvgRek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3ESA9M88tDyp9sUeXqlhMxKJPCNjUQmPDEMHTPu/j0pctXHzeaVIZGrqWkK59RdpktXRuFkl6dqsGZ0ZIwLjDHawRtKB51AUsH1WS/6nXOb9GsEEDRZNFF+Nhi5nDU/s6joG2nPXli814dVNmFUpJgX0yaEKS9cXsgB+B7kbdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=QV9wJQ+N; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720601822; x=1752137822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y29dI1FLgJ8e1P/Z82NcJYc39l8J0EY6oax+UZ24hRQ=;
  b=QV9wJQ+Np1Q59aW5fKCEIj6+X7c1D/jwRhUkF8ajR4jbRIYKZD8JGnPW
   4osAyAxP4PCgvpaHjjoVtlVJcbkPHbuyGeOYgDn/nxw/eP3o29jzES/4s
   M0i2d8woVEVPwFb2oVwLXrGeKXQRWKbX/6m31ueMc9IB9NL1bl/3Ub1HT
   0=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="10819737"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:56:58 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:17242]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.42.47:2525] with esmtp (Farcaster)
 id bf845b6e-3305-425d-9f6d-ca8a032a55ec; Wed, 10 Jul 2024 08:56:57 +0000 (UTC)
X-Farcaster-Flow-ID: bf845b6e-3305-425d-9f6d-ca8a032a55ec
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:57 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.83.14) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:56:52 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>,
	<ghaskins@novell.com>, <avi@redhat.com>, <mst@redhat.com>,
	<levinsasha928@gmail.com>, <peng.hao2@zte.com.cn>,
	<nh-open-source@amazon.com>
Subject: [PATCH 5/6] KVM: Documentation: Document v2 of coalesced MMIO API
Date: Wed, 10 Jul 2024 09:52:58 +0100
Message-ID: <20240710085259.2125131-6-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240710085259.2125131-1-ilstam@amazon.com>
References: <20240710085259.2125131-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

Document the KVM_CREATE_COALESCED_MMIO_BUFFER and
KVM_REGISTER_COALESCED_MMIO2 ioctls.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 Documentation/virt/kvm/api.rst | 91 ++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..e91c3cae3621 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4913,6 +4913,8 @@ For the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 :Parameters: struct kvm_coalesced_mmio_zone
 :Returns: 0 on success, < 0 on error
 
+KVM_(UN)REGISTER_COALESCED_MMIO2 can be used instead if available.
+
 Coalesced I/O is a performance optimization that defers hardware
 register write emulation so that userspace exits are avoided.  It is
 typically used to reduce the overhead of emulating frequently accessed
@@ -6352,6 +6354,95 @@ a single guest_memfd file, but the bound ranges must not overlap).
 
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
+4.143 KVM_CREATE_COALESCED_MMIO_BUFFER
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
+same ring buffer.
+
+poll() is also supported on the fd so that userspace can be notified of I/O
+writes without having to wait until the next exit to userspace.
+
+4.144 KVM_(UN)REGISTER_COALESCED_MMIO2
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
+
 5. The kvm_run structure
 ========================
 
-- 
2.34.1


