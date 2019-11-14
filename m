Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733DCFC68A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfKNMu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:50:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53158 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbfKNMu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 07:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573735826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ef1l1hqWsyzLFpC0Xy1WV8z70mxsduypt90ZVppGFE=;
        b=F1jDV562T2p9teuNk83grPE9cOi/OLpwDNW9sthF0uLCAq07pEJZel+pPGkLPJ5H3Nt4je
        ebTMNu/JBDCKp1JSHVX2Lz2QxHN6xTJmSLC2CPOiR6QGmYoqzJ52XdpfKbPY+sDwew91j9
        jRQ2j2FrEEobNjisJ5Q68mRTXHbQ2go=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ZO4SwoSyMV6wAsWtqsZhTA-1; Thu, 14 Nov 2019 07:50:23 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D2701005509;
        Thu, 14 Nov 2019 12:50:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0E0D60BEC;
        Thu, 14 Nov 2019 12:50:20 +0000 (UTC)
Date:   Thu, 14 Nov 2019 13:50:18 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 12/17] arm: gic: Change gic_read_iar() to
 take group parameter
Message-ID: <20191114125018.tqz5uzwmjofhbbwo@kamzik.brq.redhat.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-13-andre.przywara@arm.com>
 <68cd4ae5-0d85-4300-2851-adb3f5af6243@arm.com>
MIME-Version: 1.0
In-Reply-To: <68cd4ae5-0d85-4300-2851-adb3f5af6243@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ZO4SwoSyMV6wAsWtqsZhTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 05:19:36PM +0000, Alexandru Elisei wrote:
> Hi,
>=20
> On 11/8/19 2:42 PM, Andre Przywara wrote:
> > Acknowledging a GIC group 0 interrupt requires us to use a different
> > system register on GICv3. To allow us to differentiate the two groups
> > later, add a group parameter to gic_read_iar(). For GICv2 we can use th=
e
> > same CPU interface register to acknowledge group 0 as well, so we ignor=
e
> > the parameter here.
> >
> > For now this is still using group 1 on every caller.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arm/gic.c                  |  4 ++--
> >  arm/micro-bench.c          |  2 +-
> >  arm/pl031.c                |  2 +-
> >  arm/timer.c                |  2 +-
> >  lib/arm/asm/arch_gicv3.h   | 11 +++++++++--
> >  lib/arm/asm/gic-v2.h       |  2 +-
> >  lib/arm/asm/gic-v3.h       |  2 +-
> >  lib/arm/asm/gic.h          |  2 +-
> >  lib/arm/gic-v2.c           |  3 ++-
> >  lib/arm/gic.c              |  6 +++---
> >  lib/arm64/asm/arch_gicv3.h | 10 ++++++++--
> >  11 files changed, 30 insertions(+), 16 deletions(-)
> >
> > diff --git a/arm/gic.c b/arm/gic.c
> > index a0511e5..7be13a6 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -156,7 +156,7 @@ static void check_irqnr(u32 irqnr, int expected)
> > =20
> >  static void irq_handler(struct pt_regs *regs __unused)
> >  {
> > -=09u32 irqstat =3D gic_read_iar();
> > +=09u32 irqstat =3D gic_read_iar(1);
> >  =09u32 irqnr =3D gic_iar_irqnr(irqstat);
> > =20
> >  =09if (irqnr =3D=3D GICC_INT_SPURIOUS) {
> > @@ -288,7 +288,7 @@ static struct gic gicv3 =3D {
> > =20
> >  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
> >  {
> > -=09u32 irqstat =3D gic_read_iar();
> > +=09u32 irqstat =3D gic_read_iar(1);
> >  =09u32 irqnr =3D gic_iar_irqnr(irqstat);
> > =20
> >  =09if (irqnr !=3D GICC_INT_SPURIOUS) {
> > diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> > index 4612f41..2bfee68 100644
> > --- a/arm/micro-bench.c
> > +++ b/arm/micro-bench.c
> > @@ -33,7 +33,7 @@ static void ipi_irq_handler(struct pt_regs *regs)
> >  {
> >  =09ipi_ready =3D false;
> >  =09ipi_received =3D true;
> > -=09gic_write_eoir(gic_read_iar());
> > +=09gic_write_eoir(gic_read_iar(1));
> >  =09ipi_ready =3D true;
> >  }
> > =20
> > diff --git a/arm/pl031.c b/arm/pl031.c
> > index 5672f36..5be3d76 100644
> > --- a/arm/pl031.c
> > +++ b/arm/pl031.c
> > @@ -134,7 +134,7 @@ static void gic_irq_unmask(void)
> > =20
> >  static void irq_handler(struct pt_regs *regs)
> >  {
> > -=09u32 irqstat =3D gic_read_iar();
> > +=09u32 irqstat =3D gic_read_iar(1);
> >  =09u32 irqnr =3D gic_iar_irqnr(irqstat);
> > =20
> >  =09gic_write_eoir(irqstat);
> > diff --git a/arm/timer.c b/arm/timer.c
> > index 0b808d5..e5cc3b4 100644
> > --- a/arm/timer.c
> > +++ b/arm/timer.c
> > @@ -150,7 +150,7 @@ static void set_timer_irq_enabled(struct timer_info=
 *info, bool enabled)
> >  static void irq_handler(struct pt_regs *regs)
> >  {
> >  =09struct timer_info *info;
> > -=09u32 irqstat =3D gic_read_iar();
> > +=09u32 irqstat =3D gic_read_iar(1);
> >  =09u32 irqnr =3D gic_iar_irqnr(irqstat);
> > =20
> >  =09if (irqnr !=3D GICC_INT_SPURIOUS)
> > diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> > index 45b6096..52e7bba 100644
> > --- a/lib/arm/asm/arch_gicv3.h
> > +++ b/lib/arm/asm/arch_gicv3.h
> > @@ -16,6 +16,7 @@
> > =20
> >  #define ICC_PMR=09=09=09=09__ACCESS_CP15(c4, 0, c6, 0)
> >  #define ICC_SGI1R=09=09=09__ACCESS_CP15_64(0, c12)
> > +#define ICC_IAR0=09=09=09__ACCESS_CP15(c12, 0,  c8, 0)
> >  #define ICC_IAR1=09=09=09__ACCESS_CP15(c12, 0, c12, 0)
> >  #define ICC_EOIR1=09=09=09__ACCESS_CP15(c12, 0, c12, 1)
> >  #define ICC_IGRPEN1=09=09=09__ACCESS_CP15(c12, 0, c12, 7)
> > @@ -30,9 +31,15 @@ static inline void gicv3_write_sgi1r(u64 val)
> >  =09write_sysreg(val, ICC_SGI1R);
> >  }
> > =20
> > -static inline u32 gicv3_read_iar(void)
> > +static inline u32 gicv3_read_iar(int group)
> >  {
> > -=09u32 irqstat =3D read_sysreg(ICC_IAR1);
> > +=09u32 irqstat;
> > +
> > +=09if (group =3D=3D 0)
> > +=09=09irqstat =3D read_sysreg(ICC_IAR0);
> > +=09else
> > +=09=09irqstat =3D read_sysreg(ICC_IAR1);
> > +
> >  =09dsb(sy);
> >  =09return irqstat;
> >  }
> > diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
> > index 1fcfd43..d50c610 100644
> > --- a/lib/arm/asm/gic-v2.h
> > +++ b/lib/arm/asm/gic-v2.h
> > @@ -32,7 +32,7 @@ extern struct gicv2_data gicv2_data;
> > =20
> >  extern int gicv2_init(void);
> >  extern void gicv2_enable_defaults(void);
> > -extern u32 gicv2_read_iar(void);
> > +extern u32 gicv2_read_iar(int group);
> >  extern u32 gicv2_iar_irqnr(u32 iar);
> >  extern void gicv2_write_eoir(u32 irqstat);
> >  extern void gicv2_ipi_send_single(int irq, int cpu);
> > diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> > index 0a29610..ca19110 100644
> > --- a/lib/arm/asm/gic-v3.h
> > +++ b/lib/arm/asm/gic-v3.h
> > @@ -69,7 +69,7 @@ extern struct gicv3_data gicv3_data;
> > =20
> >  extern int gicv3_init(void);
> >  extern void gicv3_enable_defaults(void);
> > -extern u32 gicv3_read_iar(void);
> > +extern u32 gicv3_read_iar(int group);
> >  extern u32 gicv3_iar_irqnr(u32 iar);
> >  extern void gicv3_write_eoir(u32 irqstat);
> >  extern void gicv3_ipi_send_single(int irq, int cpu);
> > diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> > index 21cdb58..09663e7 100644
> > --- a/lib/arm/asm/gic.h
> > +++ b/lib/arm/asm/gic.h
> > @@ -68,7 +68,7 @@ extern void gic_enable_defaults(void);
> >   * below will work with any supported gic version.
> >   */
> >  extern int gic_version(void);
> > -extern u32 gic_read_iar(void);
> > +extern u32 gic_read_iar(int group);
> >  extern u32 gic_iar_irqnr(u32 iar);
> >  extern void gic_write_eoir(u32 irqstat);
> >  extern void gic_ipi_send_single(int irq, int cpu);
> > diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
> > index dc6a97c..b60967e 100644
> > --- a/lib/arm/gic-v2.c
> > +++ b/lib/arm/gic-v2.c
> > @@ -26,8 +26,9 @@ void gicv2_enable_defaults(void)
> >  =09writel(GICC_ENABLE, cpu_base + GICC_CTLR);
> >  }
> > =20
> > -u32 gicv2_read_iar(void)
> > +u32 gicv2_read_iar(int group)
> >  {
> > +=09/* GICv2 acks both group0 and group1 IRQs with the same register. *=
/
> >  =09return readl(gicv2_cpu_base() + GICC_IAR);
> >  }
> > =20
> > diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> > index cf4e811..b51eff5 100644
> > --- a/lib/arm/gic.c
> > +++ b/lib/arm/gic.c
> > @@ -12,7 +12,7 @@ struct gicv3_data gicv3_data;
> > =20
> >  struct gic_common_ops {
> >  =09void (*enable_defaults)(void);
> > -=09u32 (*read_iar)(void);
> > +=09u32 (*read_iar)(int group);
> >  =09u32 (*iar_irqnr)(u32 iar);
> >  =09void (*write_eoir)(u32 irqstat);
> >  =09void (*ipi_send_single)(int irq, int cpu);
> > @@ -117,10 +117,10 @@ void gic_enable_defaults(void)
> >  =09gic_common_ops->enable_defaults();
> >  }
> > =20
> > -u32 gic_read_iar(void)
> > +u32 gic_read_iar(int group)
> >  {
> >  =09assert(gic_common_ops && gic_common_ops->read_iar);
> > -=09return gic_common_ops->read_iar();
> > +=09return gic_common_ops->read_iar(group);
> >  }
> > =20
> >  u32 gic_iar_irqnr(u32 iar)
> > diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
> > index a7994ec..876e1fc 100644
> > --- a/lib/arm64/asm/arch_gicv3.h
> > +++ b/lib/arm64/asm/arch_gicv3.h
> > @@ -11,6 +11,7 @@
> >  #include <asm/sysreg.h>
> > =20
> >  #define ICC_PMR_EL1=09=09=09sys_reg(3, 0, 4, 6, 0)
> > +#define ICC_IAR0_EL1=09=09=09sys_reg(3, 0, 12, 8, 0)
> >  #define ICC_SGI1R_EL1=09=09=09sys_reg(3, 0, 12, 11, 5)
> >  #define ICC_IAR1_EL1=09=09=09sys_reg(3, 0, 12, 12, 0)
> >  #define ICC_EOIR1_EL1=09=09=09sys_reg(3, 0, 12, 12, 1)
> > @@ -38,10 +39,15 @@ static inline void gicv3_write_sgi1r(u64 val)
> >  =09asm volatile("msr_s " xstr(ICC_SGI1R_EL1) ", %0" : : "r" (val));
> >  }
> > =20
> > -static inline u32 gicv3_read_iar(void)
> > +static inline u32 gicv3_read_iar(int group)
> >  {
> >  =09u64 irqstat;
> > -=09asm volatile("mrs_s %0, " xstr(ICC_IAR1_EL1) : "=3Dr" (irqstat));
> > +
> > +=09if (group =3D=3D 0)
> > +=09=09asm volatile("mrs_s %0, " xstr(ICC_IAR0_EL1) : "=3Dr" (irqstat))=
;
> > +=09else
> > +=09=09asm volatile("mrs_s %0, " xstr(ICC_IAR1_EL1) : "=3Dr" (irqstat))=
;
> > +
> >  =09dsb(sy);
> >  =09return (u64)irqstat;
> >  }
>=20
> I'm not sure this is the best approach. Now every test that happens to us=
e the gic
> has to know about interrupt groups. Have you considered implementing the =
functions
> that you need for the test in arm/gic.c? Andrew, what do you think?
>=20

I agree that we should provide a simple API, hiding as many GIC details as
possible, for tests that need to handle IRQs but don't need to know the
specifics. Indeed I think gic_read_iar() and gic_write_eoir() should be
renamed to something like gic_get_irqstat() and gic_eoi() to be more
generic. Also gic_iar_irqnr() should probably be reimplemented as per-gic
macros named something like GIC_IRQNR(irqstat). For groups we can change
the gic_get_irqstat(void) gic op to gic_get_group_irqstat(int group), and
then add this common gic function

u32 gic_get_irqstat(void)
{
  return gic_get_group_irqstat(GIC_DEFAULT_GROUP);
}

How's that sound?

Thanks,
drew

