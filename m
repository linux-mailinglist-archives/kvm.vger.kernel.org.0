Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D067892D9
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 03:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjHZBAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjHZBAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 21:00:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E845126B6;
        Fri, 25 Aug 2023 18:00:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiHcvIYAT7Ex1C3g0yQyTz5emzxrNewVrcTmxQPc2tB/Vk6l37aUM97QEzg7E6tIYnsh6WQ6nOuTmAs/Q3T13lo/mgXcruOo9+KKl4EXI2HNx0a00Xc44aQsxI6gmL+WESritJ1WFFscm9Lpel3spd44kVzf6cB22jg59qqfomERtbgw7TxqfITlaBMtJP9bH60caHqSzYRzdWw3GdPts75vMNcr9FzSJ8OiFJ30+3+qcaNkByBr6ErbjgJpvL/PPOBn5PO0fgmwoBU4Rfh5/GIrrjkwVmTMrq+IdaBSS7mxyl14I9RjsMrz4iZONc1Xat+yz6PdUWcujTmjCd8bYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xsf6/lnGqcwEa4m99CINtaJ4nKAoCfAACJ85ewE3QyU=;
 b=RH+NOOQkIzP/j6ii/zuk3N2i7VmLGQMUpmN7HuRJcl3qWblhj0nBTsGgmqPjAfD4VF5ArE3FC95d7pkGxpvSv48bBm/WK0flWu5SV34rFT2cG8JGXoiVUgWV2q/G7DRMThZmrqMRWHse/sj1O/8HPtcUpJxpwh+l3NyW9sC9Cg8xV5BCOh6+szH1JeJPMlBKuIr59h/VUidCFVwiecXwrMweUSeeRAs+c85+xksQpGhmIOlyouKCcE8J294j0t9wXgi3ve8fbcSYPL4bTrjyIlTsYibZiwCop5XiWRS1mZ/t7ZQ8yk+C5EUzfj1iGYeJiqnNWY6gVtbDN5IofHJA0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xsf6/lnGqcwEa4m99CINtaJ4nKAoCfAACJ85ewE3QyU=;
 b=DcUd9FypZI255zeXzMt0iGrGrJn8pFjKXa1FTNl5oRIB7dJJ44wynOLVejvIj0nT2dTSYlcN5vu2oRsxiPun/WdBCpJQsHbOckuJ0JixAdGM8N7VOu4QtWKGBHU7QB85RntCMIqzMkTgXKJDFUz0/UxhDtR6119bksLBs2kY4H8=
Received: from PH8PR15CA0008.namprd15.prod.outlook.com (2603:10b6:510:2d2::27)
 by PH8PR12MB6844.namprd12.prod.outlook.com (2603:10b6:510:1cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Sat, 26 Aug
 2023 01:00:02 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:510:2d2:cafe::80) by PH8PR15CA0008.outlook.office365.com
 (2603:10b6:510:2d2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34 via Frontend
 Transport; Sat, 26 Aug 2023 01:00:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Sat, 26 Aug 2023 01:00:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Fri, 25 Aug
 2023 20:00:00 -0500
Date:   Fri, 25 Aug 2023 19:59:41 -0500
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
        "Vishal Annapurve" <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>, <David.Kaplan@amd.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
Message-ID: <20230826005941.c7gtsootdaod7ek3@amd.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
 <ZLqVdvsF11Ddo7Dq@google.com>
 <20230722003449.664x3xcu6ydi2vrz@amd.com>
 <ZN/wY53TF2aOZtLu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZN/wY53TF2aOZtLu@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|PH8PR12MB6844:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f65a58-f298-4ddd-a10c-08dba5cfc753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qx8mpks1uv+B8MygHHmnV1LWW3Rx3Kcl3CWLkRrRGW2Uwo9dkFgmE5Xilijk+93OLmddaJNmMj+JD9ANWTODAe1WBeSSgDAYupYseuVzF18a9ZzWu9O0uH6zjXNn2E/xYPjDQJAfI4+m6IjFxSl8FWFUZwzm7DQDXWvaNqlLrW7D8wvTAiHqQMn2Z0n9yHBwL8NEEzbMHzvTmtRj+6HEWcmeAGk73tMHvG0NwaksZrUW/skcKgIWafPNXbrHqpyUWKbQKZ0TTJ0YzWH/kYAV7SqUxTBxAzzi+C38Hbv7kPA4U/zCdkd/OFxjzVdHifI7yy55yhw2FcFY4/KX12SjAh2n6r3bmiPF3Bc0xsqTF9zJ4DxX/iEasbs1uvJCwL79grtRMtXotI0KnWduaJ6kXqv9QOoLQpuLmxM+mBn7+OnEW08i3OSjY4x4FzOR04bn0FzbKaHl7fnMdaIRCUtb9U0ZH0YCCVputi1X1W8y/CkmZ4UXhsHw8/JXSnLoEQ0ni3LEULUWVjXNFLs0DQ2xW7G6D8BW7UsfVzKqVkY7/wQ0zkZPEk5M18xjB8WRgm62hby0FpzEIqHndqvFBIdVtlObqO+cFqHv55Cdjsi/XelXDP1Imq61Pe73z1MQIVR5popo5P5pR8vBRQBda5wCcIIAvCU+bUNUIxGBvz9aeOoDRklMkEp9sStPKMEY3B4qY2VE12m0dPcz1UdrBRVYK4wvt7g/f5u9GcUFLWEtZIfsiF1z3SS6G0MYQ0fN2Kq9BS1hJdaViPQBiTxagKjq9w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199024)(1800799009)(82310400011)(186009)(36840700001)(40470700004)(46966006)(86362001)(356005)(81166007)(82740400003)(36756003)(66899024)(40460700003)(478600001)(6666004)(966005)(70206006)(4326008)(54906003)(70586007)(6916009)(8676002)(2906002)(316002)(5660300002)(40480700001)(44832011)(8936002)(26005)(336012)(426003)(83380400001)(16526019)(41300700001)(7416002)(47076005)(2616005)(1076003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2023 01:00:02.3235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f65a58-f298-4ddd-a10c-08dba5cfc753
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6844
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 03:27:47PM -0700, Sean Christopherson wrote:
> Sorry for responding so late, lost track of this and only found it against when
> reviewing the next version :-/
> 
> On Fri, Jul 21, 2023, Michael Roth wrote:
> > On Fri, Jul 21, 2023 at 07:25:58AM -0700, Sean Christopherson wrote:
> > > Practically speaking, hooking the fault path will result in undesirable behavior.
> > > Just because KVM *maps* at 4KiB granularity doesn't mean the RMP must be assigned
> > > at 4KiB granularity, e.g. if userspace chooses to *not* PUNCH_HOLE when the guest
> > > shares a single 4KiB page in a 2MiB chunk.   Dirty logging is another case where
> > > the RMP can stay at 2MiB.  Or as a very silly example, imagine userspace pulls a
> > > stupid and covers a single 2MiB chunk of gmem with 512 memslots.
> > 
> > Unfortunately I don't think things aren't quite that flexible with SNP. If
> > RMP entry is 2MB, and you map a sub-page as 4K in the NPT, you'll immediately
> > get a PFERR_GUEST_SIZEM on the first access (presumably when the guest tries
> > to PVALIDATE it before use). The RMP fault handler will then subsequently
> > need to PSMASH the 2MB entry into 4K before that guest can access it. So you
> > get an extra page fault for every 2MB page that's mapped this way.
> > (APM Volume 2, Section 15.36.10).
> 
> Well that's just bloody stupid.  Why is that a restriction?  Obviously creating
> an NPT mapping that's larger would be annoying to handle, e.g. would require
> locking multiple entries or something, so I can understand why that's disallowed.
> But why can't software map at a finer granularity?
> 
> Note, I'm expecting a spec change, just expressing a bit of disbelief.

I asked David Kaplan about this and one of the reasons is that it allows
hardware to reduce the number of RMP table accesses when doing table
walks. E.g. if the mapping is 4K in the NPT, then only that RMP entry
needs to be checked, the hardware doesn't need to also then check the
2MB-aligned RMP entry before determining whether to generate a #NPF.

(note: the 'assigned' bit does get set on each individual 4K entry when
RMPUPDATE use the 'page-size' bit to create a 2MB RMP entry, but if you
look at the pseudo-code in the APM for RMPUPDATE it actually leaves
ASID=0, so those accesses always generate an #NPF(RMP) and aren't actually
usable for 4K NPT mappings of sub-pages for the 2MB range corresponding
to that 2MB RMP entry (and not #NPF+RMP+SIZEM as I incorrectly stated
above))

> 
> Anyways, IMO, we should eat the extra #NPF in that scenario and optimize for much,
> much more likely scenario of the RMP and NPT both being able to use 2MiB pages.

That seems fair, I only see this particularly case occur once or twice
for boot.

> And that means not inserting into the RMP when handling #NPFs, e.g. so that userspace
> can do fallocate() to prep the memory before mapping, and so that if the SPTEs

Makes sense.

> get zapped for whatever reason, faulting them back in doesn't trigger useless
> RMP updates.

We wouldn't issue an RMPUPDATE if we saw that the page was already set to
private in the RMP table. So what you actually save on is just accesses to
the memory range containing the RMP entry to do that check, but the approach
still makes sense.

> 
> I guess the other way to optimze things would be for userspace to use the ioctl()
> to map memory into the guest[*].  But even then, initializing when allocating
> seems cleaner, especially for TDX.
> 
> [*] https://lore.kernel.org/all/ZMFYhkSPE6Zbp8Ea@google.com
> 
> > That might not be a big deal for guests that are at least somewhat optimized
> > to make use of 2MB pages, but another situation is:
> > 
> >   - gmem allocates 2MB page
> >   - guest issues PVALIDATE on 2MB page
> >   - guest later converts a subpage to shared but doesn't holepunch
> >   - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
> >   - KVM MMU splits NPT mapping to 4K
> >   - guest converts that shared page back to private
> > 
> > At this point there are no mixed attributes, and KVM would normally
> > allow for 2MB NPT mappings again, but this is actually not allowed
> > because the RMP table mappings are validated/4K and cannot be promoted on
> > the hypervisor, so the NPT mappings must still be limited to 4K to
> > match this, otherwise we hit the reverse of the PFERR_GUEST_SIZEM
> > scenario above, where the NPT mapping level is *larger* than the RMP
> > entry level. Unfortunately that does not result in a PFERR_GUEST_SIZEM
> > where we can fix things up in response, but instead it's a general
> > RMP fault that would be tricky to distinguish from an RMP fault
> > resulting from an implicit page conversion or some other guest weirdness
> > without doing RMP table checks every time we get a general RMP fault.
> 
> This seems like a bug in the SNP code.  (a) why would KVM/SNP PSMASH in that
> scenario and (b) why can't it zap/split the NPT before PSMASH?

a) A PSMASH will be needed at some point, since, as detailed above, the 4K
   NPT mapping requires the RMP entries for the pages it maps to be
   limited to 4K RMP entries, but...
b) What would happen normally[1] is the guest would issue PVALIDATE to
   *rescind* the validated status of that 4K GPA before issuing the GHCB
   request to convert it to shared. This would cause an
   #NPF(RMP+SIZE_MISMATCH) and handle_rmp_page_fault() would PSMASH the RMP
   entry so the PVALIDATE can succeed.

   So KVM doesn't even really have the option of deferring the PSMASH, it
   happens before the SET_MEMORY_ATTRIBUTES is even issued to zap the 2MB
   NPT mapping and switch the 2M range to 'mixed'. Because of that, we also
   need a hook in the KVM MMU code to clamp the max mapping level based
   on RMP entry size. Currently the kvm_gmem_prepare() in this patch
   doubles for handling that clamping, so we would still need a similar
   hook for that if we move the RMP initialization stuff to allocation
   time.

[1] This handling is recommended for 'well-behaved' guests according to
GHCB, but I don't see it documented as a hard requirement anywhere, so there
is a possibility that that we have to deal with a guest that doesn't do this.
What would happen then is the PVALIDATE wouldn't trigger the #NPF(RMP+SIZEM),
and instead the SET_MEMORY_ATTRIBUTES would zap the 2MB mapping, install
4K entries on next #NPF(NOT_PRESENT), and at *that* point we would get
an #NPF(RMP) without the SIZEM bit set, due to the behavior described in
the beginning of this email.

handle_rmp_page_fault() can do the corresponding PSMASH to deal with that,
but it is a little unfortunate since we can't differentiate that case from a
spurious/unexpected RMP faults, so would need to attempt a PSMASH in all
cases, sometimes failing.

gmem itself could also trigger this case if the lpage_info_slot() tracking
ever became more granular than what the guest was expected (which I don't
think would happen normally, but I may have hit one case where it does, but
haven't had a chance to debug if that's on the lpage_info_slot() side or
something else on the SNP end.

> 
> > So for all intents and purposes it does sort of end up being the case
> > that the mapping size and RMP entry size are sort of intertwined and
> > can't totally be decoupled, and if you don't take that into account
> > when updating the RMP entry, you'll have to do some extra PSMASH's
> > in response to PFERR_GUEST_SIZEM RMP faults later.
> > 
> > > 
> > > That likely means KVM will need an additional hook to clamp the max_level at the
> > > RMP, but that shouldn't be a big deal, e.g. if we convert on allocation, then KVM
> > > should be able to blindly do the conversion because it would be a kernel bug if
> > > the page is already assigned to an ASID in the RMP, i.e. the additional hook
> > > shouldn't incur an extra RMP lookup.
> > 
> > Yah we'd still need a hook in roughly this same place for clamping
> > max_level. Previous versions of SNP hypervisor patches all had a separate
> > hook for handling these cases, but since the work of updating the RMP table
> > prior to mapping isn't too dissimilar from the work of determining max
> > mapping size, I combined both of them into the kvm_x86_gmem_prepare()
> > hook/implementation.
> > 
> > But I don't see any major issue with moving RMPUPDATE handling to an
> > allocation-time hook. As mentioned above we'd get additional
> > PFERR_GUEST_SIZEM faults by not taking MMU mapping level into account, but
> > I previously had it implemented similarly via a hook in kvm_gmem_get_pfn()
> > (because we need the GPA) and didn't notice anything major. But I'm not
> > sure exactly where you're suggesting we do it now, so could use some
> > clarify on that if kvm_gmem_get_pfn() isn't what you had in mind.
> 
> I was thinking kvm_gmem_get_folio().  If userspace doesn't preallocate, then
> kvm_gmem_get_pfn() will still east the cost of the conversion, but it at least
> gives userspace the option and handles the zap case.  Tracking which folios have
> been assigned (HKID or RMP) should be pretty straightforward.

This is a little tricky. kvm_gmem_get_pfn() can handle RMP entry
initialization, no problem, because it has the GPA we are fetching the
PFN for.

But kvm_gmem_get_folio() doesn't. But as long as the preallocation
happens after kvm_gmem_bind() and before kvm_gmem_unbind() we should be
able to use the slot to figure out what GPA a particular FD offset
corresponds to. I'll look into this more.

> 
> I'm not totally opposed to doing more work at map time, e.g. to avoid faults or
> to play nice with PSMASH, but I would rather that not bleed into gmem.   And I
> think/hope if we hook kvm_gmem_get_folio(), then TDX and SNP can use that as a
> common base, i.e. whatever extra shenanigans are needed for SNP can be carried
> in the SNP series.  For me, having such "quirks" in the vendor specific series
> would be quite helpful as I'm having a hell of a time keeping track of all the
> wrinkles of TDX and SNP.

Seems reasonable. I'll work on re-working the hooks using this approach.

Thanks,

Mike
