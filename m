Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA58435584
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhJTVvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:51:13 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:5089
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231354AbhJTVvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 17:51:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBaGSzfeFWR8vJFq7JX+iYt1bGGrknAxUVi5jgq6e2W85kxw4l+Yf5BUMszbpHjZwWvzp2ZPmLyRm8J0ODyJjubTKJD5oRjgEyO/Q7VzhCpDp/xLvf/9B0bV9C08tJNTYYzBjYRBMQZcM5WUazW17G9O7GF8ahTTZB1A0qysxI6WjYZ2+tAqBmL7AFTfYmd9Hc1VBXOxneriKVP2NQT11t9llCMw86RkYkjCNfB6rhgifDkDniDU47zNZkiqeWGNUymCMbCk4cLXO/LdNZd2sFAi+y1Qbj1kYgP4ZYOG50hecfuWUb/ko6jwEXzTfj9s+oH4VbwybkMnImaN1BoQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrqbrQPf/O4zKrgbzMvp8b/ZfjKNBPy8oCDAeyMNTOU=;
 b=Hc6zFmEhe0h87FZehz3Ldygqi6ReQYzc96Qoiuax0chTYWFXJOgzr70GXfJOSRBm3ps/Wb1PtbhQ1F33LiJrgeJGWJzwdMFcwPo7PKOYtmBJvG8zAGK/SXuUmAa//T0MKsSwNG5rudHsBUmnbNhfp2jLN/NZpzONSECIQZCaDPRNwkArdesMwAlw+MU/WBL4P5+4YCFwFLxQlyw6VnB+8xNQcg/kmyul/RwgtQHdkbaY2XG0w/2oH1PgRckuZJIrce8FVvmREtdv0AgN+FeJet2Kd/Dp/k/b/EBMJIU9eQ8EEMqzdTSos1BDMPU/NdmqbasUGHQifVrLGruMlV2rgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrqbrQPf/O4zKrgbzMvp8b/ZfjKNBPy8oCDAeyMNTOU=;
 b=YdC89QQ+BcAI+eJbKnV2VhGmbCuVpMGQl8kF92OVIbDvcB4GwyKhcFMJsv9ecuk+dLuBngyJTmQWVRtojtpVjWW6lrvRLeWvfLHz9rx7c2RLYtADzW9/UYQnhBaHWUtvF6RIEyU6+TOXEoR0D97DgGbScKXCLrOuwq2FJoJelBc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 21:48:52 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 21:48:52 +0000
Message-ID: <a7944441-f279-a809-8817-2e4b38a0e309@amd.com>
Date:   Wed, 20 Oct 2021 16:48:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 44/45] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-45-brijesh.singh@amd.com> <YWnbfCet84Vup6q9@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <YWnbfCet84Vup6q9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:610:33::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [172.31.128.40] (165.204.78.25) by CH0PR08CA0023.namprd08.prod.outlook.com (2603:10b6:610:33::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 21:48:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74b8e84f-f1bd-4fb7-b4e7-08d994136830
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26887A6E7E731F1417BF2A5EE5BE9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvN18djk+WzNPPPRc0Z0lXOYLxPWczL88QVaEm41LT36oCa/89C76V6RhhgY+uXesa70EIOV8NUG0syi6uaW8WJ3+WQcAqbAH/Mx1zfNwVkmNYHSjX4Gu5XOxoMG5BQD/RbN1Ww4UExUMedB6jtHtFpeHdGmHz4NAkdPWMtcHhtXhMykbpK7xJH5wTuov9i5He6ONw4+XcFnMi3FivZarikPTyTPCK0imD4Zyp00HFStp/5cMjpDpyOkPjsr/t5xNclqIYRqYLHDPYsPhfn/WlceeIzwOBRByo6SQQucoQDvibJa6hgmPlxVGOJ/oJEQ6LQzOGf59vi7ht0iUv15Ck+ZZtPzBUE80FdAY+qQogUZTIPBva/X6l/yYcWzliZe3EKW12uVMUWxq3NxH6DtRIWPVMmCT/s0Nr015kWKNR63pspw4upbfOUQ7uSRfjVOSlfEhP0HYHxNXYtDa1c6/jBcAUlzIpBYzkPsp/YRR1L76T97/DJAxJilzEzEyZuBP22Nt+Vj/9s4GLd6/3Kcyc1LVCxU+Tbjnwo/wAoPhDTCr2rq3hS1L6cUciJGsdAlq7UgPnEuLZsx+rJFae0H/0hy+7TYRWJ3Ob8HRGZNudInaiZm36TCNLSPCD6JB+1N5GBxxQE0mHJ4wcvMbw9euJRdAPbwRuzFOCgIvORK9k1P4vT8FxufATZ8PGzp4nZD36/TPRQwcfLdmrMKHnGuTwa2W2BMA0aDjSqWvN5Y86IHJwMJc6NU/QCvVzOapVwq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(8676002)(7406005)(7416002)(6916009)(6666004)(66946007)(186003)(4326008)(316002)(5660300002)(8936002)(26005)(83380400001)(508600001)(36756003)(956004)(54906003)(31696002)(31686004)(44832011)(2906002)(86362001)(38100700002)(6486002)(2616005)(53546011)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnFTMUswS1JYSkNzQkRGNnJaR3ZMQ1pjVHY2cURlalMyMWJNQUgvUmxoN0N0?=
 =?utf-8?B?aTMvajdwZllJU2JNMmgrNE0xdTA5L0RBU3N1UC9DRU9IWjFxZzFsQ2xFRDJn?=
 =?utf-8?B?aEN2cW5YUUdSUy9PTERRaUtvZmlvM21tREpEVjVYZEl4cHdUS0dRcHFaU2o4?=
 =?utf-8?B?NXBCTFdCQ2x6THBDUi9NbVRNZ1FoNjh4TlZFVUJJN1dDaFZzOG10dC9yS2Zr?=
 =?utf-8?B?VUZLVGJXeHBQQnFmMXcycEFiRjUrR1oyUVJJNmVFY3hQekw0a05vOGNtSzNV?=
 =?utf-8?B?TDAyZVVhRm82cFloUjF0UTZGZTB6eVJ3U3B4UWxobnFFOEcrTkd0VC9sdjJV?=
 =?utf-8?B?c1dCU3VSQlhhL3N2Q1YyaFQ3aUpLVFpnRTZGRDV3bkJ0Vnk1TjdTYmRjMnJ4?=
 =?utf-8?B?Tkk3a2pRMmROclgwbDdxRUFveitKdnFuZ1M2WWw0K1FsOUphbEl0MkJmK2x3?=
 =?utf-8?B?KzdSMjNZR1JReWtiUzN4bjQvclhQQWU2dk1rOW5mYkY3Q1RrdHkzR3EycXJh?=
 =?utf-8?B?ZlQ5bDgzdjdtUmpJV053dTEveEVmempnZUpyMlpnNktnMGV3cGNwUzd5a1o4?=
 =?utf-8?B?NmxObWQ4Z2JDcDd0Y25TMXhCWWdsVGxyN0YzamNuL3MyNCsrbG4zNXgvTGJv?=
 =?utf-8?B?VVkveUUxQXVoT3JocVB2RDlLWXJySmxsQzdMTU9mSVFoR1VSeTEwYStXZlVI?=
 =?utf-8?B?RHJzOHljdkczQ3dLaGpTVE81NTM3NnR0M0ZkTFpFVjkvQkZmU1ZXNis5NGE4?=
 =?utf-8?B?amVub2hObUR1bEtvd1NNRmV3NWpOMUFBVDJjYmZwSEpSVmJld01qM0Q4N0Iy?=
 =?utf-8?B?SEVaeE1USnFqSXBZMEZhZWFXR3NacDJCdjBqT3NHeUp0Y2M2NitCY21DQUEr?=
 =?utf-8?B?OHlyYjlGcFJCcGRKeGhFWVF5M3JOWEhGSStjRFpHMTNpQWVxanNjT2NXbEhQ?=
 =?utf-8?B?aTRTOHIzRFZNWFBwMThGYm9DQ05meHYxZkMvU1FNYU53Wk5PS2JCdDVFb2g4?=
 =?utf-8?B?a25kN2o4K1Q4dkt4RHJnRGZpM3E1ZkRGVmxDU1dRZkhZRHBWbDgvRjh1UGlL?=
 =?utf-8?B?VTlGQW1kb2FrU0wrNzM0RDFqN2xaUmNUT2VVbkU2RThMZnZMUWhpTHg2bkZB?=
 =?utf-8?B?K2VHcnF6dTdMWnpJM2NiQ2lvK3VWSVlDREdSZzFZbDE0M1o2WjhCUkNPanhO?=
 =?utf-8?B?Q2Irdkg0NjRVWGVOWUVqbi9wMjM0THQvQTZxSjNrQVNueHdLVldpNXVxYVB6?=
 =?utf-8?B?Z3VmcCt6QTlYcWhBaEUzb3R2T2k5Uk9NZWtGRW0rZ1hsaXVzUHdEa1gxVWc2?=
 =?utf-8?B?a3FERmhJOENrUk5QSWR2RFY4Rkl1Y0VTajJYVUJpcEUreFlOb3NvNUdnMTRL?=
 =?utf-8?B?bFRSOUduNDdLZ2p1bHZhZ1lJUk5Xc21SbFk1by90dkV1UHR4QitDRmpRZ0FC?=
 =?utf-8?B?M01FOG9qREt5c2h5ekNVQkdJdFRHckpLblZENTh0M2g5WHZxb05LWUZHUnBk?=
 =?utf-8?B?OFlOamFsRnY2Q3F0SHp4TWlyQkJGdlBRd1BCSjNjWEY0aDBWa2UxZ3YzN1VX?=
 =?utf-8?B?eUxkM0VLdnBsVXhRNWU3MVc1OURpQ1EvMkdWajhBOExQZHNMdWpIak5zdS9S?=
 =?utf-8?B?MXNUV05sOW1xVEhLR1JDcHJPeUtPM3JqU3NXQkNpMlBtR0tpUlVUMHYwalBM?=
 =?utf-8?B?U0V0WllMTnljR1R0MW5hQUh5WnhOU001a0t5TUxNWFdMYUJlUTd0N3JHL0ZI?=
 =?utf-8?Q?HqIvM321rcLirmsCRbvJumAggT5mh/oNWtuII9y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b8e84f-f1bd-4fb7-b4e7-08d994136830
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 21:48:52.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbrijesh@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/15/21 2:50 PM, Sean Christopherson wrote:
> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
>> guests to alter the register state of the APs on their own. This allows
>> the guest a way of simulating INIT-SIPI.
>>
>> A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
>> so as to avoid updating the VMSA pointer while the vCPU is running.
>>
>> For CREATE
>>   The guest supplies the GPA of the VMSA to be used for the vCPU with the
>>   specified APIC ID. The GPA is saved in the svm struct of the target
>>   vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added to the
>>   vCPU and then the vCPU is kicked.
>>
>> For CREATE_ON_INIT:
>>   The guest supplies the GPA of the VMSA to be used for the vCPU with the
>>   specified APIC ID the next time an INIT is performed. The GPA is saved
>>   in the svm struct of the target vCPU.
>>
>> For DESTROY:
>>   The guest indicates it wishes to stop the vCPU. The GPA is cleared from
>>   the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
>>   to vCPU and then the vCPU is kicked.
>>
>>
>> The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked as
>> a result of the event or as a result of an INIT. The handler sets the vCPU
>> to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will leave the
>> vCPU as not runnable. Any previous VMSA pages that were installed as
>> part of an SEV-SNP AP Creation NAE event are un-pinned. If a new VMSA is
>> to be installed, the VMSA guest page is pinned and set as the VMSA in the
>> vCPU VMCB and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new
>> VMSA is not to be installed, the VMSA is cleared in the vCPU VMCB and the
>> vCPU state is left as KVM_MP_STATE_UNINITIALIZED to prevent it from being
>> run.
> LOL, this part of the GHCB is debatable, though I guess it does say "may"...
>
>   Using VMGEXIT SW_EXITCODE 0x8000_0013, an SEV-SNP guest can create or update the
>   vCPU state of an AP, which may allow for a simpler and more secure method of
>                                              ^^^^^^^
>   booting an AP.
>
>> +	if (VALID_PAGE(svm->snp_vmsa_pfn)) {
> KVM's VMSA page should be freed on a successful "switch", because AFAICT it's
> incorrect for KVM to ever go back to the original VMSA.
>
>> +		/*
>> +		 * The snp_vmsa_pfn fields holds the hypervisor physical address
>> +		 * of the about to be replaced VMSA which will no longer be used
>> +		 * or referenced, so un-pin it.
>> +		 */
>> +		kvm_release_pfn_dirty(svm->snp_vmsa_pfn);
>> +		svm->snp_vmsa_pfn = INVALID_PAGE;
>> +	}
>> +
>> +	if (VALID_PAGE(svm->snp_vmsa_gpa)) {
>> +		/*
>> +		 * The VMSA is referenced by the hypervisor physical address,
>> +		 * so retrieve the PFN and pin it.
>> +		 */
>> +		pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(svm->snp_vmsa_gpa));
> Oh yay, a gfn.  That means that the page is subject to memslot movement.  I don't
> think the code will break per se, but it's a wrinkle that's not handled.
>
> I'm also pretty sure the page will effectively be leaked, I don't see a
>
> 	kvm_release_pfn_dirty(svm->snp_vmsa_pfn);
>
> in vCPU teardown.
>
> Furthermore, letting the guest specify the page would open up to exploits of the
> erratum where a spurious RMP violation is signaled if an in-use page, a.k.a. VMSA
> page, is 2mb aligned.  That also means the _guest_ needs to be somehow be aware
> of the erratum.

Good point Sean, a guest could exploit the IN_USE erratum in this case.
We need to somehow communicate this to guest so that it does not
allocate the VMSA at 2MB boundary. It would be nice if GHCB spec can add
a requirement that VMSA should not be a 2MB aligned. I will see what we
can do to address this.


> And digging through the guest patches, this gives the guest _full_ control over
> the VMSA contents.  That is bonkers.  At _best_ it gives the guest the ability to
> fuzz VMRUN ucode by stuffing garbage into the VMSA.

If guest puts garbage in VMSA then VMRUN will fail. I am sure ucode is
doing all kind of sanity checks to ensure that VMSA does not contain
invalid value before the run.


> Honestly, why should KVM even support guest-provided VMSAs?  It's far, far simpler
> to handle this fully in the guest with a BIOS<=>kernel mailbox; see the MP wakeup
> protocol being added for TDX.  That would allow improving the security for SEV-ES
> as well, though I'm guessing no one actually cares about that in practice.
> IIUC, the use case for VMPLs is that VMPL0 would be fully trusted by both the host
> and guest, i.e. attacks via the VMSA are out-of-scope.  That is very much not the
> case here.
