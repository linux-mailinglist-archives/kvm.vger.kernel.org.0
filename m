Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30E7369536
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 16:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242762AbhDWO45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 10:56:57 -0400
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:20705
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230416AbhDWO4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 10:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvT0qAxTEnE5aoneEO/Hb86me64dl1IkOI3/wlXB6juupFtm4zhUw6c3tz2jlfGauY5G74GjN8u42vNEsG1gaiDHafSqh2+Zr7/jlRCeCnTC8PWAs9LClJLiFplytzWT7/WWgzYSjM2XiAfmnNsWGUt67Mvv3yAkbw9gAjcy2JXZJ/xaQ7dpzxh5rh4slhxX8bPlfbkbNuQgswxsjefHy/v9/mBG9T2cizRij/s99WOSBOod1iEcp8Wb6HJeMwe3OAgNnrYs0yaunXfO+mZkORGNjvGBIC0csFj7hblnJ/Mr2r6udJeoY3Mz536WsKVEjfPQiK+3/SN7byDdcRJ+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhcZc2pA6K8PnCsrcf2oxrBZADWdyYQ1S9+CnECYIi8=;
 b=AmQIv7NP9V20aH5y4fDfhHB1MBxWiUzz/cU19K+bgAi9a8U7jUIOT5hmcJFO0qdmnoK0KafW0jlvkSlTFsqFEdEpi9VM7SgGST2gkUAa/uKC62m5qFrRaH01qqrX9QclCcyLVKTne7n5aaw50RUTWhZaHqaAETX7bXkQ/ot1HXNhxC11FgvpvmWNhdnDZ5bBsoqwLFe4efT8pxsFXWGdLbwJa8PfewAuWcQAjmENtKw7wWAefh4Jhh/z31dhpwaBe0QraPonSKFMUiWht7EJLk7eBsRD6lOwvZKp6LFFMPXUL2Cy2D4dryNjesCyM4GlIo4w0+6ESTZqVRudT1rU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhcZc2pA6K8PnCsrcf2oxrBZADWdyYQ1S9+CnECYIi8=;
 b=ZQdxz6i+G/xBTphTJzT2p0jR4fXAwraVzVob5NQR+P46aNSW2xbmHhYnykuUcqIxXnI3tXU3kx1UEZe7yHjiy5cB63ZHQ0O5RzIZ7yy5LtRLl1Sppr22AvF9uRFTPT1JyAUPBN+ouQ1irjnbbRzJAuyYZg0an9Qcepecnwv36gQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0025.namprd12.prod.outlook.com (2603:10b6:4:53::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.18; Fri, 23 Apr 2021 14:56:16 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4065.023; Fri, 23 Apr
 2021 14:56:16 +0000
Subject: Re: [PATCH v3 4/7] KVM: SVM: hyper-v: Nested enlightenments in VMCB
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1619013347.git.viremana@linux.microsoft.com>
 <8c24e4fe8bee44730716e28a1985b6536a9f15c5.1619013347.git.viremana@linux.microsoft.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <81cc0700-ab88-0b37-4a6f-685589e73212@amd.com>
Date:   Fri, 23 Apr 2021 09:56:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <8c24e4fe8bee44730716e28a1985b6536a9f15c5.1619013347.git.viremana@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0180.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0180.namprd11.prod.outlook.com (2603:10b6:806:1bb::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 14:56:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a98a929d-3b0e-442e-2e97-08d90667f259
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0025:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00255D131BAFB239752728B6EC459@DM5PR1201MB0025.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQPlhE2zNyAaW+oicattDwyzHCvXT5FOfLV8Vnx6PR7TtD0qQclldYArhVUDUFhiEjb6qa9UTtp0isN81v9YuI6N62wOZQX0H9FW4iBpDOZvdFJ3ot+C5tV7xvqgeRWRMigUR5rfR5rBVuS+IXvnLVkQsEppVcIepUJEDIDwrcd95dtHFcXL7Y8Ahz79xK6WLGNWdqlnC1a+NBX5HMtf8ncuDyN+IVAEid6O9CXJwNyugHQqIfwG09OZkQhzf3YEtZIBE8c8Rbhpn+/NyT66zkdNZ+2RZZFm+TP2B8JAs8Wm3/b2Kyit2oqPEw6KhirRBh7/vMbNHeY85B2X3Mp/GcTTh07EzTCy6DlN1FPoXMljUcPfQZjXvzYOHQ2lK6wh988AyMyyp2+C8ouKay0n+DW0vOie11IlzJ4eR1XE0uSpLPJ1s7aY/8D59IQ7lEFXZzj9B9mrjhmRU8Nk8JeIOrUkjvKTwR/bTxpFF+O3aZU6F5c2fqlg7gpDk2oxHK+a4fDILyNlfz5OzqMWDwqmUfpNY96zqy1S1IPAP2lAiodNNRapK1Sis2qXsVMMwETMFFVByeFHd/VI4sBu0Tp6jbsF0b/DXjU+ZL1bo+MZSmL6Gslg9TRoP0Y9AWYydEl74eZXxu91DETfzcJTIc/1CP6J9jxzRBygEgKNe56eXA5c3RnAPbbmTCY6ONXFP0RK+AREz08NhZ2QFRljR3PP9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(346002)(366004)(376002)(83380400001)(38100700002)(7416002)(956004)(5660300002)(66556008)(4326008)(53546011)(66946007)(478600001)(31686004)(54906003)(921005)(316002)(6486002)(6506007)(16526019)(36756003)(8936002)(8676002)(2616005)(2906002)(66476007)(86362001)(26005)(186003)(110136005)(31696002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U2xIamx1MEl2U2NqQWtkbm9RRWE0MVZhcTVybU5OVjBPc3IwRHU0NEtYVXlT?=
 =?utf-8?B?NFZhSTBUVDg2VExUYkhYUFVRRG5takZwaEpIYjEvTkZON2lybkIrVUpXLzRo?=
 =?utf-8?B?eVJQYmNvd1NTZnBINWZCUFNOemdBaGU5TVl4TlJ1QzJaRFVvREZXalpMQ1dx?=
 =?utf-8?B?M2g0dDF6dUo3UkF2Y1RTNnY1WXp1VVFNSDRBSG9FU0VoWVZUMlZJbU5DNWF4?=
 =?utf-8?B?amFuWEdyUitOaXZWSHNBVUh1REl6WVhyMHZRbXAxdnBUcVBNWkRVTWxTV2pm?=
 =?utf-8?B?K1prL0dGcDdvUThPTEFrbFM5bjd0U0x6OXRtcUJXVktiNVduN2xoWnRtVG5Q?=
 =?utf-8?B?SzdqSUVvdjZscDN1Y3lOZG5vcXBwV2JVSC9KemFxRGdkT09QaFh0eXZucVEy?=
 =?utf-8?B?K0VsTE1QVTQ2dzc5RG03a0RabUlHRWRWVEZzUE04bHJQSjlHNEtMaDBwbmtK?=
 =?utf-8?B?WDYxcVVBZk15NlNNT241cXY2WVVhWlU1T3hoQTB4QkJHQXhReUN0V2ZuY2Ra?=
 =?utf-8?B?d1BXdEtBb1VUamxyTkJGaGExY0YwS3p1REtyMFJlVC9xNEUxZjhhcTRWM1FI?=
 =?utf-8?B?SFdpR2ZnTlJGWnFHTk5BVTV2T2d2VXlET1BjTlJ3WWV0SVpjbmxYMDBOVWpx?=
 =?utf-8?B?dzlPMERGUlFOSGJUd0xmbXBTRmYzU1c4R3VWQkpjRlJqVjRNWHZ0czVhdmE5?=
 =?utf-8?B?WWZhY05pTEQxR0VTREs5T0ppU2swMENWYUJvUytLSVpRRDhVcFdkdTZ5NklS?=
 =?utf-8?B?ZDhlcC9RMUlSRHNmb3JBbklsVTA5Q1k4VkxnOXlQVUNWRUJMNTVxcmYxSm0v?=
 =?utf-8?B?dmxncXNPdDVKcitFQytrcmY0WUV6dXcrN2kweGl3dzY0NkVZZ2JLTXhYMkJP?=
 =?utf-8?B?Mms4a08xNEMyVUtiWmk0V25xdTFxVjQzWFFpMVF0c0d5am0vSFNGSWl0SVh3?=
 =?utf-8?B?UGVXbXhla0JFaktoT2V5dmRFc205bDB2MTc3RFY3SEdiMmtsa0FNTUVPUFdY?=
 =?utf-8?B?TXJLQ0hYUzBoYnNFZkVBWFpDQWlUanN6dHZrWUk0VEhQaEhNK1U1Qm1id0ZT?=
 =?utf-8?B?RFcwbS9VdnRPU2VCbFk5Skk2YlU3WVZzbzhWalVpOTkyN3Zjb3VPMFFVc1Fr?=
 =?utf-8?B?eWp0MHhMNlZCQVZGRUxoQ29BeFp5MHZBV2duN1g1NFBpOEJGOTJaZ05lSnZY?=
 =?utf-8?B?SE5JSVBOamxzWnNzbFBBWTgxUy9ZbjJSQTMvTGFQNFpUaXliQlJGMWgyWVRW?=
 =?utf-8?B?SXRIS0FWY3A0RFVPTXd3NlI0dk1pZVVHc3lXcG1CeUpSVTlLUkpwN3BlTGdH?=
 =?utf-8?B?TkJ1Qjd5UUUyWFJtQjVSZ1hlSnBoMk9pYWpZT2dxZkJrWkcycGtGNE5jS3pO?=
 =?utf-8?B?U01nNE9rZzdwVC9VUjR2aVFKcWxVRkR1L0ZLaEZTcExTWC9zclJhODBGdXA0?=
 =?utf-8?B?dU9YdmVFKzhOdEs2VjgybmdQWGVuMHBVQVpqb1hQaldEcDd1eDluckZCQWdt?=
 =?utf-8?B?ejRNd1RpK082TzM0Z2h5Z2ZlVm1jNThVMm9oeWROa2g4eDYzcjd4Y2VVVlRK?=
 =?utf-8?B?b0tTSXpjdFJNa0tTaFRiRnhUckw5RytVa2laU2plM05iYy9HcUNSbm1mR2Nu?=
 =?utf-8?B?REF0Y3VrU0pSU3dwa085MUs0c3A2bkFlSHQrTFQranZqYTlGWjBvL1RDZWt0?=
 =?utf-8?B?Q1VwWlUzNElqa3d1T0hUME1GSms1aEtVYmp3cXJDdm1sUGV5dFZwUEZ0YlhQ?=
 =?utf-8?Q?tzu2X29zSPth9c4JqpY6szwtr2ALXWFczxJ5Yon?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98a929d-3b0e-442e-2e97-08d90667f259
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 14:56:16.8074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiDjj5eMA78Jghy0LSSiw1vOsFGAFulv7UsnLD2fU/129SQOefsVer4XrYUKiYhDrrPpUQbzZw7KActLhVZHWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0025
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/21 9:06 AM, Vineeth Pillai wrote:
> Add Hyper-V specific fields in VMCB to support SVM enlightenments.
> Also a small refactoring of VMCB clean bits handling.
> 
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/svm.h | 24 +++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c     |  8 ++++++++
>  arch/x86/kvm/svm/svm.h     | 12 +++++++++++-
>  3 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 1c561945b426..3586d7523ce8 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -322,9 +322,31 @@ static inline void __unused_size_checks(void)
>  	BUILD_BUG_ON(sizeof(struct ghcb)		!= EXPECTED_GHCB_SIZE);
>  }
>  
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +struct __packed hv_enlightenments {
> +	struct __packed hv_enlightenments_control {
> +		u32 nested_flush_hypercall:1;
> +		u32 msr_bitmap:1;
> +		u32 enlightened_npt_tlb: 1;
> +		u32 reserved:29;
> +	} hv_enlightenments_control;
> +	u32 hv_vp_id;
> +	u64 hv_vm_id;
> +	u64 partition_assist_page;
> +	u64 reserved;
> +};
> +#define VMCB_CONTROL_END	992	// 32 bytes for Hyper-V
> +#else
> +#define VMCB_CONTROL_END	1024
> +#endif
> +
>  struct vmcb {
>  	struct vmcb_control_area control;
> -	u8 reserved_control[1024 - sizeof(struct vmcb_control_area)];
> +	u8 reserved_control[VMCB_CONTROL_END - sizeof(struct vmcb_control_area)];
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	struct hv_enlightenments hv_enlightenments;
> +#endif

I believe the 32 bytes at the end of the VMCB control area will be for use
by any software/hypervisor. The APM update that documents this change,
along with clean bit 31, isn't public, yet, but should be in a month or so
(from what I was told).

So these fields should be added generically and then your code should make
use of the generic field mapped with your structure.

To my knowledge (until the APM is public and documents everything), I
believe the following will be in place:

  VMCB offset 0x3e0 - 0x3ff is reserved for software
  Clean bit 31 is reserved for software
  SVM intercept exit code 0xf0000000 is reserved for software

>  	struct vmcb_save_area save;
>  } __packed;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index baee91c1e936..9a241a0806cd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -31,6 +31,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/desc.h>
>  #include <asm/debugreg.h>
> +#include <asm/hypervisor.h>
>  #include <asm/kvm_para.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/spec-ctrl.h>
> @@ -122,6 +123,8 @@ bool npt_enabled = true;
>  bool npt_enabled;
>  #endif
>  
> +u32 __read_mostly vmcb_all_clean_mask = ((1 << VMCB_DIRTY_MAX) - 1);
> +
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * pause_filter_count: On processors that support Pause filtering(indicated
> @@ -1051,6 +1054,11 @@ static __init int svm_hardware_setup(void)
>  	 */
>  	allow_smaller_maxphyaddr = !npt_enabled;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		vmcb_all_clean_mask |= BIT(VMCB_HV_NESTED_ENLIGHTENMENTS);
> +#endif
> +

Is there any way to hide all the #if's in this and the other patches so
that the .c files are littered with the #if IS_ENABLED() lines. Put them
in svm.h or a new svm-hv.h file?

>  	return 0;
>  
>  err:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 39e071fdab0c..ff0a70bd7fce 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -51,11 +51,16 @@ enum {
>  			  * AVIC LOGICAL_TABLE pointer
>  			  */
>  	VMCB_DIRTY_MAX,
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	VMCB_HV_NESTED_ENLIGHTENMENTS = 31,
> +#endif

Again, this should be generic.

Thanks,
Tom

>  };
>  
>  /* TPR and CR2 are always written before VMRUN */
>  #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
>  
> +extern u32 vmcb_all_clean_mask __read_mostly;
> +
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> @@ -230,7 +235,7 @@ static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
>  
>  static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
>  {
> -	vmcb->control.clean = ((1 << VMCB_DIRTY_MAX) - 1)
> +	vmcb->control.clean = vmcb_all_clean_mask
>  			       & ~VMCB_ALWAYS_DIRTY_MASK;
>  }
>  
> @@ -239,6 +244,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
>  	vmcb->control.clean &= ~(1 << bit);
>  }
>  
> +static inline bool vmcb_is_clean(struct vmcb *vmcb, int bit)
> +{
> +	return (vmcb->control.clean & (1 << bit));
> +}
> +
>  static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  {
>  	return container_of(vcpu, struct vcpu_svm, vcpu);
> 
