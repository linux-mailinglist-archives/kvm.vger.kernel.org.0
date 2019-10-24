Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3119AE3410
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732797AbfJXNZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:25:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41084 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730235AbfJXNZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571923539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RnaYVIBwVCBk1qnxC/jWasOEO6e/vywHfNN0nktWCZM=;
        b=Bv+7pzXMRCe61VORc8N1NW5WG1oP3QCUW0qUyEZz6HUryu5DXwwL2kG9H+G4lYPfbh19Vv
        3A8Ak82UxUja6zGnQhSSbLS120Kn9Eao8aVkyLgAo3dapv64m2bNXPJhwhL3oq/tDhPHVt
        SA5XlviK+KkjmAlF7P0m07B7Nz+pYHM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-S4LDN_mDNRanYpJ-l0avxQ-1; Thu, 24 Oct 2019 09:25:35 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33FF647B;
        Thu, 24 Oct 2019 13:25:34 +0000 (UTC)
Received: from [10.36.116.141] (ovpn-116-141.ams2.redhat.com [10.36.116.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B38710027A9;
        Thu, 24 Oct 2019 13:25:32 +0000 (UTC)
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-3-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <e1a12cc7-de97-127d-6076-f86b7be6bac1@redhat.com>
Date:   Thu, 24 Oct 2019 15:25:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-3-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: S4LDN_mDNRanYpJ-l0avxQ-1
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
>   .../admin-guide/kernel-parameters.txt         |  5 ++
>   arch/s390/boot/Makefile                       |  2 +-
>   arch/s390/boot/uv.c                           | 20 +++++++-
>   arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
>   arch/s390/kernel/Makefile                     |  1 +
>   arch/s390/kernel/setup.c                      |  4 --
>   arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
>   arch/s390/kvm/Kconfig                         |  9 ++++
>   8 files changed, 126 insertions(+), 9 deletions(-)
>   create mode 100644 arch/s390/kernel/uv.c
>=20
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentat=
ion/admin-guide/kernel-parameters.txt
> index c7ac2f3ac99f..aa22e36b3105 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3693,6 +3693,11 @@
>   =09=09=09before loading.
>   =09=09=09See Documentation/admin-guide/blockdev/ramdisk.rst.
>  =20
> +=09prot_virt=3D=09[S390] enable hosting protected virtual machines
> +=09=09=09isolated from the hypervisor (if hardware supports
> +=09=09=09that).
> +=09=09=09Format: <bool>

Isn't that a virt driver detail that should come in via KVM module=20
parameters? I don't see quite yet why this has to be a kernel parameter=20
(that can be changed at runtime).

--=20

Thanks,

David / dhildenb

