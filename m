Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6488072FEEE
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244688AbjFNMoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244680AbjFNMoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:44:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD6910EC;
        Wed, 14 Jun 2023 05:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhyojVhUARUa/goviwgizzWrE/pgLO44w0IhMnigi2UHDY7oHJssxjnVHM19owJ7Ig4u3bV2AeTyG+TkQvd9iX4Tiaw+7E+HewflBowcxaqquWnBBHI3yd6Kl+KpUAVeQ4MKUq7yN/96axrsq8JJkF7a5yfw8WmXkNL2tdNDV8vWDXnuVOGte7B3PGTljEdBR7LnYF/AsFBFnDLmZ6SrpOz8aU2FEP1LGPdOc7Nger19e08L1PjKVYk7OzZnos0scJKUXZu539c5+4iKkl4yzXRmfjF2T9ob9GP9QVZJDbF2qcj4lta2d+488Ni/YNf6Rbgw4xNsOeX6i5KF40wUZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3PnbknJtw/ndRg7kLj1sMU6x5ZPDjHdexpFwdcwl2Q=;
 b=DgSD07iNBHbCe89z05HjZ9+6eC1L56u8CqtCFYJeYUFEPsQRysIEwULEMi7LhA7nXQn7poaBN6LHo+k4epqe3NA+/23dfEqvqlFqpbwuLrAF/wjh61roIZXcNI16ElLd5r5Z0JTo+bi2d/dqDTF6qCnwYvqtN4CiSK3Qi8IYvUIltbUGbXKIpClvioi6Q2apWfaVbww7IzKkkwJIEI3de1Yu4R6CLDL7YFpNyEsdO7YAq+Fsg7P6w3bmX78M+nmCKy1zGuhDSEye2uqcYnbYBOLxipMEdTNr9dSFBcT9HCJhOOGuC2nXjTcKWR9RS4UY1He4PMz0Bp5S6hVhdnsALw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3PnbknJtw/ndRg7kLj1sMU6x5ZPDjHdexpFwdcwl2Q=;
 b=PWFw/ZtFNtUOeb85ggHvJRIHEpCqV76HCs0yMlNCGWiAKzWKip7F9yWlIolMgckrwfd3wxGMy/o0+qQKiVnx/04huY47VBQjTfFnZfBv91w2U9MYaGktz0UkzLdmtxWKL6RqrTz4J1RzK/5s6KZZFD4qNKivTqAwcd8G6K7Pw+Hx6SxuxIV9EKx5AKntijhHmohPx0wQzrrOg7CDZgL4Se3lT8GiyQcLJOgjEKP8mvINgbKiwRrpjeImDuLPM0GdHW104zMG1kBjteXRz20ZOh1AxUijA+x35PLPEWyt9cPKucY56yiXdpvXpINgIW9GplEHtNUusvn14wTLHw81XA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 12:44:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 12:44:09 +0000
Date:   Wed, 14 Jun 2023 09:44:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        alex.williamson@redhat.com, naoya.horiguchi@nec.com,
        oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <ZIm2FnH6EQfA4Qr+@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-2-ankita@nvidia.com>
 <86r0spl18x.wl-maz@kernel.org>
 <ZDarrZmLWlA+BHQG@nvidia.com>
 <ZHcxHbCb439I1Uk2@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHcxHbCb439I1Uk2@arm.com>
X-ClientProxiedBy: BY5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c98d499-43ab-4fa6-c0f5-08db6cd50c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fCD9l5UzjhzaiR8UB1RL+pWUPTfTVgo52FhxrN5suHXs9X6E+HpcqLUgw03TdgOWLhmuGTkSpWNQ26rG2RZwVKl5ltg+99gaGvmnD7oa44kB/SFMJ4YIELcNLxBqDnam2C1vjHwP4nZ9Ad60egxu/1iYkxbZJVl7N4BxVf01jNrFOWnYrGbRFkOi7v/n0/wPRwYFTMMkiwLavjkgM0/jHSrITFXOl7gUXfMJJZJvIvsaRMiB08hX1s1Jid9l13+fGvb4WKXW32j8MAbp8Fcp6W2xleHik78TR2UWbLDsNIKZBZWfXJUpQV0Ad4WCLwCMxar/lkyYER0aPHkqGVd7uAd97zmZW/b40TyUbPTAdl7QnTsG6+obfkc6S5e8V+OVgkENNJrR5jTnjRmbZtBEm0FLiZsR9QhVTw2sDqbW1STTYbk51Sxuk7cgN8fl1ZQbP2kY3eD2VanxbSnVrnRPoQOjanS/YdVawkYxa8lUNcR9c2oPF/PWTz5a6vIziwyO/VjP3Rj3/Q9TDr3vGcjstPTTX9eSGdt3uaqHJwIrhYaEEmj4vrIRmr0VKypAiyts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(83380400001)(5660300002)(186003)(6506007)(66899021)(2906002)(2616005)(7416002)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(54906003)(6666004)(36756003)(478600001)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oSG78m/2I4FifF/h40HJudqCWjPHuo3efpMzvwhIjPPlwmwKpMVW5Vukho4w?=
 =?us-ascii?Q?27Wi14ktRLGn19IHQAPvdyLCoytVfj5O0h7/X8hKv51HaXLhOHv9IaOG7WDY?=
 =?us-ascii?Q?et+pQMH7XXTyyxfRcPhY3e2RNtG8KgeeOb9QcHIO61nUYfVp8k6GoTOELC9s?=
 =?us-ascii?Q?75srfgLd857qT5oaQcCV5N20TyTigH/UM4FiD2WK8SVdy6/TrDMM7PlQtB/j?=
 =?us-ascii?Q?SXbAP86/SzgWozVNdJaN1oNoR2eenDol/PoofdLKwyzj6gvu0dMz8E+Ems65?=
 =?us-ascii?Q?lXhK5sPTUJ+O4gJb4ApKN+Tw+Lkt9q4E4DPOkGqAuwGJQnbcPxeLjY2BJFm+?=
 =?us-ascii?Q?dy3Yi++nl1GDcYby1l6jrUQmempRTXb0buyow+rNNKKhvXPeuTDCcqSAYx0q?=
 =?us-ascii?Q?57xEQ+l68FbgV5DWQD8eqm5SK/PfAKVFn2YBrnSFQ+ygu24ej1etpiusOX9k?=
 =?us-ascii?Q?K5erPddilsmGt0WbjHl8vaEwOnYPAuetwliEtBAu2B7S97ncHOKfTGQUdb0G?=
 =?us-ascii?Q?u9o+SajID99T2leDarqldD6SZs9YwRbsXxYiWDICEPW/jYjdlKlvZl3o6LWz?=
 =?us-ascii?Q?6zsftL5iiBquhs8S8EKxp/MmJx8vc/Eps1YIHnUW1DN/Vox9H8jG1uqScXlv?=
 =?us-ascii?Q?Wm5tYsVukpmlo+ix67CGBlVbxRGU/EItDPK8gCgW8k4a9b+auC6L0eKZ9ser?=
 =?us-ascii?Q?iIC1OiIpm5ILC6j7KLi6VXstrTzeNmDeuPL0gjwOnq+6m4MlxCarE1RbWV6h?=
 =?us-ascii?Q?xlPxBsrcJYdIb0CU1Wo3fjSuBIBEt4VSEvfdvCAYb1AATXXZB17uPAyfImAk?=
 =?us-ascii?Q?aUkB/WKoL3OkjhKF5U6jYEwYCBpfo9tllZWO/8M28laocaxYj80aKQ4th9Ot?=
 =?us-ascii?Q?J183RWS8OdMN2Zwv2zFhEXnNMYFKFT/v4jCKszgtqYRfGKrqfMogjreqdz/t?=
 =?us-ascii?Q?r7J+XrgZaZnb/oJl3GjtL6V6mK0dHm3EWInZYKbhQ5Blzj9NCfo8Ut7X4Wl2?=
 =?us-ascii?Q?M16mAdAnuARGuI2LjsXv+olSypwpRmiJZRqqje7x20E+jgH4JwuMC3R32upl?=
 =?us-ascii?Q?+n+01i81FbE9Pw7VEw/UsjBZoydYpFNM/nEBmT9Ap8NRtbutds4QSjqeSdi4?=
 =?us-ascii?Q?lRY77vkUt5ft2zZQUK7jj98gRkqe4XFB87MjdHZaFROkk/Wl1lfoW5SU0GiY?=
 =?us-ascii?Q?VdqeIbMbuu2blwvthWha4o+atvqKT3sVTd1C2072nnkX7rX1K69jLcDk9Dlb?=
 =?us-ascii?Q?94TxPCcQ/Vs/WahKC1zz3Zv5w7iLFjCCtfx7QilWOqTXBq+GxC37qeQTzFvP?=
 =?us-ascii?Q?+8Nf5wWW8iVkdT3ftBgfekOLqvmRErnSjKNzxH7S0yibXLRZhV/4Avajrs66?=
 =?us-ascii?Q?TedJn4ergoe4yu8AVlJo/yRzc0g3BnqS/pNevJi2rH/ac/l9yHpgipBGU5cP?=
 =?us-ascii?Q?x9tjKAfTq7gscZW4vyQVZN6WmwoU5B8i0jocbQqDXhn8oR3gircJELif8CGU?=
 =?us-ascii?Q?Gbp4l8iOGbxM/8Zl4lgXtm4p3ieLzaT5GveGf1OC8eGCvmJMHgZaG7kg07NQ?=
 =?us-ascii?Q?zD3cQbJOPKSa9IegALhKQqIYCsAmc/SkClrxP7oH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c98d499-43ab-4fa6-c0f5-08db6cd50c0e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:44:09.0957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXwbYxFO6Kcnyu5iT6bAicERBBjGQ3D+gh5eJ9l+dpqEk/NIs6Zzxrj/viq1ckoT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 12:35:57PM +0100, Catalin Marinas wrote:

> Current status on arm64: vfio-pci user mapping (Qemu) of PCIe BARs is
> Device_nGnRnE. KVM also maps it at Stage 2 with the same attributes. The
> user mapping is fine since the VMM may not have detailed knowledge about
> how to safely map the BAR. KVM doesn't have such detailed knowledge
> either in the device pass-through case but for safety reasons it follows
> the same attributes as the user mapping.

To put a fine point on this - it means the KVM VM does not emulate the
same behaviors as a bare metal ARM system and this results in
significant performance degradation (loss of WC) or malfunction (loss
of cachable) when working with some VFIO device scenarios.

> architecture). Presumably cloud vendors allowing device pass-through
> already know their system well enough, no need for further policing in
> KVM (which it can't do properly anyway).

This also matches x86 pretty well. There is alot of platform and BIOS
magic at work to make sure that VFIO is safe in general. As this is
not discoverable by the OS we have no choice in the kernel but to
assume the operator knows what they are doing.

> While I think it's less likely for the VMM to access the same BAR that
> was mapped into the guest, if we want to be on the safe side from an ABI
> perspective (the returned mmap() now has different memory guarantees),
> we could make this an opt-in. That's pretty much the VMM stating that it
> is ok with losing some of the Device guarantees for the vfio-pci
> mapping. 

I don't know of any use case where this matters. The VMM is already
basically not allowed to touch the MMIO spaces for security
reasons. The only reason it is mmap'd into the VMM at all is because
this is the only way to get it into KVM.

So an opt-in seems like overkill to me.

> Going back to this series, allowing Cacheable mapping in KVM has similar
> implications as above. (2) and (3) would be assumed safe by the platform
> vendors. Regarding (1), to avoid confusion, I would only allow it if FWB
> (force write-back) is present so that KVM can enforce a cacheable
> mapping at Stage 2 if the vfio variant driver also maps it as cacheable
> in user space.

Yes, currently if FWB is not available this patch makes KVM crash :\
FWB needs to be enforced as well in this patch.

> There were some other thoughts on only allowing different attributes in
> KVM if the user counterpart does not have any mapping (e.g. fd-based
> KVM memory slots). However, this won't work well with CXL-attached
> memory for example where the VMM may want access to it (e.g. virtio). So
> I wouldn't spend more thoughts on this.

CXL is a different beast - struct page backed CXL memory should be
force-cachable everywhere just like normal system memory (it is normal
system memory). This is the kind of memory that might be mixed with
virtio.

However, some future CXL VFIO device memory should ideally allow the
VM full flexibility to use cachable or not to properly emulate
bare-metal. This approach where we pre-select some of the CXL memory
as cachable is kind of a half job..

I think providing a way for KVM to take in a FD instead of a VMA for
mapping memory could be interesting in general. We waste a fair amount
of PTEs creating a 40GB linear map in the CPU just for KVM. Avoiding
the alias mapping is a nice side effect.

We'd have to do something else for the SIGBUS stuff though..

> a) Relax the KVM Stage 2 mapping for vfio-pci to Normal NC
>    (pgprot_writecombine). TBD whether we need a VMM opt-in is at the

We are working on a tested patch for this, it isn't working yet for
some reason, still debugging.

> b) Map the KVM stage 2 mapping as cacheable+FWB iff the VMM has a
>    corresponding cacheable mapping.

That is this patch, with some improvements to check FWB/etc.

Thanks,
Jason
