Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8021C040A
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 19:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgD3RpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 13:45:04 -0400
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:13888
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgD3RpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 13:45:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7XVYS5cm6uTZhET1pNr+iTyu3N5tihD8J5pxnWYksi+FeHPVv6FxgfVKs2xT0yatc3lCxAJWF5xBAQOIG9v1p4L4EqG1fgE2Z/XSwsAeIZEzRNz4bMeUin+41B2+0x+S6Kdel0JtHtsCR/My+QnIBh6He6EyR1F+LJgctE4p1222El22zP1qlzgD7wbkunFpkqLoYTZAW94SG1/0vaxsvqQsSmNuKUNyacaP+HhvrkRlKdC36bpYCSgXGBcrGGEIsJGTD87h8Fj6t5E2ycx2Bvtn+EyCrAssSgY112ymA5QuxGe356IUkwXv8KO4oOE8iSpsVqXhB3UfmF+A4s1jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hK2rrzszdIrG6/lBxko//TtVioFYcrRAi5hGPqTgLvU=;
 b=IBfFien8zjN+R7yYxuISiyKTJrsZHQ//maSJX18Q7eRi2AtFYNRh2DQ5AqzwO2Ze1emKsPXs7pQU6yvp71DBzNuhAkwIPU3w3nIqbcVzmYCmhA7xjazC00PZOQqADaVDl1zU2dbI3BHaVpZfg1opBhY+xUTkXtEvRr2PEl3LYK35wQXLkYMuPsjweua01TxyoZjk5NIUw1LpINYK8ZL/4DxSDHAJ7dIbLpMkRNvkc86rZthsXt3aAR3pYgc/W9IWWYcmllpQoZpSaBTDqUor/35OKXmmwI4qzTw+WPoUva5L+4Yt2llab0RjluqCSIbWb5FFbmv9ivawlca1mDB/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hK2rrzszdIrG6/lBxko//TtVioFYcrRAi5hGPqTgLvU=;
 b=DHkU5SqCyzwbSzz7vD+of379zAC5yyiiZqHfIaqLt3PnvxMfVvwaNeN2aghuFaxt/XlfPK9Fom3VH798/7sRYIH2U+h7uy3hqpQsDn/CSFtKXHJVE45iMcgvBzKR8fsRutCRJGJ971cZjGPlVXZH9bqqA60nluCEg+cbAZcEIGk=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1306.namprd12.prod.outlook.com (2603:10b6:3:6c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 17:44:59 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 17:44:58 +0000
Subject: Re: [PATCH] KVM: x86: Fixes posted interrupt check for IRQs delivery
 modes
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        Alexander Graf <graf@amazon.com>
References: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <a6e74ca3-7807-8c5c-bfa8-6085acea11bb@amd.com>
Date:   Fri, 1 May 2020 00:44:37 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0047.apcprd03.prod.outlook.com
 (2603:1096:802:19::35) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:99e1:28a3:aa38:c6d8:dc69) by KU1PR03CA0047.apcprd03.prod.outlook.com (2603:1096:802:19::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Thu, 30 Apr 2020 17:44:55 +0000
X-Originating-IP: [2403:6200:8862:99e1:28a3:aa38:c6d8:dc69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71c17904-84e6-454d-7aae-08d7ed2e3360
X-MS-TrafficTypeDiagnostic: DM5PR12MB1306:|DM5PR12MB1306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1306A3931F61DDF301A907D5F3AA0@DM5PR12MB1306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(8676002)(6666004)(4326008)(16526019)(186003)(2616005)(6512007)(2906002)(53546011)(5660300002)(316002)(6486002)(44832011)(36756003)(478600001)(31686004)(8936002)(66476007)(66556008)(6506007)(86362001)(31696002)(52116002)(66946007)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEtvdpM1/8GtB46Jbjz1cTcFizXBGWzj/7yR2vin/no0bf2W5R582uVjcJ988spiTyw5rdEp2Bde5fAUJsKnBLqvCwmixoTSZVZF+Bpyl6eRcR/AS/t+5TP5vu28C3MkV2DLrAomwNRByNkLn6DzSNxblGAPKolZyh9RzF3pJlMp4RbIJN4CBeCGFDoYVjkqj0dHGMnZz7dIAPs/12VxF5xCzdAqdX0MfyR9FJI5dv2gxMTqyCv2/9boK9DcUVuNXxg2sn6/HkYbFg9zntDKl/lhUpSOjteYNUlLJjzIUW419SicBQ5xGm/xzcZILAj5HMkN/fdNbOa7LsYmFCO2FfwKJp44FXcff1q3T8WGg7rXpgd9iGvwgzranOwCltBF68qXHWGsxGNHV+Be4g3lGStz8gL/Ok8zi5HyJ4vsRJ3V9iXBZUlu/hUhsIyZpFPJGTk6G270sTQ2tmPmaVQqtorLNzTV4P1F1pgl0er7jE0=
X-MS-Exchange-AntiSpam-MessageData: PAJjbUVIH7IhcXp7OIxJNdhMrpy+Ec06wXfwQIpf3DCRSSbGSSutibTPnpub96AUyceZs7IbvBywyS6YlTyX8RXxtH5SCzg6un2q4q8/stcYNt+wQGTludPGQ0kYkgsgFbHh6eqhT5J69QC5Vc25Q7teA4HWCESWbE9zOgDRyqQ+D6Xcwhde0LlNc/PwmzGl9wvHWpL2GCwc2XWHn6nTh8TKb3+7IZFNkKAM5GHXmXHTmXOUWaVHqQ8Upc0i0NNLJ4ELd+DCHhyxXjBxdDTr9L6ZpIpsn+KETztp4HQAy73vjzk2GXmO0Spm0otm6vga7y/NGnd2Nato/f34it8iN64qIMoHEoZJeyId03Un/MinQmeRv4ahA5Y/fvK2vRj60bGGDcp5FtD/7zh4mSwXYwtyCZPzLknehwmbr2o+N7X5H/qkwttZCOTfLLsKi0caGIGz4FXk9gCh2rzrqPaN3OUlSBBWD3eckca081Ml1xz6uPl4grTVkPhSW8Sp0U/2I5CJhsbkUE3dqSXblFARQ75RM59v2mlbB795j4WHSygKFbMX9OFteSJEl9Jn5TkeZSM4bd/tWJz8gwfVD6EpkwpTK02jWs/3uTu5OdQZFgY8uGpVreyoo9uFDx0/aGR1Ny24yyD2cUNSOPMXSNmx4YTATEDmIkZvY/ue+0HzvqGcNTd7VtSeHuR9jtCwWWR+4+iwnauer07XPLe414+UtqTWNGpiUL/BmhEZ4tpSKmNKK36jK5o2zrNd3aunlumVrvwb8NlzDZoqdeWipInGzkIK7lOevSIjNjx/YrhjIzefjXJza9F13+Vlt1DgKX4zgxNxs84m72m2xK/rxta8NLbnr9px1KNEc0IY0wZ5sV7b5JgoZBwWOks79QOXNxkY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c17904-84e6-454d-7aae-08d7ed2e3360
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:44:58.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6r7wkAKPRsKxlH4OiHRogfsnxriR/A7ENdmzdhAcdgLgxlaRAgBG14aBZyC43JhxYCMgUJvfiYKelqw+t+0Dig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1306
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

Thanks,
Suravee

On 4/7/20 1:13 PM, Suravee Suthikulpanit wrote:
> Current logic incorrectly uses the enum ioapic_irq_destination_types
> to check the posted interrupt destination types. However, the value was
> set using APIC_DM_XXX macros, which are left-shifted by 8 bits.
> 
> Fixes by using the APIC_DM_FIXED and APIC_DM_LOWEST instead.
> 
> Fixes: (fdcf75621375 'KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes')
> Cc: Alexander Graf <graf@amazon.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 98959e8..f15e5b3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1664,8 +1664,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>   static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
>   {
>   	/* We can only post Fixed and LowPrio IRQs */
> -	return (irq->delivery_mode == dest_Fixed ||
> -		irq->delivery_mode == dest_LowestPrio);
> +	return (irq->delivery_mode == APIC_DM_FIXED ||
> +		irq->delivery_mode == APIC_DM_LOWEST);
>   }
>   
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
> 
