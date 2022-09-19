Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBC05BD441
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 19:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiISR53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 13:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiISR51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 13:57:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DC82126A;
        Mon, 19 Sep 2022 10:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZgRhN1KhAooxeXUNWqPnshMbT4on82tp04gxsfvbNKBDEvCXrLOjq5eiiGsSKc3AbT/iKxqQZDssm0t8a182V6acbrYpRhNoeIMGMwF3g0nrx9hz8BWSrH2LmMwqdKqZrBzMZz2BIevsH+XNs3EEYH34wN3KeUW4F3MtAudXRbNaYeWPxINYf8QJgglwa1geLzK8W8DXEVqyt+OFPlTPV7AgnPBex8oO0GkWCbEilEPl1VyJh+iJ1GP0p/e68+7Ya7vXrd1rCHBvSK8qO8B/MjfMs0Dy0HjTHr/RfsNTbiGQqnw8EbBKZ/JM83uyI3mV666OPhTbqzYVn8RrGhw2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZEEWXTQQa9g7Q9tiTY4qtCBpBSMHfNMZ3ZJYB13/oY=;
 b=kPcMJyVCqORh3fC2MpzlC0Ry7GOJcZ5JvyP4qqh2WbxOaWWDHzf1bkbtH+B42eZrF/Z5H+FLMAVJvTjVefEktTBTEIVd44I285M8bK1GH8bGjSaThWnMrECa0RszqPhR9wOt1y2WFwstRp81H+zuymcvzq/eELO+u9iUAg3nS4wttYSwsJc1F3ofXI+2Vq3Zzee4ifWSjWpSL63xE6/6pEj9QH+n9Lj5mqY8C5iep0rL2T1aSGzvEW6kzW7IjQzV8R/VYATWlo2W6cWzNqFbIX7ap09LGrUU0rZ0GUk+W4V32lfZGncmoKYA4lyOtCrOzxLNez2decG1uP5c2BMplQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZEEWXTQQa9g7Q9tiTY4qtCBpBSMHfNMZ3ZJYB13/oY=;
 b=YflCRlcWJlYDZ+V7Mf2EUn5S510Uyb1QvkLUZ4OK4/8+Rm0WwPRohXGlRnxOpil87bPv30B5Ot7T8qacl6Zn/VA1q7M3rYQdcdB4yF2uFoDUMpl1/Bl2jOufu4a+OsTrAcg0Z8uWaIH1dPFNVbffdaNc6xST5qQEihvxY0hE77A=
Received: from BN9P221CA0006.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::33)
 by CH2PR12MB4874.namprd12.prod.outlook.com (2603:10b6:610:64::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Mon, 19 Sep
 2022 17:57:24 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::ce) by BN9P221CA0006.outlook.office365.com
 (2603:10b6:408:10a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Mon, 19 Sep 2022 17:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 17:57:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 12:57:22 -0500
Date:   Mon, 19 Sep 2022 12:56:15 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Brijesh Singh <brijesh.singh@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Tobin Feldman-Fitzthum" <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Vlastimil Babka" <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        "Andi Kleen" <ak@linux.intel.com>, <tony.luck@intel.com>,
        <marcorr@google.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <jarkko@profian.com>
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <20220919175615.7ehzimgyy2dnt777@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com>
 <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com>
 <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com>
 <YyGLXXkFCmxBfu5U@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YyGLXXkFCmxBfu5U@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|CH2PR12MB4874:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc761f6-2e12-4f9f-1ce2-08da9a68682d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ToySGTuAn33OnXK18s1bAQMvZQiLePe4oTGK0XRiwOBHHW6wGllxV716GSOm4PFlw9fSfXHWeo6CT0akI5t88xUNrIR5+OOOICWErZrl2sqAsnNSLiRQCokA9BKV807OADb3E1xnVKfAJ0zpf5iN5Gz2qKblplyG8T8tFtAIpOgn4J0Vk9hry31OCkz5mCmJq7Kne1FNlE20SMYDKIG1UvLeskoY+aTmWhTeYf6ePJMlIZyjBemxVQZD6J1K2CCUdpk4MIjsZVeThkaGYNoy5w7A6v6ZvB0sILvsAWPlijHEQnTQXirPfII0uhQ9JCtl0FuFqCGmhPJW4rXuqSw447glJTx9cKF2Y/SVs0uZHDMzhvGWatMTg61748a2GaK+jUUMFXFot2hySEE/u7wbwDFFWYVfaczoTnySNilwKmoiVxEm1ZwDb3M4uDlBEszf7+UCT37ay9Xl5NMWPIaPf+KXK+uEn6hQOrVTleeoIOriRKkIbKiIjlJEJfvy86C4y2mvXFny06zj6WZtTixKhrPYg64y/m5AvJMr8WDw/k+pawP19f+Wr/xHf7QdxY7idcJw0lXGmyM1Mv1VjVUoqgBQIa+PkEK3/E3gBTF2HYIjhxZ9/firdaIbrJJ7FNov5vc/KaZgTJmirJ5VSjrB7uaCCZ5mXjSuFu86vHW6ERXS3NRw5OE6t6o5hcQGYlrXaQlTMg5P0DpcELLk7zSypAh1l5UBq21e4PJBgUIW/gdtcd9RdcMeUG9JsVsqpoqlOPw2NurfRzqJYfcDQ94TapxyjhIc7cx7dLIcFzg8tYwo5b4g7N6NlY745uAkT5s8TBTsgaVgiAV3IoxJ2DaOg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(26005)(356005)(16526019)(966005)(478600001)(2616005)(82740400003)(41300700001)(6666004)(45080400002)(1076003)(186003)(40480700001)(86362001)(40460700003)(47076005)(83380400001)(426003)(36860700001)(336012)(36756003)(82310400005)(81166007)(8936002)(70586007)(70206006)(2906002)(5660300002)(316002)(8676002)(54906003)(6916009)(7416002)(44832011)(7406005)(66899012)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 17:57:24.0628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc761f6-2e12-4f9f-1ce2-08da9a68682d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4874
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 14, 2022 at 08:05:49AM +0000, Sean Christopherson wrote:
> On Thu, Sep 08, 2022, Michael Roth wrote:
> > On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > So in the context of this interim solution, we're trying to look for a
> > solution that's simple enough that it can be used reliably, without
> > introducing too much additional complexity into KVM. There is one
> > approach that seems to fit that bill, that Brijesh attempted in an
> > earlier version of this series (I'm not sure what exactly was the
> > catalyst to changing the approach, as I wasn't really in the loop at
> > the time, but AIUI there weren't any showstoppers there, but please
> > correct me if I'm missing anything):
> > 
> >  - if the host is writing to a page that it thinks is supposed to be
> >    shared, and the guest switches it to private, we get an RMP fault
> >    (actually, we will get a !PRESENT fault, since as of v5 we now
> >    remove the mapping from the directmap as part of conversion)
> >  - in the host #PF handler, if we see that the page is marked private
> >    in the RMP table, simply switch it back to shared
> >  - if this was a bug on the part of the host, then the guest will see

Hi Sean,

Thanks for the input here and at KVM Forum.

> 
> As discussed off-list, attempting to fix up RMP violations in the host #PF handler
> is not a viable approach.  There was also extensive discussion on-list a while back:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F8a244d34-2b10-4cf8-894a-1bf12b59cf92%40www.fastmail.com&amp;data=05%7C01%7Cmichael.roth%40amd.com%7C2f2356ebe2b44daab93708da9627f2b4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637987395629620130%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=Mm13HgUAE4M%2BluyBys3Ihp%2FTNqSQTq14WrMXdF8ArAw%3D&amp;reserved=0

I think that was likely the only hope for a non-UPM approach, as
anything else would require a good bit of infrastructure in KVM and
elsewhere to avoid that situation occuring to begin with, and it
probably would not be worth the effort outside the context of a
general/platform-independent solution like UPM. I was hoping it would be
possible to work through Andy's concerns, but the concerns you and Paolo
raised of potential surprise #PFs in other parts of the kernel are
something I'm less optimistic about, so I agree UPM is probably the right
place to focus efforts.

> 
> > AIUI, this is still sort of an open question, but you noted how nuking
> > the directmap without any formalized interface for letting the kernel
> > know about it could be problematic down the road, which also sounds
> > like the sort of thing more suited for having UPM address at a more
> > general level, since there are similar requirements for TDX as well.
> > 
> > AIUI there are 2 main arguments against splitting the directmap:
> >  a) we can't easily rebuild it atm
> >  b) things like KSM might still tries to access private pages
> > 
> > But unmapping also suffers from a), since we still end up splitting the
> > directmap unless we remove pages in blocks of 2M.
> 
> But for UPM, it's easy to rebuild the direct map since there will be an explicit,
> kernel controlled point where the "inaccesible" memfd releases the private page.

I was thinking it would be possible to do something similar by doing page
splitting/restore in bulk as part of MEM_ENCRYPT_{REG,UNREG}_REGION, but
yes UPM also allows for a convenient point in time to split/unsplit.

> 
> > But nothing prevents a guest from switching a single 4K page to private, in
> > which case we are forced to split. That would be normal behavior on the part
> > of the guest for setting up GHCB pages/etc, so we still end up splitting the
> > directmap over time.
> 
> The host actually isn't _forced_ to split with UPM.  One option would be to refuse
> to split the direct map and instead force userspace to eat the 2mb allocation even
> though it only wants to map a single 4kb chunk into the guest.  I don't know that
> that's a _good_ option, but it is an option.

That does seem like a reasonable option. Maybe it also opens up a path
for hugetlbfs support of sorts. In practice I wouldn't expect too many
of those pages to be wasted, worst case would be 2MB per shared page in
the guest... I suppose that could add up for GHCB pages and whatnot if
there are lots of vCPUs, but at that point you're likely dealing with
large guests with enough memory to spare. Could be another pain point
regarding calculating appropriate memory limits for userspace though.

Thanks!

-Mike
