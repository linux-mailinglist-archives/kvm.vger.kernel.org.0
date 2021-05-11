Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1AF37AD2A
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhEKRiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:38:15 -0400
Received: from mail-dm6nam12on2071.outbound.protection.outlook.com ([40.107.243.71]:35520
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230315AbhEKRiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:38:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a64jvjALCxaryF8utMnsTBKG6/sMVkyrXTbEoNaHufjlVEZwRTAaSeYeDqoDsvL3TxvI/uDgJwHu2O4nArWveJlHdGriaFxF3Ajz7ykdFQCpoWhsFbe/TECL3DpHno+bKo6tB7rWGjgE68DIJ52TYzKjHiYB84WYZRiEhWLUjwWkRnr7KqLapT6FuGxkjKiyc4OBqKuIwS2t0yJoOgakMPv5TxQP8VmrMDt+jYEGABDvAtor0NtLN9MfLCvuEn55UVog8PAVEJeIC1ygf2ZAuYjos0OqS8wE0joZpIkFoWsUk1GyzYi7g+OnO+Q4H5GtYyNM94uBUfFGrCno8T7piw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTsIlo3NCdV3OmEk7/6Tchoz0AxdbyyuplwvorUOPrU=;
 b=dIFqnz+L7kAi0S1Lbvxb5ftb+D1zkYMqyjGWcHVl9MQsTmNVJpx87ze1Nuk6svEX0kQgiAKKkeHbxQbGTFWuf+4tS9vUP2hZ+A3sKMCXvHjR5J4l03pL5fN380P97Gv57SmSc8rAL2TK9e7O7csObBwDGV6M68xA9ca6NPLdkmZlIy2D8Gh2sLTX5dh0TAjikP6t3s7+5lcVCePuocCaTLJehSUrB+1ZvJWyAS2xKzvx6G2+2EtukFIZNkibA+xGCOXsrlrj6fmuPiBw25P4ltAf0r2twMcRVHrpRB1iDHUBGODvp4LCTGfxg3qqnLKVdt0OpLgZ8kPVBQ2cu0SsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTsIlo3NCdV3OmEk7/6Tchoz0AxdbyyuplwvorUOPrU=;
 b=fqg1AhIuBfqPSZWRIGtu43D6vn2PjidweiRfaN6spLcuwIXI33P1s/4Rv3d7jlZuSFmory+WSf5f0putlVGLS9I24JOx0YVrE6EPmpnC2bkDbaPu4Ty1/b+eHUWudwHKdj4cexcjqtQnsUWy36uFWn+YM9e2smyCD3qw2KuNuI3xYQJdgOsq328DmgQODC9qdQZdschn6CwnbcqoIhTnTKeHcwjp6Xa2ZK5pg36mYkQFZABtB984ZYgi7Zo5Z/qJS5lTcLE2Q195kWGXh4w2gjrX6Ti+l3zYJU04l6+4QoNO22g5zk3tJHa0XkMJFM9ozfVT4G/nWHq94fXTGTwEdA==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4617.namprd12.prod.outlook.com (2603:10b6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Tue, 11 May
 2021 17:37:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 17:37:05 +0000
Date:   Tue, 11 May 2021 14:37:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, ashok.raj@intel.com,
        sanjay.k.kumar@intel.com, jacob.jun.pan@intel.com,
        kevin.tian@intel.com,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        yi.l.liu@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        tiwei.bie@intel.com, xin.zeng@intel.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v8 7/9] vfio/mdev: Add iommu related member in mdev_device
Message-ID: <20210511173703.GO1002214@nvidia.com>
References: <20190325013036.18400-1-baolu.lu@linux.intel.com>
 <20190325013036.18400-8-baolu.lu@linux.intel.com>
 <20210406200030.GA425310@nvidia.com>
 <2d6d3c70-0c6f-2430-3982-2705bfe9f5a6@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d6d3c70-0c6f-2430-3982-2705bfe9f5a6@linux.intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0340.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0340.namprd13.prod.outlook.com (2603:10b6:208:2c6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Tue, 11 May 2021 17:37:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lgWJb-005PuS-0F; Tue, 11 May 2021 14:37:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1dbc131-359e-4c40-b0b6-08d914a36436
X-MS-TrafficTypeDiagnostic: DM6PR12MB4617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4617F61FC51D152FE0580993C2539@DM6PR12MB4617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEF6FPV9O6gYkWoLnkaxOyfhpaGGpI/vBgjcJQ45VTaCpT0eRTJU+R02cvcnliYKJpM63vTLtPLvHQ0q0LLlQSmWYQRYvINi/yQPL+xoacJFE3agOpMwJiyWtWvkQAXRzdOjF6rPppOGlg/JApOWMjnbeNbKXvoDG4NN095rohWml4pQ0zI1sJBO7WwDwOgUuidIUzPRETtYmzF1raOVsfqPyhTvBnwmVRN/L0FgjqMdE0kuvVMjlZH0ThQXXn5lnO+z5AGUAb4yJpWwp8gc7jwMMUQaOYqOwl8+fltANwG3LUWQHCRSBNCwTUkDPyeCAKdEqH7UFB6xL37OP9KNZJd+HMqsd6gDTlSFtTT5UBDciFAUNLdQBqM7ftb/dWEJG9VeKU+WDpm0iz/ryeS+Mfq3H/tJhL7tpoQQSCM6VyjpQzcpTJbWHrqNwJaE6fUio9hy31nceVw+kSfE7ecOYGbEjXpE81vRChaAgesI4PExr3Swq81H2iyqj+2sNj0mOvp+rRylDT0EmsRS5hUkBzuMdPorr1NQWnJqRAupCBRzEu4f8icjPwkaPbk5Ur9SnS7Hv7MU2Z7p4ZRHyGWIu12gbYRe1st0YL/I5oQNxO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(2616005)(6916009)(26005)(316002)(7416002)(426003)(4326008)(5660300002)(33656002)(2906002)(38100700002)(54906003)(9746002)(9786002)(186003)(36756003)(8936002)(8676002)(66946007)(66476007)(1076003)(83380400001)(66556008)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qnIJSxCRym78DZSq5KJiV2xEx07j9omyO7soLkLK5tRb2wg5nrrHwnJMnLtO?=
 =?us-ascii?Q?l8Xx+fTGHRN69XhKcBgbz1Z8aWC+8ymb86LLGRCvstcvha4B5O0nPCjV05vo?=
 =?us-ascii?Q?5rd4B4z13cTBPFEQRZtgjLttHwxeXeQbsweColF8RjUIVGAi4j1iFrIQoTtl?=
 =?us-ascii?Q?OVxVC0nOF/P4NW5OmB72Sn8uiP2+Iuy18EfII8aJzLQhTTnXPyEG//j+nmBy?=
 =?us-ascii?Q?+h+vE10Dw+PHYStbWSr0a2PUlH0XJFz0MVOgWSqMnjB8BYDxhKsipt8iXGaT?=
 =?us-ascii?Q?EzZ71t2/xnDGNUp/A7srI+VNA/PwwcMqaGs59i4AEdvmf/O/3VthesK57XVC?=
 =?us-ascii?Q?Hk8UZVgcypp0i7ax34z+c9zEuxBsMYcmYJfBftszu8VFXatBd6YYvclBhgll?=
 =?us-ascii?Q?9t1mpDIA5suFvDIvLD9rVvxZXV9AxV+VWaKFYZvSElLGc8t0MNNSskT9P5vG?=
 =?us-ascii?Q?+s0zYHdAQx/7ZoH9b2etdTd/GP8+oPqMnzjyaNbaNNxAAN8267WeSV2FAgMJ?=
 =?us-ascii?Q?KXB2+FHWqEJOBS2z85AzWkrFhWb52KEu3k2TXMgirua2tSqtzD00k0+/OEby?=
 =?us-ascii?Q?lC+XhDgLwv4lQrVETRKG4N23mco4isOBhg/dpjc9AF5enPCuilXFdX9oc93d?=
 =?us-ascii?Q?ycstGnFMbX2qcofjPOAybufdZJFIhUBAddCUhQzkftpfu2NroSeBdZQZEKhG?=
 =?us-ascii?Q?S6b1zELa729evXCB7Ejmat4QWNyMdl8gMVnXa86IrRJlkaQ5kLjc8kNvr+QK?=
 =?us-ascii?Q?QZIUaGslSz8Z8rRbEwkq2Q7z5ghtud9xg3q9cGe0LUELMxXnEuSHSiqgGZK/?=
 =?us-ascii?Q?RIAU+0Zo5q7mQUPI3YyIe700l2OD4t+7t0/UxaWdCQ2E71DPRZAOO40T2j27?=
 =?us-ascii?Q?d/HArbzUdbnBqKHx4BvLfH2mG0eOrYAz1j4Ay+oNE6s4z+HgqqqKh1LpOlZL?=
 =?us-ascii?Q?/6W0omGPBg4Bn4gugZ3rFCiDilFpxrJAhmhLeN5bdwSaO72q2ZH04YSrf7N6?=
 =?us-ascii?Q?u3ZINZ6d0ko5aaOkC5u1uEOb6xROukjLf+skyw7NGKmQ4razvxrXB9QX43sg?=
 =?us-ascii?Q?4uTLdnS7Xt89FXJoi0UB6LXo9OHb71k0Mq0Ppl+4U8OA5WavFy/XoSctSx6E?=
 =?us-ascii?Q?zJurR2aYhx+bQ+AGQDzpxT+rbLFgllH2e0aFqL2bYCd3NJXIhuCxRlJt8a/J?=
 =?us-ascii?Q?VRdhNTWC8a5jtCA3BdAA0q+kte+bGXb78aCw73VmSxuUnqD7cf9HqcJWjd5c?=
 =?us-ascii?Q?b2k+qgM/eS69zmRbrXcOIJ+6Rfx5WwXSgBxigWDcpbEBCMcnf3/gfzS4K+Za?=
 =?us-ascii?Q?IS/dFjx05pCA6IHuSF6+os6I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1dbc131-359e-4c40-b0b6-08d914a36436
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 17:37:05.5299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QdHyrQR1hKonU8AmBnolinepjnQMJs5cOWZHPLMjvP4ESQk1J1WF4mr+5Wiv/5Ax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4617
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 02:56:05PM +0800, Lu Baolu wrote:

> >     After my next series the mdev drivers will have direct access to
> >     the vfio_device. So an alternative to using the struct device, or
> >     adding 'if mdev' is to add an API to the vfio_device world to
> >     inject what iommu configuration is needed from that direction
> >     instead of trying to discover it from a struct device.
> 
> Just want to make sure that I understand you correctly.
> 
> We should use the existing IOMMU in-kernel APIs to connect mdev with the
> iommu subsystem, so that the upper lays don't need to use something
> like (if dev_is_mdev) to handle mdev differently. Do I get you
> correctly?

After going through all the /dev/ioasid stuff I'm pretty convinced
that none of the PASID use cases for mdev should need any iommu
connection from the mdev_device - this is an artifact of trying to
cram the vfio container and group model into the mdev world and is not
good design.

The PASID interfaces for /dev/ioasid should use the 'struct
pci_device' for everything and never pass in a mdev_device to the
iommu layer.

/dev/ioasid should be designed to support this operation and is why I
strongly want to see the actual vfio_device implementation handle the
connection to the iommu layer and not keep trying to hack through
building what is actually a vfio_device specific connection through
the type1 container code.

> > 3) The vfio_bus_is_mdev() and related symbol_get() nonsense in
> >     drivers/vfio/vfio_iommu_type1.c has to go, for the same reasons
> >     it was not acceptable to do this for the interrupt side either.
> 
> Yes. Agreed. I will look into it.

This will be harder, but the same logic applies - it serves to allow
controlling an ioasid without involving the vfio_device.

Jason
