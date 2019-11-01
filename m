Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633BCEBBBC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 02:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfKABgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 21:36:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKABgL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 21:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572572169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYDSQOMoLeBQPkoIfK0rZWTvMqm4xHGkJlGTOAlUVYo=;
        b=KOkU3zEfaliPi6L492qQMnGQadO15/P4T8auw0ZFPhIDvqdAMYOvwVMGfxBMY84KCIpWRC
        EFULuvL+k3GgFEhw91heqUE/So8NCpgS2r7UUamJnwInQVq+caqi+edHVlBCsaGGvXJAxI
        b/FbhqRf9t5x7/cOfimYRwz+JZnsvk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-EkSvj3Y5PJyIOJkCl0A6mw-1; Thu, 31 Oct 2019 21:36:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D0A800D49
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 01:36:07 +0000 (UTC)
Received: from amt.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A28E5D6A7;
        Fri,  1 Nov 2019 01:36:06 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 3A4E010516E;
        Thu, 31 Oct 2019 23:35:41 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id xA11ZbLi024096;
        Thu, 31 Oct 2019 23:35:37 -0200
Date:   Thu, 31 Oct 2019 23:35:37 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: KVM: x86: switch KVMCLOCK base to monotonic raw clock
Message-ID: <20191101013534.GA23801@amt.cnet>
References: <20191028143619.GA14370@amt.cnet>
 <08c9fce5-90ef-222d-ed86-e337f912b4a8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <08c9fce5-90ef-222d-ed86-e337f912b4a8@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: EkSvj3Y5PJyIOJkCl0A6mw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 01, 2019 at 01:09:50AM +0100, Paolo Bonzini wrote:
> On 28/10/19 15:36, Marcelo Tosatti wrote:
> >=20
> > Commit 0bc48bea36d1 ("KVM: x86: update master clock before computing
> > kvmclock_offset")
> > switches the order of operations to avoid the conversion=20
> >=20
> > TSC (without frequency correction) ->
> > system_timestamp (with frequency correction),=20
> >=20
> > which might cause a time jump.
> >=20
> > However, it leaves any other masterclock update unsafe, which includes,=
=20
> > at the moment:
> >=20
> >         * HV_X64_MSR_REFERENCE_TSC MSR write.
> >         * TSC writes.
> >         * Host suspend/resume.
> >=20
> > Avoid the time jump issue by using frequency uncorrected
> > CLOCK_MONOTONIC_RAW clock.=20
> >=20
> > Its the guests time keeping software responsability
> > to track and correct a reference clock such as UTC.
> >=20
> > This fixes forward time jump (which can result in=20
> > failure to bring up a vCPU) during vCPU hotplug:
> >=20
> > Oct 11 14:48:33 storage kernel: CPU2 has been hot-added
> > Oct 11 14:48:34 storage kernel: CPU3 has been hot-added
> > Oct 11 14:49:22 storage kernel: smpboot: Booting Node 0 Processor 2 API=
C 0x2          <-- time jump of almost 1 minute
> > Oct 11 14:49:22 storage kernel: smpboot: do_boot_cpu failed(-1) to wake=
up CPU#2
> > Oct 11 14:49:23 storage kernel: smpboot: Booting Node 0 Processor 3 API=
C 0x3
> > Oct 11 14:49:23 storage kernel: kvm-clock: cpu 3, msr 0:7ff640c1, secon=
dary cpu clock
> >=20
> > Which happens because:
> >=20
> >                 /*                                                     =
         =20
> >                  * Wait 10s total for a response from AP               =
         =20
> >                  */                                                    =
         =20
> >                 boot_error =3D -1;                                     =
           =20
> >                 timeout =3D jiffies + 10*HZ;                           =
           =20
> >                 while (time_before(jiffies, timeout)) {=20
> >                          ...
> >                 }
> >=20
> > Analyzed-by: Igor Mammedov <imammedo@redhat.com>
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 661e2bf..ff713a1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1521,20 +1521,25 @@ static int do_set_msr(struct kvm_vcpu *vcpu, un=
signed index, u64 *data)
> >  }
> > =20
> >  #ifdef CONFIG_X86_64
> > +struct pvclock_clock {
> > +=09int vclock_mode;
> > +=09u64 cycle_last;
> > +=09u64 mask;
> > +=09u32 mult;
> > +=09u32 shift;
> > +};
> > +
> >  struct pvclock_gtod_data {
> >  =09seqcount_t=09seq;
> > =20
> > -=09struct { /* extract of a clocksource struct */
> > -=09=09int vclock_mode;
> > -=09=09u64=09cycle_last;
> > -=09=09u64=09mask;
> > -=09=09u32=09mult;
> > -=09=09u32=09shift;
> > -=09} clock;
> > +=09struct pvclock_clock clock; /* extract of a clocksource struct */
> > +=09struct pvclock_clock raw_clock; /* extract of a clocksource struct =
*/
> > =20
> > +=09u64=09=09boot_ns_raw;
> >  =09u64=09=09boot_ns;
> >  =09u64=09=09nsec_base;
> >  =09u64=09=09wall_time_sec;
> > +=09u64=09=09monotonic_raw_nsec;
> >  };
> > =20
> >  static struct pvclock_gtod_data pvclock_gtod_data;
> > @@ -1542,10 +1547,20 @@ struct pvclock_gtod_data {
> >  static void update_pvclock_gtod(struct timekeeper *tk)
> >  {
> >  =09struct pvclock_gtod_data *vdata =3D &pvclock_gtod_data;
> > -=09u64 boot_ns;
> > +=09u64 boot_ns, boot_ns_raw;
> > =20
> >  =09boot_ns =3D ktime_to_ns(ktime_add(tk->tkr_mono.base, tk->offs_boot)=
);
> > =20
> > +=09/*
> > +=09 * FIXME: tk->offs_boot should be converted to CLOCK_MONOTONIC_RAW
> > +=09 * interval (that is, without frequency adjustment for that interva=
l).
> > +=09 *
> > +=09 * Lack of this fix can cause system_timestamp to not be equal to
> > +=09 * CLOCK_MONOTONIC_RAW (which happen if the host uses
> > +=09 * suspend/resume).
> > +=09 */
>=20
> This is scary.  Essentially you're saying that you'd want a
> CLOCK_BOOTTIME_RAW.  But is this true?  CLOCK_BOOTTIME only differs by
> the suspend time, and that is computed directly in nanoseconds so the

Its read from the RTC.

> different frequency of CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW does not
> affect it.

Still different frequency from RTC and TSC, which can cause
system_timestamp to not equal CLOCK_MONOTONIC_RAW (but in fact i don't
see a fix for that, and the hosts clock also suffers from the same
issue).

Should i remove the fixme ? Or just add a note about this fact
of suspend/resume ?=20

