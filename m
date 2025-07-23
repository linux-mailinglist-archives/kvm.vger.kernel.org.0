Return-Path: <kvm+bounces-53207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF817B0F068
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 863E47B8F55
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4B82E0925;
	Wed, 23 Jul 2025 10:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FrBsFoxK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB402DE702
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267648; cv=none; b=Eliu9Yu1n3kuvGdrCckcA++J9kBtWP4n7pAXW3s5FtDLMIKv9k9y/4zEeMjtOhwioVWOn7Iw6tqz1QqEFS3Wa557kGPoRy2H9LdgnOC9wmtjXzhMWLOUMggWtYunw5rLJnXKMcLqAIRULuoq/eme4SAJbJ67OE0kybob1H/VECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267648; c=relaxed/simple;
	bh=X2UnKEstGo4dvjCoZ5gOAq//oBrh8730fp8cQehcNxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nvBY28R7RFqsu6XulUkQkD4XVcu4oYT+ZYHXy26jVR5gnKlMP9QVYW5f3U8iGBiJDdpY1MqjPZG51l6taEBHchx3buOwSoOgMX8jUaGMXKQKo8LWsDL5++E2PskQan4/jjOJwnQZAGtMzKuHjd4Jsv+3XW9pq/fgrXf6fO0+0RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FrBsFoxK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45526e19f43so26942875e9.3
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267645; x=1753872445; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=FrBsFoxKRQS1fdmTeM8amrfdDC/+OYl6JTH8TSyRwl9xxn6Zi9yr279JxHXQ8ER4zQ
         GBQY4KLgORF7s5wAXuGuFTlZQfiEa6rWLzuFM0jTsA3IHChU6OxO4t7qN6n80IsBstjw
         ysyB3QJvW6fs/Kzm9LZEEiWFN5BnMykEE/LI95bWaKDhOQLKlSTdUxvL9SGbpqIa/V6c
         Gn43zidnrqigjANMg1KNhfQcX/dk/1QYr1Jmy9wDwcA/BxLxQf0lWm+wwthACwnK4sEr
         lqL1v5c2W80SoeR1UrDBZNhuV5W6rBJ/Ko83BudneJSU52nQ3TMpiPqVfZ6ERkSQ0/y5
         f/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267645; x=1753872445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=OSnm9LeBFKRa21qSqlpOlMsLGugLeREEiUljR1V6t9HRvKGQTEzB9VORzMPUWQep7I
         SWpgzpJkhSS6wBQSZH5iyt3oaXoBW6jLaU+L65VPxI576QJwODwzlR2iGQZWzBwArCF2
         ZjqXXcLjOcoB0VtqVaUJc6YLJ4fts5cYou+0iBb+8D+kVqQ+qyNAszJ10EFBteR0/x5b
         nyiId8wUBtx5kuDCR38Zgitb9sJzl03QM5Jh/x4fQA4yD2JxgChEqeIyBN2Gd1erK/8D
         FR5W1o33MNz6c0OCIZjRufsIiJUnqvIHtSkj9epvdhTiRUStQ51Z2VGRNUw/m0rU2UPT
         Q/gw==
X-Gm-Message-State: AOJu0Yxt+zegSCw8cYidkCKMCSFPQVDYgtSHTC/vUmtmVgOxHGPP2Uc1
	9rgLezY8HxWND/PquaJ81Vs8OQPwchdsX3D+Xs3kekrEVKj3f/uUSd1zCgNUg+SMgsvXh11YtNW
	Oo78FNQ8n4G8S2z42sCL7f0jx6m5uPaGlySqEg/gajRBPHLtJwTFV6RGLfkqCzetk+H5UWIfRY1
	dNfJhDIAnFGAtPQGj4OZqbtWiXuic=
X-Google-Smtp-Source: AGHT+IGh1e+V8SmScKMa7B9rDGNrVFkyz19g/99WYS3fME9s9rYU5XZGuebCy3D5fzuVYuNyo6dDcGaEqw==
X-Received: from wrov11.prod.google.com ([2002:adf:edcb:0:b0:3a5:7883:6563])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1449:b0:3a5:1c71:432a
 with SMTP id ffacd0b85a97d-3b768ee0916mr2198617f8f.14.1753267643374; Wed, 23
 Jul 2025 03:47:23 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:00 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-9-tabba@google.com>
Subject: [PATCH v16 08/22] KVM: Fix comment that refers to kvm uapi header path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c25b03d3d50..56ea8c862cfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.1.470.g6ba607880d-goog


