Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390503FB31F
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 11:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhH3Ja2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 05:30:28 -0400
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:4726
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235073AbhH3Ja0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 05:30:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdR4ChkO7vcyWudVbgcZs6lrBvrlxi5us3bRze50Q74bDQ+nFwRspMBiZOK1noG2hPnUkNFc/kxFcrqeuNRZ2v9wvREtkbjxfFt9gseQ981wXdzaxeWNoiZqRjj2MPf8G5v48Z+d7wxwojuRfoT2mDNQGV1DYBa9ZgP3PZ4GordN0lqaGpatG+uxEwyPwC/4tyiPJJEUU8w+T6A03vEfucy4/6FBDcn2jKeukeUecbeCNR0LE/PCfmv/8mw2rdpzcGJ95kYakNqZ9dT/BJK7KU1Elj6BnFj0hasDRo8BqlgIrDqJlAicSYF+QGB6MRbt46pBIjDtZBjVqHZ/DR2ZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEl2ycz/1/25Z0dBZjFKmmyWw5JF4L3mRN6A12igN0M=;
 b=H3EryHQkS1X4l1b9gS/7ryuOHGWYJrL1PNZqeJZ4tKtAJD55QBo87zqlKESmpZVnYl5MsQkfkH5utYMtT0DHU95/UdUqNSSjTmxy5eCcfya31omFcINTDKcAUH64+zG0/rrFRCSkYrv5VMpqyf3HDj5HnWmyBSgdOcRuSOQu9gS6xbd7R7fQB3vJMSwiPY6rh6fXSP0WO/97E6bjQ433C0q4EvKBmBInRZDIhU/GtqFtHxy1pkflmZT/rsSDjdGeHG2q2s8LRBKIqRIaeVlo3UbpU7E8gTU0tNvpjFAtC34J8oLv/Ke4C2AF+o7sDkcSqCXtgKlcyTtbpz3lNMmJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEl2ycz/1/25Z0dBZjFKmmyWw5JF4L3mRN6A12igN0M=;
 b=J02TTw8h9m2EGLjcYB7yw78SkknPIz0R5GatLgYYRqJQjp43RwP82M/qVmzuhjW9+BvBWtBYoyI0Brv/VDfpRYYBAefVXzpgLR9wWtFIk7oXnziNFzmOyOMTazDSK1mz6mnSScIfwy0yEhbkLqu7N7JQFAoGUmjxg/XM0fdN70A=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB5037.eurprd04.prod.outlook.com (2603:10a6:803:57::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Mon, 30 Aug
 2021 09:29:25 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::10e6:799c:9d34:fc2d]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::10e6:799c:9d34:fc2d%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 09:29:25 +0000
Subject: Re: [PATCH 1/2] bus/fsl-mc: Add generic implementation for
 open/reset/close commands
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org
References: <20210825090538.4860-1-diana.craciun@oss.nxp.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <b0ec47ea-d32b-04bb-aea4-1c8a74bc8f99@nxp.com>
Date:   Mon, 30 Aug 2021 12:29:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210825090538.4860-1-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::33) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.108] (79.113.50.66) by AM0PR01CA0092.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Mon, 30 Aug 2021 09:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6557f365-40eb-4d98-46e5-08d96b98a87b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5037:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB50379EDA8E115BE12E1282ECECCB9@VI1PR04MB5037.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: af5dK4qXcB4lX26/KfLmSBeKOA4KLJah60yqu3tBHdMnNsWCYU1vm5S+n1rP7P7PfkiEdyWYqynB9iKH5BJndTjGZMeEuGesVQo7mr173Ikk1oMpBjthZn+GCVHBCrBDu8ZlFZFumGHqWmYmdHxU4tX6WOs6BjcQg1769pVYVWqf79/To3Sn/iwVNmyJLLEiXn2eL/hlm2KSBjPdwANnfozwAlH4Lk0hVgLITPMeiFpl/gILOxoNN3ZkFNXlcLsqumcVlhtMfbmVRbV676aUn8yf1k5uVBR0lLEGVwJepBoNq8tbRsu3aOZytyKZHFlaoS+XJ+SH52j2RzNT0QWfoqJ/L3463Aegljx/SOb0FMAZ66+CpdpSaQ6kaWDaHLYCOrlJgMjVMmiGBGlSFqiwbvXYp3idudEiGN6/M0LgBSGGjXv6RFmo13QasN827QDKuVwGjQVItvBBItt3VCYliUS6y6M4nDwbGxBm8B5j7OMHZL2Sxcb16Sr8yKIQ/Erfyv1mPqQIK+JQdZ8vUqwq3lwTv7WyUs9WE5rhwTACYjJDp/BEltzEmwjM2cNAH9Blg4gXEw9TmMy5AmJfRZpZuTbq0MK1behoxLrTDXKEzkCjfyJEuMuSvYvI+p7lSV0nea9r4s53UpjC79Q7iFkgdBjH4zqciPfC9nIrXFKegtfeVjBQZfFoCm8NA+bd8rYfXIOdNNfASkMIOa0pqexM/onZEa1XA6+5FrHArcagE6czOVY6Qh5kfeKPU8cbP4n6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(2906002)(2616005)(86362001)(110136005)(52116002)(44832011)(38100700002)(83380400001)(66476007)(6486002)(31696002)(316002)(16576012)(36756003)(66946007)(5660300002)(26005)(8676002)(53546011)(478600001)(31686004)(66556008)(38350700002)(956004)(4326008)(186003)(8936002)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUdSZllRUGtiSGVxWlR3NklzRFc4V1lXaE9Va0pDQTFMYytwVXloNDc3Q0tq?=
 =?utf-8?B?V25ianBNSUpMaVdiUzN4SElGTmRaOE1nVjJjUlhpMmMrdStjRTVOUVIvRnNU?=
 =?utf-8?B?eklTYnRsRlU0R2hsbS9jVG40enVXU08vSFR5SERJRmVjZ2NDTXQyVDd0NU5r?=
 =?utf-8?B?UkpUZEJ5VVVvQVRuRDRoRER3RzlOQ1NTMTFOOXY3WThMQVBOaHBxMjJPNk5h?=
 =?utf-8?B?RUxwWlNKR0dkQzIyV1R5ekVQZ0NRQkJZY2VISEtYNUI0Ti9VcCtVTVhtbTd0?=
 =?utf-8?B?NjJpMzZlY3VVQmplQWtKby81T2VsbDZtc2l6emVuL243SXZpQ2FROVVLekFS?=
 =?utf-8?B?V1k5RThoUTh3bUdZek1xT2dEY3VoL1Jva2RqVXdSdnFXMlhSL2NUdXY3OGh6?=
 =?utf-8?B?RURmdUR2NGs5cHcxdGRoUnlKWGt4OHhYTExLbmV6MGpOTDZ3dVJRTDBEUk0w?=
 =?utf-8?B?Mm5ka2wvcDNWRW5WbVUvUzBucU43WkJzV0J1aWFRcDhicmx5WVpHUUxSZjlr?=
 =?utf-8?B?YmdLR2x1ZUxKMCtyZjB0Y2lrRmNhYVI4UWt3bTdrdFE1T1dkTFliSHFkWTFY?=
 =?utf-8?B?RjI0K2hKdnR6aFd4K3RYTDBvNVdTdGRrbThsM0hUUWMwTkhJZENSRUFSeUhI?=
 =?utf-8?B?QWFLMVhUYmxJS0UrZnJ2cDdmMTR1WFJhRWI2aXA3Q1ZoTzF0cUFvVzlwMzRq?=
 =?utf-8?B?bGxVdDY1bXdqVUJreERGRkdmeEt1dU5xZHZGVXBPNzkzNUlpbkIxWWw4b0pH?=
 =?utf-8?B?emMyYW82VjFuR3BZeE9IOWMrblhhWjZkRjVlUHErNTF4bnB1WE1wWCtXNit2?=
 =?utf-8?B?VGFITHIzR0ErK0lzQnRDZDg3NGY0c1lCdDhqdHNrUDNNdGorYnA0TXN1azh4?=
 =?utf-8?B?T283bHloVzVlYm5oS25DMGxMOW9kY0RQa2drNk9PQW45VkR6M2xmUTJmSWZG?=
 =?utf-8?B?RmFuMmoxOE51M0hMQ2dxalI2MjJENVNBdmFKdWRJMkVlandFZi92VG9tYnFU?=
 =?utf-8?B?SUppUklYdWtIemJ3VitVYjEvZmZPekpFN1dEK2w5VVZlSmFGRTcvcTk0NVNH?=
 =?utf-8?B?NUxhanJLcW9GeGNXVkF5L1I0N2FPbW9tOVBEbmJaMjNDeHg1ZE9pTGhCR0dh?=
 =?utf-8?B?NWkxR2FYSzREbWlmWWR4QXlJM0M3ZE1iVUlSay9Ed1ZqdERIMFhWLzgwU2pJ?=
 =?utf-8?B?cXZYVUFqNXJwSzB2MUdtZUlZQnJJTU5hZmFKRGpqOGMyWVFDOU95aXZZYXE3?=
 =?utf-8?B?WEZZTkZMSDFMV202bWsvQ0xZWjJXQ0lwckdJQ1R2djlmYUxoYm5kZDJnUFdK?=
 =?utf-8?B?UHE0cEVvQlNnbmprYk4rLzA0ZUhZOFhkQlltL1pPUWkvMFNtWUJ6dHNVR0E4?=
 =?utf-8?B?SkJ4OTNJeFpBenRxUlkreVNGNjYvY0RrbEx1WEFCN2Fzb0w3RmJmRkUzNmxa?=
 =?utf-8?B?RndlZWlQZG4vTE1CMnh3Zi95UTl0VEl4TFF3V1p3UG9kTHFPaGlOK1NXUHlX?=
 =?utf-8?B?V0NLZ09OZmVqZmgvSURuRjRGSnZiNkJ2aGY4cDlZR05FWWxFcUtLMUZqY2JG?=
 =?utf-8?B?RFNIb3lCRzAvT1NXV2cvTzN1WnpPOHMrbmtnb3VmUitLcTRncGVwMGJmRTJT?=
 =?utf-8?B?SVk0V0Z4dnBxbzl4WHBOWVFBUWJUOWh6dWFzUTB5SUl5SmNIeHRRL29WaXIv?=
 =?utf-8?B?aGFjRUd0RGlUYmlKbGswbWJhYU1VMjI3aUJjSnVFODJJNk42R3R2dWhlVnRT?=
 =?utf-8?Q?Z6aa6d5HGexdX6u0GCCe/MeXuipCjnLF9yVy8gU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6557f365-40eb-4d98-46e5-08d96b98a87b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 09:29:25.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47cpeDsF5kwWGZpDFo1AR2vtLM8gXwvHAX7XFsVyzEtyk+VbtWrilH1fZy0hzfLoPj1CViQXRQfaRlTv1deAEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/2021 12:05 PM, Diana Craciun wrote:
> The open/reset/close commands format is similar for all objects.
> Currently there are multiple implementations for these commands
> scattered through various drivers. The code is cavsi-identical.
> Create a generic implementation for the open/reset/close commands.
> One of the consumer will be the VFIO driver which needs to
> be able to reset a device.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/bus/fsl-mc/Makefile         |   3 +-
>  drivers/bus/fsl-mc/fsl-mc-private.h |  39 +++++++++--
>  drivers/bus/fsl-mc/obj-api.c        | 104 ++++++++++++++++++++++++++++
>  include/linux/fsl/mc.h              |  14 ++++
>  4 files changed, 155 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/bus/fsl-mc/obj-api.c
> 
> diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
> index 4ae292a30e53..892946245527 100644
> --- a/drivers/bus/fsl-mc/Makefile
> +++ b/drivers/bus/fsl-mc/Makefile
> @@ -15,7 +15,8 @@ mc-bus-driver-objs := fsl-mc-bus.o \
>  		      dprc-driver.o \
>  		      fsl-mc-allocator.o \
>  		      fsl-mc-msi.o \
> -		      dpmcp.o
> +		      dpmcp.o \
> +		      obj-api.o
>  
>  # MC userspace support
>  obj-$(CONFIG_FSL_MC_UAPI_SUPPORT) += fsl-mc-uapi.o
> diff --git a/drivers/bus/fsl-mc/fsl-mc-private.h b/drivers/bus/fsl-mc/fsl-mc-private.h
> index 1958fa065360..6055ef3e9e02 100644
> --- a/drivers/bus/fsl-mc/fsl-mc-private.h
> +++ b/drivers/bus/fsl-mc/fsl-mc-private.h
> @@ -48,7 +48,6 @@ struct dpmng_rsp_get_version {
>  
>  /* DPMCP command IDs */
>  #define DPMCP_CMDID_CLOSE		DPMCP_CMD(0x800)
> -#define DPMCP_CMDID_OPEN		DPMCP_CMD(0x80b)
>  #define DPMCP_CMDID_RESET		DPMCP_CMD(0x005)
>  
>  struct dpmcp_cmd_open {
> @@ -91,7 +90,6 @@ int dpmcp_reset(struct fsl_mc_io *mc_io,
>  
>  /* DPRC command IDs */
>  #define DPRC_CMDID_CLOSE                        DPRC_CMD(0x800)
> -#define DPRC_CMDID_OPEN                         DPRC_CMD(0x805)
>  #define DPRC_CMDID_GET_API_VERSION              DPRC_CMD(0xa05)
>  
>  #define DPRC_CMDID_GET_ATTR                     DPRC_CMD(0x004)
> @@ -453,7 +451,6 @@ int dprc_get_connection(struct fsl_mc_io *mc_io,
>  
>  /* Command IDs */
>  #define DPBP_CMDID_CLOSE		DPBP_CMD(0x800)
> -#define DPBP_CMDID_OPEN			DPBP_CMD(0x804)
>  
>  #define DPBP_CMDID_ENABLE		DPBP_CMD(0x002)
>  #define DPBP_CMDID_DISABLE		DPBP_CMD(0x003)
> @@ -492,7 +489,6 @@ struct dpbp_rsp_get_attributes {
>  
>  /* Command IDs */
>  #define DPCON_CMDID_CLOSE			DPCON_CMD(0x800)
> -#define DPCON_CMDID_OPEN			DPCON_CMD(0x808)
>  
>  #define DPCON_CMDID_ENABLE			DPCON_CMD(0x002)
>  #define DPCON_CMDID_DISABLE			DPCON_CMD(0x003)
> @@ -524,6 +520,41 @@ struct dpcon_cmd_set_notification {
>  	__le64 user_ctx;
>  };
>  
> +/*
> + * Generic FSL MC API
> + */
> +
> +/* generic command versioning */
> +#define OBJ_CMD_BASE_VERSION		1
> +#define OBJ_CMD_ID_OFFSET		4
> +
> +#define OBJ_CMD(id)	(((id) << OBJ_CMD_ID_OFFSET) | OBJ_CMD_BASE_VERSION)
> +
> +/* open command codes */
> +#define DPRTC_CMDID_OPEN		OBJ_CMD(0x810)
> +#define DPNI_CMDID_OPEN		OBJ_CMD(0x801)
> +#define DPSW_CMDID_OPEN		OBJ_CMD(0x802)
> +#define DPIO_CMDID_OPEN		OBJ_CMD(0x803)
> +#define DPBP_CMDID_OPEN		OBJ_CMD(0x804)
> +#define DPRC_CMDID_OPEN		OBJ_CMD(0x805)
> +#define DPDMUX_CMDID_OPEN		OBJ_CMD(0x806)
> +#define DPCI_CMDID_OPEN		OBJ_CMD(0x807)
> +#define DPCON_CMDID_OPEN		OBJ_CMD(0x808)
> +#define DPSECI_CMDID_OPEN		OBJ_CMD(0x809)
> +#define DPAIOP_CMDID_OPEN		OBJ_CMD(0x80a)
> +#define DPMCP_CMDID_OPEN		OBJ_CMD(0x80b)
> +#define DPMAC_CMDID_OPEN		OBJ_CMD(0x80c)
> +#define DPDCEI_CMDID_OPEN		OBJ_CMD(0x80d)
> +#define DPDMAI_CMDID_OPEN		OBJ_CMD(0x80e)
> +#define DPDBG_CMDID_OPEN		OBJ_CMD(0x80f)
> +
> +/* Generic object command IDs */
> +#define OBJ_CMDID_CLOSE		OBJ_CMD(0x800)
> +#define OBJ_CMDID_RESET		OBJ_CMD(0x005)
> +
> +struct obj_cmd_open {

Nit: maybe the name should be made less generic, e.g. fsl_mc_obj_cmd_open.

Otherwise, looks good to me:

Reviewed-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

---
Best Regards, Laurentiu
