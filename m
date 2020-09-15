Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564B626A869
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 17:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgIOPJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 11:09:18 -0400
Received: from mail-eopbgr690056.outbound.protection.outlook.com ([40.107.69.56]:37539
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbgIOPJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 11:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpGSc/yzhH5UhxYJ2AmZJCyi5mDhf7e13po1ZapTPk38qRXBkulscxJM/cZKQfos/WKJCFxJaAD2CnmipIGMf5P6aCZWo0tKDVaDoRAECG13B75F1qUVd10lECAHWoOTh2XIVPgsPfBZ+g4EL1cYq1q6qtKzO55YDRthAm8PIDldrlrz47CitZrwownAv+OOvq5epCqlAimgLwQ1H4XJsYnPXMViGTgsrn2O+zKYtQ/rJ9eqzEIuCh8rdBqonCZxQzbOH3jULhXvJD7ih2IBA8E3FmxzX3JXfa4ne9yzjI0BoHVd7S60UXK1g5VKxyrWYCoFhL5G5AQ2LgKQiDj0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d169twpUWxwadu4FcPeisrFj8MaKBnDzST7QcA/DHas=;
 b=O8oWpspcwMsup9l00asNPlOT/Zj4fKzL60fG97qVg4HKl1fjzAucl9G1ugTce1dW+ZJ4fNxu6ZPyyA7iBmHwCBDL2iV5yw0cCZkceix2SPwOcYYvyr9fnhty/uDubsNL1h6szAw79XcA26Qu5DBhs4YLZQN83cSbxPgUnmWPQ3w/9xn6BFBxEddFspsgbNwKfe2LnYQUyA2UHUS30QSp/pzkfyYTWDMEPjoz7g1RKVLKkuUUVgu8COEYZFONZsvkhMtk0FvGJNyJ37/G/xv3Wpz9ahUN5nP3H1Dz+utFsxx4+hwkgB44eHWYrYIr0AZR0Sg+FfkZhu7giR/5BiZDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d169twpUWxwadu4FcPeisrFj8MaKBnDzST7QcA/DHas=;
 b=Ei8NoXVldhiY0fVzRhfT69beAHLzSipuHGJ0s01HKBiteH4LEbuJ9X9o+MuGWOKwkZga4ptOiRu3f5+qxHyQ2va8eeXl/EidNRcPkDUhnTNzW0kB+oh0aoDmQEodBlrnndVbdT3+aUVTL+WKHD6Y3vEmEK2sX0lU6OyyuUNBB54=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0167.namprd12.prod.outlook.com (2603:10b6:910:22::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 15:08:58 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 15:08:58 +0000
Subject: Re: [RFC PATCH 20/35] KVM: SVM: Add SEV/SEV-ES support for
 intercepting INVD
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
 <cc70b4ac7119dda48a76b0d3ab6ba99ace3c4b5b.1600114548.git.thomas.lendacky@amd.com>
 <20200914220052.GH7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2f084415-0553-582e-c1b5-fda5434a321d@amd.com>
Date:   Tue, 15 Sep 2020 10:08:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914220052.GH7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0028.prod.exchangelabs.com (2603:10b6:804:2::38)
 To CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN2PR01CA0028.prod.exchangelabs.com (2603:10b6:804:2::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 15:08:57 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c17c206b-18a3-442b-5fe7-08d859894584
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01672E36A7439B4512262C21EC200@CY4PR1201MB0167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLqHiT3fjVeh1MGp+p4kFj6kjqkmcyLBdWMbLhLRQb4vY+RHrCqbda+Wa9weVZw5RRBkYczkLQX73eZLktCeZSHrjGe3oYy9TiN4AnRUloKwr7Pn3rxhoIofO8v9+iN51zGEte8rCDCQGxhjnbtk2VNFC2YBlwsd3bZZvy8/NnKY3uORKIKa+XQZdzDBANs4lzWHuw1LvwYlmG78Wcj/Hp6TiUixVVLurVdt+rM2fQY57GC0YZ3+g5ds7kQH29gf6B+C6h6XlJWYTSAUcS2Q7ovOFadWiDvd5LS8RIvux3sbWX5XZ17JEfh6LKti/y2wslMbDmV3/6oGED9/c063dgPMmDsxB5zjV2D0JXsQtxFmjbRXGhMM9vjZc1e3D5yA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(6916009)(2616005)(31686004)(53546011)(2906002)(54906003)(83380400001)(16576012)(316002)(66946007)(86362001)(66476007)(6486002)(66556008)(36756003)(8936002)(956004)(478600001)(4326008)(31696002)(7416002)(52116002)(16526019)(8676002)(186003)(5660300002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IajE6bQwyMrF+jvbQeu+DmO/o90MXkS8QwwhRjAXSZTI2hzXSzUdm5m+4kpw1YiA8C/MGaHAsO0/57eotO36sG0A1PZnO41FoRZffXLwU0bJWOKTnJSrALRnFsawMHFFRjopMQAZa6CgPHNiN13edtEAVMbHb6Yyd6pGjcKzVOBX+zDGp/ukKfaCX0kgyvpJk+ifr3IRPjR6lYKbW1hrOUNZM9YIGTCWMR++cifj8C7Ap1RkGDrkpzcNT/KnsDcOET+dXgZ2LPE9Iwrrrtz/c0h6vosmdGxjFdI8pTPN7SRSvR3hVpEWyXyECRd84n6KA1d4xL7X2DJ64DZ7GtmIujmuvw3L2dHs2LIzDq7U9SLW6xBMVTDWmbBSMPKCNY5AHl2b+l9pn/EPudFMUpYymgqM6wcSvVYhoPzDopadl9a5YrnNDrR1Iumx1usYu7+WUqW/tA1da9WgyufzHJYV6SjDOYpe6u4OLH3Nv07KxKznyuJu7VR7D77UU3y8iLDHedvl7NhIjpdSl0xeUvvmKiDDuPu+emHAugTAoH/scjr2+uuidiuldiU7WOBemHSaQbpQeORcdo1+t2weQ9OD30choefaeQKZUodS8ShEdGxd/3Tg9HwxqO0nB+3+Xvp8mu8ZRetzifxw5UHI6UQbiA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17c206b-18a3-442b-5fe7-08d859894584
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 15:08:58.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mflKKPBL0hXT0JhgfmVoRJKlVqfBsN2z0fiU8iGrujmJh7Q+p1Yj7LK+l9Sef9DJkjNe13Z0UjUhGfYiVDtag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 5:00 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:34PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The INVD instruction intercept performs emulation. Emulation can't be done
>> on an SEV or SEV-ES guest because the guest memory is encrypted.
>>
>> Provide a specific intercept routine for the INVD intercept. Within this
>> intercept routine, skip the instruction for an SEV or SEV-ES guest since
>> it is emulated as a NOP anyway.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 37c98e85aa62..ac64a5b128b2 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2275,6 +2275,17 @@ static int iret_interception(struct vcpu_svm *svm)
>>  	return 1;
>>  }
>>  
>> +static int invd_interception(struct vcpu_svm *svm)
>> +{
>> +	/*
>> +	 * Can't do emulation on any type of SEV guest and INVD is emulated
>> +	 * as a NOP, so just skip it.
>> +	 */
>> +	return (sev_guest(svm->vcpu.kvm))
> 
> Should this be a standalone/backported fix for SEV?

Yes. Let me split it out and send it separately.

Thanks,
Tom

> 
>> +		? kvm_skip_emulated_instruction(&svm->vcpu)
>> +		: kvm_emulate_instruction(&svm->vcpu, 0);
>> +}
>> +
>>  static int invlpg_interception(struct vcpu_svm *svm)
>>  {
>>  	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
>> @@ -2912,7 +2923,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>>  	[SVM_EXIT_RDPMC]			= rdpmc_interception,
>>  	[SVM_EXIT_CPUID]			= cpuid_interception,
>>  	[SVM_EXIT_IRET]                         = iret_interception,
>> -	[SVM_EXIT_INVD]                         = emulate_on_interception,
>> +	[SVM_EXIT_INVD]                         = invd_interception,
>>  	[SVM_EXIT_PAUSE]			= pause_interception,
>>  	[SVM_EXIT_HLT]				= halt_interception,
>>  	[SVM_EXIT_INVLPG]			= invlpg_interception,
>> -- 
>> 2.28.0
>>
