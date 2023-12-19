Return-Path: <kvm+bounces-4956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E8F81A434
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47F4A1C2493D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6102C4C3BA;
	Wed, 20 Dec 2023 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CvsibWWF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D416495DA;
	Wed, 20 Dec 2023 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTSS4WeLl6XGS2RmGj3PTqNAQpHYX6120oN8YTm87XzaOQY20IxIK4HDipWQ8uKTncXU4h538zDofQlfTxhWWf4z50/k6F5CC1NKyv/rc0ZKdw+H0vJ/wZHqGdT+9BfOKj7xOUm7JefLrAOz7OVrQcylXtIOY0NducWaaYm/O644tx32SPuiUPmf7CmxGckoYbGMCy79ESi8ED4u77J/Fl8KVqVe0+OaFT53GhM1llZ/04Lixp+Y0XO4TnaWyjdLfcNKrgxd3yYNwuiBMMGHGbgi7Lj/WuCThDptMqVzTYB52rXkyIzZBU9WBeAOx2MU/sBhptHNkPniYm6MH/f8EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zztFM+6SePAdYVo8ypzTXKKU7fpjrsqPY34SNgTgrFY=;
 b=TkmVIARLB8S9F5tlI7RlX6qeqJ3A4SyBAx8ovpxK5mKlnrf5sOoEvq/5swC8yQ4XO4ksA4gAtK23DvAgNacYHs/+IX9YCjhLsv8FLdyYntDWNM0jeDJiaLnyefoaQcvaDCxLE+LBKsHrXeJUmySaFXx+t2vhUK4/ZVEuLHcV7oUoPloP79rpzkmHCZRSU0Pg9FiBASENh7UvBs3QE8TMTRI1DP2O5guePzZPoLVq0Jmg6K/oWjQ+Q56NpNk59vYv4MX5MCOg57sJ7owdzHnn2YA1p0aUMukJxE0A7gRpNGC7Qu2zM30aIjkC7E/N9TSoqinZCVDULy4zLy4urhATYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zztFM+6SePAdYVo8ypzTXKKU7fpjrsqPY34SNgTgrFY=;
 b=CvsibWWFoM4QjBNpUNVqDN0zGcYlsnkpvtkdRr7HV0O/D1SpIde15PV3sIcF5iEhzl5pwcdlM8+Qnj4yYCKkC/N5TaHhVVX/gkVFF1PgNHHpO6UbpOGIQoDi+O1yf2GkToMjhY0jbrXzH89KrsVAvLEUoRxSxWiX+8hKo0Nai7I=
Received: from SN6PR2101CA0007.namprd21.prod.outlook.com
 (2603:10b6:805:106::17) by PH8PR12MB7254.namprd12.prod.outlook.com
 (2603:10b6:510:225::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 16:12:08 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::43) by SN6PR2101CA0007.outlook.office365.com
 (2603:10b6:805:106::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.19 via Frontend
 Transport; Wed, 20 Dec 2023 16:12:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 16:12:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 10:12:00 -0600
Date: Tue, 19 Dec 2023 17:46:12 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
	<nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>, <liam.merwick@oracle.com>,
	<zhi.a.wang@intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 17/50] crypto: ccp: Handle the legacy TMR allocation
 when SNP is enabled
Message-ID: <20231219234612.qaq6bv54jcgo4f2a@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-18-michael.roth@amd.com>
 <20231208130520.GFZXMUkKR+aexFpxXf@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231208130520.GFZXMUkKR+aexFpxXf@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c4d304-2869-4127-7563-08dc017668e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mSNy81YozXg0UI4icIdEP9j4E+lRFUq1zThrbIaFO75IyhSLqabKqrmRGR2VMx6JmeHp7uLFG93bJa4QJsHe1S/ZJRx1QZ+LYDDfngpxl26nOCwnHNObKb39UIAy1MzwW00jkk/pQJWK6sDQ4azMPbHPjbAngSpjK6T0el5MzzVdusmiC6P9LT1vlO4Xb2tDEMmfiRwSXoRS5SCfe+gicPfFuc0JBFdxKsfXsU7RDnSpWqGZkq/0WY6mEtNJxH0cuReKVqWd/CYDJOslhQ9w9uEbXw4wyiFGRzwRE45VMc/sx0fEbG022YKu12s/V5koElq1gpHyJNHXWblVM5XDFvhKx/8K1CEUoK95wVqKKqtB/5lMXyLESxIx3mixZaJ9UTOOlH4eTL8T9Q9BGDhDJeXXl5cTUtyyqvdouYY29ExsPRdK9vnFxR0xX51qQ/i9MWGdLRy7X5WuGQG37Y3JA/w1Z76U81QyZgeVRpcojfbwycrf9lLA4rlWox7Fg501+HqSRLABNwn20Q0f3z2zdWDeCSQsDgjVjKBGUOinmFIR5GNlZcrY+25eghQDwxfxC0bXyNuix49kJHq44F/egZcchO37mQcvAI5kfxgJifi2j4MD5KuIFc/G9Qc/vzBBZr2xeox9+GjnYZCUAwdLqJzHxvnEcJPVyzJmaE2SkwMIj1a1E4agoW4Jhb71BjGU20PQKRmqOQRD6ssOi9r+uF8RAsIpQeYFX8QiObKjZXYCrmp4XHq86NNNNdJ4j70FqbdvkBxAKrgI+aS2HDKbsw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(82310400011)(36840700001)(40470700004)(46966006)(2616005)(83380400001)(426003)(336012)(1076003)(16526019)(26005)(86362001)(44832011)(36756003)(8676002)(8936002)(41300700001)(2906002)(4326008)(5660300002)(7406005)(7416002)(316002)(70586007)(54906003)(6916009)(70206006)(6666004)(478600001)(966005)(81166007)(47076005)(356005)(36860700001)(82740400003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 16:12:05.6845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c4d304-2869-4127-7563-08dc017668e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254

On Fri, Dec 08, 2023 at 02:05:20PM +0100, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:46AM -0500, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The behavior and requirement for the SEV-legacy command is altered when
> > the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> > for more details.
> > 
> > Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> > when SNP is enabled to satisfy new requirements for the SNP. Continue
> 
> s/the //
> 
> > allocating a 1mb region for !SNP configuration.
> > 
> > While at it, provide API that can be used by others to allocate a page
> 
> "...an API... ... to allocate a firmware page."
> 
> Simple.
> 
> > that can be used by the firmware.
> 
> > The immediate user for this API will be the KVM driver.
> 
> Delete that sentence.
> 
> > The KVM driver to need to allocate a firmware context
> 
> "The KVM driver needs to allocate ...
> 
> > page during the guest creation. The context page need to be updated
> 
> "needs"
> 
> > by the firmware. See the SEV-SNP specification for further details.
> > 
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > [mdr: use struct sev_data_snp_page_reclaim instead of passing paddr
> >       directly to SEV_CMD_SNP_PAGE_RECLAIM]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 151 ++++++++++++++++++++++++++++++++---
> >  include/linux/psp-sev.h      |   9 +++
> >  2 files changed, 151 insertions(+), 9 deletions(-)
> > 
> > +static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, bool locked)
> > +{
> > +	/* Cbit maybe set in the paddr */
> > +	unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> > +	int rc, n = 0, i;
> 
> That n looks like it can be replaced by i.

Indeed, and for snp_reclaim_pages() too by the looks of it. Will fix that up,
along with all the other suggestions.

> > +
> > +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> > +{
> > +	struct page *page;
> > +
> > +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> > +
> > +	return page ? page_address(page) : NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
> > +
> > +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)a
> 
> This @locked too is always false. It becomes true later in
> 
> Subject: [PATCH v10 50/50] crypto: ccp: Add panic notifier for SEV/SNP firmware shutdown on kdump
> 
> which talks about some panic notifier running in atomic context. But
> then you can't take locks in atomic context.

In that case, the lock isn't actually taken. locked==true is basically
used to tell the code to not to try to acquire the lock, but the caller
is relying on the fact that all the other CPUs are stopped at that point
so there's no need to protect against multiple concurrent firmware
commands being issued.

> 
> Looks like this whole dance around the locked thing needs a cleanup.

There's another case that will be introduced in the next version of this
series (likely right after this patch) to handle a bug where the buffer used
to access INIT_EX non-volatile data needs to be transitioned to
firmware-owned beforehand. In that case, the CCP cleanup path introduces
another caller of __snp_free_firmware_pages() where locked==true. Maybe this
can be revisited in that context.

Thanks,

Mike


> 
> ...
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

