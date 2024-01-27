Return-Path: <kvm+bounces-7268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8CE83EAEA
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 05:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11146B2119D
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 04:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE271DFF6;
	Sat, 27 Jan 2024 04:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NeVlIPJ0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DA51DFC0;
	Sat, 27 Jan 2024 04:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706328323; cv=fail; b=k9qPHnLzvRnN/FzB3RKFQimefl4LSVjvKjKA9mBWYA9tc96vuDyIPCm6iQVMJI+p+3yfp5xsKAXmDJd61m0nKStv56+5fOnDVXKW3iRH+Ojng1uGM/UmPlPNYPfvI1HtL9jcFAb9VhtGiRWixe8sLXOYnSh6lPYtZHLqNkxpruM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706328323; c=relaxed/simple;
	bh=7QyKngepn87dNXMT5TnrkkmDhiSlG67r7Qn5+m2hV3Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B/xfrL7NiPWJQIDXXT1rJdJ18P+9GRSSGHLeZCXHGqB/i50Alefj7XAeHySPOStjesoAupe0HeGmFT2ozYcgKTQKJk0jtEEgze70msH1G5oiO5P7sswYXflzXyQ2IPfjyGSSiT9KCXnMpy7yqKWH8fSKtxZmsL52AWTKeHIvPBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NeVlIPJ0; arc=fail smtp.client-ip=40.107.100.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYQPX02gOCN71K9zVxB+NjfrsnskRLevDtlAC7CHAyP5qlgxTIaCbgNB4ZNpI7TmNZc2As13vD9SXpYxliWwbMF8hRv4/IzbrkBT/ErDyLIt51QponkBZa3gizmWugXbenmIJKPkBHddIXiRPp1pX8On2tG6cq/RKyX4cZmJTkJ9pCFC0eKdOIpWZyeCnoF3N2v3w87Q6AIyt/4mLP+xC4aycwlGtQS/xAegv63BEMp4QEUEO/54ghuB0T9j/LTVW3losnRRNSKqrQcX6W9AUA3kYN9oUaMEGPIr5q2/0sxQwfnQAcX72Ef2ank0LQYH0iXnKqApZPkv0AuNbijQEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Z75SebDZnB/i/AYm/GwCwCj76wInVsGfHuY9/mshyc=;
 b=dqxh0hnzuPwp84PGVsR/MPx/uI9jJW5a61fFx+i9/OIcJr+Aldzz3bghBmfonVq4cALoJAtoXbrYdyEstwZwMb2Fz5eKjRuBV2eCrxJt5yOZ2v/p11l/Zp4LGF4O+GHTrqkXiOFkHa+y56hCJSifLhZH8rqMVeNucIL4UmBGF85QJJ8JirIVd5CToVnYrtSFh4KNkdy0SDyhPKktfm/PmP+eQ0wObPqECAJ1H0f3mc6VZAmj2t6Rt01TMcEPCJCGNchFwJOOR6xGzYiPFUWa652y2YN9vnnH55thG1icVn5v+wdgZ+lphUCOtqn2K9MbKm7ETDPJxoJX+XN+xTKu1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Z75SebDZnB/i/AYm/GwCwCj76wInVsGfHuY9/mshyc=;
 b=NeVlIPJ04yMOTVyda5cO0VDr8q2q+DUhOMKKtOgcmpGq5EpUg/DEmT3ochpiVhFObfbHPuRVW241CtxerG6ODiexvaW8jNWQCJsnKodo3oq7tML1nMZjIWxCU46QdXMxx4ZKtJ16akMQ+x8odeO/M/nThYtL0/Cu7grT53yCqtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 04:05:16 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Sat, 27 Jan 2024
 04:05:16 +0000
Message-ID: <ff963228-56d3-4aa0-978d-3cc843b6af2e@amd.com>
Date: Sat, 27 Jan 2024 09:35:06 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <529ca51b-e698-5aa6-5af7-db2d00880559@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <529ca51b-e698-5aa6-5af7-db2d00880559@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0186.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: eaf006f6-6afd-4405-055d-08dc1eed2b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	In1HIT5+pwK3tBwVuomzY7LvzR14NjDLbabogl5GoG+xve70fWRWX94f7rJdZPLGWFg9GLVSAw17zzDFUCxLgEr87gmoU0ChJS8scs1JFfFClVvFIi2ECpghrvnWMIQ/Orcx7HLzWEe099cFxgagaLYIyq9W7kfjLbrUWdRbHMk2VM7yWzL/NOn3VUCb9fMGwT3KHcRYlefdNlgZ27a4699l2sPsSEEJBq3JUVD0vkqeFcw95yLymHDh4RAGsoxg/5OBPVjhmo7XJkXmFvGQov5lcQvcUiSnc9ywEYFut5FXiiLbwAaI6WN0//6tBmEqs342diHUfLxs+cqSpT2doOaUNGmfOssheEDOTpm0OwXx65RgSaRTlj5WWXvRM+sHCqcX+NBvFkwB+C713qBohWwtP0qG3dNZqLvE/0ESpjZ3gGvZSgPfFMNIuTaP8oBlUE90mjZWTy9sS+EUtwpu1hJqGuIquNTAH/E6MxYh29qLJibfKbQmbKiDYnUMXKN1xh1lfzgdA4bAjURshOTynf5xgAu6Dtcvhu+hA4g1Z7GDlBR1IrAFsbjv1vYcUbXMoOybwhxJelk3G6DQGRWPf1dNQ3PBmNjyw+3s23uMiL7YFffgE5AHX81xYvtYsPUfnPR58GA+0/6Qh/1Hdr4LUA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(396003)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(8676002)(4326008)(8936002)(7416002)(5660300002)(38100700002)(6512007)(53546011)(6506007)(2616005)(6666004)(66556008)(66476007)(66946007)(316002)(83380400001)(31696002)(36756003)(3450700001)(2906002)(6486002)(31686004)(478600001)(26005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXdzYnIybmpicWNZM25TL2I0eGMxZVFQVTc0eEhUYXNiajVCUjcvV0tnVlRF?=
 =?utf-8?B?NzVveTFzaU1rcVlnWGdJcWFwS1Q2bmFkUWF6M1RHTnR1QjNIc0xsUk0rTU1y?=
 =?utf-8?B?MHFyY0JIc3J0azIwbzRvM1ZlM3pmS2loVFI0WUtnaXVDZ3JsNEhoN016WFE1?=
 =?utf-8?B?Ni94SDBLK3FrOGRUZjNlbFdPV25UUzEyUlJ0cW9kMWszMnQyYiszYUttSVJh?=
 =?utf-8?B?NU9yRkdLMmRhcjFBL1NpUTBRMGJHZWxpcVErRHZZT0trK0tkRXZ2WHlJcDRM?=
 =?utf-8?B?MVJyZTBxTThCK3h6aW9OZFNWcUFZeHdyZlhCM1BQVDhFeWd1UVdWQlo1Nlpo?=
 =?utf-8?B?TjQ0RHg0NVk2bnBJaHd4eE1KemxMS2VpckRQVTg0QmJvOHJxN0hBZC93L1Ry?=
 =?utf-8?B?N2ZCQXhyS0VMZHp1Rnp3anRFSW8reTdHdDVLKzMzSGVEVkVUT29YZmJEMWZH?=
 =?utf-8?B?VFFON3JHWkRCZ0t4eE9ONHlIOEx0QU5ncU5YcU4zSG53Nmo4RXdhZ25PUUNu?=
 =?utf-8?B?L1V4YlBza2VuY09BdmppbnV2WE9oTytZcVJJS1hNcjMxQkFQNy81VHl1MVFv?=
 =?utf-8?B?VDBSNnptRXU0enhmUXpWUW5tMmpvSUxTQmpHVk01L2ZVYVlxVU5weDNjRlRs?=
 =?utf-8?B?eG9INjV0eXArS2l6bGRDM0o2WG10eEJONVh1b1dTMHZVUjk0bkU4K1NnS0hV?=
 =?utf-8?B?NzE4N1NZeWZvdkJ5bThVU0NNVktFYnZZQ0lFTlZTMkdjdFZGVzdvdHZ1M2NL?=
 =?utf-8?B?QkE0Q2ZwajZkSEhTQTIwd05tTjQ4cHJiT3NISWh6T2hjR0ltNXNKRlpTMmpr?=
 =?utf-8?B?R3cvdXlIOEtBRDdHZzBBQkdWWW5HZzlDMzg4Rm83V2daVDhXVWNGVllIandx?=
 =?utf-8?B?RFZ3U05HQ3FRYm1OWlRXRGVrcExHTXNLOVdaY3dyL1M1cU5OeXJLR2h4UUc1?=
 =?utf-8?B?cm5CYTZJb3p0STVtL2xVVVVDVUNDQ3NzQUkzUkx2WWltUW9RQ2hwYkc5aWZD?=
 =?utf-8?B?Y09NUVNzNWZnVTZpa090UTlONnViQ1UrUFVPN3I1Z1gzUlVwUGR5Nm4yVDRV?=
 =?utf-8?B?SmRnWnlFYWVMc1YvMGFUd0pwNjd1Z1FFMWFGL0lFcDdxU1pnSnVVZjJHSFQ1?=
 =?utf-8?B?c2gwSFhLQlh1c1pPL0VrbjQrUTBjc1V2OXA1eGEwbjNJZjRMOGxZUSt1cVI3?=
 =?utf-8?B?RHlSMmlyQlp0Yi9nQ1ZwREdXamJteUdCcU4wYm12MDlGY1YxeWk3dWpYa3lU?=
 =?utf-8?B?L1lqRE5BcFlVUU1lMnBwMk9OWlUyeWh5NkxTWHRERVV0VWI4Q3kwcGZMdm9M?=
 =?utf-8?B?NCtnZ0FSczF5Y2lnN1p0ODV0ZmZVK1FsWTdxenpZRWgrK05XSTB4STFnUkZp?=
 =?utf-8?B?dnVPaWpvbWFxWERCZGR4TldOd293b1RmOWhXemVaR3NUQlBKeGVUWFZldk16?=
 =?utf-8?B?b3kxUUdHOHJ3aG9JeElNeVFHUzh3bmk0SE13SWhqZmdyaS9RMy9KMWgrL09S?=
 =?utf-8?B?dk9hUGp2NGV0bFMvbjlkOXNtRnJ3czhLRU4yZWRTSWlRUWZad3RVUHZiUjVF?=
 =?utf-8?B?VGJyR2xLUkhCUzNFelZ3TTRMem5DdlA2eUtnb1pFa2xwazNNN1g1TFdmVUx1?=
 =?utf-8?B?bzRFbmdHSkZDUmtmL2ZoYlB2L25ldHdrNWxLR0VOenNJclhzeElCcUJBc2ZL?=
 =?utf-8?B?OVlmcW9mNFBZSGdhVTFjTnlFWTFZRlBVbmYwNGdrYjU5akpxZ3RXZzZ1ZHNF?=
 =?utf-8?B?UGR6UC9rS0gvd3RIV0ZxYU03eG9pQU4xWlVjLzVoVEQzdm5HOTFyemRCQlh3?=
 =?utf-8?B?ejNaVkt6b0NCVC9FaUNWdHg3Rk9aN3FLL0RQU3BuSHZWbGZic0pOU2Z1L2R2?=
 =?utf-8?B?S0l3MmhsdldONFhsT3dUdXRKOFZ5M3BHbStuckNvaWVoN1dyaHhob3lYZUx6?=
 =?utf-8?B?c0F2VzFIWktSTSs1VFNBUnQxZXhpZHVQOVFheUFCL2hsT1M4WlFrOWRKVkVp?=
 =?utf-8?B?ak9mOWFMMjdjTzRsdnBUSUdGYVRnbUFvQWFlcGZyUEx0QWxzMUZ1YlVBSnVW?=
 =?utf-8?B?QTVDWHNLYjlRYlZMYktDaEZPN3dhenhmdDc4azZ4U1pMWW54cC8vTHZaRHVX?=
 =?utf-8?Q?IGjAlfHnpVqNiLjn48SwucaAH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf006f6-6afd-4405-055d-08dc1eed2b4b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 04:05:16.5498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ckqtwSWR5SqTLACsLdbuZOjsA7+EJOVQi3jqdsX5E/sHPL/YXpnYxtVvxWy65m5c6Gsu4LRQlt4uP7s7H1E3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470

On 1/27/2024 2:46 AM, Tom Lendacky wrote:
> On 12/20/23 09:13, Nikunj A Dadhania wrote:
>> Add a snp_guest_req structure to simplify the function arguments. The
>> structure will be used to call the SNP Guest message request API
>> instead of passing a long list of parameters.
>>
>> Update snp_issue_guest_request() prototype to include the new guest request
>> structure and move the prototype to sev_guest.h.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>   .../x86/include/asm}/sev-guest.h              |  18 +++
>>   arch/x86/include/asm/sev.h                    |   8 --
>>   arch/x86/kernel/sev.c                         |  15 ++-
>>   drivers/virt/coco/sev-guest/sev-guest.c       | 108 +++++++++++-------
>>   4 files changed, 93 insertions(+), 56 deletions(-)
>>   rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)
>>
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
>> similarity index 78%
>> rename from drivers/virt/coco/sev-guest/sev-guest.h
>> rename to arch/x86/include/asm/sev-guest.h
>> index ceb798a404d6..27cc15ad6131 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.h
>> +++ b/arch/x86/include/asm/sev-guest.h
>> @@ -63,4 +63,22 @@ struct snp_guest_msg {
>>       u8 payload[4000];
>>   } __packed;
>>   +struct snp_guest_req {
>> +    void *req_buf;
>> +    size_t req_sz;
>> +
>> +    void *resp_buf;
>> +    size_t resp_sz;
>> +
>> +    void *data;
>> +    size_t data_npages;
>> +
>> +    u64 exit_code;
>> +    unsigned int vmpck_id;
>> +    u8 msg_version;
>> +    u8 msg_type;
>> +};
>> +
>> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +                struct snp_guest_request_ioctl *rio);
> 
> This seems odd to have in this file. It's arch/x86/kernel/sev.c that exports the call and so this should probably stay in arch/x86/include/asm/sev.h and put the struct there, too, no?

The prototype is removed in 7/16, I have it here to make sure that compilation does not break with minimal churn.

Regards
Nikunj


