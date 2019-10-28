Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03680E741B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 15:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390404AbfJ1OzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 10:55:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27929 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727227AbfJ1OzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Oct 2019 10:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572274513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Jp7CpqTm0L+bqd2B7yrvKaIM5Cq2LYfQcPQByUtcdc=;
        b=hy6+ywhn8uLXDrcQV0KHr9UrsxCuPTCaJdGHBaH9EksAsK7w1M85T4wcmG5ye55PMuf8tL
        mAe3rM1aiEuVaTHWyMSJSxGroRuaaq4rsiBYY3Dm4CTxEDMBeYZgI5IyU+jd1O7lUv775B
        36GYx2KF6v8Ye12MKp+Eq2BagpT0tPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-hlh2CZ35PJCPStbZhnNq4w-1; Mon, 28 Oct 2019 10:55:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 643FC85B6EE;
        Mon, 28 Oct 2019 14:55:07 +0000 (UTC)
Received: from gondolin (ovpn-117-206.ams2.redhat.com [10.36.117.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C63160FA2;
        Mon, 28 Oct 2019 14:54:56 +0000 (UTC)
Date:   Mon, 28 Oct 2019 15:54:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
Message-ID: <20191028155453.4b142994.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-3-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: hlh2CZ35PJCPStbZhnNq4w-1
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

> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index d3db3d7ed077..652b36f0efca 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -55,6 +55,15 @@ config KVM_S390_UCONTROL
> =20
>  =09  If unsure, say N.
> =20
> +config KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +=09bool "Protected guests execution support"
> +=09depends on KVM
> +=09---help---
> +=09  Support hosting protected virtual machines isolated from the
> +=09  hypervisor.

I'm currently in the process of glancing across this patch set (won't
be able to get around to properly looking at it until next week the
earliest), so just a very high level comment:

I think there's not enough information in here to allow someone
configuring the kernel to decide what this is and if it would be useful
to them. This should probably be at least point to some document giving
some more details. Also, can you add a sentence where this feature is
actually expected to be available?

> +
> +=09  If unsure, say Y.

Is 'Y' really the safe choice here? AFAICS, this is introducing new
code and not only trying to call new interfaces, if available. Is there
any drawback to enabling this on a kernel that won't run on a platform
supporting this feature? Is this supposed to be a common setup?

> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly =
under
>  # the virtualization menu.
>  source "drivers/vhost/Kconfig"

