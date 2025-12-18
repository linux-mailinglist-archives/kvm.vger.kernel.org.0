Return-Path: <kvm+bounces-66288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A751CCDED9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 00:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10E303021076
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 23:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C7B29B764;
	Thu, 18 Dec 2025 23:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pa760Jq9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A40427CB0A
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 23:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100383; cv=none; b=oDEcv1wHxhTQF8ESDfn/ekkh+FBg+xg5nQ4krg0VDcpzmOqWWnAbl7j0o0HdS5h800MZpawUd2/jyGn0DQSdSsKOldSdb56e5L601KEEd1l8C7GLVkqtrjuPTH9OfoOn2tnuuLD8/8iSGFsG/3ct9QHx1LXDVX1mmrSFj2DPSwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100383; c=relaxed/simple;
	bh=nrkH33md9Uh/+4ELuOvMD34iO1UVnhT+kokb2/ghZ10=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=O7IcU70B/MJgtpGqthtYn0sLMzmZayaE1GgFHFlpbS3BVSzJCLjknAdgoheHjGyb6zb6uauujEt7nu334YlGFIheuj70exJ3ob2jHsVq+IEexnwXzVPqi+Is1lzMd75LZ1VQAG59eK+72V+VpWKlmOui8F5Hjfo2M9fk144kbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pa760Jq9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso1863823a91.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 15:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766100381; x=1766705181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtdzkNFDhIT6wDxc4nRmWBa6a7kI4sVDVdNUoEN1Vqo=;
        b=Pa760Jq98nGvOvlgnr+WOnNoiXHNiG7im13nkU8vgUcy8/Aoc+iKoVDnb0o2ExUtfB
         UXxeUEoZbjneqs0vSC8uYod3ZPcCm/3TysC6gxtmmIxNWkFT0A8UnIsLx+c+OXrn+q+0
         9Vx8OeOITg1mrfnbtdo4XwrqMpYD2mIR7w/iNm/Bo8Sjm1oYqFKNOZpuJ3Dt9vqrnIF4
         n8Ym0/fwYsMeKiAbEp/eoR5V0HRfrLNMQuXlJqMrollXwF057x80h1lvfYgTKzu+F6V/
         2qDqsE5rCwa2P0WZo4SaBWZNkkyCymz1/9zvpBQuTS18tu2MPhOWbRZsOycMy4AzZfth
         Rc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766100381; x=1766705181;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PtdzkNFDhIT6wDxc4nRmWBa6a7kI4sVDVdNUoEN1Vqo=;
        b=bPdcXvBPXNiPd8nBWb3qBSCtzeiduCEy0SQ2LpjpDhhvVuSFLYQmXGY3qCGZQC3AJ6
         eNyVqMp16W3xQ5ZTBNrZr8QewYcUh9g6FkvgZyQ6gRrPZUSsu8OLdIXjMNwCtbTv/ZAH
         02NxmbuOFN+fSyHVdckZNpwjG+C/6Z0/WIsrVJ0uxkQOQUwc0/vqcKDmTay4TxhMUVss
         PzFmLtSB31jMt0J/Dg6hMSrtexp4LvwcX9pgxHi+tl2fYy/qq7Yvsz9OWw1BBSRFVL5D
         RyVKUDrVHbmUdYfoRRP5LO781UZyOypGjaHNHb87xX2zHa8M5OcN3Ggy6UKkQgVbb21W
         mMYA==
X-Gm-Message-State: AOJu0YziRLDFBasVoYbjJ6zDJL2B0pQrlc6UYLUZDY/1l0Lc2pJbdEiA
	PTsERX1bgpNjKW2xhn2SZX5VsEM2od7oGqNA0R0hj4ra20pF3D6CmkhguilIbbT4sq928LWsB+k
	hUUAjgQ==
X-Google-Smtp-Source: AGHT+IEO8efO0gYNdnovfKVVYgaDR96dnDP6DemDcaarlpwxa1rv4M9gTMGzd+jeqwwbZ4XEiDgxSGIqoWM=
X-Received: from pjud2.prod.google.com ([2002:a17:90a:cd02:b0:34c:cb46:dad7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f47:b0:34c:3501:d118
 with SMTP id 98e67ed59e1d1-34e9211d455mr798895a91.1.1766100381497; Thu, 18
 Dec 2025 15:26:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Dec 2025 15:26:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251218232618.2504147-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/cstart: Delete "local" version of
 save_id() to fix x2APIC SMP bug
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Delete cstart.S's version of save_id() to play nice with 32-bit SMP tests
on CPUs that support x2APIC.  The local version assumes xAPIC mode and so
depending on the underlying "hardware" (e.g. AVIC vs. APICv vs. emulated,
and with or without KVM_X86_QUIRK_LAPIC_MMIO_HOLE), may mark the wrong CPU
as being online.

Fixes: 0991c0ea ("x86: fix APs with APIC ID more that 255 not showing in id_map")
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cstart.S | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index dafb330d..49ba4818 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -84,13 +84,6 @@ prepare_32:
 
 smp_stacktop:	.long stacktop - per_cpu_size
 
-save_id:
-	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-	movl (%eax), %eax
-	shrl $24, %eax
-	lock btsl %eax, online_cpus
-	retl
-
 ap_start32:
 	setup_segments
 	mov $-per_cpu_size, %esp

base-commit: 31d91f5c9b7546471b729491664b05c933d64a7a
-- 
2.52.0.322.g1dd061c0dc-goog


