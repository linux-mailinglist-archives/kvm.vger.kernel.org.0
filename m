Return-Path: <kvm+bounces-53351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA4FB10323
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 10:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A483AEF91
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD72F2749ED;
	Thu, 24 Jul 2025 08:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFBoZyx5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C08927467A
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344894; cv=none; b=JacLBW5k45SztwuXpUPAsl2CWjF6sQIqEwlZ+yYPQzocJ4xAJc51nBm+rvb6xmwtO893lZeFG96iO1n+R9GW2gPRyjFE0yX4JtZ8kCgXRBolEiR9+7T+liBBTd6BsSdlnebYRSNl2TRcDOnytEqLv5oJ7kOJoS0jZ/8KJdkoD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344894; c=relaxed/simple;
	bh=E4skDka5+jBM109LzqEEgatmXJdZTiQGPzrQBvqeh5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DVS0bMTF5uZslyfuBZ3W7ANLd1f9mTDwnY853eGR82dcxDSy5SmsL16hqPp3ZAtcc/aZIWRsN/L4OLLTTrlj5Nl7PmV3FY7X+T2rsqqvtEeYmD7MzNbxsRigw+UCs+kujSLh9HVJ+IOij6FhgGoTvluSpU5BB4Tk55586Spt7/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFBoZyx5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753344891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cJ02ByKeKesw6MmLXs1z5moyb7EKOu1a28e6JM2JXDQ=;
	b=MFBoZyx55zB73dR4h68P3eoNjKqeFUH7+smkhlYbSZcHWLhw6lXVuZsRdM/gliqTb82vKw
	Sv50JZTAQVwikXR7BVd90ltMFrsGWbnID2rv8CTWaETBggJ3r44PlpNkmVvgZf4JTDl5YH
	ljHkuXoDi6sZImZBj3h8QOq0UdGTz58=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-k3KjeOhrOG-XHry3cS9Fgw-1; Thu, 24 Jul 2025 04:14:49 -0400
X-MC-Unique: k3KjeOhrOG-XHry3cS9Fgw-1
X-Mimecast-MFC-AGG-ID: k3KjeOhrOG-XHry3cS9Fgw_1753344889
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-70e73d3c474so11284217b3.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 01:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753344889; x=1753949689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cJ02ByKeKesw6MmLXs1z5moyb7EKOu1a28e6JM2JXDQ=;
        b=FgBXFAAzS2ZbJQ5HIrnNjl6+Bx3i5KWszEf7KXV2iwbBqn2pHio6hI7wIhVTVIjpbb
         pqzhItNGxi83zxDgvquDRnhcvkh+5q3xkR3U6ZksUNxidZUbnJ3+AE2bM5KtIkKVNvVe
         0bk8JFXzYb8z/YF0hIUvKrb8ou6ebwSpQJmKGKD6NtXdHhk9op+E4i8gIklviipSq17W
         F9U67tkwx9n4hW3MFFY17ZUeGZGepe7+j+2RzuPO6OS+gHTgm6RstNQ2mqIrt1LDb6Go
         Yy8auF4fHrLngrK7JJjDWCJgaBu/Vzf+Dhr0Iuw3O454sQrCZ3bk3EXGBTJBqAMO+eFa
         C/dg==
X-Forwarded-Encrypted: i=1; AJvYcCUXz1zLHmrlM/SmUyotVJywKmN7Ktp+Kw9roMGcjJ6pAniLjyYixpcfYp4i328ZBwrtQZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjTHN9DBB9YzVSEG2wv9XhXFy/iyD81eVWj6NA4EkkL0sHNbms
	nabQeuP3q8G2ZOp3psG97yPk27eXUSo8qnowGBzvI5fzC6hw/S9MLQ0VXLZhJ2tB03Dq2wr7ZDx
	cUSsfFPPTOBjH5QQoagOAPtAr2iiQq2w2MVk4CbBRMHcc6fjcUS0uDj/cTny1JDjw1bO4oawR3p
	4y+It6RQHTyqrNkPIILpiM7UEmMalTgZjqrFEawb9tOg==
X-Gm-Gg: ASbGncujfhNTZddnyXYPWp/UAZvQCErUPjITKUGL/u1ulBFyDJa8vZ61qgbEjC0GINI
	KE9SfUjBtTiXbR5QmOUQYTEHJ78yGoFj52iqAcQlwA2up6TzZ2UTgnCeis69HxmBoOrgccqZtpI
	kqURdS1MAM4SoJs5D0hJJY
X-Received: by 2002:a05:690c:314:b0:70d:ed5d:b4b2 with SMTP id 00721157ae682-719b41694d2mr79268517b3.13.1753344888532;
        Thu, 24 Jul 2025 01:14:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPvKRyNZLxuZc2LCwPGxrFyYTVxsjT7roo0HAnWfJQl2Ut22h5DTHOWlu7sekIJonGE+l2+DrYFw6tPUZf8IY=
X-Received: by 2002:a05:690c:314:b0:70d:ed5d:b4b2 with SMTP id
 00721157ae682-719b41694d2mr79268197b3.13.1753344887977; Thu, 24 Jul 2025
 01:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c> <20250724034659-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250724034659-mutt-send-email-mst@kernel.org>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 24 Jul 2025 10:14:36 +0200
X-Gm-Features: Ac12FXzqfSEj1dVrbaSJdrllq6HfeMDxFTLlI3oLSZh4ILH_YbA_CktsAqGaAiE
Message-ID: <CAGxU2F76ueKm3H30vXL+jxMVsiQBuRkDN9NRfVU8VeTXzTVAWg@mail.gmail.com>
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
To: "Michael S. Tsirkin" <mst@redhat.com>, Will Deacon <will@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, jasowang@redhat.com, eperezma@redhat.com, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CCing Will

On Thu, 24 Jul 2025 at 09:48, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 23, 2025 at 08:04:42AM -0700, Breno Leitao wrote:
> > Hello,
> >
> > I've seen a crash in linux-next for a while on my arm64 server, and
> > I decided to report.
> >
> > While running stress-ng on linux-next, I see the crash below.
> >
> > This is happening in a kernel configure with some debug options (KASAN,
> > LOCKDEP and KMEMLEAK).
> >
> > Basically running stress-ng in a loop would crash the host in 15-20
> > minutes:
> >       # while (true); do stress-ng -r 10 -t 10; done
> >
> > >From the early warning "virt_to_phys used for non-linear address",

mmm, we recently added nonlinear SKBs support in vhost-vsock [1],
@Will can this issue be related?

I checked next-20250721 tag and I confirm that contains those changes.

[1] https://lore.kernel.org/virtualization/20250717090116.11987-1-will@kern=
el.org/

Thanks,
Stefano

> > I suppose corrupted data is at vq->nheads.
> >
> > Here is the decoded stack against 9798752 ("Add linux-next specific
> > files for 20250721")
> >
> >
> >       [  620.685144] [ T250731] VFIO - User Level meta-driver version: =
0.3
> >       [  622.394448] [ T250254] ------------[ cut here ]------------
> >       [  622.413492] [ T250254] virt_to_phys used for non-linear addres=
s: 000000006e69fe64 (0xcfcecdcccbcac9c8)
> >       [  622.447771] [     T250254] WARNING: arch/arm64/mm/physaddr.c:1=
5 at __virt_to_phys+0x64/0x90, CPU#57: stress-ng-dev/250254
> >       [  622.487227] [ T250254] Modules linked in: vhost_vsock(E) vfio_=
iommu_type1(E) vfio(E) unix_diag(E) sch_fq(E) ghes_edac(E) tls(E) tcp_diag(=
E) inet_diag(E) act_gact(E) cls_bpf(E) nvidia_cspmu(E) ipmi_ssif(E) coresig=
ht_trbe(E) arm_cspmu_module(E) arm_smmuv3_pmu(E) ipmi_devintf(E) coresight_=
stm(E) coresight_funnel(E) coresight_etm4x(E) coresight_tmc(E) stm_core(E) =
ipmi_msghandler(E) coresight(E) cppc_cpufreq(E) sch_fq_codel(E) drm(E) back=
light(E) drm_panel_orientation_quirks(E) sm3_ce(E) sha3_ce(E) spi_tegra210_=
quad(E) vhost_net(E) tap(E) tun(E) vhost(E) vhost_iotlb(E) mpls_gso(E) mpls=
_iptunnel(E) mpls_router(E) fou(E) acpi_power_meter(E) loop(E) efivarfs(E) =
autofs4(E) [last unloaded: test_bpf(E)]
> >       [  622.734524] [ T250254] Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MOD=
ULE, [N]=3DTEST
> >       [  622.734525] [ T250254] Hardware name: ...
> >       [  622.734526] [ T250254] pstate: 63401009 (nZCv daif +PAN -UAO +=
TCO +DIT +SSBS BTYPE=3D--)
> >       [  622.734529] [     T250254] pc : __virt_to_phys (/home/user/Dev=
el/linux-next/arch/arm64/mm/physaddr.c:?)
> >       [  622.734531] [     T250254] lr : __virt_to_phys (/home/user/Dev=
el/linux-next/arch/arm64/mm/physaddr.c:?)
> >       [  622.734533] [ T250254] sp : ffff800158e8fc60
> >       [  622.734534] [ T250254] x29: ffff800158e8fc60 x28: ffff0034a7cc=
7900 x27: 0000000000000000
> >       [  622.734537] [ T250254] x26: 0000000000000000 x25: ffff0034a7cc=
7900 x24: 00000000040e001f
> >       [  622.734539] [ T250254] x23: ffff0010858afb00 x22: cfcecdcccbca=
c9c8 x21: ffff0033526a01e0
> >       [  622.734541] [ T250254] x20: 0000000000008000 x19: ffcecdcccbca=
c9c8 x18: ffff80008149c8e4
> >       [  622.734543] [ T250254] x17: 0000000000000001 x16: 000000000000=
0000 x15: 0000000000000003
> >       [  622.734545] [ T250254] x14: ffff800082962e78 x13: 000000000000=
0003 x12: ffff003bc6231630
> >       [  622.734546] [ T250254] x11: 0000000000000000 x10: 000000000000=
0000 x9 : ed44a220ae716b00
> >       [  622.734548] [ T250254] x8 : 0001000000000000 x7 : 072007200720=
0720 x6 : ffff80008018710c
> >       [  622.734550] [ T250254] x5 : 0000000000000001 x4 : 00000090ecc7=
2ac0 x3 : 0000000000000000
> >       [  622.734552] [ T250254] x2 : 0000000000000000 x1 : ffff800081a7=
2bc6 x0 : 000000000000004f
> >       [  622.734554] [ T250254] Call trace:
> >       [  622.734555] [     T250254] __virt_to_phys (/home/user/Devel/li=
nux-next/arch/arm64/mm/physaddr.c:?) (P)
> >       [  622.734557] [     T250254] kfree (/home/user/Devel/linux-next/=
./include/linux/mm.h:1180 /home/user/Devel/linux-next/mm/slub.c:4871)
> >       [  622.734562] [     T250254] vhost_dev_cleanup (/home/user/Devel=
/linux-next/drivers/vhost/vhost.c:506 /home/user/Devel/linux-next/drivers/v=
host/vhost.c:542 /home/user/Devel/linux-next/drivers/vhost/vhost.c:1214) vh=
ost
> >       [  622.734571] [     T250254] vhost_vsock_dev_release (/home/user=
/Devel/linux-next/drivers/vhost/vsock.c:756) vhost_vsock
>
>
> Cc more vsock maintainers.
>
>
>
>
> >       [  622.734575] [     T250254] __fput (/home/user/Devel/linux-next=
/fs/file_table.c:469)
> >       [  622.734578] [     T250254] fput_close_sync (/home/user/Devel/l=
inux-next/fs/file_table.c:?)
> >       [  622.734579] [     T250254] __arm64_sys_close (/home/user/Devel=
/linux-next/fs/open.c:1589 /home/user/Devel/linux-next/fs/open.c:1572 /home=
/user/Devel/linux-next/fs/open.c:1572)
> >       [  622.734584] [     T250254] invoke_syscall (/home/user/Devel/li=
nux-next/arch/arm64/kernel/syscall.c:50)
> >       [  622.734589] [     T250254] el0_svc_common (/home/user/Devel/li=
nux-next/./include/linux/thread_info.h:135 /home/user/Devel/linux-next/arch=
/arm64/kernel/syscall.c:140)
> >       [  622.734591] [     T250254] do_el0_svc (/home/user/Devel/linux-=
next/arch/arm64/kernel/syscall.c:152)
> >       [  622.734594] [     T250254] el0_svc (/home/user/Devel/linux-nex=
t/arch/arm64/kernel/entry-common.c:169 /home/user/Devel/linux-next/arch/arm=
64/kernel/entry-common.c:182 /home/user/Devel/linux-next/arch/arm64/kernel/=
entry-common.c:880)
> >       [  622.734600] [     T250254] el0t_64_sync_handler (/home/user/De=
vel/linux-next/arch/arm64/kernel/entry-common.c:958)
> >       [  622.734603] [     T250254] el0t_64_sync (/home/user/Devel/linu=
x-next/arch/arm64/kernel/entry.S:596)
> >       [  622.734605] [ T250254] irq event stamp: 0
> >       [  622.734606] [     T250254] hardirqs last enabled at (0): 0x0
> >       [  622.734610] [     T250254] hardirqs last disabled at (0): copy=
_process (/home/user/Devel/linux-next/kernel/fork.c:?)
> >       [  622.734614] [     T250254] softirqs last enabled at (0): copy_=
process (/home/user/Devel/linux-next/kernel/fork.c:?)
> >       [  622.734616] [     T250254] softirqs last disabled at (0): 0x0
> >       [  622.734618] [ T250254] ---[ end trace 0000000000000000 ]---
> >       [  622.734697] [ T250254] Unable to handle kernel paging request =
at virtual address 003ff3b33312f288
> >       [  622.734700] [ T250254] Mem abort info:
> >       [  622.734701] [ T250254]   ESR =3D 0x0000000096000004
> >       [  622.734702] [ T250254]   EC =3D 0x25: DABT (current EL), IL =
=3D 32 bits
> >       [  622.734704] [ T250254]   SET =3D 0, FnV =3D 0
> >       [  622.734705] [ T250254]   EA =3D 0, S1PTW =3D 0
> >       [  622.734706] [ T250254]   FSC =3D 0x04: level 0 translation fau=
lt
> >       [  622.734708] [ T250254] Data abort info:
> >       [  622.734709] [ T250254]   ISV =3D 0, ISS =3D 0x00000004, ISS2 =
=3D 0x00000000
> >       [  622.734711] [ T250254]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAc=
cess =3D 0
> >       [  622.734712] [ T250254]   GCS =3D 0, Overlay =3D 0, DirtyBit =
=3D 0, Xs =3D 0
> >       [  622.734713] [ T250254] [003ff3b33312f288] address between user=
 and kernel address ranges
> >       [  622.734715] [ T250254] Internal error: Oops: 0000000096000004 =
[#1]  SMP
> >       [  622.734718] [ T250254] Modules linked in: vhost_vsock(E) vfio_=
iommu_type1(E) vfio(E) unix_diag(E) sch_fq(E) ghes_edac(E) tls(E) tcp_diag(=
E) inet_diag(E) act_gact(E) cls_bpf(E) nvidia_cspmu(E) ipmi_ssif(E) coresig=
ht_trbe(E) arm_cspmu_module(E) arm_smmuv3_pmu(E) ipmi_devintf(E) coresight_=
stm(E) coresight_funnel(E) coresight_etm4x(E) coresight_tmc(E) stm_core(E) =
ipmi_msghandler(E) coresight(E) cppc_cpufreq(E) sch_fq_codel(E) drm(E) back=
light(E) drm_panel_orientation_quirks(E) sm3_ce(E) sha3_ce(E) spi_tegra210_=
quad(E) vhost_net(E) tap(E) tun(E) vhost(E) vhost_iotlb(E) mpls_gso(E) mpls=
_iptunnel(E) mpls_router(E) fou(E) acpi_power_meter(E) loop(E) efivarfs(E) =
autofs4(E) [last unloaded: test_bpf(E)]
> >       [  622.734740] [ T250254] Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MOD=
ULE, [N]=3DTEST
> >       [  622.734740] [ T250254] Hardware name: ...
> >       [  622.734741] [ T250254] pstate: 63401009 (nZCv daif +PAN -UAO +=
TCO +DIT +SSBS BTYPE=3D--)
> >       [  622.734742] [     T250254] pc : kfree (/home/user/Devel/linux-=
next/./include/linux/page-flags.h:284 /home/user/Devel/linux-next/./include=
/linux/mm.h:1182 /home/user/Devel/linux-next/mm/slub.c:4871)
> >       [  622.734745] [     T250254] lr : kfree (/home/user/Devel/linux-=
next/./include/linux/mm.h:1180 /home/user/Devel/linux-next/mm/slub.c:4871)
> >       [  622.734747] [ T250254] sp : ffff800158e8fc80
> >       [  622.734748] [ T250254] x29: ffff800158e8fc90 x28: ffff0034a7cc=
7900 x27: 0000000000000000
> >       [  622.734749] [ T250254] x26: 0000000000000000 x25: ffff0034a7cc=
7900 x24: 00000000040e001f
> >       [  622.734751] [ T250254] x23: ffff0010858afb00 x22: cfcecdcccbca=
c9c8 x21: ffff0033526a01e0
> >       [  622.734752] [ T250254] x20: 003ff3b33312f280 x19: ffff80000acd=
1a20 x18: ffff80008149c8e4
> >       [  622.734754] [ T250254] x17: 0000000000000001 x16: 000000000000=
0000 x15: 0000000000000003
> >       [  622.734755] [ T250254] x14: ffff800082962e78 x13: 000000000000=
0003 x12: ffff003bc6231630
> >       [  622.734757] [ T250254] x11: 0000000000000000 x10: 000000000000=
0000 x9 : ffffffdfc0000000
> >       [  622.734758] [ T250254] x8 : 003ff3d37312f280 x7 : 072007200720=
0720 x6 : ffff80008018710c
> >       [  622.734760] [ T250254] x5 : 0000000000000001 x4 : 00000090ecc7=
2ac0 x3 : 0000000000000000
> >       [  622.734761] [ T250254] x2 : 0000000000000000 x1 : ffff800081a7=
2bc6 x0 : ffcf4dcccbcac9c8
> >       [  622.734763] [ T250254] Call trace:
> >       [  622.734763] [     T250254] kfree (/home/user/Devel/linux-next/=
./include/linux/page-flags.h:284 /home/user/Devel/linux-next/./include/linu=
x/mm.h:1182 /home/user/Devel/linux-next/mm/slub.c:4871) (P)
> >       [  622.734766] [     T250254] vhost_dev_cleanup (/home/user/Devel=
/linux-next/drivers/vhost/vhost.c:506 /home/user/Devel/linux-next/drivers/v=
host/vhost.c:542 /home/user/Devel/linux-next/drivers/vhost/vhost.c:1214) vh=
ost
> >       [  622.734769] [     T250254] vhost_vsock_dev_release (/home/user=
/Devel/linux-next/drivers/vhost/vsock.c:756) vhost_vsock
> >       [  622.734771] [     T250254] __fput (/home/user/Devel/linux-next=
/fs/file_table.c:469)
> >       [  622.734772] [     T250254] fput_close_sync (/home/user/Devel/l=
inux-next/fs/file_table.c:?)
> >       [  622.734773] [     T250254] __arm64_sys_close (/home/user/Devel=
/linux-next/fs/open.c:1589 /home/user/Devel/linux-next/fs/open.c:1572 /home=
/user/Devel/linux-next/fs/open.c:1572)
> >       [  622.734776] [     T250254] invoke_syscall (/home/user/Devel/li=
nux-next/arch/arm64/kernel/syscall.c:50)
> >       [  622.734778] [     T250254] el0_svc_common (/home/user/Devel/li=
nux-next/./include/linux/thread_info.h:135 /home/user/Devel/linux-next/arch=
/arm64/kernel/syscall.c:140)
> >       [  622.734781] [     T250254] do_el0_svc (/home/user/Devel/linux-=
next/arch/arm64/kernel/syscall.c:152)
> >       [  622.734783] [     T250254] el0_svc (/home/user/Devel/linux-nex=
t/arch/arm64/kernel/entry-common.c:169 /home/user/Devel/linux-next/arch/arm=
64/kernel/entry-common.c:182 /home/user/Devel/linux-next/arch/arm64/kernel/=
entry-common.c:880)
> >       [  622.734787] [     T250254] el0t_64_sync_handler (/home/user/De=
vel/linux-next/arch/arm64/kernel/entry-common.c:958)
> >       [  622.734790] [     T250254] el0t_64_sync (/home/user/Devel/linu=
x-next/arch/arm64/kernel/entry.S:596)
> >       [ 622.734792] [ T250254] Code: f2dffbe9 927abd08 cb141908 8b09011=
4 (f9400688)
> >       All code
> >       =3D=3D=3D=3D=3D=3D=3D=3D
> >       0:*     e9 fb df f2 08          jmp    0x8f2e000                <=
-- trapping instruction
> >       5:      bd 7a 92 08 19          mov    $0x1908927a,%ebp
> >       a:      14 cb                   adc    $0xcb,%al
> >       c:      14 01                   adc    $0x1,%al
> >       e:      09 8b 88 06 40 f9       or     %ecx,-0x6bff978(%rbx)
> >
> >       Code starting with the faulting instruction
> >       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >       0:      88 06                   mov    %al,(%rsi)
> >       2:      40 f9                   rex stc
> >       [  622.734795] [ T250254] SMP: stopping secondary CPUs
> >       [  622.735089] [ T250254] Starting crashdump kernel...
> >       [  622.735091] [ T250254] Bye!
>


