Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A1969D509
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 21:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjBTUe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 15:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBTUeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 15:34:24 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E7C193FB;
        Mon, 20 Feb 2023 12:34:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F93Li0DgAqbCxqdP+rZpunYdYTDRgRj6c9In86/FX8hFBrBFXNNvSgpQtYiBhIycCIxtQcNjWGJNnh5LzCvrtAS6vlbbS5serBdMC167f2nEBYn57kAccO5Z9GWEaEBn1b//BvfTDHkvPU77YRD/uuF4JjH7IGZ32/A7bZAytOv+DbqoAbRlcJFJ3VrYI+L1GOs9DLJzMLcL3zucuynDx9W27K9kbhlx6tgAobNkseSGM0WKAPgfCbPOc5DFUCMjVuPuCrRrY4VgFaaa80mGPkxtCMcdV8qCew1fgufMOfX3rB0KIhgp/dd6Eb8hHyZaDK9i3Iul0gSPlKR0YkU4/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0GngpEAj0k1OWgyk0D03qOWG2sQkyN2bOfyqNVfyHI=;
 b=kmA+BfDSRMHp997ibtwX/9pPKR0sStZVbyogjWxy35S3GAJ2jkB+tWRP8MQN2973mcroVzR+JxziTBgkBB9Uh6t+rvWhKuieeW5V1+OTPUP21f+WmkXxiClcUttr0Z1IQkbVmeDRtNhUJyL6GJEY4FpXOihAbQ2LJUffBSe+c+dyWeb4GpP8q2eZivN6tryzsQD7PikbL5WRR/4lT8Apj5f4v7d9neP13iOFQEk/OMVe18vFY7BDVTQ3aBwaRo/wxXDik8TJEYmEfhJee5mVXwNQ8Jew/Ahb6mHoy9GP7uCaDjBRENMF4KLJM8e7w3iJNZru5+JO3n+WL8XR2Jad2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0GngpEAj0k1OWgyk0D03qOWG2sQkyN2bOfyqNVfyHI=;
 b=iA1Zm3T0iL4pmL1di7tZAx/lpkS+H8ndcwxMAbqcc5AepZKD1BKGpcGk5Iw3oa9UdtHhvSgbjpe+/6m+Nl99P6e6oel24FNeGmNMYOmHmqL1Q/bgT7H7JULeg6HkSGVDsdTuhx8jplp8CgO1srmLIGjO89+7VbLWa2BhL3173mo=
Received: from DM6PR03CA0042.namprd03.prod.outlook.com (2603:10b6:5:100::19)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 20:34:21 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::9c) by DM6PR03CA0042.outlook.office365.com
 (2603:10b6:5:100::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 20:34:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 20:34:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 14:34:20 -0600
Date:   Mon, 20 Feb 2023 14:31:27 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Hugh Dickins <hughd@google.com>
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 18/56] x86/fault: fix handle_split_page_fault() to
 work with memfd backed pages
Message-ID: <20230220203127.o4mf2bcrlwgsmf7z@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-19-michael.roth@amd.com>
 <29e9ed33-52eb-fbb4-5358-76939df747a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <29e9ed33-52eb-fbb4-5358-76939df747a9@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 5053471c-e46e-4a48-8340-08db1381d8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeC4GVYzt7Zj+W6CjjgyDsTGI0vI0/NJ9J75aEqW5ZqhANrQ9NYlOZBCMVH8BIIHMztU+H+ydBRpMD72nKpHr1PXUZX80eDJJCs46yjYqIsY/IPmpbuQlIgnpnuV9vbDGRtx+XIH2th8IHoJjam2wKhe3KUCSa7yFDNYNrgwgV67EPPw3TzwP7dgPnMou/5p6Q9X8zCfi2cdVH+UfO89eEtdIar8Wq6QQmR/SPiQKiRXvaEc0hG6qxmlUM5yHULkhV46C37KjMUHyy7MKZ7KQ9IgpzC0Bv0aqdUC8IUneM1GUsi1wOMdJ0wIcm7WHW2lKgFOfj6kDyXxviazu2yk31qFiDO7LTX0Ijdf27Qrbu4gY61U0NodMUM+Z8G/YySJ/FaF9TzfVwLbRwK/feTPyeiUOJrHm1BLK2p8G6EG8mrn31UI7CAdCKDr88043ZyeGQ5ZcDbeiKdqthssaENc/ignNrWkjmsUb5w7ec2XTWdM+r/d7G7hOtqPf3X6imkqxtSM5nZJurFla5eiRS7F/c3jGTIs2nWviU2srUhALwZCGRzOXhxKb0eJfmso9Slb8VSuPByUb/PWt2nd0dC4EDT9uom0runwV3HfP0F9baazMw3HAAQlyuUcCOZMHC0iP06iu3Yn1JTgpOpKaN3Xfz4cFEfzeqqiBOuuaOzzCwZe7VkHyYmtQtcXjBKcbHOtBgBOGtHovKT+WZ38yF4digVrn8oaxkmiM7tVaZpzw38=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(6916009)(83380400001)(40460700003)(36756003)(86362001)(5660300002)(36860700001)(7406005)(7416002)(2906002)(81166007)(8936002)(356005)(40480700001)(47076005)(82310400005)(426003)(336012)(70206006)(966005)(1076003)(8676002)(82740400003)(478600001)(70586007)(44832011)(186003)(54906003)(26005)(41300700001)(2616005)(4326008)(16526019)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 20:34:21.3585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5053471c-e46e-4a48-8340-08db1381d8ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 11:57:59AM -0800, Hugh Dickins wrote:
> On Mon, 20 Feb 2023, Michael Roth wrote:
> 
> > From: Hugh Dickins <hughd@google.com>
> 
> No.
> 
> > 
> > When the address is backed by a memfd, the code to split the page does
> > nothing more than remove the PMD from the page tables. So immediately
> > install a PTE to ensure that any other pages in that 2MB region are
> > brought back as in 4K pages.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> No.  Suggested-by would be okay.
> 
> > Cc: Hugh Dickins <hughd@google.com>
> 
> Thanks.  I'm really sorry to be such a jobsworth,
> and have nothing more constructive to say than I did before in
> https://lore.kernel.org/linux-mm/7f2228c4-1586-2934-7b92-1a9d23b6046@google.com/
> (please re-read), but adding a Signed-off-by where none was given is wrong;
> and I'm not ever going to comprehend enough of the context to give it.

Hi Hugh,

Sorry for the mix-up, I'd intended to remove this patch before submitting. I'll
make sure to remove it from future postings.

> 
> Best of luck for the series,

Thank you!

-Mike

> Hugh
> 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  mm/memory.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index e68da7e403c6..33c9020ba1f8 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4999,6 +4999,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> >  static int handle_split_page_fault(struct vm_fault *vmf)
> >  {
> >  	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> > +	/*
> > +	 * Install a PTE immediately to ensure that any other pages in
> > +	 * this 2MB region are brought back in as 4K pages.
> > +	 */
> > +	__pte_alloc(vmf->vma->vm_mm, vmf->pmd);
> >  	return 0;
> >  }
> >  
> > -- 
> > 2.25.1
