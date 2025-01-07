Return-Path: <kvm+bounces-34688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B16A04500
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2227D1885EC2
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3355C1F37D5;
	Tue,  7 Jan 2025 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORmpPGnV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3495C1537C3
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264635; cv=none; b=Vy3U72XCaUIyEB1Vq2FMpj6MtA7/YLxH8gptvv1hEkL1i6IrIKM6HzzYhuI0SXrmz/M37LBDXJ9bsY8CDPrL02Y0jggn5e4aRgn/0lPpcU6TakEGyJGE2HEv35tGGSwpZNrc6BODot8RJ/Q6JMZS6wmecJC+1W1D36jskg/Zjjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264635; c=relaxed/simple;
	bh=hjUxddgNgIench8tTN/A4/cad+LVlRD3ay1rqEPRWIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKa207rAPllo6szlbd0mzeUSFr789FpwPASUE2gLDJNyITU0DA80Z1XMFm3PYVHb2oPDiWe7NrsHTLmaD/I3zYaKKczTOxQKS4ZYbO18xVxU5bf2N2Rikskq+GZ1FrrL2ahmvNJYYfD0VLNt0AMnjAwc1cwcE7HKxXUfNc0R+l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORmpPGnV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736264629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=no+Cud0jOAk4dWVRpdO5fYUlo8Ug9zs65TpfSMAqw2s=;
	b=ORmpPGnVTuUXAyIA+zABWty2BbTIyrre2nPftdddmlEszyXyArjbthNlpO/VIlBowgFmqJ
	lgfQuMsZcckKo5bM7G8B8Nq6lqCeQeiuirGHlGHjgqnl/miwnjYTRQPqrnkAV0i9V6XNfv
	LX83R6VTGXW0yEhB0cXOsiuHtIzh26M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-tX8wUcTGNOa7dSaO9j5E-g-1; Tue, 07 Jan 2025 10:43:48 -0500
X-MC-Unique: tX8wUcTGNOa7dSaO9j5E-g-1
X-Mimecast-MFC-AGG-ID: tX8wUcTGNOa7dSaO9j5E-g
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso114246825e9.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 07:43:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736264627; x=1736869427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=no+Cud0jOAk4dWVRpdO5fYUlo8Ug9zs65TpfSMAqw2s=;
        b=PBLDapdVAQ28wFiocE8SYbF2c71upPCEJX95v8bDtrzjnFtyvZOxqkhZnO+Obx6tkY
         I5UrL1oPfa18Q8oNn3N6FTpbBHTscT1lZWHyLYO6ic8iDQhn+mp6/MrQCEq/k2+sC3uW
         PgZAlCZ72pvitQs3yDnCmgHeDSaud7XNUxs3WGIVgkiVyUXobVq6rzoPPVrnsWrtvtfF
         1E/AYvJ7syCgG88P/w/RIiYvG9Ododg+A1MzSDQi4IxOSr3WnYGFgCmi5u4J+pWJlhJJ
         Q5Ha8pdpwZ4BRFVT2BupNXwPdFkevLZL/BgF5ObF3OWHDPaPYIOovzouHg/gBl6tiEo5
         mVog==
X-Gm-Message-State: AOJu0YwHA7ajosQmYU0B0fIIgLs16132UjK+i1IpIm2/U/Il2rrgKssZ
	Bgk6klJgzEmDGK7lZjUcWQ+qjdHS++rQhbuMtNp4yQU2lI43SEQRAJeERuyuWxf+CE0hDa/BbWM
	T+MbnvXvD99OAcHW1YwKwkj1DRTKZaYDpxi7D0FDpDgSpetgrvw==
X-Gm-Gg: ASbGnctrg/D0HDyCSuqqlS3e/G53W8VfOfvF/y5q1Z2z9XvsHKzXEoG8TmDz11eGEJV
	IKIoAQ8acv6M42vAmxCurh3xHRHj1e+e5lB8jyIaXrp0lL1GBMtIQLGQMMxa3nE1hBMnP9pq1xy
	K9aE8TtasaE995i4MFc6WDX0uJ7hPmKhpcSmyDFlsimZlTe+hOy2WnO+B3Wm/VXvN7yVHjebZIM
	aPnL82i4SXtRdfvWkNG07fNVDmWc2L9VVgDPzCzgdtoG29877YMPyxnxZzjOFe5ZLLhfDiK13Aw
	ooqKTqSNjuzWmIqPlLwtjM3IYZCI8IZxnNDBzEK5yQ==
X-Received: by 2002:a05:600c:45cf:b0:434:f297:8e78 with SMTP id 5b1f17b1804b1-4366854896cmr459739935e9.7.1736264626947;
        Tue, 07 Jan 2025 07:43:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtLanc3Hb6BIOTSGukfIzYS1Co4sBL6WU3f6+RlroOR2If65sti0csBVLD4eTv+aaDHFjzXg==
X-Received: by 2002:a05:600c:45cf:b0:434:f297:8e78 with SMTP id 5b1f17b1804b1-4366854896cmr459739685e9.7.1736264626629;
        Tue, 07 Jan 2025 07:43:46 -0800 (PST)
Received: from localhost (p200300cbc719170056dc6a88b509d3f3.dip0.t-ipconnect.de. [2003:cb:c719:1700:56dc:6a88:b509:d3f3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4366128a62asm596318625e9.44.2025.01.07.07.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 07:43:46 -0800 (PST)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v1 0/4] KVM: s390: vsie: vsie page handling fixes + rework
Date: Tue,  7 Jan 2025 16:43:40 +0100
Message-ID: <20250107154344.1003072-1-david@redhat.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want to get rid of page->index, so let's make vsie code stop using it
for the vsie page.

While at it, also remove the usage of page refcount, so we can stop messing
with "struct page" completely.

... of course, looking at this code after quite some years, I found some
corner cases that should be fixed.

Briefly sanity tested with kvm-unit-tests running inside a KVM VM, and
nothing blew up.

Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>

David Hildenbrand (4):
  KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
  KVM: s390: vsie: stop using page->index
  KVM: s390: vsie: stop messing with page refcount
  KVM: s390: vsie: stop using "struct page" for vsie page

 arch/s390/include/asm/kvm_host.h |   4 +-
 arch/s390/kvm/vsie.c             | 104 ++++++++++++++++++++-----------
 2 files changed, 69 insertions(+), 39 deletions(-)


base-commit: fbfd64d25c7af3b8695201ebc85efe90be28c5a3
-- 
2.47.1


