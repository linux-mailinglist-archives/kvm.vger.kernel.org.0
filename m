Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08B4B5415
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiBNPBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 10:01:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiBNPBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 10:01:21 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD67D50474;
        Mon, 14 Feb 2022 07:01:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eikC8Lzr11mgLFRjJvs47z43NKP4DBb0/EwgMyRT7VxbXtCbfs4+th1CGgQP2WBTw+ISLDlIWJHWiowg6CKF68SIuhwOl30Ba1066/6OJHW5rHy0kVT/JBEPvcrI2FueAmcu1E8ce9azgmcObw2RV4irshcWC+BGEmgEGSARTdt/BUNVy+/Fqk9FvcS1O5FJTgRkfuiUgozLqE4QA/FXKrPuFRYqwRUdT93SDvrCT2VDf+FtPc7n9C74yHBTKZrX15LnHPR1XrHhEO5qxWtoxCizY05tgxkDTmmcNMj/B8WdLbFMzaYJQAixGNth73BZmhtRtwiu68eKTbhvDM5+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qC3eHKd0piFWLH5SnjN5Jv70/GzKNikK2k0qMvQk8Vg=;
 b=EK2RLBXAPWRGFadmGAhU9Erm/ugbbUvqQ+vk8CgyEoaryS4HIfa2Sgd/2AtExy3IdSoLGdQUTPkRpr4sZxz43ynFwRlz1tcqRbtum8GyDrs0NFWT5IcGdeED7PsKfIA0xAsxJWJ6Ax6KpVNk7pMxCpjouJCEne1nxX/hfU3uWXvzlDNGID+Nilb4gc08fquEQQOJJTVdv+P4a6KdqRmjUYF62sRJsn51Hj7x/XTtDHnPFnlTiOmJ+5Fao/q7SyzyPdhlSu5IEspozZMFUlcPpmXd6VrKXN85xUZPWcNHJVFt1N5gPO8cse60Lu1AbiyExhOuRmUBZT70JKnvfMd3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qC3eHKd0piFWLH5SnjN5Jv70/GzKNikK2k0qMvQk8Vg=;
 b=FB+nJLyCmTwj4ycoUUWM0KiMqAfeuzyHiFNO/yWKmZDzg04XndQCROK+m1gRP9YFbtSBcSyuyGhRQSXCfzlrLNEbT9e6mDnEkouNslmW3d+rOkP3XMh8z5b+x4WsQvNB3HbhZ+jtmvoLbBhSWyGEytEgLEG2wQk2m4h/AMKI1y9bm3jHUciHErhrQg/vV21UJ7Leu43lotBk/fGbkVcpweWGNbJ/LHQxKUNEwmdXyPDXZqN3kp6/TTGWsTSsyZiyRKYX+wdTJYKV0WOb8pSOtsrmjKA0GsJMg17FlIC0foTBwp8n1xgcyr01y3+o6uq7HecgoYALQVBynO5dzvCdxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1469.namprd12.prod.outlook.com (2603:10b6:301:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 15:01:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 15:01:00 +0000
Date:   Mon, 14 Feb 2022 11:00:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
Message-ID: <20220214150059.GE4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-6-baolu.lu@linux.intel.com>
 <20220106143345.GC2328285@nvidia.com>
 <Ygo8iek2CwtPp2hj@8bytes.org>
 <20220214131544.GX4160@nvidia.com>
 <Ygpb6CxmTdUHiN50@8bytes.org>
 <20220214140236.GC929467@nvidia.com>
 <YgplyyjofwlM+1tc@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgplyyjofwlM+1tc@8bytes.org>
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0249d11b-ffd2-419a-ccd4-08d9efcad035
X-MS-TrafficTypeDiagnostic: MWHPR12MB1469:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14699AD6AD51316DFD99D9F3C2339@MWHPR12MB1469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K1nLQ1th9YRet82/e80peXOxEe+bpTYnoF4YufTjuVmo4mUUzm86ioyR+CNuxRxtJgGcv3neH8o9PdtNbBiusSea1t/FA8GRNmKberBXnN0XvSJqk429xzhB/dAFywYZ158vUROhXXhPzxdSVgzJnhxWMVjlFoRi9ucpPNYsPE2tYvmBAv4O3v7pB4jx5l34MOzy6dMLvlgkoPcfj59PJ4LQjfTDZXO9jJOFhZankLyfrj6ffLoKOzQqW1pgbziWkntq/RUkm/tiyKZt9U4tw9yLO6WAMcttT2KI5RxBBYvuQz7ZZzPUZPoZJlUkY79r68tSJRG+M47kw8wJxu3kQyCAMmsgA/zm7sKsAUsM1i2nM/FM4I5IpLWYCIAz9pIYP0NOmefbJKyKcscPMgFZ/er6iOFLugsjWMCNUJC+uG5fZirFGOO/hil1qq2817yHq9SHSyF6LguGNIhrSlfgpttvcezY5v5mUX3CUvt4+bFoY7F1/ijXq9FshGFu5vWcIAFLv3T5HP2tPFhFS6k2uzzsVg75UKrUrsCz033gPji+BUDTYLJdnVzoeq1FBjR33uWYk5HPLphdDoAGg7WeQCQ/5fgBiuQxvZEm6kBY9Dk8rNYeMCmKpdxVICqVyT85M2/TvXfV4KP8ae1HbtYY1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(508600001)(36756003)(7416002)(4744005)(6916009)(316002)(38100700002)(66476007)(66556008)(66946007)(6512007)(33656002)(4326008)(8676002)(186003)(5660300002)(6506007)(8936002)(26005)(2906002)(86362001)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Dwxduzh2xBJ9RNpDB5XmtU2Ip+0xn8gDRQJi9GOJD+hqjgH2cne1QQNG7Ww?=
 =?us-ascii?Q?IcbXtOp/Fkj08kUag7oUX4oMRB2tJ8YfHDAbTeeblZOR9XdSr75+Mpy4CQA7?=
 =?us-ascii?Q?e/mwUVR4DHSdktNxQWMloVPhKrtY80hK9EH3XxPaMEU4j+7KPKvci5vz8kmV?=
 =?us-ascii?Q?tSiIqVb7f9acSknmuq10BZNPPZHOplGykKxYtlvyb0bGlZfnrQG4vbFPiiC+?=
 =?us-ascii?Q?1Sgb5YLRSoUQQ9CexWxlwCvQo4YzLQazspG+nDin8MoOWWA5wCQCBdt+i4ZU?=
 =?us-ascii?Q?C4qvnbIrnufSs7H9Ikawm2lJra+GZDZSQB5CO++GBlsSemYNeX7fE95CjDyG?=
 =?us-ascii?Q?ovqPpkhdFNWMGG+ifqj5YTsXs3IeypyAnqasU5k9fBFSFpJ+IJvf01E/Lukr?=
 =?us-ascii?Q?u8Ma+rI/pzd7+c/pU5ehIHjD2P377AjD60X4oJL/+bXQmgvZzF4FafTCjkzZ?=
 =?us-ascii?Q?zZ+FryBTJMJr10WRUOIp57z6i7+Fi7tU+HNNZwbICeQt0qIMHcWJQqXvTIcj?=
 =?us-ascii?Q?43UpluoMLwaKg6IfChZhchpM6cXTQBZxCMkU+TP5ihunWx/hpC70QFaNi7+5?=
 =?us-ascii?Q?gfXPEmb0nS3sukySwR584MbxEAUId4bctliicdak/RypLcZp6U60l7MUWzl+?=
 =?us-ascii?Q?1i7t1+24jjgp8CIwgi8ynwuyTSRBdRy+o8WJwTKXQF+pZHJx6szsZFrarJx/?=
 =?us-ascii?Q?T5KMNtTzHLBxKO3GQ8dsGJmCSAIYnVR9N3tY0m2HrDbDpJjzQ7D7gtc2gHJM?=
 =?us-ascii?Q?6qONJgEGDSKp4xVoBMUEqdIMU27dyxIabykcx9nWcwBL+HKuRpaMGDky9Nqx?=
 =?us-ascii?Q?LTIQBeRVpE22No4wwrrD/Ia+PLH5B93Rm+vmQ/kl6kldAGx5g/EwotY8kqA9?=
 =?us-ascii?Q?h0mvbAqY1NOCh5jZ7abVAsVGmm2bzV5VDGG7r3Cnzit3XJ6J91999Two8QXs?=
 =?us-ascii?Q?3zCrs9b0BpV0NDBVLgQIxvxlzKWQLQCyOTkftonB8enYgBgCxbHDirv8HL+s?=
 =?us-ascii?Q?57WHSMiVl8pIcZtuB4oEk3XNgrYWAA1tJGh7ThMBXvMXXEdGF7d8OYpdQbSs?=
 =?us-ascii?Q?nkFSTUJPImvO9/yV1lbgXz+316eqUU+Bak865nmH2XRJDnXMscezdp3J8NUa?=
 =?us-ascii?Q?yAhtWvFqikMrX3gh2q7kSdMMC+rrxGhWoW9c0xWrecETWUJhXLaxyyB2XBBI?=
 =?us-ascii?Q?08nVlbAIAuxk6/6Uo1Omqjrrqkj7/U2uEcWbCiH3urxtH45w6eGIKyTujLFS?=
 =?us-ascii?Q?gncYH5MtdzHmZQ4+6WV7pJ+WiiNJ28vREz7Hk619Y3o8pN9kdZCTO19bejx4?=
 =?us-ascii?Q?0iVkdQMyPpaSCxQb/+RsLzGVw4k76qZ82uIamheAs/ghFAsTnDfxaQB9U/9M?=
 =?us-ascii?Q?2LotRbKSVgmVbdZq7Nx+p1iFRhwxzu/dCb7h/+GbODUws85GX90RzNJDXWHh?=
 =?us-ascii?Q?D9ZosiK5sqINzl60opjfEvHEGTrdi7FDZATEb/kuwNMMtiwUKITwAGofppPv?=
 =?us-ascii?Q?1vPL6GNEvWRIP17tlFr9TtbFelePaTsDW2qZcdhH20yknuj3jyVgQghdGL3O?=
 =?us-ascii?Q?wLsr+enUy38aFbXfTsc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0249d11b-ffd2-419a-ccd4-08d9efcad035
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 15:01:00.6829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duceY3BriB0XQKAOuTDAL0PcO2Cd69aVTrI3Ahpp9Yv8N2IHLIYgjRQ137SWOX+W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1469
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 03:23:07PM +0100, Joerg Roedel wrote:

> Device drivers calling into iommu_attach_device() is seldom a good
> idea.  In this case the sound device has some generic hardware
> interface so that an existing sound driver can be re-used. Making this
> driver call iommu-specific functions for some devices is something hard
> to justify.

Er, so this is transparent to the generic sound device? I guess
something fixed up the dma_api on that device to keep working?

But, then, the requirement is that nobody is using the dma API when we
make this change?

> With sub-groups on the other hand it would be a no-brainer, because the
> sound device would be in a separate sub-group. Basically any device in
> the same group as the GPU would be in a separate sub-group.

I don't think it matters how big/small the group is, only that when we
change the domain we know everything flowing through the domain is
still happy.

Jason
