Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F69580016
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiGYNqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGYNqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 09:46:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33049AE40;
        Mon, 25 Jul 2022 06:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaH8zZ3hld8DhdNbOTRdDKw/hgdftOwIZuTW0ETSE/hvb/afsP1DxyPGczmGb7SSkJDW1HoT020YWf4NsAnVZnjBhW6a96HU2HL3pggS7ME4YyM9XZCGOjd23T92DvqHIeu7J8Fj0kbJ2P4f8EI1yBfhJJQhyoM6GG9K2KykzHYdcgdxVzzF2DqJ7HlAUiDuh1EwhiE7hkl79GSvx/RePdGin1xa+U90W3IrnPAkSnO900L8E6sC0Fv2NN8ib67Rl15kDs8u42/g4ncTfk0lVWLJDwhmy4gqbq4TF8CXuJJno4uq+QGEcYydsDbzzOjquCzTH8mtsycot0nVMLPaPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swuGHIExufSyU2ZSdqdRv5+rKdcvTrBiII7QG+w+19Y=;
 b=cqETuCikEclfPKD0YOGno+T9jmaMuXBDZHUgBdTtaJ9QanW51JfhwzLjfF5Yxl+cd5TgFNvv8gkN3t/s4w68CFgSpo8+JMtcOpd8d6bp3L5wtf8qVVqQgGAhZBxRGO46H1cFnmQyGnZiVl4NGf+sT85ApMWcW6+9ToaTVh+9Z6xTnPc0TfRo/+BG2jtGhLG+Lo1AvxHgsCB0NDgR8qW5g8q8lbb036vu0pLJTPYW7JesWws2t2WNS1b52d88ZmCp5tt9kLSbSF8g5isKeT/KjxZz2XS1eTTAfe9+/nnX3UJ0d0IjKzYJo/w8EqXkIFC5UMdiF66Dveu/cezo29wOrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swuGHIExufSyU2ZSdqdRv5+rKdcvTrBiII7QG+w+19Y=;
 b=erguTXnW91C36TOuYFeehL1IcX4ITBVVM9DwbWuwjn2iUbN0OTNbfJ0Y3FDlYe+wGrPe/U5+VudzOIxi7B8ZePeDpPod+j7ouyGjPdMrI2Pbwil8bdmXAXpRr6BEGE2ezo8WLROXfmGhZ+G1Dhqs85p/O0TiY/om2uWd/gzW3RA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL3PR12MB6378.namprd12.prod.outlook.com (2603:10b6:208:3b1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.24; Mon, 25 Jul 2022 13:46:35 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d9f4:5879:843b:55da]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d9f4:5879:843b:55da%9]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 13:46:35 +0000
Message-ID: <d0e82407-91fa-cfa4-ff86-262075d23761@amd.com>
Date:   Mon, 25 Jul 2022 19:16:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com> <20220720145927.GA124133@chaop.bj.intel.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20220720145927.GA124133@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa466846-c42d-4445-a977-08da6e4416f7
X-MS-TrafficTypeDiagnostic: BL3PR12MB6378:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+hVYeGuOkrDW0PhOTlIo6S+xWjo7ep8ukWtjg4s9Ci+pszMd7K14QLhb7RDDX1qYubqpNWPXzEE+/k281/rO4KPcwyG/c3qXeOq2SdpNTgAQKEJala9JU5REisxC90b0ceZwEhUb+KzP8/HYL1F1Xypd0KcCkL8Rf5HlbB5splZ5rupZruzyCf9Fqiw6NXHNKlgpLEf6TxZ7bPTA50skCG1elZLQ8pYJt7BqqRluetSLgxIlTf/TujIl+lxrFE0V3BBPZFMCGnz+5YRuugRAzxTrA8u8h0cn6XjFrqO5T+YRTvVSgYPUJZMSAYq/lLjy9NNL3gLGzi6lA96tKdnCBcoCvFewt9nmBAe7Vhxqp1TeWWjdq+krG1eQjeKUHxckH5slhHNRM4lXW8MDA6BL51OSk10753XA9dvRdWrDaI44ay6EL/oK4lKY40sDGyLvvPeND1hff49vyQLJevRZqUl35Nm54jmb3UntkXJu3naUSR/R94eIK2gWpSHW4BEhbQDY62NnW5dTpLcaATpvj5PQyRn5TH9/a8Zo2lZO/7CXzoHfMGTFpe0Guwk/YXlP+fqJpDzDruIBbZ0eSTSZoZar09oo/Lt7duA88rMB4j4gNhSr2chVjUkHQRM5m1OSfgBDs5bCiPdcavywLAP7QXHqnouLLw+CL6ei16wGVwWkEipt+dMGrsKXDya3dJDkS3z/biFUbSvzqHnSknXP6BYdGicFa7OE19wq4oAdiRiccknUXMXbZ3b+9H3qAtjRoFvX2a8NZ6ZXxYgJdy9Bg3QuFecwv90VnvbGaNeqOaGFdyLRT8h3i7gqSdu/rWuTEMxwAv1KrWUV2AQfenazd4YCHs5IJurNZgK3ULHHd0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(6666004)(2616005)(6512007)(31696002)(2906002)(6506007)(53546011)(186003)(26005)(38100700002)(83380400001)(41300700001)(36756003)(5660300002)(110136005)(66556008)(316002)(66946007)(966005)(6486002)(478600001)(8676002)(31686004)(66476007)(4326008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXpkM1ZNbDA3b1kvc0hlaFhVb3hPUFdmSzNVek52ZjhwK3RESHNwTGdGTzFP?=
 =?utf-8?B?eUZnaWN4QWcxUi9OYTEwZVVHNVArM002enVZak0yaHlQK2UwdkMvUi82WmNC?=
 =?utf-8?B?Y3dkdy9sMUQ0NDlTNUIySVN6MW4wWXVTeHNPaHY3S29NQUdaR01qNWhvMHly?=
 =?utf-8?B?M3dKL0FFYlFhNy9kN3g3c2JkMWpmL1hvd1hJN3liUTJOcG5xNDZxZjBzNDU1?=
 =?utf-8?B?eGRSZTY4MmZ1Y0MyZWtrcVhGVjl5RXdMdGRRcGRlcVltNDB6RmN2dVh4cmF0?=
 =?utf-8?B?djVrRC9DdEdNVzlTZW9nMFc4VjB6b3F5MmVZcVNQWmlkZ3diT0wwSmxnSEdP?=
 =?utf-8?B?WTdkaXRJOVNhanpXTGxCVitjNWVZbUZWMHRVbTk1cjc0dm82WXMxYm9SVms4?=
 =?utf-8?B?VkJLZWlxbzVTTnphRng1YUVuTjJ5M1UxeXROYmM5Ny9kbmdOMFkzZ1NiSU0w?=
 =?utf-8?B?QTJXMm9LbTNrejByYXhQV0NRNWNKakJpTHRseUY5RlpMQVVmT000WGZLYVN3?=
 =?utf-8?B?MFMvbUtyaXdhMzZRRGZFZUNDZ25CQTU3WURkWnU0Ky9mdmk3dWtRL0VielEw?=
 =?utf-8?B?R0NveVNNWnV0ZXg4Z3phZlJYaEpUSUpNVXp4WHVZSFduUVN3TExCZTIrRVJO?=
 =?utf-8?B?VDBsTmY0T3V2NXVsRjNrdm5taUZBZm15cGptdmtSM0xpV1BDSHZSL2xNemhR?=
 =?utf-8?B?Y0oxRmQ0M010K0lxemhNa0FHNzVtNUhpaytDaWlyUjJlbkY5K1JZQWtYUkdJ?=
 =?utf-8?B?a0pvRVhCc3Z0L1BVTmdWVFNmd0cyRzFQcGVhRnhaU0hodzEyK2NWZDJoeEFM?=
 =?utf-8?B?d2FRcHZ2N3VjcmNLTkQyd2lBTFp2OEFlcHVSM3JDV1Z1TksreWw2Z2FKZG4w?=
 =?utf-8?B?QmJ6azdvTE1DVmZneUg2U3RTS0pPdFZaWlk1eVZSamhMMEY3MnZyUUFYazU4?=
 =?utf-8?B?SGVqRUNqU3FuQ0R6b1F0K2NWOG9JTDh5bHc2U05nWmNrb1J2NUNnUS9TYW5w?=
 =?utf-8?B?aDdKUnF4SkpxUTFXRHMzY0o5T0lXZTByMkJlazR4aVA5bnl3NlQ3M04yd1Bj?=
 =?utf-8?B?aEp0bWxFNndPZ2FXcWpiL1RFcjhNeWxRN2cwSTJOckNzQzNKN2d4aVpBelZS?=
 =?utf-8?B?U3Z3VkRHOWdyZTd0T3kwamcxYjdZVG1jR3kzZXBxLzZNbVZ0OHRHeHBLalJF?=
 =?utf-8?B?OFJ1WTZFc3MxSTl6QjhMd3VwK0hzU0hyZUZ3ZXh0V0ZKRDFKelI4UCtpNWlU?=
 =?utf-8?B?QTIvTmt2ZGRUTHZoRFNrUlFpN3lYL0ZvM0N3ZGZOamliamc1T1RJSFAyc0k2?=
 =?utf-8?B?d3dyYlpSYnNJQWdobkdQbzN0VHhMTGtHSjBDNlhvVldUWVUvWEs4c21UUFR3?=
 =?utf-8?B?eHJtb2NhVmF0ejRLMVczQUxNMUxpMnA2SHRsVkNNWGY5a1k4bXdLTTZUdENF?=
 =?utf-8?B?bVhQcDQ5YTlZV1hjT3V1NEs2aElIUi9qUTZpQTdHR1Roa1lCR0J2NHJkcys1?=
 =?utf-8?B?NDZUQk93MmtrTFNnZ2NhWXRnMTZMbmdLVVdpZEMxSnlXNjdKT0dwMGFtMC9L?=
 =?utf-8?B?UmFJNmJnL0FKbFZ5UDlVYm52TnlGZ1N2V202V1poS1MzdFVpOGdxS1E4K2h2?=
 =?utf-8?B?Zm42WElDUzdCZCtLdGJpVDh6MHNvQlp5WFZSYllmdzAzTU91WW94aldrMWdu?=
 =?utf-8?B?OUVrZE1Wck1YaEk4Ukkwam9SeFFoQm1tZUZpSHN3VzB0OHVPRlpKNHJQZzJr?=
 =?utf-8?B?Mk1OUkdYQkRTUFVPMGxzUzFHUHBJSUZTTW9QYkhsNlQ3bC8xTkVxN2tsY0Ju?=
 =?utf-8?B?ZzJaY1cxUFZkR2V6RzlyZ3VVZkFpa3k0ZTRCM2NWWldqMEdOSEpjMW9NcitN?=
 =?utf-8?B?VTBLQVgvbEppcnorSFltcFUvQktUVENmc1ZIcXlvVlNsdnR0T0lxSVR2anFF?=
 =?utf-8?B?WVNaUkZRR0tKVUJSeENkbHpNdFBpcnJNeGR5RzNBdlNHZDlYMjJucy8rS2Vo?=
 =?utf-8?B?TGVPcXFYRE8rcE9uYmFDbllnaHRoQmhSNG05WGNKdmJDanZaQUVBVEd5Z1dW?=
 =?utf-8?B?WkFEbDU4R1dkSFV5TVlpTHppT1EvMnBUT201ekV2ZGxPZHpRZ05VQmowTHFz?=
 =?utf-8?Q?A2R/wq4UbzsqrW5ZwcteP+Ef8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa466846-c42d-4445-a977-08da6e4416f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 13:46:35.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/g+xsP1qt6xXvaR1+TGKmmxD/JRZO3+16UW6I9LcHsPc0UIN7Hg6Fux80eUrDAAkOY0rofl2O4vAPvy7jerng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/2022 8:29 PM, Chao Peng wrote:
> On Thu, Jul 14, 2022 at 01:03:46AM +0000, Sean Christopherson wrote:
> ...
>>
>> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
>> on insertion/removal to (dis)allow hugepages as needed.
>>
>>   + efficient on KVM page fault (no new lookups)
>>   + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
>>   + straightforward to implement
>>   + can (and should) be merged as part of the UPM series
>>
>> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
>> completely covered (fully shared) or not covered at all (fully private), but I'm
>> not 100% certain that xa_for_each_range() works the way I think it does.
> 
> Hi Sean,
> 
> Below is the implementation to support 2M as you mentioned as option D.
> It's based on UPM v7 xarray code: https://lkml.org/lkml/2022/7/6/259
> 
> Everything sounds good, the only trick bit is inc/dec disallow_lpage. If
> we still treat it as a count, it will be a challenge to make the inc/dec
> balanced. So in this patch I stole a bit for the purpose, looks ugly.
> 
> Any feedback is welcome.
> 
> Thanks,
> Chao
> 
> -----------------------------------------------------------------------
> From: Chao Peng <chao.p.peng@linux.intel.com>
> Date: Wed, 20 Jul 2022 11:37:18 +0800
> Subject: [PATCH] KVM: Add large page support for private memory
> 
> Update lpage_info when handling KVM_MEMORY_ENCRYPT_{UN,}REG_REGION.
> 
> Reserve a bit in disallow_lpage to indicate a large page has
> private/share pages mixed.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> ---


> +static void update_mem_lpage_info(struct kvm *kvm,
> +				  struct kvm_memory_slot *slot,
> +				  unsigned int attr,
> +				  gfn_t start, gfn_t end)
> +{
> +	unsigned long lpage_start, lpage_end;
> +	unsigned long gfn, pages, mask;
> +	int level;
> +
> +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> +		pages = KVM_PAGES_PER_HPAGE(level);
> +		mask = ~(pages - 1);
> +		lpage_start = start & mask;
> +		lpage_end = end & mask;
> +
> +		/*
> +		 * We only need to scan the head and tail page, for middle pages
> +		 * we know they are not mixed.
> +		 */
> +		update_mixed(lpage_info_slot(lpage_start, slot, level),
> +			     mem_attr_is_mixed(kvm, attr, lpage_start,
> +							  lpage_start + pages));
> +
> +		if (lpage_start == lpage_end)
> +			return;
> +
> +		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
> +			update_mixed(lpage_info_slot(gfn, slot, level), false);
> +		}

Boundary check missing here for the case when gfn reaches lpage_end.

		if (gfn == lpage_end)
			return;

> +
> +		update_mixed(lpage_info_slot(lpage_end, slot, level),
> +			     mem_attr_is_mixed(kvm, attr, lpage_end,
> +							  lpage_end + pages));
> +	}
> +}

Regards
Nikunj
