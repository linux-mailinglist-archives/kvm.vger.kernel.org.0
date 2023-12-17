Return-Path: <kvm+bounces-4652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C6C815EDB
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 13:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535842831BB
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 12:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455A232C74;
	Sun, 17 Dec 2023 12:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JM+1W437"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6182D847A;
	Sun, 17 Dec 2023 12:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5D1C433C7;
	Sun, 17 Dec 2023 12:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702815053;
	bh=a66tj8N4PdZrRpj7zjYZM1VA5iyh24+UFASNVr20mZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JM+1W4373Z1/80Pnq7FohMDx2169u6iuvDaFZkGyYZG1opJrcS+EG0yJbBfKzGcyf
	 vumCk1ikMTEiF6e55LXu4Db2Z4LuM3vQ66x+cRHZ6VARJePslZP1urmKY/vLEEDJN/
	 N+uNd0Nznzv8pgRdRgXBNl/Bkk4wHOs5K9exveF/5H8an9xvZ4QjHAzDRFI2sXuA5g
	 gJzn6et7TaZrgFDg6IWGGndPZS1gkCR6QxYP80LbGG2LIp5arHpLKciEsJIuWtlR1F
	 e18EzhzLwndRx+QLdYYpdIm4OkEchJrpTKanvcOTUW99EkyjuGr5ZZUD4J+Buc3LOt
	 RVKUzeQiLtXAQ==
Date: Sun, 17 Dec 2023 12:10:48 +0000
From: Conor Dooley <conor@kernel.org>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Conor Dooley <conor.dooley@microchip.com>, linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [RFC 6/9] drivers/perf: riscv: Implement SBI PMU snapshot
 function
Message-ID: <20231217-navigate-thirsty-03509850a683@spud>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
 <20231205024310.1593100-7-atishp@rivosinc.com>
 <20231207-daycare-manager-2f4817171422@wendy>
 <CAHBxVyE3xAAj=Z_Cu33tEKjXEAcnOV_=Jpkpn-+j5MoLj1FPWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XU9hTNRI3vOngvxn"
Content-Disposition: inline
In-Reply-To: <CAHBxVyE3xAAj=Z_Cu33tEKjXEAcnOV_=Jpkpn-+j5MoLj1FPWw@mail.gmail.com>


--XU9hTNRI3vOngvxn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 16, 2023 at 05:39:12PM -0800, Atish Kumar Patra wrote:
> On Thu, Dec 7, 2023 at 5:06=E2=80=AFAM Conor Dooley <conor.dooley@microch=
ip.com> wrote:
> > On Mon, Dec 04, 2023 at 06:43:07PM -0800, Atish Patra wrote:

> > > +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> > > +{
> > > +     int cpu;
> >
> > > +     struct cpu_hw_events *cpu_hw_evt;
> >
> > This is only used inside the scope of the for loop.
> >
>=20
> Do you intend to suggest using mixed declarations ? Personally, I
> prefer all the declarations upfront for readability.
> Let me know if you think that's an issue or violates coding style.

I was suggesting

int cpu;

for_each_possible_cpu(cpu)
	struct cpu_hw_events *cpu_hw_evt =3D per....()

I've been asked to do this in some subsystems I submitted code to,
and checkpatch etc do not complain about it. I don't think there is any
specific commentary in the coding style about minimising the scope of
variables however.

> > > +     /* Free up the snapshot area memory and fall back to default SB=
I */
> >
> > What does "fall back to the default SBI mean"? SBI is an interface so I
> > don't understand what it means in this context. Secondly,
>=20
> In absence of SBI PMU snapshot, the driver would try to read the
> counters directly and end up traps.
> Also, it would not use the SBI PMU snapshot flags in the SBI start/stop c=
alls.
> Snapshot is an alternative mechanism to minimize the traps. I just
> wanted to highlight that.
>=20
> How about this ?
> "Free up the snapshot area memory and fall back to default SBI PMU
> calls without snapshot */

Yeah, that's fine (modulo the */ placement). The original comment just
seemed truncated.

> > > +     if (ret.error) {
> > > +             if (ret.error !=3D SBI_ERR_NOT_SUPPORTED)
> > > +                     pr_warn("%s: pmu snapshot setup failed with err=
or %ld\n", __func__,
> > > +                             ret.error);
> >
> > Why is the function relevant here? Is the error message in-and-of-itself
> > not sufficient here? Where else would one be setting up the snapshots
> > other than the setup function?
> >
>=20
> The SBI implementation (i.e OpenSBI) may or may not provide a snapshot
> feature. This error message indicates
> that SBI implementation supports PMU snapshot but setup failed for
> some other error.

I don't see what this has to do with printing out the function. This is
a unique error message, and there is no other place where the setup is
done AFAICT.

> > > +             /* Snapshot is taken relative to the counter idx base. =
Apply a fixup. */
> > > +             if (hwc->idx > 0) {
> > > +                     sdata->ctr_values[hwc->idx] =3D sdata->ctr_valu=
es[0];
> > > +                     sdata->ctr_values[0] =3D 0;
> >
> > Why is this being zeroed in this manner? Why is zeroing it not required
> > if hwc->idx =3D=3D 0? You've got a comment there that could probably do=
 with
> > elaboration.
> >
>=20
> hwc->idx is the counter_idx_base here. If it is zero, that means the
> counter0 value is updated
> in the shared memory. However, if the base > 0, we need to update the
> relative counter value
> from the shared memory. Does it make sense ?

Please expand on the comment so that it contains this information.

> > > +             ret =3D pmu_sbi_snapshot_setup(pmu, smp_processor_id());
> > > +             if (!ret) {
> > > +                     pr_info("SBI PMU snapshot is available to optim=
ize the PMU traps\n");
> >
> > Why the verbose message? Could we standardise on one wording for the SBI
> > function probing stuff? Most users seem to be "SBI FOO extension detect=
ed".
> > Only IPI has additional wording and PMU differs slightly.
>=20
> Additional information is for users to understand PMU functionality
> uses less traps on this system.
> We can just resort to and expect users to read upon the purpose of the
> snapshot from the spec.
> "SBI PMU snapshot available"

What I was asking for was alignment with the majority of other SBI
extensions that use the format I mentioned above.

>=20
> >
> > > +                     /* We enable it once here for the boot cpu. If =
snapshot shmem fails during
> >
> > Again, comment style here. What does "snapshot shmem" mean? I think
> > there's a missing action here. Registration? Allocation?
> >
>=20
> Fixed it. It is supposed to be "snapshot shmem setup"
>=20
> > > +                      * cpu hotplug on, it should bail out.
> >
> > Should or will? What action does "bail out" correspond to?
> >
>=20
> bail out the cpu hotplug process. We don't support heterogeneous pmus
> for snapshot.
> If the SBI implementation returns success for SBI_EXT_PMU_SNAPSHOT_SET_SH=
MEM
> boot cpu but fails for other cpus while bringing them up, it is
> problematic to handle that.

"bail out" should be replaced by a more technical explanation of what is
going to happen. "should" is a weird word to use, either the cpuhotplug
code does or does not deal with this case, and since that code is also
in the kernel, this patchset should ensure that it does handle the case,
no? If the kernel does handle it "should" should be replaced with more
definitive wording.

Thanks,
Conor.

--XU9hTNRI3vOngvxn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZX7lSAAKCRB4tDGHoIJi
0l/hAP9YqJoyrNUc/htZ3H5eYM9OdIGG2sawQAN+P2IYsH66AAEAs/CkW1OYlLt3
zyWWLtE53KE6mH6LAp9FSYmcrAjDGA0=
=gtpU
-----END PGP SIGNATURE-----

--XU9hTNRI3vOngvxn--

