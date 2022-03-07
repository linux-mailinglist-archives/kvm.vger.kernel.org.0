Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE44CF265
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 08:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiCGHJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 02:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbiCGHJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 02:09:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65A15D1B5;
        Sun,  6 Mar 2022 23:08:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGvJhNPdLvypXFyA86DUM/6zPImuQQhJYc7V2mBoEvas1cEG1dWHtibaXFbM1ZRgUwwBVKz0mK0UYqscnvByN05/z/iD7SOkwOWugCKWKU5GFj4zDaIAzO0mCvfLoNbxbamGeqbKbzGBnYkdLe9S4YjOTHazQjBgkO2PHW1eV7OCyletdaXEjY0E+DxMkWCTL5KjrQPY/MtGYEuN0VuSbAv2+I2Qon20T/QLJyoVfU8xatR0FtB01fjuBEvZGl0BPeYI9vJT1qc6/IB+wEIf1jytkHKTx6jCXztxV03bW6PRhPO1G6oeQoiSH8PnNAf4u7P/zVY5Mxv5LdCZL0zVCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJ2859RNzi97GF6r7oDysB3AxuDGpDSJ8lm4fn7AEvo=;
 b=gfZ6M1aXDGef/XYHc0tKSaPSyXUy03zFoHByabxRZb85WeAXzbOW2K6ZI5QS6U8QirVOOc10HKlkeD326BgvktgxBBNEkBWX2oXmoRT9RShDpF3+4dVXKj72ja2mnxROHti/tdpOHlBa4pTNrJfRL8WltuY+bPo3oFuqiAleaMmZpaUgrOdfgXSRCCgN1k42DpxuAoPZTmQoJTHOAjHw1CgQ76NivA28A4HeYEEYLkWcb74e2HXv9RN45do5bTQnINCeyNUhFxjwp0TVowwvHucsEZze2bkgesoDTBmlmf9v7WaQFt8eOpxNcYEkIL8HX4qYBP317kHtd7nRTxel8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJ2859RNzi97GF6r7oDysB3AxuDGpDSJ8lm4fn7AEvo=;
 b=b93iPJoHGg5xaogprzBgsLDwrqEG0kjM6zqADtxbaA4rcA8elCimSdnfBr8azjnzmLCCJnkpjU7Uy3bxtg/hdNW9Ri8oZBCCFEa8uwe+gJVQdDhWqs18WMfybmpZLB+31xj8hEtGQBa5/pWM8YI2o5n5P7RBH1P5yL14HppOHJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21)
 by MWHPR1201MB0126.namprd12.prod.outlook.com (2603:10b6:301:57::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.23; Mon, 7 Mar
 2022 07:08:54 +0000
Received: from SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::5d1f:4060:d060:62df]) by SN1PR12MB2477.namprd12.prod.outlook.com
 ([fe80::5d1f:4060:d060:62df%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 07:08:54 +0000
Message-ID: <b5641fdf-6360-acb4-0050-196c08fc07f0@amd.com>
Date:   Mon, 7 Mar 2022 12:38:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 3/6] KVM: SVM: Implement demand page pinning
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-4-nikunj@amd.com> <YiUQDHdT0DB/mYVc@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YiUQDHdT0DB/mYVc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN1PR01CA0106.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::22)
 To SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9849410c-10a9-43eb-9805-08da000956ce
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0126:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB012619903BA1974937C82E6CE2089@MWHPR1201MB0126.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7x+6F8b97YiEQ2tbESZrGYSlBC2cWW7ByqpemMVhiKikTUHhrS/jPErBTldC10qUy2WkHySLKJqHiy0M/Sli10/fj30bMgtS74pb8iEgPZO4z97VegPOczny/WzwZdgKoOn+HNY4pzhC6KvGOBcdsNcehecdRcXoa3aDn9ofWFpXvtLvjxjEG3BoH/3zBPBS2goxst0KTHfDt5mfnLEJVumjXpmufvjTSOxln6uxdv4tMiXX5UcPTKFpDtiL2uZ2iP5NUj9NcnWeSNvqKAE/SZRjx3fQEoAAZMNuW3o2pxD9JQRpSTM+4QIrWgm6Kaf8tppDYrSCR9Cw9CFxPcmpHgsXM+D9hGfz2yu2/R58YMVTWfRtcC4CTC7jB624s3hnlrrum9gKSHbMjD7g8vYCcUcpIlzQwpT6PY9NzJCubDyHQo4etfUWnbbMEwDtzAYIgcU1qBjAA71+vyfJUx524DgqjigUjY91JJO6powZqiGvkvgmRcF4ulaUqSr7QzDeud7fV6XaI9EI80Ro8GjglAw/fp0/1o5c/GUFtXnP8mTMRtQCRteFfe3BN8p/cvUoDAiZFvu8z/ATQj2NBHiO3/ASBuaSeshZmLDDKpF/AYJjlT5MN4w91g9jsNU0X8w27yJ7KxiSgegcXEmNlDhm4k6wIsQFjf7dH0K68ldt/PLs304gkVM205yV5lQDfX0aFbuNcZVYNMy1wmp9L/KixBAkSOTJiZR75lo4D0MUlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2477.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(6486002)(38100700002)(66946007)(4326008)(8676002)(6916009)(54906003)(316002)(7416002)(508600001)(6512007)(36756003)(5660300002)(26005)(2906002)(186003)(2616005)(6666004)(8936002)(6506007)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzJlNm5yL3Z4b2tzcEFJRHd3RTMzWHlMK1R2VUNUNUVXQk9aZ1psNGZtMnho?=
 =?utf-8?B?aC9SVjU5V05xeDVDTmlPMy9oZXAzdDRjN3JNamNGZ2ZFck1qMFJrRWNpRFJ4?=
 =?utf-8?B?MVhjZU1CV2tDVFV2blRJVm4xWm1sM05LYWFRUmFISk5LYTkvUU1QOGRZVVpq?=
 =?utf-8?B?d1lMdVFROHo5SStSeThFSmpEWDhQZmp2blVkSHdEUTViQnBsNk9EM3AvT3JD?=
 =?utf-8?B?MTkrWFBPWGNkOE5IVVN2ZWNyd3prV2YvUTg3NUV2NWM1MnlXWEVLR1ZPS00v?=
 =?utf-8?B?NXZ2YlBIVUlVV05UelZYN2VlbGdkWExHNmk4VG8yaWd1UWhlWFQ1Zkxrbi96?=
 =?utf-8?B?K0VJS3Rkbi94Nkl5SEZvMjJHR0xuODBkdkdCVWNXOXgrWmZwWjJ1Yk5kd3NR?=
 =?utf-8?B?cUw0TUFLQWxBNGRrVFI5WFZrUTNsb2taV0NISGMvaG50clNQVjNBdDJpaWZM?=
 =?utf-8?B?dnQ2REFGNEg3Q25KQnJJTkNMQXZpc01ScmlRdUlwT0dwaEhEYkdkdDF5MzRk?=
 =?utf-8?B?d1puZ3Rxd0pDaEt0OGEyOU1PTnJxaE82V0dxSkhnUUFGL2Irbjhib3RmbllW?=
 =?utf-8?B?SVdTNUlseHY3ekpwU1VnOW1RdHljWm16SSthRUxTRmNLNE12b2phNXRaM0Jh?=
 =?utf-8?B?SGdld3Y2RXZYcnRNTHlqT3NEZGd4RkVoQnB6emtIWHNrT0IrZ3RaMUNobGcr?=
 =?utf-8?B?c1FBTUtseEhkZ1VNNlBmaDNwZ2pCaFlwckkyT2V5eHFrWlg1d2Qxc1R0RDZw?=
 =?utf-8?B?QmQ3OTRBNjYxb3hwSDc5OVhsSXRzSlJZaUtQZ0hEd3RrMm1VNk9RelFGaXlY?=
 =?utf-8?B?Mmp4eU50bmthcExBSHhhQUZodGJMdWNJN3hXQmRENnQ5UDAyV0xsYW1ZUDFv?=
 =?utf-8?B?WTIyUlM1TmZRMXYra1MwQkl0S0ppcVJlZ0E2QmlXZjVKZ25Tejd2aDhwcGpW?=
 =?utf-8?B?U0dOM1BhTWNYWjYxaitXKzJveHNtRTcwd3JzU281a2xCb3hQL1VpU1UySi9r?=
 =?utf-8?B?NDRxNGhyZzNLMUdQTFBqd0ViTTBzemZkek5DUEN0K3dGTUYzc2NSQVUwMEk0?=
 =?utf-8?B?ZTd2S25iOWIzQmNzK242MkdkSHh5NFdXbFo4dGhzM2pLSEZ4OUJ3YitzWUFW?=
 =?utf-8?B?Y1JiRWkrcU1DbElaWE9XTFZxRDlPdWRiVHZKRHA5QXJNa0h0eXVnNVBnR25s?=
 =?utf-8?B?R3JOalpSMHU4cjdQNnAralZHdGE0V1R2RExBZUl5RUIySG9VUDAwUE1Hanpp?=
 =?utf-8?B?NUpLcjJTTEZjQkdoSllEQUtRZjZRUzU0a2l1UGNMZG0xVHRnMk1FT0czOS9I?=
 =?utf-8?B?NG9HTTZBTHNvSTNINjJoaUNxY2h1TS9XTTZPZ1pZZXBKdm0vVStYK2lnRnU1?=
 =?utf-8?B?anlJdlV0T0JDTUdWMzNLMnZrbWlKOUtvWW1pOXkrNDBoRENNTyt0SjdCNW80?=
 =?utf-8?B?WnNEOWZGcS9TN1c5b0Y0d05NNC9TV2FXaU9PN2lLRm1RSnhKVDZUdzFGVHdS?=
 =?utf-8?B?aXV5Qk0yamg0b2hwWlRQbG4vb3hxWGZCRWF0SFBjcVQ3Nm5lNnlyY3NBcnFV?=
 =?utf-8?B?WGlmRERrQlBCTWJibGZxZVNWdDNCVThyM2Q2eHlNcU9mWWFnZHlJdnZFcFIy?=
 =?utf-8?B?ZGluL3YvVlZ3VUwzTkw2UXEwQ29NaEJTQnc2RURydkdtcTlDRmRhR1lFWHFr?=
 =?utf-8?B?cThzdXJtcDhlTVZ5bW5ZZnQvVk5DdWJKaGdKWlozaUc4MjRFV2dkN0p5VC9T?=
 =?utf-8?B?SmgrSmt1QThQOG9pQWlpd00wNW1QaitwK3RNc01ldHVsYVdld05wUEE0WU44?=
 =?utf-8?B?ckdQU1JXamc5Rks1eDhhUGcrRkdUQzRlTUZiREFLY0JzOStWNXRBbEtZY0dB?=
 =?utf-8?B?bDZGWVpRcUd1NW5xNUZhSEdxa3V1cEVOQkxUcGRWWVdET0dmc1c2aVBHei9S?=
 =?utf-8?B?NFg3QXM3Tkw4aTcyV2RZUGhqYXREcmdBNDR2aHhsTk4vbDdnb2hTRFdzS1lL?=
 =?utf-8?B?ZzNZUmllaGhOMlhOKzNuN1RyVHovSU0xWG9JR0ZGZVJaMTh6d0JrbHkxSTRE?=
 =?utf-8?B?a0UxTU42WEJvNmVYU2ZMSkpoY1BKWXhZM0JubEI4aGNQbWE4YVJSdU9lZWg1?=
 =?utf-8?B?cEdKR2pYNHdqUUtrZTVTWWowMEEyclliQzJmdVJUREYzellVRWJQNzhTT241?=
 =?utf-8?Q?g1DI4QVrGBdQFhK7qoGyyOo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9849410c-10a9-43eb-9805-08da000956ce
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2477.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 07:08:54.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKOfI5wiDyeNfih+yT34DbR6gv63moy8DGIBUOUxewir5UT+9le2xEz6xA0cedyNnjl3G2RNrJBTHGQ7WETMNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/2022 1:18 AM, Mingwei Zhang wrote:
> On Tue, Jan 18, 2022, Nikunj A Dadhania wrote:
>> Use the memslot metadata to store the pinned data along with the pfns.
>> This improves the SEV guest startup time from O(n) to a constant by
>> deferring guest page pinning until the pages are used to satisfy nested
>> page faults. The page reference will be dropped in the memslot free
>> path.
>>
>> Remove the enc_region structure definition and the code which did
>> upfront pinning, as they are no longer needed in view of the demand
>> pinning support.
>>
>> Leave svm_register_enc_region() and svm_unregister_enc_region() as stubs
>> since qemu is dependent on this API.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---

>> +
>> +	/* Pin the page, KVM doesn't yet support page migration. */
>> +	for (i = 0; i < npages; i++, rel_gfn++, pin_pfn++) {
>> +		if (test_bit(rel_gfn, aslot->pinned_bitmap)) {
>> +			old_pfn = aslot->pfns[rel_gfn];
>> +			if (old_pfn == pin_pfn)
>> +				continue;
>> +
>> +			put_page(pfn_to_page(old_pfn));
> 
> You need to flush the old pfn using VMPAGE_FLUSH before doing put_page.
> Normally, this should not happen. But if the user-level VMM is
> malicious, then it could just munmap() the region (not the memslot);
> mmap() it again; let the guest VM touches the page and you will see this
> path get executed.
> 
> Clearly, this will slow down the faulting path if this happens.  So,
> alternatively, you can register a hook in mmu_notifier and shoot a flush
> there according to the bitmap. Either way should work.
>

We can call sev_flush_guest_memory() before the put_page().

>> +		}
>> +
>> +		set_bit(rel_gfn, aslot->pinned_bitmap);
>> +		aslot->pfns[rel_gfn] = pin_pfn;
>> +		get_page(pfn_to_page(pin_pfn));
>> +	}
>> +
>> +	/*
>> +	 * Flush any cached lines of the page being added since "ownership" of
>> +	 * it will be transferred from the host to an encrypted guest.
>> +	 */
>> +	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
>> +}
>> +
>>  void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>  {
>>  	struct kvm_arch_memory_slot *aslot = &slot->arch;
>> +	kvm_pfn_t *pfns;
>> +	gfn_t gfn;
>> +	int i;
>>  
>>  	if (!sev_guest(kvm))
>>  		return;
>>  
>> +	if (!aslot->pinned_bitmap || !slot->arch.pfns)
>> +		goto out;
>> +
>> +	pfns = aslot->pfns;
>> +
>> +	/*
>> +	 * Iterate the memslot to find the pinned pfn using the bitmap and drop
>> +	 * the pfn stored.
>> +	 */
>> +	for (i = 0, gfn = slot->base_gfn; i < slot->npages; i++, gfn++) {
>> +		if (test_and_clear_bit(i, aslot->pinned_bitmap)) {
>> +			if (WARN_ON(!pfns[i]))
>> +				continue;
>> +
>> +			put_page(pfn_to_page(pfns[i]));
> 
> Here, you get lucky that you don't have to flush the cache. However,
> this is because sev_free_memslots is called after the
> kvm_arch_destroy_vm, which flushes the cache system wise.

I have added wbinvd_on_all_cpus() just before the iteration in my new version.

Regards
Nikunj
