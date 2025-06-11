Return-Path: <kvm+bounces-49054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 589CAAD5735
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B94961BC22E4
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E37E35897;
	Wed, 11 Jun 2025 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XG6LAPQd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B30729ACC2
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648830; cv=none; b=nUAWINgC/GAclfxhqaByUND9DU1JLqgqyg2Z5mHYPL8T+WWOo7Zq27Bff7pb1N7Qu2xSs53eoch/6vXpJLtnfy8wfRSDqcABpvnjBfDDwuKpwFhQMOhZkmLZX7/OdIXLrdWABf8MwSwM5EQUz7qXnSiQgbsIsDCOzkz9ato4k/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648830; c=relaxed/simple;
	bh=uVZJEiHocoaakWHyA3fg/NdyzZ7cVeeLc6jmjENhZ/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BpbWPcFMO5O4fc9m3tFwvEwI4Az1dh3/dltgTV5uIBUheYpcir22iTcyJLnve0clPQ4Vi0BmKqd/u+FPjSVNqIxeI2nayjBX7mEM8j7qf3SsOk/z7kCMvgzaDkLjDuzFUMcWeAz39SA9hO1j7X6DaxhbBg52cZ00laFiZRCJp1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XG6LAPQd; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso4083501f8f.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648827; x=1750253627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ipoP8xNDjEIconCL8zxlaSKecDJQOQHycTLmRsr3jsI=;
        b=XG6LAPQdQH2b8GQJswwttBaS9I0Ze4hTvwG6gHX+d0A4OjR6Nq35zSb4kuScVgh+h8
         ZVynZZCGOEXqTYneui1TgBiOwrqcbW07Uk7kDw2IbZrE1GjvzSZ69Moa4XvaYatA03b+
         kyuusWtx0QHUu4yzkpgTQGkTDKVGdem/M2dA5F8Ae+tfZGcilCPoclWBdxpkWIC+KsRr
         Jie14SU27+deHdSKRcYaEc3O0iEuIgLkKW76YhZp+/ai+vnhEv4pGSuqdNXQklkvpTxQ
         BfayKhoziL7ZNC4FWVsuGwJGAYoe+J9stt+A6E/S+lbBrQdXTkdX7L3s+gSj263El98z
         6wuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648827; x=1750253627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipoP8xNDjEIconCL8zxlaSKecDJQOQHycTLmRsr3jsI=;
        b=u+0Bt0rG9ZuIgcnWdKLLL0r4KOox8oSQv6fXy9fa1VJl6Pc+5zoOYNCOkNrTqH5s3b
         EIoPybXPnI53tJKp9z0yPEcJypw9TYTuotIUdVTehYQwdEaYCbmLKkt3fXUL3eL9riIs
         knLoZFE/+jbKH2/L0huzJszFZQR6i3C+2k+dm8bk7eeszYNPxNUmVn7aeuETbG5Rm2eR
         1A4ZFipbpN9CciVv+ikxIMs3AJAn234Ey2FRr7zheHQhC8VHyE/ezFgJ2HChvPy6vPFi
         Bh4VVh6NIIO6rovBWUi4EVKuDGPRXrJAm7eHVP9HFqWNCuRm9gKLgQm2yvn6z3JLP5dw
         Idyw==
X-Gm-Message-State: AOJu0YzFh6gZ/hnvZni7+RslOTaU4PXEJg7khV7YL9yCRyAK+Mme/cZX
	pTjZtslHUc8+A9c+Nx4izDdda7t21y6feMd/EObT41bfPS7vetvu5IhVsAezy0FgvIFIFRxQ69/
	eJXh7RGkfhlHYH/L+rwxpMjvsCpMFBFx9RDvWshLdOJrj2m1t8CvbIxBZQ6lQlTTFrs6PSdzK+c
	FW7VdTLtpI9NyMe4uI4aqRck7yUAI=
X-Google-Smtp-Source: AGHT+IF8m/89MTXda+VzDrvu0RJ/n7UpnITSLdxSxLWKnF222wfDhxftmaJ4GgCm4ymT4m2HSbwt1QBpUQ==
X-Received: from wmbez9.prod.google.com ([2002:a05:600c:83c9:b0:440:5d62:5112])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1448:b0:3a4:e56a:48c1
 with SMTP id ffacd0b85a97d-3a558a43563mr2743213f8f.55.1749648826221; Wed, 11
 Jun 2025 06:33:46 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:19 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-8-tabba@google.com>
Subject: [PATCH v12 07/18] KVM: Fix comment that refers to kvm uapi header path
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index aec8e4182a65..9a6712151a74 100644
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
2.50.0.rc0.642.g800a2b2222-goog


