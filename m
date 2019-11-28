Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2638810CC3F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfK1P52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:57:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbfK1P52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 10:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574956647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NW048hDnyp9fl4jwyHIoarId6mDI31NPs3Sf5FRFpWk=;
        b=PkueMPeRE4cHAVRSs87TGRjgq/jNhbFYJY/CPwBXwXOjX5y1xVZeY8ZtQVnrWbg1IlMiSl
        yMT4N2pYXOC082/rW+VJP+u6/MSHT1n8JrvU5ebvDrzYJVyBA2rz1Ix5mQj0oQoA/ZtWe2
        xEAe6ZLwFfNzBDNnmkHIpbBxUPrjpiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-5h1lpMfWOkGJOk2r2DQJwQ-1; Thu, 28 Nov 2019 10:57:24 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFCF580253C;
        Thu, 28 Nov 2019 15:57:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E75395C1B0;
        Thu, 28 Nov 2019 15:57:21 +0000 (UTC)
Date:   Thu, 28 Nov 2019 16:57:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: PL031: Fix check_rtc_irq
Message-ID: <20191128155719.xqk6xjx6jbpy6ptv@kamzik.brq.redhat.com>
References: <20191128155515.19013-1-drjones@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191128155515.19013-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 5h1lpMfWOkGJOk2r2DQJwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 04:55:15PM +0100, Andrew Jones wrote:
> Since QEMU commit 83ad95957c7e ("pl031: Expose RTCICR as proper WC
> register") the PL031 test gets into an infinite loop. Now we must
> write bit zero of RTCICR to clear the IRQ status. Before, writing
> anything to RTCICR would work. As '1' is a member of 'anything'
> writing it should work for old QEMU as well.
>=20
> Cc: Alexander Graf <graf@amazon.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/pl031.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Note, this is based on not yet merged "Switch the order of the
parameters in report() and report_xfail()".

>=20
> diff --git a/arm/pl031.c b/arm/pl031.c
> index 1f63ef13994f..3b75fd653e96 100644
> --- a/arm/pl031.c
> +++ b/arm/pl031.c
> @@ -143,8 +143,8 @@ static void irq_handler(struct pt_regs *regs)
>  =09=09report(readl(&pl031->ris) =3D=3D 1, "  RTC RIS =3D=3D 1");
>  =09=09report(readl(&pl031->mis) =3D=3D 1, "  RTC MIS =3D=3D 1");
> =20
> -=09=09/* Writing any value should clear IRQ status */
> -=09=09writel(0x80000000ULL, &pl031->icr);
> +=09=09/* Writing one to bit zero should clear IRQ status */
> +=09=09writel(1, &pl031->icr);
> =20
>  =09=09report(readl(&pl031->ris) =3D=3D 0, "  RTC RIS =3D=3D 0");
>  =09=09report(readl(&pl031->mis) =3D=3D 0, "  RTC MIS =3D=3D 0");
> --=20
> 2.21.0
>=20

