Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6E5E07B2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbfJVPo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:44:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731525AbfJVPo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 11:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIElbnd0U7wNXLmpfb9HrITNz0eKnSw8luZffmWNlKk=;
        b=f//gWxWULsX8wKW5Fj45gERYOP9WrjmFkOYSfIL5yNwNAhAIbBgTALUESoNKm6AiRmZxH5
        C+otMbcwT9FuIfFdO2RtxXtP5AvpQ/YtYnh94FIqtW771LD5Ut0fRZPGKtxjXkItKBqOAW
        VPJwqUoHLnkmg8E9zTNk3WZfq1NXY8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-ZoFcKV0lPJmqdIEWe6gj0w-1; Tue, 22 Oct 2019 11:44:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F0B1800D6A;
        Tue, 22 Oct 2019 15:44:22 +0000 (UTC)
Received: from [10.36.116.248] (ovpn-116-248.ams2.redhat.com [10.36.116.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8208F1001947;
        Tue, 22 Oct 2019 15:44:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: improve error reporting for
 interrupts
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-3-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <664db049-3715-64d3-66dc-a61d9228c515@redhat.com>
Date:   Tue, 22 Oct 2019 17:44:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1571741584-17621-3-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ZoFcKV0lPJmqdIEWe6gj0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.19 12:53, Claudio Imbrenda wrote:
> Improve error reporting for unexpected external interrupts to also
> print the received external interrupt code.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   lib/s390x/interrupt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 5cade23..1636207 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -118,8 +118,8 @@ void handle_ext_int(void)
>   {
>   =09if (!ext_int_expected &&
>   =09    lc->ext_int_code !=3D EXT_IRQ_SERVICE_SIG) {
> -=09=09report_abort("Unexpected external call interrupt: at %#lx",
> -=09=09=09     lc->ext_old_psw.addr);
> +=09=09report_abort("Unexpected external call interrupt (code %#x): at %#=
lx",
> +=09=09=09     lc->ext_int_code, lc->ext_old_psw.addr);
>   =09=09return;
>   =09}
>  =20
>=20

Reviewed-by: David Hildenbrand <david@redhat.com>

--=20

Thanks,

David / dhildenb

