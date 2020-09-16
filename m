Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0026CB72
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgIPU1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:27:31 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:17632
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbgIPU1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 16:27:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ijh6ZfXB6cD1CH6LIMk5v0KEX0Mz5gTsOa4Yo1JRVkzoBgeqt3pUD2Fuc6ehjVX1SeRBrUUO+k/XFAlqUbh86gzLUG5OUO8koF+9G4GZxUGkXfmrk9Ilcqqx/aaKKaNJbPCAcQox3jNAf1emyXpt/dnAxY/SIs121KZT6GBEwn9MeoSmLxSiJYF4NUhHOohcuxNyAuujD4ERGstg/LVoxjdG+JiJZneAU3SV8f+5vQiGtZ6K8qhHFpyna2YrYaPH8XJuiN5RsUzkfffRn9XvPbytrzMroE56O/ntYdWc0x9WFsrD9buR+lEa8H3vpG2w1qAXgfaqcqGGZg+0hJ9DsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtaYVRLwf3qY5khFcuYh300loHhzck9H/b4rRuHn3O8=;
 b=C30yArODEU3THcqvjW2JyMYZlqHzdl3b9904rQop68IlzOg11pldQo/jyhCoNoAONoshXJ3onhuFRcV52anxnxsQx2xM+rCpY66BB3zJZkuAiAcdwZ09ie76qLgs/prHMOFCFkFfomprQ3Nem7t5Ah20h4P8Kmvjn3GSWgRn+gsxr4Ek2MVGWuMM0cKGU2SMCFJjUrM8etCM1bfPvLItu0N+a3ka7ATZZqBN9Z3m52l8txOhkhe9ox4ZJo0SUTCz9q8X1SinY8/NiNp+uoIj+CskDSjtLwnGrUgQSdJMqphgZczlwmB8FKGcEfDOiog4NYFtSfQfGxjH3b9XxIe8IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtaYVRLwf3qY5khFcuYh300loHhzck9H/b4rRuHn3O8=;
 b=QLwmpEE6g5N6VgEqYNElyF+tKDc+KWug06YtT2ok8R4v4bbgnJHmbITSs52NkvHtZMBBRCulRwLs7j9G7iqgjuUtZrSed3h0k6lecpOoxBDikQinDEIy5UhfFaOBcBSeQQXERrisXVuVSaf+C01YYK5JI1KbAHr/j5Lr02rrLAI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Wed, 16 Sep 2020 20:27:16 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 20:27:15 +0000
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
 <aff46d8d-07ff-7d14-3e7f-ffe60f2bd779@amd.com>
 <5e816811-450f-b732-76f7-6130479642e0@amd.com>
 <20200916160210.GA10227@sjchrist-ice>
 <b62e055a-000e-ff7b-00e4-41b5b39b55d5@amd.com>
 <20200916164923.GC10227@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9988f485-ce78-4df4-b294-32cc7743b6b2@amd.com>
Date:   Wed, 16 Sep 2020 15:27:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200916164923.GC10227@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:3:c0::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR16CA0024.namprd16.prod.outlook.com (2603:10b6:3:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 20:27:14 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4bb28a5e-ea7d-4fde-bf5e-08d85a7ee649
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12581B82A9E42DAFBD87C7E0EC210@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3Ir/EftwSEZkV9dLIjTrvYqK0z36MIRTU+ETJw1JHLA7P8Ik5Z1uSuV+4FsL3+cr4aaEMEV5amyuaMmaIPmRip0XHIpeMLDtFIsaaDPYz6AH+egR+PRRsxIshLs27CYJgm12peZU+g61GFRqcFYsxFp+IfYSJLOBfHRv+3c9xIScsVbdJzfuMlatCOxP05y254jJQnNgmudU32mlj8NuskAtIU4N3+C0J3L0Pzg3CLlO9L7erJLGS5ZaDbczBJAPCqN0WPLip72VfeoHNV8NVs3Tmx1U6fFc1ZsiJ+YAwHcKEsQaQErkSLB15oaSHNNQbBsr7rNyLddKbFz9dNTIFLlYp0pTiiKWe7FkGKMcHJjzdJWSUdUYJndHr7bCmkX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(5660300002)(186003)(52116002)(478600001)(66946007)(36756003)(31696002)(16526019)(86362001)(53546011)(16576012)(316002)(4326008)(2906002)(26005)(6486002)(66556008)(8676002)(8936002)(83380400001)(54906003)(6916009)(956004)(2616005)(31686004)(66476007)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m2/wKJuhz4wwkmP+efOhGHypwFm12K2Z1SN+9txrhrhSl+AhrohkSDjGcTQm0N+9r72+SELzvBerl8F6+d4wtiWelb8lJp+fkYnFEF7b5suNffQal5lCQqzVxf4GjvKQROIFWa5YaQWW7luqfrl+A/ee/QUYYi2arhFUK4+429XBpakuxrviRC5lLt9uiytUf6KKZraWNazI9e8l/Plj5OyY7s2pHdXwkrZlLruQacImzxbAGcS65SAa+jd1IfeYYt4r6LnRTEJNZFo/K2XGKFnPCqFXdmjLKTbTQvwDAN7JwpuqbGBvT2HjGONrhqHgdiOoT27ZQim/kkfW2AvmDCpqo9ORWeiazaZLL6CpVlEEOae+g96CPWLxPvMV2DXo3ZU/LoNMmKVhi24WVd4fbuqE2UCt2mvDz9iLMVf7MiPuG2YN9Qcc22DLs5zd0CsYL4AGWvZ7x9scQOmEc3gzsDkxiYXX+GAJVjqqxRaFrw3u6ki0zKOXrFAa7dp6xQ9KBKsELp6Twg9Iu8qgSojoDrMGPKGn9W5m68rFDMKMRh6JTTyyGU2BIhIttmX8LnTYdPayfiirvJAzMHz4NHicTd3wR/Li5ffn5nK8JSmaibF+MG4A9y84XPS8bmDdHFme5n+YqRnLXBwp47/4ZgmkvQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb28a5e-ea7d-4fde-bf5e-08d85a7ee649
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 20:27:15.3724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdwraeJKYlzMEKz/Yvz4lmnFhmObOkppvvwtngFruleaNTa+VIyxg8bnXTXOjLsCuIf90amBP6mWLbQy8BVr2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/20 11:49 AM, Sean Christopherson wrote:
> On Wed, Sep 16, 2020 at 11:38:38AM -0500, Tom Lendacky wrote:
>>
>>
>> On 9/16/20 11:02 AM, Sean Christopherson wrote:
>>> On Wed, Sep 16, 2020 at 10:11:10AM -0500, Tom Lendacky wrote:
>>>> On 9/15/20 3:13 PM, Tom Lendacky wrote:
>>>>> On 9/15/20 11:30 AM, Sean Christopherson wrote:
>>>>>> I don't quite follow the "doesn't mean debugging can't be done in the future".
>>>>>> Does that imply that debugging could be supported for SEV-ES guests, even if
>>>>>> they have an encrypted VMSA?
>>>>>
>>>>> Almost anything can be done with software. It would require a lot of
>>>>> hypervisor and guest code and changes to the GHCB spec, etc. So given
>>>>> that, probably just the check for arch.guest_state_protected is enough for
>>>>> now. I'll just need to be sure none of the debugging paths can be taken
>>>>> before the VMSA is encrypted.
>>>>
>>>> So I don't think there's any guarantee that the KVM_SET_GUEST_DEBUG ioctl
>>>> couldn't be called before the VMSA is encrypted, meaning I can't check the
>>>> arch.guest_state_protected bit for that call. So if we really want to get
>>>> rid of the allow_debug() op, I'd need some other way to indicate that this
>>>> is an SEV-ES / protected state guest.
>>>
>>> Would anything break if KVM "speculatively" set guest_state_protected before
>>> LAUNCH_UPDATE_VMSA?  E.g. does KVM need to emulate before LAUNCH_UPDATE_VMSA?
>>
>> Yes, the way the code is set up, the guest state (VMSA) is initialized in
>> the same way it is today (mostly) and that state is encrypted by the
>> LAUNCH_UPDATE_VMSA call. I check the guest_state_protected bit to decide
>> on whether to direct the updates to the real VMSA (before it's encrypted)
>> or the GHCB (that's the get_vmsa() function from patch #5).
> 
> Ah, gotcha.  Would it work to set guest_state_protected[*] from time zero,
> and move vmsa_encrypted to struct vcpu_svm?  I.e. keep vmsa_encrypted, but
> use it only for guiding get_vmsa() and related behavior.

It is mainly __set_sregs() that needs to know when to allow the register
writes and when not to. During guest initialization, __set_sregs is how
some of the VMSA is initialized by Qemu.

Thanks,
Tom

> 
