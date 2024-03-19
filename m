Return-Path: <kvm+bounces-12130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4892087FE3B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A34BAB2339F
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C7D8004F;
	Tue, 19 Mar 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rz9sul6J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FB43FBB9;
	Tue, 19 Mar 2024 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853727; cv=none; b=k4i1/O0htQHHv06vMDCdpLHsDPik1ZkxdCtq5k8+2umdXh2Q41i71ixN1dm6lStRwy8Q1heEKpF/MMAHXajldJ7MqJFWpCldD31xAIB3rZ9KQfVxZ52AGyso6kv8wqtnP+246cNZ1R38FBPPsKPp4krChpAFk6j6Brob8+gskIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853727; c=relaxed/simple;
	bh=AMeQHVzmFzEQ5pOEjitrQsM9EdvdtRNgGa+vzpIPHQk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=CcpncsLDs+hkdsVJT1GCCe12yTh8XMjl7pPHLuJ9fgTxXJ4tWvCcjJktOHKi+KRMXABGLaGotuP8XMR9UE8Zb5JjDoY/N7ildAp2crg1MAGlOHEEU6ZsExgQQWELl+woq7ffl2JXxQNqzaJqHaNVWvdyshgU3dGtUJcd+C5ptw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rz9sul6J; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-78a13117a3dso40620285a.1;
        Tue, 19 Mar 2024 06:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710853724; x=1711458524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdVAHfQQIN7iu87LjaYltiBjtIWrfsmEChPPCLn2oS8=;
        b=Rz9sul6JXLhMFimZXlAADoG+fyycFw9iROAYoi0YNdFNiZ2TdZ/UhciHjYOEHRliJO
         sg9ModoDxtjSs/trmYVhvSZNZ4KrgzKo77JTorsvOFMUH2hA5+iqPyk7jDZAwaNVvzcw
         PFukKnnvbxEm+FEicKDGnOzP94zJ+kDGblJia2qblPskkrEQa/nShJZIZ8xKK7lgZHLo
         Z8STSL/p/5ofzoOmTKyRuKSTe2zuB71y2Wqk8TjuL096tE3Mc/1ozON9b07Usn+PhjsT
         bdvxzgS2KQDf35pUyuKXu6Rt77+SirkIZNv6yRfRBH00aWObWAE4Xr5u2zdUJ740q18W
         gNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710853724; x=1711458524;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mdVAHfQQIN7iu87LjaYltiBjtIWrfsmEChPPCLn2oS8=;
        b=jwmcHIuhplazPLz7Qcz0/eYHPTHMb3XeAHL/PzaBcS6FVyFK8+I3n4LbrFwtFVWjft
         9S3tmJSzapipIaTIEWs/l/gVsMkjcwo1wb2sjGcQVChCB1OdgteCZzLrNH0996TuNVjc
         amta9L2025l8CmzZ9YUfFDcvK9UD5UeBdM2BSBE5m7hTzIGWt55MrcoECHC5/2geug2S
         kq4ZhjvLPUP/ZLqXmrOXicnrZShkInTxqkRlovrFDhrmz/DbRPPhciu3d4wBHsb4YkUY
         /4NEU4ovbTOHnylM8mDWZddZzHFhkfCgEH8guh54E3zTOyFA60j+zj8pGDHxPghZwx65
         vzjw==
X-Forwarded-Encrypted: i=1; AJvYcCVmv6ajVpZ3PMbf5V3Y7qyM5wCJJXgCsa9ib39WMxR9ScQq3e7ZK2xqQ+GLs+zdZo+659CulG7BYtQhLORm+uH5Cd7bD2K4JTq9s2a2ipJB7QiapZPTr5cOt8r8
X-Gm-Message-State: AOJu0YzJGta97dtSO9DTMwyfvq//kWeoT4ixPpMqNTvDYEsvQeWrSTVE
	ZIsW9iinB3oxFwCcJOEyGHcEYIUDirze/xYbfe1xeZcAIcnBzZsE
X-Google-Smtp-Source: AGHT+IHD63cSeMzwYqMGgdunUUCq9Upn1sjL1uQ8FO8DsysTbFsd/9s/VppJIlt14DsXMYq42Vgszg==
X-Received: by 2002:a05:620a:248a:b0:789:e89d:6829 with SMTP id i10-20020a05620a248a00b00789e89d6829mr4402907qkn.35.1710853724349;
        Tue, 19 Mar 2024 06:08:44 -0700 (PDT)
Received: from localhost (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id y22-20020a37e316000000b00789f55e1ca3sm2548842qki.8.2024.03.19.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 06:08:43 -0700 (PDT)
Date: Tue, 19 Mar 2024 09:08:43 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Igor Raits <igor@gooddata.com>, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 netdev@vger.kernel.org
Cc: Stefano Garzarella <sgarzare@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Message-ID: <65f98e5b99604_11543d29415@willemb.c.googlers.com.notmuch>
In-Reply-To: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Igor Raits wrote:
> Hello,
> 
> We have started to observe kernel crashes on 6.7.y kernels (atm we
> have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> have nodes of cluster it looks stable. Please see stacktrace below. If
> you need more information please let me know.
> 
> We do not have a consistent reproducer but when we put some bigger
> network load on a VM, the hypervisor's kernel crashes.
> 
> Help is much appreciated! We are happy to test any patches.
> 
> [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI

Did you miss the first part of the Oops?

> [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
>    E      6.7.10-1.gdc.el9.x86_64 #1
> [62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIOS
> 2.14.1 12/17/2023
> [62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
> [62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 41
> 80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 84
> c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f 44
> 00 00
> [62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
> [62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000785
> [62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: ffff989862b32b00
> [62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 000000000000003a
> [62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: ffff9880b819aec0
> [62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 0000000000000002
> [62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000)
> knlGS:0000000000000000
> [62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 0000000000770ef0
> [62254.282733] PKRU: 55555554
> [62254.285911] Call Trace:
> [62254.288884]  <TASK>
> [62254.291549]  ? die+0x33/0x90
> [62254.294769]  ? do_trap+0xe0/0x110
> [62254.298405]  ? do_error_trap+0x65/0x80
> [62254.302471]  ? exc_stack_segment+0x35/0x50
> [62254.306884]  ? asm_exc_stack_segment+0x22/0x30
> [62254.311637]  ? skb_release_data+0xb8/0x1e0
> [62254.316047]  kfree_skb_list_reason+0x6d/0x210
> [62254.320697]  ? free_unref_page_commit+0x80/0x2f0
> [62254.325700]  ? free_unref_page+0xe9/0x130
> [62254.330013]  skb_release_data+0xfc/0x1e0
> [62254.334261]  consume_skb+0x45/0xd0
> [62254.338077]  tun_do_read+0x68/0x1f0 [tun]
> [62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
> [62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
> [62254.351488]  vhost_worker+0x42/0x70 [vhost]
> [62254.355934]  vhost_task_fn+0x4b/0xb0

Neither tun nor vhost_net saw significant changes between the two
reported kernels.

    $ git log --oneline v6.6..v6.7 -- drivers/net/tun.c drivers/vhost/net.c | wc -l 
    0

    $ git log --oneline linux/v6.6.9..linux/v6.7.5 -- drivers/net/tun.c drivers/vhost/net.c
    6438382dd9f8 tun: add missing rx stats accounting in tun_xdp_act
    4efd09da0d49 tun: fix missing dropped counter in tun_xdp_act

So the cause is likely in the code that generated the skb or something
that modified it along the way.

It could be helpful if it is possible to bisect further. Though odds
are that the issue is between v6.6 and v6.7, not introduced in the
stable backports after that. So it is a large target.

Getting the exact line in skb_release_data that causes the Oops
would be helpful too, e.g.,

gdb vmlinux
list *(skb_release_data+0xb8)



