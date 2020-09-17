Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95626E0B4
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbgIQQ2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:28:33 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:64820
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728496AbgIQQ2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:28:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/D+8akEqFcuypmtONHWJXikbxiia3IyQVQAHCL29D0SwfW/bST807CjSukrRTdkZfJtjaT0OYuQxA030wHhs1iPPuyi/UiqC7r6GX2TVhqdjg2Tz3wGNJj1LQUzq35dMvUeVRqJLVtBvW5QPWjQ/DeZmGPI20Veg/yfCYOscBy4tjx4lNRLc2A/GBPrnio2EE6E5Xk1OxurleQyACMpOUO8rIOLveoeaP6FfrIsQWBm+8DfCyiPqFjknJXeXqDYrJ+9KoBw9eVDTlL7EJoWEJsS0Rlwexb8HZqMyrGG9wEfrN4Bc9MCmhiXySQJwMeeKmp9X4RTTQB+SDu+0kO1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aucLh4BOMWnuJKQ+W5RBMvig2yzj3p5zkb0JhCYPCDc=;
 b=GU8GM8Go2G+6NOXcPyamm5KEyL+dBJeQkQOaZHcE0j4TA6vPmmW/FssGq9kQpIZDJLbqedXfNwiOi/8mKDROabvOyMwskLtOIqGTp24Olp9bVNJ5MdDkPJGxfUzb4KFd6hZ7pvocgD+lgSQs79p3fPn8OHi4FN+kbkq05aVgbKDFweDlS6xczewSzkEXU7+OYX3qMhuCUZaJAL67QprMDOuM6MBTTUwpultg8EQBcUCoSV75QHW3dZrZlysgZCFUqUDkQRGbEDcAm8y7Pb1M/kzG43phxeGmUi9iAJJHUlg5YeVKFbHSVBn0B7ubc5Cw2mJagoilFFw6YRFOltNTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aucLh4BOMWnuJKQ+W5RBMvig2yzj3p5zkb0JhCYPCDc=;
 b=mhWZquAg0BHt1sU56YSDgB66n55kzQs7XNRJLVK0VBo+v7UxIzclsz36hXZBdxn/a2ZdqvkibVF4yh3qw3ykfI5NKeyrDz93v6HVGM5Ll911cIjc0hEFqF+R4rhAzcOMNIAsb4WXMddRweTu8qWFlJN8HDvAg0AJPWs2smOTlx8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0220.namprd12.prod.outlook.com (2603:10b6:4:4e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Thu, 17 Sep 2020 16:27:27 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 16:27:27 +0000
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
References: <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
 <20200914212601.GA7192@sjchrist-ice>
 <fd790047-4107-b28a-262e-03ed5bc4c421@amd.com>
 <20200915163010.GB8420@sjchrist-ice>
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
 <20200916160210.GA10227@sjchrist-ice>
 <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
 <20200916164923.GC10227@sjchrist-ice>
 <9988f485-ce78-4df4-b294-32cc7743b6b2@amd.com>
 <20200916225015.GB12355@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <52f3eb69-cd5a-5234-e222-7ca483f0f424@amd.com>
Date:   Thu, 17 Sep 2020 11:27:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200916225015.GB12355@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0032.namprd07.prod.outlook.com
 (2603:10b6:803:2d::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0032.namprd07.prod.outlook.com (2603:10b6:803:2d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 17 Sep 2020 16:27:26 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3ecf635-9426-4f1f-aa39-08d85b2690d5
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0220AAD6B3CDDB17636F9A26EC3E0@DM5PR1201MB0220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKZ8VILQBoSUD1qFuwfG0pIkb3SUMoOrw2EqyUqU0Ni+rlkJKoLk72UVkBp5YvbXjEn6V4co72hWgtnwiqXtUvAEtW+pCqlDVo5HhOonpiIvrqg8oC/rzrO8EAFWWanUMKWTN2/7IRcc56WhWugsRKhkaW0D9hhuhy5ElPeGERHzAskEWP5bzYbqsYo/4wSPBsV98q+zFLtiEkWqKBu8UfdhsptdABG4vrcqPAStnh2lnxSQzFumhr9wn1g8GRcwDXENu5NpiWoR7ZxXIvBEFFEDQKk0VJE01Uf+CO+4/dCfSAOdi+T8buG4Xp82L+RgQdQrkQQ1NbePGV5PcOYCDDQ2FaJW8rXjkTCPWWuGVHR1Gti0s0CBYRQutyjzDiu92XzNHQ1BTHYv277RI1Rs2wZPtm1d5zMWWFPMOnrxaoabNm73GMPaJYsQTbQ0Tuwl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(66556008)(66476007)(6916009)(8676002)(54906003)(8936002)(83380400001)(86362001)(31686004)(31696002)(4326008)(2616005)(53546011)(5660300002)(7416002)(66946007)(26005)(36756003)(478600001)(6512007)(6486002)(316002)(186003)(16526019)(2906002)(956004)(6506007)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sRazScmTMiysybyLlvcaSQFpwPT1uJGwhQopwQjhUoaOn010Dj8wNQw/AX7tnkHqbenkUpwl/DFxqPEU3WOxdd7qzd+JFW/dqhkTqQEoYU7JxPPu/vbKAUuQd07lMkKTl7bngN2xoprSkJBovz1Y6lLlnBDd8n68bsB2CNf7pK+xVE/2vg0IXdRujoGqUap71AkowI2IK3jWnIdw6D33I18gHK0C9Q/6Q9N00eAKiFShAzB+qPdtQgLZk+bwoke5V/fg++ZuAN9cQ+bwyv8ytFysYF90B74uamJDeP6W/ZiqvtBUYKqRDF/XvJWNOQGtdgaPZpXf2CdBLBN3cUT5j66+BcvW3qkTmkXo8FCIpm/7zP/CXaOc8UgDLyarur9VH8BTxQx8hRGqi9ZpMZjk63If3i2Cwx+QXWjjYgEJ/wWXys3dAiKL89kqH9ay4Rw1bsFrMt/CHLBXGThtuxZcp/9ss9Pr+yMpHE143v2UK6m9m/uXWWZbQy6vt2Hs4xWx+rKL/Jx4hKMlo0H2ShkdXg/EXObVUWESpjuOx49iurfYS/gR9CdDq35EW7Bma0gj42JzU8gE5X+9bpmuvA7d9lFHvPl2WydHkUptIeJGwK/thQSv646VVmlhpdVR19IAUFHM/yFOGy+fZZYTnYkm6A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ecf635-9426-4f1f-aa39-08d85b2690d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 16:27:27.2790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cHPbGlgUxvsroQc7nViDcncf5T/pGVH8uO1azy0IyYDwswaorRMZU/oZIYKKb+jmggVu3jyGCViFSWJy21Hog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/20 5:50 PM, Sean Christopherson wrote:
> On Wed, Sep 16, 2020 at 03:27:13PM -0500, Tom Lendacky wrote:
>> On 9/16/20 11:49 AM, Sean Christopherson wrote:
>>> On Wed, Sep 16, 2020 at 11:38:38AM -0500, Tom Lendacky wrote:
>>>>
>>>>
>>>> On 9/16/20 11:02 AM, Sean Christopherson wrote:
>>>>> On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
>>>>>> On 9/15/20 3:13 PM, Tom Lendacky wrote:
>>>>>>> On 9/15/20 11:30 AM, Sean Christopherson wrote:
>>>>>>>> I don't quite follow the "doesn't mean debugging can't be done in the future".
>>>>>>>> Does that imply that debugging could be supported for SEV-ES guests, even if
>>>>>>>> they have an encrypted VMSA?
>>>>>>>
>>>>>>> Almost anything can be done with software. It would require a lot of
>>>>>>> hypervisor and guest code and changes to the GHCB spec, etc. So given
>>>>>>> that, probably just the check for arch.guest_state_protected is enough for
>>>>>>> now. I'll just need to be sure none of the debugging paths can be taken
>>>>>>> before the VMSA is encrypted.
>>>>>>
>>>>>> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
>>>>>> couldn't be called before the VMSA is encrypted, meaning I can't check the
>>>>>> arch.guest_state_protected bit for that call. So if we really want to get
>>>>>> rid of the allow_debug() op, I'd need some other way to indicate that this
>>>>>> is an SEV-ES / protected state guest.
>>>>>
>>>>> Would anything break if KVM "speculatively" set guest_state_protected before
>>>>> LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?
>>>>
>>>> Yes, the way the code is set up, the guest state (VMSA) is initialized in
>>>> the same way it is today (mostly) and that state is encrypted by the
>>>> LAUNCH_UPDATE_VMSA call. I check the guest_state_protected bit to decide
>>>> on whether to direct the updates to the real VMSA (before it's encrypted)
>>>> or the GHCB (that's the get_vmsa() function from patch #5).
>>>
>>> Ah, gotcha.  Would it work to set guest_state_protected[*] from time zero,
>>> and move vmsa_encrypted to struct vcpu_svm?  I.e. keep vmsa_encrypted, but
>>> use it only for guiding get_vmsa() and related behavior.
>>
>> It is mainly __set_sregs() that needs to know when to allow the register
>> writes and when not to. During guest initialization, __set_sregs is how
>> some of the VMSA is initialized by Qemu.
> 
> Hmm.  I assume that also means KVM_SET_REGS and KVM_GET_XCRS are also legal
> before the VMSA is encrypted?  If so, then the current behavior of setting
> vmsa_encrypted "late" make sense.  KVM_SET_FPU/XSAVE can be handled by not
> allocating guest_fpu, i.e. they can be disallowed from time zero without
> adding an SEV-ES specific check.
> 
> Which brings us back to KVM_SET_GUEST_DEBUG.  What would happen if that were
> allowed prior to VMSA encryption?  If LAUNCH_UPDATE_VMSA acts as a sort of
> reset, one thought would be to allow KVM_SET_GUEST_DEBUG and then sanitize
> KVM's state during LAUNCH_UPDATE_VMSA.  Or perhaps even better, disallow
> LAUNCH_UPDATE_VMSA if vcpu->guest_debug!=0.  That would allow using debug
> capabilities up until LAUNCH_UPDATE_VMSA without adding much burden to KVM.

I think the vcpu->guest_debug check before the LAUNCH_UPDATE_VMSA would be 
good. I'll remove the allow_debug() op and replace it with the 
guest_state_protected check in its place.

Thanks,
Tom

> 
