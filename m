Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6257F633
	for <lists+kvm@lfdr.de>; Sun, 24 Jul 2022 19:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiGXRdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jul 2022 13:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGXRdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jul 2022 13:33:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FB4B1E0;
        Sun, 24 Jul 2022 10:33:03 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26OHLhq2028818;
        Sun, 24 Jul 2022 17:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BugUo7+Rp/RwZIaEcq3DD0ZapE/5+gvowHMudMhvOZE=;
 b=shlUDNpQkZgWJnBI1FkGkPVU+vFRJoIQzmB3D2PlJVqIrpqTMrf0j385IDtmeR68fqNl
 KV9U/qmmqKZBcGYzcMU2nSKYc/Az5VHeErCHqlWOUKmzQFt0FdBE1PDd6jU0n8dDU1OP
 0w+42DnGrmzD5k4Y8TRqYaTyOC6fw3r8+MNM/05FDuOQE2LVceHQh0jRqbnXrlTE2qZW
 S4FPcw4zq0VlNGI2i2bdM3hs0gGEz1BNOe4QVS2oeukGbHMvOzcb7tZJRQ+UPWkijUho
 ALGw6+CPRdS8Lzdu1kGY4Xad+Q65GItlbmv7HDsvUoVjB614A0Fp1/6MjXmxU2ZbIxiG og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhadr84bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 17:32:08 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26OHLlQ5028909;
        Sun, 24 Jul 2022 17:32:07 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhadr84bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 17:32:07 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26OHLFGZ028731;
        Sun, 24 Jul 2022 17:32:06 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3hg9899xq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 17:32:06 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26OHW46S40305132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 Jul 2022 17:32:04 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E7F56E052;
        Sun, 24 Jul 2022 17:32:04 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567516E04E;
        Sun, 24 Jul 2022 17:31:56 +0000 (GMT)
Received: from [9.65.220.76] (unknown [9.65.220.76])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 24 Jul 2022 17:31:55 +0000 (GMT)
Message-ID: <240cc182-4628-bef4-2b99-47331b0874f1@linux.ibm.com>
Date:   Sun, 24 Jul 2022 20:31:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        Dov Murik <dovmurik@linux.ibm.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xdiTVv2ibwldcYKv5fB7fxmxRBBxQGv1
X-Proofpoint-GUID: nsiIU9BuCIfho9vMX2pH8fcPIaN8VMQL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 spamscore=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207240077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ashish,

On 21/06/2022 2:02, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The RMPUPDATE instruction writes a new RMP entry in the RMP Table. The
> hypervisor will use the instruction to add pages to the RMP table. See
> APM3 for details on the instruction operations.
> 
> The PSMASH instruction expands a 2MB RMP entry into a corresponding set of
> contiguous 4KB-Page RMP entries. The hypervisor will use this instruction
> to adjust the RMP entry without invalidating the previous RMP entry.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/sev.h | 11 ++++++
>  arch/x86/kernel/sev.c      | 72 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index cb16f0e5b585..6ab872311544 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -85,7 +85,9 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>  
>  /* RMP page size */
>  #define RMP_PG_SIZE_4K			0
> +#define RMP_PG_SIZE_2M			1
>  #define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> +#define X86_TO_RMP_PG_LEVEL(level)	(((level) == PG_LEVEL_4K) ? RMP_PG_SIZE_4K : RMP_PG_SIZE_2M)
>  
>  /*
>   * The RMP entry format is not architectural. The format is defined in PPR
> @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
>  	u64 secrets_gpa;
>  };
>  
> +struct rmpupdate {
> +	u64 gpa;
> +	u8 assigned;
> +	u8 pagesize;
> +	u8 immutable;
> +	u8 rsvd;
> +	u32 asid;
> +} __packed;
> +
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  extern struct static_key_false sev_es_enable_key;
>  extern void __sev_es_ist_enter(struct pt_regs *regs);
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 59e7ec6b0326..f6c64a722e94 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2429,3 +2429,75 @@ int snp_lookup_rmpentry(u64 pfn, int *level)
>  	return !!rmpentry_assigned(e);
>  }
>  EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> +
> +int psmash(u64 pfn)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	/* Binutils version 2.36 supports the PSMASH mnemonic. */
> +	asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +		      : "=a"(ret)
> +		      : "a"(paddr)
> +		      : "memory", "cc");
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);
> +
> +static int rmpupdate(u64 pfn, struct rmpupdate *val)
> +{
> +	unsigned long paddr = pfn << PAGE_SHIFT;
> +	int ret;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +		return -ENXIO;
> +
> +	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> +	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
> +		     : "=a"(ret)
> +		     : "a"(paddr), "c"((unsigned long)val)
> +		     : "memory", "cc");
> +	return ret;
> +}
> +
> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable)
> +{
> +	struct rmpupdate val;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +

Should we add more checks on the arguments?

1. asid must be > 0
2. gpa must be aligned according to 'level'
3. gpa must be below the maximal address for the guest

"Note that the guest physical address space is limited according to
CPUID Fn80000008_EAX and thus the GPAs used by the firmware in
measurement calculation are equally limited. Hypervisors should not
attempt to map pages outside of this limit."
(-SNP ABI spec page 86, section 8.17 SNP_LAUNCH_UPDATE)


But note that in patch 28 of this series we have:

+		/* Transition the VMSA page to a firmware state. */
+		ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);

That (u64)(-1) value for the gpa argument violates conditions 2 and 3
from my list above.

And indeed when calculating measurements we see that the GPA value
for the VMSA pages is 0x0000FFFF_FFFFF000, and not (u64)(-1). [1] [2]

Instead of checks, we can mask the gpa argument so that rmpupdate will
get the correct value.  Not sure which approach is preferable.


[1] https://github.com/IBM/sev-snp-measure/blob/90f6e59831d20e44d03d5ee19388f624fca87291/sevsnpmeasure/gctx.py#L40
[2] https://github.com/slp/snp-digest-rs/blob/0e5a787e99069944467151101ae4db474793d657/src/main.rs#L86


-Dov


> +	memset(&val, 0, sizeof(val));
> +	val.assigned = 1;
> +	val.asid = asid;
> +	val.immutable = immutable;
> +	val.gpa = gpa;
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_private);
> +
> +int rmp_make_shared(u64 pfn, enum pg_level level)
> +{
> +	struct rmpupdate val;
> +
> +	if (!pfn_valid(pfn))
> +		return -EINVAL;
> +
> +	memset(&val, 0, sizeof(val));
> +	val.pagesize = X86_TO_RMP_PG_LEVEL(level);
> +
> +	return rmpupdate(pfn, &val);
> +}
> +EXPORT_SYMBOL_GPL(rmp_make_shared);
