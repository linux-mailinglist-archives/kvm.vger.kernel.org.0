Return-Path: <kvm+bounces-7587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D57A844131
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 14:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAE93B2DB0A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 13:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285AC8288C;
	Wed, 31 Jan 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2KIdMtgL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9317F491;
	Wed, 31 Jan 2024 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706709502; cv=fail; b=EfpGTy2d4RGMYaMq9llqLp6lXjuRR15zndWVGXY9qBb7TMG8l1VzFiGG73iIPa0t/5xzTb+Ij/T4P9MPXK/C0YJ4m1MsEuctxwgh8Ie1aObi2zkLEBrTVmWNjWRM1Cl6QiNXGzyYwf717u1YL4F4mzMcPhyci0Y1id3KaePCCCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706709502; c=relaxed/simple;
	bh=E2Fj/NbupL0r9rBQNDcis3k60eMUDs316dsIQyOpFiw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PmJ7K2Xv1xJ2Js0l+8+jkQ6W2y2TBKPXdCClorCIdgD6K9jQdQlg1Is5kJRpg8nooh9rh5/jHDjgL65Rd7OogoHtRy0B/P5z+ATAoVjTH6levRja5MlPjl5uARGUsA1c2JWOQIwLZMWm8W60nw95sZyjf5+GnAsw2WHBxGU40Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2KIdMtgL; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJiovbVeE0o1atUX0bIkDUcyBAOJfemxgl9KMR8N0RTl+0U8zu9fxUwKHNBoRa3pY+vygK7rLIl4DyRH3giDyS/R6FGbotN8spDc0oxFy9FvvgPzarNez9P2KdhxWivV9Kc6xX/EDiYUCcPdSwJ4d6eQI73xg3GBPVpQ2K/fUQSPYglMdN44oyjQKl6PqaUszsSa6A+OincSi+yHFC8fy9NrclHwI4dN23f47OBo+Hs/hGBrBDSI1pWbF4I7D/r4fxNlwg3qJXG+NSZLwPk8lBL6ayi9EcgUwXWHBQpAWsLybzePXaNmI2nuDNRmpN4GXvcNoZuE7LYW8eGspKBZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIH/rsIqo9reuNyCFrXZY0722rnff1p219s+e1BM3aA=;
 b=HbqBl9SkE4/ZZtXu1aBBBB848BSGBgjfTcd37t4wOEiX2QStxSo6xEjvovWaHuEp0D5zsdSJjYrKGShwDSGUBpyxhKiSMPKe204fkOBRNVC6YKY4MKEOJsbkqCnzOrNZqLIaN5S9gfLr0zVgF49oM2tQyMrRKZBo/rIdFiAsCHsoxSRFr0zK7Ns0ur72lLaFVZieYW4Qqa2L7izJCkF1BHTNUcTb44AmucNW8de55VkenXvXCEX772LJJ8K/bIjZbnjTQlaRphsm2omwvEze+OHC5hCn6jyJ+QHPQUw2xLT1jRcYltx9x0ZHGM99gQwQyuynIfUtmxjqVPBZOSUZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIH/rsIqo9reuNyCFrXZY0722rnff1p219s+e1BM3aA=;
 b=2KIdMtgLFK5lyjXUwJH9TYNtcAXY+ADudNCUXdsn1FvU5gHfLNarMIueLjsQFNXKPq44jHLtiigyqJYthipz9ocNqA2bmdePJabBty6G+O2PX70lTcU0nfcwVtnr8AuKsNbhZkOgXrFMElJR1gVXtG+9L79jQ7o4gjVe612Kzzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.24; Wed, 31 Jan 2024 13:58:15 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::9c66:393e:556b:7420%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 13:58:15 +0000
Message-ID: <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
Date: Wed, 31 Jan 2024 19:28:05 +0530
User-Agent: Mozilla Thunderbird
From: "Nikunj A. Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
Content-Language: en-US
In-Reply-To: <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: 5582f6e9-4e39-436a-807e-08dc2264abc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M7sUFmdR78pBg7LlSDZ3CMNlQQ1wvzwoXZ9tYLgtvhGddV6p4WIMO/hhJTE/y5SbkouNuCJnEoJWxoFoewQ8O0wqNSg9U/lDkHG3VWmERWc6G3Kwj8zh4v9rVrvo2CEbkn6Qk7+BEMrtwhoMK4a/tnfDSp7k7nXpRHzDseArbnXUnMB1dvZsoxTzh1eRrniTrazaV2yVREzsIY4e2KyBNQC1HjEirJhWyT1BUCnqz9cjlLyZiWGjfJ5rVmOrdWwxKJsEWKIbaXhF5tTOvRlkRiN6O88xRc0ih7fRH0RkC4HInVRk8ihlprQAZyTsjYkd7V8rFG9FfAbEq3d0y9CLeXW9ldhSv3LIdC4DFr5Z3/05NYb/4RKJeTVVDppvgbhoqBTjx39ETltQekYzeo+y3anoWrc9PkK0lbv3nGolrDbAWXXtHbWbWS72U9MamJLrcNdpy5yHdKzacAgYebxVaDWW0yl5BnIqE5v3XInOWfyvxoxYpwaRGpsvX/mzpDUbnFDONMRSS59pNUalJkb3mcgweHyvzdwmh2MzkEiRuhlp+NL0MHLRdixhFtPWlW6YrDgmGlX4VtWDgJz1NyDMsl9/6OU6OhiLadn8fG8s7iab8stQmHWwNH82bhRo+pyqYhR2Apv5OYJ2xWkQVZolnw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(396003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(41300700001)(66946007)(4326008)(8936002)(30864003)(8676002)(2906002)(5660300002)(7416002)(31696002)(66476007)(316002)(36756003)(6916009)(66556008)(38100700002)(6506007)(53546011)(6512007)(478600001)(6666004)(6486002)(83380400001)(2616005)(26005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUZQQ3VJcWdYSnQwbWVtSFhMN201ZVlwT0JxRjBNNi9vUXJyREwvMXY1alQy?=
 =?utf-8?B?VlYydmcxN1RVb3k4eHZaWm9aWkkwUk1qQ0NZRzVpYWRWc3pMNnV5MzFPZ0Nl?=
 =?utf-8?B?ZlhyKytuaWExZXJVeTE2L1VHQS9OZnZ3OEMvUlN3VGo2clpCUWdSMUZFNjJj?=
 =?utf-8?B?QWhsT0ZIQmZ4eUlXempaUTEvdTZXdG8zb1RNemxURjBoajVGdEU5ZlB5RU1k?=
 =?utf-8?B?bkJRcVlPb0RsckVYdndJT1M5dUMwY05RbWE2cHEzOExDNTFkaEpQbzFYMzFy?=
 =?utf-8?B?bUQrUG9RckZyb1prd3B3NnN1cmp3cnNseVhHOTB2cnJvOElDcTRMVEZmY0pR?=
 =?utf-8?B?WUxmTkNwaUlCRTBmUUQwZGFoWmlwY1Qva08zVGwrT2g5eFZYWHYxYk4wRXIv?=
 =?utf-8?B?em50OUg2R1ZmSE4yUEJNRVVEWG9OSFZWQXdTZENPUjR5cFBwU05xcnZjaFVn?=
 =?utf-8?B?Q1ZIcXpTQVExWllmTVFBS1A2cDhYZElwZ3BhR1hOOHc1dkt1b3gvUE5GbURa?=
 =?utf-8?B?VXZ3a2thN0pramtRMy82SnpMTmJZODBOeUVPZ3VEREpENWhhUndqU090T1lU?=
 =?utf-8?B?WG81alJEWmFWYm43K0RhRHRZV3luTHRoSDBwZ1pOZ1dyVStYNGJxYzdoeXVz?=
 =?utf-8?B?RFlZcFVRT2NEendTT2ZXQWxFYVJEVHA3SUdjUGpPZWhBZDRxZkFnN0JUU3Rp?=
 =?utf-8?B?MHcyUUtsbU5yY01MZ1M3NmNQemhHNVNKb0tGTzZJcmRzZDZVTzNmak9YS3NG?=
 =?utf-8?B?RkFJcGw4U1h2ZmZqTi9pcE55N1BDRDJnNmg3QUY0UDE3Nkd4T0s4di9aZEYw?=
 =?utf-8?B?STVmbUlMWTlzdndBTkNLbkhFa2YwdkNnVjdHSHdCMUQvSmhOVkxMSU1FWW1O?=
 =?utf-8?B?MVpJUlRkdndLb0UxdzVVQVNHd1pQdkY5VHRackFhanlsdnJnTngxTUhBMkxu?=
 =?utf-8?B?YkFxS0YvS1ZtMHJZZ00rbDFHMnhzckx2MUF0OU5odFdVTjZscWJUYzBady9N?=
 =?utf-8?B?VDNFekMwYUFuSUo5WkM3dHYveXpKSHozdUF5TnVFVDhud3FQMjZzbnh6bVZU?=
 =?utf-8?B?cjdrSjgvdDFOU2E0QWN5bGw1NWFweERHT1ZsVzU0TUY4TVo2ZHg5Vzg1N1Vj?=
 =?utf-8?B?dHEyV2FvSGZ2dDh5aG9PcHhXRTdOTzg1czNlWHFpS0RnbWdxcmp0SG9IWlNO?=
 =?utf-8?B?QXZ1VEwzYTU4SHlSRTlmWjFESlQzdklQQlBFdVBCRXQ0S1hZNUNyM0F1Nith?=
 =?utf-8?B?cWttcVVYNTVQOHIxRTN0a2Q2bDJRR0RYT2RaYTNCNTVzK0pQc3o5Y0FCSGhx?=
 =?utf-8?B?aGwvTG5RaFc1MVVkNXdSYWcrNEpmZk14MnQyQmMyMFJsMGQ1L2NIb2NyWmlE?=
 =?utf-8?B?RGhxU1VwdmtHN1VJVzZDNEFXRkpoUU9tazVId2dMVmFTOGNrRVcxWUFGRWI0?=
 =?utf-8?B?aXplc1ltRUg3OWFvdnBJdFZFN0ptemZqZ1ZpalBIcnlNL200aFdYaklrRjFW?=
 =?utf-8?B?aHNxZmJRNzVzdTNiMmdzNE45aEkwM2l1ajFvTGNNaTNEc0tTaVVhVmtEMXl6?=
 =?utf-8?B?bmh6K2tzZDhpQVdLWENlOGdIektYbEhrNzdJSHQ5WW1ETTA3SDFaQkJmaW1l?=
 =?utf-8?B?UmFCVngrcm9ZTkxIMjNIMkkvK002UDFSY25TRmRYUWtEV0c0OXh0eXFHWnhi?=
 =?utf-8?B?RU1lS29RdkZ3QzkzS0Y0SitSWlBmOVY5N0NTdDB5Yi9kWCt5V2d5ODlSU1FY?=
 =?utf-8?B?RmdMNVcwWTYzcmRlYjZvME5CMjZnb2JVL1U4QjczNCtoTlB1bCs1aGN0VEhZ?=
 =?utf-8?B?cUFzTHY4K1JWNExBa0hFL1BkL1ZpTCtCV1FJQWRoTnR5UGV2N1ZKUU16aGo3?=
 =?utf-8?B?eVBHeUplbkVyRDMvcHphUXZzY1V0bCtGdWxEMkxsRjNxdUkzYjV1SFFsQk1k?=
 =?utf-8?B?cU9zYXlSanJyWnNVcGdlSlRjUW02aTI3N1UxalhoYVRwRTAzZVpKMDErWjZJ?=
 =?utf-8?B?aHdIcjVPQ29KaDRkVTlhYWw4TEdMWUdIbEFZYzZTVHcwSkREbWlyczBBK1RZ?=
 =?utf-8?B?KzE4dFVkZWZDKzFseDU3bnlBTG5GVzZUS3pYZmN0WnU5ZER2UG03WlVaQS8x?=
 =?utf-8?Q?k3DrGUfgvNcnfYjCou+fYqa5+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5582f6e9-4e39-436a-807e-08dc2264abc1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 13:58:15.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3o8cFpdikj8yMJ26sMq3gjpQ5Ez2mXSm3uYkcU3yvb8YeiD+VMG8NwD2ps2YirvVaQ/kh3vjS3tBWR8pFyWQeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

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
> 
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
> 
>>  {
>>  	struct snp_guest_msg *resp = &snp_dev->secret_response;
>>  	struct snp_guest_msg *req = &snp_dev->secret_request;
> 
> ... there already is a "req" variable which is not a guest request thing
> but a guest message. So why don't you call it "req_msg" instead and the
> "resp" "resp_msg" so that it is clear what is what?
> 
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
> 

Changed to "req" for all the guest request throughout the file. Other "req" 
usage are renamed appropriately.

Subject: [PATCH] virt: sev-guest: Add SNP guest request structure

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters. Use "req" as variable name
for guest req throughout the file and rename other variables appropriately.

Update snp_issue_guest_request() prototype to include the new guest request
structure and move the prototype to sev_guest.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 .../x86/include/asm}/sev-guest.h              |  18 ++
 arch/x86/include/asm/sev.h                    |   8 -
 arch/x86/kernel/sev.c                         |  16 +-
 drivers/virt/coco/sev-guest/sev-guest.c       | 195 ++++++++++--------
 4 files changed, 135 insertions(+), 102 deletions(-)
 rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
similarity index 78%
rename from drivers/virt/coco/sev-guest/sev-guest.h
rename to arch/x86/include/asm/sev-guest.h
index ceb798a404d6..27cc15ad6131 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -63,4 +63,22 @@ struct snp_guest_msg {
        u8 payload[4000];
 } __packed;

+struct snp_guest_req {
+       void *req_buf;
+       size_t req_sz;
+
+       void *resp_buf;
+       size_t resp_sz;
+
+       void *data;
+       size_t data_npages;
+
+       u64 exit_code;
+       unsigned int vmpck_id;
+       u8 msg_version;
+       u8 msg_type;
+};
+
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+                           struct snp_guest_request_ioctl *rio);
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b4a1ce3d368..78465a8c7dc6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -97,8 +97,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 struct snp_req_data {
        unsigned long req_gpa;
        unsigned long resp_gpa;
-       unsigned long data_gpa;
-       unsigned int data_npages;
 };

 struct sev_guest_platform_data {
@@ -209,7 +207,6 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -233,11 +230,6 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
-{
-       return -ENOTTY;
-}
-
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c67285824e82..43ffd307731f 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -28,6 +28,7 @@
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
+#include <asm/sev-guest.h>
 #include <asm/insn-eval.h>
 #include <asm/fpu/xcr.h>
 #include <asm/processor.h>
@@ -2170,7 +2171,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);

-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+                           struct snp_guest_request_ioctl *rio)
 {
        struct ghcb_state state;
        struct es_em_ctxt ctxt;
@@ -2194,12 +2196,12 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn

        vc_ghcb_invalidate(ghcb);

-       if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-               ghcb_set_rax(ghcb, input->data_gpa);
-               ghcb_set_rbx(ghcb, input->data_npages);
+       if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+               ghcb_set_rax(ghcb, __pa(req->data));
+               ghcb_set_rbx(ghcb, req->data_npages);
        }

-       ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+       ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
        if (ret)
                goto e_put;

@@ -2214,8 +2216,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn

        case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
                /* Number of expected pages are returned in RBX */
-               if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-                       input->data_npages = ghcb_get_rbx(ghcb);
+               if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+                       req->data_npages = ghcb_get_rbx(ghcb);
                        ret = -ENOSPC;
                        break;
                }
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0450c5383476..b6c8f70e936c 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -27,8 +27,7 @@

 #include <asm/svm.h>
 #include <asm/sev.h>
-
-#include "sev-guest.h"
+#include <asm/sev-guest.h>

 #define DEVICE_NAME    "sev-guest"

@@ -169,65 +168,64 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
        return ctx;
 }

-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
-       struct snp_guest_msg *resp = &snp_dev->secret_response;
-       struct snp_guest_msg *req = &snp_dev->secret_request;
-       struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-       struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+       struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
+       struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+       struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+       struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
        struct aesgcm_ctx *ctx = snp_dev->ctx;
        u8 iv[GCM_AES_IV_SIZE] = {};

        pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-                resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
-                resp_hdr->msg_sz);
+                resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
+                resp_msg_hdr->msg_sz);

        /* Copy response from shared memory to encrypted memory. */
-       memcpy(resp, snp_dev->response, sizeof(*resp));
+       memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));

        /* Verify that the sequence counter is incremented by 1 */
-       if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
+       if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
                return -EBADMSG;

        /* Verify response message type and version number. */
-       if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
-           resp_hdr->msg_version != req_hdr->msg_version)
+       if (resp_msg_hdr->msg_type != (req_msg_hdr->msg_type + 1) ||
+           resp_msg_hdr->msg_version != req_msg_hdr->msg_version)
                return -EBADMSG;

        /*
         * If the message size is greater than our buffer length then return
         * an error.
         */
-       if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
+       if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
                return -EBADMSG;

        /* Decrypt the payload */
-       memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));
-       if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
-                           &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
+       memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+       if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
+                           &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
                return -EBADMSG;

        return 0;
 }

-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-                       void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
-       struct snp_guest_msg *req = &snp_dev->secret_request;
-       struct snp_guest_msg_hdr *hdr = &req->hdr;
+       struct snp_guest_msg *msg = &snp_dev->secret_request;
+       struct snp_guest_msg_hdr *hdr = &msg->hdr;
        struct aesgcm_ctx *ctx = snp_dev->ctx;
        u8 iv[GCM_AES_IV_SIZE] = {};

-       memset(req, 0, sizeof(*req));
+       memset(msg, 0, sizeof(*msg));

        hdr->algo = SNP_AEAD_AES_256_GCM;
        hdr->hdr_version = MSG_HDR_VER;
        hdr->hdr_sz = sizeof(*hdr);
-       hdr->msg_type = type;
-       hdr->msg_version = version;
+       hdr->msg_type = req->msg_type;
+       hdr->msg_version = req->msg_version;
        hdr->msg_seqno = seqno;
-       hdr->msg_vmpck = vmpck_id;
-       hdr->msg_sz = sz;
+       hdr->msg_vmpck = req->vmpck_id;
+       hdr->msg_sz = req->req_sz;

        /* Verify the sequence number is non-zero */
        if (!hdr->msg_seqno)
@@ -236,17 +234,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
        pr_debug("request [seqno %lld type %d version %d sz %d]\n",
                 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);

-       if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+       if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
                return -EBADMSG;

        memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-       aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
-                      iv, hdr->authtag);
+       aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
+                      AAD_LEN, iv, hdr->authtag);

        return 0;
 }

-static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
                                  struct snp_guest_request_ioctl *rio)
 {
        unsigned long req_start = jiffies;
@@ -261,7 +259,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
         * sequence number must be incremented or the VMPCK must be deleted to
         * prevent reuse of the IV.
         */
-       rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+       rc = snp_issue_guest_request(req, &snp_dev->input, rio);
        switch (rc) {
        case -ENOSPC:
                /*
@@ -271,8 +269,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
                 * order to increment the sequence number and thus avoid
                 * IV reuse.
                 */
-               override_npages = snp_dev->input.data_npages;
-               exit_code       = SVM_VMGEXIT_GUEST_REQUEST;
+               override_npages = req->data_npages;
+               req->exit_code  = SVM_VMGEXIT_GUEST_REQUEST;

                /*
                 * Override the error to inform callers the given extended
@@ -327,15 +325,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
        }

        if (override_npages)
-               snp_dev->input.data_npages = override_npages;
+               req->data_npages = override_npages;

        return rc;
 }

-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
-                               struct snp_guest_request_ioctl *rio, u8 type,
-                               void *req_buf, size_t req_sz, void *resp_buf,
-                               u32 resp_sz)
+static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+                                 struct snp_guest_request_ioctl *rio)
 {
        u64 seqno;
        int rc;
@@ -349,7 +345,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
        memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));

        /* Encrypt the userspace provided payload in snp_dev->secret_request. */
-       rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+       rc = enc_payload(snp_dev, seqno, req);
        if (rc)
                return rc;

@@ -360,7 +356,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
        memcpy(snp_dev->request, &snp_dev->secret_request,
               sizeof(snp_dev->secret_request));

-       rc = __handle_guest_request(snp_dev, exit_code, rio);
+       rc = __handle_guest_request(snp_dev, req, rio);
        if (rc) {
                if (rc == -EIO &&
                    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -369,12 +365,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
                dev_alert(snp_dev->dev,
                          "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
                          rc, rio->exitinfo2);
-
                snp_disable_vmpck(snp_dev);
                return rc;
        }

-       rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
+       rc = verify_and_dec_payload(snp_dev, req);
        if (rc) {
                dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
                snp_disable_vmpck(snp_dev);
@@ -391,8 +386,9 @@ struct snp_req_resp {

 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-       struct snp_report_req *req = &snp_dev->req.report;
-       struct snp_report_resp *resp;
+       struct snp_report_req *report_req = &snp_dev->req.report;
+       struct snp_guest_req req = {0};
+       struct snp_report_resp *report_resp;
        int rc, resp_len;

        lockdep_assert_held(&snp_cmd_mutex);
@@ -400,7 +396,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
        if (!arg->req_data || !arg->resp_data)
                return -EINVAL;

-       if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+       if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
                return -EFAULT;

        /*
@@ -408,29 +404,37 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
         * response payload. Make sure that it has enough space to cover the
         * authtag.
         */
-       resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-       resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-       if (!resp)
+       resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+       report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+       if (!report_resp)
                return -ENOMEM;

-       rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-                                 SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-                                 resp_len);
+       req.msg_version = arg->msg_version;
+       req.msg_type = SNP_MSG_REPORT_REQ;
+       req.vmpck_id = vmpck_id;
+       req.req_buf = report_req;
+       req.req_sz = sizeof(*report_req);
+       req.resp_buf = report_resp->data;
+       req.resp_sz = resp_len;
+       req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+       rc = snp_send_guest_request(snp_dev, &req, arg);
        if (rc)
                goto e_free;

-       if (copy_to_user((void __user *)arg->resp_data, resp, sizeof(*resp)))
+       if (copy_to_user((void __user *)arg->resp_data, report_resp, sizeof(*report_resp)))
                rc = -EFAULT;

 e_free:
-       kfree(resp);
+       kfree(report_resp);
        return rc;
 }

 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-       struct snp_derived_key_req *req = &snp_dev->req.derived_key;
-       struct snp_derived_key_resp resp = {0};
+       struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
+       struct snp_derived_key_resp derived_key_resp = {0};
+       struct snp_guest_req req = {0};
        int rc, resp_len;
        /* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
        u8 buf[64 + 16];
@@ -445,25 +449,34 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
         * response payload. Make sure that it has enough space to cover the
         * authtag.
         */
-       resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
+       resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
        if (sizeof(buf) < resp_len)
                return -ENOMEM;

-       if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+       if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
+                          sizeof(*derived_key_req)))
                return -EFAULT;

-       rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-                                 SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+       req.msg_version = arg->msg_version;
+       req.msg_type = SNP_MSG_KEY_REQ;
+       req.vmpck_id = vmpck_id;
+       req.req_buf = derived_key_req;
+       req.req_sz = sizeof(*derived_key_req);
+       req.resp_buf = buf;
+       req.resp_sz = resp_len;
+       req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+       rc = snp_send_guest_request(snp_dev, &req, arg);
        if (rc)
                return rc;

-       memcpy(resp.data, buf, sizeof(resp.data));
-       if (copy_to_user((void __user *)arg->resp_data, &resp, sizeof(resp)))
+       memcpy(derived_key_resp.data, buf, sizeof(derived_key_resp.data));
+       if (copy_to_user((void __user *)arg->resp_data, &derived_key_resp, sizeof(derived_key_resp)))
                rc = -EFAULT;

        /* The response buffer contains the sensitive data, explicitly clear it. */
        memzero_explicit(buf, sizeof(buf));
-       memzero_explicit(&resp, sizeof(resp));
+       memzero_explicit(&derived_key_resp, sizeof(derived_key_resp));
        return rc;
 }

@@ -471,32 +484,33 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
                          struct snp_req_resp *io)

 {
-       struct snp_ext_report_req *req = &snp_dev->req.ext_report;
-       struct snp_report_resp *resp;
-       int ret, npages = 0, resp_len;
+       struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+       struct snp_guest_req req = {0};
+       struct snp_report_resp *report_resp;
        sockptr_t certs_address;
+       int ret, resp_len;

        lockdep_assert_held(&snp_cmd_mutex);

        if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
                return -EINVAL;

-       if (copy_from_sockptr(req, io->req_data, sizeof(*req)))
+       if (copy_from_sockptr(report_req, io->req_data, sizeof(*report_req)))
                return -EFAULT;

        /* caller does not want certificate data */
-       if (!req->certs_len || !req->certs_address)
+       if (!report_req->certs_len || !report_req->certs_address)
                goto cmd;

-       if (req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
-           !IS_ALIGNED(req->certs_len, PAGE_SIZE))
+       if (report_req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
+           !IS_ALIGNED(report_req->certs_len, PAGE_SIZE))
                return -EINVAL;

        if (sockptr_is_kernel(io->resp_data)) {
-               certs_address = KERNEL_SOCKPTR((void *)req->certs_address);
+               certs_address = KERNEL_SOCKPTR((void *)report_req->certs_address);
        } else {
-               certs_address = USER_SOCKPTR((void __user *)req->certs_address);
-               if (!access_ok(certs_address.user, req->certs_len))
+               certs_address = USER_SOCKPTR((void __user *)report_req->certs_address);
+               if (!access_ok(certs_address.user, report_req->certs_len))
                        return -EFAULT;
        }

@@ -506,45 +520,53 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
         * the host. If host does not supply any certs in it, then copy
         * zeros to indicate that certificate data was not provided.
         */
-       memset(snp_dev->certs_data, 0, req->certs_len);
-       npages = req->certs_len >> PAGE_SHIFT;
+       memset(snp_dev->certs_data, 0, report_req->certs_len);
+       req.data_npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
        /*
         * The intermediate response buffer is used while decrypting the
         * response payload. Make sure that it has enough space to cover the
         * authtag.
         */
-       resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-       resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-       if (!resp)
+       resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+       report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+       if (!report_resp)
                return -ENOMEM;

-       snp_dev->input.data_npages = npages;
-       ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-                                  SNP_MSG_REPORT_REQ, &req->data,
-                                  sizeof(req->data), resp->data, resp_len);
+       req.msg_version = arg->msg_version;
+       req.msg_type = SNP_MSG_REPORT_REQ;
+       req.vmpck_id = vmpck_id;
+       req.req_buf = &report_req->data;
+       req.req_sz = sizeof(report_req->data);
+       req.resp_buf = report_resp->data;
+       req.resp_sz = resp_len;
+       req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+       req.data = snp_dev->certs_data;
+
+       ret = snp_send_guest_request(snp_dev, &req, arg);

        /* If certs length is invalid then copy the returned length */
        if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-               req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+               report_req->certs_len = req.data_npages << PAGE_SHIFT;

-               if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
+               if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
                        ret = -EFAULT;
        }

        if (ret)
                goto e_free;

-       if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+       if (req.data_npages && report_req->certs_len &&
+           copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
                ret = -EFAULT;
                goto e_free;
        }

-       if (copy_to_sockptr(io->resp_data, resp, sizeof(*resp)))
+       if (copy_to_sockptr(io->resp_data, report_resp, sizeof(*report_resp)))
                ret = -EFAULT;

 e_free:
-       kfree(resp);
+       kfree(report_resp);
        return ret;
 }

@@ -868,7 +890,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
        /* initial the input address for guest request */
        snp_dev->input.req_gpa = __pa(snp_dev->request);
        snp_dev->input.resp_gpa = __pa(snp_dev->response);
-       snp_dev->input.data_gpa = __pa(snp_dev->certs_data);

        ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
        if (ret)
--
2.34.1



