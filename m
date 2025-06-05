Return-Path: <kvm+bounces-48539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6EAACF335
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F02EE3AC945
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6767E24DD1D;
	Thu,  5 Jun 2025 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ntP3O165"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CBD2356BD
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137901; cv=none; b=YECt0DMv91hcTxRPMFoIyN9I/KgW031wFOBab1GeKwcnrDb4ws5dNqBjPdUG8uWz22phQ/BtFrezf2ULKmZ6hFTm4pUVPqfH4t95bgpmFTFJsMm4MetVfS/PgUxUlb+fkAafG2hnNxzDD8voj/3H5X0Vm/3+2wXMngC9b+NWDfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137901; c=relaxed/simple;
	bh=h9y2PxHa3T/iR0irvc8EFzsEpKcI12tJbooS4AaFVxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ISbTodZL2Dfu35elTM+ukDY+eM1FrQpOx3Jx+IZfBo8u0YX50i7iM1Zo5IzGDa+y8gwlkKQQaMl6B/JmbOAS/bg6E9aW1RdlBcP+s3wXnmXcInboQQguvFzQvOKfU2EtgZGiBPR9wBQV7frDp5X5K7xDhJxjH76yZB8jhzOfCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ntP3O165; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso7161015e9.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137897; x=1749742697; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya9V8PlB1f9QKkO6N2m4/v94EO/9DMMarQp6ACk30eE=;
        b=ntP3O165ePxDnjzBGo2ZhWatOLdxvgxVibREXBJE2AVGE2eHXHaP9KywfFe50IlWcH
         gAiaUxpnppovltsscSKzdoEI9ZftyX3YBRYOQ+5ZRN/twZPMInSB2bTLgMukLlxqiZZF
         /ddBn+pjNIieZTizkQCcinymoqrTyvOX8ASBryiaCrGtuEquOITyniIK53uB40Gx2Zr1
         Nky+XC0kQhbnnlDBfI1K/exR2GCwrdaK0U502pqwnpz+VZk3KQB47ZGhBu2eLk5ULTXL
         F398KZQf+Sr8zmrws1mG1btn3uv7s0+fZEBWRqQfMvQf8jqXN32E0ufUIyQ4BqnVcipz
         sQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137897; x=1749742697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ya9V8PlB1f9QKkO6N2m4/v94EO/9DMMarQp6ACk30eE=;
        b=L7gQ7EE0a7UwNCiMdDd56LuhTM6nwrNIvWhzfraw3tf4HzkAeOYRTeU+mHDP5rRTdN
         Jf2/zdEvz3mGc59VtqIeif0wb7pAq1gYjbaa1ZdMFcLN4ouAe42G1C4P126tnBJMq34L
         Ov+E/X/KfeHobqvCgKqHfFzleX3tWED2mL1bvCKioXrK8emOUmzfOQqmmqOIUxYqYFeD
         ZaT5Ne8R877G29tNkcXkF8cW6AFWINdHKtQ8VmHXmH5FLFnL7K6K6zOG5i0iYv1ZCExK
         fgM1ViPsbf4UbywB+eZR1wZgfetPqew3oN7lbnxsG0bpkIaDhtTgA8JQj9BjpFOq+ZH4
         Io3A==
X-Gm-Message-State: AOJu0YxrYJedTe56aylYs0zDId1gsVjuD6qElqZEkf1GMn3TAkNXvKBU
	WDW4K9Mc3e+mspwk0JCew9vioPTDYC1+rvFaGlNulrjiRAzHfViYMg7Ewp+ADlOBoK3D3QvomZW
	Wka0EYdr+AZrpoLyyz4+MlUKMetNdS03GZl196lD1Xo50nV6p+svcK3Ovr8E2RHwQ4tIoYW6TTw
	u2Oaab2BeFhMLv8syvZknGhTwW0iU=
X-Google-Smtp-Source: AGHT+IFhrDIh6gCXeF6nxFdv6Zput8Ia9sHzYK88p92EvJQS2AgWKQpdoJNqkVyvlyFiBZqhNRmwPvnK8A==
X-Received: from wmbhc7.prod.google.com ([2002:a05:600c:8707:b0:442:f482:bba5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3106:b0:441:b3eb:570a
 with SMTP id 5b1f17b1804b1-451f0a6a94bmr72946715e9.2.1749137897069; Thu, 05
 Jun 2025 08:38:17 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:49 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-8-tabba@google.com>
Subject: [PATCH v11 07/18] KVM: Fix comment that refers to kvm uapi header path
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
2.49.0.1266.g31b7d2e469-goog


