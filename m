Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F259F6080BD
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiJUV1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJUV1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:27:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AFD29E5A4;
        Fri, 21 Oct 2022 14:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl3iGSdhsIDx/7oEMhmLRgCSC6UHTWa7QybNS5uhfwrOWWt6ZPhOzpzY+74dzVeyeUIoNNUV/rn3F2dor2hhIK7AN+FqeYuYl8bcIrS4JqticOsbj84qMBgEGknRBpkdPU3nkHludFiRFqvur68zR2BMLKRb2vsWAaLQB2+kgtf4h03t71gWRrYd7JnCux2IRm/uZw5vz+lDu91YVQfdSC6oJnQFviZ4wS3dJZLsRuvgZ1T6hbubWGuaHIFS3ux5QvVXH73+CLgRtx+UWeVPgskdbVksTVR0B6MTpUOQfnqMpsn66CufBZ/TDl6569XzxVJ91p75C5V1iTt1yr0iAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTmGk0PIUYAQnZtD2J9iJxNjHJUr1z3zOGY6EmZMeo4=;
 b=XGSH/PD9NMNc93yJgEyWGLjPV98qnaIiiu6+D0IT3wLslUKYY4QlXuQCaJtWNuQhkAFb4/mGQsz1rUx223v302dUozHARje02D9GV7BXmPhU50FNpWEG0Z4oWxv9Gg31R01IJNf3f6KfD0z8wP4+a/NUxHXkm19Ep5S5M/tyix5rloaeh73xUHRfjuYixaAIwB9Cx/Ohmvc83Kq3XRS50q/GpWIyxZesrWxRulg//4/lXQKeQl7gseic7W+nvHd9G6SpVlT08gk+EilFOx/mOSWQplZVY/tW/6nnnVT6fPFWFHAIR33HvKvBQYP1iyAAefypSFjrcpnyv6pe7FVajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTmGk0PIUYAQnZtD2J9iJxNjHJUr1z3zOGY6EmZMeo4=;
 b=DqQAyxaT7kec34pmQNdXe/arL52jbd4sQuuBRCzPSUqTt8Sm55su4fLwbAHvNMJniM0sg2IPia8pU4yIy/Zb7o6k5mS/fQjIv/U+9bZhXNtprHcxvma+OY6xWugFgxmB85pfw92p8NpywJovpZbag9EYAr1fg5CuuVQpL+ScRu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6142.namprd12.prod.outlook.com (2603:10b6:8:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Fri, 21 Oct
 2022 21:27:11 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 21:27:11 +0000
Message-ID: <93846971-7477-6f03-a6b4-f1461254719b@amd.com>
Date:   Fri, 21 Oct 2022 16:27:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH V2] virt: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221021173328.2489411-1-pgonda@google.com>
 <b7414cda-9924-33c3-68da-9b26b2bcc0b6@amd.com>
 <CAMkAt6rCPYi3EewVfrTb6ie5VZwSnY0aEv_oDT4pom9dLTgf9A@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6rCPYi3EewVfrTb6ie5VZwSnY0aEv_oDT4pom9dLTgf9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:806:d0::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: d45d4c6c-ece0-4251-0d91-08dab3ab042c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bH1TvO9rKuL2uUJBEhu4XueDADOJuXLnEScr6Rlrm6o6Zbwx2cEWpFZqlkexybVsReOIVdAjxQXfrcED9DcHOenlzWALBnO9xs7P75BhLDv5TKMPKjF0auwQyhkaIcrL+QBIpu7qdbjy3haiYATEvsarpGJYZbwCtgmfi588xUaaLkLLMCPATnSsVekRSu7BmvQnFfs+tXe+Qu082xJVlTy9MuM5mxC2orvlyA6NnI2V+svDlXY3eurQ+SGAHXK/5cunHh1EEtQla/aQUIOqs61HQqw+bta2fiP0fE9pwxSzkmr1JvvpqDBtRU2hZijyHUDah6h4mkJ13P7RREfPJQ8DHbUyKbxULZt06miJclfuQw0gJwsUmWJAyO+TfJH91CbEKUBjXBo7ay+d1p0ED7MyWhkMfr7d/FW6b9nMjZ9lKcNC+vBFzeABN6c5PaD9+Ta8YzYuZXILTG/tacCPB8zwGFIYr7s1feSu8sd0VgSrs5mhgc/DEofcLRhQxJDGarkhQuBBsCZcfMqC/XARJGIHJSXh19DaSjdA5ZpgDCUHgdfp+14RVezom5nESk1FIE0syGkn14jQcoa88espZTR00Uo1/E2aloy/C6yddOpFC4zxTmXddDqm5d0rxHH895s/jeFvETAUjIT7NcdiTyr1OBqyFgbQRL568VleG1OWuXqgJZwEOEPjkDOyHyWFv5ZTDSOFMO9DkvHVZVVcN9FcCrIPspODebh3LbjPnohsoy0lMzwqkVkb/BM8iQHgbxDcCiAFqUfz9/rAHQG8B0ZYJ3tb9Dtpw+8RQPt90R4Us50eCExoLZO+iIrz0hU3DeZBvsRf3t5QfFBey4Hqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199015)(2616005)(53546011)(6512007)(186003)(2906002)(83380400001)(5660300002)(6506007)(26005)(41300700001)(6916009)(478600001)(8676002)(66476007)(8936002)(966005)(4326008)(66946007)(54906003)(6486002)(316002)(66556008)(66899015)(36756003)(31696002)(86362001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RStmOUVHNWd0YSthTGpYYWp3ZjdROUpkWDRVMDBIVkVlUE1HTmo0ZVBaL29Z?=
 =?utf-8?B?UWpCNXl3WWVRVno3NGZhS3dNWWVDeGZkUGhjTEV0bEEyeDdRYTFGcm1Rek1l?=
 =?utf-8?B?ZlJWaDducmIra0Qrc0x0UlhMNmtQWHdGa1RkeEtjNTNMOE5iNG1CT283b1Vl?=
 =?utf-8?B?VWRWRE9SY0xXM2dxWHk5MWo0UnFLT0Q2RHBodGZ0YWZpK2NBYndZRWRud0Qz?=
 =?utf-8?B?ODRCbnBOV2c4NW90a3FBcFpDQlE2eHVxSG0yelNUbkg0b2I1MnBoVnRGMmRK?=
 =?utf-8?B?UG1LWTBSWnA5MEJoWERTWWVMZEtZUTNFbjhvVitmaHlkZ2lmM1E0MHRmV3Nz?=
 =?utf-8?B?Z0NKTC9OQlNNdnNRNVlqaHdsY3RvTkdvOVREOG9DRnorMWVwZjN2Nm1ld0o5?=
 =?utf-8?B?Yll0M2Z5NG56WDMyQmNjSXhQZ1FRM2daOFNEcDVYU0pVRlJ2YktnUmF4WHU5?=
 =?utf-8?B?V0xLeU9SeW81SVd5MkRGUWRFeEZNNnJ3c3d6U0cwVVl1aG1uRW4xWFRIM2tV?=
 =?utf-8?B?K3BKajRvR0hRSnROM2tHWklPRkFLMG43ZUNlT3RTNERRSzFyaEJvaE9rd3o1?=
 =?utf-8?B?UTJ2cjhZU2dMSkpuYytSTjlxUENLMk5KVzZHR2lEM0ZzektCV21kempuTEFu?=
 =?utf-8?B?VUQxZndYNUVxQyt5bGhNVFlHOEE2ZnRpNWxNSGQzZVlocVN3aDdFRGduRWYx?=
 =?utf-8?B?ZVdJbVBvU3p6RnVVZmdheW9zVCsyUTVPNVhjM1FtSlg3ZXlrR1gvSkJPWmZS?=
 =?utf-8?B?QXBxY0hFNnZWNE9ZalRMUHozL3lBYmpkV0FRa3RCNVpuTGpiQUw3WjNJNnhM?=
 =?utf-8?B?MWxGd09kTGR4YmdjK2Nua1lyYjdmS0h0dlAwMUxFQ0RKS250L3NyVE1YaFVK?=
 =?utf-8?B?QUJCTWsyVmdxY1VUZlpGMzdzVWxzcGVsTVFJdndJSkFRZHd4MDI0YnMxRGVv?=
 =?utf-8?B?bXI1RTVWckQ3a2xVaW5qSjNDWkxRSE40TVI2SzFBbTQvZGFFc2pnME0xRkkr?=
 =?utf-8?B?MDhHMEtmNGFKVDRzejd4bnBUZkVVQk9nYlpWSEpwdlJ5YU1vM1pxZEhmOTE5?=
 =?utf-8?B?MHFuZW5zSXprdG1WcThCakhIWmtLWFJYcTE4NnQrdloyVjhvR29sRUlIMWM3?=
 =?utf-8?B?WWRVeDJTeWNScTZVOUgyNlR1UDVnblhIajliRjAzejhvSUEzV3piQllzSlgw?=
 =?utf-8?B?N2JuU0p5emtBMk5yNFduSmJyNmxJRFNVbWVZWFJyTCtDdERoeFRieTVqU0o0?=
 =?utf-8?B?UjN6dEYrbFd4UjFPNFFiakhYTmhtWWFtdnB4VTNNSStucUFuSno1NXJhUWtP?=
 =?utf-8?B?SlhUZFY0MDhSU1E1ckIxUmZjZXNLK2h1NVVYS3NVMmZOVkxkR1RlK2tUaXl6?=
 =?utf-8?B?V0ZyOEg3dGxkYWNQRWRrb0RRYzlQS0pWTDJHUzNKbUp4Q2N0cDBlbFJvdW9v?=
 =?utf-8?B?WmFybUZhQlJ1OVZYd2JBMWNpOUh0NTU0enlhcitIQllCTGhtbHM5VGJmNnRM?=
 =?utf-8?B?KzFLb1h3bEU0Q0lpU2xaL29teFlDVUZFM3Q5bENwV2FHMGh6NzJTNG1iMFJS?=
 =?utf-8?B?bG56aDRvTlNsZkdyMXZtdEFaMlpuMTRicmdtVU1Nc0NoNlF2M2ZOUmtoMTVE?=
 =?utf-8?B?NUVWdHU2c3lXSnRucGJhbzJPNmF1RDVNOGVZZW1TRHhvMjdrQ0NobDhUc0Zy?=
 =?utf-8?B?MG43Tm5LVkhVQmV3aENsNmo0Ny9HOGF5MTY5c0dveSt3ZHE0K2UwVElFZGlv?=
 =?utf-8?B?SVVzVHdTSzlnTTdqQVBXekNhV3BpTzJURlk4U0gxeFNxdE5JdG9SRXhweTNp?=
 =?utf-8?B?dHpVeUhsc0VIZXd3T0RoUHpsd3ExQjZXZTJLQ1BGZmpoVU9KbktONCt4T1Vw?=
 =?utf-8?B?aGprYWJ5S2t6U0I3RnhYRGdKWXAxcXpSdDV1bWxPTkp2am5saWpaN2pNTXFO?=
 =?utf-8?B?MlFJanBsamZaNmJvOHE5a2VmUE5lSmVuUmRITUtSWXpRWkpOUldIVW82QTJQ?=
 =?utf-8?B?YThRWXVXQ0tFMTRCcVV6RVBnbGJRYjNkVWdzcEhYZmdqRXRZTlM4SkJJYTYw?=
 =?utf-8?B?M0dyUnlGMmwzSm10TktQZWJTeWFwR1NzSmk3UnFIRko3ZUdCdkRBWitHTURv?=
 =?utf-8?Q?930mvvo9OAnLjgm0ninDl5EMY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45d4c6c-ece0-4251-0d91-08dab3ab042c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 21:27:11.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVHdhvicCpBqgjCjYChp3qbfe94g5Lc4EOkNCl4tCKH63+F9e0gNoSKsePQVMvZKM68Jv8YyjuQXNPgRKzBI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/22 15:57, Peter Gonda wrote:
> On Fri, Oct 21, 2022 at 1:02 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 10/21/22 12:33, Peter Gonda wrote:
>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>>> communicate securely with each other. The IV to this scheme is a
>>> sequence number that both the ASP and the guest track. Currently this
>>> sequence number in a guest request must exactly match the sequence
>>> number tracked by the ASP. This means that if the guest sees an error
>>> from the host during a request it can only retry that exact request or
>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
>>> reuse see:
>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>>>
>>> To handle userspace querying the cert_data length. Instead of requesting
>>> the cert length from userspace use the size of the drivers allocated
>>> shared buffer. Then copy that buffer to userspace, or give userspace an
>>> error depending on the size of the buffer given by userspace.
>>>
>>> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
>>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>> Reported-by: Peter Gonda <pgonda@google.com>
>>> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
>>> Cc: Borislav Petkov <bp@suse.de>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Cc: Michael Roth <michael.roth@amd.com>
>>> Cc: Haowen Bai <baihaowen@meizu.com>
>>> Cc: Yang Yingliang <yangyingliang@huawei.com>
>>> Cc: Marc Orr <marcorr@google.com>
>>> Cc: David Rientjes <rientjes@google.com>
>>> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: kvm@vger.kernel.org
>>> ---

>>> @@ -477,25 +496,37 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>>>        if (!resp)
>>>                return -ENOMEM;
>>>
>>> -     snp_dev->input.data_npages = npages;
>>> +     snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
>>>        ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
>>>                                   SNP_MSG_REPORT_REQ, &req.data,
>>>                                   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
>>>
>>> +     resp_cert_len = snp_dev->input.data_npages << PAGE_SHIFT;
>>
>> The hypervisor is not required to update the number of pages that the
>> certificates actually used/required if enough pages were supplied. So this
>> value could always remain as 4 (based on SEV_FW_BLOB_MAX_SIZE) on
>> successful return.
>>
>> And if that's the case, we could always just return 4 for the number of
>> pages no matter what. Otherwise you'll have to update the logic here if
>> you want to obtain the actual number.
> 
> Are you asking for this to just hard code the userspace requirement to
> 4 pages? We could leave this as written here, that would leave the
> guest open to a new GHCB spec where

It's up to you. Ideally, if userspace provides a npages value of 0, then 
the driver issues the request with 0 and gets back the actual value. Then, 
to ensure the sequence numbers are updated, you issue the request again 
with the either the just returned value or SEV_FW_BLOB_MAX_SIZE >> 
PAGE_SHIFT. That will update the sequence numbers and the driver returns 
the number of pages required as returned from the first request.

That number can also be cached and then whenever userspace calls down with 
npages of 0, immediately return the cached value. If the request ever gets 
a SNP_GUEST_REQ_INVALID_LEN with the cached value, the newly returned 
value gets cached and the driver performs the request again, like the very 
first time in order to update the sequence numbers. The driver would then 
return the new npages value back to userspace. Of course that becomes the 
"minimum" number of pages now, so even if the hypervisor reduces the size 
of the certs data, it always requires more than needed.

> 
> "State from Hypervisor: on error will contain the number of guest
> contiguous pages required to hold the data to be returned"
> 
> Is instead:
> 
> "State from Hypervisor: contain the number of guest contiguous pages
> required to hold the data to be returned"

If the driver always returns 4, I don't see this as requiring any change 
to the spec. It may be more than is truly needed, but that doesn't matter, 
the cert data will fit, it just may be more than necessary. This can occur 
even if you pass back the actual number, if, in between the call with 0, 
the hypervisor updates the certs such that less pages are required.

> 
> I think this would be a non-breaking change since the spec says
> nothing of the non-error case currently. Fine with your preference
> here. Either Dionna or I can follow up with a series to allow more
> than 4pages if needed.

I'd prefer that userspace get the actual number, but really, I don't think 
it's a big deal to just return 4 until the driver can handle a more 
dynamic approach should more than 4 pages ever be needed (this would also 
require support on the hypervisor where currently not more than 4 pages 
are allowed to be provided, too).

I just wanted you to be aware that in testing you're likely to see 4 
always returned to userspace.

> 
> The logic required would be parsing the GUID table? I think we'd
> rather keep that out of the kernel driver, right?

No, that's not the logic I'm thinking of. I'm just thinking of using the 
userspace specified npages and acting accordingly.

Thanks,
Tom

> 
