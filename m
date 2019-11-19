Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024D0102537
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 14:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSNOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 08:14:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSNOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 08:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574169272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YB6gU8ikEiFDx2DKIh68eFdrenBuxJ2OWegwg4khmKQ=;
        b=dVrIXknB3zoe5aEpm8YkSzYgsdcPvDf2NNuCWAsQN1Zm6OfxBFSXw6QL8ZFrv2vA+JtVNZ
        J8RQ+5dG9UJhL11AtBJoAVP44DEXQdrbCpnUu0hAOJ6HmjVjaAs3yGzuYk4PcKiAAWcZhd
        480s/fsJ2SclzAprl2yzu57R+ZTDPf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-5k06wjbOPZi9HSHULPInFg-1; Tue, 19 Nov 2019 08:14:27 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6E20800686;
        Tue, 19 Nov 2019 13:14:26 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-181.ams2.redhat.com [10.36.117.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C563E2935B;
        Tue, 19 Nov 2019 13:14:22 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 1/3] s390x: export sclp_setup_int
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
 <1574157219-22052-2-git-send-email-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <5ddea0bc-df5a-6af6-a7b4-494565ea0005@redhat.com>
Date:   Tue, 19 Nov 2019 14:14:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1574157219-22052-2-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 5k06wjbOPZi9HSHULPInFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/2019 10.53, Claudio Imbrenda wrote:
> Export sclp_setup_int() so that it can be used from outside.
>=20
> Needed for an upocoming unit test.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 1 +
>  lib/s390x/sclp.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 6d40fb7..675f07e 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -265,6 +265,7 @@ typedef struct ReadEventData {
>  } __attribute__((packed)) ReadEventData;
> =20
>  extern char _sccb[];
> +void sclp_setup_int(void);
>  void sclp_handle_ext(void);
>  void sclp_wait_busy(void);
>  void sclp_mark_busy(void);
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 7798f04..123b639 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -45,7 +45,7 @@ static void mem_init(phys_addr_t mem_end)
>  =09page_alloc_ops_enable();
>  }
> =20
> -static void sclp_setup_int(void)
> +void sclp_setup_int(void)
>  {
>  =09uint64_t mask;

Reviewed-by: Thomas Huth <thuth@redhat.com>

