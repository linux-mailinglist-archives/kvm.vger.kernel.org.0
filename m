Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFB39F719
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhFHMx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:53:57 -0400
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:26208
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232299AbhFHMx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:53:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqD3k+eWyYZOujXMn7IbdJSnlM6tPeZJ5LyA/rn8XjlRJvB6Xl6ztIT6nCwTkKlfQRxuOuZUp7uQNUKbw4jD43CmudLCgpXwf6vyDf1MBqgeMgDNfPxBw+i9BDSyXA8bALijzoWDmVoVCqLV5iLp9EsnAr1lzf1iHrWGZZ7HL7G0Faw834aZgOZ9y43NMQ5NXr1t4Qcz0MYR78MXWzUJh9dxPU3jvHIX0rY9VRR6dDKAeN7rSrfGNzoKMnBPd4mKh/UUYA06U0MzMcLUO9u3w+AwoWKjEzUIxTvJ+XwklLZ3oBoC3X5BVKRzTDSu/3WwL0W2SpIwAhwRC1Os4DDgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz7m66TaMomX/GUdvjQm01q4W+8F/FOy+n0RcbkZ8Rw=;
 b=jz+T7EyvQtkmFt6nKQXHpmTJQRYCjvtFd1MW5dMei/MtpYU8NopqjWdoE9epq2wY8UogSn6a0znMkor0JnkkoToVazXZZ99hU8fAmMZdcXcO1rKN4qn2G+bQ0FUDUhXlIv/sL1qpw+fEeOu5RRXFL6ebWcQpDpfedhFzV2qu2LcajNXM9jTbsCvE1vkqqvEQ/JHt8TtCZ0yKiTrPMGC7yXwDxqEo9HbJ5KxjoN/+24Cb8G96qZZ914+82vNBkg0WhTJp13kwuC4+aQrdYZOtuzXn5CkiqXOS76dWvxvFZ5yEI1Xh1vDDb/EPVL8mAoA3+WNLEDwsTaTYaS6bbSqvcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz7m66TaMomX/GUdvjQm01q4W+8F/FOy+n0RcbkZ8Rw=;
 b=g1tvG+624DWUyX9yX5vcz7q/m63mRCcSmXDIJJqi6Nhpi2dzXziHwGEffPTabvY6QQPvO2IwG7AwVuzFzCyYig5UBmMVJkntX/azytnLEsbp/VwVy5x3YpefI+8f4Mwo9HA3SG1nTVw+Jnt9mzCv9bZ1sHeqQbGC3LUaL/iftIZU8wOFqhHkBBD9S1AmDwJ14zf9opHFqRvPZxM341EG1183pi7hLtmrYc1hOig20dgKJI1Wefhv+PPWi8FSRAFXdlpSteytS/RZNZPfyYGGwjFSz5rlkfv2IJVyIuGRk7iC7gRFcEMBejTnciMK4sa2tpwV8NbHI5/h8haKVQc8Vg==
Authentication-Results: metux.net; dkim=none (message not signed)
 header.d=none;metux.net; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 12:52:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:52:02 +0000
Date:   Tue, 8 Jun 2021 09:52:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210608125201.GC1002214@nvidia.com>
References: <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
 <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
 <20210604115805.GG1002214@nvidia.com>
 <895671cc-5ef8-bc1a-734c-e9e2fdf03652@redhat.com>
 <20210607141424.GF1002214@nvidia.com>
 <1cf9651a-b8ee-11f1-1f70-db3492a76400@redhat.com>
 <9a5b6675-e21a-cf62-6ea1-66c07e73e3ae@metux.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a5b6675-e21a-cf62-6ea1-66c07e73e3ae@metux.net>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:208:160::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0003.namprd13.prod.outlook.com (2603:10b6:208:160::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Tue, 8 Jun 2021 12:52:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqbD7-003ppZ-0x; Tue, 08 Jun 2021 09:52:01 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6d409bb-7fea-4be2-e857-08d92a7c35d7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB507848866B3D5BD93C1E89CEC2379@BL1PR12MB5078.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCFTWaWDfJMtJrnfWlbwYFwRviHASQD4viHMg+USR2G9GE4qxdpWl8nJZ9rZp0zNlAlURRcmOdvfe4fVNr+z1ly5bCUTFFe2ixSfRa0dsT2Tq7jFpwGJ1WE5JfWPYy+WFK7u43HKddy1okBlz6koMz3kOZuf8j8v/J12Ll9TobMX80nSE++DgdD5+3q8ka3PGfCFy8oU6nro79jDuqTKp3FGbB4bUi1TGRonUzwkYTf6Jvu4Rd4pgyv6lFcEgV4PpKp8w0z82Nir1JyuobFlgXcxtfMsmXv3LrAFZLjTxN9LQ9dASa4JeKi8bPBgh5J2uvEVr7zj74WfcV1Mn+jdxz0kYfdXkAcT79Azgtd9XIy6wJmvE6AitA7qh/PaW3SoDe3IC/ONC9X/NJBkDcPJvdn7YQoxU+htvKsbiJniEkFZadIckzez2O8GNWynQI2AK33bMsDDHoMI5M2+ZvA4atTErf6ltAdSNfhVKbdyv6veXjLnu6+bvhQkYXxa1/bOjS6YJTEjmXuJJHO1IA4xh3zV3EYvjpmX/5h578Jk9sdrkOIbMl+u89zsXoOIPUhL36Xv7Sq3h3X5VTMV3mNd0kFUgdbD/e/qFcNlYkSXJSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(66476007)(5660300002)(66556008)(38100700002)(66946007)(2906002)(8936002)(36756003)(7416002)(54906003)(186003)(6916009)(4744005)(316002)(33656002)(426003)(86362001)(9786002)(478600001)(9746002)(26005)(4326008)(83380400001)(2616005)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nQ4q6H52DyRkLCKNY/KXfnl5EP2zwhJ6jH32DI9Nj/ZVwpQLuChgvK1gY/fC?=
 =?us-ascii?Q?edJ0mSWL52Pj86TBA+UdIiUfQoXm/AOD7G7hCrqLtseEwNsQENgthTki67lh?=
 =?us-ascii?Q?XEGyslY3B0MFioPwCLEsRkTm+xA5m/UmjNvpfp+2STe4Q9gLEK0Ze+Ptl+JX?=
 =?us-ascii?Q?6SufwppBBYMImgP53bzUn1qA2x1NdUVBY+x07i9bJ6feT/1U+toh3rHDIPn9?=
 =?us-ascii?Q?F6+JThzTWyEXcb0cPg1Zq3mqmMoT4bfQMHnz359DmSEYr+c7Xm7xYRyhAeAg?=
 =?us-ascii?Q?NXZ/snfacJEPFzsyvgYr42ZT/zYRH0D+SpME6Y4KLkmTQDJ79rBCdpx9EGF+?=
 =?us-ascii?Q?GrHJyxRe5QK6IG7SM564QM+b2yS4P3l6gJZ9cv57uuwJLax6/WPiF4lqoRYQ?=
 =?us-ascii?Q?PB+VekmKjgoZzbV7c19WE6BvjBhIBJNRVmRzNpGj4tF/ekgSBWOnGG3r10Gf?=
 =?us-ascii?Q?/DhZfVqDLxIPmP43Y/AsgQjrrffElqqDOGE8GU4wbsy/PnB/DdeYus16nNas?=
 =?us-ascii?Q?br5j1ranKngmNw4ObjqWcJqYv3PvgDc+rMuZjLGjlQYWcPddt/zPbxqNEqmp?=
 =?us-ascii?Q?9dBNkc24EMgpiyPijUlv2sm8Ns3ed4G47mJPxwB7nFKHN63nySk3TempbFQg?=
 =?us-ascii?Q?oArrRDJyoiulxfsPVZkz0wheLR58GU01g/QoaRJasD0wlBgU0+hn4SPDizu/?=
 =?us-ascii?Q?zxaZ6+Zg90vsKtK2yEcZ1zYgluFjFqRMon3/tb+uywuxjOqDW2J43AVscbKa?=
 =?us-ascii?Q?1S/QQaE/CWnaykAPsPTuVV2vN4PyBIeryrrTyrgl01Gzj6KJc+tLiZ67NiyF?=
 =?us-ascii?Q?upOj4W6FhYZwMpAKRoygfVoIt+gTvwhBGa84MCxOf9YIV0J4EZtTMa/GCEt4?=
 =?us-ascii?Q?FsDjg5da3OBlU2DxnywORgaFQovqfOzozZgMrRgsbaLQu6/tdJbRcCTetzue?=
 =?us-ascii?Q?EwWA3qIExaRf+/vLykUajJgE3lLG4coysHF7IQhenUW7/l5lNwp5dy6+JXBu?=
 =?us-ascii?Q?Y/CYdLME3bSPr1Audgvhc9nKYEJcZbbjJeWs5p8I16R/G+/QzR8dq/fwg9eB?=
 =?us-ascii?Q?vKlJrJpPkyScOydW9wknE4gU7SN33kqLE5jPGc8mVSmVIGJzQyXAP9xcaGFa?=
 =?us-ascii?Q?/NB8A6FCCjwwTxbebRYG+nB8bHi9MF2009XOnaPKvXxjsgiISUL80lRrpx1+?=
 =?us-ascii?Q?FkMK4bax2d14kFsu0yBrW8CRQ8lm0e67C5klQ0dFC9rRvFADufyU0q4KcoPo?=
 =?us-ascii?Q?3OvcOzjHchqPP/Eupf20OiA9612FlyKQlPISx8oxpePfEbr5/cW7buSujE3s?=
 =?us-ascii?Q?kBtmR7x5GMk8xc+CLJbyPvjO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d409bb-7fea-4be2-e857-08d92a7c35d7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:52:01.8762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZtksV2SvZfOICVCA8oUIfSpCmSiS7vwuxjpJ2dfxAkWw51Ompmn+5Vh88Vj/mfz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 10:54:59AM +0200, Enrico Weigelt, metux IT consult wrote:

> Maybe the device as well as the transport could announce their
> capability (which IMHO should go via the virtio protocol), and if both
> are capable, the (guest's) virtio subsys tells the driver whether it's
> usable for a specific device. Perhaps we should also have a mechanism
> to tell the device that it's actually used.

The usage should be extremely narrow, like 

"If the driver issues a GPU command with flag X then the resulting
DMAs will be no-snoop and the driver must re-establish coherency at
the right moment"

It is not a general idea, but something baked directly into the device
protocol that virtio carries.

The general notion of no-nsoop should ideally be carried in the PCIe
extended config space flag. If 0 then no-snoop should never be issued,
expected, or requested.

Jason
