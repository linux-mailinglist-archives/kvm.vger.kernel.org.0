Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BC69E9DA
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 23:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBUWGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 17:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBUWGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 17:06:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1148C303CE;
        Tue, 21 Feb 2023 14:06:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knC41Lnox3TQ3rvEz5djao8wftoPA1Vsy65Xr6db97m6LxSi1vOVQ0aTUoUj2IBeXniKivrHnyL2eqkT/Vek6BEBNCiDd0F9Q9n6N/GkNWDZOnHft3odp3Lpd/5InaDzgGkdGBVmq7F+0na2vnbD9O+ln+CROsErDQh6HZRoQ20+JcrQTT+nPn+BIcJNyk+1oJjpaNliCKet3khOZSOosbTuHNATrEXjJ4TgAb/WpEi387ey8QDtCBSPu1lOXTzs2SYZlVfQ+gefdvwGf8VQ6McYRAea8CElVe59ewJFCFcZ2FU7NcJNqf13iW6b/2Yf9tZhmW3YHrnTLAvJmUkBcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZyHiit4p3IDqeFtLvP3SjkUsiHaYD5sdx271a5WCco=;
 b=agm6ZEqX+mV1yYBppQ3PVQnOA36Rj1yCyeYTiVeFIE/14mFQSe5bwhiGM0Zia0vOJJ6zqN+X75QAdZLKmLvPBCUtgxxSQnqjGi7aSrBNZX5EL/N9wMnFE3KQ11Mq9rZZi7TRxi1VogZpnfnbZn0dW+5eog03d18eKoQWaV2ryk4gXdZEggRcYRwzeHbA7ANKloVM/6M9c44JTYJHXpqVvOdVz/geR9Z5tupoeEVuIVp7MsrelV0YJe1VOYYT6NrtsX4E4nfYKQ17XqLRVDocFTeI48GuLfQlWQtq4RjcRb1D3bgllZ+2sB/8YczF3+maQ/E8LWyp77Yw8msEi1l/Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZyHiit4p3IDqeFtLvP3SjkUsiHaYD5sdx271a5WCco=;
 b=XXfMafhWSBU4eUegj9/4G2OTNMGUiNRQLy+06JHUQ0Rfj4lii93X/Z+nogJq8N5D1iqD15isXFkeHlt6XFyViruK3P8arqg0/ZaZLWk7NQeY57n9UHhHYejUDuxDE2cDPW99gpGYrHupfEaUHd+pVxPBClv2CU0usM5QqUmtQtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 22:06:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 22:06:13 +0000
Message-ID: <40bf3fed-460e-b578-6795-08e564f412db@amd.com>
Date:   Tue, 21 Feb 2023 16:06:06 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 24/56] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-25-michael.roth@amd.com>
 <20230221112823.000063e4@gmail.com>
 <f70a2398-bd78-24aa-b0ae-9171465d50ff@amd.com>
 <20230221231514.00004b27@gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230221231514.00004b27@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c7769e-8caa-446d-69e8-08db1457d8db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7se0XbO54SgNdD0Zo+ENJz3yAsNeDlSW1nNCphuG6dHxlqlH1yR3Bib81gQE2YK1Hjy3a69UMU4mgV/0Ap8ZsARUG0gmWcW+56QgYhuQ6Y5s2IiPbZGKoiI9neQzpAiDe3LnqcxDlrO+V31PkVINjvqLKmE5/aiDFIVYWuzXIeJSKRImTgaRCUoMND1za0bntkORW/UWkEni3dioGDaiexRL4ZUhg7E4vkaosWac6rel9Asou2aRdETKsVJfvTQ/Mso/ZQ+nW00fIBwBJUHB8VRMK/POfsKF2iz9NtESC/62F0Him1eDmQiCYXNC6Gx0N9OS4nQRoT9KMnn8mBGf97QzGUK1LisgLHfmiVO5tFSn38+a5dTL+mDuRgwX/5jHbTx+fJovkvuzaxQxXH8/PWnccqVhwQ8Ps1zHT+qwCWEMUZIy0+9u73Pbci76YPdiVpB+JY6RMfGQFNt0I+rqX7sllRRjBvUt04whpuGS/fjZonYEOlPvyEEHqJMj04lNfOay2KtgqSnMPb75NYiVCvLUV7grz44fEY9CeFtqUegh/5bf4yU3YH6tr4VE9hRRAeQHlifw0PKdPkABp5wkaHXJMhlYQo0aueFtBAHoAXEa7q9HM7XGFRDtNbSw4o6XTn+alEAMOfDk7YYznYWn6LEuHnuMXLgATe8kMuQxqv8cL1YKXOTMfM9BhK2lBX0M6r3o8qr1xruW5jsq8kq8nx/NukHBGClX+Y0VGN9QIH4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199018)(31686004)(83380400001)(54906003)(316002)(36756003)(38100700002)(66946007)(8676002)(66556008)(66476007)(2616005)(53546011)(41300700001)(186003)(6512007)(26005)(6666004)(6486002)(6506007)(478600001)(7416002)(5660300002)(7406005)(4326008)(31696002)(6916009)(2906002)(86362001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjNMZXk3QnR2Unp2VHR4TjR5eWkzUG1kaXBqYnFGaG8yNHRMZW9EbkEzSFdz?=
 =?utf-8?B?ME02UjdHYzVDbHJNN2JUSUxsZytaZDFXalpJcWVsT3VSS3JtbjU2c1BSVTBi?=
 =?utf-8?B?czZpODA1bTVuQWhINXhueWNsaWYzOHdCbW1SZlcrY0oxYnZPRkJWdkgxaVlZ?=
 =?utf-8?B?RnZBVlFlU2dCYUgxbzRnaXVkL09VUG9GWHcyZGNYbVlibnFvbUJWZjRxYVU3?=
 =?utf-8?B?Mm9jQ1d1cTRKZ3dIL1paQXA0cmdpV254N0NLRjZtQ2lVQmNrOTlFMUdXaFhn?=
 =?utf-8?B?UVBqMmVPU3BIT1lReXV0ZnJGWm41dndOdUhaemFsVzg5Wnc4NUdsRnkwZmNy?=
 =?utf-8?B?R3IxcnZFYjNHbzRWRG5VVjE2Q0dKbjdzY3cwT2RYVnNOOUxhWDJyUnplQXV5?=
 =?utf-8?B?aEswKzhPNjlzSnoxODN1b1I2MnFncHpmczhHTUFsZ2kyMG1jMXBJM21xdDhu?=
 =?utf-8?B?K3ZiU0NxWjdOa0xtL1Z1Uk5aT3ZjSDhYREtFa2Ywa1VHMk1aTFlmNTkvYXlD?=
 =?utf-8?B?eFdFdCtGYjRvUE11QXpmdE82U0VOS0FOa29FZVJZYTJFZXRuZjlZKy9tckpX?=
 =?utf-8?B?b2FOYWtGTkg1alVvRVNva3FFOUcyTTJobUZYRWpRNUZNaDdmd1YxVTVGeWMy?=
 =?utf-8?B?a1ZjNS9jdDc1TVNQaERvem4vdUZRYnQwZ0xiV0xhMkpyY2pjQW9xREFOU3py?=
 =?utf-8?B?RkdJWnV1QkdqVVVHNlk5YWN3ejNyZWxYR3pBWXloSDAyVXdBUWxmQWx5K2tn?=
 =?utf-8?B?R2xiaGZYY2Nod0luZUhtbWRpWW1iSTFNbWZrM2NpZDFwRXAycDNtdmFuREI1?=
 =?utf-8?B?cGd1U1h5dHQ5eDIwbHloVjF6NmNiNEJlcjFkSFJld3R1QW42K2ZxMHNaOC96?=
 =?utf-8?B?bTNyOWp5eWNEa09zbU9QNnN3aW80SUY2ZHQ0YThkS0lHMTllTSswZGJKR0hm?=
 =?utf-8?B?OXYwYmlFZ0FOMko2K2RCT3lNUkRDZnN1VkNSRWNCYXlibDJwTGliOTFpL0xi?=
 =?utf-8?B?SFI3MjhYc3V3Z1ZvN3dWcDdYRVMzVmxqYXBvZU9aQTJGT3ZJZXQ2cGRCZ0lP?=
 =?utf-8?B?b3BzdzJSNytMbVNnMDdkc3R1NjAzRXpJNUZkNDE0eGYvNGh6cnZnV0pSakFa?=
 =?utf-8?B?dEF5RThpVzdmU2FGREVsOU1jWVNBSVNIVUphaG1DMk1QVVZIbzk4WURMZ2Fq?=
 =?utf-8?B?OWoyZTJQVXVWL0ZNbDJ1Q3JzYUZUaHpXUGRJd21PUEI0YkI5MVRHN0xMWHQ1?=
 =?utf-8?B?L09jeW01MThQMDg4OWtrRm1WN1JidjJNcFh4WXBoVEtRVW1VMGYzWVhUMEYx?=
 =?utf-8?B?LzVFN0c3UlNoeUtvUkVXbmMxMmpWdkI5RXpXa0d4RExlSnVFT1ZrZTFxeHFn?=
 =?utf-8?B?U3RkbVB2c01OYXM3ZlgwYW5mM1pVNGdwM0FieERuZWlSeXRjTldyTUp5b3Fh?=
 =?utf-8?B?ZUw2WTBpSW51Ynp4U2JWdVBSYjVBY1Flb2k5WEYrYW1kSVNHUUpYY1dLRFZG?=
 =?utf-8?B?cm4wOVQ2bmJNTkNVbzBFR2VuK2EvbVBFK01la2FjeHBTVU42eFMzdXFjTUVm?=
 =?utf-8?B?bDhDVVlvRW1ZeW1ycVhEdmYyK01Gd2JTbEZTWEY5Z25ZaU43cEtPaE1mZ3Jz?=
 =?utf-8?B?YWIxcSsyVVhLSzdNOWVpMWRVVko2TEJPbjJPNEMyb3dPeUNiMlVUbERMUC9K?=
 =?utf-8?B?cFVyVktLSm5DSGpkWFVYZ0VnajlYMzVTZENTKzcrNGlYOHVreUxsNjRyanRq?=
 =?utf-8?B?SWRUcEJlQW5ROW9ZWWNXcFVFTmtnNXF4QnBTaVRNY3BORGJ6eG9ZdmQ3VTZj?=
 =?utf-8?B?aDhIcERNRU1BeEYwdkxIbSsyUEpXVmtmZmhaRElqM1IvZnFpc1p3V081YUJT?=
 =?utf-8?B?OU9YZG9qRVl4VmdWQjJTQTBpaUo4eE1OTzJOQm1uWGlSMlltL3BHYk53ZmRF?=
 =?utf-8?B?SnBqUit4U2I5d2wzdVgrNENZa2FVVTY5UE5aMkx1VzIyUk9YLzdxYklZKzVE?=
 =?utf-8?B?eHdGcExwYU5NTHhHd3BBU00waTFLYWVqV2Nlci9QZDVuSEliWVEwTG9Nc1hi?=
 =?utf-8?B?aHJpNUJTTXRXeHIzbjZLU29NaUROV2IwUk9XR1JXZDFjY2xPVWY5MzNyZ2dK?=
 =?utf-8?Q?Quete3FZ2SzNrBPim16DuRJcx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c7769e-8caa-446d-69e8-08db1457d8db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 22:06:13.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svIQz+e22JmVKzEp6aVwbQklLvq5Q1883OOz2OjwC4fQRfqz5l07O6xVoj4ynVIL2qf5yFluLVAfe7QdcGvJcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/2023 3:15 PM, Zhi Wang wrote:
> On Tue, 21 Feb 2023 09:31:01 -0600
> "Kalra, Ashish" <ashish.kalra@amd.com> wrote:
> 
>>>> +static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
>>>> +{
>>>> +	/* Cbit maybe set in the paddr */
>>>
>>> This is confusing.
>>>
>>> I suppose C-bit is treated as a attribute of PTE in the kernel not part of the
>>> PA. It means only a PTE might carry a C-bit.
>>>
>>
>> snp_reclaim_pages() is also called for reclaiming guest memory, in which
>> case the (guest) paddr will have the C-bit set. Hence this C-bit
>> handling is done within snp_reclaim_pages() so that the callers don't
>> need to handle it explicitly.
> 
> Thanks for the explanation.
> 
> Do you mean it will be used like that in the later patch? Sorry if it is in the
> later patch as I was making progress slowly. It is quite a big patch set.
>

Yes, these are callers in later patches, like the following code path in 
patch 25:

static int unmap_firmware_writeable(u64 *paddr, u32 len, bool guest, 
struct snp_host_map *map)
{
         unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
	...
         /* If paddr points to a guest memory then restore the page 
state to hypervisor. */
         if (guest) {
                 if (snp_reclaim_pages(*paddr, npages, true))
                         return -EFAULT;

                 goto done;
         }

       	...
	...

Or, the following as part of patch 52:

int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, 
int *error)
{
	...
         data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
         data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
         data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);

         /* The destination page must be in the firmware state. */
         if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
                 return -EIO;

         ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);

         /* Restore the page state */
         if (snp_reclaim_pages(data.dst_addr, 1, false))
	...
	...

Thanks,
Ashish

> At least, I don't see that kind of usage in the current patch. Feel free to
> correct me if I am wrong.
> 
> The call chains:
> 
> __snp_free_firmware_page()
>      snp_reclaim_pages();
> 
> As __snp_free_firmware_page() takes struct page*, all the follwing coversion
> from it would not carry C-bit.
> 
> __snp_alloc_firmware_pages()
>    rmp_mark_pages_firmware()
>      snp_reclaim_pages()
> 
> As __snp_alloc_firmware_page() allocates page with struct page*, the same
> conclusion as above.
> 
>>
>>
>>> The paddr is from __pa(page_address()). It is not extracted from a PTE. Thus, the
>>> return from them should never have a C-bit.
>>>
>>> BTW: Wouldn't it be better to have pfn as input param instead of paddr?
>>>
>>> The caller has struct page, calling snp_reclaim_pages(page_to_pfn(page), xxxxx)
>>> would be much clearer than the current conversion:
>>> page_address() (struct page is converted to VA), __pa() (VA is converted to PA)
>>> in the caller and then PA is converted to pfn here.
>>>
>>>> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>>>> +	int ret, err, i, n = 0;
>>>> +
>>>
>>> should be unsigned int i, n; as the input param npage is unsigned int.
>>>
>>>> +	if (!pfn_valid(pfn)) {
>>>> +		pr_err("%s: Invalid PFN %lx\n", __func__, pfn);
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	for (i = 0; i < npages; i++, pfn++, n++) {
>>>> +		paddr = pfn << PAGE_SHIFT;
>>>> +
>>>> +		if (locked)
>>>> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
>>>> +		else
>>>> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
>>>> +
>>>> +		if (ret)
>>>> +			goto cleanup;
>>>> +
>>>> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>> +		if (ret)
>>>> +			goto cleanup;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +cleanup:
>>>> +	/*
>>>> +	 * If failed to reclaim the page then page is no longer safe to
>>>> +	 * be release back to the system, leak it.
>>>> +	 */
>>>> +	snp_mark_pages_offline(pfn, npages - n);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
>>>
>>> The same comment as above. Better take pfn or page instead of paddr with
>>> redundant conversions.
>>>
>>
>> Again, the paddr can point to guest memory so it can have C-bit set.
>>
>> Thanks,
>> Ashish
>>
>>>> +{
>>>> +	/* Cbit maybe set in the paddr */
>>>> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>>>> +	int rc, n = 0, i;
>>>> +
>>>> +	for (i = 0; i < npages; i++, n++, pfn++) {
>>>> +		rc = rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
>>>> +		if (rc)
>>>> +			goto cleanup;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +cleanup:
>>>> +	/*
>>>> +	 * Try unrolling the firmware state changes by
>>>> +	 * reclaiming the pages which were already changed to the
>>>> +	 * firmware state.
>>>> +	 */
>>>> +	snp_reclaim_pages(paddr, n, locked);
>>>> +
>>>> +	return rc;
>>>> +}
>>>> +
> 
