Return-Path: <kvm+bounces-28607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A9699A13B
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 12:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FED31C222F9
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FF52139D2;
	Fri, 11 Oct 2024 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnA2fh7k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F80321262B
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 10:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728642301; cv=none; b=Oth+YRxQ1rCCoK8JuW5AQip/HD2B7MEVyR+RMTg3+AI2cJ3r1msNllRrq3361N1zdlnVamE+2T9goJOFw5/XT9a8eTCYL82fqYmlEr/Y5scG5/DfVuJPjkitjlO+DR1IYgVFnIyUKcNFgI8pe0vV+VFCw2lQjbei4YJemu8aBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728642301; c=relaxed/simple;
	bh=VbaT/yecnhtiCgn8TPk8o6PtMGGPa1ZhtNJTgsHIyaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UIU19ZG73eZJWaNxLRUDABwcOcpcGeralk8Vg8DS+dba27SJcGsv9bKgHW4THcfqMudN7SJjxooXZ1x6NWyPppWShQB7pv2feUQT26onKfg0DXlY2cW4DiV7wSzQMrecVcrymH1xPjUqRrLDa/Zmw37OHKLUdr/KJSDaxncNcqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OnA2fh7k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728642298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7vv3EQMzd4TWBTeWa4q+6Cuvwi7TbHKjxDMuJRyd/lA=;
	b=OnA2fh7k0x6xNtN/2UmkByh/2DQhKW2ZTfGodqdYKoMqfxUISHBV2P0gA6b9IaGTG3XIhC
	ufeUcU1Bev6qIq+OAtx002iW0H+CjnxLq7C9HQqhcseF9n91oINd5tpJAXoNBrOCpTuP0G
	VuzBPM4jL+zJtlSsQfDkNo25l7cW16o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-AwgB_dA3O82RSwjCG7wvpQ-1; Fri,
 11 Oct 2024 06:24:55 -0400
X-MC-Unique: AwgB_dA3O82RSwjCG7wvpQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FF6D1955D5A;
	Fri, 11 Oct 2024 10:24:52 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.4])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E446B1956089;
	Fri, 11 Oct 2024 10:24:46 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Thomas Huth <thuth@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v1 0/2] mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
Date: Fri, 11 Oct 2024 12:24:43 +0200
Message-ID: <20241011102445.934409-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

During testing, it was found that we can get PMD mappings in processes
where THP (and more precisely, PMD mappings) are supposed to be disabled.
While it works as expected for anon+shmem, the pagecache is the problematic
bit.

For s390 KVM this currently means that a VM backed by a file located on
filesystem with large folio support can crash when KVM tries accessing
the problematic page, because the readahead logic might decide to use
a PMD-sized THP and faulting it into the page tables will install a
PMD mapping, something that s390 KVM cannot tolerate.

This might also be a problem with HW that does not support PMD mappings,
but I did not try reproducing it.

Fix it by respecting the ways to disable THPs when deciding whether we
can install a PMD mapping. khugepaged should already be taking care of
not collapsing if THPs are effectively disabled for the hw/process/vma.

An earlier patch was tested by Thomas Huth, this one still needs to
be retested; sending it out already.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>

David Hildenbrand (1):
  mm: don't install PMD mappings when THPs are disabled by the
    hw/process/vma

Kefeng Wang (1):
  mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()

 include/linux/huge_mm.h | 18 ++++++++++++++++++
 mm/huge_memory.c        | 13 +------------
 mm/memory.c             |  9 +++++++++
 mm/shmem.c              |  7 +------
 4 files changed, 29 insertions(+), 18 deletions(-)

-- 
2.46.1


