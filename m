Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7425FF445
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiJNUAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 16:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJNUAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 16:00:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7460B8E7A9;
        Fri, 14 Oct 2022 13:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAcSEtgoAvH2jMbHy/tHYM6ocOcA/KQO8sJ6HOp+CmgJf2c8d9Y9JDzszqHK4jjMJov8L/fKoBcBZuyMEWKdVF1OYb6qBp7UwBrjHwUrE2Y/DP/Sx2dQS5AzCgdICVMOI6hfW4w+OJ+5k0jsnuQCApWqV10yPlXWDzwlXuJUPIjQaY963q9p/soEC93j6ApCrtlCjBzTOTmpUH01ssqi9VBysct3ZfEzs6DsnsbdjETsw+drGcm4kGnn8VtaMSqgPTU/KmKHn9xxnI40rcRzn6nM6ROv/3uyCOG1pM1pG5zPywfR8FF5gbtSPZcygkR/9cYaKbwj0bbVuaGqqBKf/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEkf8qVerPjr6EMXSOjekh7ie6Af1vYnbzkPYpoJgYc=;
 b=cu4GuzV9hExz2kM/C2eCpY5iti2ggb9i8N1AoV60Ym8tOxmFEvZZByoKDi0CRxJCCZ6ZaHoF1z5xA/gxBNMjAqWj8D7IGJ9MON/2Auw9TNanwt1Rdf/SHGXRnNrrInaOk61OxO1xjgsCPfPYhnBC8XpvQSfSLU0VFg7430jAbWiunk8JM/Npz7YTyYshl5svGcsJU9quQb/fVhY+Cw75aqNk0nEvrMi3isjkOD2uz04q6wemd+w94xd1zORNoFVn9dLH6zEwzrvvahb7BBhtZnFQtQHQ7WpTQLVLTqsaWJeiHHj5jiRMFrBeaV0li62ycZgfuCogK2beQic1EDnhsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEkf8qVerPjr6EMXSOjekh7ie6Af1vYnbzkPYpoJgYc=;
 b=KberASEIOGMotxudR9sfUuLpdUmIFlwxG0Zqc0HPlpZsj/xdv9fJaAagyhGSaQDCM2yp5y28Rld63r7lyA1gLSs9a/zc7RGwjxJmwvnkrZvAeU2UVWMKB1oSsBGO4E/yrSirywItuD1N1lv3/mBXYuO20uTHlZgMfxvntR+SyJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 20:00:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5723.026; Fri, 14 Oct 2022
 20:00:14 +0000
Message-ID: <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
Date:   Fri, 14 Oct 2022 15:00:09 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y0grhk1sq2tf/tUl@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:610:53::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: 359dc2ae-e177-4767-8536-08daae1eb57a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0e+lmwMs7CE+YETS5WYN8Z5KywhrX0sxbCKoo8ATX/cT+w15eiKtqDvja2wbMlowSkM2zprSMVb8noQmSvugC9xIEkYQuazR2edXulE6HtheZClL+9F181aLBmiT6KKmiQtkjZiJcUghBzscmqaEBugMiU9CgWyVvatdfQT9KaOvDExBS1723aSGmr0eQSYOKJdw9zwsLyISEsPuO2E1YBrJp1J8E2E3L7J3Cmb9T/AcbDdK6yDJNfns1sLm0orwJ16RakVlGJs1srTvQR+1Ay+JcTQUxWvHF5b5pmGK0f0yS5/GGf65AvdHLbR+njYr3ABES4wMfcgytvhWNk4YFffSzuQ6kpz8DBLlTxJfwhqXTt4Gban720IFcjL6lb8IXfiXdL+daDyMj/Rg4ZX6giEVTeCojY8OpSodKpEmbc0bjp7zvP0ske4GaVmZMScUaa/9OcFJk0RPHCopFcPPYl2Q3uWYi0zrhTQ+DMw2R0f3UbxsrGM+BpKRJqq371/6tdDQC9vNB6FqEFKnR2tvkp3pL5V5lzds42GWsQf/hUBfjzipZeqkoFQ8SC15u1LJxKGuy2tNhFwx2px6GVtTZ1fNKx7Ld0aeXzdQe9noWQUrnv2ITBqZ2VIwRcTLTUzihOn1i4JpMdYe83uVpt2DHowGsVAq6SIGIr/neLYvB1TalqloYQVAh8RTuNWQMwaQPMYdfQ4eBmZz4oQwpxO6n671Qalqq+0MoU30VUmkO83Qjd/8n/YtmpRSt3gZO9dpnz2AWVbIHGw+AXi+fJOGpo6JTIJf7dZE4K/LvuUYbBg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(66476007)(4326008)(66946007)(316002)(6916009)(66556008)(8676002)(38100700002)(36756003)(7416002)(41300700001)(478600001)(8936002)(2906002)(7406005)(5660300002)(6666004)(53546011)(6506007)(186003)(2616005)(6512007)(26005)(31696002)(83380400001)(6486002)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWYxUmZuaWpCaVRzQjBGaWZoN1pTNWw1YXhuMmRBOWNwdVJuK1ZwZDlYb3BK?=
 =?utf-8?B?QVl4bmpFZUlmby9ueFpQUDNHUnpReiticXZTSjk0Y2tPTElTbmtLZ3Z4YWgz?=
 =?utf-8?B?VEI4aVZ6ZFFEUnBsa2xBcDhTWksweUVPOVc3L3Q5ZmZnbU5hblM1Zmg1cUl5?=
 =?utf-8?B?cHBKWDhHNk5pYVlVSFlTNXlGL2FTYlcyNnhsczhub2ZETHhGWERwQm1ERVhX?=
 =?utf-8?B?dTBEZ1g4TXBsb3VJc3RCcFdyQnFYNTFQNG84MnBZTU9uNklVVEg3UDRLRmZO?=
 =?utf-8?B?ckFHUTB4ODNBZlVwQjh2ZzZSVDAzZU82MXhjcWVZMjJsVUxjWFBQTndvcEhl?=
 =?utf-8?B?UXBpdXBmaGtHVHBIbEczOHVVMUV0NzhycisvV3RPMGIya2hHY2JuVHBLckMv?=
 =?utf-8?B?NW45d0dhaVcxSFRxbDNFUVA4SUg3NnZWWUtxbStOcDN4dmlqM3ZwT2E4bWlp?=
 =?utf-8?B?U1pvZWdxT2w0M1A4T1FWQ0tJKzdHclVnOTdvcnRET3M2STZGZEVvMUIxazl0?=
 =?utf-8?B?aysrSFFtWTlXa2FSQ1MzdFlqMHBMYUw0QXYyemdKc0ZqSGpDM0VreEx4dmNV?=
 =?utf-8?B?dzFZakFtZEl6SGJuNS9acmFNMUlOaUU2Sko3V3pmN21YelM5NlVGeVd5K1dU?=
 =?utf-8?B?UHV5dGdMV1d1RUF3WUVzc04wRWZwR0huMFVCZFlZaXVmdjZ4MW01eC9LWUd5?=
 =?utf-8?B?TlExeUdBUmlGazVwTWY5UDJsOW1OcXBDWEROMG5rL09BQ2s2WldRbVgvNEhC?=
 =?utf-8?B?d1ZXNmd4ZVA0QnQ0Mm1wRG5wbkFkSExuM2VsU00zcVEwMjZ0MXo1MUZPZUd4?=
 =?utf-8?B?R2w5U3cyeHZFYmtnRXBIaXRXZGlIWEhDV2lMYUFjYTFTcTNseHRoV1VtYU9T?=
 =?utf-8?B?VDh1UjRMbVVSZThneGExSVFyT2V6Zi9memgvYmFNa1RJb1FvOWtOc1hJeVBK?=
 =?utf-8?B?U1UrWTNudWlLQTFYbGt2UE11Mld3TENoWGJLMHk5ZXpSb09SVlZlU2RIZW5J?=
 =?utf-8?B?N25uZEhRUDAvaUxnc1k0VTNvZVJnYWY1YzZwK3VDQmc3SUFOdkNBN1g3MDNM?=
 =?utf-8?B?bnJwUG1aOFl5V1lGYWlmV0V3akJTV1JpYVduemJ4TTgzSmhJUUJoMnArR25P?=
 =?utf-8?B?clpXRE9RSVg4Q2RrN0RQT3d4dDgyVkU4bEFrWkdQdnlmem1rU3BNVGVFWXlZ?=
 =?utf-8?B?MjZWODJxNkpRbVFnUk4rN2h0WXVnT0dEeUtWWlFEcEJGcEQzYUpRWWo5NXpl?=
 =?utf-8?B?anhKM2ovLzFublA0a0F0ZjZUVkNjWmhaV3ZzSEpmSVFITXIwSGhhRnAvRzhq?=
 =?utf-8?B?Umw5NVRtMmpZTkxteXVaUi9iQmR1K3NRWW51dGUwYTFWTGg5a1ZrL1pVQnRk?=
 =?utf-8?B?RjZGQzBHaTNrL1Z3cHdHOHJKT1dWNVBkWWRlaUcvalQwY0RNT01jZS9CYnJK?=
 =?utf-8?B?YUlqWDhmL29LYU9BRTkzLzJROU1Vb01JVmdjT05ZUndiS1NZb3dyQmZQU1Fy?=
 =?utf-8?B?aktWLzAyakZDVS9kcHFVenF6ZVFrV2pDVTNHSGlIeEgrdXVlc3hIOXBudHRy?=
 =?utf-8?B?WUw0NFlGdHVNbG5pSEt5VmhqcjNqWmR6Ykd0V1pOMWdJcklmMkx0cGQ0MzRK?=
 =?utf-8?B?WmdWY29MNS9yN2M3Qkx5eGNRS3l0YStZb1Z0TzllVFR3V2RManRITWRZMWxx?=
 =?utf-8?B?Ym5LWWpnZm5ZSFhqbWJDcEVmbmlSQk1zQnVrSnlpVmF1TkI0NWtMblI1c3hC?=
 =?utf-8?B?NmQvN1VWUGEvUG1sdmJId0ltZ21NYUtDWDFqYUlaNGVZcjZpNE14NG9wSHh1?=
 =?utf-8?B?SUZzK21RMmt3VHczSGpOOW5yaHR6SzJwN3l6cDIxSjdBKy9ZcWtRU0c4Zmly?=
 =?utf-8?B?anpWbFIvUS9kYVl6dC9XTHN3YXBHNGtFenBoK2ZtbFFLZXhCWVNlVUlYdjVE?=
 =?utf-8?B?MkV1M3E4eFVQL3AyQzU5bElCdUFFL1oxRFVOLzdRQVZoQzA0WjZVc0xCbHla?=
 =?utf-8?B?RCtYM08xUzg2ZFJaWHZIdUtqbitOYVMxRDdaN2JjVnhrQ2VTaU54Z1JVWEZl?=
 =?utf-8?B?Zk5EL0NmVzA2dnJYNzQ4WlloUVFveG5NMXpTSlVHS3kvcFZjK2tqZWdLR0Vj?=
 =?utf-8?Q?cUflPwgaFAqvPz15vw+Mt0sT3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359dc2ae-e177-4767-8536-08daae1eb57a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 20:00:14.4866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yn3nBb1jB/M4FycKBc/zNk6h4SAvMujtadguuyCHfbb8/ks+wMheKnVN5pFTqwCPZJM9WC55PM3OPA9CowMHBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 10/13/2022 10:15 AM, Borislav Petkov wrote:
> On Mon, Jun 20, 2022 at 11:05:01PM +0000, Ashish Kalra wrote:
>> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)
> 
> That function name looks wrong.
> 
>> +{
>> +	WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
>> +	while (npages--) {
>> +		memory_failure(pfn, 0);
> 		^^^^^^^^^^^^^^^^^^^^^^
> 
> Why?

The page was in FW state and we couldn't transition it back to HV/Shared
state, any access to this page can cause RMP #PF.

> 
>   * This function is called by the low level machine check code
>   * of an architecture when it detects hardware memory corruption
>   * of a page. It tries its best to recover, which includes
>   * dropping pages, killing processes etc.
> 
> I don't think you wanna do that.
> 
> It looks like you want to prevent the page from being used again but not
> mark it as PG_hwpoison and whatnot. PG_reserved perhaps?

  * PG_reserved is set for special pages. The "struct page" of such a
  * page should in general not be touched (e.g. set dirty) except by its
  * owner.

If it is "still" accessed/touched then it can cause RMP #PF.
On the other hand,

  * PG_hwpoison... Accessing is
  * not safe since it may cause another machine check. Don't touch!

That sounds exactly the state we want these page(s) to be in ?

Another possibility is PG_error.

> 
>> +		dump_rmpentry(pfn);
>> +		pfn++;
>> +	}
>> +}
>> +
>> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
>> +{
>> +	struct sev_data_snp_page_reclaim data;
>> +	int ret, err, i, n = 0;
>> +
>> +	for (i = 0; i < npages; i++) {
>> +		memset(&data, 0, sizeof(data));
>> +		data.paddr = pfn << PAGE_SHIFT;
> 
> Oh wow, this is just silly. A struct for a single u64. Just use a
> 
> 	u64 paddr;
Ok.
> 
> directly. But we had this topic already...
> 
>> +
>> +		if (locked)
> 
> Ew, that's never a good design - conditional locking.

There is a previous suggestion to change `sev_cmd_mutex` to some sort of 
nesting lock type to clean up this if (locked) code, though AFAIK, there 
is no support for nesting lock types.

> 
>> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
>> +		else
>> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> 
> <---- newline here.
> 
>> +		if (ret)
>> +			goto cleanup;
>> +
>> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>> +		if (ret)
>> +			goto cleanup;
>> +
>> +		pfn++;
>> +		n++;
>> +	}
>> +
>> +	return 0;
>> +
>> +cleanup:
>> +	/*
>> +	 * If failed to reclaim the page then page is no longer safe to
>> +	 * be released, leak it.
>> +	 */
>> +	snp_leak_pages(pfn, npages - n);
> 
> So this looks real weird: we go and reclaim pages, we hit an error
> during reclaiming a page X somewhere in-between and then we go and mark
> the *remaining* pages as not to be used?!
> 
> Why?
> 
> Why not only that *one* page which failed and then we continue with the
> rest?!

I agree and will change to this approach.

> 
>> +	return ret;
>> +}
>> +
>> +static inline int rmp_make_firmware(unsigned long pfn, int level)
>> +{
>> +	return rmp_make_private(pfn, 0, level, 0, true);
>> +}
> 
> That's a silly wrapper used only once. Just do at the callsite:
> 
> 	/* Mark this page as belonging to firmware */
> 	rc = rmp_make_private(pfn, 0, level, 0, true);
> 
Ok.

>> +
>> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
>> +			     bool need_reclaim)
> 
> Tangential to the above, this is just nuts with those bool arguments.
> Just look at the callsites: do you understand what they do?
> 
> 	snp_set_rmp_state(paddr, npages, true, locked, false);
> 
> what does that do? You need to go up to the definition of the function,
> count the arguments and see what that "true" arg stands for.

I totally agree, this is simply unreadable.

And this has been mentioned previously too ...
This function can do a lot and when I read the call sites its hard to
see what its doing since we have a combination of arguments which tell
us what behavior is happening ...

> 
> What you should do instead is, have separate helpers which do only one
> thing:
> 
> 	rmp_mark_pages_firmware();
> 	rmp_mark_pages_shared();
> 	rmp_mark_pages_...
> 
> and then have the *callers* issue snp_reclaim_pages() when needed. So you'd have
> 
> 	rmp_mark_pages_firmware();
> 	rmp_mark_pages_shared()
> 
> and __snp_free_firmware_pages() would do
> 
> 	rmp_mark_pages_shared();
> 	snp_reclaim_pages();
> 
Actually, this only needs to call snp_reclaim_pages().

> and so on.
> 
> And then if you need locking, the callers can decide which sev_do_cmd
> variant to issue.
> 
> And then if you have common code fragments which you can unify into a
> bigger helper function, *then* you can do that.
> 
> Instead of multiplexing it this way. Which makes it really hard to
> follow what the code does.
> 

Sure i will do this cleanup.

> 
>> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
> 
> No side comments pls.
> 
>> +	int rc, n = 0, i;
>> +
>> +	for (i = 0; i < npages; i++) {
>> +		if (to_fw)
>> +			rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
>> +		else
>> +			rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
>> +					    rmp_make_shared(pfn, PG_LEVEL_4K);
>> +		if (rc)
>> +			goto cleanup;
>> +
>> +		pfn++;
>> +		n++;
>> +	}
>> +
>> +	return 0;
>> +
>> +cleanup:
>> +	/* Try unrolling the firmware state changes */
>> +	if (to_fw) {
>> +		/*
>> +		 * Reclaim the pages which were already changed to the
>> +		 * firmware state.
>> +		 */
>> +		snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
>> +
>> +		return rc;
>> +	}
>> +
>> +	/*
>> +	 * If failed to change the page state to shared, then its not safe
>> +	 * to release the page back to the system, leak it.
>> +	 */
>> +	snp_leak_pages(pfn, npages - n);
>> +
>> +	return rc;
>> +}
> 
> ...
> 
>> +void snp_free_firmware_page(void *addr)
>> +{
>> +	if (!addr)
>> +		return;
>> +
>> +	__snp_free_firmware_pages(virt_to_page(addr), 0, false);
>> +}
>> +EXPORT_SYMBOL(snp_free_firmware_page);
> 
> EXPORT_SYMBOL_GPL() ofc.
> 

Thanks,
Ashish
