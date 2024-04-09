Return-Path: <kvm+bounces-13965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F9E89D14E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 05:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21121C24343
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F50855E49;
	Tue,  9 Apr 2024 03:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qNhmyzxj"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306554BEF;
	Tue,  9 Apr 2024 03:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634657; cv=none; b=DmI2GW6wsO2M+sYMjsq4ySZ8efR8+gHbBZtURCWWw7rlThPYeQBb2dStNrMB2GMa9Wa+6xlO/HZOnavkDk79I98L/Gy69DY5pVinyfZBU+f/7i4PpaYWPPHLScccDGcYue0+3nf9VD7E6QQ2h6YV2LNNJNqpuZZc16QcM0k74H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634657; c=relaxed/simple;
	bh=D3QRDwURSb1D82em5oIO2807bgI0sgntetivb8uWMbY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u2/ZXITMtMqW+J8L0E/oJTCuc1/LoxP2lToDm1H5wWIj+5rjqZZC87G63knE7rOW0D79JPKz2Uegj1Ne7jM3L41kSAdfcB3nDhiGc/czCxshY8bc5zffKtAoPacxZgAmjgvfkNTAFenoCPq/saQSXfo8lrRpp+B20EVDQ53lg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qNhmyzxj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D3QRDwURSb1D82em5oIO2807bgI0sgntetivb8uWMbY=; b=qNhmyzxjMW6HbohJSSQ0x0JFq7
	kOcdzVnoIj2VagRNFZfAsjuzgPlu4n1kIXmPwBk67dqGua/4tfF2r4ufWtb4V3ZP5n/T6jLAmEPQY
	GRIarHpCqk9kLpBHzFDIzZS3t9paPqRNU6Ip9CGINZ/L+nNKDSTVhxzp/vHYN3lkz2jm/36RxqH/t
	MHVlKdcLe+4jewOXvKhNF6ngywEG8uF4Z9oBTwouOt20UGNBeJZQsuclw+/B/ugA8lp4x05aaIe1D
	t9vukzX6HvYDEphx9GwTT5luVO2HkMugNC4CwWjIfiqArr0F/LT/t/8Ugd9Y/kBp4wMPmp4mSfOq0
	V9Cmc7gA==;
Received: from [2001:8b0:10b:5:2f81:68c0:d3e5:5a65] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ru2VF-00000001GnW-2qbN;
	Tue, 09 Apr 2024 03:50:33 +0000
Message-ID: <b67d05d6a6b08a2f402348aeb9ce2c816b80e1f8.camel@infradead.org>
Subject: Re: [PATCH 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock
 drift fixup
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, Jack Allister
 <jalliste@amazon.com>,  Paolo Bonzini <pbonzini@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Sean Christopherson <seanjc@google.com>,  Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2024 04:50:32 +0100
In-Reply-To: <1195c194-a2cc-6793-009c-376f091be7f0@oracle.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
	 <20240408220705.7637-2-jalliste@amazon.com>
	 <1195c194-a2cc-6793-009c-376f091be7f0@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-dsf7U/9flaLboQtkLwCH"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-dsf7U/9flaLboQtkLwCH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2024-04-08 at 17:34 -0700, Dongli Zhang wrote:
> Hi Jack,
>=20
> On 4/8/24 15:07, Jack Allister wrote:
> > There is a potential for drift between the TSC and a KVM/PV clock when =
the
> > guest TSC is scaled (as seen previously in [1]). Which fixed drift betw=
een
> > timers over the lifetime of a VM.
>=20
> Those patches mentioned "TSC scaling" mutiple times. Is it a necessary to
> reproduce this issue? I do not think it is necessary. The tsc scaling may=
 speed
> up the drift, but not the root cause.

Right. See the three definitions of the KVM clock I described in
https://lore.kernel.org/kvm/7e0040f70c629d365e80d13b339a95e0affa6d61.camel@=
infradead.org/

One is based on the host CLOCK_MONOTONIC_RAW + ka->kvmclock_offset, the
second is based on the reference point in master_kernel_ns /
master_cycle_now,=C2=A0and runs at the rate of the (scaled) guest TSC.

It's the *third* definition, which I called 'Definition C', which is
purely a bug, and which comes from running at the rate of the
*unscaled* guest TSC. And which doesn't exist without TSC scaling.

I don't think this patch needs to talk about the TSC scaling issues at
all. Those, and the existence of 'Definition C', are just bugs.

For that matter, I'm not entirely sure I'd have mentioned 'drift'
either. Yes, the two non-buggy definitions do drift from each other but
that isn't the point of this patch. Let's try again to explain what
*is* the point of this patch...



In all sane environments, ka->use_master_clock is set and 'Definition
B' of the KVM clock is used. The KVM clock is a simple arithmetic
function of the guest TSC.

The existing KVM_GET_CLOCK function isn't just buggy because it uses
'Definition C' and ignores TSC scaling. It's also just fundamentally
wrong as an API.

First let's consider the case of live *update*, where we serialize the
guest and kexec into a new kernel, then resum the guest. So we don't
have to deal with the full horrors of TSC migration, and the broken
algorithm described in the kernel documentation for doing that; we can
just preserve the KVM_VCPU_TSC_OFFSET. (We'll come to that problem
later).

Now, how do we restore the KVM clock? There is no real excuse for this
not being cycle-accurate, and giving the *same* pvclock information
back to the guest as before. The TSC wasn't disrupted at all during the
steal time. And the KVM clock should be precisely the *same* arithmetic
function of the TSC. The pvclock structure shouldn't change by a single
bit! Although in fact we *will* tolerate the data structure changing,
but only if it gives the same *result* (=C2=B11ns for rounding as Jack
notes).

KVM_[GS]ET_CLOCK are fundamentally useless for this. KVM_SET_CLOCK can
attempt to set the KVM clock at a given UTC time, but UTC is an awful
reference. Its frequency is also skewed by NTP, which is probably going
to be unsynchronized on the newly-booted kernel and running at a
different rate w.r.t the TSC than it was on the source.

Using UTC was always stupid because of leap seconds; TAI would have
been better. And one might argue that that aside, KVM_[GS]ET_CLOCK
isn't *such* an awful thing to use for live *migration*.

But wait, we *also* have to migrate the TSC using a wallclock time as a
base, and that naturally introduces some unavoidable discontinuity in
the TSC. So why in $DEITY's name would we use wallclock time as the
reference for migrating the KVM clock, giving it a *different* time
jump from the TSC on which it is based?

Even for live migration, even though the accuracy of the guest clocks
are fundamentally limited by the accuracy of the NTP sync between the
source and destination hosts, why wouldn't the clock jump at least be
*consistent*? We want that precise arithmetic relationship from TSC to
KVM clock to be preserved even in the live *migration* case where we
have to accept that the TSC itself isn't cycle-accurate.

Because we don't have a way to accurately preserve the TSC=E2=86=92KVM cloc=
k
relationship, we are seeing the clocksource watchdog trigger in guests
and disable the TSC clocksource... because the *KVM clock* was used as
a reference and got corrupted :)

So, Jack's patch adds KVM_[GS]ET_CLOCK_GUEST which reads and writes the
actual struct pvclock_vcpu_time_info structure.

> How about to cite the below patch as the beginning. The below patch only
> *avoids* KVM_REQ_MASTERCLOCK_UPDATE in some situations, but never solve t=
he
> problem when KVM_REQ_MASTERCLOCK_UPDATE is triggered ... therefore we nee=
d this
> patchset ...
>=20
> KVM: x86: Don't unnecessarily force masterclock update on vCPU hotplug
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Dc52ffadc65e28ab461fd055e9991e8d8106a0056
>=20
> I think this patch is only closely related to KVM_REQ_MASTERCLOCK_UPDATE,=
 not
> TSC scaling.
>=20
> ...
>=20
> Same as above. I think the key is to explain the issue when
> KVM_REQ_MASTERCLOCK_UPDATE is triggered, not to emphasize the TSC scaling=
.
> Please correct me if I am wrong.

Not sure; I think that's a separate issue too.

> >=20
> > Additional interfaces are added to retrieve & fixup the PV time informa=
tion
> > when a VMM may believe is appropriate (deserialization after live-updat=
e/
> > migration). KVM_GET_CLOCK_GUEST can be used for the VMM to retrieve the
> > currently used PV time information and then when the VMM believes a dri=
ft
> > may occur can then instruct KVM to perform a correction via the setter
> > KVM_SET_CLOCK_GUEST.
> >=20
> > The KVM_SET_CLOCK_GUEST ioctl works under the following premise. The ho=
st
> > TSC & kernel timstamp are sampled at a singular point in time. Using th=
e
>=20
> Typo: "timstamp"
>=20
> > already known scaling/offset for L1 the guest TSC is then derived from =
this
>=20
> I assume you meant to derive guest TSC from TSC offset/scaling, not to de=
rive
> kvmclock. What does "TSC & kernel timstamp" mean?

In ka->use_master_clock mode (Definition B), the KVM clock is defined
in terms of guest TSC ticks since a reference point in time, stored in
ka->master_cycle_now and ka->master_kernel_ns. That is, a TSC, and a
kernel (CLOCK_MONOTONIC_RAW, to be precise) timestamp.

Jack's KVM_SET_CLOCK_GUEST should be taking a new reference point with
kvm_get_time_and_clockread(). As we know, changing the reference point
like that has basically the same effect as a stray invocation of
KVM_REQ_MASTERCLOCK_UPDATE =E2=80=94 it yanks the KVM clock back to 'Defini=
tion
A' based on the CLOCK_MONOTONIC_RAW. But we correct for that...

Next we calculate (correctly via guest TSC frequency) the KVM clock
value which would result with the newly changed reference point.

Then we calculate the *intended* KVM clock at that *same* host TSC
value, by converting to a guest TSC value and running it through the
pvclock information passed into the ioctl.

Then adjust ka->kvmclock_offset by the delta between the two.

And now the KVM clock at this moment is set to *precisely* what it
would was before the live {update,migration}, in relation to the guest
TSC. At least within 1ns.

> > information.
> >=20
> > From here two PV time information structures are created, one which is =
the
> > original time information structure prior to whatever may have caused a=
 PV
> > clock re-calculation (live-update/migration). The second is then using =
the
> > singular point in time sampled just prior. An individual KVM/PV clock f=
or
> > each of the PV time information structures using the singular guest TSC=
.
> >=20
> > A delta is then determined between the two calculated PV times, which i=
s
> > then used as a correction offset added onto the kvmclock_offset for the=
 VM.
> >=20
> > [1]: https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/k=
ernel/git/torvalds/linux.git/commit/?id=3D451a707813ae__;!!ACWV5N9M2RV99hQ!=
OnMXeXj4Plz6xvAc5lYsKaR3d1GDGGGRhZkdLMbxr8Skc_VAv_O1H8qP9igQv4KPCtYDw2ShTUt=
Ed2o3mD5R$=C2=A0
> >=20
> > Suggested-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Jack Allister <jalliste@amazon.com>
> > CC: Paul Durrant <paul@xen.org>
> > ---
> > =C2=A0Documentation/virt/kvm/api.rst | 43 +++++++++++++++++
> > =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 87 ++++++++++++++++++++++++++++++++++
> > =C2=A0include/uapi/linux/kvm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 ++
> > =C2=A03 files changed, 133 insertions(+)
> >=20
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 0b5a33ee71ee..5f74d8ac1002 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6352,6 +6352,49 @@ a single guest_memfd file, but the bound ranges =
must not overlap).
> > =C2=A0
> > =C2=A0See KVM_SET_USER_MEMORY_REGION2 for additional details.
> > =C2=A0
> > +4.143 KVM_GET_CLOCK_GUEST
> > +----------------------------
> > +
> > +:Capability: none
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct pvclock_vcpu_time_info (out)
> > +:Returns: 0 on success, <0 on error
> > +
> > +Retrieves the current time information structure used for KVM/PV clock=
s.
> > +On x86 a PV clock is derived from the current TSC and is then scaled b=
ased
> > +upon the a specified multiplier and shift. The result of this is then =
added
> > +to a system time.
>=20
> Typo: "the a".
>=20
> > +
> > +The guest needs a way to determine the system time, multiplier and shi=
ft. This
> > +can be done by multiple ways, for KVM guests this can be via an MSR wr=
ite to
> > +MSR_KVM_SYSTEM_TIME / MSR_KVM_SYSTEM_TIME_NEW which defines the guest =
physical
> > +address KVM shall put the structure. On Xen guests this can be found i=
n the Xen
> > +vcpu_info.
> > +
> > +This is structure is useful information for a VMM to also know when ta=
king into
> > +account potential timer drift on live-update/migration.
> > +
> > +4.144 KVM_SET_CLOCK_GUEST
> > +----------------------------
> > +
> > +:Capability: none
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct pvclock_vcpu_time_info (in)
> > +:Returns: 0 on success, <0 on error
> > +
> > +Triggers KVM to perform a correction of the KVM/PV clock structure bas=
ed upon a
> > +known prior PV clock structure (see KVM_GET_CLOCK_GUEST).
> > +
> > +If a VM is utilizing TSC scaling there is a potential for a drift betw=
een the
> > +KVM/PV clock and the TSC itself. This is due to the loss of precision =
when
> > +performing a multiply and shift rather than divide for the TSC.
> > +
> > +To perform the correction a delta is calculated between the original t=
ime info
> > +(which is assumed correct) at a singular point in time X. The KVM cloc=
k offset
> > +is then offset by this delta.
> > +
> > =C2=A05. The kvm_run structure
> > =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > =C2=A0
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 47d9f03b7778..5d2e10cd1c30 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6988,6 +6988,87 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kv=
m, void __user *argp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > =C2=A0}
> > =C2=A0
> > +static struct kvm_vcpu *kvm_get_bsp_vcpu(struct kvm *kvm)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_vcpu *vcpu =3D NU=
LL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < KVM_MAX_VC=
PUS; i++) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0vcpu =3D kvm_get_vcpu_by_id(kvm, i);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (!vcpu)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0contin=
ue;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (kvm_vcpu_is_reset_bsp(vcpu))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return vcpu;
> > +}
>=20
> Would the above rely not only on TSC clocksource, but also
> ka->use_master_clock=3D=3Dtrue?
>=20
> =C2=A03125=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ka->use_master=
_clock =3D host_tsc_clocksource && vcpus_matched
> =C2=A03126=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && !ka->backwards_ts=
c_observed
> =C2=A03127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && !ka->boot_vcpu_ru=
ns_old_kvmclock;
>=20
> Should the condition of (ka->use_master_clock=3D=3Dtrue) be checked in th=
e ioctl?
>=20
> > +
> > +static int kvm_vm_ioctl_get_clock_guest(struct kvm *kvm, void __user *=
argp)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_vcpu *vcpu;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu =3D kvm_get_bsp_vcpu(kv=
m);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!vcpu)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!vcpu->arch.hv_clock.tsc=
_timestamp || !vcpu->arch.hv_clock.system_time)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EIO;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (copy_to_user(argp, &vcpu=
->arch.hv_clock, sizeof(vcpu->arch.hv_clock)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EFAULT;
>=20
> What will happen if the vCPU=3D0 (e.g., BSP) thread is racing with here t=
o update
> the vcpu->arch.hv_clock?
>=20
> It is a good idea to making assumption from the VMM (e.g., QEMU) side?

What if the vCPU has never set up the KVM clock and vcpu->arch.hv_clock
isn't even populated?

I don't think we should be using an actual vCPU at all.

I think we have to *create* the pvclock information, just just blindly
memcpy from some vCPU's ->arch.hv_clock.

Yes, we do need to scale via guest TSC frequency, but *only* in the
ka->use_master_clock case because otherwise, everything's hosed anyway.
In the ka->use_master_clock case, where we know all guests are running
at the same TSC frequency, why not just snapshot the scaling factor?=20
We can fix the broken __get_kvmclock_ns() that way too.

In fact, in the !ka->use_master_clock case, this ioctl should probably
return an error. Because in that case, the KVM clock *isn't* stable in
terms of the guest TSC as it would be in a sane world, and it doesn't
make sense to care about migrating it accurately.

We should think about the case where ka->use_master_clock is true on
the source, but *false* on the destination. Could KVM_SET_CLOCK_GUEST
still work in that mode, by calling compute_guest_tsc()?=20


> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > +}
> > +
> > +static int kvm_vm_ioctl_set_clock_guest(struct kvm *kvm, void __user *=
argp)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_vcpu *vcpu;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pvclock_vcpu_time_inf=
o orig_pvti;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct pvclock_vcpu_time_inf=
o dummy_pvti;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int64_t kernel_ns;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint64_t host_tsc, guest_tsc=
;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint64_t clock_orig, clock_d=
ummy;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int64_t correction;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long i;
>=20
> Please ignore me if there is not any chance to make the above (and other =
places
> in the patchset) to honor reverse xmas tree style.
>=20
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu =3D kvm_get_bsp_vcpu(kv=
m);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!vcpu)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (copy_from_user(&orig_pvt=
i, argp, sizeof(orig_pvti)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EFAULT;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Sample the kernel time an=
d host TSC at a singular point.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We then calculate the gue=
st TSC using this exact point in time,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * From here we can then det=
ermine the delta using the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * PV time info requested fr=
om the user and what we currently have
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * using the fixed point in =
time. This delta is then used as a
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * correction factor to fixu=
p the potential drift.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!kvm_get_time_and_clockr=
ead(&kernel_ns, &host_tsc))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return -EFAULT;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0guest_tsc =3D kvm_read_l1_ts=
c(vcpu, host_tsc);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dummy_pvti =3D orig_pvti;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dummy_pvti.tsc_timestamp =3D=
 guest_tsc;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dummy_pvti.system_time =3D k=
ernel_ns + kvm->arch.kvmclock_offset;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clock_orig =3D __pvclock_rea=
d_cycles(&orig_pvti, guest_tsc);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clock_dummy =3D __pvclock_re=
ad_cycles(&dummy_pvti, guest_tsc);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0correction =3D clock_orig - =
clock_dummy;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm->arch.kvmclock_offset +=
=3D correction;
>=20
> I am not sure if it is a good idea to rely on userspace VMM to decide the=
 good
> timepoint to issue the ioctl, without assuming any racing.
>=20
> In addition to live migration, can the user call this API any time during=
 the VM
> is running (to fix the clock drift)? Therefore, any requirement to protec=
t the
> update of kvmclock_offset from racing?
>=20

$DEITY no. The clock drift at *runtime* due to stray calls of
KVM_REQ_MASTERCLOCK_UPDATE is just a kernel bug. It isn't the user's
responsibility to correct it!

However... where invoked in ka->use_masterclock_mode, perhaps
pvclock_update_vm_gtod_copy() *should* perform the same kind of
calculation, and actually *adjust* ka->kvmclock_offset as the true
definition of the KVM clock drifts from CLOCK_MONOTONIC_RAW?

But internally; never seen by userspace.


--=-dsf7U/9flaLboQtkLwCH
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwNDA5MDM1MDMyWjAvBgkqhkiG9w0BCQQxIgQgF+iwIwqZ
ezHcxR1qSwUKKXFd2zYH/XDLTCTUxbTxgPMwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCICHS7RcamRzzQZWEKGtm2KdO/cAA0IRdi
LjooUW7X2J9oaheM0YIuHkLKb6gB5jB6zcZtRwzOLHqqrKjvs9vVyVcS8jDQsZMDMCXtv+8efR8P
mtcwfIK/3ucQNbgMjh14VKms9y6ThSpdvzkWeXq8r8et3ksjr7YbcqN3BwkeeovxNNR4pVcbyD8b
BHxhq9F+dh16bat2gBWUOQ1n4N8KvXtsIw5Cmwro4m/N9JIjBV3c8wA7Zggg4ApYbOCQ02qHrMfK
c3INNkA7nW2aUgJTRB4SRNsRtGLzVtzc25Bbzn9CPS7U9oGO9KgD4XRj2GaVI5NbFB+U/JaSX2RO
KtUjpdJlzCkhdqVIVdIWZ5SmkYZhcCAFyf3h44DNfVFfZgEl+h74tqWuxh4MstNfwrU68e2WtlHN
CHfq0pUXqGs+xRM3UlHpGnkDSYabzXwmOKituknu43hKBp4ZOoHSIp4TrIs/o5tPohNQb0jza4WR
R9HrEz70wcUpTKtxV0auHymR8NjX0+d4k4Wlzhjkd4ujl4uijCYNa2yRvuJUhTWmeN75ZVGY3J/4
3ufIiHP05T6xWrexUKmd/zEMfJqyOk8qjc4FS9XF61+Njcu+fkgvjxyA4Hqz+yiJUGu0nH6oDUso
vbSyv4FNND4W66ZnVtVNghnLfL8y6qahYECB2KXk4AAAAAAAAA==


--=-dsf7U/9flaLboQtkLwCH--

