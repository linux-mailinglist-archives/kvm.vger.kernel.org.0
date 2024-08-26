Return-Path: <kvm+bounces-25086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2297795FACF
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D8E1C20C4A
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED3319DF62;
	Mon, 26 Aug 2024 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlORUi7T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08A19D89D
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705053; cv=none; b=OYycL/zJlcqsmC+cExvAj26UAMZRETkf2uYCJLKsenvZ4Pr8RrXqO/LegovL2aWlWAG9fIQkFQaHHGCP1xigUhuINIG35pxaRfB6q9j14JJxHiSOrzvLtR+PXtdpX2o+BiE0LBXvi0VM8seQK9g6xdfu78MXBCF/DoM7j4SAcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705053; c=relaxed/simple;
	bh=0JOvh9d6Ck9MlI1IecLNRwn4z9Son10cjOiVCsL6GIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAXVa5WNFnJgD3NoEMuuVgeQpn+cYQTpmhpT3kKaAIolnxglOjnqkf9M1Sh6IvpyQPKFjbchLGC/tthJAYrkYY1L20Qu0TLb7QsqskEZshiGU1J3R4KBJjLU/CTJdY5O4fCmRmZnnv7vnP3R51p4Efr5uTyDaECS53JUQTN4Kdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlORUi7T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaLXo2idJup/Oy4OwRPy2aK364ayUQ63MrUET5wBpvQ=;
	b=WlORUi7T0GKEw0Z+Bsp2hqnlPrQ8BrVlWB8Z/I0dj7H1ijrvKlOSPg/nR8SpEiCphyDV2M
	nV4LZlZ4N5F0CcYttpgMjUxqONZ/0iDJN4BZmAp38p3GqzhnCHRPTwLhi3thr4i6BBIR8B
	5sGjT/GMJWi9ON1SjQdIw7dFPBB6k+I=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-4r5Ox5mmMumN5XhKyMo6zA-1; Mon, 26 Aug 2024 16:44:09 -0400
X-MC-Unique: 4r5Ox5mmMumN5XhKyMo6zA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1df704ef8so599548885a.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705049; x=1725309849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaLXo2idJup/Oy4OwRPy2aK364ayUQ63MrUET5wBpvQ=;
        b=T7dupp4l2PSeQ5MN8oAuih+y8z2B3VGOSit/6cWhZTuqodt/PnTwGm1LwXrhZDmLhC
         5U5bMqYjsX8YCxk8wQxAIfkNIIgkKAnCWdMUo8H1sqYEiE6ZO6X8JUgZ2XCi90ypm8Yk
         viyd9HUkpr2D4uWJa7LRg549pVin0cQHfHiM7ixmqYyzHQS/5tLs7i/LtZFOHHQ6Qdb2
         0dbZcVrZWWYcASVIqkNW2hvJ+XaAILmExVsn4C07aBKepAJCWX8ppARMEMzV4WLWxGe4
         L7PhjzVzOOspudfP0SwATYfOXQnuMGn5kt18V2eaiBrs+0/yJadCq9dbQ1pbtbUa2GQ+
         zCLw==
X-Forwarded-Encrypted: i=1; AJvYcCWsaTDuiLWtw7gNXiX7VoAgftiGOZXzcmlmo9Bq/XXc3VoHig+3VM2rfjzem4q6UvuwSJI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGyUGpuGnFAsVNJFkh1WYKdFoUiEui08m1bRElYXqmOyWoLepx
	lKwlejh2thfjiTiP05POowCYSU+87qE+B3FcC859gQSRfZ55TKruqSMxTlWbxCJTGafUIjsJmqa
	chS9H/M1TnItZVsAeDd/T5gg0yRtAm0qrcg46OPEJFOb5Uec8mw==
X-Received: by 2002:a05:620a:4112:b0:7a3:49dc:e6e3 with SMTP id af79cd13be357-7a6897a6f65mr1244452485a.53.1724705048904;
        Mon, 26 Aug 2024 13:44:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAEqST5igJBEO0jhxDT4OAwN3xGv5rzMyL4N+pVFoujxFDEyZ/hbdQR2zB1kD+DQ4JLF652A==
X-Received: by 2002:a05:620a:4112:b0:7a3:49dc:e6e3 with SMTP id af79cd13be357-7a6897a6f65mr1244449385a.53.1724705048557;
        Mon, 26 Aug 2024 13:44:08 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:44:07 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Date: Mon, 26 Aug 2024 16:43:40 -0400
Message-ID: <20240826204353.2228736-7-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Teach folio_walk_start() to recognize special pmd/pud mappings, and fail
them properly as it means there's no folio backing them.

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/pagewalk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index cd79fb3b89e5..12be5222d70e 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -753,7 +753,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pudp = pudp;
 		fw->pud = pud;
 
-		if (!pud_present(pud) || pud_devmap(pud)) {
+		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
 		} else if (!pud_leaf(pud)) {
@@ -783,7 +783,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pmdp = pmdp;
 		fw->pmd = pmd;
 
-		if (pmd_none(pmd)) {
+		if (pmd_none(pmd) || pmd_special(pmd)) {
 			spin_unlock(ptl);
 			goto not_found;
 		} else if (!pmd_leaf(pmd)) {
-- 
2.45.0


