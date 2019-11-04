Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A248EEE449
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 16:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfKDPyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 10:54:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727861AbfKDPyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 10:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572882879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtaA/tnAC4AEJ5dB2aRh2Hx5/NTxvbZPsc6i8UxwZQ4=;
        b=Hu+Dp1ijixxy8QPwdmr2XzgX+F/EBCTHiNzPmLx2Ns5o7cbDL3IVdTjBSmfemh+IUXP9bR
        WFr/vmg3f1kID9is/iy8H5cFH8b/O02gyPBG49JFUzQm89EDyAQ8ICc58V2A5kvWiyMHXW
        qA+z7M4prIUs/8HYKzgM6QW0EPyoaf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Rymv6yBPOaWzPV6d7zR1qQ-1; Mon, 04 Nov 2019 10:54:35 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E77047A;
        Mon,  4 Nov 2019 15:54:34 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAFF8600C4;
        Mon,  4 Nov 2019 15:54:29 +0000 (UTC)
Date:   Mon, 4 Nov 2019 16:54:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
Message-ID: <20191104165427.0e5e6da4.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-3-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Rymv6yBPOaWzPV6d7zR1qQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:24 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
>=20
> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> protected virtual machines hosting support code.
>=20
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at runtime.
>=20
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
>=20
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  5 ++
>  arch/s390/boot/Makefile                       |  2 +-
>  arch/s390/boot/uv.c                           | 20 +++++++-
>  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>  arch/s390/kernel/Makefile                     |  1 +
>  arch/s390/kernel/setup.c                      |  4 --
>  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
>  arch/s390/kvm/Kconfig                         |  9 ++++
>  8 files changed, 126 insertions(+), 9 deletions(-)
>  create mode 100644 arch/s390/kernel/uv.c

(...)

> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index ed007f4a6444..88cf8825d169 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -3,7 +3,12 @@
>  #include <asm/facility.h>
>  #include <asm/sections.h>
> =20
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  int __bootdata_preserved(prot_virt_guest);
> +#endif
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +struct uv_info __bootdata_preserved(uv_info);
> +#endif

Two functions with the same name, but different signatures look really
ugly.

Also, what happens if I want to build just a single kernel image for
both guest and host?

> =20
>  void uv_query_info(void)
>  {
> @@ -18,7 +23,20 @@ void uv_query_info(void)
>  =09if (uv_call(0, (uint64_t)&uvcb))
>  =09=09return;
> =20
> -=09if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb=
.inst_calls_list) &&
> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)) {

Do we always have everything needed for a host if uv_call() is
successful?

> +=09=09memcpy(uv_info.inst_calls_list, uvcb.inst_calls_list, sizeof(uv_in=
fo.inst_calls_list));
> +=09=09uv_info.uv_base_stor_len =3D uvcb.uv_base_stor_len;
> +=09=09uv_info.guest_base_stor_len =3D uvcb.conf_base_phys_stor_len;
> +=09=09uv_info.guest_virt_base_stor_len =3D uvcb.conf_base_virt_stor_len;
> +=09=09uv_info.guest_virt_var_stor_len =3D uvcb.conf_virt_var_stor_len;
> +=09=09uv_info.guest_cpu_stor_len =3D uvcb.cpu_stor_len;
> +=09=09uv_info.max_sec_stor_addr =3D ALIGN(uvcb.max_guest_stor_addr, PAGE=
_SIZE);
> +=09=09uv_info.max_num_sec_conf =3D uvcb.max_num_sec_conf;
> +=09=09uv_info.max_guest_cpus =3D uvcb.max_guest_cpus;
> +=09}
> +
> +=09if (IS_ENABLED(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) &&
> +=09    test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb=
.inst_calls_list) &&
>  =09    test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, (unsigned long *)u=
vcb.inst_calls_list))

Especially as it looks like we need to test for those two commands to
determine whether we have support for a guest.

>  =09=09prot_virt_guest =3D 1;
>  }
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index ef3c00b049ab..6db1bc495e67 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -44,7 +44,19 @@ struct uv_cb_qui {
>  =09struct uv_cb_header header;
>  =09u64 reserved08;
>  =09u64 inst_calls_list[4];
> -=09u64 reserved30[15];
> +=09u64 reserved30[2];
> +=09u64 uv_base_stor_len;
> +=09u64 reserved48;
> +=09u64 conf_base_phys_stor_len;
> +=09u64 conf_base_virt_stor_len;
> +=09u64 conf_virt_var_stor_len;
> +=09u64 cpu_stor_len;
> +=09u32 reserved68[3];
> +=09u32 max_num_sec_conf;
> +=09u64 max_guest_stor_addr;
> +=09u8  reserved80[150-128];
> +=09u16 max_guest_cpus;
> +=09u64 reserved98;
>  } __packed __aligned(8);
> =20
>  struct uv_cb_share {
> @@ -69,9 +81,21 @@ static inline int uv_call(unsigned long r1, unsigned l=
ong r2)
>  =09return cc;
>  }
> =20
> -#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +struct uv_info {
> +=09unsigned long inst_calls_list[4];
> +=09unsigned long uv_base_stor_len;
> +=09unsigned long guest_base_stor_len;
> +=09unsigned long guest_virt_base_stor_len;
> +=09unsigned long guest_virt_var_stor_len;
> +=09unsigned long guest_cpu_stor_len;
> +=09unsigned long max_sec_stor_addr;
> +=09unsigned int max_num_sec_conf;
> +=09unsigned short max_guest_cpus;
> +};

What is the main difference between uv_info and uv_cb_qui? The
alignment of max_sec_stor_addr?

> +extern struct uv_info uv_info;
>  extern int prot_virt_guest;
> =20
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>  static inline int is_prot_virt_guest(void)
>  {
>  =09return prot_virt_guest;
> @@ -121,11 +145,27 @@ static inline int uv_remove_shared(unsigned long ad=
dr)
>  =09return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>  }
> =20
> -void uv_query_info(void);
>  #else
>  #define is_prot_virt_guest() 0
>  static inline int uv_set_shared(unsigned long addr) { return 0; }
>  static inline int uv_remove_shared(unsigned long addr) { return 0; }
> +#endif
> +
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +extern int prot_virt_host;
> +
> +static inline int is_prot_virt_host(void)
> +{
> +=09return prot_virt_host;
> +}
> +#else
> +#define is_prot_virt_host() 0
> +#endif
> +
> +#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                   =
       \
> +=09defined(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)
> +void uv_query_info(void);
> +#else
>  static inline void uv_query_info(void) {}
>  #endif

(...)

> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> new file mode 100644
> index 000000000000..35ce89695509
> --- /dev/null
> +++ b/arch/s390/kernel/uv.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Common Ultravisor functions and initialization
> + *
> + * Copyright IBM Corp. 2019
> + */
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/sizes.h>
> +#include <linux/bitmap.h>
> +#include <linux/memblock.h>
> +#include <asm/facility.h>
> +#include <asm/sections.h>
> +#include <asm/uv.h>
> +
> +#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> +int __bootdata_preserved(prot_virt_guest);
> +#endif
> +
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +int prot_virt_host;
> +EXPORT_SYMBOL(prot_virt_host);
> +struct uv_info __bootdata_preserved(uv_info);
> +EXPORT_SYMBOL(uv_info);
> +
> +static int __init prot_virt_setup(char *val)
> +{
> +=09bool enabled;
> +=09int rc;
> +
> +=09rc =3D kstrtobool(val, &enabled);
> +=09if (!rc && enabled)
> +=09=09prot_virt_host =3D 1;
> +
> +=09if (is_prot_virt_guest() && prot_virt_host) {
> +=09=09prot_virt_host =3D 0;
> +=09=09pr_info("Running as protected virtualization guest.");
> +=09}
> +
> +=09if (prot_virt_host && !test_facility(158)) {

Why not check for that facility earlier? If it is not present, we
cannot run as a prot virt guest, either.

> +=09=09prot_virt_host =3D 0;
> +=09=09pr_info("The ultravisor call facility is not available.");
> +=09}
> +
> +=09return rc;
> +}
> +early_param("prot_virt", prot_virt_setup);

Maybe rename this to prot_virt_host?

> +#endif

(...)

