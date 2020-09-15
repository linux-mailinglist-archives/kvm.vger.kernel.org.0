Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5998826AE93
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 22:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgIOUOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 16:14:42 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:9185
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727822AbgIOUN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 16:13:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1ZYYmXvaOCmyPBnDHSYjg4o6D5N5L6OWlhMi+h94OeJ2UCKRgTVLu91JvyA+00UpEHvzVkosvzqx0Bw1cvK23yILAkTBZGzeA/AlgUpoV6iICoJkXAOdtci3hzaoLbHNXMQKTmwv3hb8Uq3rZ7hV55nmkeNoS4vWGq0imcldDcGYs2pZhzkXvoG5Fq+u0kv66Swb7if3zOT0ud9dWyJBkOsmB8BCeQ0wbWm8Qb/f0j6QPCidMcJ7er7pu8mpvEWyU95uS15butzuluR24fhc4x1LTlLmJaTdRQrCuT7fNQxx976485HcWJclMY/074Ocr0fenoKHOdFcEMzMJXhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlcDS+DN4MjXbms01ipidG9/oNacrzfaodMawUSy04I=;
 b=JdfrbB7ea2dQ+z1V2jy35JFsZCFo8OpBACOb2sisCEjmKNRq70ch5DaM9bXQTGLg8dhQz9Zh9O2Pp5WxTguYGMOT76EWAC9k6M+4FDDBZUcZCARt+M3o8I/jdZ4RuRMBeH2hHZrRq24RHIxZMYKf6ejcDhADlFrwCVEUWhePBGtmiR8jPBPLU8lf+nCYLG8y050xY7vQBwt8mYv+gBTJr30eN1Z8irxh4skzZXRzJSL0zNCvcaxYSRo+ig9L5OLzevZVLTejryNmcBSRb52WlQjTzBiNgCnWdyQaaCC6iGzSsV2XiK1qaNjmUacuYrYZc3AOApkl9Emolsz28w6mnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlcDS+DN4MjXbms01ipidG9/oNacrzfaodMawUSy04I=;
 b=HgGOwu7LUcetHPYbOeEWG9JjRRIKzvj6Pg7/5ZnH2nKLMPIWkyq545Oiqr0Ow3r5IpGsSkqEakKqZDx2xzoRKJt5H6BWDwkG46gpzRG3QLmelSnN9p9BVHpfbN7m/GWyikE8aBkOWXbg6VqtSHjxuLtfwEpDyli19KgoOY5bKak=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.17; Tue, 15 Sep
 2020 20:13:54 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 20:13:53 +0000
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
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
 <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
Date:   Tue, 15 Sep 2020 15:13:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200915163010.GB8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:806:6e::17) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR11CA0012.namprd11.prod.outlook.com (2603:10b6:806:6e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 20:13:52 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78e7fd8b-f6fd-4517-4fcd-08d859b3de33
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1350C43127CA30767F13AFEDEC200@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nsBfI3LuAGWtLlcY7+kITLIHWLkq/VGLwILL/wkQHsX4E1OL4kKkw+HBmaPOPPd/RKV8LqVV6P/oFFPxQGr3jM0dIQ9JjwnK2TuGpjww/MWR9Oygh5+5v2uiddzqEDzYn3wQn7pESNYjuvyPf/qQJGVvhGrS/wogDf1JaSkRRtn6gP8ipjKIUElm2Ua3AAydOsMWh9Uy6IgtBl+NrZypdSJ9Bi+4wieMLS0j/jm0AKUFnVg8eKYKNI/SArcITsf9PA0w3vrqg9oqb+wpPyY/tcgEDtahxFIGJjYtwR1CV1Ey2MWpNov4eI+CqNY+s5PTO1VOMHovKq6GP/kHRqWXQrG53o2v0RJdtoLf67VTYNKAB0nP0ueRu5F2r7bXsAV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(6916009)(7416002)(86362001)(5660300002)(54906003)(52116002)(26005)(186003)(66476007)(66556008)(66946007)(316002)(16576012)(16526019)(53546011)(6486002)(8936002)(2906002)(31696002)(478600001)(4326008)(2616005)(956004)(8676002)(31686004)(36756003)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xdFNGKD6Mz7C5WWRQ0sevTQwJ4X4y9jE4BLqQWYN+/ueqPBQ/YqICRSnJKTN5Zt2eHgneMlsEYrzU9g8m8ccrRLJm0IVU1HrPOHKSYEmavKzKsgAUt+Jb2u4HOJyrP7F+/d3d4bo6A1pD8x+ur3MGMm5ID/P8TsfHCHGlkxsclCDxOvxrcm8PzECWk62z0PQMpzhnTXLJ59WVAvaNJfm8Y0zFzOmZ20E6uNZa0qLPBBBI7ayVKeDwcfRvAMIsjOnQ1pG+xauvmP96WKvquSNeOK9WQsrY2poq+q+sf1dr+yUA7oxInZlgTJWeS51yaEeFOv+ByTwnMNEOfBsNF0QIsYIxkRmfZ8CO3uXScGBmquwX3Is43Rm4znqzPBbgRCJd2lmlKMPc+oXi93h5LJoPqzzDb0k6jV/0erMkUTYWky8O66Uu79NSvXGHhZtVPu92BA6KUAIZstFgllgM5kgRUT3i7U9PSvdlwXVMmiGo4YbcRvvFFwLXd2xNUkrD0aUUW/C5YNNN508WGg5s28Sixp5qDo+OjNjvsA8FM9zNkTrid6feXXMDZxmnfXAGp4d5T9Q88glCyqRhthq/BWujKfBt+5jXu8J3+bkbEMetWzfVWLPvyV045bsz/jLF/jJCXi1AiVZKVyfIJn8q7y9lA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e7fd8b-f6fd-4517-4fcd-08d859b3de33
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 20:13:53.7426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xy5msr9v6z0OQyh2iUvXZaFkmHLxRJ9dZP7zgV90rdHQ9AEs8Ij/hrJyIAPHzJ1D/L4Lyrb6TsVZ4B2h/xoz6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 11:30 AM, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 08:37:12AM -0500, Tom Lendacky wrote:
>> On 9/14/20 4:26 PM, Sean Christopherson wrote:
>>> On Mon, Sep 14, 2020 at 03:15:22PM -0500, Tom Lendacky wrote:
>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> Since the guest register state of an SEV-ES guest is encrypted, debugging
>>>> is not supported. Update the code to prevent guest debugging when the
>>>> guest is an SEV-ES guest. This includes adding a callable function that
>>>> is used to determine if the guest supports being debugged.
>>>>
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>>>  arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
>>>>  arch/x86/kvm/vmx/vmx.c          |  7 +++++++
>>>>  arch/x86/kvm/x86.c              |  3 +++
>>>>  4 files changed, 28 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index c900992701d6..3e2a3d2a8ba8 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
>>>>  	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>>>>  	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>>>>  				   unsigned long val);
>>>> +
>>>> +	bool (*allow_debug)(struct kvm *kvm);
>>>
>>> Why add both allow_debug() and vmsa_encrypted?  I assume there are scenarios
>>> where allow_debug() != vmsa_encrypted?  E.g. is there a debug mode for SEV-ES
>>> where the VMSA is not encrypted, but KVM (ironically) can't intercept #DBs or
>>> something?
>>
>> No, once the guest has had LAUNCH_UPDATE_VMSA run against the vCPUs, then
>> the vCPU states are all encrypted. But that doesn't mean that debugging
>> can't be done in the future.
> 
> I don't quite follow the "doesn't mean debugging can't be done in the future".
> Does that imply that debugging could be supported for SEV-ES guests, even if
> they have an encrypted VMSA?

Almost anything can be done with software. It would require a lot of
hypervisor and guest code and changes to the GHCB spec, etc. So given
that, probably just the check for arch.guest_state_protected is enough for
now. I'll just need to be sure none of the debugging paths can be taken
before the VMSA is encrypted.

Thanks,
Tom

> 
