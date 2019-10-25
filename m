Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618C8E46FF
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438379AbfJYJVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:21:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726389AbfJYJVU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 05:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571995278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8phOtogGp2hjHHsbOvvLJ37RndyQ/0HIf14DtfEUvNU=;
        b=MqgBLdqDemm3iHVuArZl4MgBnD1FcIdg3M7psK10vmAv1r67Pp5nOwwe4qsY01OGb+XhwB
        6Qp+UEjA/L9rofVY766c5XNO5mcaiYQWa0kDzyw/duX2+NNMnI6H1wct5/OvM9WJwfk7F1
        kaH95XoT6joqiCUu6o/U1yH4hcLtZzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-3DsX7h63OzGrr5p2x6GtaA-1; Fri, 25 Oct 2019 05:21:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E265E1800DFB;
        Fri, 25 Oct 2019 09:21:13 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E05B60BF3;
        Fri, 25 Oct 2019 09:21:05 +0000 (UTC)
Subject: Re: [RFC 03/37] s390/protvirt: add ultravisor initialization
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-4-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <d0bc545a-fdbb-2aa9-4f0a-2e0ea1abce5b@redhat.com>
Date:   Fri, 25 Oct 2019 11:21:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-4-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 3DsX7h63OzGrr5p2x6GtaA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
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
>   arch/s390/include/asm/uv.h | 16 ++++++++++++
>   arch/s390/kernel/setup.c   |  3 +++
>   arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 72 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 6db1bc495e67..82a46fb913e7 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -23,12 +23,14 @@
>   #define UVC_RC_NO_RESUME=090x0007
>  =20
>   #define UVC_CMD_QUI=09=09=090x0001
> +#define UVC_CMD_INIT_UV=09=09=090x000f
>   #define UVC_CMD_SET_SHARED_ACCESS=090x1000
>   #define UVC_CMD_REMOVE_SHARED_ACCESS=090x1001
>  =20
>   /* Bits in installed uv calls */
>   enum uv_cmds_inst {
>   =09BIT_UVC_CMD_QUI =3D 0,
> +=09BIT_UVC_CMD_INIT_UV =3D 1,
>   =09BIT_UVC_CMD_SET_SHARED_ACCESS =3D 8,
>   =09BIT_UVC_CMD_REMOVE_SHARED_ACCESS =3D 9,
>   };
> @@ -59,6 +61,15 @@ struct uv_cb_qui {
>   =09u64 reserved98;
>   } __packed __aligned(8);
>  =20
> +struct uv_cb_init {
> +=09struct uv_cb_header header;
> +=09u64 reserved08[2];
> +=09u64 stor_origin;
> +=09u64 stor_len;
> +=09u64 reserved28[4];
> +
> +} __packed __aligned(8);
> +
>   struct uv_cb_share {
>   =09struct uv_cb_header header;
>   =09u64 reserved08[3];
> @@ -158,8 +169,13 @@ static inline int is_prot_virt_host(void)
>   {
>   =09return prot_virt_host;
>   }
> +
> +void setup_uv(void);
> +void adjust_to_uv_max(unsigned long *vmax);
>   #else
>   #define is_prot_virt_host() 0
> +static inline void setup_uv(void) {}
> +static inline void adjust_to_uv_max(unsigned long *vmax) {}
>   #endif
>  =20
>   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                  =
        \
> diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
> index f36370f8af38..d29d83c0b8df 100644
> --- a/arch/s390/kernel/setup.c
> +++ b/arch/s390/kernel/setup.c
> @@ -567,6 +567,8 @@ static void __init setup_memory_end(void)
>   =09=09=09vmax =3D _REGION1_SIZE; /* 4-level kernel page table */
>   =09}
>  =20
> +=09adjust_to_uv_max(&vmax);

I do wonder what would happen if vmax < max_physmem_end. Not sure if=20
that is relevant at all.

> +
>   =09/* module area is at the end of the kernel address space. */
>   =09MODULES_END =3D vmax;
>   =09MODULES_VADDR =3D MODULES_END - MODULES_LEN;
> @@ -1147,6 +1149,7 @@ void __init setup_arch(char **cmdline_p)
>   =09 */
>   =09memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
>  =20
> +=09setup_uv();
>   =09setup_memory_end();
>   =09setup_memory();
>   =09dma_contiguous_reserve(memory_end);
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 35ce89695509..f7778493e829 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -45,4 +45,57 @@ static int __init prot_virt_setup(char *val)
>   =09return rc;
>   }
>   early_param("prot_virt", prot_virt_setup);
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

If I'm not wrong, we could setup/reserve a CMA area here and defer the=20
actual allocation. Then, any MOVABLE data can end up on this CMA area=20
until needed.

But I am neither an expert on CMA nor on UV, so most probably what I say=20
is wrong ;)

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
> +}
> +
> +void adjust_to_uv_max(unsigned long *vmax)
> +{
> +=09if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> +=09=09*vmax =3D uv_info.max_sec_stor_addr;
> +}
>   #endif
>=20

Looks good to me from what I can tell.

--=20

Thanks,

David / dhildenb

