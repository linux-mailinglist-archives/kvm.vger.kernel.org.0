Return-Path: <kvm+bounces-3889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6538098DE
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B7F81F21311
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 01:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74A01C10;
	Fri,  8 Dec 2023 01:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pSZBbTWQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C0D173C;
	Thu,  7 Dec 2023 17:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEcWlpKnR3o5DieMPSPqCkXKKSOvTBuPfwafz3svnG36qDswNBFnNgjgO8ovtiQaMJGIKptHOLhjGEoVHv0rMpUsGP9phzrqC+BPfTptLmrect5YZvumuvlnc8T43tsCCnP/DaXk9OIFIOit4T4cBD/XyTFg++k/wJydw/0rihXQTg8Tvb4Lw6ZKld22wivUM1qczxXQy+2gPcwjd1ZSnIQ5qk4SsCu+5IJNhyo96jI9gVIV/yyK03BksdHotojLotLqPk/wsQwg6pnTCCtPx+kejw6EhEQEnFqOZPBRoclViZ4osjL4ZjskCI1cbmGxt5X9WV/wBAW24PAn8n7DeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbAF+p8rVQBPmcfTbpY5StoXDA7vAGdVTNg5uY2cYGE=;
 b=R1mJclEa7zTws3eQD32YjdsqGGBuP/3i6WyYpgNssVhYcA3owL0UUyKuNp4XtBQF80xskar4Wi2RyDsJiBwY+YlV384LaouAsO/p0qBuJEzPgTs2JVB96u2C90qW8RDf0ME4CutA7EBdIu6dCzNTAAr4jP3TLEAQwOK9xV3XUH8ibd7VmkJYDQM9opily0h4zxZtzRZiFHwlLe+PjpMsYUABS6rVbj9RewldIR8Qu1/3Yhka8vHtKaMlKCeaCjXb7Sb9+3xZ6D9eAp7bJGqNZa+KBNqV9938C0/MP7WBc4wiFMGZUn8PQ9unY/gK7ZXjHrZjqFU+JHWTbcMr4UtFbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbAF+p8rVQBPmcfTbpY5StoXDA7vAGdVTNg5uY2cYGE=;
 b=pSZBbTWQOqxdtQEm6V9VznCTJM7s15hiDlRV0CM+NMZ9fgbmZeyQzg7bK8MsR4mGHLbadpNAljZ2NhT83Sv+WFUBvypQoYn1JPhI0PK3B1fA7ky056HQHV5o2Xm6/m7jVaotAKZOtoPmeCCTLBQOYGFdksYGGrpyH2pRV/KYpmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Fri, 8 Dec
 2023 01:53:42 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615%5]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 01:53:42 +0000
Message-ID: <91266021-20db-267e-2ccf-023627ba1569@amd.com>
Date: Thu, 7 Dec 2023 17:53:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH iwl-next v4 05/12] ice: Log virtual channel messages in PF
Content-Language: en-US
To: Yahui Cao <yahui.cao@intel.com>, intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
 kevin.tian@intel.com, madhu.chittim@intel.com, sridhar.samudrala@intel.com,
 alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-6-yahui.cao@intel.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231121025111.257597-6-yahui.cao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:40::35) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f24a24c-0ef5-4b5d-d5ed-08dbf7908132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C1RtPCrJPN7GuKFFfxVPB5SfJv3i71Ehbn50IeOuTE3TqqPiSOH/Pvvo+rgMTcdBgDWbGqJM5uvYFhQth5qR+c2Q+TUhZOKwR/BYP9rmtA0nkVKgMlq4rwE1VI/rN8URrdWgnDFkYm9ESnKH4IlbyXHVV2QChzSl9zwsw78mcc4pTwQ+4DIUc23xeWdm8IFUWrgFTRFRiczYVSAZKMDhpWV0oLjw6VIvRCJOh2f6ruzrHvpuzGO80BWpbZ5e7uBeLg3MmuUuHLTrBhcVQYhcmG7r4MysbcWr++abvO+b5WXt51GgQ1NSiPvYUboxA0bdgwqqfZsqQL4pGMN9hSmkoB4ATkORxLK4tmjpL259s4w+/1LpFpioNPG+KKX8Qd9xeGZpHgisMfPxrcY7GyMWtnHUjG8Uf/iCRlj57ALaDPeqFCDIfj5zGae6VvAA9FRpDmpdUiuss4rcuyU6rtHru7EiPaBzre2zzagcED0tkpFEH84LIAuZFJTNNdz5zqCI88ZJzYUItqq6btbM2AIStySFv63QOs2Ujg6GmZEohUMUzkPc6nOK6/dzkB4DrBRIJDgfpMC8gYuSWj0vJAVyQ1jzRG1seIeU5r1DdYVQY1PWmSVX4AfMH8nC/AsMr5FoT1E+XkgNZBYWULDXNm7P4tzm3WPkJsB7SLnSTR4/NWYZOSLfNjOKWzUbSEj6w8QJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(230273577357003)(230173577357003)(451199024)(186009)(1800799012)(64100799003)(8676002)(8936002)(4326008)(66556008)(316002)(66476007)(66946007)(38100700002)(41300700001)(31696002)(36756003)(5660300002)(15650500001)(6512007)(7416002)(30864003)(2616005)(26005)(2906002)(83380400001)(478600001)(6486002)(6506007)(6666004)(53546011)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkNDWS9PcmxpaXFuTjJHT3lLVjBuN0pLSENPdEMwcDFlSlFoOXNsSW1JWmVC?=
 =?utf-8?B?bGlISUhkdi9EL0NmK25VZ2NGd0ZYdTIzZXlPQVpyYTQrNm5NdUpZanhlZ1lD?=
 =?utf-8?B?RzB2dmtCQmFWaDIwSTBWRE5MR1lucUpCeDNFQStYRWFBRURtNFhib3ovVEth?=
 =?utf-8?B?K2sxMVRFVVkxbTBBaGlLREtNVlU2V2hqWDhLbjdac3NYdVJxbzhrdzU3eU1C?=
 =?utf-8?B?U28vczVZa3JpdlBtMUFQSFJnbDlHejJVUjIzT3VLSldhZTJjb2JpMGJBVzBP?=
 =?utf-8?B?TDlTWXVjclg0SW14RU14Qlo1QXVQK2EybHExTTJ4N01HTFRpZnJNWEVxU0Vp?=
 =?utf-8?B?QU8rdVA2Y0xyaEhOVjNISVZvU1pKL2ZOWko5Y0xDSUkweS9wWTJsUFVoNHJP?=
 =?utf-8?B?aFk1ekM0a3VTc3p0K2xKNkJueHltRVliMjRKbjJvSnRDS0FtRWJJa0txR2lW?=
 =?utf-8?B?VDRLYmwwTG44Q1A0NEdIMmErRjN3M2RsemtNcXlvWFFUKzhZNUJjdVRuZnZL?=
 =?utf-8?B?OFRsS2F6dW40b3VJZFNBM1VTMmtOaWNxeTQyVDlpWXFHMGU0NE5pSkd6S0o5?=
 =?utf-8?B?bFVUSEx4dUF2YzRYK1pKWWlVTDI5NHh5UHhxc0RPTDNBTG9KdEJzWHZWQTFr?=
 =?utf-8?B?TktScUZsc2RYQjhzcmdhUUtVbmZkcUpXYnB5RU40ZEo5SXJXUWJlR2VZNGRp?=
 =?utf-8?B?TjJELzd1UytMQTUvRlh6MzBvaXBSSzYzaTVOUUwzenhNbnVZWXRnMG0yaXFE?=
 =?utf-8?B?SUMyMTBoM3RYVzU2MU51Z2RrNnNuYVhoaE41VnB6aUVpblNicEUxdFVYZ0d5?=
 =?utf-8?B?VitPRTh1OVQ4SERUdmpacXBqbEJKQWhXY3FnbEZJQlY5K2NHdmxERVBET3l0?=
 =?utf-8?B?Y1JjU2JlTXl3OGMvSkd3cHMwWWlIK3hsMkNRTEVKZkxzeUV2SVJVbTB1RXNi?=
 =?utf-8?B?SXNuRSs0UDdBeG1GQ25GNDg0QVp1VUNYYzF5VTFBdk9IMEt5OGRDVTJnMzJK?=
 =?utf-8?B?VmJ2ZXdYSmp4d3I5aFUxMGpVYTY2L20xVmVDVE51RUNwMUQzbkpWTkNEMDJn?=
 =?utf-8?B?NmkzMWZVYmxabXRwbUMyTmxDS1l1WmMvVStNNTcwUHF1VlEwUktPYlNHbEFP?=
 =?utf-8?B?cnFMdUhXYlhGQUJkYzc1bWFuM0l1WHNBTlJXZm45RGNWZTBhMGlSaFZyb1dv?=
 =?utf-8?B?d3gyTllZVHp6UEJRU3VXb0l2RlR3OHJBcndEeUZkM3lPNGwwWGVYc0RpQUZv?=
 =?utf-8?B?b2lZdzM4azJ4VU5ScWNLZDBMdXlVWXRvbTVnNlVIYzNRQWdMUDQzWno5dWtr?=
 =?utf-8?B?WENMK2VjMnVuMkFqUU1aTE5aNm53NnJYakZKZkdXaU5kL2RJUFYrd0xNUk04?=
 =?utf-8?B?bXhJOEw5bkF6aTVWMzJiRVpRVk9aZTlrcHg2cENENHBhbS9BQk9xbUcvVHdC?=
 =?utf-8?B?ZVBESkpzTkxpVEZlNzRxR1JUZmR0aWtpSXZLYndla2Y3ekQva0VnK2VIK1dZ?=
 =?utf-8?B?WWsvZWY0RXBLL0h6eEM3Sk1OZm9LQUJ6YUJ3UG9sVDJKRlU3UVhFT0dDZ3Z3?=
 =?utf-8?B?THVxWWVIbmJWbWZIbVJabFZDN0dBbUVqY0YzbEZ6aWN0U0VjWEVXLzlvT2I2?=
 =?utf-8?B?OG5zRlJkV2JWZ0l2ZzIrb1kxcVRpZVd4UjQ1UkFuaFNXM1ZvOGJCdmozMzVy?=
 =?utf-8?B?TC9qU2FKL2VRUmsyQUMrN3czYkU3dm9DVmdFNU9YemREWnJiMXplMnFyZExh?=
 =?utf-8?B?UzQ5V0ZtblB1L05mOXl3QUtUb2lMY1hKdWY5Vys5ZVJ6RFhsWnN2ZW9LWjF4?=
 =?utf-8?B?eVRISEk5eVcrSVo2cXZVMFI4OEEwS2pUZEgzbCtjQjZ4ck1hTHJ1c2NpdGQw?=
 =?utf-8?B?a3RhbnE2bFhyN2U0N1Y4S1lHMXpBaHJweE41UjNmeC9NbXo0d1VaU1hKYkNh?=
 =?utf-8?B?THZqTWxYNm44amhIWDN6cjlDWU42dkhvZS82WlZqQnpRbEgrcXVPWVhjam5o?=
 =?utf-8?B?ZlUrY1kwdE9oWWNIRVNWWGt6SWxDcGpreVdhUWM4UDFjeXgrTGxvc0tGZGJn?=
 =?utf-8?B?N21zcjVCekdZaFFEa2VGQ2JqY2tHNGlLTmhIZHFRakdVbm45QjQxVFJ5ZlZy?=
 =?utf-8?Q?J3HwyKPW/4Paffo+22T4kF1Ja?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f24a24c-0ef5-4b5d-d5ed-08dbf7908132
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 01:53:41.9221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3K/AlfMHsbrvl3zFttD3FyRkGnUjHjvlvmqVpfIm9A49W9W6xwk/yor+dDCC6IFRCP/uV21EUseioNepE3ZZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675



On 11/20/2023 6:51 PM, Yahui Cao wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Lingyu Liu <lingyu.liu@intel.com>
> 
> Save the virtual channel messages sent by VF on the source side during
> runtime. The logged virtchnl messages will be transferred and loaded
> into the device on the destination side during the device resume stage.
> 
> For the feature which can not be migrated yet, it must be disabled or
> blocked to prevent from being abused by VF. Otherwise, it may introduce
> functional and security issue. Mask unsupported VF capability flags in
> the VF-PF negotiaion stage.

s/negotiaion/negotiation/

> 
> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> ---
>   .../net/ethernet/intel/ice/ice_migration.c    | 167 ++++++++++++++++++
>   .../intel/ice/ice_migration_private.h         |  17 ++
>   drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   5 +
>   drivers/net/ethernet/intel/ice/ice_virtchnl.c |  31 ++++
>   4 files changed, 220 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_migration.c b/drivers/net/ethernet/intel/ice/ice_migration.c
> index 2b9b5a2ce367..18ec4ec7d147 100644
> --- a/drivers/net/ethernet/intel/ice/ice_migration.c
> +++ b/drivers/net/ethernet/intel/ice/ice_migration.c
> @@ -3,6 +3,17 @@
> 
>   #include "ice.h"
> 
> +struct ice_migration_virtchnl_msg_slot {
> +       u32 opcode;
> +       u16 msg_len;
> +       char msg_buffer[];
> +};
> +
> +struct ice_migration_virtchnl_msg_listnode {
> +       struct list_head node;
> +       struct ice_migration_virtchnl_msg_slot msg_slot;
> +};
> +
>   /**
>    * ice_migration_get_pf - Get ice PF structure pointer by pdev
>    * @pdev: pointer to ice vfio pci VF pdev structure
> @@ -22,6 +33,9 @@ EXPORT_SYMBOL(ice_migration_get_pf);
>   void ice_migration_init_vf(struct ice_vf *vf)
>   {
>          vf->migration_enabled = true;
> +       INIT_LIST_HEAD(&vf->virtchnl_msg_list);
> +       vf->virtchnl_msg_num = 0;
> +       vf->virtchnl_msg_size = 0;
>   }
> 
>   /**
> @@ -30,10 +44,24 @@ void ice_migration_init_vf(struct ice_vf *vf)
>    */
>   void ice_migration_uninit_vf(struct ice_vf *vf)
>   {
> +       struct ice_migration_virtchnl_msg_listnode *msg_listnode;
> +       struct ice_migration_virtchnl_msg_listnode *dtmp;
> +
>          if (!vf->migration_enabled)
>                  return;
> 
>          vf->migration_enabled = false;
> +
> +       if (list_empty(&vf->virtchnl_msg_list))
> +               return;
> +       list_for_each_entry_safe(msg_listnode, dtmp,
> +                                &vf->virtchnl_msg_list,
> +                                node) {
> +               list_del(&msg_listnode->node);
> +               kfree(msg_listnode);
> +       }
> +       vf->virtchnl_msg_num = 0;
> +       vf->virtchnl_msg_size = 0;
>   }
> 
>   /**
> @@ -80,3 +108,142 @@ void ice_migration_uninit_dev(struct ice_pf *pf, int vf_id)
>          ice_put_vf(vf);
>   }
>   EXPORT_SYMBOL(ice_migration_uninit_dev);
> +
> +/**
> + * ice_migration_is_loggable_msg - is this message loggable or not
> + * @v_opcode: virtchnl message operation code
> + *
> + * Return true if this message logging is supported, otherwise return false
> + */
> +static inline bool ice_migration_is_loggable_msg(u32 v_opcode)
> +{
> +       switch (v_opcode) {
> +       case VIRTCHNL_OP_VERSION:
> +       case VIRTCHNL_OP_GET_VF_RESOURCES:
> +       case VIRTCHNL_OP_CONFIG_VSI_QUEUES:
> +       case VIRTCHNL_OP_CONFIG_IRQ_MAP:
> +       case VIRTCHNL_OP_ADD_ETH_ADDR:
> +       case VIRTCHNL_OP_DEL_ETH_ADDR:
> +       case VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE:
> +       case VIRTCHNL_OP_ENABLE_QUEUES:
> +       case VIRTCHNL_OP_DISABLE_QUEUES:
> +       case VIRTCHNL_OP_ADD_VLAN:
> +       case VIRTCHNL_OP_DEL_VLAN:
> +       case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
> +       case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
> +       case VIRTCHNL_OP_CONFIG_RSS_KEY:
> +       case VIRTCHNL_OP_CONFIG_RSS_LUT:
> +       case VIRTCHNL_OP_GET_SUPPORTED_RXDIDS:
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
> +/**
> + * ice_migration_log_vf_msg - Log request message from VF
> + * @vf: pointer to the VF structure
> + * @event: pointer to the AQ event
> + *
> + * Log VF message for later device state loading during live migration
> + *
> + * Return 0 for success, negative for error
> + */
> +int ice_migration_log_vf_msg(struct ice_vf *vf,
> +                            struct ice_rq_event_info *event)
> +{
> +       struct ice_migration_virtchnl_msg_listnode *msg_listnode;
> +       u32 v_opcode = le32_to_cpu(event->desc.cookie_high);
> +       struct device *dev = ice_pf_to_dev(vf->pf);
> +       u16 msglen = event->msg_len;
> +       u8 *msg = event->msg_buf;
> +
> +       if (!ice_migration_is_loggable_msg(v_opcode))
> +               return 0;
> +
> +       if (vf->virtchnl_msg_num >= VIRTCHNL_MSG_MAX) {
> +               dev_warn(dev, "VF %d has maximum number virtual channel commands\n",
> +                        vf->vf_id);
> +               return -ENOMEM;
> +       }
> +
> +       msg_listnode = (struct ice_migration_virtchnl_msg_listnode *)
> +                       kzalloc(struct_size(msg_listnode,
> +                                           msg_slot.msg_buffer,
> +                                           msglen),
> +                               GFP_KERNEL);
> +       if (!msg_listnode) {
> +               dev_err(dev, "VF %d failed to allocate memory for msg listnode\n",
> +                       vf->vf_id);
> +               return -ENOMEM;
> +       }
> +       dev_dbg(dev, "VF %d save virtual channel command, op code: %d, len: %d\n",
> +               vf->vf_id, v_opcode, msglen);
> +       msg_listnode->msg_slot.opcode = v_opcode;
> +       msg_listnode->msg_slot.msg_len = msglen;
> +       memcpy(msg_listnode->msg_slot.msg_buffer, msg, msglen);

It seems like this can still be abused. What if the VM/VF user sends 
hundreds of thousands of ADD_ADDR/DEL_ADDR, ADD_VLAN/DEL_VLAN, 
PROMISCUOUS, ENABLE_VLAN_STRIPPING/DISABLE_VLAN_STRIPPING, RSS_LUT, 
RSS_KEY, etc.?

Shouldn't you only maintain one copy for each key/value when it makes 
sense? For example, you don't need multiple RSS_LUT and RSS_KEY messages 
logged as just the most recent one is needed.

What if multiple promiscuous messages are sent? Do you need to save them 
all or just the most recent?

What if you have an ADD_ADDR/DEL_ADDR for the same address? Do you need 
to save both of those messages? Seems like when you get a DEL_ADDR you 
should search for the associated ADD_ADDR and just remove it. Same 
comment applies for ADD_VLAN/DEL_VLAN.

> +       list_add_tail(&msg_listnode->node, &vf->virtchnl_msg_list);
> +       vf->virtchnl_msg_num++;
> +       vf->virtchnl_msg_size += struct_size(&msg_listnode->msg_slot,
> +                                            msg_buffer,
> +                                            msglen);
> +       return 0;
> +}
> +
> +/**
> + * ice_migration_unlog_vf_msg - revert logged message
> + * @vf: pointer to the VF structure
> + * @v_opcode: virtchnl message operation code
> + *
> + * Remove the last virtual channel message logged before.
> + */
> +void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode)
> +{
> +       struct ice_migration_virtchnl_msg_listnode *msg_listnode;
> +
> +       if (!ice_migration_is_loggable_msg(v_opcode))
> +               return;
> +
> +       if (WARN_ON_ONCE(list_empty(&vf->virtchnl_msg_list)))
> +               return;
> +
> +       msg_listnode =
> +               list_last_entry(&vf->virtchnl_msg_list,
> +                               struct ice_migration_virtchnl_msg_listnode,
> +                               node);
> +       if (WARN_ON_ONCE(msg_listnode->msg_slot.opcode != v_opcode))
> +               return;
> +
> +       list_del(&msg_listnode->node);
> +       kfree(msg_listnode);
> +       vf->virtchnl_msg_num--;
> +       vf->virtchnl_msg_size -= struct_size(&msg_listnode->msg_slot,
> +                                            msg_buffer,
> +                                            msg_listnode->msg_slot.msg_len);
> +}
> +
> +#define VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE \
> +                               (VIRTCHNL_VF_OFFLOAD_L2 | \
> +                                VIRTCHNL_VF_OFFLOAD_RSS_PF | \
> +                                VIRTCHNL_VF_OFFLOAD_RSS_AQ | \
> +                                VIRTCHNL_VF_OFFLOAD_RSS_REG | \
> +                                VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2 | \
> +                                VIRTCHNL_VF_OFFLOAD_ENCAP | \
> +                                VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM | \
> +                                VIRTCHNL_VF_OFFLOAD_RX_POLLING | \
> +                                VIRTCHNL_VF_OFFLOAD_WB_ON_ITR | \
> +                                VIRTCHNL_VF_CAP_ADV_LINK_SPEED | \
> +                                VIRTCHNL_VF_OFFLOAD_VLAN | \
> +                                VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC | \
> +                                VIRTCHNL_VF_OFFLOAD_USO)
> +
> +/**
> + * ice_migration_supported_caps - get migration supported VF capabilities
> + *
> + * When migration is activated, some VF capabilities are not supported.
> + * Hence unmask those capability flags for VF resources.
> + */
> +u32 ice_migration_supported_caps(void)
> +{
> +       return VIRTCHNL_VF_MIGRATION_SUPPORT_FEATURE;
> +}
> diff --git a/drivers/net/ethernet/intel/ice/ice_migration_private.h b/drivers/net/ethernet/intel/ice/ice_migration_private.h
> index 2cc2f515fc5e..676eb2d6c12e 100644
> --- a/drivers/net/ethernet/intel/ice/ice_migration_private.h
> +++ b/drivers/net/ethernet/intel/ice/ice_migration_private.h
> @@ -13,9 +13,26 @@
>   #if IS_ENABLED(CONFIG_ICE_VFIO_PCI)
>   void ice_migration_init_vf(struct ice_vf *vf);
>   void ice_migration_uninit_vf(struct ice_vf *vf);
> +int ice_migration_log_vf_msg(struct ice_vf *vf,
> +                            struct ice_rq_event_info *event);
> +void ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode);
> +u32 ice_migration_supported_caps(void);
>   #else
>   static inline void ice_migration_init_vf(struct ice_vf *vf) { }
>   static inline void ice_migration_uninit_vf(struct ice_vf *vf) { }
> +static inline int ice_migration_log_vf_msg(struct ice_vf *vf,
> +                                          struct ice_rq_event_info *event)
> +{
> +       return 0;
> +}
> +
> +static inline void
> +ice_migration_unlog_vf_msg(struct ice_vf *vf, u32 v_opcode) { }
> +static inline u32
> +ice_migration_supported_caps(void)
> +{
> +       return 0xFFFFFFFF;
> +}
>   #endif /* CONFIG_ICE_VFIO_PCI */
> 
>   #endif /* _ICE_MIGRATION_PRIVATE_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> index 431fd28787e8..318b6dfc016d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> @@ -77,6 +77,7 @@ struct ice_vfs {
>          unsigned long last_printed_mdd_jiffies; /* MDD message rate limit */
>   };
> 
> +#define VIRTCHNL_MSG_MAX 1000

This seems fairly arbitrary. How did you come up with this value? It 
seems like you can figure out the max number of messages needed for a 
single VF and it wouldn't be too unreasonable. What if it's a trusted VF 
that supports 4K VLANs?

Also, should this be named more appropriately since it's specific to the 
ice driver, i.e.:

ICE_VF_VIRTCHNL_LOGGABLE_MSG_MAX


>   /* VF information structure */
>   struct ice_vf {
>          struct hlist_node entry;
> @@ -141,6 +142,10 @@ struct ice_vf {
>          u16 num_msix;                   /* num of MSI-X configured on this VF */
> 
>          u8 migration_enabled:1;
> +       struct list_head virtchnl_msg_list;
> +       u64 virtchnl_msg_num;
> +       u64 virtchnl_msg_size;
> +       u32 virtchnl_retval;
>   };
> 
>   /* Flags for controlling behavior of ice_reset_vf */
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index 661ca86c3032..730eeaea8c89 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -348,6 +348,12 @@ ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
>                  return -EIO;
>          }
> 
> +       /* v_retval will not be returned in this function, store it in the
> +        * per VF field to be used by migration logging logic later.
> +        */
> +       if (vf->migration_enabled)
> +               vf->virtchnl_retval = v_retval;
> +
>          return ice_vc_send_response_to_vf(vf, v_opcode, v_retval, msg, msglen);
>   }
> 
> @@ -480,6 +486,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
>                                    VIRTCHNL_VF_OFFLOAD_RSS_REG |
>                                    VIRTCHNL_VF_OFFLOAD_VLAN;
> 
> +       if (vf->migration_enabled)
> +               vf->driver_caps &= ice_migration_supported_caps();
>          vfres->vf_cap_flags = VIRTCHNL_VF_OFFLOAD_L2;
>          vsi = ice_get_vf_vsi(vf);
>          if (!vsi) {
> @@ -4037,6 +4045,17 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
>                  goto finish;
>          }
> 
> +       if (vf->migration_enabled) {
> +               if (ice_migration_log_vf_msg(vf, event)) {
> +                       u32 status_code = VIRTCHNL_STATUS_ERR_NO_MEMORY;
> +
> +                       err = ice_vc_respond_to_vf(vf, v_opcode,
> +                                                  status_code,
> +                                                  NULL, 0);
> +                       goto finish;
> +               }
> +       }
> +
>          switch (v_opcode) {
>          case VIRTCHNL_OP_VERSION:
>                  err = ops->get_ver_msg(vf, msg);
> @@ -4156,6 +4175,18 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
>                           vf_id, v_opcode, err);
>          }
> 
> +       /* All of the loggable virtual channel messages are logged by
> +        * ice_migration_unlog_vf_msg() before they are processed.

Should this be ice_migration_log_vf_msg() in the comment instead?

> +        *
> +        * Two kinds of error may happen, virtual channel message's result
> +        * is failure after processed by PF or message is not sent to VF
> +        * successfully. If error happened, fallback here by reverting logged
> +        * messages.
> +        */
> +       if (vf->migration_enabled &&
> +           (vf->virtchnl_retval != VIRTCHNL_STATUS_SUCCESS || err))
> +               ice_migration_unlog_vf_msg(vf, v_opcode);
> +
>   finish:
>          mutex_unlock(&vf->cfg_lock);
>          ice_put_vf(vf);
> --
> 2.34.1
> 

