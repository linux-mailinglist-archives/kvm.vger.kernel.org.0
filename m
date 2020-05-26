Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651391E2704
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388663AbgEZQaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:30:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42301 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388659AbgEZQaT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 12:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590510618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFH+lO6ohBLSBU7ZKmdmDibYJAoqrjA+Qt35whMPcWw=;
        b=EUZkshHKix5V8A8TVgiiQyEAnHam7R4/CUwI58JY22zn6URz62Cn6672aS2ryHSnZjb6kv
        HfPtsZX6syJfbArFlF9uS28jtT4/EsgIAJID4eWMku+1pusGcRDqdbOBNLaB8lLWYXb4Ek
        NGRihovDRBqHP5tWWnnm025cr7IGPk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-gsgQ_yY5Oge-dN8-dIAyXQ-1; Tue, 26 May 2020 12:30:15 -0400
X-MC-Unique: gsgQ_yY5Oge-dN8-dIAyXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CAEC8018A7;
        Tue, 26 May 2020 16:30:14 +0000 (UTC)
Received: from gondolin (ovpn-113-77.ams2.redhat.com [10.36.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 225B95C1BB;
        Tue, 26 May 2020 16:30:09 +0000 (UTC)
Date:   Tue, 26 May 2020 18:30:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 07/12] s390x: Library resources for
 CSS tests
Message-ID: <20200526183005.76fc9124.cohuck@redhat.com>
In-Reply-To: <1589818051-20549-8-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-8-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:07:26 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Provide some definitions and library routines that can be used by
> tests targeting the channel subsystem.
> 
> Debug function can be activated by defining DEBUG_CSS before the
> inclusion of the css.h header file.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h      | 259 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/css_dump.c | 157 ++++++++++++++++++++++++++
>  s390x/Makefile       |   1 +
>  3 files changed, 417 insertions(+)
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
> 

(...)

> +struct ccw1 {
> +	unsigned char code;
> +	unsigned char flags;
> +	unsigned short count;

I'm wondering why you're using unsigned {char,short} here, instead of
the uint*_t types everywhere else? It's not wrong, but probably better
to be consistent?

> +	uint32_t data_address;
> +} __attribute__ ((aligned(4)));
> +
> +#define SID_ONE		0x00010000
> +

I think it would be beneficial for the names to somewhat match the
naming in Linux and/or QEMU -- or more speaking names (as you do for
some), which is also good.

> +#define ORB_M_KEY	0xf0000000
> +#define ORB_F_SUSPEND	0x08000000
> +#define ORB_F_STREAMING	0x04000000
> +#define ORB_F_MODIFCTRL	0x02000000
> +#define ORB_F_SYNC	0x01000000
> +#define ORB_F_FORMAT	0x00800000
> +#define ORB_F_PREFETCH	0x00400000
> +#define ORB_F_INIT_IRQ	0x00200000

ORB_F_ISIC? (As it does not refer to 'initialization', but 'initial'.)

> +#define ORB_F_ADDRLIMIT	0x00100000
> +#define ORB_F_SUSP_IRQ	0x00080000

ORB_F_SSIC? (As it deals with suppression.)

> +#define ORB_F_TRANSPORT	0x00040000
> +#define ORB_F_IDAW2	0x00020000

ORB_F_IDAW_FMT2?

Or following Linux/QEMU, use ORB_F_C64 for a certain retro appeal :)

> +#define ORB_F_IDAW_2K	0x00010000
> +#define ORB_M_LPM	0x0000ff00
> +#define ORB_F_LPM_DFLT	0x00008000

That's a default lpm of 0x80, right? It's a bit buried between the orb
definitions, and it also seems to be more of a implementation choice --
move it out from the flags here?

> +#define ORB_F_ILSM	0x00000080

ORB_F_ILS?

> +#define ORB_F_CCW_IND	0x00000040

ORB_F_MIDAW? I had a hard time figuring out that one :)

> +#define ORB_F_ORB_EXT	0x00000001

(...)

> +/*
> + * Try o have a more human representation of the PMCW flags

s/o/to/

> + * each letter in the string represent the first

s/represent/represents/

> + * letter of the associated bit in the flag fields.
> + */

(...)

Generally, looks good to me.

