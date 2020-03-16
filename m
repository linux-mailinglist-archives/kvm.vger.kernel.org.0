Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A94B186730
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 09:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgCPI7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 04:59:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730110AbgCPI7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 04:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584349152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Yb6X1nf1afqu1woqOPhFH/C7hFOIBFvA8rMXchYAn8=;
        b=aHsdOfgDAN+Za8eHX7rxeICiZQU76vOaXLWIqazZ5EES2ru7nZFr5xD93C8+aKfbumNyS2
        6fRNzWEoOchz8QjiVZuQ7uM5o5dENt4W7dqjmk8K+RIVwFBwio+k/r3XhAeORT6YqftbiM
        Eq5EuLD3kCMksJnx4xzQHd1qZ+g0Q+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-EL-lcsolPh2hO--2MdBz_A-1; Mon, 16 Mar 2020 04:59:10 -0400
X-MC-Unique: EL-lcsolPh2hO--2MdBz_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E51298017CC;
        Mon, 16 Mar 2020 08:59:08 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34F9060BF3;
        Mon, 16 Mar 2020 08:58:59 +0000 (UTC)
Subject: Re: [RFC PATCH] vfio: Ignore -ENODEV when getting MSI cookie
To:     Robin Murphy <robin.murphy@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>
Cc:     iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20200312181950.60664-1-andre.przywara@arm.com>
 <c9e00735-9673-2016-b274-d5290b648a06@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1db62a9a-feb4-e717-53c7-65431fd6c6c1@redhat.com>
Date:   Mon, 16 Mar 2020 09:58:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c9e00735-9673-2016-b274-d5290b648a06@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/13/20 3:08 PM, Robin Murphy wrote:
> On 2020-03-12 6:19 pm, Andre Przywara wrote:
>> When we try to get an MSI cookie for a VFIO device, that can fail if
>> CONFIG_IOMMU_DMA is not set. In this case iommu_get_msi_cookie() retur=
ns
>> -ENODEV, and that should not be fatal.
>>
>> Ignore that case and proceed with the initialisation.
>>
>> This fixes VFIO with a platform device on the Calxeda Midway (no MSIs)=
.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Hi,
>>
>> not sure this is the right fix, or we should rather check if the
>> platform doesn't support MSIs at all (which doesn't seem to be easy
>> to do).
>> Or is this because arm-smmu.c always reserves an IOMMU_RESV_SW_MSI
>> region?
>=20
> Both, really - ideally VFIO should be able to skip all MSI_related setu=
p
> if the system doesn't support MSIs, but equally the SMMU drivers would
> also ideally not expose a pointless SW_MSI region in the same situation=
.
>=20
> In lieu of a 'nice' way of acheiving that, I think this patch seems
> reasonable - ENODEV doesn't clash with any real error that can occur
> when iommu-dma is present, and carrying on without a cookie should be
> fine since the MSI hooks that would otherwise dereference it will also
> be no-ops.

Looks OK to me as well.

About looking at whether MSI is in use I wonder whether we could do like
irq_domain_check_msi_remap() in kernel/irq/irqdomain.c without checking
IRQ_DOMAIN_FLAG_MSI_REMAP.

But if this simple patch fixes this marginal Midway vfio-platform use
case, that should be good enough.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>=20
> Perhaps it might be worth a comment to clarify that this is specificall=
y
> to allow vfio-platform to work with iommu-dma disabled, but either way,
>=20
> Acked-by: Robin Murphy <robin.murphy@arm.com>
>=20
>> Also this seems to be long broken, actually since Eric introduced MSI
>> support in 4.10-rc3, but at least since the initialisation order was
>> fixed with f6810c15cf9.
>=20
> I'm sure the entire Midway userbase have been up-in-arms the whole
> time... :P
>=20
> Robin.
>=20
>>
>> Grateful for any insight.
>>
>> Cheers,
>> Andre
>>
>> =C2=A0 drivers/vfio/vfio_iommu_type1.c | 2 +-
>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c
>> b/drivers/vfio/vfio_iommu_type1.c
>> index a177bf2c6683..467e217ef09a 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -1786,7 +1786,7 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (resv_msi) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D iommu_g=
et_msi_cookie(domain->domain, resv_msi_base);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret && ret !=3D -ENODE=
V)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out_detach;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0
>=20

