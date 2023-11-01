Return-Path: <kvm+bounces-273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5854B7DDB53
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D665281816
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D9E10EE;
	Wed,  1 Nov 2023 03:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="a1VZ6os6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E007E8
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:07:36 +0000 (UTC)
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6451F4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 20:07:29 -0700 (PDT)
X-AuthUser: ybhuang@cs.utexas.edu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1698808045;
	bh=l6LfqZb1FfTC/QISMHPLoGO4JMkr37fL/NKypHnd0wo=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=a1VZ6os6dBoUEwfbFPlj/zFWISqLdYtbJ/XCFHQZqbk0J6PCPzi7VPAaxNgn1jQQp
	 rgqUFHJfXLR00C4zOl9i7Ph5gBtaHcYy8oNrkVJ9O5C/d8B89ZaXsjibjE3HRsTLfr
	 C9qpxxvWJ+mpcBWGtJmzdjcOSijzxWnS31dn1sYs=
Received: from smtpclient.apple (035-146-022-132.res.spectrum.com [35.146.22.132])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 3A137NXu041237
	(version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 22:07:24 -0500
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.4\))
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
From: Yibo Huang <ybhuang@cs.utexas.edu>
In-Reply-To: <ZUAlh87sS5pUbBOd@google.com>
Date: Tue, 31 Oct 2023 22:07:23 -0500
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCF46F0A-73F9-4D7E-82B0-1C7A16D3EFF0@cs.utexas.edu>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
 <3E43ADC6-E817-411A-9EBF-B16142B9B478@cs.utexas.edu>
 <ZUAlh87sS5pUbBOd@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3696.120.41.1.4)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Tue, 31 Oct 2023 22:07:25 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

> Yes, it would be helpful to confirm what's going on. =20


Sean was right. It turns out that the actual cause of my example was =
that when doing ioremap,=20
the guest OS will configure the PAT based on the value of guest MTRRs.
The key function is #pat_x_mtrr_type().

In my example, the ivshmem driver tried to ioremap the PCI BAR 2 region =
as WB.
However, for some reason during the VM boot process, OVMF (the BIOS I =
was using)=20
set the corresponding guest MTRRs as UC (Interestingly, SeaBIOS doesn't =
do this).
Therefore,  #pat_x_mtrr_type() determined that the actual memory type =
was UC.
As a result, the guest OS set the corresponding PAT as UC.
This was why ivshmem was not cacheable before removing the guest MTRR =
entry.

After removing the guest MTRR entry, #pat_x_mtrr_type() would return WB.=20=

So this was why ivshmem became cacheable after removing the guest MTRR =
entry.

> What test(s) did you run to determine whether or not the memory was =
truly cacheable?
> KVM emulates the MTRR MSRs themselves, e.g. the guest can read and =
write MTRRs,
> and the guest will _think_ memory has a certain memtype, but that =
doesn't necessarily
> have any impact on the memtype used by the CPU.

Thanks for the clarification. I used a memcpy benchmark (size 500M) to =
determine whether or not the memory was cacheable.
When the memory was not cacheable,  the benchmark took several seconds =
to finish.
When the memory was cacheable, the benchmark took several milliseconds =
to finish.


> Heh, this isn't opinion.  Unless you're running a very specific =
10-year old kernel,
> or a custom KVM build, KVM simply out doesn't propagate guest MTRRs =
into NPT.
>=20
> And unless your setup also has non-coherent DMA attached to the =
device, KVM doesn't
> honor guest MTRRs for EPT either (AFAICT, QEMU ivshmem doesn't require =
VFIO).
>=20
> It's definitely possible that disabling a guest MTRR resulted in =
memory becoming
> cacheable, but unless there's some very, very magical code hiding, =
it's not because
> KVM actually fully virtualizes guest MTRRs on AMD.
>=20
> E.g. before commit 9a3768191d95 ("KVM: x86/mmu: Zap SPTEs on MTRR =
update iff guest
> MTRRs are honored"), which hasn't even made its way to Linus (or =
Paolo's) tree yet,
> KVM unnecessarily zapped all NPT entries on MTRR changes.  Zapping NPT =
entries
> could have cleared some weird TLB state, or perhaps even wiped out =
buggy KVM NPT
> entries.
>=20
> And on AMD, hardware virtualizes gCR0.CD, i.e. puts the caches into =
no-fill mode
> when guest CR0.CD=3D1.  But Intel CPUs completely ignore guest CR0.CD, =
i.e. punt it
> to software, and under QEMU, for all intents and purposes KVM never =
honors guest
> CR0.CD for VMX.  It's seems highly quite unlikely that something in =
the guest left
> CR0.CD=3D1, but it's possible.  And then the guest kernel's process of =
toggling
> CR0.CD when doing MTRR updates would end up clearing CR0.CD and thus =
re-enable
> caching.
>=20
>> The thing was that I could not find any KVM code related to emulating =
guest
>> MTRRs on AMD platforms, which was the reason why I decided to send =
the
>> initial email asking about it.
>>=20
>> I found this in the AMD64 Architecture Programmer=E2=80=99s Manual =
Volumes 1=E2=80=935 (page
>> 553):=20
>>=20
>> "Table 15-19 shows how guest and host PAT types are combined into an
>> effective PAT type. When interpreting this table, recall (a) that =
guest and
>> host PAT types are not combined when nested paging is disabled and =
(b) that
>> the intent is for the VMM to use its PAT type to simulate guest =
MTRRs.=E2=80=9D
>>=20
>> Does this mean that AMD expects the VMM to emulate the effect of =
guest MTRRs
>> by altering the host PAT types?
>=20
> Yes.  Which is exactly what KVM did in commit 3c2e7f7de324 ("KVM: SVM: =
use NPT
> page attributes"), which was a reverted a few months after it was =
introduced.

Again, thanks for the clarification!


