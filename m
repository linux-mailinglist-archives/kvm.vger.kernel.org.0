Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7D32D768
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 17:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhCDQHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 11:07:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236574AbhCDQHD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 11:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614873938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qY1DlRsij3cTrbhkPV5OgPfiBwcs7doGA1y8LRt1/t0=;
        b=dKy2V+R9kAFBizb9Di6FdXSbEzcsazFozefRcJ/RAYJ0wd959h6N3iTH3GzBMq7m6qlNrk
        6gNFC3GNP3RNFJSEWnbtD6KpsCgOLmvSFyzbfnO/YwGIXeNnJw4ceuBTIFROYgxoSr6gQn
        Qp+fY68OOjFEQdIALUMR0WTxQElc50E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-no-0lgYdN2q0sICV6b5Euw-1; Thu, 04 Mar 2021 11:05:36 -0500
X-MC-Unique: no-0lgYdN2q0sICV6b5Euw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B14E38030D1;
        Thu,  4 Mar 2021 16:05:33 +0000 (UTC)
Received: from gondolin (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 305F6179B3;
        Thu,  4 Mar 2021 16:05:24 +0000 (UTC)
Date:   Thu, 4 Mar 2021 17:05:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com
Subject: Re: [PATCH 02/19] target/s390x/kvm: Simplify debug code
Message-ID: <20210304170521.78c61998.cohuck@redhat.com>
In-Reply-To: <20210303182219.1631042-3-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
        <20210303182219.1631042-3-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  3 Mar 2021 19:22:02 +0100
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> We already have the 'run' variable holding 'cs->kvm_run' value.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  target/s390x/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index 7a892d663df..73f816a7222 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -1785,8 +1785,7 @@ static int handle_intercept(S390CPU *cpu)
>      int icpt_code =3D run->s390_sieic.icptcode;
>      int r =3D 0;
> =20
> -    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code,
> -            (long)cs->kvm_run->psw_addr);
> +    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code, (long)run->psw_ad=
dr);
>      switch (icpt_code) {
>          case ICPT_INSTRUCTION:
>          case ICPT_PV_INSTR:

Thanks, queued this one to s390-next.

