Return-Path: <kvm+bounces-39905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 399B8A4C98F
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69D8317BBA8
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D91524E4AD;
	Mon,  3 Mar 2025 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebb0CaRv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C2D24CEEE
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741021827; cv=none; b=AIGFgbIH61qt3f1qeLBpIeAYiXpTN12r8EbQvfZLnkm67p+viWZKOJh0UU/BT5aNFw/pgn45l/s68sjsR2Upqg/RbAhn24IA7XfKRdT7EnEwgpDbq+xw49N9VmZnirB4DlwMBDfrmjhelB/TPKh/3EpSHp6IQONiYlp3eSkxGYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741021827; c=relaxed/simple;
	bh=N0sXzR2Z0T8gQ0/uo8e47ns0PZar8CCfouz9iff3wdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HmY2c6vBsrvUNJjBD/o1KGsruYslPeMUd3tBvwvx+dtG6XWfYj/7Z1vvUa9PXTyf0PVUns8oTfODYYlcFnLW4lfoBcnEd5u+FElAftMlN6Qrydfv5khr3uAUzHYS1wAJ1CXJR2nVhntpUogeow/M459YR9t3GmgJkAFexYZyNy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ebb0CaRv; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43bbfc1681eso6845715e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741021824; x=1741626624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4oI5gikAe6u/yzkS2aHXgPYAy14SbTcaxCMtBWbnfZE=;
        b=ebb0CaRvqmsfe2aFvUrX2s8wlV8TVnzFMLTuieQjTV8asV2vVliP+EOyddfB9EHA37
         HciMeDUjnSZUmfQQKVty21lXJ3Peu3PfcsEx49aBvghilSQ+9mCB+cMZZ20gXbtDca0i
         cI+qvbMGkY8yHfkT6/OVHQfaGcco5RdD9FFdjZdvhCWKEUC21TIoa/dXsAuR8cHjbMkU
         1GMUkrf24XE0uyY98FZ4hGnQRgIg+ivrLRCgzhQKNhK8Pcdayd5OPV23sEqJnOiEZpH0
         nG63EEGljBppmHhrhg7+H+xb90p69cCQB1LlAG+alMnbmWhwTbQm5tGSXiDp/WGWC0U4
         7NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741021824; x=1741626624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4oI5gikAe6u/yzkS2aHXgPYAy14SbTcaxCMtBWbnfZE=;
        b=v6N8X822d7GeXvKQcTx1DdpIIWCoUv7GV0YinLQ9xlOV3xyNMMGmgF1RxwkwK0iTKS
         53woNp3NleIfdD3jmvLp8a5xpIcxGR06YuTCQq0Svggn679nEArvAhYhkx2GG0gTk7HK
         DUn1rMsraici/wHlQkS/3Xc5kvj/9DSpT/Z74ziMikG9H2eGgPtRDbvIkheVeuG7negM
         QvIdr8Mg8+mK53QUcaFhIkbRgiQlu7OJnO9gbslv877oMnaZNOBwgYBLEEyO6XnD1iAU
         yvjTdhIzjHYDPgSraLgLA/yJxbxMFrp7RqNBFwJkyZnNXZLzKTZSCtcZ6PNC/x/m3aPW
         feLg==
X-Gm-Message-State: AOJu0YxOjvxbowN1otyggiu6P5OsFKBvUIU36Z/f1z33HFBWMsFF39xA
	88w1SUdQzQ8aP6y+b2Xbv7lsGMTN9Dh7rKR7Q109eH0jynfA+QbDOlykjvAqvd6K1ZYn26l2EPJ
	6G3lIIBBhO2EhDpaBXb48D+pg0AubloGGKB7/ypuW8bie1BaZSrI+aTW1+lhq0HTrc5if4aEJ65
	4Iw3DLb6/hIzFTfbwRfN/znxg=
X-Google-Smtp-Source: AGHT+IEpy3ESU/AqUCDzF54FxB9DXrs2FJ78OuUIkcSkZmbkbP/GGc1e3KuLkPNQiVV2tNmdlqnulefRMg==
X-Received: from wmcn3-n2.prod.google.com ([2002:a05:600c:c0c3:20b0:439:93e2:dc87])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:244:b0:43b:c7ad:55f0
 with SMTP id 5b1f17b1804b1-43bc7ad56ecmr27090665e9.5.1741021824142; Mon, 03
 Mar 2025 09:10:24 -0800 (PST)
Date: Mon,  3 Mar 2025 17:10:08 +0000
In-Reply-To: <20250303171013.3548775-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250303171013.3548775-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250303171013.3548775-5-tabba@google.com>
Subject: [PATCH v5 4/9] KVM: guest_memfd: Handle in-place shared memory as
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
index 2d025b8ee20e..296f1d284d55 100644
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
2.48.1.711.g2feabab25a-goog


