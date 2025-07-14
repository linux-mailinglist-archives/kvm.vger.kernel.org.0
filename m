Return-Path: <kvm+bounces-52337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C03B04220
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 989DC1A65237
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842492580F1;
	Mon, 14 Jul 2025 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A8zwmoSi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDCD1EC014
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504515; cv=none; b=eFKQc0+KoT8u7A99BnKjQcLDfKOCKuDF43V+piqRd5mPsNEzj8NhKOULOSAvQxRAY5ry2hSdHAyOULF9HejSDYSvrKLZb/46ILH1cLHDnmwv5z/fo5QIlK1hHg/xOcI/ExF9eJV6eQTMkd2RdRKT23gmEpHpHIvZRNzTV7CBSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504515; c=relaxed/simple;
	bh=t5xT/7u2I0KWv6mcF8qRo1MV6ot0YPcIa5BfRLGUdYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cE2hMuX/u6cJy9sXaxP2zXo+SYAZWCP+lF1mIEmSZeI0z5i2LKEtRFFjq9Qc6X0ztLHOoa6SIdn9YNBMfuu6Dhz28m1NZ1sTHUMje3M5HcOM/7RX27EakNn5e3CMe3qRywo0jsP9oWE9S06qsGgCuWerxj9nP+3tQO/UvQHx3R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A8zwmoSi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3122368d82bso6664404a91.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 07:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752504514; x=1753109314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5xT/7u2I0KWv6mcF8qRo1MV6ot0YPcIa5BfRLGUdYs=;
        b=A8zwmoSiuHBdHD6sR4jKEiDZOXX3NABvv3sQxJfrpMwLiyo0ZNeXOXvtt69Go5/Nqz
         2biVa9fO8WzF4TXu7+3iZnAFugWhGXV/g5/vRDu17wcJ6NSuYlmonDM8iqeaU0GZQ5rs
         mhU3+S7+ZS5L8d7GTUsEf5LcDqghWIlxSYmvcfG2FNqKgVfHsorc0W+AAXL0celXgq7i
         /43NI54iR9o5KfnmGLg5NI3Fgq6ovLgG7gblriseF4aHSr+Vuf6H+8d4kyDMkoBwYHw5
         YkbefX7sQlI9vsxYuvK+B3z+BTPU/CKpCT+wN+BkCCY4HZp5+ifcNWnK17N1gkKgY22B
         f/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752504514; x=1753109314;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t5xT/7u2I0KWv6mcF8qRo1MV6ot0YPcIa5BfRLGUdYs=;
        b=DcBAel13OTWnhpVo6i/AfjdTT7gXFggiYheufRzQfkITBmGbFXy9x5aSrmc/jKtlJq
         TzbrShWYJSJHOTnBWr1OalI8vI2exfZVYiX/KLhfaTh6tQIzqdGtEA53NefFzZFm47fI
         gj3VlY/OOmkewkmM1t1b8NuJMu50Q2TF9wlcER4uC8pVkqsNy8ubcE5uXMKNC1iw7MtZ
         wunNqcpv8CzUew3xehFcUSGCwi24iPm9slKaVJGM/V4HHfJ8mDzyufkKDoM0z+alIrjR
         BdqryuM7KsTT84WGzXVY42u/YAgYa+j5HsfZRn8KIO6+kts0c3VklaxqRbpYLaqBZmzZ
         ER3g==
X-Forwarded-Encrypted: i=1; AJvYcCUNxh9Ypa/IkFjoWohejQHvULlV7GEyqc+X7lYkKrmvDkrvBi44kvzsM94JWFkpHssOKoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO4YSx+4WNETXgw5cHLwh6OmD9W91M7rLJv0FL4HqzT/RV3vvX
	lcSrwwVBWGH835sblCQKVwU+9NVcpcB9rSYb3RfrGTK/47yuHXhn2LV8BGXyMyegtEIYKTM6jHh
	nr5zUrg==
X-Google-Smtp-Source: AGHT+IECMjh/eKobtUekoMFvEQ1vDM7Y9ahRR2DZwaxk2esMAUua5vrlnPLNde4YHZLst0k/hh605QQVyM8=
X-Received: from pjee15.prod.google.com ([2002:a17:90b:578f:b0:31c:4c97:bf9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4988:b0:311:a314:c2cf
 with SMTP id 98e67ed59e1d1-31c4cd0fa3dmr19918037a91.30.1752504513798; Mon, 14
 Jul 2025 07:48:33 -0700 (PDT)
Date: Mon, 14 Jul 2025 07:48:32 -0700
In-Reply-To: <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com> <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
Message-ID: <aHUYwCNDWlsar3qk@google.com>
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Srikanth Aithal <sraithal@amd.com>, linux-next@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025, Zheyun Shen wrote:
> Hi Aithal,
> I can reproduce this issue in my environment, and I will try to resolve i=
t as
> soon as possible.

Phew, that's good, because I can't repro this, and I don't see anything obv=
iously
wrong.

> > 2025=E5=B9=B47=E6=9C=8814=E6=97=A5 13:21=EF=BC=8CAithal, Srikanth <srai=
thal@amd.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > Hello,
> >=20
> > While running the kselftest for SEV migration (sev_migrate_tes) on
> > linux-next (6.16.0-rc5-next-20250711, commit a62b7a37e6) on an AMD-base=
d
> > paltforms [Milan,Genoa,Turin], I encountered below kernel crash while
> > running kvm kselftests:
> >=20
> > [ 714.008402] BUG: kernel NULL pointer dereference, address: 0000000000=
000000
> > [ 714.015363] #PF: supervisor read access in kernel mode
> > [ 714.020504] #PF: error_code(0x0000) - not-present page
> > [ 714.025643] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
> > [ 714.031303] Oops: Oops: 0000 [#1] SMP NOPTI
> > [ 714.035487] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Not taint=
ed 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 PREEMPT(voluntary)
> > [ 714.048253] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.1=
7.0 12/04/2024
> > [ 714.055905] RIP: 0010:_find_first_bit+0x1d/0x40

..

> > [ 714.148307] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
> > [ 714.153544] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
> > [ 714.159115] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
> > [ 714.164817] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
> > [ 714.169896] mmu_notifier_unregister+0x53/0xf0
> > [ 714.174343] kvm_destroy_vm+0x12d/0x2d0 [kvm]
> > [ 714.178727] kvm_vm_stats_release+0x34/0x60 [kvm]
> > [ 714.183459] __fput+0xf2/0x2d0
> > [ 714.186520] fput_close_sync+0x44/0xa0
> > [ 714.190269] __x64_sys_close+0x42/0x80
> > [ 714.194024] x64_sys_call+0x1960/0x2180
> > [ 714.197861] do_syscall_64+0x56/0x1e0
> > [ 714.201530] entry_SYSCALL_64_after_hwframe+0x76/0x7e

