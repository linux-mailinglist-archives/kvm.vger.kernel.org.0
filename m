Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852816050E4
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 21:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiJST4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 15:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJST4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 15:56:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A901D8180;
        Wed, 19 Oct 2022 12:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzDh8yxj0kIPSEStalr9l11SB8WZhSmMuXB52uV6zC2OOSPPC93n/0/+f05hFeXb6OzMCsdsD44szJ4+DpT1Nb/xUN2bggWA/lMUbnySABHfdGoBVTMlSTdzWHNlq2Ezrz7VqgFRBuNTDaja0od8NsnxJo6n0WyAAMTpwg35boScP/6q/QcbQfM5/fc73QX1wP+7fFydPFK23yreUTU/oWSunxJMavDtbqtveMxLdykDQ4v3bWWEZiPqmglueJ6aDLRI0twW3gEItRfVORViN/isdlsZYfCRwGNqgQTAoWEaWw050OhQZkbsqxN5fAAe17UP5c09bq8RgmBIL5C9eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgaCfYnW+m/sZ0/p8Fu/sK5jd/i7wWlslDkYDpmDhlg=;
 b=UicFdUA+hhzBkh7xtWhWTYcEXcGWKCmncqa1RTp8GqLVxEVY5v6MsMvhPryae6zjayfgOY0AIhc8ZzALBncEazVqhgeeEU+lRsbSJ/dQsY8mKq+vwl81BdAp62vKr+BxfZHhcSrRYo4ZJGqIArPEwTdaBvsvMNNYCqagQWnrXYJaLbO0ihcFJ/FgoYIR+J11bgb3wrOYfDC+UUa+z4yzUUiSu3t5wkzZGGAwhhnxR+2MHhWK2kBQ6nAgwn+tm4mjk7ukUJDcLpOumdIH9afEQfYi658tgZ2/4THgAeYuOYnOkTK9r9kCNQTjFeIe8vf5iin63e0Mx6EMAvaUtduVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgaCfYnW+m/sZ0/p8Fu/sK5jd/i7wWlslDkYDpmDhlg=;
 b=UoUhHOHn5AMIst3436EQkmb5H6Sm3wDdwuLi45aL2BvifjV4urMDWBkruH0o19+3mjOPr+8gjhjwTbYk8reYg70x9nzim1lHM3QNeBgJ0z66nLhxp98kZg1utMJYcSrMdV/UbBGDFI/C4DjZNz98Yqrbi2S9OiDIMb9I43jjq50=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 19:56:25 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 19:56:25 +0000
Message-ID: <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
Date:   Wed, 19 Oct 2022 14:56:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
Content-Language: en-US
To:     Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221019150333.1047423-1-pgonda@google.com>
 <528937ab-8046-d5d1-26ff-50ef35f5635f@amd.com>
 <CAMkAt6ritG1zmOreh9WYLYAGww0EJQy+m-Y0nfxD5+gpTkpJ1w@mail.gmail.com>
 <821e750b-26c9-3331-7577-5cb832a35afa@amd.com>
 <CAAH4kHYhLkiN7H03GKgMU+3h9rhp2a03gNFGLbrNtjp=PYYHQw@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHYhLkiN7H03GKgMU+3h9rhp2a03gNFGLbrNtjp=PYYHQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:208:32a::9) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 0403f370-574e-4381-b4c4-08dab20c0110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Xz7IJEzghCqowYy8YlQHuz6xaSWg5ZbZ+iT3riURn2j5p/W94zsJsFl4c0zcPHCFfZaOkZCTD+yVn+1LphiqlYMeQnBt35F/EBgdW2X3sdsU/cHLzvmQVrSuMMlJeJbY1C8GDu/Ls/AO+oYGei3bHWUyoe5qGZ8Nfhoft6mC0pvPlYBwgSDj2qTK642IQ5VcrmZ/mCThMO+t+xOEpegDgP7haC9Q1PulcczMbJVxE2bWaz3SlJb14GADJYDqUM2K2w4zIsxUbjRvJBJty5IZKTqLaXUWTVsK298z0O5tgm4Wh5ZVcYC+tgjtgiaB9WCEvvmBODIjcGOdiWMFG3iba+my2aY5k3njw/CI2XjYqEsmX9h182a/M72SdmuRoFerVYDhINjW/JtR/DmjndP2a3ix/8Jj9P6GN22iK4kA04KUj9jAxVXRJeXw8OhTVPsGdI2X+lGuU0yfRWA9iRcCwpDvX+myHA7auGjROhomhxQNecNG2kczDMZLQt3QkyRtwUozHvLfLd4AZkOc7jG9gp48TZERYkFx3DxFa+DO9X0WLnS0abh/DdHeTMp5yTPVX7OiFVaRUvgw9pKAIdO4kYz3ALkE5ry+CMKoCTgmPGmxT5ksRZd9MAyLOnihr0YEVHTebKUAQJKK/WsCYuDyRqiE3e/tyF8fEY2FgMV04oyY+vgBuK11msCPG324TDPyPjnDl/uOFSngHPKvu6dL2nbqX4KNGfq6qDFy+2eqkzdf3uRGgh8U1p5X/qtWVH9cWTa1o2w/Xse35LdufbnuWVSY0wvjoC56WCLFtXGNDWzJO6FNIR7/BeW/tO++1HCXBCiIqiAeK4eyDF/Di68FWokGpUU1+JCYWfmSOneB9qvp/ZMF20YCqRkq/TTz3gY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(31686004)(478600001)(6486002)(83380400001)(966005)(36756003)(6666004)(86362001)(38100700002)(6916009)(54906003)(2906002)(186003)(316002)(2616005)(8936002)(41300700001)(6512007)(31696002)(5660300002)(8676002)(4326008)(6506007)(26005)(66476007)(66946007)(66556008)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3g1S3MzU3ptc3ZxdncxNVpDeVZvKzd0L3VpZUwvMmZJemFkM2YwVkgzWVQ3?=
 =?utf-8?B?eGpGeUtLek5wSEhsRmpUQU1Na1dzNjdNZitVY2lucjQ2MDJQVXAwM0Z4TzY5?=
 =?utf-8?B?aGpNNFNIdlYwU0hVRmJJQjRsZGhJWjFlN1g1QXpLUDFDK2lSUTlLZmdBdUNv?=
 =?utf-8?B?MlNNWkp4RDJTTVhSUEdybnRvMEUvOHZyRDJpVGlJYnJDNFV2RHREMHF6RVUr?=
 =?utf-8?B?ZkZlOURKOXhyUU1wNmZyWTJ4MEdaRDdUUXMyaXkvR2E2L0lkMVk3RWZBckNZ?=
 =?utf-8?B?YmFpcUVzdFpGMURBV1QxNnFrTGtWTWtuNmhobk5yMi9idmlUeW0ydmJFVE8r?=
 =?utf-8?B?cXlmcVFab1JrVVVEaURoeGxoYU8rTnJEUmtKemYrVVZGSmx2ZzZHeVRsS0tk?=
 =?utf-8?B?VUhxbXI5M3BMdkd1aEZKY20xZ3F3ODVFNmdNUHFrTXVUTkhsZ3JmMUtZdjRw?=
 =?utf-8?B?YmRkYW9BUXM2N0NUeitOK2xiREZ1dFk0T09oU3YrcnVGNldkbXUyM3pUclBN?=
 =?utf-8?B?US9sV3QrT2hzU2htZXJGV1o4WUpMNDErQ3Z6RHNiR3RWNHkvc1M5cmljWnFs?=
 =?utf-8?B?dnhLNy9tR0lqaGMxYVlVVjFHTVFzSTc0NG5oUktYTERnMlowR3R3MUFJQXB6?=
 =?utf-8?B?WW4wWUp0eVZ6cHMva2hDQXptQWlsY2d5ampodnp6cG44TE1NRFJrdDdvd2pR?=
 =?utf-8?B?c1M5RE1rclh3N0lwODRzblh1SU9kUjVYUktjWnlhVWxTOWhVbzlxYVV6OEhH?=
 =?utf-8?B?VDdiS2xBT1ppRVZQdVVZdTIvS2FmK2NkSTVmanoyd2F5Vk9JSEhwZUFXL1c0?=
 =?utf-8?B?S0R6amlCeTFKRUt4Q0RLdGI0R0JUWldSck1iaUVQdTN3ckdNRW1iaEpZZjZv?=
 =?utf-8?B?NWJ6UkF4ZXg0SE5VWEZLMFdFUXErTWdLYXZocENvWDNyYm9QVE9iKzJsNVZB?=
 =?utf-8?B?TVNEbHFRL2Ezd1RVa2RsenlHM1A4bGlYMXdYVTRYNW9acDVKNWhsM3Y5eE85?=
 =?utf-8?B?L1pkU3hLeVVSa1pEcVcvUkpjQTdCNVFkMWZlZXdPSXlZVXFmTEJQQXUyYmtw?=
 =?utf-8?B?YlNDNlNDSXVqWHM2Y0tQd2tnR2thNFBrUWhMRU0vdlhGUlNNaVNKRVd0bjZT?=
 =?utf-8?B?bXpYTU5sWFZ2b3ZSNGErcmRPME9UQzFFQ3hhazZpRjRsMXJEbUIrNk4zOU1U?=
 =?utf-8?B?TDdJbXJheTljZmtpZkdkWjExUmsyMm9IVm82ZW1VSzJpL1VkRjZ1Si83U3Rt?=
 =?utf-8?B?VURDQi91RktZaUdjSmV2cTBITXJyR1BHSmtvSmFhbXpKTk5sWmRIWTFzOUlm?=
 =?utf-8?B?V0dsREx1dWNpWVprZ2xmRzdCdU1qWDBNNHpOamI5b0ljSzJxWERsOUxRK0VT?=
 =?utf-8?B?TlV3eDFERFNiUmtmMzBPUHFqWUFQNUI4MzMrVXEzNThHdHR3allodGQwOFZu?=
 =?utf-8?B?VkFieGw4cWRWMnAxM1RsRWVqaUJJZUdMVy9jYmJ1USt5VEFnbnptTEdDMEpF?=
 =?utf-8?B?SVZEbDAyNHF1aFkxclJ3Y0QrcXRNTDhmWkdXOXdobmpPN3kvYXZXS3N4am9n?=
 =?utf-8?B?VjA4TGdkYk5GNHVQTmtQSmwzeGdtR1BWbkFGOUkwS1Fmb0N3bHd3Z1JwMjFN?=
 =?utf-8?B?eTB2QnJDamxWU3ZVaERLNUY0UndncnNxZnArNFU1M1kwVmMvc1l1MjQ1dmFp?=
 =?utf-8?B?cXhYTENiaExMQkN0emkvRGpOcGNPZG94SnFLZ2tDcHdKMEdEQ3hpOVpnVFNp?=
 =?utf-8?B?bGxFYXBRVGQxYmh3RVhJTjMxaWJ3Mk5xRGVCK0FGU0VqM1pFcjN1OFNaMHN4?=
 =?utf-8?B?U0ZHdUxVb09UOStSa2ROWVN0Z1NoemRFekRTekNQVHVVa0Uya3dqbmVoUUM4?=
 =?utf-8?B?eFZSb255UG1yeXRYL25oTXBVNVB2UWN3cDZUY0J6VWRuc3E4ZThBWDBqcUUz?=
 =?utf-8?B?VnI5TlY5RDFwVDZ3Z25XNmFzUDd1b0sxZjNjcHZ4Sk9nb210UnNVanRqY1N6?=
 =?utf-8?B?a0Jaa2plQVZES21lMG5VN25RWUxZajZnTisxMUloVTVJZDZOQmN4ZnVqN2R3?=
 =?utf-8?B?UUZjQ3dHc2NPWVJjeDQwTU1WYjFTQWRmUXE3a05BbDdzazAvWStWc2JJM0Vw?=
 =?utf-8?Q?aH9q2954veF9mI+V4v0pRMtZA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0403f370-574e-4381-b4c4-08dab20c0110
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 19:56:25.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWQD7FbVRUs5M+cxke+DKUDtZUebUAVgDvVFpStAaYo/Sap/G8z/m6Rq8lqFpB9kDXKrhGngz8UKWMHvuClIqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 14:17, Dionna Amalie Glaze wrote:
> On Wed, Oct 19, 2022 at 11:44 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/19/22 12:40, Peter Gonda wrote:
>>> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>
>>>> On 10/19/22 10:03, Peter Gonda wrote:
>>>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>>>>> communicate securely with each other. The IV to this scheme is a
>>>>> sequence number that both the ASP and the guest track. Currently this
>>>>> sequence number in a guest request must exactly match the sequence
>>>>> number tracked by the ASP. This means that if the guest sees an error
>>>>> from the host during a request it can only retry that exact request or
>>>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
>>>>> reuse see:
>>>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>>>>
>>
>> I think I've wrapped my head around this now. Any non-zero return code
>> from the hypervisor for an SNP Guest Request is either a hypervisor error
>> or an sev-guest driver error, and so the VMPCK should be disabled. The
>> sev-guest driver is really doing everything (message headers, performing
>> the encryption, etc.) and is only using userspace data that will be part
>> of the response message and can't result in a non-zero hypervisor return code.
>>
>> For the SNP Extended Guest Request, we only need to special case a return
>> code of SNP_GUEST_REQ_INVALID_LEN. See below for my responses on that.
>>
>>
>>>> I wonder if we can at least still support the extended report length query
>>>> by having the kernel allocate the required pages when the error is
>>>> SNP_GUEST_REQ_INVALID_LEN and retry the exact request again. If there are
>>>> no errors on the second request, the sequence numbers can be safely
>>>> updated, but the kernel returns the original error (which will provide the
>>>> caller with the number of pages required).
>>>
>>> I think we can but I thought fixing the security bug could come first,
>>> then the usability fix after. Dionna was planning on working on that
>>> fix.
>>>
>>> In that flow how does userspace get the data? Its called the ioctl
>>> with not enough output buffer space. What if the userspace calls the
>>> ioctl with no buffers space allocated, so its trying to query the
>>> length. We just send the host the request without any encrypted data.
>>
>> In the case of SNP_GUEST_REQ_INVALID_LEN, userspace wouldn't get the data
>> if it hasn't supplied enough buffer space. But, the sev-guest driver can
>> supply enough buffer space and invoke the SNP Extended Guest Request again
>> in order to successfully complete the call and update the sequence
>> numbers. The sev-guest driver would just discard the data in this case,
>> but pass back the original "not enough buffer space" error to the caller,
>> who could now allocate space and retry. This then allows the sequence
>> numbers to be bumped properly.
>>
> 
> The way I thought to solve this was to make certificate length
> querying a part of the specified protocol.
> 
> The first ext_guest_request command /must/ query the certificate
> buffer length with req.certs_len == 0.

This becomes an incompatible change to the GHCB specification.

> By making this part of the protocol, the sev-guest driver can check if
> the certificate length has been requested before.
> If so, emulate the host's VMM error code for invalid length without
> sending an encrypted message.

On the hypervisor side, the certificate blob can be replaced at any time 
with a new blob that is larger. So you may still have to handle the case 
where you get a SNP_GUEST_REQ_INVALID_LEN even if you previously asked before.

> If not, then send an all zeroes request buffer with the req.certs_len
> = 0 values to the VMM.
> 
> The VMM will respond with the size if indeed the expected_pages are >
> 0. In the case that the host has not set the certificate buffer yet,
> then the host will inspect the header of the request page for a zero
> sequence number. If so, then we know that we don't have a valid
> request. We treat this also as the INVALID_LEN case but still return
> the size of 0. The driver will have the expected pages value stored as
> 0 at this point, so subsequent calls will not have this behavior.
> 
> The way /dev/sev-guest user code has been written, I don't think this
> will break any existing software package.

I think having the sev-guest driver re-issue the request with the internal 
buffer when it receives SNP_GUEST_REQ_INVALID_LEN is the better way to go. 
You could still cache the size request and always return that to 
user-space when a request is received with a 0 length. The user-space 
program must be able to handle receiving multiple 
SNP_GUEST_REQ_INVALID_LEN in succession anyway, because of the fact that 
the hypervisor can be updating the certs asynchronously. And if you get a 
request that is not 0 length, then you issue it as such and re-use the 
logic of the first 0 length request that was received if you get an 
SNP_GUEST_REQ_INVALID_LEN with the user-space supplied value.

Peter, is this something you could change the patch to do?

> 
>>>
>>>>
>>>> For the rate-limiting patch series [1], the rate-limiting will have to be
>>>> performed within the kernel, while the mutex is held, and then retry the
>>>> exact request again. Otherwise, that error will require disabling the
>>>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
>>>>
>>>> Thoughts?
>>>>
>>>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
>>>
>>> Yes I think if the host rate limits the guest. The guest kernel should
>>> retry the exact message. Which mutex are you referring too?
>>
>> Or the host waits and then submits the request and the guest kernel
>> doesn't have to do anything. The mutex I'm referring to is the
>> snp_cmd_mutex that is taken in snp_guest_ioctl().
> 
> I think that either the host kernel or guest kernel waiting can lead
> to unacceptable delays.
> I would recommend that we add a zero argument ioctl to /dev/sev-guest
> specifically for retrying the last request.
> 
> We can know what the last request is due to the sev_cmd_mutex serialization.
> The driver will just keep a scratch buffer for this. Any other request
> that comes in without resolving the retry will get an -EBUSY error
> code.

And the first caller will have received an -EAGAIN in order to 
differentiate between the two situations?

> 
> Calling the retry ioctl without a pending command will result in -EINVAL.
> 
> Let me know what you think.

I think that sounds reasonable, but there are some catches. You will need 
to ensure that the caller that is supposed to retry does actually retry 
and that a caller that does retry is the same caller that was told to retry.

Thanks,
Tom

>>
>> Thanks,
>> Tom
> 
> 
> 
