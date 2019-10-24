Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40B9E33FE
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbfJXNYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:24:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48743 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393559AbfJXNYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 09:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571923461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1hJ1knkfPhjKeEhTWav39es1pC718+ZBZuT/W9EuBl0=;
        b=iVEoJpMeJRD44pWpb/dA0agusUa94P+S9JyOuOkMlKaZK6U0ekSnlavPKYIVkCNryp40M/
        q04+inuHQmDHLWvEYQ/TldOeRJAbyHgiXHjOvK1tPJJZHaHIC/aGkhkMJj/Jd09aSZgMuT
        Glg0moChj4RGn9YyKsvil3OEVppvJ/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-4am-lOfWM8yIhU8DeRE8-A-1; Thu, 24 Oct 2019 09:24:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5426800D49;
        Thu, 24 Oct 2019 13:24:16 +0000 (UTC)
Received: from localhost (ovpn-116-62.gru2.redhat.com [10.97.116.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48B7110027AB;
        Thu, 24 Oct 2019 13:24:16 +0000 (UTC)
Date:   Thu, 24 Oct 2019 10:24:14 -0300
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
Message-ID: <20191024132414.GQ6744@habkost.net>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
 <20191015132929.GY4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
 <20191022214416.GA21651@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382D523@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17382D523@SHSMSX104.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 4am-lOfWM8yIhU8DeRE8-A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 11:22:18AM +0000, Kang, Luwei wrote:
> > > > > > > f9f4cd1..097c953 100644
> > > > > > > --- a/target/i386/kvm.c
> > > > > > > +++ b/target/i386/kvm.c
> > > > > > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, i=
nt level)
> > > > > > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), =
mask);
> > > > > > >              }
> > > > > > >          }
> > > > > > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTE=
L_PT) {
> > > > > > > +            int addr_num =3D kvm_arch_get_supported_cpuid(kv=
m_state,
> > > > > > > +                                                    0x14, 1,
> > > > > > > + R_EAX) & 0x7;
> > > > > > > +
> > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > > > > > +                            env->msr_rtit_ctrl);
> > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > > > > > +                            env->msr_rtit_status);
> > > > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE=
,
> > > > > > > +                            env->msr_rtit_output_base);
> > > > > >
> > > > > > This causes the following crash on some hosts:
> > > > > >
> > > > > >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> > > > > >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Ass=
ertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
> > > > > >
> > > > > > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
> > > > > > additional conditions that might prevent writing to this MSR
> > > > > > (PT_CAP_topa_output && PT_CAP_single_range_output).  This
> > > > causes QEMU to crash if some of the conditions aren't met.
> > > > > >
> > > > > > Writing and reading this MSR (and the ones below) need to be co=
nditional on KVM_GET_MSR_INDEX_LIST.
> > > > > >
> > > > >
> > > > > Hi Eduardo,
> > > > >     I found this issue can't be reproduced in upstream source cod=
e
> > > > > but can be reproduced on RHEL8.1. I haven't got the qemu source
> > > > code of RHEL8.1. But after adding some trace in KVM, I found the KV=
M
> > > > has reported the complete Intel PT CPUID information to qemu but th=
e Intel PT CPUID (0x14) is lost when qemu setting the CPUID
> > to KVM (cpuid level is 0xd). It looks like lost the below patch.
> > > > >
> > > > > commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> > > > > Author: Luwei Kang <luwei.kang@intel.com>
> > > > > Date:   Tue Jan 29 18:52:59 2019 -0500
> > > > >     i386: extended the cpuid_level when Intel PT is enabled
> > > > >
> > > > >     Intel Processor Trace required CPUID[0x14] but the cpuid_leve=
l
> > > > >     have no change when create a kvm guest with
> > > > >     e.g. "-cpu qemu64,+intel-pt".
> > > >
> > > > Thanks for the pointer.  This may avoid triggering the bug in the
> > > > default configuration, but we still need to make the MSR writing
> > > > conditional on KVM_GET_MSR_INDEX_LIST.  Older machine-types have x-=
intel-pt-auto-level=3Doff, and the user may set `level`
> > manually.
> > >
> > > Hi Eduardo,
> > > Sorry for a delay reply because my mail filter. I tried with the Q35
> > > machine type and default, all looks work well (With some old cpu type
> > > + "intel_pt" also work well).  KVM will check the Intel PT work mode
> > > and HW to decide if Intel PT can be exposed to guest, only extended
> > > the CPUID level is useless. If the guest doesn't support Intel PT, an=
y
> > > MSR read or write will cause #GP. Please remind me if I lost
> > > something.
> >=20
> > I understand you have tried q35 and pc, but have you tried with older m=
achine-type versions?
> >=20
> > Commit f24c3a79a415 doesn't change behavior on pc-*-3.1 and older, so i=
t only avoids triggering the crash in the default case.
> > Doesn't QEMU crash if running:
> > "-cpu qemu64,+intel-pt -machine pc-i440fx-3.1"?
> >=20
> > KVM rejecting MSR writes when something is missing is correct.
> > QEMU trying to write the MSR when something is missing (and crashing be=
cause of that) is a bug.
>=20
> Hi Eduardo,
>     Yes, you are right. Intel PT is only set in leaf 0x7.ebx but leaf 0x1=
4 is lost because of the leaf number still 0xd (should 0x14).=20
>     May I remove the "off" like this?

We can't.  This is necessary to keep guest ABI compatibility.
Instead, we need to make QEMU not crash if xlevel is too low,
because xlevel can be configured by the user.

>=20
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -132,7 +132,6 @@ GlobalProperty pc_compat_3_1[] =3D {
>      { "Icelake-Client" "-" TYPE_X86_CPU,      "mpx", "on" },
>      { "Icelake-Server" "-" TYPE_X86_CPU,      "mpx", "on" },
>      { "Cascadelake-Server" "-" TYPE_X86_CPU, "stepping", "5" },
> -    { TYPE_X86_CPU, "x-intel-pt-auto-level", "off" },
>  };
>  const size_t pc_compat_3_1_len =3D G_N_ELEMENTS(pc_compat_3_1);
>=20
> Thanks,
> Luwei Kang
>=20
> >=20
> > --
> > Eduardo
>=20

--=20
Eduardo

