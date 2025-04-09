Return-Path: <kvm+bounces-43036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E8DA834DC
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 01:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 008D7447827
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 23:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B559E21D3E1;
	Wed,  9 Apr 2025 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1KtXU583"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5819004A
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744242982; cv=none; b=b0Th87SCVS01HOsEaAorXbBRud+qLcYrpzuergNh/4zJqQKniWxZ6E7VckDXTZcWJ9dEBj162zf9+rg8eIUcGcTi3JJWW8FJQghkxxpZdXTwqlVmYsAc3A0P7uoaPrkwHtkcpNVqE+asbRjBzxSVhFa2Y+s2lkvuUsEND5Izrr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744242982; c=relaxed/simple;
	bh=y+yyXocDaiOTuOzMi+TszJ7pL3PGPglAn/e/y7Ue3mU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fL1rTaRUCDcoPnAI/p1coufesVstRdHgP4oPlOgE5MpWSpXomvfh7TVxp4kw9LmtQaaiUY23+Mx05WkMFaHF2CvNfQHunPhgD1Zkb565Z4zV9FggP0UjG8WK46zoui1xLOzTmYDVeE7hHxjpgEoyGkKglNpVZcb120B635sxyOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1KtXU583; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-306e5d9c9a6so348044a91.1
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 16:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744242979; x=1744847779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkeFSOiqw/7aJ+qIzL1zuWuYp4ehBX48C6LDBcHbjyg=;
        b=1KtXU583140dgJOFtVeI/cuY/STbyJdNyZvCppOgc/pgaXTPFVzyz6tjR/U6Z1WNKK
         f41OogcgyuHWlOAchHTZ+q1bNC3TmT3VaV0i2c4C+eNmJ6WGj1Fg6a++5yEw4kYJ1/25
         koRxe0lcobiAyCjGuVHWpA95/S0HGQiU46aMuuMyzZAeA2cMHgmP+jE5joMGjJl0IK4f
         cTU8OnNceHIzP1FuWs7zNiK88u5mzib/k7xK3xJDRMrp92MsQBnRAIiB1VYEzNix/5X5
         T9SNF8RfNk9Q8cODVZdow2LoSVCmUoO5X3ySXPbsDCKsCePK2sbmK5bRZixNYQsIzq3M
         2waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744242979; x=1744847779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkeFSOiqw/7aJ+qIzL1zuWuYp4ehBX48C6LDBcHbjyg=;
        b=KdeOVrdGs8BC//g37FGdNp88fXs1IUM1YeLmgUMr5hd4QNK729pt01Bl7iER56r2IJ
         cJEuJrwdH4dNEAmRFv0kqMHrTAs7d8J/0Z/V5f71ILw8v/ZoAY+5shyAaX73QULX5Utq
         paJoC8fyU4y9Wk9CNMhiuIn3V5MtUhx7OR70G0W751nDPR9tvn2KcIDeMcbdd6VrHhhU
         a/TuAT54pCdY/tAHsrl4+svcMkHkRmncLRRHFT3KvTXWQURBpWf7a79+fBD5k5MTKnwR
         GGoTJ2HjcN2zFTTo2ygevVQZRh9h+74IJTcvpVbsxJoGpu8MtyoOqNXNnGgazalYKU9x
         BueQ==
X-Gm-Message-State: AOJu0YyRAstd8aDzQTAbjfWYR/1TOje84bI/CCq5cinOpJgqTnv1GgvR
	xoZ4IECHatrMQguYQcxtcnaQc+pegcAAPKDW7+tuRFbBEi4ZuoJzTCa6zuNYYtytQo6Sa4wkutx
	aig==
X-Google-Smtp-Source: AGHT+IE7pFFxWKbmw/ifnFn5nYk/wffS3ge6lPDEDyB58ryciTbA2xXTBjU+nX2ZeZWzTTZF17pWYulO/JI=
X-Received: from pjbqb7.prod.google.com ([2002:a17:90b:2807:b0:2fc:201d:6026])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc1:b0:2ea:7cd5:4ad6
 with SMTP id 98e67ed59e1d1-3072ba2324amr1085676a91.32.1744242979679; Wed, 09
 Apr 2025 16:56:19 -0700 (PDT)
Date: Wed, 9 Apr 2025 16:56:18 -0700
In-Reply-To: <20250314062620.1169174-1-zoudongjie@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250314062620.1169174-1-zoudongjie@huawei.com>
Message-ID: <Z_cJIqEQEtEO9B8Y@google.com>
Subject: Re: [bug report] KVM: x86: Syzkaller has discovered an use-after-free
 issue in complete_emulated_mmio of kernel 5.10
From: Sean Christopherson <seanjc@google.com>
To: zoudongjie <zoudongjie@huawei.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kai.huang@intel.com, 
	yuan.yao@intel.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	luolongmin@huawei.com, suxiaodong1@huawei.com, jiangkunkun@huawei.com, 
	wangjian161@huawei.com, tangzhongwei2@huawei.com, mujinsheng@huawei.com, 
	alex.chen@huawei.com, eric.fangyi@huawei.com, chenjianfei3@huawei.com, 
	renxuming@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 14, 2025, zoudongjie wrote:
> Hi all,
> 
> I have discovered a use-after-free issue in complete_emulated_mmio during kernel fuzz testing
> with Syzkaller, the Call Trace is as follows:
> 
> Call Trace:
>  dump_stack+0xbe/0xfd
>  print_address_description.constprop.0+0x19/0x170
>  __kasan_report.cold+0x6c/0x84
>  kasan_report+0x3a/0x50
>  check_memory_region+0xfd/0x1f0
>  memcpy+0x20/0x60
>  complete_emulated_mmio+0x305/0x420
>  kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
>  kvm_vcpu_ioctl+0x413/0xb20
>  __se_sys_ioctl+0x111/0x160
>  do_syscall_64+0x30/0x40
>  entry_SYSCALL_64_after_hwframe+0x67/0xd1
> 
> RIP: 0033:0x45570d
> Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f93213e9048 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000058c1f0 RCX: 000000000045570d
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 000000000058c1f0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000000b R14: 0000000000425750 R15: 00007fff27f167f0

Do you have the kernel Code + register state?  This is from the userspace ioctl().

> The buggy address belongs to the page:
> page:000000005de3ae57 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x111bff
> flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
> raw: 0017ffffc0000000 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888111bff780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888111bff800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff888111bff880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                                  ^
>  ffff888111bff900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888111bff980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> ==================================================================
> 
> Do you have any suggestions regarding this issue?

Do you have a reproducer?  A C reproducer in particular would be helpful.

And does this repro on the latest and great upstream?  It's possible the underlying
bug has been fixed, but not backported to v5.15 for whatever reason.

> Any insights or debugging strategies would be greatly appreciated.

Assuming the memcpy() is towards the end of complete_emulated_mmio() based on
the offsets, that would correspond to:

   memcpy(run->mmio.data, frag->data, min(8u, frag->len));

My guess would be that frag->data is bad/stale; run->mmio.data is a static offset
into the vCPU's run page, and I would expect far bigger explosions if the run
page is freed while the vCPU is still reachable.

