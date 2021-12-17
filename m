Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7E54795D8
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 21:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhLQUzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 15:55:20 -0500
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:59137
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237288AbhLQUzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 15:55:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftQnqNEE79urw+R7gHHSTO9x46tTGBM9W4jmO5nDcfEjbOKKFqEkrrTArYbMMhcOwG1sPd/92+iC41EBAawobCtMKiSCAuuXTs1jBNRZY37tekBqg2AwvmngDF9JNVnHFC3A5vE/ntSHCuI9VmuqmsHh3z6rJm73zKmygKY3jYf7Q1d3dqREKZ81cR+e+8/sgfRZegLVLb5KxJXES4wc8lyEyGAakDRKGLusISDnbnZEJ9QNJcqam0wIvPxOQC1Z5euvHtBde6TTBh3UVE+sHOWrSoYoHzYFLDwtWi/0cUx1Vfk9wO/repk/oNglGumNUKIx9PnnJCKm6pvszOFvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x5Koj3WJ5yNZkDI8CPGaoOLGuMl8bwJq6ayypdGiVo=;
 b=B02CcvanOjTzKAGxeyob5VGzgjY3Y8RRhoWF1ngl1aEbKNUMuEw0j6XRFGi3xV73XOFJji7A8ZIXrixlNdGGWfQkRDCdX4kiIbFIUjwFKN+McmBAb4HBKanIz07WiwEFApB7Ni4J9DopmNOHcKCFhWWAmdmC7n2qC1/xtmf4gDK6ecoQIa8igyNzArhwxOqIDp5T0ywwzJhbHtYgRshODS3LHNaYSdd0FJoyonDSlDDh3KsSRY6xzbM/2HMUnXxe5vJWUcx7lDsU2xieJ8J/szRcceaQwwTg7EhazNEBhmTdgvUaouQPE7/tUkMzRr2Bes2sgJO1E/w1RKHltQwDgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0x5Koj3WJ5yNZkDI8CPGaoOLGuMl8bwJq6ayypdGiVo=;
 b=a/vdmYbxQOY5uG1fXBDd9gPwwdKZHoae3pga04cRdTzjxNowQ+CTg0tlXmBLB2FV6AAGnXdz6Ad6rARbEm4eJDY2K/iNQcnL5bEvU1NGOXGbJUGpTO0Q3tdIWW3Ze1u1GIb+2j5nsqpGg/A9MujtsHEbfTvhj/DQ2D00suPvFvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Fri, 17 Dec
 2021 20:55:05 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 17 Dec 2021
 20:55:05 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com>
 <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org>
 <b798bcef-d750-ce42-986c-0d11d0bb47b0@amd.com>
 <41e63d89f1b2debc0280f243d7c8c3212e9499ee.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c3dbd3b9-accf-bc28-f808-1d842d642309@amd.com>
Date:   Fri, 17 Dec 2021 14:55:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <41e63d89f1b2debc0280f243d7c8c3212e9499ee.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0015.namprd12.prod.outlook.com
 (2603:10b6:806:6f::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA0PR12CA0015.namprd12.prod.outlook.com (2603:10b6:806:6f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 17 Dec 2021 20:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa6d2fb2-d763-4fcf-a3e9-08d9c19f809d
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5565CD156D21825223A84F72EC789@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ASrkckyXrYpiHENjug7n38DNLKeDZGzFtGmGhL43bkDdMY39674XGB+PiB3Qtf+XXJsFlIRhn5YHELBfmwN5ntx58j4CzJ9DZi6HQetisXjo1u0wbdFlAoecx2HHA35Nq8BakMSg0Db79ulse3okyaaJBf89OujeEip4x7xoC32LY4S5R2jNJSpSHSKuY1CEjXQelYrQvacCQRa6YVoAzdcg7l6Ty+yw7r5j3FBAsCrUvsKDYbdxp/Z8bnf0Hhs1l2u0Isy1dN/a3Ux1vBum3VM2ptfcOmdMOfFA1/mIOcL6Orw17ytomKyxmBvAXeVWkYoj7HKrxp1b5iCk/7QlkYYTyUdSPvraSIFU9saRhrOrMU/KW4Z7jF4QOXCdxpcwKWEY01uV42gbvyMMCRVVLvGBuBmO9Fh14QZACu/9qjKWT7o4DkwUUQoTfmH/qVoNAPJSs3y5wjTy9bJtNks/R/HqJxL0KkzROxBlew3etzSgSzOWIUVtecSxOrSMl8kdPxwLOkiLDYUATVUGOQFsewAtf7RsHWZtmxj/cFSfA1W/D8jIbuN8QiK0ORjG3t/PQKWuiwvgnIxkdUL2S6VgnR3sQgZmE6If1aDL33HHnhnN9P81L4CfemmhJVdy/L+JB4hN0XjuyzYEHzIl6oJI9r8apj8w49wiVuUfW4eY4sztKAbqAIlPsJllJjHAFnMWXLgcAkRilHFLxCcbVj5YvF8ggORlNkxYMd0PvFBbS+5xLQNLwkkbaabKIuolcEf2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(4001150100001)(8676002)(6506007)(508600001)(36756003)(8936002)(53546011)(5660300002)(6486002)(2906002)(38100700002)(86362001)(31686004)(26005)(66476007)(54906003)(31696002)(316002)(83380400001)(7416002)(6512007)(66946007)(66556008)(186003)(110136005)(4326008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjNranUvZXNwbDhlVVFLUWRjVHVOa3FTSWdsRzVzSW84RDJzc3ZGVmZYamZz?=
 =?utf-8?B?cytKR2hwRDlqOGgyb2tNK0JTMlJ3RG9Qdy9wd1JzeG1SaSswQjM3eDdGTmNU?=
 =?utf-8?B?OUhkdGpzdmtEQW1La3Z3enp4VmJsai9DWS8xRm5QejYwMTBMd2F4eko4cmFL?=
 =?utf-8?B?WUhhS3lsM1BTV2d1R0VJeDJwMzQwOUNRci8xTzY3S3hmRFJ2bHlhTFBsajNi?=
 =?utf-8?B?Wlo5bU92VEVPUEpESjNTbjcySFlqbDZ2QzRwWEdBSWRKeGw4WFZFallQMThm?=
 =?utf-8?B?SjlxOHcrOEZOUWVjd0FQTUxxZFVEN3NhZ3pZYkFnenJjaWpMT205RUpvaERa?=
 =?utf-8?B?blRTYmdyUTd1NUZTR3I4N0huVjhCSlNYYUJacm4zUEhzMGRYR3hQUm0wNHVo?=
 =?utf-8?B?dmwzcEhKNE1oVFFWYmhMS2tvRVhINW5LeHlYbGc3ZzBWcWZzM0luaHhnTm9C?=
 =?utf-8?B?bWxWdnNRaWlPcVpHbjQ5djlQWGI3NjExbmw2NEljK1Rpdzh0MkozZjgvakJp?=
 =?utf-8?B?OVNKbEFQbzNmUC92TG9pc2JGQmNDOVV6U28zdFhMc2IzNXl6Mk43TjM0S2JT?=
 =?utf-8?B?MDhhVzJIQnBrRGVzNG9rRmhTbmtRYnJwMkR5Q0I2Y0tIYnVKaHJKMTZkVEkv?=
 =?utf-8?B?d2w3SXpJOThURVpoQnJTNnJSakRnb0laWWRlSldheGx0QW5iM2xRSW1oTXhN?=
 =?utf-8?B?a1I1anQ5WmdxVkVjZStQYWRVYkVEWThrR2dKN3pwZVpSQ1UrdVIrdkRoM2RM?=
 =?utf-8?B?ZXlxMy94QkVuOFdraExycm9lcGhXQ2FXRGhUbXROYUVpbUhHQUVzM3BpNEVW?=
 =?utf-8?B?WXRVOS9Qc1ZrNVJ4V1ZTb1ZVb2NpV0RQRzZhTERDdkYvVngwRVpBMkNaRGw2?=
 =?utf-8?B?N2Z1MDg5SzJiTy92b2pIN2VidlBDUmd5RVNNT1pnWmljSnBFakVjOEswQ2dH?=
 =?utf-8?B?U01ja29pc1NqNkZBRTNjQWY1MC9NakczVDMxQUdOanhYTXZMY2kxT3dvdGox?=
 =?utf-8?B?TFF1SGgvUXRBRjFpSzFMNDkrZUQyZ2JpOFNlMnc5Ymo4N3VQK3ZyaURScEl1?=
 =?utf-8?B?N2RTQnRvTHJlNnJGU0pNWThHQU9vcGxzaytIZWRLR2V2RFNoNEdWZUlHdWhW?=
 =?utf-8?B?aFQ3NTlXcm1FWkw5dzRwNWVRS2Q5UXU5cVpUaTlXNUlwTW43TUhjeTV1UGUr?=
 =?utf-8?B?d0hhL1pBblNjS2F6bktVRExYaTc4Z2dOdi8xVlZ1WlEyZGd1SXRZcU80Y0pM?=
 =?utf-8?B?YzhJczlaWWw5aTFabHYrWnhXUGZqeXgvczIrdnBOUnRYOUJ6L01BY0lhUE5Q?=
 =?utf-8?B?SnJFYnZnTCsrYkZjLzYrbFNXcGtlZHd5czFxT2dTR2ErYkJxVGxhd3A3bkUw?=
 =?utf-8?B?UlFZUHcxNUVmZUZ3ZW05bFNVazRoVzFmaHdBT0ZldUt3UjFzS1UvQm5heXk5?=
 =?utf-8?B?c2M4c2dTNW9EaU54UnlkS1ZDUG1nOEgxbzhGV3FweVQ2R2JNdEZlOUhhS2pa?=
 =?utf-8?B?a2hYcDRCeVRoSmxqakQ2VlVPY3F4OGp2ZjJUVGU0Y1BXMnR1d1RURVduT1Nw?=
 =?utf-8?B?elJ3M05GQTk5SndOYU5UdjU4eHdnRjdqalNaZTVNT1NwVHFYNFZPTTNMVkFR?=
 =?utf-8?B?S05pZkY2WjJYQmo2ek1lT2JZTmxtOE5HRXBNUzh1QzgxZ000S1pyTEl3UXVK?=
 =?utf-8?B?TWZZQ0U0dlA5TFdveFp2S2cvRTI5N3YwM3Jtay9aVjNab3BGaXBBTFZ4eEkz?=
 =?utf-8?B?L0YyNHp3N2pHRXdBVkZ1Um9UWC9hSWxtMTA1M2lCbVcwcVNPbGJ4YnhDSVFn?=
 =?utf-8?B?YkxDc0VSa2R2Sk5XRGt1K1FmalFBSkFwVUJEMEZwcjY0U0ljZTFOdTNJVkFR?=
 =?utf-8?B?SEdCQUU5N2E1NnlRUFNhU2MvVktkck9rQzJvN3ZzNmxJaXh1dTBmVGdxWEtl?=
 =?utf-8?B?bXFIeVpGa3NFWXdRYjY2SjMxMUtwNlYyT1k3VmZ0ek0rekx3ZzR0ekZjc25i?=
 =?utf-8?B?djArNStKV3dpU0tuTE8xbWkvUkV2QTlLVVhBZ0FMUU9LU1M3aUZuUmRzVC94?=
 =?utf-8?B?T0hoTHRPVGZpZXh3aGxNZkNVaWdHNC9NL1QyeFR5SGliN0tlNlBjKy9OTnV4?=
 =?utf-8?B?cEJtdC9pc3MwYXEzVTdUYlRTNWFadjdGNFpSb0FXVjU0cjlYTnhyNTcrUy8w?=
 =?utf-8?Q?iSUfGIHtqqAi0vAGDVGRBA8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6d2fb2-d763-4fcf-a3e9-08d9c19f809d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 20:55:05.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVrtQVmQBVRoWoe4DKfIbH9je4daybLmLD0M06mM5jnKWy7zoWNewbjAcXOzeoToMYnKYMRVtzbDKiSCOMnjUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/17/21 2:13 PM, David Woodhouse wrote:
> On Fri, 2021-12-17 at 13:46 -0600, Tom Lendacky wrote:
>> There's no WARN or PANIC, just a reset. I can look to try and capture some
>> KVM trace data if that would help. If so, let me know what events you'd
>> like captured.
> 
> 
> Could start with just kvm_run_exit?
> 
> Reason 8 would be KVM_EXIT_SHUTDOWN and would potentially indicate a
> triple fault.

qemu-system-x86-24093   [005] .....  1601.759486: kvm_exit: vcpu 112 reason shutdown rip 0xffffffff81070574 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x80000b08 error_code 0x00000000

# addr2line -e woodhouse-build-x86_64/vmlinux 0xffffffff81070574
/root/kernels/woodhouse-build-x86_64/./arch/x86/include/asm/desc.h:272

Which is: asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));

Thanks,
Tom

> 
> Failing that, I'd want to start littering the real mode code with
> outputting 'a' 'b' 'c' etc. to the serial port and see if the offending
> CPU is really in the trampoline somewhere when something goes wrong.
> 
> I can knock up an example patch to do that (not tonight) but this would
> be somewhat easier if I could find a machine I can reproduce on. Sadly
> I only seem to have access to Milan *guests* without nested virt, not
> bare metal. Got a machine I can log in to?
> 
>   
> 
