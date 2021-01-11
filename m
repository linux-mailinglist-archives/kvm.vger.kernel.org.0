Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845362F1D3F
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389793AbhAKR55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:57:57 -0500
Received: from mail-eopbgr700042.outbound.protection.outlook.com ([40.107.70.42]:61408
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389680AbhAKR54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:57:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnAptpP1xYUuvmeD030ocQmgoUyD8+2YM97Nc2y6fD4DVeaH4mKS5tgY+ChrLE0sEei4+AW1d0uF3op4lrbCMliobXzAHb+XoRw4rBXuFIEI/ikm5WDISxNrl3AysfNxB1Cb0r2xd6KVtl5FCVP7sPEKFZDDwa7p/dATLfILMws2u0+7JWGNS50AbygYY2wWzawcM5/w9pDynbH8zCdAA/NS4q1Tyl5Wh0S0bCb3RA6KZGADzFhFQFdUt1xa8QaE7AL9qW4WgRA9/2VatkAluZ2yJj0R+PkDLmOOIV72JxrjQtl52WxXl6OEUMLC4LsSvky3w/FmFDLav043n7dR7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOexZLTqOUWjQ34uYOxmDKfYCjTMjV4q/h5afrItHlc=;
 b=BMPBSsNPuksSt2LxNebZSvg9/WwYuV0X99q1y7512T3XrWPNd5Qza38dzfGl0eTRiISlSBFi8YUnvqp3HJFGc/vadZl2HgtmoA1PBCuuhAZ4vny3gsHmg/KDjwMm3/9/cZHP7kW4U1Z1z6/DcdaFzEdRlM5WaBTxH1xIPEg9Rszs0P5WFCzAhKmAckS0DjdWSvLu04GnR0vbvjxAErNySa9HV0RiNPop7fjsmNGOXQ488Fe5gXqDo5DGWoVj2lfiLW/Zs/6GOiklNJ59Mr0rBkpeFwdz4CGv3H9idwZATpWCTZZRMJEsMWzjgiDYkngBEvax1vTwa0FtbJzH2eFDvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOexZLTqOUWjQ34uYOxmDKfYCjTMjV4q/h5afrItHlc=;
 b=zLl94wP+bo7B78TQjSejmtXkPOtI/V9sTVCbbNlsrnXE1obl3tOKjY+S62ndNg4m/eWP0sFDWEM8spy40S6qiytUDabUuzg6I2EkqDu2V4p7GYOHYID1ftYDSmYMaXa/U6PTMHMR1xy1rKsIn9Jn53qh377kmJeM7ZrL7/LoIqE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1450.namprd12.prod.outlook.com (2603:10b6:4:3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 17:57:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:57:07 +0000
Subject: Re: [PATCH 11/13] KVM: SVM: Drop redundant svm_sev_enabled() helper
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-12-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <89efe8fb-6495-5634-9378-a7dbb57f9d81@amd.com>
Date:   Mon, 11 Jan 2021 11:57:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210109004714.1341275-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:805:de::45) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR05CA0032.namprd05.prod.outlook.com (2603:10b6:805:de::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Mon, 11 Jan 2021 17:57:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 228beb36-92fb-48c1-26e5-08d8b65a4fbb
X-MS-TrafficTypeDiagnostic: DM5PR12MB1450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1450766503E081A5AF2DAA70ECAB0@DM5PR12MB1450.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RaQOg+xZhQUangGseFUAb4UpnJIl3b7kDm37f+KR55kLFH4R+4WIBY1x14N/s+S48Viq9vY/UaKVCjO4+87hpd7BXQDEG6/1MqCzu7JjudbUH+LBsd9jYEw8pIGEkodPXwyFHePQRbJyiDPQbQQYBi2GatnKDJJJ5Hci1Kb+tUNdlVyRhNGMQ7Cji20/ogFv3Phe/wR6rMQaP0OD+EpH/fFIYMmlHPt//F70jCySeOQWWvbb82Pq6jy8q20RS2eEP8fb9Qw7puP2YBSfAQK57073NTEu9usntUYWq+ChsgAw6DbsQNOnTBz4dNV2rbWaomyggX6NQ6al5HlwLpDa296UMVNE4jezufLVZAzfC+1M77xQuGSa1dhsu72U+PUubkO8ZK2pK0m/MoRi2tDHChEYz78pwN9fKjmY1P8kUQ8T3mY8G7mdvoJdpG9qexKzv2GMihfXflEHIDNYelgbfFQE1Ny02NAMK7cJLyoaLRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(36756003)(86362001)(8676002)(66946007)(66556008)(6486002)(110136005)(316002)(5660300002)(2616005)(2906002)(16526019)(956004)(8936002)(6512007)(54906003)(53546011)(26005)(186003)(6666004)(52116002)(7416002)(31696002)(4326008)(478600001)(66476007)(31686004)(83380400001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VEgvWjNRVE5OU1RPeDl2d3JkbzdrRXozaEFkbHhMUkxhMEtyVVFYdVhLMkNk?=
 =?utf-8?B?RG5YQjJOUFpEKzd3dHRqM2JmVm1zQ2NsRHBRZzZ5TjNkMWh0VUhYZTAya2to?=
 =?utf-8?B?WUJoWlBmTWV4TnZ3eUpJTEQ3VnVwVGx5WVVjSllFVy84UHFzcERTQW4yVGJz?=
 =?utf-8?B?Y2RSUGthRTJUMkhZeFFJQjdybDAvYllvb2d4RlF5cE93ellGUzlQZHRHekpS?=
 =?utf-8?B?T3A2ZzB0UzBGaFBDWWVGZ1JOczcwb0N4dTNkWldURFNqQXkzc1F0SGpMNmV2?=
 =?utf-8?B?T3pveUdCdXFqODVpTzEwdVVERUFaaHhvN01kN01nMFVmejY2WHNWelhiRDR5?=
 =?utf-8?B?SDlHNzFNSzdyeTMxbXFIR1VZWlBldHZ4a0JGallLMTIrbHJBSjQyMk03Q3ll?=
 =?utf-8?B?WmJ5RUsrNG4yR09HOVpQdDFZTGI1UkpzMTJjRGxxekE0UTRxWTVQSGxlaGJF?=
 =?utf-8?B?aGdDamU0WGNQVUx4aGZkbFJNNXBMblJQUTZDckJrUkpiL0xBZjUwRkszY010?=
 =?utf-8?B?QlB4eHRtL2I2QnZ5ZVp0R21DaSsrTTcwMmhrTWhoK3F2aXRSRVk1VXp6ZEVu?=
 =?utf-8?B?S1dnK1cycWQxYzJVVVNGRllMRmQ3YitZZDNRWWthYzd0WWMyMm94czFzNURQ?=
 =?utf-8?B?alo0YmZERE8xY1QyMGIyWjBsUyt4a3NKWE9zZWZLN1M4dVYvK2pSdEVlc1ZZ?=
 =?utf-8?B?ZHBrTjV4TWdEeU5vUWdVU21Ic2pEYVd6V0tLYytQcDc2VXJNcWI0b3VHYXF1?=
 =?utf-8?B?dkpsZ2s5MllTdHR5a1dkOHhIT2FNOWZGejZaVGFJS1dUK05pVzlYYzluc1cz?=
 =?utf-8?B?QXpRb1FCVXQyNmluQ2dETEM2MXlLOEpsM3U4YVN5WWQ2WmdJQ3c1MWVQVERm?=
 =?utf-8?B?TUV6UmNQVW9nQ0tKcjM4OTYvRVVxN0ZTMUh3VS9FZHRwQUVncGxzclRPNS9I?=
 =?utf-8?B?UENldEJpUmRaRGVqZlo5VEtnWndTcENRL05yWkkySkZ3MnloZDh0ZDFBbklD?=
 =?utf-8?B?TU5LN2lhTW1UMHJtd2IyY25OS0NIcjNndndKZG9EM2l1YTZVZCszU2QzMWpS?=
 =?utf-8?B?ZFdmajh5TDQzYU5jZWUraGFENkRKbHNNNENza28ydmpQd2JHMDRsdzVRQjU1?=
 =?utf-8?B?bjNDazRBZW11aEdlRDNGdm5aY1RlUHptdlhxbTUxL0JodmN5RFBlWCtJUTlj?=
 =?utf-8?B?R1BIMkdUeDh2UkU4eThScW12UTN5c3NxQkJmNnZ5ZGZJcmRFVHd1eDhNdmdC?=
 =?utf-8?B?aEV1T0tjaDF6MDFkQVNYbWFvMDJ5QUFvYkVUbjR5aUozR2lFYXlJVE92eEZM?=
 =?utf-8?Q?Eelk3VgYBPO1n2+fr7xut0AyKeKnEBNCc+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 17:57:07.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 228beb36-92fb-48c1-26e5-08d8b65a4fbb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEydXlPd6auSv3GyB75ghrDh8/BlzEkoGNewBCBbKp+/qrFgnnrTqMKyyzml6M8jKERf8kD0tABgBNsiLoovLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 6:47 PM, Sean Christopherson wrote:
> Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
> in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
> This effectively replaces checks against a valid max_sev_asid with checks
> against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
> if max_sev_asid is invalid, all call sites are guaranteed to run after
> sev_hardware_setup(), and all of the checks care about SEV being fully
> enabled (as opposed to intentionally handling the scenario where
> max_sev_asid is valid but SEV enabling fails due to OOM).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 6 +++---
>   arch/x86/kvm/svm/svm.h | 5 -----
>   2 files changed, 3 insertions(+), 8 deletions(-)
> 

With CONFIG_KVM=y, CONFIG_KVM_AMD=y and CONFIG_CRYPTO_DEV_CCP_DD=m, I get
the following build warning:

make: Entering directory '/root/kernels/kvm-build-x86_64'
  DESCEND  objtool               
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h                                                           
  CC      arch/x86/kvm/svm/svm.o                                                                                                                                                                
  CC      arch/x86/kvm/svm/nested.o                                                             
  CC      arch/x86/kvm/svm/avic.o                                                                                                                                                               
  CC      arch/x86/kvm/svm/sev.o          
In file included from ./include/linux/cpumask.h:12,     
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/cpufeature.h:5,                                                                                                                                    
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:38,
                 from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/percpu.h:6,
                 from ./include/linux/context_tracking_state.h:5,
                 from ./include/linux/hardirq.h:5,
                 from ./include/linux/kvm_host.h:7,
                 from arch/x86/kvm/svm/sev.c:11:
In function ‘bitmap_zero’,
    inlined from ‘__sev_recycle_asids’ at arch/x86/kvm/svm/sev.c:92:2,
    inlined from ‘sev_asid_new’ at arch/x86/kvm/svm/sev.c:113:16,
    inlined from ‘sev_guest_init’ at arch/x86/kvm/svm/sev.c:195:9:
./include/linux/bitmap.h:238:2: warning: argument 1 null where non-null expected [-Wnonnull]
  238 |  memset(dst, 0, len);
      |  ^~~~~~~~~~~~~~~~~~~
In file included from ./arch/x86/include/asm/string.h:5,
                 from ./include/linux/string.h:20,
                 from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:38,
                 from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/percpu.h:6,
                 from ./include/linux/context_tracking_state.h:5,
                 from ./include/linux/hardirq.h:5,
                 from ./include/linux/kvm_host.h:7,
                 from arch/x86/kvm/svm/sev.c:11:
arch/x86/kvm/svm/sev.c: In function ‘sev_guest_init’:
./arch/x86/include/asm/string_64.h:18:7: note: in a call to function ‘memset’ declared here
   18 | void *memset(void *s, int c, size_t n);
      |       ^~~~~~

Thanks,
Tom

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8c34c467a09d..1b9174a49b65 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1052,7 +1052,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	struct kvm_sev_cmd sev_cmd;
>   	int r;
>   
> -	if (!svm_sev_enabled() || !sev_enabled)
> +	if (!sev_enabled)
>   		return -ENOTTY;
>   
>   	if (!argp)
> @@ -1314,7 +1314,7 @@ void __init sev_hardware_setup(void)
>   
>   void sev_hardware_teardown(void)
>   {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>   		return;
>   
>   	bitmap_free(sev_asid_bitmap);
> @@ -1325,7 +1325,7 @@ void sev_hardware_teardown(void)
>   
>   int sev_cpu_init(struct svm_cpu_data *sd)
>   {
> -	if (!svm_sev_enabled())
> +	if (!sev_enabled)
>   		return 0;
>   
>   	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 4eb4bab0ca3e..8cb4395b58a0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -569,11 +569,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   
>   extern unsigned int max_sev_asid;
>   
> -static inline bool svm_sev_enabled(void)
> -{
> -	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
> -}
> -
>   void sev_vm_destroy(struct kvm *kvm);
>   int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
>   int svm_register_enc_region(struct kvm *kvm,
> 
