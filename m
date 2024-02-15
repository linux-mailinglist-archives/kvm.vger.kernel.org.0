Return-Path: <kvm+bounces-8836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D9D857203
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C37A71C226A0
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6047A14601F;
	Thu, 15 Feb 2024 23:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsSflqiJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C50145FF0
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041256; cv=none; b=qpQlVB0QQEB/XgngW6KhM1OmNXbmW+sEW3TUzKZi2DhBWTiC70rhJ0O6UFRwQU0kI/oXHrHSTNi6QhVMQPqNEs7wO6dDwfCPA1VCKkAIOWg7pY3xX5Lc2ieKSCF7ReBs7zITuQDzqb/iw3BN3QLxZNbZbV6WB0dkGwxIqP/j9NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041256; c=relaxed/simple;
	bh=OMyN7fHzEfLgoBye4T8ZSNiYVwuoMrC6dnIEAZg3ngg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YSamIkAZB+r2D6AJ+IdNoc3h8+3wVgb/d+vOZaEItFqgenKQFJGTZfal7ZFC3/QEIgA1JGEahRWubZF/A6tsyaBI25DOVLcqqhf2P8W8Hz8uA9CoWMWKMwHD8y2ZXPqx8F60cv9X+kOh8VGYlJpWIArQ9z+nt3JbZer4r/FMoh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsSflqiJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc15b03287so2043909276.3
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041254; x=1708646054; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jBD0v9lfe/Rw/ET2I01vheD5aGv2zWzm/5LdmhbgJC4=;
        b=jsSflqiJGSC6ps15oKMCnGRb+vWgLzNEJVqlcvbd4s455JGS3nt7dwCGe3w+nGbWLl
         aOCCZg5ZtKMlph2MoJFVPs+Ehl1oc9t4NB9kgvroh+gz5cQdpX/KPTptcvRPNcKRFGzM
         /FtjwgV5g0iaCoIFSyx/ImGZkX3UEEXEuW5g+hjcNbnDJb6puakIgtVKSdVYTlNhwSsr
         ItrSoBw+ebGTg8DCasLDuf9/AUaoSb21FekVFK63luPmZelxtvjo8DS+MiCX6CjBczyd
         /GO26OhxX0xocKAYzFRuLK+F9frUXj1Bon9cA4KAymnLFTq+IgNHPvx2u6iOCDO8YRng
         hgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041254; x=1708646054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBD0v9lfe/Rw/ET2I01vheD5aGv2zWzm/5LdmhbgJC4=;
        b=WGIRh4NcpUUv9HYKHOp0pcDNM00JaOfZqT/PiZZtGZJwEaAqKL8q8R6N2MmOAx47c5
         FedaxTOnHT7kc7pHauMJYmSpRazBuJ/LlPO08H3r9FkQ5SGbp+ZJGti93X9yKaP79Bld
         sED9TXMjCv7sFCIQa0rTStvJi/vwxBvUiIt+SQqkGJlWrrqgvWCe2kDSCkZ1dyldxNLa
         sCGkLqQXzZmndCPlnQHwkqdc4zwO2SmLjY9vFSKIlD++1khH58HfZRmsWUFz6kthR1Gf
         Rfm2Tv6ILZqfJMe3hStm04ibM6fROu2WJhttAkDFnpQsBtOJ/CWL0bCintIWi/m0fdJ1
         hINw==
X-Forwarded-Encrypted: i=1; AJvYcCXYgZQkAeh+CfWc3qa30x3h3vJGa3TPcD+pYcEsOD/bwQHmcPrxO4aHxZ7vi7at868INS4WsEuyGAoYCEPT+oFmGvm/
X-Gm-Message-State: AOJu0Yz3fLeA2DL8YaAIoXiXAzKDGjkwo2zpsAHy2QsZkUzt+tDHjsbc
	bGu4F7dHinesQ7HOHxxiZYEDv5+0+fD9d/SYtu44m+4TUGLlT+8Q8Ot5oLdWDGxCIAJLo19tDGg
	4UV1fyRRx0g==
X-Google-Smtp-Source: AGHT+IFG6eQ7U1pvB32UpE/Y9o390fzwKxrTI+bmqgzS9btoriiRyB8NESOhZyB5uyLvr3E+n4pE3rTBJf6EHA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:d47:b0:dcb:611c:9055 with SMTP
 id cs7-20020a0569020d4700b00dcb611c9055mr129053ybb.5.1708041254107; Thu, 15
 Feb 2024 15:54:14 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:54 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-4-amoorthy@google.com>
Subject: [PATCH v7 03/14] KVM: Documentation: Make note of the
 KVM_MEM_GUEST_MEMFD memslot flag
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The documentation for KVM_SET_USER_MEMORY_REGION2 describes what the
flag does, but the flag itself is absent from where the other memslot
flags are listed. Add it.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3ec0b7a455a0..8f75fca2294e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1352,6 +1352,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1382,12 +1383,16 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports three flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
+incompatible with KVM_SET_USER_MEMORY_REGION.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
-- 
2.44.0.rc0.258.g7320e95886-goog


