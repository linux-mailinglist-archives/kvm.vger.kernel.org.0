Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E4E73C9
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 15:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390195AbfJ1Og6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 10:36:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729377AbfJ1Og5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 10:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572273416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1tDPTKYm0gFl0ElnSqLHmBt0Ic2EiYyOwiQjqnXl2sU=;
        b=Yj16+7d0I+62dNWIEo+1xle/yq4IWH0X5rZXZXP+pIWyzYqSwD89ZMBP2GIdY1TL6XTET4
        jhcnlUM82lHH0fq0dXdSKA7i2AM0DnhzGSKpuczQu1xUDx6Kfv25FZxtI2XuRk/x7oFn3B
        aRu5ZoR0NCP1ODRMi4Ie4Qf44gsd3L4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-eRFzfWePNUSNu7Gi3UzFWg-1; Mon, 28 Oct 2019 10:36:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52CD7180491C
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 14:36:53 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6AAE5D6AE;
        Mon, 28 Oct 2019 14:36:45 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 31BFB105153;
        Mon, 28 Oct 2019 12:36:27 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x9SEaMxL014838;
        Mon, 28 Oct 2019 12:36:22 -0200
Date:   Mon, 28 Oct 2019 12:36:22 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: KVM: x86: switch KVMCLOCK base to monotonic raw clock
Message-ID: <20191028143619.GA14370@amt.cnet>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: eRFzfWePNUSNu7Gi3UzFWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Commit 0bc48bea36d1 ("KVM: x86: update master clock before computing
kvmclock_offset")
switches the order of operations to avoid the conversion=20

TSC (without frequency correction) ->
system_timestamp (with frequency correction),=20

which might cause a time jump.

However, it leaves any other masterclock update unsafe, which includes,=20
at the moment:

        * HV_X64_MSR_REFERENCE_TSC MSR write.
        * TSC writes.
        * Host suspend/resume.

Avoid the time jump issue by using frequency uncorrected
CLOCK_MONOTONIC_RAW clock.=20

Its the guests time keeping software responsability
to track and correct a reference clock such as UTC.

This fixes forward time jump (which can result in=20
failure to bring up a vCPU) during vCPU hotplug:

Oct 11 14:48:33 storage kernel: CPU2 has been hot-added
Oct 11 14:48:34 storage kernel: CPU3 has been hot-added
Oct 11 14:49:22 storage kernel: smpboot: Booting Node 0 Processor 2 APIC 0x=
2          <-- time jump of almost 1 minute
Oct 11 14:49:22 storage kernel: smpboot: do_boot_cpu failed(-1) to wakeup C=
PU#2
Oct 11 14:49:23 storage kernel: smpboot: Booting Node 0 Processor 3 APIC 0x=
3
Oct 11 14:49:23 storage kernel: kvm-clock: cpu 3, msr 0:7ff640c1, secondary=
 cpu clock

Which happens because:

                /*                                                         =
     =20
                 * Wait 10s total for a response from AP                   =
     =20
                 */                                                        =
     =20
                boot_error =3D -1;                                         =
       =20
                timeout =3D jiffies + 10*HZ;                               =
       =20
                while (time_before(jiffies, timeout)) {=20
                         ...
                }

Analyzed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf..ff713a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1521,20 +1521,25 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsign=
ed index, u64 *data)
 }
=20
 #ifdef CONFIG_X86_64
+struct pvclock_clock {
+=09int vclock_mode;
+=09u64 cycle_last;
+=09u64 mask;
+=09u32 mult;
+=09u32 shift;
+};
+
 struct pvclock_gtod_data {
 =09seqcount_t=09seq;
=20
-=09struct { /* extract of a clocksource struct */
-=09=09int vclock_mode;
-=09=09u64=09cycle_last;
-=09=09u64=09mask;
-=09=09u32=09mult;
-=09=09u32=09shift;
-=09} clock;
+=09struct pvclock_clock clock; /* extract of a clocksource struct */
+=09struct pvclock_clock raw_clock; /* extract of a clocksource struct */
=20
+=09u64=09=09boot_ns_raw;
 =09u64=09=09boot_ns;
 =09u64=09=09nsec_base;
 =09u64=09=09wall_time_sec;
+=09u64=09=09monotonic_raw_nsec;
 };
=20
 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -1542,10 +1547,20 @@ struct pvclock_gtod_data {
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
 =09struct pvclock_gtod_data *vdata =3D &pvclock_gtod_data;
-=09u64 boot_ns;
+=09u64 boot_ns, boot_ns_raw;
=20
 =09boot_ns =3D ktime_to_ns(ktime_add(tk->tkr_mono.base, tk->offs_boot));
=20
+=09/*
+=09 * FIXME: tk->offs_boot should be converted to CLOCK_MONOTONIC_RAW
+=09 * interval (that is, without frequency adjustment for that interval).
+=09 *
+=09 * Lack of this fix can cause system_timestamp to not be equal to
+=09 * CLOCK_MONOTONIC_RAW (which happen if the host uses
+=09 * suspend/resume).
+=09 */
+=09boot_ns_raw =3D ktime_to_ns(ktime_add(tk->tkr_raw.base, tk->offs_boot))=
;
+
 =09write_seqcount_begin(&vdata->seq);
=20
 =09/* copy pvclock gtod data */
@@ -1555,11 +1570,20 @@ static void update_pvclock_gtod(struct timekeeper *=
tk)
 =09vdata->clock.mult=09=09=3D tk->tkr_mono.mult;
 =09vdata->clock.shift=09=09=3D tk->tkr_mono.shift;
=20
+=09vdata->raw_clock.vclock_mode=09=3D tk->tkr_raw.clock->archdata.vclock_m=
ode;
+=09vdata->raw_clock.cycle_last=09=3D tk->tkr_raw.cycle_last;
+=09vdata->raw_clock.mask=09=09=3D tk->tkr_raw.mask;
+=09vdata->raw_clock.mult=09=09=3D tk->tkr_raw.mult;
+=09vdata->raw_clock.shift=09=09=3D tk->tkr_raw.shift;
+
 =09vdata->boot_ns=09=09=09=3D boot_ns;
 =09vdata->nsec_base=09=09=3D tk->tkr_mono.xtime_nsec;
=20
 =09vdata->wall_time_sec            =3D tk->xtime_sec;
=20
+=09vdata->boot_ns_raw=09=09=3D boot_ns_raw;
+=09vdata->monotonic_raw_nsec=09=3D tk->tkr_raw.xtime_nsec;
+
 =09write_seqcount_end(&vdata->seq);
 }
 #endif
@@ -1983,21 +2007,21 @@ static u64 read_tsc(void)
 =09return last;
 }
=20
-static inline u64 vgettsc(u64 *tsc_timestamp, int *mode)
+static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
+=09=09=09  int *mode)
 {
 =09long v;
-=09struct pvclock_gtod_data *gtod =3D &pvclock_gtod_data;
 =09u64 tsc_pg_val;
=20
-=09switch (gtod->clock.vclock_mode) {
+=09switch (clock->vclock_mode) {
 =09case VCLOCK_HVCLOCK:
 =09=09tsc_pg_val =3D hv_read_tsc_page_tsc(hv_get_tsc_page(),
 =09=09=09=09=09=09  tsc_timestamp);
 =09=09if (tsc_pg_val !=3D U64_MAX) {
 =09=09=09/* TSC page valid */
 =09=09=09*mode =3D VCLOCK_HVCLOCK;
-=09=09=09v =3D (tsc_pg_val - gtod->clock.cycle_last) &
-=09=09=09=09gtod->clock.mask;
+=09=09=09v =3D (tsc_pg_val - clock->cycle_last) &
+=09=09=09=09clock->mask;
 =09=09} else {
 =09=09=09/* TSC page invalid */
 =09=09=09*mode =3D VCLOCK_NONE;
@@ -2006,8 +2030,8 @@ static inline u64 vgettsc(u64 *tsc_timestamp, int *mo=
de)
 =09case VCLOCK_TSC:
 =09=09*mode =3D VCLOCK_TSC;
 =09=09*tsc_timestamp =3D read_tsc();
-=09=09v =3D (*tsc_timestamp - gtod->clock.cycle_last) &
-=09=09=09gtod->clock.mask;
+=09=09v =3D (*tsc_timestamp - clock->cycle_last) &
+=09=09=09clock->mask;
 =09=09break;
 =09default:
 =09=09*mode =3D VCLOCK_NONE;
@@ -2016,10 +2040,10 @@ static inline u64 vgettsc(u64 *tsc_timestamp, int *=
mode)
 =09if (*mode =3D=3D VCLOCK_NONE)
 =09=09*tsc_timestamp =3D v =3D 0;
=20
-=09return v * gtod->clock.mult;
+=09return v * clock->mult;
 }
=20
-static int do_monotonic_boot(s64 *t, u64 *tsc_timestamp)
+static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
 {
 =09struct pvclock_gtod_data *gtod =3D &pvclock_gtod_data;
 =09unsigned long seq;
@@ -2028,10 +2052,10 @@ static int do_monotonic_boot(s64 *t, u64 *tsc_times=
tamp)
=20
 =09do {
 =09=09seq =3D read_seqcount_begin(&gtod->seq);
-=09=09ns =3D gtod->nsec_base;
-=09=09ns +=3D vgettsc(tsc_timestamp, &mode);
+=09=09ns =3D gtod->monotonic_raw_nsec;
+=09=09ns +=3D vgettsc(&gtod->raw_clock, tsc_timestamp, &mode);
 =09=09ns >>=3D gtod->clock.shift;
-=09=09ns +=3D gtod->boot_ns;
+=09=09ns +=3D gtod->boot_ns_raw;
 =09} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 =09*t =3D ns;
=20
@@ -2049,7 +2073,7 @@ static int do_realtime(struct timespec64 *ts, u64 *ts=
c_timestamp)
 =09=09seq =3D read_seqcount_begin(&gtod->seq);
 =09=09ts->tv_sec =3D gtod->wall_time_sec;
 =09=09ns =3D gtod->nsec_base;
-=09=09ns +=3D vgettsc(tsc_timestamp, &mode);
+=09=09ns +=3D vgettsc(&gtod->clock, tsc_timestamp, &mode);
 =09=09ns >>=3D gtod->clock.shift;
 =09} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
=20
@@ -2066,7 +2090,7 @@ static bool kvm_get_time_and_clockread(s64 *kernel_ns=
, u64 *tsc_timestamp)
 =09if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
 =09=09return false;
=20
-=09return gtod_is_based_on_tsc(do_monotonic_boot(kernel_ns,
+=09return gtod_is_based_on_tsc(do_monotonic_raw(kernel_ns,
 =09=09=09=09=09=09      tsc_timestamp));
 }
=20

