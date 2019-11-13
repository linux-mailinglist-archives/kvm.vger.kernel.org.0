Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01ABCFB10C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 14:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfKMNFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 08:05:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30248 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727122AbfKMNFu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 08:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573650348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzuB70X2L591fX6uCZ1N72IlLgOXbE5oNWHyCti9s+o=;
        b=Uhff75ZohX/YHm9j37BB50PnK0ZW2l1Fcwc/evsn+WqUDdzmc9JX/qlCE6zSoZSR+7JxSv
        xvvAq2UK3poo+KIQ/STd/6w1J09Esr5yoMvplRynl/NI6duX6/5R31Ablhvbjgn1HZrbhr
        wAJeQDzkMO0zQKZ4wh9PjzukQSHPInU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-6DzfgOYePmKWKokthGSOdQ-1; Wed, 13 Nov 2019 08:05:47 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53F2C477;
        Wed, 13 Nov 2019 13:05:46 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A221BEA66;
        Wed, 13 Nov 2019 13:05:42 +0000 (UTC)
Date:   Wed, 13 Nov 2019 14:05:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v1 4/4] s390x: Testing the Subchannel I/O read
Message-ID: <20191113140539.4d153d5f.cohuck@redhat.com>
In-Reply-To: <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
        <1573647799-30584-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 6DzfgOYePmKWKokthGSOdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Nov 2019 13:23:19 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> This simple test test the I/O reading by the SUB Channel by:
> - initializing the Channel SubSystem with predefined CSSID:
>   0xfe000000 CSSID for a Virtual CCW

0 should be fine with recent QEMU versions as well, I guess?

>   0x00090000 SSID for CCW-PONG

subchannel id, or subchannel set id?

> - initializing the ORB pointing to a single READ CCW

Out of curiosity: Would using a NOP also be an option?

> - starts the STSH command with the ORB

s/STSH/SSCH/ ?

> - Expect an interrupt
> - writes the read data to output
>=20
> The test implements lots of traces when DEBUG is on and
> tests if memory above the stack is corrupted.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 244 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  lib/s390x/css_dump.c | 141 +++++++++++++++++++++++++++++
>  s390x/Makefile       |   2 +
>  s390x/css.c          | 222 +++++++++++++++++++++++++++++++++++++++++++++=
+
>  s390x/unittests.cfg  |   4 +
>  5 files changed, 613 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
>  create mode 100644 s390x/css.c
>=20
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..a7c42fd
> --- /dev/null
> +++ b/lib/s390x/css.h

(...)

> +static inline int rsch(unsigned long schid)

I don't think anyone has tried rsch with QEMU before; sounds like a
good idea to test this :)

> +{
> +=09register unsigned long reg1 asm("1") =3D schid;
> +=09int ccode;
> +
> +=09asm volatile(
> +=09=09"=09rsch\n"
> +=09=09"=09ipm=09%0\n"
> +=09=09"=09srl=09%0,28"
> +=09=09: "=3Dd" (ccode)
> +=09=09: "d" (reg1)
> +=09=09: "cc");
> +=09return ccode;
> +}
> +
> +static inline int rchp(unsigned long chpid)

Anything useful we can test here?

> +{
> +=09register unsigned long reg1 asm("1") =3D chpid;
> +=09int ccode;
> +
> +=09asm volatile(
> +=09=09"=09rchp\n"
> +=09=09"=09ipm=09%0\n"
> +=09=09"=09srl=09%0,28"
> +=09=09: "=3Dd" (ccode)
> +=09=09: "d" (reg1)
> +=09=09: "cc");
> +=09return ccode;
> +}

(...)

> diff --git a/s390x/css.c b/s390x/css.c
> new file mode 100644
> index 0000000..6cdaf61
> --- /dev/null
> +++ b/s390x/css.c

(...)

> +static void set_io_irq_subclass_mask(uint64_t const new_mask)
> +{
> +=09asm volatile (
> +=09=09"lctlg %%c6, %%c6, %[source]\n"
> +=09=09: /* No outputs */
> +=09=09: [source] "R" (new_mask));
> +}
> +
> +static void set_system_mask(uint8_t new_mask)
> +{
> +=09asm volatile (
> +=09=09"ssm %[source]\n"
> +=09=09: /* No outputs */
> +=09=09: [source] "R" (new_mask));
> +}
> +
> +static void enable_io_irq(void)
> +{
> +=09set_io_irq_subclass_mask(0x00000000ff000000);

So, you always enable all iscs? Maybe add a comment?

> +=09set_system_mask(PSW_PRG_MASK >> 56);
> +}
> +
> +void handle_io_int(sregs_t *regs)
> +{
> +=09int ret =3D 0;
> +
> +=09DBG("IO IRQ: subsys_id_word=3D%08x", lowcore->subsys_id_word);
> +=09DBG("......: io_int_parm   =3D%08x", lowcore->io_int_param);
> +=09DBG("......: io_int_word   =3D%08x", lowcore->io_int_word);
> +=09ret =3D tsch(lowcore->subsys_id_word, &irb);
> +=09dump_irb(&irb);
> +=09if (ret)
> +=09=09DBG("......: tsch retval %d", ret);
> +=09DBG("IO IRQ: END");
> +}
> +
> +static void set_schib(struct schib *sch)
> +{
> +=09struct pmcw *p =3D &sch->pmcw;
> +
> +=09p->intparm =3D 0xdeadbeef;
> +=09p->devnum =3D 0xc0ca;
> +=09p->lpm =3D 0x80;
> +=09p->flags =3D 0x3081;

Use #defines instead of magic numbers?

> +=09p->chpid[7] =3D 0x22;
> +=09p->pim =3D 0x0f;
> +=09p->pam =3D 0x0f;
> +=09p->pom =3D 0x0f;
> +=09p->lpm =3D 0x0f;
> +=09p->lpum =3D 0xaa;
> +=09p->pnom =3D 0xf0;
> +=09p->mbi =3D 0xaa;
> +=09p->mbi =3D 0xaaaa;

Many of these fields are not supposed to be modifiable by the program
-- do you want to check what you get back after msch?

Also, you set mbi twice ;) (And for it to actually have any effect,
you'd have to execute SET CHANNEL MONITOR, no?)


> +}
> +
> +static void css_enable(void)
> +{
> +=09int ret;
> +
> +=09ret =3D stsch(CSSID_PONG, &schib);
> +=09if (ret)
> +=09=09DBG("stsch: %x\n", ret);
> +=09dump_schib(&schib);
> +=09set_schib(&schib);
> +=09dump_schib(&schib);
> +=09ret =3D msch(CSSID_PONG, &schib);
> +=09if (ret)
> +=09=09DBG("msch : %x\n", ret);
> +}
> +
> +/* These two definitions are part of the QEMU PONG interface */
> +#define PONG_WRITE 0x21
> +#define PONG_READ  0x22

Ah, so it's not a plain read/write, but a specialized one? Mention that
in the patch description?

> +
> +static int css_run(int fake)
> +{
> +=09struct orb *p =3D orb;

I'd maybe call that variable 'orb' instead; at a glance, I was confused
what you did with the pmcw below, until I realized that it's the orb :)

> +=09int cc;
> +
> +=09if (fake)
> +=09=09return 0;
> +=09css_enable();
> +
> +=09enable_io_irq();
> +
> +=09ccw[0].code =3D PONG_READ;
> +=09ccw[0].flags =3D CCW_F_PCI;
> +=09ccw[0].count =3D 80;
> +=09ccw[0].data =3D (unsigned int)(unsigned long) &buffer;
> +
> +=09p->intparm =3D 0xcafec0ca;
> +=09p->ctrl =3D ORB_F_INIT_IRQ|ORB_F_FORMAT|ORB_F_LPM_DFLT;
> +=09p->cpa =3D (unsigned int) (unsigned long)&ccw[0];
> +
> +=09printf("ORB AT %p\n", orb);
> +=09dump_orb(p);
> +=09cc =3D ssch(CSSID_PONG, p);
> +=09if (cc) {
> +=09=09DBG("cc: %x\n", cc);
> +=09=09return cc;
> +=09}
> +
> +=09delay(1);
> +
> +=09stsch(CSSID_PONG, &schib);
> +=09dump_schib(&schib);
> +=09DBG("got: %s\n", buffer);
> +
> +=09return 0;
> +}
(...)

