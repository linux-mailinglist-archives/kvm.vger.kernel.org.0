Return-Path: <kvm+bounces-31304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F17F29C2226
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 282831C2404C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FC7193075;
	Fri,  8 Nov 2024 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dg8ubsjH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F751BD9DB
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731083557; cv=none; b=BDYi4juGU0CWsqCMQK0f+d/cBJC7ag0EOJ1s2MkvPmiWYtu5GjUBpuXtBnZEdbwM1cz6c3tmJJ9cB8LM+uzhtcQUXxhzvnCGODqWC5kusTZ9lRmnnVqbBvcFn09GCaKDjOdCOCmFZ0nuYyARPlySww7cierIyAr0j/IjwWj4uJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731083557; c=relaxed/simple;
	bh=AnvrjaJy/vrLSe7sUgafShkk6/FA90lKRMl8dVnl0C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p28/ukZomfL2snARUkux94wJJ+gs0k6mP68OpWohOy7nfZ+jCPuW9nsVjR0qWnKdA0tJxG3kR+6WHfzDRAsfpjH0vWqOuUp60N64G2zC2TQ4JEFwwwR1IOteerdsSpd+xvUvLIB0drczRLsRpIeKl2cz52VMviwizMH2O9QXD+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dg8ubsjH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731083555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ARNxrMJwiTf6cTrp5WO9zitBzCD/zba3zIGWs6M4Po=;
	b=dg8ubsjHn3+fRx31BLvYCeb4G5ORk4f7+izxo9u7Zkww+zw1aqI6Ehe2/NoMJ3xpynh1G+
	+zYcDj5GTvo7UJc2XVkhgbpyxMRpnbHmXrZ5BeXVfwXLqDUqiEDE7cEQRwABvOLARr4KEh
	46spXf4hbBxWgWLFBHs2QA3QN3wdpO8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-lhtoJS2zPsC6jXKvUtR1zg-1; Fri,
 08 Nov 2024 11:32:31 -0500
X-MC-Unique: lhtoJS2zPsC6jXKvUtR1zg-1
X-Mimecast-MFC-AGG-ID: lhtoJS2zPsC6jXKvUtR1zg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F29A1955F41;
	Fri,  8 Nov 2024 16:32:30 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E95C195607C;
	Fri,  8 Nov 2024 16:32:29 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	seanjc@google.com
Subject: [PATCH 2.5/3] KVM: gmem: limit hole-punching to ranges within the file
Date: Fri,  8 Nov 2024 11:32:28 -0500
Message-ID: <20241108163228.374110-1-pbonzini@redhat.com>
In-Reply-To: <20241108155056.332412-1-pbonzini@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Do not pass out-of-bounds values to kvm_gmem_mark_range_unprepared().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

	Sent separately because I thought this was a bug also in the current
	code but, on closer look, it is fine because ksys_fallocate checks that
	there is no overflow.

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 412d49c6d491..7dc89ceef782 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -324,10 +324,17 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
+	loff_t size = i_size_read(inode);
+	pgoff_t start, end;
 	struct kvm_gmem *gmem;
 
+	if (offset > size)
+		return 0;
+
+	len = min(size - offset, len);
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
+
 	/*
 	 * Bindings must be stable across invalidation to ensure the start+end
 	 * are balanced.
-- 
2.43.5


