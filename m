Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE945843C6
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiG1QFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiG1QFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:05:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9080A2A244;
        Thu, 28 Jul 2022 09:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jct6un6FqEBGFeEefpUuBy7XYycFDrTSla1YqUeRVv1F9zVsciii4afUR4bWp61Axy47nEcCBXvhCN9NBkIClZCfn74o9Kfj6g7mp/l0FKEoxSNxFbDpX5Fju5W6cZOd45wl9QZzVzdEGfwtnebe3FA8xx/zFwvQjVCXJpQICpYY6WShmBeKJISH9xgiddNGULEqwA79tLZG7XeVa12cud3sZMWsY82QBdELY17jNROPZOvQ1RZc/XWnRFnTuJnC0BMoMUSISiQ7BKPDuVX4+2i5gIYuS3KSJs/Gx5OUPq+LTbJDFLDle9q6wsVoTZGDXi9bP9/xjQTZMC7YBtwaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gur3G7YsPntA2ATFW/ikWxiAAOc98+Iu8b232Uai00=;
 b=jPueov4XioaZuxsPnZXQRx/pJc9k0i+3aKXTifpV5LHjEBdin7gQPnLnZv67YEiE88/isGV8VCNKMw15gUuigwUdoC32SH0H0nsCjNcYRGspymafUselLmaiiXJs8SO1JR+eMffQqaJyEFmmf4lVH1h/BRvOcaB9an7Rb0r4Snf7qGiiGYQq6V/ROI62KKM8XXX1sjewemcBc2YgqVyUhi09C4ro0+aEEkZcHG07qdgSb/4+mgx3DzSDeIP9UTT9ojwoKgsRi3mubFycg+5xAJJZLlzkkTu8xK22JIBHi5YTNsXTxTXxWkyYo83wxdNIoeWZgDPRXiQiOdEq+oiURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gur3G7YsPntA2ATFW/ikWxiAAOc98+Iu8b232Uai00=;
 b=mOFEJDSyT/AVAPZzlLxClGvYoVdbmt8uZ8YpbuzLcPDPEosYAcSnKSfILDXg3DSsGdP/2p4j7/x7dIncN6CN+g+vdmJtPR0/S0jN+d/4xtJMAkDeOhValJJ+9kIwx8Cim52IA7huNNwhi3HXwzi81PrY5WIoXeXYreJgd1kQ9Ow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MWHPR12MB1149.namprd12.prod.outlook.com (2603:10b6:300:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 16:05:30 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%4]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 16:05:30 +0000
Message-ID: <43a2f4c3-9a3a-6b4b-abfe-04f392db4cfb@amd.com>
Date:   Thu, 28 Jul 2022 11:05:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Possible 5.19 regression for systems with 52-bit physical address
 support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220728134430.ulykdplp6fxgkyiw@amd.com>
 <20220728135320.6u7rmejkuqhy4mhr@amd.com> <YuKjsuyM7+Gbr2nw@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <YuKjsuyM7+Gbr2nw@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0046.prod.exchangelabs.com
 (2603:10b6:208:25::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f764f823-8acb-4796-e667-08da70b2fe92
X-MS-TrafficTypeDiagnostic: MWHPR12MB1149:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rM38wwkgBib4MrocnGEFCbTASPU5XYLlxZirApurO+rSWsoGS8a26QwGBIlSuzyP4qOPb61clSUkzOgWUkhN85S0Q7QKM0ge5JKV47pBJTnALo3yJc8OwnlGJFsevHaL6JU0KXexe1kDhmW3KRfYWpFM+S71EENF3ae/YprcDeB/0SbXym26LMXZ+7JSUQfvgCQScxeL57BP9XteikPdKbbjX0f6Lkp++15n3oyUAZe89NXHHNfGYvtuJt3ADHn808SO7DLYdLfbCmcT2NvvE2IbumYKLj9Tah8bC+qqSJPjEjQkggbgndnvpZomDwogzsZCoSdWgtwCwr+lJYai02TpjLZaNkPQdXCmLupu0CBD60C+5+Sep52lI6NR9E1ziLumQIwDlIP68no5N+WmgUpCCbjnEVqWEW9ZYz+olP2sz5dvTKaxR6JApcb4nJrCecCmI4EWSJ4bGKVM6+WwfO3JCo+uQBJcKDot5JhPbGjwT2mbSX1OUGXk7MzutsnuqP9IziRVfpikNBGmNhBKkllmM0lwwLxkIKuCP+Rh842ZOjw33ZtkP1OqCDChvWQ0uOL8OorQtdSYuaYwr3cWSBfLP61MI6wnKzELfDV2lBxfQq+ghWkwyFywyBc55Gsgoor3Kj4JJgfdDjf+UJi6f1OKqQ4j0cO6FYBihoet45slFuVW6fDchoTbyKSQCBnEt3H+6v+zaYjBhxROtX3W3VH/uceCVferFsl2f2iq7aqUIll3vSoQtADd/30epyXCWofgRA8strc+9357sOSZgVYpSap2L4yWteuF9jO3HnHiW02ssKskZrm5iz8z1Mm1cxxZU3ZxJdKBipNUwDm9BYKEC8MjgoGyY99isC0as3uFihvCu8r/n3lPK3DgzWr9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(4326008)(8676002)(66556008)(66946007)(66476007)(38100700002)(5660300002)(8936002)(2906002)(478600001)(186003)(83380400001)(966005)(6486002)(41300700001)(6512007)(53546011)(6506007)(2616005)(26005)(316002)(6636002)(110136005)(31686004)(36756003)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU1BdG9IUllDYW1qS1B6M3lrMmNtbndnQ2VmU2EwcjdYbnNUYVBxUE01ZW5u?=
 =?utf-8?B?TlhkNEloVHZ4ZUhyeGxoU24rQVMxdDFUcGxweVgzK0N6cmdES243Tjd0dith?=
 =?utf-8?B?Ump4UkYzTG04bG8wMVFkUVpBZ0tFTzQvUzArZWJ6UktITnNVTmVsVmRpTXc3?=
 =?utf-8?B?TUFyQXUrMGZDMUZXcDdtaStyaDFtWG95OXFobTRjTjd5YjFHb2VDZTRtK3VR?=
 =?utf-8?B?NXl2bUZQam0xWDNYbTR6LzZ4TU9aeTArRDd3Nyt5c0txSWdlcG9MbUNCTGtS?=
 =?utf-8?B?Q3hSc05aZk9OUTBjU1ZRR043WmxzNUJiK0R2amlza1hyTUdqeWdGMGJaZGVw?=
 =?utf-8?B?SmljaE9CSmhDU1d1VlJRM2lLYlZsUnErTmI1RE16QTRtL1RpUUtnQ1N2b3c3?=
 =?utf-8?B?VVJxUGM0bnBhQTcwN3RJMnpDNnpxUHcrRlZkWTA2K3RlVkRKc0ZlMGF5b3BF?=
 =?utf-8?B?RXV4SnhRdEl6b2hWUHkrQ3JUQlF6OGkrY0VnanJUbUwyUm9McFFlUHN1Wmcw?=
 =?utf-8?B?QURrT2xLaG5ha0dGd3Y3eENTWVdNREpCVURCTU9rN2xMaGlqRm9MdHJMd0Nu?=
 =?utf-8?B?VHhBNGd6eURVUnJWWW5qaVlYMFk3Rm9UeFY2cm5zZmlqZUJsaDNodkdZOUh5?=
 =?utf-8?B?QjJHdm5MYjAwU1dFcEdDZWtrZFFNejZuVTBNb1dnMWh6UjNuVjh6UkNVcGJX?=
 =?utf-8?B?MjA3RzZVTEZXV1U2eG5pMTRFMnRBL0hsdHhBdFFPdm5oM2xjN3k1MUxSTEZD?=
 =?utf-8?B?MElVc25OSGJqTUF0MjVjcWtNOWVPUkFEcHhiVHoveVNkMU1hK1QwU1diTDV5?=
 =?utf-8?B?ZUJZWGdNenZLNjZRejRLaXROWFJ1RDN1Y2RJSGdSYmFUQmdybHNFNktTUXA4?=
 =?utf-8?B?THJ4R0FQSXpGMmdVODgrNzU5NFp3T3BUMG1JV1NJek9wM1I1QUhUY0VKVzA2?=
 =?utf-8?B?ZENvYjR2RnlRMzJweUx0OGFOUHkrNStEYVZEZEFEa2RCNkJwREU3Y3hpbnF0?=
 =?utf-8?B?RFNXRGhxRzFwVmJyelFJVW9kNmhnbTUxaisrWXBDSmcxNlh1QmxSNnVWVjNO?=
 =?utf-8?B?QzhsSHRraTFPYUcxVjZGWXJoSVdDRVYwSXlCSFFOVWZMSXB4SEJwalVxZVZu?=
 =?utf-8?B?cHhDUnpNeEliMERpL0hEemZUSllDTnBlQnFBVk9yb1E2dUlGUGZidmt3UnZP?=
 =?utf-8?B?aGE4d00wa0QzNmlZbUNIUEhiTXpsdkh5MUJYYnRTaUxkOFdQaU40dmNSRHBR?=
 =?utf-8?B?NWFHUVBOeE5rQ3JuVzRsU3d3cms0d09VcTF0VGpXNDI5QjhTc3NsOFMwckZ4?=
 =?utf-8?B?R2J6d1F6L0U0ZG54ZEIyY3p6bFJSMEErRUxYNy9Za0c1cVBCZXZqcmZtSHB0?=
 =?utf-8?B?RlFpU1M1NzgzYm5TeGFrYU9XZ3VqYXZkV2dGWVZZZkZCbVROZ0Vpejd6MTZF?=
 =?utf-8?B?dnNMK0V2cUlrZjhtZTU4ejdkYUNBVHJFTW5XN2kwVWlZbVlDZTZ6NVNDbFl5?=
 =?utf-8?B?SVhQeFY2Q0d5VVY3K1ZXTEhRbEtHTGNhZUcydXVIblJpZ29qckkyOVA4ZUp6?=
 =?utf-8?B?RnJtZGc1UnFHdWErV21ydFBtZHJvMXkrUk1sZUtuYnVnMWdTelZTZnUrMkI2?=
 =?utf-8?B?T3dOWVZ6VWp3QmRhdnNUS2FRSlhKNFRQeGtEVnB6amZjb0VXL0I4SmJ5N2dN?=
 =?utf-8?B?Qk4vSWgrcG1qNnRyWXAwT0VXYUhCTkFZSlhJMTVFdnY4RnVvVlkxQ1I2Kytn?=
 =?utf-8?B?RVpKOXBMWlVya0ovMmF4MDIyVmVpb0JwOURCOGF4QWxpa1NPN0dIZWdQUUd6?=
 =?utf-8?B?VlFsR01ieTNJQ2FISWN4dnF1VWRTVzk2UW1BT0M5VnFzWVBVcVB6RWVuS2lG?=
 =?utf-8?B?VlhmbVhsandES2RMbmJYMVNRbVZueHAxMXhkaGFrRGorSTdZd0orOUxpTk1p?=
 =?utf-8?B?RUZsYytzYzlvVXJoNm1oWXhzZXU3YkdiY0VDVE9xYy9KV3pkMFlSMkVnQkpp?=
 =?utf-8?B?eE5KUDBPK2IyelF3eGdkcjR1NTBOdVQ4WVJ4QS9GN005TDFWdUFnTm5paGFv?=
 =?utf-8?B?bTZ2Z1Jvd3BaU1BxTWVrcUI1N1V3RUU4MkMzWG5TWDVaazJjMEZwN0VyMjNX?=
 =?utf-8?Q?7zoDGGYay+/oil9zFAWo3wu0I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f764f823-8acb-4796-e667-08da70b2fe92
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 16:05:30.5125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6OqhJM7KpISD0r33mQ7ACIYXAeH3URUUJNjHzYNPTKHkh9SB8UNdNFEV6KR0CWbULbWISgRcX6nvwmUX6JUtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 09:56, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Michael Roth wrote:
>> On Thu, Jul 28, 2022 at 08:44:30AM -0500, Michael Roth wrote:
>>> Hi Sean,
>>>
>>> With this patch applied, AMD processors that support 52-bit physical
>>
>> Sorry, threading got messed up. This is in reference to:
>>
>> https://lore.kernel.org/lkml/20220420002747.3287931-1-seanjc@google.com/#r
>>
>> commit 8b9e74bfbf8c7020498a9ea600bd4c0f1915134d
>> Author: Sean Christopherson <seanjc@google.com>
>> Date:   Wed Apr 20 00:27:47 2022 +0000
>>
>>      KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled
> 
> Oh crud.  I suspect I also broke EPT with MAXPHYADDR=52; the initial
> kvm_mmu_reset_all_pte_masks() will clear the flag, and it won't get set back to
> true even though EPT can generate a reserved bit fault.
> 
>>> address will result in MMIO caching being disabled. This ends up
>>> breaking SEV-ES and SNP, since they rely on the MMIO reserved bit to
>>> generate the appropriate NAE MMIO exit event.
>>>
>>> This failure can also be reproduced on Milan by disabling mmio_caching
>>> via KVM module parameter.
> 
> Hrm, this is a separate bug of sorts.  SEV-ES (and later) needs to have an explicit
> check the MMIO caching is enabled, e.g. my bug aside, if KVM can't use MMIO caching
> due to the location of the C-bit, then SEV-ES must be disabled.
> 
> Speaking of which, what prevents hardware (firmware?) from configuring the C-bit
> position to be bit 51 and thus preventing KVM from generating the reserved #NPF?

On the hypervisor side, there is more than a single bit of physical 
addressing reduction when memory encryption is enabled. So even when the 
C-bit position is bit 51, some number of bits below 51 are reserved and 
will cause the reserved #NPF.

Thanks,
Tom

> 
>>> In the case of AMD, guests use a separate physical address range that
>>> and so there are still reserved bits available to make use of the MMIO
>>> caching. This adjustment happens in svm_adjust_mmio_mask(), but since
>>> mmio_caching_enabled flag is 0, any attempts to update masks get
>>> ignored by kvm_mmu_set_mmio_spte_mask().
>>>
>>> Would adding 'force' parameter to kvm_mmu_set_mmio_spte_mask() that
>>> svm_adjust_mmio_mask() can set to ignore enable_mmio_caching be
>>> reasonable fix, or should we take a different approach?
> 
> Different approach.  To fix the bug with enable_mmio_caching not being set back to
> true when a vendor-specific mask allows caching, I believe the below will do the
> trick.
> 
> The SEV-ES dependency is easy to solve, but will require a few patches in order
> to get the necessary ordering; svm_adjust_mmio_mask() is currently called _after_
> SEV-ES is configured.
> 
> I'll test (as much as I can, I don't think we have platforms with MAXPHYADDR=52)
> and get a series sent out later today.
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..a57add994b8d 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -19,8 +19,9 @@
>   #include <asm/memtype.h>
>   #include <asm/vmx.h>
> 
> -bool __read_mostly enable_mmio_caching = true;
> -module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
> +bool __read_mostly enable_mmio_caching;
> +static bool __read_mostly __enable_mmio_caching = true;
> +module_param_named(mmio_caching, __enable_mmio_caching, bool, 0444);
> 
>   u64 __read_mostly shadow_host_writable_mask;
>   u64 __read_mostly shadow_mmu_writable_mask;
> @@ -340,6 +341,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>          BUG_ON((u64)(unsigned)access_mask != access_mask);
>          WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> 
> +       enable_mmio_caching = __enable_mmio_caching;
> +
>          if (!enable_mmio_caching)
>                  mmio_value = 0;
> 
> 
