Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8226051B5
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 23:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiJSVFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 17:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJSVFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 17:05:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAF522BCB;
        Wed, 19 Oct 2022 14:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJc1S3Gdnvt7BAR2CiXLrZ6FadU2aejbnBLDLAf9FLooMUMuz7ImWYZfAYX1MQ0i1a7jZ32WqyhPvJQ6n/Cv48KDY/cp/60wKmpZKUFT7nJO6ZMpmhmdMhoEDa4bJprimrtAD5pRegXAAD5bkeYBeGH6YByMMF+kwy9C/jzcFqrB/ptyYpk9uHvumssdgSFYEPD1s6XEN8KnUmkYVgAq3mGJFyX8+QlZ4y6KgLJ1sF8qW/UP6x5qLFRjAUJ+KnAY0DbTD7T9bPZ/eEyWQq1ZC75GJ6DvHgCZkzDHDa3yKdCXnGfyn/uC2bd7Aodu4ruqcpVqNM+G8f0u88yHypKApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTZPjFR+UGzqmSXdgqIGQuBZtOV8GrFY6YqrPsZk0gs=;
 b=GzFIAZaAFrnzyFFZ62yRs0eTMLoD4xnp5fd2Ek+uvS254q1ptztq3oKJRNROAiIDpFad8HZwopKCueJTBwxwqp3vw/8rAXuA9PnscnWbY17Uaz0mvmG4YjlBMwZ1JLl//Tn/iTzx7BHMIeATkMKN/lO8e/1J3ppt/dMP6KBdDAPdcnKDM1Qr1ZHXPIdKWktCisWrNuf6lKui6EGOM/itfAuSRy6aeWGK+eyfdZfwfENcZZ0Wx+GHGkO9WEpDD1OzxypJ1+Y08touxesb1805iseAhKWM9iDAz+lx80t5OwDtDdPfFpPimZFgk2AIzxcjs0EJmhTIE416pfZ2KBaMBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTZPjFR+UGzqmSXdgqIGQuBZtOV8GrFY6YqrPsZk0gs=;
 b=onhfvxIUBPzZgkN6jVvfYCvzf/ZM0U10k1AATYcrnYnXjZDfnGSpMMCm4buDhrImvsFmuECipht+bbEkg8JQjQwx02csvTlr0m7bsQAuAvxaWAv9efGhqzK7/xFJyFfOAx9t4SDMuoNiPAXIMaqvvidBaEEvVkUFfBpfHYwAHwk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB7196.namprd12.prod.outlook.com (2603:10b6:930:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 21:05:13 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:05:13 +0000
Message-ID: <10497679-8323-b830-56dc-4a6dc2581a27@amd.com>
Date:   Wed, 19 Oct 2022 16:05:11 -0500
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
 <5621c2b6-a5eb-c786-afee-020e97c0e4c8@amd.com>
 <CAAH4kHYnfQF6fweNQixQnjA95Os9RBvoAhFk6CPtOZmnA0+-9w@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHYnfQF6fweNQixQnjA95Os9RBvoAhFk6CPtOZmnA0+-9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:610:b0::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 547d2c41-f898-4363-70a4-08dab2159d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ml8Y77dyI9ihLFWCOv2z3Ynf+qF02bsoIBiWPQmIJDj+b+9aj/3s229iJZDt4nLnBvNUGz+Z3kMX4cWR2ITxIIwQkXdcG41HraYpBYLfrclgTEKpI1ae74xv2Tn1xViWXUsNpuks5/OV9bZ05QYeTwM5iE+A40C0ds1K8wEPxgVz5rnc+0e1VCU0bxz4xKyWi26VOUX3ZXUaVeDaOIUYsfROx5vuUzvxCK+yFEUhQTk2YWn1XkyXNA1bGLEowBgEpetdtk5l6RsVPwbzNgGPAzS/96fa7jMbACUJtze7l6cBK5u2gWbdl3fmRC7ZjhXF7/dCR7m9V+T6HZ3ZS9aoMAREByoNrwxfkWlRbgi1GTR7oWRDtcoKFQ9wtR3IM0kqxVN38k9jFH0v8H34IOC6mQ/Mo0ZSZUFfa/UDzxa9LmTJ1/xfICb0jFH5xMbIHsh/WYmUwksKw1Og9S45BXIqU2xezdB6TjxIExhyPZYOils7dEHWyoPOalhQAnfLoz7JqMvDXr+WidaPcYM5XdczkSHJDIIizJQRRp3fzy3d2A8cwgv9oFOm4AGayEuxl921fkMf3ZAHfE1yv7AM42tfGJEaOLAZ5+XZ33hLfq5om9+Rx4icOBB3RUaVxlFx6Y/eHnoWHWQxD/+OqIFWeJ5Mo3BCUOI7f9+z6zF07eVCbe96mu7pKjSyUfmxAUVTed0kGYx3B6r9r4Wqc3mFpwWmqPT5DfLVysVn/3W923jfc2m5Y5kTCS+OLsn0DhUVhJQsirUXh2RAwv/1TBDw7E6TRWyEaaPyADxZ5FS7QEV9j981ToNW45Vc3Z7F31Wkv6pMV+Z20tlppSIPiN3gDMeVTeAmo8UsVmWsVhmneOgQlej7UDEoaoGGEL9wOQX6BhtA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(451199015)(8676002)(66556008)(4326008)(66476007)(66946007)(316002)(8936002)(41300700001)(6486002)(86362001)(6506007)(6512007)(26005)(966005)(53546011)(54906003)(31696002)(6916009)(31686004)(38100700002)(83380400001)(5660300002)(2616005)(478600001)(36756003)(2906002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDI4dEhuK3B1emJyeVo4Ynl1bUR6NUZ1T1VhRHIrYlRrSE1sSEVudnBWNEtE?=
 =?utf-8?B?MWt6dGJkM1UrLytaT1VqMDkxK2h3ODVpa3E1dGQ5aXh1elNXbGNxZ2FsRXhY?=
 =?utf-8?B?M2U5c3JJTFJUc0VLcmhqMytIY1JHNFNnUS8yb21OZS9VcDNONDRqeWNqMlh1?=
 =?utf-8?B?b0llWTNNWE8xUUhyek54ajlBVUFYa3FMZmFXbERPUmhXTW5aYUlBeWNtcHFo?=
 =?utf-8?B?eC9nTW5oSmluaFNXR0FaUmVZUlNvVHh4YnU1aWgxSDlJa201ZFMzcURJcG5Z?=
 =?utf-8?B?NVlDTDVFaTBqdERyQzNUR1VYNkgrdnIzcUJYWUhhNURKN0ZZVzh2eEJFT1NT?=
 =?utf-8?B?TzBHWi9GdzZJZ1RRSjNPeDVFalIzZW80THlCSWl2QmFCdDZDcUFBeThTcHVO?=
 =?utf-8?B?bnkvcFlBVXdWa1JlMGdyM1lpeDZ4ZS9lVyszdTRFQjRsaUtKSjJyVWN6aC9a?=
 =?utf-8?B?R0VhMVU0RUNRL2w4MGxOMXNpY3ZhT2l6eGZmaHZyVW1Ka3ZHRy9oNlBDYnVo?=
 =?utf-8?B?SmxJelFoYyt0OEFGbGdmbm9aRzNRNmk4NVVmcnV1dzdIbXdjMmdQUFVjRFhJ?=
 =?utf-8?B?b2QxWWI1V0xJcWlhZzY0Q1R1MVJiVGh2WkJldWxucGttYmJDZFB3K1BaeFhv?=
 =?utf-8?B?eFVtMXV2QkVzTHo5Qk1qbWV3bU04STd5RGpsMkdLbjJabFc2UUJvUEFBaUt5?=
 =?utf-8?B?WFV5VFE1WjNrKzltQ2o4N1gzanpVUWIzRWVtRDFwM1hRcWQvMnhSVGx3UE84?=
 =?utf-8?B?SjA5bWpwTkJjdUdNTHhGa3huZjFsd0ZNdU5OeDVjQVo2WTlPUU1YaXdUVHZS?=
 =?utf-8?B?V0VKR0M1VXRtZ0VmVDFiK2x6MkozcnhwMUU4UlhZejFad3lyRzRwMFlBNFJk?=
 =?utf-8?B?bUZnaGtlWFRwd2VQTzRHWGlMMERXNVpCOUV0cFUxdng3TW9pYTg3NTYrUldZ?=
 =?utf-8?B?UDNGY3hlSFUrSFlWc0tnVUZKM1JDSWlhTitoak5RMkE3VUVmU3ZzSjFKT3E4?=
 =?utf-8?B?eVNXQUlCSmdBMkFIako3Rm1hamlVTlR4OXo5K0g2TXZ0ajNTeGp5R3ZnbEZ0?=
 =?utf-8?B?NzlXMXRSRzhiKzlxTmIyRDhDWm80T3RQbkdkTS92dm96UG02OGdBYW9tV0RG?=
 =?utf-8?B?RHViOTkyWkFmVWRqQ3NqenYwRDRpa1czZ2I4ZzQzcEVHVzI0ZHFpVUVrNzV5?=
 =?utf-8?B?U3RBTUM4UUtqR0ZFZDlkd1l5Vi85SGoyekI0TG9WeHlpNnFEZndRbjNheVhL?=
 =?utf-8?B?Znh1K2lYZXprWUxmb1dEMXBOWmlpM000U0NHRHd3ZDcwNVNnU1cyNGZQdWc3?=
 =?utf-8?B?MFNQUjFtdXYyZHB3R1NsV1JnUTN4cnJKS0FhUmdOVkc3UG1TaUZETCtCVE9o?=
 =?utf-8?B?cTV0SnluUHgyZGdXc0ErKzlqb0VWYzFhcnZoTzFFckJkeTF2NWFWNGZmMTUw?=
 =?utf-8?B?bUQ1WXNiT1Y3dkxKWEJnZ2o4RG1HT2hDVEY3STZvb1FGOW45cWxub1psM3U1?=
 =?utf-8?B?VFdBeFYvbTBKc2czVzBIWmpnRVMrZGJ1bG1IMU1pV1dCTjlVZGt1MG91QkRp?=
 =?utf-8?B?N0drTEtBdFJzZm1BdFlKTlkxc0xiTWxvRm1JY1NjakhjcmYwczh1LysvK1lu?=
 =?utf-8?B?d09OWm5tRENLWkV1dnczM2c0NzRmMHNLbG9UV3Q0Sk5QUiszeXR6QStRbWlh?=
 =?utf-8?B?Qm42Vk1ma2RwNTl5YVhkUGdzMnRvdE1tblN4ZlVKWmhHZGNlWVI1RXk4a3Nn?=
 =?utf-8?B?SzF4SWZKamMvNkF5S3hWSkg3cTZ1eldJQ0ppTmdnTlpweWFGdHcxdU1yU2l2?=
 =?utf-8?B?N0lkUWtlemZySUg4Y3VlaXRMeGNqOHJWUEpFVnlkbFVGNGk3S3V1ZWp0S3VF?=
 =?utf-8?B?WmFPdmZwS1ZDMEZKNVVnbVlWSUNXV21JMVBScnBuQWhjZDhJbm43VnJXWFZQ?=
 =?utf-8?B?eXRnbFBnSm4yM3AwSmZFN0YrMHBQck9walFNLzNEMkU2R1FmRFo5eXNmZUpv?=
 =?utf-8?B?bnc2S0lqL2xJRGtGWEFzT0dWbEFaYS94d0lDNHdhdDhhUTZOOVVCNDNjMGUw?=
 =?utf-8?B?MS80TTNVSTdCMklJTklLT2pWcisrdGk2Y1gvd3BRZ2tMVWtuUE4yd1BFaGNw?=
 =?utf-8?Q?+JfsCN8tv88wKsJd75tHts2nQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 547d2c41-f898-4363-70a4-08dab2159d65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:05:13.2325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sN2nm8+mK3FLTJBWf3PTdHBXj7eRnEAETOLAqu4JWwfUnYsAn0eRN3soOs0YLZ71Sbhp7vF/4fXi+29DtMtseA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7196
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/22 15:40, Dionna Amalie Glaze wrote:
> On Wed, Oct 19, 2022 at 12:56 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
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
> 
>>
>> I think having the sev-guest driver re-issue the request with the internal
>> buffer when it receives SNP_GUEST_REQ_INVALID_LEN is the better way to go.
> 
> I take it you mean in the case that the host's certs_len == 0?

Not sure what you mean. The sev-guest driver has an internal buffer for 
receiving the certs, snp_dev->certs_data, and it would use that whenever 
it receives an SNP_GUEST_REQ_INVALID_LEN return code.

> 
>> You could still cache the size request and always return that to
>> user-space when a request is received with a 0 length. The user-space
>> program must be able to handle receiving multiple
>> SNP_GUEST_REQ_INVALID_LEN in succession anyway, because of the fact that
>> the hypervisor can be updating the certs asynchronously. And if you get a
>> request that is not 0 length, then you issue it as such and re-use the
>> logic of the first 0 length request that was received if you get an
>> SNP_GUEST_REQ_INVALID_LEN with the user-space supplied value.
>>
> 
> A request that gets SNP_GUEST_REQ_INVALID_LEN when the guest expects
> that it is providing a sufficiently sized certificate buffer means
> that the guest has encrypted its report request.

Correct.

> We then have a harder problem than throttling because not only do we
> have to reissue the same request, it must be with different
> certificate arguments provided from user space.

Correct. But before returning the error to userspace, the sev-guest driver 
will issue the request again with its internal buffer so that the sequence 
numbers are updated and a new request can be issued.

> 
>> Peter, is this something you could change the patch to do?
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
> 
> Yes, the throttled caller gets -EAGAIN, and other ioctls other than
> retry after that get -EBUSY.
> 
>>
>> I think that sounds reasonable, but there are some catches. You will need
>> to ensure that the caller that is supposed to retry does actually retry
>> and that a caller that does retry is the same caller that was told to retry.
>>
> 
> I think that constitutes a change to task_struct, the way that there's
> a buffer for interrupted system calls.
> That seems a bit much. Do we have to model for protocol-breaking user
> tasks that have access to /dev/sev-guest?
> The caller that gets -EAGAIN knows to retry. There's no reason for
> other tasks to retry due to command serialization and the -EBUSY
> behavior.

Maybe for well-behaving user-space applications, but that's not 
guaranteed. I agree with Peter and think waiting in the sev-guest driver 
is the simplest and fairest thing to do in the case of throttling.

Thanks,
Tom

> 
> 
