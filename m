Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FFA7A4BB6
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbjIRPVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjIRPVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:21:18 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57484CD5;
        Mon, 18 Sep 2023 08:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coV11WyES7OsY8ZXcsO5ZzBGNrIWbl6bFnx/I1nokXVpNKhpJ9kaFn0BHFhBzpj6ngzWBjbDuDVrWday7zjfcmKCblgq3RsYdBvgef3vEhU864BvUbKv/cWalM8HQKZYHx5g7PAMZuqnrQR833HDJETISScAEROfcIi8SquxVvx3kNMlNybkZ5WfOPbgtEWPb8FojgA/qFKgv88KQSaM/2Af0kLutyEUlKGuodAUVXq7ZI8JMyuyw9raqdJltfCfay7oUdSyH+VSaKN0xvAxRAnxKiR0gSrizNY8TNy/jRRthMz4zt7T4xqtuoTWZcmPAhkRDDBIwtlYDKV9UoZ+RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zx5uPsFKEQhOAtQGG5/9UiJPBFjc4uh7M8xzHF5h8K8=;
 b=IdRTed6zkBHrlCHhpVVfOS9AVlaCRg3otENKDLzk+6oVv+UQhmNGkzA/3DH3dCihzaS3EeZSnLlhoZJy0NzkXRKXqoA16ndIktmDQdWm3lSCJBTWh7F64ogJgaxN+QhlZs67cXmQgV0pp/+JP9SgYM579RSE2LE03TLBKl5Rei8bm0pbedZBsIo9IHu4U4smeuOx3wlS9xfJssi3BfyBfbHBUj50OI87i/4yruYzGdVsNH864eD8DboRl9B8dFPoC7lS2RC4JPj48OecFN8Bq+b5Dg0P6wch+cfKKOi36vvq5t2p60FtBjDoDd6FrQ7Ra3szW0aaPIahb2SRD9qi+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zx5uPsFKEQhOAtQGG5/9UiJPBFjc4uh7M8xzHF5h8K8=;
 b=QTyBfQ3Ul3R6h1RZFE1fb/yrKPnchBRqohipmSZOIrDhg6jEqe0Donzo463MVH99fwbsvBPsmANfmNXI68dnRvNx+qXg4CjcFF5HdLeq4vakmfHig+spxZscGIepzodmFXDZyxUXDDqPhRSAwuZ3rXEvUS0R+zrPOpPpazkLYKxFnWZyxAthyaNH3/MG+COLeLLvQiZfJ8u7xth+JhY6iTVpXLT9KX8P4KvAkw2c03wdGFZ+QF3Eq6NHzcxWsZAp9moy7fQfHROeJUoV2nhaSnJi58Xoj3G+o1GHRIJjwFGnxeXwOzRseNA9hahrdZ+D8jLdJXf9AB8tS96WoMIa1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7604.namprd12.prod.outlook.com (2603:10b6:208:438::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Mon, 18 Sep
 2023 13:02:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 13:02:57 +0000
Date:   Mon, 18 Sep 2023 10:02:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230918130256.GE13733@nvidia.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
 <20230915082430.11096aa3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915082430.11096aa3.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:208:236::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7604:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b0e115-9019-4a2b-8250-08dbb847940a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WPUQQWxob5TpOEQE0tnWNG7iFpRQaIjuYtqf9afsvzyZ/lrZCG+Rqn2KiZlc0L+zmmPi01K3WsNb1uiU3HhxcIJXoCopMK8F3ls8MHGANHFnmE+Gau/PDihnQpet4I5CgH0qbEvv4lTL3Ajxm+8oKM7ptUYivavaHk4Iq6pBCnH5/IEiMOv3zT4kuaTJ/oRJExOoGdUL6ZvjzkeRRHCB1YltSgsqctZMG/ILNd/mpIzpJqbt2s9oXhJj6G7M+qVvgpTbCXrkaa979fMpBX05B+6/F+RSpbLtT2onXHO6mCQsCWq7pBVLpTTaEXVp14IoeeFiXrYPw/kayN9FgPleUBQpEmUbY95kM5V216x6Sni/kqkjToki7IcpCBPgWV1U/Y54UejiR02spS55KYJSG0MFLHeX2cUyu614Oj/Dcf9YBLqVl9P05IxkL5RytKN71QlJw/r60DIzhL2OaXow9gGR/9N2xThw0lBaqt8uBhCS16LMKAmImodS7XkrhOCehUkFi9kKJaCnYa9v5GPPkloFVnfLLdBBXIg8odP0OHF5b3YxzE9153kA8u3gLXC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199024)(186009)(1800799009)(6506007)(6486002)(6512007)(478600001)(83380400001)(26005)(2616005)(1076003)(2906002)(4326008)(66946007)(66556008)(66476007)(316002)(6916009)(8676002)(5660300002)(8936002)(41300700001)(36756003)(86362001)(33656002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oFl+ErWOWJSF/nm+C06pF5kZsIsnmlYMxvuqOFkRGyJElFNjP2D1gIEblDjZ?=
 =?us-ascii?Q?aDqFBq/8sh90Xo5DDPqLKcZV0xiIfuQ4AgialVUQgu7RT7l3zs97oWr/vL2/?=
 =?us-ascii?Q?uhg1VATcNp29S0fAkyua+e1ooY2beCcg/d+X4EzWZtnX+7YEPsSJdqT7oA0V?=
 =?us-ascii?Q?66dJm77YwnByupvPVhbK1Or2mateGKLIXpJYdeuiIWzbPEOpkFSdCqB+JLVv?=
 =?us-ascii?Q?MG7GwKL8qzYAqvLaLMr3d3HC/u8Fs0a9Bp3khSV1JGGonu1rO7wXWY9KDLa5?=
 =?us-ascii?Q?IpeMj0nYDhH3/RP1HIgC4HZ+1jrakey4Ya/WDxCp6ch4G8PUi5JW1pXyQL3L?=
 =?us-ascii?Q?xq65SkbVw0HPX1lf5FDxNeerPwarjEuUzdvTr+oVRjpuaFjQArUK/nzikpjc?=
 =?us-ascii?Q?bOZeLA2N2Tr/wk0Vuf6DkvfmCSHB3hGxGTgToi+HiICIvBz0VzdiE2UmFyCX?=
 =?us-ascii?Q?6Xe0EP7Y/8fgLn+yukd8DwVMmlJblBWxZySFI+KbqhkNWTUqRt8/wjvrMFtX?=
 =?us-ascii?Q?Tw59C6T1NZgkbbjAIONFsobK6TILuTReUgFnrwzTESCsWkUJx19xiyG6ZV88?=
 =?us-ascii?Q?bqaS2AShqgWhW9Fev3STD0BdsV3lmnOCm73mufHJSYY4QDItrxiVQWGYsZ+i?=
 =?us-ascii?Q?SDmWyOaHHqIma2mX4fsMWB2wEAonUT9ofjY3gP24plr+ddEMX4PkpF2ubCIl?=
 =?us-ascii?Q?ombBLwR+VZcmgkNuUunghUA7F5cBBXNQAWCvaxGfTwusKLqZVsRkMBWM8GU+?=
 =?us-ascii?Q?mZxN9H6txsSqe84FTxCedjvVARY7OaDzBxKAxzYOUvZUBdWUtrfc4jhl2f3P?=
 =?us-ascii?Q?jgfXKOHW8tVI2VAUTcPDWuBiekOwyP/jMIAkdzGVBDr+xJ5K6i+UdlrbQWWF?=
 =?us-ascii?Q?1NuCUvE2Z1z2OVuYjq0ddF3hYMa9UefAHc9RIzWJJt4y+9WIWOpGrfO9UBiZ?=
 =?us-ascii?Q?sWyJS27Ru8Sqb21NmiqZj6yvRW7p0wzNS2NSVFyiDOBGT4BH8tcjtauCdgsn?=
 =?us-ascii?Q?p1tLv6EuFFj/Vusjjc56RZHUHGb6zvnHR2V4jCv4+IjYwafacbkhKjGbT6st?=
 =?us-ascii?Q?U167ctBBrN2j6LRisMCQFmpGB2ZFpRW8fscbRLRTk9wx8OVQk+yz2OncK3cd?=
 =?us-ascii?Q?AtpPq3j7l99cmloEQ8aoqZFJVZhxuvDfPdgmP+rSrnaMyYfRiRhHHlUo7rCE?=
 =?us-ascii?Q?ikIVE/r/AfNqTNuSSTcQDeBrfUqLmzngmOUMn8TCujMZvqn86VNYxvpJeRkW?=
 =?us-ascii?Q?tlpLZ4+zkgxsAKltdJYQ6LcHpCJWN2FvxmcrK+ElwETQrqSd0t87EvMrMdQh?=
 =?us-ascii?Q?HjUnjlrMCjjLccalRCgdI6xmnQNhn3mtFFlSqaoQr9Ed0FYtf+miZGo+8IQS?=
 =?us-ascii?Q?ODMC/T4w69tSGn0eBzbfTPHCWKDr9PaDEpOVjHYkFjCUrQZ/AZMTFqeknTzE?=
 =?us-ascii?Q?dtoFVJ8q9Sy4Dwb3abs7J4ndQibw9Lcor6iJ2tOwVtt+wifk99N0hp/e2HFW?=
 =?us-ascii?Q?67WN2Cb1LQPDtRdkKtrwwdBFwK/0oPAilYku3laX7emSpTJHh/VcjMMWeCXS?=
 =?us-ascii?Q?OjmvQBZl2F76OxAZlyU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b0e115-9019-4a2b-8250-08dbb847940a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 13:02:57.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8b8khOcunp91Up2GrqMwUdu2CSHili1w6nfQjsEiAMlfpuaKr9SSrARynDOs0SIX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7604
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 08:24:30AM -0600, Alex Williamson wrote:
> On Thu, 14 Sep 2023 19:54:15 -0700
> <ankita@nvidia.com> wrote:
> 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > for the on-chip GPU that is the logical OS representation of the
> > internal proprietary cache coherent interconnect.
> > 
> > This representation has a number of limitations compared to a real PCI
> > device, in particular, it does not model the coherent GPU memory
> > aperture as a PCI config space BAR, and PCI doesn't know anything
> > about cacheable memory types.
> > 
> > Provide a VFIO PCI variant driver that adapts the unique PCI
> > representation into a more standard PCI representation facing
> > userspace. The GPU memory aperture is obtained from ACPI using
> > device_property_read_u64(), according to the FW specification,
> > and exported to userspace as a separate VFIO_REGION. Since the device
> > implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
> > to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> > PCI device in the VM with two 64-bit BARs (where the cacheable aperture
> > reported in BAR2).
> > 
> > Since this memory region is actually cache coherent with the CPU, the
> > VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> > mapping is done using remap_pfn_range().
> > 
> > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > device may not. A read or write access to the physical address from the
> > last device PFN up to the next power-of-2 aligned physical address
> > results in reading ~0 and dropped writes.
> > 
> > Lastly the presence of CPU cache coherent device memory is exposed
> > through sysfs for use by user space.
> 
> This looks like a giant red flag that this approach of masquerading the
> coherent memory as a PCI BAR is the wrong way to go.  If the VMM needs
> to know about this coherent memory, it needs to get that information
> in-band. 

The VMM part doesn't need this flag, nor does the VM. The
orchestration needs to know when to setup the pxm stuff.

I think we should drop the sysfs for now until the qemu thread about
the pxm stuff settles into an idea.

When the qemu API is clear we can have a discussion on what component
should detect this driver and setup the pxm things, then answer the
how should the detection work from the kernel side.

> be reaching out to arbitrary sysfs attributes.  Minimally this
> information should be provided via a capability on the region info
> chain, 

That definitely isn't suitable, eg libvirt won't have access to inband
information if it turns out libvirt is supposed to setup the pxm qemu
arguments?

> A "coherent_mem" attribute on the device provides a very weak
> association to the memory region it's trying to describe.

That's because it's use has nothing to do with the memory region :)

Jason
