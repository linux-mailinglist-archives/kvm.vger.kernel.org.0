Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9568E26CD08
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgIPUwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:52:45 -0400
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:37664
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbgIPQyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 12:54:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mx+TvXPSar+Fy6wXQJc6lVG80Yf47wzGik19dGvYNiPmLcmf9/qiKCEHtRErfG/7J2cbIG5ctbivv2KHBl61ocV2hO5ksARcRj7GQSmWdlBa9X5E5p8Gg4Kyoroi3EfuWIjM+6/2gdTFTknKtQX6xU2qgH3libd/vT3nFoGSteljeE2hCuS56PLTS2AQBVJMuftNlymGxqy06iGmOb55LprezkpvUkYBttw2CLV18GixF/Q9bYdi2akl8ItQfKfJqd9FZMX8uc2gTJTWCINlM3N5PrsZWjiAU2b9exrR81NpAETA+s1VAb3/SAGI5TvIiaFmsgQuy1a41rPtQd+eow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQCJ7uZHgMjTNbe0DqInwpsqMn5fft9UcXQJuEm+qBc=;
 b=hLy51GLMzaN3byQG5hghd+rAGib55g8cHRNupIoWYaquoZjCMFEehPqko+aErYiwI5xm1zA/C637QLxUHHZ09CVdEtjU7Bhl+zlMnlwDFuwnAlVd4QbKCLArUKfMnHqTg3hhm16lXpLI0QFb7LV0YP/kKgwIhtuthvm9mmucrTE42qF73EvAKcbKo6mixxJVlkD9xaeDHQbITlDTH/KOCO/ByJfaIkklVUrUIKP5rbGuTMtZOKBD8d9isw+guiB3x9fLsV+AYyvYQWBJ6jrmB/QVrVmxxUDAE0TvuuDN/f4X4G92rhTfooYbECAAh97gU3ds9371baDogZnDyRDG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQCJ7uZHgMjTNbe0DqInwpsqMn5fft9UcXQJuEm+qBc=;
 b=VxBsFFiFs9x2hUPWxAwdbYphNxKGy3oN2Tu+H7wlKZLTy0F3HgAvtwR9Nenvc5kNfT02FoLsch7+975jXzRYtMdGKoPXIpYtX/e8hZQIqZd9HHTx1djQXCmty5vJ9fmJ6NFQxaVl1VpPGWPEQm1I/xCdJLsaSjSjNNQiPyk0MnY=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Wed, 16 Sep 2020 15:11:12 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 15:11:12 +0000
Subject: Re: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
From:   Tom Lendacky <thomas.lendacky@amd.com>
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
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
Message-ID: <5e816811-450f-b732-76f7-6130479642e0@amd.com>
Date:   Wed, 16 Sep 2020 10:11:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0053.namprd12.prod.outlook.com
 (2603:10b6:802:20::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN1PR12CA0053.namprd12.prod.outlook.com (2603:10b6:802:20::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 16 Sep 2020 15:11:11 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 308e1f51-ca4b-4116-0539-08d85a52bfd2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4385:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB43851C000FA1534F0103388CEC210@DM6PR12MB4385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kPmsY+Ibwv/QXQnO3kgbkQwvmj4wjJU63RXUtAk5/wdghTCyBA/B1uZpaarS2Xgwq70h32eg5O9wRwFILKeklvv0xIDvkJqkhtq9nA0V2BI3JEUPdIdRdAGsfrY7dlSpMR2rCy+4NCmNbsX908UtS8AG430CDPhmQCYyTsIKIMZDGbHyBH+1LHx32lY4sGfSk4Zre0I99XUhl+/pIQuIBljMWDOP8GE3pxWgSrFU5Gbnuiw5G008hXdqqHsYrQ32MUFF2g4kkdoVUdPp9fTAFmlKjAjR3W2sVhqo/5udY8XDzhbm7bSquaXat0YXckBAIxG9W0IZDHw41zXQ8Gu8lekE4ADxH5oR8rLRU18Z8UYDl53F2ntYfLPUi5pPw106Vj1X8ARDTHWsUL0OFULsWfJEBjCzW6coR4wZO1ALpJgmnIn0LwCKMz/RK2ONrX9b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(186003)(66476007)(66556008)(66946007)(36756003)(5660300002)(31696002)(86362001)(52116002)(7416002)(2906002)(8676002)(53546011)(26005)(16526019)(478600001)(83380400001)(2616005)(956004)(6916009)(6486002)(8936002)(16576012)(54906003)(4326008)(316002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bRIdoSTx1wAxgabDLTPvgTYa6LZlmO5IA1NQsVC14XQLznXZyC04uBjWnWdcfJj45T1goYafI3oDSpjR1sEn4AFnv96ejCW8wcsnEGZAup3lRN217C9R/RtOZ43K7uAwyr3CaECeVmhONqTTBiEFCqHlEQXYIeaj7fWMpVI3M6TEWPZoRxI478CyJTkbhWoz46c4zFqKBfHxI0b0jmZ/XNthB7LsLx8JQXyHS7wMx82EETU+F0bBw3/7kKqK+1rW7f36LKtZoInzyJjuLCYZzrkKve5SLjzo2gLr4Qo+BdhYQF4klnohF0m3iAmaHpga9/VPZvxzrWPrGfsrh5LCLWGOYDjtsYTjC4RvOVZ6RxQT1HF1A0y1GuPzGiBgM9ovh42BevGnoyrdIv+uknYj3WuoBYPO2yOY1dsVqZ22Fgk+UopKIpUyZtriJ4y68wHgrTWMsd60/XthciB2M6eFbDdjIuLNNd7FAgmcGPoSRDJ3bucsoTu59didfK3WXzZxcBFMvvIZZXa32mkYCPX9PgS+DH0jY8MC+akLYoG7oFDjRQUSGN/FAthyZVULj54rJBB7OcWKIdA1MUaQp9pvmWVxHbPbbpyPFg40A27SEfa3IDvS3g8Pn6/ZNZcNkTyk08ZK6YhmbuMjO8QKeyWEMg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308e1f51-ca4b-4116-0539-08d85a52bfd2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 15:11:12.7324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNo4uYXeIlrQGv1fYyGo5cmXJ27wejYoa0LGrb00DXgyTvdWMRdtLAKgqVdeoyt4B+S9b1OCxV62liAKDlV6/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 3:13 PM, Tom Lendacky wrote:
> On 9/15/20 11:30 AM, Sean Christopherson wrote:
>> On Tue, Sep 15, 2020 at 08:37:12AM -0500, Tom Lendacky wrote:
>>> On 9/14/20 4:26 PM, Sean Christopherson wrote:
>>>> On Mon, Sep 14, 2020 at 03:15:22PM -0500, Tom Lendacky wrote:
>>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>>
>>>>> Since the guest register state of an SEV-ES guest is encrypted, debugging
>>>>> is not supported. Update the code to prevent guest debugging when the
>>>>> guest is an SEV-ES guest. This includes adding a callable function that
>>>>> is used to determine if the guest supports being debugged.
>>>>>
>>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>>> ---
>>>>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>>>>  arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
>>>>>  arch/x86/kvm/vmx/vmx.c          |  7 +++++++
>>>>>  arch/x86/kvm/x86.c              |  3 +++
>>>>>  4 files changed, 28 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>>> index c900992701d6..3e2a3d2a8ba8 100644
>>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>>> @@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
>>>>>  	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>>>>>  	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
>>>>>  				   unsigned long val);
>>>>> +
>>>>> +	bool (*allow_debug)(struct kvm *kvm);
>>>>
>>>> Why add both allow_debug() and vmsa_encrypted?  I assume there are scenarios
>>>> where allow_debug() != vmsa_encrypted?  E.g. is there a debug mode for SEV-ES
>>>> where the VMSA is not encrypted, but KVM (ironically) can't intercept #DBs or
>>>> something?
>>>
>>> No, once the guest has had LAUNCH_UPDATE_VMSA run against the vCPUs, then
>>> the vCPU states are all encrypted. But that doesn't mean that debugging
>>> can't be done in the future.
>>
>> I don't quite follow the "doesn't mean debugging can't be done in the future".
>> Does that imply that debugging could be supported for SEV-ES guests, even if
>> they have an encrypted VMSA?
> 
> Almost anything can be done with software. It would require a lot of
> hypervisor and guest code and changes to the GHCB spec, etc. So given
> that, probably just the check for arch.guest_state_protected is enough for
> now. I'll just need to be sure none of the debugging paths can be taken
> before the VMSA is encrypted.

So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
couldn't be called before the VMSA is encrypted, meaning I can't check the
arch.guest_state_protected bit for that call. So if we really want to get
rid of the allow_debug() op, I'd need some other way to indicate that this
is an SEV-ES / protected state guest.

How are you planning on blocking this ioctl for TDX? Would the
arch.guest_state_protected bit be sit earlier than is done for SEV-ES?

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
