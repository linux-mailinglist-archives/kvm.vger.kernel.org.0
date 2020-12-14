Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726532DA220
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 21:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbgLNU4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 15:56:19 -0500
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:29169
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbgLNU4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 15:56:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAU1ayco3IhzEthP1vLAs0t+HLvdVsyFQbP6lMc23g4qAFqj/Ew1jF8ksrmt8LGZUlUwyeZn8xOu1jI9SazfxaqlmJv9/POOPtDX/SzwcSvkqfkQUu9nOg8HdEy+hQX1D8I8dMgrjwdTtdRVtlSsCWsIf+HslyybQ94tN1acTBYJReWJkqPhG4yB/ITuE7XClxtmqkA/mQx1SK7FFymTGEYcc/eUb49DUyZMz8fdDXasOTYnPJPaCqioI1In5FTErIKmok2+QE656so8kuB6ANywvlS7CoHCKjeXe2/Swbe3U+w5lAwXEYenkjqbPmfImqZqFSFP6nDfDtQsg+iB2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts4YCnk1G5Bev+b+EhGD/d6SQC0uJtfOHsRgc6KEiiU=;
 b=AMoVA08lCaLBTQ4einv2swNDMU9vozoU2b9pZIz4++qsh5armvk9jp86EZNsAiwRyf+0mkgnoKLJm23gnjgOpaqAlpwbI4y1OE4Kp3DbeAq+ElqQlDak8/hALt/Tt5qkVitXxbpUQU0IRrCwh4uy5EuxamJhC5wQ8TtkMbdrVxbUw700sFmDtDlziXvM257PsuwQzY8q/SDz8330V4rXQ3+QCw7s4ASxc48fZ0CenP9GU6OAzu/qMw4rRgPybD2IbdgHk+O1Ja/P9KuX4mkIC+NeDFdlJELIO17bEYBi/IgTkXaHgJeraYtFeD1qOuPjSYCjSQJ7++/0Ms/wFbo3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts4YCnk1G5Bev+b+EhGD/d6SQC0uJtfOHsRgc6KEiiU=;
 b=rt0mRx03/r4fRDd2EXanMGBGOseNUTQ7NMLxD2fkoyntcjXRBWm/a9KJJs/QnY07SxZ/K2hHfXnMHGihQrsD45Q/qDASr20DFnieogFyvQXFxJ4TnSSFsgpH3HI9xehvEwyeylEm7aaigLElO9+/wbsLCBkWgNMhT17VxwaZROY=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2892.namprd12.prod.outlook.com (2603:10b6:5:182::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.22; Mon, 14 Dec 2020 20:55:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 20:55:14 +0000
Subject: Re: [PATCH 3/3] KVM: x86: introduce complete_emulated_msr callback
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
 <20201214183250.1034541-4-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <da346203-7465-dcc8-9ed3-7e92aa136e62@amd.com>
Date:   Mon, 14 Dec 2020 14:55:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201214183250.1034541-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:610:b0::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:610:b0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17 via Frontend Transport; Mon, 14 Dec 2020 20:55:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b18c7ad8-28e7-4f98-55e3-08d8a0728e20
X-MS-TrafficTypeDiagnostic: DM6PR12MB2892:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2892BACB90E12A707DDBC72CECC70@DM6PR12MB2892.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63wa6TcHW+Qsa+SujW6ZUnN2AY5OOlrieqKacCfHrH9QnDWnAjDMzDRNC13GICW8zgmutemkO271b3kh08XUztF112buWUpRsW1EyOD1yEc0i2xh44OpUFcgi/ZfdmEZ8heiocOCYAzBM/AwLlR8qoCfi4QGxDrkKYER8miTUEy+f44Ac6wKDNT3kitpQEW+H212MvzICjPNHSaxJsaLylIgcOUpkKPrKkeYSR7poC2Ght9eWoHa/nU3G4aFh+zRbv0xAHy9Hul/kygVrKb9X5sPrjqNfKIkpE+DCxNOEDxJvXtafWIOibZM23odkloBwXS6M6zez0FZg6rbrFUJll1/jojmkHbxdyzMrJ3s2sg6t1Wjtdz43mI8loxbjt+WEBM+A6zzuvGmasc5cxH8tMsBG8btbUwKP5BevTNwe2kzWn3kdRF0x+OFLxh6ZHtz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(5660300002)(53546011)(52116002)(34490700003)(54906003)(31686004)(508600001)(83380400001)(8936002)(16576012)(186003)(4326008)(16526019)(26005)(86362001)(66556008)(66476007)(2616005)(31696002)(956004)(36756003)(8676002)(66946007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVE3RnFPSS8zYnBzMitDM3AwaXdVU0NJOENJYUFtTjhXRWxCZDJpNVJvdm1s?=
 =?utf-8?B?STdnR2xTSC9hVG8rU0xNMjg5THBLQy9yR2l5YWlZQXdDSnFPellGUVNuc2RU?=
 =?utf-8?B?VjFwc1JlUVRYNXFHaTlOSjJOL1piUmc2cG5xRkNBWDJwamVVK3VuSWxweHE0?=
 =?utf-8?B?Q2grRlFjbk1TR2tRd1FCZWdwSjM3dEpSQndHK204SkRKMWpOeDZRNlBNTnRw?=
 =?utf-8?B?ZFA1ZW9HejZtUmZIb0E4R1hIRWJNMDRmZ0xtdHJDUjNUVFFLYks0RHRRU3d2?=
 =?utf-8?B?UXZ5YWhmekpBVzZtUUh3TkY1OGlnNUJYUG8yc3RiMU1hckZzdmNMa0NrN2k1?=
 =?utf-8?B?TTI1TDMxS2NQNnFmNG5rSDlzMHd5RGo3akR0WE42Zy9rSlVYSFAyOGg3Yjh1?=
 =?utf-8?B?eE9lSjhIY1p4UjNrcEkvMWhuNWZLQlhyekhjd2tXWWMvWmJQL0hQT3FGQmxL?=
 =?utf-8?B?VW9uVk9YTUthbUpLOGV3QlREZzBSZG1QSTN2U0hHTFBtZUcwenRIQXpxYmd0?=
 =?utf-8?B?YTFqUjE2S1lqQ0xSbFQ1UjRpWkUzdXpqNzlsejhyYVppRVpPVkdzZkdUN0c2?=
 =?utf-8?B?UDk0aUN3SWVoL0RuOEdsTnlockF5VmxqODVOZitXdXlzMzZISVI2eHBGTmNW?=
 =?utf-8?B?bm5tSGxpMkViRmlvMnV1WGFXYTJqbHQzWVdZYk1WM1E0ZGh0SW9iRGppd3BL?=
 =?utf-8?B?TWx4cjN2YjNEbTdTUjcxODNiT1J5NGgzYmZCcHJidnNBSEp3SWFkc2JSVXdX?=
 =?utf-8?B?Q3QwYTQ3ZDNTcEJEWmozNzh5c2x1dkdqV2V2eGtLakFMWVRDaWxjYVFHYmlw?=
 =?utf-8?B?QUg3M01BSk4veHBlVEU5Y0o4Sko2Q3RrUEdST2ticFNjaUQ2V05pN0JLMTI2?=
 =?utf-8?B?dSt4RWZvNkh2U2JRWFZmUGpZTjltbHlKZU82MVM5V1gvMDhTVjJiM0VpemhI?=
 =?utf-8?B?U0dtdTRpNmVCZjFXRnlvQ0dPZU5icEJBdFF1VTIyRXExcUlLTDNVY1NwbFdB?=
 =?utf-8?B?RjE5dFEzQkVqK0E3UGw5STdGeGIrQVV1clZySExMTVFLaXdVU2k5ZDNIRGZX?=
 =?utf-8?B?bWZmNmxyY1NFeUpSSjNpQVloY2hFRE9oUzVWMFlaQ0I5cUFRandJWTFEeW1S?=
 =?utf-8?B?UFo2MlRtSUdMeExzYTN5VzgvZVorbEdOY2kxd2NUVnJzU24rT3dpS2pwSXMr?=
 =?utf-8?B?U1BjZTFuRHVLdzkrMVA0Tk1xbXpqUGx5REtCRHNpY1JxcS84OFVCSnFZOEhI?=
 =?utf-8?B?M1FHOHVKUjdCZk9UR1FOZG0zVVdzb2lOOCtmNmtGdzk3Y0ptQUdTSUFTTG85?=
 =?utf-8?Q?E6EQwR0QiCPnHHAEpeHWO3r8D/lkq6xM8I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 20:55:14.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b18c7ad8-28e7-4f98-55e3-08d8a0728e20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 426vahXQzB0cB+BCGKMTXFuFSmgljkInVwS16+sAjHaR3VnUR/6HvIT3UKZgpBrfMI/1whcoE46fz59hvF3Feg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2892
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:32 PM, Paolo Bonzini wrote:
> This will be used by SEV-ES to inject MSR failure via the GHCB.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

(Changed Sean's email on this reply, but missed the others...)

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 1 +
>  arch/x86/kvm/vmx/vmx.c          | 1 +
>  arch/x86/kvm/x86.c              | 8 ++++----
>  4 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8cf6b0493d49..18aa15e6fadd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1285,6 +1285,7 @@ struct kvm_x86_ops {
>  
>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>  	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> +	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 801e0a641258..4067d511be08 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4306,6 +4306,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>  
>  	.msr_filter_changed = svm_msr_filter_changed,
> +	.complete_emulated_msr = kvm_complete_insn_gp,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 849be2a9f260..55fa51c0cd9d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7701,6 +7701,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.migrate_timers = vmx_migrate_timers,
>  
>  	.msr_filter_changed = vmx_msr_filter_changed,
> +	.complete_emulated_msr = kvm_complete_insn_gp,
>  	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
>  };
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2f1bc52e70c0..6c4482b97c91 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1642,12 +1642,12 @@ static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
>  		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
>  	}
>  
> -	return kvm_complete_insn_gp(vcpu, err);
> +	return kvm_x86_ops.complete_emulated_msr(vcpu, err);
>  }
>  
>  static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_complete_insn_gp(vcpu, vcpu->run->msr.error);
> +	return kvm_x86_ops.complete_emulated_msr(vcpu, vcpu->run->msr.error);
>  }
>  
>  static u64 kvm_msr_reason(int r)
> @@ -1720,7 +1720,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  		trace_kvm_msr_read_ex(ecx);
>  	}
>  
> -	return kvm_complete_insn_gp(vcpu, r);
> +	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
>  
> @@ -1747,7 +1747,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  	else
>  		trace_kvm_msr_write_ex(ecx, data);
>  
> -	return kvm_complete_insn_gp(vcpu, r);
> +	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>  
> 
