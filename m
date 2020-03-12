Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC12182CEC
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgCLJ7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 05:59:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725978AbgCLJ7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 05:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584007184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfdtuMjqV4xA6TiIUXqMrT4N1Cfthn1N0mvQcwPp5tg=;
        b=C+aLhxAtAsf4ILUePfUEpS68BRkVqe4cJ6nNWpy+a0xU6ocVb08oSW96fxiGj3XliJsAuF
        T8muTK9UkycGjWF1Rvpvht8OlyLK6VuV30/EvXKI/3ODw/wszQvyOgF9cBs07z9N0FZgPk
        C/SxGjHFPlWAJamsJeldBRseV2QEC9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-t4xEsr7HMISRGINyRi2OEQ-1; Thu, 12 Mar 2020 05:59:42 -0400
X-MC-Unique: t4xEsr7HMISRGINyRi2OEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8FEEDBA3;
        Thu, 12 Mar 2020 09:59:40 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A24272A5;
        Thu, 12 Mar 2020 09:59:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
 <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
Date:   Thu, 12 Mar 2020 10:59:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/12/20 10:19 AM, Zenghui Yu wrote:
> On 2020/3/11 22:00, Marc Zyngier wrote:
>> That is still a problem with the ITS. There is no architectural way
>> to report an error, even if the error numbers are architected...
>>
>> One thing we could do though is to implement the stall model (as
>> described
>> in 5.3.2). It still doesn't give us the error, but at least the comman=
d
>> queue would stop on detecting an error.
>=20
> It would be interesting to see the buggy guest's behavior under the
> stall mode. I've used the following diff (absolutely *not* a formal
> patch, don't handle CREADR.Stalled and CWRITER.Retry at all) to have
> a try, and caught another command error in the 'its-trigger' test.
>=20
> logs/its-trigger.log:
> " INT dev_id=3D2 event_id=3D20
> lib/arm64/gic-v3-its-cmd.c:194: assert failed: false: INT timeout! "
>=20
> dmesg:
> [13297.711958] ------------[ cut here ]------------
> [13297.711964] ITS command error encoding 0x10307
>=20
> It's the last INT test in test_its_trigger() who has triggered this
> error, Eric?

Yes it may be the culprit. Anyway I removed the collection unmap in v6.

By the way are you OK now with v6? I think Drew plans to send a pull
request by the end of this week.

Thanks

Eric
>=20
>=20
> Thanks.
>=20
> ---8<---
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 9d53f545a3d5..5717f5da0f22 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -179,6 +179,7 @@ struct vgic_its {
> =C2=A0=C2=A0=C2=A0=C2=A0 u64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 cbaser;
> =C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 creadr;
> =C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 cwriter;
> +=C2=A0=C2=A0=C2=A0 bool=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 stalled;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 /* migration ABI revision in use */
> =C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 abi_rev;
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.=
c
> index d53d34a33e35..72422b75e627 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1519,6 +1519,9 @@ static void vgic_its_process_commands(struct kvm
> *kvm, struct vgic_its *its)
> =C2=A0=C2=A0=C2=A0=C2=A0 if (!its->enabled)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>=20
> +=C2=A0=C2=A0=C2=A0 if (unlikely(its->stalled))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0 cbaser =3D GITS_CBASER_ADDRESS(its->cbaser);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 while (its->cwriter !=3D its->creadr) {
> @@ -1531,9 +1534,34 @@ static void vgic_its_process_commands(struct kvm
> *kvm, struct vgic_its *its)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * According to s=
ection 6.3.2 in the GICv3 spec we can just
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ignore that co=
mmand then.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vgi=
c_its_handle_command(kvm, its, cmd_buf);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o done;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D vgic_its_handle_com=
mand(kvm, its, cmd_buf);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Choose the stall mo=
de on detection of command errors.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Guest still can't g=
et the architected error numbers though...
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* =
GITS_CREADR.Stalled is set to 1. */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 its=
->stalled =3D true;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * GITS_TYPER.SEIS is 0 atm, no System error will be
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * generated.=C2=A0 Instead report error encodings at ITS
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * level.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WAR=
N_RATELIMIT(ret, "ITS command error encoding 0x%x", ret);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * GITS_CREADR is not incremented and continues to
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * point to the entry that triggered the error.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> +done:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 its->creadr +=3D ITS_C=
MD_SIZE;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (its->creadr =3D=3D=
 ITS_CMD_BUFFER_SIZE(its->cbaser))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 its->creadr =3D 0;
>=20

