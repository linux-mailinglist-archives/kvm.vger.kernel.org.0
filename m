Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B542167759
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 09:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbgBUIlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 03:41:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729037AbgBUIlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 03:41:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582274494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TX2bKGmaoFX1kB0Vs23BSK7K2oJcCGlc8FxuCCpPBNM=;
        b=XoB+RpOmVnovaFaXCSajDLv5PkzhrP9+UX4Lk3OzEqm6bWaKzrJK7tdHGCfpTcc0SMOSgN
        WGk4IGHdwTRLYl2CdsfEK0sNZReEEObJQ+mqeocJQoS2pY82xMx4sSiTtfXIRelnLXhOks
        rTwNFVusOEDwuZ5lTr2JLlnWBVD89yo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-7fL0ULPGP-G8hP98qjPlqQ-1; Fri, 21 Feb 2020 03:41:32 -0500
X-MC-Unique: 7fL0ULPGP-G8hP98qjPlqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCDF78010CA;
        Fri, 21 Feb 2020 08:41:28 +0000 (UTC)
Received: from gondolin (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF76E26FAA;
        Fri, 21 Feb 2020 08:41:09 +0000 (UTC)
Date:   Fri, 21 Feb 2020 09:41:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?B?SGVy?= =?UTF-8?B?dsOp?= Poussineau 
        <hpoussin@reactos.org>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: Re: [PATCH v3 19/20] Let cpu_[physical]_memory() calls pass a
 boolean 'is_write' argument
Message-ID: <20200221094107.7e855499.cohuck@redhat.com>
In-Reply-To: <20200220130548.29974-20-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
        <20200220130548.29974-20-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Feb 2020 14:05:47 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> Use an explicit boolean type.
>=20
> This commit was produced with the included Coccinelle script
> scripts/coccinelle/exec_rw_const.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  scripts/coccinelle/exec_rw_const.cocci | 14 ++++++++++++++
>  include/exec/cpu-common.h              |  4 ++--
>  hw/display/exynos4210_fimd.c           |  3 ++-
>  hw/display/milkymist-tmu2.c            |  8 ++++----
>  hw/display/omap_dss.c                  |  2 +-
>  hw/display/ramfb.c                     |  2 +-
>  hw/misc/pc-testdev.c                   |  2 +-
>  hw/nvram/spapr_nvram.c                 |  4 ++--
>  hw/ppc/ppc440_uc.c                     |  6 ++++--
>  hw/ppc/spapr_hcall.c                   |  4 ++--
>  hw/s390x/ipl.c                         |  2 +-
>  hw/s390x/s390-pci-bus.c                |  2 +-
>  hw/s390x/virtio-ccw.c                  |  2 +-
>  hw/xen/xen_pt_graphics.c               |  2 +-
>  target/i386/hax-all.c                  |  4 ++--
>  target/s390x/excp_helper.c             |  2 +-
>  target/s390x/helper.c                  |  6 +++---
>  17 files changed, 43 insertions(+), 26 deletions(-)
>=20

> diff --git a/hw/s390x/ipl.c b/hw/s390x/ipl.c
> index 7773499d7f..0817874b48 100644
> --- a/hw/s390x/ipl.c
> +++ b/hw/s390x/ipl.c
> @@ -626,7 +626,7 @@ static void s390_ipl_prepare_qipl(S390CPU *cpu)
>      uint8_t *addr;
>      uint64_t len =3D 4096;
> =20
> -    addr =3D cpu_physical_memory_map(cpu->env.psa, &len, 1);
> +    addr =3D cpu_physical_memory_map(cpu->env.psa, &len, true);
>      if (!addr || len < QIPL_ADDRESS + sizeof(QemuIplParameters)) {
>          error_report("Cannot set QEMU IPL parameters");
>          return;
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 7c6a2b3c63..ed8be124da 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -641,7 +641,7 @@ static uint8_t set_ind_atomic(uint64_t ind_loc, uint8=
_t to_be_set)
>      hwaddr len =3D 1;
>      uint8_t *ind_addr;
> =20
> -    ind_addr =3D cpu_physical_memory_map(ind_loc, &len, 1);
> +    ind_addr =3D cpu_physical_memory_map(ind_loc, &len, true);
>      if (!ind_addr) {
>          s390_pci_generate_error_event(ERR_EVENT_AIRERR, 0, 0, 0, 0);
>          return -1;
> diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
> index 13f57e7b67..50cf95b781 100644
> --- a/hw/s390x/virtio-ccw.c
> +++ b/hw/s390x/virtio-ccw.c
> @@ -790,7 +790,7 @@ static uint8_t virtio_set_ind_atomic(SubchDev *sch, u=
int64_t ind_loc,
>      hwaddr len =3D 1;
>      uint8_t *ind_addr;
> =20
> -    ind_addr =3D cpu_physical_memory_map(ind_loc, &len, 1);
> +    ind_addr =3D cpu_physical_memory_map(ind_loc, &len, true);
>      if (!ind_addr) {
>          error_report("%s(%x.%x.%04x): unable to access indicator",
>                       __func__, sch->cssid, sch->ssid, sch->schid);

> diff --git a/target/s390x/excp_helper.c b/target/s390x/excp_helper.c
> index 1e9d6f20c1..3b58d10df3 100644
> --- a/target/s390x/excp_helper.c
> +++ b/target/s390x/excp_helper.c
> @@ -393,7 +393,7 @@ static int mchk_store_vregs(CPUS390XState *env, uint6=
4_t mcesao)
>      MchkExtSaveArea *sa;
>      int i;
> =20
> -    sa =3D cpu_physical_memory_map(mcesao, &len, 1);
> +    sa =3D cpu_physical_memory_map(mcesao, &len, true);
>      if (!sa) {
>          return -EFAULT;
>      }
> diff --git a/target/s390x/helper.c b/target/s390x/helper.c
> index a3a49164e4..b810ad431e 100644
> --- a/target/s390x/helper.c
> +++ b/target/s390x/helper.c
> @@ -151,7 +151,7 @@ LowCore *cpu_map_lowcore(CPUS390XState *env)
>      LowCore *lowcore;
>      hwaddr len =3D sizeof(LowCore);
> =20
> -    lowcore =3D cpu_physical_memory_map(env->psa, &len, 1);
> +    lowcore =3D cpu_physical_memory_map(env->psa, &len, true);
> =20
>      if (len < sizeof(LowCore)) {
>          cpu_abort(env_cpu(env), "Could not map lowcore\n");
> @@ -246,7 +246,7 @@ int s390_store_status(S390CPU *cpu, hwaddr addr, bool=
 store_arch)
>      hwaddr len =3D sizeof(*sa);
>      int i;
> =20
> -    sa =3D cpu_physical_memory_map(addr, &len, 1);
> +    sa =3D cpu_physical_memory_map(addr, &len, true);
>      if (!sa) {
>          return -EFAULT;
>      }
> @@ -298,7 +298,7 @@ int s390_store_adtl_status(S390CPU *cpu, hwaddr addr,=
 hwaddr len)
>      hwaddr save =3D len;
>      int i;
> =20
> -    sa =3D cpu_physical_memory_map(addr, &save, 1);
> +    sa =3D cpu_physical_memory_map(addr, &save, true);
>      if (!sa) {
>          return -EFAULT;
>      }

s390 parts
Acked-by: Cornelia Huck <cohuck@redhat.com>

