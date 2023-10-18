Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D0F7CE8BB
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjJRU1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjJRU1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:27:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2989A4;
        Wed, 18 Oct 2023 13:27:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcXDUbhyWn9T+jx75G0ZdYct4O9hXXAwi0sGxtAtzifUGYVPSv5xU7rKsGcONo8evNqaWFlNmh06cJ+ikZLRebb9JbmlxzaoT/q9ptRVtLn/eCGLFVdooOxHL6E4rKfnSisEaICQSxZh3X9QjDSYCaQTV6bO5j44bq+0YTsbd7vDEIM31PheOHiwBYX8Zqi3wRBfHU07jfx5Af8GMXDx0F6H5STpJ9YPwK5xcFvc9jKcfeDZzZF+xH9qyD7qAVpkATV++OWMFqoNrk8cwZzYgyRl7MSqZX0zVGdi6pQfV1iQIZdVnmORP0UbSz11V7ueFUSt2vAtbx6BYkyYz3ZILQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/weRuittkt8e4EBns2qpQvAvdMKdQENgKYlm96Hvd0=;
 b=TXXAowlargLokgDlcdGT2/hsjS3Y4gJ1Vl1zsDP9z5IqS/LbXApGu8hjVOUZhEXvjDQXpT8nblTD7x4kTUMNdLvbtqtOPa3cgAtqBkVQj+k3bHnvOlnQc9bh4Ss/PNqzmddxIwzpEutZQqxZHU0ND2niCjS5fMuFG7eHIev1bDWonQmJnLcd+WWeF+p3LLwFqbeFams5aOfR9rDuz+gySh1YBsPgJBtXr7GLuUGMLSN4sKv7JVuDhqtIILWmdawzokSaBNjpvjguAN7CLpnUrvpqlea35BAAjafu8lnOgnQ7kpwdQnQUWvxA//kHhc7iqq7kHrKEN/C8Q/15HLYnWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/weRuittkt8e4EBns2qpQvAvdMKdQENgKYlm96Hvd0=;
 b=sAOIHAz5yWQeVUU2rTzDEdJbh4Lb7Fl/3pNhQ6adOEawxRF18pMSkSIW2SZGyYBl0cz0xe2Y2/pfMSPvoRM4B2pONPD/Yg2kLEzthlkNwz7c/WNnXosV0MQOhBLyMZM69NCw/A95XMuAhRXQIIgxT4yhuJgvU4SNyAdnZl96NeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by IA0PR12MB8840.namprd12.prod.outlook.com (2603:10b6:208:490::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 20:27:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6ac8:eb30:6faf:32b2]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6ac8:eb30:6faf:32b2%5]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 20:27:06 +0000
Message-ID: <09556ee3-3d9c-0ecc-0b4a-3df2d6bb5255@amd.com>
Date:   Wed, 18 Oct 2023 15:27:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Alexey Kardashevskiy <aik@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
        liam.merwick@oracle.com, zhi.a.wang@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZS_iS4UOgBbssp7Z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::20) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|IA0PR12MB8840:EE_
X-MS-Office365-Filtering-Correlation-Id: 04fa3703-f907-42df-56c0-08dbd018986c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4pPuwAn+ip3Zc0bps996/l0DockWkGcxozh8HhuqCa6haWOyLMWwTUvYiGLGJH7RM8z0sLiuNJZvE2YyBiLqp5cv9WHjS6aiaUVKOvxa/W0B+5kO+qNtBlOK2TxMo8fpUOrLGuLbiIB+khAYoJ/TmOq49dwfgoqwR2MPfzYkSSVZhm1UEdger7z5S6RTSejFs4u0gr7byn8uyIYxj/u8GQpeQ8Gghc5MelrKa1ASad1RDG25kpPmw0c44dvgUli6/ypBt88svZamRAjvBhY4f9778Zy+frJ4gs7eO+CIUl6c7bv9UCCtX2VEuzow258dlshZgE/G0UUdLlPDAc9Fjp3dFbnGLOw3mNGmJ5ISm6ycuU81FETPp+c3XemaZHFT/y75vUNy7M70kMQZ4P1nEF9lXFTT1BOW0rmSKi8RoOH79T/t6wzYP5M5sC9LBxcwwAjLhBp5Dia9VyZg5DxbvqFIyenznAx4qT+w7YNT3HyZrRav2ZkeoEu4LNyI/I9WO7Wxnz0hiuukFK9EWO26ueT0vXJy8jPRSoRbQgrwp/ZWElQCDW2rGeipf99myMfJ/7i7DAlaKMiKSqrdp7CRivy5ZXsqV+q4D2K6mqVR/HWATLPOKqyu0N2TGjAYtAHz/UKJKCJ/GxoKw5vnayJoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(136003)(366004)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(2616005)(54906003)(6666004)(478600001)(66556008)(66476007)(66946007)(110136005)(6486002)(6636002)(53546011)(6512007)(6506007)(41300700001)(26005)(316002)(7406005)(7416002)(4326008)(2906002)(8936002)(5660300002)(36756003)(8676002)(83380400001)(86362001)(31696002)(38100700002)(66899024)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmxMcXZJeGpvcXcrQVd6bjhyeTZ2cWdrY3p1K2tQYnQvdnc4VUxxSzU4TUpT?=
 =?utf-8?B?NVZRcEcyYnVrNVRSczBWMCtQK0JwRUwxcEpNU3lRMGdyOC9qZkNGeUFKeTJm?=
 =?utf-8?B?Mzg0YVA4RTlyVENCUmJIVXlxUHZPSWFFblhGMzBNSGFYbDdDenRYbEYvMFBa?=
 =?utf-8?B?SzRKL0s3K2Q5U1ZFMFNtem5MaDYrZW56V0pqenc4YitaOGVheGVDS0NJYnFG?=
 =?utf-8?B?R2thbGdGSnNCUm5KenpwQmxuVDUwRS85bDQrQXpZQW9jeFRubnlKNTU0NjNj?=
 =?utf-8?B?ZWxIbERiY280TmxOcFNPZ1ZxN0t0ckllYmpKY0RkM2E5c05hOWR6RmlwU29j?=
 =?utf-8?B?bDcvVU4rR0JhL2ZOVEQ5U3BRZ29yNHVOR0ZFRjZaVW1iTXdGZ1F2TlB2Vy8w?=
 =?utf-8?B?QU5JYUZ5MzNkVzZ4M1ZPYmt5VEMvRC9xb0YwTjlMMVMvcDNVa3ltWlFRNG5Z?=
 =?utf-8?B?ekxpMUpHeStXU3BpaWN3U2VXZ1h4a2ttdUs0cWlGWHJ0Zi9TOXhUVFpQenB5?=
 =?utf-8?B?MUxDWDZDWFZiSUY3QTMvQlNIb2lBRkpjZHlpU3FhT24yRlFlenJsNXBtdmpO?=
 =?utf-8?B?QytvaUhKUHNOSjU1OHBPbG1KRjloQkF5ZXZMT2tqTDljN2ZieFFqNDZCMVd5?=
 =?utf-8?B?TDZhdk8yVVYxbk9ERWk3Z0dYNHB4a3RjVTRxNUp5VTd5S1ppNisxZDkwRjZW?=
 =?utf-8?B?bTZkVlUvWUtnMnczb0N0d3hLZXQ1ci9PSGVJQXdzUjBLTHJoSHZ6MjQ1MGFh?=
 =?utf-8?B?UjB0a0xEZkFSRlNVb3VDNXFyQkRmRnJpUGl6UGNGN3NxY1F5emh5cXZ2MWpj?=
 =?utf-8?B?SXVFWXpOSHQzM2xQMSs0S0JvZ0UxNUxsSytlck8xMExLVzNLaW14SGREWkJv?=
 =?utf-8?B?WHlUVVhxRkRHNzE5U2VvVlo1NnNLZkJZbCtlL0t2Z1FON3JKeEZNNGFZbWo1?=
 =?utf-8?B?d29rcU1OZVJ3cWV1SzBCSlgzVnZEUytyVzNaRXhvRkE0bW5QUyt5b0pKeGp2?=
 =?utf-8?B?TWR0L3Z6T0JZR2s2R1pCQmhGeXk1NVJubjV4Yzc1VlQ4TFpIUmg3NVkxUWNw?=
 =?utf-8?B?Q3JLMG14eTRUU1hhOGtkR2tDb3dCMDlZVG05cVNTZll4dm1aRWRjLzRjc2JQ?=
 =?utf-8?B?VHpyZ01yWXpLNER2SVArZloyQXUxU0JDSzJZTE5PSHRkemVZTXRMdnJBWDc4?=
 =?utf-8?B?dGRmVFI4eEFSK3hGbmx1cldBdUpZeWYxZVg2OFlFSThaTnAvZ1V0UTd2SUI3?=
 =?utf-8?B?MkZ6dWNmQ3ZMU254UmEvOGFhMldvUW9SNjkzRUJVUUoxNFRKdERMYXpRUmhw?=
 =?utf-8?B?WDJNVFY4eXE0VHo1Mmg0Q3luNlc3WkRVS2lPNTFsU1dRNFlYRW9iSER2Q3VY?=
 =?utf-8?B?a2poTGJMR3ZMT3M4UTNhRGNxRGl0Z3lWVWxvM1YwSWdHeWZIaXUxVkV1U0FT?=
 =?utf-8?B?VGp4Q01XR1NhYXFoelh3eXNaWG90VFhkYy9QR3VzV3ZDS3VWc0xlSUp1Zm01?=
 =?utf-8?B?djVHUGt0VUZzRnZiQ1NLOFNBZjk1bElyYzY5Mll6cWtOYnpyamY3aHg1emp4?=
 =?utf-8?B?bHc3YVQ1Q3o5Y291UEd5ZGc0NUJpZ1E5NEJIVHlBbXZHUlludDY1M2tnRHoz?=
 =?utf-8?B?NXR5YTRpT0ZTazFLVTJlaVMvbFRBcS9kODE0c2JONXRHMmdtc3c4dmJMNTM3?=
 =?utf-8?B?aHdrWlRTNTRFc1kwM3FKZU5iZjZiMXgvaEdqK1J4SGZxSlNPZUJFb3dXY1Y2?=
 =?utf-8?B?UmU1bHlnbC9QMnVwWDJTQnNoRmtSaEQrakxjaDlCZkhQTllFNVoyTUJ3TGVR?=
 =?utf-8?B?aFFjSWNjQWd6WDZLRlE4cDZIbFA4cm1BVkZCaGQzK2JHdXEzN3htdHNPaXlv?=
 =?utf-8?B?eE9vbHFxc1pMS3VseUpOeDZwaCt2SHRRMWgrSC9rTkx2Um1leUJ6bk5xaDY5?=
 =?utf-8?B?LyttSFlBNkJ4bHBMaW1mV0ZYZkRXN1ZScG44Z3FTK2NqZlhYU2dEOVlHeVZZ?=
 =?utf-8?B?aFpkK2cwOEdhZnlQL3Exb1M5VkdUeCtCbFVhV3E4M0Z2bUpWOXF5aEZqeVlP?=
 =?utf-8?B?SStRdTlRRGdCblRKRlZOYWw1QjlDd0htRjdoOWlNYU9DNThGQjJ1TXcrQkJ2?=
 =?utf-8?Q?r+PA48miOS0DfefWfkpLr8lVA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fa3703-f907-42df-56c0-08dbd018986c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 20:27:05.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Twkt6Db/9mmDQSzMcGWd33JpqHZETELK3IG7gi0m4i+a2LmdG9tbVw4QW/waM9hjRLoYvUN1Wf86QxGc9njSsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8840
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2023 8:48 AM, Sean Christopherson wrote:
> On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
>>
>> On 18/10/23 03:27, Sean Christopherson wrote:
>>> On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
>>>>> +
>>>>> +       /*
>>>>> +        * If a VMM-specific certificate blob hasn't been provided, grab the
>>>>> +        * host-wide one.
>>>>> +        */
>>>>> +       snp_certs = sev_snp_certs_get(sev->snp_certs);
>>>>> +       if (!snp_certs)
>>>>> +               snp_certs = sev_snp_global_certs_get();
>>>>> +
>>>>
>>>> This is where the generation I suggested adding would get checked. If
>>>> the instance certs' generation is not the global generation, then I
>>>> think we need a way to return to the VMM to make that right before
>>>> continuing to provide outdated certificates.
>>>> This might be an unreasonable request, but the fact that the certs and
>>>> reported_tcb can be set while a VM is running makes this an issue.
>>>
>>> Before we get that far, the changelogs need to explain why the kernel is storing
>>> userspace blobs in the first place.  The whole thing is a bit of a mess.
>>>
>>> sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
>>> bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
>>> while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
>>> between bumping the refcount and grabbing the pointer, KVM will end up leaking a
>>> refcount and consuming a pointer without a refcount.
>>>
>>> 	if (!kref_get_unless_zero(&certs->kref))
>>> 		return NULL;
>>>
>>> 	return certs;
>>
>> I'm missing something here. The @certs pointer is on the stack,
> 
> No, nothing guarantees that @certs is on the stack and will never be reloaded.
> sev_snp_certs_get() is in full view of sev_snp_global_certs_get(), so it's entirely
> possible that it can be inlined.  Then you end up with:
> 
> 	struct sev_device *sev;
> 
> 	if (!psp_master || !psp_master->sev_data)
> 		return NULL;
> 
> 	sev = psp_master->sev_data;
> 	if (!sev->snp_initialized)
> 		return NULL;
> 
> 	if (!sev->snp_certs)
> 		return NULL;
> 
> 	if (!kref_get_unless_zero(&sev->snp_certs->kref))
> 		return NULL;
> 
> 	return sev->snp_certs;
> 
> At which point the compiler could choose to omit a local variable entirely, it
> could store @certs in a register and reload after kref_get_unless_zero(), etc.
> If psp_master->sev_data->snp_certs is changed at any point, odd thing can happen.
> 
> That atomic operation in kref_get_unless_zero() might prevent a reload between
> getting the kref and the return, but it wouldn't prevent a reload between the
> !NULL check and kref_get_unless_zero().
> 
>>> If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
>>> That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
>>> concern.
>>
>> The global cert lives in CCP (/dev/sev), the per VM cert lives in kvmvm_fd.
>> "A la vcpu->run" is fine for the latter but for the former we need something
>> else.
> 
> Why?  The cert ultimately comes from userspace, no?  Make userspace deal with it.
> 
>> And there is scenario when one global certs blob is what is needed and
>> copying it over multiple VMs seems suboptimal.
> 
> That's a solvable problem.  I'm not sure I like the most obvious solution, but it
> is a solution: let userspace define a KVM-wide blob pointer, either via .mmap()
> or via an ioctl().
> 
> FWIW, there's no need to do .mmap() shenanigans, e.g. an ioctl() to set the
> userspace pointer would suffice.  The benefit of a kernel controlled pointer is
> that it doesn't require copying to a kernel buffer (or special code to copy from
> userspace into guest).
> 
> Actually, looking at the flow again, AFAICT there's nothing special about the
> target DATA_PAGE.  It must be SHARED *before* SVM_VMGEXIT_EXT_GUEST_REQUEST, i.e.
> KVM doesn't need to do conversions, there's no kernel priveleges required, etc.
> And the GHCB doesn't dictate ordering between storing the certificates and doing
> the request.  

That's true.

>That means the certificate stuff can be punted entirely to usersepace.

> 
> Heh, typing up the below, there's another bug: KVM will incorrectly "return" '0'
> for non-SNP guests:
> 
> 	unsigned long exitcode = 0;
> 	u64 data_gpa;
> 	int err, rc;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		rc = SEV_RET_INVALID_GUEST; <= sets "rc", not "exitcode"
> 		goto e_fail;
> 	}
> 
> e_fail:
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);
> 
> Which really highlights that we need to get test infrastructure up and running
> for SEV-ES, SNP, and TDX.
> 
> Anyways, back to punting to userspace.  Here's a rough sketch.  The only new uAPI
> is the definition of KVM_HC_SNP_GET_CERTS and its arguments.
> 
> static void snp_handle_guest_request(struct vcpu_svm *svm)
> {
> 	struct vmcb_control_area *control = &svm->vmcb->control;
> 	struct sev_data_snp_guest_request data = {0};
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 	struct kvm *kvm = vcpu->kvm;
> 	struct kvm_sev_info *sev;
> 	gpa_t req_gpa = control->exit_info_1;
> 	gpa_t resp_gpa = control->exit_info_2;
> 	unsigned long rc;
> 	int err;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		rc = SEV_RET_INVALID_GUEST;
> 		goto e_fail;
> 	}
> 
> 	sev = &to_kvm_svm(kvm)->sev_info;
> 
> 	mutex_lock(&sev->guest_req_lock);
> 
> 	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
> 	if (rc)
> 		goto unlock;
> 
> 	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
> 	if (rc)
> 		/* Ensure an error value is returned to guest. */
> 		rc = err ? err : SEV_RET_INVALID_ADDRESS;
> 
> 	snp_cleanup_guest_buf(&data, &rc);
> 
> unlock:
> 	mutex_unlock(&sev->guest_req_lock);
> 
> e_fail:
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
> }
> 
> static int snp_complete_ext_guest_request(struct kvm_vcpu *vcpu)
> {
> 	u64 certs_exitcode = vcpu->run->hypercall.args[2];
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	if (certs_exitcode)
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, certs_exitcode);
> 	else
> 		snp_handle_guest_request(svm);
> 	return 1;
> }
> 
> static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
> {
> 	struct kvm_vcpu *vcpu = &svm->vcpu;
> 	struct kvm *kvm = vcpu->kvm;
> 	struct kvm_sev_info *sev;
> 	unsigned long exitcode;
> 	u64 data_gpa;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
> 		return 1;
> 	}
> 
> 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
> 		return 1;
> 	}
> 
> 	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
> 	vcpu->run->hypercall.args[0]	 = data_gpa;
> 	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
> 	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;
> 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
> 	return 0;
> }
> 

IIRC, the important consideration here is to ensure that getting the 
attestation report and retrieving the certificates appears atomic to the 
guest. When SNP live migration is supported we don't want a case where 
the guest could have migrated between the call to obtain the 
certificates and obtaining the attestation report, which can potentially 
cause failure of validation of the attestation report.

Thanks,
Ashish
