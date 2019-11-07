Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82361F32F4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfKGP2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 10:28:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51736 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726231AbfKGP2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 10:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573140524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lFqlZJZ37tGFz/G4K4JZ1Hz2QYP9k4eYL9tt0I0noI=;
        b=EmHqwopL4mLEuMigUlwr96/uildgaNR6kP4IDE2x99JPutohQlymfBGoFHpJ2YcTCAfghV
        n4Hnl2XOGFOeyVmVnfmKM0lWOvjJMF60chT19T9IBTAk8QAO3AhrIsYDkyddLthzfKbn9J
        pWpf9NxeOEfEWOhx3XuQ5u2C+gVfVUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-RrwxuE9mPx-bLJee797VZg-1; Thu, 07 Nov 2019 10:28:40 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D4A08017E0;
        Thu,  7 Nov 2019 15:28:39 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF381600D1;
        Thu,  7 Nov 2019 15:28:33 +0000 (UTC)
Date:   Thu, 7 Nov 2019 16:28:31 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
Message-ID: <20191107162831.489e0591.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-4-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: RrwxuE9mPx-bLJee797VZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:25 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
>=20
> Before being able to host protected virtual machines, donate some of
> the memory to the ultravisor. Besides that the ultravisor might impose
> addressing limitations for memory used to back protected VM storage. Trea=
t
> that limit as protected virtualization host's virtual memory limit.
>=20
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 16 ++++++++++++
>  arch/s390/kernel/setup.c   |  3 +++
>  arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)

(...)

> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 35ce89695509..f7778493e829 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -45,4 +45,57 @@ static int __init prot_virt_setup(char *val)
>  =09return rc;
>  }
>  early_param("prot_virt", prot_virt_setup);
> +
> +static int __init uv_init(unsigned long stor_base, unsigned long stor_le=
n)
> +{
> +=09struct uv_cb_init uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_INIT_UV,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.stor_origin =3D stor_base,
> +=09=09.stor_len =3D stor_len,
> +=09};
> +=09int cc;
> +
> +=09cc =3D uv_call(0, (uint64_t)&uvcb);
> +=09if (cc || uvcb.header.rc !=3D UVC_RC_EXECUTED) {
> +=09=09pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
> +=09=09       uvcb.header.rc);
> +=09=09return -1;

Is there any reasonable case where that call might fail if we have the
facility installed? Bad stor_base, maybe?

> +=09}
> +=09return 0;
> +}
> +
> +void __init setup_uv(void)
> +{
> +=09unsigned long uv_stor_base;
> +
> +=09if (!prot_virt_host)
> +=09=09return;
> +
> +=09uv_stor_base =3D (unsigned long)memblock_alloc_try_nid(
> +=09=09uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
> +=09=09MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
> +=09if (!uv_stor_base) {
> +=09=09pr_info("Failed to reserve %lu bytes for ultravisor base storage\n=
",
> +=09=09=09uv_info.uv_base_stor_len);
> +=09=09goto fail;
> +=09}
> +
> +=09if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
> +=09=09memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
> +=09=09goto fail;
> +=09}
> +
> +=09pr_info("Reserving %luMB as ultravisor base storage\n",
> +=09=09uv_info.uv_base_stor_len >> 20);
> +=09return;
> +fail:
> +=09prot_virt_host =3D 0;

So, what happens if the user requested protected virtualization and any
of the above failed? We turn off host support, so any attempt to start
a protected virtualization guest on that host will fail (hopefully with
a meaningful error), I guess.

Is there any use case where we'd want to make failure to set this up
fatal?

> +}
> +
> +void adjust_to_uv_max(unsigned long *vmax)
> +{
> +=09if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> +=09=09*vmax =3D uv_info.max_sec_stor_addr;
> +}
>  #endif

