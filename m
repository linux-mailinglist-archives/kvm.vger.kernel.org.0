Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421881518F1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgBDKhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 05:37:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgBDKhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 05:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580812671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=4Ak30yKFdoLowaZ9b4evJ0p34pMH2ElOOZ3YejGiSaE=;
        b=QwdsKWZ0kcFnXwt9bgqF/n/HHBbGIGnTR34iwyv1BkcyKMz1/7vpCje3DiX+cudoTjIr3U
        Xt1bHTHYyef7dR3A/RI6WJ1OtmHiL9gFT1HJlmT2mETD2Mg9SSDxcbFdhuQzQckRm9Vrb2
        XK5FS6xNSBtp5l1hl+HlhvtQ/JQpirg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-01E_5977OSmefFcojUxSzA-1; Tue, 04 Feb 2020 05:37:49 -0500
X-MC-Unique: 01E_5977OSmefFcojUxSzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 961FE8010E6;
        Tue,  4 Feb 2020 10:37:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 590E65D9CA;
        Tue,  4 Feb 2020 10:37:44 +0000 (UTC)
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-7-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
Date:   Tue, 4 Feb 2020 11:37:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-7-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
>=20
> Add exceptions handlers performing transparent transition of non-secure
> pages to secure (import) upon guest access and secure pages to
> non-secure (export) upon hypervisor access.
>=20
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [adding checks for failures]
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> [further changes like adding a check for gmap fault]

Who did which modification here? According to
Documentation/process/submitting-patches.rst the square brackets should
go in front of the S-o-b of the person who did the change, e.g.:

  Signed-off-by: Random J Developer <random@developer.example.org>
  [lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
  Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>

It would be nice if you could stick to that scheme.

> ---
>  arch/s390/kernel/pgm_check.S |  4 +-
>  arch/s390/mm/fault.c         | 87 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 2 deletions(-)
[...]
> +void do_non_secure_storage_access(struct pt_regs *regs)
> +{
> +	unsigned long gaddr =3D regs->int_parm_long & __FAIL_ADDR_MASK;
> +	struct gmap *gmap =3D (struct gmap *)S390_lowcore.gmap;
> +	struct uv_cb_cts uvcb =3D {
> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
> +		.header.len =3D sizeof(uvcb),
> +		.guest_handle =3D gmap->se_handle,
> +		.gaddr =3D gaddr,
> +	};
> +	int rc;
> +
> +	if (get_fault_type(regs) !=3D GMAP_FAULT) {
> +		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
> +		WARN_ON_ONCE(1);
> +		return;
> +	}
> +
> +	rc =3D uv_make_secure(gmap, gaddr, &uvcb, 0);
> +	if (rc =3D=3D -EINVAL && uvcb.header.rc !=3D 0x104)
> +		send_sig(SIGSEGV, current, 0);
> +}

What about the other rc beside 0x104 that could happen here? They go
unnoticed?

 Thomas

