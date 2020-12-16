Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23542DC4CB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgLPQ41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:56:27 -0500
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:62541
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgLPQ40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 11:56:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm3oZpTgksynSZKE5pG6c22rmus8q3HszNMpratZnfz7YpbwCRm46qfMexRja1wi9z9JH3tPizXQ8apouVjtMVtPnmQz350ERU4bIKHka7dywqa+zTf16RChfjmYDioMYgNWXBp9M9nkGzhW//bLG79jhlzMbeZHJYu/DL+D/nOg6Vi65xh2c6srNUh21mEDEy/2AL7sCdrNwPeWe36LJAboHIvhqyaFi1HvPxP0emcVORZLY1YOmhiONrb97ve6sUosq0U1GENC4kH10W3+fGV/hc17b9gCrBauDRbcsxKQZ62P93sonaS617OurXwwuoHg8t53P9vrsd0LXXwEVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWPw9tfaA3XzCMEfEx1eDZoAm9Otq86GT3llwFfb85k=;
 b=cQAyTHKc0ovGQPBds50RQRWi4yTHX1KBxMsbFLc6MpzqAfoho7T/LkVsVll08q/9s33ll2kpoK7EMM9DtDWN+7SSYATbBEErqAISVgHM9Ws1CAw8/8rh6PRPjV+o/65iD2295KEQzlb2FUCimDx/F4QQy+kdn7YL84UDE2UNWwAgt/p66aNrJ1EbrB8rvQOHT4Hn3XgjpOsEx/go6JXmIJ7xEYmMhw49Bh2RZ/ByaNf3iVjtn+jnu14mqb4hTsVmfmlXYt85ax7tnIaqa8jN6XY9/9UDHM/tq23Ux13z3kW6j1GqUCFvkqxWGmkbhl6B9mLEg/PxFcE1tM5YHWMI5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWPw9tfaA3XzCMEfEx1eDZoAm9Otq86GT3llwFfb85k=;
 b=brQfdOsjd5DzfdfQuSfM/YdfqBIUVdNMcKVAZLMygvavn77Kpf2xdzkWOkkAAqTFLMwwONXhWN99+5zQROzQg+Vl1HuZ4ls0A1ZbvYmCHEyM7SCVIEYS+CXAkaiz7HZxgzIQGocNB2WLCR1icLc4grhRzlHMEHOKjNeBUgJ20II=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Wed, 16 Dec 2020 16:55:33 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 16:55:33 +0000
Subject: Re: [PATCH v5 34/34] KVM: SVM: Provide support to launch and run an
 SEV-ES guest
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <e9643245adb809caf3a87c09997926d2f3d6ff41.1607620209.git.thomas.lendacky@amd.com>
Message-ID: <d75a9f3e-0f8e-6a2d-b9c3-c4d12933553e@amd.com>
Date:   Wed, 16 Dec 2020 10:55:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e9643245adb809caf3a87c09997926d2f3d6ff41.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:610:4c::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR10CA0006.namprd10.prod.outlook.com (2603:10b6:610:4c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 16:55:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d05d923-171f-4437-2c18-08d8a1e3675a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4862234380D600918FA4E8B5ECC50@DM6PR12MB4862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOv02Kd1Ibo87iEXNwCww1G9xWeSoipIZwhSRbgbRthBrxyxlo0ldAsJt+FEhdxW77HuGtyymDxZXs3L0vxvmNN5dsSFksszrF1Q4b30IkBpg6LRmPf6vJUBvPJ8iVcJbmr9DzFe5yf9eMGmJWFFDClPyBMGHTs+SC/mcryQUo7AWKgxOUgirOKiZQYPXjVhoTu1NJlVhSmsobAIOaQL5IvF0lpKgO+c0S91p7GdUAjq/ETFdl7kSyedJg0xkmEmLMFSLnhk+CnXqJZW8Klc/xKrxzCnNsSujvoLxe/Ov28FHVhOtVEHzuG8+fUY0bVvF7TtYcqqMYOSjEtGfIb6fRRanslbaEdbdO2PeM7C9CrjmtVQgxKwqHi90rnV/HDAjRVcyHyq+Rn5ak032WiiYjp9vDqO02giV0Qx4xQysQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(8936002)(6916009)(956004)(16526019)(7416002)(52116002)(53546011)(2906002)(478600001)(31696002)(16576012)(31686004)(66476007)(5660300002)(36756003)(86362001)(186003)(26005)(83380400001)(8676002)(66946007)(4326008)(2616005)(316002)(66556008)(6486002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U1NNTG04OHFocXcxUUdZdUdzdS9JZzFEQ2s2NytDb3hhcGFheUJsUDFVV1ZF?=
 =?utf-8?B?U0hqV2RPWGtBUDJTU0ZtUTVyQ1JKbWNwZUpVdW4zdXQ2ejNSRzdrNmRmRmx3?=
 =?utf-8?B?d0xGVjQzaGJOWWZnRkFibVc1SUxabFJrKzBOa1hWODdadG1wZ2pBQkJKbFhH?=
 =?utf-8?B?Y0Q4a1FjL1hLcUpkU1RhWGNiTUw5bFlITmVrcFN2WGd4M1hOd0NqSGNtaXNB?=
 =?utf-8?B?bVRSNlZXTmxzSTFvM21NVE8xeGV5d293UUppRGxIa3ZmeFNCUUprejVJVXpJ?=
 =?utf-8?B?RlNkZllxSU03amVTVkJSTHZwYkNYdTd5VVluOVRzdGJYalloOVhNZmMyQzAw?=
 =?utf-8?B?WVA3L3ZPakpoWG4yelhjYUdFMHhOSEJpS1ZWWFRpNys5b1RiRXZPTnBSQkgz?=
 =?utf-8?B?bnlRTHo5eGczeE9EeXZsVkZSWDB3M0Z4Y1hoY1FuNGZiUm1EUEJGZVNQak5u?=
 =?utf-8?B?Zk14dHQraDhmTUZvMHBZb0I5ckc3TnhqUkJXeHB5ZFl0RXYrcGpjbmhVUFRz?=
 =?utf-8?B?d3dBbmxyZzZ4Y01IbEx2aE5JbmpxTEZ4Y1lpL3Q1YmRwYmg3bitwRWtNN3JF?=
 =?utf-8?B?UDhVRDdoOExSYTRodHUzS0x6UUJ6QXZOQ1p2aGUxbmpZdVQrQzdYNEF2bldU?=
 =?utf-8?B?dkc3SlBPWWQ2RU51cm96c3VreDZzaGU0YXFGWjk1Z2dJU0FBV1VFRzNjVEVl?=
 =?utf-8?B?S1UrazRic3A3TFp4eU8yZkl5UTJpYVA5TDZUdWo0ZTQ3aE9xTHB4VyszNHkx?=
 =?utf-8?B?N1NkNEhhTmV6cU1SQXhOOE0xZjNDYXBBMmRTNVNlK3pSRTFMSW1lL0ZFZnM3?=
 =?utf-8?B?VEk0ZllBNEN5azdYYlNZS0F2Q1dFOHRSU1Z4RmtJcVVzZGVDK0tpM081NVFy?=
 =?utf-8?B?cG43QTJmQ2FJYjVXS3JNRzdiRWV4REJqOWJ6NEVVdllKaGV3OFBDQU1zQVhH?=
 =?utf-8?B?ekZTTUdyVE9oeVNIc2c2dlM1WEZkcFpyT2xCKzN1bWpBcnNjUjdJVjE2eE1j?=
 =?utf-8?B?aW9pcmRSbzlpK3R5SVg5bHdRVWk5OGFNNXljUGpuTjlqcVdXazkrMVREWXZy?=
 =?utf-8?B?UGNxRWZZYSthWVVPTEdTY1gxQ0NIdVVCNnJOMmkxWkFvUU8zcjk3YzhFVzNB?=
 =?utf-8?B?TjFHcmEyOU5aM0lFdVZOYXUyYzRrOWZHMHVzbHgvWUt5dm5LZTc0TmpHazVY?=
 =?utf-8?B?dnJHMld2ZXlSa2FmSEtqS2kyY2JzZnhxTlJVQ2YxR3M4UzBUKzdEemVDK1p4?=
 =?utf-8?B?TUhQbkRXWmZUcGlKVmt6Ui9pbitQdVNXUVNJSUthQzgxYnk0QnlEQ0VQS2pi?=
 =?utf-8?Q?xcJQgI2SBGcgGoUr/SKujHmrlCW4G8lEC7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 16:55:33.5766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d05d923-171f-4437-2c18-08d8a1e3675a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxP2VU1bpfZ0/sN0ZUPauFza0sewYcKgWED+BVY+hfq1MU0vFiB0z8i+jZEwpYgxOnfr8fG5lKEYYW96b2WJrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 11:10 AM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> An SEV-ES guest is started by invoking a new SEV initialization ioctl,
> KVM_SEV_ES_INIT. This identifies the guest as an SEV-ES guest, which is
> used to drive the appropriate ASID allocation, VMSA encryption, etc.
>
> Before being able to run an SEV-ES vCPU, the vCPU VMSA must be encrypted
> and measured. This is done using the LAUNCH_UPDATE_VMSA command after all
> calls to LAUNCH_UPDATE_DATA have been performed, but before LAUNCH_MEASURE
> has been performed. In order to establish the encrypted VMSA, the current
> (traditional) VMSA and the GPRs are synced to the page that will hold the
> encrypted VMSA and then LAUNCH_UPDATE_VMSA is invoked. The vCPU is then
> marked as having protected guest state.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> +
> +	/* Sync registgers */
> +	save->rax = svm->vcpu.arch.regs[VCPU_REGS_RAX];
> +	save->rbx = svm->vcpu.arch.regs[VCPU_REGS_RBX];
> +	save->rcx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
> +	save->rdx = svm->vcpu.arch.regs[VCPU_REGS_RDX];
> +	save->rsp = svm->vcpu.arch.regs[VCPU_REGS_RSP];
> +	save->rbp = svm->vcpu.arch.regs[VCPU_REGS_RBP];
> +	save->rsi = svm->vcpu.arch.regs[VCPU_REGS_RSI];
> +	save->rdi = svm->vcpu.arch.regs[VCPU_REGS_RDI];
> +	save->r8  = svm->vcpu.arch.regs[VCPU_REGS_R8];
> +	save->r9  = svm->vcpu.arch.regs[VCPU_REGS_R9];
> +	save->r10 = svm->vcpu.arch.regs[VCPU_REGS_R10];
> +	save->r11 = svm->vcpu.arch.regs[VCPU_REGS_R11];
> +	save->r12 = svm->vcpu.arch.regs[VCPU_REGS_R12];
> +	save->r13 = svm->vcpu.arch.regs[VCPU_REGS_R13];
> +	save->r14 = svm->vcpu.arch.regs[VCPU_REGS_R14];
> +	save->r15 = svm->vcpu.arch.regs[VCPU_REGS_R15];
> +	save->rip = svm->vcpu.arch.regs[VCPU_REGS_RIP];
> +

Paolo, I just noticed that a 32-bit build will fail because of R8-R15
references, sorry about that (I'm kind of surprised krobot hasn't
complained). This should take care of it:

---
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4045de7f8f8b..84b3ee15f4ec 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -529,6 +529,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->rbp = svm->vcpu.arch.regs[VCPU_REGS_RBP];
 	save->rsi = svm->vcpu.arch.regs[VCPU_REGS_RSI];
 	save->rdi = svm->vcpu.arch.regs[VCPU_REGS_RDI];
+#ifdef X86_64
 	save->r8  = svm->vcpu.arch.regs[VCPU_REGS_R8];
 	save->r9  = svm->vcpu.arch.regs[VCPU_REGS_R9];
 	save->r10 = svm->vcpu.arch.regs[VCPU_REGS_R10];
@@ -537,6 +538,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->r13 = svm->vcpu.arch.regs[VCPU_REGS_R13];
 	save->r14 = svm->vcpu.arch.regs[VCPU_REGS_R14];
 	save->r15 = svm->vcpu.arch.regs[VCPU_REGS_R15];
+#endif
 	save->rip = svm->vcpu.arch.regs[VCPU_REGS_RIP];

 	/* Sync some non-GPR registers before encrypting */
