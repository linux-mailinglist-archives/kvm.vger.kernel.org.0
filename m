Return-Path: <kvm+bounces-55348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FC4B303E8
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEA1C7BE0B2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5109535A284;
	Thu, 21 Aug 2025 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UOIX/qy0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1926353349
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806842; cv=none; b=poPklCwP3EUwMEtnapOrco3nOWYca0OF2H3URXMpJnT+SkxSADJ/Il4Dpo7/X5UNEPqmdmXCC3ZWNlKohD4Ma90dWgsWb03nCV01hMv/Hh+MloXb/LwoV/GNTU988YKxK3wMNIGNAyha0MFyqixi90poOE9ykH+5ll51MzPDTog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806842; c=relaxed/simple;
	bh=3FOM28sJXvbUF2Tn/5jLCVekviR1dLu1+OtM4m//AQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/+bMxExQ8EwRabJIoBFzFj2FSKL3RvfVfNfYPD6q2LrUPCaEHolryzcwQWwUGi+Lo/qFLFhTQ2NnEBj9ZJfcD6s7k+YcL5E+2igsc95+xnmcrD4G1DeiSlB/1c9DfkCoo+E+HhmzBuFWAB3uQrJP6qsovU7eQsN1wLKfKGmBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UOIX/qy0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
	b=UOIX/qy0qd4UJ49d7l4MNk7nDiW141L16mOksv03urBDSQfKxzfJB1qEtz4oxiYIGVqYV8
	flTcnNFzBSfAXrsC2EUygznvH1dPVwsFgn0eLUL12C6T0QXoDnjZLmPhIqwvkmBC+7jCwA
	ath4VJhJBqa5l6PMDUXROFPrFuVeGM0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-f3L-tvGmMYKkc34H0Dy9RA-1; Thu, 21 Aug 2025 16:07:14 -0400
X-MC-Unique: f3L-tvGmMYKkc34H0Dy9RA-1
X-Mimecast-MFC-AGG-ID: f3L-tvGmMYKkc34H0Dy9RA_1755806834
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b46bbso6492645e9.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806833; x=1756411633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
        b=JTFlDvj9yRu7G+iAImuMmVbHfXtqBOXhZJaK8/vhCKmA/8jgjmN7tJ+doKaJ9JKJQR
         1Rg1br4KlaxEVidK0aBNCtMQdnxB7iFHXCp5NqFWY8x+5zs7o15FSi+Y0Wu++Owt0OSz
         6nEc7o6dbG00LOdj90LK2CnIzU1xBdMGv0dWRIgIWjE0AdnwVPWvas1cdgQMhzmfs+kr
         XLpK1sJncNvp+KrhfwpKL8BivWeJfTfRcArFBU4bv+9ojzzbqggs6yKyErOsPPJ08gMn
         b18txExHcrckTuBs1byzUITYmYMpM8WD0Rs1zDhfKomman+UsoBGTkVY+R4zw2Kt+b7g
         rv/w==
X-Forwarded-Encrypted: i=1; AJvYcCXN50H8hf13xvAkviNr9LI4xDUCXS7fZczz0yGxB5yK/5IGtt7BgisrkcLR66fU5+o9cik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTrJr1Z9q0+NkqQoMhDEn+X+26k8dT/MUXNwsVE5ki+A0qsM4g
	UxpVdHuHStoideweF/yIcBe4+rIdbq6OZ8DYDIV4MjYFdDb+8jfblDFjT6InRsoS90N4ywJcxsP
	9EX9m7iyvjHd89C4eAyR1oze9aaYRxsFdf11Mx0HeHsdFumrNmn9JNQ==
X-Gm-Gg: ASbGncvh1eE5e6iAHeUbhYU6kMMz0QZBBzlL+/MEzRFy0exQA5FCgwU/xfTxAvHoABS
	Yb0MZF/+PJqx4nMiVfbv2kQ2Not77011GDdR/kbDKuBjkDej52QJR3MeqgpQw0t0x2ulrjJN1vl
	rszaeeDsNOK0z/vOK42D3CfxN2XeOHFUsg21E2Ytz1Ijh1SlANXUi/E0rMbt8epkyjwiLP/q3XA
	jRxY6zDgRK+O0ny+GlaGvXsrYzAJcUpCCTIqcLqXgN6u+hwzKzif5FG39zAXMUk/NuSOrf0wWTI
	B/8OdM/9j4rHwDVHcLz9nVhUbnq09+oMb9YfFZq7NTfD5r0NthujjjoxigatNLNEPhtV25STaOf
	lx5BUPMXN9QW8eqtOno0o5g==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2598545e9.14.1755806833367;
        Thu, 21 Aug 2025 13:07:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSutx6qbatKffMJ28UfT2ZDXFlSv+vNq81oYks3KAGI73zxxTWKo8ClwQ/mmPq6W0wDfVQow==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2597955e9.14.1755806832889;
        Thu, 21 Aug 2025 13:07:12 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c166bsm12916801f8f.33.2025.08.21.13.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:11 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:28 +0200
Message-ID: <20250821200701.1329277-3-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a64..b1d1f2ff2493b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config HW_PERF_EVENTS
 	def_bool y
-- 
2.50.1


