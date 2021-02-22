Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F61321E12
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBVR0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:26:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhBVRZ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 12:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614014672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5mrm3DZDcM5fraUv4fndEkj6st2YNZQP0B5Q36J9Uo=;
        b=eA2hPWtNFSBChFkO1/svU5YW0B/7ijE61JlzagtOiKJapbOMVXecxssihddYHsR2e0XcVo
        ufgAUMf6r3XFMvfHYKa3zY2CkQSi0rSX7jDp56bXut8qoOGt43K1w4WzGp42MTaXV71poE
        6oMYOqYqgZRuPm22tG1Fwa5NrqWF4Es=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-1b80s02bMCOR2lkI1fzehA-1; Mon, 22 Feb 2021 12:24:29 -0500
X-MC-Unique: 1b80s02bMCOR2lkI1fzehA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498CB1936B68;
        Mon, 22 Feb 2021 17:24:26 +0000 (UTC)
Received: from gondolin (ovpn-113-115.ams2.redhat.com [10.36.113.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1AD85D9D3;
        Mon, 22 Feb 2021 17:24:07 +0000 (UTC)
Date:   Mon, 22 Feb 2021 18:24:05 +0100
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
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>
Subject: Re: [PATCH v2 01/11] accel/kvm: Check MachineClass kvm_type()
 return value
Message-ID: <20210222182405.3e6e9a6f.cohuck@redhat.com>
In-Reply-To: <20210219173847.2054123-2-philmd@redhat.com>
References: <20210219173847.2054123-1-philmd@redhat.com>
        <20210219173847.2054123-2-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 18:38:37 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> MachineClass::kvm_type() can return -1 on failure.
> Document it, and add a check in kvm_init().
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  include/hw/boards.h | 3 ++-
>  accel/kvm/kvm-all.c | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index a46dfe5d1a6..68d3d10f6b0 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -127,7 +127,8 @@ typedef struct {
>   *    implement and a stub device is required.
>   * @kvm_type:
>   *    Return the type of KVM corresponding to the kvm-type string option=
 or
> - *    computed based on other criteria such as the host kernel capabilit=
ies.
> + *    computed based on other criteria such as the host kernel capabilit=
ies
> + *    (which can't be negative), or -1 on error.
>   * @numa_mem_supported:
>   *    true if '--numa node.mem' option is supported and false otherwise
>   * @smp_parse:
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 84c943fcdb2..b069938d881 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
>                                                              "kvm-type",
>                                                              &error_abort=
);
>          type =3D mc->kvm_type(ms, kvm_type);
> +        if (type < 0) {
> +            ret =3D -EINVAL;
> +            fprintf(stderr, "Failed to detect kvm-type for machine '%s'\=
n",
> +                    mc->name);
> +            goto err;
> +        }
>      }
> =20
>      do {

No objection to this patch; but I'm wondering why some non-pseries
machines implement the kvm_type callback, when I see the kvm-type
property only for pseries? Am I holding my git grep wrong?

