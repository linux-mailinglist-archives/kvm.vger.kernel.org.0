Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4F5BD687
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiISVim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 17:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiISViQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 17:38:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2AB1FCD0;
        Mon, 19 Sep 2022 14:38:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxEtujEobF6fJDoKm3KCzfaUoa4M46d9oA9Q7fPsOsg7p/aaavokYKo3lNnWZcLAYQ0VWFUK8aewadSbsQE7H620vMwE277o79Xgn/enzatbeJ5inuWh9qtyjTpY3e6YETwMgOt30iDcZnkN71l3VCVW7KVYxkBekkJJtOGLt3tXqADhyHipM382qrdubxhY5+Yfxh/uVJC3G1Fum38ybEXvkNLIhG8P8CxBsoSdYsj5ZwwA9ObjkV8TSCum81FfGfPVBJ/EvBaIkbdyVv+wjxsKUBXFZRsErP2tp9cmglnGHDqHccKMfP8pINoRCvf99pDDL1gLqq3YY/8e98wgig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIz0SQ/Tzc5rl8GWGkVLuAlwnQoekbRMlkyXQlkZ9+U=;
 b=fB258W81eO/vOjq+DDSLdVV02WJaBibkL/yqVpzEIIO0ulsoZ09h1d0eHnj9o6HMnp3oxj6sMxADUId65nsnt0iUWcSQbibj8IOvWnvfA6gk2+Dv8gqcjQOlJHV5bbxPK30CEu5vnam20DAiB9LUwSDOUDzZScg9vRu54JRKs4P706/N4tj3XCzCU10qJ2MCpoXqzwuXp+kHOkimPtp0xlYtU2wPSqXIIuK8Uhrqlh0wViEj1O7I7FE8b0oAQnBddEOPse2feZvSC+459T2rg489NXJc3SLSTS3NHjf8H07XBbijJe9JfvTnGkK83L9p6IRZc89JfSY8hP7IlyUxxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIz0SQ/Tzc5rl8GWGkVLuAlwnQoekbRMlkyXQlkZ9+U=;
 b=xpJK8veyJwd9daEKYkouoSP1EUWUdydEmnMCRpGQozuhR5kVE+CWjCtk3AM1ELoMnbd4Nz+9Ho+DWeC9r/z4eG4dyIKl+O6r5CDQfssJlIg/qaCnCgFNG0zrITaxluBN01Yhye9Ev7Iwqj7q3m28rCbj9RytFG9h3IRSyzv0koo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.16; Mon, 19 Sep 2022 21:38:07 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 21:38:07 +0000
Message-ID: <0716365f-3572-638b-e841-fcce7d30571a@amd.com>
Date:   Mon, 19 Sep 2022 16:38:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 37/49] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>, Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <78e30b5a25c926fcfdcaafea3d484f1bb25f20b9.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6rrGJ5DYTAJKFUTagN9i_opS8u5HPw5c_8NoyEjK7rYzA@mail.gmail.com>
 <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CABpDEum157s5+yQvikjwQRaOcxau27NkMzX9eCs9=HFOW5FYnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:32b::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6288:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb351c6-0578-4cd8-17ab-08da9a873d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZa6omdYdUo1HXpKOOBzHkRjrzCJ60oc/taLPJA50dCyXRP1ZmCCLWS9tnXSPjtLOhV30m6NZvm6+RBraKKL3QD5qfmNy7IT/elREF0+i8Ex47iS02KgpEJ8MZndm83+W70tLk2M3vfZMdA3NLyCX6SOcD+lSnnfZmUNHct23l5drckdtWtolybkt4yHWfCIn+gjbFqvT7hc1wyytb0iszD0thntBCHZ3lqcpxlNENxyYmJwX57vdb+Ghd97tAg2EfrXSJpMiSJMgzGqQKuGxdhwDAVjXVRqFpehDlxlpHoQXxabDf01grEwJZ+yuC6EL8EYYW5YCY0lrmzb/GRBhPcj5/EU3FmldvDb6XbLnz/lfJehTSpFQAjnLUXjy0i8WEl7gXq0Y2tyAfv+ZCtS+sCWnAX7IryPXlszCNqPdBbxvOes4h3HcZkyOQmfbRjvgsFBMNeW6SAk+axpDi9ukoOmRrpnFVeBEWzE6carlBAYLvsYpE6Sm3a6EjB0FOCq3PeptKB39acZncIsz7owMKl7ao/LWlqoMpFOLmjy9qeXR6ruXM9zxh85gdQ5xGgsEdC0t1CdklJDzCk0r/0OQhJ36/Wldhb2DHNHjAJh7wg1JUQLNcJuBDSQjai5Vd5W62yht4mC1KIyAtn0TeGtJ7eJa0nNqWJyf6+3htadYiy/fo/9ed3ryocG1zSl8XctXNzL8iA4zet2i8c+t6IorSSBx4uZNhho9401WYRnhHK9nF98WtTUXRdvb/jOrEDssfoDk2A3256LH+zw3JvZgcE1I4+usF5GOrCO6AIfZJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(86362001)(316002)(36756003)(31686004)(66946007)(7416002)(7406005)(5660300002)(6666004)(66476007)(38100700002)(8936002)(66556008)(478600001)(54906003)(110136005)(4326008)(41300700001)(2906002)(31696002)(26005)(8676002)(186003)(6512007)(83380400001)(6506007)(53546011)(2616005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1MvTlhMVEtCWG1yMmRPc3VVQ3lTR3pjZlpmdDB0WXRhUjN4MmgxZDIyTXBU?=
 =?utf-8?B?QWxJVDhOUk9YMWdVcW8zbWthTWZ4UnBFY2YvNXlWZDRSMGRKa1RkRXlxSFow?=
 =?utf-8?B?czllZHN4VVJnb0dvby94VEQvbjVYUkM3NWRhUW9DZTNUNm5GTWpCN1FIL21P?=
 =?utf-8?B?aWJKYlRmSWgrc0RjaGsreXpmRG1VM2IvQkErMDVFYUFJam5BTEhjVGQ4UHly?=
 =?utf-8?B?Qkt5ZkNVS0dPVXZ0ZlJqN0dHdnliTXgrNldnN2RoNW5UOUhFZUJhNUFMTXlj?=
 =?utf-8?B?OUYvanN4SjVKOFIybmF1VWRZMTVwczdHbGhYWjZKRTJ5bWhaYmZURVdzdS9K?=
 =?utf-8?B?cFlSRmhid1JVa3RGTGhRSDA2UEQzZ2RNemorcHdFQWwzaUVPNERhOWsydEJ3?=
 =?utf-8?B?UFNTdGNOeXV4bXIwUnlqZEJySGlCbERSL3k1eDR3ZWJhUVp5T1p5MWhud3Fy?=
 =?utf-8?B?bVFRMVlCcXFrQmpBUHEvVm5XTURaWkNQdmswTjhRWDZ5YUJiek1VQjZ4OHdi?=
 =?utf-8?B?L3Z6eUt2cWVQOUdPWURxYXlEZlh6VFB4NjhZSVlmTTNYYzRjN0FaN2dabEt5?=
 =?utf-8?B?czFBOEM1N2ZOeUtsbFgvc3MrcHhVRk8yd3hVT2FaSFRlYzVHL3k0NS9WK2V4?=
 =?utf-8?B?NGQ0OHdnd3U3cVFTdzRQanNuM0dBcmRZNmVNUklreGFGL1dIeG5QQlMxU2c3?=
 =?utf-8?B?bC9RWXNjd1hKbTE1TDk2MXQ5MkdWM1Jyd1ljRnB6VzRqTFl3ZG9XMEJOY2Zl?=
 =?utf-8?B?ZmtUb28rb2FKdkM5bzZJdDltbmhJazYyTm9HUmFWdXVmeHp3VWY5T0VTQ0RK?=
 =?utf-8?B?ZzU3Y3c5QXg0M0N5S0FVTS9kbm9QdFE0WXFOa0E0WnhIWHBmNWQ3ZEZJMUxB?=
 =?utf-8?B?bHhVSGJTSDRPaDdlL3UyQy8rQnBYbWZvcHZFNVF3cEE2ZEg0aG12bmtRZXJL?=
 =?utf-8?B?cWpOUXBLa2dab3I2Ky8reXFxNi9jajc1WnYvb2R3Rm9pSzhvcERlZE84ZUhm?=
 =?utf-8?B?NE9GNC9aY3M5cUh3UmorV3ZTQ2xZZlBDYnlvcVFWU3VLK3JkSmt1emE3Tm11?=
 =?utf-8?B?MkY5L1N4RVZmM3dZRyt4YytINXM4QzBlZTk5T0ZQMzJsNjJVUDVlL2RQalpQ?=
 =?utf-8?B?RXlTdDgrd1hJcHk3WUN0M0dWVmtWZzVMMDhLZE53VlZZdER0bHpzTHlpazBx?=
 =?utf-8?B?eVlRNmhUUk1yeHJyVHdvd2MrSUNHclVGTVpOWEgrQnhNR29YNGY4WmRGMUJ0?=
 =?utf-8?B?Uk0vZ3JCejE5aDNXeW1KbUcyUTBLeXBwTzJDYUtDbFRCVEVCTEU2NlBBeFlv?=
 =?utf-8?B?YmZKZXJXNmtiVnJKU3Z3RW4xS3lrYXVjTVBSbmdOMXlDa1ZxdURQZ1BmMUVH?=
 =?utf-8?B?dUFxNm1yVWFIN2hKd1AzK0ZnY3IvSXB6R2dnRUlHUkVFaEJKK2JSL051Vngv?=
 =?utf-8?B?cjhJQVFuR212RDJ1OXYyMjM3cTU2cXhVbFh1K1pBMHpCb3ZmaU5sMGdzT1N0?=
 =?utf-8?B?ZDRVRVRqMGExZDYyS1cyZ1pOTFplUzNQeU90ak9BbG9oRjIxT1NuL2xrRFVO?=
 =?utf-8?B?QVJDY0IyYXc5alM5VjNmOUtXRmVzeXM2cFNPWHdUampROStYMTR4L3QycDU2?=
 =?utf-8?B?RGtPSW9jRkJiWjlQQUhIT3k0d09SMHlwUlowNHExU3ZWQVFZTlJCclNDWTho?=
 =?utf-8?B?NDNjVmZEZmF2dHJBSEx1enZFc0xsbGlieVZreUlMa1U4MXN6dzZpSTNYRnE5?=
 =?utf-8?B?clZzR3RkZXh1clEvcC9PRXJlQ0s1bGN3WU5tVkxJMGhHMjZZdWtzWXNoZFFv?=
 =?utf-8?B?cnVIaFFKaDc0azhZeWUraDkrd0QvOHpyTWhuUUkrekxmMDNiQVppTTJ3eHMr?=
 =?utf-8?B?NWZOeWhnbmdvSUVqTVlOVXlXUHpqOE94RHAxRnlrNnY4U1N4UzQ4b0ZDb1A3?=
 =?utf-8?B?VEYxc29SYmpwVU5JZHBsV2ZGUkkya09MNVlyRjVzc0xyam5QKyt5SHFFL0VM?=
 =?utf-8?B?TTVuQ3ZLayt6N21rYVpHMEs3d01Nb3pXc1RJOEFZNVN2V2hleUNQb2lSQ2lw?=
 =?utf-8?B?Zi94bWxJTEswUUZwNnVsZWVXZ0dGSDdXa0crL21ST3ZlaE9zZnhEUFpsdDZt?=
 =?utf-8?Q?5k7RN5+5TKZoe9iF8o+wqYolY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb351c6-0578-4cd8-17ab-08da9a873d73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 21:38:07.0917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fdSuZ8IP8gURyVrrMYXYFblRNp8yI3n/Z5vg+lq3Lj+i5sCnuatDJkvj5//Lvfhsr+75qArXsCfJ6BRWa6aRUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6288
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/22 12:53, Alper Gun wrote:
> On Fri, Aug 19, 2022 at 9:54 AM Peter Gonda <pgonda@google.com> wrote:
>>
>>> +
>>> +static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op, gpa_t gpa,
>>> +                                         int level)
>>> +{
>>> +       struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
>>> +       struct kvm *kvm = vcpu->kvm;
>>> +       int rc, npt_level;
>>> +       kvm_pfn_t pfn;
>>> +       gpa_t gpa_end;
>>> +
>>> +       gpa_end = gpa + page_level_size(level);
>>> +
>>> +       while (gpa < gpa_end) {
>>> +               /*
>>> +                * If the gpa is not present in the NPT then build the NPT.
>>> +                */
>>> +               rc = snp_check_and_build_npt(vcpu, gpa, level);
>>> +               if (rc)
>>> +                       return -EINVAL;
>>> +
>>> +               if (op == SNP_PAGE_STATE_PRIVATE) {
>>> +                       hva_t hva;
>>> +
>>> +                       if (snp_gpa_to_hva(kvm, gpa, &hva))
>>> +                               return -EINVAL;
>>> +
>>> +                       /*
>>> +                        * Verify that the hva range is registered. This enforcement is
>>> +                        * required to avoid the cases where a page is marked private
>>> +                        * in the RMP table but never gets cleanup during the VM
>>> +                        * termination path.
>>> +                        */
>>> +                       mutex_lock(&kvm->lock);
>>> +                       rc = is_hva_registered(kvm, hva, page_level_size(level));
>>> +                       mutex_unlock(&kvm->lock);
>>> +                       if (!rc)
>>> +                               return -EINVAL;
>>> +
>>> +                       /*
>>> +                        * Mark the userspace range unmerable before adding the pages
>>> +                        * in the RMP table.
>>> +                        */
>>> +                       mmap_write_lock(kvm->mm);
>>> +                       rc = snp_mark_unmergable(kvm, hva, page_level_size(level));
>>> +                       mmap_write_unlock(kvm->mm);
>>> +                       if (rc)
>>> +                               return -EINVAL;
>>> +               }
>>> +
>>> +               write_lock(&kvm->mmu_lock);
>>> +
>>> +               rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
>>> +               if (!rc) {
>>> +                       /*
>>> +                        * This may happen if another vCPU unmapped the page
>>> +                        * before we acquire the lock. Retry the PSC.
>>> +                        */
>>> +                       write_unlock(&kvm->mmu_lock);
>>> +                       return 0;
>>> +               }
>>
>> I think we want to return -EAGAIN or similar if we want the caller to
>> retry, right? I think returning 0 here hides the error.
>>
> 
> The problem here is that the caller(linux guest kernel) doesn't retry
> if PSC fails. The current implementation in the guest kernel is that
> if a page state change request fails, it terminates the VM with
> GHCB_TERM_PSC reason.
> Returning 0 here is not a good option because it will fail the PSC
> silently and will probably cause a nested RMP fault later. Returning

Returning 0 here is ok because the PSC current index into the PSC 
structure will not be updated and the guest will then retry (see the loop 
in vmgexit_psc() in arch/x86/kernel/sev.c).

Thanks,
Tom

> an error also terminates the guest immediately with current guest
> implementation. I think the best approach here is adding a retry logic
> to this function. Retrying without returning an error should help it
> work because snp_check_and_build_npt will be called again and in the
> second attempt this should work.
> 
>>> +
>>> +               /*
>>> +                * Adjust the level so that we don't go higher than the backing
>>> +                * page level.
>>> +                */
>>> +               level = min_t(size_t, level, npt_level);
>>> +
>>> +               trace_kvm_snp_psc(vcpu->vcpu_id, pfn, gpa, op, level);
>>> +
>>> +               switch (op) {
>>> +               case SNP_PAGE_STATE_SHARED:
>>> +                       rc = snp_make_page_shared(kvm, gpa, pfn, level);
>>> +                       break;
>>> +               case SNP_PAGE_STATE_PRIVATE:
>>> +                       rc = rmp_make_private(pfn, gpa, level, sev->asid, false);
>>> +                       break;
>>> +               default:
>>> +                       rc = -EINVAL;
>>> +                       break;
>>> +               }
>>> +
>>> +               write_unlock(&kvm->mmu_lock);
>>> +
>>> +               if (rc) {
>>> +                       pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
>>> +                                          op, gpa, pfn, level, rc);
>>> +                       return rc;
>>> +               }
>>> +
>>> +               gpa = gpa + page_level_size(level);
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
