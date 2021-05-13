Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952CA37F249
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 06:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhEMEf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 00:35:59 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:56545
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229471AbhEMEf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 00:35:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG2Ki8H/1HAlJR00i/Nhn1gfb/fKb9q33+iBjWtWso73pdObtCJLomaEfNN1tQNc7zQxmIpxB0S7cGeEUjokIyc46//hiScOgAxbU7N/GjO3jx1oD+rzoZtQ3mhbYXlSj1qlry7cxit3bLyEAzNQMsjpyfGXGTE1xbb0gqSg4U8YWznu36SblKq+pM3Evh3wN6VSS2kpVnsN9l3AUUcBcflOJ0tE1lnl9aFe0RhI2Pjt9cBeZ9YVFtx/M9G5wfd2FCmedaKYrf/VU1mLr0GTQdXlKujM5D+Wtaq2cogdUgI1wg7Lf1RWcnGSP35FluBjI8yftwR5CZL2QhkifrlHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XA4zHsQv4z1l8oE3lVg170JL82eTMDfjtdbs/N/Mx4=;
 b=ZlG7gyxJJuKyIrz6EKfg2i4RGLIkvAppG005gQc70LZ53ThGsRJM9YhOMHVOFLQW0pkOi+zT8snMKbK4Sezo7jK0JQGkJXoG9Sbq1xHJ/IO62twJDwUmb6vZrdN7dYem/Al9+1Td5ZsekRrFDXPCx4/a6mcPL/fhEcuDbA+Ygl3I4Kt3kIy/AuTOX/zmT+QrsPPqYFIxJ31oG6xixQxK5NRyCVakPLUwUpd6MiFznSRP+xS20VHViWHg+4RmgTAHzC0nPNltauyf7Nn1yCznhtUZ4oLhNlJXaw+YGjYNCQ3GTIS/HbiEs6axQRp9uZBpY+2igvb4a9jqB2V2bc0iGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XA4zHsQv4z1l8oE3lVg170JL82eTMDfjtdbs/N/Mx4=;
 b=CCm4+d/oqidwwpXsloquuaaSwf3yripp/y0aPNZsZX9cMd1Jua/6GhysN2tVAcKil3hIu42dRlueGiZyfkrTANGIsUPjBhiSDqrfEpF1CQBQCoIwNsx5aYR0K3CW+3dPJEQbaoFCYPO8Imhfo+La+RiCiSYGv4F9kveBLvLxUro=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 04:34:47 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 04:34:47 +0000
Date:   Thu, 13 May 2021 04:34:41 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210513043441.GA28019@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvU+RAvetAPT2XY@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:806:d3::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0004.namprd11.prod.outlook.com (2603:10b6:806:d3::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 04:34:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d190ef-9e96-41fb-aaa1-08d915c87019
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45753067D6FC08D04A3639CB8E519@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ljaKnIc9g9Yz8NnZw1HIT2WWHED6GgAEdPCr06kFiZMQyw3GA74IwwrXylruEKLXucdkD8Bwbu4Zue6kkjJzCzwb0+I65S8EcgqIh1ejFgrjO3NT7X34P9sAe3cgXrqhH3g2UOaI4HCgfUduPZEJv+D6rcFUPnKmLTeDcAeK2qq+3t89jcTcmx0+kVgAjHUuM1LrBA2Bxn+HB10kUJLuRLErbCLamfMChKL3o1qh+gLoqWiPVrDmyKN8gAUeIGcYJ/63SM+0bJ55+c8MMIjRnBb7TJkKvxEs4hfcrMx1WXIISbCl/N+XcBMOO4eAkkKlwKWnelqFPlv2AZMbBtXRA/Cg+Ch3QVbaiA/7zBi4+A9oTn+LiOKC50elMfOdvyPmmgP64UwPMxeBaYXcIFTLovk9tXSN0n8mCBHvMHWjpFYXenyZZX/f14RJ3rAzim8Zm7YCX3SaeuGFSODl+g7KLeZo2a4eoNaMtbD5LxqVN3S0LMx6NMLycIfrzFgcJzoH+ZitjPu8LilX4sJijkfbUG5gcJ/qCVpi+HHyhZ16sHaxafX2mYbgr3tR8hZhRJbr3OcYVXdryQYmILk0H9Vt8U8/cY3W97sTnsqZfb1uNjihLxDPDjXsjp8Xbtsq8iBpijMK98eFlNMbftlDsVtSRZ84x9dq5w9rhlmcqe4Gj5UQNm3SI3cgga0j2KXWoZ5EcN1zud/ojYqFKRWi5oU8R48cGicq6Y2qLxZFgmbq8o7A8dKewOpvDzn/aHflre+q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(44832011)(6666004)(33716001)(2906002)(26005)(83380400001)(66946007)(5660300002)(186003)(4326008)(1076003)(6496006)(16526019)(6916009)(33656002)(66476007)(52116002)(86362001)(9686003)(8676002)(7416002)(966005)(66556008)(55016002)(38100700002)(478600001)(45080400002)(8936002)(38350700002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LlzUZSP7ET0ijby66Hfxwp5lpBO9nT6pwn+tahUMJMGptA/aNvNFTtLWQHDe?=
 =?us-ascii?Q?X0X9zT/C/n/QC0P8NV52jvd+Tepf/DA7WfIvnqcgisdebN5dw/02DIS6qz6S?=
 =?us-ascii?Q?v5v7NSpev6ZBbzOf8QON3Hg+BycrMqXgm3eX4oV2W3MSLUuN3pCFuF8w0/jj?=
 =?us-ascii?Q?3QmgE/KuB1Pzxg2KKwQ3PyoDul0Dmqc814EVkXSWNKT3IQI4nlzSxePZX2Ij?=
 =?us-ascii?Q?1BNG/PkOUsVmqpRWIHeCxBMH4KWpMILo3KX6rsu19/abA1fDUBSPFLPIdKgS?=
 =?us-ascii?Q?frmoxgJ5NrF5SZIkYvxHSQH4E0XrJHl1Dne/CkBSPy7QU54r2QkGSR/7J4qF?=
 =?us-ascii?Q?cQkGV8mrDCCahSSPWiMiXfS9TBidrFb4dTztH+ekQwsJ/ZAvESPJBkvXlEle?=
 =?us-ascii?Q?CN3KnLpGH4JqvJ9e+BSeDYLYWgnmG2/QQ73VVEJjHoP5+exs8G4pIhxj+SRP?=
 =?us-ascii?Q?Rt6DurbFQtKAUeCHbQynow1MRhj4WRbXV0n4tBE4NIxFq6yzStRMbv3UNtJw?=
 =?us-ascii?Q?cxBclSnIv3IC8LGVfQfZf2xjb8aNFOsyuHaJ/VH0/DiRUa9RRBxq5taPNFXG?=
 =?us-ascii?Q?bdiY85HdY9GucN4lbGaeJMf7/3P3kwhXa0+SEJHRQPXQVe3Ayfyz13aCQzj/?=
 =?us-ascii?Q?cZ3RORT6QZhv5jliJO/8xBFCbQ2miGE4ZtpL2SzpZBPUNukC62KqMmdZzrd6?=
 =?us-ascii?Q?Y7vkvXDzU4QA+Vur0GaCXcWnduMb09vuI//gLUsg7XS1oQ2WqL/+bk/euNSP?=
 =?us-ascii?Q?faob77lnGjXK7U0eMsIhyjlNiYJ2wudmcQAwsLTcdMH2udcwGpejjLoAYLHS?=
 =?us-ascii?Q?FW4YUx6ocWLKnt8RnA+/q9tHU61IFH44DaG9a9MYt9+S2Hxto0ngtwuzu27x?=
 =?us-ascii?Q?5DBDvmeVrd+Oe+KHJoIEkQvloVHDdnLW6TfGVy1XNj1r+Ydn9sYMAKvtVgiR?=
 =?us-ascii?Q?LInvabCIbRZc8d+JeN4t3dgPymJnClwmPCsTBETC64czueS5E/Z03vekaadJ?=
 =?us-ascii?Q?mx8Qf0PAvwPPtC6GeQwDFkoGHy3aUvR22UU9zIW+D/ZPub1CrwRgWYDQB40V?=
 =?us-ascii?Q?DxG0aCOqrglpJR6uqt7UP2GF5uYyyn3Fbq0h3SogYucgXQOq7AMrjQZJF9Jc?=
 =?us-ascii?Q?yJ2xwYjAKQrckol+ggXKaES6HltJpr+BNftvr/uWMicepb0AN3aNee9uVXSr?=
 =?us-ascii?Q?gD30V6gxPnK7+7onKagGWqC5I/y8Sd5RjqAY1v5a89wz6ZQwqjJMU5HTlvqU?=
 =?us-ascii?Q?eCi/qbmNUJKM9QOtGXtxCMNIpYLl3aTCE66EwaUq/qDmVFIWMWySfsS+qZ9E?=
 =?us-ascii?Q?MivJWF9yhRMW8MBT24MfR86E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d190ef-9e96-41fb-aaa1-08d915c87019
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 04:34:47.2775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3WluWMe3mhnuJtVD0O/Ck0IDnJNTIpR6okIVh0wLg1Jwp2AgwJYI7Sm/+tpxK2ECSFqTQOvJhTVp4rQY0yG5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On Wed, May 12, 2021 at 03:15:37PM +0200, Borislav Petkov wrote:
> On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> > +static inline void notify_page_enc_status_changed(unsigned long pfn,
> > +						  int npages, bool enc)
> > +{
> > +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> > +}
> 
> Now the question is whether something like that is needed for TDX, and,
> if so, could it be shared by both.
> 
> Sean?
> 
> > +void notify_addr_enc_status_changed(unsigned long vaddr, int npages,
> > +				    bool enc)
> 
> Let that line stick out.
> 
> > +{
> > +#ifdef CONFIG_PARAVIRT
> > +	unsigned long sz = npages << PAGE_SHIFT;
> > +	unsigned long vaddr_end = vaddr + sz;
> > +
> > +	while (vaddr < vaddr_end) {
> > +		int psize, pmask, level;
> > +		unsigned long pfn;
> > +		pte_t *kpte;
> > +
> > +		kpte = lookup_address(vaddr, &level);
> > +		if (!kpte || pte_none(*kpte))
> > +			return;
> 
> What does this mean exactly? On the first failure to lookup the address,
> you return? Why not continue so that you can notify about the remaining
> pages in [vaddr - vaddr_end)?

What's the use of notification of a partial page list, even a single
incorrect guest page encryption status can crash the guest/migrated
guest.

> Also, what does it mean for the current range if the lookup fails?
> Innocuous situation or do you need to signal it with a WARN or so?
> 

Yes, it makes sense to signal it with a WARN or so.

> > +
> > +		pfn = pg_level_to_pfn(level, kpte, NULL);
> > +		if (!pfn)
> > +			continue;
> 
> Same here: if it hits the default case, wouldn't it make sense to
> WARN_ONCE or so to catch potential misuse? Or better yet, the WARN_ONCE
> should be in pg_level_to_pfn().

Yes, it makes sense to add a WARN_ONCE() in pg_level_to_pfn().
> 
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 16f878c26667..45e65517405a 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -2012,6 +2012,13 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
> >  	 */
> >  	cpa_flush(&cpa, 0);
> >  
> > +	/*
> > +	 * Notify hypervisor that a given memory range is mapped encrypted
> > +	 * or decrypted. The hypervisor will use this information during the
> > +	 * VM migration.
> > +	 */
> > +	notify_addr_enc_status_changed(addr, numpages, enc);
> 
> If you notify about a range then that function should be called
> 
> 	notify_range_enc_status_changed
> 

Ok. 

Thanks,
Ashish

> or so.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7Cb880e2dae4d24f208c8b08d915480b4a%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637564221487050648%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=q%2FOAt%2FQqv0t%2BXDhjvPQAEYj67XQIUWbis0MXGMu4EZY%3D&amp;reserved=0
