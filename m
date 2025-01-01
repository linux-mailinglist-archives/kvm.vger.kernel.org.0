Return-Path: <kvm+bounces-34441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2529FF351
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 08:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2763A1A65
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 07:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7382746A;
	Wed,  1 Jan 2025 07:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2PLpupF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8239474BE1
	for <kvm@vger.kernel.org>; Wed,  1 Jan 2025 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735717809; cv=none; b=nrcOv8Azz6dUFCqVSzDtpYqZWJSrCySx8RN/9o7v++bM5x9T0l5nieOb2O653Qm/fbmEvKUNykooDTD/4uqGyg0QKShfm/zhvQGMkaa484c1wphLB0Zud8HukPBLsFcBDQwBy4VaJM4NBtrWLjCjpdeeGEszHgfTQF7nXOspsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735717809; c=relaxed/simple;
	bh=Hm5hGc3w9PLJNaug3Hs3WiAMry+Yq/o78VwtmLZdTXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VvaFvtEkh5VaYLv78rhngK7SBPb7pmAMgEvNR12oBWlFeCzVTJGXUAJRTXajM4WCcxWsHLbDYv0uipNS3ZB+W1Op+ogLVtFFnfDkIR0Sz7gkb9ecezPxpLUZNomVzTmjsTxwzUoTifvVXMgqiANbyk/fFO18apEkWQTh5pASdU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2PLpupF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735717806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QuXJfuR4M/Vz0LFQTf2it8PRbZ7VK8wqMOOGRb8Oa6I=;
	b=R2PLpupFBJT8YhDCPRcErVi4G1Jz/jHzDWj3O15AyXGsdZi4B+NVhLfcQp+X1NP74unfKA
	got54hOgkEnifUob8U9l9C+AKFYjR83TKYNrwHqt6v6/NUDb7YAdatYfI06xpkcOC9syqY
	YceSYw8WGI8ph4iXka1NaDBvhWGvsMc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-OR8eH_i-OAqH0-XNfWQcnw-1; Wed,
 01 Jan 2025 02:50:03 -0500
X-MC-Unique: OR8eH_i-OAqH0-XNfWQcnw-1
X-Mimecast-MFC-AGG-ID: OR8eH_i-OAqH0-XNfWQcnw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFCA919560A3;
	Wed,  1 Jan 2025 07:50:01 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B7191956052;
	Wed,  1 Jan 2025 07:50:00 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v2 00/13] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Date: Wed,  1 Jan 2025 02:49:46 -0500
Message-ID: <20250101074959.412696-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This is a completed version of Rick's RFC series at
https://lore.kernel.org/r/20241203010317.827803-1-rick.p.edgecombe@intel.com/.
Due to EPANETTONE I didn't use the latest RFC, which is fixed here.

As in the patches that I sent ten minutes ago, I took all the "Add
SEAMCALL wrappers" patches from the various TDX parts and placed them
in a single series, so that they can be reviewed and provided in a topic
branch by Dave.

I will rebase kvm-coco-queue on top of these, but I almost definitely
will not manage to finish and push the result before getting the first
NMIs from the rest of the family.  In the meanwhile, this gives people
time to review while I'm not available.

Paolo

Isaku Yamahata (6):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_sept_add() to add SEPT
    pages
  x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages
  x86/virt/tdx: Add SEAMCALL wrappers to manage TDX TLB tracking
  x86/virt/tdx: Add SEAMCALL wrappers to remove a TD private page
  x86/virt/tdx: Add SEAMCALL wrappers for TD measurement of initial
    contents
  x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX
    guest KeyID

Kai Huang (1):
  x86/virt/tdx: Read essential global metadata for KVM

Rick Edgecombe (6):
  x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX TD creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX vCPU creation
  x86/virt/tdx: Add SEAMCALL wrappers for TDX page cache management
  x86/virt/tdx: Add SEAMCALL wrappers for TDX VM/vCPU field access
  x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations

Yuan Yao (1):
  [WORKAROUND] x86/virt/tdx: Retry seamcall when TDX_OPERAND_BUSY with
    operand SEPT

 arch/x86/include/asm/tdx.h                  |  50 +++
 arch/x86/virt/vmx/tdx/tdx.c                 | 432 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                 |  46 ++-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  50 +++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.h |  19 +
 5 files changed, 590 insertions(+), 7 deletions(-)

-- 
2.43.5


