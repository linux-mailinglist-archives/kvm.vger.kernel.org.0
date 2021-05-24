Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3437938E79D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhEXNa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:30:56 -0400
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:42720
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232965AbhEXNac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 09:30:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLMzwZmG/VuiwzLugZCOE2jzhQqxV/s34kjElGIR75UwTIqHTxNBFs10p8YghT8QfExOSFRIReHV7qrjSgqiYYnGBR7tKDpqRjz0ag03qjVdNtDBbeizm/XoHWbsoSCkz5nHy21ywr49sRKPkZCCD9IpuXnzmFAe2b/1yT9O/CuqKLXzQVK70WvipIzXEaiinxJKiFl+y5wPh7HVEsdpS/VFmz2YK5ivQug8zhA6yXy7sZmnbQK1L2Wqt+Aen1d2D5tzvu7a/6OHrSQGHfBw1vS4odcG5JVQYWPi1IoxA+Pfg1D9V7wly9SKWg8S60TYzlxtjgyidIK5dSaKw0D8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Aw8QaW9ATw3lb7dE1l5dgmhCNtLhW/qtycbvqON0LQ=;
 b=NdmAKuKKQmjxsqmtHftqRZ4YmcpcYB+2aPRS2Afa1KihRsMnhxPyoFtkqG82+hyvdbSVsw4jDIt0t2vSiCiVttkQwPqvFCSn1euee7FKgHheEa8Pbhql/p3KfKVYS6WnvLlx0WrTj9d4iNzovSeFYb6jA/ryoq+G8BecjGtuJ57a4QVd8rEctDFlZEj2sQx0+h3DX0aEV0JS/JiI38A1FB4ARfH8FW0IyP/CXnaidrwDQcjSS0VxPRQ64/xs22Y+cT0jUDsEtmDx5+Vu/xDNsSBDGmMQpeNGk7MkjThF0CVnFVoeaDbav7wfjg7JPqUMT5VFtkJ3bY6oKwHDNyBQNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Aw8QaW9ATw3lb7dE1l5dgmhCNtLhW/qtycbvqON0LQ=;
 b=Uic5XXH/aNheVuvnGY+QicFhZLpjYbbicUsjxfgDB5DjOtjxwg+nNK65hEdtQHoidNm8/hMp5NA4TnjrGDjg2TbffL2eeMYjn++b2DDSiZrYNEdwXrcfQ06GivIvfOmgeu6eNf9vlJTMibIi4t4BhefLnKYa6nun/IyNvaw/P7k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Mon, 24 May 2021 13:29:00 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.027; Mon, 24 May
 2021 13:28:59 +0000
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
Date:   Mon, 24 May 2021 08:28:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87pmxg73h7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0201CA0056.namprd02.prod.outlook.com
 (2603:10b6:803:20::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0201CA0056.namprd02.prod.outlook.com (2603:10b6:803:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 13:28:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b26b8074-8dce-4096-3f86-08d91eb7e38d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB386559C9695F8F7C83579DF5EC269@DM6PR12MB3865.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvxeJLiVGj3EmGSJ5DvJ1neZzMfRSe3ZQF8D666zab6JvHPB98EEXe1dilR0KNFckitvIvBVjDwjvKJZ4MUbertKYudr4Y6Qxzs9FaZmPwp3UEQalFLBcK2gPNymR+8iFkX4hADtQm0NQ2H8nl82xdDem3D0vDuKQvR7kOKKXy3H182oO+d5GS2Ck07gtmU1fgBbXf+HiFnOLf4PFo6RlNfyx7lqaRgyjBvsfgiy+Vnu9w+0gUeJAmr0Ub06rSDFOiofoj1fv9fyrku0i7UDiSajS4V95aqo4M25IKIFrTyQbb668LuCSzWy17EfNBv3Kw5X4XGNBwhaGHHaRsdaIAiYC5+GxR0phqrpwS8NOC9tkn+MHI7sPTkCQUijo29JdHFPQK89KTVw/W8D6CDRSHmyTC4YbVUI3KTBob8M1nM9ofEIq18B07V0ZpdoyBHLGH6iMoVrFn2W6CthgXdHn3zYnX+fxTQtKnvhs0ASkgPnvkcWcU229AsiynevWA9BG430j0iIdiqWl5Kq8n0QmoBC7g3sgtIpdRLkkyUozpThuoBb3rf4eOZv0zI+Ce1tSAf2Nz91fFB6Q1IieCgv9MyTWv3yNoP2SP3RfE/RKGR+b7SBettxHoUYvMLQ6URt6VsYTBb2FDw/bS3k6DdKu7/+vmyKtxy/13eY6fcw44Fm0nT3uXi4+BzWygQ4BT/V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(8676002)(31686004)(6506007)(36756003)(66556008)(66476007)(478600001)(6512007)(53546011)(83380400001)(66946007)(26005)(7416002)(5660300002)(31696002)(956004)(2906002)(54906003)(2616005)(4326008)(86362001)(186003)(38100700002)(8936002)(316002)(16526019)(6486002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WjQ2eWhnU0hNTzZFNTV3WVN0ZVZuYUpKSWpCNE1vc3BkZTc2S2RJanN2d0RT?=
 =?utf-8?B?d2F2U3V3UksyWGNDd3BHVlhGSWpWblNwV2o3RUZYY0JCVkVHbFhjYWdzNlp5?=
 =?utf-8?B?OGNOQmJJbjRVZ2NjMG9nUmpXRzZjYm5XYWlKdlcrQkt5cS9NekVta2RpUjBi?=
 =?utf-8?B?WFpHTGg2NklCazNhczVxeTB6bUErbVlCQnZ1TjhGNm56WjlKc05zWnVER2Ns?=
 =?utf-8?B?czZoYVNCTzVQSzlLLzEvejhWdEZEaHNnTGhNNTZhQTk4VzAvWmI5YnZndFE3?=
 =?utf-8?B?UkQ2cVR0UzR0RWxxUXhhbGVpVzFUOUpMeVVPNk9rTEpUeXcwVGc4WW1qWlVi?=
 =?utf-8?B?NlpiZ0NRT2NGaFlYTld1dll1Rks1UjkwV05mbnp0WFphcC9jN0JyV083UGRH?=
 =?utf-8?B?Q2c5MndPL1lGcGxoanl1TjhHc0IrWkpZVlBXNWQvbEwwRGU3R3U2WUZncDhl?=
 =?utf-8?B?SFJhV2E2SGtFeG9oWVVhcHVDc1JJYWJ2dEJHeURsdkN5Tk9jU2NiVGdtR2FH?=
 =?utf-8?B?WnQ1bFRIQ08rNU1zdkh2TWMvcTJqeEhMa1QzZDZsbFJJY0lWZGQyQ0pmbHYz?=
 =?utf-8?B?VXBIa1hCMFdQTm9HYnA2b01CMVdMdDJ6bjVBb3BxdjVkdW8vSGNZeUdMcWlm?=
 =?utf-8?B?L3J0MGR4ZzU4UjlObm9HY3lpTWhMcC9heHJXZzFOd0RYSmV2Z3l5S3dCeXZQ?=
 =?utf-8?B?MXgzUnU2d1gvVjdwTDNzQ2Q1M0ZWR1JDODlGQzJNcWVPVUFnQ0RRdjU4MG1X?=
 =?utf-8?B?blVLY1E4NXcvc0lKWkVOeWJWR1RzUXFicy9CSGd0N2d0T1d5c1dVTHBLM2tn?=
 =?utf-8?B?Q0I0Z1lRQncxR2l2TzVpNU41ZUNSUU1DNkVHZVJ6cmxNc0k3ajd4Z24vZDBw?=
 =?utf-8?B?bWFET3pRdWEyTm9sWXBtVGRwSVB4V0tFYk5mY2lUZjlqQkxEVGhRU3lCaEZt?=
 =?utf-8?B?YlZ3Z2tqNjY5akRscUhaWm1ISzF5TlVzSlJZWnR6a2RsMEhVUGNVeHVsWXNE?=
 =?utf-8?B?SjZyUGNMQkw5dm1uV0MxRDR4ckZ5aW1qV0NxWEpUdlZiZjNUQmhZZ2xBcHJE?=
 =?utf-8?B?N2ZkUjB0YkJEQ3VaVVZSL1RWUHpqRmdoUitKbHUvbkVPRmxiSzh6ZXhLWG5p?=
 =?utf-8?B?VlVCZWJvNEZQVDBVdG85dHBBQzBQMlMwMGRpM2pjRDFyMWo0aU8wQjNuS0c2?=
 =?utf-8?B?NWV5cXY4WGM2V2YvTXpZYmk0REdac2V2VkJNQ1ViZU1wRG1uUHcrcGdFS1Fq?=
 =?utf-8?B?d3lUNGZDWmtIMDBra09XRUxOUHUrVHp2cjkzWlNDWU53NkhsTGhGYitsRkpT?=
 =?utf-8?B?cktoSVd0eGpIYWtBdndUTVVTeCthbVVUczl2NEVrVlN2Nk1MLzJiendCNU56?=
 =?utf-8?B?cjgra0ZvSFgvdWRoTm1KMVRsdWFsRW5vRlV5WSsxeW92cEhpTDlWS3Azbi8y?=
 =?utf-8?B?U0REKzdrTzI4b3RYbXNReDFwNTBTdXByMmJuQi9mYUFkdlRiajdrbnIveUZ6?=
 =?utf-8?B?OGFvcndaM1dQQ3Y3L1RXUTVtK001MDBqSEhYb0d1ejh3c1RXR1h6SURaNnFQ?=
 =?utf-8?B?V2dwd2h6SEdOUHp0d0pxbDVnSzNzRnpCRml4eHJPUGZwL0dGQTZzaEsrVUdF?=
 =?utf-8?B?cm9ndHQrc2NDYlNaVHV1S21mVmxKUXFVTHVSalEyeHgvUXlOUWtSeUJxU3U4?=
 =?utf-8?B?UzNtencwK0hXemUrVnBjWFJyVWIyS0p6UkhrMVd1OGJqRm83enJ1M1dZblBo?=
 =?utf-8?Q?dfXPuvmBPnIZaMee33d8wD89a41qPRuxwjdqGix?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26b8074-8dce-4096-3f86-08d91eb7e38d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 13:28:59.6738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjB8SWwtJvTpHcflehUjjtNQNh55kh1DOj3cWApObbC49sAihK6y0xQOFMjaddS88PSVVm41411eOFJoOrofwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3865
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/21 6:53 AM, Vitaly Kuznetsov wrote:
> Tom Lendacky <thomas.lendacky@amd.com> writes:
> 
>> When processing a hypercall for a guest with protected state, currently
>> SEV-ES guests, the guest CS segment register can't be checked to
>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>> expected that communication between the guest and the hypervisor is
>> performed to shared memory using the GHCB. In order to use the GHCB, the
>> guest must have been in long mode, otherwise writes by the guest to the
>> GHCB would be encrypted and not be able to be comprehended by the
>> hypervisor. Given that, assume that the guest is in 64-bit mode when
>> processing a hypercall from a guest with protected state.
>>
>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>> Reported-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/kvm/x86.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9b6bca616929..e715c69bb882 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>  
>>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>  
>> -	op_64_bit = is_64_bit_mode(vcpu);
>> +	/*
>> +	 * If running with protected guest state, the CS register is not
>> +	 * accessible. The hypercall register values will have had to been
>> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
>> +	 */
>> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>>  	if (!op_64_bit) {
>>  		nr &= 0xFFFFFFFF;
>>  		a0 &= 0xFFFFFFFF;
> 
> While this is might be a very theoretical question, what about other
> is_64_bit_mode() users? Namely, a very similar to the above check exists
> in kvm_hv_hypercall() and kvm_xen_hypercall().

Xen doesn't support SEV, so I think this one is ok until they do. Although
I guess we could be preemptive and hit all those call sites. The other
ones are in arch/x86/kvm/hyperv.c.

Thoughts?

Thanks,
Tom

> 
