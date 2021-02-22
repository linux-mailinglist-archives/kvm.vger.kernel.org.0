Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A26F321E6A
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhBVRoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:44:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhBVRoe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:44:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614015787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iZK1AHq84V95gWDJ19gXOB4yY4ebnGHnrWYQW1lx22Y=;
        b=IsXEY80aIDhHGew0TYz61iIKps7KqoxQiLBRRMu+2Q5c8MiiVTDidhKAjXLUnVzzRTAEd0
        JBh1AsAvc/gN17YPjfZt0cqPWMmvhfcidDDDy7+TC9j3vAKO9SSiVablyEyZ2YmuQqzjGi
        paDCFpbBlQdgt2CTs3dPgk2sJTA2hQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-0CE6DRn-Pp6-w9VgG4m5yg-1; Mon, 22 Feb 2021 12:43:03 -0500
X-MC-Unique: 0CE6DRn-Pp6-w9VgG4m5yg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F908195D560;
        Mon, 22 Feb 2021 17:43:00 +0000 (UTC)
Received: from gondolin (ovpn-113-115.ams2.redhat.com [10.36.113.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 931011002382;
        Mon, 22 Feb 2021 17:42:47 +0000 (UTC)
Date:   Mon, 22 Feb 2021 18:42:45 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Daniel =?UTF-8?B?QmVycmFuZ8Op?= <berrange@redhat.com>
Subject: Re: [PATCH v2 03/11] hw/core: Restrict 'query-machines' to those
 supported by current accel
Message-ID: <20210222184245.1e0d0315.cohuck@redhat.com>
In-Reply-To: <20210219173847.2054123-4-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
        <20210219173847.2054123-4-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 18:38:39 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> Do not let 'query-machines' return machines not valid with
> the current accelerator.
>=20
> Suggested-by: Daniel Berrang=C3=A9 <berrange@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  hw/core/machine-qmp-cmds.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
> index 44e979e503b..c8630bc2ddc 100644
> --- a/hw/core/machine-qmp-cmds.c
> +++ b/hw/core/machine-qmp-cmds.c
> @@ -204,6 +204,10 @@ MachineInfoList *qmp_query_machines(Error **errp)
>          MachineClass *mc =3D el->data;
>          MachineInfo *info;
> =20
> +        if (!machine_class_valid_for_current_accelerator(mc)) {
> +            continue;
> +        }
> +
>          info =3D g_malloc0(sizeof(*info));
>          if (mc->is_default) {
>              info->has_is_default =3D true;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

