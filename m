Return-Path: <kvm+bounces-19722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A84519093CE
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 23:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3A9D1C21E04
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 21:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8C5186280;
	Fri, 14 Jun 2024 21:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SIDFrFQL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602AF1836E5
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718402171; cv=none; b=G7Ncpn4XGhfTyOY0CPW/poIhWXvFQmTA5ijL1wQkcotFrQi58jjlisXtCEK/5gB36V9qdEuPca3XIoLvXdaB5rN0cmXWkGnWqG4yaE/Zi6U8gOJ49XdEPB5mtm2NP+be01N6bQ8YZSMgvfinPQuPukQ7C84xB3ZWpcPTFaoW9ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718402171; c=relaxed/simple;
	bh=Vwg6q7fggXLeb5tpS4EisZKmEOQoagaqE3VchQj5zPk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iQFt77Nfl+mr9JfRGFS8e5Lm+KmZh0pLFOFS5QcRH4CtPkisBjA+bCpWvcl+GaF2QaGPLcarV44rc1bkNMZh5VemgjeqfdF+X9MWy6HvQZ6XsG6FNXBTo5Sr9U5BXrShMQ9CQrktHmoSYGkCJlCsqKxGBjb0kPw8F3x+KDz65gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SIDFrFQL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718402168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a+FgBZXjI3XY9vehVUUcgNN5izssMgAKgIaS5/cDLQU=;
	b=SIDFrFQLSO8uMNeu+mdxejRSr1g7akHzp+OGWzOaRVaSu5WNl1rW107Mq2U3Txs9BXXxgi
	wh/5dl6GR3JjvPpBi/I/T+82TJJaCxJ7g0SXrD2zwu9U4SPp8lNHOnJG+ykYDVQPdhgvrQ
	NhtSYolaP3jupsymGHMwb00iSsGxFpI=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-4AxirkUDMiG9L03OzM732g-1; Fri, 14 Jun 2024 17:56:07 -0400
X-MC-Unique: 4AxirkUDMiG9L03OzM732g-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3746147204eso29266255ab.3
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 14:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718402165; x=1719006965;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+FgBZXjI3XY9vehVUUcgNN5izssMgAKgIaS5/cDLQU=;
        b=T43w7AocnKJwu9EY4bRlCq7fUBAOCoeGEfapKfX/GT5evYA/RBAYpExGJHUFt7uTf1
         Oc2hvNVwNdepC8l7Xaits1Rb5kd1JjzA/6Th41Jezubk1mY7MA81LTmuo0SWY4RdzNES
         1hBasYT1GZodOdqONz3PVrxpE106ilGTZkzlGKpfNWTm54F8BYKIby2OcX48vASA1TOY
         g3B+FUK5ZCRr3rFPj6vobtmZEr+PO1ErhNLVi84LysMS32x8PS/I8/0HWTowtOShPG4s
         REwNPLjUCZPT8sjB010GoQGXVIsDHkqFeZJcmd33f2ncjWlLhREIQFmFfzthiLWqDbVx
         H6VQ==
X-Gm-Message-State: AOJu0YwpJIgusU/JRzxnrjZn9IJVU/BZzq1Xsp1HoSbV5VSaaQDjwIsp
	2WS3adm0m6fP7VaptR6ciPaI7smRQ8Yn4GMNByEoVZO2vPVtyhT99bJDvlByYfBGvw0MCK5Xww/
	7YxMfuvV4UQl1qOAYqcFcNN8eaFJWWs2ji+kQg2Dnqwn6PcG/adIKRFd9Pg==
X-Received: by 2002:a05:6e02:1786:b0:375:c473:4a81 with SMTP id e9e14a558f8ab-375e0fe301cmr40129055ab.31.1718402165633;
        Fri, 14 Jun 2024 14:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXKj6qscxO8UfaNmhMDffg7PhHYVOZb9bJtLKPndTHdHaaCEe/bSaYvU1Qjw3bfZ0F7F6cIQ==
X-Received: by 2002:a05:6e02:1786:b0:375:c473:4a81 with SMTP id e9e14a558f8ab-375e0fe301cmr40128885ab.31.1718402165284;
        Fri, 14 Jun 2024 14:56:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-375d866e47fsm8316835ab.11.2024.06.14.14.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 14:56:04 -0700 (PDT)
Date: Fri, 14 Jun 2024 15:56:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v6.10-rc4
Message-ID: <20240614155603.34567eb7.alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc4

for you to fetch changes up to d71a989cf5d961989c273093cdff2550acdde314:

  vfio/pci: Insert full vma on mmap'd MMIO fault (2024-06-12 15:40:39 -0600)

----------------------------------------------------------------
VFIO fixes for v6.10-rc4

 - Fix long standing lockdep issue of using remap_pfn_range() from
   the vfio-pci fault handler for mapping device MMIO.  Commit
   ba168b52bf8e ("mm: use rwsem assertion macros for mmap_lock") now
   exposes this as a warning forcing this to be addressed.

   remap_pfn_range() was used here to efficiently map the entire vma,
   but it really never should have been used in the fault handler and
   doesn't handle concurrency, which introduced complex locking.  We
   also needed to track vmas mapping the device memory in order to zap
   those vmas when the memory is disabled resulting in a vma list.

   Instead of all that mess, setup an address space on the device fd
   such that we can use unmap_mapping_range() for zapping to avoid
   the tracking overhead and use the standard vmf_insert_pfn() to
   insert mappings on fault.  For now we'll iterate the vma and
   opportunistically try to insert mappings for the entire vma.  This
   aligns with typical use cases, but hopefully in the future we can
   drop the iterative approach and make use of huge_fault instead,
   once vmf_insert_pfn{pud,pmd}() learn to handle pfnmaps.
   (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (3):
      vfio: Create vfio_fs_type with inode per device
      vfio/pci: Use unmap_mapping_range()
      vfio/pci: Insert full vma on mmap'd MMIO fault

 drivers/vfio/device_cdev.c       |   7 +
 drivers/vfio/group.c             |   7 +
 drivers/vfio/pci/vfio_pci_core.c | 271 ++++++++++-----------------------------
 drivers/vfio/vfio_main.c         |  44 +++++++
 include/linux/vfio.h             |   1 +
 include/linux/vfio_pci_core.h    |   2 -
 6 files changed, 125 insertions(+), 207 deletions(-)


