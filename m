Return-Path: <kvm+bounces-37851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 040DAA30B6A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABEC1162AD6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAFA236A7C;
	Tue, 11 Feb 2025 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SDAtHrIS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA1722331E
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739275903; cv=none; b=h685x3VBliIg3QOQeanHR7jWnYrf3S9SHgbyBel6wpzcKRhwzApEwVqSJ2/x8+h2outaWpsLD77TVK0e7TB8P/OsLSkGsPPC+TZq48JJQ6QS4DLlawr0KDTe4dt0hIbe0FRnMzX/lEgu2SIFxn+a98AtKS90bvndm+21bRxSYsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739275903; c=relaxed/simple;
	bh=OIfyRRSYHI5yO/1M7fAZ42sOnWraacKOBpqYBOZUDC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqTsTLJZlwjEJfUO0pJDtsH1/B9kJkXLezTDeDlyR5aNAIJDOCLBjbfZGZvZEFHBUZaVwpg1mHVJwQyAHkH5LmDrTO0JZj0LVzcYwfCcX9ZLzm8Qx9CuL+eDUiE7t7d1qq36yhQVTEAY7Lw8Z0X/DarSaA0aSNScQkMMy58ZMyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SDAtHrIS; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38dc56ef418so2049157f8f.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 04:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739275900; x=1739880700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4c2azch4XGSzLhm4hVjhhxsYncTOG8CAgSFUNg+Wf8=;
        b=SDAtHrISjMtmogqUtprIwKvUl25be6+/ydnCT7hxXvsoFSzgUE1Ev69Z3UTe5l7zYY
         QMAxFxNqsa2HHkm1GJJ89rZBxhvIhDtpOQvze5lDi/6PVkn5ppUO0UpvpxtuYcjKZ6Ib
         ps5aW/arx6JKnn/cb7hJ4lZxw10/eHEDpG7qlz2RUe9uDypo3XocYiLYE2WYYn24WqJr
         kFWABWy4ji0ZWboZ9jEt9SX33IYBdZQ1uF02RymdGTm1egN6DDXUnDFTgBCTv5rg/D+Q
         QCzR6o4E0nfAOSwl2AKAuHeiBlBHCuU+MOgbtCoxn/MEnK6olCd8pYmI/iga0wbdvzSu
         apFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739275900; x=1739880700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4c2azch4XGSzLhm4hVjhhxsYncTOG8CAgSFUNg+Wf8=;
        b=vV4Emgib5flNqCZkWaZe8fIXWqQvjEQH+dTT/1gpMWwcv3KE4yEGz0Uk+XOcS6kTVB
         /O78t07vSq5xHD8AE+Jz37lQ7ashpd/6Zsp01+tdg2Xl/HPeJmFFGAe5t9vDP8SzK3tp
         8IE+F1YRyfehP0v78FaJSaooOiMJNs96fwvf+IUNc2p5tzX4zHnxUw6K4wt2NVrJ03W0
         JfJfZzu8+2oa3C0BJije9KHXcNdeIjcEgLcSH+m5bZn45o3DEaguXpGIwg0WYx8kcq+7
         1uSbya8qpx99qMgRoaoNUKsFkSVPUiECyUGP35Oum1CNMWoRy6ELx7lxTkLKe9TaQRoP
         ntNQ==
X-Gm-Message-State: AOJu0YwnKoQ/K64/z3PLxG5To7TpINmr5G7THsghUl17UE+i6qJDaZBU
	Es+D+PuAStGe8s86rW3RwokF7lu5gTHMtDdl0IwUx8ORK0tNBMtTOLoU4FqlDghjzXSyrOy2rgN
	89EzLIawsNbiY/5f38BqyB8SFbE7CnpDJZdMF9c9w/bMWaijLlL4dO44mL/7UBMCnd8/Y7SZ8C8
	Ycrphqrou3UdYZL7H3ZtOn4y0=
X-Google-Smtp-Source: AGHT+IEZVlgZ7l4TTAOh1SBqdQFPpEAEB3+x5+ryB71coKgbya9elk4Zr5rIWpnyM79ic86FoQOK0Ptk8A==
X-Received: from wmbet8.prod.google.com ([2002:a05:600c:8188:b0:439:5539:d861])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1448:b0:38a:88bc:aea4
 with SMTP id ffacd0b85a97d-38dc9233a6dmr12990245f8f.30.1739275900187; Tue, 11
 Feb 2025 04:11:40 -0800 (PST)
Date: Tue, 11 Feb 2025 12:11:21 +0000
In-Reply-To: <20250211121128.703390-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250211121128.703390-6-tabba@google.com>
Subject: [PATCH v3 05/11] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
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
index 438aa3df3175..39fd6e35c723 100644
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
2.48.1.502.g6dc24dfdaf-goog


