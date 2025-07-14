Return-Path: <kvm+bounces-52342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 389B8B04347
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 17:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A44E4E1F42
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDA8261584;
	Mon, 14 Jul 2025 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oC/V2J1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80618260566
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752506088; cv=none; b=buFQ4HDlMVtxwD97SnuvuUJOhMC3wtC2QGuageBt/rUQF4oZdUBX465I1cAEMs8247iaPY7RkiVEf1QpCqT55m7sw6LInkTQjI4hylBw1HsLjSHLV4EUHnUAFyK5fAzjdrYNXQJybyZzSZpuIUoowEDMZqFodhNUS5vWRy5N9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752506088; c=relaxed/simple;
	bh=Rb5Ojqqhv5eA0DyW6c06TTTVEu+CSbhkppk2UGzPmqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ApUEnlcas3XxkFV85LhIzdsteHoF8lj9mopfnKt9S990uutV8Dctw2itUQ7l+hJgf88s2bNL+AhdEKrR86+WOTswypC/eB9ZgBzU6AXFxtlYzFYEBe6c+arg4OTLeuSHpgAfFSvlvz/dq0zvpNWZ0fP5Sedj+cp+djW+udC+Pq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oC/V2J1U; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso7263237a91.1
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752506086; x=1753110886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Mly3ZZQYDnlEsq3pZjTSNYHkF/08sz7EiTQ0FuSgIM=;
        b=oC/V2J1Uv0NMGgtIG/hxBZvfJMx7HhTEUxPJfVqBOMVNycGUPUt6n49iq03KVsWMXB
         ilcOjrwsjGVB5BzyVzSFYqHTXFw6LVN7VcqdNHPS24sh+w2tHwuxNnIQbsH8j85IjzYU
         iti1YU9UW8IdLg8ehl4ebuLmZKJdi87lEESYBwmw55H8y2/WIH+fpw4FEMWQWNig6hXW
         WxID7C6PW7Pj1KGiNjEm5/r+Vqrpikw3PWQEoxoP0TN1+T7VN2K6eunnuLheP8d5KP/5
         svHn0uEtGjsvjcDfsIzoNBTpqaQTzNZ1UEv9P2OIMHtCdDwnYvfaVdpWKhx6JIO0z3T8
         tNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752506086; x=1753110886;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2Mly3ZZQYDnlEsq3pZjTSNYHkF/08sz7EiTQ0FuSgIM=;
        b=gk6V+X6gVH/yxyjir9/pltqUsg3K19QvFMYCW1WzLwEZrQrAu4LS2H3YNEqryM1afX
         ysmZrIA700RCKq3fyoCkbmjwadKBEZFw/VcaLlxZDOAjkWpPzup3U3pZk1kB4nMacEvn
         6na45ggb2gV4Y6Ad8p0MQd1QUFet6TyO5X8PqojHFbijUWCdnjXqawie/jOOQ4FoEdB6
         2fXTp1DnBHEaYXuT5PcahmRixSitJnAgqbe3sDsFMFbVIFk6ecEDwg6HfRbdNKFA60KQ
         nIi8Cp8UCtbewqv51TUSOJXzduxAxZY3rXVX2ECH1uh2oe3xE2+yDfdYkWcyC+a+BPo7
         BTcg==
X-Forwarded-Encrypted: i=1; AJvYcCUh4e29F63oiwzhK+AVe26R+36hlDJteH9B+HLpXOZZYCbqU3kodpB5MK/RRuNhpPjJEFY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyubho0XTh5Roaz/RtDDuqvrAduSb7jNyWNZRbrKEgSMpGwnYGQ
	9aGxr3dXVmFS64Jb8k0PgS8TUWrMAO9nKgfdvNFtKFGsqJjhLESK4iy+Vmm34Y037VooOTd/bBX
	Y6UzxPQ==
X-Google-Smtp-Source: AGHT+IFBQoWH3T35EGiYhrDKTL5i22UHbM257opXaQWUd5rayk7z4NwPu6Y8eWW3cbf2CEYUVF5qa++lnWc=
X-Received: from pjbss4.prod.google.com ([2002:a17:90b:2ec4:b0:31c:2fe4:33be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d610:b0:313:fb08:4261
 with SMTP id 98e67ed59e1d1-31c4cd55c4cmr19544828a91.32.1752506085892; Mon, 14
 Jul 2025 08:14:45 -0700 (PDT)
Date: Mon, 14 Jul 2025 08:14:44 -0700
In-Reply-To: <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com> <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
 <aHUYwCNDWlsar3qk@google.com> <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
Message-ID: <aHUe5HY4C2vungCd@google.com>
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Sean Christopherson <seanjc@google.com>
To: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Srikanth Aithal <sraithal@amd.com>, linux-next@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025, Zheyun Shen wrote:
> The problem is triggered by the following codes in tools/testing/selftest=
s/kvm/x86/sev_migrate_tests.c:
> static void test_sev_migrate_from(bool es)
> {
> 	struct kvm_vm *src_vm;
> 	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
> 	int i, ret;
>=20
> 	src_vm =3D sev_vm_create(es);
> 	for (i =3D 0; i < NR_MIGRATE_TEST_VMS; ++i)
> 		dst_vms[i] =3D aux_vm_create(true);
>=20
> 	/* Initial migration from the src to the first dst. */
> 	sev_migrate_from(dst_vms[0], src_vm);
>=20
> 	for (i =3D 1; i < NR_MIGRATE_TEST_VMS; i++)
> 		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);
>=20
> 	/* Migrate the guest back to the original VM. */
> 	ret =3D __sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - 1]);
> 	TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EIO,
> 		    "VM that was migrated from should be dead. ret %d, errno: %d", ret,
> 		    errno);
>=20
> 	kvm_vm_free(src_vm);
> 	for (i =3D 0; i < NR_MIGRATE_TEST_VMS; ++i)
> 		kvm_vm_free(dst_vms[i]);
> }
>=20
> I add some logs in kvm and following shows the result:
> [   51.618135] sev guest init kvm:ff177f272432e000                       =
                                                          =20

Argh, I forgot that sev_vm_move_enc_context_from() requires the destination=
 to
*not* be an SEV guest.  KVM needs to explicitly copy over the stack.

> [   51.627235] kvm destory vm kvm:ff177f272432e000                       =
                                                           =20
> [   51.628011] kvm destory vm mmu notifier unregister kvm:ff177f272432e00=
0                                                         =20
> [   51.642840] kvm destory vm arch destory vm kvm:ff177f272432e000       =
                                                          =20
> [   51.673612] vm destory x86                                            =
                                                          =20
> [   51.673957] svm vm destory                                            =
                                                          =20
> [   51.674401] kvm destory vm kvm:ff177f272432c000                       =
                                                           =20
> [   51.675152] kvm destory vm mmu notifier unregister kvm:ff177f272432c00=
0                                                         =20
> [   51.675981] kvm destory vm arch destory vm kvm:ff177f272432c000       =
                                                          =20
> [   51.715937] vm destory x86                                            =
                                                          =20
> [   51.716289] svm vm destory                                            =
                                                          =20
> [   51.716754] kvm destory vm kvm:ff177f272432a000                       =
                                                           =20
> [   51.717530] kvm destory vm mmu notifier unregister kvm:ff177f272432a00=
0                                                         =20
> [   51.718363] kvm destory vm arch destory vm kvm:ff177f272432a000       =
                                                          =20
> [   51.746672] vm destory x86
> [   51.747018] svm vm destory
> [   51.747454] kvm destory vm kvm:ff177f2724328000
> [   51.748219] kvm destory vm mmu notifier unregister kvm:ff177f272432800=
0
> [   51.749033] BUG: kernel NULL pointer dereference, address: 00000000000=
00000
> [   51.749885] #PF: supervisor read access in kernel mode
> [   51.750519] #PF: error_code(0x0000) - not-present page
>=20
> It seems that the cpumask structure is not transferred correctly from
> ff177f272432e000 to ff177f2724328000.  But unfortunately I=E2=80=99m not =
familiar
> with SEV migration. I need to spend some time looking into how SEV migrat=
ion
> works in order to solve this issue.

...

> >> I can reproduce this issue in my environment, and I will try to resolv=
e it as
> >> soon as possible.
> >=20
> > Phew, that's good, because I can't repro this, and I don't see anything=
 obviously
> > wrong.

/facepalm

-ENOCOFFEE.  I was conflating CONFIG_VMAP_STACK with CONFIG_CPUMASK_OFFSTAC=
K and
thus testing the wrong thing.

I think this is the fix, testing now...

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 95668e84ab86..1476e877b2dc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1936,6 +1936,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, str=
uct kvm *src_kvm)
        dst->enc_context_owner =3D src->enc_context_owner;
        dst->es_active =3D src->es_active;
        dst->vmsa_features =3D src->vmsa_features;
+       memcpy(&dst->have_run_cpus, &src->have_run_cpus, sizeof(src->have_r=
un_cpus));
=20
        src->asid =3D 0;
        src->active =3D false;
@@ -1943,6 +1944,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, str=
uct kvm *src_kvm)
        src->pages_locked =3D 0;
        src->enc_context_owner =3D NULL;
        src->es_active =3D false;
+       memset(&src->have_run_cpus, 0, sizeof(src->have_run_cpus));
=20
        list_cut_before(&dst->regions_list, &src->regions_list, &src->regio=
ns_list);

