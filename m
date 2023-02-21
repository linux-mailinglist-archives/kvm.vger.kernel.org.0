Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D502169E370
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbjBUPbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 10:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjBUPbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 10:31:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CC82BF1A;
        Tue, 21 Feb 2023 07:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmvH8gBSAJi90u7MKDAU4NInAWGzdg99XuWGRzPy6+rEJcXGRnKCUgvjh2NVczP5uZn1Vd7poNbQyLHlRJ7XOwWEWH/X3zPLPVIvh+Y2oIC2Chp5XGzLUMAK0ztcDCeTpwTp8IOkESmYaqkyNa1A/1lKGh9Ogh4ATMnOCJz6s+mfhD3qo6bmdx2FlVRWMSp+GyTY4wWjOgY3Anv22UuDbZN0TCTLm903qPFZGkVpMofPT5b9gnGzuFoWPGFpyMfItmdCH0xVl6I8KqNilR50fdXrUrumpZhy8Wwg3kC81ufY7T2JYphxHdWwp3cMtGUfOMy0qbU5ms9duPNgo+sIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBPITLK/70/JdBXu5gXUM9tvTU9wC2Ljvmkz4rQtwRk=;
 b=QjHCUalgncsSg0NWUoCPLyuFffZGo14RSKk/EIsVZ1lIeHqejFuop9jS2lJOI4E0aTpMVjFXLBv+DMVMu67sOvLkcVihsD6epRsw1Uks85AyMcbg2fH8Xg+UIf+aAvhv8vY5Pk30plHdzwvd0nVCdts3BqRWof1NidNlJ+Sstx1b0tdxpWeQJp6jk6q3YLvXayk0aww1URhypaycIUIN+Rud0Kj/sWREcCpaBCFJa8kWDWY9ex6h+PVEWE0dZu/qSDOTuVDnm48k5tUDNlUTDfBLpNpomdemVmE9QsHEUMNC66cxOE6J7ykOQlxJtLTbOQ/v5uk1ZA6XYlu0RDxpNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBPITLK/70/JdBXu5gXUM9tvTU9wC2Ljvmkz4rQtwRk=;
 b=fPQeVmzNa6kf1BhTLHis7bRCw5Q2KM5Bj8qAEMkT9n5xgYuoPWFrekeKbM6VDyoNK98LEDenmx5tU5/E34WePRViVBw4P7G9q/Y4Km/xWZ7gXUIa7gPtMDeXLbFih9WmupENsvESBTTZq5DTdVxB+uU+S3USBn2yUFlO/aY7Hfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 15:31:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 15:31:08 +0000
Message-ID: <f70a2398-bd78-24aa-b0ae-9171465d50ff@amd.com>
Date:   Tue, 21 Feb 2023 09:31:01 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 24/56] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
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
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230221112823.000063e4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL1PR12MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ad02c0-1f07-438d-5ff4-08db1420a703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyNB53AH8o1+sr+8Og5SvStDh0UAurp3MjBj2B5rM/KLOi4wSXqjO6RYsmBSDlJJBYQmn1JHjPxYBsjaKJovNrTCnSXaCpVskh+25eZZsT8OJHD5Mg5cikUZ5CoEd4jqIpTkZJq9bmfc5AtujnVUFA01wAdDOF8kJsTP+CLSEcLuvayE1LcR859sQbsyrs7Yw4MHCy9cW7uUnuG5Dx59H8Atcrbf1uIsEVOfii3nDb83BfLS6E+2pgAqlQALelXP1WGx9wLEhGE8Iq+BoiUp0XsH32r3kGhAxlf1gKjdf81Lluv9U/FWY5dIa+7Zn8jja4wfi9Wa1c09liK2niahrjxxM/LL4JCAdiFbm3GhdDY71b+14vXRPOrCEjnBQ4VJGCKLzLGVnjc2rAbtVojefJpgEl8xlR9Gcx2HxhstVQ8PNunWCASEryXQGmf6reiFixfznqeoBRFLRHjH1LBSOF92w4CtJFPNQYt1NophZVV2qm9MR/C/wfID+SFWUM/QvjZQzbGBufEwZHxcAu78UaS221jdQ7YaRcTkerT92il/17mmu750iGh3c205V9JVwuClHDUaqDl8GyiT2l4ZB6SDXpjSv6bmcg1CAl4WZg6WoJFc8n2MXjkZf+TX/zGL4aFVDiPojJNwB5onU0okdI9l8jsNso9FUFsNjYDXJDMTBpwHZGWzpHpz841iu/UcI3QcaYdbV/owtwRVWidC4RIfTEbd0TFqMIS7EUylqZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199018)(8936002)(2616005)(7406005)(5660300002)(7416002)(31696002)(478600001)(8676002)(83380400001)(66476007)(66556008)(66946007)(4326008)(6636002)(110136005)(36756003)(86362001)(6486002)(316002)(41300700001)(31686004)(186003)(26005)(6512007)(2906002)(6666004)(6506007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFEzYU5DR2pmQlkzNGdXN1EyanNONklPRGxsRUpBYmYvUUdRcEJVc3Z6UFpS?=
 =?utf-8?B?QkJLTVduMVVpNFQ4azZkd2dwUzRhNnQyY3ZJM3Q5ak5wTXF0ajRTNURIVzJ0?=
 =?utf-8?B?WWtqQzdwaDhpTytOVjVvam04TjF5QkFXanF0Y21rQjZZNjJ2MXh5OVJMaVdD?=
 =?utf-8?B?L1hBMTBhUUltNVhHYjVjcG8rcDY5SVptUGx6MGs3ZGI3ZDdyNEdzU0ZhZmly?=
 =?utf-8?B?L1c0cUxEeVF0cUZKMzlLSFpjOUhLSGl0Rlg3cXl3VmU0RXA1cllIUTN4d1Vw?=
 =?utf-8?B?ZlBGWjBnVlVhaUsyZWNzd1Z3L1ZwNFU0VW81NGZSUDhyVkFiYW5vWkxwTTRv?=
 =?utf-8?B?SFBweEU1ZGNHazIvUCtsRUR6MktQcVVPYnN5akZCNWpqcmVMRGxGVi93eGtm?=
 =?utf-8?B?SHBnZ3l2VnZBbGljTjIzSno1M0ROUlhVSE5ibVJUTVJxaGY1Rjc4ZnNaUE5o?=
 =?utf-8?B?bnZCZGRUdjQxbitlWlRoMlE0dkE1cnJXREdxc0ZzOG9SMCtYL29YdWdyc3gy?=
 =?utf-8?B?Ukp0czduRm1FUFMwVld6YmVNd1VFMkt0TnU4dktCQkRTOFRWMjlMb0k2NnJF?=
 =?utf-8?B?T0Rpc2JYd1ZsSHEvWW02N3NUUHp5d0p0ZUZjdE9FWkN3RE1yTWlLdDhHOVZj?=
 =?utf-8?B?RmFGZDZjbmFBbHo2dFVBYjlPUzFzQ3JrNUFlclp5cEdwaG9vVjhJR1FqMWtY?=
 =?utf-8?B?OUpGWThRTzZ5c2dwN3ppcTF6aVVETGNLVG9GRnpVclJUYWREYTU4RVpZK200?=
 =?utf-8?B?eG1NM3lUbTNTREhmMitVZ0RkWkR1eEllUEVia2Nqa0xUZVE1TEswZ0pSSGxZ?=
 =?utf-8?B?Tm1jMzdDQ1NWVm9kaHBoV0VGUXFyczZJREV6cGVMR0gxU1NYaFkxNzI3dVNw?=
 =?utf-8?B?NVRYTEpsRGxkSTFxLzNSbHdpQ2NZdjRobXRucXhkZ1kvVHk5M0VnUWVpNERW?=
 =?utf-8?B?c2d3alhVZWpFaUhKNjkxNEJRcTN6SFFyVVhZZm5ReFc1WFR4ajlRMWZ2eHY1?=
 =?utf-8?B?YW0wS1I5eUJML2VRSUtSKzhIOGpVd3BlNkRzSlVUWERmSWVyQWZyd09DT2tJ?=
 =?utf-8?B?NUQ1RHVMTGhjdWZVeUdZL1dEa09oR0Y3VFZFek5zOVRtTTBQV3A4bEhlQllX?=
 =?utf-8?B?SzNEWXJTVWlWaFQ0MVMrQXc3WU1PbU15SFFPV3I4OE1FZEVYc2RZRHBkUzd1?=
 =?utf-8?B?S25ab0cvdkNpRW5PM3FnUmtNcTM2NWl0VSt2MGxWUEJwbDFuTzdZdUY1NFdS?=
 =?utf-8?B?QXBLZnA3YWk2TTdvM2w0Ymk5WXJKTUdEY0xMeEY4dlZ5UHNkRUN1UXdmcndq?=
 =?utf-8?B?NVhYejZnN0RkdDVkU2NDL1dtTDFoNUxNNTA2V0kwVXZUNXlEMEZ4WFQ4Wlhq?=
 =?utf-8?B?UFlya3MwZllaNzZIY2kyYlUrbnQ3SHdDTDNYTTcxM2ZWOW9vVTdEQU1ZYmlr?=
 =?utf-8?B?c2svRFdlQ0ZJOFFIMThrTVcweWZLSC9wbWZGWHhNMWRJdXN1RW1zbndEbGpE?=
 =?utf-8?B?c3pPckJud001V0ZvV25Xem5wdzNiUTBWRmpsdVllbFBIczFac2w4cFF0aW44?=
 =?utf-8?B?Zk9VTFhrUXNJWE5hd0pKaTFuK0Y4ZTFkYng5bDZPcE5hR2tCMnBwdCtDaE14?=
 =?utf-8?B?S1dUWjlpT0wwTlpBS0xMYk5FRlI4dENIeURHc2JDTE5ibW1yVm5TVS9RazZo?=
 =?utf-8?B?RHJ1V3Y3citGT0g0WlFOdHpvd0dseHJDQjEwTkxSdXcycVlnK0ZJTlJYZERH?=
 =?utf-8?B?LzNMc3Vtblc2c0RodFhBUnlZSjdDQlR3ZjYzUVV5SDBUcVVBSEVBUENtU0Nh?=
 =?utf-8?B?MXp3RlV5b2M0Q011Tlkzb2ZpY2J4citWTWlOME1jeWxtOE5UeExFeCtBMSty?=
 =?utf-8?B?K2pqWDZIZ0xaZkx1dkxSb2U1cU44KzhqVyt0NDdKU0FrMFBPbWJ3bjc1S0Rm?=
 =?utf-8?B?a3lKbmRjNE5kb1pmZDcvcFV3ck9yUW95elJHUFR5MG1FNituM0RKelZHdm9S?=
 =?utf-8?B?TWJMcDhUeGw0elF4ZnV4aWZ2a3o2WEs4ZnY2QmpXYll1eG9heUNYVWUycnVI?=
 =?utf-8?B?QStGaTIzL3V6Vkt0Tld1N25FaHh5eG43bEZVbjljVGlrbVpFdXJpUkQ1cXNz?=
 =?utf-8?Q?i4c81313bDvtrdWPkF4nLnhLO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ad02c0-1f07-438d-5ff4-08db1420a703
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 15:31:07.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfLmBQv6r6krbYJuKdZHUnbnGYYvsl/8EPXXAAk6oyCZVB/RH1PdiPH5YOwQzzwcGnftVTxrkWjHnsD4670eQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool locked)
>> +{
>> +	/* Cbit maybe set in the paddr */
> 
> This is confusing.
> 
> I suppose C-bit is treated as a attribute of PTE in the kernel not part of the
> PA. It means only a PTE might carry a C-bit.
> 

snp_reclaim_pages() is also called for reclaiming guest memory, in which 
case the (guest) paddr will have the C-bit set. Hence this C-bit 
handling is done within snp_reclaim_pages() so that the callers don't 
need to handle it explicitly.


> The paddr is from __pa(page_address()). It is not extracted from a PTE. Thus, the
> return from them should never have a C-bit.
> 
> BTW: Wouldn't it be better to have pfn as input param instead of paddr?
> 
> The caller has struct page, calling snp_reclaim_pages(page_to_pfn(page), xxxxx)
> would be much clearer than the current conversion:
> page_address() (struct page is converted to VA), __pa() (VA is converted to PA)
> in the caller and then PA is converted to pfn here.
> 
>> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>> +	int ret, err, i, n = 0;
>> +
> 
> should be unsigned int i, n; as the input param npage is unsigned int.
> 
>> +	if (!pfn_valid(pfn)) {
>> +		pr_err("%s: Invalid PFN %lx\n", __func__, pfn);
>> +		return 0;
>> +	}
>> +
>> +	for (i = 0; i < npages; i++, pfn++, n++) {
>> +		paddr = pfn << PAGE_SHIFT;
>> +
>> +		if (locked)
>> +			ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
>> +		else
>> +			ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &paddr, &err);
>> +
>> +		if (ret)
>> +			goto cleanup;
>> +
>> +		ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>> +		if (ret)
>> +			goto cleanup;
>> +	}
>> +
>> +	return 0;
>> +
>> +cleanup:
>> +	/*
>> +	 * If failed to reclaim the page then page is no longer safe to
>> +	 * be release back to the system, leak it.
>> +	 */
>> +	snp_mark_pages_offline(pfn, npages - n);
>> +	return ret;
>> +}
>> +
>> +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
> 
> The same comment as above. Better take pfn or page instead of paddr with
> redundant conversions.
> 

Again, the paddr can point to guest memory so it can have C-bit set.

Thanks,
Ashish

>> +{
>> +	/* Cbit maybe set in the paddr */
>> +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
>> +	int rc, n = 0, i;
>> +
>> +	for (i = 0; i < npages; i++, n++, pfn++) {
>> +		rc = rmp_make_private(pfn, 0, PG_LEVEL_4K, 0, true);
>> +		if (rc)
>> +			goto cleanup;
>> +	}
>> +
>> +	return 0;
>> +
>> +cleanup:
>> +	/*
>> +	 * Try unrolling the firmware state changes by
>> +	 * reclaiming the pages which were already changed to the
>> +	 * firmware state.
>> +	 */
>> +	snp_reclaim_pages(paddr, n, locked);
>> +
>> +	return rc;
>> +}
>> +
