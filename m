Return-Path: <kvm+bounces-30844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B53779BDD9C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 04:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD2F01C22F4B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E60190667;
	Wed,  6 Nov 2024 03:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hi5iB0tL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8145118F2EA
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 03:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730863832; cv=none; b=n2dWtfmnaH3iend2FU2rGlVgXyx3p6ABlYUL6JJjWaiDGmW8xNqB35/fUKrV67D6NJ3QD0uTUeH+65FfvQi/iP2uCSrwFWHXLMQPsodcKxFW14IwOo/fkelMmZBChxXOfk1sDeKh1ubfM96q6p7eLhmq+nFJpXrKaA/YJYKNUPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730863832; c=relaxed/simple;
	bh=7Kk3znZIyerx2PDNIN0drxdx/hAXIsUrO3BiNtWqf8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sevWrLrSxbLYTjdcyD4jUKOrsi+PsD/UelfivZMftvmoeKY8ibCQ1tSUCScK+8oS4knYktgsQMkVSMMxPbLy+t9Z/smI3yS2gCrgnN4ZtlRALf2FvyMev0DhF23ZWbRZQIHls5iJ4QwQWRT1PibKCjujK+dslzjxMhtUrLV8mKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hi5iB0tL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730863828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0+wD5C8mnnSFMtajBQ0Ep+tgIvgdpwZh5j0ZoDDULiE=;
	b=Hi5iB0tLaQf31yx9Iofp4/Dxy0quCwgsAf3pCT25fI52+nj6NiYAzbCQQHxHtkd+WTBKIg
	laRMHQYAUbWYP5cXCV8E3b18Lgen7vUkPExULkC2FORSGWzZ0hbUPScnK6mywyV6065qoI
	Es+zO5palBD7DKwp0gLzC/lT/bKkua8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-oQoryfmHNgyVupvvQDWDOQ-1; Tue, 05 Nov 2024 22:30:27 -0500
X-MC-Unique: oQoryfmHNgyVupvvQDWDOQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2e2ca4fb175so6279906a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 19:30:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730863826; x=1731468626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+wD5C8mnnSFMtajBQ0Ep+tgIvgdpwZh5j0ZoDDULiE=;
        b=C0YCn43DkmqHcL+23+OyJdKSd0onXT0Z4iZ6cy31+lMhihYk23q9f6v2TJSM0bhn2B
         PrDKR/BSJOcEMDNZdFDHgb90hnGndGPmx1bbEUwxNsHINId+uz10qgjOH3+Ij+/vXMrk
         nlumkPEXLtrLsWoE1N4AWih1zqIGQXmMOGXbYlDocVye9SoQCNIvZVDWobeLP0Ynlxel
         RTSpBI2GCMKOfs45d3r0qOvaZNWa/HqXB2PldIBylpg9Ar32c0gbJDXz3pMjChEXaBh/
         ZITRIeN4eMyuSUQgADrqe7oIF7AT0HEbTrN94Xc5fVGOmsjSNCnFB+s5yRe0TV4m4aZL
         zm+g==
X-Forwarded-Encrypted: i=1; AJvYcCWIj6DuAtJ+fSk1kZseAXPHX0QONXIO0afGf+ud1YHe6qM+G5Gfd/TcSwZ7nKMtBAvawrI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6zWjY1d4ZE/AHTBKC7Myjgh4iMWoUXz+ztvM3dl5Ml5Z08nnf
	nH1u1rt/qrkzvJYch7SZEZvzmsC7mDFCET+c34FGmzKY44Zt7csfVUKhn2rqMkl3zxrUbqAWmMR
	i10kKgi5B4e4Mv3txYT0rm5C9BCfPWLk46s27Ala3W+o0p/KEGKzIR1wnLYobBvIN1ch265NIV+
	d9N6w5LmsOd/6sky5hvGuWnaPq
X-Received: by 2002:a17:90b:4c46:b0:2e2:8fb4:502d with SMTP id 98e67ed59e1d1-2e92ce52d78mr28691984a91.16.1730863826240;
        Tue, 05 Nov 2024 19:30:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZ8ehhnb5warv41MQecmdcJ74fifjbHOtjAiOyNQliV/l9hnuvE6Steaw0kjpDyhiXUzeiDRKvVs9Tf1rD8pE=
X-Received: by 2002:a17:90b:4c46:b0:2e2:8fb4:502d with SMTP id
 98e67ed59e1d1-2e92ce52d78mr28691961a91.16.1730863825811; Tue, 05 Nov 2024
 19:30:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105185101.1323272-2-dtatulea@nvidia.com>
In-Reply-To: <20241105185101.1323272-2-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 6 Nov 2024 11:30:14 +0800
Message-ID: <CACGkMEswM_3uhOHnzGwOMjfiPqpMgTnjVRhgpWquzTwVpwNr6g@mail.gmail.com>
Subject: Re: [PATCH] vdpa/mlx5: Fix error path during device add
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux.dev, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 2:52=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> In the error recovery path of mlx5_vdpa_dev_add(), the cleanup is
> executed and at the end put_device() is called which ends up calling
> mlx5_vdpa_free(). This function will execute the same cleanup all over
> again. Most resources support being cleaned up twice, but the recent
> mlx5_vdpa_destroy_mr_resources() doesn't.
>
> This change drops the explicit cleanup from within the
> mlx5_vdpa_dev_add() and lets mlx5_vdpa_free() do its work.
>
> This issue was discovered while trying to add 2 vdpa devices with the
> same name:
> $> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.2
> $> vdpa dev add name vdpa-0 mgmtdev auxiliary/mlx5_core.sf.3
>
> ... yields the following dump:
>
>   BUG: kernel NULL pointer dereference, address: 00000000000000b8
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP
>   CPU: 4 UID: 0 PID: 2811 Comm: vdpa Not tainted 6.12.0-rc6 #1
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-g=
f21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>   RIP: 0010:destroy_workqueue+0xe/0x2a0
>   Code: ...
>   RSP: 0018:ffff88814920b9a8 EFLAGS: 00010282
>   RAX: 0000000000000000 RBX: ffff888105c10000 RCX: 0000000000000000
>   RDX: 0000000000000001 RSI: ffff888100400168 RDI: 0000000000000000
>   RBP: 0000000000000000 R08: ffff888100120c00 R09: ffffffff828578c0
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>   R13: ffff888131fd99a0 R14: 0000000000000000 R15: ffff888105c10580
>   FS:  00007fdfa6b4f740(0000) GS:ffff88852ca00000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00000000000000b8 CR3: 000000018db09006 CR4: 0000000000372eb0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    ? __die+0x20/0x60
>    ? page_fault_oops+0x150/0x3e0
>    ? exc_page_fault+0x74/0x130
>    ? asm_exc_page_fault+0x22/0x30
>    ? destroy_workqueue+0xe/0x2a0
>    mlx5_vdpa_destroy_mr_resources+0x2b/0x40 [mlx5_vdpa]
>    mlx5_vdpa_free+0x45/0x150 [mlx5_vdpa]
>    vdpa_release_dev+0x1e/0x50 [vdpa]
>    device_release+0x31/0x90
>    kobject_put+0x8d/0x230
>    mlx5_vdpa_dev_add+0x328/0x8b0 [mlx5_vdpa]
>    vdpa_nl_cmd_dev_add_set_doit+0x2b8/0x4c0 [vdpa]
>    genl_family_rcv_msg_doit+0xd0/0x120
>    genl_rcv_msg+0x180/0x2b0
>    ? __vdpa_alloc_device+0x1b0/0x1b0 [vdpa]
>    ? genl_family_rcv_msg_dumpit+0xf0/0xf0
>    netlink_rcv_skb+0x54/0x100
>    genl_rcv+0x24/0x40
>    netlink_unicast+0x1fc/0x2d0
>    netlink_sendmsg+0x1e4/0x410
>    __sock_sendmsg+0x38/0x60
>    ? sockfd_lookup_light+0x12/0x60
>    __sys_sendto+0x105/0x160
>    ? __count_memcg_events+0x53/0xe0
>    ? handle_mm_fault+0x100/0x220
>    ? do_user_addr_fault+0x40d/0x620
>    __x64_sys_sendto+0x20/0x30
>    do_syscall_64+0x4c/0x100
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   RIP: 0033:0x7fdfa6c66b57
>   Code: ...
>   RSP: 002b:00007ffeace22998 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
>   RAX: ffffffffffffffda RBX: 000055a498608350 RCX: 00007fdfa6c66b57
>   RDX: 000000000000006c RSI: 000055a498608350 RDI: 0000000000000003
>   RBP: 00007ffeace229c0 R08: 00007fdfa6d35200 R09: 000000000000000c
>   R10: 0000000000000000 R11: 0000000000000202 R12: 000055a4986082a0
>   R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffeace233f3
>    </TASK>
>   Modules linked in: ...
>   CR2: 00000000000000b8
>
> Fixes: 62111654481d ("vdpa/mlx5: Postpone MR deletion")
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


