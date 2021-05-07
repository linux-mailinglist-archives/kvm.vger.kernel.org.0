Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F6376D33
	for <lists+kvm@lfdr.de>; Sat,  8 May 2021 01:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhEGXQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 19:16:57 -0400
Received: from mail-eopbgr770040.outbound.protection.outlook.com ([40.107.77.40]:34821
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229880AbhEGXQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 19:16:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eir4NxQjqRDiCo1aCtGy+f6Z1Q18agd4JNomtgzmkcVFa3x5X67r6RJuTrnN4VRm8Ic5Ridwx3FXOoDV45KYVHuwjSVL/fKfNG9WGyHY4+SKzyXdydyr0pLyLliBF9ErTHY/8Xt4nGjLgsQ0EurcZ2sG/3T4n69SRsF55A82QF14Nt6eQydh6S1sos/JhFSLDFHZfgnrXL2LJFIgidJezBRzivtwA9zR0TOMUcrh7HjIZ7FvNWwDal/KEv+VelXBBdFcDLMkbTpTY0NbVC4xZOkYiF9MGlcC+V4bC422LuB3EmHIhB7Fk9hSj6qwU67w1ThHStrrC0Y8mdfaVXGW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNmdB3QzOgzY3iql7UXrxJA/DfBgJIaSCT81V7taAaY=;
 b=iS17qh+3Y4rkNn2ZskaVsAxQD0dzPOVSJcQea8n767l7bes4l2NoYP28dN6Clvrt0s6wjHC8brtpcsn1OYoaM0qIZ/Vzc/1nzZDjl7uuEEvmc7+leYIYQBhyGLt2DyAK5a5GRIsSPzk/pgxuQ7l50YCKiL13GT7/8sRKdEffiFZw7Mstwn/WOOgZ/GNRFR0AtHGFUMvGfHnBJsUXnINfAqjp7relANCn5gqbaHLopKb+velH8DEPo7Q+J/26ZvbanMUVb3qKBTrGQFmQ/q1Lj+M+0MhT9nQhrwHq1IVhr0ne9CUMv+HQISeqeZvHky6pwmELstmHOwH5/9BBXnEWrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNmdB3QzOgzY3iql7UXrxJA/DfBgJIaSCT81V7taAaY=;
 b=pzsygmXXrq9FqnmoxFEY8BKedJ7loO2x+K3A0yUhNdoYJdwi9OqxSP7KSDGGDiuw5ChrnoSMAXX/DPzDGlPw8R+VDxvQBDxTt72dYqEpHkVJXbe+Jz5XqGNA1P+meNn+E3+yDk1QNNwsrWkwhGirzsORmHzq8Jm+ZlnJTRgS7q4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3577.namprd12.prod.outlook.com (2603:10b6:5:3a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.29; Fri, 7 May 2021 23:15:50 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4108.026; Fri, 7 May 2021
 23:15:50 +0000
Subject: Re: [PATCH 1/2] KVM: SVM: Update EFER software model on CR0 trap for
 SEV-ES
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f2a78f56-9742-6092-523c-1e81131bb020@amd.com>
Date:   Fri, 7 May 2021 18:15:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210507165947.2502412-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0701CA0032.namprd07.prod.outlook.com
 (2603:10b6:803:2d::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0032.namprd07.prod.outlook.com (2603:10b6:803:2d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 23:15:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aedac384-4a47-41f5-e9ce-08d911ae0da6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3577:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3577C42C4F812948EE12417BEC579@DM6PR12MB3577.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z5B8JLpy5OctjQgCI7Ti8wqlBTrmJ45DAhgDttwWjFsSGflutW68fRjbRsxoFXYCcKGXd5+RFNxZ6+RlOIhmcXpOcZ8Z1Ts9LMrnuUYOdqkurtIL/m2iqgOi0Y1CXS10OWFMWdrstk8kyCSJ8f96W26/XrHFcjUK9Xl3RU8gJ/r6DXNPxdQlKj1yyecUy2DqdAFg/zV0jrnYmsgcT/jwT/fVf2UM7/i4N9EdRJLdBxtpAbAlY0tVpY4R1Uio00uKOqpycy3XUg9PydBdq0jlm/yW9/Oh10OXR+DSVprkmAA9Q0P/LkmF1MiKtrTNSSTfs9bWdDbzLR1M7WwIz9b24Fc8IAVROOISkTSufO/J1sguWDn0Z13fLyfg95NryBr/Lz7zlH61ryZAkTznydhPoLpYjGwkx2gBC6hFcVnOsVJFfx6M3tZV679PFzrZucTjw/11yqMpYCT2exuVdLO2xdcmtqRk79cESbKH7c6vGg0aIBuWNXTjH4X9viJmXOio4Vh0TkL1HQRaD9PdnOUzMT5ScHY4/go4ut9hrZxvEgc/Fo0Qy9bs2VoS5L1C7p2pqHquViewdiOuyR/ZYpVMwAFplDx9TJdDlpATOTgmtY/K5z8oShBuPK/WaiH6WEKBkhJ3P/BLH8KwV/r2e1ZOlT4DpOyEGb8bi7f4ZSZ8QQZnPS8xmc285rPDFlZBfm7Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(83380400001)(6506007)(53546011)(2906002)(7416002)(38100700002)(4326008)(5660300002)(110136005)(54906003)(186003)(15650500001)(956004)(2616005)(36756003)(16526019)(31686004)(31696002)(6486002)(6512007)(86362001)(26005)(66476007)(66946007)(66556008)(8936002)(316002)(478600001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVNrT1ZVVkExYmQ5WnQ3M3o1NUNGOFhubnBqNFFTUG0zbjVCWFQ2cERGL3Zy?=
 =?utf-8?B?R1JUd1A2MCtwK0FwTUdGVE4xcjZCcTVwekx2SStIRHdzNHFHcERiZlRueTFm?=
 =?utf-8?B?TlRjeVJzTktrSk5RWTc1eEpDanpiMWJGM0hBSFV3UGMyRzFXN2Q4UTMwLyt0?=
 =?utf-8?B?aXVuVVNGVkxUUXhUd0xXUUF3b2w1WXZyWTNvSmc1Z1AzZGpZcm5UdmhCOXV0?=
 =?utf-8?B?Q2hrdnQvbTYyU3JsaFcxV3BRSVNSTXhlclFhaDlSMzlJSEpvVkVOZDNwcFRi?=
 =?utf-8?B?QVlWT2pkQTFNeW41YlJCRG9DUm9naklWdDRKaDNLOUQ1dFJydDdRRWhkam5l?=
 =?utf-8?B?dFladzZEeGlPczBSa1VXRFNOQlVsbVdOS1c3U1NaQkRCemlPNmlWaXdhNHBh?=
 =?utf-8?B?d2Q0OVY5RVlVOXZ3WWgzNGFKdmR0Yys5U3ViZXBPUWpsaW9nejhQOWFSdVJz?=
 =?utf-8?B?SlpINE9FZ3NUVzAzZEdlM3ZPUEVYUVV5YUphR0ZhTEpQMFhibHdZL1FZMTVo?=
 =?utf-8?B?eWlXdmRRZVlwN0lmcnFTTEZhWElNYVp3K09YalBHSFQzN1BXSi9tbmxXRTY5?=
 =?utf-8?B?Q3lKK3E4Z1lDMmJaaFFLNVFKS3lNY2V4ZlVaQlNQUEFqVFZPc2g4aDFXUitR?=
 =?utf-8?B?MzRFWnBZRjAxeXEvUGJpd0ZjUHhFYUZhblkzUml0NVBNSnNLRE55Y2NGK3FO?=
 =?utf-8?B?ak8vSktkaXJBTS9PUDNOeENsMzVtNTdPTTZrSTExRUFJTkVsWmhDY2JvcVZp?=
 =?utf-8?B?VkxPK2FidUQ3QnZXMzlqblV3cmxEcVY4UnZVQi9CVWlwaGxibUVrQWl6SjZR?=
 =?utf-8?B?dXVRWlc5cENxYlFxSmRuY3FFWXVTUjJBNmtSQ1Y5cnRsai90NmRBbWtPKy9l?=
 =?utf-8?B?eFJ4d2VZaW0yMnJFNXdVbmRIaTlZOEcrdU5VTW8zYlZ3UWgweWlkaEZvNXMr?=
 =?utf-8?B?OFBDbE1SMnBkWWxBejZMY1EzNHU1bHB2bERqZTNKM29remdvR2c0WFk0cGdu?=
 =?utf-8?B?K2QzYmNPbzNLcWxmZFBLajc1OUxMSFMweEFYL093QzlVUUNSKzd5VzRpY2dX?=
 =?utf-8?B?OXEwL2p0c01ZSkZJU1F0OWFZR2VIdmVzczhkdTFpTGUyUE9FcEl3cWp6RjB6?=
 =?utf-8?B?SU14bEZ3TDZmeEhpUEZ2SUZGb05vU1hhV1hjbHZPYXIzN20zSGJUWTQvalcv?=
 =?utf-8?B?NnQrVVpBQW1KRVcvOURMQTZUNlArYzN4OEZzL2tlSnVTNWZjbWMrV2srVjRX?=
 =?utf-8?B?eGVUeEVaN0QxbnppVklTTmV0MEZIdmtuakxla0tUanorTjk3OUFwZ1JHMGwy?=
 =?utf-8?B?K0JyUW13cDNsbFBqWGJGWmx1RTFMY3dKQ1F6UVRpYjJINUlsQzc1ckFxQklw?=
 =?utf-8?B?TUlDMDNKVU02emZxTEZSa2hjNW14YUFETi9yOGQxREdUV3J6WFNNb2F4ajNU?=
 =?utf-8?B?aUkwTXoxaUFxY05CR3ZUVVE4TnJINGZVbDd4andCM3dteFBiZlRGejRkVmFy?=
 =?utf-8?B?VmYrcGNzQ29UekJaalZ2aXU1Z1htNmRhMm12QUJRQ2JZb3RlQTJ4YTJTdnF2?=
 =?utf-8?B?WGlUVXE3MTRiSWNyYmo2dnFzbGRVajd1QlhhdXc5K3lsdU01SEJHUUhDQkVM?=
 =?utf-8?B?WUZkem1DNXNCVTRhZFNDUkhPWVRuaUQ0VjduMTdabGp4elJ4Nkl5RWJsaU9F?=
 =?utf-8?B?aEFSY3VsWk16dEFxUFFXTEVFaXliaG85aVdYUzJHTm4zNjd2UnljblN4TjRP?=
 =?utf-8?Q?qiAkCcnEKq8/fYEn8c4N35V+e0u6CgdlXBpA1Q7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aedac384-4a47-41f5-e9ce-08d911ae0da6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 23:15:50.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23mLgVOMv8NZIprW4QV7Vh9fb5lloCQHGANRXQcdLIOL9diLpyDGL11WlLJhyXqraMnflCpjBc5Z+XxI4LnpXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3577
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/7/21 11:59 AM, Sean Christopherson wrote:
> For protected guests, a.k.a. SEV-ES guests, update KVM's model of EFER
> when processing the side effect of the CPU entering long mode when paging
> is enabled.  The whole point of intercepting CR0/CR4/EFER is to keep
> KVM's software model up-to-date.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Reported-by: Peter Gonda <pgonda@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a7271f31df47..d271fe8e58de 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1696,15 +1696,17 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	u64 hcr0 = cr0;
>  
>  #ifdef CONFIG_X86_64
> -	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
> +	if (vcpu->arch.efer & EFER_LME) {
>  		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
>  			vcpu->arch.efer |= EFER_LMA;
> -			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
> +			if (!vcpu->arch.guest_state_protected)
> +				svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
>  		}
>  
>  		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
>  			vcpu->arch.efer &= ~EFER_LMA;
> -			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
> +			if (!vcpu->arch.guest_state_protected)
> +				svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
>  		}
>  	}
>  #endif
> 
