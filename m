Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A88604E04
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiJSRDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 13:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJSRDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 13:03:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89D318D836;
        Wed, 19 Oct 2022 10:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8yjD0a6WYm29VTmDjEezuCp/VSnISyA1rwjqJANioE32fcAnkmghxnJKrlrIwMUfPEQTMJZLOucn3dDRcR/jI+HquvyL28vzDm3T6Jhz11ZhR8TIt+Rxdch5t2Un3vk5RgWwPUtaRCV/uV2DxNbIz8iBuCpaRXndNZYJSGjSBX1zfNCofoL57UEyCZTu93ueO4/gQ8n0PSYtgJ+XgAZUoWc9KmXnE7CbL/9BBuirYizXRjHMchm8U98dA3x6DPLv14GpBZCoYqHH1XjLlzpY57dRt2th9xQ6LESu6XehqeAdlX6yLVPr7tbwA6oJwx7eEgJ4RZdGB5t7UnCJnZKnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZgZR6MFJUqPrnkcYsFJV3EOGNdzaaAY0h8uD0plsbE=;
 b=dxQnm43fM7k1IGIfO7gST64KXwUq6FQ0M5sjiCHJfvoAwTG/HyCOghtxGXJznN2VyIr4AacZcnE54cgG+jkWaRAodYE5yJ6r1Jfc3M4/8MnG9HzhIJGyL+X+M90Qf/q9PjJUcwAvsmAf4NKiR7A2xfo3BlJZh7tT+nJkI8T5eCTK1HFg6yBGbmXeEl5qmt0TrRWOyzSpNXNXj1aBrDXWRnptxj2WUblZ+364bUhM7CRqEbZHkJIal7qUGTyrMpLoOaf/CtF87o2eyEx5r0NSryHVZ44IBY3P4/2cPbIVFnwFPnwsriKaWFvmXI4IFUXZUeZL3iHotpycI9jXrvwk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZgZR6MFJUqPrnkcYsFJV3EOGNdzaaAY0h8uD0plsbE=;
 b=44GMi4LG8WgNV6l3WxPKx5c+AQaVjKMUXLOOg/2MWZ7N3b+ruVaCWemO8tyi27kPT4FJEa6BNyUCgLWobVcpwmAerzHFE0+aYZq0llLIFWGvWRqE9WV0c/ljMsSDPMYYAKb2oMsIAzp2LvnldWqYw+2Yowo38DVFQSYblR40oIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB7635.namprd12.prod.outlook.com (2603:10b6:930:9e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 17:03:41 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 17:03:41 +0000
Message-ID: <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
Date:   Wed, 19 Oct 2022 12:03:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Borislav Petkov <bp@suse.de>, Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221019150333.1047423-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221019150333.1047423-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0270.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: b351a142-80f6-410e-680b-08dab1f3df8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bt9Y0t3YYzAy/s5S2pEm07L5+G/UcrhQjHwRPBPfor3aLAcR5PbTFhlzaLzbidRGo4nXheAT7D5dUaXw0oj1YmR8FNBuFdQecocRvB2lRn7tno8Ggj2/6fnXtdOXD1fj1vLjk03N+8vscWJkgwFYiqVBiWLTlX35cDKscMy5Zz7cyNthF0hH3syx8MOQnEQob/kJK1wL8R1BGd4mFjiGlAQ6LnuGBXA2C3lT5+TqSGoPpJC+vT9u82O7znfCm9yktPP2utdxSm51TAzfB9Lg9JL07kRq9vDqIcb9G1zCRP4CWCLmjCnD8Qa7Q1slElj4JtUsH8NfvBv3IAak5Bf1QunZVytiH4VEDGd+wRFA0wZmIVQ8Rml2f5lujKupFjJbWyRdwGuLsQPTPCainb3qP/XwDL1yovI4yE+M6hFmAN7ZAA8Lf9M6fCC+VrvXweJIcPuV6G4zIWBGj4Jk3e245A/u6GqbsvHXZ9kO2EsPmf17yYJkVDjRdjFTX47x4/NH5oOR7Cj3PFMO1hU0tI1xK9tm88IRGOMTFbbiMILhKtX2kDJh7gAHeRhgBxRXLRNrhrmbAT6bXTpV+JElz5MDeuA4ZktIJXJK7eC8K5qdPTPgSyXG4F4Qedeijkx06oNPfhyrXhuDSTnJXCcdL4AcdoTwSgB/qBngDg83iRDwYweCnvTKmbJXdZmGSSoC1Ub2QT5sGL0gfP60oo86GBl01I1/IxeAW73cfua2xiVA1Y/FQXAJS5xWrCxLAA9ZoFnFBw4gn/eoXN3np69QatqjJDNT/b1Hn5aWPWorrRFZLHfvFIL0redd6PVyKmuiRi4G6NoNC1o8Ry9bQ8nodxJxeufQdzr+pt26EiUgRMF7KhGYknhDyH7RpTbQ7GAa1mBr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(83380400001)(86362001)(31696002)(38100700002)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(6486002)(8936002)(966005)(5660300002)(316002)(6916009)(54906003)(26005)(6512007)(6506007)(53546011)(186003)(2616005)(2906002)(6666004)(478600001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1lmaExDK3lTZHpHZDlzTHBhcUJPZHlaNTZsWjMxZGdQeVpDZnNWOEN1YlBO?=
 =?utf-8?B?T2c2QmpYNHJwMmE4NDF3MExiV25pNldTaTFwSUZBbXpuWHJWNjNGY041d3Bn?=
 =?utf-8?B?Y1g1eEtDVmR4aHFuM3VWSDBhbDZhaG1iWEM5VmlVa2dFck4xRVNTQlV3aDFM?=
 =?utf-8?B?YTc5empzZktOYzVHRndkTXo3cE92Nmp5WmNEbE9sNUlIMlVCMS9nazREY1BF?=
 =?utf-8?B?eWZSZkkrRkttV1dwOEdDV0lKcGNLZmRxS2tRakhTS2ZSQ2xTOGRBUlNhTDhH?=
 =?utf-8?B?elU3MjlyZlYrMXhUTHRiR0k0WlNDUWZMTk84SENNRDFKUUZVbksxMlBLYjlh?=
 =?utf-8?B?OTNka0J3cmVqbXVEblJKRThhUyt1d0JHQ2ZSaDlmT2k5eXQzOUR4dzF4N0x4?=
 =?utf-8?B?YXNOOEM0ZnNIVVVobFQvckJyZFNwZE1NdnBSQmtxazNvbzUvRzFrOExvRmFy?=
 =?utf-8?B?aSsyUkp0a1lxNFYzcGF3M1VBU1owalNrK1Q3RzQ5dFVUM0V0emRLUnRIeXpq?=
 =?utf-8?B?M3MwaCtSYVJ3emRrSkYwU0ZONmpCR0VFS3BkaTJGR25TeWhCWXk4Sk9BcDJM?=
 =?utf-8?B?ai9iWDliK0Mra2s5NnQ1OUJzczBhU0ptd1VPK0czV1lVcjZFZGcyeDBmUEVv?=
 =?utf-8?B?aVhRNVFoY3lRUE4zTWlwc1VLRk1PcUc2aFprT0ViQ0hha0pKUDZ4Zi8xRWNQ?=
 =?utf-8?B?WmZLWWNrazR0ak5pUjV6VG1SemVzU0hWaXowbW5ZTXR3bkVTMVVGcEFLS0R2?=
 =?utf-8?B?UUhYc1M5dlZzbVVqZHJDdmlCcGVLNVFCVUdHU0pmeXNUSmluS1F3cm5vVEU0?=
 =?utf-8?B?MHB2V0RZaDh0eldJdHJqNzZTL09DMC9jWjkzZTFqbHBYSEZIVWc3enFlTXdI?=
 =?utf-8?B?Mysyc3p4REgxZ244YmtLTEY1UXV0bUV4RWVydHdENmVYVkxwZDA3eU9ta0RL?=
 =?utf-8?B?NTdOMnFaRXRyRnUzdUIvNTg0TmNCZWw5MnlWSzhKMTZmeHQ5QnRETTBKT2t4?=
 =?utf-8?B?OS92V3R0dG05djhwMjhiekFoQlAyQWJ6NTJtcWhLMjRPMjdXN3FBSG1CNER6?=
 =?utf-8?B?OTExNnJvSW5ZNEY0Wk9JWFhDRWNqSGNOUE9wZ2FTbGVpdzZPWDBVNW96RUlN?=
 =?utf-8?B?REV0TDQxalpKRTROYzU1Y0tDVDBsZXVNbmhsN0FOeHhJVm41Z1lqVXRCSTNK?=
 =?utf-8?B?bDRSdVVBYTgzZm5wQnh6bWVUR29GTjFrM2RZM2xJRVNOaVdmODFKWWVzOHJX?=
 =?utf-8?B?OTNCMEpwdUE1T0hGQTRvV3ZKL2xnRkQ1czR6emV2TEhZbE5sS2xJdW15amt6?=
 =?utf-8?B?c2J5VG5hTGhHN25XN3J1NHR4N2JxTElXUzlhZ1B2TGxJU01TY2M2YVJXN3BR?=
 =?utf-8?B?WHZrbXlvZG9nUlZlSit6cXZzZlUwdGJoVGFON0tMN0tOZjZhQmlham9mSzBQ?=
 =?utf-8?B?MHJHdEZVa1kxSy9NZkI3QWcybWpNelQ4czl5cTVrYkZZZnlDdk5kSytTRHZt?=
 =?utf-8?B?ZTk4c1g5Z2dkd2g1QzdGNWxncFVtdGdVdWUvdWQzdXVGNmV1WW1yNzR6YWlI?=
 =?utf-8?B?cjdkVEU2WnY3VEpjL25vUXIvSytoUjVnSkVHMUdqVnFib0tSYjh4ZFNZeW1j?=
 =?utf-8?B?NmxlV0ZQWVlmVEh3ZTZ2OTlOOEkxd0s2aCtOVjgzWkI4NlJ0RHd6c05lVm1z?=
 =?utf-8?B?bU51cFJnZWtua0JaenJhZ0V2NWV3LzdNVDFQMWJ3b0h2TjFGOG9kUEJXK09X?=
 =?utf-8?B?SExlVVg5M0NVZWluUDNNL084RUFuUWRONk83N0tKWnJxVmRYd3hBcmthZFBa?=
 =?utf-8?B?YWhoVmdJQzFiNG5ncE4rKzNQQ2taempJcHIwbHU0QmVKN3FxcTNmQW5XYU00?=
 =?utf-8?B?eEkxV282czZaUEZ4ZHlMbUxQRWlyTVZYS0JzS1pJamtrSE5jQTlublJQUktY?=
 =?utf-8?B?bDI2YWJ6TXlRK243aVdDK3dXWHJvNnVyTk1oOVY5Ly9NUXhXRnhOaDhqQkRp?=
 =?utf-8?B?SCsvV0ozeFBEZUJ6MzNEQVJGQU53VEt6bG1FYmhjYmh0Tlh2bDFWL256RHcx?=
 =?utf-8?B?UFl6M3BjV2Rjbm1RRHloV3NJYmtoRXQwRGFMOFcwcmtSS3d3N1prb0J2REQ2?=
 =?utf-8?Q?WU0G9QmEeV0KuJ7pvxAPkx1ZJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b351a142-80f6-410e-680b-08dab1f3df8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 17:03:41.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNqRiIO9m1I2LdXN8N0SFf1KKqViHg/MrkV9dHifdDEDJe9GLp0wz8oK9VM96pnP7M7CQommgC7TuL/3hglX/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7635
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 10:03, Peter Gonda wrote:
> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> communicate securely with each other. The IV to this scheme is a
> sequence number that both the ASP and the guest track. Currently this
> sequence number in a guest request must exactly match the sequence
> number tracked by the ASP. This means that if the guest sees an error
> from the host during a request it can only retry that exact request or
> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> reuse see:
> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf

I wonder if we can at least still support the extended report length query
by having the kernel allocate the required pages when the error is
SNP_GUEST_REQ_INVALID_LEN and retry the exact request again. If there are
no errors on the second request, the sequence numbers can be safely
updated, but the kernel returns the original error (which will provide the
caller with the number of pages required).

For the rate-limiting patch series [1], the rate-limiting will have to be
performed within the kernel, while the mutex is held, and then retry the
exact request again. Otherwise, that error will require disabling the
VMPCK. Either that, or the hypervisor must provide the rate limiting.

Thoughts?

[1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/

> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> 
> ---
>   drivers/virt/coco/sev-guest/sev-guest.c | 45 ++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index f422f9c58ba7..227ae6a10ef2 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   	return true;
>   }
>   
> +/*
> + * If we receive an error from the host or ASP we have two options. We can
> + * either retry the exact same encrypted request or we can discontinue using the
> + * VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if we were to reuse the sequence number the encryption scheme is
> + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> + * reject our request.
> + */
>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>   {
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> +		  vmpck_id);
>   	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>   	snp_dev->vmpck = NULL;
>   }
> @@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
>   	if (fw_err)
>   		*fw_err = err;
>   
> -	if (rc)
> -		return rc;
> +	if (rc) {
> +		dev_alert(snp_dev->dev,
> +			  "Detected error from ASP request. rc: %d, fw_err: %lu\n",
> +			  rc, fw_err);
> +		goto disable_vmpck;
> +	}
>   
> -	/*
> -	 * The verify_and_dec_payload() will fail only if the hypervisor is
> -	 * actively modifying the message header or corrupting the encrypted payload.
> -	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
> -	 * the key cannot be used for any communication. The key is disabled to ensure
> -	 * that AES-GCM does not use the same IV while encrypting the request payload.
> -	 */
>   	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>   	if (rc) {
>   		dev_alert(snp_dev->dev,
> -			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
> -			  vmpck_id);
> -		snp_disable_vmpck(snp_dev);
> -		return rc;
> +			  "Detected unexpected decode failure from ASP. rc: %d\n",
> +			  rc);
> +		goto disable_vmpck;
>   	}
>   
>   	/* Increment to new message sequence after payload decryption was successful. */
>   	snp_inc_msg_seqno(snp_dev);
>   
>   	return 0;
> +
> +disable_vmpck:
> +	snp_disable_vmpck(snp_dev);
> +	return rc;
>   }
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
