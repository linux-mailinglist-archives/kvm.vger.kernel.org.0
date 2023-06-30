Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AD4744426
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjF3V57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjF3V55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:57:57 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F270F420E;
        Fri, 30 Jun 2023 14:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwRoII9UKeBAtvWdMH5aHAZadSdfkcGZsIRPNx7AF0MJYE6ZaDH4iA+K510u1YW244cJiUUXXIYtcAVBMYANcgmtaK+iyi/faGjWIHvXT3reumbPmUunbBECdt4fgvLEKZsb8a5LpDVHGsDNoGNiSpyhzGMCCBkmy9+sovx6w563WUHmCETu8Iq/HqddqvFZsxLzvbv/HHYOnJj1jI2NR2b6XxCLxKeQxhoOv23ZQLO5X9dIIiH6ShMwKdU1DFlH10e02Beb2gPGHN8eb2W0c9S+59Qaaxs9khb7NSuWt7Wcqe1Nc1Fjlxh2n70Tm95c6ysVJllTpokvfqmhASQoNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofvttpDQehXYPDP4ZFcX8rjFJafH4SdfBs+poFQFqfA=;
 b=m0XvJNiQ+LQpSF6p9VXEBEwS9Xz5nFzN6jOmorVyNlUJ32STFdEUDK+y8uNY0jm16nC3Et7Zy1ytYsGcu9I6VN8opa3chcZI/rc8scwSNEtszD7M/ksDotX/aubLyveQe/i+dsnuhfH9C6x3P2xF2v0oj7qNldr1ulYLmDqwidrvlzBicxnkhg5SVPqug5FIxZPhm+Ghv1VeExtBMDsoFdmIJxGZYytEiJm4bQV3/z1SWAHSWmmacxCqSGG9ZSFTcMaORPSjOuWQNSXQbiXN27XKQZ2LBMSp58MjfjJGk0HezyHAepNatzRwmtfY0yvmYU6XahD5oUoIMxnodhPMmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofvttpDQehXYPDP4ZFcX8rjFJafH4SdfBs+poFQFqfA=;
 b=ZOcTducyZ/H2OE33oMueKITMqA1bcbg0qblcWaE7fhcWvd6rkD3mLStMZGumUsN7jMhu8m4ekTc5PhsuTuhVdI0UT6oC7R20Y8OhI7bdGIcNjRVVyns1YIC7JMtEArhQFBBoAfr0C+kXzZXUapx1G76aIqJs3D7dvnUFBl0UKYQ=
Received: from DS7PR05CA0077.namprd05.prod.outlook.com (2603:10b6:8:57::17) by
 DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6544.19; Fri, 30 Jun 2023 21:57:51 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::98) by DS7PR05CA0077.outlook.office365.com
 (2603:10b6:8:57::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.10 via Frontend
 Transport; Fri, 30 Jun 2023 21:57:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.43 via Frontend Transport; Fri, 30 Jun 2023 21:57:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 30 Jun
 2023 16:57:50 -0500
Date:   Fri, 30 Jun 2023 16:57:09 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v9 09/51] x86/sev: Add RMP entry lookup helpers
Message-ID: <20230630215709.owobzb5cr2wtkqhd@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-10-michael.roth@amd.com>
 <59d5ca67-6a31-1929-8d2f-0e3314626893@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <59d5ca67-6a31-1929-8d2f-0e3314626893@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|DM4PR12MB5134:EE_
X-MS-Office365-Filtering-Correlation-Id: e217223d-fa3f-4569-8a99-08db79b50c8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZ0DxnAJgHwbo2Qbk/TEPWdYCN4rICkiQSPBkqFgqigWaPu+MUREwy7aSw/wrO7PehIfBP92TJCcFmdRu6OVrx+qr24E8fAi42pJscKDO+lF7LeQz9JYHoBhv4m/lb8TbMvOB2MQLvXfQ+DGRVkl5OuS6s3twN86I+R7jH/0daLiHxcsH6bqb/TvfQhvxFKxc5S/T4ZzJn7tOp2/h7SrQEzufrgqXuIrwvgQo31q9k58/Cvsgq/agw7MEo4XiTVS0B6yyLVfaXMNrb1GQy2HCeJ+7s3Y1r1fgVOgUemLbaOKAqxYtOdH0HLvbT4HDuGqkd/x6R0leZGfSjnLycI5fPHBUJa8nNuAq2enwF9JfrPz7XJ/kVBTj5hV9A2kKRFb6zZuu14bKk+Lgro6v+ef7ls77rYoyoTAn+/rdII565ExcCHpm4HT+cOyKfoUPWLwRZZcbHkuwpyEm6058aFXQNQXTMUG6gsasXjgOR80p3iXsnCkHD97iCyVCpkECQvyqUiDew+Ij4cPgTs5UIl3EWSnS2IXs1v329PHeXZ1pZFH3zjOHsnPmrxnN+I1Jhj+swJaPxFUKZF6lNh6/LWtOlImm71bgdK91aisX+pyxjQMOgdzzIq2S9aer4Ff2G017R5KUHRLekniDfn0lDOyc0mM2WqXOlKZslIzVbSqEJKMzJgIdPj9yp7MJbJvYzGpO3dyVXOe58/+ikhvfo/VeKp1etKYP1ROU0Z5Ovtg8YJwukoe2fu+lI/X8Y3Krjx/9TRJr6j0WDwcn+pN6Vul/aOqp7xN7POxTzqgdT34Erc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(336012)(426003)(47076005)(40460700003)(83380400001)(2616005)(2906002)(81166007)(356005)(82740400003)(36860700001)(40480700001)(36756003)(8936002)(8676002)(82310400005)(5660300002)(86362001)(54906003)(41300700001)(6916009)(4326008)(70206006)(70586007)(6666004)(316002)(478600001)(16526019)(186003)(66899021)(53546011)(44832011)(1076003)(7406005)(7416002)(26005)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 21:57:50.8789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e217223d-fa3f-4569-8a99-08db79b50c8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 09:08:58AM -0700, Dave Hansen wrote:
> On 6/11/23 21:25, Michael Roth wrote:
> > +/*
> > + * The RMP entry format is not architectural. The format is defined in PPR
> > + * Family 19h Model 01h, Rev B1 processor.
> > + */
> > +struct rmpentry {
> > +	union {
> > +		struct {
> > +			u64	assigned	: 1,
> > +				pagesize	: 1,
> > +				immutable	: 1,
> > +				rsvd1		: 9,
> > +				gpa		: 39,
> > +				asid		: 10,
> > +				vmsa		: 1,
> > +				validated	: 1,
> > +				rsvd2		: 1;
> > +		} info;
> > +		u64 low;
> > +	};
> > +	u64 high;
> > +} __packed;
> 
> What's 'high' used for?  The PPR says it's reserved.  Why not call it
> reserved?
>
> It _looks_ like it's only used for a debugging pr_info().  It makes the
> struct look kinda goofy.  I'd much rather limit the goofiness to the
> "dumping" code, like:
> 
>      u64 *__e = (void *)e;
>      ....
>      pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
>                                pfn << PAGE_SHIFT, __e[0], __e[1]);
> 
> BTW, why does it do any good to dump all these reserved fields?
> 

The reserved bits sometimes contain information that can be useful to
pass along to folks on the firmware side, so would definitely be helpful
to provide the full raw contents of the RMP entry.

So maybe something like this better captures the intended usage:

    struct rmpentry {
        union {
            struct {
                u64 assigned        : 1,
                    pagesize        : 1,
                    immutable       : 1,
                    rsvd1           : 9,
                    gpa             : 39,
                    asid            : 10,
                    vmsa            : 1,
                    validated       : 1,
                    rsvd2           : 1;
                u64 rsvd3;
            } info;
            u64 data[2];
        };
    } __packed;

But dropping the union and casting to u64[] locally in the debug/dumping
routine should work fine as well.

> >  /*
> >   * The first 16KB from the RMP_BASE is used by the processor for the
> >   * bookkeeping, the range needs to be added during the RMP entry lookup.
> >   */
> >  #define RMPTABLE_CPU_BOOKKEEPING_SZ	0x4000
> > +#define RMPENTRY_SHIFT			8
> > +#define rmptable_page_offset(x)	(RMPTABLE_CPU_BOOKKEEPING_SZ +		\
> > +				 (((unsigned long)x) >> RMPENTRY_SHIFT))
> 
> Is RMPENTRY_SHIFT just log2(sizeof(struct rmpentry))?  If so, wouldn't
> this be a *LOT* more obvious to be written:
> 
> unsigned long rmptable_offset(unsigned long paddr)
> {
> 	return 	RMPTABLE_CPU_BOOKKEEPING_SZ +
> 		paddr / sizeof(struct rmpentry);
> }
> 
> ??
> 
> It removes a cast, gives 'x' a real name, removes a random magic number
> #define and is clearer to boot.

Yes, we ended up reworking this to be an array of struct rmpentry's that
are indexed by PFN. That helps to simplify the lookup logic a good bit.

> 
> >  static unsigned long rmptable_start __ro_after_init;
> >  static unsigned long rmptable_end __ro_after_init;
> > @@ -210,3 +235,63 @@ static int __init snp_rmptable_init(void)
> >   * the page(s) used for DMA are hypervisor owned.
> >   */
> >  fs_initcall(snp_rmptable_init);
> > +
> > +static inline unsigned int rmpentry_assigned(const struct rmpentry *e)
> > +{
> > +	return e->info.assigned;
> > +}
> > +
> > +static inline unsigned int rmpentry_pagesize(const struct rmpentry *e)
> > +{
> > +	return e->info.pagesize;
> > +}
> 
> I think these are a little silly.  If you're going to go to the trouble
> of using bitfields, you don't need helpers for every bitfield.  I say
> either use bitfields without helpers or just regular old:
> 
> #define RMPENTRY_ASSIGNED_MASK	BIT(1)
> 
> and then *maybe* you can make helpers for them.

Yah, if we have the bitfields it makes sense to use them directly.

> 
> > +static int rmptable_entry(unsigned long paddr, struct rmpentry *entry)
> > +{
> > +	unsigned long vaddr;
> > +
> > +	vaddr = rmptable_start + rmptable_page_offset(paddr);
> > +	if (unlikely(vaddr > rmptable_end))
> > +		return -EFAULT;
> 
> This seems like more of a WARN_ON_ONCE() kind of thing than just an
> error return.  Isn't it a big deal if an invalid (non-RMP-covered)
> address makes it in here?

Yes, now the lookups are by indexing into an array of struct rmpentry's,
that scenario basically the same as an attempted out-of-bounds access,
so definitely worth a warning.

> 
> > +	*entry = *(struct rmpentry *)vaddr;
> > +
> > +	return 0;
> > +}
> > +
> > +static int __snp_lookup_rmpentry(u64 pfn, struct rmpentry *entry, int *level)
> > +{
> 
> I've been bitten by pfn vs. paddr quite a few times.  I'd really
> encourage you to add it to the names if you're going to pass them
> around, like __snp_lookup_rmpentry_pfn().
> 
> > +	unsigned long paddr = pfn << PAGE_SHIFT;
> > +	struct rmpentry large_entry;
> > +	int ret;
> > +
> > +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> > +		return -ENXIO;
> 
> OK, so if you're running on non-SNP hardware, you return -ENXIO here.
> Remember this please.
> 
> > +	ret = rmptable_entry(paddr, entry);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Read a large RMP entry to get the correct page level used in RMP entry. */
> > +	ret = rmptable_entry(paddr & PMD_MASK, &large_entry);
> > +	if (ret)
> > +		return ret;
> > +
> > +	*level = RMP_TO_X86_PG_LEVEL(rmpentry_pagesize(&large_entry));
> > +
> > +	return 0;
> > +}
> 
> This is a bit weird.  Should it say something like this?
> 
> To do an 4k RMP lookup the hardware looks at two places in the RMP:

I'd word this as:

  "To query all the relevant bit of an 4k RMP entry, the kernel must access
   2 entries in the RMP table:"

Because it's possible hardware only looks at the 2M entry for
hardware-based lookups, depending on where the access is coming from, or
how the memory at the PFN range is mapped.

But otherwise it seems like an accurate description.

> 
> 	1. The actual 4k RMP entry
> 	2. The 2M entry that "covers" the 4k entry
> 
> The page size is not indicated in the 4k entries at all.  It is solely
> indicated by the 2M entry.
> 
> > +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level)
> > +{
> > +	struct rmpentry e;
> > +	int ret;
> > +
> > +	ret = __snp_lookup_rmpentry(pfn, &e, level);
> > +	if (ret)
> > +		return ret;
> > +
> > +	*assigned = !!rmpentry_assigned(&e);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> > diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> > index b8357d6ecd47..bf0378136289 100644
> > --- a/arch/x86/include/asm/sev-common.h
> > +++ b/arch/x86/include/asm/sev-common.h
> > @@ -171,4 +171,8 @@ struct snp_psc_desc {
> >  #define GHCB_ERR_INVALID_INPUT		5
> >  #define GHCB_ERR_INVALID_EVENT		6
> >  
> > +/* RMP page size */
> > +#define RMP_PG_SIZE_4K			0
> > +#define RMP_TO_X86_PG_LEVEL(level)	(((level) == RMP_PG_SIZE_4K) ? PG_LEVEL_4K : PG_LEVEL_2M)
> > +
> >  #endif
> > diff --git a/arch/x86/include/asm/sev-host.h b/arch/x86/include/asm/sev-host.h
> > new file mode 100644
> > index 000000000000..30d47e20081d
> > --- /dev/null
> > +++ b/arch/x86/include/asm/sev-host.h
> > @@ -0,0 +1,22 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * AMD SVM-SEV Host Support.
> > + *
> > + * Copyright (C) 2023 Advanced Micro Devices, Inc.
> > + *
> > + * Author: Ashish Kalra <ashish.kalra@amd.com>
> > + *
> > + */
> > +
> > +#ifndef __ASM_X86_SEV_HOST_H
> > +#define __ASM_X86_SEV_HOST_H
> > +
> > +#include <asm/sev-common.h>
> > +
> > +#ifdef CONFIG_KVM_AMD_SEV
> > +int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
> > +#else
> > +static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return 0; }
> > +#endif
> 
> Above, -ENXIO was returned when SEV-SNP was not supported.  Here, 0 is
> returned when it is compiled out.  That inconsistent.
> 
> Is snp_lookup_rmpentry() acceptable when SEV-SNP is in play?  I'd like
> to see consistency between when it is compiled out and when it is
> compiled in but unsupported on the CPU.

I really don't think anything in the kernel should be calling
snp_lookup_rmpentry(), so I think it makes sense to adoption the -ENXIO
convention here and in any other stubs where that applies.

Thanks,

Mike

> 
> > +#endif
> > diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> > index d34c46db7dd1..446fc7a9f7b0 100644
> > --- a/arch/x86/include/asm/sev.h
> > +++ b/arch/x86/include/asm/sev.h
> > @@ -81,9 +81,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
> >  /* Software defined (when rFlags.CF = 1) */
> >  #define PVALIDATE_FAIL_NOUPDATE		255
> >  
> > -/* RMP page size */
> > -#define RMP_PG_SIZE_4K			0
> > -
> >  #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
> >  
> >  /* SNP Guest message request */
> 
