Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9D7D15E7
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 20:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjJTShg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJTShf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 14:37:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9BD55;
        Fri, 20 Oct 2023 11:37:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKsxWv4lAumzVV/nsUtJCAA+9gu8L5IrPAvoTKjtLqvRSDZv6PWwxFYW/cvOWFTjZ2QKyNys+U1Di5FLND4qwHtELOOyRQ1BGP2TpQo8xGe9tyoHCqtciwFRNL+OlmkC1aSXjx7SqzyADnpYV8pQi3S/u9j6qQqKsT3JjsxKwz560Qjod3OcYZmEB8LfPSwnit5O/zWE0Yn7EbzobjfBjQFI0ZMDHexeRs+IwZtD4A1F1xnjUVSELniA35aj6aqyLKEPGucQUOmO56RtexZeSNYySyoR4n90k5r55Q2Nc/4uow7RLGGaCd1MRka81Zs9UlQpOJ2esMZ3X3u7e9YzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdyxsrFaOegbYF5Rb7uHY2DvUr4ng5P7TFHi6Lev14I=;
 b=gpH8MabggigeCogFTkTXfgiO5tAk43vQLNjTjfozhhWFhX1eXPQvwOVjw/kuKjIpRZRRqUiJUdtxIsLIS2F1Cia0SylsT3pR5Up4OsvhCN1FUoj13uUI+LJeVdhqVAw+COaG3PgUfI1RrIGvN1bax+VTKYb1R0Oqd8sZxwgOllRi0ihrdymUSfTGyfy16s/UuaBdNq0/1ZCrujdyoLiGDHOkg7tlMDOLfXS0hlX42fm2Ig+URucKnlyz58PILJXx7HAQ99aKHCXUf5ZDqk7I1jnl0UphPyssEisFnOPz+qDlEEELsJCb7LibYBrJlrYj0AdcZTqLyyT7MZsE288fFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdyxsrFaOegbYF5Rb7uHY2DvUr4ng5P7TFHi6Lev14I=;
 b=1M7/i/QMIp4n/4JSaVTm704hjHL8Fjm2v+yL8AvIiqnNnOe45h2Z6q9q9Ycl1+h84XfxT/Hfzrfz21cLDOBv9mvpXKvUltMfvJckD6A2ozopkrK/vSO8JDYForBIAIkSpxb/RRIRGfMg19pnYdMzhgBllyZ/gcyQHnXuAuMUfaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by LV3PR12MB9096.namprd12.prod.outlook.com (2603:10b6:408:198::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 18:37:27 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::a13:336d:96a5:b7bf]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::a13:336d:96a5:b7bf%4]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 18:37:27 +0000
Message-ID: <397ff410-e649-c2c8-aa8a-d8f9e40df10d@amd.com>
Date:   Fri, 20 Oct 2023 13:37:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <924b755a-977a-4476-9525-a7626d728e18@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0064.namprd11.prod.outlook.com
 (2603:10b6:5:14c::41) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|LV3PR12MB9096:EE_
X-MS-Office365-Filtering-Correlation-Id: c280eb62-6646-4f0d-bd82-08dbd19b9bfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXPX59oYo+D8/qMKcTdWOxMLe3FhYkEPhbsHNL6WqT4/kYc6VO+Jnr6D4+KVZ0Q53FXXYV6/97/sPXnxfFaPej9sD+ILqLiz6CybwCDMAcz4Zqeh0dMKe4gvcO3Qs3s7p/WgWVaqGOWQCGvCtjhb4pbqgNN20qbY8xinCVwYeBn6PhghNN626B/RCudElZoeA/+URJe66NSf5HBatRdUjtumvAgQPUigOu0IhJDwOmhuzpc+lAxeCya5iAh/UWJ3qNBt1Yaku5FToRJcnQLva9WGTe2vi3Ki6fV/zci+b9oITeZ1Dqc2PQXPkyg8xEeLdo8xFFsFBoFB1HzGF5U12TUzsfPAYf3GwmrLnYzHMAbiaX4RrFn5/fwe0+UwqDQsIvD/GE0vugHWjwJAPUIQyBsHNipDiIScOMcooSIE7/q11ut/sOkghcfYE8K8iPyS1MsgFO0GD2LQQ/KstiQY6Nz2Es4HkUFTjh4UGWIbzzvM7I3afX4GywF0VTb09LP8IkYND6j0W18Vb+BTbA+HXxsoIyZk2oNrUmfJoyXhT4c4BwkNiiLbRCg7JXaRPi43u4MdbYQhriLcTbkfu8br6SqfPXyEALJe3ji3QEoOpZ8yge7c+0K9y4Cdt0Xe8TQkUP3eJp+1kKYw66z1zb3IAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(366004)(376002)(136003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(83380400001)(53546011)(26005)(2616005)(6512007)(6506007)(6666004)(36756003)(31686004)(86362001)(31696002)(38100700002)(6486002)(4326008)(41300700001)(8936002)(8676002)(478600001)(5660300002)(2906002)(7416002)(7406005)(66946007)(54906003)(66556008)(66476007)(110136005)(316002)(66899024)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWFIR3praStCRzV3VnJFNkJtRnU1UGRCTkpWQ2hmNnBYVURnWnJLY1ZIUkQ0?=
 =?utf-8?B?VTNFdFRRK1BSbnJSTm9reEQyRXVjTUtpVU9pelFZampwUGd1b1NzcmJpMnFS?=
 =?utf-8?B?d0hsSmE3S0MwSjBhQktuQ2kyUnpGcTQrb3pJTldjUGhKVmRySWtITkZJaFJp?=
 =?utf-8?B?M0FiUFdSY1BhUnh5WVRYOFEwMXVBOTZTenNnU1d2UW5WNitqMDAvTGJFYmNG?=
 =?utf-8?B?SzBNcFRMOUVVTFdvbEpGbVk1UzhIeFpsVU8xWGo5bCtDWmhEUnQ3RnAvMUEw?=
 =?utf-8?B?YTJzOW5uNlg2WVhWNm5rYXd1eFlGNXpvL2xncU9QTTc1bExEL1JaVVcyckFp?=
 =?utf-8?B?akM0aUNmMlI0clhMbEJ1UWJicC8zRys3NVEzZ1BycjRsbUhGVldyZU02Nmwx?=
 =?utf-8?B?Wk8yb2pZdW9PUXFhS2ZpU0Z3NGFySXNYK0YzYStLa2dFYU5PMW5GdHZUN2Jq?=
 =?utf-8?B?Mmk4bnc1QlV0YkNJQmNCWXRwUmtlZkdpMnFNYXdJZlRrMEhBdldKTFFUU0Ev?=
 =?utf-8?B?MDVKVjZVU0kvTXdvY1pweFMrd2lqVitrUC9GY084YXgydHF0RmwyVG1Ja0Ns?=
 =?utf-8?B?REdlVlhXZWlmOVhMa2N5eFhBNzRRSllya0Zlam1uUnVMYWVZV2pqbHI5YURz?=
 =?utf-8?B?dGRDcGlwQzQrWW5tYWFnMGdKN3A2ejQwT1BqaHVESE56L3BOVlRXU3NqQUMz?=
 =?utf-8?B?OTlIdGllcFBWV1ZObWVqQlc4T1NRak85a0N5MVU1M2VTOVhGeVk1Y2loQ0xr?=
 =?utf-8?B?MjVwS1ZXdjUyamZJWTE2NENuMHNtQ2tOTmF1M1ZWR0VrbXhzT2xoeFBmZC9v?=
 =?utf-8?B?ZTF5S3VXcnFGbDhvRWtZS05TdEJoRGRBYm8xclNweGtnbWNWSUNXbDdKNUdI?=
 =?utf-8?B?TGsxaFVQYVFwYUovRG5JYTlkcWdpaGJuUXRnblZhd1hPeFB0OXp0Rm1KSlNW?=
 =?utf-8?B?UEpsVHd2UUQxMHNQbEtvYnppZDI4WkhFaHlIVE9LL096eG0xd0dUZkhaRzFT?=
 =?utf-8?B?VkJ2L3dicm56UzROd3NSRUMyU1d0Z0U0QXgwcnFHWktpeE81ay9KRTYvY2xO?=
 =?utf-8?B?TnEyQk1JcUhaRWp6dkN2SzRFakNQUk1BZHpOTDBNMlJSaHZLYWU2UXFDR1U1?=
 =?utf-8?B?RDhrOXlzQTgyYXJCaDFUcXRONlBBOFU2MlByTUY2Y0VWaE1QMnUwek82VzJC?=
 =?utf-8?B?WVU1ODhoY2NXbHZITTJoRGhlZDBXdVFDOVVSam5yNUJBc0tsK0FzU0tPZW5y?=
 =?utf-8?B?bGdhZU5md0JJa3VLa3VjQVgyM1lLR3RVclczRy9YVmlpOFdvbjgyclFvbFZQ?=
 =?utf-8?B?bzlKWEZwa1lvbXJjRUFvTDZlOGFJUWV2Mk14VTdnZU1FMDRVeGdod1BlWUZE?=
 =?utf-8?B?SWh5LzBRMWY0bTFGVXJPZVJHU1p1SDF0RG5FNDIyVzBicXZBMWhheFR1ekJC?=
 =?utf-8?B?bEZ2MGdrbjdKRXRHUVJPY3VvdThucE1pUmEwM0lUT2hYQ3BsWTVubkdQbnlt?=
 =?utf-8?B?Y2JYbGRTa29SZUpMOVJuanc1dlE4NkVmakx1ekVwa1hLOEM0ejBxK2VMZmRV?=
 =?utf-8?B?N1NCanUwczdzR1JCOEtpdUw3cjN2TjdqLy8wVlNkbXJQVk9HZ0x0dXkzdGdi?=
 =?utf-8?B?MThqQ3diTFNzQXdobmhLakRJa1FwbER2N3ZlT3N6NVZZNlJqUFV2bnZIN1ZK?=
 =?utf-8?B?NHdZb0RlSjEyWnVyRUg3UGwzQU1PeGtLUDJLRzRyWVRrcFhkaWgxcGZ2bHZ0?=
 =?utf-8?B?RDVweURqWm4yLzJhOVdTbFg5V3E3TFBjSWErc1lpMDJlVFU4aStlaWZ1bWVs?=
 =?utf-8?B?Q1AvUXlXcmQ1cVlUSjZTejhuSS9mcThsSFZiQmxMSG50a0tFNjh1RlkzbTRv?=
 =?utf-8?B?SWpRRU9kS212dFF3TmxCZXEzczNLOVB3Y09JVjBWbEgrZVVhMDhCMnFSWC9J?=
 =?utf-8?B?dnd3UlhaU29RWjYyMGFkOEloMzV0MlhPaVRQWGVBQnhNWlRMQzk5Wkd6aG5G?=
 =?utf-8?B?ZyttNXpheWpTV3d3WkRFUzZtSVJjMjJXYXNIekNQNENIN3M1eTRJbjR5UFJv?=
 =?utf-8?B?MTArd00zUFZvMGJCeFVJY3pndlE2Qkt5ejQ4R2dmYzNza1ZmUDFqS3U5Vnlm?=
 =?utf-8?Q?HMxo6PS2P/DD3lPVg1rLgJWGk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c280eb62-6646-4f0d-bd82-08dbd19b9bfa
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 18:37:27.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXssPszTqQfBpr5tSf2hPaVK/3HT1SNYIry3byB3avGgXaIKvjasb0RAhTcgoByl71EPA16aVAzf/99p9BksGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9096
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/23 21:48, Alexey Kardashevskiy wrote:
> 
> On 19/10/23 00:48, Sean Christopherson wrote:
>> On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
>>>
>>> On 18/10/23 03:27, Sean Christopherson wrote:
>>>> On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
>>>>>> +
>>>>>> +       /*
>>>>>> +        * If a VMM-specific certificate blob hasn't been provided, 
>>>>>> grab the
>>>>>> +        * host-wide one.
>>>>>> +        */
>>>>>> +       snp_certs = sev_snp_certs_get(sev->snp_certs);
>>>>>> +       if (!snp_certs)
>>>>>> +               snp_certs = sev_snp_global_certs_get();
>>>>>> +
>>>>>
>>>>> This is where the generation I suggested adding would get checked. If
>>>>> the instance certs' generation is not the global generation, then I
>>>>> think we need a way to return to the VMM to make that right before
>>>>> continuing to provide outdated certificates.
>>>>> This might be an unreasonable request, but the fact that the certs and
>>>>> reported_tcb can be set while a VM is running makes this an issue.
>>>>
>>>> Before we get that far, the changelogs need to explain why the kernel 
>>>> is storing
>>>> userspace blobs in the first place.  The whole thing is a bit of a mess.
>>>>
>>>> sev_snp_global_certs_get() has data races that could lead to 
>>>> variations of TOCTOU
>>>> bugs: sev_ioctl_snp_set_config() can overwrite 
>>>> psp_master->sev_data->snp_certs
>>>> while sev_snp_global_certs_get() is running.  If the compiler reloads 
>>>> snp_certs
>>>> between bumping the refcount and grabbing the pointer, KVM will end up 
>>>> leaking a
>>>> refcount and consuming a pointer without a refcount.
>>>>
>>>>     if (!kref_get_unless_zero(&certs->kref))
>>>>         return NULL;
>>>>
>>>>     return certs;
>>>
>>> I'm missing something here. The @certs pointer is on the stack,
>>
>> No, nothing guarantees that @certs is on the stack and will never be 
>> reloaded.
>> sev_snp_certs_get() is in full view of sev_snp_global_certs_get(), so 
>> it's entirely
>> possible that it can be inlined.  Then you end up with:
>>
>>     struct sev_device *sev;
>>
>>     if (!psp_master || !psp_master->sev_data)
>>         return NULL;
>>
>>     sev = psp_master->sev_data;
>>     if (!sev->snp_initialized)
>>         return NULL;
>>
>>     if (!sev->snp_certs)
>>         return NULL;
>>
>>     if (!kref_get_unless_zero(&sev->snp_certs->kref))
>>         return NULL;
>>
>>     return sev->snp_certs;
>>
>> At which point the compiler could choose to omit a local variable 
>> entirely, it
>> could store @certs in a register and reload after 
>> kref_get_unless_zero(), etc.
>> If psp_master->sev_data->snp_certs is changed at any point, odd thing 
>> can happen.
>>
>> That atomic operation in kref_get_unless_zero() might prevent a reload 
>> between
>> getting the kref and the return, but it wouldn't prevent a reload 
>> between the
>> !NULL check and kref_get_unless_zero().
> 
> Oh. The function is exported so I thought gcc would not go that far but 
> yeah it is possible. So this needs an explicit READ_ONCE barrier.
> 
> 
>>>> If userspace wants to provide garbage to the guest, so be it, not 
>>>> KVM's problem.
>>>> That way, whether the VM gets the global cert or a per-VM cert is 
>>>> purely a userspace
>>>> concern.
>>>
>>> The global cert lives in CCP (/dev/sev), the per VM cert lives in 
>>> kvmvm_fd.
>>> "A la vcpu->run" is fine for the latter but for the former we need 
>>> something
>>> else.
>>
>> Why?  The cert ultimately comes from userspace, no?  Make userspace deal 
>> with it.
>>
>>> And there is scenario when one global certs blob is what is needed and
>>> copying it over multiple VMs seems suboptimal.
>>
>> That's a solvable problem.  I'm not sure I like the most obvious 
>> solution, but it
>> is a solution: let userspace define a KVM-wide blob pointer, either via 
>> .mmap()
>> or via an ioctl().
>>
>> FWIW, there's no need to do .mmap() shenanigans, e.g. an ioctl() to set the
>> userspace pointer would suffice.  The benefit of a kernel controlled 
>> pointer is
>> that it doesn't require copying to a kernel buffer (or special code to 
>> copy from
>> userspace into guest).
> 
> Just to clarify - like, a small userspace non-qemu program which just 
> holds a pointer with the certs blob, or embed it into libvirt or systemd?
> 
> 
>> Actually, looking at the flow again, AFAICT there's nothing special 
>> about the
>> target DATA_PAGE.  It must be SHARED *before* 
>> SVM_VMGEXIT_EXT_GUEST_REQUEST, i.e.
>> KVM doesn't need to do conversions, there's no kernel priveleges 
>> required, etc.
>> And the GHCB doesn't dictate ordering between storing the certificates 
>> and doing
>> the request.  That means the certificate stuff can be punted entirely to 
>> usersepace.
> 
> All true.
> 
>> Heh, typing up the below, there's another bug: KVM will incorrectly 
>> "return" '0'
>> for non-SNP guests:
>>
>>     unsigned long exitcode = 0;
>>     u64 data_gpa;
>>     int err, rc;
>>
>>     if (!sev_snp_guest(vcpu->kvm)) {
>>         rc = SEV_RET_INVALID_GUEST; <= sets "rc", not "exitcode"
>>         goto e_fail;
>>     }
>>
>> e_fail:
>>     ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);
>>
>> Which really highlights that we need to get test infrastructure up and 
>> running
>> for SEV-ES, SNP, and TDX.
>>
>> Anyways, back to punting to userspace.  Here's a rough sketch.  The only 
>> new uAPI
>> is the definition of KVM_HC_SNP_GET_CERTS and its arguments.
>>
>> static void snp_handle_guest_request(struct vcpu_svm *svm)
>> {
>>     struct vmcb_control_area *control = &svm->vmcb->control;
>>     struct sev_data_snp_guest_request data = {0};
>>     struct kvm_vcpu *vcpu = &svm->vcpu;
>>     struct kvm *kvm = vcpu->kvm;
>>     struct kvm_sev_info *sev;
>>     gpa_t req_gpa = control->exit_info_1;
>>     gpa_t resp_gpa = control->exit_info_2;
>>     unsigned long rc;
>>     int err;
>>
>>     if (!sev_snp_guest(vcpu->kvm)) {
>>         rc = SEV_RET_INVALID_GUEST;
>>         goto e_fail;
>>     }
>>
>>     sev = &to_kvm_svm(kvm)->sev_info;
>>
>>     mutex_lock(&sev->guest_req_lock);
>>
>>     rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>     if (rc)
>>         goto unlock;
>>
>>     rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>>     if (rc)
>>         /* Ensure an error value is returned to guest. */
>>         rc = err ? err : SEV_RET_INVALID_ADDRESS;
>>
>>     snp_cleanup_guest_buf(&data, &rc);
>>
>> unlock:
>>     mutex_unlock(&sev->guest_req_lock);
>>
>> e_fail:
>>     ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
>> }
>>
>> static int snp_complete_ext_guest_request(struct kvm_vcpu *vcpu)
>> {
>>     u64 certs_exitcode = vcpu->run->hypercall.args[2];
>>     struct vcpu_svm *svm = to_svm(vcpu);
>>
>>     if (certs_exitcode)
>>         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, certs_exitcode);
>>     else
>>         snp_handle_guest_request(svm);
>>     return 1;
>> }
>>
>> static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
>> {
>>     struct kvm_vcpu *vcpu = &svm->vcpu;
>>     struct kvm *kvm = vcpu->kvm;
>>     struct kvm_sev_info *sev;
>>     unsigned long exitcode;
>>     u64 data_gpa;
>>
>>     if (!sev_snp_guest(vcpu->kvm)) {
>>         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
>>         return 1;
>>     }
>>
>>     data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>     if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
>>         return 1;
>>     }
>>
>>     vcpu->run->hypercall.nr         = KVM_HC_SNP_GET_CERTS;
>>     vcpu->run->hypercall.args[0]     = data_gpa;
>>     vcpu->run->hypercall.args[1]     = vcpu->arch.regs[VCPU_REGS_RBX];
>>     vcpu->run->hypercall.flags     = KVM_EXIT_HYPERCALL_LONG_MODE;
> 
> btw why is it _LONG_MODE and not just _64? :)
> 
>>     vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
>>     return 0;
>> }
> 
> This should work the KVM stored certs nicely but not for the global certs. 
> Although I am not all convinced that global certs is all that valuable but 
> I do not know the history of that, happened before I joined so I let 
> others to comment on that. Thanks,

Global certs was the original implementation because it was intended to 
provide the VCEK, ASK, and ARK. These will be the same for all SNP guests 
that are launched. The original intention was also to not make the kernel 
have to manage multiple certificates and instead just treat the data as a 
blob provided from user-space.

The per-VM change was added to allow a per-VM certificates. If a provider 
has no need to use this, then only the global certs blob is needed which 
reduces the amount of memory needed for the VM.

Thanks,
Tom

> 
> 
