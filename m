Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6C71631B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 16:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjE3OGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 10:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjE3OGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 10:06:14 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6908BF9;
        Tue, 30 May 2023 07:06:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hutp3ABhhIZv8Ki6TK7faZi6oKQFHQ5gRqlPUQKIDbvy5tO3IHSa9CfFSjPa9JiO9s9MHNVXpFpnYgDgmAU/QEuL4J/L1SYLcWkOFDCbvODAnci86nLUmBkT01IdpjJKZCHkQSSLkUJGrcviftmyvQPUeTw2BK7xlzVSq/JS9WrG4VEfdWg1D7cxtuvp+zYpeBL90xFLWu6ugmkqAEZ5RE3+69HS3K3aiolZ83ioPdYKmQVWqVjXe+mwlTmAo4p7Fmlb0eEGAbzxBfECS2nadh8Mve0FCBn1slcB0fDZ0JyDOFHJi2y6ZEmCEdzwLYVL2VuPgblrddWGuXg/Z86dLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQ3k8czXEQabtSduqTDlQv3V3kXPck7NMZJkhzDt3pk=;
 b=G3gnx0qpRgNjMkfmaBXYH0J4xJqErn3v2dTxHApfWlZRnnutW0sDZRI7IRX2elTQGeK5AW0j7XrHKfMEeJPXw/8R3ulyWWqeWgqFdrq9D0gfJFRhhkvQOyq/WZjkrNSz1/BubfOcvJyaLihCnULAPyMDA8mhks1cKKLZh6ikWwZItTCJdzFOUysb6ohWHinjQeElUCM7aicWa+do2VtHBydJqY0REejm4Xhboslitbg4zHMD0ggVoYhJ76P+jL3klz0EkOTRw6BHecpV4pdMhvCGhvPetwhEiP9LseowIBmqxpUZ5wL9AjrAhtCl+g/UcMhDTHsiOCDTgP2hPHEdaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQ3k8czXEQabtSduqTDlQv3V3kXPck7NMZJkhzDt3pk=;
 b=mdpkSDr63bIehtCJ8MFHd1CCIscF7Ltn9NwaN7qItDX01+XFQpoc/v9U5/6dVwMGh0L2MBf0Z9Cl/oQYcAUyl0zSlTxK4RkKA1FYinFzEJdF87gmnjeQjclGy6dKFvsBD4aMPA0T87t0FGvcOliOi/LTEONCRV2tbTMuYC6c2CYA0R6NtB5p4hNw61Tmz/pPhUX5E4z7vTR5RrYn4Iefoer7LcKoy6YDutS5vwaHN6PAOkL4AmucBDC4CezPdLKdKmrzfu3h7ZffEoQmp6lJTLH5LavfuTi218X3HGgWIy2uxDUpwgYf2dGZjNnin0ZI8ECiAsynyNohsoj50PdaZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB8195.namprd12.prod.outlook.com (2603:10b6:930:77::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 14:06:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Tue, 30 May 2023
 14:06:06 +0000
Date:   Tue, 30 May 2023 11:06:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHYCygONW53/Byp3@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com>
 <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
X-ClientProxiedBy: SJ0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: 99d98ee3-67ac-4da3-5c36-08db61170278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lq0m7aHpjJXxGRwEbIYcm8VOVUZH1doDgfiLsNnuGDSwY+IMA+1HyVCe1dmKy5FPxiSQJcwyDi1XN/g7Qi92drvXE6LInLn2zv6Esb4kCOGiGEPsaRp/8JB5/HZhJMZiFW0nh0TRVPF7x+ayFFbgGKcCxEray98rXTmn+0ZpFcGBtvVrdw8LatjaS7hYiClH8BKfXlrNLeju8V4b7yWEKIcpxBmmiuyQxsG9LX3RPwViV9c5XuMxzG6p6XlljZnd+rlPi4tLtpGevF2XrGux9eiQywB44mhiyT3fbzmquzP2PaBLwYALNNVuL/cMM3xawmx6ymQFQx39EcDC9qWSWmkO+tXCi7rqFaB8S5NXXz1xSVRZ+XfkRy1mGNVaNvJspvFhcaLbmrCWKqHXIMjgkKVV+XhMBUYy6WpvT9OiZNCa0X299Qz2J4I3zw0xci8llZ2bQENu6vc14Wg/4rDPMDkZpMRznyp5f95RTvnhx0SCK9EB3iY/phK4GspQh7EMzadg+SPlexe6dbkudXbIGy2x7nSz8yWyOYurhzZmDoAb3PTTsLYotJ+g4YKh0YtamFfBzMwigD9slqlQZNf925X8n2r0d82KSZ2DU6+LmxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(478600001)(54906003)(8936002)(8676002)(5660300002)(7416002)(86362001)(36756003)(2906002)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(966005)(6506007)(6512007)(53546011)(26005)(6486002)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4IAHWOUSKu3VRrjhSa6pv30rmrR4uNlZE/5KgCDvbj8iAkqIfurI36XcScFL?=
 =?us-ascii?Q?E5+HCRNEhv+G7fVWUCXALdBKhpRBQ4CRDNQa08npKpf4LmV9Z/GkFK0c4gyr?=
 =?us-ascii?Q?/lacyc2VyAgaB+u7z+G7gOznXjDD/6yScuugyVh3xBt5o+dVfGSUcl3VBC9o?=
 =?us-ascii?Q?gkj6rdKZtu+o6qEfxEBa8t4k8KKEhCgruMQf2BF0Ishy+PzyH+fPOM4KrKPf?=
 =?us-ascii?Q?kYjK/NpPqXFQI6t9/BX9FUdWx2v4hjdgvDUIbk3mFhQzupf4nH98qd+KoqK6?=
 =?us-ascii?Q?TKc4U+2Ugrdbg5rszg+PPxmP8UKr7tPhu+HkJ/rCHpjNK2vaZUy0XzuTAMDB?=
 =?us-ascii?Q?XRKUeckWTAhdKdLUzsm2l5/ca6G2IFJCNipBOVsUMNT93D9Z5ALt9p0sqImn?=
 =?us-ascii?Q?A4mWed6Wmh/6Sb9gfrHHDF+gwy+UaeEJ3OkqT6MVxd0xhV+KZnoxyK9aFssU?=
 =?us-ascii?Q?s2+56YtfMUfotMzWTXyHHi7nUosejMfAKF0yhS76SZ7EwxcwM8b6PCbDfpvb?=
 =?us-ascii?Q?fNHlSwJQ5YDqYM+7vijC20MiZDnjCH/QGJzsfa0DDlrmeOeK7Grpn70Zvxnm?=
 =?us-ascii?Q?s3FvSZW91d9V1nR3o1xBScYr47DL1AHw4dvTuMmNM0SOQX7Dpve0owimgvRP?=
 =?us-ascii?Q?xx/3mC9DCfeQSfyHPUTkB52K8suD1QluVDmCoLF+NPIwVTpx+btMNVdPCWRD?=
 =?us-ascii?Q?yyjJW4XCaw9FUw1XlNfCkJGrg0PjEIL1noWHNIgpcodFYu57WKT+kIPmi9xG?=
 =?us-ascii?Q?oALrlpZi0WZTtfStyLbc7JSGaRgt4RTqM+UGiEyJZa4jyO/5IDnPqm/7rPwm?=
 =?us-ascii?Q?1PGIxhewRpVJ4w/ICbnaCfahEdXVmElkgsg8mAn2mNuB+HLcO3i25TOKHEHP?=
 =?us-ascii?Q?1ao9sTxjMWjD4TlNWsKithqhRXDISBB+zFlcmEw6OOv2+0nY7N4n8bwZaYXj?=
 =?us-ascii?Q?6SXOnlCW9GpF7vqtZlL7JaBt/B7zrD0rgHsk4eidIhImCq1SSo272/k89D6K?=
 =?us-ascii?Q?QX6ijs64vL8kMHJetrPyzcIId01k29/SvlUbhs0AK4gEk7ifgPTkD4bx7wXf?=
 =?us-ascii?Q?ekgE7HKw/PsaAMDNJMJGbN9RKHjR4L6/itG1BlJiSw3hZbDZCHuVsd/lXF/2?=
 =?us-ascii?Q?s1p7YB37ohstOrCZkguRvLW4vxYnrHtN3bK/45C+CU+Zcs5qObthIUBnIe66?=
 =?us-ascii?Q?uGeWbTvhtzu/deJ2v4tnG+GXo3hUxtY9MIq8wsxPBsJ4nHODBCvC2yK1l77R?=
 =?us-ascii?Q?o3DxPUVScTNeK7+ZynelQr7jIcZZacHqVCGb7Zssz/oTGY1OybQSChra3+ok?=
 =?us-ascii?Q?VEHUTHHg7UqQsy+JpymICTesjLqLJw6SjqROYQLAAbbcje5FsTfoSPzogWT9?=
 =?us-ascii?Q?CgFf9EJhqLTkApfQOOO3KAno72XNy5HB2gTyuROnFU8GjO9b5bpX1CgYDBVI?=
 =?us-ascii?Q?m4gkHSv1jkBaJV6+h5rAdJrUblW+ZCeVUd+bDE8xU9BfCunKfv+sf7+lq2Bt?=
 =?us-ascii?Q?8Cz6AGPWdvLCAxr1HgRD9gpYSgf7SoflDtFy1RwPzKh3yOLs7C7qQ8Lj7bt/?=
 =?us-ascii?Q?cz+z70qMwvUgi+7r8dG64Kbby1MweEKdc1ZU8ngT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d98ee3-67ac-4da3-5c36-08db61170278
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 14:06:05.8742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFfCoiFCRRYMtB+cdOQSwT2B9YWQCU/VjUGmGFs8BO3xnENLYCxyoTLZ/NO+JubR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8195
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 02:44:11PM +0100, Robin Murphy wrote:
> On 30/05/2023 1:52 pm, Jason Gunthorpe wrote:
> > On Tue, May 30, 2023 at 01:14:41PM +0100, Robin Murphy wrote:
> > > On 2023-05-30 12:54, Jason Gunthorpe wrote:
> > > > On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
> > > > > 
> > > > > > > As no notification is sent and the SMMU does not snoop TLB invalidates
> > > > > > > it will continue to return read-only entries to a device even though
> > > > > > > the CPU page table contains a writable entry. This leads to a
> > > > > > > continually faulting device and no way of handling the fault.
> > > > > > 
> > > > > > Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
> > > > > > just have the iommu driver push an iotlb invalidation command before
> > > > > > it acks it? PRI is already really slow so I'm not sure a pipelined
> > > > > > invalidation is going to be a problem? Does the SMMU architecture
> > > > > > permit negative caching which would suggest we need it anyhow?
> > > > > 
> > > > > Yes, SMMU architecture (which matches the ARM architecture in regards to
> > > > > TLB maintenance requirements) permits negative caching of some mapping
> > > > > attributes including the read-only attribute. Hence without the flushing
> > > > > we fault continuously.
> > > > 
> > > > Sounds like a straight up SMMU bug, invalidate the cache after
> > > > resolving the PRI event.
> > > 
> > > No, if the IOPF handler calls back into the mm layer to resolve the fault,
> > > and the mm layer issues an invalidation in the process of that which isn't
> > > propagated back to the SMMU (as it would be if BTM were in use), logically
> > > that's the mm layer's failing. The SMMU driver shouldn't have to issue extra
> > > mostly-redundant invalidations just because different CPU architectures have
> > > different idiosyncracies around caching of permissions.
> > 
> > The mm has a definition for invalidate_range that does not include all
> > the invalidation points SMMU needs. This is difficult to sort out
> > because this is general purpose cross arch stuff.
> > 
> > You are right that this is worth optimizing, but right now we have a
> > -rc bug that needs fixing and adding and extra SMMU invalidation is a
> > straightforward -rc friendly way to address it.
> 
> Sure; to clarify, I'm not against the overall idea of putting a hack in the
> SMMU driver with a big comment that it is a hack to work around missing
> notifications under SVA, but it would not constitute an "SMMU bug" to not do
> that. SMMU is just another VMSAv8-compatible MMU - if, say, KVM or some
> other arm64 hypervisor driver wanted to do something funky with notifiers to
> shadow stage 1 permissions for some reason, it would presumably be equally
> affected.

Okay, Alistair can you make this?

> FWIW, the VT-d spec seems to suggest that invalidation on RO->RW is only
> optional if the requester supports recoverable page faults, so although
> there's no use-case for non-PRI-based SVA at the moment, there is some
> potential argument that the notifier issue generalises even to x86.

IMHO I think we messed this up at some point..

Joerg added invalidate_range just for the iommu to use, so having it
be arch specific could make some sense.

However, KVM later co-opted it to do this:

commit e649b3f0188f8fd34dd0dde8d43fd3312b902fb2
Author: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Date:   Sat Jun 6 13:26:27 2020 +0900

    KVM: x86: Fix APIC page invalidation race
    
    Commit b1394e745b94 ("KVM: x86: fix APIC page invalidation") tried
    to fix inappropriate APIC page invalidation by re-introducing arch
    specific kvm_arch_mmu_notifier_invalidate_range() and calling it from
    kvm_mmu_notifier_invalidate_range_start. However, the patch left a
    possible race where the VMCS APIC address cache is updated *before*
    it is unmapped:
    
      (Invalidator) kvm_mmu_notifier_invalidate_range_start()
      (Invalidator) kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD)
      (KVM VCPU) vcpu_enter_guest()
      (KVM VCPU) kvm_vcpu_reload_apic_access_page()
      (Invalidator) actually unmap page
    
    Because of the above race, there can be a mismatch between the
    host physical address stored in the APIC_ACCESS_PAGE VMCS field and
    the host physical address stored in the EPT entry for the APIC GPA
    (0xfee0000).  When this happens, the processor will not trap APIC
    accesses, and will instead show the raw contents of the APIC-access page.
    Because Windows OS periodically checks for unexpected modifications to
    the LAPIC register, this will show up as a BSOD crash with BugCheck
    CRITICAL_STRUCTURE_CORRUPTION (109) we are currently seeing in
    https://bugzilla.redhat.com/show_bug.cgi?id=1751017.
    
    The root cause of the issue is that kvm_arch_mmu_notifier_invalidate_range()
    cannot guarantee that no additional references are taken to the pages in
    the range before kvm_mmu_notifier_invalidate_range_end().  Fortunately,
    this case is supported by the MMU notifier API, as documented in
    include/linux/mmu_notifier.h:
    
             * If the subsystem
             * can't guarantee that no additional references are taken to
             * the pages in the range, it has to implement the
             * invalidate_range() notifier to remove any references taken
             * after invalidate_range_start().
    
    The fix therefore is to reload the APIC-access page field in the VMCS
    from kvm_mmu_notifier_invalidate_range() instead of ..._range_start().

Which I think is a hacky fix.

KVM already has locking for invalidate_start/end - it has to check
mmu_notifier_retry_cache() with the sequence numbers/etc around when
it does does hva_to_pfn()

The bug is that the kvm_vcpu_reload_apic_access_page() path is
ignoring this locking so it ignores in-progress range
invalidations. It should spin until the invalidation clears like other
places in KVM.

The comment is kind of misleading because drivers shouldn't be abusing
the iommu centric invalidate_range() thing to fix missing locking in
start/end users. :\

So if KVM could be fixed up we could make invalidate_range defined to
be an arch specific callback to synchronize the iommu TLB.

Sean?

Jason
