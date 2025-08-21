Return-Path: <kvm+bounces-55370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C02B30501
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2FA618938FD
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D178A3728B1;
	Thu, 21 Aug 2025 20:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N9QEUCIo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEB6371E9D
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806904; cv=none; b=c/9LbWgckNRXye+8DI1ecIOx83Q1R2H/PBcSTNC81FtKz1/UOwMae95IflpbxZBbE6xsDdu4MtdljWwglExeQfOKeJCxoTnWmQwR6Jjxx17FE/Z+VgAfzK3WSHeKv55MRsjxcGwQqvNxANwQvkJViKySeM/SzoDgrIHG9B24oi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806904; c=relaxed/simple;
	bh=r9aVOOwiYkYkJ2XxN3c4oDiixJCUuv2T31t2h3Fc0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzhXB8G0iYGLfCdOVS5P21oNWqxOHmkCGh6skKJK/Ug2Ms46wRVJwaISp5yzRoAa4gN9r4VcvEMX34KxI04IZceO547AuyDsR6NOUg3c1WxTdE6A/26Jw+rw/L8Vl24bxmrMD4rWlhhaqCVDeg+YbXPZFr6iKfWvM7xqdQN5SDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N9QEUCIo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=N9QEUCIogiC101Gz+YwJ7Z7m5vi+HHY9IpUIgjXUtBM7syDWqUJa+AJfAQ5H2r2M43Eqmy
	7X1YutAKrYObOYmfElxD2g4NzUtgx8+zzkvc1/UqT6BaZVtJ8gutIyh8VpIRMsMB4esQTN
	UV0e/P2IDG3ZWLOKyQ10zRNdeldVxNo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-lomVNKeGM82C3iCVeHCd1g-1; Thu, 21 Aug 2025 16:08:18 -0400
X-MC-Unique: lomVNKeGM82C3iCVeHCd1g-1
X-Mimecast-MFC-AGG-ID: lomVNKeGM82C3iCVeHCd1g_1755806897
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so8303275e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806897; x=1756411697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
        b=wh/5CV3/1flziQ/XM/kalXkxH62K2sq5M9iBMWsj58dIBiua6Gz/HghzN1oyjKj6iw
         2zUs9R8ycbLG0yyTTF4xmM8lwNiUGwYTekJnobOgecVacc1AaXtm7E9Q10zbHntIgvWJ
         aQO/9ak0eDwkXSZ8GlKS3J9s8HZohkAWtFknJa4iZY2LgF9e65pWSytpx1waQL1TaLTW
         B8OADLTCM5opl/E/+UBwiJOz1XU+E8Y/cY0//qBJlyRIJPbas5oy28aYOkgflUb8rMBI
         PBrBgAtJebpj8UH1+dfH2q+5zd7KmW7FkFoT+Winp+qKrYhJQIKD4SkOV6G06cI6W8ON
         oShw==
X-Forwarded-Encrypted: i=1; AJvYcCV95fezrnLRkXsmjCTWsuMX9iDJbYdgWOis/Kj7RvWOJozLXFoXVIRUcTbY7ya0esryggU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxXl05hT4BtFhvIYG2DWSuxQYRu8bvioap5scoNCC03Wjl3Q5z
	iZd3owUuDZPP6lg09xephSvjSO6aXVrLwH3fu6dLnGVxZFWAJwVEDcFvbY95kRNmoDYsi+KkDQ1
	7Rv5NUHtEQOYPDKd1RtmFN0LK5ZoVte3xIUcSTNq7vb1RuW/ZQWM08A==
X-Gm-Gg: ASbGncue003yoARRQjgCd86IBnaJo72iS9qmJMNxGOCwW0oxdrmN++K1QWIkvicH9GM
	oDkivElOPOatMM/dPz6rDEMjxzk9OEkqlAIJTchcvkTnpBtA6wU6k1ZWIvJjivHHUeokvaK5Kks
	LwayG0xMRjXqyrp0RL5uIIkvbSBjmsw7Jl8a9ogKrZcRgjWWxABTgOm4m8uC3maEtwZmZfQNQTl
	1acLasMhI9IcfW55EuuvTPJQljHfoCkM3Da1LIExXywAIuqTtWi1Bnqfvdc8VrMMWHPOiiRhS/k
	h1fnE6cEDzZERrg8zzXVqRglFnLM6PXPQTzObwjNNLDemdiEREq+SPDavHxsYo6xGWsQcr82oYR
	9eK+no757P0vmMJ7Pn1kJkA==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505955e9.29.1755806897450;
        Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPdYXvWWhsiYzUao4v8GSpApokx2tOJxTxGWaryOs6bj53AmOc+7o5w7P2pIRGnKU6jzi+ow==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505625e9.29.1755806896948;
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a551sm8831035e9.19.2025.08.21.13.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:51 +0200
Message-ID: <20250821200701.1329277-26-david@redhat.com>
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

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1


