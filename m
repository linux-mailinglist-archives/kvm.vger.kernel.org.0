Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC6E3551
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 16:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391332AbfJXOPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 10:15:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726008AbfJXOPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 10:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571926543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2opU6N6m1wz6aDqqkbrk6Znhodiar6RbhpaEcpu0Kk=;
        b=QcNj7Kdzch/f9LTt4h2TgKMvOf+XxJrI3IT7Bqw7+a8bcPt89dN6G7G+rclbq88jB93oO1
        KAZqChgIOGXPT6NLRnQ0Qqaho++7JJLyI/dYPNkCzXyRWprgwYwPtmmwCeEhiOV9HTmSSC
        oD8/T6xx7lOLrCOXM8TJjKdy8U/SOAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-KhechL12NUKftkTc7zP1yw-1; Thu, 24 Oct 2019 10:15:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CAAD47B;
        Thu, 24 Oct 2019 14:15:38 +0000 (UTC)
Received: from localhost (ovpn-116-62.gru2.redhat.com [10.97.116.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E85F45DC1E;
        Thu, 24 Oct 2019 14:15:37 +0000 (UTC)
Date:   Thu, 24 Oct 2019 11:15:36 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH v4 2/2] i386: Add support to get/set/migrate Intel
 Processor Trace feature
Message-ID: <20191024141536.GU6744@habkost.net>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
 <20191015132929.GY4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
 <20191022214416.GA21651@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382D523@SHSMSX104.ccr.corp.intel.com>
 <20191024132414.GQ6744@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382D885@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17382D885@SHSMSX104.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: KhechL12NUKftkTc7zP1yw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 01:36:50PM +0000, Kang, Luwei wrote:
> > > > > > > > > f9f4cd1..097c953 100644
> > > > > > > > > --- a/target/i386/kvm.c
> > > > > > > > > +++ b/target/i386/kvm.c
> > > > > > > > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cp=
u, int level)
> > > > > > > > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(=
i), mask);
> > > > > > > > >              }
> > > > > > > > >          }
> > > > > > > > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_=
INTEL_PT) {
> > > > > > > > > +            int addr_num =3D kvm_arch_get_supported_cpui=
d(kvm_state,
> > > > > > > > > +                                                    0x14=
,
> > > > > > > > > + 1,
> > > > > > > > > + R_EAX) & 0x7;
> > > > > > > > > +
> > > > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > > > > > > > +                            env->msr_rtit_ctrl);
> > > > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > > > > > > > +                            env->msr_rtit_status);
> > > > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_=
BASE,
> > > > > > > > > +                            env->msr_rtit_output_base);
> > > > > > > >
> > > > > > > > This causes the following crash on some hosts:
> > > > > > > >
> > > > > > > >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> > > > > > > >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs:=
 Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
> > > > > > > >
> > > > > > > > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
> > > > > > > > additional conditions that might prevent writing to this MS=
R
> > > > > > > > (PT_CAP_topa_output && PT_CAP_single_range_output).  This
> > > > > > causes QEMU to crash if some of the conditions aren't met.
> > > > > > > >
> > > > > > > > Writing and reading this MSR (and the ones below) need to b=
e conditional on KVM_GET_MSR_INDEX_LIST.
> > > > > > > >
> > > > > > >
> > > > > > > Hi Eduardo,
> > > > > > >     I found this issue can't be reproduced in upstream source
> > > > > > > code but can be reproduced on RHEL8.1. I haven't got the qemu
> > > > > > > source
> > > > > > code of RHEL8.1. But after adding some trace in KVM, I found th=
e
> > > > > > KVM has reported the complete Intel PT CPUID information to qem=
u
> > > > > > but the Intel PT CPUID (0x14) is lost when qemu setting the
> > > > > > CPUID
> > > > to KVM (cpuid level is 0xd). It looks like lost the below patch.
> > > > > > >
> > > > > > > commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> > > > > > > Author: Luwei Kang <luwei.kang@intel.com>
> > > > > > > Date:   Tue Jan 29 18:52:59 2019 -0500
> > > > > > >     i386: extended the cpuid_level when Intel PT is enabled
> > > > > > >
> > > > > > >     Intel Processor Trace required CPUID[0x14] but the cpuid_=
level
> > > > > > >     have no change when create a kvm guest with
> > > > > > >     e.g. "-cpu qemu64,+intel-pt".
> > > > > >
> > > > > > Thanks for the pointer.  This may avoid triggering the bug in
> > > > > > the default configuration, but we still need to make the MSR
> > > > > > writing conditional on KVM_GET_MSR_INDEX_LIST.  Older
> > > > > > machine-types have x-intel-pt-auto-level=3Doff, and the user ma=
y
> > > > > > set `level`
> > > > manually.
> > > > >
> > > > > Hi Eduardo,
> > > > > Sorry for a delay reply because my mail filter. I tried with the
> > > > > Q35 machine type and default, all looks work well (With some old
> > > > > cpu type
> > > > > + "intel_pt" also work well).  KVM will check the Intel PT work
> > > > > + mode
> > > > > and HW to decide if Intel PT can be exposed to guest, only
> > > > > extended the CPUID level is useless. If the guest doesn't support
> > > > > Intel PT, any MSR read or write will cause #GP. Please remind me
> > > > > if I lost something.
> > > >
> > > > I understand you have tried q35 and pc, but have you tried with old=
er machine-type versions?
> > > >
> > > > Commit f24c3a79a415 doesn't change behavior on pc-*-3.1 and older, =
so it only avoids triggering the crash in the default case.
> > > > Doesn't QEMU crash if running:
> > > > "-cpu qemu64,+intel-pt -machine pc-i440fx-3.1"?
> > > >
> > > > KVM rejecting MSR writes when something is missing is correct.
> > > > QEMU trying to write the MSR when something is missing (and crashin=
g because of that) is a bug.
> > >
> > > Hi Eduardo,
> > >     Yes, you are right. Intel PT is only set in leaf 0x7.ebx but leaf=
 0x14 is lost because of the leaf number still 0xd (should 0x14).
> > >     May I remove the "off" like this?
> >=20
> > We can't.  This is necessary to keep guest ABI compatibility.
> > Instead, we need to make QEMU not crash if xlevel is too low, because x=
level can be configured by the user.
>=20
> Thanks Eduardo.  But I think it is a little complex for user.
> User found crash but how does he know it need to configure the
> xlevel or others?
> If we want to the old machine type support PT can we add some
> code to extend the level to 0x14? Or old machine type can't
> support PT,  mask off this feature from leaf 0x07.ebx[25]
> directly and output some messages?

I agree it's complex for the user, but let's address this
separately:

the first issue here is the crash: QEMU must not crash if using
(e.g.) "-cpu ...,+intel-pt,xlevel=3D0x13".  This can't be solved by
making any machine-type changes.

The second issue is usability.  This is hard to fix on old
machine-types because we must keep guest ABI compatibility.

In QEMU 3.1 the results of:
  -machine pc-i440fx-3.1 -cpu qemu64,+intel-pt
was:
  CPUID[0].EAX (level) =3D 7
  CPUID[7].EBX[25] (intel-pt) =3D 1

and we can't change the behavior of pc-i440fx-3.1.

Your suggestion of printing a warning is good, though.  We can do
that if intel-pt is enabled and level < 0x14.

>=20
> Luwei Kang
>=20
> >=20
> > >
> > > --- a/hw/i386/pc.c
> > > +++ b/hw/i386/pc.c
> > > @@ -132,7 +132,6 @@ GlobalProperty pc_compat_3_1[] =3D {
> > >      { "Icelake-Client" "-" TYPE_X86_CPU,      "mpx", "on" },
> > >      { "Icelake-Server" "-" TYPE_X86_CPU,      "mpx", "on" },
> > >      { "Cascadelake-Server" "-" TYPE_X86_CPU, "stepping", "5" },
> > > -    { TYPE_X86_CPU, "x-intel-pt-auto-level", "off" },
> > >  };
> > >  const size_t pc_compat_3_1_len =3D G_N_ELEMENTS(pc_compat_3_1);
> > >
> > > Thanks,
> > > Luwei Kang
> > >
> > > >
> > > > --
> > > > Eduardo
> > >
> >=20
> > --
> > Eduardo
>=20

--=20
Eduardo

