Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDB14837C0
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiACTxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 14:53:23 -0500
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:45921
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234094AbiACTxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 14:53:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJDxp0KibcxcUvk+s0Zsi/jIDdOu+djsKlB4+7nASXXHhH6u30xce7VrRQEfdKHQFPd/gZVpV56r47IsX3OYXxe2Wru3s/UTkCRlQYjVII5HIpMgwVJkUHiOjT3n3547eHrgdcH2zNR7PAPMp3UMQhSouGUH0MNxflP85wlZWYGIpIl22SOTeBD7lMCf+nPlSoYMMlSpoKJeU9ACseo/m4+Wf3KhgRR37kiTMhz6J7UntytGUoJ7/bm9ddi944ovsQ5JKcumcKbUOBYQkOd5DNGjicVYVkbKy+UevEccmuMgqXMGYdgv41iuUTY7QDKaNOwjqHUfBqDp3izMKYcTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfYO1RBwOPZGo9t/zw7xA88KgOCvY6LOcQwIEPS0Inw=;
 b=D/XnHl+zih2rpQ12+jg2kiYPKiVkV30pLoy4e555S5V9z3EXCWvybcmMAuAGZ5LXpcp8/mwCEBUzPM74wDmBZzCTPTCBziPyiIJlV6M4h3/KgCJ75AjrvCh7rkUW3bhBLZxe72zBUmmcWJyx8yqN2ZZYpWNgnTeMrMIfXe3Gl0mt7gyk3wR/lVeiBCwepMX/ebqYwV+FAQAP2B96UdU5eTnpkgw3nG9wqTNayj/AzsRacXjzSu1PwYh2HQO0pm7PLT+MtAJSA0ZU+7Zf3eRRZSAEZ8l31m4Bw22lPb9Ph0rpQXLryDPKgoSUdnOgrC2tdjdqIiihPW4FKKQAap11Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfYO1RBwOPZGo9t/zw7xA88KgOCvY6LOcQwIEPS0Inw=;
 b=BQHke1Sr/af38lRVllBUY6pImvGrBzOTQzg9Fub0XGQYUVX4gLuDJKduxJgK7qGbTue5XvbcVTZr2hmydfVnIx0pbcCtQABKD3zzg1OD/cHZoKu3YFs5zzxKk3ow21cjNkSo1IUy2SqWQz/FqU3CGdtOfHP2NUV9rlT4gUS3OI47EuN57g91dFH8/n1myqalCQy1whCvf615b9qPVGThE+3Hlc7In6KDq7lzA/dYoZu0B0+4sfTi01HJhI8/LdsczDX5Xj4PrH+5y20WJx+Ql9MKmTfSpLqnLHQUgXbJSZJXtuFQhoLk3WtNIZrcDwBCGD+645QHyGfxZaBAu1WIXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 19:53:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 19:53:19 +0000
Date:   Mon, 3 Jan 2022 15:53:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20220103195318.GA2328285@nvidia.com>
References: <568b6d1d-69df-98ad-a864-dd031bedd081@linux.intel.com>
 <20211230222414.GA1805873@bhelgaas>
 <20211231004019.GH1779224@nvidia.com>
 <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb8650c-432f-bf06-c63d-6320199ef894@linux.intel.com>
X-ClientProxiedBy: MN2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:208:120::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa1208b8-6869-4f90-43e2-08d9cef2b0cc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5333:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5333C79E437BEB40A26D8925C2499@BL1PR12MB5333.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3eeCkkFVJKtgJ0p9yQrazSMDb0r+va2ICVIQmELA6fnl5SYzbTBBdulWEiu3aak7MKJCmfo2fZewIavlaY1S0epNvhb0ASWmjdgqhaQl/MKFvmKr2tEvscbr1Saf+ACZizXvuDlAfiWq1cktWOxt4wKFRUsFPk6eMtjJYsfwAh9d+LcDBd+qaccdTgeaj0ZaxnsKrmwA8oS1xddEvkyoUe+WjGGc0cryQoP1dYp7mpjw2WwSaYs2Y5pXzHoMMeYZFMbMwJ85ZnLcUDYke6iplTo6gi+uxK34yLt7oy+19exoHp9GwCsfSCdcWtqCxmQCsALPCuoCbXfiq6+2CnOf7Zszuv+whzls4H2B5rLWr+7PV6a0SRXXPIFCXHu4RmKOgmdQBUjmJoUgVjdEHnI9rx+ztrDRFevW/npQEhsD8sCOlrwOii63QIUuZvVnPHJIW/mcX7KmQVnFcKhx6WMjn6sYhduVZRysXTYRX7Pv//Qv/4HS0AbAH1p7hRsPSYoDila97mT+sUenIGjwTRt1QDG6sTIHdcVFvnOhxMWGqrhebm8sfJyHkqZUHUV+O+nz+poiDzK1VkjuImJShkUxQ0KLPwXVwUuXN81Qpbs4sd0qQ7e9IXpwkJbVISG3saCkM13iSAfF9yU6wSDdWepHdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(33656002)(5660300002)(508600001)(8936002)(8676002)(6506007)(4744005)(316002)(7416002)(54906003)(186003)(36756003)(38100700002)(6916009)(66476007)(6486002)(86362001)(66946007)(2906002)(2616005)(1076003)(66556008)(4326008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2TsRnRGrLRUc/sRaHqod7wUR/SPMx9VSQuOl1x9E0TrGfyKFZ/WCOVTz+0kL?=
 =?us-ascii?Q?BNLv6PsFmiYjdJOkY7ZLSrv6UqbUYkGZ+8sHCBFJDLWn+7SVuxPtes2pSdXl?=
 =?us-ascii?Q?9DqH0JIFMfp2Qo0LUDkV8N3ObP5phfIegLEa1L7S4DfDd4VSosC7CcB++Z//?=
 =?us-ascii?Q?mwTNZjPUfgneP6gIcOl5gR3Qc+yECe6MMt5CTiOPF/hJSwRv7WWO+jo7LN8Z?=
 =?us-ascii?Q?I3F3x7Wc2aPoIsfVKRsUOzH1L6wBiDb27L4n3uu0I9RzuqZ0nXjshUoFGEZz?=
 =?us-ascii?Q?mMES5eYKpGq72h5IAuOjUVnHoQYG5TD+tJlFujjQ8uff+GGwefRhEpxfDNvi?=
 =?us-ascii?Q?uoeUwJKvJm3rhmQrvNKXvWWqNXyQyja7cb2P0cN+2r91/jRH03EyJD+Vkwhq?=
 =?us-ascii?Q?JEh5xfiF8thTbM1W829ZKiyGdXStDzd8PHUXuUIGZdG+R82rbFR3HDFkfAlH?=
 =?us-ascii?Q?4y0hDnIWh5lrrgRZ9b+TOl/cqpCfRsV4BkCYdmQ+W1Zg8D/uPnoa6lOmQ3Wu?=
 =?us-ascii?Q?tfVuI0Zq6qOBmAMEl5A932Ylb6wcWt0NSK60eI+Bc3kZqWO0jzREv+0Hx+sj?=
 =?us-ascii?Q?jsHvS+UUW6fFYBY7li3ox1QIds7VkAj/y0n8XgnIhE3Tu85WC2tVFDQMWhXC?=
 =?us-ascii?Q?7Y1QjhxXhjf2moNYVRMRChuEuyiKQOJuI2mF3UbNbuX9lsJnyAEHkupfsbKP?=
 =?us-ascii?Q?mncw8k4H45xXsstRZxv2Bf0jf/Ous1bTfAiOWcvuQYkNRtK476CD1WaAIRM9?=
 =?us-ascii?Q?/+Vk3x5VLR+PXsWxR4wzPiAhCbTIj5/bjTFPtTJ0RPfB4CgTLpl3dxasdmxu?=
 =?us-ascii?Q?PY5c6FvFWIQCV0VUuKqrlCLW5Rjy50O+GbhmpJcpChuegIACUoAEjNcLrkJB?=
 =?us-ascii?Q?y4a9wv05ki8Naw6FxRlYG9GlwwnEBLOFWSVOitrBLhBjGjm4QgKCZ+fyvGKe?=
 =?us-ascii?Q?UuGe1vDEr4sIX6JjPhOzdPPvACkiZEtUMF5dh+zeG4/0Xx2F8J0U46TDdTPJ?=
 =?us-ascii?Q?u17XFDYhtmzBlcx75/hYIjrzq4EKV2Msny2ov2akOp0l6gZQZoMy3eebSkGY?=
 =?us-ascii?Q?4xwb1FDqg/SeGw4JFAm/F9erCEXLHqxDX1a0aqOnTsADVTuxU6MXV5Ru2U1j?=
 =?us-ascii?Q?zFu0VgvSq9ZPI1QryDJlcdBrbLFax5x7v4K3qZhJMGJrd0RnhBV2AaywmWfx?=
 =?us-ascii?Q?yF+GFHBf0Tilo6h5cl40TzGUA5SeCWJntqlg3RinsUPkz+N9JaC2TduuQ5aj?=
 =?us-ascii?Q?D2NWH8Lm0QCoDZCNv+ZW0RHO6M+IBEAYSAnt5sq5kcfVJfq9gA2l0k+Hw++f?=
 =?us-ascii?Q?TC9s9CPVrEL4IjIcPFSUI9QM83SZ4/hYh6c2zLDc4Hi4zVSqwGm1Jcj7K903?=
 =?us-ascii?Q?2WYhHLBpOUC3gwNlnqLMD7ZEyCThVsKfEhEU1AymPGmKs+1STUZ6PUbsqIIP?=
 =?us-ascii?Q?xjEE3k1f9/NQnBSMDHiv8jaVoQo3UvekhgXMy2Y3uEqT1IagG7ykiwFfWphg?=
 =?us-ascii?Q?JRbV4hLjfsTCiMBml7+tr5mU7MA2AflJtOliMGFSiQSkBtDqnc0vlOgbVimk?=
 =?us-ascii?Q?OLuy/mD9uUxIAFoDzBk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1208b8-6869-4f90-43e2-08d9cef2b0cc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 19:53:19.4626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjBuT3/92yWyDbhGeEAFqwPAHTF5xZr7YGXOfikNZB2WgwbYWN35iHJvQ/a0rn0y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5333
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021 at 09:10:43AM +0800, Lu Baolu wrote:

> We still need to call iommu_device_use_dma_api() in bus dma_configure()
> callback. But we can call iommu_device_unuse_dma_api() in the .probe()
> of vfio (and vfio-approved) drivers, so that we don't need the new flag
> anymore.

No, we can't. The action that iommu_device_use_dma_api() takes is to
not call probe, it obviously cannot be undone by code inside probe.

Jason
