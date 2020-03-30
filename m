Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC80E197784
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgC3JL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:11:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:38803 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728080AbgC3JLz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 05:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585559514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2DCNzbDRPMtY5AnjTRXp7pP6euGDlLTuk3BX6MYjYU=;
        b=XIgl9shCPaavJGtc9Yp5n3i8xLVQzkkuC68CIqNvOcOuzdkz2/yC7awfYTAtN1VpaDvEOY
        mgzLmHHbRphz4wHjXAUxjluKFscRFp2ZBm4UmMOx0EX5wEKosk8A14ukroAZxIk9fHgvdB
        TM6+pUh2aw7oP3MtD8OUvntHT3dq8IU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-YUwdMTuWP9aQAZleaNZsXw-1; Mon, 30 Mar 2020 05:11:50 -0400
X-MC-Unique: YUwdMTuWP9aQAZleaNZsXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FFFDB83;
        Mon, 30 Mar 2020 09:11:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 340D419925;
        Mon, 30 Mar 2020 09:11:42 +0000 (UTC)
Date:   Mon, 30 Mar 2020 11:11:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 10:46:57AM +0200, Auger Eric wrote:
> Hi Zenghui,
>=20
> On 3/30/20 10:30 AM, Zenghui Yu wrote:
> > Hi Eric,
> >=20
> > On 2020/3/20 17:24, Eric Auger wrote:
> >> +static void its_cmd_queue_init(void)
> >> +{
> >> +=A0=A0=A0 unsigned long order =3D get_order(SZ_64K >> PAGE_SHIFT);
> >> +=A0=A0=A0 u64 cbaser;
> >> +
> >> +=A0=A0=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc_pages(or=
der));
> >=20
> > Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
> yes it should

If it's supposed to be a virtual address, when why do the virt_to_phys?

> >=20
> > Otherwise I think we will end-up with memory corruption when writing
> > the command queue.=A0 But it seems that everything just works fine ..=
.
> > So I'm really confused here :-/
> I was told by Paolo that the VA/PA memory map is flat in kvmunit test.

What does flat mean? kvm-unit-tests, at least arm/arm64, does prepare
an identity map of all physical memory, which explains why the above
is working. It's doing virt_to_phys(some-virt-addr), which gets a
phys addr, but when the ITS uses it as a virt addr it works because
we *also* have a virt addr =3D=3D phys addr mapping in the default page
table, which is named "idmap" for good reason.

I think it would be better to test with the non-identity mapped addresses
though.

Thanks,
drew

>=20
> >=20
> >> +
> >> +=A0=A0=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)=
=A0=A0=A0 |
> >> GITS_CBASER_VALID);
> >> +
> >> +=A0=A0=A0 writeq(cbaser, its_data.base + GITS_CBASER);
> >> +
> >> +=A0=A0=A0 its_data.cmd_write =3D its_data.cmd_base;
> >> +=A0=A0=A0 writeq(0, its_data.base + GITS_CWRITER);
> >> +}
> >=20
> > Otherwise this looks good,
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Thanks!
>=20
> Eric
> >=20
> >=20
> > Thanks
> >=20
>=20
>=20

