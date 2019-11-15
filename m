Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD5AFDC2F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKOLXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:23:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfKOLXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573816995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i4U6G7gq5Wpr6N1E0YyeWg0t9lCtvTfJibMmZ9/36dA=;
        b=dfBUBsB1445jNeBELV8Xd5XHSo+P0PN6nABWB7DzIihTRZUZ6JSulcJU+Qjar1w0qtp4LR
        aBXKldttJh0X70sogMkIossFtIePjJJZENZbr0fFpGuKU35H2rNVwhM6DsaTSf6E494tPN
        m5EzEY+9d9FMYlOwkxAfbU8t7Ib/YzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-FsMZtrpsOASB7mg6kaa6zQ-1; Fri, 15 Nov 2019 06:23:12 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F329107ACC5;
        Fri, 15 Nov 2019 11:23:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E56A1BC6E;
        Fri, 15 Nov 2019 11:23:06 +0000 (UTC)
Subject: Re: [RFC 35/37] KVM: s390: Fix cpu reset local IRQ clearing
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-36-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6128cef9-5780-a5dd-68a1-62d7cfeaf05a@redhat.com>
Date:   Fri, 15 Nov 2019 12:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-36-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: FsMZtrpsOASB7mg6kaa6zQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that.
>=20
> Now that we have a new interface, let's properly clear out local IRQs
> and let this commit be a reminder.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ba6144fdb5d1..cc5feb67f145 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3485,6 +3485,8 @@ static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcp=
u *vcpu,
>  =09=09 * non-protected case.
>  =09=09 */
>  =09=09rc =3D 0;
> +=09=09kvm_clear_async_pf_completion_queue(vcpu);
> +=09=09kvm_s390_clear_local_irqs(vcpu);
>  =09=09if (kvm_s390_pv_handle_cpu(vcpu)) {
>  =09=09=09rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
>  =09=09=09=09=09   UVC_CMD_CPU_RESET, &ret);
>=20

I think you could squash this into patch 33/37 where you've introduced
the RESET_NORMAL (and adjust the patch description there).

 Thomas

