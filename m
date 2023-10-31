Return-Path: <kvm+bounces-184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D13B7DCC0A
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 12:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B126C1C20C45
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 11:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DC51BDE9;
	Tue, 31 Oct 2023 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iGQM8KHo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19945199DB
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:42:31 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E45691;
	Tue, 31 Oct 2023 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=VlN8p3RfYXpXh6bENRI9S68YgJgpcAwvfutYsLKoRF8=; b=iGQM8KHo53UcuP/wjvDnraWCAV
	+cK8IC6VobUa7A1LGj5o1rYNKBzU7e2CPUH3yazhrqfKrj0odV/auJ8v2ZG7AUJmdviuvjozHRzVX
	a+nGB63sCxSFYXUBhpu20H37NPhNMWgCDQYSbl1oQ3DnYk8zUa7sW4gqRqv3LJJW+Y3unaQCUwGfl
	OqRWJAE5/GLny+lqvaOERSTGUUfCYazW0nBf40A7ACDIC0PLuz41sZEo1BAAd0S1mnHYgN68Fxv2X
	z1/JTXkulD1nAwKvg7y2/m2SzivuGJJ3al8MwwTsH8OOrrZNJmOlI40kI9i4Jmu36D4vHx3xlGOEw
	6ttE7z6g==;
Received: from [46.18.216.58] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qxn8W-004mxB-1n;
	Tue, 31 Oct 2023 11:42:22 +0000
Date: Tue, 31 Oct 2023 11:42:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: paul@xen.org, Paul Durrant <xadimgnik@gmail.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86/xen: improve accuracy of Xen timers
User-Agent: K-9 Mail for Android
In-Reply-To: <1a679274-bbff-4549-a1ea-c7ea9f1707cc@xen.org>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org> <1a679274-bbff-4549-a1ea-c7ea9f1707cc@xen.org>
Message-ID: <F80266DD-D7EF-4A26-B9F8-BC33EC65F444@infradead.org>
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



On 31 October 2023 10:42:42 GMT, Paul Durrant <xadimgnik@gmail=2Ecom> wrot=
e:
>There is no documented ordering requirement on setting KVM_XEN_VCPU_ATTR_=
TYPE_TIMER versus KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO or KVM_XEN_ATTR_TYPE_SHA=
RED_INFO but kvm_xen_start_timer() now needs the vCPU's pvclock to be valid=
=2E Should actually starting the timer not be deferred until then? (Or simp=
ly add a check here and have the attribute setting fail if the pvclock is n=
ot valid)=2E


There are no such dependencies and I don't want there to be=2E That would =
be the *epitome* of what my "if it needs documenting, fix it first" mantra =
is intended to correct=2E

The fact that this broke on migration because the hv_clock isn't set up ye=
t, as we saw in our overnight testing, is just a bug=2E In my tree I've fix=
ed it thus:

index 63531173dad1=2E=2Ee3d2d63eef34 100644
--- a/arch/x86/kvm/xen=2Ec
+++ b/arch/x86/kvm/xen=2Ec
@@ -182,7 +182,7 @@ static void kvm_xen_start_timer(st
ruct kvm_vcpu *vcpu, u64 guest_abs,
         * the absolute CLOCK_MONOTONIC time at which
the timer should
         * fire=2E
         */
-       if (vcpu->kvm->arch=2Euse_master_clock &&
+       if (vcpu->arch=2Ehv_clock=2Eversion && vcpu->kvm->
arch=2Euse_master_clock &&
            static_cpu_has(X86_FEATURE_CONSTANT_TSC))
{
                uint64_t host_tsc, guest_tsc;

@@ -206,9 +206,23 @@ static void kvm_xen_start_timer(s
truct kvm_vcpu *vcpu, u64 guest_abs,

                /* Calculate the guest kvmclock as the
 guest would do it=2E */
                guest_tsc =3D kvm_read_l1_tsc(vcpu, host
_tsc);
-               guest_now =3D __pvclock_read_cycles(&vcp
u->arch=2Ehv_clock, guest_tsc);
+               guest_now =3D __pvclock_read_cycles(&vcp
u->arch=2Ehv_clock,
+                                                 gues
t_tsc);
        } else {
-               /* Without CONSTANT_TSC, get_kvmclock_
ns() is the only option */
+               /*
+                * Without CONSTANT_TSC, get_kvmclock_
ns() is the only option=2E
+                *
+                * Also if the guest PV clock hasn't b
een set up yet, as is
+                * likely to be the case during migrat
ion when the vCPU has
+                * not been run yet=2E It would be possi
ble to calculate the
+                * scaling factors properly in that ca
se but there's not much
+                * point in doing so=2E The get_kvmclock
_ns() drift accumulates
+                * over time, so it's OK to use it at
startup=2E Besides, on
+                * migration there's going to be a lit
tle bit of skew in the
+                * precise moment at which timers fire
 anyway=2E Often they'll
+                * be in the "past" by the time the VM
 is running again after
+                * migration=2E
+                */
                guest_now =3D get_kvmclock_ns(vcpu->kvm)
;
                kernel_now =3D ktime_get();
        }
--
2=2E41=2E0

We *could* reset the timer when the vCPU starts to run and handles the KVM=
_REQ_CLOCK_UPDATE event, but I don't want to for two reasons=2E

Firstly, we just don't need that complexity=2E This approach is OK, as the=
 newly-added comment says=2E And we do need to fix get_kvmclock_ns() anyway=
, so it should work fine=2E Most of this patch will still be useful as it u=
ses a single TSC read and we *do* need to do that part even after all the k=
vmclock brokenness is fixed=2E But the complexity on KVM_REQ_CLOCK_UPDATE i=
sn't needed in the long term=2E

Secondly, it's also wrong thing to do in the general case=2E Let's say KVM=
 does its thing and snaps the kvmclock backwards in time on a KVM_REQ_CLOCK=
_UPDATE=2E=2E=2E do we really want to reinterpret existing timers against t=
he new kvmclock? They were best left alone, I think=2E=20
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00

