Return-Path: <kvm+bounces-52339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB22B0424F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 862723A87CE
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6088B25B2F4;
	Mon, 14 Jul 2025 14:57:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C570259CB0;
	Mon, 14 Jul 2025 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505029; cv=none; b=ZV/aR09l2nrX94WVE2T5saJVHal6MZoAWe3arbsYlx0SLaWE75xER8qz6gA958o0CuoLKCl9b0354ipCfOW9d1pvZPEa4CjQUUIvDyO5ssOOZlry1kXPGHLg2ALCY5bm43y1uvuT1TF3ZGkGgzHFg5uJfbgLyb6U8gRkJyQOjGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505029; c=relaxed/simple;
	bh=CVaX47SHOe4vJ05VeCEEWy1KKUEuNVXFqHTL3r5qeSk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=f/DiWHBoeG/wE23/GF6zE1j3NvEtIHwEiqImvGVJFVpQ61XNXsE2lnKu1KIYo+/Unk1A+dgZbHhfRCCyGNoKNEy+t84cJJADjzbZ2bEDljjiRICsMvBuHgMAgO4fCz+Mq4D8NyHxMscp29/P7wGRlVrnPpfwKGzSqsVbQIYSRYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 3318710051698;
	Mon, 14 Jul 2025 22:57:02 +0800 (CST)
Received: from smtpclient.apple (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id B68BC37C929;
	Mon, 14 Jul 2025 22:56:59 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Zheyun Shen <szy0127@sjtu.edu.cn>
In-Reply-To: <aHUYwCNDWlsar3qk@google.com>
Date: Mon, 14 Jul 2025 22:56:44 +0800
Cc: Srikanth Aithal <sraithal@amd.com>,
 linux-next@vger.kernel.org,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <15D0C887-E17F-4432-8716-BF62EEE61B6B@sjtu.edu.cn>
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com>
 <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
 <aHUYwCNDWlsar3qk@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)

The problem is triggered by the following codes in =
tools/testing/selftests/kvm/x86/sev_migrate_tests.c:
static void test_sev_migrate_from(bool es)
{
	struct kvm_vm *src_vm;
	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
	int i, ret;

	src_vm =3D sev_vm_create(es);
	for (i =3D 0; i < NR_MIGRATE_TEST_VMS; ++i)
		dst_vms[i] =3D aux_vm_create(true);

	/* Initial migration from the src to the first dst. */
	sev_migrate_from(dst_vms[0], src_vm);

	for (i =3D 1; i < NR_MIGRATE_TEST_VMS; i++)
		sev_migrate_from(dst_vms[i], dst_vms[i - 1]);

	/* Migrate the guest back to the original VM. */
	ret =3D __sev_migrate_from(src_vm, dst_vms[NR_MIGRATE_TEST_VMS - =
1]);
	TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EIO,
		    "VM that was migrated from should be dead. ret %d, =
errno: %d", ret,
		    errno);

	kvm_vm_free(src_vm);
	for (i =3D 0; i < NR_MIGRATE_TEST_VMS; ++i)
		kvm_vm_free(dst_vms[i]);
}

I add some logs in kvm and following shows the result:
[   51.618135] sev guest init kvm:ff177f272432e000                       =
                                                          =20
[   51.627235] kvm destory vm kvm:ff177f272432e000                       =
                                                           =20
[   51.628011] kvm destory vm mmu notifier unregister =
kvm:ff177f272432e000                                                     =
    =20
[   51.642840] kvm destory vm arch destory vm kvm:ff177f272432e000       =
                                                          =20
[   51.673612] vm destory x86                                            =
                                                          =20
[   51.673957] svm vm destory                                            =
                                                          =20
[   51.674401] kvm destory vm kvm:ff177f272432c000                       =
                                                           =20
[   51.675152] kvm destory vm mmu notifier unregister =
kvm:ff177f272432c000                                                     =
    =20
[   51.675981] kvm destory vm arch destory vm kvm:ff177f272432c000       =
                                                          =20
[   51.715937] vm destory x86                                            =
                                                          =20
[   51.716289] svm vm destory                                            =
                                                          =20
[   51.716754] kvm destory vm kvm:ff177f272432a000                       =
                                                           =20
[   51.717530] kvm destory vm mmu notifier unregister =
kvm:ff177f272432a000                                                     =
    =20
[   51.718363] kvm destory vm arch destory vm kvm:ff177f272432a000       =
                                                          =20
[   51.746672] vm destory x86
[   51.747018] svm vm destory
[   51.747454] kvm destory vm kvm:ff177f2724328000
[   51.748219] kvm destory vm mmu notifier unregister =
kvm:ff177f2724328000
[   51.749033] BUG: kernel NULL pointer dereference, address: =
0000000000000000
[   51.749885] #PF: supervisor read access in kernel mode
[   51.750519] #PF: error_code(0x0000) - not-present page

It seems that the cpumask structure is not transferred correctly from =
ff177f272432e000 to ff177f2724328000.
But unfortunately I=E2=80=99m not familiar with SEV migration. I need to =
spend some time looking into how SEV=20
migration works in order to solve this issue.

Thanks,
Zheyun Shen

> 2025=E5=B9=B47=E6=9C=8814=E6=97=A5 22:48=EF=BC=8CSean Christopherson =
<seanjc@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Jul 14, 2025, Zheyun Shen wrote:
>> Hi Aithal,
>> I can reproduce this issue in my environment, and I will try to =
resolve it as
>> soon as possible.
>=20
> Phew, that's good, because I can't repro this, and I don't see =
anything obviously
> wrong.
>=20
>>> 2025=E5=B9=B47=E6=9C=8814=E6=97=A5 13:21=EF=BC=8CAithal, Srikanth =
<sraithal@amd.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hello,
>>>=20
>>> While running the kselftest for SEV migration (sev_migrate_tes) on
>>> linux-next (6.16.0-rc5-next-20250711, commit a62b7a37e6) on an =
AMD-based
>>> paltforms [Milan,Genoa,Turin], I encountered below kernel crash =
while
>>> running kvm kselftests:
>>>=20
>>> [ 714.008402] BUG: kernel NULL pointer dereference, address: =
0000000000000000
>>> [ 714.015363] #PF: supervisor read access in kernel mode
>>> [ 714.020504] #PF: error_code(0x0000) - not-present page
>>> [ 714.025643] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
>>> [ 714.031303] Oops: Oops: 0000 [#1] SMP NOPTI
>>> [ 714.035487] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Not =
tainted 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 =
PREEMPT(voluntary)
>>> [ 714.048253] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS =
2.17.0 12/04/2024
>>> [ 714.055905] RIP: 0010:_find_first_bit+0x1d/0x40
>=20
> ..
>=20
>>> [ 714.148307] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
>>> [ 714.153544] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
>>> [ 714.159115] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
>>> [ 714.164817] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
>>> [ 714.169896] mmu_notifier_unregister+0x53/0xf0
>>> [ 714.174343] kvm_destroy_vm+0x12d/0x2d0 [kvm]
>>> [ 714.178727] kvm_vm_stats_release+0x34/0x60 [kvm]
>>> [ 714.183459] __fput+0xf2/0x2d0
>>> [ 714.186520] fput_close_sync+0x44/0xa0
>>> [ 714.190269] __x64_sys_close+0x42/0x80
>>> [ 714.194024] x64_sys_call+0x1960/0x2180
>>> [ 714.197861] do_syscall_64+0x56/0x1e0
>>> [ 714.201530] entry_SYSCALL_64_after_hwframe+0x76/0x7e


