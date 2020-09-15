Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978A526B7FF
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIPAeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:34:00 -0400
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:28838
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbgIONko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 09:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZxKlywqOMClmj7mGx0oHc7cWZfxxw+xkMO7eRsF3gDFostwD8kY1DHQHBCYW8uC8ZVxUz/SJrAYm/geHrJTUf3iZ/jJ5xCO4qKsC8tpFFEe0O9RIFI3cD+pdp1PFcf/oKiiYYJIbjDuEVBlCo6ubIzVYFabR/qbHId36g0d1xwTHTxHI/ujU5fDlaASkTcYE4Br/C4f/TIRdEi09DwuTMQnBsiPeUW4D7SPvyy4bajvX7khGruJqC9xFyiJYoTCm6BE29DkQYJANbgVOrzQQef89vIihjVn3uM6oAb4OdwU5aP5tw4WNKN60Sz7FAg3g/nENCvVpOrlzxjRufFbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3am9umqPy/RvqfH58I+TKLP98VS3OIUlNWNgPr5rTvg=;
 b=RWGcqLbW2M5RNKQ/J+2p+wbMzdt3XykbySD7FIa/uOmC0Ym9RzPqKNSrlahWuTzEj+djQPWaLQeDhHQ7B5VVeEYN3RomO9J6YS7BIswyYn6a7DxE6wn3tEuuxD3FLEyr2gmdRKq27dpsZZltHgRVuWogZedf3yYJYxW9GH/na5FsfmuQAmjVPn5+T0jqT59bXadY5oauvnki95Q3jOilE3JIqJtL+h5YvMSOVwKE1iMnedfITvsBw40cTUFz82NhwMbY8rJH6efXpxVmUh3wdb5dr7li+jR1snja+wDQuohz87nwxnm32OY/AtZROqgcT+nn+XeUKLiobKFE9bv9SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3am9umqPy/RvqfH58I+TKLP98VS3OIUlNWNgPr5rTvg=;
 b=NiPfH+6H8dIDJ9nJnQvYWVWbj0lnRNBcd7ZCQ5GEBEDmkWu+PdwqMKJBZ0wRJOSXvGJU7GXni/xbD3gv2YrbBKukp3cPk9q9+kYtFYtxf2kbcYI/N7Z59xXSKwIq+VO/qzgt3tzVVMzMX1QIoEPZjypYdY4F1gsEO38uBbBtJ7g=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1926.namprd12.prod.outlook.com (2603:10b6:903:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 13:38:54 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 13:38:54 +0000
Subject: Re: [RFC PATCH 09/35] KVM: SVM: Do not emulate MMIO under SEV-ES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <c4ccb48b41f3996bc9000730309455e449cb1136.1600114548.git.thomas.lendacky@amd.com>
 <20200914213352.GB7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2b220348-171b-68dc-689b-c238e90301cc@amd.com>
Date:   Tue, 15 Sep 2020 08:38:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914213352.GB7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR1101CA0001.namprd11.prod.outlook.com
 (2603:10b6:4:4c::11) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR1101CA0001.namprd11.prod.outlook.com (2603:10b6:4:4c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 13:38:53 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef4af0a4-9a64-43f6-39a3-08d8597cb032
X-MS-TrafficTypeDiagnostic: CY4PR12MB1926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1926D07E7F878927CFCED076EC200@CY4PR12MB1926.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xmQk799wrCG97yR0QKhVmV87Zeyd/ib6jPcjTZ67b4M8eiMXdYMBeFMlMw75MxcJdum5E4F6uiL7R1c1QjrNd+cdd6IiOx43Qvj9RQHMSpiwH3Hzz06dlw2HK7f08TayVR27rkTg5aIEzls2FiuIvLRAuEI+D7AzTFRtEDMM0TCMHc1Ta6tr/oPB/m41K+OWTgH2L1AnanLcV+AU5hg16RUOjC7hCxJVa3vnB/ukEDr8tpxVmEROvU/Xvb3d5HDmfZIYCAYzcKnFlXoORNkebQAv7nZQq7Ohpon2tzuJJ/z/igbVmI7hytLohjJWX+H9DVvfdzEWRiBjPda4IirqYbq9lGc5gKYq6CAj9VI6jdUdd6zAnp9D7vi0GHDekMK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(8676002)(6916009)(31696002)(54906003)(31686004)(83380400001)(86362001)(2906002)(5660300002)(66946007)(66476007)(66556008)(478600001)(7416002)(8936002)(26005)(6486002)(36756003)(53546011)(16576012)(4326008)(316002)(16526019)(186003)(52116002)(2616005)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +ztvglHnmUXyALU07IaeHVP6jhwn27G3OZHnt2/UriUhvdMlc2Ez0fgwI5JqwKK0paGhr3RQvTKVszqUUGh4ajoaKa3egBEVXBacBm2ubcn4Rob4yZlkh0H2/Gdkd4Mw+ji38XGpAEnFvghyzfvkmV4ieY7KFcIfOwHpPqaAvmHmNtXj3TIzdTSFCvoumhKiQboBXbrK54ifsLmBYVToR9wddV4UhmTWtvv6vBtOk461SPtEumlQKt3G4eRVLK3SI3TOXKpZTY/vsL6s39/Gld7vk21PTHMtn0n4ww1rxuqxygMnby40mTUcTvvM7PHGAaQmMzsW7PY7O1xVSVnqTr5Cd1qeOH8SswqKXbKRm1mPxyxDarR7tarV8jJVVzgvrzznRa0LPYJ/rlM2cJt/aHw68wP/9dq5zlqy8xnkmEcjGT5xNDxHKjMqy2WUe6ot/fkQ6QtQoUXoK5mzW1R0BmEiRjC4LlmtDanSbkWHKzg+MnLXgflIin3JwHFK4C74/oVYemK0A2zSIuJ+zX1G4TZkrvKogulAdD5tH51GNS41Wk6hlqOVsPVxOwmPc2DXwAG8zoLTMPZfF/X9gsx2NC5xFgbt+Q1e3Sm4knhs7HNfO0cZJRj2h4dpW6zYC9g+Of7kQILF64Wu2WjzbtXN4A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4af0a4-9a64-43f6-39a3-08d8597cb032
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 13:38:54.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DCMUvyWQq6MJRL7yfP0I506nqxQsGio03QI8tDPj2EmwijJ9+Rq3DNpWq4eijhR7DROnVttjymaJW4Jfk8GYBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1926
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 4:33 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:23PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When a guest is running as an SEV-ES guest, it is not possible to emulate
>> MMIO. Add support to prevent trying to perform MMIO emulation.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index a5d0207e7189..2e1b8b876286 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5485,6 +5485,13 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>>  	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
>>  		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>>  emulate:
>> +	/*
>> +	 * When the guest is an SEV-ES guest, emulation is not possible.  Allow
>> +	 * the guest to handle the MMIO emulation.
>> +	 */
>> +	if (vcpu->arch.vmsa_encrypted)
>> +		return 1;
> 
> A better approach is to refactor need_emulation_on_page_fault() (the hook
> that's just out of sight in this patch) into a more generic
> kvm_x86_ops.is_emulatable() so that the latter can be used to kill emulation
> everywhere, and for other reasons.  E.g. TDX obviously shares very similar
> logic, but SGX also adds a case where KVM can theoretically end up in an
> emulator path without the ability to access the necessary guest state.
> 
> I have exactly such a prep patch (because SGX and TDX...), I'll get it posted
> in the next day or two.

Sounds good. I'll check it out when it's posted.

Thanks,
Tom

> 
>> +
>>  	/*
>>  	 * On AMD platforms, under certain conditions insn_len may be zero on #NPF.
>>  	 * This can happen if a guest gets a page-fault on data access but the HW
>> -- 
>> 2.28.0
>>
