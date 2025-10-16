Return-Path: <kvm+bounces-60184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9278DBE4D94
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:31:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3259C4F98FB
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7330F221F12;
	Thu, 16 Oct 2025 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UhtDXPhv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BBE22D4C3
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635815; cv=none; b=RUT7fnr0mrIGF3nWhRbyaO0+Oro4dICX8oZEygAQqkBzurdPm885lke4yy1TeNXBEGIAO8GfejUiHjuyX1PC9KzEUPKmrATU7Z/e6WgrkERwpnQcAF9OZJIOuEE7Qbg4bOna18/YOkZKyQcKckT6lPdk1pn2VDNG4mbsSg0bTy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635815; c=relaxed/simple;
	bh=Ru4m8I7GXDakLu5/QZ8fZL1qLohr4A91qPbj1pId4+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8wff1FC7StdAW7cFblAD0wyxHE0iuot3Txd8llki/ArUMEFVR5v0zdk84XeUS7JGS6JmaagBjif3rNRWiGewMCQK0VbyZyELdvKsDzB6lbcHwk9kNf1Eom695wcY9ifYsxnKAlBv7cOOJwoWhNzQRlHIjxW2kJy4II1zS7bMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UhtDXPhv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso1200349a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635812; x=1761240612; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6tAVv6b9fRDhntp0ml3AD/e15cFGLUttzwV4nvdq0R8=;
        b=UhtDXPhvqA06ZRnLxi/Omu72OTZydcByyk/lkS+e3IZe+2vGiGtbWLpSI6TSeZ7+hs
         cV+wRgcjWqYHms/wMtNU64f6YGGfVk+IPtXUwJJkmK3JBU306jm7ktto4QIJ7pI5Ora8
         eh9mnZt4YEd8Gn9GMwNyR0XF0jM6VVJEK+LrotIfdhyLljVrVLPnRPJUgY6cc9CHl/Z7
         ZJS3n29kkbflp00g864+mk1pJ1MbfVP+8SVLoSmsldy2o+4eQoYM96Kr//vmldCv8Ykc
         0qlTnrzpYMdvNxae05ltqUEqZ6MZA7OGr5UOGdAG1BVtNX/fQL1ToGkF7sk+7vt3QVtc
         p3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635812; x=1761240612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6tAVv6b9fRDhntp0ml3AD/e15cFGLUttzwV4nvdq0R8=;
        b=lTf2GYKhYOY2F3zQ10h0J366w67H1AvPLLfyIIfH5B+73i4mPV/HOs8IEpRLuqhooM
         i63gZxFgvaUvEkdUs9U9/ebfWOkDudqvahwMrH2RK3V9rr+40af0UMeVKSiXqypZBfPG
         n/kS1yuGFbTJVLxjE7YJavG+ZDfr6ohtbjBU+i5l4lplY/SNgbtl/PJgE8Poii2UuuRp
         iLY69bV532QvZMHLC8WeBmnUNRB71GRketNUSYWLcBmyMokLUdlZE5AwzS9o7vSjdOIP
         OIZd9x3YlMw184GERSjGxljPJULBNBCvMrrIwB0Zv14O0uPGj34StH6Qld6MkUGlzxFG
         i4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWVG5t+Tt4VHMfau7XUhqiAvtGkosb0HiF6dL+BqBIRbwPyY4tjbMgM7WoBlV+m973COs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUlOkRTjmAPE378aCaYFHzhl4e1TcVQxu/VL2qN814SbXbWIcz
	yYpZ58MGFKO0rH07YaR6NAzmaR93FAVuXb+ZaL8K/gBOBcyyy5ucMAl3JPFC33OzBZ1RGk3rLqW
	4Cfmj9g==
X-Google-Smtp-Source: AGHT+IFiziQxx4vN6XNlZpR7uI1Y1WkivFjq8+/qZ9wHBFeEPxqCLQgsLYXVUg11kld4O3lt/m0fng8h7Tw=
X-Received: from pji6.prod.google.com ([2002:a17:90b:3fc6:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e43:b0:339:cece:a99
 with SMTP id 98e67ed59e1d1-33bcf86c699mr779489a91.13.1760635812664; Thu, 16
 Oct 2025 10:30:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:43 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-3-seanjc@google.com>
Subject: [PATCH v13 02/12] KVM: guest_memfd: Add macro to iterate over
 gmem_files for a mapping/inode
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Add a kvm_gmem_for_each_file() to make it more obvious that KVM is
iterating over guest_memfd _files_, not guest_memfd instances, as could
be assumed given the name "gmem_list".

No functional change intended.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .clang-format          | 1 +
 virt/kvm/guest_memfd.c | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/.clang-format b/.clang-format
index f371a13b4d19..220cda77a8f1 100644
--- a/.clang-format
+++ b/.clang-format
@@ -540,6 +540,7 @@ ForEachMacros:
   - 'kvm_for_each_memslot'
   - 'kvm_for_each_memslot_in_gfn_range'
   - 'kvm_for_each_vcpu'
+  - 'kvm_gmem_for_each_file'
   - 'libbpf_nla_for_each_attr'
   - 'list_for_each'
   - 'list_for_each_codec'
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2989c5fe426f..5cce20ff418d 100644
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
@@ -164,13 +167,12 @@ static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
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
 
@@ -189,10 +191,9 @@ static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
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
2.51.0.858.gf9c4a03a3a-goog


