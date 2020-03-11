Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B46181427
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 10:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgCKJJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 05:09:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11661 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbgCKJJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 05:09:20 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D9CCC96868EE027D56DF;
        Wed, 11 Mar 2020 17:09:13 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 17:09:04 +0800
Subject: Re: [kvm-unit-tests PATCH v5 09/13] arm/arm64: ITS: Commands
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-10-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ad7d4011-0b8e-978d-54e7-d44cd4e34ed7@huawei.com>
Date:   Wed, 11 Mar 2020 17:09:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-10-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/10 22:54, Eric Auger wrote:
> Implement main ITS commands. The code is largely inherited from
> the ITS driver.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v3 -> v4:
> - device's itt now is a VGA
> - pass verbose to choose whether we shall print the cmd
> - use printf instead of report_info
> 
> v2 -> v3:
> - do not use report() anymore
> - assert if cmd_write exceeds the queue capacity
> 
> v1 -> v2:
> - removed its_print_cmd_state
> ---
>   arm/Makefile.arm64         |   2 +-
>   lib/arm64/asm/gic-v3-its.h |  57 +++++
>   lib/arm64/gic-v3-its-cmd.c | 463 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 521 insertions(+), 1 deletion(-)
>   create mode 100644 lib/arm64/gic-v3-its-cmd.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 60182ae..dfd0c56 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -19,7 +19,7 @@ endef
>   cstart.o = $(TEST_DIR)/cstart64.o
>   cflatobjs += lib/arm64/processor.o
>   cflatobjs += lib/arm64/spinlock.o
> -cflatobjs += lib/arm64/gic-v3-its.o
> +cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>   
>   OBJDIRS += lib/arm64
>   
> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> index 3da548b..889d6ce 100644
> --- a/lib/arm64/asm/gic-v3-its.h
> +++ b/lib/arm64/asm/gic-v3-its.h
> @@ -102,6 +102,28 @@ extern struct its_data its_data;
>   #define GITS_BASER_TYPE_DEVICE		1
>   #define GITS_BASER_TYPE_COLLECTION	4
>   
> +/*
> + * ITS commands
> + */
> +#define GITS_CMD_MAPD			0x08
> +#define GITS_CMD_MAPC			0x09
> +#define GITS_CMD_MAPTI			0x0a
> +/* older GIC documentation used MAPVI for this command */
> +#define GITS_CMD_MAPVI			GITS_CMD_MAPTI

You can drop it.

> +#define GITS_CMD_MAPI			0x0b
> +#define GITS_CMD_MOVI			0x01
> +#define GITS_CMD_DISCARD		0x0f
> +#define GITS_CMD_INV			0x0c
> +#define GITS_CMD_MOVALL			0x0e
> +#define GITS_CMD_INVALL			0x0d
> +#define GITS_CMD_INT			0x03
> +#define GITS_CMD_CLEAR			0x04
> +#define GITS_CMD_SYNC			0x05
> +
> +struct its_cmd_block {
> +	u64 raw_cmd[4];
> +};
> +
>   extern void its_parse_typer(void);
>   extern void its_init(void);
>   extern int its_baser_lookup(int i, struct its_baser *baser);
> @@ -109,4 +131,39 @@ extern void its_enable_defaults(void);
>   extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
>   extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
>   
> +extern void __its_send_mapd(struct its_device *dev, int valid, bool verbose);
> +extern void __its_send_mapc(struct its_collection *col, int valid, bool verbose);
> +extern void __its_send_mapti(struct its_device *dev, u32 irq_id, u32 event_id,
> +			     struct its_collection *col, bool verbose);
> +extern void __its_send_int(struct its_device *dev, u32 event_id, bool verbose);
> +extern void __its_send_inv(struct its_device *dev, u32 event_id, bool verbose);
> +extern void __its_send_discard(struct its_device *dev, u32 event_id, bool verbose);
> +extern void __its_send_clear(struct its_device *dev, u32 event_id, bool verbose);
> +extern void __its_send_invall(struct its_collection *col, bool verbose);
> +extern void __its_send_movi(struct its_device *dev, struct its_collection *col,
> +			    u32 id, bool verbose);
> +extern void __its_send_sync(struct its_collection *col, bool verbose);
> +
> +#define its_send_mapd(dev, valid)			__its_send_mapd(dev, valid, true)
> +#define its_send_mapc(col, valid)			__its_send_mapc(col, valid, true)
> +#define its_send_mapti(dev, irqid, eventid, col)	__its_send_mapti(dev, irqid, eventid, col, true)
> +#define its_send_int(dev, eventid)			__its_send_int(dev, eventid, true)
> +#define its_send_inv(dev, eventid)			__its_send_inv(dev, eventid, true)
> +#define its_send_discard(dev, eventid)			__its_send_discard(dev, eventid, true)
> +#define its_send_clear(dev, eventid)			__its_send_clear(dev, eventid, true)
> +#define its_send_invall(col)				__its_send_invall(col, true)
> +#define its_send_movi(dev, col, id)			__its_send_movi(dev, col, id, true)
> +#define its_send_sync(col)				__its_send_sync(col, true)
> +
> +#define its_send_mapd_nv(dev, valid)			__its_send_mapd(dev, valid, false)
> +#define its_send_mapc_nv(col, valid)			__its_send_mapc(col, valid, false)
> +#define its_send_mapti_nv(dev, irqid, eventid, col)	__its_send_mapti(dev, irqid, eventid, col, false)
> +#define its_send_int_nv(dev, eventid)			__its_send_int(dev, eventid, false)
> +#define its_send_inv_nv(dev, eventid)			__its_send_inv(dev, eventid, false)
> +#define its_send_discard_nv(dev, eventid)		__its_send_discard(dev, eventid, false)
> +#define its_send_clear_nv(dev, eventid)			__its_send_clear(dev, eventidn false)
> +#define its_send_invall_nv(col)				__its_send_invall(col, false)
> +#define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, false)
> +#define its_send_sync_nv(col)				__its_send_sync(col, false)

(not verbose? Naming is always difficult ;-).)

[...]

> +
> +static void its_build_invall_cmd(struct its_cmd_block *cmd,
> +			      struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_INVALL);
> +	its_encode_collection(cmd, desc->its_invall_cmd.col->col_id);
> +	its_fixup_cmd(cmd);
> +	if (desc->verbose)
> +		printf("INVALL col_id=%d\n", desc->its_invall_cmd.col->col_id);
> +}
> +
> +static void its_build_clear_cmd(struct its_cmd_block *cmd,
> +				struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_CLEAR);
> +	its_encode_devid(cmd, desc->its_clear_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_clear_cmd.event_id);
> +	its_fixup_cmd(cmd);
> +	if (desc->verbose)
> +		printf("CLEAR col_id=%d\n", desc->its_invall_cmd.col->col_id);

its_invall_cmd.col->col_id?

Don't you want to print the arguments (DeviceID and EventID) as you've
done for other commands?

> +}
> +
> +static void its_build_discard_cmd(struct its_cmd_block *cmd,
> +				  struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_DISCARD);
> +	its_encode_devid(cmd, desc->its_discard_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_discard_cmd.event_id);
> +	its_fixup_cmd(cmd);
> +	if (desc->verbose)
> +		printf("DISCARD col_id=%d\n", desc->its_invall_cmd.col->col_id);

The same question here.

[...]

And afaict, there's some fixes for the Linux ITS driver since the RFC
version of this series. Please have a check if you can.


Thanks,
Zenghui

