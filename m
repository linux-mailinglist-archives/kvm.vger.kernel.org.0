Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF310EB4C
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 15:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfLBOGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 09:06:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727544AbfLBOGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 09:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575295594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aFSsSaba0PQssGQ5xtZsVEwB/8VIoUj7hYVGKWKv0A=;
        b=Cj/p9o6WLX2op37PDyUxw/Zymt6PSm/+4C2uMD8YpD8YgkY/UFT/ZAENN4zIopycM1wpN3
        CU6dT1w6JIyXiZIzCEu9HxzLrBTYY+2FkxRBCYsndqnmUlAwxCIw+AZOTjU9ihGuZiPiG/
        U0gUA2OuZcGY0JZ4KIWXNLqb35h+WBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-miLdwQutNRWraoXofOsy7A-1; Mon, 02 Dec 2019 09:06:31 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18C27DBED;
        Mon,  2 Dec 2019 14:06:30 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7435160BFB;
        Mon,  2 Dec 2019 14:06:26 +0000 (UTC)
Date:   Mon, 2 Dec 2019 15:06:23 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/9] s390x: Library resources for CSS
 tests
Message-ID: <20191202150623.627730ad.cohuck@redhat.com>
In-Reply-To: <1574945167-29677-6-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
        <1574945167-29677-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: miLdwQutNRWraoXofOsy7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Nov 2019 13:46:03 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> These are the include and library utilities for the css tests patch
> series.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 269 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_dump.c | 147 +++++++++++++++++++++++
>  2 files changed, 416 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> new file mode 100644
> index 0000000..95dec72
> --- /dev/null
> +++ b/lib/s390x/css.h
> @@ -0,0 +1,269 @@
> +/*
> + * CSS definitions
> + *
> + * Copyright IBM, Corp. 2019
> + * Author: Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#ifndef CSS_H
> +#define CSS_H
> +
> +#define CCW_F_CD	0x80
> +#define CCW_F_CC	0x40
> +#define CCW_F_SLI	0x20
> +#define CCW_F_SKP	0x10
> +#define CCW_F_PCI	0x08
> +#define CCW_F_IDA	0x04
> +#define CCW_F_S		0x02
> +#define CCW_F_MIDA	0x01
> +
> +#define CCW_C_NOP	0x03
> +#define CCW_C_TIC	0x08
> +
> +struct ccw {

ccw1, to make it clear that this is a format-1 ccw?

(Do you have any plans to test this with format-0 ccws as well?)

> +	unsigned char code;
> +	unsigned char flags;
> +	unsigned short count;
> +	unsigned int data;

data_address?

> +} __attribute__ ((aligned(4)));
> +
> +#define ORB_M_KEY	0xf0000000
> +#define ORB_F_SUSPEND	0x08000000
> +#define ORB_F_STREAMING	0x04000000
> +#define ORB_F_MODIFCTRL	0x02000000
> +#define ORB_F_SYNC	0x01000000
> +#define ORB_F_FORMAT	0x00800000
> +#define ORB_F_PREFETCH	0x00400000
> +#define ORB_F_INIT_IRQ	0x00200000
> +#define ORB_F_ADDRLIMIT	0x00100000
> +#define ORB_F_SUSP_IRQ	0x00080000
> +#define ORB_F_TRANSPORT	0x00040000
> +#define ORB_F_IDAW2	0x00020000
> +#define ORB_F_IDAW_2K	0x00010000
> +#define ORB_M_LPM	0x0000ff00
> +#define ORB_F_LPM_DFLT	0x00008000
> +#define ORB_F_ILSM	0x00000080
> +#define ORB_F_CCW_IND	0x00000040
> +#define ORB_F_ORB_EXT	0x00000001
> +
> +struct orb {
> +	unsigned int	intparm;
> +	unsigned int	ctrl;
> +	unsigned int	cpa;
> +	unsigned int	prio;
> +	unsigned int	reserved[4];
> +} __attribute__ ((aligned(4)));
> +
> +struct scsw {
> +	uint32_t ctrl;
> +	uint32_t addr;

ccw_addr?

> +	uint8_t  devs;
> +	uint8_t  schs;

Maybe dev_stat/sch_stat?

> +	uint16_t count;
> +};

Out of curiousity (I'm not familiar with the conventions in
kvm-unit-tests): You use the explicit uint32_t et al. types here, while
you used unsigned int et al. in the other definitions... maybe it would
be better to use one or the other?

Also, you probably always want to test against a QEMU-provided device
anyway, so you can probably ignore transport mode and stick with
command mode only, right?

> +
> +struct pmcw {
> +	uint32_t intparm;
> +#define PMCW_DNV        0x0001
> +#define PMCW_ENABLE     0x0080
> +	uint16_t flags;
> +	uint16_t devnum;
> +	uint8_t  lpm;
> +	uint8_t  pnom;
> +	uint8_t  lpum;
> +	uint8_t  pim;
> +	uint16_t mbi;
> +	uint8_t  pom;
> +	uint8_t  pam;
> +	uint8_t  chpid[8];
> +	struct {
> +		uint8_t res0;
> +		uint8_t st:3;
> +		uint8_t :5;
> +		uint16_t :13;
> +		uint16_t f:1;
> +		uint16_t x:1;
> +		uint16_t s:1;
> +	};

Hm... you used masks for the other fields, any reason you didn't here?

> +};
> +
> +struct schib {
> +	struct pmcw pmcw;
> +	struct scsw scsw;
> +	uint32_t  md0;
> +	uint32_t  md1;
> +	uint32_t  md2;

Hm, both Linux and QEMU express the fields you called md<n> as a 64 bit
measurement-block address and a four bytes model-dependent area...
would it make sense to do so here as well? If the extended measurement
block facility is not installed, we'd get a 12 bytes model-dependent
area, which IMHO would also look better here.

> +} __attribute__ ((aligned(4)));
> +
> +struct irb {
> +	struct scsw scsw;
> +	uint32_t esw[5];
> +	uint32_t ecw[8];
> +	uint32_t emw[8];

If I read the PoP correctly, esw, ecw, and emw are defined bytewise,
not u32-wise.

> +} __attribute__ ((aligned(4)));
> +
> +/* CSS low level access functions */
> +
> +static inline int ssch(unsigned long schid, struct orb *addr)
> +{
> +	register long long reg1 asm("1") = schid;
> +	int cc = -1;
> +
> +	asm volatile(
> +		"	   ssch	0(%2)\n"
> +		"0:	 ipm	 %0\n"
> +		"	   srl	 %0,28\n"
> +		"1:\n"
> +		: "+d" (cc)
> +		: "d" (reg1), "a" (addr), "m" (*addr)
> +		: "cc", "memory");
> +	return cc;
> +}

Looking at the Linux code, stsch, msch, and ssch all set up an
exception handler. IIRC, I had introduced that for stsch for multiple
subchannels sets, not sure about the others. Are we sure we never need
to catch exceptions here?

> +
> +static inline int stsch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") = schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	   stsch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=d" (cc), "=m" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return cc;
> +}
> +
> +static inline int msch(unsigned long schid, struct schib *addr)
> +{
> +	register unsigned long reg1 asm ("1") = schid;
> +	int cc;
> +
> +	asm volatile(
> +		"	   msch	0(%3)\n"
> +		"	   ipm	 %0\n"
> +		"	   srl	 %0,28"
> +		: "=d" (cc), "=m" (*addr)
> +		: "d" (reg1), "a" (addr)
> +		: "cc");
> +	return cc;
> +}

(...)

> +static inline int rchp(unsigned long chpid)
> +{
> +	register unsigned long reg1 asm("1") = chpid;
> +	int cc;
> +
> +	asm volatile(
> +		"	rchp\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28"
> +		: "=d" (cc)
> +		: "d" (reg1)
> +		: "cc");
> +	return cc;
> +}

Does rchp actually do anything useful on QEMU? Or is this mainly for
completeness' sake?

> +
> +/* Debug functions */
> +char *dump_pmcw_flags(uint16_t f);
> +char *dump_scsw_flags(uint32_t f);
> +#undef DEBUG
> +#ifdef DEBUG
> +void dump_scsw(struct scsw *);
> +void dump_irb(struct irb *irbp);
> +void dump_schib(struct schib *sch);
> +struct ccw *dump_ccw(struct ccw *cp);
> +#else
> +static inline void dump_scsw(struct scsw *scsw){}
> +static inline void dump_irb(struct irb *irbp){}
> +static inline void dump_pmcw(struct pmcw *p){}
> +static inline void dump_schib(struct schib *sch){}
> +static inline void dump_orb(struct orb *op){}
> +static inline struct ccw *dump_ccw(struct ccw *cp)
> +{
> +	return NULL;
> +}
> +#endif
> +
> +extern unsigned long stacktop;
> +#endif
> diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
> new file mode 100644
> index 0000000..5356df2
> --- /dev/null
> +++ b/lib/s390x/css_dump.c
> @@ -0,0 +1,147 @@
> +/*
> + * Channel Sub-System structures dumping

I think "subsystem" is the more usual spelling.

> + *
> + * Copyright (c) 2019 IBM Corp.
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + *
> + * Description:
> + * Provides the dumping functions for various structures used by subchannels:
> + * - ORB  : Operation request block, describe the I/O operation and point to

s/describe/describes/
s/point/points/

> + *          a CCW chain
> + * - CCW  : Channel Command Word, describe the data and flow control

s/describe/describes/

but maybe better:

"contains the command, parameters, and a pointer to data"

?

Also this is format-1 only, isn't it?

> + * - IRB  : Interuption response Block, describe the result of an operation

s/describe/describes/

> + *          hold a SCSW and several channel type dependent fields.

s/hold/holds/

s/several channel type dependent fields/model-dependent data/ ?

> + * - SCHIB: SubChannel Information Block composed of:

s/SubChannel/Subchannel/

> + *   - SCSW: SubChannel Status Word, status of the channel as a result of an

s/SubChannel/Subchannel/

> + *           operation when in IRB.

I think that description is a bit confusing: An SCSW always contains
the subchannel status; it's just when it is contained in an IRB that
the status is associated to the last event on that subchannel (as the
result of an operation, or as an unsolicited status.)

> + *   - PMCW: Path Management Control Word
> + * You need the QEMU ccw-pong device in QEMU to answer the I/O transfers.
> + */
> +
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <string.h>
> +
> +#include <css.h>
> +
> +static const char *scsw_str = "kkkkslccfpixuzen";
> +static const char *scsw_str2 = "1SHCrshcsdsAIPSs";

Nice, random strings? :)

(...)

