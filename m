Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DF84137B3
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhIUQle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 12:41:34 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:6368
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhIUQld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 12:41:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns5HR9YO4pClEJJNE9aARDE/j232a2nJ0XvnvuP878nbcMrNSNqPufDEbLvZPxInFH6iG3oZNYC/WWFmn9BP4ptxuGsuixL2dOlDkuUC6jVedwAnSykH0gBuxF1OCHYlgL/kkRqQ0gyuhNugoT22bvq5LtRECg3sfXofYODgqXX+UOm6SUEi3RBTRzMenzQbhyPcY5iYko8EYlzsLkA7uzRQEdEiknoKX+Cvl0t8taW2wYdggCViTnvunvskqWMMeHuIxWCBU8KeXOV59MHDuZX4mxXvkfa6ZJLdMfUjUwV3xLE6VxvqKaFfwX5HfNzFB8nqQSsLLiGvxijlKB+rWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vja+C1J4f/6jtVjkoewvw1SVOOB+8E16wGTTkGtOEw4=;
 b=iZRDfyXVxBWzSWWEqv7/JBMLp2x5Gs+jRLFAbJsmZdzmt6/9x9aSs21I2XhanU5hiIAjOZ0LNVuxjgTD4SgszocuOhdwoLBrS1Lx+GITvMY4GattCjS7oY4OrruDDTWoMoPAjjNoiereOC3cYjG9qQuMjVsd4tnyFm4MMt4S4KaqA/QWlfouQKLtWkymuQvvX0YxfeE9udJ2qJoSjVmvM4AK8I+M2+Ub7qOgzNjudCZmoOQNRUhQYGc++QTBH4VDaaVbhzTQ5aerOw9xQuxrI+VcM4icNTadzd3U3tW0PdIGIVjAr8gbYGoL/4kDA9I0t4LFVhMCdZVmxzObYu+JLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vja+C1J4f/6jtVjkoewvw1SVOOB+8E16wGTTkGtOEw4=;
 b=L8HH4Hk3M8nYv4fIuGcR8DPgsIb1Tru8UPBD7TmfMeL1peZhWEjbgt8d4060w6lgfaPF4a0Cqq8A70jfbWC7IfGndKTDTunIDun6HPg7tcr1xYAnYnfioRqHp4DkPilSbb73TlOpLOkw8ByAWmL80ojPHtTErCBsL0sTXUKplOY0Wtv9H4/yqdYi2BhwyGiISZ3togtdco4jitkXXbIflnsrYdEhTKkg5OOj4OQRILrT8p/QrWQmLfqac9F34a06EtJqUwE8MBjfmEq+86owYpd0ecBmNj9Gr47N3h7HhwzCEIxLhDKrLbGPAtpN+CAVka5QhXsG8rFTqZdIDKz3Xg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 16:40:03 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 16:40:03 +0000
Date:   Tue, 21 Sep 2021 13:40:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Message-ID: <20210921164001.GR327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:2d::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:2d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 16:40:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSioL-003W2N-RQ; Tue, 21 Sep 2021 13:40:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9553774-47e9-439b-818c-08d97d1e75c7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5174F9F77D0DB24A2C5FAF8FC2A19@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9jmImo62zi2n4o5oRLhr4uzZYUPur/S4kTguWOmTAEO4TN4Dg/q5wXz+htSqzx2yBgU2ZRDOogDZ+Fl6iOjmAO74aCATMrQsiURlgXkICux6r0HcGEEuvROVKT6yWqeUKYKhdNfLtljWqReZHLhxMUfcKFhYoK7+eppBeiY63rze5zYaYwyfLgyFafYNVwl+SRpopgAZbTEeUZ3R7brGV8Mt+phOGwPgqDo9JZPqjfwWAZyc+3KxqecIiMJAoMlH3MQL5LS+ANdT9ZRXRYMSzFSVX+s6/nkZET+6iCAWoIy1pxx1mOSFeL7Iqt5jImFzfv9eypt1F4MyTqj6yWF1ogLUFz4EUaq/mpxsmf4w073H+vjVJA3nKYFSG3sWYtsgpZrmETZFzq3ZIR4NiWBEOB+2BTdDlcseTiff2/xhIkZ6imoq5joexM6cZi2NBWuBhhTjRd93xh9s8XXQY/6+TafYQq3etmQEENQOILksTaQ1hzAGge4wk1SykbHMBFrhnsvW49YNpzaj0tcnnKi7Gc3WaY5oYJZ1xfZYOsINMAfZhgwWu+SeBjolw+jI2nlDuxB1lPWicMWMZJZtI+6r4UspeE5xEM+ZD0rZSa7nqNxC1ahrRBurcudgWV3MBswGAgwfszaar8J24OoXhNtxiIg7FhNBuRP+Fgeoa2Xk7CC2nBBVh06wn6r3VjP4J7O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(26005)(5660300002)(33656002)(36756003)(2616005)(316002)(508600001)(186003)(1076003)(426003)(66556008)(2906002)(8936002)(9786002)(9746002)(66946007)(38100700002)(83380400001)(6916009)(66476007)(4326008)(86362001)(8676002)(107886003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6tNABDb+PaM6g8iXepja8zX5/0yRgg0q15eF2otMrvsChbcq/7sE9TgpeSZ2?=
 =?us-ascii?Q?g9h/hiS/IMoocOZEFHMHJiKoniqFZK+4IDwyKBCljZ8UwSCFakQzxdcglhxC?=
 =?us-ascii?Q?FbImIlvDF217PaMenAbQTKT+IQcpndmPAjv7Vs6kanu466/ivpCQ8tRjoLVz?=
 =?us-ascii?Q?2ucfJ1+AVnJ4nR3g0/V1BbjncCyKZR2MFD5parbHwv+2a118ImiLxRX5tzob?=
 =?us-ascii?Q?c2Ed8MJqUEIHHCGQNvFRv7f73NFgHNierVhnIkZffkOspOkSpXbhaEXtMwYU?=
 =?us-ascii?Q?AHJqdA96DpKL5oSCTIvbyjuKioa3yt8vR68cw3BDzAEAUNT4pY8CyFDeOxxQ?=
 =?us-ascii?Q?2jO3sJ/PyMzby/vrHtHv+4YFuGRw5L5engSHb+C8aZyWGvXXr8fQ+YShzB4O?=
 =?us-ascii?Q?ka0+jx7gcS7uTxZiqbUi66v8scU8wFqQVq0quVzEgmnlNdyp8o3eiFgns16x?=
 =?us-ascii?Q?WCS2ceH5Rt4Qvs3h3K/VCXdLQ1kVUyvbbHvpkx0kBByNX2slESLnpCa3oBpr?=
 =?us-ascii?Q?eurkHessrz7mrQh7gyu5nIE+DlpyrW29JbLrEwecXqlJ59GULZZ8nDaoPRz9?=
 =?us-ascii?Q?cvdd29Jt9oD6i7G/UDLvvyONiu7viDAZxFNIh1qs9OE1FLCP2vmkOx/vhevZ?=
 =?us-ascii?Q?aB8jf5iesJ43+bFXViDzZGqRkqo4dwjibPZOH6TLyDfOSmpHE5OoE4Mu2nPF?=
 =?us-ascii?Q?OIzktvY5+jXVkONlSNAYuTpWyMhFw1kJ7WDoRotm/3wxTjqtQ8Za0W8UFq6h?=
 =?us-ascii?Q?92N7Mqdg6J2tLqzn1rCNcmWDqMXoGU+AF+nyi8/OEbnCCXHql/9YN3IXGzcP?=
 =?us-ascii?Q?s7Humq27DKRGG0Dp/MpbVX+Rt99q7Y2EPABsZD8S5chZxmuB6BcVITk0BBqj?=
 =?us-ascii?Q?/eAUpMHPr/reSusZBFe+aBP1ygIjv5fWscwToyoLAGmYQKkGstJ3FuPyOkJ9?=
 =?us-ascii?Q?Txfk1+Iqfq1jS3lvoB0NihD2g1fgvCvobZkDodHyUV+Ujax2Q/BEPeg0eI5w?=
 =?us-ascii?Q?/8Kr1QXoQgCpTG/PU/9sF7zYySZsN5DXqKFR+eocrzQWHaz+UUy1Jqwt2DJ6?=
 =?us-ascii?Q?Zcg2UD3C0bFHUub6UxnC4WYYvTgXFV3HqqCjB8Cj6kC8ZRo7xMwpFgOz/cro?=
 =?us-ascii?Q?nQJL6r+3k5x9Fi4opH/W9NT/4ZA+qPZAf9tY9aHQOnB8NPg1e7Y+eYf4WFqy?=
 =?us-ascii?Q?+mM2FuvasM9hchwvqAESnmDPK3PxIr4pQ6uVBKJcMycBxbWKScz8qRaTQF26?=
 =?us-ascii?Q?zNJzZoWGFi5FjUfAkISpeB3B63Zln+AVdfhYeqKpV3nMkb7b4nDCFz0Tth3D?=
 =?us-ascii?Q?0hn/p/38/iHANq2mOi3pczp4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9553774-47e9-439b-818c-08d97d1e75c7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 16:40:03.1301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9zzdq8kjxBsS73JEOCxPrrPlDNu0hNcsOZw/NktnLcHeXrnpVsiQ6Q+iGDZgq5j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:33PM +0800, Liu Yi L wrote:
> This patch exposes the device-centric interface for vfio-pci devices. To
> be compatiable with existing users, vfio-pci exposes both legacy group
> interface and device-centric interface.
> 
> As explained in last patch, this change doesn't apply to devices which
> cannot be forced to snoop cache by their upstream iommu. Such devices
> are still expected to be opened via the legacy group interface.
> 
> When the device is opened via /dev/vfio/devices, vfio-pci should prevent
> the user from accessing the assigned device because the device is still
> attached to the default domain which may allow user-initiated DMAs to
> touch arbitrary place. The user access must be blocked until the device
> is later bound to an iommufd (see patch 08). The binding acts as the
> contract for putting the device in a security context which ensures user-
> initiated DMAs via this device cannot harm the rest of the system.
> 
> This patch introduces a vdev->block_access flag for this purpose. It's set
> when the device is opened via /dev/vfio/devices and cleared after binding
> to iommufd succeeds. mmap and r/w handlers check this flag to decide whether
> user access should be blocked or not.

This should not be in vfio_pci.

AFAIK there is no condition where a vfio driver can work without being
connected to some kind of iommu back end, so the core code should
handle this interlock globally. A vfio driver's ops should not be
callable until the iommu is connected.

The only vfio_pci patch in this series should be adding a new callback
op to take in an iommufd and register the pci_device as a iommufd
device.

Jason
