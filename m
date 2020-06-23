Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C612055CA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgFWPZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:25:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732781AbgFWPZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592925949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBAXVsoXXh0/I2Sku0Zs4vjlE275yD39tzwQsaS7Dok=;
        b=a3nZagn72f6P0zZqZoYWCPnFrl8K8Mk4LQ/za22lPCLjpGpvAwBgRdTp6CMZiZ4JrVHsYx
        6c+24Pzv/wNvGsz3N+ARTsZhttq/1q341+dw65t793/4leg08wTxMBl8SPSgNTEAVrrmzx
        ZAYcclAMLb+Ew57Dw2VgKhiK5bNmWTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-A9yNL1DHOtOBrK8pOcq0nA-1; Tue, 23 Jun 2020 11:25:47 -0400
X-MC-Unique: A9yNL1DHOtOBrK8pOcq0nA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0FBF107ACF2;
        Tue, 23 Jun 2020 15:25:45 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3CDB60F8D;
        Tue, 23 Jun 2020 15:25:31 +0000 (UTC)
Date:   Tue, 23 Jun 2020 17:25:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/7] accel/kvm: Let kvm_check_extension use global KVM
 state
Message-ID: <20200623172529.4ebe956c.cohuck@redhat.com>
In-Reply-To: <20200623105052.1700-2-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
        <20200623105052.1700-2-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jun 2020 12:50:46 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> As KVM supported extentions those should be the same for
> all VMs, it is safe to directly use the global kvm_state
> in kvm_check_extension().
>=20
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f24d7da783..934a7d6b24 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -913,7 +913,7 @@ int kvm_check_extension(KVMState *s, unsigned int ext=
ension)
>  {
>      int ret;
> =20
> -    ret =3D kvm_ioctl(s, KVM_CHECK_EXTENSION, extension);
> +    ret =3D kvm_ioctl(kvm_state, KVM_CHECK_EXTENSION, extension);
>      if (ret < 0) {
>          ret =3D 0;
>      }

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

