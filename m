Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE78C1976E5
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 10:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgC3IrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 04:47:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:53024 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729422AbgC3IrK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 04:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585558029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3toyHtdmIDsvhTBATPytSTJjTPkQkswWc1NSEnUkCA=;
        b=LTkVOMWBQRhpPmr+aAo23tg0yHahoUOyYTuWNPb/7yfuw5n66o/d2Ex8bF14OSGznhTSOO
        ZOAdv5IPHsbVNyPJQ+ITOtaJMDbTKBGPab536hEQ9X8Qwr0UY2UPSKUD52+at9v7focON8
        o+tgiIq6JmLDH5AiVthFIDCHgRG363A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-PV9z_La-NdqheXia0TXc2w-1; Mon, 30 Mar 2020 04:47:05 -0400
X-MC-Unique: PV9z_La-NdqheXia0TXc2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 427BD1937FC0;
        Mon, 30 Mar 2020 08:47:04 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C33CE19925;
        Mon, 30 Mar 2020 08:46:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andre.przywara@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
Date:   Mon, 30 Mar 2020 10:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/30/20 10:30 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/20 17:24, Eric Auger wrote:
>> +static void its_cmd_queue_init(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D get_order(SZ_64K >> PAGE_S=
HIFT);
>> +=C2=A0=C2=A0=C2=A0 u64 cbaser;
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc_p=
ages(order));
>=20
> Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
yes it should
>=20
> Otherwise I think we will end-up with memory corruption when writing
> the command queue.=C2=A0 But it seems that everything just works fine .=
..
> So I'm really confused here :-/
I was told by Paolo that the VA/PA memory map is flat in kvmunit test.

>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / SZ_=
4K - 1)=C2=A0=C2=A0=C2=A0 |
>> GITS_CBASER_VALID);
>> +
>> +=C2=A0=C2=A0=C2=A0 writeq(cbaser, its_data.base + GITS_CBASER);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_write =3D its_data.cmd_base;
>> +=C2=A0=C2=A0=C2=A0 writeq(0, its_data.base + GITS_CWRITER);
>> +}
>=20
> Otherwise this looks good,
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Thanks!

Eric
>=20
>=20
> Thanks
>=20

