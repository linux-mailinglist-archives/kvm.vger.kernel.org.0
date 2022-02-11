Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95F54B2114
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 10:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348366AbiBKJJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 04:09:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348370AbiBKJJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 04:09:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E21024;
        Fri, 11 Feb 2022 01:09:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRZ5Jk/ThAqudJ/vKZycsWculex3jEAp9xp8MBT/StcZUFdF3JMfry4G4HhtTtu2jTVmc4feJSZ1kDgTY+rC2wLnaduNJahlMEU/5tsa4EZLp5JYDIdKxaI7C0NJ3Bu4+LwITmS/wEttok/fEu2nfZvhGvSC7wLuMCLDaUVLzQl3+BzpcYoW0WqVuQPN3d0cu/7ij+ootyN6J3Cedwl9bipJEMIvz/wnFePiGIKzRdvkxWbtsKugZ/N4hvBtyWe7yEyy4xHP/qCXRKaUK0RBuLumYPZi6oBwSbQ0PgN9IL4kagjab0K5KOAPzjZZQEpfDlvZiyc5G9x3gss2KPMu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UdfA+qVU2bvQXUeytNcqDVOtPYU4y5ETZpWjv0eDGo=;
 b=a9aKYpm5TidgaIflZvAlZNFb4o2bO2nh89g3gmGtJBzzzbNO72ltiG3p9acYpKS9YCeG2oY5RW+s5u3MrLsbl53ZSAoCJUj7WOJ2KSNoZFL8Rl6DAPS2p2kPsLoPHeBsfcT9J/KKGugT+D0bgfQgyYI+UBiKym4K/PcZi/ZgZrNY3Fl/eBN+5LENEqJbTH8rk9aRhKTm2PjD7Y0oyqrvepZkRv3IQTzVIaq3zpht9eNR4AtX0GA1uvT/EY06f/0Ot4YAyGAUU8blN+TNoBUuGEXThY3q5iWWQKs7Yjprh+805qJh0sPukiICIR86YWItzlyFLgHBBEo20RsKkbOuPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UdfA+qVU2bvQXUeytNcqDVOtPYU4y5ETZpWjv0eDGo=;
 b=HNGS+J91FDdiHntFGagSFaejP7aErrsEcX49dBQZ5MvCYmwZggr579Dje0kpjKzTg/h7LvYMMPtAaW8UivGyU9oz/1FTiWmEUlMvYNwbAc39bz3NjV0rlTNyCPe8+DUDXm95JFyBBLeC7C2g+t7f33dbMGCnOsgm2K5HMiq+UUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 MN2PR12MB3501.namprd12.prod.outlook.com (2603:10b6:208:c7::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Fri, 11 Feb 2022 09:09:03 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::19bf:2e9b:64c3:b04b%7]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 09:09:02 +0000
Message-ID: <9871bfc0-42e8-c485-687f-dd111224fbe6@amd.com>
Date:   Fri, 11 Feb 2022 14:38:48 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: Re: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role
 changes
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-13-pbonzini@redhat.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20220209170020.1775368-13-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0048.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::34) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f79853bf-e482-4ae4-3bec-08d9ed3e2509
X-MS-TrafficTypeDiagnostic: MN2PR12MB3501:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3501AC8006A087876119320AE2309@MN2PR12MB3501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMIPpucnIbCg8R/gnL4JJBIC2/uzEPiWpLCXaXls04w6y1IdmpLpRau0yYRTyF+A5SmC1TOF6uIN73alLLxaOEjz7DPJaCM5O0UTJblgWINKneTI5RVvmtDBnaC7HUlpEu7r5fNVzRzL6gPTIjTl1zIw9Z5mRoNNlMmz9oW7BuzBQaQNNF92Q04sBSDS6lkrbBCjlXxFKnYQrz2AlfjH/l9Hn+jeZuuPXGLxbJcFog2PjmrFuod0+W2nRct9moN3M9X1ESoS0GejsuAFdWB4BA5AE14J3MIThJHDNiOV5h3TEaXo1vxwwNVBNV6oLL5GACs9gcXBSFyFRARlZPrtJVxFhWXpHZQTmAYQxXW5S0RBdloz5ylzl0dhuDMlrbNLIvvs0odwVba6FXLMgvr2381JqCxpQLEq0zh+H4zUsxj89JYNAEx+loFfTyriUEZbLX6bb7IegHogeSv58xoUNmlx0yJQKJBqdTndci0udA96d79Lm2pXWElztYHaLIYSAPfPqah3z1QlGScmeBVcfpcn+W9EnMss+skdq+KldsovvvvCBM+I0D/SJZRy4aJZJviEoJgkiCoRLXkJ7EbJG1pRWF0mQiCV19Hl788p+3Ixr+AEGWaUxSP4rxrKg907RayZ3w6BW+SwAPiCWLwbWYzI+2YNsNIuNP7zW6JmbpH3MGiYLwHPzMwWPZjlyXrRTMtT85Ii5X/y3s1LSKdh82g7unuS0d0i/jTodRPpNi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(8676002)(66476007)(66946007)(66556008)(4326008)(38100700002)(31686004)(6512007)(508600001)(31696002)(8936002)(5660300002)(2616005)(6486002)(36756003)(26005)(186003)(6506007)(53546011)(4744005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTFDYWJIT2w0b3I1dUF3SDJ1bW81R1QzZThWc2loSUQ1ZWdvV25TQkFoYkli?=
 =?utf-8?B?elN1dldTSUJpWUNUaVp6dTZNdS9TczlrOHVnMWZnRjdDUDBmOHcrWDVOUnEv?=
 =?utf-8?B?MVE5MHRKNEw1V3lQZGowdDBLalNlTlZhaC9WZlZETzl2QnJUUVIzUmN6c0dL?=
 =?utf-8?B?Uks0Nk5USFBlbm9zd2tSZzVNdE9sQjFVK1BZOXJtd1BacTV2MFBUSWJSckFV?=
 =?utf-8?B?N2RwK2N5ZmxkR0FJSmpzcENyR04weUM2Rit0aUJjTEg1S2FaTkVSbDFIVG5p?=
 =?utf-8?B?eFJENmhFZ3piYzNaTGhmQld0aTRkWDR0a3hiSExFNGt4NTJwZFZmZmxQaEtL?=
 =?utf-8?B?SnlndHFXUytzd1JTcG12eThqaDBlTnhpaDdTMkpFU1hQZ1lQVCsxOGltenhM?=
 =?utf-8?B?dmc5OC9aSFFXNGFjU2p4ZXh5VFMwaXJYdWVLeW1Ja3BjY3BiMWlTanc2YjBU?=
 =?utf-8?B?MjFNaUcyb3BGQktEWlczVDFHZGdDbFVQQXUyL09mYWRDamxlaU0xbU04QndB?=
 =?utf-8?B?blI3R3lLem5EZmJFZnR4SGYxT1ZVREpHTXo1a3IvU2owbDd6WTJuRkd0ZkpC?=
 =?utf-8?B?cnBEc2VCOUFzNzQ1cGJFa0tocEgwVDlobXJXbDBWR0w1YTlldEh3YmNjTyt3?=
 =?utf-8?B?WGU1dGIvMXBpckl6d0VoR3VmNjJGRW9SRi9pZmloaUdiQjZqZDJlVmE5a3N1?=
 =?utf-8?B?ZEkxaXM4QWVWU3d1WllGbUx4d3ZrZUpIQzFaQW12WkNmVnQrM3lLTlJRZm1t?=
 =?utf-8?B?YnJ2ZFQyZnVUeG14K3R6bXVySVI3eEl5TmZyNmhPaGw0bldhZVNFMHB5c09S?=
 =?utf-8?B?UnRxKzZtV0tnVEZVMnFJQzZlc1M0Z1F3aFNzOE1DeEU3aTVuZXpESnpQRHl5?=
 =?utf-8?B?SW5Pb0ZnNGhiVnFGck9FUnQrbm4rcVlZcFdWVWxhelpENzZGVk03emFCaTRE?=
 =?utf-8?B?ZjFLRWVsQ3JlbkJodldpdFRRa0ZoRktLNjhQODNLWEVyVXZWbVFSOEcvb3hM?=
 =?utf-8?B?RkVhL1MwamdzekVMWkY2WFNLWWhhQTc1MWRZN1d4Z1RzcnBBWWZJeVpyMmhB?=
 =?utf-8?B?MlU3ZEV6UThOVmEyLytyanlQSUlobDFFeWlvT3RhODM0a0ZvZ0laM2xPZnpM?=
 =?utf-8?B?Y1JmNkFxUzhWRnZnWGpRNGlETGF0dDV4RjRZMFU1WXhQZDlid2FaT1VyM1A4?=
 =?utf-8?B?aHRKTzVGdmpiaXVUbVlYRWRVdHUzMUpIOENPa0NuM0R6bFZ1eWZqVjJvVXBD?=
 =?utf-8?B?aU96eldiNzU1UUh0bTVRQjhpMkNtQjcya09VTVlzZlhCN0l4UnVKRHNndHYw?=
 =?utf-8?B?L1VXdmtHdWowa2g0MXd2N2ZnVVY2MCt0Q3o1c2haSFlZL3o2TUp2ZjRjVUY1?=
 =?utf-8?B?SlEvNnN2dTRjbDBBMExuV3RVa1BIUDhwUVhiaTE1cUdIR2x1Qmt6Nks2S3lZ?=
 =?utf-8?B?M3Z0QkQ2ZlZNbG8xQ1lSRE1STjUyMTdkbFFSQlFhTitYKzh4U3JUUUdLNExT?=
 =?utf-8?B?TDR5SFB2L3Y1dElXaDJzSVFNVnAxcDd2bGFhRTgzWTFDRVFoMFlEUVh3SEwv?=
 =?utf-8?B?WmNWeGlEVVQvQ3lHZmZLSzlzQ1RzOFNkZ29kUmh2aXp6YzlkUDVDTmJtZ3hE?=
 =?utf-8?B?TjdlZlE1VjNTS0lIYWgvUDhFNGdsdjJQUE1veS84Z2hFRGhzVzRxSXVYSVZr?=
 =?utf-8?B?MVBRUmNndjJPVXZ5OFJMWGhOUlF1RDZFWWdRZkkwQ1VlQlVvR1E2alR0VzB1?=
 =?utf-8?B?WXBkRWhCY0YyYnJ1cVEwOEh2aWVOdHBxbzNyTEw2ZzdWTnZTekdBWkswa1Ni?=
 =?utf-8?B?cXU5eTlKVXh1SERHVHlRRllBenFMRDcwZ2trMU02ZGxrV2g0SVZQN2NHaVNO?=
 =?utf-8?B?UVVTOW9UOTd0d2hrL1A5OGlKYnJHK2x0OGtCb1dWZ3NIU1NTKzRINHlsNm40?=
 =?utf-8?B?QTBBY0NKK293c3ZnTzhnd1lvWVRyQ0hLbmVvc01CRFgrWmsyUEQ5UXdpVjho?=
 =?utf-8?B?eUlKazUwNHdsU0U3WEhIdHBCYWJ2d1VDb3pUMzJTWVBBaE8wbU9iSDVNY3Vj?=
 =?utf-8?B?bThBS3RXZitHaXZydElzcnAxcG9aRTZ3c0NVdjFPZi9IM09paUVLbjhiQTll?=
 =?utf-8?B?RzJCNkhuajhUbGtvR0orNnZiNVI4VXVtQldDakJQMlh3bk0yY3JPQk1rb2Rp?=
 =?utf-8?Q?HvnH8Sf5wUltJYyXgXXxz6I=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79853bf-e482-4ae4-3bec-08d9ed3e2509
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:09:02.8502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/3GkiSsOQTqaZTj8POF7IZqrNxn8+i9Uyux1wn/sNBCtmWgVAVuKQC8XrtwEcqZkb5OsYfbNUOOopcIK0aGhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/2022 10:30 PM, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0d3646535cc5..97c4f5fc291f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -873,8 +873,12 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  		kvm_async_pf_hash_reset(vcpu);
>  	}
>  
> -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> +	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
> +		/* Flush the TLB if CR0 is changed 1 -> 0.  */

                                      ^^ CR0.PG here ?

> +		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
> +			kvm_mmu_unload(vcpu);
>  		kvm_mmu_reset_context(vcpu);
> +	}

Regards
Nikunj

