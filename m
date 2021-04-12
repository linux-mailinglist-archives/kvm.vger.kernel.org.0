Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3E635C6C7
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 14:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbhDLMza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 08:55:30 -0400
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:10208
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241271AbhDLMzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 08:55:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fseZ+O443Heb/6u72XthtKbW15MaIi8BbHcsJxZZ7Ml7P0cqEhNd6vIqpUDpOzE3O1rlhAjPhszAew+XDvDKua4DcLwUOqIhzCtjUjsmI2YBbNP645O6q25r81BKhKs5ONFRU2XSNAbDijxRu0dMf+AqF6msIjeQJ6V2FhkRWn4wG3NTSG/+l+SuCV6IrRRg1ATCQ1qpnGUchIXuzaN/yMuPNZFhBf0plMPsedgzaMfpGH8qvt2zGVGce7VxT2u6EoJhdMKfOCU6bPI2PqpxzuLcxR6afnIRJb1fUq7QLUsuX5+aLE9H6NpJEkijeaP6Wie56py22ezEPn2kKodExg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnA6GjSAOwYQNdq4zpOXi1EVvMFU/M5+PH/NztBoFiE=;
 b=FtaGuJRRzFbYamggSKF1nXYaAM7bNMnjZHpC/5iRyOoKOJMXNZn+r1d1WVB9QMn+HxuhwL/BE90AiOR9vO3UCqd1tKIwfyRngHloFDyfIlV0AUH1qFLTM/5HMbB/Fsuhkc81RupL+cROlgL61cXS+07646DJogJLv+yY8YL7zJ8HqxJQXUiaUHSyWyjHb71wrbt7w55PeZIfiDahw9sOe8bjBuBGaVx00IeaSuuUNaMsHWtBh8DhzpDZ0SX4MmNS70gIp9LxaX1aSUh+SydB2NryBZ7ewHJ5revwR7ZZHo8dAPz37W+NrS6KDOCSBsQRJuHIo5zKhgZEUA0dGJBCuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnA6GjSAOwYQNdq4zpOXi1EVvMFU/M5+PH/NztBoFiE=;
 b=RTSxMz6RrdIsCoYsDj0nBKEZU6R7RN3f4+jbWSW6bjaYfwIQRZvGyvIjtrZ/7wyn7gblL5nRGdrdVsr2j5jwAUxQvRa7zyMXWQr7kQ8LIWRojKQCiNS2JPGn6mE2ngzBw2MmFSGulakDHFmk2caqZYlQoDKFEeE+9Li+x6y1NF8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 12:55:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 12:55:03 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 13/13] x86/kernel: add support to validate
 memory when changing C-bit
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-14-brijesh.singh@amd.com>
 <20210412114901.GB24283@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f9a69ad8-54bb-70f1-d606-6497e5753bb0@amd.com>
Date:   Mon, 12 Apr 2021 07:55:01 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210412114901.GB24283@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0010.namprd02.prod.outlook.com
 (2603:10b6:803:2b::20) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0010.namprd02.prod.outlook.com (2603:10b6:803:2b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 12:55:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb082c33-1839-477a-9a1c-08d8fdb230b8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4349D6C4D46D2F004F9BCF02E5709@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKMyj34lu9ILRmupiIZH/tgvUvAz0ZYFI/yhPNd18/wU3MNDT4r9/OfogsyWqBYX+g+u5P3eoUV11x4iC2z+lkOwB2RxKJ1P+bFKSJI8+mLl2NyXCdOxaNwjCEhomM/asmFbdzctF3qRk6suPAryudJkxs6jqjstIvgm994HMbQGfxyfTQ1kcOANWsjciPZLthfSJxAZbfK50P8aJ6WpMnQA95fW7BTQbxhD1+aaacus6dnaXLbwB2/Y90cGLV7h2+jInXSIM4tk+V9+NWUrbEgyNjZpFeC8GzLA64ZPQ4s7/qUemVn9sa8wqm9Ek6Vaphq+k0OMFwnu69plYkuVGXHOnLSYZOOI+pkKLZvEQV1meIrXG6Hhv3yWeXeeqaGeK8655hPiAvDvGBxC+jHBwsF52Lh4cAWwkd9vPEXfovlzLuCiTZpLlz8SNvIC5WGLR7L6EQFY1sIrBqF2NSZaQ3GIleVUpoVG4EFwssGCBMWwipTFWcQsXb5SFijen3WmQ61BSZpxFQzLPFe1mvQiUyWwKisYPAV9pxkZpTrW+YawSDJEAO4pkW4GpYL8JNcoZmmdgPhFL8pYrwMDG4znCi6PUBPdA0xQ9xSs3BWXiqzCIfHiBzZmMfAnWTPse5X/1icbGQErIQCQQ5+2eYBNQmlPGZRBZTZMhiwuMEHTw/URDuIDtiv0LAZttaW2rVuh5f+HMILyMZI3Yf9DIh+hvYbhl7P6kkpdH2jpdusWcx0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(36756003)(6486002)(31686004)(8676002)(38350700002)(15650500001)(6506007)(54906003)(31696002)(8936002)(26005)(66556008)(66476007)(52116002)(478600001)(44832011)(6512007)(5660300002)(186003)(16526019)(2616005)(4326008)(2906002)(66946007)(956004)(6916009)(53546011)(86362001)(7416002)(83380400001)(38100700002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2ZqZXNOUEowd0JweFI4WlFVcmRZdlZpZTg2eUprOFZDbksyc1dhbWdLV0U4?=
 =?utf-8?B?TDluQ3JjaDJ2K0d6ekJvL1RNQVIxL2s5TngyUGRzQzB1eVE2c3FxZTI5SU1r?=
 =?utf-8?B?L1JGOFRwN3IyMHJ4SHVxQ0dEL3ZPRSttaml0M0VRV21PNjhUUmNKWnhJZ1F1?=
 =?utf-8?B?NFhaSDJNYjRoYjFNc3B3Lys3SGVudnY2Q2I5T2NqM2JZU0cwOEZhdDN4cktq?=
 =?utf-8?B?TExzMWhDL2hxakJ2cjVyUERWUHZ2ZEN3Q3l4eE1qZWNpT1pIQUtuNW81Y0Vx?=
 =?utf-8?B?bitseHd4b0pWelJmZi9iYm8yaFVrNjhmemhiclUxRlN1SGlJaFRzajQ1V3ps?=
 =?utf-8?B?Y211UlR5VWh2UmhRT1VzQVF1WHZ1Z2Z6QVNUVVRxTW9xdXdJV1I5K3A3b3cw?=
 =?utf-8?B?a1M5WXJtL2VYMnpwT2Y1SmlRSnFBUXM2b2RETVJYdHJlZ0Y3SFp1RVRtdUln?=
 =?utf-8?B?L0sxY3JkRncrL2tFSnhIRDQ4L2szTmdCd0NTV2pXTHJyZjc1TmJmc3lqay9N?=
 =?utf-8?B?OFdpNmF2VFFWTTVzWWhVeEN3YkNYWkM3VXNSUytwMm9kQmRzNFlmVU55Q2JF?=
 =?utf-8?B?SXpueG12MkEzTnRnTXc3aWR4M3M3WDR1U0ZSTG1vdFptdVE2N1ZEMno3amR2?=
 =?utf-8?B?U1ZveDk1L0ZMK0dTRXh1Q3V0Y0ZHUFQ0OHpEUWt5bGZJeitLUGFIbkdvS2hq?=
 =?utf-8?B?c3g5c1FyRGRkSU03Z1R4T0NPbXRVRVlPdlJZVkxWYzhKV1NOOGhiNHVuanFK?=
 =?utf-8?B?b0tjSWFWM1NiUVkycWVPUWdhK1RZZE5rUEFMd25jajZEeUZWYkdlKzd4Mkta?=
 =?utf-8?B?eDZWZ0ZSS3AyUXhFYnIzYlIvdWx6amZPQVFtNDNsUmtnNEplbEkwLzM2Umx6?=
 =?utf-8?B?dmZjMFlCMVMzWjYrSFhJelM1a2pVaVJhNzhTUlpQNFFkWFFVN0lZbWlIUm1H?=
 =?utf-8?B?bW82QjdUSU5STGpjb2FlTDFrOHVLRTF6SFRrT09MTHBkdnEyU1FwdXRXOFBi?=
 =?utf-8?B?K0VBc282Ym0rUHp4S0FFSHA3MU5uam1ZaER5TW81bG4rQ3NBdytQWFUwYTJX?=
 =?utf-8?B?QmZrem8vTVI2VjZWMzgwQndGK0VieXo4QUxJdmFiQW52OTgwRE5SQjRrNStE?=
 =?utf-8?B?ODFHU1BlQlM1YkdERGIyaDF6MXliYXBKOWV4ZW4yektIYk1pdDJDRzYwNWNp?=
 =?utf-8?B?Q2pzOVN6bVNwS2o4Yy9OM1g1a094QWtReENsNWpjTW10YjNBY05KWWRMN25z?=
 =?utf-8?B?Y0loYklHWkZIT3FLc0tDaFZoWXM3aTdZRVF3Mm1BT0cwSmVLQVZIV1hzdk5H?=
 =?utf-8?B?Q0daQ09NQ052WnNYL2dMcU9WM3BlL21Vd21zSjhVd0hUQ2tXT3U2cm5wMXJ2?=
 =?utf-8?B?YnZqN0NoM2JaZzNzMDdvQ0dDaTlNMFZCd0xFb3paMlFBbmdLZjdtbmd5dU1s?=
 =?utf-8?B?a1JMUEVmakgycURSZ1I3d3dtYzdVMWwxWitFTS80UzRuOUpLeDl2S2tabU5i?=
 =?utf-8?B?MnhNZzcxeEx2ZXRhYStCNkhaTWQzNEtJSXFhR2ptZVBndWZKV0JxVE02Nnp2?=
 =?utf-8?B?Z0prdzhHY3dNNzJSZ1VUQ2tQZVVWSTRRS3NZQ0dNTjRnNFdscU82QWM2TE1v?=
 =?utf-8?B?cHJWWEVCMzhHQm1qdTZlL3d3L01lZXVNamRjQ3MvalpwUCtuejJaeXRBOE5x?=
 =?utf-8?B?K1VYSTI0SHkvNG9PUVZQcUUzdmt3TlBsejhoWkVVU2JlbjZiQ1doNUNVNEcx?=
 =?utf-8?Q?JbSe0qaGqQgAkaPEvUYCrZ+lhd/M9XcAjS8Ev2/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb082c33-1839-477a-9a1c-08d8fdb230b8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 12:55:03.8574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAqg0l4gJuxUnm2yH3bHso80l2+Lg1kSPy8puTmNj9WVnfM81Qr4VIbF+ZqzFDT1gLZFABmjN/RwlicDD+9ySg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/12/21 6:49 AM, Borislav Petkov wrote:
> On Wed, Mar 24, 2021 at 11:44:24AM -0500, Brijesh Singh wrote:
>> @@ -161,3 +162,108 @@ void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr
>>  	 /* Ask hypervisor to make the memory shared in the RMP table. */
>>  	early_snp_set_page_state(paddr, npages, SNP_PAGE_STATE_SHARED);
>>  }
>> +
>> +static int snp_page_state_vmgexit(struct ghcb *ghcb, struct snp_page_state_change *data)
> That function name definitely needs changing. The
> vmgexit_page_state_change() one too. They're currenty confusing as hell
> and I can't know what each one does without looking at its function
> body.
>
>> +{
>> +	struct snp_page_state_header *hdr;
>> +	int ret = 0;
>> +
>> +	hdr = &data->header;
>> +
>> +	/*
>> +	 * The hypervisor can return before processing all the entries, the loop below retries
>> +	 * until all the entries are processed.
>> +	 */
>> +	while (hdr->cur_entry <= hdr->end_entry) {
> This doesn't make any sense: snp_set_page_state() builds a "set" of
> pages to change their state in a loop and this one iterates *again* over
> *something* which I'm not even clear on what.
>
> Is something setting cur_entry to end_entry eventually?
>
> In any case, why not issue those page state changes one-by-one in
> snp_set_page_state() or is it possible that HV can do a couple of
> them in one go so you have to poke it here until it sets cur_entry ==
> end_entry?


The cur_entry is updated by the hypervisor. While building the psc
buffer the guest sets the cur_entry=0 and the end_entry point to the
last valid entry. The cur_entry is incremented by the hypervisor after
it successfully processes one 4K page. As per the spec, the hypervisor
could get interrupted in middle of the page state change and cur_entry
allows the guest to resume the page state change from the point where it
was interrupted.

>
>> +		ghcb_set_sw_scratch(ghcb, (u64)__pa(data));


Since we can get interrupted while executing the PSC so just to be safe
I re-initialized the scratch scratch area with our buffer instead of
relying on old values.


> Why do you have to call that here for every loop iteration...
>
>> +		ret = vmgexit_page_state_change(ghcb, data);


As per the spec the caller must check that the cur_entry > end_entry to
determine whether all the entries are processed. If not then retry the
state change. The hypervisor will skip the previously processed entries.
The snp_page_state_vmgexit() is implemented to return only after all the
entries are changed.


> .... and in that function too?!
>
>> +		/* Page State Change VMGEXIT can pass error code through exit_info_2. */
>> +		if (ret || ghcb->save.sw_exit_info_2)
>> +			break;
>> +	}
>> +
>> +	return ret;
> You don't need that ret variable - just return value directly.


Noted.

>
>> +}
>> +
>> +static void snp_set_page_state(unsigned long paddr, unsigned int npages, int op)
>> +{
>> +	unsigned long paddr_end, paddr_next;
>> +	struct snp_page_state_change *data;
>> +	struct snp_page_state_header *hdr;
>> +	struct snp_page_state_entry *e;
>> +	struct ghcb_state state;
>> +	struct ghcb *ghcb;
>> +	int ret, idx;
>> +
>> +	paddr = paddr & PAGE_MASK;
>> +	paddr_end = paddr + (npages << PAGE_SHIFT);
>> +
>> +	ghcb = sev_es_get_ghcb(&state);
> That function can return NULL.


Ah good point. Will fix in next rev.

>
>> +	data = (struct snp_page_state_change *)ghcb->shared_buffer;
>> +	hdr = &data->header;
>> +	e = &(data->entry[0]);
> So
>
> 	e = data->entry;
>
> ?


Sure I can do that. It reads better that way.


>> +	memset(data, 0, sizeof (*data));
>> +
>> +	for (idx = 0; paddr < paddr_end; paddr = paddr_next) {
> As before, a while loop pls.


Noted.

>
>> +		int level = PG_LEVEL_4K;
> Why does this needs to happen on each loop iteration? It looks to me you
> wanna do below:
>
> 	e->pagesize = X86_RMP_PG_LEVEL(PG_LEVEL_4K);
>
> instead.


Noted. I will remove the local variable.


>> +
>> +		/* If we cannot fit more request then issue VMGEXIT before going further.  */
> 				   any more requests
>
> No "we" pls.


Noted.

>
>> +		if (hdr->end_entry == (SNP_PAGE_STATE_CHANGE_MAX_ENTRY - 1)) {
>> +			ret = snp_page_state_vmgexit(ghcb, data);
>> +			if (ret)
>> +				goto e_fail;
> WARN


Based on your feedback on previous patches I am going to replace it with
WARN() followed by special termination code to indicate that guest fail
to change the page state.


>
>> +
>> +			idx = 0;
>> +			memset(data, 0, sizeof (*data));
>> +			e = &(data->entry[0]);
>> +		}
> The order of the operations in this function looks weird: what you
> should do is:
>
> 	- clear stuff, memset etc.
> 	- build shared buffer
> 	- issue vmgexit
>
> so that you don't have the memset and e reinit twice and the flow can
> be more clear and you don't have two snp_page_state_vmgexit() function
> calls when there's a trailing set of entries which haven't reached
> SNP_PAGE_STATE_CHANGE_MAX_ENTRY.
>
> Maybe a double-loop or so.


Yes with a double loop I can rearrange it a bit better. I will look into
it for the v2. thanks


> ...
>
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 16f878c26667..19ee18ddbc37 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -27,6 +27,8 @@
>>  #include <asm/proto.h>
>>  #include <asm/memtype.h>
>>  #include <asm/set_memory.h>
>> +#include <asm/mem_encrypt.h>
>> +#include <asm/sev-snp.h>
>>  
>>  #include "../mm_internal.h"
>>  
>> @@ -2001,8 +2003,25 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>  	 */
>>  	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
>>  
>> +	/*
>> +	 * To maintain the security gurantees of SEV-SNP guest invalidate the memory before
>> +	 * clearing the encryption attribute.
>> +	 */
> Align that comment on 80 cols, just like the rest of the comments do in
> this file. Below too.
>

Noted.

>> +	if (sev_snp_active() && !enc) {
> Push that sev_snp_active() inside the function. Below too.


Noted.

>
>> +		ret = snp_set_memory_shared(addr, numpages);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>>  	ret = __change_page_attr_set_clr(&cpa, 1);
>>  
>> +	/*
>> +	 * Now that memory is mapped encrypted in the page table, validate the memory range before
>> +	 * we return from here.
>> +	 */
>> +	if (!ret && sev_snp_active() && enc)
>> +		ret = snp_set_memory_private(addr, numpages);
>> +
>>  	/*
>>  	 * After changing the encryption attribute, we need to flush TLBs again
>>  	 * in case any speculative TLB caching occurred (but no need to flush
