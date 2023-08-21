Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B87823D2
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 08:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjHUGot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 02:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjHUGos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 02:44:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2973FAC;
        Sun, 20 Aug 2023 23:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFT5cWz59nlvnBmBS1auGWTIzwiPWhKWunVwQkkPTqU9OztFiwcl8gM7iKyeza8sP9TZfzKmHXJ306opGt3e57LS29YvRLRHrRit7+ykWWc6E7VEDug3+dJYxqoLOEpCLVBFmCat4fXCJbkm3kVDLrmfoB2/N+sIrvzXFEvdREaLxUyytvsEZJLcXJ9qg8VqAJ/drRsVDnp5XCUdd86UnxPtknVfuFbwLacid/XVxVRfiQ4HcN0RCKtb1dDD6LaggKvhR/r46NidddUEAd33ZZwzT/HeCP1IjNvHT0pvVl93nA61JW4Ii47GouAg9YZuzjBjO8bVAH+8RqM45ne8Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBTpXBm673d+bxjO7V+XJfdWEaMeN9v2xHEe4VIvvA0=;
 b=niNxSdaiOliGXYyXgClIBSKqfrT5WlJATtH9f/886qER36DtlnKTxeR5/UHr218iP2G430JJ+KAhtvvtMiONOl8TJ7x8spDo5b7NgAqpB2m0V7LC8ywSc701IgqGQx1g3MO2s9m5Vn4AkFT2Qikg/rScTq7jdvJZVcLuypeaHFV7fh9J/d13aFS3U7WzdYB3/zOOhPxsZEYDn/HNBhLV0gLK3UhpYQsxxPLuQzalBA7leXKLnI949MQBAnI7fhniZKVVVKK3RU/01G/MPkSfZDH4qRL9i2g8hPVRlVrDO5DekSoxbFXUFa8gOC7AnVYhTS20JHoZ7X7XpuWD4bs9eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBTpXBm673d+bxjO7V+XJfdWEaMeN9v2xHEe4VIvvA0=;
 b=QhmK1KZSvc+IYm5sDDiZcWxXccTx9g7Cu7eDg4pof8peAc4m2mRrp0TpJptWJiY6E/Q0OF6IzN2z1mwZjrowXz+y+MCotYjpbM2qZ/xLiHDh8yVcoB+fHEfSCwHn55yftJowtNvL9cZn3e+pwP/vM/c8PkFv2fjgt9GgD+WkYJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.24; Mon, 21 Aug 2023 06:44:41 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c%4]) with mapi id 15.20.6699.020; Mon, 21 Aug 2023
 06:44:41 +0000
Message-ID: <0b37f490-a8c0-d8bc-bda1-fcb04bd5c221@amd.com>
Date:   Mon, 21 Aug 2023 08:44:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
To:     Steve Rutherford <srutherford@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230818233451.3615464-1-srutherford@google.com>
Content-Language: en-US
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230818233451.3615464-1-srutherford@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0228.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::12) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|DM6PR12MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: e8abcc5d-71d5-4479-07a9-08dba2121883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AuVRuNzL3pnTj4bhrjUhElaxyyM+kKdyVxIINM7mcPla95j9KYgAd9GTPv71PyBdybnoykpvZbDHt6bX3XiOpJ8AZGn3b4ynzp9G45AVbf5/l6En+Au/huzf+I0I0N6wnLBqbzqHBjf6JgmllTqvHTwMiLc5aGI03RbM6+4OryCadWntL7ia2oI9hc7Gl8IOtLF0zTvYyrbk38FXove1gvg7cs2q5oDnfJ5HMj4hxDSsr/ohHpD71Zvza5CFfKrP9Y5iLp+nXjPkVRN32G1Pq4iqLfum9YyEyZHkd+ouN108wu44mrq3IqKQOXMaLXhWW+oAYEdkZjsJr+UE+gT54mPClKUO3uufImYI2jnJ50m3/Nux7IPlt5+5Of36rts0Oc+gXN2A1yl3dzaTfYyHCdb7EbMfYI5uWttSG0uEMeMbX5D06p4lBkli3AUP6ETOS9182fUYye0ZbXIG9IiB4b51IVDSuNqfCMdRhkv70al1UBDOGwXki2iFVa6cxH13h3Nzr5wQ/s002fOGVBaCqgSnxGw0yyStrCGuUopKzex3TSywsTSZMpUoYOZEnjTRpus0ysftnavrPCVnoRe8q02JksC9vmUXQvH4T2TCaE74xu+DPGYze/K2BC5lDftIplty30jTa5UDU+cwmaLiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(346002)(366004)(39860400002)(186009)(1800799009)(451199024)(54906003)(66476007)(66556008)(66946007)(6512007)(316002)(110136005)(8676002)(2616005)(8936002)(4326008)(36756003)(41300700001)(478600001)(6666004)(38100700002)(53546011)(6506007)(6486002)(2906002)(83380400001)(7416002)(86362001)(31686004)(31696002)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEdHYkx0K01lSnRaQlVWbzNyZlM3djdhdzd0MGdPOGZrNWZoaXYwSENNaWZa?=
 =?utf-8?B?VUpvZXdkVmRURFN6ZDhGWkVZeTUyQlNsMFVtYXIwQmp6ZUhRcnZDRmMzUk9R?=
 =?utf-8?B?eEVtMjBSQzZzUmJ2cDN3VUk2ajM1ZlhzdEFidlIrOVlPeTc5MFBwSm1ONHNX?=
 =?utf-8?B?Tldta3VqSkdTTjRPQXVJcFcvamg3UmZ6b1BZWUt1bWRzUTF0cTNvQ0RKUU5p?=
 =?utf-8?B?bEdjYXRlNzVYU05aeFlIV0hXSjFXQlZJUVdncG9WTXQwM3dwL0NNYmN4VFZh?=
 =?utf-8?B?OFlPejNibmdTK0FLSnhldXNodExoUmJDWWtmZGlYQWYxeWkrMkdxeDRVVFlD?=
 =?utf-8?B?N084SjVnVXJRRDNXTjNxSlVqM1FvaVQrMWs2cElodGdSNkg5Y1dvMVBwTmpR?=
 =?utf-8?B?QmZuZk1vZE1iaGRiU0k5VGttR3ZFWWVqSzhhYUZjR1BUbyt6WUpES3JoSlNm?=
 =?utf-8?B?M3dhTGx4WUtHMmJIWXlNZVJIK0xla0lVYnlKdkYwK3VRRFBMUEwxQjMzV3lx?=
 =?utf-8?B?NExRRURJRTNZNXpCcmRiUWx5UDRDSUdCdjJyMkh4UkhpQXhOazZtMkZ3Ylp5?=
 =?utf-8?B?VERpSjZQZXQ4aFBEcnloSjhrV09hZVBLcC9jNHFWTE5YUHE5N2lZZlgyRi9M?=
 =?utf-8?B?ZFhGZmx1ankybGg5VmowOUxHVGNVTUJ2aHFPNE1pODMxZDVxaXdQVGVQd0dE?=
 =?utf-8?B?bFdEcnRBajZWRmRvNXAzK3Q1VHMrZDNJNXY1ekM0eDFrYkhXd1JEcWhsa0dh?=
 =?utf-8?B?ODk2NHo2eWNvelZORUJFa3dyREUyS0lGZzlBQS8wT0M3bzUzUHVWVHFSRW5k?=
 =?utf-8?B?aEpPY3NVQUt4VlcwMlBnU215ZXhLdVFsVGZ0SzJCUFFTRHBMSGJSUzk1QUt6?=
 =?utf-8?B?RjFMUkVwdXhYSUROREs4OWlmbHpqdENPVWJqbGhhNU11eTQ4L1dpQk5qNmox?=
 =?utf-8?B?WnNXZFFURjhMcmZTWlFYZ2hVb2hVMEJKbVROaWUxYWx6NmFiOHJHdWxqWkZK?=
 =?utf-8?B?R1Z5TzB4cmQvVEY2K3JPSm9pcFpkbXkrc1E3MFdyVjRva3MxRXpxOE1FbGo1?=
 =?utf-8?B?NDNSdGh0Qm11NE1MWGYyQ0gwNEIzR21xMGYzSkJydFhMeUtyQWZxRVA0UGtH?=
 =?utf-8?B?bjlZN3VBcnpaZ0JxRFpSOGVUNjdWTWVnUnVTV0t2ZjVRT1lXYlNFcnUwNXA4?=
 =?utf-8?B?YmR3UlAxUW85YTVLMzZGNDFDUUN3UW9FSGVuSk5Ha0hrS3dPTjVETFR4dG1M?=
 =?utf-8?B?a0RoR2V3MFJjbmNVNzY5L1RabmpPa0ZmTzhrWjlYUnA1cUlIaGZqYm9tL0Jk?=
 =?utf-8?B?RVNwWXk4YW5EWTRJd1VYL2JCSXVLZXRRNFVqVjVZL2ttRi9DS0U0WngwQnpQ?=
 =?utf-8?B?cGI0aVFKS0lDcW9lWG1LeFhMendRcitkR29VZkcxQkdxRlB0c3BSUFV0WG5m?=
 =?utf-8?B?NzcyRDlmY0ZYZlZwZHBVMmlrMTFjSGR2cWRMdDdCdkpHZ2NSS01WN0wvQXVP?=
 =?utf-8?B?c0lkRWR1NFdkcENMOU1LMVZBK1hCSmV4QmZOcFU0dzV4ekY3YU1kcjZnNnFZ?=
 =?utf-8?B?MzlHL3lPbGpwa2l0bllUaHBxY1RwUm9CYm1IamhvclJNSUZPTU1XR3lBWUxa?=
 =?utf-8?B?ckY5cm1ydk9vVitNMTY0MFRBWWdXakxsUnlXQjE5ZEpGYXUxTCtXR3ROc25H?=
 =?utf-8?B?TXdBZklEL05yMklUVTZ3U0hxZllyVWlmVlRSOVl1RVNMUC8vQ1JheVNidnJN?=
 =?utf-8?B?UC8xY2tUL3RVTDV5WjdkZUtkT0JJTjdBL0RXV3RsZjJFcVd2RllIM09xbEFS?=
 =?utf-8?B?V1FURTVHUE9ZbjFxKys4d0tsN3plUG9Rek5NU2QrMC9jR3ZsUWl6WVo1b2Nv?=
 =?utf-8?B?OG4zY1NoOTEzUGU4YVBmeE9VSVI4ZXlwRmxDdjNhSTI1Y1YyRFNDSDZKejQ0?=
 =?utf-8?B?czFUcmp6a1AyVjFkRG5WMFdxQUNvaG4xNWxGWTV5WFlZYW14MEFuK2ZMYkFB?=
 =?utf-8?B?K0pMd0c3Qk5UMHBCQ3Yvc1oxd2pnMksxQW9aOVl6N3lETFBTdFN6Z2tob3lV?=
 =?utf-8?B?UTU1cDB0cVRuanZ6b0ZWY2FkZXREeWI4UmhvR09XV1k2cTN6TkZKWnNGdlhV?=
 =?utf-8?Q?YROWZodYK9WXzgSMaI2GAgq/k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8abcc5d-71d5-4479-07a9-08dba2121883
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 06:44:41.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rP2J55cHLlIVb3JS9vLEoCoQnB+w5f4FuUMUACg6nhoVTWLRwsYrLYk5krntucXR8TginKO76lKSwnDjRQKQOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/2023 1:34 AM, Steve Rutherford wrote:
> early_set_memory_decrypted() assumes its parameters are page aligned.
> Non-page aligned calls result in additional pages being marked as
> decrypted via the encryption status hypercall, which results in
> consistent corruption of pages during live migration. Live
> migration requires accurate encryption status information to avoid
> migrating pages from the wrong perspective.
> 
> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>   arch/x86/kernel/kvm.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6a36db4f79fd..a0c072d3103c 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
>   
>   static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>   {
> -	early_set_memory_decrypted((unsigned long) ptr, size);
> +	/*
> +	 * early_set_memory_decrypted() requires page aligned parameters, but
> +	 * this function needs to handle ptrs offset into a page.
> +	 */
> +	unsigned long start = PAGE_ALIGN_DOWN((unsigned long) ptr);
> +	unsigned long end = (unsigned long) ptr + size;
> +
> +	early_set_memory_decrypted(start, end - start);
>   }
>   
>   /*
> @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
>   		return;
>   
>   	for_each_possible_cpu(cpu) {
> +		/*
> +		 * Calling __set_percpu_decrypted() for each per-cpu variable is
> +		 * inefficent, since it may decrypt the same page multiple times.
> +		 * That said, it avoids the need for more complicated logic.
> +		 */
>   		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>   		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
>   		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));

The fix looks correct to me.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
