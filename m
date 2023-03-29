Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60B76CF6A7
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjC2XAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjC2XAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:00:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC29D4699;
        Wed, 29 Mar 2023 16:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDF5hj8BDGMD4qxIh985mwaV/AH5sy9XS7UG48Ey3Sf4GgaINL+hztWMJII1g2higdWH6eoCS1TkBmRi6WRzx0SOV69r3mCNx1dF8yWMU0N1qhn7ERlgkXx3bUUncIrytsPH0GstKu/+WtzniaNFyp4q6RwS7tWsdijRtjM538ZXHpkjZVjUR4DdV/8kd/cEgwC2NlKhWObjwPB+rvuM9Wfqc399/qmpjtHVUKPFJ1ISw+vxIfTjNinkfvo/5xiZElpvsNc+rKJkveIT1eUus0l+ncdczf1oYapSbga51YOzLU778GKGRhOEp6tkTb9+CcWZZXgNEPloMiCat9GeJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F65i/CnmezvIfKePWCnnkLjIp+bYiExkhS6ySO1ya+M=;
 b=G/BIQHVHu16TUvTOHERBJD0cNDjgTbNkzJUtsIdc8C4gLOQfeJJ0wn3ITqWAM7JkKSdikjUzXQcmGOksmQNXYKReGHQo02rJY4m8zzR3UEfIk8VLAHi9J3c1HmJ7PxkVYbk+SvWlkFt3/1Qw+gs+QG/c2+tCOuG9JWhiSoT2Lw+RLUZeL3jSSmNN5oHWVzwqcySUD//a2VEyfod8KzjGLZFCtnRVCXZY6gHlg2j5RcqE1Z3AavQeg/JSfq3tiNnjJ3QXyJ4MGxFWjh+dcuQKEkS/yUM8S9jRSzY3kC/a7LQuzSI8i5dKznNiKfjgCnV6KUWWhfN+nzYIjG+7ARaX3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.cz smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F65i/CnmezvIfKePWCnnkLjIp+bYiExkhS6ySO1ya+M=;
 b=fbek3/RGpoHnVnJ0SrKVy2bxepOxiHlSPYjOG/EghObYfHS+XmLajG78U9JksX/E3eQOFe7UvPpcxCfuNmBYAgd+MdIM3lXlTJViYCUAiCIWysAoojToIah+ospKCq7HjVI7lqVcvcE25CozFM6PDS7U2xacQtvXwFr4pS5BVvs=
Received: from DM6PR06CA0012.namprd06.prod.outlook.com (2603:10b6:5:120::25)
 by SN7PR12MB8434.namprd12.prod.outlook.com (2603:10b6:806:2e6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 23:00:18 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::73) by DM6PR06CA0012.outlook.office365.com
 (2603:10b6:5:120::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 23:00:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 23:00:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 29 Mar
 2023 18:00:16 -0500
Date:   Wed, 29 Mar 2023 17:59:58 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Vlastimil Babka <vbabka@suse.cz>
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
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 12/56] x86/sev: Add RMP entry lookup helpers
Message-ID: <20230329225958.4s3nwcqyjwzydwsf@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-13-michael.roth@amd.com>
 <b48ad925-eff0-8421-730a-6da13bf93ab6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b48ad925-eff0-8421-730a-6da13bf93ab6@suse.cz>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|SN7PR12MB8434:EE_
X-MS-Office365-Filtering-Correlation-Id: 386e2420-2963-4438-c419-08db30a95d40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+uw6rUbm+26o3aAn9ppZfmNfSIoOrNoLwa5+GtFs6ghcG7NMHOaIeJA/+TzRSQQl9NEcbZjvYZLQRka6G3jOBNmON7xkjaXFOo/YmouydAZ3291KdPWG9GePxSHSOqlA4Q65AwXqhvCoKWoo2EPxa9DgJ8RYGwRluZOH3iFV1NyVlTEHmcWnCS/K5NbO0VertEhJwl88/BOTlpzzloFiHIohMm5UkZTnFCTZX9QVYzr1wC+sKxYo7R8ECxcgOE6xJJvK58AtZsAiSTnSYjq/gwngZf7Drmk03yswHMKnmDnO8u8SiqhkVePGtZJNqld15PvaBPb/lBbVM367AvUxaCETjjBmlTKIydKMa1vQfFUr7Zpjdb4RZzS/vhKuPKTvcb3yPEdKEWMWsYw/brDifnzNkyGnBcTu6cueP5hvRIVL3umv68tUUGbhobBchkehSoB8xnC2aUkKRg/ZiQD6jf4pUSjf2y+zx8TEYHp6P7BJ5KW6p3RNxQtyAXPnvL4MZ3zeMsK3TSozOGQmOVmDgJ5mg53PLAFnqvog8/D4fUNeib6J81QfQeOLJ0xK3ejJgzZik8rzZBxq7kvjOZHYVM6zluCzWoAyl1rFwj0O7v9DfO3G0cc8Bb9KijKJ37Z02j9RFQlO+QDNi9v/RIP05YQOwoeNjK920p93YOpJ9dqO8Jbkle9gCIF2bK3YKCZk9RJ8EfYQ2XMt484QWoH09tQ1ewPXN4twTau1qV8szwX2wf66p9rJAXeEcbJrxak
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(5660300002)(7416002)(7406005)(8936002)(6916009)(70586007)(70206006)(316002)(41300700001)(40480700001)(8676002)(54906003)(81166007)(426003)(66899021)(2616005)(2906002)(336012)(4326008)(82740400003)(36860700001)(44832011)(478600001)(40460700003)(356005)(47076005)(36756003)(16526019)(6666004)(82310400005)(966005)(186003)(83380400001)(86362001)(53546011)(1076003)(26005)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 23:00:17.4407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 386e2420-2963-4438-c419-08db30a95d40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8434
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 04:28:39PM +0100, Vlastimil Babka wrote:
> On 2/20/23 19:38, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> > entry for a given page. The RMP entry format is documented in AMD PPR, see
> > https://bugzilla.kernel.org/attachment.cgi?id=296015.
> > 
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> 
> > +/*
> > + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
> > + * and -errno if there is no corresponding RMP entry.
> > + */
> 
> Hmm IMHO the kernel's idiomatic way is to return 0 on "success" and I'd
> assume the more intuitive expectation of success here if the entry is
> assigned?

In general I'd agree. Here's it's a little awkward though.
snp_lookup_rmpentry() sort of wants to be a bool, where true indicates
an assigned entry was found, false indicates no assigned entry.

But it also has to deal with error values, so the most direct way to
encapsulate that is true == 1, false == 0, and < 0 for errors.

Inverting it to align more with kernel expections of 0 == success/true
gets awkward too, because stuff like:

  if (snp_lookup_rmpentry(...))
    //error

still doesn't work the way most other functions written in this way
would since it could still be "successful" if we were expecting PFN to
be in shared state. So the return value needs special handling there
too.

Would it make sense to define it something like this?:

  /*
   * Query information about the RMP entry corresponding to the given
   * PFN.
   * 
   * Returns 0 on success, and -errno if there was a problem accessing
   * the RMP entry.
   */
  int snp_lookup_rmpentry(u64 pfn, int *level, bool *assigned)

> The various callers seem to differ though so I guess it depends on
> context. Some however don't distinguish their "failure" from an ERR and
> maybe they should, at least for the purposes of the various printks?

Yes, regardless of what we decide above, the call-sites should properly
distinguish between failure/assigned/not-assigned and report the
information accordingly. I'll get those fixed up where needed.

Thanks,

-Mike

> 
> > +int snp_lookup_rmpentry(u64 pfn, int *level)
> > +{
> > +	struct rmpentry *e;
> > +
> > +	e = __snp_lookup_rmpentry(pfn, level);
> > +	if (IS_ERR(e))
> > +		return PTR_ERR(e);
> > +
> > +	return !!rmpentry_assigned(e);
> > +}
> > +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> 
