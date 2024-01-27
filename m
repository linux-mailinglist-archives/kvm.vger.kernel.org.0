Return-Path: <kvm+bounces-7267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B2583EACE
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 05:02:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 797EA1C234C1
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 04:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4081C125A4;
	Sat, 27 Jan 2024 04:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gwqWSIyv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF928BED;
	Sat, 27 Jan 2024 04:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706328134; cv=fail; b=CbRR75p1G4wm0pxx0CZTlDBAci50szG2HllDHBt37W08n/sfcAsiJeWIrueYUuZqS3LYB781eXZvX4CJSQv5dWkeRXTUrvZrg2832EnIEAp3LWw/LEq30Q8MqqDFmccc8DuD+GghwlEitNV4RTawbllidDWKYVCv7+Evhm5nKtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706328134; c=relaxed/simple;
	bh=Yuut5jTUJ120LcpLq07kIGMe6pcOgIfsO4WkZudDRs4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lymwH1ahyRL/GeSbGXacQ+r7S9B8ArggzLNOqMRD/KWoSmeUsTLtznTdSNfnuvPX9hzXBYwQYoQFy+5x45k9Nd9PZwMU3GFDnDNhHq4QZHaSQSHlNbwQ/Qz1bYgVrOcXRlp3bZ0PxaXRFC8AveZCt4YA8PUbiYlY0oc7GfcXF6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gwqWSIyv; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQhqULnb89W1GcvreBWGy8X95/15YuhL8oL9/KklDAm5zRrHJV9FOfi4KdV561Zi3GyXo1z0VRrgus3qC+r6od0SsEplt9Gk+aMZVICm2sBO1CHq8QiuBx2H1oqvaOBHloJBnTy4JiKBncWYsRXiuY4IquBmUMG7igoCnBeKWWWq9dHuG7layCLvpilTnO5PzSzQPvsD/+w3ZVFz0L2HmUwFAVYlnVPIaUkldbotZJG1p2qqR+7sxIg31MTSVZER6PlaqLVStKrVMRmpsV1Ff8zwK0cHA1EZ1lbhpjLLctET8csU2eH5IcgnX3y01RcYGpmW8EMaR11djUhlDhFRrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLSf3xfbI1BF2M4vsqde3Zlx9x7Q9flRX6UBnZIWO7w=;
 b=Xhhs7HZEyfJj8rkqAZfXfXsRJnnLX9Gugf6IGotj/9CGgmkprqaJlIN2A305T23xuMAs1ru9jNcMJaPnAlcC2HGSkXm1rBEzitTEt/sioKmys/9/dS6YzsGWpr8PjfxJI1SwSU4bLKFws9FeBBDDaMu1mmoKl7arH3XSCoVoxfBt+K557FzRM3sgj4xeBgW8oLPqKRAVstJqXqXPXA8ZOT2k02YQst4nF7w4W6Zj1YFyzIZf8F/uRvh6YPaotWYvfDt+D1rsSApEwZjdr2Uc9dQSiECQ2ulTCeRNcN6DeZRvmtv7UpNFLCKFURtojbbIUpsVwt1FVYzgqhL9wedsQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLSf3xfbI1BF2M4vsqde3Zlx9x7Q9flRX6UBnZIWO7w=;
 b=gwqWSIyvpFEH2IAGSaUgvOGshTzVj6ZJnyfv7jI+GMoP7swxHhpqnEcv4dLLX2rKx+5RfBiN+yYWaj4RjHXUdtNeCUISKHqNalN2V0vv39IXW8fNo4qEUXd0GQRn/3cpHL0eo1oftn9WckkLhUZqJKOZW7NjfA1EsgsjmFZdBv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Sat, 27 Jan
 2024 04:02:07 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.022; Sat, 27 Jan 2024
 04:02:07 +0000
Message-ID: <ee19d79d-6cc3-441d-85ee-834445356f88@amd.com>
Date: Sat, 27 Jan 2024 09:31:58 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f9de9cd-fd15-4ae3-9c02-08dc1eecba70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jPrDVM0ElsTb2jWq7cdzoMqMqAtZuYW06QkRhdHZXE6pCF6aifu3obwpL6gpiu3ASE2PTtVu7yAlaxTyKelh+PhgAXT4OzYuyPLgUtV12Tz50JcSntyifXPx5nrjaO36jSni8Ri7WkCqPU7JZqgnYIqaKjT4niPjJTTVD/Lajpd/7c32nJz8kASJo6KAoaaWDt2lBJP74QxN8EoMRWJmIlLnXiKxvz+x6qfubjtKJ19YTD5MpfSrb+hTvpEUO23t3HrvGZUIhAOgLhQQEWN7tmFCSb/LXyqDwEcWd+HCXQfqTBsXTRhDIjaCQ1KkiMktUs4/p2vrMCTU76OJcELEGUUENPbY3N+jyCcdpzA4T5s3alyhOCOlVb//DVdLAuMobbn89vVtbUwdhhEmoFE/ytXhnIYwy9BtPOYd0rB4FrqHsy7R22i/Lz3nWe2VSSKQGPJs1ACdgEB6dUVa4MPIjQZBWHQg3WxfugRJTvUkkNi9z1sT7Wg2N6xaFjxtMPbzz9fh9yLoRj6GRxz8UE+TSQ3kCpWLAf1aIfuh4VKEBBj1Jmsya/7PFEY0PvaRCCWEGoaACjY1k7Wlw3NwXDMGlTZTXXN/kMfxkst23IssLFLNZbchYuF9KbD21WXMySvSFrp3+/Icg7fzRo6vnjC5Iw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66946007)(478600001)(6916009)(6486002)(66556008)(31696002)(316002)(66476007)(38100700002)(26005)(6666004)(6506007)(2616005)(8676002)(4326008)(6512007)(8936002)(5660300002)(53546011)(83380400001)(7416002)(2906002)(36756003)(3450700001)(31686004)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cndZWGs0UWdBVisxZmNPbCtEei9KWVd1WXFoZ3A3M3hrRXN1Rm43ektNOTEv?=
 =?utf-8?B?N0hvVGxJRjlKdGdTSHRWWDhOOTRCODl2eTEwbUsxeWhrSE91c3hXbnYramZ6?=
 =?utf-8?B?RStvUVNrdjdvamRBNnpOM0FqVDlnU2lMWmFMbjM0em40QXQrek1hVmpFL1kr?=
 =?utf-8?B?YU5rbmYxWFJkdEhaM2lpbGVWblFRR25ONEtJaVVPOWVWa0cyQXlKcWxsU2ZK?=
 =?utf-8?B?ZE9MUWN3QXZ5T1RxazFWN3VHWXBMOHRtcGd6aksrUUJxc1VpZ0JoZ0tuRmo3?=
 =?utf-8?B?SHVNNVJZdWVta0dRTnRGSGczNFdCNWJWUUxtSXZPcVRYNDFhNDBvVHlmV2lz?=
 =?utf-8?B?NEVNQ0hYZ0QxTFpwblBkbmRSN24vS1N1TmY0Qk55R2NxWmJmSGRWV3JqeTJy?=
 =?utf-8?B?VjBzejZSL1JIem5UakFmY0QwNEpDb3lBeGduQmVsVkdWM2xmYTUvSkROTGdn?=
 =?utf-8?B?Tnh4Ti9KbmtGMFk2MHoydGVyVCtoSnB2dHVudklnN0dzbjNCNEFvRWYrTUxK?=
 =?utf-8?B?c0k3ZnJ1TmZ6czVITzEwMndVNm1ZTHlSci9Oakkzdm5vQUJTYnBXZjBpaElt?=
 =?utf-8?B?bEZ3QmpFUXBySC9KQTRtTTlpRU5PODFBL1FKYVlEZHRERDFrOHhmbm9Wb1BI?=
 =?utf-8?B?cVArQ3BvSVF2SXZQV05kVEZQbXltd3BHdUwwME5QQTk2bmtRbTFYbEdWZGtT?=
 =?utf-8?B?cWl3cDE4NFhISHlLN1FHTGFDZFRVS1VDbGd4N0tRaGZQUzF5YXdZTU5tbHRJ?=
 =?utf-8?B?c1RqeVM1eVk2bm5KbFRCclB6WE1XZWlQQklGQTIycHZYMzVlcnp5dHUvRlBP?=
 =?utf-8?B?Wk9sVlRVT05PS09GaTlkZWpwQkVSMlQzbWRTcElSdHhHbWxhMERrR01CYXJM?=
 =?utf-8?B?cHZKa3NYNGlDc25XMEhmdjVGUGsyVVpRR2JDVEpsWkdPemxaUElPUFZDdnhn?=
 =?utf-8?B?TW4vSG1IaVRneDIrcWtORi9nMjBjSE5TNzF5UFY4ZFdhRjY5SnRaVm5tMm1B?=
 =?utf-8?B?UHc2NTVzZGZmTy9hMmlFb2FlM2NiQkhLbDZTN2I1emZ3VmF2aW5qOTVqYWNR?=
 =?utf-8?B?ZGRjNzJ6ZVNEYWt3ZjB6VTQydmV5RGplYit5bUVQOUdlUDlTOWlhbjJyMHRU?=
 =?utf-8?B?T2Nxa1pKSGpXbmxabW9aRm1jZDQ0Sy9GMWl5WVgwTGxpK1JBd3NwVGZORmkz?=
 =?utf-8?B?MFFOSFRVNkMvUmdBM0kwTXcybVpCTnVXTmRhd0dyRERSU09mbmRVTkFPREdP?=
 =?utf-8?B?QnRQaEZub2pWazk5QjlVY201NUVzZGJlUW5xY0ZkWWt2RGtuaDN1Sy9ad0px?=
 =?utf-8?B?SW9md2VyeEFQWVNNV0lCcGpjcDgremVqdGZHNWZyZWJIQSt5azJRRllHZDB4?=
 =?utf-8?B?bGkvejZ2M0VYUVFTcWFzbVJacXU0SFlKZXB3dm5kOTRXdmRCM3FXQjRhVmV3?=
 =?utf-8?B?SmNlRXdhemxYTGcrNkFIT2hXMDg0V1hMMGJBRmZMcldERWM5VnhTVGxHRUgv?=
 =?utf-8?B?MEpWc2VyOW92YnZhWmxPNlZvMDMrbU1ERFFROEozTkRlZVdFdW9NRVBiejFr?=
 =?utf-8?B?VlhVYk5HSithckZGVmNnR2ZCYnRzZkYrY3RhTXJrbHRvejdZbXdKbTYvL0ZJ?=
 =?utf-8?B?czN4bnpwbEtHaVhZbk95blZpaEpyczJWZTB4Vnp5K0hLTHpuaXM0aDVZd1ZO?=
 =?utf-8?B?WEhUeGQ0cVBuY0J6K25vOFVWYU83VWV2OXN2blY5VXZhOUFvOFU0bmZRdFVx?=
 =?utf-8?B?d2l6bktBcmc0QWwwbjNOQ1UrVk96MUJNMEFWRnFLM1Z5dzJocG14bEM0ZXhO?=
 =?utf-8?B?NWpKWi94Z21SeU8wUVUwWGYrVGdvZ1dhdllBS1RvVmx0bE80NnpjcWFnQUNL?=
 =?utf-8?B?OW1KNko3WjBhQXdNdFBNdDNINVZaVzBhbTNxUWhqcmQyMDF2NWhZSmp5Y3hj?=
 =?utf-8?B?dU9CUnR1Y2RpS3Q2OE5uT1h5TkNhQnNjT1FXbU5VN3BXSGtPeVQvV2pMVXBU?=
 =?utf-8?B?aEExVW1uclZxbmVlMkwzVjdITS9zUmtYcDZVK3pWSzhlV2doajlZZFZ4ZFF1?=
 =?utf-8?B?WGU4a2h3RkQ5bzM4QmhwaDVwd3lCSDhPZmUzN2w5ckpzNEMzckFOVGlHZkdG?=
 =?utf-8?Q?pkFMsjXswCQUeqwhLj1975vsc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9de9cd-fd15-4ae3-9c02-08dc1eecba70
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2024 04:02:07.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BERnJ6C0oxEHg4ZKVmPb+YMjJ3PvKk/wzMY5LN0aLbsmcEeoVruYUfMjjoVYvH87LiPRTwrxtwHD5BEI88CJNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5712

On 1/25/2024 5:29 PM, Borislav Petkov wrote:
> On Wed, Dec 20, 2023 at 08:43:45PM +0530, Nikunj A Dadhania wrote:
>> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
>> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +			    struct snp_guest_request_ioctl *rio)
>>  {
>>  	struct ghcb_state state;
>>  	struct es_em_ctxt ctxt;
>>  	unsigned long flags;
>>  	struct ghcb *ghcb;
>> +	u64 exit_code;
> 
> Silly local vars. Just use req->exit_code everywhere instead.

Sure, will change.

> 
>>  	int ret;
>>  
>>  	rio->exitinfo2 = SEV_RET_NO_FW_CALL;
>> +	if (!req)
>> +		return -EINVAL;
> 
> Such tests are done under the variable which is assigned, not randomly.
> 
> Also, what's the point in testing req? Will that ever be NULL? What are
> you actually protecting against here?

Right, and in the later code, this is checked at snp_send_guest_request() API. So this is redundant.

>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 469e10d9bf35..5cafbd1c42cb 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -27,8 +27,7 @@
>>  
>>  #include <asm/svm.h>
>>  #include <asm/sev.h>
>> -
>> -#include "sev-guest.h"
>> +#include <asm/sev-guest.h>
>>  
>>  #define DEVICE_NAME	"sev-guest"
>>  
>> @@ -169,7 +168,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>>  	return ctx;
>>  }
>>  
>> -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
>> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
> 
> So we call the request everywhere "req". But you've called it
> "guest_req" here because...

Yes, I was thinking about it and came up with this.

> 
>>  {
>>  	struct snp_guest_msg *resp = &snp_dev->secret_response;
>>  	struct snp_guest_msg *req = &snp_dev->secret_request;
> 
> ... there already is a "req" variable which is not a guest request thing
> but a guest message. So why don't you call it "req_msg" instead and the
> "resp" "resp_msg" so that it is clear what is what?
> 

This naming is much better, thanks.

> And then you can call the actual request var "req" and then the code
> becomes more readable...
> 
> ...
> 
>>  static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>>  {
>>  	struct snp_report_req *req = &snp_dev->req.report;
>> +	struct snp_guest_req guest_req = {0};
> 
> You have the same issue here.
> 
> If we aim at calling the local vars in every function the same, the code
> becomes automatically much more readable.
> 
> And so on...

Will change accordingly,

Regards
Nikunj


