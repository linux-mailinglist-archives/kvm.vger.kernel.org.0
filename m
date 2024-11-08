Return-Path: <kvm+bounces-31286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 267B39C2112
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE989286710
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DAC21B457;
	Fri,  8 Nov 2024 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlgxW4hi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136321A71B
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081071; cv=none; b=V/NXkI0rI+MxtgMkGb9ZM21dTXqiJ/vrabmEuyzGOHTzBepNUw6rG8T1ZWjgjmJrA1Bg6j1gKkbReE2X9C77hjJCxbuhE2O/8VSjxsfx3vH64HPRMVYQGuy/aJxEOiF400pAjubdvyq4uTjb1ooe615M2NsD2S4VqymBXiKW3cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081071; c=relaxed/simple;
	bh=Q/uJy8ntqnUW2y4y1sductKww9jPTyNRE39sVzcOyAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LSJkclSwc/IbgMWNoMG10P1n2j0vm2W7dsCRHs0mSqyehIknO/CSiV28YJvCJv5R+xD3UdTlc/Nnz7PTe5DugiUOIvoOQUrx/DPwDhcgXszZOCTckd5uJhQVpfJeIK6hrMNU21b28muvTFCJJ9+EH4AKF3+q+VBZVGK+JBjQbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlgxW4hi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731081067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZOAytq2CgWGfFFI0mwebhZNB2xc89M/Ks4aDIYHx/gg=;
	b=HlgxW4hiz4HzkypqrAZlQwrYlNdhMsX8WvM/5/fOoZHFg+lasect+jxr2+BHPXT+eqzCKA
	qRGblEARE4Iu8912yN9ta7KEgLv4zfQJuNcftcHrkLhO7a4SHfNtuZ8i3HyRruI1ZKmMDq
	OZpp2b5vsZYMGQ3Nl7HuAVpfjMdxMYM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-GCzGPZBqOUWAw8DZk6m29Q-1; Fri,
 08 Nov 2024 10:51:04 -0500
X-MC-Unique: GCzGPZBqOUWAw8DZk6m29Q-1
X-Mimecast-MFC-AGG-ID: GCzGPZBqOUWAw8DZk6m29Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C7FC1956046;
	Fri,  8 Nov 2024 15:51:03 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 676E1300019E;
	Fri,  8 Nov 2024 15:51:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH 0/3] KVM: gmem: track preparedness a page at a time
Date: Fri,  8 Nov 2024 10:50:53 -0500
Message-ID: <20241108155056.332412-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

With support for large pages in gmem, it may happen that part of the gmem
is mapped with large pages and part with 4k pages.  For example, if a
conversion happens on a small region within a large page, the large
page has to be smashed into small pages even if backed by a large folio.
Each of the small pages will have its own state of preparedness,
which makes it harder to use the uptodate flag for preparedness.

Just switch to a bitmap in the inode's i_private data.  This is
a stupidly large amount of code; first because we need to add back
a gmem filesystem just in order to plug in custom inode operations,
second because bitmap operations have to be atomic.  Apart from
that, it's not too hard.

Please review!

Paolo

Paolo Bonzini (3):
  KVM: gmem: allocate private data for the gmem inode
  KVM: gmem: adjust functions to query preparedness state
  KVM: gmem: track preparedness a page at a time

 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 243 ++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   8 +-
 4 files changed, 237 insertions(+), 22 deletions(-)

-- 
2.43.5


