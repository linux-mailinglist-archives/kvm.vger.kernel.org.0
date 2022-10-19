Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277DF604FD3
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJSSoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 14:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiJSSoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 14:44:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA84196EF4;
        Wed, 19 Oct 2022 11:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oju0SLUf2Q8YVkSitsc3bqoCfSr+Zue2N1rcORwnRHxC8ezXW0ASo9XqA2ZhWpt1qDp6PLALfy1D9btyegVHTaLCKr8OLNeUvXTjCWxNoEvMjqspp/2wauo8MrzmOcmA/oaWk7Q4DhF6Hpy+OzHDEO5gPMRmtvmVr7CTuXeQVY4n862Wz6GYbg+OUdPvcvi7ZxvKsjlB5tV73PT2cGYbk1bqXP1YzMA9pTHpHPoxkulZeTXqX7O5Ie02mb9G+3RemR/0l8gFQpgkCihFxCTl5nCBKefueGzrZoIWCL/qi0jUC7FAa9RrQa3GOZ4RwNA2FKj25uJ4MqHHEoNMtZJ32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvpLdw9P1uHmA726pr91rGZEKmnVMFz+Y5reW3NkQVU=;
 b=MsVRljASdPrPU9aNY/FjAUqYCEGSUBURN02+X8TGFlcEL5q1cVl1LHhDIJXU/69WtqL38EQCUoAYUgPjZAQhGRxR9Lv1daLco/F6omVqPBicEb+6BsqTAQpIqYWok3cf98R0HgLC1pX9JASGf57VJZTXGszHykRj5GJ/n4XEDrR0SOeoXn8oUsp09nGSfqxgDxrhleX/KMDFiM5U0PNAcOwOVkyiUZpe7uNhpzPC2qYblgEGLYEdGMGW9Cg0ITLCJrk6nAsza8lsmSEsz/4cpU++2Dmbhi8lFYUOgm7gnxgl8p15owk34xr/PF2nQS/d6w/3PwemKVy+oFqA9vu1tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvpLdw9P1uHmA726pr91rGZEKmnVMFz+Y5reW3NkQVU=;
 b=FJMjMamQj796XW6XPLWDw46SjQUDzLmDzchQHj8DH3Ds8ylWtMMJtXkKGDb+URBDG+CIIOMnr2FcnFQMZcXtmGgqbyJIHTLebX87X4/2o8ffRkDLjclCftJk0YVcKOMkXaLLedTD7gxL1NHhNjCTQy1Qh1kmlqjpz9QV/2e/tp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH2PR12MB4151.namprd12.prod.outlook.com (2603:10b6:610:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 18:44:01 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 18:44:01 +0000
Message-ID: <821e750b-26c9-3331-7577-5cb832a35afa@amd.com>
Date:   Wed, 19 Oct 2022 13:43:59 -0500
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Dionna Glaze <dionnaglaze@google.com>
References: <20221019150333.1047423-1-pgonda@google.com>
 <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
 <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0064.namprd07.prod.outlook.com
 (2603:10b6:610:5b::38) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH2PR12MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: a128f351-ffca-4995-72d4-08dab201e3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZFMjDh7VNtJFia2GdqWFSkHY80+GcRwFR2AJQ7o9181FeqInml2GGhosrbvsX3lg9j1OQUuZbZsXjbG9ud/sPdpT0dHbSxYPNkLvz/Wgerc5yB5UmJKkbrJ4hePnGSOpNezfhbeHC8vnW11nRm/r3F5BQjzHXVit+4hu+PP0nJFTRZkkbnqLDTNgiOwsvNysOpXZhl0qnw+5LeAEYG1BPPn+YuwLwUrleJD0utR9v/Q1HiPi/ataIsz7xYNvy2uEmiUQcCPZ5p+gx5AMlKVepkdVZG2DO+A7dmmMaF1A9NnOWcdQGcCvQc4xRznkkhC1tW8LX05TNjQOCPP0vZpj0C4z8AiOnGqwdJJIpJzkorq0dglO229XOigOgo+LYP0bi7nkj56y1Azp1nf75Rre7MDnjfU3Phnr//r3O59ntR4ZAL4tzdCcCKsGgLeqcVwjP4unAq+3l0M8fO2xPV76CUaG0zNjyTFx4C118Y6ueYCfqFI4eaGnvw+LwxPC+6TGxCi1p9q8Z4Gq01/3X025g7dlBRI8xdCTs+nJf/a9uLS+Gx8mWd7WJ7MDxqVBO0LHz68nAyYLHe1JeEbL7wiRZ5clgQMcknvKhqfE5aRlslBsZUMH5iOHM+9fa/NhB8hED2Yu1VO2c1itJeBxbX87iM/BVyBZTO2DM2X1MSzOUdoF1jmYo2tDLFSbTHXOOp2NDtcQIHzmHBtt7za8KSKxcE04yJsWLxMA/AI1/qlTVD66lKcR0coUZp/2QG1uaT1xzulucbHh2OB4oSh0Q57ayM4Sqfd/TGwx2SUB/sWqUkYQHe/XvnPvwP9aNHxSytz3NNmwo+QSOmRTnI4FBePGQ+xhDvWFUOzQq7Vc0SawrA9TlTcN6W4R0jxLUTe9zn0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(2906002)(4326008)(66476007)(31696002)(41300700001)(38100700002)(5660300002)(8936002)(66556008)(8676002)(86362001)(6512007)(26005)(6506007)(2616005)(53546011)(186003)(36756003)(54906003)(6916009)(6486002)(966005)(478600001)(66946007)(316002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmFGditveEFjQnJEMlhGZnVoUzIvaFp5WGYvei91ZmdiNFlYdm1YOHU0YkFJ?=
 =?utf-8?B?TFNVUTV6ckpHSlNkeWJzZVZQOGNuYlRDRjhqTmVXSitDUE9pUUV2VkdlRGxI?=
 =?utf-8?B?WTE1WW5nRFhIMFFmQWc3cGh5R1AzL0YxaDF4L3FwYmM5WXovRHZNaG1DZVpt?=
 =?utf-8?B?TkNtQmpQN3FXenhHL0ErSzB3eG5GR0N4RlpDNmxnRG1QemVjQ1VlMTRnejhZ?=
 =?utf-8?B?dGtveTZSUUtna1FSTTJlV3g3VkFWK0wzKy9hQlUrVHVpb0gyaC9RakgvdHEx?=
 =?utf-8?B?aWdJNmhMYWEvTSt5WWltL1JONi9DNnZmUTNTdlZZcWl3TGdYbXNzMWVscnYz?=
 =?utf-8?B?aklaNCtRK0QrWWpQVFVndnBKL2k5OWFGOHFOdjZEQmx6dnRXTEhKT3JLV1lH?=
 =?utf-8?B?TjJWTjZSTFllMXI1bkpzcTBvZEhkRVVHQVFjV3BrWVdXbmpBNFFUQkZYOVdj?=
 =?utf-8?B?bWVwZS94bVZJWEk4TkZNVlMrcm9tZW1rTUZkOUFmQnhOR2pxa2NwcXZDNE01?=
 =?utf-8?B?TE5qVWViOHl4a0lhSXpUbnAxdFZyYUF1L1VVNmVJSlE3NGgzbjMwM2thb21r?=
 =?utf-8?B?MU92V3dsc0dvOStLQVIrcnF0cXNwZmlSdUJ2OGFWeWVFNWpFOTAxMDdBN2Fs?=
 =?utf-8?B?YnVxZTN4MkJpTTlwa3ljZ2dCc2thUlc2alM4N24xa3pGRzBkZFVkQytlZXZj?=
 =?utf-8?B?UVY2Z1hpL2FzWVUzOTRJaDIwa2x1WjBlZzhHUGRnUzBWL1dzSy9uZXBid1RJ?=
 =?utf-8?B?TnVnbjA4bDJENDZwcG9LU1R4VzJGMDBJdkdvcjRYbWhnRDZMaWF6Ukh3Q0sv?=
 =?utf-8?B?QTFjZU5LQS83YlI3WEtwMHRmTElYSTdROEdyejh3Qk5jYVdsU1RtRHIvdjIx?=
 =?utf-8?B?SzJVOTZZbERDMTNDNmE1NUdILzM4akMyYzdNVHg0TGFmNUdwRVhDQ2VjbnFt?=
 =?utf-8?B?WGRCYUl0alAvOWVCcURJTUR5eklPWmdvaEp2RWJveTFDZXFXTE85M2p2S2lk?=
 =?utf-8?B?V2NYVGIyOFI0UUF2TDBtd3VESDc5NmJrNTV2QnhXRC9nclVhVkdTWmgzWWFZ?=
 =?utf-8?B?WlJwZHpIME05WnVtSkNEREdJemc2aVIyUlVRRzZkUG15RDFwLzdBV2VvMWto?=
 =?utf-8?B?d0hVQVJBZ3FMejZURnFNRC84N3N6RWtlZ3FLUjlWMWVobE1sMzU3dndldHhH?=
 =?utf-8?B?SXZacm1Ga1QyWlpIM0piSnFlbmZWNndsWUlmMTcyVmg0SGw4MlRqRjUwbjFa?=
 =?utf-8?B?LzNQaXlTblE2OW5IZGNCYVBWVUh3TTlEYTdJOHE5ZU9POGRhMm5FckJ2OWRo?=
 =?utf-8?B?WklDNVFuYXU5YjRxcEUwTnJqWkdxemxhT0JvaGxqeTV1TlFxakVsanVXZno0?=
 =?utf-8?B?TWp2MFZrWXlIMEY2TjBybXJhSkJmVitCdkVLeW53YXRHYjNRanh6cExrY3B4?=
 =?utf-8?B?YUdEcWd3dFhCait2ekpQT2RRVDcxeXRleEpIWXdZOWNZZVV5dGhhNE1NT2NH?=
 =?utf-8?B?V2RDQ3NuN1ZNZUJBUThjWGVvV2FobDJBanRzRDRvUW1ReERZdHMyS29od1Ru?=
 =?utf-8?B?Z0JLaHhtTXg2dkdHb3Q2MjdFSTloRDdLTnVES0dQa254TEVtVG9oRGU0clRB?=
 =?utf-8?B?dHNLTUNGU2t5cWNHeUpaeWpBMWVkZG03SFd4RnlsWDZjWnprQ2pTMWFCQnNL?=
 =?utf-8?B?SEp5bWZyM0lnb1h4Wm9hTmFwUTBSQ29aYVU2d1VpcVNCQ2dhTmF4YThVamZ3?=
 =?utf-8?B?bS81M3VkSXdHTG0yK01wUHk0UjA0ZnFtMVZXSmFTb2hqS3VTOE1uU1BvRzRF?=
 =?utf-8?B?U2Z1a1FVQ2phK1ljaElvaWpjUkxKZWZqUjJ5ODRQWW1kSjZBQk42Sno5a0hQ?=
 =?utf-8?B?M0pnZ1phZ2FDL0FKNWxOTkNReklnNjZtV1VEaUFlY1AzQ081dzBaWXBSSTdl?=
 =?utf-8?B?ZHQ2cDBwY2RLczljaDdpblcyS1pqV2o3dkdndkNNYmp5Rkx3ZWw2ZVlmM2pr?=
 =?utf-8?B?Z1BmUUVKOVFxbDR1Qm1xc1l5aWhyVVdaZlpDQmMzQ040eDBLbjBEUHJTdUlU?=
 =?utf-8?B?TTdoc0hVWDR0RW5CWHk3Q2I3YTZzajl3RXJkd2lRMWpMbDBTdW84UDcyV053?=
 =?utf-8?Q?0ok6Ug8cH8k2MhPX90wAbw2ok?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a128f351-ffca-4995-72d4-08dab201e3ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:44:01.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvYiHVgn2Yg+smteGiwswV7b0M/602kMDew67lEWVuSRpfJdrLPobp4BlQVWUfKEGgmR0DYWY3pVJbUcSH1y8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 12:40, Peter Gonda wrote:
> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/19/22 10:03, Peter Gonda wrote:
>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>>> communicate securely with each other. The IV to this scheme is a
>>> sequence number that both the ASP and the guest track. Currently this
>>> sequence number in a guest request must exactly match the sequence
>>> number tracked by the ASP. This means that if the guest sees an error
>>> from the host during a request it can only retry that exact request or
>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
>>> reuse see:
>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>>

I think I've wrapped my head around this now. Any non-zero return code 
from the hypervisor for an SNP Guest Request is either a hypervisor error 
or an sev-guest driver error, and so the VMPCK should be disabled. The 
sev-guest driver is really doing everything (message headers, performing 
the encryption, etc.) and is only using userspace data that will be part 
of the response message and can't result in a non-zero hypervisor return code.

For the SNP Extended Guest Request, we only need to special case a return 
code of SNP_GUEST_REQ_INVALID_LEN. See below for my responses on that.


>> I wonder if we can at least still support the extended report length query
>> by having the kernel allocate the required pages when the error is
>> SNP_GUEST_REQ_INVALID_LEN and retry the exact request again. If there are
>> no errors on the second request, the sequence numbers can be safely
>> updated, but the kernel returns the original error (which will provide the
>> caller with the number of pages required).
> 
> I think we can but I thought fixing the security bug could come first,
> then the usability fix after. Dionna was planning on working on that
> fix.
> 
> In that flow how does userspace get the data? Its called the ioctl
> with not enough output buffer space. What if the userspace calls the
> ioctl with no buffers space allocated, so its trying to query the
> length. We just send the host the request without any encrypted data.

In the case of SNP_GUEST_REQ_INVALID_LEN, userspace wouldn't get the data 
if it hasn't supplied enough buffer space. But, the sev-guest driver can 
supply enough buffer space and invoke the SNP Extended Guest Request again 
in order to successfully complete the call and update the sequence 
numbers. The sev-guest driver would just discard the data in this case, 
but pass back the original "not enough buffer space" error to the caller, 
who could now allocate space and retry. This then allows the sequence 
numbers to be bumped properly.

> 
>>
>> For the rate-limiting patch series [1], the rate-limiting will have to be
>> performed within the kernel, while the mutex is held, and then retry the
>> exact request again. Otherwise, that error will require disabling the
>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
>>
>> Thoughts?
>>
>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
> 
> Yes I think if the host rate limits the guest. The guest kernel should
> retry the exact message. Which mutex are you referring too?

Or the host waits and then submits the request and the guest kernel 
doesn't have to do anything. The mutex I'm referring to is the 
snp_cmd_mutex that is taken in snp_guest_ioctl().

Thanks,
Tom
