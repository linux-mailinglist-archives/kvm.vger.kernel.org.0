Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A835A3918EC
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhEZNgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:36:16 -0400
Received: from mail-mw2nam08on2072.outbound.protection.outlook.com ([40.107.101.72]:62688
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234096AbhEZNgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 09:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj9w1MlnXtPTogp86VIg5FA80+zmntiZMdMJxlfhKDbmlVZrLSbYIa5npdUzi28x42EPgj2yWIckDTV1zRWsA7iVqTwadRB2N0zINpqTM2yCJW/SM/N7Og58NVHP9NORULk2s4X0MH1oF7q2oqNur4FH/yBVxeG+pOncF6XZUyZVPsQGWhg6EDvMdpsRaFCIYKHIKrtUl74mGkSd+ToQzCAoMt/uoABc2HD1xTH7POxDratV/Nlr42rGmihSqO5/+S5+OZEWSahxFj8fUARaF7WwXvbmTkkSHrMux4Vq/Sn8TxQEtt3mbWN5Y1PXmBIWCihkDh6za/zNU6dMgX+O0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzNyPzoRmIrd4W+4cNvOqkt2UTEWm503AoFNnMZBytw=;
 b=PfdJReFfQpqSYHLb7Y6f/R0HuaVrLGvA3FYpIVCue28CGkopXxDK5d6TtwwcJzyVH8QsFpsG9ZPk0G0ZZc2QuEQJk+AapTK+K656DUksEx//N+SlI3Zj0F+7kqgAeZoFwN69U8g4lya+OUDzfCCGUNJfIaHmoMFTtzw/iA8atv02LwZADu66UNvZbQk167oBFB2mSIin3ulNZicM+tP2+zPT1piHik5lLb5qZx/eZsYz6KDOy4ATFU22oMtyWo+OBTr0spclLyhrWrWwEUNC96vI0fGtBSihej29HWetS7jSfYpojy3GBJh1ThWgVWwsuequzXG4rtfBXbNP9OB/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzNyPzoRmIrd4W+4cNvOqkt2UTEWm503AoFNnMZBytw=;
 b=E/+JNo+UUnq2SvJsh0zJqyRHeuCQ90QtP9U04DaVb4o7ndGisMzwTu+KOMCOnhUM9kDZOTI9qFdw0wu7xnWfY8TfbOqU+zJYuJSlkXWlVW2tor682wh0fOsWClb6QrR1jOqyA7UtFSpiYSpWpQbPgus9cCmxaZeaPetTkltljNI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 26 May
 2021 13:34:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Wed, 26 May 2021
 13:34:39 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 14/20] x86/sev: Add helper for validating
 pages in early enc attribute changes
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-15-brijesh.singh@amd.com> <YK4lTP+bHBzUxAOZ@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <5177b468-c05b-a286-7042-88a64f063ff3@amd.com>
Date:   Wed, 26 May 2021 08:34:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YK4lTP+bHBzUxAOZ@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN1PR12CA0044.namprd12.prod.outlook.com
 (2603:10b6:802:20::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN1PR12CA0044.namprd12.prod.outlook.com (2603:10b6:802:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 13:34:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eed96b32-04f4-4148-8819-08d9204b02ed
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB451058D0A1976C39FDD8E1F6E5249@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 923cgw1miYk635ZYxtJfU/BHcAheLiULj7ITQBoQqq+kXo68gBn5L9ZyfUFK3HtC9cyLLypMgMSXpt+1M9fAVkDUpDIJ6K0zRTUovsz+2quJb2cfOgr861Q4jlxaBJ+OEYuN7VmjqPN6XzgcJxgoBrql+1toHMvdEvxaajM6x69yLptIAewlru5Xg2ZrmshtW9hut/ypYgLXu5JhZSMEgo1jYFKo+Z03P5sA4JzG4XxUwjExkX/93OdM/vz5bY7H2jdYedeAj1Z8hThcKS0Oh+HD/hZ8KmpPV0FrAvCnEazLZXaxUdWuEB9LYIBYDoLIYKUhsPCUy9i7ve1TM1addzugtNrW+HeTUaAmaF8nVb/TaPkLwsga9hl9PMwAtBA1IIL/porXwrenY3xj/ItD/hJNTBzPwIVaBnxx6/rRcAN3NyqdtvIV4JkEKccqXcQzhKbX77bkssAtaJO1S8lkzangCELXyuUWYG1LZ62M3NcSkFWxwD37nPdN0nfgKwv8jeWKLNoJ0vKZXjXsOYKrs0uf/04NjkTZlcOWAZA6s7VSM6yiANM221JMkclEyPAle+0XTg558v8sWtfULmJRLQhr/ekzzQ16kgg1fY5+Ukn0/HksI4zdqUcItUfnKfIsOLXave3D0qFQsHP5QM6yeq56MAedI3Dd6uuG4tdewob4fEOPCp0udamYoxvhaDK3luhB4NRyr/FOhqo6FZx46crZcUlzEqUrj6ME7z9am8M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(66476007)(66556008)(2906002)(8676002)(83380400001)(6916009)(86362001)(26005)(36756003)(52116002)(53546011)(6506007)(66946007)(4326008)(38350700002)(31686004)(6486002)(38100700002)(8936002)(478600001)(5660300002)(6512007)(7416002)(16526019)(44832011)(186003)(316002)(31696002)(956004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a0VqWnVFejZjdjZGUksrazJVa1pBTnlFdm1VM3NpSnZHbVZtTFd2RDY5QnRF?=
 =?utf-8?B?Sk1oRmJFcDlmZ2VPcWpGZk5KSHl1dEMrdUxzeHB2c29YKzYybWRhdHFaRWdS?=
 =?utf-8?B?aFgzMzZvWEc5U3UweVYwbDVvMDU1MURKQWttM1RxRG1OZ3NaYUtKM09XVU9v?=
 =?utf-8?B?STNoNnVIby9QMzM4Tm52NzJDL0xvUmlTWVRydzVGNGpMU2dEVzBZa0VqT2xN?=
 =?utf-8?B?b3Z2RTNzRkhXbXVrRGV3ODQ2NkhtODhIYjJ6YVJJZFp3VGJkWGxUeHZCbmJn?=
 =?utf-8?B?WFdqQmROenphcUNTRU8yZDV4czNnRkJ4R2xLTmlHMmh4eU02UHdnaW5nUUZJ?=
 =?utf-8?B?K283alVnUHVPTjNEeEt2S0U3dTBmdEp6ZnRibXJqZnVNVStYazVyY1lsZlFW?=
 =?utf-8?B?QXdsUW9rcWlPWk9sUGxGK2xpbTBuVTZEL1VFQndPdzl4VHg0ZlhESjVGbEpF?=
 =?utf-8?B?RWFkQmpyM1YxUVV4amRVVEpvdmxsNFd2c0U0NnNUZENvTnYxLzBuWWVlV1cr?=
 =?utf-8?B?NHV3QWcxMXZJd3pYVzBMcGtDb042Qy9DaDFxNzFKckZ5ZnBKd0oxU0FRaDR6?=
 =?utf-8?B?dDQ5a2hWdU5oOEx0TXFIeW1sRWZ3QTg4UGhPaGJyTGJRcklORE1ncTNnV3F1?=
 =?utf-8?B?aU5zanZBTWdySEVRdkRyMzFqbzF2NzBISmtyZzRTejA2dHBvYXlZT3FmYnhK?=
 =?utf-8?B?YjV6WTZyVDJLQ2dmTGdEUzZhWEEyVGxwYmtUbSt2RVFzdHlZQ3BUUUhlblB3?=
 =?utf-8?B?U0VUeGFuNG5DOUg5ZDIybFNnWnhONk1acE1PamR3QmRKaVBlMHBWOU9ja1J3?=
 =?utf-8?B?U2QxMFE1R29nc2F1b1lnT2EvTlprRmFaMVEyRTdtZUcrZG5hNWdzQTg0TzY4?=
 =?utf-8?B?VzM2OWJFUzA4VWgzTmtXZGhsNlBJR2pMTEZXVWZXQWN6cTJWcUNrWmg1b1Jk?=
 =?utf-8?B?MXpJZnhDdStCaDZoNlFuUzdTdnZzY1g3TGREVUJCRlYxaEdOTXpNeTc2bmRp?=
 =?utf-8?B?anZ6SlhhTFJ3RjlJcURhdHdnRm9xZzh4VHRaLzR4OVJCZ3ZaRHM2dk9HQ1ZI?=
 =?utf-8?B?cEQ0UTc3eEdGcTcwdXBZU0E2TU9HN0k1bCtYL2JodFdHSWxpdUtDcUlhazJJ?=
 =?utf-8?B?cDFoZXpQMjhNdERwVU53d3BjUnVxdHN2NVdkTVJaVHN5NTR6WDBIcFYzbmlO?=
 =?utf-8?B?M1YyYU8zd3NMcXlSY05YeEFTQ21naDgrbUF0ZmVyZU5jTUNEbWNLOUZMRlp0?=
 =?utf-8?B?YVpOSjlVRnpiZjkvcS8vMEwydzhHNDN1ckkxaWY4WjNuZ2sxbG1ENkgzWDc3?=
 =?utf-8?B?Zk1QRkV2dGUzbll0WkhrZUNmUGNRd1lTcExXUEVUQjZ0NVRrSkJjMURlVmtJ?=
 =?utf-8?B?WUl5K1hML2QybG9EdEVJMm1Oa2M1UXJGNTJGVzk1NnVjdEJSNklwK1JGTy8w?=
 =?utf-8?B?UlNOV0hOTFhaakxkMkxoS3QrdXJ4eDE0ODdMWStVbEE4UktkQURLSEgvZVY5?=
 =?utf-8?B?YlgweCsrMndUcmN3TnF2OStYR2o0T0FQN1J1RmlmTDRWL054Z3Z2M2p5blpn?=
 =?utf-8?B?N0FHaS9YWWcvNUFNUnVneUtyM0c1NG8vaEdOdERLazhSQlJiaWFSRW5Kcy9m?=
 =?utf-8?B?K2JPWUtmSzVWZmltMlJWTFdMcmNDS1Fxc3BNQ080Tm5Gc2c2V3FxNGVkNCsy?=
 =?utf-8?B?aHNqdjUvNTE2Y2xLWE9LVGR0UU9PNjFENmw4M3h2VFdZZEc2ODV4YjVHSkdD?=
 =?utf-8?Q?Og3+TC5UCPGeI/Ls5Xcsr5h4yyKjCsNjydqf3V0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed96b32-04f4-4148-8819-08d9204b02ed
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 13:34:39.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9H5cv7FFL4NkHbfaM1MtzvXE/e2lErVAEFdhSg+xStuPDnBliUQIatBMMTd8nHrA4fYDfPaBHI73aM/cnLOBsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/26/21 5:39 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:10AM -0500, Brijesh Singh wrote:
>> +static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool validate)
>> +{
>> +	unsigned long vaddr_end;
>> +	int rc;
>> +
>> +	vaddr = vaddr & PAGE_MASK;
>> +	vaddr_end = vaddr + (npages << PAGE_SHIFT);
>> +
>> +	while (vaddr < vaddr_end) {
>> +		rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
>> +		if (rc) {
>> +			WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc);
> WARN does return the condition it warned on, look at its definition.
>
> IOW, you can do (and btw e_fail is not needed either):
>
>                 rc = pvalidate(vaddr, RMP_PG_SIZE_4K, validate);
>                 if (WARN(rc, "Failed to validate address 0x%lx ret %d", vaddr, rc))
> 			sev_es_terminate(1, GHCB_TERM_PVALIDATE);
>
> Ditto for the other WARN.

Okay, I agree with comment, I will go through each code block and use
the return value from the WARN().

..
>> +	unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>> +
>> +	if (dec) {
>> +		/* If the paddr needs to be accessed decrypted, make the page shared before memcpy. */
>> +		early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);
>> +
>> +		memcpy(dst, src, sz);
>> +
>> +		/* Restore the page state after the memcpy. */
>> +		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
>> +	} else {
>> +		memcpy(dst, src, sz);
>> +	}
> Hmm, this function needs reorg. How about this:

I think with your edits its looking similar to what I had in v1. In v1
early_snp_set_memory_shared() was not doing sev_snp_active()  check
whereas it does now.I didn't check the sev_snp_active() in this function
but I agree that it can be reorg. I am good with your changes. thanks


>
> /*
>  * When SNP is active, change the page state from private to shared before
>  * copying the data from the source to destination and restore after the copy.
>  * This is required because the source address is mapped as decrypted by the
>  * caller of the routine.
>  */
> static inline void __init snp_memcpy(void *dst, void *src, size_t sz,
>                                      unsigned long paddr, bool decrypt)
> {
>         unsigned long npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
>
>         if (!sev_snp_active() || !decrypt) {
>                 memcpy(dst, src, sz);
>                 return;
> 	}
>
>         /*
>          * If the paddr needs to be accessed decrypted, mark the page
>          * shared in the RMP table before copying it.
>          */
>         early_snp_set_memory_shared((unsigned long)__va(paddr), paddr, npages);
>
>         memcpy(dst, src, sz);
>
>         /* Restore the page state after the memcpy. */
>         early_snp_set_memory_private((unsigned long)__va(paddr), paddr, npages);
> }
>
>
