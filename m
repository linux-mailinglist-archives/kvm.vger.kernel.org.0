Return-Path: <kvm+bounces-41402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 252FDA67902
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2373C7ACB7E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE51211A06;
	Tue, 18 Mar 2025 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EXyD+uPE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDA9211474
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314721; cv=none; b=t/Mt39k+QWci1KOwbkFD10Krx+Q7BkJ26pyS34tV3LhylzRRuIFAADLpRlzTn7d73EFq9FyNG+8pIWGNEulXe+TRupNioN2tGxc1tGZ4tvnYT68JN+nyWDZLqav71M+GvOsje9kDzm4a6Y5qFOLupTijXMRXhYpWxlJL14c1l3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314721; c=relaxed/simple;
	bh=VThRx3xXCNs1De0U3v1PjAl8DRWbDmLzde3CVZrAVGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nPW9Q90vFFsyR71yJUXTtlJGwy9YYsGME1pC8fS2UJ4YUR0kLZa7pouZMiS0WeyPtRymNk/TWK88R6CFjr9cGv19Ys5Np16oIdP0/4CTx0GWOGcN1ak/GaZFtGceliug6q0yqKSk5aUOwJiX5ulBDe4JrxOOmnMBKAfwkhbLnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EXyD+uPE; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so30340355e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314713; x=1742919513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EcAixsmdhk6bmV6ZGX7oCYFqnhwEUpezZCWTXKhO+8=;
        b=EXyD+uPELE6tZpMFjFPv0JuTDMTB6EYiVaQRYJcipuHRAS8VWDNDPA1DpnmcY+bKVV
         Azs0KG6M13rKTRzkQZX/vpjTlx7Dq0WpsYG7tNNSj3KEC7HGJa6wnbS5CACspO9xLsaQ
         8d2UlEStBxEhxxRTYdufGwiOMjvSUOGma65pwl1aTxErYWdpE/eXAI1/JqqybbGgs+aV
         WLtY0xoSsFH7eKE6fah9XPlrR2NjZ6/Nt1CqE2oYm90/izllAvX76wPS/l3+Xp/OcPRd
         e+X8+we29pRMaUM/0dX7SRH+O4H5x6E4ti6hLguS28EhhVe0ACzqGkb6d9koWAVlIz9B
         hSQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314713; x=1742919513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EcAixsmdhk6bmV6ZGX7oCYFqnhwEUpezZCWTXKhO+8=;
        b=nr4jOeiBaMVLen91u3oYG+fuyB8E2M0+vx9Z02S1sxYqXmhlrDSRiTZLYO7i+cIOC3
         VwkO3lq+RBYNiFvK6FD2WK7p3nrlZf6QOl1HSVH7DE8DgL8afwLpq9bj8vb7K92b7/xt
         uDsy5KRqOXgF805WSv0ij0y9ivNJpRwtREm8AWvAmI9SGbm3ehPr6uLYOvETty4SxV4v
         DSM2EpuYXeZZ9S0/eO9bzNffNHEvim4ZhdgZvmQ/PLkm1P2MTpMFIrT4WPEIo0wYv7qr
         QcGEZFQyn9b34uVs4b9sLWC7njhd4+An8YjNAs+Km+H3lMibbv2Ur2tMq+n4C0XXQh7o
         TMaw==
X-Gm-Message-State: AOJu0YxHw66zz4Xnq4mDL6/R7xJNLu9NpiVN1w6hhjPMuWSBjGhi3unM
	Z4mfQf0K6OKFDkQCpy0D7b0AtAuF/2BhVScBQrubaJm4CmEux4MsLEvKSwTlkUKZKIvLBOuixgt
	jNYX0SO2ydlJCDcEuUeBBjEaVGb8qRj0MLonL9jyusKVENhl7HfFjloVHRhATxxKHPSTqdEr95b
	bpQcDB4bhk9reFo78pXJ5XsrE=
X-Google-Smtp-Source: AGHT+IFuB0YnKL6kUm38tBS/6LJDBkvMlWqrQgPpMVTZtzFsku07rNUNUVUMU/c13cdgLnKM1DZebVk/ow==
X-Received: from wmcn5.prod.google.com ([2002:a05:600c:c0c5:b0:43c:f316:abd1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d85:b0:43c:f6b0:e807
 with SMTP id 5b1f17b1804b1-43d3ba30defmr34291435e9.31.1742314712952; Tue, 18
 Mar 2025 09:18:32 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:18 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-5-tabba@google.com>
Subject: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For VMs that allow sharing guest_memfd backed memory in-place,
handle that memory the same as "private" guest_memfd memory. This
means that faulting that memory in the host or in the guest will
go through the guest_memfd subsystem.

Note that the word "private" in the name of the function
kvm_mem_is_private() doesn't necessarily indicate that the memory
isn't shared, but is due to the history and evolution of
guest_memfd and the various names it has received. In effect,
this function is used to multiplex between the path of a normal
page fault and the path of a guest_memfd backed page fault.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 601bbcaa5e41..3d5595a71a2a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return false;
+	return kvm_arch_gmem_supports_shared_mem(kvm) &&
+	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


