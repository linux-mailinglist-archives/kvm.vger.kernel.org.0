Return-Path: <kvm+bounces-36363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F080A1A58C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92E2F3A48F4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7AF211489;
	Thu, 23 Jan 2025 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ZIK1Ee7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2520F98A
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737641680; cv=none; b=MJ3fD+hnQC0rZ6ont3wwpr56zsSJV9DBqYDrXHpZWs2Kq8baT2OHeBxblX9cAuBOr1oDDLGzL8C14G/WKspZppw2NGOBfWL6uyKqyjPvVBiY9edcGz/yU76YqlJD+WSaxmzhakbz6erWJtzy/xR7r3JmC58GiXLp2RK4vm/Ch7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737641680; c=relaxed/simple;
	bh=pyocaIgYW6FpWJ+hgCKaAhp4a9SJ7ESIw0XECJtAsEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnZALjKLaglYT/TyIS0K9BeHRLEvx3r98CT5tsNw6SApl+P1IjmYZiCYhOelkluJ0/7HY0KZsxBnQIC/GwD0DZVvPBfHgIQNodENJzHfzml2Y8ylBc5bQeXZ6BnHX1IWjQL6UcRDxBm6PNF9nSRqF3l27gxN/dunUFcNzj3DRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ZIK1Ee7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso2045888a91.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 06:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737641678; x=1738246478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0LnQnwU5g3fWpCDush3MJhvn8IZIebEPkRKB2Sj6qI=;
        b=1ZIK1Ee7LX1iIt2CUwpBC5YvT9E7dUAHqFtSxZVL2MFfllq2xxT1PCwXLzwAO8Lv/l
         BnrBS2+Dc9is9+iT8zWCkYDxM0t8M7WkHKu7KE4ObzQihycsZXOTEVwWpelXaDChtiO8
         /DAWiN2YlHO8JJXXVs3EvAULS19o28Q2nTsn0KkMCMwFFwBpWdDqe0IYj/HMdkNe+xE7
         sJMH/0+GuqEMNrVdEj22H2wnauXK6J/WcM/4y1ih1HvSWxAR8a6Cd+O+0G7pBBQ2IZCs
         3bSQVur0cKlN/PnwyVA0kLquFKDxVbm8JOtTGtxaGeV2AzngUIZ+St7MikMqHPloWbc0
         iVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737641678; x=1738246478;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j0LnQnwU5g3fWpCDush3MJhvn8IZIebEPkRKB2Sj6qI=;
        b=VF9+heEQk2gfgVRIQYyZ3rn79M6zqkabpWR8IMB1FuBro8/3NmmBR1HrASkU3WJYUR
         D8VtwCKxGRiKK3rkCW85OCqufUk4GJSN7noyX+WPI0TQkNPKOjDdyfLzexjpVZ76By2u
         05wZ51Mdbct2jTYdftVpLShDYZmhsUN1IfvMTiIepcX/63BKmm5VGK8dkyu+RCn0sZQ3
         nCr9XlmuA6jrwPbdywClFszd/wYIbd9zb2D1YKCLv/2AHtH6QbHEV4sZ3FnE8eS+/wg5
         dAj7lADkIGvnM8BiZP6czjpGB6VqvgodGCv46ExSjGkTflbgXxuelXYEnBB4Mze7ojbY
         K98w==
X-Forwarded-Encrypted: i=1; AJvYcCWWOxefl26ZvBMBP2GGFyUOtjqPc3nEmmn7b2UvcJJubYgVPfSPxXBN6D6MH33B2HcJCV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6+AVPfOk7xMOw7tdONv7n6gtbBBF6EFKJCTXB7ZiSdZj+2D8G
	au2nYwyZuCpHUdQ35veUspM4GhDDgbPHU5PFsBMPq6x8dg43hAddl2Ve/TMvbIhwKkbSm6WGYdp
	nfA==
X-Google-Smtp-Source: AGHT+IFpM4hIat+w0vlPn02jx2qvqmsdm14k20gXhYjzbm1EqG62SVufDxICymLNqoCdrH4u2c2rjn12hZY=
X-Received: from pfwy10.prod.google.com ([2002:a05:6a00:1c8a:b0:72d:7bb4:ffc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:21ca:b0:727:3fd5:b530
 with SMTP id d2e1a72fcca58-72dafb36d75mr34870853b3a.15.1737641677931; Thu, 23
 Jan 2025 06:14:37 -0800 (PST)
Date: Thu, 23 Jan 2025 06:14:36 -0800
In-Reply-To: <b8973c88-ca7d-4f23-bf54-aee0a8bb4c5e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b8973c88-ca7d-4f23-bf54-aee0a8bb4c5e@amd.com>
Message-ID: <Z5JOzFv_Us-3jLr4@google.com>
Subject: Re: next-20250121: kvm selftests: RIP: 0010:__kmalloc_node_noprof+0xff/0x490
From: Sean Christopherson <seanjc@google.com>
To: Srikanth Aithal <sraithal@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-next@vger.kernel.org, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025, Srikanth Aithal wrote:
> Hello all,
>=20
> While running kvm selftests on AMD EPYC platform with 6.13.0-next-2025012=
1
> below general protection fault is being hit.
>=20
> /Jan 22 00:45:35 kernel: Oops: general protection fault, probably for
> non-canonical address 0xe659260b3c31e5e0: 0000 [#1] PREEMPT SMP NOPTI
> Jan 22 00:45:35 kernel: CPU: 113 UID: 0 PID: 143333 Comm: memslot_perf_te
> Not tainted 6.13.0-next-20250121-f066b5a6c7-98baed10f3f #1
> Jan 22 00:45:35 kernel: Hardware name: Dell Inc. PowerEdge R6515/07PXPY,
> BIOS 2.14.1 12/17/2023
> Jan 22 00:45:35 kernel: RIP: 0010:__kmalloc_node_noprof+0xff/0x490
> Jan 22 00:45:35 kernel: Code: 0f 84 0b 01 00 00 84 c9 0f 85 03 01 00 00 4=
1
> 83 fb ff 0f 85 e9 00 00 00 41 bb ff ff ff ff 41 8b 44 24 28 49 8b 34 24 4=
8
> 01 f8 <48> 8b 18 48 89 c1 49 33 9c 24 b8 00 00 00 48 89 f8 48 0f c9 48 31
> Jan 22 00:45:35 kernel: RSP: 0018:ffffa77176403ab0 EFLAGS: 00010282
> Jan 22 00:45:35 kernel: RAX: e659260b3c31e5e0 RBX: ffffed7142251180 RCX:
> 0000000000000000
> Jan 22 00:45:35 kernel: RDX: 0000000003106071 RSI: 000000000003b080 RDI:
> e659260b3c31e5e0
> Jan 22 00:45:35 kernel: RBP: ffffa77176403b10 R08: 0000000000000000 R09:
> ffffa771c9605000
> Jan 22 00:45:35 kernel: R10: ffffa77176403b28 R11: 00000000ffffffff R12:
> ffff92a240044400
> Jan 22 00:45:35 kernel: R13: 0000000000000008 R14: 00000000ffffffff R15:
> 0000000000000dc0
> Jan 22 00:45:35 kernel: FS:=C2=A0 00007f91abd0d740(0000)
> GS:ffff92e13e880000(0000) knlGS:0000000000000000
> Jan 22 00:45:35 kernel: CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000800=
50033
> Jan 22 00:45:35 kernel: CR2: 000000002346c3c8 CR3: 000000223fbb6004 CR4:
> 0000000000770ef0
> Jan 22 00:45:35 kernel: PKRU: 55555554
> Jan 22 00:45:35 kernel: Call Trace:
> Jan 22 00:45:35 kernel: <TASK>
> Jan 22 00:45:35 kernel: ? show_regs+0x6d/0x80
> Jan 22 00:45:35 kernel: ? die_addr+0x3c/0xa0
> Jan 22 00:45:35 kernel: ? exc_general_protection+0x248/0x470
> Jan 22 00:45:35 kernel: ? asm_exc_general_protection+0x2b/0x30
> Jan 22 00:45:35 kernel: ? __kmalloc_node_noprof+0xff/0x490
> Jan 22 00:45:35 kernel: ? srso_alias_return_thunk+0x5/0xfbef5
> Jan 22 00:45:35 kernel: ? __get_vm_area_node+0xd2/0x140
> Jan 22 00:45:35 kernel: ? __vmalloc_node_range_noprof+0x2ec/0x7f0
> Jan 22 00:45:35 kernel: __vmalloc_node_range_noprof+0x2ec/0x7f0
> Jan 22 00:45:35 kernel: ? __vmalloc_node_range_noprof+0x2ec/0x7f0
> Jan 22 00:45:35 kernel: ? __vcalloc_noprof+0x26/0x40
> Jan 22 00:45:35 kernel: __vmalloc_noprof+0x4d/0x60
> Jan 22 00:45:35 kernel: ? __vcalloc_noprof+0x26/0x40
> Jan 22 00:45:35 kernel: __vcalloc_noprof+0x26/0x40
> Jan 22 00:45:35 kernel: kvm_arch_prepare_memory_region+0x13f/0x300 [kvm]

..

> _Recreate steps:_
>=20
> 1. Build and Install next-20250121 kernel with attached kernel_config.
>=20
> 2. Build and run selftests/kvm component from linux next-20250121 tree
>=20
> Issue currently seem to be hit intermittently, I am trying to find more
> reliable recreations steps, meantime wanted to post the issue here for
> awareness/getting any pointers.

I would be surprised if this has anything to do with KVM, KVM is simply doi=
ng a
vcalloc(), and it's not even a particularly large allocation for this test.

What code does "__kmalloc_node_noprof+0xff/0x490" correspond to?  Without t=
hat
info, you're unlikely to get any help/ideas.

