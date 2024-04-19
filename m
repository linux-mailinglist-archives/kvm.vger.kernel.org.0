Return-Path: <kvm+bounces-15263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C838AAE77
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA8BB1C20D4D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A20020300;
	Fri, 19 Apr 2024 12:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a899tjid"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2252E622;
	Fri, 19 Apr 2024 12:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713529852; cv=none; b=gEAVS930EGuK33OvTSWg8YrY1rU4EwRSxclHxUrdL/ww3U3ElcEhNr9P7r5ZDCTHMLT1RQZBYrDHoxr5DlWvKxwjKgzyz1+3Us1xCwniHkOQb6HZU36VzldrQa2XnKiFibx/+z0+CLgCPNdWqbtF555ae77+nJBIDRfaRj53zdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713529852; c=relaxed/simple;
	bh=d3LnSllhTHTvYSq58METac5iIO+H5uvJi46fuvkGTaE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WHt4rNXP2ekWm4wy/2mD5zk6iKg+LeJoO+l+/vCBEtG22fD0Tb7vWi+wKhpG/EerF+q2Zt5BWJ/Zk63mK742CdrfbT/B7JRYPawgtds/c2mZzQq8D/+QXIjjrdqZ8HySj14uccxEPcT0au+o6RYNYV3wuGbR5cDiB4q9iECIRXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a899tjid; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nXt65ZLFmnexpaQiCeXtPXBrT6SRBX/7hgJn979CrEc=; b=a899tjidBzNXqhq07spL4NJY7v
	Yipu7u7+TCViJqW3/WIvVGRv8Ci0sZ91buGf9Sc8OgGoe3Zn0f8lbSkElrFiYko+nCU95lcJQp+lB
	UwtVoqx7BY1JLuc/vl6lAIPZ8zojtbv/igW+j1IhlvnQceQjsh1XlC0QO1McmR3O0R6axzqSpwr/g
	jDmHHKiIjpZz1pWTxDnBmzD4J+AT1evNaOWn8yfo0JXt4yCnooGQj5nJvyyQDJpGsMegzl11ldaKu
	y41Cg1qxo9H3H1ocBo+gR3jYTNIqS76N4AooS73uzm/blAq8YxDdlEOmc24XunyM8aeBmByHL4yrR
	fvdid0Dw==;
Received: from [2001:8b0:10b:5:c08e:a4fc:45a2:fa90] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxnO6-00000007d8B-3ci6;
	Fri, 19 Apr 2024 12:30:43 +0000
Message-ID: <f22f17979d9202e2cf9580d9f82ce525645faf30.camel@infradead.org>
Subject: Re: [PATCH] KVM: x86: Don't unnecessarily force masterclock update
 on vCPU hotplug
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Dongli Zhang
	 <dongli.zhang@oracle.com>
Date: Fri, 19 Apr 2024 13:30:42 +0100
In-Reply-To: <20231018195638.1898375-1-seanjc@google.com>
References: <20231018195638.1898375-1-seanjc@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-k6XtwhPTDZF0YsoMPfnX"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-k6XtwhPTDZF0YsoMPfnX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-10-18 at 12:56 -0700, Sean Christopherson wrote:
> Don't force a masterclock update when a vCPU synchronizes to the current
> TSC generation, e.g. when userspace hotplugs a pre-created vCPU into the
> VM.=C2=A0 Unnecessarily updating the masterclock is undesirable as it can=
 cause
> kvmclock's time to jump, which is particularly painful on systems with a
> stable TSC as kvmclock _should_ be fully reliable on such systems.
>=20
> The unexpected time jumps are due to differences in the TSC=3D>nanosecond=
s
> conversion algorithms between kvmclock and the host's CLOCK_MONOTONIC_RAW
> (the pvclock algorithm is inherently lossy).=C2=A0 When updating the
> masterclock, KVM refreshes the "base", i.e. moves the elapsed time since
> the last update from the kvmclock/pvclock algorithm to the
> CLOCK_MONOTONIC_RAW algorithm.=C2=A0 Synchronizing kvmclock with
> CLOCK_MONOTONIC_RAW is the lesser of evils when the TSC is unstable, but
> adds no real value when the TSC is stable.
>=20
> Prior to commit 7f187922ddf6 ("KVM: x86: update masterclock values on TSC
> writes"), KVM did NOT force an update when synchronizing a vCPU to the
> current generation.
>=20
> =C2=A0 commit 7f187922ddf6b67f2999a76dcb71663097b75497
> =C2=A0 Author: Marcelo Tosatti <mtosatti@redhat.com>
> =C2=A0 Date:=C2=A0=C2=A0 Tue Nov 4 21:30:44 2014 -0200
>=20
> =C2=A0=C2=A0=C2=A0 KVM: x86: update masterclock values on TSC writes
>=20
> =C2=A0=C2=A0=C2=A0 When the guest writes to the TSC, the masterclock TSC =
copy must be
> =C2=A0=C2=A0=C2=A0 updated as well along with the TSC_OFFSET update, othe=
rwise a negative
> =C2=A0=C2=A0=C2=A0 tsc_timestamp is calculated at kvm_guest_time_update.
>=20
> =C2=A0=C2=A0=C2=A0 Once "if (!vcpus_matched && ka->use_master_clock)" is =
simplified to
> =C2=A0=C2=A0=C2=A0 "if (ka->use_master_clock)", the corresponding "if (!k=
a->use_master_clock)"
> =C2=A0=C2=A0=C2=A0 becomes redundant, so remove the do_request boolean an=
d collapse
> =C2=A0=C2=A0=C2=A0 everything into a single condition.
>=20
> Before that, KVM only re-synced the masterclock if the masterclock was
> enabled or disabled=C2=A0 Note, at the time of the above commit, VMX
> synchronized TSC on *guest* writes to MSR_IA32_TSC:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case MSR_IA32_TSC:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm_write_tsc(vcpu, msr_info);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 break;
>=20
> which is why the changelog specifically says "guest writes", but the bug
> that was being fixed wasn't unique to guest write, i.e. a TSC write from
> the host would suffer the same problem.
>=20
> So even though KVM stopped synchronizing on guest writes as of commit
> 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on guest
> writes"), simply reverting commit 7f187922ddf6 is not an option.=C2=A0 Fi=
guring
> out how a negative tsc_timestamp could be computed requires a bit more
> sleuthing.
>=20
> In kvm_write_tsc() (at the time), except for KVM's "less than 1 second"
> hack, KVM snapshotted the vCPU's current TSC *and* the current time in
> nanoseconds, where kvm->arch.cur_tsc_nsec is the current host kernel time
> in nanoseconds:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ns =3D get_kernel_ns();
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (usdiff < USEC_PER_SEC &&
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->=
arch.virtual_tsc_khz =3D=3D kvm->arch.last_tsc_khz) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * We split periods of matched TSC writes into gene=
rations.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * For each generation, we track the original measu=
red
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * nanosecond time, offset, and write, so if TSCs a=
re in
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * sync, we can match exact offset, and if not, we =
can match
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * exact software computation in compute_guest_tsc(=
)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 *
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * These values are tracked in kvm->arch.cur_xxx va=
riables.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm->arch.cur_tsc_generation++;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm->arch.cur_tsc_nsec =3D ns;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm->arch.cur_tsc_write =3D data;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm->arch.cur_tsc_offset =3D offset;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 matched =3D false;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 pr_debug("kvm: new tsc generation %llu, clock %llu\n",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kv=
m->arch.cur_tsc_generation, data);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Keep track of which generat=
ion this VCPU has synchronized to */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->arch.this_tsc_generation=
 =3D kvm->arch.cur_tsc_generation;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->arch.this_tsc_nsec =3D k=
vm->arch.cur_tsc_nsec;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->arch.this_tsc_write =3D =
kvm->arch.cur_tsc_write;
>=20
> Note that the above creates a new generation and sets "matched" to false!
> But because kvm_track_tsc_matching() looks for matched+1, i.e. doesn't
> require the vCPU that creates the new generation to match itself, KVM
> would immediately compute vcpus_matched as true for VMs with a single vCP=
U.
> As a result, KVM would skip the masterlock update, even though a new TSC
> generation was created:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpus_matched =3D (ka->nr_vcpu=
s_matched_tsc + 1 =3D=3D
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 at=
omic_read(&vcpu->kvm->online_vcpus));
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (vcpus_matched && gtod->clo=
ck.vclock_mode =3D=3D VCLOCK_TSC)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!ka->use_master_clock)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_reque=
st =3D 1;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!vcpus_matched && ka->use_=
master_clock)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_reque=
st =3D 1;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (do_request)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>=20
> On hardware without TSC scaling support, vcpu->tsc_catchup is set to true
> if the guest TSC frequency is faster than the host TSC frequency, even if
> the TSC is otherwise stable.=C2=A0 And for that mode, kvm_guest_time_upda=
te(),
> by way of compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the
> kernel time at the last TSC write, to compute the guest TSC relative to
> kernel time:
>=20
> =C2=A0 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
> =C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 tsc =3D pvclock_scale_delt=
a(kernel_ns-vcpu->arch.this_tsc_nsec,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 vcpu->arch.virtual_tsc_mult,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 vcpu->arch.virtual_tsc_shift);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tsc +=3D vcpu->arch.this_tsc_w=
rite;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tsc;
> =C2=A0 }
>=20
> Except the "kernel_ns" passed to compute_guest_tsc() isn't the current
> kernel time, it's the masterclock snapshot!
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&ka->pvclock_gtod_sy=
nc_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 use_master_clock =3D ka->use_m=
aster_clock;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (use_master_clock) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 host_tsc =3D ka->master_cycle_now;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 kernel_ns =3D ka->master_kernel_ns;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&ka->pvclock_gtod_=
sync_lock);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (vcpu->tsc_catchup) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 u64 tsc =3D compute_guest_tsc(v, kernel_ns);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (tsc > tsc_timestamp) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 adjust_t=
sc_offset_guest(v, tsc - tsc_timestamp);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tsc_time=
stamp =3D tsc;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> And so when KVM skips the masterclock update after a TSC write, i.e. afte=
r
> a new TSC generation is started, the "kernel_ns-vcpu->arch.this_tsc_nsec"
> is *guaranteed* to generate a negative value, because this_tsc_nsec was
> captured after ka->master_kernel_ns.

So what? It *should* be negative, shouldn't it? I think the problem is
how we're using that value, and what we're conflating it with.

Let us consider the case where ka->use_master_clock is true, but we're
manually upscaling the TSC in software so vcpu->tsc_catchup is also
true.

Let us postpone, for the moment, the question of whether we should even
*let* use_master_clock become true in that case.

There are a number of points in time which need to be considered:

 =E2=80=A2 vcpu->arch.this_tsc_nsec
 * kvm->arch.master_kernel_ns
 * The point in time "now" at which kvm_guest_time_update() is called.

For any given point in time, compute_guest_tsc() should calculate the
guest TSC at that moment, by scaling the elapsed microseconds since
vcpu->arch.this_tsc_nsec to the guest TSC frequency and adding that to
vcpu->arch.this_tsc_write.

I say "should", because compute_guest_tsc() is currently buggy when
asked to scale a *negative* number. Trivially fixable though.

Now, let's look at what kvm_guest_time_update() is doing. It attempts
to do two things. First it calculates the guest TSC at the reference
point that it's putting into the pvclock structure. That's what needs
to go into the 'tsc_timestamp' field of the pvclock structure alongside
the corresponding KVM clock 'system_time' at 'kernel_ns'. In master
clock mode, the value it uses for kernel_ns is ka->master_kernel_ns,
and otherwise it is the current time..

It's perfectly reasonable for master_kernel_ns to be earlier in time
than vcpu->this_tsc_nsec. That just means the TSC value we write to the
pvclock ends up being lower than the value in vcpu->this_tsc_write, by
an appropriate number of cycles. So as long as compute_guest_tsc()
isn't buggy with negative numbers, that should all be fine.

But there *is* a bug in kvm_guest_time_update(), I think...

In tsc_catchup mode, simulating a TSC which runs faster than the host,
the delta between host and guest TSCs gets larger and larger over
time.=C2=A0That's why kvm_guest_time_update() is called *every* time the
vCPU is entered, to adjust the TSC further and further every time.

But currently, kvm_guest_time_update() only nudges the guest TSC as far
forward as it should have been at master_kernel_ns. At any time later
than master_kernel_ns, the delta should be even higher.

I think compute_guest_tsc() should look something like this, to cope
with the negativity:

static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
{
	s64 delta =3D kernel_ns - vcpu->arch.this_tsc_nsec;
	u64 tsc =3D vcpu->arch.this_tsc_write;

	/* pvclock_scale_delta cannot cope with negative deltas */
	if (delta >=3D 0)
		tsc +=3D pvclock_scale_delta(delta,
					   vcpu->arch.virtual_tsc_mult,
					   vcpu->arch.virtual_tsc_shift);
	else
		tsc -=3D pvclock_scale_delta(-delta,
					   vcpu->arch.virtual_tsc_mult,
					   vcpu->arch.virtual_tsc_shift);

	return tsc;
}

And the catchup code in kvm_guest_time_update() should correct *both*
the reference time *and* the current TSC by *different* amounts,
something like this:

	if (vcpu->tsc_catchup) {
		uint64_t now_guest_tsc_adjusted;
		uint64_t now_guest_tsc_unadjusted;
		int64_t now_guest_tsc_delta;

		tsc_timestamp =3D compute_guest_tsc(v, kernel_ns);

		if (use_master_clock) {
			uint64_t now_host_tsc;
			int64_t now_kernel_ns;

			if (!kvm_get_time_and_clockread(&now_kernel_ns, &now_host_tsc)) {
				now_kernel_ns =3D get_kvmclock_base_ns();
				now_host_tsc =3D rdtsc();
			}
			now_guest_tsc_adjusted =3D compute_guest_tsc(v, now_kernel_ns);
			now_guest_tsc_unadjusted =3D kvm_read_l1_tsc(v, now_host_tsc);
		} else {
			now_guest_tsc_adjusted =3D tsc_timestamp;
			now_guest_tsc_unadjusted =3D kvm_read_l1_tsc(v, kernel_ns);
		}

		now_guest_tsc_delta =3D now_guest_tsc_adjusted -
			now_guest_tsc_unadjusted;

		if (now_guest_tsc_delta > 0)
			adjust_tsc_offset_guest(v, now_guest_tsc_delta);
	} else {
		tsc_timestamp =3D kvm_read_l1_tsc(v, host_tsc);
	}

Then we can drop that extra masterclock update in
kvm_track_tsc_matching(), along with the comment that
compute_guest_tsc() needs the masterclock snapshot to be newer.

> Forcing a masterclock update essentially fudged around that problem, but
> in a heavy handed way that introduced undesirable side effects, i.e.
> unnecessarily forces a masterclock update when a new vCPU joins the party
> via hotplug.
>=20
> Note, KVM forces masterclock updates in other weird ways that are also
> likely unnecessary, e.g. when establishing a new Xen shared info page and
> when userspace creates a brand new vCPU.=C2=A0 But the Xen thing is firml=
y a
> separate mess, and there are no known userspace VMMs that utilize kvmcloc=
k
> *and* create new vCPUs after the VM is up and running.=C2=A0 I.e. the oth=
er
> issues are future problems.
>=20
> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> Closes: https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@o=
racle.com
> Fixes: 7f187922ddf6 ("KVM: x86: update masterclock values on TSC writes")
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
> =C2=A01 file changed, 16 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 530d4bc2259b..61bdb6c1d000 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
> =C2=A0}
> =C2=A0#endif
> =C2=A0
> -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
> +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_gener=
ation)
> =C2=A0{
> =C2=A0#ifdef CONFIG_X86_64
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool vcpus_matched;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_arch *ka =3D &=
vcpu->kvm->arch;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pvclock_gtod_data =
*gtod =3D &pvclock_gtod_data;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpus_matched =3D (ka->nr_vcpu=
s_matched_tsc + 1 =3D=3D
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_r=
ead(&vcpu->kvm->online_vcpus));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * To use the masterclock, the=
 host clocksource must be based on TSC
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * and all vCPUs must have mat=
ching TSCs.=C2=A0 Note, the count for matching
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * vCPUs doesn't include the r=
eference vCPU, hence "+1".
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bool use_master_clock =3D (ka-=
>nr_vcpus_matched_tsc + 1 =3D=3D
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_read(&vcpu->kvm->online_vcpu=
s)) &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gtod_is_based_on_tsc(gtod->clock.vcl=
ock_mode);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Once the masterclock is ena=
bled, always perform request in
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * order to update it.
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * In order to enable mastercl=
ock, the host clocksource must be TSC
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * and the vcpus need to have =
matched TSCs.=C2=A0 When that happens,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * perform request to enable m=
asterclock.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Request a masterclock updat=
e if the masterclock needs to be toggled
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * on/off, or when starting a =
new generation and the masterclock is
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * enabled (compute_guest_tsc(=
) requires the masterclock snapshot to be
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * taken _after_ the new gener=
ation is created).
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ka->use_master_clock ||
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (gtod_is_ba=
sed_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((ka->use_master_clock && n=
ew_generation) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (ka->use_ma=
ster_clock !=3D use_master_clock))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0trace_kvm_track_tsc(vcpu-=
>vcpu_id, ka->nr_vcpus_matched_tsc,
> @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *=
vcpu, u64 offset, u64 tsc,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu->arch.this_tsc_nsec =
=3D kvm->arch.cur_tsc_nsec;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu->arch.this_tsc_write=
 =3D kvm->arch.cur_tsc_write;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_track_tsc_matching(vcpu);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_track_tsc_matching(vcpu, !=
matched);
> =C2=A0}
> =C2=A0
> =C2=A0static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_va=
lue)
>=20
> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc


--=-k6XtwhPTDZF0YsoMPfnX
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwNDE5MTIzMDQyWjAvBgkqhkiG9w0BCQQxIgQgPYOrB2La
j/PnhdUuKqrD4Fnn/+OmYGsx3kmJkdfpvEkwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAGGsd5NCktCXOlDut36UdXlb0bOFUeHOZR
aRvcXvnmEKe+ReF/tWEVDeL7OlkFHuBpoydOVxj757eZW1GXXc4rfR2DcE4Hc9KUnEI0jivBEjFf
tnjAQc+TG11zpCt0s/+Q1zuyfILajFDpNUv/ZmBOrshS8n7i8MPDChaEVrPBpzE4JTpP+slWc7pN
7FHIAM7Pu7ZQacp8JC6uGDX6pc2eNM17JMoPO+Fkn5h63iMNNqZecf49NrYMfNVF+YVVYehq8quX
WH7HFVRlUdLnIAJYSKbqmFA6vD8hY03Fz34bNltSNxya3RFtbB8G/OZh7ypRy8CLKE6ScNxabMRE
v0Mvai7CvRnqTCpxA07/QspVJE8uNIKI3FHSbX9ocDiFQD4Wpw6CbjUWmzIFED02Wz9FFjrdX/ww
MzPGLVLqr6yLmB9HX6vukKGAYGhEahAcKhiqLSaAcOgq+T4uhE43ljhsx2SC4ey1+O7vsf84lo3w
IR/Ytwb6nNn2xykaYkhEHkSkGmF0gzAGOC1YdctAsCUve8/daV+q0VeBP8+rjfs+AqF3uPOfOi5y
Hj2DTFNKk1adMXthCEW4CSEEEy0Tf3hT+GHSz9vrkgTLgzSVcv5Kq82E/0Ghnvew94KTxN2OjJmL
VOF8qcE3AxQUsxSiGSTWwMncLgPHdW4gMwUsed0BGQAAAAAAAA==


--=-k6XtwhPTDZF0YsoMPfnX--

