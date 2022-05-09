Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD451FE70
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiEINjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 09:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiEINjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 09:39:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CED1A3A1;
        Mon,  9 May 2022 06:35:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chDKWTQdiBed67TDCCnqq9ezpTt35QSHRHtFyrpnKyD8lxOY6YlQuJoxNFSYhzFXViBSGeicPQ/AjEwzfCEoY6+amjnxjh0QtyjdQqdxqFXTC48GnknfHX9qEjp5pKxIu14x58+VXiZ4c2zzDaLSyHdLeMhdzbM7UgbX5IGc9SrR2jqjOKw3xoGk2rDKaKV6t/y12BATFAwBmbcFpeFBjLhhiO+Xz6bMcqJDpUDThZXxqqWVwK1SLY4cvWs/wvwcN6v0vI7y2rkakiyMc9MTDLbYId8x3xlo9SIbfdBBE2FZIRzZ/tc65ow0N7kVoyhtJop0BkQBeJCqbYuMqVsBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OijZttoBWjm0v2NubX+65XSH8m7uW1vc8tC1NfAG2gw=;
 b=B9VGJOjIMovOmOdFSxb3FOXzpj/E1j0wwkcA6K7Bjb/T2jC3fbyDJHjx/5kof1dAqX0Gdbnz4HIUCFz1rSxU7mzR71LDsksY1VdIe1FI1/fEY3kiWxDVkp0pifrNRQGXmh09gJIq2tBjl21m+FjJ8pWMYvthF2cv8W23s4VSkUdB5FikktNuOH3sYBXesVGBxqjtdAY5N991Xjk6P8JVwZ6lmFi39SBCDKg6qixSg/nhmcSby7rPL2GccsRJMCu99GwRbWMK1VoNCh6Dx+qQx1zXbQeikFWXj5KcnBG1oywApaq5bEbKTTvT+S2ZQrD0tz4Yys+cXhM74Hy3M6F5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OijZttoBWjm0v2NubX+65XSH8m7uW1vc8tC1NfAG2gw=;
 b=inlOW0mh3Mak8KxL0Nhfod2RPvawI59UbFosJj0Hql33znnYxPadig28qXYEx1FI8T7HMP/tZOBstI1nyOBs4NYcvFL6OFwuHdi9cNFCWIEm+agT6Geb1ZvAmeCR9HjalPA6M6lsoc5s6NFPZPkopGXbTc10/ctMezIcSDf3bdc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by MN0PR12MB6320.namprd12.prod.outlook.com
 (2603:10b6:208:3d3::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 13:35:35 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::5c1f:2ec0:4e86:7fad%3]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 13:35:32 +0000
Message-ID: <ffa7d6ad-56ad-9da8-ebf6-3a10d56842db@amd.com>
Date:   Mon, 9 May 2022 15:35:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 04/15] KVM: SVM: Update max number of vCPUs supported
 for x2AVIC mode
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, jon.grimm@amd.com, wei.huang2@amd.com,
        terry.bowman@amd.com
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
 <20220508023930.12881-5-suravee.suthikulpanit@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220508023930.12881-5-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0165.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::20) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 196f44f2-81b4-41ee-d95c-08da31c0c9d4
X-MS-TrafficTypeDiagnostic: MN0PR12MB6320:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB6320EC9B0C9B5EF1791DA4419BC69@MN0PR12MB6320.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5bjbG7Y9P0jCRpkcB9vXhmXXaYkSbNAGDTkq84dw9b7ENenhv2GEwv8QILMakBWw4Ko83KFgfLpiEsWWw+aX3Z7D/1q7blnOrhZ5SE+qTsNH/V7RPMNjQtJbBJzRYIRx5zDnMl3c7YyATQ8GvKiWsnhcF9P12kFA0Tbj1b2K2i4SgmeR0I/oxqRYee4XtWg24+msAYlHszlW0pVB8nGAjcgserg5Z+imhxtXmy5WfZHC1iEPReny9f0kC9DOm1s4hsJG06xti2z7QDdgOSj+hdp4ebIqNrLDpmQxnxlXw2FV10EwkasUqY1cIOJv8CKv+kzwTsnA+U7BT+GnDTY3GqkjJjqSISkYnKf1f0fDjStfunRS2omStG/9K2Uk1JenV7McieNOeAA1IIoCnhlxWzW12KhI3U3KpusuJ1IxfqSidAdsVviOX4gn2BpeD/BIL8+B6Puw2Eym3euqJuQH6kxJlHVVXai4ArYeDkXO6y6h11rU35X/a/RLr+witDhblw2gP4KTpC+SIGIMphEYSYftBGvqZHizQ6pBa4aE57tnZvFNdkawbvekdTvz884JnpOJLcZ0p4y1m4xyYIkMB1Bcq5MhqlSKlRipwXuxOsz6TfaikQTnuKhr40I1Z/mPPHuEYEsimMKV6RDg8XNq2HWVeQhFOe7JFhzd74n3CbXrP2xTO2x55TypLXNyHnDW9YGKgON0/ZkOc+pGewpRs7TD0SoYleJGFJJSM+F6YA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(15650500001)(508600001)(6486002)(31686004)(83380400001)(2906002)(6512007)(186003)(26005)(31696002)(5660300002)(8936002)(6506007)(6666004)(36756003)(2616005)(86362001)(8676002)(4326008)(38100700002)(66556008)(66946007)(66476007)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWtuekgyZlhDYzk3YVhmdlJIQ2dTaHNVRVlXeGEvM0xydGhXWjl4cnlkQVV3?=
 =?utf-8?B?ZUgxcHIzVWZkWDR2bUREdnlxWGEyNmpPRTU5TVpldW9TTHBQOE1tOCttRnY4?=
 =?utf-8?B?YUVOak53d29MbjQxSVMwQlpiSG5KeWlmMy81bTZlMSsweFR4WHAxSXVobjIx?=
 =?utf-8?B?NHBGVktvbCt1L2ZRRG5ITDhtWWtEd1lGUng0bFBFM25rR3MxL2ZwV0JrVzZp?=
 =?utf-8?B?M0tLU2MyemtxeGwxN0pWSDdlUGFSM0hmdERqd3BHVThrbDk0OG1lNVJlcStM?=
 =?utf-8?B?RDNRQzJ6Q3dOWEJhb3lWS0psNExPQXhJclYrNThJejhvN1FPZ3MzUnBxRmto?=
 =?utf-8?B?Tis1cWg3d1JOblljTml3RTIvalFCa1lWZE1pTlF1eFBkVGtVSGgzeTFHbmVR?=
 =?utf-8?B?Tk81Z0dlc1RHZEJrRFB4dGtGYWRJWEk2ZXBBV0VSeFpUbHRVd3F0M0tQQ1JE?=
 =?utf-8?B?OEgwNVNRci9URm5lRXM2NG42TUpQdVJYVGN2UWdTazVjVzRiQld3VFRaSU44?=
 =?utf-8?B?NmY0bFJxa2o3NVE3eHJ1K0R1SDNlMDlYT2xDTU03MGpCZXpPQTRxWGk3K2s1?=
 =?utf-8?B?aVd3K0dlaVNiei9wYTlJcVovdGFHYVhhUDFyclBsQmdPdnJWcXVsMkp3Rnpt?=
 =?utf-8?B?L0VmQ3BsWXAvSnlrMEVhVHVxNVJObmNqcTZFZHhoSjI2RTdjMXFvSzBlcnRv?=
 =?utf-8?B?T3ZKSWVFSFRlbHN4K1FXcXVncldYZW5iMFc1MVJ6NUQvdVJEazZuM0tlYUtI?=
 =?utf-8?B?ZHpXMXQ1TlYwcG1STVJaSW9waU5ZV09HNWNveGpmdGxxMVJwaGFHa0ttM0F3?=
 =?utf-8?B?ZTFCcC9kTmYvMEpXSnVYMFRjd0VxV2p2b1c3TE8xQmo5TnhHOHdSQ0FqOVZ5?=
 =?utf-8?B?UTJSOUhLdmEzbzJkR3N3NEkrQWhDZFBJY3FKNGNrbWFoYTZScU83TUJqN3ZN?=
 =?utf-8?B?MlRtSy9yMG9UVDEwYnMvYk9XK2l4Z0FneTlFL1JXeHR3ZDg5bnUzQXY3Mmlm?=
 =?utf-8?B?M2ovTkY5WGM3Q3BQMHlpMmdTRFVSUjJ1ZmwzQ3lNdWpMYXgrNjhHRzBGdU9a?=
 =?utf-8?B?WmFhejJoM1BkTmVGMlNhNWxNS0xOVE1FS1ZvYnFoQ1lNenFMZU0ybWt1SjlH?=
 =?utf-8?B?YmtKQ29qMmtIL2NpMHk4em82Y2FlT2MvdWlrNWlOeUYxZFozR2tlNUUrZENB?=
 =?utf-8?B?enI4NGdKSWFSSHVSeUlra1ZLRis0Smx0enkveTFZTmNvRGNIMVg2WGJxVXlJ?=
 =?utf-8?B?ajBBTnJGaGEyQUJTdGU1d0RYUXRsR1ZNT2pyejJXY1BHaklqZE5RWmh1VUsz?=
 =?utf-8?B?aDNMc2FWb2R3eXhrTEZwaWt6ZFRGUG52UHdXQkhNcEp1MzBIRkRiRG1mTUM3?=
 =?utf-8?B?dGVONmswY2N1NDRZSmw5NWhaMkpibmNjY3pDeldnMzVVdkx0L1JBN0lxT0hm?=
 =?utf-8?B?S3YrV2RJa0lWclp1U1NmN1lRblhKdnpGeFlRMlZ4U0tiVW15c2RDazNQNkU3?=
 =?utf-8?B?enJUYndRdU1UUEpBcWt0T0JrYmx2ZE1PZ3RRL2R2c1hjMmhyNXlQNVhnOGZZ?=
 =?utf-8?B?dnR5UVZYOEQ1YkZ6WnFZSElHNllMSXczOWRFU0tpS1FRY1RobGt3Z0FyVmN4?=
 =?utf-8?B?enk2ZmJsY29yQTh1cGtyUkJaTDl5MUthbWV5VWcwdmhSSW9vUXhtdWg3Sk5v?=
 =?utf-8?B?L0FtZm0vZHFxeVVFTWRIRzBEaVNHbkplVktMNVZYVG9yVVZ1d1V4T3J5M1My?=
 =?utf-8?B?amYzV3JlamJmZ3VUbmhjcG1KN1Y4d05ReHloTnpaYU00SDJyUGpocVU4d1pU?=
 =?utf-8?B?RHFiV0haWmorNkJuYnJlL2ljY2NONGxwNk80UkZVak4wM21JSlYrYVVPM0Y4?=
 =?utf-8?B?Uy9sdnVTSnJ1VDdYYXVlVFBHU3NVK3F3cjlJd0dlUjFVWGxZVCt1eGd0cnlC?=
 =?utf-8?B?MUZadjlRaEJMMk93ZnNqMGNGNEJNVjZQU0ZJdElUYVBmRURHWWY1WllXSmdr?=
 =?utf-8?B?M1NTWkxaTVlPd1doNlA2TlFseFFVVGpyYmQ5NlRHSVFtWll6blFGMnZEMC9t?=
 =?utf-8?B?TCtQU1ErUGtiUjFQN3JkK0hnRnhIVnU1WHhLRHZXaHpKMXVRUllDWUZjV2N2?=
 =?utf-8?B?ZVFFNS95WW5Bc0IyaHMzNGc3ekRtTEllTDZ1cHJ0UWswRGtXYlRIK2lEVVlx?=
 =?utf-8?B?WWc2TGFIZG5zMURRQXY5RE10Y1NYeUtpL0oraWliV0dzUjBaZU1hM3lsL2J3?=
 =?utf-8?B?RlhlRm1HL2xvWU03cmZKVGRpSXFqMVVOeHJ3aHBxN0hRYmFRdGZFV0NJSXhm?=
 =?utf-8?B?cEdzZVUyK09jaXhkTWdGNHFsa1dWZVlvWGdTNlVpQitQTUxvdWhrZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196f44f2-81b4-41ee-d95c-08da31c0c9d4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:35:31.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZdqt0VorTAq+/mt3FBkVxKRC38Iz6Q4To8dOM+8yTptts9WCJF2GXE50jQQBh00Sg+UnLItKThiAnrCOt6ckw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> xAVIC and x2AVIC modes can support diffferent number of vcpus.
> Update existing logics to support each mode accordingly.
> 
> Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
> the actual value supported by the architecture.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/include/asm/svm.h | 12 +++++++++---
>   arch/x86/kvm/svm/avic.c    |  8 +++++---
>   2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2c2a104b777e..4c26b0d47d76 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -258,10 +258,16 @@ enum avic_ipi_failure_cause {
>   
>   
>   /*
> - * 0xff is broadcast, so the max index allowed for physical APIC ID
> - * table is 0xfe.  APIC IDs above 0xff are reserved.
> + * For AVIC, the max index allowed for physical APIC ID
> + * table is 0xff (255).
>    */
> -#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
> +#define AVIC_MAX_PHYSICAL_ID		0XFEULL
> +
> +/*
> + * For x2AVIC, the max index allowed for physical APIC ID
> + * table is 0x1ff (511).
> + */
> +#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
>   
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 95006bbdf970..29665b3e4e4e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -185,7 +185,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>   	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
>   	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
>   	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
> -	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
> +	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>   	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
>   
>   	if (kvm_apicv_activated(svm->vcpu.kvm))
> @@ -200,7 +200,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   	u64 *avic_physical_id_table;
>   	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   
> -	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
> +	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
>   		return NULL;
>   
>   	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> @@ -247,7 +248,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   	int id = vcpu->vcpu_id;
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
> +	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
> +	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
>   		return -EINVAL;
>   
>   	if (!vcpu->arch.apic->regs)

Looks good to me.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
