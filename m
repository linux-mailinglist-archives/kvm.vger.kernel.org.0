Return-Path: <kvm+bounces-6856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8700383B110
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 238691F23F09
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABFC12AAC8;
	Wed, 24 Jan 2024 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ze5lK+nx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9011A8002E
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706120690; cv=none; b=JNuRGMkGNyuHuODsCzQ1QiVp/FXXkzV3U7alerlbbxb9e07zB2LJVTSWSTfAgyuudal9c4ITJLXBZWVtgIjgym+GjawJLRcIN6AoYhRuEcvzyU9TZiRKZ5q4KvyBMxqwBCTU1uIULOssPjXBNo4YBfneIPbs6AautAEBk/sQKl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706120690; c=relaxed/simple;
	bh=dMTI/iw3AwXKWzsdbGrnwWHhPG4qRZb1SvoewX0XY6A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tmBqcHAeY0bDvaqIQV/MDIRX3SOLX/ndsLrpES7YrKJaVdNsZXPfH73K1WGmviM1QssjBI4a52UI5GgLLogoV3HzSF27rJTLB/wgn3otB7N3O8tDdyVC50rTrX3tA7kM5bJh58ujze+1khhq575x4O6lk9CwDehrhxa2byrevkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ze5lK+nx; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc22f3426aeso9327786276.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 10:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706120687; x=1706725487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ViUKkMF4Pj6an+9nMYGHNnsIRWTiYHX7FFlEoxJIQw=;
        b=ze5lK+nxoBbzSGJ8AYGM+Aa3pdxuTENpEw8lVqP9Jv0RBs+mP5i2YGPFGLBTgeczUo
         4gA4ph9A3bpcpdiPF8Tf3pIUB1+WRoIs5bempgffopeYk9T5iZVp4wAfeO5QxaMcpuJR
         Z6U8p5E6+KLnHtPihEJH8omvD19ftyUp96KHg4z8UmmfpKW9VhAoMMerTXfR9X0fuwK0
         ri6MskxwjCQtRj2rNP06a3u4vNXzK4M6T4sreraIOlnQP1c8C3iAA56jwnXU52vrpgDa
         IpsIUK4u7340il63IygnwIZqsTkU06auYyhvpflTGXyar/Jj42BODT8W4idnV4Gzj24a
         adQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706120687; x=1706725487;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ViUKkMF4Pj6an+9nMYGHNnsIRWTiYHX7FFlEoxJIQw=;
        b=RqZUimj6X0xZQn5/IVSAqmnfQ3BAh2vT64VVbKuqFz6kvc/+hU5dKBi+kk/FTcT3XN
         bVL4urxAc6SQEFHEYGeCxtEzQ22X6Xn9qCRTfXsdQ7Wi8WHovJ0Bp3ESDSy3f1t8i18U
         Ej1hJNhBu722w2bC0ZXsPObSLdyKBvXdQlJrdt/PIxt3t2zswzz9j9smFey2bRXNfvt2
         BdS7kSBS2wqeNx3UZSVP7HogtYkk1dimz5dvgCCYoS8yGp28zsjqRkU/VNRH5fhwTEoE
         Q3/VNhlv7JJcetWcPpa/9wd+PMExQAMFRsbTc9LZ2K/4u+KPBhoFHs1SFkCuYUh5YUfd
         /6QA==
X-Gm-Message-State: AOJu0YytaZzW4eYIUBPpnV9K93JcZNXibXVzsg0eN3c7gjsj/9fMEGQA
	Vtjnzub0mMl5N+SG6IVug5EeXUWPVv9Qg85Gt9ma2B+EVobRgb0J8D03+qUWHaRBSbP9uv6FNrV
	oSQ==
X-Google-Smtp-Source: AGHT+IErZCjgxnW1nA8vfwx3LLzPh3uYWKzk557n5Oly2WUmwS0tLE4X7wX0yLZvbfR26aJy3V98IVQVBqk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:a8a:0:b0:dc2:5457:ae60 with SMTP id
 h10-20020a5b0a8a000000b00dc25457ae60mr12143ybq.1.1706120687620; Wed, 24 Jan
 2024 10:24:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 24 Jan 2024 10:24:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240124182444.2598714-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Notes - 2024.01.24 - Memtypes for non-coherent DMA
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>, Kevin Tian <kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"

Recording and slides:

  https://drive.google.com/corp/drive/folders/18QbkitOXcZyYXpT558wXf9Hs-rQs8mhX?resourcekey=0-qOuxyhLUBUGlCwHrzPqAkQ

Key Takeways:

 - Intel CPU<->CPU accesses are coherent for guest WC/UC accesses, so KVM can
   honor guest PAT for all VMs without putting the host or guest at risk.  I.e.
   KVM x86 doesn't need new uAPI, we can simply delete the IPAT code.

 - Intel CPUs need an SFENCE after VM-Exit, but there's already an smp_mb()
   buried in srcu_read_lock(), and KVM uses SRCU to protect memslots, i.e. an
   SFENCE is guaranteed before KVM (or userspace) will access guest memory after
   VM-Exit.  TODO: add and use smp_mb__after_srcu_read_lock() to pair with
   smp_mb__after_srcu_read_unlock() and document the need for a barrier on Intel.

 - IOMMU (via VFIO/IOMMUFD) mappings need cache flush operations on map() and
   unmap() to prevent the guest from using non-coherent DMA to read stale data
   on x86 (and likely other architectures).

 - ARM's architecture doesn't guarantee coherency for mismatched memtypes, so
   KVM still needs to figure out a solution for ARM, and possibly RISC-V as
   well.  But for CPU<->CPU access, KVM guarantees host safety, just not
   functional correctness for the guest, i.e. finding a solution can likely be
   deferred until a use case comes along.

 - CPU<->Device coherency on ARM is messy and needs further discussion.
 
 - GPU drivers flush caches when mapping and unmapping buffers, so the existing
   virtio GPU use case is ok (though ideally it would be ported to use IOMMUFD's
   mediated device support).

 - Virtio GPU guest drivers are responsible for using CLFLUSH{OPT} instead of
   WBVIND (which is intercept and ignored by KVM).

 - KVM x86's support for virtualizing MTRRs on Intel CPUs can also be dropped
   (it was effectively a workaround for ignoring guest PAT).


