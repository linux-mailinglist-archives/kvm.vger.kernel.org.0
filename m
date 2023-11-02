Return-Path: <kvm+bounces-363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 188957DEC28
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE55B281A4B
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AB81FCA;
	Thu,  2 Nov 2023 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uh8USihN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0211FAD
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:14:06 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B26112;
	Wed,  1 Nov 2023 22:14:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIEL+LMxlphiSpt10YdmkkBm6uDrbyDcYmO85qdu+tS90s66XpftPRBVQRwins9RFi7YUsylfoKl2okkztnRG/10s6ZVWXI8F3E2NcO9zuAdVSt1IyROqB/9sJhfUJ65sh4phPQiRiZdbvbX1MOR/yaB2fqbd86fI3z9+dKycR8GROn9bW07YxUpSVIJ0qmhQL+NSOE4Ddu52LhwsndQvvQkNQp0KJB5o0Cuj4XrsLKmXZipotTbVTn18OeNTkupFiWJBxnYF0HxsBF8FkXo0Sv/NlFCAX8Css+gGJUYEmCJ3PUxDqgVSuzOvkKIN5zmHEwqZIHRB97qMfIfDnW+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfndYPfzZygQUslXBT/Rc3FIqjXWwKnGko77wO4vt30=;
 b=iHHAnsWihdnSkaiT8bDmvEcvmEHFA0PWUsn93t4K5mfAxGj3qksxl5AbPcaBiK6J6kWoyWEc+fZmrTX6QiPmeJA9/zcET5eSmimMLKsrIve7hqEKuz7erRdJ6+vBPrZ+acFWQWq+aJbPSIdq2e4Vv9R5kuL6twxNp6Weykzzx68nIX788w8p9qKjqyCd0K5fpWKAnxvMzR9CMaBPxBbExnn/ZXhpQCfEkwJOSj/S907kDx7qGCe0e5OxRBURrsm88d34CGYNrHJK7v/OVpNio/wZg4yJZiN99JPi0t5BF3+nsA8AgEKRgSWZ6MqCM0CEwH3f5t1TeHCyf2QgcADadQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfndYPfzZygQUslXBT/Rc3FIqjXWwKnGko77wO4vt30=;
 b=uh8USihNlZAZUKKfs7O5KE5VxTTG+Oo4L/ZFP8ZFvS2gXApVUP/bqqY/GrBcTzrA+tFv9So5loYpc85Sy5bNzV+VoDAKcmQ33xiEFkf8Ytl0KYbH0HKCAMq7s1YZeCQOgbOs95l0+2fOFWDqSXwuT2Ce+BrgxC2hu+kwL9/Zwb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA1PR12MB5638.namprd12.prod.outlook.com (2603:10b6:806:229::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Thu, 2 Nov
 2023 05:13:57 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:13:56 +0000
Message-ID: <5b6f1d00-8dcd-49d8-98bc-53638ec5b43e@amd.com>
Date: Thu, 2 Nov 2023 10:43:45 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
 <CAAH4kHbceVXo_==J7K4f5kTbCYj=SQWQNDs2CAAms3vdreG7cw@mail.gmail.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHbceVXo_==J7K4f5kTbCYj=SQWQNDs2CAAms3vdreG7cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA1PR12MB5638:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e67970-6bae-4cc3-31f1-08dbdb628328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rfg2ZlfxtzV8Oxc9NzpIX6n1KkqxE1ke4LfOtDZ5UiTI7pFDWPBw8j4YAM+tusy1obbNBgfR6PtvKYOHWdZr0zcrQv34FLxXMllrO8enkT7C6d1C0el917iPzeUppKDizKVIpeEhlSMKIUidgOejXn8MPo2MH6xTvUbuNdbFDlvd/qru/Bc7vAxDd4NsP+9cXpXo4OZ8L2D93F44/Xcnj2hI8fWc2KqdHCoSc+qasKwzcBDQf/Rlwu6/gyVmm+hpAbnwtUjjiRdoutwvp9+4TO7Jh8o/yQT7uRFUWE1TtHxlSkQgGuMJDcbiHENLDI72yhCdhMl8byrpjp3SPZjsDIBS7S1bOA3nlE9GiuPUellN/2zhMxDLMHi6PU6K5OGB5ePNgFXqNY8JeIB13Qm/l3pTboHMnVer5pJIcxHZgf9WXavjq4iHUqDJ582TXKzdhxRYNNCU+ZdMfdlEAKmAiBSqNHeS7jZ/oZm1W1bGmdC19TaBp62RD0vMWL13x1Ls8o/ZTsOCIVH4I2+eEQmIJW19hKgRsmJHT/Lcgc+Kly2oxxCo7Wb6ofdHgTQj4MvxevpuTksiYi3u/WGOz6ydsHCEyb6REHHIo18CGOwB8LIfqOfmkQctCFSyMWsSteRbxLU6aQRzfEV9A6MnxFpMRQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(346002)(136003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(6486002)(478600001)(2906002)(3450700001)(36756003)(66476007)(66556008)(31696002)(66946007)(7416002)(5660300002)(26005)(41300700001)(2616005)(38100700002)(83380400001)(8936002)(8676002)(31686004)(4326008)(6506007)(6916009)(316002)(6666004)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RExQejE4MTdlL0Q4TGs2eStyRDRaQjRCMzlQT2Z4bGV2Nyt3d1k1a0Vha0Rz?=
 =?utf-8?B?QjlPcEx3NHR3MmxoQTdrLzFPZTlvY0xPSDIwclFWZVl3a1k3RTB6U08vT2lo?=
 =?utf-8?B?Yi9rTVhENS9jUjhra1A1Q2xNMysrenp2ZHhjUW04VzEvemdkbmhtSjJuR2xX?=
 =?utf-8?B?TEYrOER0bFlKR1o4ZThJcTI4blYyVEtDb1R5ZU1samRXdXJRRTlGbm50USsv?=
 =?utf-8?B?aHNRa3dCek9YT1V5MHhnNG9nRThieDVDTzRSTng1STVkd3pQUEhISFV4RnVY?=
 =?utf-8?B?K3pDS2pxV3Rva0JkajIwNXVadmYyNGxiU2pJOXBFeVVnRThjNVBEU2VtTEZI?=
 =?utf-8?B?MTdiMnA5Y1Q3YTZ6K1JmT3cwaHpqV2tlQjVPVkdudnFUSHJwTU0vcEpwSUFN?=
 =?utf-8?B?N21YU2t3YnJVcVVwNlhQRzB4Z2FNOEROY3BZdkE4NHYzeVkveUpvTU11a1FH?=
 =?utf-8?B?cURxVURKUlRrMUs0U2F2RGIwdENQaFZYSjEyaHhhdkdEdHNWeFA0MUxYc1hv?=
 =?utf-8?B?Z2VEODlwVmwrL2ZvdlRQdEMzbnp5Q3VGTENtckkxR05naE9RUVVjOTNHVEd0?=
 =?utf-8?B?Tjg4S2MxOVE0WEE3Rk1ORHAwMENJYzdRQzBQR1RNYUNUWm04KzBHYjF5QmdH?=
 =?utf-8?B?aGoxU09EU295alJKUnJyN2p2T2E1U0NkUUtXU1V3d0hUbHFkR0VtSGNtSHNi?=
 =?utf-8?B?Q1h0QWVVV0tYc1dRSlh6Y0JtTHZuN3NJTVArUnJFSTB4WGdlZGdTaVZlcHBl?=
 =?utf-8?B?K2NJMXJSL09LSnJVV0sydmVHY1lPTiszaVVmS0ZiMzNYb2xiNVcwQjJ1TVFz?=
 =?utf-8?B?dHdmNnQvY1pwaEIwOXB2SEM5ZE53K1hmT2FiekdBRWNITC9Oc040VjlHTzIy?=
 =?utf-8?B?djNDVWZFc0w1VUdmOXNzaGkzeU1uUm02YzRidkRpMGZyRHRld0dqVm5MQnBG?=
 =?utf-8?B?bjlTNGZIeVN1ZWxDcWQrNlp6aThDMlRKWW90VlRsU1JuYTFkMG5za0tnM2tk?=
 =?utf-8?B?L2MrOWhmZmpBSFJSN0NoVElzQjNuWnIvdG5qMVUrZjZ2ZmpkeDJuV2t5Ymhm?=
 =?utf-8?B?LzVPY2l0S1RXUUxGWEpYN2pXRitFSDNXNFFnd2ZRUEFpWUZUTEU1S2Nac2JD?=
 =?utf-8?B?MXNRcjFQcU4xenJMWmpnK3RTUDRodVVka2RucU93Q0hmVis1aVlhZVZ1UElE?=
 =?utf-8?B?SHFzaXFJVDgvNFFZaGw4UTVqU1hlRCtiUk1teXViaUsyMVh2aE5yRVFPajUz?=
 =?utf-8?B?YkVVOXR0L05pNW1UUTA5dEVCZjFmaE8wengzaEo3Kzg5ZmNSRzRxOEMvU2FO?=
 =?utf-8?B?N2Q2aGNyMVZEamgyOU5NNUloOXVuNVV6ZVNIdldMQW9mZHZlaGwrcnd4NlhR?=
 =?utf-8?B?L2E0VlljTHAweGR3M0JTWHpxQWpBR2RwS3hMRk1MQWppUmxBSU95UWhWZHAr?=
 =?utf-8?B?TUt2ZXRrS0FNWWhCa1RvbndyMThUamg3eWQyeEFSV0ordHl6L1p2WThuOUwz?=
 =?utf-8?B?RStPZVZJaFV0Y3l2ZElsYWdJaFZnSlJUUjBIYUlobXZ6aWFvaVcyZUJXN25o?=
 =?utf-8?B?dWplL3BDbC9sM3NrQjVhVzljOXN0dWVCNW4zUmt1dmNGeEQ1aG51L2tteklP?=
 =?utf-8?B?aG5mWDgzaFBzanIyS25iTHY1blFjVFBXWFJhQWk1b09McjM2Qys0VnRzMXJs?=
 =?utf-8?B?dWlQV1VnSWozeHRhZGx2dDViS01QVUJMajVwREROY1FaRGNiT1FVMzRtbDVQ?=
 =?utf-8?B?S2J2U1VxM0JBTmVncndZelpQbzdRNTdJdzVDQ3NXNVd1L1hKanhaSmVKVERZ?=
 =?utf-8?B?UnJUUGFVTUxpcXU5RDNUa3B0Zm1hUFd4d3hZVENhSk9tMmZGMXZiREw1RFZD?=
 =?utf-8?B?N3llUzIrQ1UrMjdBRUJxeXU5QkFremJFRllzRWZ4dWVIa1VZUVBjQk5sMmhK?=
 =?utf-8?B?dG9tb0xkR0ZUYk9qRTR1YXJEY1hFN0dSanZHd0s4T3FsMnUwaW1iY0ExS29D?=
 =?utf-8?B?bXNvcjdrU1RCdm1GWm9pR2JMaFVIWXAxNFU5UzVPOXMvQ1VCdU5SR1pMbFVY?=
 =?utf-8?B?TjVqWHJCSVlDcERmUWw1NmZ2RUtTd1dMTFRCNmY5ditkM1FGYnVYKzBkQ3VL?=
 =?utf-8?Q?GZ/V3Aoh6xPBmN9F5UHSFszTc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e67970-6bae-4cc3-31f1-08dbdb628328
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:13:56.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYtMCPXrXQJYC8tSmlRRXVcLs0dGo80mjPELTdTk/KlNEZTzr384/q8e67/ZVQwj83drtYC8//THZOlMPQmo3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5638

On 10/30/2023 10:16 PM, Dionna Amalie Glaze wrote:
> On Sun, Oct 29, 2023 at 11:38 PM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>

>> @@ -1393,6 +1397,78 @@ bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>>  }
>>  EXPORT_SYMBOL_GPL(snp_assign_vmpck);
>>
>> +static struct snp_guest_dev tsc_snp_dev __initdata;
>> +
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +       static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
>> +       struct snp_guest_request_ioctl rio;
>> +       struct snp_tsc_info_resp tsc_resp;
>> +       struct snp_tsc_info_req tsc_req;
>> +       struct snp_guest_req req;
>> +       int rc, resp_len;
>> +
>> +       /*
>> +        * The intermediate response buffer is used while decrypting the
>> +        * response payload. Make sure that it has enough space to cover the
>> +        * authtag.
>> +        */
>> +       resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
>> +       if (sizeof(buf) < resp_len)
>> +               return -EINVAL;
>> +
>> +       memset(&tsc_req, 0, sizeof(tsc_req));
>> +       memset(&req, 0, sizeof(req));
>> +       memset(&rio, 0, sizeof(rio));
>> +       memset(buf, 0, sizeof(buf));
>> +
>> +       if (!snp_assign_vmpck(&tsc_snp_dev, 0))
>> +               return -EINVAL;
>> +
> 
> I don't see a requirement for VMPL0 in the API docs. I just see "When
> a guest creates its own VMSA, it must query the PSP for information
> with the TSC_INFO message to determine the correct values to write
> into GUEST_TSC_SCALE and GUEST_TSC_OFFSET". 

The request should work irrespective of the VMPL level. 

> In that case, I don't see
> a particular use for this request in Linux. I would expect it either
> in the UEFI or in SVSM. Is this code path explicitly for direct boot
> to Linux? If so, did I miss that documentation in this patch series?

This works with UEFI boot. I havent tried this with SVSM yet.

Thanks
Nikunj

