Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB3B7B8796
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbjJDSHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243820AbjJDSHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 14:07:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9040EC9
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 11:06:59 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f61a639b9so1136017b3.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 11:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696442818; x=1697047618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=532vqNvLhdEr7Nq8RloEZxq7TYu615b2Ne4yyz9O118=;
        b=wGeTNX/3HOvOX78S1KZElQrbyi7HxyEZ81IuBMDlC5mJVReFp80t/pzJp6XpfN8EHu
         zMVmx02LvaPmdPkQ5iXiBKctzGKRbKDa/mp7GatdaUra7Rmx3m5v6nLfpPdJCNXPNXhe
         oof5hzfQp1w2udOZQL3MISgDuexVBpp2E3DTFNzhcNhNo10ydpwMBeBmAf6ahZ7WKXb8
         k4TxpRwitKkAQnKJVWnc86IMEtTqUJX6ali/+5FnreQaoycPtylPDRo/WCkzyiEVCdhM
         tEcneIy7LL0ITyvxI9rX5lcjQ4JwYecr+22QILH8A0ZBidDXoofezeKgGB8/5r1XtfS9
         kvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696442819; x=1697047619;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=532vqNvLhdEr7Nq8RloEZxq7TYu615b2Ne4yyz9O118=;
        b=cSahmmKUB/PN2gkax8wQT9wNVngmDeK6PEk65iiI708HFg9f5WXNBuArnQMXjfdoLW
         yc3uz0oQJB8y03QvhVRQ65j3MX/NowxmG8P84ZQPfGPQnM7hN1rjxW7iiDVKYRUDzIY9
         xXFThGJdENixnoDrGzOHWGJ6VlXnPQfEmhWVfT2ISzJE7PrUAQCdStNIwnlJyEwgXdH4
         ISzy+YD7ZF886zVhdEH4lGFxilDj7InOlu+St0BbFvIGV9f34sinCQnkGTsphkK4bvRE
         LsiSHc/4jbErjOlsfnX0XusQW0cYnmDFLsBYB1whRuA/ANhN7V3zsXB3NoZRcG5qOeHg
         5mSw==
X-Gm-Message-State: AOJu0YxGssFsMeM99RVUQwUdiQODy91XNMHI0YpMhOCxaRkFAmgeL2JY
        JWjhOooQXaFL1E0TJPK0Dsrw3DdH7vA=
X-Google-Smtp-Source: AGHT+IFrs6BfWa0JCldLnRDVyduS/nfo18CRZghII7glgGCFR/sMkTXeV23srJKfA7JACPtGwWy6MzYXL+8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b65a:0:b0:59b:eb4d:21f2 with SMTP id
 h26-20020a81b65a000000b0059beb4d21f2mr52068ywk.4.1696442818769; Wed, 04 Oct
 2023 11:06:58 -0700 (PDT)
Date:   Wed, 4 Oct 2023 11:06:57 -0700
In-Reply-To: <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
Mime-Version: 1.0
References: <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com> <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com> <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
 <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
Message-ID: <ZR2pwdZtO3WLCwjj@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023, David Woodhouse wrote:
> On Tue, 2023-10-03 at 17:04 -0700, Sean Christopherson wrote:
> > > Can't we ensure that the kvmclock uses the *same* algorithm,
> > > precisely, as CLOCK_MONOTONIC_RAW?
> >=20
> > Yes?=C2=A0 At least for sane hardware, after much staring, I think it's=
 possible.
> >=20
> > It's tricky because the two algorithms are wierdly different, the PV cl=
ock algorithm
> > is ABI and thus immutable, and Thomas and the timekeeping folks would r=
ightly laugh
> > at us for suggesting that we try to shove the pvclock algorithm into th=
e kernel.
> >=20
> > The hardcoded shift right 32 in PV clock is annoying, but not the end o=
f the world.
> >=20
> > Compile tested only, but I believe this math is correct.=C2=A0 And I'm =
guessing we'd
> > want some safeguards against overflow, e.g. due to a multiplier that is=
 too big.
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 6573c89c35a9..ae9275c3d580 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3212,9 +3212,19 @@ static int kvm_guest_time_update(struct kvm_vcpu=
 *v)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v->arch.l1_tsc_scaling_ratio);
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(vcpu->hw_tsc_kh=
z !=3D tgt_tsc_khz)) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vcpu->hv_clock.tsc_=
shift,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vcpu->hv_clock.tsc_=
to_system_mul);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 u32 shift, mult;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 clocks_calc_mult_shift(&mult, &shift, tgt_tsc_khz, NSEC_PER=
_MSEC, 600);
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (shift <=3D 32) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->hv_cl=
ock.tsc_shift =3D 0;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->hv_cl=
ock.tsc_to_system_mul =3D mult * BIT(32 - shift);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 } else {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_get_tim=
e_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vcpu->hv_clock.tsc_shift,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vcpu->hv_clock.tsc_to_system_mul);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 }
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 vcpu->hw_tsc_khz =3D tgt_tsc_khz;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 kvm_xen_update_tsc_info(v);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
>=20
> I gave that a go on my test box, and for a TSC frequency of 2593992 kHz
> it got mult=3D1655736523, shift=3D32 and took the 'happy' path instead of
> falling back.
>=20
> It still drifts about the same though, using the same test as before:
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/kvmcl=
ock
>=20
>=20
> I was going to facetiously suggest that perhaps the kvmclock should
> have leap nanoseconds... but then realised that that's basically what
> Dongli's patch is *doing*. Maybe we just need to *recognise* that,

Yeah, I suspect trying to get kvmclock to always precisely align with the k=
ernel's
monotonic raw clock is a fool's errand.

> so rather than having a user-configured period for the update, KVM could
> calculate the frequency for the updates based on the rate at which the cl=
ocks
> would otherwise drift, and a maximum delta? Not my favourite option, but
> perhaps better than nothing?=20

Holy moly, the existing code for the periodic syncs/updates is a mess.  If =
I'm
reading the code correctly, commits

  0061d53daf26 ("KVM: x86: limit difference between kvmclock updates")
  7e44e4495a39 ("x86: kvm: rate-limit global clock updates")
  332967a3eac0 ("x86: kvm: introduce periodic global clock updates")

splattered together an immpressively inefficient update mechanism.

On the first vCPU creation, KVM schedules kvmclock_sync_fn() at a hardcoded=
 rate
of 300hz.

	if (kvmclock_periodic_sync && vcpu->vcpu_idx =3D=3D 0)
		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
						KVMCLOCK_SYNC_PERIOD);

That handler does two things: schedule "delayed" work kvmclock_update_fn() =
to
be executed immediately, and reschedule kvmclock_sync_fn() at 300hz.
kvmclock_sync_fn() then kicks *every* vCPU in the VM, i.e. KVM kicks every =
vCPU
to sync kvmlock at a 300hz frequency. =20

If we're going to kick every vCPU, then we might as well do a masterclock u=
pdate,
because the extra cost of synchronizing the masterclock is likely in the no=
ise
compared to kicking every vCPU.  There's also zero reason to do the work in=
 vCPU
context.

And because that's not enough, on pCPU migration or if the TSC is unstable,
kvm_arch_vcpu_load() requests KVM_REQ_GLOBAL_CLOCK_UPDATE, which schedules
kvmclock_update_fn() with a delay of 100ms.  The large delay is to play nic=
e with
unstable TSCs.  But if KVM is periodically doing clock updates on all vCPU,
scheduling another update with a *longer* delay is silly.

The really, really stupid part of all is that the periodic syncs happen eve=
n if
kvmclock isn't exposed to the guest.  *sigh*

So rather than add yet another periodic work function, I think we should cl=
ean up
the mess we have, fix the whole "leapseconds" mess with the masterclock, an=
d then
tune the frequency (if necessary).

Something like the below is what I'm thinking.  Once the dust settles, I'd =
like
to do dynamically enable/disable kvmclock_sync_work based on whether or not=
 the
VM actually has vCPU's with a pvclock, but that's definitely an enhancement=
 that
can go on top.

Does this look sane, or am I missing something?

---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/x86.c              | 53 +++++++++++----------------------
 2 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 34a64527654c..d108452fc301 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -98,7 +98,7 @@
 	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_SCAN_IOAPIC \
 	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
+/* AVAILABLE BIT!!!!			KVM_ARCH_REQ(16) */
 #define KVM_REQ_APIC_PAGE_RELOAD \
 	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_CRASH		KVM_ARCH_REQ(18)
@@ -1336,7 +1336,6 @@ struct kvm_arch {
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
-	struct delayed_work kvmclock_update_work;
 	struct delayed_work kvmclock_sync_work;
=20
 	struct kvm_xen_hvm_config xen_hvm_config;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6573c89c35a9..5d35724f1963 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2367,7 +2367,7 @@ static void kvm_write_system_time(struct kvm_vcpu *vc=
pu, gpa_t system_time,
 	}
=20
 	vcpu->arch.time =3D system_time;
-	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
=20
 	/* we verify if the enable bit is set... */
 	if (system_time & 1)
@@ -3257,30 +3257,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
=20
 #define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
=20
-static void kvmclock_update_fn(struct work_struct *work)
-{
-	unsigned long i;
-	struct delayed_work *dwork =3D to_delayed_work(work);
-	struct kvm_arch *ka =3D container_of(dwork, struct kvm_arch,
-					   kvmclock_update_work);
-	struct kvm *kvm =3D container_of(ka, struct kvm, arch);
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-		kvm_vcpu_kick(vcpu);
-	}
-}
-
-static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
-{
-	struct kvm *kvm =3D v->kvm;
-
-	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
-					KVMCLOCK_UPDATE_DELAY);
-}
-
 #define KVMCLOCK_SYNC_PERIOD (300 * HZ)
=20
 static void kvmclock_sync_fn(struct work_struct *work)
@@ -3290,12 +3266,14 @@ static void kvmclock_sync_fn(struct work_struct *wo=
rk)
 					   kvmclock_sync_work);
 	struct kvm *kvm =3D container_of(ka, struct kvm, arch);
=20
-	if (!kvmclock_periodic_sync)
-		return;
+	if (ka->use_master_clock)
+		kvm_update_masterclock(kvm);
+	else
+		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
=20
-	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
-	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
-					KVMCLOCK_SYNC_PERIOD);
+	if (kvmclock_periodic_sync)
+		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+				      KVMCLOCK_SYNC_PERIOD);
 }
=20
 /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
@@ -4845,7 +4823,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
 		 * kvmclock on vcpu->cpu migration
 		 */
 		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu =3D=3D -1)
-			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
+			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu !=3D cpu)
 			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
 		vcpu->cpu =3D cpu;
@@ -10520,12 +10498,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
 			kvm_update_masterclock(vcpu->kvm);
-		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
-			kvm_gen_kvmclock_update(vcpu);
 		if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu)) {
 			r =3D kvm_guest_time_update(vcpu);
 			if (unlikely(r))
 				goto out;
+
+			/*
+			 * Ensure all other vCPUs synchronize "soon", e.g. so
+			 * that all vCPUs recognize NTP corrections and drift
+			 * corrections (relative to the kernel's raw clock).
+			 */
+			if (!kvmclock_periodic_sync)
+				schedule_delayed_work(&vcpu->kvm->arch.kvmclock_sync_work,
+						      KVMCLOCK_UPDATE_DELAY);
 		}
 		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
 			kvm_mmu_sync_roots(vcpu);
@@ -12345,7 +12330,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
 	kvm->arch.hv_root_tdp =3D INVALID_PAGE;
 #endif
=20
-	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
=20
 	kvm_apicv_init(kvm);
@@ -12387,7 +12371,6 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 void kvm_arch_sync_events(struct kvm *kvm)
 {
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 	kvm_free_pit(kvm);
 }
=20

base-commit: e2c8c2928d93f64b976b9242ddb08684b8cdea8d
--=20

