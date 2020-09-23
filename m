Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD6276246
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 22:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgIWUkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 16:40:05 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:51040
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbgIWUkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 16:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUAyujksTNbEK6mzc05UCVp9b2ExKzdAAxWKWGw5SJWPPNFM3Dui9pV9moCLC1H5yTeBs9DgLcF68zUCgDdKruCx9Vn9uXZvh2R7mKA0RL/XQh6uchZvjhnMRnTq+B3XD+vtl6fcV11+gwpZ33jBjTpkIlpmuyj3qBPDGhe65Wg3Y9EWblGyJH5OUIvKNEujUQ7P0TlOG3hc8ac2HNrS6I/RmKfwuxA9W/DfkRIbtVoX80gpKpPkfBwt0q7xBPLqXaQE6YbVLG83yqA1fu/s0i+I5eant5f+lZKckl+PUGWcL4nmskW6SeI8GbIXqPYSfS+NLWWFEIKonpj8K1xniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VcmuBHyvyuKhSE/tcEsbC8izNgEadHV4YRFSCzw8bQ=;
 b=aZCEkFPOCyCX8yL0hrWo0MO7meBRV4fbmL3j6A6vNZG2BTsmE9+RDilb3XfB/O7ylVHuYjad5l5J4OxGvcDrIHmawENiUDKsb4y1hddIEFOHUVl656HSv9CSaNZlYZz3Z3Ss9NpO0ju3lbWfMpZ8WTusyIrpW+9EGuCXb8GdmcBrKRmPMt+oYT8KBnhCOKnUubIriBjUTifphvCFfObiirHO/e4TQLZQ5SnW/zXJrLTYWvsD/8bjXApkPqW1gBSseYHE0NK8xUezqqEFT/WDWM+6vL6661lZQ3ovfwQ0OsKEqj6pXwUdsSC78aJHJJ94Zh/jtszoQzKbAcD8yAWmdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VcmuBHyvyuKhSE/tcEsbC8izNgEadHV4YRFSCzw8bQ=;
 b=MMJ2w0mRg/gFULR+bHdST9F9jGilhcmyPQqfR7iiEtEWj9dH9Wl6IZ5fn1uHFrzwGhvMH6HzismQeYuXR7I7OMi+Du4xHNi6062jDBKsmFvBkY63tiXL602b8XMBsYZeV3LCV5vihbvW9qKpALKe/CfcIQ+AgBJMsUtEuOVNUnw=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2826.namprd12.prod.outlook.com (2603:10b6:5:76::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.19; Wed, 23 Sep 2020 20:40:02 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Wed, 23 Sep 2020
 20:40:02 +0000
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
 <20200923203241.GB15101@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <12be5ce2-2caf-ce8a-01f1-9254ca698849@amd.com>
Date:   Wed, 23 Sep 2020 15:40:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200923203241.GB15101@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0008.prod.exchangelabs.com (2603:10b6:804:2::18)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN2PR01CA0008.prod.exchangelabs.com (2603:10b6:804:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 23 Sep 2020 20:40:01 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f16ff2db-3290-4653-2ceb-08d86000d87e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28269ECBEF7045E1B8D123C5EC380@DM6PR12MB2826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cb7f4zCoq49dHltPnMVj6liIedOe7k9oyz2XcmMa2wtuDFp5rDdEk0jjpNuzVNHx9JsrWtvwOmjzSL6Cinxk+aKi01OpCP64O3tZnldxM5n6O+IXZlar5I+6S/ycb+hLKjG0+QF1LSZH/c5GfEwZgV5uLCQopxmnXyuBGgz/WK1e65Muctg7sMzogKf2PvEmbx2MaIwy6Ui5KWmDRlY9swh3mR4or0zOAh8RfmWwMYEY+o+zkEFqY4B/vAKwhf4ShVwoWX08rOW0wGgAn/8n2ondoXvUo+3/pwajKTbT0aQHUzjMGox/b8cQQFuIIzAGLg2dikwqgYT6nSQWeGh68RzlIjXbUqRJggxOjceXwekVetmU/diA3YkwR/Hk9S0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(86362001)(7416002)(6916009)(2616005)(2906002)(66946007)(4326008)(956004)(66556008)(66476007)(83380400001)(31696002)(31686004)(478600001)(5660300002)(26005)(8936002)(6486002)(8676002)(53546011)(36756003)(16576012)(52116002)(54906003)(186003)(316002)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XKxs28nGHkOVVFXJX+Z/CDCnGA1bBit3HplivF/Izy2w5PDgYK6yPVhd97DVvji3wjY5V8TqhwNsW0HZ2ASkilKI5mGwsl/BlDgL3JlOdRrNOAvW9R1MNGY1hAMStoIzK7eVVQKbgfR29WzcNPKK6e8HtFwOyoFWrcH2C+dYN3itBTqAgpTTDUWWwahyu5rChwAjkFgLYa2SLo4gFgfUwC6abZ3c2qGyI842RBrGSzLCvtSso2uWTgfiuGxI0CEt/2XkZxL3X4QT1YfpVZbtVC6YTWt4Xv1dZmykLDuvZI6UM2VoryT3heV6aDeswhnqeFaBjJ/QFbqJTrBw/0QSGS7ec6ul0nKX+J+GK/pkEN7jRqmZhmnj+CY7GqWUbb9MbQKDhdWDjkMrqXtDNnnf3S0VvFvbQekiBhUKWiSuFRpq2xO0p38Ye8/JjV/wS41J8t/BsXMqgT9//nFJ2XMZz9Nv6WP99PWrVYepGf11V+Oq5O82wXJqFJJvpgWalU9dVBG9B/Vnluhr5iA1/iW8/sBrUPYdwIW0o43N1ejc67ivSgw5yVBI2xAfCScw0WOA8GOr5ttRAQ52ewjYEfnBixY4Vpa4Q3R3ugGPUyOpvcimXftYpVGtJta7/wQ1BZ72GYrmsrLlmt8GuGn5t+Fxfw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16ff2db-3290-4653-2ceb-08d86000d87e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 20:40:02.3248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpTVpzVYIYzSveJubSAC+u73GyFRoRBvEvfWhoNoSh8p0fLqhSv9jDC2t7Zr4lWMBQDrz4csOB8n/7mqOJUWew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2826
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/20 3:32 PM, Sean Christopherson wrote:
> On Wed, Sep 23, 2020 at 03:27:39PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The INVD instruction intercept performs emulation. Emulation can't be done
>> on an SEV guest because the guest memory is encrypted.
>>
>> Provide a dedicated intercept routine for the INVD intercept. Within this
>> intercept routine just skip the instruction for an SEV guest, since it is
>> emulated as a NOP anyway.
>>
>> Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c91acabf18d0..332ec4425d89 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2183,6 +2183,17 @@ static int iret_interception(struct vcpu_svm *svm)
>>  	return 1;
>>  }
>>  
>> +static int invd_interception(struct vcpu_svm *svm)
>> +{
>> +	/*
>> +	 * Can't do emulation on an SEV guest and INVD is emulated
>> +	 * as a NOP, so just skip the instruction.
>> +	 */
>> +	return (sev_guest(svm->vcpu.kvm))
>> +		? kvm_skip_emulated_instruction(&svm->vcpu)
>> +		: kvm_emulate_instruction(&svm->vcpu, 0);
> 
> Is there any reason not to do kvm_skip_emulated_instruction() for both SEV
> and legacy?  VMX has the same odd kvm_emulate_instruction() call, but AFAICT
> that's completely unecessary, i.e. VMX can also convert to a straight skip.

You could, I just figured I'd leave the legacy behavior just in case. Not
that I can think of a reason that behavior would ever change.

Thanks,
Tom

> 
>> +}
>> +
>>  static int invlpg_interception(struct vcpu_svm *svm)
>>  {
>>  	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
>> @@ -2774,7 +2785,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
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
