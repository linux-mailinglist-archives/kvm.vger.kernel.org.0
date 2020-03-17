Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475F187B5E
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 09:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgCQIg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 04:36:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27636 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgCQIg4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 04:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584434215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2j8iTagAgwDVubh8DPg2ar7MFNgcBjiOBebGJ7tz5fg=;
        b=PFx6GMy6XUOoh/OgjH1QnxSIQ8inh6+GdnbNoc+r4imtAwZcGTq+nH7CzqpszJ626/A3u7
        We6DrxlIzmc43kQxwqdVsUwd1RP2wVExwuKF75+tm9JqWbIAUqndm+ZjyjbApVF5zrOQB2
        oLTZz79JcqeDbAy+qJ74RpgqrsFC3aM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-5LHvM1ieNRWBCv24GAwrCw-1; Tue, 17 Mar 2020 04:36:48 -0400
X-MC-Unique: 5LHvM1ieNRWBCv24GAwrCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80539800D4E;
        Tue, 17 Mar 2020 08:36:46 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CDD05C1BB;
        Tue, 17 Mar 2020 08:36:42 +0000 (UTC)
Subject: Re: [PATCH v5 09/23] irqchip/gic-v4.1: Add initial SGI configuration
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-10-maz@kernel.org>
 <4ccc36c5-1e0a-b4f6-b014-8691fdb50c84@redhat.com>
 <aed58073-0494-ee38-4d2f-287888ed8840@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d40dc34f-c5cf-1091-c20d-f2c02a906964@redhat.com>
Date:   Tue, 17 Mar 2020 09:36:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <aed58073-0494-ee38-4d2f-287888ed8840@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/17/20 3:02 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/17 1:53, Auger Eric wrote:
>> Hi Marc,
>>
>> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>>> The GICv4.1 ITS has yet another new command (VSGI) which allows
>>> a VPE-targeted SGI to be configured (or have its pending state
>>> cleared). Add support for this command and plumb it into the
>>> activate irqdomain callback so that it is ready to be used.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>>> ---
>>> =A0 drivers/irqchip/irq-gic-v3-its.c=A0=A0 | 79 +++++++++++++++++++++=
++++++++-
>>> =A0 include/linux/irqchip/arm-gic-v3.h |=A0 3 +-
>>> =A0 2 files changed, 80 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c
>>> b/drivers/irqchip/irq-gic-v3-its.c
>>> index 112b452fcb40..e0db3f906f87 100644
>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>> @@ -380,6 +380,15 @@ struct its_cmd_desc {
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct its_vpe *vpe;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 } its_invdb_cmd;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 struct {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct its_vpe *vpe;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 sgi;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 priority;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool enable;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool group;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool clear;
>>> +=A0=A0=A0=A0=A0=A0=A0 } its_vsgi_cmd;
>>> =A0=A0=A0=A0=A0 };
>>> =A0 };
>>> =A0 @@ -528,6 +537,31 @@ static void its_encode_db(struct its_cmd_blo=
ck
>>> *cmd, bool db)
>>> =A0=A0=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[2], db, 63, 63);
>>> =A0 }
>>> =A0 +static void its_encode_sgi_intid(struct its_cmd_block *cmd, u8 s=
gi)
>>> +{
>>> +=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[0], sgi, 35, 32);
>>> +}
>>> +
>>> +static void its_encode_sgi_priority(struct its_cmd_block *cmd, u8 pr=
io)
>>> +{
>>> +=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[0], prio >> 4, 23, 20);
>>> +}
>>> +
>>> +static void its_encode_sgi_group(struct its_cmd_block *cmd, bool grp=
)
>>> +{
>>> +=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[0], grp, 10, 10);
>>> +}
>>> +
>>> +static void its_encode_sgi_clear(struct its_cmd_block *cmd, bool clr=
)
>>> +{
>>> +=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[0], clr, 9, 9);
>>> +}
>>> +
>>> +static void its_encode_sgi_enable(struct its_cmd_block *cmd, bool en=
)
>>> +{
>>> +=A0=A0=A0 its_mask_encode(&cmd->raw_cmd[0], en, 8, 8);
>>> +}
>>> +
>>> =A0 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
>>> =A0 {
>>> =A0=A0=A0=A0=A0 /* Let's fixup BE commands */
>>> @@ -893,6 +927,26 @@ static struct its_vpe
>>> *its_build_invdb_cmd(struct its_node *its,
>>> =A0=A0=A0=A0=A0 return valid_vpe(its, desc->its_invdb_cmd.vpe);
>>> =A0 }
>>> =A0 +static struct its_vpe *its_build_vsgi_cmd(struct its_node *its,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stru=
ct its_cmd_block *cmd,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 stru=
ct its_cmd_desc *desc)
>>> +{
>>> +=A0=A0=A0 if (WARN_ON(!is_v4_1(its)))
>>> +=A0=A0=A0=A0=A0=A0=A0 return NULL;
>>> +
>>> +=A0=A0=A0 its_encode_cmd(cmd, GITS_CMD_VSGI);
>>> +=A0=A0=A0 its_encode_vpeid(cmd, desc->its_vsgi_cmd.vpe->vpe_id);
>>> +=A0=A0=A0 its_encode_sgi_intid(cmd, desc->its_vsgi_cmd.sgi);
>>> +=A0=A0=A0 its_encode_sgi_priority(cmd, desc->its_vsgi_cmd.priority);
>>> +=A0=A0=A0 its_encode_sgi_group(cmd, desc->its_vsgi_cmd.group);
>>> +=A0=A0=A0 its_encode_sgi_clear(cmd, desc->its_vsgi_cmd.clear);
>>> +=A0=A0=A0 its_encode_sgi_enable(cmd, desc->its_vsgi_cmd.enable);
>>> +
>>> +=A0=A0=A0 its_fixup_cmd(cmd);
>>> +
>>> +=A0=A0=A0 return valid_vpe(its, desc->its_vsgi_cmd.vpe);
>>> +}
>>> +
>>> =A0 static u64 its_cmd_ptr_to_offset(struct its_node *its,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct its_cmd=
_block *ptr)
>>> =A0 {
>>> @@ -3870,6 +3924,21 @@ static struct irq_chip its_vpe_4_1_irq_chip =3D=
 {
>>> =A0=A0=A0=A0=A0 .irq_set_vcpu_affinity=A0=A0=A0 =3D its_vpe_4_1_set_v=
cpu_affinity,
>>> =A0 };
>>> =A0 +static void its_configure_sgi(struct irq_data *d, bool clear)
>>> +{
>>> +=A0=A0=A0 struct its_vpe *vpe =3D irq_data_get_irq_chip_data(d);
>>> +=A0=A0=A0 struct its_cmd_desc desc;
>>> +
>>> +=A0=A0=A0 desc.its_vsgi_cmd.vpe =3D vpe;
>>> +=A0=A0=A0 desc.its_vsgi_cmd.sgi =3D d->hwirq;
>>> +=A0=A0=A0 desc.its_vsgi_cmd.priority =3D vpe->sgi_config[d->hwirq].p=
riority;
>>> +=A0=A0=A0 desc.its_vsgi_cmd.enable =3D vpe->sgi_config[d->hwirq].ena=
bled;
>>> +=A0=A0=A0 desc.its_vsgi_cmd.group =3D vpe->sgi_config[d->hwirq].grou=
p;
>>> +=A0=A0=A0 desc.its_vsgi_cmd.clear =3D clear;
>>> +
>>> +=A0=A0=A0 its_send_single_vcommand(find_4_1_its(), its_build_vsgi_cm=
d,
>>> &desc);
>> I see we pick up the first 4.1 ITS with find_4_1_its(). Can it happen
>> that not all of them have a mapping for that vPEID and if so we should
>> rather use one that has this mapping?
>=20
> It can't happen in GICv4.1, and you may find the answer in patch #16
> ("Eagerly vmap vPEs").=A0 I also failed to follow this logic the first
> time looking at it [*], so I think it may worth adding some comments
> on top of find_4_1_its()?
>=20
> [*]
> https://lore.kernel.org/lkml/c94061be-d029-69c8-d34f-4d21081d5aba@huawe=
i.com/

OK thank you for the pointer. Slowly moving forward ... ;-)

Eric
>=20
>=20
>>
>> The spec says:
>> The ITS controls must only be used on an ITS that has a mapping for th=
at
>> vPEID.
>> Where multiple ITSs have a mapping for the vPEID, any ITS with a mappi=
ng
>> may be used.
>>
>>> +}
>>> +
>>> =A0 static int its_sgi_set_affinity(struct irq_data *d,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct cpum=
ask *mask_val,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool force)
>>> @@ -3915,13 +3984,21 @@ static void its_sgi_irq_domain_free(struct
>>> irq_domain *domain,
>>> =A0 static int its_sgi_irq_domain_activate(struct irq_domain *domain,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct irq_data *d, bool reserve)
>>> =A0 {
>>> +=A0=A0=A0 /* Write out the initial SGI configuration */
>>> +=A0=A0=A0 its_configure_sgi(d, false);
>>> =A0=A0=A0=A0=A0 return 0;
>>> =A0 }
>>> =A0 =A0 static void its_sgi_irq_domain_deactivate(struct irq_domain *=
domain,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 struct irq_data *d)
>>> =A0 {
>>> -=A0=A0=A0 /* Nothing to do */
>>> +=A0=A0=A0 struct its_vpe *vpe =3D irq_data_get_irq_chip_data(d);
>>> +
>>> +=A0=A0=A0 /* First disable the SGI */
>>> +=A0=A0=A0 vpe->sgi_config[d->hwirq].enabled =3D false;
>>> +=A0=A0=A0 its_configure_sgi(d, false);
>>> +=A0=A0=A0 /* Now clear the potential pending bit (yes, this is clunk=
y) */
>> nit: Without carefuly reading the VSGI cmd notes, it is difficult to
>> understand why those 2 steps are needed: maybe replace this comment by
>> something like:
>> to change the config, clear must be set to false. Then clear is set an=
d
>> this leaves the config unchanged. Both steps cannot be done concurrent=
ly.
>>
>> "
>=20
> I think it makes sense.
>=20
>=20
> Thanks,
> Zenghui
>=20
>>> +=A0=A0=A0 its_configure_sgi(d, true);
>>> =A0 }
>>> =A0 =A0 static struct irq_domain_ops its_sgi_domain_ops =3D {
>>> diff --git a/include/linux/irqchip/arm-gic-v3.h
>>> b/include/linux/irqchip/arm-gic-v3.h
>>> index b28acfa71f82..fd3be49ac9a5 100644
>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>> @@ -502,8 +502,9 @@
>>> =A0 #define GITS_CMD_VMAPTI=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD=
_GICv4(GITS_CMD_MAPTI)
>>> =A0 #define GITS_CMD_VMOVI=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD_=
GICv4(GITS_CMD_MOVI)
>>> =A0 #define GITS_CMD_VSYNC=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD_=
GICv4(GITS_CMD_SYNC)
>>> -/* VMOVP and INVDB are the odd ones, as they dont have a physical
>>> counterpart */
>>> +/* VMOVP, VSGI and INVDB are the odd ones, as they dont have a
>>> physical counterpart */
>>> =A0 #define GITS_CMD_VMOVP=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD_=
GICv4(2)
>>> +#define GITS_CMD_VSGI=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD_GICv=
4(3)
>>> =A0 #define GITS_CMD_INVDB=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 GITS_CMD_=
GICv4(0xe)
>>> =A0 =A0 /*
>>>
>> Thanks
>>
>> Eric
>>
>>
>> .
>>
>=20

