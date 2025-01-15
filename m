Return-Path: <kvm+bounces-35562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BFBA1283D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:09:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97EB1163688
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E6118A6A8;
	Wed, 15 Jan 2025 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAOsXcT0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041EB137930
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957362; cv=none; b=RFcerA/vqtm9eD0M0NQC4L0P3Dg88l5D10YwYIObSts7R9HKbEAnxZyag4PjYdTWdcwhkfZlp9xDPrEXKH97ZTeBEjc8GHm894OqcAMEuAl8KQTSyMlzjdDxW3YW/SMhZnsLo+mpfJCS5lvwxvvIjFykW+k6snKUSZtN45b6NoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957362; c=relaxed/simple;
	bh=+MbYHRfyAaTnhq+tCSvtFqEqoz30FUB+zynw9XDj8bY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HLzrzcJKWig7lR29pg11BM8VySFhLyCjnuG7Yf8HHQ8QOQYuxLisJpQz4K6iR4ZwCWl/oqrOYERze66Hr7wjW5kHBvO9QJjdz9WPcMmDIgfbJrm3b0nMQ2BoFU0qQ7CWfLLe9mq7NdZtbtsqlmtUCajAPUxx81mnjI9RFPq7/Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAOsXcT0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736957359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=70iHeTbTiYRZmNEDijg38TUwGyDlMjyFEuoschqacCw=;
	b=LAOsXcT0DRqdl8q3eZZD17UPAUgdbuBfTUbKMdhfxTA/9jM9JMDim93kSfzlT696ffgmft
	5uE2xliIfVWaPgEk48ue7w95DarNJlhY4p9nPnOND22KEUkhXilkKmNgGBw5eivS6eU523
	NLb2NSODHdLeuZPRY7jAF//PxxoE1Bg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-eyNyO9cBOfqo5r0_e_hqfg-1; Wed,
 15 Jan 2025 11:09:16 -0500
X-MC-Unique: eyNyO9cBOfqo5r0_e_hqfg-1
X-Mimecast-MFC-AGG-ID: eyNyO9cBOfqo5r0_e_hqfg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E75AA195606B;
	Wed, 15 Jan 2025 16:09:14 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2BAC30001BE;
	Wed, 15 Jan 2025 16:09:13 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Date: Wed, 15 Jan 2025 11:08:58 -0500
Message-ID: <20250115160912.617654-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


Hi,

This is the final-ish version of the "SEAMCALL Wrappers" RFC[0], with
all the wrappers extracted out of the corresponding TDX patches.
This version of the series uses u64 only for guest physical addresses
and error return values:

* u64 pfn is replaced by struct page

* u64 level is replaced by int level

* u64 tdr and u64 tdvpr are replaced by structs that contain struct page
  for them as well as for tdcs and tdcx.

A couple functions are also moved over from KVM to tdx.h

static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
static inline int pg_level_to_tdx_sept_level(enum pg_level level)

The plan is to include these in kvm.git together with their first user.

Thanks,

Paolo

Isaku Yamahata (5):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
    pages
  x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
  x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
  x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
    contents
  x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX
    guest KeyID
  x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking

Kai Huang (1):
  x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest
  x86/virt/tdx: Read essential global metadata for KVM

Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

 arch/x86/include/asm/tdx.h                  |  68 ++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 403 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                 |  47 ++-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  50 +++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.h |  19 +
 5 files changed, 580 insertions(+), 7 deletions(-)

-- 
2.43.5


