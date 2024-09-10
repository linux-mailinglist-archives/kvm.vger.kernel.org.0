Return-Path: <kvm+bounces-26408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4EF9746B6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C8A11C259E1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3721BDAA1;
	Tue, 10 Sep 2024 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wl6OsPG2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D541BD4FD
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726011902; cv=none; b=jMdZ8ciFznflITIowcGzT4ZkoY9kccmvkUk4/KuNYkRUPN4daQz+xw6CVxy5XnQ8EfJ5O6SABCzFQ6iV1y0zwfyxI/2mzrBnYUuBEjv8EcD85yGMuGi+6KwCcGD9NcrZSFrkpz/FrkyPfDB0deqmogBV0T0KBgJPWQlzAxuZdIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726011902; c=relaxed/simple;
	bh=LrEdspsLCh8pfXrwGeKzyBwtTCfJskcHEhFW59Ake2E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BAW4DokBJwiTLz/m7eNmLb9usYDuoSWyy2Y/DvvnEl76FUCd2zB15s9z1vk/PQfJVphn2Sq+BPFv1n3127s9+Nzu2vNsJz7riaMfeg8JRSYy9FwU62OlUtC70XSDF+5t72kw0UEvevbqDNUj9Uf1Ya5F3IJTraG4y0ABqBELR8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wl6OsPG2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cd849a6077so1211355a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726011900; x=1726616700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5QWCSGDqbjsS0n7qJVo2UbLIELWUXKqatSc9NHlgvU=;
        b=wl6OsPG2sF4zyriW6DFl0qO1oNl+O3xGGPUsVTH1OBPzBAb2fmrzYwY8Fkkd1zQKGS
         3c3QfFMmAglWrDVoiYRk/2MtXtwftj9sG4CzBFJiMev0Ck98FZ39/BzWRmY64d7RWIBE
         9DHOINxXuWmkpGDB1gj6nb4MyWVOxSVVrnB86PCegV91H8EqmU6Fqa49Ll1XD76a/IOw
         4xzKVTHivmLjhLvMKwVQpA6dVoNsIbRTDHQ7yJg+PEWnMtbmol2EVF+IgX1vuo4SJanv
         J2G9rUzgwGVCT7Okj4R/JsGcXrqLFASegt6YkUphTGyyHUN/fBoypB1tmmMN9m1CwMzE
         ojvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726011900; x=1726616700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5QWCSGDqbjsS0n7qJVo2UbLIELWUXKqatSc9NHlgvU=;
        b=o93dQnNpqMhRDc5PCGNdcKW6DVDwewjA54tW2aBA0cTwC8/jtKSkMwYmT4WJpFvBI+
         4Xlc7uVD80D41BK9aMrl/iVmFyr3R2NeEMGIb2mLVFBD93PEf7jjoZPvMnpBJSet8p/R
         TOk8r+7ZzHl+GbZdxnJA2AvXcbKeKGMibkyIJeGzzKVxRMpzQT3fexPy5NdM1kT3+SLN
         hiK9kpIzMLw3bkIL6e/YG5aJehXncxawJkv35GN3QvR31/vWK0u8ngaKl+PMRTfxEbFc
         YTGweQmlIG7fuuJE35Am2YGQ2Jy6a/MZvXW5l0deqPWMiB2XmvCRGXvQ26BETIfnC6Su
         rweA==
X-Forwarded-Encrypted: i=1; AJvYcCX5rbQqhK7ozayTTaCaAZST9fmUhlUh4PMpKDWwua8d+ExQBnU7GZB5GCVOSw1VX91mj8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhFBltsyoy84M1tUKQ0QKTH0q+XT/Y08MaYV1j0vBbecy/FYJe
	JIyCCdppUyj87dPHDfi9GZm6fDqeEDhQ8TczcCXGtNgmoA+MC0cpmilhxRUuNRSsb1eZVBge5Tm
	t6PoCArd3yJWfwWNvWfdMrQ==
X-Google-Smtp-Source: AGHT+IHo9nrZMACTW1GYMiSHsHPpyJhtvpckq5UoyzEbjp2HiFKw7SxN6vYrJsaFr5HrF/PjOMK6efHCzGq+Tv7awg==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a63:3dc6:0:b0:6e9:8a61:b8aa with SMTP
 id 41be03b00d2f7-7db0bb80899mr2016a12.0.1726011899568; Tue, 10 Sep 2024
 16:44:59 -0700 (PDT)
Date: Tue, 10 Sep 2024 23:43:47 +0000
In-Reply-To: <cover.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726009989.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <6f6b891d693ea0733f4b2737858af914bd70a8b6.1726009989.git.ackerleytng@google.com>
Subject: [RFC PATCH 16/39] KVM: guest_memfd: Add page alignment check for
 hugetlb guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com
Cc: erdemaktas@google.com, vannapurve@google.com, ackerleytng@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-fsdevel@kvack.org
Content-Type: text/plain; charset="UTF-8"

When a hugetlb guest_memfd is requested, the requested size should be
aligned to the size of the hugetlb page requested.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2e6f12e2bac8..eacbfdb950d1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -909,6 +909,13 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	return err;
 }
 
+static inline bool kvm_gmem_hugetlb_page_aligned(u32 flags, u64 value)
+{
+	int page_size_log = (flags >> KVM_GUEST_MEMFD_HUGE_SHIFT) & KVM_GUEST_MEMFD_HUGE_MASK;
+	u64 page_size = 1ULL << page_size_log;
+	return IS_ALIGNED(value, page_size);
+}
+
 #define KVM_GUEST_MEMFD_ALL_FLAGS KVM_GUEST_MEMFD_HUGETLB
 
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
@@ -921,12 +928,18 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 		if (flags & ~(KVM_GUEST_MEMFD_ALL_FLAGS |
 			      (KVM_GUEST_MEMFD_HUGE_MASK << KVM_GUEST_MEMFD_HUGE_SHIFT)))
 			return -EINVAL;
+
+		if (!kvm_gmem_hugetlb_page_aligned(flags, size))
+			return -EINVAL;
 	} else {
 		if (flags & ~KVM_GUEST_MEMFD_ALL_FLAGS)
 			return -EINVAL;
+
+		if (!PAGE_ALIGNED(size))
+			return -EINVAL;
 	}
 
-	if (size <= 0 || !PAGE_ALIGNED(size))
+	if (size <= 0)
 		return -EINVAL;
 
 	return __kvm_gmem_create(kvm, size, flags);
-- 
2.46.0.598.g6f2099f65c-goog


