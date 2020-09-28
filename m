Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F827A720
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 07:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgI1FxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 01:53:22 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:19904
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbgI1FxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 01:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw+NvJZk14goZUfsIMEz43u7U7fty5lm0Yblu18rCy0Zi1FvJI9TWhzF6yzMnEIsSxm76xpwdFrbTq3cs7rrgV/q+7CnmJyUXtDGMYba59Ac0XpSJ5ipf56mEX3xdIfiU1qhu4kF3uc6LyUt6MpKqtDKO5ofsVuXbBxCr36dDtqQi49dMJfX7xUYNYLlICCqnxknLfH/Ubm4bDufdi4pH4w3peaxS9CMLM/PFNSKw9IB8WXRv44TI6eGP1jcHz0KqgI1/xZzT7jgG/KvcBZy+iaHL9xiwE+S6GeHSCg5JeP9AQWdprJLQ6bjBWYvm/LMICMe8Ft11c/Had8AK6x7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSayHfNfSsZPVIAOJP4CKcUyH4bI5vn7jU/B6gznoUc=;
 b=JUg8UFPtx2XvJEnXDl7kKE+kIoJrzUnKLURUQOzINdSFLaa9Fc/loJI9VycXkGbgCXSCEzeR+l2Yo62QY6gabcy0Mf21tPCcMqHtoCD1DGeCF+pQ/W6arbLjacjyJNaLT2bE6EueLSR5ehM5jvIc2NKY8oXo9VCbbSdCKJVAF4Qct8ZsmvG1s3++RAos7SjbWkH1zOSK7gYfpCS9hyv/aX0W/59dye+M5hI1NQqKQDOYm4ct9fRmJXjhuPnHangEWQmGuwziDiuwnSvzHp7qXW28iaGvCKiZISLU4CZe5ti4PEzBjrfuMSvNComaM4pSW8tmwZt9fN8UDTne5TnDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSayHfNfSsZPVIAOJP4CKcUyH4bI5vn7jU/B6gznoUc=;
 b=HQwc3KcQAzwl0PbDyhHDjgNYI1HtTupzxMtBEOpovZZ0MtPkSGhPjSoMpDyAqFueEurUxbLckmywa1BxMVEgm58QHz11gDAQsfUgzfsAbBLOXmi4tqC2bV15+hFSHjvQcGuFYOHLkEtTwz/3UJTWvlko6N31o13r7OSxAWtoHOg=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB3466.namprd12.prod.outlook.com (2603:10b6:5:3b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.25; Mon, 28 Sep 2020 05:53:17 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 05:53:17 +0000
Subject: Re: [PATCH] KVM: SVM: Initialize ir_list and ir_list_lock regardless
 of AVIC enablement
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org
References: <20200922084446.7218-1-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <1b8ff096-85a4-3dda-61d3-9a44ca6bb360@amd.com>
Date:   Mon, 28 Sep 2020 12:53:07 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200922084446.7218-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2405:9800:b530:f552:3d55:5d18:e1fe:a9fe]
X-ClientProxiedBy: SG2PR06CA0139.apcprd06.prod.outlook.com
 (2603:1096:1:1f::17) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2405:9800:b530:f552:3d55:5d18:e1fe:a9fe) by SG2PR06CA0139.apcprd06.prod.outlook.com (2603:1096:1:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 05:53:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 804563cc-f73d-490f-15f7-08d86372cbb5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3466:
X-Microsoft-Antispam-PRVS: <DM6PR12MB346627B98BB0376F9CB795C3F3350@DM6PR12MB3466.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7s3/QPi1iSevZnGzUQprOCwbvb8iOzI3YUzeJxWVceq8RHFPaRGjUEqz+BlsnNTaj38yBupl9eIaiw708HsSjfpaibCtN8SXE+DDkqwoCji7l+VkMbppuj/0DamIbtJy310oPbPSFhAGfDgDLpcroe02wBFPkPlnfzDPME6MCJO99xqoNxMS7pGsG3ppchxv/1ltR2kkiV4jObOGfoRP5z6Pul6rJxAmJdN6CyoV8q9zxBVz/7Y5Ta61fLvPYH8/ukXUSnEfQVeDe0aX428AM8ts/lnZGlV5XfHh6dL7VbYTnssvST5pY4irTjNRaVeQpFaf8Gk52SDJX/RTbnwQErkWxCm0HSkv3HLi+mYR/wAmMMpm56FFbO8QRyoOBCn5ue061nT1fMOSu0RLZAjvR2/38JqTWBUxs0qvB58NP+gQP1tWVRAZrYv42PuOVzA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(2616005)(4326008)(31686004)(83380400001)(8676002)(6486002)(53546011)(6506007)(16526019)(186003)(6512007)(52116002)(36756003)(44832011)(478600001)(8936002)(6666004)(316002)(66476007)(66556008)(86362001)(5660300002)(31696002)(2906002)(66946007)(26953001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tfvaoVRTsRnJPNM5IsQxO+wTHjLnTl8vnz8724/T2IeXCp7UNl0o9//x08UubzN7DHpvniD7hh3BWszn99X2kHHsnVBN/cvTbik9OXCkYMgtayya/8dARl2TH0cvgrg8uheDbLM/Yv72K1cDrtxR7dwzbVHpunrvro0ZhdUzTKcV3FAJmo975e+uhp3q5jhseaR917OATlmDbf/RS9wuAXpZ2SatELb26VXFeqtJUIAbUPDvsjWGAvlod7/SdthwL8Zf5h3vsXVLXsZv0nYEC40pzPBt6XPznxBPCb+e1yLergbIrb6AaQUJUx9JFzdHt7cpYMJ2MwxuyM+yTiFWg7uYcSR8vxc7pWHGZzlWRo4O5o9xbIHHzBQ4/R8paZ7qz6cQZgaPQLMUbG93o8ngMgjLZRs4pa5uwqPeB2nl4xbDG5QpbMsjBHwB6Db52uZ22VNUnlEEOxPSNrX1XtddmLLkiu7QIjFHg+z7opZeaXW8kTzN4iYOw+Lm6CD/IPOEG6qfd50GnYEl6BZBPGYcVnSD6JJp7rkSRekWyrcZPcI1A3WVYYnMMGTORL2PV5FkVMlJ8sswAfbYeTbhrQPhSWkCRKx+TnK0BjeeYg8HUC2ROK6AG2t1sd3c69yXJnIf7bBvTYGyW4wmN+dSW53dogcn6bcycBUzLM8eGqzs8i9hUrodq/X+ecOQ27MzbiHl53Vb5W40StNuc2m021GjCA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804563cc-f73d-490f-15f7-08d86372cbb5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 05:53:17.2097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zxnia+/EFTtEYPbaNJRPczYK/xM8phov7Quy5bT6WgqJxJ1stSJXLneYWf6A1j7cF1zGKWbvlWG0WkjaRdLAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3466
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Are there any issues or concerns about this patch?

Thank you,
Suravee

On 9/22/20 3:44 PM, Suravee Suthikulpanit wrote:
> The struct vcpu_svm.ir_list and ir_list_lock are being accessed even when
> AVIC is not enabled, while current code only initialize the list and
> the lock only when AVIC is enabled. This ended up trigger NULL pointer
> dereference bug in the function vm_ir_list_del with the following
> call trace:
> 
>      svm_update_pi_irte+0x3c2/0x550 [kvm_amd]
>      ? proc_create_single_data+0x41/0x50
>      kvm_arch_irq_bypass_add_producer+0x40/0x60 [kvm]
>      __connect+0x5f/0xb0 [irqbypass]
>      irq_bypass_register_producer+0xf8/0x120 [irqbypass]
>      vfio_msi_set_vector_signal+0x1de/0x2d0 [vfio_pci]
>      vfio_msi_set_block+0x77/0xe0 [vfio_pci]
>      vfio_pci_set_msi_trigger+0x25c/0x2f0 [vfio_pci]
>      vfio_pci_set_irqs_ioctl+0x88/0xb0 [vfio_pci]
>      vfio_pci_ioctl+0x2ea/0xed0 [vfio_pci]
>      ? alloc_file_pseudo+0xa5/0x100
>      vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>      ? vfio_device_fops_unl_ioctl+0x26/0x30 [vfio]
>      __x64_sys_ioctl+0x96/0xd0
>      do_syscall_64+0x37/0x80
>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Therefore, move the initialziation code before checking for AVIC enabled
> so that it is always excuted.
> 
> Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm/avic.c | 2 --
>   arch/x86/kvm/svm/svm.c  | 3 +++
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ac830cd50830..1ccf13783785 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -572,8 +572,6 @@ int avic_init_vcpu(struct vcpu_svm *svm)
>   	if (ret)
>   		return ret;
>   
> -	INIT_LIST_HEAD(&svm->ir_list);
> -	spin_lock_init(&svm->ir_list_lock);
>   	svm->dfr_reg = APIC_DFR_FLAT;
>   
>   	return ret;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c44f3e9140d5..714d791fe5a5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1225,6 +1225,9 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>   	svm_init_osvw(vcpu);
>   	vcpu->arch.microcode_version = 0x01000065;
>   
> +	INIT_LIST_HEAD(&svm->ir_list);
> +	spin_lock_init(&svm->ir_list_lock);
> +
>   	return 0;
>   
>   free_page4:
> 
