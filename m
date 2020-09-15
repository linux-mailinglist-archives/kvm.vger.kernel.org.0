Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5364E26A7A8
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgIOO65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 10:58:57 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:49793
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727333AbgIOO5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 10:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkcYW+JO21IYZ34okPqE+55d7YhvLrlPDuyfTgOnclg4X6xHtkx1BT2peZEIPvcHFrNbjp9sSU4LG3Ju/CjCXO0+pXVEZCLjEa7OojS5xhWHdDRRfoxLrJxqLPAERML8sK6jiQo2DzfGKJDFaGi83S5MNwwPQIQomDvdhyz2BDlKZurqQfsAM5IDqMxA6769yveagBFwZErDtcYzo5QyZNsUcS4lIkdE5u0yNc2juY7tqmDdp9nZTBO+9PeO4WTOg4RY4rM0mIPMuCVNHBf0vguKLKnm2FidQerUZ3EHxd9zM7Xe1IDAGdjw8xCk7Z05xiaFwRQkyRJFmYW7X8Xrew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ2uktH0f4mujy/xXGHLvz66vP1ZasbHRPoGlx2723Y=;
 b=FUAVjn7XMdgIXxanbSwwkQwAOKU47xx1/GAfkSXU6KZlRf7f8EU9/bS+okRNUZzSRNuUnaJBU3F4guTLzdpg16hxh0zZfkbsCjUTcJbfIRt0D5qfS3TgIPWSz0l1Pm8QpDj/bm0g7tLScnzOWQ5cVjZPwY+x4yxlGzni1DNAeslOXMBymEH1nHWop4Hjd3bOEsOSZMskTfZsB2PB7nnrkrPaEXWqYwhRU+Wc4h09yHSvNmJiw3f13l+oq1BSKkYC9L8paJwWVhVpVm0LL/nkxxk59VLTkY2PUmXW/6PfSW3DIwxcrRSsh41xg5s+AmnsATJMyKokqteTGqtQjI55fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ2uktH0f4mujy/xXGHLvz66vP1ZasbHRPoGlx2723Y=;
 b=hDBdwFqmCGf7DVBypIKYiN73BfZlWbj8az5heP2iJUGJ/4ZICRibqoMOnv/mHQJbGN9k3SblQ33nlcuN68HIMyDSqN8VrXTdtsAWdrGyFS47Z9WJbB7Jdlmu3+3Lpbpwwc8626XOPpf23dMKzDP1pJlJZVXEPYSB45QBktC8RPo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0152.namprd12.prod.outlook.com (2603:10b6:910:1b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 14:57:26 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 14:57:26 +0000
Subject: Re: [RFC PATCH 28/35] KVM: X86: Update
 kvm_skip_emulated_instruction() for an SEV-ES guest
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
 <ff66ee115d05d698813f54e10497698da21d1b73.1600114548.git.thomas.lendacky@amd.com>
 <20200914215144.GE7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8cbafd62-528d-fc8e-9945-575c2b659247@amd.com>
Date:   Tue, 15 Sep 2020 09:57:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914215144.GE7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0078.namprd18.prod.outlook.com (2603:10b6:3:3::16)
 To CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR18CA0078.namprd18.prod.outlook.com (2603:10b6:3:3::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 14:57:25 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2fdd14bd-4f51-4c8b-2816-08d85987a8c0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0152:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0152F5FC6D922ED93965E698EC200@CY4PR1201MB0152.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmww6d3p505ZtB9oU7fr8OTI8SwJiCoB15PLowFnDE+UjR/9fwgKXR1x1XN7YWrOIkD7HUk//J5YMXinnorm6uwBPKC950A7Jae9e9nipK4FF01pzRqjZP2lJSOCK2muMdmmiiXZgCAdNEZOKFgyPYCAR1xfoF7AKqxP8qi7n1SIubSQr6oBZHpBBqM05QZEfnXoaTcX98NtTZdO05j0XICk1Jo6W+dng6QzIl4tlPuEgyWanpGgidtmlQx5gqiBUgtYUc+tMMtr14UldWfI9xTG6VDqzdXeYb+f+N8qFMC8yjiwjw8xPkRgjMIdwKNQ2Mnr71VxNhzzHNGqNnMj/IlsMw0uzEUEW857TsV2Bb4ZYFBwB92OP87ZA0W1GZlyxe57zZCO3jgQWP0qSvKN6hemhQKILRs8tVH/guY1ONo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(15650500001)(66476007)(16526019)(316002)(86362001)(2906002)(66946007)(66556008)(16576012)(26005)(52116002)(6916009)(83380400001)(186003)(53546011)(4326008)(54906003)(8936002)(36756003)(478600001)(7416002)(31696002)(6486002)(5660300002)(8676002)(2616005)(956004)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fIrqqPk7vkzMWFiKKZQ+h7qLhMQbk1zWE1cDf6XRHJwveh4ad3iovDM86j07+8w7Ruj1VYlK/NilG16AHcCLBxe+qajN0S3/LhN554HhGhXqGj7Rjdeelg4RVNyja5l3Qz8l+KUSFvdtCEhnd7eMwwRI6gszpabQXXz+B9vp3EEXSlycOAdr6ZYWJ65Aj6yJCpX099aAkn9VVsOXyZvxowqz4rGKqHVpqc8uff1aCO0qc352oBcUF8WWt11zldIPvQpRwcExwz9VmcCbq0f9935bII9xJ8u9opyBVgnkNvIGoRNNxiF1lWFoDZcnQL2kCnOsWH6Q6//YsREmX9i8/DY7rnwe0Nw0weQT0W+dQfvyAgyEpnfN1qNOFxmYf9lhFBsImtY+rRYX8YTjkveK7djhnM0l5AxuExb9A/9ZsMxPKtnpeSddh+B6+qa56SieaJJdTTvDNYm0apeywqNHUbcj/324uGXSGkL7SrmQsSn6wSb1qXAfPwgKNvUaMDmhcJBAtbvFLrzn4fiSJsMouGWjBC3CBBFyuoLLSMgOyApoZNTzfvhNTTvSRAUHWwoVjV3yy5uenTr78pbQ6uVEAr1RPqGbJ85lPsJC1bka03WaW8HYuA+Krd6UyhR1BpUSGONtLZlwSTM374/L3rmKuw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdd14bd-4f51-4c8b-2816-08d85987a8c0
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 14:57:26.2426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vz0BjgTULaMYwRK1Fz5zEZAgxPqmVA31Rh9icNiXQUU96/sXeLjUIpGLQyb/YglwdkmHJ7MGWB0EyMKuJFvpOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 4:51 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:42PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The register state for an SEV-ES guest is encrypted so the value of the
>> RIP cannot be updated. For an automatic exit, the RIP will be advanced
>> as necessary. For a non-automatic exit, it is up to the #VC handler in
>> the guest to advance the RIP.
>>
>> Add support to skip any RIP updates in kvm_skip_emulated_instruction()
>> for an SEV-ES guest.
> 
> Is there a reason this can't be handled in svm?  E.g. can KVM be reworked
> to effectively split the emulation logic so that it's a bug for KVM to end
> up trying to modify RIP?
> 
> Also, patch 06 modifies SVM's skip_emulated_instruction() to skip the RIP
> update, but keeps the "svm_set_interrupt_shadow(vcpu, 0)" logic.  Seems like
> either that change or this one is wrong.

I added this because of the get_rflags() call. But let me look into
changing get_rflags() in svm.c and see if this patch can go away.

Thanks,
Tom

> 
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/x86.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 23564d02d158..1dbdca607511 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6874,13 +6874,17 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
>>  
>>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>>  {
>> -	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
>> +	unsigned long rflags;
>>  	int r;
>>  
>>  	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
>>  	if (unlikely(!r))
>>  		return 0;
>>  
>> +	if (vcpu->arch.vmsa_encrypted)
>> +		return 1;
>> +
>> +	rflags = kvm_x86_ops.get_rflags(vcpu);
>>  	/*
>>  	 * rflags is the old, "raw" value of the flags.  The new value has
>>  	 * not been saved yet.
>> -- 
>> 2.28.0
>>
