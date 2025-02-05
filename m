Return-Path: <kvm+bounces-37364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65906A2960F
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA882168432
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B071D7E31;
	Wed,  5 Feb 2025 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LTTqiC4M"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC21519BA;
	Wed,  5 Feb 2025 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772337; cv=none; b=ZTIig3diR0Zc+haSYXmTaODluh19QAM8wxLWgUudgutcobTuSB0ego6l0g/Mid+/iOrR6dzfC7maql9e39PpGnRVyTGWQ+3eTdn9rfJmEAsZISsKmI3RMRLLXUdH9Ku+KU7D9Qlgz1F5MNOK2NYUk2kKsqRMmufxlAHxxKmaUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772337; c=relaxed/simple;
	bh=2B10IHhwV+fD52/8ngYPa5UP9kbyA71ZWPhfsV+pCE4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=BXMcTxnMTACyShyY6PZIxdZ75NTKiFlHEzTl9ZMiBhb+fFUnqxQPQd7Eqj6IK4AZXaivy/YSEgat42ds8qUOC92GHfKRv1hPDrHChA1kqex3qGiRy59nQ0mFMAvuMkAGxhS8KUtRE4x7QO9TcY0g4E1LWKCUYj18NvG6g5EdHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LTTqiC4M; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=yYNYds3ilPbUKF8CC1VPmTA+jLg8X3b2oPBrNXV66HY=; b=LTTqiC4MRODsMQ14H/4j8BtQsp
	E22EjNARwljjPncg99fuUSqKTiC+EMNCBgDQNnO0+X+cPF807+OonaHxEAPlon6TPwmSYdxO4d7Li
	gXNB+mx1Jmgguf1xettw7KMQ744Le1ESiLU6W8mdgTTHJ3WnKQzkNxuehU+W9+10RU8PQKInPxfUz
	aUvzOTOtE/9lbp6xjrjD+NeJ+d+GqOFXep+YbThhkD5KPraiZIEhin/X0BKx41rwvdR4Gf8sp3UrR
	W7DdZi05YyXDHoUjYKP4J3iYmRRR/1U2My1ZzZdo49LZ4n0UWIrjVOcDDGttu+1om1X+0qtlSdAmr
	J17GSFhw==;
Received: from [2a00:23ee:1cc0:4ec:554b:727b:8793:1097] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfi71-0000000GhH7-1jro;
	Wed, 05 Feb 2025 16:18:51 +0000
Date: Wed, 05 Feb 2025 16:18:46 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/5=5D_KVM=3A_x86/xen=3A_Restrict_hy?=
 =?US-ASCII?Q?percall_MSR_to_unofficial_synthetic_range?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Z6OI5VMDlgLbqytM@google.com>
References: <20250201011400.669483-1-seanjc@google.com> <20250201011400.669483-2-seanjc@google.com> <43f702b383fb99d435f2cdb8ef35cc1449fe6c23.camel@infradead.org> <Z6N-kn1-p6nIWHeP@google.com> <cd3fb8dd79d7766f383748ec472de3943021eb39.camel@infradead.org> <Z6OI5VMDlgLbqytM@google.com>
Message-ID: <48FAD370-09F1-47AA-8892-8BE29DC8A949@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 5 February 2025 15:51:01 GMT, Sean Christopherson <seanjc@google=2Ecom> =
wrote:
>On Wed, Feb 05, 2025, David Woodhouse wrote:
>>=20
>> Save/restore on the MSR makes no sense=2E It's a write-only MSR; writin=
g
>> to it has no effect *other* than populating the target page=2E In KVM w=
e
>> don't implement reading from it at all; I don't think Xen does either?
>
>Hah, that's another KVM bug, technically=2E  KVM relies on the MSR not be=
ing handled
>in order to generate the write-only semantics, but if the MSR index colli=
des with
>an MSR that KVM emulates, then the MSR would be readable=2E  KVM supports=
 Hyper-V's
>HV_X64_MSR_TSC_INVARIANT_CONTROL (0x40000118), so just a few hundred more=
 MSRs
>until fireworks :-)

Nah, I don't see that as a bug=2E If there's a conflict then the Xen hyper=
call MSR "steals" writes from the one it conflicts with, sure=2E But since =
it's a write-only MSR the conflicting one still works fine for reads=2E Whi=
ch means that Xen can "conflict" with a read-only MSR and nobody cares; arg=
uably there's no bug at all in that case=2E

>> Those two happen in reverse chronological order, don't they? And in the
>> lower one the comment tells you that hyperv_enabled() doesn't work yet=
=2E
>> When the higher one is called later, it calls kvm_xen_init() *again* to
>> put the MSR in the right place=2E
>>=20
>> It could be prettier, but I don't think it's broken, is it?
>
>Gah, -ENOCOFFEE=2E

I'll take the criticism though; that code is distinctly non-obvious, even =
with that hint in the comment about hyperv_enabled() not being usable yet=
=2E

ISTR we needed to do the Xen init early on, even before we knew precisely =
which MSR to use=2E And that's why we do it that way and then just call the=
 function again later if we need to change the MSR=2E I'll see if that can =
be simplified, and at the very least I'll update the existing comment to ex=
plicitly state that the function will get called again later if needed=2E

You shouldn't *need* coffee to understand the code=2E

>> > Userspace breakage aside, disallowng host writes would fix the immedi=
ate issue,
>> > and I think would mitigate all concerns with putting the host at risk=
=2E=C2=A0 But it's
>> > not enough to actually make an overlapping MSR index work=2E=C2=A0 E=
=2Eg=2E if the MSR is
>> > passed through to the guest, the write will go through to the hardwar=
e MSR, unless
>> > the WRMSR happens to be emulated=2E
>> >=20
>> > I really don't want to broadly support redirecting any MSR, because t=
o truly go
>> > down that path we'd need to deal with x2APIC, EFER, and other MSRs th=
at have
>> > special treatment and meaning=2E
>> >=20
>> > While KVM's stance is usually that a misconfigured vCPU model is user=
space's
>> > problem, in this case I don't see any value in letting userspace be s=
tupid=2E=C2=A0 It
>> > can't work generally, it creates unique ABI for KVM_SET_MSRS, and unl=
ess there's
>> > a crazy use case I'm overlooking, there's no sane reason for userspac=
e to put the
>> > index in outside of the synthetic range (whereas defining seemingly n=
onsensical
>> > CPUID feature bits is useful for testing purposes, implementing suppo=
rt in
>> > userspace, etc)=2E
>>=20
>> Right, I think we should do *both*=2E Blocking host writes solves the
>> issue of locking problems with the hypercall page setup=2E All it would
>> take for that issue to recur is for us (or Microsoft) to invent a new
>> MSR in the synthetic range which is also written on vCPU init/reset=2E
>> And then the sanity check on where the VMM puts the Xen MSR doesn't
>> save us=2E
>
>Ugh, indeed=2E  MSRs are quite the conundrum=2E  Userspace MSR filters ha=
ve a similar
>problem, where it's impossible to know the semantics of future hardware M=
SRs, and
>so it's impossible to document which MSRs userspace is allowed to interce=
pt :-/
>
>Oh!  It doesn't help KVM avoid breaking userspace, but a way for QEMU to =
avoid a
>future collision would be to have QEMU start at 0x40000200 when Hyper-V i=
s enabled,
>but then use KVM_GET_MSR_INDEX_LIST to detect a collision with KVM Hyper-=
V, e=2Eg=2E
>increment the index until an available index is found (with sanity checks=
 and whatnot)=2E

Makes sense=2E I think that's a third separate patch, yes?

>> But yes, we should *also* do that sanity check=2E
>
>Ah, I'm a-ok with that=2E


