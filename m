Return-Path: <kvm+bounces-59598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 476D9BC2D46
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C749C3AED45
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47B525F994;
	Tue,  7 Oct 2025 22:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNfUiqfu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C625A2BB
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875282; cv=none; b=PebtLCYvlc3vFM4hf2pSdI1ihSCFg8iFcNC+fOTvLDMYRl5Ey18vLmti7G88DspT9efpGs7qOR+DW/5Y7Y5Cdb771J7j9LSqBtvZ1u7tegvle7BM34TI3TMw18TvF6sYSRGCWGAKyLhN76h6J1z30BTliD6sF/xjWhSGBah02OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875282; c=relaxed/simple;
	bh=D88a6T3cHwEivrt11hcB7FfmUSn6F2rkXBumHlnlYb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nxr4rPHdrouZWtLKXg5A+CeLSxL33GKvPLfgrh9V57bKRdKDDYA1Q3JqNa4Zy0m0GWmmxu8ghG4YfmXoZmpv4S21NDMa+K7zxymrelpNkaN19ARH0/7n03S60zhbJg6Jvl2JBoPgCDoPfrbS1YFZCexRJLh8tksijmPWlxL6HKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNfUiqfu; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2697410e7f9so138501785ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875281; x=1760480081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5dmbXUVSLKd9bSlEnT0VG6XHvP3bFxOE7VRW3AC7JgU=;
        b=KNfUiqfuB58nFu9qPb2P7wotXj46X72vhz+mYAy7yez0izig2Jd2gIBwSP+1G+imcI
         80a6yPjWfCz11jgNha11Hhge8j9ABRCTL3tbq5YNNUG6ytsvtSANOqbCTBj6zK/hIbgE
         2vsRSBQkaprW9vkcJqF2Q6wn/gQ2wjWJ66aGErNtN4/8bSTvvdyaXVipJSs2WaS4kdA3
         wzZvF3q6zIW58SWnG+ry4sNKk2f9UnGQK+tMty2A2dPmLwWFZE1cEkzoLTvY16BrxQy3
         2FoaDWVB5sOScOH2gjzVcF7SGF3emRGev2Dvt3RStJl/7rEucq1Thkkr1Hy6Dlh4qHWT
         0T2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875281; x=1760480081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5dmbXUVSLKd9bSlEnT0VG6XHvP3bFxOE7VRW3AC7JgU=;
        b=SW3mVhgjdVAK+o5Slj3yhLYrEy1fJxFqiqvi2+imkEWqatZo9OOmFl0OSlLuA3F/BL
         fUXyXXegeXyIibVvYroNLgmDcZJ9rThfR6BumJbLLQx5BxBUYGl1MFMRDO5GxeLcgV8x
         4AbAT64QQ/2K4ViqvouXhXyzmo7aY4U0GIXp8WNVPfF8WYWtLM/aHbc/ThKflHNrAPaD
         t6ywVjNea38Xpb7hDB5YzgKgzmgaowDBYXML5si0RcW8agUWXyx39f9CDE3pbNKTW7VU
         T6UqbdZC74bCMhWkP3iNBikRP08fctekoUxEnRis9Mtq3kdLcl+SV9MqLykoocGA/iXY
         Pwaw==
X-Forwarded-Encrypted: i=1; AJvYcCXT8mDaCbjRbNnXZDRGvlDHg2jCdE8xrG1A8SUu5AdxtMFfXNIzfRCq2reBdGstOLL2HG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVd52ez41t/+3hOMteSDZV5lOXQNI/sNDUuV+DJ5uNmy+GVPex
	pGmHoD7HyGrul7JSqmSmctCIe1Ck8C4kdX7sHczz7EJmyO8QatbQaoSmOJ6zINwSugy0FGSE5Ov
	e7fCdag==
X-Google-Smtp-Source: AGHT+IFtELfPuC1E9Gi/gZ0IIwRTquQz/eR0bBtgh0yn3iXudV5xJa4KSH0/8AxoiBoCF/S9YIizGIBH2jI=
X-Received: from plow6.prod.google.com ([2002:a17:903:1b06:b0:290:28e2:ce51])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f602:b0:274:9dae:6a6d
 with SMTP id d9443c01a7336-290272c1a67mr16678315ad.34.1759875280674; Tue, 07
 Oct 2025 15:14:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:10 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-3-seanjc@google.com>
Subject: [PATCH v12 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
iterating over guest_memfd _files_, not guest_memfd instances, as could
be assumed given the name "gmem_list".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3c57fb42f12c..9b9e239b3073 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -22,6 +22,9 @@ struct gmem_file {
 	struct list_head entry;
 };
 
+#define kvm_gmem_for_each_file(f, mapping) \
+	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -159,13 +162,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	list_for_each_entry(f, gmem_list, entry)
+	kvm_gmem_for_each_file(f, inode->i_mapping)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
@@ -184,10 +186,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
 {
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	struct gmem_file *f;
 
-	list_for_each_entry(f, gmem_list, entry)
+	kvm_gmem_for_each_file(f, inode->i_mapping)
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
-- 
2.51.0.710.ga91ca5db03-goog


