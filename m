Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE75151AC2
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBDMtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:49:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37753 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727127AbgBDMtA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 07:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580820538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=oX5GlZgXq82vNSWN9LhqpMNOHy1UTBtpuifHtRuB3ac=;
        b=cUubMmqeQmDwlQczh41zwUGRkI38r5Rwy3LzONlIeWUEWpkNexswseOHlh5q+kcDjHEF4/
        0Irhg0kGnYHXHv9Uleoo86bCS21UZUmHlnRpnfn0hZlJLWCG2MfnyGe03cUlqGKSNmCp5D
        zUT2lzlPWh9vLOFqYFxiIXBQFqHeaGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-Kefbzag3NmGXLDX4x6HCcw-1; Tue, 04 Feb 2020 07:48:55 -0500
X-MC-Unique: Kefbzag3NmGXLDX4x6HCcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9F2059901;
        Tue,  4 Feb 2020 12:48:53 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8953E87B1A;
        Tue,  4 Feb 2020 12:48:49 +0000 (UTC)
Subject: Re: [RFCv2 06/37] s390: add (non)secure page access exceptions
 handlers
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-7-borntraeger@de.ibm.com>
 <dd3d333d-d141-5a22-9b1d-161232b37cfb@redhat.com>
 <20200204124123.183ef25b@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2362357d-f2b5-62f2-8cb1-b7e281ea66e2@redhat.com>
Date:   Tue, 4 Feb 2020 13:48:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200204124123.183ef25b@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/2020 12.41, Claudio Imbrenda wrote:
> On Tue, 4 Feb 2020 11:37:42 +0100
> Thomas Huth <thuth@redhat.com> wrote:
>=20
> [...]
>=20
>>> ---
>>>  arch/s390/kernel/pgm_check.S |  4 +-
>>>  arch/s390/mm/fault.c         | 87
>>> ++++++++++++++++++++++++++++++++++++ 2 files changed, 89
>>> insertions(+), 2 deletions(-) =20
>> [...]
>>> +void do_non_secure_storage_access(struct pt_regs *regs)
>>> +{
>>> +	unsigned long gaddr =3D regs->int_parm_long &
>>> __FAIL_ADDR_MASK;
>>> +	struct gmap *gmap =3D (struct gmap *)S390_lowcore.gmap;
>>> +	struct uv_cb_cts uvcb =3D {
>>> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
>>> +		.header.len =3D sizeof(uvcb),
>>> +		.guest_handle =3D gmap->se_handle,
>>> +		.gaddr =3D gaddr,
>>> +	};
>>> +	int rc;
>>> +
>>> +	if (get_fault_type(regs) !=3D GMAP_FAULT) {
>>> +		do_fault_error(regs, VM_READ | VM_WRITE,
>>> VM_FAULT_BADMAP);
>>> +		WARN_ON_ONCE(1);
>>> +		return;
>>> +	}
>>> +
>>> +	rc =3D uv_make_secure(gmap, gaddr, &uvcb, 0);
>>> +	if (rc =3D=3D -EINVAL && uvcb.header.rc !=3D 0x104)
>>> +		send_sig(SIGSEGV, current, 0);
>>> +} =20
>>
>> What about the other rc beside 0x104 that could happen here? They go
>> unnoticed?
>=20
> no, they are handled in the uv_make_secure, and return an appropriate
> error code.=20
Hmm, in patch 05/37, I basically see:

+static int make_secure_pte(pte_t *ptep, unsigned long addr, void *data)
+{
[...]
+	rc =3D uv_call(0, (u64)params->uvcb);
+	page_ref_unfreeze(page, expected);
+	if (rc)
+		rc =3D (params->uvcb->rc =3D=3D 0x10a) ? -ENXIO : -EINVAL;
+	return rc;
+}

+int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb,
int pins)
+{
[...]
+	lock_page(params.page);
+	rc =3D apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE, make_secure_pte,
&params);
+	unlock_page(params.page);
+out:
+	up_read(&gmap->mm->mmap_sem);
+
+	if (rc =3D=3D -EBUSY) {
+		if (local_drain) {
+			lru_add_drain_all();
+			return -EAGAIN;
+		}
+		lru_add_drain();
+		local_drain =3D 1;
+		goto again;
+	} else if (rc =3D=3D -ENXIO) {
+		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
+			return -EFAULT;
+		return -EAGAIN;
+	}
+	return rc;
+}

So 0x10a result in -ENXIO and is handled =3D=3D> OK.
And 0x104 is handled in do_non_secure_storage_access =3D=3D> OK.

But what about the other possible error codes? make_secure_pte() returns
-EINVAL in that case, but uv_make_secure() does not care about that
error code, and do_non_secure_storage_access() only cares if
uvcb.header.rc was 0x104 ... what did I miss?

 Thomas

