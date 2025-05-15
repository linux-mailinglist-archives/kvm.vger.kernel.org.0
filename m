Return-Path: <kvm+bounces-46733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC564AB921D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 00:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBFA51BC6C5E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA1B28B504;
	Thu, 15 May 2025 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="249Lp/bY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB9A270552
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 22:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747346657; cv=none; b=cWP9XO+94I08LITj1J5w8HH/Ad8GztdOB9SyDaOYo8byc7C+SjbVsB3Q9GckRQakumyXENt62naoOpGNZ2QvDy8iYROS3MHafoKW0owEYUAVhCY58lkkxHY7JW0angy1docm9zv0PHJdYffMtUmW0AEbUx+5kWXfrtRc7WHPxjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747346657; c=relaxed/simple;
	bh=fwldXoroq5XBUEJ0quH7C1UmH9HOLo1mqXHCCdRb9cc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c3Y9ZmFoNPlj6O2RveMKW91k5+FIoev/gnq2LYHYgKCuR3fV+Ojv2OyKUUX7WkZmTy4I0Dx+9GDbieY+UpGnMLe8GW2lWAifTVCJ+YK3blo8Do0Pd6vhcqBAoTdKGSMPyZjBU0EGCZrdZK08noJCG8LMZb9vOPoMEbCLo8nfzC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=249Lp/bY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22fd4e7ea48so13446855ad.3
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747346656; x=1747951456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NL+bcQz8U5Llwby9qZ/g3HOxD9xJ00J+/SoiAzJaZ80=;
        b=249Lp/bYTh9DgmvnQmV+WTSvtEpqWSRYSl2cvs/TQhMxMetA4zgvWUBqFeAxofD5RB
         eX5lbhdfK/5h925ierg+Qy/dHx32vmiEbjrpjGXnDs99STZhlziwp5pi5AVYgVbs/owk
         Dh7ieKaO0sfuAE1FlDqsRiRl4G7kVsAuaXr0CFQJKOdHjLj4JPcB1nLIiejhs8TWb5mz
         EIudnRY2soCLI5V4I4G7O1c90QBHQoxFKmxxR/cUSH+3PJycLRaY+l+7Bzr/qs0viB2B
         5Dx+uVSHJaenUPUtaNtkVoJkmyFY3HfwrEivQmGT9j4Vl1otDl/HrmaNxBfLL44lvFfx
         CNNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747346656; x=1747951456;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NL+bcQz8U5Llwby9qZ/g3HOxD9xJ00J+/SoiAzJaZ80=;
        b=JICpwUBxDLzNawDoI7neE5WdJsxC1vf+wNz3OjmwT0YcgVDuMF1FcpM711app2kv5O
         cuCzjz39fdFCR/sXgG+nUNStsz3bAEH6zdFiwWjQ0VIM2VrsP8uRB5z6oGed7O6TN9D2
         cFDHZmMc1NGvNf/tlXWVpwPKaWzT6s3q0pnSXGHrVPBY0Uaib33dj26p4cpBC47uClbP
         EPJfGe4M4s60WTqzsn/wcqguzvYQz0218cmLk4msEYKk2ZEJfPOFzfpFJUZ8SoOC/0du
         mxSG4cSdgmMVehnjk6CMkxyoUKbfWCq6C8WgBPGl+ekGE3V0/fwNWnYT60nkkLk28LjW
         jngg==
X-Gm-Message-State: AOJu0YwYAPq7/OixSol95S/5KT/3wMLSuvRR3n9uWgOv2IQRHAixB8Vt
	fDUgHTeQ8yn+fy9xEypbOA6uwoTCMwahKzYWj+5vmbWlDcJBufk7PO9u5k8A9kb0yboOdT+83IR
	dqY2M8YCsIQouBu+/YkFZVUmUbxeHAj+neXogxcSCAIEku6SBr/83E21egeSgS5kqdf78o6PdDQ
	x6C5XSD9RyVv8arVOzGCsibDid2Zn5+50BFFu4oZSJ75Om6ucIAggpzyGx4ec=
X-Google-Smtp-Source: AGHT+IG/Mw7qmj3Mxbl76BVdTruv+BrUfU87J4WKFPJAAHk/FfhcnDpLwk4Q9Zzdf5/4KmQMj3JGw2Mx0UiqJxmNNg==
X-Received: from plgi15.prod.google.com ([2002:a17:902:cf0f:b0:223:294f:455a])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e5ca:b0:223:f9a4:3f9c with SMTP id d9443c01a7336-231d43d5526mr11709575ad.9.1747346655484;
 Thu, 15 May 2025 15:04:15 -0700 (PDT)
Date: Thu, 15 May 2025 22:03:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250515220400.1096945-1-dionnaglaze@google.com>
Subject: [PATCH v5 0/2] kvm: sev: Add SNP guest request throttling
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"

The GHCB specification recommends that SNP guest requests should be
rate limited. Add a command to permit the VMM to set the rate limit
on a per-VM scale.

The AMD-SP is a global resource that must be shared across VMs, so
its time should be multiplexed across VMs fairly. It is the
responsibility of the VMM to ensure all SEV-SNP VMs have a rate limit
set such that the collective set of VMs on the machine have a rate of
access that does not exceed the device's capacity.

The sev-guest device already respects the SNP_GUEST_VMM_ERR_BUSY
result code, so utilize that result to cause the guest to retry after
waiting momentarily.

Changes since v4:
  * Fixed build failure caused by rebase.
  * Added ratelimit.h include.
  * Added rate bounds checking to stay within ratelimit types.
Changes since v3:
  * Rebased on master, changed module parameter to mem_enc_ioctl
    command. Changed commit descriptions. Much time has passed.
Changes since v2:
  * Rebased on v7, changed "we" wording to passive voice.
Changes since v1:
  * Added missing Ccs to patches.

Dionna Glaze (2):
  kvm: sev: Add SEV-SNP guest request throttling
  kvm: sev: If ccp is busy, report busy to guest

 .../virt/kvm/x86/amd-memory-encryption.rst    | 23 +++++++++++
 arch/x86/include/uapi/asm/kvm.h               |  7 ++++
 arch/x86/kvm/svm/sev.c                        | 38 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        |  3 ++
 4 files changed, 71 insertions(+)

-- 
2.49.0.1101.gccaa498523-goog


