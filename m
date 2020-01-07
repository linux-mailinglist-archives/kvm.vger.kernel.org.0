Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FCF1336EA
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 23:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgAGWzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 17:55:20 -0500
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:11167
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727046AbgAGWzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 17:55:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrX7zaDsvhqA+S7zJ2pXvQCVGfA7krjLQtyknCQTcxXNaVKfC2JYTpAJtp8wWpAlAQAskSnL+Gyylxp5gh/he8lu5vkFejEXdmAUhaghOAuWhVB0sM5SGbnPiaLoQFA0fMlPhEm7HhhxFIfMWQooDqLkfja3nmoHRMaBSl0DXHmnwRCrO1CJLIwYlxoG5vgqg0D47dXmLatP6gUTe/W66ilc+GXEAxBehfO3i6nheDaPzt0uOOtenw75rZAFFwCy1yIymcR590x7oSQo+EUuz1Uj5QXP39icnhKIXWlIULl5xw9Ml6gk+VJa8slkdCAXuguv52TXc2LpB0S6gqvMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g24uyAFCQflbr82Wg4okp4yY84A+nPTuPzIaTNTKzaY=;
 b=bTyLK3zPR99aafV06reRUqST5DP8r3b938DbMXH5dhL3aPInyIXtSSJ9QX7HAb6y3McxyC+tjdmdu0M2upndUAQKs5KRw8s2nSNzlTo/O3F63cWHJBFyC8kuVmZ4elRo8IcNHyBhhKMg9tfDsUTRqNaRRAd99Vby79vG5McAkPVTqLF8tLjWR90XjdUTQb064IKE8lCC9CFFGXnX/igjU/v6o4x8tD47jwoskWuMiOCUY1WnWav5HOpHDcLm7iMD0g5gbjxe623piioRhwkX49/c+phkmDJP3+eJOPjknGQoVnIqQR9iIWXkX+kOM8mig8W26JzKCajTHR7ATPPrRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g24uyAFCQflbr82Wg4okp4yY84A+nPTuPzIaTNTKzaY=;
 b=Ggbb1w/nYAT+JFbTuHtF4+3mda/10admEAGU2LjBWz4n96Fijx0KFNY2S0TqYEobrChIuPqYZsySwOtN2p35/OCnSjO3CpS7E1IMwdgBoOTgklMaI20VckA/xU7Fu4BLkdFKtBpe9qcZdCWc+JwymGiy4mo4T12UtaHvl0PcrAk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6SPR01MB0105.namprd12.prod.outlook.com (20.179.164.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Tue, 7 Jan 2020 22:54:37 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 22:54:37 +0000
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <298352c6-7670-2929-9621-1124775bfaed@amd.com>
Date:   Tue, 7 Jan 2020 16:54:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200107222813.GB16987@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0052.namprd02.prod.outlook.com
 (2603:10b6:803:20::14) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN4PR0201CA0052.namprd02.prod.outlook.com (2603:10b6:803:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Tue, 7 Jan 2020 22:54:36 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c19c4852-4765-45de-b1e3-08d793c49226
X-MS-TrafficTypeDiagnostic: DM6SPR01MB0105:|DM6SPR01MB0105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6SPR01MB0105436C788E719EC305C406EC3F0@DM6SPR01MB0105.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 027578BB13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(54906003)(316002)(66946007)(2906002)(31686004)(66556008)(16576012)(31696002)(478600001)(66476007)(4326008)(86362001)(5660300002)(956004)(53546011)(2616005)(8936002)(81166006)(26005)(52116002)(6916009)(6486002)(186003)(81156014)(16526019)(36756003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6SPR01MB0105;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xKCZ9wJL6YI5I2ZYV55ZWgcmdtxAPT8jQD1/A+6tdZzcUtL7+3xkSDMzUtcNg04GKUIvMDeltONosacKM9/gJM+9wJCiPzVXia7IYon8RFXIMmwn1XMIoFAOPlHzUYozVsrW730Z9Joci/OsgjRams5uAeDbLqIvT8F2w1AEHvHwSdmUpngT9NLqGNdix5Ok88BwcJaU7jL9Adhq+DRd3eBANATT5pp25YmNsOCGhBipXKrQ5zh2OBcDYobqKGiJHCRvhIAX8VjSzLyvqJ+dK1g3DOOt9w/7Gu0dSDoUnVBg+EzWjiLCPNq39A39pZkpOEr6sybbSOQiyC4byi1f7z6UFrePz97Qy43yUTCOU120mZLhbGr2RzbvH8KRTAiJqhEhPTwMJVSkQuo9DxHyMhsyOd7hVFoow6NuLYMiHA7YegTphSMIczZPe0wFgXuI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19c4852-4765-45de-b1e3-08d793c49226
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 22:54:37.3285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFTBXiN+rzKTCGPM5STcHqPKU/w4/e8GTeja7Pc25GJsXqNGj1LV57UDp/9GIlUS1rK/4szcx/4Ttkj14/Lglg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6SPR01MB0105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/20 4:28 PM, Sean Christopherson wrote:
> On Tue, Jan 07, 2020 at 02:16:37PM -0600, Tom Lendacky wrote:
>> On 1/6/20 5:38 PM, Sean Christopherson wrote:
>>> On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
>>>> On 1/6/20 4:49 PM, Sean Christopherson wrote:
>>>>> This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
>>>>> on a future processor, i.e. x86_phys_bits==52.
>>>>
>>>> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
>>>> always be a reduction in physical addressing (so I'm told).
>>>
>>> Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
>>> that reducing the PA space is optional.  Section 7.10.2 is especially
>>> clear on this:
>>>
>>>   In implementations where the physical address size of the processor is
>>>   reduced when memory encryption features are enabled, software must
>>>   ensure it is executing from addresses where these upper physical address
>>>   bits are 0 prior to setting SYSCFG[MemEncryptionModEn].
>>
>> It's probably not likely, but given what is stated, I can modify my patch
>> to check for a x86_phys_bits == 52 and skip the call to set the mask, eg:
>>
>> 	if (msr & MSR_K8_SYSCFG_MEM_ENCRYPT &&
>> 	    boot_cpu_data.x86_phys_bits < 52) {
>>
>>>
>>> But, hopefully the other approach I have in mind actually works, as it's
>>> significantly less special-case code and would naturally handle either
>>> case, i.e. make this a moot point.
>>
>> I'll hold off on the above and wait for your patch.
> 
> Sorry for the delay, this is a bigger mess than originally thought.  Or
> I'm completely misunderstanding the issue, which is also a distinct
> possibility :-)
> 
> Due to KVM activating its L1TF mitigation irrespective of whether the CPU
> is whitelisted as not being vulnerable to L1TF, simply using 86_phys_bits
> to avoid colliding with the C-bit isn't sufficient as the L1TF mitigation
> uses those first five reserved PA bits to store the MMIO GFN.  Setting
> BIT(x86_phys_bits) for all MMIO sptes would cause it to be interpreted as
> a GFN bit when the L1TF mitigation is active and lead to bogus MMIO.

The L1TF mitigation only gets applied when:
  boot_cpu_data.x86_cache_bits < 52 - shadow_nonpresent_or_rsvd_mask_len

  and with shadow_nonpresent_or_rsvd_mask_len = 5, that means that means
  boot_cpu_data.x86_cache_bits < 47.

On AMD processors that support memory encryption, the x86_cache_bits value
is not adjusted, just the x86_phys_bits. So for AMD processors that have
memory encryption support, this value will be at least 48 and therefore
not activate the L1TF mitigation.

> 
> The only sane approach I can think of is to activate the L1TF mitigation
> based on whether the CPU is vulnerable to L1TF, as opposed to activating> the mitigation purely based on the max PA of the CPU.  Since all CPUs that
> support SME/SEV are whitelisted as NO_L1TF, the L1TF mitigation and C-bit
> should never be active at the same time.

There is still the issue of setting a single bit that can conflict with
the C-bit. As it is today, if the C-bit were to be defined as bit 51, then
KVM would not take a nested page fault and MMIO would be broken.

Thanks,
Tom

> 
> Patch should be incoming soon...
> 
