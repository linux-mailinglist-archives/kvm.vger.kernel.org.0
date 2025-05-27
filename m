Return-Path: <kvm+bounces-47812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 674B9AC59C9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 624544A4F1D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E936728368D;
	Tue, 27 May 2025 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dV/yrL2Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862A42820CD
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368984; cv=none; b=KR/wiz9Cjy48ifiT2S/ww/C2Y7j8lemosYrXGHfXBPGvJeAWqmTTP/9jyg0VIjdkSodt3JH21Ky6Q+nWT6Jwbbir8BSsffK/J3HX4wEstJWOlOqzoDWrzv56ivgKemqa3vnChw8UAqkNYkfeN1kHMkepqOwa8c6GxBPJCJ4tYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368984; c=relaxed/simple;
	bh=3T8lFtRXSgIUGD6Qf7ZyhQa42WeiO73opCenbKlbhTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cSFp/rC6+MSfdMoWxjJ5MEVDdfsx60UzSdPxwkK5qRaVByByiomg68DD+Pu3m9jY5uzfwcOAK6jB4wFcx8lrBwG+pGjpkAJe+I+PoJxLq9ooR4r5p4DViIeVCQbgE63paEAEEatjNop77jeHD/XU9aP9ow64eCxIxHV5PfpZETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dV/yrL2Q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so18814215e9.3
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368981; x=1748973781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4u+mnyvzOg5GK38vm0Ijv+UY5LkqIzlts25Ri0gFsg=;
        b=dV/yrL2QOF+7u6Eyg2ZIrNL4ugCsky9FPpme3h1kcfalFH03eW0YeJDZNE/qNJKyVI
         /m892gAr8zvTN8LvF1bzj7mfKLzAmbSvLCe5Chol6wb3JqCzenb5vrhcaz16NXyIDa47
         3jWgSKSjQtSxC8UYdNda9xSCFGmfx620vdHhmJkyVQPxyVMdqS/eXLrHltka4ywjbCgy
         TMpYdhxCeRKqeRAPhnIa9YCKCUgimzNCL4aiFLUQJXD5AMlfhcx0ihq4u+qlJpYB9iuD
         gJ+KamhH+K85aWNPbLx8dgxaFMySsABU/k8bIJLKCdOcUkd+oGMwWJyljooV0sYAG07Q
         GLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368981; x=1748973781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B4u+mnyvzOg5GK38vm0Ijv+UY5LkqIzlts25Ri0gFsg=;
        b=ZRIRyFW/UBRFrI/GIdj5E34Z8GisyGg9y7nm0A5pvP75h8URpmEkq9KOqwz3bfB3Gz
         bxG6HptoVEGmyILFSqQ5rNnB1MQH2DME8Ue89q+/mJLbou1Pj5NF9VZN4YhgsxnZ3V25
         K5AkzhWNjSjVUv9pbVPclvhEA3QT+AduKx1v7j5WJ49Whrs2BW932Q53YnmqzpQIgnn5
         oFI4y8HJBUXXA1KGYHUM1tpj4gnAjXQz9h3hqqEKz8w1XqfNrvjv3ZbDbeAYyvnSiTQO
         3VLkKTr7/b8TRPxVUJqXfI65YdEwqlwEYIqyTfEuvUhks38IaxEWAkYh+kqJqqhZO9mk
         mAjg==
X-Gm-Message-State: AOJu0YzM0tef6W1zPdIu5DdwZ29+AQfMfEYsy6cYB073PskVeGjw212W
	50+KSSOWesQftEgLCnySj21YNtFl0+zML/X4NBO8x8HvTub3WE92f2cI55lj8LjKmdHM7SlQdie
	tLN8dIeLED3GTDRll8ZF33UR+5CSqIU/ShW6Nyl7uYPt2NlIQ26l9Z9Iqjik/Y35IyyDAR+HQTP
	Ef70oY6+KryYJzx85csU04fW7IpA0=
X-Google-Smtp-Source: AGHT+IFnXBOGCz4JW53CjhJr79zbRrXC73Tg7DLSny6JCyrlvi53lYGVsGL6sxvC2l8qjcxZrWCgXeeZtw==
X-Received: from wmbes14.prod.google.com ([2002:a05:600c:810e:b0:44a:b468:85f0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:512a:b0:44b:2f53:351c
 with SMTP id 5b1f17b1804b1-44c91dcb6e7mr133569705e9.18.1748368980415; Tue, 27
 May 2025 11:03:00 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:36 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-8-tabba@google.com>
Subject: [PATCH v10 07/16] KVM: Fix comment that refers to kvm uapi header path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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

The comment that refers to the path where the user-visible memslot flags
are refers to an outdated path and has a typo. Make it refer to the
correct path.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae70e4e19700..80371475818f 100644
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
2.49.0.1164.gab81da1b16-goog


