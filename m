Return-Path: <kvm+bounces-55205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1789B2E6AC
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90307567546
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 20:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9419D2D3EDE;
	Wed, 20 Aug 2025 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fffWNqU/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312102D3217
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 20:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755721880; cv=none; b=s/nFsCbUvr5hz61dZXRLlAU26vKwibW5OSWkT7sKOL96ztS4W+AkNTOdBvC54L3FtrV2HtXyd8ekzRbdz2qG9F36qB798Sx6sT3rwbrmBlVQDe+BsexG5p1oNWmREDrBY7E1ldKMa5gReiYl7UGf5vfAXdsovHEHpEzTvLScj7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755721880; c=relaxed/simple;
	bh=p0wORNFPcgtTIQruWF7qHHMAgbrx3h1utzh60JxPzXU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hsYndRMOw9qKdc6WQSHZj007bWJTzn8hTYzcZ6sJwweNpb2OmYhBdgTkZgP5+RaUXqCFMSFbdpdJ00Yn57Z+G6uqnVYdzbJqfwIpEsHqsUiM1OVr3oE8EgpwLBbBgIo1Z2UgFx/ISCAL1nQCj2bHyqTn29+Sd83+Yu1ZGQuqE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fffWNqU/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so1402195e9.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 13:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755721877; x=1756326677; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3peP7Zh3maJKyMPmiApr5AT5nQviFK0IHw+wb9yUIYE=;
        b=fffWNqU/lZF8wsF9QxMBtVEVAt5DtiTY8HEgqohfgwBBUoc6PQhYMCa/uZM68KhUTX
         lvUwSNTRDwjQK6+urzjdGqdwGrpmxKVbomRmiIa6qit3kG6+muPlEYOcgDcR330Wz9PE
         +OnJGG9cwP8VBg+cRLVTLhPMGSqfIWNaIutTFaw/yYQzJJpr0HQ2qX5rnC2b1rp/p41k
         /Imtzjcj+k0L+Xc92VvWLHNVaNSubu6Z51KG5N37YOWYnqlbjlmuTfLndUcxGENNVd0T
         6r5nx7/DNUtromhPRJy3ikVcI6v83ikHndRgyNFjOJb393YeF/3kWQriDm2s9iYJy5Pi
         1jaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755721877; x=1756326677;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3peP7Zh3maJKyMPmiApr5AT5nQviFK0IHw+wb9yUIYE=;
        b=SlBvg7LA489SlXe/hvL5G4yLkPhDBD5qVOMDGiM0tfOhLlDBtLoHjQMQ4ev3oeWuUi
         KPVLM7jNmYfaW/8A+ZHze5JyXuIYeHP3gzVidPzDlLlLErPUrPJxrHfGQKpfwaerwjmO
         UVHZS/iuWeQOWBcUiqjD3cQKeuxjIWNpFcIIYA8ZXrMhjng/TBx5HVWzF5HLMsWTfvZr
         C+ABlWufCvzElwAk0bmg2Ac6KWg1qQBFIzE9bEWvBgV0JjdE4oTo5MurXYNzGdmXyjPR
         IYFj71fCMyz5fJtTDX8RYktGGSm7HHr4Qz07UfDN2t58WVpBxc0tCbsdrVv8IU2LMcr/
         s1hw==
X-Forwarded-Encrypted: i=1; AJvYcCWH71JeIaCR/UsF2E8UGCqrta1ikQN5ST9mu/BTXp38V7PL1xLDGFp94JIaNtN02OWq3OA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBLh1XuT1a95hnhSCZsIq48gL/NWTp6vy8x8QfZb+E8kSwChR9
	isECtgeiLJkpSKTPfLQ7P8Ir4tama0ASpRmPpRN/nYrjpsg3cfuLYGbswVOzvdIdElf3b0fUfcw
	XutSitqwy6724SA==
X-Google-Smtp-Source: AGHT+IGmqi5rV6a1OH5BcnYXAGtTlTBZLJEb+z2OAuoaeMEryJb7aYQaoZO8+FHe09EcsPRvT30MEssnfppJuA==
X-Received: from wmbdy22.prod.google.com ([2002:a05:600c:6596:b0:459:dc99:51e4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d1e:b0:458:bbed:a81a with SMTP id 5b1f17b1804b1-45b479ab128mr37375585e9.10.1755721877594;
 Wed, 20 Aug 2025 13:31:17 -0700 (PDT)
Date: Wed, 20 Aug 2025 20:31:02 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250820203102.2034333-1-smostafa@google.com>
Subject: [PATCH] MAINTAINERS: Add myself as VFIO-platform reviewer
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, clg@redhat.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Based on discussion:
https://lore.kernel.org/kvm/20250806170314.3768750-3-alex.williamson@redhat.com/

I will start looking into adding support for modern HW and more
features to VFIO-platform.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index daf520a13bdf..840da132c835 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26463,6 +26463,7 @@ F:	drivers/vfio/pci/pds/
 
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
+R:	Mostafa Saleh <smostafa@google.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


