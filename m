Return-Path: <kvm+bounces-23713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBEC94D43C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 051A01F229CE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB6F19A295;
	Fri,  9 Aug 2024 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezHs7ZOz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B646D199397
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219771; cv=none; b=MDyfA06RBztWh5zTkEaRNzAUAWd6Ndip6cl6NBOC96Ok28ndI42xeu0RlGS2h9mDWfKAeTR8MYjD8IqEXyr1ndahP0vbDvEbJviyqb9pR8I2VrEl/NNp3obcU2NmWrNOTAqMIa/AZZpNucYAP4zx9vFI6qZ4AY47W9UUO9Q5SAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219771; c=relaxed/simple;
	bh=C1EqeOtQk0O3VuTVuRQD9+bF0J9qW0lfyAutjUQ5RI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KknRFRTnsIKKt/4HPKm+0vfhPxS368mORNZOs7YN3Xij7jY/ZZjLbJyowyJdT/3pY1Tpf0tENy1TogcSkegZDDoEYFix85hCD4nP9QD+boimMWVGHAUVYcFUPTr7aY2+O52vMEyVs6Xq7qzRirHm8eg0xfCRY0QnSoRRsBYiZX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezHs7ZOz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfMsI243pXvbDIYk3LIHdKnZKRp0h0WHhTX8nwPWLTI=;
	b=ezHs7ZOzlrsJ1+uPUfu+/Kur2CwuLGgYAIIB5Vig/qzGZQqkB5tx9BLzBY7+OokfCdnKIc
	rBWMX5UZQ3Hs98PeSB1xqWqDJB8IwJUQKneQpgYwjr0JHqUBTZMUrotd4bBZaBqKpPabA0
	G+LCFTSf3Mn7Ukl0sJCUMvcM/uMDJiU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-fXLsxlGEN36qijpgpyqcXg-1; Fri, 09 Aug 2024 12:09:27 -0400
X-MC-Unique: fXLsxlGEN36qijpgpyqcXg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44fe28cd027so3757821cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219767; x=1723824567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bfMsI243pXvbDIYk3LIHdKnZKRp0h0WHhTX8nwPWLTI=;
        b=klxhpXo0BfzR4yK79mI7NU46DSh9hCajeJPuaNi91zV7wasLNnMUHwA79h62BZRThx
         NhDPLGNsw2ZoSFdLOskxs92UE4HMiZilr8jgwfVkRIoTn6RL6P7L7hCgHWrPR8O7HqXc
         th0ikQzEa6KkMDjvF1cc3CHkNPTcuKTfr41wbvFWRGU9uFZs9j8FqyosPN++A5VzrbOe
         Xlwzd/0c24UmalSAH192GFyIyi6W1Wv+vdzo4oj4FQMPePnj5+HnxcaB0Gahvhv9WbJL
         0/HFOtjxr23HOJChz9Q9bfHsr3VBrY30F+JOGnUWGhLy3F+enk8PbCCyEBC9WJi5GXD8
         L+fw==
X-Forwarded-Encrypted: i=1; AJvYcCX/g5faVvR9wm9FuEE+UFHMBPd3RsMY1ptVWr3FGyCzavnuGW28G+/iU4bAuMvACngE+3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuyrQ3DT9TPFihW2Y1Q1nJAVSTFmDwWMxdX+JuyBwXetX3KrXi
	phGYY3vTIWpiwCsg0SKetCFwTyGMifevmBF/PCHY/Yb981U7Hjq9JY8+3vWGAYtHXOJpYKr1o7i
	bf4azrdlfipElplAWys73SWe0GffY4cD5n0Hc6qpTy14ceDDIIw==
X-Received: by 2002:ac8:59cc:0:b0:44f:c953:290d with SMTP id d75a77b69052e-4531251d17bmr12886141cf.2.1723219766852;
        Fri, 09 Aug 2024 09:09:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElkbLJ8q6bD88BtBGZOYKdaksYNPrmA3JWwjtOEQ9+GQ5ZX+OpUCG/V8WuVaLDdrJFvk6CQQ==
X-Received: by 2002:ac8:59cc:0:b0:44f:c953:290d with SMTP id d75a77b69052e-4531251d17bmr12885751cf.2.1723219766412;
        Fri, 09 Aug 2024 09:09:26 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:25 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 05/19] mm/gup: Detect huge pfnmap entries in gup-fast
Date: Fri,  9 Aug 2024 12:08:55 -0400
Message-ID: <20240809160909.1023470-6-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240809160909.1023470-1-peterx@redhat.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since gup-fast doesn't have the vma reference, teach it to detect such huge
pfnmaps by checking the special bit for pmd/pud too, just like ptes.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/gup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index d19884e097fd..a49f67a512ee 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3038,6 +3038,9 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pmd_special(orig))
+		return 0;
+
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
@@ -3082,6 +3085,9 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
+	if (pud_special(orig))
+		return 0;
+
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-- 
2.45.0


