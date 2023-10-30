Return-Path: <kvm+bounces-105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33CD7DBE8E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D49B41C20B3E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B966119463;
	Mon, 30 Oct 2023 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mxj2TjQe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A11B19455
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:12:22 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09723FA;
	Mon, 30 Oct 2023 10:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUjA0zal02frxHh6T/Eh/lFL/6IBRJOdwrQ5+QY49Kcs463v6eaEWXQ2gfy5Ic8WOkVECnUR9JuFYXl4kjTwjBx9yMxLqP73HExunROHPzHOHsEEdCkL41HNsDQH1dUU2COs5MIssmMHihieksiUTttDPMMnhWZlcOBetB4wcLdsxi9M8QF59QRQpT7u6nbIjhRw8MM60jH3i/Q/BVz75k1KFsMdyjBJoFDG7bN2KqPSEwQuArurfMsRQUlKscanFm6CH9m7b3b+JTO7Q436OeEE+p0ejriCcgBllLQo/SHMqDtK93rUUP7f/uaXPGqgTDLR640eZzN5XMlWbk0h7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83qERt5UCOVvYt8y06MVZGLApSi+3BiArB+kEqr8BDM=;
 b=NSPorNeubc+CAsdRSbv4tdSNbR6nUiab7ydA4T/SiHQkZAub+rV4jQIjr3uMXJUjZbFr8/CVdiGP3H8F3L2JH+Gwmsu0efHVnMPIPq+Ra0kCB0iqYVxL4eiquMhxUfrBixiWxeHArhC1JSTvvXgMW4a+4xgtRpcZpuNJNSdKVIIY+Dj3v/uT7w25/uddozrI+7XIOh0GxQuzgb4FYmSrbdk2B7/IKvjbcnR4gHSy/f+L9uEBqYHDyzynu2tDax92yC2kaNp2SoV9bfGbsS+wicaAkKnzB30/fuB46U7FajLxmd16U0v/cwOdTiE0Q+wsWdjcDptLkmE/ml0n/VbSHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83qERt5UCOVvYt8y06MVZGLApSi+3BiArB+kEqr8BDM=;
 b=Mxj2TjQej/SMvgMXYDnu+bBrKnLSZunXhk71bn91EQQlun+Va3PBYufRV7sczMSI8dzwSAU9SVFYSpaBOSF19i9T6cOG9eSpi6JVJ/uJAk64De/iR0Pm6IDPPpnKFPhIBJaYlFbQD1ZkUlqeOKW1UmiwtnBUBY9jEAcTF9DVs4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by DS0PR12MB6654.namprd12.prod.outlook.com (2603:10b6:8:d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 17:12:14 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 17:12:14 +0000
Message-ID: <57b904e1-9a17-9203-e275-4b5a31ca8a71@amd.com>
Date: Mon, 30 Oct 2023 12:12:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 05/14] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>,
 Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-6-nikunj@amd.com>
 <CAAH4kHY_sM0DTL+EVz3GNDq1q_5S4FH1Ku9EMV0HOzFAY1s4QQ@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHY_sM0DTL+EVz3GNDq1q_5S4FH1Ku9EMV0HOzFAY1s4QQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::33) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|DS0PR12MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ec3ee9-7943-4fe0-1c9e-08dbd96b5c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nYDmvO+zSk0quCgAkn7XNu2vbKYy04/kW182QDsNYyY/AjvWaZ7kwzQ+C5qfD0kuOEC3CqXOY/YkG2PmFhWCs3phoUgSjv14JCy1NMdyIpbcI4mwle+NGaoy106bYS4T+ML9G7b1ZpTLpFpIzP9vWi8whgJnobqyAD8hDjKa+mak8rGUd97JbpyWl0GM4TaQf0NMNpP5HcDk43N/0BSwrqjGIwNvgAoC7qAvYnTb/KzMXct08GqW8Ge4Y+z6LJpjnIjKhwYmWybkJcjoiWRufYTRaRLlYTQ2Qtba1NbtqR5gkt7pMRmHm+x+kYRvW988k6J9s2ZUPVCYT2f4OT7WJIDvNWZfbjj556YpCFMDAVFvdWwVqCWD3wXCDfpATtRWGqOpgfiI1ZrzXkEi3LbvYQihiTamocKP40YbuWYiPg3uucVtCk7B5fa05jWQmEukn5fREDfDLqJskjnr/ALMHaOvifjRUwUUqWh/6jlBWtbYvL4dwRG4a7zpomRzv1Azjeo3Tq1KR0Vc/PGeLspO6yLiHpI8fNxfY4sdqhBWB6lVibBNMiSbcYr+xs6r0Qxd5c/iiWMyO49vO5Uo1ayDgT1V0CW47rYG/pvrI2/jKCRmyGimHhrg0pQ1gNAy+ssQQ5NcVV9qF8kWPgTAJPpyCA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(346002)(39860400002)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6512007)(2616005)(26005)(53546011)(478600001)(6506007)(6666004)(83380400001)(5660300002)(7416002)(2906002)(41300700001)(110136005)(8936002)(4326008)(8676002)(66476007)(66946007)(6636002)(66556008)(316002)(6486002)(38100700002)(31696002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3dYdDl1c3U1YmdZZWZHeUpjcjZka1d4Ny9zV2JDckZZQ255bks2ZDViYjEr?=
 =?utf-8?B?aEsySTJZQndYMmFoc3VGMUw3YzNQeUgxVk9xeGp6c3pORXQ1eXNWVXdRMVhD?=
 =?utf-8?B?ZVovTUc2Wno0TitsSmpucEtRSzBtS0hET0xLTHVZRUN1WjFQVlRMTXNmelhD?=
 =?utf-8?B?bEk3RXF1bXJBeWdsc3NoSC9OVUgwd1FPLzVsNFFpTXBOZG1lclNES0F3SlRi?=
 =?utf-8?B?cXFVZTdjd3IxZVJWTC9wMGh4UHVBb3hZNHUrUkdpNjlqa1ROUDdHQlkxQXZi?=
 =?utf-8?B?aUNWeEJzQTBGQnFpYTVCTXhPRmJWZm9YbEFLKzdxVWNYbld0V05PVlFDcGg1?=
 =?utf-8?B?VmxWZjhqM1dkZzdLd2NvbHliNVZYdWY5dU94QnZZZkNKeTV6ejdnREl3VFBZ?=
 =?utf-8?B?Y2w3bUJIYzU2K3VvUjBPampmTUVwUFI1Zi9iSmZWOGJQa3pncDRlSlBFdlpO?=
 =?utf-8?B?ZWh3MmljRldJLzdMajA3UlA0Z0o1bnZCYThkWjlwY0l5WVpmMSt1amhiMWtB?=
 =?utf-8?B?ays0T1hOUUhKTjNnbHdQcFNMbUV0alRyYmc1cGMvbzAzVG5TQ1JmbklRL2l5?=
 =?utf-8?B?RGJhdDkraVBzNHZ3b3d5S1JNejk1bldpRkhaZW41eVJFdFkvWERjTFJza3lU?=
 =?utf-8?B?RTI2eTh2TFJ2NU5KcXBidVBPTTkwUXFpeDVDYlVlRlVvWmh5dzB5cFV5dUls?=
 =?utf-8?B?QlBxYVo5MXBJbHFtcGw4bjgyWVlTbGI4eGorODhLaitYWVhuS3RVTEg2ZSs2?=
 =?utf-8?B?di9VT3lzN2hqdzd1cEJKZWpkRFFlMytTcDAwaUZTeFhHTVRZR3c5YW5tVUFp?=
 =?utf-8?B?ejBVMVpMUG9mR2NZQ2xJNE1BYllhQzFKNng0V3BUWmNxbjc0SDlETW90NDEw?=
 =?utf-8?B?cVRUMmMyRXZTSmlEYUkxd0dWa2szeTlvQXZ0dzZJY2MwbnFrcGlQelpIWCtw?=
 =?utf-8?B?NnQ3Y0QrYndNOTFKOG5YbG00NmR1SWxsR044cnJMZVovK0lWOUpsSHhwRUJC?=
 =?utf-8?B?Yk9BVnpMR1ZhWUFZMnhzQ3VuNTJUOFd3NGU1amZSRUc4YUZOcTUrais1Zmh0?=
 =?utf-8?B?SGp3TDdnRitRQTUxaGpsc2RmbmZsZzZCL1lzcWUrUXQrMTR6SGkxZG9YRjh4?=
 =?utf-8?B?RnFhR1lSWGlUOW9mMmNZeHpnTk1LeDF6bHBFbTFjT0s2UXEyMm5FQmlSUElF?=
 =?utf-8?B?OVdXaDFVWWhRUzVzUG15TzdTWVc0K1l6YkcyMENpbGlOZ0Uwa2JRMFhKNjZj?=
 =?utf-8?B?MkdDZnczejI0U0hLRW4xUnhPdkJ6NFlvR0VhTm1kUnV2Z0Qwd09OOHRneFJl?=
 =?utf-8?B?eHNCVFJGYlhJSUFja3hrcm1ZU2RZVXZzOVBHN0c0QkM3NDZ6WXBrNEMweDlt?=
 =?utf-8?B?d3hwQ3BvMmpORHN1aTVxbVo4VWQyVmFNYUZaT2xPcWxyekNMT2tBcFhZaWZS?=
 =?utf-8?B?NjlwZmpOS0haaWhSbFAvZzhRZnp4QklMUDNhUk1XQ3o2dlRxL0tmdCtIYzVL?=
 =?utf-8?B?UjJKM3NhNUsvSXlKV2JtYVFrVUhWNXo1MVJNWSs3OGtVeTM3WXVkYzlIZXZU?=
 =?utf-8?B?NXdBMTBwbGdKeXdKcnhtNGhmdTlnQTc2TUhxY1NhTTVrZXNqdndSaHEzMDBK?=
 =?utf-8?B?V3ErVEN0YTYxWkVUcy9ENkZGMTRmdnlDTElLOEJ3MXhMbHZ1bGk0a1ljekl2?=
 =?utf-8?B?Y1RudzV5UHNDdzMvN0JBRjVZMXFVdEJ4T1JUcDZLVE1iVHV0aVoySzFaeVE5?=
 =?utf-8?B?VU05Zk1GMGx4dkZqV2lEWmJWOHVSNUdvbUIrK0RCUkxoMjh6MDhpVkxVZ1JC?=
 =?utf-8?B?a1paejBCbkM4Nmxxck1SV2dFZ3ovaitPWXRNaDYwUlhNU0xXVWFEQ2pETERZ?=
 =?utf-8?B?R0N1ZXQ1Nm1QaUE3ZEpiaE9lUElGaGlOcUhhRllzd21YTENUemkxRTVjaEUz?=
 =?utf-8?B?L1o4eklBSnhyZnpzSFRwNjJ0OWloTFZ3ZFIyNmg5K0FmYytjR1BFZE5vRHI3?=
 =?utf-8?B?b3BreG5BMTBGb3dRZ2pqVTg3dnZVNG80NXNOYXYxMVpVMGpuSDI5bzR2Nnl2?=
 =?utf-8?B?L3A2N3pZa05NMWNwVzF3aVAvdHpYdlBrTEtjWDVEbE9Oak55ZzF2WUVZaWhy?=
 =?utf-8?Q?/14VDYJEBKhtxduAxbVKg3NDb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ec3ee9-7943-4fe0-1c9e-08dbd96b5c72
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 17:12:13.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOBX6mgV1Xpm+Z2F7i0qSg/lW8ktrTbwSVH/qtkZyEVKyzKmtsPZzFJy2L6bSHRbRI9SxCnGty86iq1p5eOXHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6654

On 10/30/23 11:16, Dionna Amalie Glaze wrote:
> On Sun, Oct 29, 2023 at 11:38 PM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>
>> Drop vmpck and os_area_msg_seqno pointers so that secret page layout
>> does not need to be exposed to the sev-guest driver after the rework.
>> Instead, add helper APIs to access vmpck and os_area_msg_seqno when
>> needed.
>>
>> Also, change function is_vmpck_empty() to snp_is_vmpck_empty() in
>> preparation for moving to sev.c.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   drivers/virt/coco/sev-guest/sev-guest.c | 85 ++++++++++++-------------
>>   1 file changed, 42 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 5801dd52ffdf..4dd094c73e2f 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -50,8 +50,7 @@ struct snp_guest_dev {
>>
>>          struct snp_secrets_page_layout *layout;
>>          struct snp_req_data input;
>> -       u32 *os_area_msg_seqno;
>> -       u8 *vmpck;
>> +       unsigned int vmpck_id;
>>   };
>>
>>   static u32 vmpck_id;
>> @@ -61,14 +60,22 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
>>   /* Mutex to serialize the shared buffer access and command handling. */
>>   static DEFINE_MUTEX(snp_cmd_mutex);
>>
>> -static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>> +static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
>>   {
>> -       char zero_key[VMPCK_KEY_LEN] = {0};
>> +       return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
>> +}
>>
>> -       if (snp_dev->vmpck)
>> -               return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
>> +static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
>> +{
>> +       return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
>> +}
>>
>> -       return true;
>> +static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
>> +{
>> +       char zero_key[VMPCK_KEY_LEN] = {0};
>> +       u8 *key = snp_get_vmpck(snp_dev);
>> +
>> +       return !memcmp(key, zero_key, VMPCK_KEY_LEN);
>>   }
>>
>>   /*
>> @@ -90,20 +97,22 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>>    */
>>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>>   {
>> +       u8 *key = snp_get_vmpck(snp_dev);
>> +
>>          dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
>> -                 vmpck_id);
>> -       memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>> -       snp_dev->vmpck = NULL;
>> +                 snp_dev->vmpck_id);
>> +       memzero_explicit(key, VMPCK_KEY_LEN);
>>   }
> 
> We disable the VMPCK because we believe the guest to be under attack,
> but this only clears a single key. Shouldn't we clear all VMPCK keys
> in the secrets page for good measure? If at VMPCK > 0, most likely the
> 0..VMPCK-1 keys have been zeroed by whatever was prior in the boot
> stack, but still better to be safe.

Doing that would be a separate patch series and isn't appropriate here.

Thanks,
Tom

> 
>>
>>   static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>>   {
>> +       u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>>          u64 count;
>>
>>          lockdep_assert_held(&snp_dev->cmd_mutex);
>>
>>          /* Read the current message sequence counter from secrets pages */
>> -       count = *snp_dev->os_area_msg_seqno;
>> +       count = *os_area_msg_seqno;
>>
>>          return count + 1;
>>   }
>> @@ -131,11 +140,13 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
>>
>>   static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
>>   {
>> +       u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
>> +
>>          /*
>>           * The counter is also incremented by the PSP, so increment it by 2
>>           * and save in secrets page.
>>           */
>> -       *snp_dev->os_area_msg_seqno += 2;
>> +       *os_area_msg_seqno += 2;
>>   }
>>
>>   static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>> @@ -145,15 +156,22 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>>          return container_of(dev, struct snp_guest_dev, misc);
>>   }
>>
>> -static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>> +static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
>>   {
>>          struct aesgcm_ctx *ctx;
>> +       u8 *key;
>> +
>> +       if (snp_is_vmpck_empty(snp_dev)) {
>> +               pr_err("SNP: vmpck id %d is null\n", snp_dev->vmpck_id);
>> +               return NULL;
>> +       }
>>
>>          ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>>          if (!ctx)
>>                  return NULL;
>>
>> -       if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
>> +       key = snp_get_vmpck(snp_dev);
>> +       if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
>>                  pr_err("SNP: crypto init failed\n");
>>                  kfree(ctx);
>>                  return NULL;
>> @@ -586,7 +604,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>>          mutex_lock(&snp_dev->cmd_mutex);
>>
>>          /* Check if the VMPCK is not empty */
>> -       if (is_vmpck_empty(snp_dev)) {
>> +       if (snp_is_vmpck_empty(snp_dev)) {
>>                  dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
>>                  mutex_unlock(&snp_dev->cmd_mutex);
>>                  return -ENOTTY;
>> @@ -656,32 +674,14 @@ static const struct file_operations snp_guest_fops = {
>>          .unlocked_ioctl = snp_guest_ioctl,
>>   };
>>
>> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
>> +bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
>>   {
>> -       u8 *key = NULL;
>> +       if (WARN_ON(vmpck_id > 3))
>> +               return false;
> 
> The vmpck_id is an int for some reason, so < 0 is also a problem. Can
> we not use unsigned int?
> 
>>
>> -       switch (id) {
>> -       case 0:
>> -               *seqno = &layout->os_area.msg_seqno_0;
>> -               key = layout->vmpck0;
>> -               break;
>> -       case 1:
>> -               *seqno = &layout->os_area.msg_seqno_1;
>> -               key = layout->vmpck1;
>> -               break;
>> -       case 2:
>> -               *seqno = &layout->os_area.msg_seqno_2;
>> -               key = layout->vmpck2;
>> -               break;
>> -       case 3:
>> -               *seqno = &layout->os_area.msg_seqno_3;
>> -               key = layout->vmpck3;
>> -               break;
>> -       default:
>> -               break;
>> -       }
>> +       dev->vmpck_id = vmpck_id;
>>
>> -       return key;
>> +       return true;
>>   }
>>
>>   static int __init sev_guest_probe(struct platform_device *pdev)
>> @@ -713,14 +713,14 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>                  goto e_unmap;
>>
>>          ret = -EINVAL;
>> -       snp_dev->vmpck = get_vmpck(vmpck_id, layout, &snp_dev->os_area_msg_seqno);
>> -       if (!snp_dev->vmpck) {
>> +       snp_dev->layout = layout;
>> +       if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
>>                  dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
>>                  goto e_unmap;
>>          }
>>
>>          /* Verify that VMPCK is not zero. */
>> -       if (is_vmpck_empty(snp_dev)) {
>> +       if (snp_is_vmpck_empty(snp_dev)) {
>>                  dev_err(dev, "vmpck id %d is null\n", vmpck_id);
>>                  goto e_unmap;
>>          }
>> @@ -728,7 +728,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>          mutex_init(&snp_dev->cmd_mutex);
>>          platform_set_drvdata(pdev, snp_dev);
>>          snp_dev->dev = dev;
>> -       snp_dev->layout = layout;
>>
>>          /* Allocate the shared page used for the request and response message. */
>>          snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
>> @@ -744,7 +743,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>                  goto e_free_response;
>>
>>          ret = -EIO;
>> -       snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
>> +       snp_dev->ctx = snp_init_crypto(snp_dev);
>>          if (!snp_dev->ctx)
>>                  goto e_free_cert_data;
>>
>> --
>> 2.34.1
>>
> 
> 

