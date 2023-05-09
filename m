Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE576FC461
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 12:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjEIK7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 06:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbjEIK7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 06:59:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAB7DDB8;
        Tue,  9 May 2023 03:58:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtBqgdDE6Fl4FU4RifqB6hf/DxJRpqVsgmZ/LJLGzC3ALkJSgwmdfRlC8uZt1gOUD7G7ZFHnQi3tLPMJ2RtPA4Y1FkwG1rt0SYstj+ekrZhzHfBvB4tn9yAzTYfv91n2JXhTVbTWBmYRttH1Mn+8qX4gjJh+U63FSt0C1hRUjH2nfIHQlT1WW1MomrlzA0/WwHH2/2/pC8XVxPMVnjZ6D79+9exbQY7IwBxOITSRxnjx9ya3OMIVx4HW6Th1qtQbcWbvVxjk85QKQfGzK7n7CZ2GykUL9xpBco9ECSyUuzbwFl7kBBBIroZIOxAocLcUyOB2437Mu4PBhqWme1hibA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4w2txgUq4i/TTwciPE6PE8RMegXxB9HTk8oqkveLqj4=;
 b=TlVC1Lk7/AvArjOsQZOcTWlLrsl1Tg4DZJbNRv0hVOcAFf0jTOEKQyACOMzYIXNd7D+HnebwDF8ca+0i7nwZRQuoz9xTSHGdRVbOGhODIxYbjk3RPzyBMWloINRaoi67ewz3kIet39ZDqGqYy75S4pRVOxU+K3lIGt5cnfdZENvvrHEKkhtOtLuowDUxsFnp/RNl0GLyLVqk5lGfSZrIZfu246FS4v/mg1pWN7QiOYFGQKfdoNb2t/H6gXybRLUoVWJb8YBlS0a8RLI/HPtWhakRvR+W23PNQMI+r4MHtV6KHCGRnX6pgp1KBvfdjw3EH4OKgfo5Era5Xhrhqk24zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4w2txgUq4i/TTwciPE6PE8RMegXxB9HTk8oqkveLqj4=;
 b=BpOi3r/+X77pE6A+zRCPCtd2Z7b9izUwxa9LUvU/+r/wNYaXbqg30L8fr7CF7IjBRw+AVHaFWkgUVAu23NQKUtqo7Oi/04oE8SwbIerQzJE5hQka1JLkDBFSfKru0/bU2UsIRQPXQSSG9DYgpTP8HMlA8zReD+xGRGQRYkioCtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 DS0PR12MB7746.namprd12.prod.outlook.com (2603:10b6:8:135::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 10:58:44 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::f8b0:cf29:9e21:380]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::f8b0:cf29:9e21:380%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 10:58:44 +0000
Message-ID: <be291727-052a-7e0c-64a0-0950e1c8b44c@amd.com>
Date:   Tue, 9 May 2023 12:58:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com>
Content-Language: en-US
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230411125718.2297768-6-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::16) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|DS0PR12MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: d4f3228c-0d45-474c-4ec5-08db507c5b12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tg2yKA9Tviv8iX4v6z/Hr5z0ZEfjAI0M7ot/DxDS0lT5ns2EpCBPhMF7InUpiHOrFB8kGxFVHJxqtvgP6REfH7jUbquzJ1b0dh3noJ+HUPVIqD12FOpJ2rYSfFTZCqZZKslzFlF/Se3Sk9OKYH4Kn6zWWaY8EdatBJJaxgyscGJuPpjeD40KOxaoWEW02M/IlE3W3GwOJhDJb0MJ/hrlPMcZIkj579t6quUeLAGUcMBds5f54nVMRZivqEEY7OdNtUca3hjq3XZ6i3v2uNdBezO37yT5M9NSuOVrLki9ewEjiBlbubU0MtzR+2GZtjStER7bvSeMG2T4bCfPMG2iXJsD7XUrToEhGMDEOnozzUOv8vBGInW3MN9EtPExnjBio1l6TpSCyBhzd1HzLzjlX8fXoO6FscPiPa71Vip6zPTEUGRC3X5Ta/U3poVMGnYfBRbWpXuXkF0vkKGb9BzpP8+EGs0p3fG9lOWbxRdvNWVQ9cLoAHmgdYuNv73FfVEl9W3oiHf1xFSWfWU0X8+FpvB7dpbFfPbySl3FrVe1ai7wDkn8qDlHAApCT4IN742OzwXeqW8dwFsjI77Jrsp0F59tCPdbA6cbz5mHutmb6DuvXI4iaHWjGlQtZwEOljsDvqeGDosT+HyrNne8SPROag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(6512007)(26005)(6506007)(6486002)(83380400001)(36756003)(2616005)(31696002)(38100700002)(86362001)(186003)(478600001)(2906002)(8936002)(54906003)(31686004)(66476007)(4326008)(5660300002)(66556008)(8676002)(316002)(41300700001)(66946007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1lCcXdDSmdUVnd3azM1MWZmZEtXR3VCVm5kWXJCUndqK1JJY2o2OTM0aXdW?=
 =?utf-8?B?a1hoQVNuaTRTUVBPRWpNZnpSWHNQM1hsWUVnYUVJUVNGd3RObXpFWXRoQnVK?=
 =?utf-8?B?MXh6RnBaUDdySS8ydWJic2cyZHpHMzZZeElSVE9CS2dXTnJvdkJXL01CbWdm?=
 =?utf-8?B?WTNyUXpaWnhMMnNzN05LREtzRlFsd3hyVnlXc0d2Nm5LRTZianhWaXNBY3lB?=
 =?utf-8?B?ZWtKSkJmemlTaTRlOFZYNXdmKzhDTk85S3ByQ3IwYzJXN3BBTXNUS25FNzkr?=
 =?utf-8?B?bHRsR2ZBYWRkN0NVSENvMktmY1Q2UUFoU1I0b2pvOU93emcwQlVqRlIveVJ5?=
 =?utf-8?B?a2ErYlhVWTlCYWpTWk04Tms2NE5GMk44TDNzMGIzcnRZQldvM2xxS09FYjNs?=
 =?utf-8?B?djRkc1dhaW5iUlpKNWI2b0RtbmxpWTZKYUNJMUxkWlNFN2hTSUhpS09KY0lJ?=
 =?utf-8?B?NHFRNERiZFpJOXl1TkVlN0NQcU43RFhhNUdmajhHNEcwWTgwZjdmSXUwUGho?=
 =?utf-8?B?dVJnTjFxVjB1SVBRK0M0RWViRVVpSDhLSXA3SXhqRXpaNUFtTktCVElPZzdE?=
 =?utf-8?B?aUNNUE44Wks4aC92NWtsYk9yLzdrcTdaeDAzT2JsNlkzZ3BENWk2dENaa3M1?=
 =?utf-8?B?NHMzaTZteXVFckJ2QnF6Yys2QS9HSHFzVzY0eiszNUZ3d1NpMzY0eG02UjV5?=
 =?utf-8?B?MlNpaXMydVNIV21rbk9pb011QTNQbXl4T3FMZ3BsaWJXcTgxVWsxdWNCSEp3?=
 =?utf-8?B?U2pXOTR1NlJWSURYb0svOHB4N0NTanp6ODVMNm9FNlVPam10VHBzU1hVUDBY?=
 =?utf-8?B?N3RmNmhlMzJUa3ZpaUxaWmNUTHlqVm11alBOdkNEMGVGaUVXSzhINTNKa0Rm?=
 =?utf-8?B?TVB2bThwT3U0KzBzZDZWd2RUTlRENXBleGtCWXhaN3NPNW5XTHhiaFdKVkF4?=
 =?utf-8?B?Y05CbkdCT1JwSXl1T2hPKzRNQVVvZ2p1d1V5WGFaaDhNWEFUd01jbVpjMjJG?=
 =?utf-8?B?RkxzVlE3b01zOHdhNWNtbStuN09VTUlZWXdOdmwzYjJTTGVneElWRmszSGh1?=
 =?utf-8?B?RjQwZ0dVR1JmcllSUG1EcUV0SlV6MXY1bEt2RjBwWkhISzdwN1JIcDNSQzZL?=
 =?utf-8?B?Q3pZbEN6YWlTT2RRbExLZWhYN3BJSUNKYndMVks4QU1SYU4wMkF5VWNrU1Jx?=
 =?utf-8?B?NUNoem5RWGRFaDAzM2E2QTd1NVRxczYzR1RUOUhGeUtGQVNNYWJQNFAxSXJ2?=
 =?utf-8?B?anczYm5QNEkxWVE3bTZjV0VsYVFUUG04Uzl2K1ZYbzg0dWhnakJFdkZ1OVMr?=
 =?utf-8?B?dUJVb0RMWmZvRTNIUVk4UTE5aXJNZVVGR2JwM1JidVdkNlY5M1RlV3MxbW9N?=
 =?utf-8?B?RjZxT09ZT1UyTTFhVERHNFU4TVp1NGlEQTVBOXI4eHRDc0hYTEFVSzlkc1FK?=
 =?utf-8?B?WWhyNGovakp2QzIxRkJzZjVuQmxHcmpVeTM5UmtNV3A4dXJvMTEwUlVvTWRo?=
 =?utf-8?B?dUtSSVkwWnZkVS9QMWpuOWNseWM4NzlVd3lJemRqSWs4dHpKVHQ1UFlKQjRB?=
 =?utf-8?B?c24vL2tZMnhOUndNUmtjWmR3cUQxeDU4bldiUDF2eVJySStObUtjaytEdFhU?=
 =?utf-8?B?bkdGTE9lNjFxM0ZScDU1TUZOZmRUSG5jOU9VeUtOamRKcTJZdEM0a3ZGZGNR?=
 =?utf-8?B?b3d0WFc3dFFhZmNzaUhqeVBtVFE1ZlhzSlZKb3BnMktpaUFzN3Q4eFJaTnpL?=
 =?utf-8?B?cjZUNzNzMjdTaERsQnYrWnVxSTdPWkpZdGVzcmJBczhZNjlEbG9zMlZJQUZ4?=
 =?utf-8?B?aFNmZUhKdlpOTHNjNk96cHIyYzdpcndiMlZIVk1aeDZ0Yzhhdno1QmpGcUhy?=
 =?utf-8?B?Q3B4VnJ5bDZvOW5pNU52dXVYdEQ2Z2J2Q1VSSFUzYVd2YkZNdFRueHBtVVJv?=
 =?utf-8?B?MFdEeFozTlFRUWk5NVJpK3F6RWNGNHRhNVdNZUI1czlSai9vdDZNYndaTDl5?=
 =?utf-8?B?bExRMkI1YjgxRFV4THNBQVhicnpGYW51ZmpZaFI2aWR2cDZOSWg0ODRJM0hP?=
 =?utf-8?B?M3pLUE82dkJKbEV4dU1xdm5VTHVSSDZVcm5MazVyYjcvS3QrTzc1SW1xSXRH?=
 =?utf-8?Q?tbb6895ph68F9OuTEXlLx2QeC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f3228c-0d45-474c-4ec5-08db507c5b12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 10:58:44.0398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEH/7LH5/DgH3sjpYIYmlP3L2ODyqpxOpeJlGuV9AbPIys5YRLUBXT6A5vUgCMyTyqMELJKzAZRVpMWBVPfuEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7746
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Prior to SEV-ES, KVM saved/restored host debug registers upon switching
> to/from a VM. Changing those registers inside a running SEV VM
> triggered #VMEXIT to KVM.
> 
> SEV-ES added encrypted state (ES) which uses an encrypted page
> for the VM state (VMSA). The hardware saves/restores certain registers
> on VMRUN/VMEXIT according to a swap type (A, B, C), see
> "Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
> volume 2.
> 
> The DR6 and DR7 registers have always been swapped as Type A for SEV-ES
> guests, but a new feature is available, identified via
> CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
> support for swapping additional debug registers. DR[0-3] and
> DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSwap)
> is set.
> 
> Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
> supported by the SOC as otherwise a malicious SEV-ES guest can set up
> data breakpoints on the #DB IDT entry/stack and cause an infinite loop.

You mean #DB => #BP here?

> Set the features bit in sev_es_sync_vmsa() which is the last point
> when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
> init happens) is called not only when VCPU is initialized but also on
> intrahost migration when VMSA is encrypted.
> 
> Eliminate DR7 and #DB intercepts as:
> - they are not needed when DebugSwap is supported;
> - #VC for these intercepts is most likely not supported anyway and
> kills the VM.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> Changes:
> v8:
> * added CPUID's DebugSwap feature
> * commit log, comments updated
> * redid the whole thing
> 
> v4:
> * removed sev_es_is_debug_swap_enabled() helper
> * made sev_es_debug_swap_enabled (module param) static
> * set sev_feature early in sev_es_init_vmcb() and made intercepts
>    dependend on it vs. module param
> * move set_/clr_dr_intercepts to .c
> 
> v3:
> * rewrote the commit log again
> * rebased on tip/master to use recently defined X86_FEATURE_NO_NESTED_DATA_BP
> * s/boot_cpu_has/cpu_feature_enabled/
> 
> v2:
> * debug_swap moved from vcpu to module_param
> * rewrote commit log
> 
> ---
> Tested with:
> ===
> int x;
> int main(int argc, char *argv[])
> {
>          x = 1;
>          return 0;
> }
> ===
> gcc -g a.c
> rsync a.out ruby-954vm:~/
> ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'
> 
> where ruby-954vm is a VM.
> 
> With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
> on the watchpoint, with "= 1" - gdb does.
> ---
>   arch/x86/include/asm/cpufeatures.h |  1 +
>   arch/x86/include/asm/svm.h         |  1 +
>   arch/x86/kvm/svm/sev.c             | 36 ++++++++++++++++++--
>   3 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index d9c190cdefa9..3a5eeb178778 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -435,6 +435,7 @@
>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
> +#define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
>   
>   /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>   #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 770dcf75eaa9..3a422d213010 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -280,6 +280,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>   
> +#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
>   
>   struct vmcb_seg {
>   	u16 selector;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f0885250252d..ba12e7962e94 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -22,6 +22,7 @@
>   #include <asm/pkru.h>
>   #include <asm/trapnr.h>
>   #include <asm/fpu/xcr.h>
> +#include <asm/debugreg.h>
>   
>   #include "mmu.h"
>   #include "x86.h"
> @@ -53,9 +54,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
>   /* enable/disable SEV-ES support */
>   static bool sev_es_enabled = true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
> +
> +/* enable/disable SEV-ES DebugSwap support */
> +static bool sev_es_debug_swap_enabled = true;
> +module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>   #else
>   #define sev_enabled false
>   #define sev_es_enabled false
> +#define sev_es_debug_swap_enabled false
>   #endif /* CONFIG_KVM_AMD_SEV */
>   
>   static u8 sev_enc_bit;
> @@ -605,6 +611,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   	save->xss  = svm->vcpu.arch.ia32_xss;
>   	save->dr6  = svm->vcpu.arch.dr6;
>   
> +	if (sev_es_debug_swap_enabled)
> +		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
>   	pr_debug("Virtual Machine Save Area (VMSA):\n");
>   	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>   
> @@ -2256,6 +2265,9 @@ void __init sev_hardware_setup(void)
>   out:
>   	sev_enabled = sev_supported;
>   	sev_es_enabled = sev_es_supported;
> +	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
> +	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
> +		sev_es_debug_swap_enabled = false;
>   #endif
>   }
>   
> @@ -2976,14 +2988,20 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	svm_set_intercept(svm, TRAP_CR8_WRITE);
>   
>   	/*
> +	 * Unless DebugSwap (depends on X86_FEATURE_NO_NESTED_DATA_BP) is enabled,
>   	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
>   	 * the guest kernel enable debugging as otherwise a VM writing to DR7
>   	 * from the #DB handler may trigger infinite loop of #DB's.
>   	 */
>   	vmcb->control.intercepts[INTERCEPT_DR] = 0;
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> -	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> -	recalc_intercepts(svm);
> +	if (sev_es_debug_swap_enabled) {
> +		clr_exception_intercept(svm, DB_VECTOR);
> +		/* clr_exception_intercept() called recalc_intercepts() */
> +	} else {
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
> +		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
> +		recalc_intercepts(svm);
> +	}
>   
>   	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
>   	svm_clr_intercept(svm, INTERCEPT_XSETBV);
> @@ -3048,6 +3066,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>   
>   	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>   	hostsa->xss = host_xss;
> +
> +	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
> +	if (sev_es_debug_swap_enabled) {
> +		hostsa->dr0 = native_get_debugreg(0);
> +		hostsa->dr1 = native_get_debugreg(1);
> +		hostsa->dr2 = native_get_debugreg(2);
> +		hostsa->dr3 = native_get_debugreg(3);
> +		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
> +		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
> +		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
> +		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
> +	}
>   }
>   
>   void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)

