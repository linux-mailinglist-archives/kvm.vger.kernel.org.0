Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3A6654FE7
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 12:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiLWL6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 06:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbiLWL6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 06:58:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5C32B610;
        Fri, 23 Dec 2022 03:58:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ds+rUIFG2Sc122z6G2EgMPNAEsLAZmS2C2MLYdIQla4LSYNWflceGZF5wLZCRPYGycMnVIIa/9ES2SerhmYejoEIVMMgTYpgcoAN/5omdksgDyL1i74hw9Vi8H2zTzvODL2di8U6JCMvL8McePVVU0apKw1bxEh5TO4nVmACOdDWM4hEf0hFmgRFoHtqkfpvX4+1U2rOzk2G0jC+c/C7yQOgxZGjp4bt16t/rmTnnMRBZB6OXrDG1rXfNwfhlIC8+5E5soXMbqxCHHEowg8mxDtBA+rE0eG6p4XcZPa05IqjADxnpL9HABuOq5lOCwItXYxZM14wrooNh7widBgrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8s31XZx7hesNv/jFq/AC+NP/UoYYI7GJkxz1+UMZnUs=;
 b=ZuKwr69WjNJy3vdTLJ+UDAsJoeZGh3MCywqtqBmf4fo8SDjx0tHK+dOh9CumW0cuUBtcLWoPBnJ1Nw8VNFa+DuHY9WikIexuCr4quiOCw+8b8JVUn8xBTDDlI7xCvro8rgt7qsA9zKvkw3/5UaVmvNR8shtLeMd2ZttAWICO5BxOimPLB4CFsOePnJ0EEO6cU7VbuEx3BPUULMpSrGu6QAMlgZ3I84mBV+EyJqMqAlCEBMxG02nSH78Brsu0htYTm5DCRi5RX2A2mtBOOWVcUjw4o94RKilLdlwYBv97W8AV1HvZP5pydRb0BYX6Y2iXigCFP+/pps/Xl/s1s42lJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8s31XZx7hesNv/jFq/AC+NP/UoYYI7GJkxz1+UMZnUs=;
 b=mlQtn0ffU36IXC5xB5Tc5wgR6i+lFGw8eUyO1rUp/py7kztKzwvo7P6XwwNwujDqLTqWVpCaH0GSrdRw8OhFheflFK4LCVb+mmTm3Hquu0gFi5ar2IniLawUnyDHkceJbNlPaTfSLrBNBO1nuOu5ER23rHFcxGWz5Z2/21nadOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Fri, 23 Dec 2022 11:58:15 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%4]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 11:58:09 +0000
Message-ID: <db606c53-90bc-e829-0910-381a539a97fd@amd.com>
Date:   Fri, 23 Dec 2022 17:27:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 11/64] KVM: SEV: Support private pages in
 LAUNCH_UPDATE_DATA
Content-Language: en-US
To:     erbse.13@gmx.de, Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-12-michael.roth@amd.com> <Y6Sgwp/BofzCUrQe@notebook>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y6Sgwp/BofzCUrQe@notebook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0111.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: 77821671-c585-418f-fc60-08dae4dcf552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1MsvpN1M2ZYsbJsXb3BgXS8rP4hvcePOmbbc6/oavelyWRV2KH13TaGkz+UDZMshw3zjt/2pP4XrQH9+3ZSko+UlCL4EifO7a3gsRjugH8vhdNMjSF73LLL6MdLyJOO4gX5KyqZI7R4BHxN1OjN5AwWxLANILZtcxNeBi/4Dj8O9LkOgr1RnqMjbO6BSC5RCb1IxD0gYm424OK7BdtVemDzN0scQvUoRMLcEMxeNfB7wmcvd4WiVqWHgjJF/GWoxARMfKTCDQgA7XJWUapaBOYTKZ6rLeY0VoC7JSsX/uDulI7saM7qS98nicEN/kxPQwmFLx0I2v8H4HE4lSbfXk08eUO9n57DwIPAbQhGQM2tWUyB2dyT9lgQPO+3ECIRbOqfwa2kCzz40pepucQWBCL0qp3PoaldwotSAGqWx3gXV8Z2c4ePz8w74+UwcwNBWSEobEIny23xpNTJHUWE4UdYkoCDvrqHxld66QtU7eKMuv94Qty/bmoDjp0k55Pp/wG/EvuSfUkie2TsA/F7/8KmZDbkE8J++2ELjghzyO2pk1nr5yRPNjLVci8CzXUTeBhYHffJX4LSJl3f4yUzuqtdCSXfSBnGR+oB70Xl4k9SS5cQCtCh7vbxwXf4N1tZ/73mkhXdE93YY487kYl2dfKdvlEmF2l6vV4zN8Yz+y/KYMBq6YrHFzgGNek7CKJb35cXYCd7vBkpecmVd/d7G/gWb7lAbaZ0UBOsFATzHkaKLPI3UibAbr7v2XF0z8p4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(31686004)(36756003)(6862004)(2906002)(4326008)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(38100700002)(31696002)(66476007)(83380400001)(478600001)(2616005)(6636002)(37006003)(316002)(6486002)(41300700001)(8936002)(53546011)(6666004)(6506007)(26005)(186003)(6512007)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXM5SXlwd1RnbWRVemZxTUI5d3o4T0Y3ZWJmUWJHWC9tUnE3Vi9TcDMzbXdI?=
 =?utf-8?B?VjltZXFpUjBzdnBRS0ZhM0hXK2tmekxMbjBNN2xNM0QzM2hmUThuQVRZOTdX?=
 =?utf-8?B?L0dzTGRlcUpGU0xEWWI3S01uSXg0YnZnblBaek51Nk1HWXRBK0NWdjVoWGta?=
 =?utf-8?B?WXFDNkdicGc4a2xaSnhyMER5RGtzeGZFaHB1YjVLVFZpQTVzd1Z2MkdvQ05L?=
 =?utf-8?B?aTI5SnFvN3ZqNW5qRkE1eTVRQjJOOWwxWUVzVDF2Y0ZGN0tGOUxTeUFhZ251?=
 =?utf-8?B?YlFWN0ZoRHRZUzlySmRKQnFnS0dTbndzQUNjM2V0OTgzUEJiMUY5bjhpRzdz?=
 =?utf-8?B?VE9EYmRqYzlBV2RTeG9xQVIxWVVsdE9OOGtMbWVUK0tndk5yaHNLWUFWOUhC?=
 =?utf-8?B?b0dCbGNWUkdPYkZ1a1NyWWovWmtxVGhNdjZneWhsOUx4SXQ1Q0ZOWTlpRk1Z?=
 =?utf-8?B?VFRlMDk2KzNKdk5pRUNTVXRlMU4vYUNmNXJ1UzhDZTg1UzJjb0pnL1IrMXNl?=
 =?utf-8?B?ZGU1c2ovRzB0QnRwUHNZUGVMa2ZZbnFkYjJFNmN3T1pLd0hoejhibnlZaU1n?=
 =?utf-8?B?Y1IrcXBoRU94ejJVOG9xV2RGTnNhbXNWbFQ5YXMrNDR4RHo3d3FlWStSTWx2?=
 =?utf-8?B?bUJ1ZTZuQzcrVFZ5bm90d2pGdGVZK3F1azd0OG4vTEtMc1hIN25uZnNCQm4z?=
 =?utf-8?B?SDRLbVNBZDVGdklvSkdSdWhXUmFNZkVDNkc2M0pkVTZUSGpQWjZoWlIrZG1p?=
 =?utf-8?B?U1FBdUMyWUU0dlErT3ZKZXF5RWI3NG1XUUVpLzE0R1VBZVFkdVJRdzR0akdN?=
 =?utf-8?B?cU1QUW8vREtpUHdISVVRWnkzbW9kMzhaMCt0Lzc4dllIS0hmbW9FQkxERGda?=
 =?utf-8?B?U1lDQWxReGdISlBHcXJmTTR1TjdmUEo0R0kyQzFxc2s4ME8rRVgxd3c2UWpr?=
 =?utf-8?B?aC9EYXJXS2dlV25EbnZKbElPayt5b3d1MTdRZDZXanpNUERiTUEvV0tyNHFq?=
 =?utf-8?B?alFCTmVMRFRuOC8yUkRxSW1yUXF0NVQyM2lPZFVjVjNBQkVHckpjcHNwbXBY?=
 =?utf-8?B?Z1RxczF1dUttS3FKeFY1c3dPS1NweVJJL1p5QWk1T1VFdU1FdUQ3OWlEdkJU?=
 =?utf-8?B?bnZZdWVocWhVWXFMWndPcjNlWi9WZHVOUVhRcHpIQXZMZlNmcmo1M2JIM2lZ?=
 =?utf-8?B?QWpidHg5TUd5RXU2U2FLOHo4UU9ha2VaYVE0VW5TK2lWVFlsUmpFcmpCMjJ1?=
 =?utf-8?B?ZlE1dXBsaU1PVnJmWFYvVDdJTXAwcC9CTVJ3U0s5U1BPTFJrclF4Q2JKc0tZ?=
 =?utf-8?B?eGtEdlh0cFBuR3NacWo0QklRdWU1em95QWVzYVMxWGl0NzBXVElSSmNLdjVU?=
 =?utf-8?B?VS9hVlJtQTlEVSt5TlhXWWk5MUVxYmt6dCs4V1lMLzRoUmZjT3pqbGNzaFFy?=
 =?utf-8?B?dncwSzV2WEVyTVJFVVFOS3NNK3pqUFNrU0I3b0tPTnRCeVBaKzJKN05YVlFH?=
 =?utf-8?B?U2VaNkdORTUvdCtSRW4vYTQwTnpWaks5YnJqVGw4c3FaWndIaXdFOXlVOGlh?=
 =?utf-8?B?em9FdXREU3c2VGVOSTN5US9laEZGZTRMZDcwdFF5cm1paU1aSDlHWkJ2Mmti?=
 =?utf-8?B?d2g5R0tvUlV6cE5mQmJyOGJZVFI1RWwvR1YvSHlEOWVsMUdpOXNXUjEyeGNo?=
 =?utf-8?B?dnp6T0xyT1ZtTEU1RmFiUk1nMkh5REFxZ2Fkc0xPVkFPcmF5Y1VFY0dMYmhu?=
 =?utf-8?B?WEJxV2FXQ2pKSkRTdnBadm9hSlhQZjlSSmJiUkFxOCtReFlXbG1UN3lMUnlJ?=
 =?utf-8?B?NitnbXBXbytqUC81N0tMTG0xb1lkMU8xeGtwV3FPNGRWZ3F4ajlKZ0pmbDU1?=
 =?utf-8?B?VFJTZ3FvSFZnc2QxNzA0dnNRWVVpSm16aG9xR2xhdnZaU2cvWFgvRGc0VEhZ?=
 =?utf-8?B?VVlqbkF4WTZDeHhRODBKZ3BXQlNDK0dQRGllQjE3N3BIKzhJM3I3VzZKQVpQ?=
 =?utf-8?B?cVFrcy9lNUlMQjR2b1Z5UjhwMFFaT2VVTlMwSXZuRDVqNjRjUVpBUHBPRlR5?=
 =?utf-8?B?dVBmMDFLRjh5ZnRZVk9ITXFVcDBqRFR4YjBWeEVGckJxQm5BbXdUaHV3S0FC?=
 =?utf-8?Q?7sishZwPKRrvg407mv+QdUQol?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77821671-c585-418f-fc60-08dae4dcf552
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 11:58:08.9734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8u4Z/OjIosPoQTeDpYK/PbnfEKUSP+OWZ29yrX3Qws9QVxQQiFxuiXC8FqLEZrSZAk5ER+on3loI7r3dAUR8Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/12/22 23:54, erbse.13@gmx.de wrote:
> On Wed, Dec 14, 2022 at 01:40:03PM -0600, Michael Roth wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>
>>
>> Pre-boot guest payload needs to be encrypted and VMM has copied it
>> over to the private-fd. Add support to get the pfn from the memfile fd
>> for encrypting the payload in-place.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 79 ++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 64 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index a7e4e3005786..ae4920aeb281 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -107,6 +107,11 @@ static inline bool is_mirroring_enc_context(struct kvm *kvm)
>>  	return !!to_kvm_svm(kvm)->sev_info.enc_context_owner;
>>  }
>>
>> +static bool kvm_is_upm_enabled(struct kvm *kvm)
>> +{
>> +	return kvm->arch.upm_mode;
>> +}
>> +
>>  /* Must be called with the sev_bitmap_lock held */
>>  static bool __sev_recycle_asids(int min_asid, int max_asid)
>>  {
>> @@ -382,6 +387,38 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  	return ret;
>>  }
>>
>> +static int sev_get_memfile_pfn_handler(struct kvm *kvm, struct kvm_gfn_range *range, void *data)
>> +{
>> +	struct kvm_memory_slot *memslot = range->slot;
>> +	struct page **pages = data;
>> +	int ret = 0, i = 0;
>> +	kvm_pfn_t pfn;
>> +	gfn_t gfn;
>> +
>> +	for (gfn = range->start; gfn < range->end; gfn++) {
>> +		int order;
>> +
>> +		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (is_error_noslot_pfn(pfn))
>> +			return -EFAULT;
>> +
>> +		pages[i++] = pfn_to_page(pfn);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int sev_get_memfile_pfn(struct kvm *kvm, unsigned long addr,
>> +			       unsigned long size, unsigned long npages,
>> +			       struct page **pages)
>> +{
>> +	return kvm_vm_do_hva_range_op(kvm, addr, size,
>> +				      sev_get_memfile_pfn_handler, pages);
>> +}
> 
> The third argument for the kvm_vm_do_hva_range_op call should be addr+size; the
> function expects the end of the range not the size of the range.

Good catch, will fix.

>> +
>>  static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  				    unsigned long ulen, unsigned long *n,
>>  				    int write)
>> @@ -424,16 +461,25 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>  	if (!pages)
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	/* Pin the user virtual address. */
>> -	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
>> -	if (npinned != npages) {
>> -		pr_err("SEV: Failure locking %lu pages.\n", npages);
>> -		ret = -ENOMEM;
>> -		goto err;
>> +	if (kvm_is_upm_enabled(kvm)) {
>> +		/* Get the PFN from memfile */
>> +		if (sev_get_memfile_pfn(kvm, uaddr, ulen, npages, pages)) {
>> +			pr_err("%s: ERROR: unable to find slot for uaddr %lx", __func__, uaddr);
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
> 
> This branch doesn't initialize npinned. If sev_get_memfile_pfn fails, the code following the err
> label passes the uninitialized value to unpin_user_pages.

Sure, will fix.

> 
>> +	} else {
>> +		/* Pin the user virtual address. */
>> +		npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
>> +		if (npinned != npages) {
>> +			pr_err("SEV: Failure locking %lu pages.\n", npages);
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
>> +		sev->pages_locked = locked;
>>  	}
>>
>>  	*n = npages;
>> -	sev->pages_locked = locked;
>>
>>  	return pages;
>>
>> @@ -514,6 +560,7 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
>>
>>  	size = (range->end - range->start) << PAGE_SHIFT;
>>  	vaddr_end = vaddr + size;
>> +	WARN_ON(size < PAGE_SIZE);
>>
>>  	/* Lock the user memory. */
>>  	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
>> @@ -554,13 +601,16 @@ static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
>>  	}
>>
>>  e_unpin:
>> -	/* content of memory is updated, mark pages dirty */
>> -	for (i = 0; i < npages; i++) {
>> -		set_page_dirty_lock(inpages[i]);
>> -		mark_page_accessed(inpages[i]);
>> +	if (!kvm_is_upm_enabled(kvm)) {
>> +		/* content of memory is updated, mark pages dirty */
>> +		for (i = 0; i < npages; i++) {
>> +			set_page_dirty_lock(inpages[i]);
>> +			mark_page_accessed(inpages[i]);
>> +		}
>> +		/* unlock the user pages */
>> +		sev_unpin_memory(kvm, inpages, npages);
>>  	}
>> -	/* unlock the user pages */
>> -	sev_unpin_memory(kvm, inpages, npages);
>> +
>>  	return ret;
>>  }
>>
>> @@ -609,9 +659,8 @@ static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
>>  			goto e_ret;
>>  		kvm_release_pfn_clean(pfn);
>>  	}
>> -	kvm_vm_set_region_attr(kvm, range->start, range->end,
>> -		true /* priv_attr */);
>>
>> +	kvm_vm_set_region_attr(kvm, range->start, range->end, KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>  e_ret:
>>  	return ret;
>>  }
>> --
>> 2.25.1
>>
> 
> Regards, Tom

Thanks
Nikunj

