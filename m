Return-Path: <kvm+bounces-36874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4EEA222CA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFBA63A3211
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5041F1E1A2D;
	Wed, 29 Jan 2025 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZiEA13Vn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B9A1E0E16
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171416; cv=none; b=QOPeYc2H0uXTC0h2mW3+Rcblb0RAc3tK40Yo3a5KxwYlz0+Bu2d+e2Hy8Pr0q19BwGGCiWMxal708yX66Zco+mvhjxkyhAWf6Azm5fDYYM+yBhB2fRW2T5sg+sw9ktltO+UBOicTbhIuRDQYZUOKDGV067K+CVN5V/qQzfQD81g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171416; c=relaxed/simple;
	bh=Gv2OZPl1bMY0RPBa4hp+clbwB5r7GxE0cnVfY9KeGEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Am8GozBdHdnfYM+ucwwOT8ft9+AlWD82zO5Sw26J8/Ik5rN3IemVZn9xe4mIf0XjiUvCvn3gMqNbFbFXq3hhYfi7ONs4LnKdcGCzapFV6xDGaXqMRACkfcSVS1NT7WEJDbfxXAC4wSUA79vSc4Fs+pKSbFwnSyoXlIilbN1O230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZiEA13Vn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so50893905e9.3
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171413; x=1738776213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LUYJLmVCJmslu0EZ70wF3BbY2jfY7y/4QOInoyL0YSs=;
        b=ZiEA13VnHFuolh/qNk0VzlrLTaxI19RllMzy3/chwXVJ6d2LYwIhr1inrOIReahaBv
         OCzBUnHtIJ42m0+du1znjaEbcwfdZ6jpFLJsgsE2p6HYFiAX7ET3KvssAQ8Eyb8kpaHE
         NSf1atLsPf2IOsd6J5RQYbQPeP2c8KzJPDAUb6IddpC7gV3dwt1gKM2gTftFZV99v7wl
         Q9GXfkcVU3J04o7gwVYdOotKgvBpETM+YXHIck08V0Rk3Rftu4X4T4U2QF8/sxC7JpMg
         0AraXt2sVcDyfAtR7YTC/GoviWB8imGokmpEK4DUuTMEL4j3mePg7mx89sdQDc6NtJ4i
         j4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171413; x=1738776213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LUYJLmVCJmslu0EZ70wF3BbY2jfY7y/4QOInoyL0YSs=;
        b=Hrq8dnnQOJyYdRHQD3y4Y7pGLabjAPNPtcog7+ULXtXfMfqDYuJrv7OOkn1FGZeIIT
         6CpKDFGVPi0hcojcsrJlsTr9m4NOBK/1guGsJGjZSvSkGf0g8fgYrhnk3ztU1xQUM7ud
         Em0cv8tEaHMTRmEaLBbfHsfvGi1iCI1FY1zFa7/DRXIlux1qW+fozd5cjn3VIQw1EeFQ
         T6DlWlUIoadKf5DZn9s3th94H2uU40QFiDlkdtfcKvt0X6lvJ9U2d/+pKhzzHIJTpezA
         I8SJnvuo0GzM0P6U7NkWTboAJioRtIEwbUfLFW8c3jDrtLh4Og9NfeRKsK5YMQF62Ph6
         Zujg==
X-Gm-Message-State: AOJu0YzreIKt9hSK1cd9VOkdFvDRl4kBWl74aBQiNEOEomzM0cNW1GpB
	kWCXcTTJ4N0L2oPWrQVwpxjbLMxrBIHsQgmt/1ptcBgQChXsuvSb2LsdJR907Ewz/ltRx/dot2D
	FLNX1TU1R3tINrT4CbLUCtvPWmzxH8to7jlSnrS5T9fsi+2wymBvHVfPfzsa1aSoRvfc5YG/CP0
	NqlbyuEm2J/+qai0Vo+3dv8n8=
X-Google-Smtp-Source: AGHT+IEzz5y+mMN5wvE2N/WLUB8ZD0NYIc/aKjbCfNBDRcZwxKLOkunY2FkpKk8kIiLC8nBZsvQDYPVFww==
X-Received: from wmrn34.prod.google.com ([2002:a05:600c:5022:b0:436:3ea:c491])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1863:b0:386:37af:dd9a
 with SMTP id ffacd0b85a97d-38c5209037cmr4744111f8f.35.1738171413076; Wed, 29
 Jan 2025 09:23:33 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:14 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-6-tabba@google.com>
Subject: [RFC PATCH v2 05/11] KVM: guest_memfd: Handle in-place shared memory
 as guest_memfd backed memory
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
index 408429f13bf4..e57cdf4e3f3f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2503,7 +2503,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #else
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
-	return false;
+	return kvm_arch_gmem_supports_shared_mem(kvm) &&
+	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.48.1.262.g85cc9f2d1e-goog


