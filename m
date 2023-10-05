Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F147BA879
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjJERx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjJERxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:53:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BD5DD;
        Thu,  5 Oct 2023 10:52:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuXmqZjxPcdRI3DFhZtNmyLyCrxYUPNpOlhyRo1ZV2pgHS6l00DXQie7ypIKlOG2kxBvfHYWtbJwEizCT9ZSQGPvZiuyxI7wAJNQgxfV3HPcZ8nBaDYRVySuQSCVzyeEfIrpDOu+7fvVjFjKzUUVWITnnY/cndshBv4J0lRyGzo6TRF8ZAT1OEld6LsS7lDHdy77l7IYZBEoFEkp4t1C328kFoX8hF9p/pAA9dJYbKgCYNjb9v4kNtUdgP5IZvowJBI3xmnrWDKJDBNu+g/ahSuPXTDBi3DN7HJY8c7XVu91tmcD2aHC7mXkag4YajH9H3mFBlnemQgCgwJE1/SVRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JH30AXY8RydZr5SMo+4uSNARyDUbHggctPWCrhVPBLM=;
 b=XAlqlkFa585C023f1v/w4r45t/8T31wpL7Vh0NQEpYHitqppG91/ZMu1VdixXktnXXXRaUl+nYvrsOvkDDQbwvZcmBfJ2D8p6Gqy2ya2p5j3kfBAtTFZHTef/dpXHCpI2Q1Djdi3YUfdklgNRCNwdjEp7ok2C9AAzxqWwH3tgLB8IK9nka8Ta8PwwjjWbyeBIidh90V/0RK3jhTAtx8HoGQulpGZAhe7Tzz939EDPoJtBaf3RDrNJqT3z1sSTwkoIW7ClHH9SDhCxU7jKEybV1/J8qk7sTOb5hoqC9TCzWJ6HFw2LXiU2EFFsh6B1C1AEBoxvBA0qJSfywDgVeC8fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH30AXY8RydZr5SMo+4uSNARyDUbHggctPWCrhVPBLM=;
 b=4hkAS2PpVvVpqN20KiDyqEEBxV7WJVivk5dTRF3ebzAduoRgCQRQZ6Zk3u+AfBUFG12s7WP1ECqhMoAxsEaFh3Upaavw+ra5qSFq1fiusFPlpFQqJK4Noxd5uKgMWBJoQ89wqV+MoKzeAJ6BRB+JFTjvOwSayUlIKWooQTk7/MY=
Received: from BL1PR13CA0339.namprd13.prod.outlook.com (2603:10b6:208:2c6::14)
 by CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 5 Oct
 2023 17:52:54 +0000
Received: from BL6PEPF0001AB76.namprd02.prod.outlook.com
 (2603:10b6:208:2c6:cafe::61) by BL1PR13CA0339.outlook.office365.com
 (2603:10b6:208:2c6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.26 via Frontend
 Transport; Thu, 5 Oct 2023 17:52:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB76.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Thu, 5 Oct 2023 17:52:54 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 5 Oct
 2023 12:52:53 -0500
Date:   Thu, 5 Oct 2023 12:52:38 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, <wei.w.wang@intel.com>,
        Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH v2 1/6] KVM: gmem: Truncate pages on punch hole
Message-ID: <20231005175238.7bb2zut4fb7ebdqc@amd.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
 <f987dcde3b051371b496847282022c679e9402e4.1695327124.git.isaku.yamahata@intel.com>
 <ZQypbSuMrbJpJBER@google.com>
 <ZQy29msIoAGQUGR2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZQy29msIoAGQUGR2@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB76:EE_|CO6PR12MB5443:EE_
X-MS-Office365-Filtering-Correlation-Id: 99806d05-a96a-41eb-2064-08dbc5cbe6c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lST2BjvAYwIdQUoW6IeujKoMqwdoVt/8QV3I/Uo6L8ZhzuX4DKK8X9AEwL406SNct1FAfe+OqOgmwThseSE0J9ME8bEztMikMn434Z026wiRQVnHyZk5YlGTKcDtrPkopdNkppQGre2Qf4xf4t9Lg4A4cxkbXoyUb4k18AZGcEzm5BOWQtbj0UL/vX8eEdhhzBuTEYDu/Ud8hEGzTHvcQhnqoUZ0WiMBHgn/KOj4J/VSLiFcCquMd4D+enjDDlS5g7R+OcrUWjzmmpKRIo6+S8OBQuZQU+ZCRAdVHgqxYNmppEX1vkvsfK7m9lEwh2ydy5IRdkHXOtBmfxOybYG/akUWEObPXo8+xPIG5w5MGsb9lTolkWi5ZajztZJ79cRChlyPJwip0iI69S11mirL6lXjKWRTUTbRn7BvSu7m/cnzb/fIAjgmmKn6kflzUoCgKrec8tfKzKohZJAosQ1B068CGhzO+dhwi7HKqbqWDEgUdfyOq+iR7PVIzPipeSOG+CIqdgM6PSgIemk5FDO2Feyl88pGnTypfunYnzg+XFGKWSzEylldMf+RpOmNlkl3OMbj130WMP7sqPJsGpg8BmBXIRjRfvA2eBtL3vRcDcdSVtx6EojyhUfatCgW+o4ZoCmTjbCo7FBeOgrNau/64W/T4zH4HJ6z9wEUlyaDXJHBRrANsiEDYICD/7+p0zaub2uSXJX1jBhhhsa1EN0LFwmLvFoBXCwebLiP618LSLn2tgAvz1wUGLSyi84/Tv63Vd4dybBb+XLiSLgkTt5fQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(396003)(376002)(346002)(230922051799003)(82310400011)(64100799003)(1800799009)(451199024)(186009)(46966006)(40470700004)(36840700001)(478600001)(70586007)(2616005)(966005)(426003)(44832011)(8936002)(83380400001)(26005)(2906002)(16526019)(1076003)(54906003)(41300700001)(7416002)(336012)(6916009)(70206006)(5660300002)(316002)(4326008)(36756003)(47076005)(82740400003)(81166007)(36860700001)(8676002)(356005)(86362001)(6666004)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 17:52:54.2972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99806d05-a96a-41eb-2064-08dbc5cbe6c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB76.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 02:34:46PM -0700, Sean Christopherson wrote:
> On Thu, Sep 21, 2023, Sean Christopherson wrote:
> > On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Although kvm_gmem_punch_hole() keeps all pages in mapping on punching hole,
> > > it's common expectation that pages are truncated.  Truncate pages on
> > > punching hole.  As page contents can be encrypted, avoid zeroing partial
> > > folio by refusing partial punch hole.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  virt/kvm/guest_mem.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> > > index a819367434e9..01fb4ca861d0 100644
> > > --- a/virt/kvm/guest_mem.c
> > > +++ b/virt/kvm/guest_mem.c
> > > @@ -130,22 +130,32 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> > >  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
> > >  {
> > >  	struct list_head *gmem_list = &inode->i_mapping->private_list;
> > > +	struct address_space *mapping  = inode->i_mapping;
> > >  	pgoff_t start = offset >> PAGE_SHIFT;
> > >  	pgoff_t end = (offset + len) >> PAGE_SHIFT;
> > >  	struct kvm_gmem *gmem;
> > >  
> > > +	/*
> > > +	 * punch hole may result in zeroing partial area.  As pages can be
> > > +	 * encrypted, prohibit zeroing partial area.
> > > +	 */
> > > +	if (offset & ~PAGE_MASK || len & ~PAGE_MASK)
> > > +		return -EINVAL;
> > 
> > This should be unnecessary, kvm_gmem_fallocate() does
> > 
> > 	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> > 		return -EINVAL;
> > 
> > before invoking kvm_gmem_punch_hole().  If that's not working, i.e. your test
> > fails, then that code needs to be fixed.  I'll run your test to double-check,
> > but AFAICT this is unnecesary.
> 
> I confirmed that the testcase passes without the extra checks.  Just to close the
> loop, what prompted adding more checks to kvm_gmem_punch_hole()?

I don't know if it's the same issue that Isaku ran into, but for SNP we
hit a similar issue with the truncate_inode_pages_range(lstart, lend) call.

The issue in that case was a bit more subtle:

  - userspace does a hole-punch on a 4K range of its gmem FD, which happens
    to be backed by a 2MB folio.
  - truncate_inode_pages_range() gets called for that 4K range
  - truncate_inode_pages_range() does special handling on the folios at the
    start/end of the range in case they are partial and passes these to
    truncate_inode_partial_folio(folio, lstart, lend). In this case, there's
    just the 1 backing folio. But it *still* gets the special treatment, and
    so gets passed to truncate_inode_partial_folio().
  - truncate_inode_partial_folio() will then zero that 4K range, even though
    it is page-aligned, based on the following rationale in the comments:

        /*
         * We may be zeroing pages we're about to discard, but it avoids
         * doing a complex calculation here, and then doing the zeroing
         * anyway if the page split fails.
         */
        folio_zero_range(folio, offset, length);

  - after that, .invalidate_folio callback is issued, then the folio is split,
    and the caller (truncate_inode_pages_range()) does another pass through
	the whole range and can free the now-split folio then .free_folio callbacks
    are issued.

Because of that, we can't rely on .invalidate_folio/.free_folio to handle
putting the page back into a normal host-accessible state, because the
zero'ing will happen beforehand. That's why we ended up needing to do this
for SNP patches to make sure arch-specific invalidation callbacks are issued 
before the truncation occurs:

  https://github.com/mdroth/linux/commit/4ebcc04b84dd691fc6daccb9b7438402520b0704#diff-77306411fdaeb7f322a1ca756dead9feb75363aa6117b703ac118576153ddb37R233

I'd planned to post those as a separate RFC to discuss, but when I came across
this it seemed like it might be relevant to what the TDX folks might ran into
here.

If not for the zero'ing logic mentioned above, for SNP at least, the
.free_folio() ends up working pretty nicely for both truncation and fput(),
and even plays nicely with live update use-case where the destination gmem
instance shares the inode->i_mapping, since iput() won't trigger the
truncate_inode_pages_final() until the last reference goes away so we don't
have to do anything special in kvm_gmem_release() to determine when we
should/shouldn't issue the arch-invalidations to clean up things like the
RMP table.

It seems like the above zero'ing logic could be reworked to only zero non-page
aligned ranges (as the comments above truncate_inode_pages_range() claim
should be the case), which would avoid the issue for the gmem use-case. But I
wonder if some explicit "dont-zero-these-pages" flag might be more robust.

Or maybe there's some other way we should be going about this?
