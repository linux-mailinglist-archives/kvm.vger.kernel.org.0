Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848563A4C20
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFLBay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 21:30:54 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:21729
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229622AbhFLBas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 21:30:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ8fB1fhFAPII8HAf4f5rACDuXog7JzuIiS9phZrTO45dAoRya6voOG9aWEaVafPNoCSQKK73HkE3wRrzv9JIlnhVCSugQ25OoUo8yAxW3p6J84l1iSw7lUN9XakNhA+ZhK+b8ysxdIdb61f+gQweBwRNh3XSUWgmUiRSZ+2o6+Yp1uu99HJjoqK1A43iRcif8RpKWZ5HkC7Jfetms49dCxOV7EH7W+mpyPZZbB+K6tsIdWP4upwY0/m56bZfxs5chU8Go2j7iQZ93+p71Q5vbpDUIPh6G5vofXMJG4IyzD0V7vrg4/L4y093zHurCg+LZSqrvU8JK1CSmjuLTaVsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAzR4MbPGX4yoQntsHbnuddGFgy3BHzMpWF+5VmzyQ0=;
 b=ncnmAmZTsXu699N/WZxkeaz/z+YvAV8zMPcmt/1G2MDklPRumGSwNqb62b4gSlJ+aSkqOLtxe/wYo8V4YqHwyOLJXTlwdcDIHl4AJ9GBLe/TFo10gJz7W9xCZmGyoJWjyOlKDCpd9IwO2r00HeB5TxfEdkRl4s7QnLJT/Q/o0Qv4yPRANWxUh3TvfcWCtmHTMf1h1pDaeIbAE9/8cp3jDxR67wVwA0iU+NRBb0RIPmIFvFD+A232CJNMPM/aFjyUdEvTQp2sPOQfWd6fwlqRIgKfEHUSpoAOfIdc2h+3qKW6d6kdZmvs9wyRju9iU96E130+Av2jcsPvvpA6qnmqFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAzR4MbPGX4yoQntsHbnuddGFgy3BHzMpWF+5VmzyQ0=;
 b=OnQJMZOUyB/H5fL4TcGU97mzLTcajjy4PJfmztVAFgcHK3OwAwYfYc3UqqmXCAemlX6Sv1477DM+UnGKKsRVyPKpELXa9JGVy6AaKsVBBdyVCxOfigqBKM7Oj/trsDW1IDvp4v4mKajf+W6XroHmptEZpLzNuBgAUm8pgepPo1AgtURmCez3OYqksgtPqFBCEbj1NQtpnE6mzWGCP89Jz9DS+Y/36Ca0vHWsSqEDuRS3y8u7sr8Dutwr2wx04X+e8JcGCLUkvjvEolJ6CeSO9EhRUwe/0a5McfrVmABo0C1lfLbSINdEGX2dvDm/hxkr0FcksoS/70CiD7nX0GnhVg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Sat, 12 Jun
 2021 01:28:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.024; Sat, 12 Jun 2021
 01:28:47 +0000
Date:   Fri, 11 Jun 2021 22:28:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210612012846.GC1002214@nvidia.com>
References: <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <20210611164529.GR1002214@nvidia.com>
 <20210611133828.6c6e8b29.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611133828.6c6e8b29.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0090.namprd13.prod.outlook.com (2603:10b6:208:2b8::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Sat, 12 Jun 2021 01:28:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lrsS6-005oHc-JM; Fri, 11 Jun 2021 22:28:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47a0813f-1eaa-422a-c74b-08d92d416cf5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5173EA064263C0CE412E66D4C2339@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+FHBFM35ekUUZfqi/HoQXiUTlILE6nzsx853vZk/WLK5tvYrjtDZ6ih5alEaQ5Hnhr4O4F0r7GpD6ppcIBe2z6mVz9HRoX56QPr83FKcWvX4axxNsHSslGDkZacZQmN8cPfEnTfMWMBr4NmY13nQwgYvl6sQ10vREPaFlJHqjxan2A9zmYMSXTiiyquF51VBWy2AxW64asduEDE0lO6SSVzSbxe4+sjhF4y8JsGaKE/cR3kTKbsqRH2uK5EKjPvf1yWsFEcflwSpNJODSiYU7P4im9FVhYatgnQhXNMQhmgXhjG6AtZMHxRN2q/i6DoPs5GdqZU4OVmxYcPXDgM0fW/8az3H5YcshYLxs4alId38bKFY9TgvRgTE2FiIgN5/osxK40xr2nIOdiOiN3CFcJXk0/lAyG+ohCR4PwtBwTP3L7oXE0O6dQIw010ud0kjHWSSHOkeJejzoNRX8As+5TMleU62rsoaK44E7r8vBSZgBrodocuYYsylLZYS3bsgSaKNjilzcCiL8vCINYIxnfZZUjcPYyG3oVqP3Udq7HL1J0moGx5YvFOJVdZDwngpUM4fw6RbLTasQH2JWqAe/cFF0dWT/2yTqejIKrWi4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(66946007)(2906002)(478600001)(9746002)(8676002)(9786002)(8936002)(86362001)(2616005)(83380400001)(316002)(4326008)(38100700002)(6916009)(426003)(5660300002)(36756003)(66476007)(33656002)(1076003)(7416002)(66556008)(26005)(186003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A4RwXjiKSoeTWP7QyD8Z9jWv1qGGFvSGI8bRBzyGDu3zqAIGB889ZPJAT3jK?=
 =?us-ascii?Q?y+5ZCsMwAZbWslBM09/oIZdMz3Zxji9RmvSWYlP51UAuPRGzL4AfOXBeuaP5?=
 =?us-ascii?Q?fDE181GbUNTo/E5V+Uui0ifu04G32ruY7du8ghvKG+e/oyIkKOZTETdd9pkI?=
 =?us-ascii?Q?BpJMQOH895TW7lt/mCQQsXCXr5TY+RfhYonLPRGWd55si/GYZmo0xmYWVzjp?=
 =?us-ascii?Q?TJZj7eKqMUMRkjpOc8OZJ6iCdw4qYDSeK6FZPKpG7y9Mv7hrt8H4AsknDvr/?=
 =?us-ascii?Q?2NnCvMnaERoaBly3MD8a1kZM98ijs5sBxNTQkvQs/1bkqIWS4AIRsH5aoThs?=
 =?us-ascii?Q?nt/5vffMXqFrLH2qv8iZRr5tSUzV7yTXGNnVoiJQfwGYJSK/XN8r5d3EQksd?=
 =?us-ascii?Q?L86nWRXDhtQOKlznyB4szOzInlV/wWXgrjpoHoOHT8+GFIJWIhEpYWkEdU5z?=
 =?us-ascii?Q?KK8Zumf9hiiYcl3VYEsBCYPkWyl3jPUBCRwZdZrtZ9Zj5y9mr5IAO+Mx7X1q?=
 =?us-ascii?Q?Z1ZQUEN5kxyx3uq98x4bkxy7ER/914ipe8XqnFbY6Kgb+Z/uYnG1vqutm7r6?=
 =?us-ascii?Q?MTZMRyGzyCc9sJ1vM8e6H20evdZOKvsrfvm8b8lv/Le1a5U5xRQUMhnBIMrE?=
 =?us-ascii?Q?QN3Gh6RJWhRbDEZtYdQBg4NN/KrZiau5qkpy3oOZVpjw3Vd+NzTEACSD5kKQ?=
 =?us-ascii?Q?o6Sf51whB92rx3UZ9q6/f+XQFzAxM1z4qyLE53MtPJIqQlbfaFH1ET46MQ2b?=
 =?us-ascii?Q?fTHxo4m1nikg4JthpDoj/5Mgxqzhf0pceVB1s7ejVSpM7azoVCRVTTDE3IUq?=
 =?us-ascii?Q?VieK5f09V1KF8l0sIwiU7yz55ZvTWWgtQrWupIyNB7q04cJEDTB2Jl84L7mp?=
 =?us-ascii?Q?LeXEoemrZyZW1tWweQ8O4BQFDS29sPoW4AF4CpzkCLqcUEM4D0/1pinn36e6?=
 =?us-ascii?Q?N3oDFlcdk9yn7gAbhO1Q2iyDHrRxVDIrEk6fXH7PCbjlXr6dkPofeVVG3xR/?=
 =?us-ascii?Q?eF8ptQ3F/phsmcx7D+fiMWm5nf4ug36pFTYOH3NxuBQqbBl8p1eZ22v532jo?=
 =?us-ascii?Q?0LLfwNEzQ+9IHO9lGJqC04DgxmqPgnA29gFFdHkdOv+ZePkOkYHAVDZHwl0J?=
 =?us-ascii?Q?5Dv9K5RyJxSPQECiENz1gvbGLg1Y96k25ai0udnBtB9C+Aflu/mt0ViXRLPr?=
 =?us-ascii?Q?CjypSZogGqfR9ZMrIXuTW3Q4LEeo69bS+c1UkBQ6FL6vAOkQ38KYdBU8/dI1?=
 =?us-ascii?Q?HrkDx1POZzPZBvVesCcTL8qYV30eu2IgcDvWjYWkB4BlmnzZroH+MMkseIML?=
 =?us-ascii?Q?/ilnRa1oKAeAMZ7GHdSDlRMg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a0813f-1eaa-422a-c74b-08d92d416cf5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2021 01:28:47.6056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ETxhQxC/ZEAIhlm51owfQMndTtI5ME9Zr8Kfxg85QlbkgRY3lSm3KfNSgmGX/x5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 01:38:28PM -0600, Alex Williamson wrote:

> That's fine for a serial port, but not a device that can do DMA.
> The entire point of vfio is to try to provide secure, DMA capable
> userspace drivers.  If we relax enforcement of that isolation we've
> failed.

I don't understand why the IOASID matters at all in this. Can you
explain? What is the breach of isolation?

A userspace process can create many IOASIDs, it can create an IOASID
that can touch any memory the process can touch. It can create two
IOASID's that are identical copies of each other.

How does restricting a device from attaching to an IOASID create
security if I can just make a copy of that IOASID and attach to that?
Is there some quirk of the IOMMU I'm missing?

My understanding of isolation has been that two different security
contexts cannot have access to devices in the same group because that
can leak access across a security bounday, eg because device A can do
DMA to device B and take control of it.

Isolation means that the control of the devices in a group is not
inadventantly spread between two security contexts, like two
processes.

> I don't see how this provides isolation.  If a user only needs to
> attach their devicefd to an ioasidfd to have full access to their
> device, not even bound by attaching to an ioasid context, then we've
> failed.  

That is not quite what I tried to explain. The first ioasid any device
in the group attaches to becomes the only ioasid that any device in
the group attaches to. It is an ownership model unique to the
iommu_fd.

It directly prevents process A and process B from opening devices in
the same group and trying to operate them independently. A and B will
not posses the same iommu fd so only one of them can activate a
device. The other device remains unusable.

Iin this model, I consider the iommu_fd to be the security domain. The
meaning of isolation is that only devices explicitly joined to an
iommu_fd can access IOASIDs in that iommu_fd.

Userspace has choices how to use this

Placing all devices in the same iommu_fd userspace is telling the
kernel that they are in the same security domain. This means userspace
says is safe for them to all share IOASIDs without isolation.

If userspace wants tigher security domains then userspace can create
additional iommu_fds, up to a unique iommu_fd per group. This would
duplicate the security model that the vfio groups force today.

The kernel security feature is to prevent un-isolated devices from
being joined to different iommu_fd security contexts.

Jason
