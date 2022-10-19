Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E1C6051A9
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 22:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiJSU6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 16:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiJSU6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 16:58:33 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2080.outbound.protection.outlook.com [40.107.96.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2515E1C4920;
        Wed, 19 Oct 2022 13:58:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XevjOFc4D5blByItFuBmRPZQqYmiZt5peFKzQXiGzfEuR8dj8wAOp2DDKsjDfZbksrRfakYwL2EqEAl3/8t2z40PH2Xlhx6Z5fk88HjlqNCo8Ft5jE22KYl/OcnsRBnDwW0kRc0Rke0/mQ/9SszyBwcx+LQR7kDnOhO2lAv9H21+4rwKzTUfYwMlqCHs3rMYu/pjUSeHiEqs2XV4rLhW7QpGAcRRSDgFYxTbgEV7CJi2nKnNqFxIVQnI0AawqRF++f+xJLljQxeDWSd+hGrkr3upeqk2NvrrtUMKly40cz/V0qg6tYx/R3o/EcCvU1qLiVqIizQbxy0x8d1gbAKjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yl7mtEH25Pc6+rDOzuvbOww7vGpO2M8JHAVpeKTKyts=;
 b=CeLMQ+G3+grZcT0he3lng5UhN5xUHMXkyyjFa6Wrdtpvhuw+fxHbkFjJpKWZBPozGjC+0s/XH8gyc8TRwpZTY5ZejicOpXkphnfm47haNjdUaWgBB/VJG/76hPAXqHeAO2V4rSpZcuYLEofOWYpP35553NFxko8qhMyhSa5w0vFdFhLJAtR5W01GYAjcAtN2HZGmZQj+T5Xt8L+e2SQfOFPUiAQPgHWFuUsrCLzNscHtBhivybvn13zk/o/nMjZklvtq5SRY5yxSyJmaFWzW4Q6tMXAeaCOBhsYW3Sqjulg4ibc1jW1kpNAlxIVXN7le4EcpH+/X1CUATcUW6E/lfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl7mtEH25Pc6+rDOzuvbOww7vGpO2M8JHAVpeKTKyts=;
 b=nmVo199BPDoeiVpfnCV6yjB4T5lN3caodZxzxNV0McT6W0cf7sEuQxQZxpSToV2rsB5kT7npHIFlq4IV4JeaPmDCwBmc6XolBDYhQm2L3bzfD9AsecC4EAnjXla12fM8f4gas+Q5pKmxUy8DmzKXUYp623Sbp0c2fom4cAxH2DQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.26; Wed, 19 Oct 2022 20:58:29 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 20:58:29 +0000
Message-ID: <948704a4-2348-041f-4f46-bbf42d985549@amd.com>
Date:   Wed, 19 Oct 2022 15:58:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] virt: Prevent AES-GCM IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
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
 <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
 <CAMkAt6pCPmf++Dg=x5bSN4-gR-s7BuYiryOGvGezLupFN9aEKw@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAMkAt6pCPmf++Dg=x5bSN4-gR-s7BuYiryOGvGezLupFN9aEKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:207:3c::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f8e3535-2575-47f1-5615-08dab214acf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMj/+U/ehn342CvpsIObUtHOhLtYxqRrd3/q0D42Ew0gisErw1B4DcuY1FkU0TlWJ+YVUwL1FnL+2WDxlVI+SItabzmqIOMf7fL+ld5MXPPBRXV+KXhxcUetTU/jNJdSlzx7jPSBDrMeSyt4EXan2+tnDimT8ikuCJCdRMLTptgMKwEOrZ3lG8hAXdLB9DXBGPRfYhgT7eBdvVRKemqmUHVys6qaV+YIBednfezvGqzJRif2cInGhGwUEzNXfRhMeIxiwctkEElb+Dj5xogKmOjzgMaVPvDcvasb5a4MfnrUPHayChq75iMzOBIxukE3MxsFJYu2cTgSKm0QD3ZBeE1Z65Cligyw+fMezszyPPzOWx912DbFSgGjLdOIPVU8Y25p4ORxtBaJ94whJw5rkCwyNvsOgjBFBTyN82tp/YUqmo5tmPyU2rHfbJ1rd100ubOGUDYMWYYrQIjwk7VOyOb1+cL3ff3pWxkXOwXrTD/RmL0t8pIekAWC62EuzHWsztjcbDT1G5Uz8JD05SXNmFLkQZ3cO2Tx2QEMuVzB3K7BkGI+PkxXQYZbgKwEFdOlF+ZNJNq6h1JUX32sRBGWvg0XIWdha0CgE6CqBANplu5VgJxQ9vORUwHd716BmuEC72flTwRkocrBno8hB/cy+X0P2RsWVyOAZYIR9OtzhBsBbwWFp6ktoOffSFOB3NU3YKwDfJjHRf3Ya//2oKv8RH4uPLZFeJeOicf08aA6n+LnxVAuQt4euBzBPh69E1RihXgqNzQXdCR7LoCiK1D1pwMuiEb9CP9YzLuWtKvaONLjGQ1shCB6Wydi7vlEopsdSL22iAEKfxjfb/XpQ36N0kYO6e048fMCGl6q2Jqiqko9L5u7ZGDAlIhbruMmhjNT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(31686004)(86362001)(8676002)(66556008)(36756003)(6512007)(26005)(6506007)(4326008)(2906002)(66476007)(8936002)(31696002)(38100700002)(5660300002)(41300700001)(66946007)(83380400001)(316002)(54906003)(6916009)(966005)(6486002)(186003)(53546011)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmRRNUMvL3pPWWtzOGNUVmdobm1XajE0THJja1ZZcEdZUWxqWmxjVnNkcVMw?=
 =?utf-8?B?KzR1d09kTHZCRFNUWTNMbE1XRWoyaEo5bDRKYUMweThpSFFoenUvaFp2VXZk?=
 =?utf-8?B?YlNCSU5zMWdBZVZlVy9pYU16SzZzYzRvTEFTT1Rtb001djFoVzF6ZEhUZGdk?=
 =?utf-8?B?T3NQdE5HdUxyWDFKYVgwdE9nTTZVR0tMZ1QwdUZxa3MvUlJDVjlYdkdKWFdT?=
 =?utf-8?B?VVliRzJzVVgxek04YmluaGhLLzBGMFBVUVFLQ2RRZTJkVGhDZHZqSTU2MURO?=
 =?utf-8?B?aVZ4OEE4a0VQcEhNUVp0SHQ5eURxYTYwdlMra3YwRUZhYXVsZU56dllvTlhG?=
 =?utf-8?B?cGk4d2lzcFozV3NlNXZNUzdmSlU1TENFMjdCOXdGUzBkb2N5dXZCTVAyVFZv?=
 =?utf-8?B?R3pkaFZsR2hjK3RzRDN4VGVEOWt4c0VNTVY4YS96eDRGaU1yMjJwWnU4UkpB?=
 =?utf-8?B?MFBxSU5qdGYxVkR1ZDZJeFM4VjltOE0zZy9VTTd0VWc2VGtMWDF4bFRtV3N4?=
 =?utf-8?B?STEwUC9XcjlBQVVud0JXVnFXZEhnRzhoZGxTcVZDZyt3UTRpTjNKU2lNbWdy?=
 =?utf-8?B?VGYycDFCTVdGbEF5OU5xc2lDRzNSczNKTm5QUThvN3dTc3pTZjZqVWFMSWVh?=
 =?utf-8?B?VGhNektvbkpnbmJoSnNITTR6bmFMMStZNGs2WHk2dXN5bTBCczJqKzByeTRK?=
 =?utf-8?B?UXE3d2dOTkt6cWVCS2VCTXV5cFpacVRhTHU5RGVmLzZWeHZhTjJ0dTB2NklE?=
 =?utf-8?B?SVZLRDNuWWZCU0ZJdk5haGpRVG1MbnZXaDdSZzZjTFdmZmhYNXBNRW5CTTZt?=
 =?utf-8?B?eGptRjZLeGJPZXpNNmpKVklEMVdKZjBkcm13cHRSYU5JQkZuTHlEWU9PbGNO?=
 =?utf-8?B?ZmRxaWVOZ2hIaWdUT1grcUtIQ2dyZXNhcGRhTWxvZE1JcTZXbHpSVkRmNzVF?=
 =?utf-8?B?amJTbEpBT3p2MjQ2K2wzekd3VTlsbGZjWm9zUWdJaWMxV3c5eS9BU2xIUU05?=
 =?utf-8?B?b1d6amVaTVdpZjVPczcwdng0cjJVT2VXZUU3WUV1N3RkL1FJdXkrNjV1djJY?=
 =?utf-8?B?LzFlQXdvOFNmaVAxL2ppejIyWTc5dXNTcWRWL1kvNzI2bEI5dkNWWHAvdDRY?=
 =?utf-8?B?R2JSRHY5S3dhS0FnbU1uaWRUdWMwdVRJN29meGJKWkNWWjN1VnVWd2t6UWFH?=
 =?utf-8?B?L1g4bzI3emhaVUpxNTZJK1l1Vk1WTko2ZDRrQTVEaDBBUS81NENhOHF4ZklS?=
 =?utf-8?B?cTdqV1dxdmI2SW9jdzQvRzd6a2pTZkNxaWxtTE9SemZxNmVyVmMxS3VRYnlK?=
 =?utf-8?B?MmljbndFRXpUZm5NUnRDQ3h1c2ZVV29DczJ5b05oN2FKanYvYWg1a1R0c240?=
 =?utf-8?B?dDNCZGNqVGtndHFYM0hCTFhPckgzbFJBQkI5MkhWR204VVVranE5V3czRjlt?=
 =?utf-8?B?Q2tJSHlXSGJHV3Fibnh5R1FzcUpBbXpBRi92TkZnbk5XeFQxaTBtWmNnZThx?=
 =?utf-8?B?cTA3OFJFL1M3VktSRUJvdDBmc3hobTJadzh5NlVqa3NoSXQwaDV2SW5XMUd4?=
 =?utf-8?B?bVZJK3FXMmd0REZmdlVqQ1cyQUxmYmYrOXlQaUlpL3FyTkdzYTdtNmpVVlAz?=
 =?utf-8?B?YkZiTmtyREN0NTY5S0hiNjNucDE1N0xWUjIyTVFmNTVTaFBUOXluVmEwSzln?=
 =?utf-8?B?d21mcC8wRi9Cc2xwbUVPbjVjcVhGSGhocGJWQXhYUktENEdZRWl1WXM0QjVS?=
 =?utf-8?B?M0wvWGtiRVM3QXF5eWZkWGU2bjIvVjNEaUh3TitmaGhFK1BrUTJURE9CajNw?=
 =?utf-8?B?Q2dsbzRTTkxFeE5MZXlZQ3ZGTXlxcTdSUEd4b2pFcitYWmN5ZVNpQ1RiU1Zk?=
 =?utf-8?B?OGFFdFhueStCT29ScFhldk5mdVBUbVB1VHNRc28zVEJYSUtuS0dyRmhIV3Jh?=
 =?utf-8?B?UFUweDlmMGdWTDl0cWZGbjNIMHUwSW1YSE5zNGE0OUk2VG0rUVlhOGIyMXhG?=
 =?utf-8?B?VGZkUmFwTVAzRTZqcFdLandBdWY1Wkx3VVJ3Y01CUVZDYUQvWFhGRkpzV1Nn?=
 =?utf-8?B?dUVhQ0dobzVRZXhaT2d1dXV0bGVoWEN4ZGVRclRNbFZLZVpYTUlvRzd3cWhD?=
 =?utf-8?Q?QpblEHwhlaxaxK+TwnTawbuSZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8e3535-2575-47f1-5615-08dab214acf1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 20:58:29.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxv45hpiaRctdmt7ieuPkP8mQLf6+GDCXsvfGvb1KOcIARhXBCdYMLF9bJMhb9jT0yDqElZgQLcYpRifLqOwEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 15:39, Peter Gonda wrote:
> On Wed, Oct 19, 2022 at 1:56 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/19/22 14:17, Dionna Amalie Glaze wrote:
>>> On Wed, Oct 19, 2022 at 11:44 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>
>>>> On 10/19/22 12:40, Peter Gonda wrote:
>>>>> On Wed, Oct 19, 2022 at 11:03 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>>>
>>>>>> On 10/19/22 10:03, Peter Gonda wrote:
>>>>>>> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>>>>>>> communicate securely with each other. The IV to this scheme is a
>>>>>>> sequence number that both the ASP and the guest track. Currently this
>>>>>>> sequence number in a guest request must exactly match the sequence
>>>>>>> number tracked by the ASP. This means that if the guest sees an error
>>>>>>> from the host during a request it can only retry that exact request or
>>>>>>> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
>>>>>>> reuse see:
>>>>>>> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>>>>>>
>>>>
>>>> I think I've wrapped my head around this now. Any non-zero return code
>>>> from the hypervisor for an SNP Guest Request is either a hypervisor error
>>>> or an sev-guest driver error, and so the VMPCK should be disabled. The
>>>> sev-guest driver is really doing everything (message headers, performing
>>>> the encryption, etc.) and is only using userspace data that will be part
>>>> of the response message and can't result in a non-zero hypervisor return code.
>>>>
>>>> For the SNP Extended Guest Request, we only need to special case a return
>>>> code of SNP_GUEST_REQ_INVALID_LEN. See below for my responses on that.
>>>>
>>>>
>>>>>> I wonder if we can at least still support the extended report length query
>>>>>> by having the kernel allocate the required pages when the error is
>>>>>> SNP_GUEST_REQ_INVALID_LEN and retry the exact request again. If there are
>>>>>> no errors on the second request, the sequence numbers can be safely
>>>>>> updated, but the kernel returns the original error (which will provide the
>>>>>> caller with the number of pages required).
>>>>>
>>>>> I think we can but I thought fixing the security bug could come first,
>>>>> then the usability fix after. Dionna was planning on working on that
>>>>> fix.
>>>>>
>>>>> In that flow how does userspace get the data? Its called the ioctl
>>>>> with not enough output buffer space. What if the userspace calls the
>>>>> ioctl with no buffers space allocated, so its trying to query the
>>>>> length. We just send the host the request without any encrypted data.
>>>>
>>>> In the case of SNP_GUEST_REQ_INVALID_LEN, userspace wouldn't get the data
>>>> if it hasn't supplied enough buffer space. But, the sev-guest driver can
>>>> supply enough buffer space and invoke the SNP Extended Guest Request again
>>>> in order to successfully complete the call and update the sequence
>>>> numbers. The sev-guest driver would just discard the data in this case,
>>>> but pass back the original "not enough buffer space" error to the caller,
>>>> who could now allocate space and retry. This then allows the sequence
>>>> numbers to be bumped properly.
>>>>
>>>
>>> The way I thought to solve this was to make certificate length
>>> querying a part of the specified protocol.
>>>
>>> The first ext_guest_request command /must/ query the certificate
>>> buffer length with req.certs_len == 0.
>>
>> This becomes an incompatible change to the GHCB specification.
>>
>>> By making this part of the protocol, the sev-guest driver can check if
>>> the certificate length has been requested before.
>>> If so, emulate the host's VMM error code for invalid length without
>>> sending an encrypted message.
>>
>> On the hypervisor side, the certificate blob can be replaced at any time
>> with a new blob that is larger. So you may still have to handle the case
>> where you get a SNP_GUEST_REQ_INVALID_LEN even if you previously asked before.
> 
> Ah, I forgot the host could keep changing the size of this data.
> 
>>
>>> If not, then send an all zeroes request buffer with the req.certs_len
>>> = 0 values to the VMM.
>>>
>>> The VMM will respond with the size if indeed the expected_pages are >
>>> 0. In the case that the host has not set the certificate buffer yet,
>>> then the host will inspect the header of the request page for a zero
>>> sequence number. If so, then we know that we don't have a valid
>>> request. We treat this also as the INVALID_LEN case but still return
>>> the size of 0. The driver will have the expected pages value stored as
>>> 0 at this point, so subsequent calls will not have this behavior.
>>>
>>> The way /dev/sev-guest user code has been written, I don't think this
>>> will break any existing software package.
>>
>> I think having the sev-guest driver re-issue the request with the internal
>> buffer when it receives SNP_GUEST_REQ_INVALID_LEN is the better way to go.
>> You could still cache the size request and always return that to
>> user-space when a request is received with a 0 length. The user-space
>> program must be able to handle receiving multiple
>> SNP_GUEST_REQ_INVALID_LEN in succession anyway, because of the fact that
>> the hypervisor can be updating the certs asynchronously. And if you get a
>> request that is not 0 length, then you issue it as such and re-use the
>> logic of the first 0 length request that was received if you get an
>> SNP_GUEST_REQ_INVALID_LEN with the user-space supplied value.
>>
>> Peter, is this something you could change the patch to do?
> 
> OK so the guest retires with the same request when it gets an
> SNP_GUEST_REQ_INVALID_LEN error. It expands its internal buffer to

It would just use the pre-allocated snp_dev->certs_data buffer with npages 
set to the full size of that buffer.

> hold the certificates. When it finally gets a successful request w/
> certs. Do we want to return the attestation bits to userspace, but
> leave out the certificate data. Or just error out the ioctl
> completely?

We need to be able to return the attestation bits that came back with the 
extra certs. So just error out of the ioctl with the length error and let 
user-space retry with the recommended number of pages.

> 
> I can do that in this series.

Thanks!

> 
>>
>>>
>>>>>
>>>>>>
>>>>>> For the rate-limiting patch series [1], the rate-limiting will have to be
>>>>>> performed within the kernel, while the mutex is held, and then retry the
>>>>>> exact request again. Otherwise, that error will require disabling the
>>>>>> VMPCK. Either that, or the hypervisor must provide the rate limiting.
>>>>>>
>>>>>> Thoughts?
>>>>>>
>>>>>> [1] https://lore.kernel.org/lkml/20221013160040.2858732-1-dionnaglaze@google.com/
>>>>>
>>>>> Yes I think if the host rate limits the guest. The guest kernel should
>>>>> retry the exact message. Which mutex are you referring too?
>>>>
>>>> Or the host waits and then submits the request and the guest kernel
>>>> doesn't have to do anything. The mutex I'm referring to is the
>>>> snp_cmd_mutex that is taken in snp_guest_ioctl().
>>>
>>> I think that either the host kernel or guest kernel waiting can lead
>>> to unacceptable delays.
>>> I would recommend that we add a zero argument ioctl to /dev/sev-guest
>>> specifically for retrying the last request.
>>>
>>> We can know what the last request is due to the sev_cmd_mutex serialization.
>>> The driver will just keep a scratch buffer for this. Any other request
>>> that comes in without resolving the retry will get an -EBUSY error
>>> code.
>>
>> And the first caller will have received an -EAGAIN in order to
>> differentiate between the two situations?
>>
>>>
>>> Calling the retry ioctl without a pending command will result in -EINVAL.
>>>
>>> Let me know what you think.
>>
>> I think that sounds reasonable, but there are some catches. You will need
>> to ensure that the caller that is supposed to retry does actually retry
>> and that a caller that does retry is the same caller that was told to retry.
> 
> Whats the issue with the guest driver taking some time?
> 
> This sounds complex because there may be many users of the driver. How
> do multiple users coordinate when they need to use the retry ioctl?
> 
>>
>> Thanks,
>> Tom
>>
>>>>
>>>> Thanks,
>>>> Tom
>>>
>>>
>>>
