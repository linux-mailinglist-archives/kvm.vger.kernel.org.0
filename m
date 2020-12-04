Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1260E2CF2EF
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgLDRRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:17:43 -0500
Received: from mail-dm6nam08on2049.outbound.protection.outlook.com ([40.107.102.49]:37857
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730547AbgLDRRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 12:17:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGICusjk+NZkiYrVTttXfPZXnB0TyUzzqoMSsV64N7Y5A3/n3Tspv4WVw1owlerhrAi6lwaHIMIkGuvP/Jb5eJF/u9/EGSGlR7Ui4ccffH7D87oow/uZYRN1yJHjOs9xn7z9eo79+NXQk7npuj/ccfnDgL0TNCvQFcM/z2YSSJGbCgORY7AcV+UKS/N1z0E/S7F9V331hgJJbhwasY0OT7uGAAUtXjD+n17tHov+z+4wHLRP5AmB2tREQjc8IGw8fPbgp2X/XlD1CTFThMrh7kX0nrRT/bVhT8I7SK6ZXi8iu3k7QQh4tako3n6I/alCpkAyZ7agi1klqj7Ylk5t/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UA9TlqmEy5WvXZBr0/9JmE4RXmdril9wkWatqr8z+n4=;
 b=njjaiUnCS/zm2UVPi7ITgO+UfE3PLnrk+d+jJly1XNM3mmwiqpUo2kelMc0hpUM8H0W2D9wWiKGIi7co0wdsLOMZIKU5bFcGByxS6HzY3wzCi/XZ8qry/hSwLw5cZsDY7AC17/6c768f3x8R46jfavo/u+KLpOBs7THBVrW7QOIVUp6whSWXzCITgZcrQ6Y/7RLivozetggtG2BUxUhhlwF4rDPh2ueUzorku510jjzdJrF6vxWQ27VgcEKrAV+ow4mBwWVFDkR4270KX+fRlExAEMDO1C0WdHDBd5ZzErj36RCmHgo0s1fX4DwFIFmgrcTewoBZI+9umfqwNilaEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UA9TlqmEy5WvXZBr0/9JmE4RXmdril9wkWatqr8z+n4=;
 b=To7kOzgztyDG3GKED4gFTqSXwU/cajO5QG/JjMaOYuVTvV0YiAf8+4aofDXfLandHQFMYJZc8iexczfJ6K8BilgD8H8O1AbukrP94pYXT6oIS2n/l2891kD8Zmc/3XJDBAXdWbGsdExfPayJu5BbfUbuDlwa6zMNrIuiZ7aBJDM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Fri, 4 Dec
 2020 17:16:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 17:16:50 +0000
Cc:     brijesh.singh@amd.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d5139a3e-2dce-dd95-19e2-5ae157d07ffb@amd.com>
Date:   Fri, 4 Dec 2020 11:16:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <X8gyhCsEMf8QU9H/@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: DM5PR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:4:ad::37) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by DM5PR07CA0072.namprd07.prod.outlook.com (2603:10b6:4:ad::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 17:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19ad94d8-4fff-44ac-0746-08d89878630d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366DABEA1609E1B8B2856EEE5F10@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNPgCkh3zkDwFWj/zji+dOiPX9hoNWnS0huT1SCAkfnx+kNIZyQ9mBbtOljkf4dNUzqLzt4KhTCYaZS3oVdrp3M/TvvofjoMlJv0IeFbFI20F5kaUd/mKlN1j4/hzF3FWNNmnA7rgtahlmSrI+7EF5RHHehDTAwJ4ljowiY+E6/EetJdVSFYtmemP6aGhQjIga1LS9MYfbR+WxuwB7kvvUIl4FNZiM6oBQgJAeS+6+r2iOaHO+/Ectc17c2BhQCo4M2EzjeI7GKMo6Ja5mI8ZYP1S9OaOIoYy/Pu3/hXBZPE9/WyF0dk511IJhGXEP+2ZjnNB8EvTo9uasDYPggUC4jUgNytih/Ov1u4+2Ltk1p4hfWabRlipMTCFBIcsrupGa2HiO79pULjEqEzZScMZSnNVX3uSCRU2IHOyjgdJt8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(66556008)(6486002)(26005)(6666004)(186003)(16526019)(31696002)(6636002)(6512007)(4326008)(8676002)(8936002)(44832011)(2906002)(66476007)(66946007)(36756003)(2616005)(6506007)(956004)(52116002)(316002)(110136005)(7416002)(53546011)(478600001)(31686004)(86362001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3EyOUFDbUM0cW12MStQYTQzRVJsZE1PaFR0NDBqWE5JdTc1TXk0WXZpaDBJ?=
 =?utf-8?B?MHNUNE1mM2hrTjRrenVDYWZ4Qm1yQXIxN2dZUVIxcXowK1ZEWVFrWGdQeHQ1?=
 =?utf-8?B?cG9PQ25manhFYWt6aStrUHE1THRJWXpwSTNJR2s0VGFpV2d2d2VMTWhzOWhp?=
 =?utf-8?B?Q3FvdzA1U3ZtTWIxckdxU1RWYkdBL3dTMmxWRTBJUnNwV0c3UC9acnYrTHov?=
 =?utf-8?B?TUlGdi90UitxdEVuTkx5bmhFWjJxN0pjQU9IK1BKd0xNUmV6a1pJeFpaclZn?=
 =?utf-8?B?NUc1TEV1MWRxQTJRbDZyR0I3eFBYZEh6SXl6OEQycFBuZTFEcjhTM2tuMDZI?=
 =?utf-8?B?WFVrMXhqbEQ1cjBPNEZCYkNHN3J4QzZPemFkQTJZSU1uYmlmc2dNWnVsYm1X?=
 =?utf-8?B?Z296M2lVbmdFQnlHcm1naWJZOTNib1d4RnVYcXpMc0RycGRDVWdsOGV0SCtJ?=
 =?utf-8?B?Z0paaEtXcFJxZmpoOXRiSjFWKytDdnNEQUxEdkpEUzRjOXBoYlVOdVpaOW1p?=
 =?utf-8?B?RHRnY244TGdIZkYxd1hWM3ZaSGsvOXV4eHBMclc0Z3RBU0lTeld2T3lZdWY3?=
 =?utf-8?B?OWxXVHM3cDViSW8wZHc2aUdLWTFVM3FERk80Uzc0SXFSanNmWmJwWFRpSFBB?=
 =?utf-8?B?OU1hcGRGYlpMc1Uwcm05V2dUb05jei80K1RaVzFhR2VSbTkwUFBzMzZjcC96?=
 =?utf-8?B?MmhPY2krQk9Mcnc1NVdRcHpzd1IrOHFFNk8wbHBMTU5vNGFPWFJYVlRiNjAw?=
 =?utf-8?B?b3JWSlN3YTFLdjc5bE81WnM0aVJja1BNYmx5VWtzaU1rblh6VXkrNlg5Wlh6?=
 =?utf-8?B?OHVGVkVmRDdHVE9LaWN5eDlmZGRZSW1VTVJpV3hqS0N6ditIdDY0QWI5K0VH?=
 =?utf-8?B?VWlDaWp1R3JWeEZxeDdRNmxLS05qM2p3Qis5K0U5Mk5FZEJoeU1ubzNGaVhD?=
 =?utf-8?B?VERpanRORnN5S0dzaTJ3QVQ2WC9QWGlVbjUrVGgxN250bHhTUlRoNVFBcXpm?=
 =?utf-8?B?eUdMYVBUc2JBbEduOTlHTzRoR0ZNRzJ6NUFPUENPVHdoMTZnaDgvdFVVdjFW?=
 =?utf-8?B?WWpuNmkyWnNWV2ZSaEF4YTEwSEZWVG05ZFlQZW5WbDFWSjNrcE5FSGFodDBG?=
 =?utf-8?B?T2EzNkpJZ09JYjZreTVPYyttU01ZQ1g5RGE2Mi9zZkk0djVIMEIzbmZJY0hR?=
 =?utf-8?B?SERkYytvNFdpYW5uYUV3ZVlnNDYyWGlmUXhXVWtnY0FiNmJXNVBDNTUwcjc2?=
 =?utf-8?B?eGg3WG1na3JyUE96dk9ZN0dNVVVZczZxL0tCaXZVcnc2NkZCUDYxQjlpcXVx?=
 =?utf-8?Q?7OQ8PxBxo7uc/Nl9WYMAHPNWyauxc/uBC1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ad94d8-4fff-44ac-0746-08d89878630d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:16:50.0499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZ/5xfVRbzmuu4XiOCyJQMrWFt5n55wObQinGElilB8e8DD6Id5YFMWlJepakoZyatgj97Z1mnYWMbbYhoJZzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/2/20 6:34 PM, Sean Christopherson wrote:
> On Tue, Dec 01, 2020, Ashish Kalra wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> KVM hypercall framework relies on alternative framework to patch the
>> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
>> apply_alternative() is called then it defaults to VMCALL. The approach
>> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
>> will be able to decode the instruction and do the right things. But
>> when SEV is active, guest memory is encrypted with guest key and
>> hypervisor will not be able to decode the instruction bytes.
>>
>> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
>> will be used by the SEV guest to notify encrypted pages to the hypervisor.
> What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> think there are any existing KVM hypercalls that happen before alternatives are
> patched, i.e. it'll be a nop for sane kernel builds.


If we invert the X86_FEATURE_VMMCALL to default to VMMCALL then it
should work fine without this patch. So far there was no hypercall made
before the alternative patching took place. Since the page state change
can occur much before the alternative patching so we need to default to
VMMCALL when SEV is active.


> I'm also skeptical that a KVM specific hypercall is the right approach for the
> encryption behavior, but I'll take that up in the patches later in the series.


Great, I am open to explore other alternative approaches.


>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Reviewed-by: Steve Rutherford <srutherford@google.com>
>> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
>> index 338119852512..bc1b11d057fc 100644
>> --- a/arch/x86/include/asm/kvm_para.h
>> +++ b/arch/x86/include/asm/kvm_para.h
>> @@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>>  	return ret;
>>  }
>>  
>> +static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
>> +				      unsigned long p2, unsigned long p3)
>> +{
>> +	long ret;
>> +
>> +	asm volatile("vmmcall"
>> +		     : "=a"(ret)
>> +		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
>> +		     : "memory");
>> +	return ret;
>> +}
>> +
>>  #ifdef CONFIG_KVM_GUEST
>>  bool kvm_para_available(void);
>>  unsigned int kvm_arch_para_features(void);
>> -- 
>> 2.17.1
>>
