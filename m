Return-Path: <kvm+bounces-359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 065267DEB97
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D21C31C20EB0
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ABDE1878;
	Thu,  2 Nov 2023 04:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e8pXpnOQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AAF1851
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 04:04:11 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BED187;
	Wed,  1 Nov 2023 21:03:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yj2o1f+uLCjl9ph8PZUjmabjoTT8gHmodZoOJM1RHGmU3TsRg9HQW7gHWGmVmskUYsHXwLN9QeCXdxKbB1pE/x0s6xfBOeRHueouVM57F4mRFWTgJ8WmyS9PN6YHdPeplMmDGV3YhiX0vghs29aTuvPnrlFiZFYnq3kIBpG2qhWgsI5FUqhS82FgGIfvd2ABRkXb9Z2zMc+2meWUfRJPDiv1kQZamIbWud1TpC1KhNyLbxJvzsvmzeuGg6FGaamh5uOete0wIil9wD2sCoUvxwIqW0w0E3uwEA0wgMgXmYIFM6jzab1psJt3+3vg1XQulK1aVOEalhR9q/K6j4ABbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/JFLHYdc4VTMc8d71TEizYAARPKPZGYGo6DDT0AViM=;
 b=C4Z2TiJpd6Ccgy5jZ08szjZ5timbIJnmdKUcOPMxR3U4gJKjciMFg1IHOKW25HA5Aw42yfGXBVTooxnEKd07ZKivxUn1k6Ze02EXKPyjox/g3lyV8KjY3N+Hz+qJ0yw2SLFqBoqS0ucqZdfKBRVTzRF1K947Ll5KZfzXibao9VqTP/7Olm7xeyN4uzIh17x6B3Hfc1+iU0FTyA9oBK0UQIwtYVghhfOthNRFRtx/+Qxio2eLP2wiTvK/HCnCrQzkU8p928tVaVCw+TJjXO5zFhJk5rWLovIL+wB53Du5h8BSVdyQr3xN1wtAl02Ojfk4VLY065YKs/KdWCGfckPEsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/JFLHYdc4VTMc8d71TEizYAARPKPZGYGo6DDT0AViM=;
 b=e8pXpnOQsXiw3AuUWyS0B1n+kfa3l71RN/Jl04rIlJozyAvxD9zE6wpWpwMuVJ4PMsTRK1DgUlNEKT8ucZfd0Ymsj04ZaiDYnIPpAVZ0GEtALwqAghObRUs/HUwltuj1P2mEvhRz58a8Os5GqD+OMEH+ZJ7NpLdsTKMzkpel+0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB5514.namprd12.prod.outlook.com (2603:10b6:610:62::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.19; Thu, 2 Nov 2023 04:03:54 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 04:03:54 +0000
Message-ID: <5b005b81-792a-4338-8085-e064c273f887@amd.com>
Date: Thu, 2 Nov 2023 09:33:44 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 05/14] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-6-nikunj@amd.com>
 <CAAH4kHY_sM0DTL+EVz3GNDq1q_5S4FH1Ku9EMV0HOzFAY1s4QQ@mail.gmail.com>
 <57b904e1-9a17-9203-e275-4b5a31ca8a71@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <57b904e1-9a17-9203-e275-4b5a31ca8a71@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0082.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB5514:EE_
X-MS-Office365-Filtering-Correlation-Id: bc6a22aa-9f55-445e-e22a-08dbdb58baf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QWWycnkiBQgvC88kHqaMV6Lt35muatJ9HKnpnJ9L5Efxc7yXtgqz5sU72Gcwu1Q4PztlCOIyA1gW8Ui2vkhzJd2+Rd7YH6Lx63ni7j/Or25lRaUftRMpqxpGgTryCzoTYiQ2T9nqJnZ5f1oxbpgOlkTlPTq7g/mZD1KvKSqYo7QpGTUvhzRuVd3L9KExBsNztxMoBrnDPAGE+NoP4UMjPwjWh1Tja1KgQExgofrXuxsPZWvH6TlyfO3XPaJUrn5ppLO9NgNRaadnOymEq5mexKMSIgF/M8j+8pwKi5YVmxTCGW6vSw/+PMNfSnAiQetMFvdyJrFfQHIF6+ulKLweJFxDJHr4VW/RQjdiTmZkb9wdgyt2Bd9wtgGJ9LqE1t0Z8E/mZqP4CJNb0rq0dMkl0HvPIITTgejqFe8nYtwb5cfeTVRnUKlJ/kv5riG1TrDHhTpJKEWANKzj9Ni3YZXgfqwIJJ8ZGU5jlBMy/tHWaxURuDzOevzauI1yK3K+c/Y90cJFFx/UpXP9LRuzLWvNADZtjZ60Xe54igkqHSYiqm7ZHMbI6F19yAYFLVonz7LnNbQnJfNHPfxQVPr8WY23qSy5Pmz79sFT5bd58C+PR0KGBKDhGTsz1zanf3qgYp/15NyZX9dt1HLI7ySFx3PaYg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6506007)(31686004)(8676002)(2906002)(8936002)(4326008)(4744005)(3450700001)(6666004)(478600001)(41300700001)(6486002)(66476007)(66556008)(110136005)(7416002)(66946007)(316002)(5660300002)(53546011)(2616005)(26005)(83380400001)(6512007)(31696002)(36756003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGpHbmd2a2YreGdYalhYRmNmd2hESERxRVlCMkg2MGc1aE44MFAvV2FqNSt1?=
 =?utf-8?B?QmJIK0lZN1M4Ymhqd0xwSFJlRC9lbkVTb1lnU3ZvT3llVkRQNEhhWmFGbFZ3?=
 =?utf-8?B?R3pjNlMzamd3UGk2QnhuRFBFeEdHVUsySnBrTzlMTjFrRGl3TzdnTGhobFhY?=
 =?utf-8?B?aTBvNEk0UkE5NGJzRlo3a0xNRmtJM25NZVZyVmNqK1loaWF3Z2lOUmY5MitN?=
 =?utf-8?B?dEgrekgvaEhhZ2dIcG1OMjlSdU0wNmd6elpkQldxRU5DcjM0MFBjYTVyV05o?=
 =?utf-8?B?bnFHNzBXR0RpWjBrbTErUk9lM0kxZHJqZ3BtdU5zc1J4SUoxYjFTM3A4SHNw?=
 =?utf-8?B?TU5ZelJ0aC95YlhzUHRYZTM4K0o0TU1CVkg1L3g4V2hxejcwcmlrTUJrY3A0?=
 =?utf-8?B?TEtDUjVsN09YeHNCYzlFeTNoSDNkNnM3YnpwaVlwK2V0SHladkdIWDlBeGVT?=
 =?utf-8?B?V2wrT25SeURvYjNWaUhRWXBsTzBpbUh4QmRERk9XRklXeThBMkhIVUh6ZDFk?=
 =?utf-8?B?TTAvanpsd1daTXVsQ2tPL1RPaDZjeGkxM1dLcDJaSDY0bnJpTDVST2V3ckFM?=
 =?utf-8?B?UkxBb0NYejY5cmw3OE1XdjJFNE82ek5MWGNoaTJUcSt0WVhUbG1CdERGQVBw?=
 =?utf-8?B?aTNZSlhubkd1NSt3SHFGblRiRW9weGg2QTNrNm5sdFhvMDljSGlhdnBtOU0r?=
 =?utf-8?B?QTJZVTZjVjZ1Y25HWWNqc1BwRW1sNjE0dGlJdkVTcTQ4NC9UbXNFVkhDRzhO?=
 =?utf-8?B?VDZETGw0RXV5RSthWk9oT0dMcnZsTzlQQ2JGQkVLbzRjTkl5NG5SVk8rOER1?=
 =?utf-8?B?ckJBTEw5UkcwbUtQSlFYcHFTRGNQbkpTbEtmVEhtOWp3UTJLTFArSFk0RjRx?=
 =?utf-8?B?QmgvSW91S3NBZk1SUFM0ZXdGdDh5MVIyZkZxVm1Ja3haZk02c0xXYU1rSEVq?=
 =?utf-8?B?SFV4R3NBdjV5QWNuTllpbGRua2xvRGUxMEcwUnpkZkZLTTZMbTNTT0dpNmU1?=
 =?utf-8?B?Ni8rU1pvMC9aQjkxWTB4eDRqSnZjQmVFTlVXc1FKVlBjQWVIYm5hUDF0Z0dG?=
 =?utf-8?B?NDBMZU5mRWRmWjRuZjFvejJWcWRaVFVWTnlLS2VtUTJ0VGlRQzNzWUNBQ3JT?=
 =?utf-8?B?Tnh5ZE02Rmo4WnN5THliWkVVT3NCZEpYTVFCRTVYenZ1V3Y1MGY0S0syckRv?=
 =?utf-8?B?QmZnYWlQTEtDM1FQd2NkNTdLVWZxNENFeklPbGRubjRaaGJTZHBINFhKZmcy?=
 =?utf-8?B?eG14YllCMVhkVEVodGdVVjRiRzRZN3BSRm0vRjNWOXFQUWxBdUdOU1Q2ZEZh?=
 =?utf-8?B?OGl3a2grTTNRYWR6Y2dZZjBBUHJ6TnhmZGJiTFE5dGpWNEg5Z3o2d1ZEN1ZL?=
 =?utf-8?B?dm15aWgrVnRwZjNMYi8vM1hTK0k1NEwwMWV6WllwK0NLb2E0VGdBYnN0L0or?=
 =?utf-8?B?QmFkd1hldTR6N1VPSmFTRlFqbXhSWW9KT0JUQUVEdVBKaGp1bnV2eEpEM2Y4?=
 =?utf-8?B?Y2thQ1BQM1k5MTdVSG5kNm55K0ZIRVo4K3NWUHJ3QlhhUnFUMFNIcUxZb2R2?=
 =?utf-8?B?cFhqc0RRMVVRTmJaMVhPMjVDOVJ3OEVoUnVBenMrRGRaUCtiUlR5NU9pT05G?=
 =?utf-8?B?MlNVVkkrVkpaTUVHeUNiTG1zV0JDUFIyVnBVSVlUWkhFVGtHWWFmTXBQaDR3?=
 =?utf-8?B?dWkwOW9VVUVXMndHRThCSDVwOHk4bUl3Y1hQeFYzM0ZIN1NOTzJiYjJndjN1?=
 =?utf-8?B?dmc5aG83MXVrMnZNNk02eTNFdlpNRkhRYlY3UWpWcHo5MTg0RkpCRVh2SXZN?=
 =?utf-8?B?ai9UWjhGSG5nRXNKYzNjRXpQS0NVSmNGS2xCOU5zQnJ5OG5aZWRweWJhdXhp?=
 =?utf-8?B?dko4TlFSSkE4Mng5ZXFmRWtqK01YcnoyS1NXaXQvb1VHVjF1dk9lMllNR2M0?=
 =?utf-8?B?VTVmMEpacTRZWXBHL0h2bC9Rb2VHT0xsZ3JsZVVBQkdabmFxU0c3MlNzM0Z6?=
 =?utf-8?B?YTlsOGpVUHdpNmFqb3pwNWRrN2J2akNDYWkwWjhxVXoxbkZmNGtoK2ZMWkor?=
 =?utf-8?B?Vzl0ZG9seXc0ZG9ZeTJmcEEzVDJRNnpuaWFOWFFSNCsxZ0hnYi9LQytzcnN3?=
 =?utf-8?Q?1ou2mVcf54tFcNdXQKS3QN3pR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6a22aa-9f55-445e-e22a-08dbdb58baf7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 04:03:54.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6UkLklcAiw0Hf1rXlwXgWNx2yVC+ujoSSbz9pZs9zKWQ6eWQCdMXa/Ycqfu9KnAqyJm8vtAMGASEnXeLZ4c5wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5514

On 10/30/2023 10:42 PM, Tom Lendacky wrote:
> On 10/30/23 11:16, Dionna Amalie Glaze wrote:
>> On Sun, Oct 29, 2023 at 11:38 PM Nikunj A Dadhania <nikunj@amd.com> wrote:

>>> @@ -656,32 +674,14 @@ static const struct file_operations snp_guest_fops = {
>>>          .unlocked_ioctl = snp_guest_ioctl,
>>>   };
>>>
>>> -static u8 *get_vmpck(int id, struct snp_secrets_page_layout *layout, u32 **seqno)
>>> +bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
>>>   {
>>> -       u8 *key = NULL;
>>> +       if (WARN_ON(vmpck_id > 3))
>>> +               return false;
>>
>> The vmpck_id is an int for some reason, so < 0 is also a problem. Can
>> we not use unsigned int?

Yes, I will update that in my next revision,

Thanks
Nikunj


