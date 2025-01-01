Return-Path: <kvm+bounces-34429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C66A29FF337
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E13653A032B
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB62426289;
	Wed,  1 Jan 2025 07:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QT5Zivpa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0F518027
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735716655; cv=none; b=JXTXLjLjVtCsh32eJtAd17/VzyOQ0qJl3vv6P4rXkS+MIMFiIALlb9Ig/1YcVJVBqCq8FZKhwCtAXWcYEGMOwSpWInkCyae5nyVDf+ip4hszVpXETLzQ/Xzit2YoB+e9I/BV61Kd/tyEuC1g1AzWJsH3Y5CNwxnOGsqDfrDWadY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735716655; c=relaxed/simple;
	bh=wLm/fWj5usyI8I2l03ZqzH7nzYmkD3uYW9K/bKNwxe0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fxzUiudn1eonTQq8R8gcPbs9HtRbUluEdEnop5SM4M9jqTAholGl2ttkEiL64GBY/BP0Q/VBiCzwiYnhKVmGu6ASPwUoEimmCuEWdwqvFKGDnMicEQoz4kIsPRXd4WcqkW+eaDIR9HFK3AQmJe9TtmOSMUOI1io3EhXJM30h5Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QT5Zivpa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735716652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1Dz2fi77c+edfiNqNZRa4gt6Q6EsarDpaBvAZPsrQJ8=;
	b=QT5ZivpaNgASoEfUD6xzC94LceQCjSQaUgkAiC2x6CWKzdKqJef3ihX6KrLoZujQ/xpu9e
	owa6EsX8OE8ZM5ljxiE6BID+vdxMkPpowEeS4axhG8Vu8AzhYkiLZhMFFQeImK2d7Dnj1U
	b/rmg3WpG7GMvEnJDCNahZLTQdGAO5U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-zcmw1YctPN6IeUfX4NaI2g-1; Wed,
 01 Jan 2025 02:30:51 -0500
X-MC-Unique: zcmw1YctPN6IeUfX4NaI2g-1
X-Mimecast-MFC-AGG-ID: zcmw1YctPN6IeUfX4NaI2g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BDF21956086;
	Wed,  1 Jan 2025 07:30:49 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 30DAD19560AA;
	Wed,  1 Jan 2025 07:30:48 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH 00/11] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Date: Wed,  1 Jan 2025 02:30:36 -0500
Message-ID: <20250101073047.402099-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This is a completed version of Rick's RFC series at
https://lore.kernel.org/r/20241115202028.1585487-1-rick.p.edgecombe@intel.com/.

I took all the "Add SEAMCALL wrappers" patches from the various
TDX parts and placed them in a single series, so that they can be
reviewed and provided in a topic branch by Dave.

I will rebase kvm-coco-queue on top of these, but it's New Year's
Day and I only have a few minutes before turning off the computer
for good for a few days, so I'm not sure I will manage to push the
result.

In the meanwhile, this gives people time to review while I'm not
available.

Paolo

Isaku Yamahata (5):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
    pages
  x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
  x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
  x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
  x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
    contents

Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

 arch/x86/include/asm/tdx.h  |  38 ++++
 arch/x86/virt/vmx/tdx/tdx.c | 362 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  46 ++++-
 3 files changed, 439 insertions(+), 7 deletions(-)

-- 
2.43.5


