Return-Path: <kvm+bounces-365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A981B7DEC56
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 355211F2249F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0E546B3;
	Thu,  2 Nov 2023 05:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n4T13gB1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CEF1FDB
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:36:58 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80027112;
	Wed,  1 Nov 2023 22:36:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3dHqqaANL/hjN893dTL47gKVPfEUhu4GHUhJY9AMoDf5VQOMofjI/9SqdJk5Kl/g9+6RrK1COBxZXgFsOW3aV9RSjOBJz9QJOWPchOc2vRWUeszdqc2wj+PWLHn1B//3VpMKoAPoGY8c2tBkpG6DXwTViqEiwrF9cY2QXOy20DhTu4hr3im5xG8NKQoix8SfYfaEbeyh5UiKiwYiYwR3r9tQVEU0x8TchrTQ5uoj0r5Vo7CgTtexLSVi1FUN26ff+b/gmyt0IH3LbW+7J6c1PRAvEA4UNb9Bm5qCzmSUhEAluXRD7L8epama3kdtv+shnA0RCjlDcgWDln/M6KqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kl3TXlO8JkmT5hdOkzsd6YwiudfH7D3pmYlY2sr7ccg=;
 b=NkOpdAWC1EmvaTZCVhp9alXiDav4i/G0MpK8mbgNm/EA+TWBQBQknj19bzZ3u8XA+p6KxkJ5RFrFanvk8e9VLma60+tuSNEffSl+oc0SVqaDqpZiWJaWXYrUGeW3n6zWZvsk2b753VKk7D412FlIj9IZdVr3aTe7lXpBZfzJOREmAvXTiUuZG08cM+Paojs5ALUw+lgQj9J0JF1wjlOX2wkjHPfLlr1PAvTwxtxduMYDOblULSPgZAzNOikdyj+jI+CK5sFtN/yVxZyR4dHpnMgv/X2Nk/Lon+LxNkKVOCikx07P0AXezTKrdu/lVvW5ClJv4+Rc7Ty8aJGl/ZU19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kl3TXlO8JkmT5hdOkzsd6YwiudfH7D3pmYlY2sr7ccg=;
 b=n4T13gB1+SkWcNElFe4kJseqSVTyVSXyk5OsGaw6zzN5K5YiHvmu1MDxAfmfW7e4cMc368aWYp99szhsrPA09maptC6sD5jMdkryX9vrUg78nqWrxy4yGE2B+KAYvwCXCxDXwGJO2SCv2CP3Spl/FfUdxexO+L2btkn7GHyk45s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Thu, 2 Nov
 2023 05:36:51 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:36:51 +0000
Message-ID: <60e5b46c-7e4b-44bb-a76f-a4b30b154d4a@amd.com>
Date: Thu, 2 Nov 2023 11:06:40 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
 <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0163.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 0353618b-cbd3-4969-67e8-08dbdb65b6d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yahw6ECp0cGeyIWLNojX0XAL1wmR864xAh0wdjffIi9ZI4xig7u/bTUknWkkrXIvZeSX/fwFOYXp10e4UFsHi5zR5Bq/AeEvVjuuiJ/oKb5pZ9fDTeF9Ldj00GMIy6xoU76d9asfHNrBTwg6W9fNpfrl9a9ojr02aau8abCjoXhnIC4Tg2BmHDEcG5qJ+dHOtkzEjHi9gKAU0PWmrYSP8oOZdlQDI/sQ9TxcLfc7qXKi6MzSOstP5QY1gFvbTLTjieVoxDtkqHXmnW2xC6HaX72jPAYSzppcqBeRNArTXV0malr+MTTxR+DeGxFS/iV184lxO0tucjiEE1RM3FA3ToOXkFdLfVmx8myzXMIPqAlNZ/kZHWwJv+S9Xc62ltALYjaPlwd9oQz8u4Dj9PZNI4bylXOWveakIZoNMnHSXC6TV7v3Ar3hZx6dWbmq1tXJhsFUL7ryCj5O+tOjX/mRC2FHhFqZa8Bi/PpwjyOLUgrrIq//RjXkJ5aCDjiCVjYM9UgzGSh6EyX6ic45Pr0OVnAlSh2Xcdx8s4DxBHsH4+VBDdQIQ563XdtiNafAPzX3FJWokXO0IE0ZkAPKITfti64a307vH2mbITAOJj98zpKcBHCfMyDB369AfJID99psEcywuoCN+tXM7mP2R8wdOQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(39860400002)(376002)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(30864003)(3450700001)(7416002)(5660300002)(53546011)(36756003)(26005)(6506007)(6512007)(31696002)(2616005)(6666004)(38100700002)(83380400001)(2906002)(6486002)(478600001)(110136005)(41300700001)(66556008)(316002)(66946007)(66476007)(31686004)(4326008)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXdFaFp1cTF0QnhlSTAxSkVxTUZHVVpzRHBvN3BWOUV0dDFyNktFOEEwQ2gv?=
 =?utf-8?B?eTMrOVh1NTY4aFRCL2U4ajlRN21KT1lTREVpRFFaQUFCKzc1Z2M4UU1KRmVH?=
 =?utf-8?B?Y29UVURCK3N2TnVWQUZlL2wwdGEraVMxSjJPU2F5Ny82L0h4MjlZYnczZmcv?=
 =?utf-8?B?RzVoSmdrbUFoL0k3TVZoOVZwc055THVDS2E2MktrQnZxdGJWRzcrVmNZZlBa?=
 =?utf-8?B?eWtDVnFCN1ZpazMvUlREZkdNbVRxc24xenhSemdya0xYSXFGMjJNc0JJak00?=
 =?utf-8?B?SjBKaCtTcnpzcGFmV05HbWd4Q09PdHlLbC9VR2YrNExQV3FGeEJZZk1WTmxF?=
 =?utf-8?B?UnJDU2N0MW9oRUVTR3kzZ2x4N1ZuTUdHUUE1YlJMYlpIS3I0aFpiMi8xUC82?=
 =?utf-8?B?cnMwQ0hQTGNvUmszTWNNTmYzNEUzTjdqUnZtUW9BRHRVanNCYVNaMUdkNjZF?=
 =?utf-8?B?ZkZabHpOQWI2SEZxVmpnM3B5NEo0dWVja1pvOUhyOVRkdFJSQ2dQa0VPaVQ5?=
 =?utf-8?B?UW1NVExMeEsrYTNwWkVYdGJTQ0lZa0UvSnMvTkNJRjZqVlJyU0dzb3N3VzFh?=
 =?utf-8?B?OXRhendIWVV4aEIvWUdTWEtsZHFHeEFja2s5VXNrcGVYdDU2NmRaTnlvWE8v?=
 =?utf-8?B?WEpXem5vK21PQm91V0pEa3JodnlocW9FcElRRjNzZXhVdWtQY3RyQzRJYzhn?=
 =?utf-8?B?ZHNFOGR4WkFQZ0xlT0dpQkprVldoRlNZU2VRb2xFZDc4RmZuZHVYLzFkQUNM?=
 =?utf-8?B?bUQzVWZHSDdta1V2SE9zOVVwWWdWaXlhcSszTmg0Z0dzU0kxWEJTNXlORGhD?=
 =?utf-8?B?TUFmZkMvSzBsZ2lNWFNPcEQzUEpKMUpBUkhZL2pLbnptWTA2S0ZtV01MRFpH?=
 =?utf-8?B?ZnFwM1hTbkRvaWc3T0loM3pueFpUdityOGdNYVhGeTJLdytlelh1ZkVjZjNU?=
 =?utf-8?B?M0pmeVhQUjNCTzl1ZFU3UDN4Z3dacXJoRHRQaVhnMkMyMlRIcll1ZW1Uc1FC?=
 =?utf-8?B?VGROK3lQc3l1NW9WMFRUQlBCRTZLRHErL2dxeWRsNy9PcDI3RVpsekdNemtl?=
 =?utf-8?B?L3Vja0trVTg0Q2RhamZMREo3QitJM0dFQ1pFdGRCcHYzQWpHaFBYQkQwQmMw?=
 =?utf-8?B?VGdHSUVGdTJXSGZkbVN1ZGREV3hobWE5NHhTdWlONGl5YlNNR0plZHpFejF0?=
 =?utf-8?B?Wnh2NVU3VG1KOXFDN1pWTFBJRVBjdWNZNDFlZUFwc2ZTSlV6SzFYQUhDL3RM?=
 =?utf-8?B?M1dUamtNREZZQTJyN09CK1dXNzF4SjNXUEVwRG5iWE8zOFNWQlJoS0lXelBt?=
 =?utf-8?B?NExwQmJSRnMzc2NXSm9FZ093YVIxaHdYZjFUZGZnMjVlV1g4YXcxL3Zha2Vw?=
 =?utf-8?B?YVFET3NWS21MbUFaMjNpQnQxTnNaSWRBY1I1YnJRdUhhcmZLM3lud2NMRXF6?=
 =?utf-8?B?YTN4U2V6UVUzRW1NTFo5U3dabTNpdUdaSG8xL3pXZWdpVFFVV09aM2EwdXlt?=
 =?utf-8?B?SDVOVVFHR2RPWFN2MmlGMm1ZaElyR1lmY2wxRFlkbjZpZjZuYmY0WW9Idmkv?=
 =?utf-8?B?RDVvK0ZRdXQ0VDJNc0dUNko3UFBremxiMk0yWnVGUnQ3eWJwWUhCY1puZjk5?=
 =?utf-8?B?QXNHUm9iY3BSUXpkTHZPQUEvUVZkZHFjUHpCUFJjWW40WGJrU09MNGxqMWt0?=
 =?utf-8?B?cXV5WklrSVFlQXc3L2xmazB6S2oxUlc5blJ1djd2aW16ak9NUGV4RDRHWWhN?=
 =?utf-8?B?a0hPZ2JBR2hvRk1GMjhWOFlBTlFhbVZ5SWJWempYckk2a21aR0ViTy9KVHZ0?=
 =?utf-8?B?L3k3YkdGUGVCQ3E5eS9BYjgwSWJFODFLQjQ3UUdlOWZxNmQ0M2FSZVlTMnZW?=
 =?utf-8?B?d3YwZ1dUaytzcUlYUDBTL05jMm1LZWpRNzUrdDg5cnc1R2FMYkJpelhkRXFB?=
 =?utf-8?B?Rmd4WDA2TlhYMmZrV1VUVGVhcnpoU25tTHlQZkZFMmQ5Y0RkS3lyUjZLeCtz?=
 =?utf-8?B?dTZiSlBSR0xtYVRObXlUZWFsQkcyU3JYZ1ZiYWd4QmNMazZDMkFvY3FmUXBq?=
 =?utf-8?B?bnZzMVY4UStSMThRYTBPWEpuZlFuMG93WkJYY0hWSTdBM1c4N1lQWDBrVk40?=
 =?utf-8?Q?g86q80N9ldBK0p7QAFKYF53MG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0353618b-cbd3-4969-67e8-08dbdb65b6d5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:36:51.1991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PM78wfLS37vMPMqTJUlgJ1+V4EkgB/wIEguQCcFtB2EIsLcg/lXg9ZnWW2efeRleFHjlST+GRSn9S64WS5M04A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440

On 10/31/2023 1:56 AM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
>> guest to securely use RDTSC/RDTSCP instructions as the parameters
>> being used cannot be changed by hypervisor once the guest is launched.
>>
>> During the boot-up of the secondary cpus, SecureTSC enabled guests
>> need to query TSC info from AMD Security Processor. This communication
>> channel is encrypted between the AMD Security Processor and the guest,
>> the hypervisor is just the conduit to deliver the guest messages to
>> the AMD Security Processor. Each message is protected with an
>> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
>> Guest messages to communicate with the PSP.
> 
> Add to this commit message that you're using the enc_init hook to perform some Secure TSC initialization and why you have to do that.

Sure, will add.
 
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/coco/core.c             |  3 ++
>>   arch/x86/include/asm/sev-guest.h | 18 +++++++
>>   arch/x86/include/asm/sev.h       |  2 +
>>   arch/x86/include/asm/svm.h       |  6 ++-
>>   arch/x86/kernel/sev.c            | 82 ++++++++++++++++++++++++++++++++
>>   arch/x86/mm/mem_encrypt_amd.c    |  6 +++
>>   include/linux/cc_platform.h      |  8 ++++
>>   7 files changed, 123 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
>> index eeec9986570e..5d5d4d03c543 100644
>> --- a/arch/x86/coco/core.c
>> +++ b/arch/x86/coco/core.c
>> @@ -89,6 +89,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>>       case CC_ATTR_GUEST_SEV_SNP:
>>           return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>>   +    case CC_ATTR_GUEST_SECURE_TSC:
>> +        return sev_status & MSR_AMD64_SNP_SECURE_TSC;
>> +
>>       default:
>>           return false;
>>       }
>> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
>> index e6f94208173d..58739173eba9 100644
>> --- a/arch/x86/include/asm/sev-guest.h
>> +++ b/arch/x86/include/asm/sev-guest.h
>> @@ -39,6 +39,8 @@ enum msg_type {
>>       SNP_MSG_ABSORB_RSP,
>>       SNP_MSG_VMRK_REQ,
>>       SNP_MSG_VMRK_RSP,
>> +    SNP_MSG_TSC_INFO_REQ = 17,
>> +    SNP_MSG_TSC_INFO_RSP,
>>         SNP_MSG_TYPE_MAX
>>   };
>> @@ -111,6 +113,22 @@ struct snp_guest_req {
>>       u8 msg_type;
>>   };
>>   +struct snp_tsc_info_req {
>> +#define SNP_TSC_INFO_REQ_SZ 128
> 
> Please move this to before the struct definition.
> 
>> +    /* Must be zero filled */
>> +    u8 rsvd[SNP_TSC_INFO_REQ_SZ];
>> +} __packed;
>> +
>> +struct snp_tsc_info_resp {
>> +    /* Status of TSC_INFO message */
>> +    u32 status;
>> +    u32 rsvd1;
>> +    u64 tsc_scale;
>> +    u64 tsc_offset;
>> +    u32 tsc_factor;
>> +    u8 rsvd2[100];
>> +} __packed;
>> +
>>   int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
>>   int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
>>                  struct snp_guest_request_ioctl *rio);
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 783150458864..038a5a15d937 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -200,6 +200,7 @@ void __init __noreturn snp_abort(void);
>>   void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>>   u64 snp_get_unsupported_features(u64 status);
>>   u64 sev_get_status(void);
>> +void __init snp_secure_tsc_prepare(void);
>>   #else
>>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>   static inline void sev_es_ist_exit(void) { }
>> @@ -223,6 +224,7 @@ static inline void snp_abort(void) { }
>>   static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>>   static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>>   static inline u64 sev_get_status(void) { return 0; }
>> +static inline void __init snp_secure_tsc_prepare(void) { }
>>   #endif
>>     #endif
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 3ac0ffc4f3e2..ee35c0488f56 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -414,7 +414,9 @@ struct sev_es_save_area {
>>       u8 reserved_0x298[80];
>>       u32 pkru;
>>       u32 tsc_aux;
>> -    u8 reserved_0x2f0[24];
>> +    u64 tsc_scale;
>> +    u64 tsc_offset;
>> +    u8 reserved_0x300[8];
>>       u64 rcx;
>>       u64 rdx;
>>       u64 rbx;
>> @@ -546,7 +548,7 @@ static inline void __unused_size_checks(void)
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
>> -    BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
>> +    BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>>       BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index fb3b1feb1b84..9468809d02c7 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -76,6 +76,10 @@ static u64 sev_hv_features __ro_after_init;
>>   /* Secrets page physical address from the CC blob */
>>   static u64 secrets_pa __ro_after_init;
>>   +/* Secure TSC values read using TSC_INFO SNP Guest request */
>> +static u64 guest_tsc_scale __ro_after_init;
>> +static u64 guest_tsc_offset __ro_after_init;
> 
> s/guest_/snp_/
> 
>> +
>>   /* #VC handler runtime per-CPU data */
>>   struct sev_es_runtime_data {
>>       struct ghcb ghcb_page;
>> @@ -1393,6 +1397,78 @@ bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>>   }
>>   EXPORT_SYMBOL_GPL(snp_assign_vmpck);
>>   +static struct snp_guest_dev tsc_snp_dev __initdata;
>> +
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +    static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
>> +    struct snp_guest_request_ioctl rio;
>> +    struct snp_tsc_info_resp tsc_resp;
>> +    struct snp_tsc_info_req tsc_req;
>> +    struct snp_guest_req req;
>> +    int rc, resp_len;
>> +
>> +    /*
>> +     * The intermediate response buffer is used while decrypting the
>> +     * response payload. Make sure that it has enough space to cover the
>> +     * authtag.
>> +     */
>> +    resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
>> +    if (sizeof(buf) < resp_len)
>> +        return -EINVAL;
>> +
>> +    memset(&tsc_req, 0, sizeof(tsc_req));
>> +    memset(&req, 0, sizeof(req));
>> +    memset(&rio, 0, sizeof(rio));
>> +    memset(buf, 0, sizeof(buf));
>> +
>> +    if (!snp_assign_vmpck(&tsc_snp_dev, 0))
>> +        return -EINVAL;
>> +
>> +    /* Initialize the PSP channel to send snp messages */
>> +    if (snp_setup_psp_messaging(&tsc_snp_dev))
>> +        sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> 
> This should just return the non-zero return code from snp_setup_psp_messaging(), no?
> 
>     rc = snp_setup_psp_messaging(&tsc_snp_dev);
>     if (rc)
>         return rc;

Yes, that will also have the same behaviour, snp_get_tsc_info() will send the termination request. 

>> +
>> +    req.msg_version = MSG_HDR_VER;
>> +    req.msg_type = SNP_MSG_TSC_INFO_REQ;
>> +    req.vmpck_id = tsc_snp_dev.vmpck_id;
>> +    req.req_buf = &tsc_req;
>> +    req.req_sz = sizeof(tsc_req);
>> +    req.resp_buf = buf;
>> +    req.resp_sz = resp_len;
>> +    req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +    rc = snp_send_guest_request(&tsc_snp_dev, &req, &rio);
> 
> Aren't you supposed to hold a mutex before calling this since it will eventually call the message sequence number functions?

Yes, I will need to otherwise lockdep will complain. This is being called from boot processor, so there is no parallel execution.

>> +    if (rc)
>> +        goto err_req;
>> +
>> +    memcpy(&tsc_resp, buf, sizeof(tsc_resp));
>> +    pr_debug("%s: Valid response status %x scale %llx offset %llx factor %x\n",
>> +         __func__, tsc_resp.status, tsc_resp.tsc_scale, tsc_resp.tsc_offset,
>> +         tsc_resp.tsc_factor);
>> +
>> +    guest_tsc_scale = tsc_resp.tsc_scale;
>> +    guest_tsc_offset = tsc_resp.tsc_offset;
>> +
>> +err_req:
>> +    /* The response buffer contains the sensitive data, explicitly clear it. */
>> +    memzero_explicit(buf, sizeof(buf));
>> +    memzero_explicit(&tsc_resp, sizeof(tsc_resp));
>> +    memzero_explicit(&req, sizeof(req));
>> +
>> +    return rc;
>> +}
>> +
>> +void __init snp_secure_tsc_prepare(void)
>> +{
>> +    if (!cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>> +        return;
>> +
>> +    if (snp_get_tsc_info())
>> +        sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
> 
> How about using SEV_TERM_SET_LINUX and a new GHCB_TERM_SECURE_TSC_INFO.

Yes, we can do that, I remember you had said this will required GHCB spec change and then thought of sticking with the current return code.

> 
>> +
>> +    pr_debug("SecureTSC enabled\n");
>> +}
>> +
>>   static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
>>   {
>>       struct sev_es_save_area *cur_vmsa, *vmsa;
>> @@ -1493,6 +1569,12 @@ static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
>>       vmsa->vmpl        = 0;
>>       vmsa->sev_features    = sev_status >> 2;
>>   +    /* Setting Secure TSC parameters */
>> +    if (cc_platform_has(CC_ATTR_GUEST_SECURE_TSC)) {
>> +        vmsa->tsc_scale = guest_tsc_scale;
>> +        vmsa->tsc_offset = guest_tsc_offset;
>> +    }
>> +
>>       /* Switch the page over to a VMSA page now that it is initialized */
>>       ret = snp_set_vmsa(vmsa, true);
>>       if (ret) {
>> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
>> index 6faea41e99b6..9935fc506e99 100644
>> --- a/arch/x86/mm/mem_encrypt_amd.c
>> +++ b/arch/x86/mm/mem_encrypt_amd.c
>> @@ -215,6 +215,11 @@ void __init sme_map_bootdata(char *real_mode_data)
>>       __sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
>>   }
>>   +void __init amd_enc_init(void)
>> +{
>> +    snp_secure_tsc_prepare();
>> +}
>> +
>>   void __init sev_setup_arch(void)
>>   {
>>       phys_addr_t total_mem = memblock_phys_mem_size();
>> @@ -502,6 +507,7 @@ void __init sme_early_init(void)
>>       x86_platform.guest.enc_status_change_finish  = amd_enc_status_change_finish;
>>       x86_platform.guest.enc_tlb_flush_required    = amd_enc_tlb_flush_required;
>>       x86_platform.guest.enc_cache_flush_required  = amd_enc_cache_flush_required;
>> +    x86_platform.guest.enc_init                  = amd_enc_init;
>>         /*
>>        * AMD-SEV-ES intercepts the RDMSR to read the X2APIC ID in the

Regards
Nikunj


