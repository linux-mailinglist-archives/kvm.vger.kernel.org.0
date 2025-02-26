Return-Path: <kvm+bounces-39223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF8BA453FD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 04:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52C3216E2CD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91D32566DF;
	Wed, 26 Feb 2025 03:26:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2D254B0D;
	Wed, 26 Feb 2025 03:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740540406; cv=none; b=CqyuorYYrHtl+RMXkRSW8e6zz1wXUAa1ADAMI+JAGshH7HskzFZESVGsNGcuL7Dop2+LN4CyYuWz4CO8pkQoKDK8jUxvKDj3UmpQyDzVgp/uWoMHJVx3sQZ3YmwUxmvemKLZH2k3h+0dDtwAprQN+oZ+/Bv5gyijoEBwBbQhpbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740540406; c=relaxed/simple;
	bh=qPkEScglKByJZT7BS8LBCP/UdriUkwRQSvTwEGsB+/0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=L3TwLqJibzy6jUHjcO+CPASN3krF/QhFM6xMXcnMsYonOJn5McVemDiuMVGN0mOzS0i3Y2JO3ayJw77rWSwP0v7zc21AdeiYvto5RIA9lW0ozuOnmHD03VZj73AhDewpOtnu+IFAvvy7189Bzts5LJu7Xb1F/QLoe87l/xwYtF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 36EBE1008EB20;
	Wed, 26 Feb 2025 11:26:39 +0800 (CST)
Received: from smtpclient.apple (unknown [10.180.86.250])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id F090037C98C;
	Wed, 26 Feb 2025 11:26:38 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v7 3/3] KVM: SVM: Flush cache only on CPUs running SEV
 guest
From: Zheyun Shen <szy0127@sjtu.edu.cn>
In-Reply-To: <Z75se_OZQvaeQE-4@google.com>
Date: Wed, 26 Feb 2025 11:26:28 +0800
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 pbonzini@redhat.com,
 tglx@linutronix.de,
 Kevin Loughlin <kevinloughlin@google.com>,
 mingo@redhat.com,
 bp@alien8.de,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D32EF18F-7C4D-466B-9058-1EBD4C378EFC@sjtu.edu.cn>
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
 <20250128015345.7929-4-szy0127@sjtu.edu.cn> <Z75se_OZQvaeQE-4@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3826.200.121)

I'm very sorry that the formatting of my previous email was messed up =
due to an issue with the email client. I am sending a new email with the =
same content.

> Sean Christopherson <seanjc@google.com> wrote=EF=BC=9A
>=20
> On Tue, Jan 28, 2025, Zheyun Shen wrote:
>> On AMD CPUs without ensuring cache consistency, each memory page
>> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
>> thereby affecting the performance of other programs on the host.
>>=20
>> Typically, an AMD server may have 128 cores or more, while the SEV =
guest
>> might only utilize 8 of these cores. Meanwhile, host can use =
qemu-affinity
>> to bind these 8 vCPUs to specific physical CPUs.
>>=20
>> Therefore, keeping a record of the physical core numbers each time a =
vCPU
>> runs can help avoid flushing the cache for all CPUs every time.
>>=20
>> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
>> ---
>> arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++++++++++++---
>> arch/x86/kvm/svm/svm.c |  2 ++
>> arch/x86/kvm/svm/svm.h |  5 ++++-
>> 3 files changed, 33 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 1ce67de9d..4b80ecbe7 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -252,6 +252,27 @@ static void sev_asid_free(struct kvm_sev_info =
*sev)
>> sev->misc_cg =3D NULL;
>> }
>>=20
>> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>=20
> And now I'm very confused.
>=20
> v1 and v2 marked the CPU dirty in pre_sev_run(), which AFAICT is =
exactly when a
> CPU should be recorded as having dirtied memory.  v3 fixed a bug with =
using
> get_cpu(), but otherwise was unchanged.  Tom even gave a Tested-by for =
v3.
>=20
> Then v4 comes along, and without explanation, moved the code to =
vcpu_load().
>=20
I apologize for not including sufficient information in the changelog, =
which led to your confusion.

> Changed the time of recording the CPUs from pre_sev_run() to =
vcpu_load().
>=20
> Why?  If there's a good reason, then that absolutely, positively =
belongs in the
> changelog and in the code as a comment.  If there's no good reason, =
then...
>=20
The reason I moved the timing of CPU recording from pre_sev_run(=EF=BC=89 =
to vcpu_load() is that I found vcpu_load() is always present in the call =
path of kvm_arch_vcpu_ioctl_run(). Moreover, whenever a vCPU migration =
occurs, the control flow will reach vcpu_load() again to ensure the =
correctness of CPU recording. On the other hand, recording information =
in pre_sev_run() would result in recording the CPU number every time =
before entering the guest. Without vCPU migration, only the first time =
to record is effective and the subsequent records are redundant and thus =
waste time. This would result in each VM exit taking longer (although =
the additional time may be very short).

> Unless I hear otherwise, my plan is to move this back to =
pre_sev_run().
>=20

Another issue in the v3 version is that I incorrectly cleared the =
recorded mask after each cache flushing. The mask bits should be cleared =
and changed at the time of vCPU migration rather than after a cache =
flushing.=

