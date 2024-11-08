Return-Path: <kvm+bounces-31293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 355609C21E5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E42D72828DC
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CFC198832;
	Fri,  8 Nov 2024 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gcb9fg5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8073F192D82
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082846; cv=none; b=JIEaoSXjU9mxQi2+byCPtwS7RSzHPac1Zzl5earp3WfGXvCCqOF24XR1QZBdL/9A0kWutggzNcRqhyNIO1aKXv7EfKm1V8CBm3lJQn89QYDr6PPtMDH4s+u0u3M8OrA7RJeGM5iTSx3CIG/AKiyc0yznGUEzcJLjaWns6Sz1EWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082846; c=relaxed/simple;
	bh=5dZ18ImJXoySEGDscXOeOWUR/4N+1w2gRsbHb9WD/zo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Byokn+1B2TS+LX26OQkx/NNqwvybRXhT9dmiBC4j2OzJP34cjfPycc3nLrnRq1ws5o79bTgu5pvU4742RI48t1WQgI0WGX2xG/yiSpAvFMxi7ZmVeSLzv3XUIzde7ZYyZ35NjpQoxccDxNFIyTo96016uWnYBN0RDFIQQShQLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gcb9fg5j; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-431ad45828aso15922495e9.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082843; x=1731687643; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qSNggYYB42ksK77mqLJizRXwTBzrM89QBEMwFFNrJdw=;
        b=gcb9fg5jV6FNDQZJIxGOEKFHcWn2ccXCkwZdWl8tmX8oHODXEDiW3NFQCpdFZUlzlG
         FjTuv0LXznk5qvpAfpmu2h7p3XbkkvkdcdhWAo/fFoJ9xAzTmdgNUraeVafLhNBGI7M9
         pCJ4+8naZ83SFlwU/Qi47kJ56sO4AUXe0Dz+6lFJceujtTWtF9Bc42ZLFDMZAjc/wX2o
         pCWAdwRAei5bgnPBUDnAEWsa1p37YpKFD1epr6Y7Af0JrQ37WyRtquNOs+mrigwwu77F
         6VcSeqgzE8BZNO8BHujjVR749oilwhh2tAb50iXgNhwQLCcYaEmSQTOP+jCMNKkjWlQb
         +EKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082843; x=1731687643;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qSNggYYB42ksK77mqLJizRXwTBzrM89QBEMwFFNrJdw=;
        b=tYYYXBp6sJtuemVTZXzqdZZjbfZUjgIsJa5cmBV5sGIaCL/XyYb21nhQWpj/avrA05
         A6NuLfcQi7MJWWzVjAhvfvYB+8vQSZPdVLm/NjR4F7XW8BnSxIb41jyaJvFsYPrkNWbQ
         RjlaCrRfEE9orpPxvV/5tkVps1z5BOCPaHeiAx4CSG1vs0mv08Pvd28SsvNboze5v50B
         3jCIs0fl+qKFjVBOB17rAnOzc3iL9TIX6mX1vJ9PObSo1VqnrUKlpv+dB1Zkzcpk78sC
         8mGMXkqvt7JS8C1RUxWcAQEC4QdvKD+AwSwxcefFsJKktsfay5TmnoR23qhSDzDVQbMj
         EU9A==
X-Gm-Message-State: AOJu0Yzg4GzjWRzK3JCNAUopXdactGa/e9zqxeRU0XzfCqLmvVYkQrU6
	c3A9BZItMdys7WGJLGWo4EdRx5Fj+gaXcrUw6lTohVS0BEBrlMgZ6hIsoxb+a0JIsTuZzYt0Wg=
	=
X-Google-Smtp-Source: AGHT+IGNt2ARzTp6h05fXXQEL275e7en0LhPQqztYO3DssrZ2Bpa4ilDg6kO0xlH0JaVTwhHigLo2F9OCQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e611:0:b0:37d:45dd:dfbf with SMTP id
 ffacd0b85a97d-381f18641abmr2475f8f.4.1731082842629; Fri, 08 Nov 2024 08:20:42
 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-1-tabba@google.com>
Subject: [RFC PATCH v1 00/10] mm: Introduce and use folio_owner_ops
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Some folios, such as hugetlb folios and zone device folios,
require special handling when the folio's reference count reaches
0, before being freed. Moreover, guest_memfd folios will likely
require special handling to notify it once a folio's reference
count reaches 0, to facilitate shared to private folio conversion
[*]. Currently, each usecase has a dedicated callback when the
folio refcount reaches 0 to that effect. Adding yet more
callbacks is not ideal.

This patch series introduces struct folio_owner_ops and uses it
as a generic way to handle callbacks on freeing a folio. It also
applies the callbacks to hugetlb and zone device folios.

A pointer to struct folio_owner_ops is overlaid on struct page
compound_page, struct page/folio lru. To indicate that the folio
uses the callback, this patch series sets bit 1 of the new field,
similar to how bit 0 indicates a compound page.

Patches 1 to 6 rework the hugetlb code to allow us to reuse
folio->lru for the owner ops as long as they are not isolated.

Patches 7 to 10 introduce struct folio_owner_ops, and apply the
callbacks to zone device and hugetlb folios.

Cheers,
/fuad

[*] https://lore.kernel.org/all/CAGtprH_JP2w-4rq02h_Ugvq5KuHX7TUvegOS7xUs_iy5hriE7g@mail.gmail.com/

David Hildenbrand (6):
  mm/hugetlb: rename isolate_hugetlb() to folio_isolate_hugetlb()
  mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb
    folio
  mm/hugetlb: rename "folio_putback_active_hugetlb()" to
    "folio_putback_hugetlb()"
  mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on
    folios
  mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
  mm/hugetlb: use separate folio->_hugetlb_list for hugetlb-internals

Fuad Tabba (4):
  mm: Introduce struct folio_owner_ops
  mm: Use getters and setters to access page pgmap
  mm: Use owner_ops on folio_put for zone device pages
  mm: hugetlb: Use owner_ops on folio_put for hugetlb

 drivers/gpu/drm/nouveau/nouveau_dmem.c |   4 +-
 drivers/pci/p2pdma.c                   |   8 +-
 include/linux/hugetlb.h                |  10 +-
 include/linux/memremap.h               |  14 +-
 include/linux/mm_types.h               | 107 ++++++++++++++-
 lib/test_hmm.c                         |   2 +-
 mm/gup.c                               |   2 +-
 mm/hmm.c                               |   2 +-
 mm/hugetlb.c                           | 179 ++++++++++++++++++-------
 mm/hugetlb_cgroup.c                    |  19 ++-
 mm/hugetlb_vmemmap.c                   |   8 +-
 mm/internal.h                          |   1 -
 mm/memory.c                            |   2 +-
 mm/mempolicy.c                         |   2 +-
 mm/memremap.c                          |  49 +------
 mm/migrate.c                           |  20 +--
 mm/migrate_device.c                    |   4 +-
 mm/mm_init.c                           |  48 ++++++-
 mm/swap.c                              |  25 ++--
 19 files changed, 342 insertions(+), 164 deletions(-)


base-commit: beb2622b970047000fa3cae64c23585669b01fca
-- 
2.47.0.277.g8800431eea-goog


