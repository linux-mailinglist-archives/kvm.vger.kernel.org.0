Return-Path: <kvm+bounces-126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F387DBFD4
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEE7EB20F09
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10FA19BB6;
	Mon, 30 Oct 2023 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="byFCJgSN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3CD16408
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 18:26:15 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0967698;
	Mon, 30 Oct 2023 11:26:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzHtwYi76K0sr0ZxGf/Ujw42mjYXE0H0XgYMJ5tC9fhodyuBi5+u8IxAr7BGousj8tAxLS6xeep8dBztFJFCb2zoIIwFv9GxzxSNuPxGe+TjywIpkGTpvkh94q11ivz6TI/Ak759P84iFoEwrTK2yXsCacJzPsQitr+mxl+K8jQLtKkUhU7HJAUEOEJ1rJ+jIc89io39RFy9Px9DHZ2ivBs/pWew3Tk8AIfETqUqHpQaUr/U0plF+T5NhzaUDExQTEfCJGZrdg2z1LTz7YbxKweZ+iVfRQQBMycJ3a+56lg562J24jusRYkgWQ0KGsdOAN30DQEkgWJpv5mT/YgCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx2s2IT3vmqZ0o7LXhNefKfZvf/iuzcCQJF1sL/oCMc=;
 b=BATOwBISP16n4SBzwDA21SG3cO0S1HBjX9cNz7Ovaiv6+7EMfHQqCy7riqy4219+BDQlChyvoV8HgJyIQW4c00zr7rdFGpxK87Ipzd1yv1Gc774Ch4EftFX6ajIW0aR+t3zmSJs7/MB75nRT+hqUwD5TFSmQ1YCKow1/ctVj/LGEaip+XCkGwiEZYvNY8dAHmRWSNbrvgbhkCut7zI7BkWda4wvADKtinaqNS9cvTiT3IPi5CqXlGNpu6DTV8ZepOdIfwIFZVBy8999H8gPLyCOK1xy+NQJsRv6dCqwtr/zaUemF32aJncCKeiehnawiAysx9LHHoVwngoHLPxxyRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx2s2IT3vmqZ0o7LXhNefKfZvf/iuzcCQJF1sL/oCMc=;
 b=byFCJgSNCTJcGl0uk+ww7kMVtFMLrgdaz4PsQcLv7w0eLf8iQJXWiUYNaBuJ6j9Ugis/pwlw0yaTo00hLUCFYwBfDks2KIBzbefMDoMb9nODkSLeU18eUGnEBFMZXNJwmTkYmH1ExWC944ZIep16Nno+PnDoGB0raGzaTfLJvxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by BN9PR12MB5225.namprd12.prod.outlook.com (2603:10b6:408:11e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 18:26:11 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 18:26:11 +0000
Message-ID: <1bdd1e8c-0114-c6c2-4726-ee83c761dfbd@amd.com>
Date: Mon, 30 Oct 2023 13:26:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 05/14] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-6-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:806:f2::29) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|BN9PR12MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 431ff825-d9da-4f85-2a99-08dbd975b147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z6zMU4fNnuH2d4pXudbilFihQTcC/NKRLxILce2TTs0M0axec+xbGkXTdKEBPRmi65c7D7VlClpTSrLx3cpjnpjAeWGWzzPfHpVKF7t+BNcTIE935rLaifMh4RdvQ1p5zn+G7W4aEttjNxQ4SN8SHHwrVPGaQBtGYUYjzFRwpbPJWWsDpc78z/tPVVWWi8PZ7ANHDrt6fADgKrcWtM65AsCWKJeD33wSFm1ujqGqZPBqLw3maAf2KeOgKTkCS71pKYZdEYzkK0gygotmWZf6wmK1qZMWOL/tScauK8TMJEJyecBb0pfDc9ZVS9hU1rPDBvPsYpXdXFNf8UtL9vS+JiPbN/NxL2pu50afzqt/Ghi6+LrfCgS4TJKJXuIL822lIN+geVIr0gxG5N6f0Qdkwe8Pthj6dWV3oNy6QHznW1u5hXy0IrwrB/gJZdonwHh3PLGxu9y2SKmir6GTIbsqlMjYn8r4aJiMylWMo2LX090sw4sm+vsrBsm2GoRYP6TR6p5C1KSEKhIdP/LWixOy6y26dO8s2/DJk9KWD/OXJjHrYUrese+03ut2LPs0gU50wdbxrWAQcELmcn1l3xVehovUq9oRTIFdrkY/743r6X2R9TvvaSlcGXXB/iQcIH44EeiCiJoP2vZbJDXhHqnFMw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(396003)(366004)(346002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(31686004)(6512007)(53546011)(6666004)(83380400001)(6486002)(478600001)(6506007)(36756003)(86362001)(31696002)(38100700002)(7416002)(5660300002)(66476007)(66556008)(66946007)(41300700001)(26005)(2906002)(2616005)(8676002)(8936002)(316002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTZneWNBY21uVzczR1dzenpqeThyR1NrZVhPUHRYZDR2bG03aHk0c1lmVHI0?=
 =?utf-8?B?ckZLY1ZzTjdqYU9yMHE0UU85OWNkZGUzeGFEMmhqS1lER1ZVOENKOUVJWk5O?=
 =?utf-8?B?MndVbjZiRUwvOTJzdmEwcXBBOHErdmdxWXNTYmtrQXczQmg4dGJjaEJWRDhy?=
 =?utf-8?B?bGc3QUEzQnFVRGRJeFVJK3FXYXNRYy92REw2c1ZDTXdZQzRZbXJkSlQrNXIy?=
 =?utf-8?B?d1hGbnQ1Y25zaXFTZTZRcjVsY1YyblZ4Q0dmbEFDaGZpWEF1Ym42OXk5ZEdT?=
 =?utf-8?B?RlRoZXdoSUFBRnRJSXFScDhrVkFYWGhLT2srSWk5cDAxb09VWng0TXVCUnNl?=
 =?utf-8?B?bDhDSnZmdW9kOCtEODRuZDkveEw5Um5BUWlUamlGYWdMNG1BaFp6RUZlNlpK?=
 =?utf-8?B?Qi9TUEo0aCtyd2wxckVkM2h0UW5uQTZHbVdpRGg2d1ZIdUNxbVhjK3c4S0RD?=
 =?utf-8?B?S0cwSjFzL2VWMWNzY1Z5NGVpRXhDZ1ZQRUtqRFJFWFczVTFRQTFPVkVROGRV?=
 =?utf-8?B?NGg1STVJN2dOV2VSeGdxeUdsbEFCN21FbmxWK3R5V1NOM1B1Q0xLSDRtbU1w?=
 =?utf-8?B?VllnWStZYVBxdFpac0xVVXlTWXdKWjBvZkZVcW9yOWYrVis0UWxWSDdyOHVD?=
 =?utf-8?B?VlYwR0F3OHlGS1Vtei9wOWdpaWhkNUI2VVFZZnY5aDZMaDlQUURXYWtLUWc3?=
 =?utf-8?B?MTlSOW45Qm1ZbERVQjh3MmNsU2VNRnJxamppVjZiYlgzWGM1bUd4RXU5bUV6?=
 =?utf-8?B?S0hXd1h2bitrVXBCYTVjMGJxZnc0TzlUcElLalVWeVVsampFamlzM29WTTRM?=
 =?utf-8?B?QWx4RHJUQmV5bWdHQWV2VUxuRCtJZ0M2emRuZXExMWFtQUpEVjZ2UUhkeklL?=
 =?utf-8?B?VGpWUUQ0dTFCV3MydEZGck0yYUJQMjhHcFQrajNKUVhqaU5wRTVSY0o0S05Q?=
 =?utf-8?B?ZkRqeTZWempPclg2SFN4TWZMbFN6NTBCQkhPTW5lUTJnYitYVENQSVBLMXgx?=
 =?utf-8?B?M1ZyT0o1NUZ2UG55OXlMZ3A1ZldHbGZWVXc2NDV6OWE4allzRGFIRTFBQkZy?=
 =?utf-8?B?SDBxR3kvRjBCWXduLy9CVUp1bk9qWVVLeHAybmhyOVBDYUp2Wms0N0ppblkv?=
 =?utf-8?B?RHp3ZlR0dkJlbVZMS1p5VEpHZkpSdldEV01PUlphQ3ZsMTdnVDJKMFNJeU1o?=
 =?utf-8?B?ZnlnWFc2SHVMRk1oNmZKdHlPbUdZYVlTeTZVbXo2T0U0alBlWlJWclFCRnAx?=
 =?utf-8?B?R25vdkdDTEovcDdwV3YvQ25sN1Bab215K2FHaTJmeFZlQlZQTzhzTGROU0t4?=
 =?utf-8?B?T3FWYjJFUGg2ZXBGMUEydVdjWnJteDZneGlPMnk2WC8rcW1uUWpiQUt3bFBZ?=
 =?utf-8?B?dWNoeEY1NEpsNjJVMGFmaW96anpnaWZQcjFlbVNCQUdHSlNIWVNsWVkwZjRZ?=
 =?utf-8?B?d0tsalVSazFFcThuZk1MbGQxekhkWW55MUM4b0tXdjVpeWsyWjhNeUNTVnI0?=
 =?utf-8?B?Y2hrQXMvMHJ1YWdKRDUyMEFnMDFXdVlZNDVYNU5TZjlXKzIyam5pWFVHQ01z?=
 =?utf-8?B?QlBmUnF5YnV6SEdaQ1B2WEhGeEcwNVAxbzZWelJBSGQ3bDdPWmJzQU0yVzE5?=
 =?utf-8?B?a2pVM0x4TWVCSmE5Y0xDQlFibC9BdSs4L1VGckZiM0F4dWJ6T3hWcExldmcy?=
 =?utf-8?B?Rk5yZFFGVFNQeWt5Mk92ZDlpTWMyK0ZIN2t0VWFxc3NxTldaWGQxWlNyaGJy?=
 =?utf-8?B?aHRQSk5tSnhlcENsMkE4dTlvcWIzaG05Z09ucVgrS05mOVJubHVpUHdPSW1o?=
 =?utf-8?B?NFdEV1BlaGRPbWpLQnFPekZhVjdwUXJiU0FwVnVsMHczc1hVMXRnZG82TDgv?=
 =?utf-8?B?Vm5OODlHWWE1bENkb0lFSTRPc1dJQ01QOFVFWFVvT3BjODlmbDRQVSt5T0dr?=
 =?utf-8?B?YU5TMlVKbkE0SnV1ZVBNcElRSmVETjh2VnNMY1pBMWlXaDVlWWR4aUpOVXA3?=
 =?utf-8?B?ZzVlZm5QbFd4d2VScGFiUHdjWC8yaTlLWmhIb2tUTUhxODZxdVJVSXVUWHF4?=
 =?utf-8?B?MlViOHN4WjZCejZIYTFacHBtRFcweEhqem1tbk1FUmVkeFF1dWR2ZC8wbG5D?=
 =?utf-8?Q?gPf8Yjv3Otfy2OXwmZ/LeZM2M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431ff825-d9da-4f85-2a99-08dbd975b147
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 18:26:11.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJ/k72xjarkNLdMIQii4W+g1G+uKS6B9AeofCllQeXdneaySG6nOim9zWaU6nm3mqJ31numwS/6oSteWcf/ikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5225

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> Drop vmpck and os_area_msg_seqno pointers so that secret page layout
> does not need to be exposed to the sev-guest driver after the rework.
> Instead, add helper APIs to access vmpck and os_area_msg_seqno when
> needed.
> 
> Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
> preparation for moving to sev.c.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

With the fix to the snp_assign_vmpck() to change the int to an unsigned 
int as requested by Dionna...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/virt/coco/sev-guest/sev-guest.c | 85 ++++++++++++-------------
>   1 file changed, 42 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 5801dd52ffdf..4dd094c73e2f 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -50,8 +50,7 @@ struct snp_guest_dev {
>   
>   	struct snp_secrets_page_layout *layout;
>   	struct snp_req_data input;
> -	u32 *os_area_msg_seqno;
> -	u8 *vmpck;
> +	unsigned int vmpck_id;
>   };
>   
>   static u32 vmpck_id;
> @@ -61,14 +60,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>   /* Mutex to serialize the shared buffer access and command handling. */
>   static DEFINE_MUTEX(snp_cmd_mutex);
>   
> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
>   {
> -	char zero_key[VMPCK_KEY_LEN] = {0};
> +	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
> +}
>   
> -	if (snp_dev->vmpck)
> -		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
> +static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +	return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
> +}
>   
> -	return true;
> +static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
> +{
> +	char zero_key[VMPCK_KEY_LEN] = {0};
> +	u8 *key = snp_get_vmpck(snp_dev);
> +
> +	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>   }
>   
>   /*
> @@ -90,20 +97,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>    */
>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>   {
> +	u8 *key = snp_get_vmpck(snp_dev);
> +
>   	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
> -		  vmpck_id);
> -	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> -	snp_dev->vmpck = NULL;
> +		  snp_dev->vmpck_id);
> +	memzero_explicit(key, VMPCK_KEY_LEN);
>   }
>   
>   static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>   {
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>   	u64 count;
>   
>   	lockdep_assert_held(&snp_dev->cmd_mutex);
>   
>   	/* Read the current message sequence counter from secrets pages */
> -	count = *snp_dev->os_area_msg_seqno;
> +	count = *os_area_msg_seqno;
>   
>   	return count + 1;
>   }
> @@ -131,11 +140,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>   
>   static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>   {
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
> +
>   	/*
>   	 * The counter is also incremented by the PSP, so increment it by 2
>   	 * and save in secrets page.
>   	 */
> -	*snp_dev->os_area_msg_seqno += 2;
> +	*os_area_msg_seqno += 2;
>   }
>   
>   static inline struct snp_guest_dev *to_snp_dev(struct file *file)
> @@ -145,15 +156,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>   	return container_of(dev, struct snp_guest_dev, misc);
>   }
>   
> -static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
> +static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
>   {
>   	struct aesgcm_ctx *ctx;
> +	u8 *key;
> +
> +	if (snp_is_vmpck_empty(snp_dev)) {
> +		pr_err("SNP: vmpck id %d is null\n", snp_dev->vmpck_id);
> +		return NULL;
> +	}
>   
>   	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>   	if (!ctx)
>   		return NULL;
>   
> -	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
> +	key = snp_get_vmpck(snp_dev);
> +	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>   		pr_err("SNP: crypto init failed\n");
>   		kfree(ctx);
>   		return NULL;
> @@ -586,7 +604,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>   	mutex_lock(&snp_dev->cmd_mutex);
>   
>   	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (snp_is_vmpck_empty(snp_dev)) {
>   		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>   		mutex_unlock(&snp_dev->cmd_mutex);
>   		return -ENOTTY;
> @@ -656,32 +674,14 @@ static const struct file_operations snp_guest_fops = {
>   	.unlocked_ioctl = snp_guest_ioctl,
>   };
>   
> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
> +bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
>   {
> -	u8 *key = NULL;
> +	if (WARN_ON(vmpck_id > 3))
> +		return false;
>   
> -	switch (id) {
> -	case 0:
> -		*seqno = &layout->os_area.msg_seqno_0;
> -		key = layout->vmpck0;
> -		break;
> -	case 1:
> -		*seqno = &layout->os_area.msg_seqno_1;
> -		key = layout->vmpck1;
> -		break;
> -	case 2:
> -		*seqno = &layout->os_area.msg_seqno_2;
> -		key = layout->vmpck2;
> -		break;
> -	case 3:
> -		*seqno = &layout->os_area.msg_seqno_3;
> -		key = layout->vmpck3;
> -		break;
> -	default:
> -		break;
> -	}
> +	dev->vmpck_id = vmpck_id;
>   
> -	return key;
> +	return true;
>   }
>   
>   static int __init sev_guest_probe(struct platform_device *pdev)
> @@ -713,14 +713,14 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   		goto e_unmap;
>   
>   	ret = -EINVAL;
> -	snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
> -	if (!snp_dev->vmpck) {
> +	snp_dev->layout = layout;
> +	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
>   		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
>   		goto e_unmap;
>   	}
>   
>   	/* Verify that VMPCK is not zero. */
> -	if (is_vmpck_empty(snp_dev)) {
> +	if (snp_is_vmpck_empty(snp_dev)) {
>   		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
>   		goto e_unmap;
>   	}
> @@ -728,7 +728,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	mutex_init(&snp_dev->cmd_mutex);
>   	platform_set_drvdata(pdev, snp_dev);
>   	snp_dev->dev = dev;
> -	snp_dev->layout = layout;
>   
>   	/* Allocate the shared page used for the request and response message. */
>   	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
> @@ -744,7 +743,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   		goto e_free_response;
>   
>   	ret = -EIO;
> -	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
> +	snp_dev->ctx = snp_init_crypto(snp_dev);
>   	if (!snp_dev->ctx)
>   		goto e_free_cert_data;
>   

