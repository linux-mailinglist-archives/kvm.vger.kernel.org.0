Return-Path: <kvm+bounces-73280-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLTtMnStrmntHQIAu9opvQ
	(envelope-from <kvm+bounces-73280-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:22:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36541237DB3
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 12:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56F233080F95
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 11:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B944739A7FA;
	Mon,  9 Mar 2026 11:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYkoQYw2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69939B94C;
	Mon,  9 Mar 2026 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773055048; cv=none; b=cw+wWhERnvAXmhT2YfbfzVKoNnwvsdxNT777YVOludNIldzYaZ1k3ULsqJYPCDsAHsbjEcF+4tlQWjdZ/jxUAykgJTj/efgNI52rrbPRdv7Uokf9juPrSRaOV/dJQD2S9YpOUY9Lu/QyhS+Rqs4ZjToup2kRPixjeX4pRUvvEog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773055048; c=relaxed/simple;
	bh=SnmyFF1XhivWaff3cyVDTm+Im2RbOKLj8Y3ciYszN7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bbijGatOVSmhpI+oUqZ51fwaYT2PrA1jbBHHK7l9gv4005Q0ppPZ5+bqJAXitC9gIfJmO9xg+sx0P2LWBSK7ycc+x8mqNuoRdMGEvjDCsTYck9fH3T6RBUwnRD5swEYBZyapIvflte6hvQ292k+bvTovlTjGqKHonzj5ETG/6V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYkoQYw2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D09C4CEF7;
	Mon,  9 Mar 2026 11:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773055047;
	bh=SnmyFF1XhivWaff3cyVDTm+Im2RbOKLj8Y3ciYszN7k=;
	h=From:To:Cc:Subject:Date:From;
	b=FYkoQYw2zMbmsB5a4Zg6oMiB50D8VDqvzw9kxL2z1M/Dwv7enDYy+XRKOHOv8d7SQ
	 bQHHRrDxMt69JPyGtYisY29w43KqeS/lbMq21EbJ9BvGc08qu+Az5vsp/O+8eLxQS7
	 opT63/r5Gg7AgFbg3JZGNCUDbtgJRiBRzB6SdbgOQNXlEEMfpN+BuzSBcx61ZHj0Hn
	 qZ3fyDi6yexUItC3vJg8qVafYeQPp2rUk89JqpQ4zW9BRQRwmrfEMXO+8GDG6QtMkV
	 NFZ7Fwegjhy3om6p0e68TJR0ppMj7SJ8aYX9dKS9/zd3yfOsf0BZXXcVWdPjBt724i
	 3i4QrqNmeKGoQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v2 0/3] Add iommufd ioctls to support TSM operations
Date: Mon,  9 Mar 2026 16:47:01 +0530
Message-ID: <20260309111704.2330479-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36541237DB3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73280-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.989];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

This patch series adds iommufd ioctl support for TSM-related operations.
These ioctls allow VMMs to perform TSM management tasks such as bind/unbind
operations and handling guest requests.

This series is posted separately in v2. The v1 posting is available at:
https://lore.kernel.org/all/20250728135216.48084-8-aneesh.kumar@kernel.org

Changes from v1:
* Rebased onto the latest kernel
* Addressed review feedback
* Dropped the TSM map ioctl; the KVM prefault patch will be used instead to
  ensure private memory is preallocated

Aneesh Kumar K.V (Arm) (3):
  iommufd/viommu: Allow associating a KVM VM fd with a vIOMMU
  iommufd/tsm: add vdevice TSM bind/unbind ioctl
  iommufd/vdevice: add TSM guest request ioctl

 drivers/iommu/iommufd/Makefile          |   2 +
 drivers/iommu/iommufd/iommufd_private.h |  15 ++++
 drivers/iommu/iommufd/main.c            |   6 ++
 drivers/iommu/iommufd/tsm.c             | 115 ++++++++++++++++++++++++
 drivers/iommu/iommufd/viommu.c          |  57 +++++++++++-
 drivers/virt/coco/tsm-core.c            |  33 +++++++
 include/linux/iommufd.h                 |   3 +
 include/linux/tsm.h                     |  44 +++++++++
 include/uapi/linux/iommufd.h            |  54 ++++++++++-
 virt/kvm/kvm_main.c                     |   2 +-
 10 files changed, 328 insertions(+), 3 deletions(-)
 create mode 100644 drivers/iommu/iommufd/tsm.c

-- 
2.43.0


