Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2265ECA3B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 22:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKAV0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 17:26:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727079AbfKAV0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 17:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572643603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vc9DkpMujQuhpCve3Y34f4TSvB+W8OlWdKhsXSlhGW0=;
        b=VZtq4Z7EDvydN/7C8E+ikm70ccdYigRNm7X8lfiqJ5EoJ9FIhyp5Qqah9+JTvN7e5dMwSB
        /y/3HrUDDJVTcRbB8gLMQHHoMhNebAfh7AoPb7GkHDy5YnkVFsXaEYPeNsaD0JqNMzI5Ts
        PfDkbKdMKHwRjlsd9Kc5z3LzV2wjK6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-GsvX0Ji3MkOSgzBUAc1JGg-1; Fri, 01 Nov 2019 17:26:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 021E2800D49;
        Fri,  1 Nov 2019 21:26:40 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCE7F5D9E2;
        Fri,  1 Nov 2019 21:26:37 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 9FBD910517E;
        Fri,  1 Nov 2019 19:26:19 -0200 (BRST)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id xA1LQFgl020794;
        Fri, 1 Nov 2019 19:26:15 -0200
Date:   Fri, 1 Nov 2019 19:26:15 -0200
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH 5/5] cpuidle-haltpoll: fix up the branch check
Message-ID: <20191101212613.GB20672@amt.cnet>
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-6-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1572060239-17401-6-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: GsvX0Ji3MkOSgzBUAc1JGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 26, 2019 at 11:23:59AM +0800, Zhenzhong Duan wrote:
> Ensure pool time is longer than block_ns, so there is a margin to
> avoid vCPU get into block state unnecessorily.
>=20
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  drivers/cpuidle/governors/haltpoll.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/gover=
nors/haltpoll.c
> index 4b00d7a..59eadaf 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -81,9 +81,9 @@ static void adjust_poll_limit(struct cpuidle_device *de=
v, unsigned int block_us)
>  =09u64 block_ns =3D block_us*NSEC_PER_USEC;
> =20
>  =09/* Grow cpu_halt_poll_us if
> -=09 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
> +=09 * cpu_halt_poll_us <=3D block_ns < guest_halt_poll_us
>  =09 */
> -=09if (block_ns > dev->poll_limit_ns && block_ns <=3D guest_halt_poll_ns=
) {
> +=09if (block_ns >=3D dev->poll_limit_ns && block_ns < guest_halt_poll_ns=
) {
=09=09=09=09=09      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If block_ns =3D=3D guest_halt_poll_ns, you won't allow dev->poll_limit_ns t=
o
grow. Why is that?

> @@ -101,7 +101,7 @@ static void adjust_poll_limit(struct cpuidle_device *=
dev, unsigned int block_us)
>  =09=09=09val =3D guest_halt_poll_ns;
> =20
>  =09=09dev->poll_limit_ns =3D val;
> -=09} else if (block_ns > guest_halt_poll_ns &&
> +=09} else if (block_ns >=3D guest_halt_poll_ns &&
>  =09=09   guest_halt_poll_allow_shrink) {
>  =09=09unsigned int shrink =3D guest_halt_poll_shrink;

And here you shrink if block_ns =3D=3D guest_halt_poll_ns. Not sure
why that makes sense either.

