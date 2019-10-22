Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AE9E0DD8
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbfJVVoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 17:44:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733171AbfJVVoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 17:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571780664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PKEnwwvZkBoKQkKjGLBuPW/9OyQ9zYCnXgLkDtHA/wU=;
        b=aFCksAJEuXcAYCOB/HflqKJ99Q9hnQunhOv5UOimbRnSlYV2FHp6nO9buk326Y62Biq/xS
        BI/6w8JYgfmpQ7cGiWkPTuurcXLJhwOTytO4R3QFgU9IbkjTl7iuyLRIfblD+X8JWdRsyc
        CCJbgexCpUObpBYosM9pa/WKkoQ1VYU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-BzegCTQAPeCZk_lTI7ZwPA-1; Tue, 22 Oct 2019 17:44:20 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A938476;
        Tue, 22 Oct 2019 21:44:19 +0000 (UTC)
Received: from localhost (ovpn-116-104.gru2.redhat.com [10.97.116.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 807745DA32;
        Tue, 22 Oct 2019 21:44:18 +0000 (UTC)
Date:   Tue, 22 Oct 2019 18:44:17 -0300
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
Message-ID: <20191022214416.GA21651@habkost.net>
References: <1520182116-16485-1-git-send-email-luwei.kang@intel.com>
 <1520182116-16485-2-git-send-email-luwei.kang@intel.com>
 <20191012031407.GK4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382A209@SHSMSX104.ccr.corp.intel.com>
 <20191015132929.GY4084@habkost.net>
 <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E17382BB76@SHSMSX104.ccr.corp.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: BzegCTQAPeCZk_lTI7ZwPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 06:02:28AM +0000, Kang, Luwei wrote:
> > > > > f9f4cd1..097c953 100644
> > > > > --- a/target/i386/kvm.c
> > > > > +++ b/target/i386/kvm.c
> > > > > @@ -1811,6 +1811,25 @@ static int kvm_put_msrs(X86CPU *cpu, int l=
evel)
> > > > >                  kvm_msr_entry_add(cpu, MSR_MTRRphysMask(i), mask=
);
> > > > >              }
> > > > >          }
> > > > > +        if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT=
) {
> > > > > +            int addr_num =3D kvm_arch_get_supported_cpuid(kvm_st=
ate,
> > > > > +                                                    0x14, 1,
> > > > > + R_EAX) & 0x7;
> > > > > +
> > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_CTL,
> > > > > +                            env->msr_rtit_ctrl);
> > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_STATUS,
> > > > > +                            env->msr_rtit_status);
> > > > > +            kvm_msr_entry_add(cpu, MSR_IA32_RTIT_OUTPUT_BASE,
> > > > > +                            env->msr_rtit_output_base);
> > > >
> > > > This causes the following crash on some hosts:
> > > >
> > > >   qemu-system-x86_64: error: failed to set MSR 0x560 to 0x0
> > > >   qemu-system-x86_64: target/i386/kvm.c:2673: kvm_put_msrs: Asserti=
on `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
> > > >
> > > > Checking for CPUID_7_0_EBX_INTEL_PT is not enough: KVM has
> > > > additional conditions that might prevent writing to this MSR (PT_CA=
P_topa_output && PT_CAP_single_range_output).  This
> > causes QEMU to crash if some of the conditions aren't met.
> > > >
> > > > Writing and reading this MSR (and the ones below) need to be condit=
ional on KVM_GET_MSR_INDEX_LIST.
> > > >
> > >
> > > Hi Eduardo,
> > >     I found this issue can't be reproduced in upstream source code bu=
t can be reproduced on RHEL8.1. I haven't got the qemu source
> > code of RHEL8.1. But after adding some trace in KVM, I found the KVM ha=
s reported the complete Intel PT CPUID information to qemu
> > but the Intel PT CPUID (0x14) is lost when qemu setting the CPUID to KV=
M (cpuid level is 0xd). It looks like lost the below patch.
> > >
> > > commit f24c3a79a415042f6dc195f029a2ba7247d14cac
> > > Author: Luwei Kang <luwei.kang@intel.com>
> > > Date:   Tue Jan 29 18:52:59 2019 -0500
> > >     i386: extended the cpuid_level when Intel PT is enabled
> > >
> > >     Intel Processor Trace required CPUID[0x14] but the cpuid_level
> > >     have no change when create a kvm guest with
> > >     e.g. "-cpu qemu64,+intel-pt".
> >=20
> > Thanks for the pointer.  This may avoid triggering the bug in the defau=
lt configuration, but we still need to make the MSR writing
> > conditional on KVM_GET_MSR_INDEX_LIST.  Older machine-types have x-inte=
l-pt-auto-level=3Doff, and the user may set `level`
> > manually.
>=20
> Hi Eduardo,
> Sorry for a delay reply because my mail filter. I tried with
> the Q35 machine type and default, all looks work well (With
> some old cpu type + "intel_pt" also work well).  KVM will check
> the Intel PT work mode and HW to decide if Intel PT can be
> exposed to guest, only extended the CPUID level is useless. If
> the guest doesn't support Intel PT, any MSR read or write will
> cause #GP. Please remind me if I lost something.

I understand you have tried q35 and pc, but have you tried with
older machine-type versions?

Commit f24c3a79a415 doesn't change behavior on pc-*-3.1 and
older, so it only avoids triggering the crash in the default
case.  Doesn't QEMU crash if running:
"-cpu qemu64,+intel-pt -machine pc-i440fx-3.1"?

KVM rejecting MSR writes when something is missing is correct.
QEMU trying to write the MSR when something is missing (and
crashing because of that) is a bug.

--=20
Eduardo

