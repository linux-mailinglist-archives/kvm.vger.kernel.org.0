Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D607288790
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387961AbgJILGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 07:06:55 -0400
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:19873
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732362AbgJILGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 07:06:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvsPHCPrGbYvZ17PWeYhl3SVWCAwg5P+8salHTZyD8Z2A/1GnkRP3u0N4itDB2JCY9OLlFhvo4Ow1UBLqZCKCCSOcLCRAQZANiFhyyf3mah3ntp/aXVWFpoSXfCfnaXbxGANJJqZCwryS6r59bOTG9y5Bj1OLljnAum+8Gs6BhI7zwr9pANJ6PNqAmLz7ZdvFQWJ66sYmr9aIZqLIMIQnYb5Dq+aVe5yXsceE0ELL3vbWIEaXR4RyeZubNmRepVBbRmG3yiki812gJPkPtYPy/3/7mDrnikvugh90efxub2W3XIxxc00Pt0sCVnzYLsD3+nmffjrpiFt/Ye+8PTI6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WH1j2713CkM/uK3A96Yvlevmt5xW4p67QSMmBuK/MU=;
 b=Bx1PWZkIiJohnKLE5QDmJV3OleJzciRDG6Dj1QhH1SAR+/PMLoqO+Yl6GBQqWf9F4r8iE13vLCoGKGJ3RqQ5WtefbgKXbxIdd7Wg9xXC01Zd47vk5wqFzHrMJPnbGYxJp3yE4kMVXiqdbg4WMzxB4L3HqzlJdtofZ4lCDEoy4e8N5plY8dWtl50BQbTPnCPieIUH7tuY39PPnfLzZveW5YUCmuobLzC1TIrw8g4rcNdngWplwswoM00cBlwF44/ktk7eFu1LaEWAI1ybu+rZorY3p8fNt5YYnOnjxyflQDxsauvPrSWpkkXAuZD53mJQ+/Dea2cwvqWnh7gZX+X7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WH1j2713CkM/uK3A96Yvlevmt5xW4p67QSMmBuK/MU=;
 b=QLsE4pZwftxEpgEJAJHTEIeQUoWUszfZxrCJs+z6KBGB5VvMjYZnSaOJFml+NAF0J2sunC36Q+lmQ/HFWmF6mflWzdGnW5tpQA/TPdbrmpDaWj9KHzOGMdfHbHxBpbXfgGPJxMnOJiOeCTI/XNiFFaIlXFV66AQQzeKa0lCPvBM=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1157.namprd12.prod.outlook.com (2603:10b6:903:3b::9)
 by CY4PR12MB1512.namprd12.prod.outlook.com (2603:10b6:910:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 11:06:53 +0000
Received: from CY4PR12MB1157.namprd12.prod.outlook.com
 ([fe80::892c:1651:c5a8:4c43]) by CY4PR12MB1157.namprd12.prod.outlook.com
 ([fe80::892c:1651:c5a8:4c43%12]) with mapi id 15.20.3455.023; Fri, 9 Oct 2020
 11:06:53 +0000
Subject: Re: [PATCH] KVM: SVM: Initialize prev_ga_tag before use
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org
References: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <50da7a89-a727-18b8-79be-fde665bc9419@amd.com>
Date:   Fri, 9 Oct 2020 18:06:43 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201003232707.4662-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.80.7]
X-ClientProxiedBy: KL1PR0401CA0027.apcprd04.prod.outlook.com
 (2603:1096:820:e::14) To CY4PR12MB1157.namprd12.prod.outlook.com
 (2603:10b6:903:3b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (165.204.80.7) by KL1PR0401CA0027.apcprd04.prod.outlook.com (2603:1096:820:e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Fri, 9 Oct 2020 11:06:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b6d9b6e-d5c0-4a3c-ee3b-08d86c436d6a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1512:
X-Microsoft-Antispam-PRVS: <CY4PR12MB15128E2AFFE3001BA809A992F3080@CY4PR12MB1512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzTzJiRp6aUnYlKSAlT51BM5GCGWELijh+vSiFQLo594ZegrqK8zHc36GxihUHcTJrwExdeEGw+LwsxJe5otEDaZLQtaYTUmezCjBVqnV/THOS/uB3xuawKs9zh3ecq/f4NLlp1mHBMo+S5oNG5lWofynrIcO9meBH2QkOMCzOMv4qrjCqLBcI+J6Dm4+JhZhJoqnhE2ixXe0JWj5ivx1WAWRm7Eh01cosG/vHfvXz+7kftnwRp77iEL7za2/lKYxNuk3EJBdZ3xrIzF8CAaGfcOiOP0KcEBiA/p8jdf7Xi88vgazEunuoE8bNh8F8XCSQnhZnxE1ayk1cwMadCr8RqGJmpPGe2Pla6/E8OcTq3suZ3YZnYXOmguHtM7GNk+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(6666004)(26005)(66946007)(8676002)(66476007)(44832011)(66556008)(52116002)(31686004)(8936002)(6486002)(6512007)(86362001)(53546011)(4326008)(6506007)(16526019)(478600001)(956004)(2906002)(186003)(36756003)(5660300002)(31696002)(2616005)(83380400001)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wB/jbVvFRx6E5HoWIwpgXT8102NDRwMHmDsr3VzcUza5/ULcfeUIhFZLbWapx5VOvhxSgyD0D3wup/RNgh8YGyWCpYVMC5dz2btXYvEG9Xqp9UxjgO6D5UhI8/u+Nja4TDVcCrkcUhfUdwBN2g+E/5Okwdwmm1NVhLkyiKMLCYyfAQLuabfV19O4K/U74XkbrXmOGspai6VCHwskiK0MBqlZJ3gSMyweIgxZsjF0jOXmZsUjfSERFSAdKukIsqwXEOIVbOkLAh4m38bxc6AYLSw9KdzupugQERouD2H1pufKpvfkHF/EV2QqmCwckSTfhWUhafxwee6wABIa3ceSG3rQsEIgMBE1C4S4JZNg3l+8GaEAfIfJvfWMDXWk9E3nhsUb6KUZoHjgwvz4d2cNhjLL5eMNEBkmN//d0+i1CSoyV523ZhKRSPlCQFR7wdeYKFe82T3Q1/nCbWM8hO/Z9WH9TcZ/7RjlosQ7Jk9TK8rHHNgK9tWw4gF9+CALIVfVwH09B4nkHpgJWUbZxE+M06BsTUWiHHEu+yHRYiYLNhVep/3eji6tHEyq52N9ifo5G62zdddUIKFp4mTS83sRUqAhjtlVHuLWdkP1xhx2Rhr/nmCrjac0T3Ve5Au0iY1AYWtk6LVOSWLeHze4Pn18tw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6d9b6e-d5c0-4a3c-ee3b-08d86c436d6a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 11:06:52.9797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8Zxo8ODj8M9ncY8RBa21YBkltmGe6KuSLaBb39YXuQgLPOYlOB0yg2FqU45iSL8GwoJzCpZL5cCDWsAfOLS+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Are there any issues or concerns about this patch?

Thank you,
Suravee

On 10/4/20 6:27 AM, Suravee Suthikulpanit wrote:
> The function amd_ir_set_vcpu_affinity makes use of the parameter struct
> amd_iommu_pi_data.prev_ga_tag to determine if it should delete struct
> amd_iommu_pi_data from a list when not running in AVIC mode.
> 
> However, prev_ga_tag is initialized only when AVIC is enabled. The non-zero
> uninitialized value can cause unintended code path, which ends up making
> use of the struct vcpu_svm.ir_list and ir_list_lock without being
> initialized (since they are intended only for the AVIC case).
> 
> This triggers NULL pointer dereference bug in the function vm_ir_list_del
> with the following call trace:
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
> Therefore, initialize prev_ga_tag to zero before use. This should be safe
> because ga_tag value 0 is invalid (see function avic_vm_init).
> 
> Fixes: dfa20099e26e ("KVM: SVM: Refactor AVIC vcpu initialization into avic_init_vcpu()")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/kvm/svm/avic.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index ac830cd50830..381d22daa4ac 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -868,6 +868,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   			 * - Tell IOMMU to use legacy mode for this interrupt.
>   			 * - Retrieve ga_tag of prior interrupt remapping data.
>   			 */
> +			pi.prev_ga_tag = 0;
>   			pi.is_guest_mode = false;
>   			ret = irq_set_vcpu_affinity(host_irq, &pi);
>   
> 
