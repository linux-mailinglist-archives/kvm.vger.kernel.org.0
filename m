Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E96419F37
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 21:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbhI0Tex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 15:34:53 -0400
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:39873
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhI0Tew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 15:34:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqtu+TDL/i8YSfLCbwTsZenNyK3YKxjHVyl6kMk5PK6hMWeesxSRvPVv5US0DBDGpGFPRSXj7b5QzsV6hyMvNP7JXVBPnhW8L6WkAytOgL1XDmzfDI5PLtxFakNAr/LSm4Vi80v3Z2GKIvwYBWQWV7GMTNZeo8D6laMHgpT2gMJNX5JlXF5chSclBKvIGW6YPBBeev8BIXFt+fleOaG7EChFV8cR2d93XEcvmET3b0aQ6Xw5Q1p0kxF/DYh+LwTK87qX62fHdihIyTBqOtf1aASHUXTKtRkJBXZGopZJIIxvTZSzyy/SUV8n69+OJ1TdP5pmGtR3rd319uCKveGfKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nbMlcLwHwnbuz8VGhsrlLebPNA6V/P3jHy1C01+MTS4=;
 b=Lv+DJXjhx5Tt8melh7w4fwCGG5qxfFwsoeuvoEwl1P83UHjEvrFW5wc+WyP0xQnoiRkLNe/MCfjR5NtPc/MywygrwOiNfJNEG7xKOCidiCp0YJcd4fiUHiB7X2qjCiaN1siR2zbFG3KQr82fjhhHnqiALCkSl9ZiXjyI/ZD1ygA4LxdnsdENWtHvfxTqjs8UEf2EaN5Dp0A6fLd9XblwD0i35svKQLlOY/4OpR7i7tefG0OmrcNy+h7/o+EjcAPkWxJYsa9IsRIhW7XieY/zeHgNs7a2dPXypAGppPNYSvMig42Qq319G6ikFpZVBG/oNs1oCBg5yOaGaf3/pvPWrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbMlcLwHwnbuz8VGhsrlLebPNA6V/P3jHy1C01+MTS4=;
 b=mKi49Knm/1O0tZ8TUsH4cD6hoIZ872F7izS9GZ2ln90mHOEr4tidNWPkxchfTHl5bSeSoZ0a6mXfk0IY/R9WiqBRnAT0hTlcHWpjOM9k/qSZ8SPwX5tsTTq3ADv0y55ejDze74b32GaFm6hf8IgnB2I0extmA2CLl3AmuUYfuk4=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 19:33:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 19:33:11 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
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
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 25/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
To:     Peter Gonda <pgonda@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-26-brijesh.singh@amd.com>
 <CAMkAt6qsZNJPM97Y6_8b7QmLv=n0MaDs7hThi3thFEee4P10pA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e5a47417-2f2e-7055-71ad-850b509f3876@amd.com>
Date:   Mon, 27 Sep 2021 14:33:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6qsZNJPM97Y6_8b7QmLv=n0MaDs7hThi3thFEee4P10pA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0043.namprd02.prod.outlook.com
 (2603:10b6:803:2e::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by SN4PR0201CA0043.namprd02.prod.outlook.com (2603:10b6:803:2e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 19:33:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bb9583a-9fa9-4cea-fa58-08d981eda456
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4365F495D3EBD14C97308BBFE5A79@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2+jvG0wIoWEFFvquTqOYID4qAqchFgSzlDNlA4q2AaM/l4XpDwlnUc53SgTwBQ1C4eW0zOsCoqEnNLRTNXb/pv1uJ77TgVkTNcIrYSRiPpb+BC9jT2fKqwzKCu1/uh3Z+sJO7DcIx9OV5+bEOCq4gsqA4FligLpk092nTeuTUI0X5Kfvyh7AlFvHu96k0wTp7vRctQjcOI37AKnoYIKlliDL6BeOiBOwLhFD8hpdXEDUodld/6BxVnEMs2Gvcxq4/ol6jl6t3NTsHOPpmz8jNAdVKHPt3Z3033/Fx0ZFI0ilRMwy836lJ75Mb70SsgQBdZb71U0B6Vyhk/EWwaUPPhvmtzuGxTSxm10XEq7gFfoyjZlGERtDg75I8HZBbkAVi/T3/rzev5v+pCSl+tzRuKzulo1uTcAfoBVn5lgxpIgv6dg6ZNO13NP0ceKkSS9JQ1/LsHzLZA8zm6nt+e9OffxtpwrC3bNdI7eOjn3my99GNGwjuabNgUjb8hyR+ztj1FRW4oW5jSaBzNS9V+YMxanwy0xBFxLkw/BwtzT7ixoYWqHbNV8BfzBfpk1aS6zZd7WWTQZeNRdOWPVIMKofpfATJ421s10kabw7UbZvbSPgUcdK29JKWHTlwjCYepxE9Bq82t9q41uZ6dsFvlRuUjdEPIJGocRDcfGHP6HHKaewMbORe12aCGoBy7s+bl1uO/II2Fl1IVzzpp0htQNByQT86rR/1hHhaO0zFGjLQCJZwOIxth1j8AFdZ4Wze6KunliEC7+XSy6W+wZM+4ObQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7406005)(31686004)(38100700002)(38350700002)(6916009)(2906002)(7416002)(8936002)(16576012)(44832011)(8676002)(6486002)(316002)(54906003)(4326008)(86362001)(52116002)(53546011)(31696002)(508600001)(26005)(186003)(36756003)(5660300002)(66556008)(66476007)(956004)(2616005)(66946007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFE4SWFMc2JOWHFEZTFjVTU3dTk0RTlreDlLQW9nTDF2a1Awd0h4ZkpzeitO?=
 =?utf-8?B?dUE2NFRzN1dJNGlTRTJTRHlGRFg4QnhnVlU0SkRkcWZ0WVR3YzlndzRaUVFp?=
 =?utf-8?B?OXdOVkVtS2h4ZmNQeUtJVjFyRFVVUzk5K0Z4MHJYSHU5WElIVFh1WlB2RGNB?=
 =?utf-8?B?U09MbW91RGgrQW1UeXR5UXBMVnArSUhlc2F1cUs5dHpNRllUbVdOV2xtczBk?=
 =?utf-8?B?NlZTN3RSTER1YlZHREk0cDNIQ0ErMHFpbXE2Rmd6cDdCenVOd0lYcVBWWU0r?=
 =?utf-8?B?bG0ybVQrMENhQ0lhd3FyRmdDMm9xMjY0OG5hQU8yUmMvbFByMEJ4d3BaRDBx?=
 =?utf-8?B?ZVY4ajNPaWsxdnU4eWM5Y0QwVnNJUUVoOGlHUlBTanNDcEV3Z1lmaXN0NzVS?=
 =?utf-8?B?Tk9SNTlqa3JldlJwcGd1eThVazJMbW9hQTl1aVJYLzVqRUI5aDlsKzlJV0Ey?=
 =?utf-8?B?N0VvdkRWNjY4OGZkQitZN2poRDdIcGxmcFdPT1NHZ3kwS3hmeDR4T3NRZ2hz?=
 =?utf-8?B?RzloTXBwNFdjNFYzTEtLYjBHU3VVZlU2ZGFVUkw1VVlDUXVocVZIV1I5S3ow?=
 =?utf-8?B?R1RhWVVOektKTnRMZ2g1ZVZyWUlvTW42WXZpT2ExaGI4MVdpTGR0M3pDdG1l?=
 =?utf-8?B?VHRpdjdkZ2p5YkEyTHZMRUVQNExleHJPaDRuRk9ObndPaFJxYmRKa2xHQ0J0?=
 =?utf-8?B?clJwdkZDSG5oeGYzZ2UvdFdLc1d3Mk1NemF6ZTAzTmhOZFFIbUJMQkNYdk96?=
 =?utf-8?B?cEk1WUpTTzdRdm9wNytHWFNVeWtMaHVxR29ieWNsZUlTYVBGRUcvazRheUhE?=
 =?utf-8?B?UVBQU3ZZaU11MDhrN1BHT1hyalJGbHIvd1Z1R05DdDMzMHdEaGo3V3NtOVNT?=
 =?utf-8?B?VEhqN1R0bmZyOFdITksvVGVrT2tHb1hwbjBKeTFsSzF4eERFSFVsQjBUakFx?=
 =?utf-8?B?WmVGVHg0NTdGZld1c3RRREpMblcrRkYyWlVFRHJoOWdKN3pHRklVVy8vNzZX?=
 =?utf-8?B?VE9rRlN6ZGlpZEEyYzFMM0NsNk9EMmw1d1BsOHBLSjZDNlRBTk16V3RPaEFR?=
 =?utf-8?B?ZURKRHdlTDMwQ0xwSGYwRDBkNVhlMlhYbDBtTzR3UU5vQWZFVmYrQzJaZC9h?=
 =?utf-8?B?L0c0d2FaL1Mxd1JXY2wrckZySWNPZ2h1ZTBaSkN1aTQzemJqNjQ4eG11MkhG?=
 =?utf-8?B?VHFkTXZ1eUkwMklHbldpaXNSYjcyUzVmL1JkRUZObmpRQ0d6VGdRclhSNE5z?=
 =?utf-8?B?c1Y5L216QmsrV25DR2JjbmxwdnRzZEV6MHlqSndmd3BKYTRLMUtEV1pxZTJL?=
 =?utf-8?B?VWJQb0hFUDYwNXYvVWVsNnlOUm5haUQ1VHltYWFndnhCajdjK0ZqRU5SaUMx?=
 =?utf-8?B?dEZVYWdkUXhzT1IramxQdzg5UXdhZXphVkhTQlYwaDVoRU42cFB3MzFtSytx?=
 =?utf-8?B?bENqVFloYVhEMUFpQThSNWdQM2FYWE1XL0pkTTlhQkxVUDdoc1lwK1l6c2Y3?=
 =?utf-8?B?dUxaZWc2MGVCVktOaFRpdW43T0hXdThuYTE1MzJCUmJrMFJZZDRnUUE2cFNN?=
 =?utf-8?B?VndmRGxNYTZJN25yNnlmMzZ3SXRvRHllWUJVMWF5czc5UXJra1kzU0d0M1Zn?=
 =?utf-8?B?MkYwa0xhZW9uRUNvNmlmbFgvWW1PaC9CNmNrWTZYbUZjN2V3ZGpwOVJneDdQ?=
 =?utf-8?B?NVVBZHN5NlVpVzdTUncxSGZhVGdzVGVsTjU3Sy8vbEt5S0tSc3N4OVhseVhB?=
 =?utf-8?Q?/qCOsbchMB8zzOCtB+CBSA8/j43QHAhMzyVvtwL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb9583a-9fa9-4cea-fa58-08d981eda456
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 19:33:11.6460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhTVi1WT0RjNRnT6+3hWnjUiE9JKCrkbRzV3SqEJy/JxioAceT4kYLD4HVgcYYSNf94BDOqjZpuRpncoQkLbFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/27/21 11:43 AM, Peter Gonda wrote:
...
>>
>> +static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +       struct list_head *head = &sev->regions_list;
>> +       struct enc_region *i;
>> +
>> +       lockdep_assert_held(&kvm->lock);
>> +
>> +       list_for_each_entry(i, head, list) {
>> +               u64 start = i->uaddr;
>> +               u64 end = start + i->size;
>> +
>> +               if (start <= hva && end >= (hva + len))
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
> 
> Internally we actually register the guest memory in chunks for various
> reasons. So for our largest SEV VM we have 768 1 GB entries in
> |sev->regions_list|. This was OK before because no look ups were done.
> Now that we are performing a look ups a linked list with linear time
> lookups seems not ideal, could we switch the back data structure here
> to something more conducive too fast lookups?
>> +

Interesting, for qemu we had very few number of regions so there was no 
strong reason for me to think something otherwise. Do you have any 
preference on what data structure you will use ?

>> +static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +       struct sev_data_snp_launch_update data = {0};
>> +       struct kvm_sev_snp_launch_update params;
>> +       unsigned long npages, pfn, n = 0;
> 
> Could we have a slightly more descriptive name for |n|? nprivate
> maybe? Also why not zero in the loop below?
> 

Sure, I will pick a better name and no need to zero above. I will fix it.

> for (i = 0, n = 0; i < npages; ++i)
> 
>> +       int *error = &argp->error;
>> +       struct page **inpages;
>> +       int ret, i, level;
> 
> Should |i| be an unsigned long since it can is tracked in a for loop
> with "i < npages" npages being an unsigned long? (|n| too)
> 

Noted.

>> +       u64 gfn;
>> +
>> +       if (!sev_snp_guest(kvm))
>> +               return -ENOTTY;
>> +
>> +       if (!sev->snp_context)
>> +               return -EINVAL;
>> +
>> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
>> +               return -EFAULT;
>> +
>> +       /* Verify that the specified address range is registered. */
>> +       if (!is_hva_registered(kvm, params.uaddr, params.len))
>> +               return -EINVAL;
>> +
>> +       /*
>> +        * The userspace memory is already locked so technically we don't
>> +        * need to lock it again. Later part of the function needs to know
>> +        * pfn so call the sev_pin_memory() so that we can get the list of
>> +        * pages to iterate through.
>> +        */
>> +       inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
>> +       if (!inpages)
>> +               return -ENOMEM;
>> +
>> +       /*
>> +        * Verify that all the pages are marked shared in the RMP table before
>> +        * going further. This is avoid the cases where the userspace may try
> 
> This is *too* avoid cases...
> 
Noted

>> +        * updating the same page twice.
>> +        */
>> +       for (i = 0; i < npages; i++) {
>> +               if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
>> +                       sev_unpin_memory(kvm, inpages, npages);
>> +                       return -EFAULT;
>> +               }
>> +       }
>> +
>> +       gfn = params.start_gfn;
>> +       level = PG_LEVEL_4K;
>> +       data.gctx_paddr = __psp_pa(sev->snp_context);
>> +
>> +       for (i = 0; i < npages; i++) {
>> +               pfn = page_to_pfn(inpages[i]);
>> +
>> +               ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
>> +               if (ret) {
>> +                       ret = -EFAULT;
>> +                       goto e_unpin;
>> +               }
>> +
>> +               n++;
>> +               data.address = __sme_page_pa(inpages[i]);
>> +               data.page_size = X86_TO_RMP_PG_LEVEL(level);
>> +               data.page_type = params.page_type;
>> +               data.vmpl3_perms = params.vmpl3_perms;
>> +               data.vmpl2_perms = params.vmpl2_perms;
>> +               data.vmpl1_perms = params.vmpl1_perms;
>> +               ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
>> +               if (ret) {
>> +                       /*
>> +                        * If the command failed then need to reclaim the page.
>> +                        */
>> +                       snp_page_reclaim(pfn);
>> +                       goto e_unpin;
>> +               }
> 
> Hmm if this call fails after the first iteration of this loop it will
> lead to a hard to reproduce LaunchDigest right? Say if we are
> SnpLaunchUpdating just 2 pages A and B. If we first call this ioctl
> and A is SNP_LAUNCH_UPDATED'd but B fails, we then make A shared again
> in the RMP. So we must call the ioctl with 2 pages again, after fixing
> the issue with page B. Now the Launch digest has something like
> Hash(A) then HASH(A & B) right (overly simplified) so A will be
> included twice right? I am not sure if anything better can be done
> here but might be worth documenting IIUC.
> 

I can add a comment in documentation that if a LAUNCH_UPDATE fails then 
user need to destroy the existing context and start from the beginning. 
I am not sure if we want to support the partial update cases. But in 
case we have two choices a) decommission the context on failure or b) 
add a new command to destroy the existing context.


>> +
>> +               gfn++;
>> +       }
>> +
>> +e_unpin:
>> +       /* Content of memory is updated, mark pages dirty */
>> +       for (i = 0; i < n; i++) {
>> +               set_page_dirty_lock(inpages[i]);
>> +               mark_page_accessed(inpages[i]);
>> +
>> +               /*
>> +                * If its an error, then update RMP entry to change page ownership
>> +                * to the hypervisor.
>> +                */
>> +               if (ret)
>> +                       host_rmp_make_shared(pfn, level, true);
>> +       }
>> +
>> +       /* Unlock the user pages */
>> +       sev_unpin_memory(kvm, inpages, npages);
>> +
>> +       return ret;
>> +}
>> +
>>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>   {
>>          struct kvm_sev_cmd sev_cmd;
>> @@ -1712,6 +1873,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>          case KVM_SEV_SNP_LAUNCH_START:
>>                  r = snp_launch_start(kvm, &sev_cmd);
>>                  break;
>> +       case KVM_SEV_SNP_LAUNCH_UPDATE:
>> +               r = snp_launch_update(kvm, &sev_cmd);
>> +               break;
>>          default:
>>                  r = -EINVAL;
>>                  goto out;
>> @@ -1794,6 +1958,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
>>   static void __unregister_enc_region_locked(struct kvm *kvm,
>>                                             struct enc_region *region)
>>   {
>> +       unsigned long i, pfn;
>> +       int level;
>> +
>> +       /*
>> +        * The guest memory pages are assigned in the RMP table. Unassign it
>> +        * before releasing the memory.
>> +        */
>> +       if (sev_snp_guest(kvm)) {
>> +               for (i = 0; i < region->npages; i++) {
>> +                       pfn = page_to_pfn(region->pages[i]);
>> +
>> +                       if (!snp_lookup_rmpentry(pfn, &level))
>> +                               continue;
>> +
>> +                       cond_resched();
>> +
>> +                       if (level > PG_LEVEL_4K)
>> +                               pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
>> +
>> +                       host_rmp_make_shared(pfn, level, true);
>> +               }
>> +       }
>> +
>>          sev_unpin_memory(kvm, region->pages, region->npages);
>>          list_del(&region->list);
>>          kfree(region);
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index e6416e58cd9a..0681be4bdfdf 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1715,6 +1715,7 @@ enum sev_cmd_id {
>>          /* SNP specific commands */
>>          KVM_SEV_SNP_INIT,
>>          KVM_SEV_SNP_LAUNCH_START,
>> +       KVM_SEV_SNP_LAUNCH_UPDATE,
>>
>>          KVM_SEV_NR_MAX,
>>   };
>> @@ -1831,6 +1832,24 @@ struct kvm_sev_snp_launch_start {
>>          __u8 pad[6];
>>   };
>>
>> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL           0x1
>> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA             0x2
>> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO             0x3
>> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED       0x4
>> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS          0x5
>> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID            0x6
>> +
>> +struct kvm_sev_snp_launch_update {
>> +       __u64 start_gfn;
>> +       __u64 uaddr;
>> +       __u32 len;
>> +       __u8 imi_page;
>> +       __u8 page_type;
>> +       __u8 vmpl3_perms;
>> +       __u8 vmpl2_perms;
>> +       __u8 vmpl1_perms;
>> +};
>> +
>>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>>   #define KVM_DEV_ASSIGN_PCI_2_3         (1 << 1)
>>   #define KVM_DEV_ASSIGN_MASK_INTX       (1 << 2)
>> --
>> 2.17.1
>>
>>
