Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93A83B6B0C
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 00:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhF1Wus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 18:50:48 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:55488
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233035AbhF1Wur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 18:50:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqAn2y2fu/R7L0FQAnC+NAhNRyT7EmftoczHYdtkfRPM7MgyL/e0CO9ggPNIj4s45cYyRLY1Lsm4ly38tv3CTCPwpb3nkjpLXsXttu0r69OZDTNf72/hG2KYaUOUDOsutikgcm5sm9b3TAK/mFKkbF0odio8LPu5jbZyVoDFMuLMCWAwVxtxomsuXAcskMTwjtz/K3Edn7RBWWbJ39uxHjCAeLRJRmIHGLa9YJ1EeJhUqZ9iGf4NPoOWByUvT0YzJ81ojNSXQqC2y5biXMShBVeHEpHvroY74+niJInFEqewSziZtUqK2T94pgyfXBvU0Fay+8diI6rTDBeDSggeMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDRvVLY7xK5oYejQXH/tFLwdnmBVO7Wbyoi61KpBXUQ=;
 b=YFXpolBh3ygFUelrWJNUdsto+RakMceB4It/gk0ezkigRdLAHoR4HTya91/EtRG/XJNPQVz0ynmpqVmhUju9yiZjPJ5SuBOJsbOmlRafGByLkyw+pUwXFhBM9qMQO5E3Ld/XhVoDvLSj3UHd+Q82P3kukL3vP6D48sdqprxX3Sfah5pPYnfe07xnf6Df3JdqhyZkTu7f1DR/opbpgh7Xlw2BkX7Zks1pTSJpD2aRbsnsJu4RqqRE+5EqvlkCHBIkkhsMJUI5Hnau1Ey3DGDkxuNUrCWQ+FZTqK17l4mpmcf2BHpreENUIrYyttBsN8KKs0KSsrcKblw3RTI+AqS4vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDRvVLY7xK5oYejQXH/tFLwdnmBVO7Wbyoi61KpBXUQ=;
 b=nlvRyg6lLPhT8xOAeF/eAZEzXcFm9D3CKWcY1yhr/wrvzcEjxL/UCbZO7c+gT9rAP7OWy5H3UpYmnvi6CG6PSoykm27RfKA2XyGsYQo4hSuKsmahYMmSWY4P6qpXZf60UJu+OrekFpN5GgVcUnW6N9XCirRG7uYsGPsMGnY7YOOcHm/mS/iIXMvhxkO8vRKhNb4ah+uqcCkkU/P/12mRvsbksarEXZBrVmjlvniUiyE2n+PMeM/wU6D5D0fvdkonwniVEnp5GO1WR4V28fohULlMjnNXCMdjADTEhgLhbxgCgrtm2266QGiRjylcMivJVSNEjpPW1JmNz63OyiNryw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 22:48:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 22:48:19 +0000
Date:   Mon, 28 Jun 2021 19:48:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20210628224818.GJ4459@nvidia.com>
References: <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210625143616.GT2371267@nvidia.com>
 <BN9PR11MB5433D40116BC1939B6B297EA8C039@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210628163145.1a21cca9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628163145.1a21cca9.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0249.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0249.namprd13.prod.outlook.com (2603:10b6:208:2ba::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.13 via Frontend Transport; Mon, 28 Jun 2021 22:48:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ly038-000lYj-Nc; Mon, 28 Jun 2021 19:48:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8540b07-7181-4b6f-067f-08d93a86d361
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5254094B51CD54FE68C8180BC2039@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVzgYUW9c2BL86W5nOoouN7sA3pVOLyt4ZbNCaJSCXZ5bDOK12mJF4CBlnTenzVnrE8HgxLCE9cn2LxieZ50LTfBVrwu6U0i0PapMGkDIeguxocBoFUUY1n7dBowU0PhsIH9LvQA318V6UzQVM4M7eo2jm6scx4WhGdZY6qCvjM1vDifByjtejJKOpFCibLqRGOtw7MkvmVu4OhHOcFWAFlYIFQLgvEIUpMZrnrCSeaiqE0BrSiR9cm3uCRmhVPTXA0rSNzTis9OpDv1+4RLbtXM9a493HqPEDd7G3qWqBN/14gwwrEA+hnI0xmhBtDk5YSH9DZHpeWRGqeRLzjwmQ+9EMHsQsGTeaUiZwSDzjKVE4EHlvTKuNooEwwHlE5jJFfXIvnYg4/zKGvKwJcRusiJwCvCzhjWVyC03b4m0zM6cxaGGTGERo8xfKM39THAR4CIkplpdhpQyhg7Gq39MfgJ8SyChUcSR3ZTkuYw2ey780D4wANhdCggajLykD1K7Qgzt5PX9uAYFFWF6vN5Ds6hxWpS1Kj9fdWMh3xBUOW0zWDKgfiphDLUI/hn9sSbfdVAxwG0aU/ynlFSRGcfvs1Y9973toc5vv0HyKsmuf8jR6fQnpwZBFr2As9K0drffztQxGPPCYuvd9g8/dHxGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(86362001)(26005)(6916009)(7416002)(8676002)(2906002)(4326008)(186003)(316002)(5660300002)(9746002)(36756003)(38100700002)(1076003)(2616005)(478600001)(8936002)(9786002)(66556008)(54906003)(33656002)(66946007)(66476007)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sKZKiFFrYxm548obMditgZgRDa8n8a1LoZtxnumf3FWK4sjfCC4+PV0MQwwG?=
 =?us-ascii?Q?Bn+1oaFWtJC41ffDS4yIcN1dbgdvZKfkMo+RBIAxah21bWg3AJdKpsBYEMRz?=
 =?us-ascii?Q?sb6Tla9NC4YxGEq4RW5KyVosi6+mqfckM/XsdU8McKGwkDra9SsfJFCsmo4R?=
 =?us-ascii?Q?L8Tp/3c8OYZJjL0N3dNjOddVJnQSdkpImV/B/g+Syp/8c/b+raoSG+nj7JBq?=
 =?us-ascii?Q?8I7U75ccMXzNwpGHhUh9Pfx6ARCTbRAMalnlckD75qmnvFVYDM3RwWv7+0c5?=
 =?us-ascii?Q?1r7UbQ5cjAbvN6okUYvN8w3CW4jZc+jsBtc0prHAHKN/aj8mgq+NdtHa7tsW?=
 =?us-ascii?Q?CNWeC1UIMmdUzqIucYlHVoAAmz3FDWb+t/itd0Wjmq/RECOvCQrVhUmTFziJ?=
 =?us-ascii?Q?hrGCLumh1T49jeRkoG184pR/KwcDiUUuXNt6yHZFE0XW2/ygKtzz/VyPxQBr?=
 =?us-ascii?Q?Vc7ORiiKV6h56zpPWX3K9sAXK0MfG7IWr2E6QvTnmWNoe30FUKqwFCYXzp0B?=
 =?us-ascii?Q?fkFtd272Hs4W5XHYFssvJgyx+xlNnVbCUbCfNxhwtDgn8WQDS3Icq4+6eNkf?=
 =?us-ascii?Q?O8kjdpe4v3m+E+BFVX8pYzEcc3pXetVcNEnjvSYvpbuWDWcKhQQ4j2P57iLI?=
 =?us-ascii?Q?B805ViUR6vzF68BtSSn11Vx8gEH8XW3L1JdZS9w3RqM1QCb3B8r+I6z7eqW2?=
 =?us-ascii?Q?8cDlBMRVF8sn963nsMLxFeUVwmAmEQm7V54sdQAVrdmWlnAoUCD3QaEJLQBk?=
 =?us-ascii?Q?4ocXQ4xet5enI3fomDlRAiqbghDhGtCbks1yvmLiEKsiYwOdiYVMQZVV7I/d?=
 =?us-ascii?Q?2n0JQXaOJfa9CXrakhss48LNsJzWgUJLFEFdIDwjjGbKH+G2CYf0fXkKBbPj?=
 =?us-ascii?Q?jaOvTzVgdfjXrryaD6t/EOrUQ6CqSHXw/hxvhDl5/EpnzDrPfxH/ktVoUgfk?=
 =?us-ascii?Q?WQCvsbbywUaA/mT0jRWpQceSh8L0i4JFCzMpnd0zWkWC3pLaB6FDbryJCTaY?=
 =?us-ascii?Q?bbCh8QMqcbe4Eo1QpCCGnmLzRHsMpc9t+TXioD4m7Qi9WOoyYh7rXgNo9aRd?=
 =?us-ascii?Q?SBmJnSSHgGhutyWlzxw16VDk1x39zVUafS6Iq9br4eOU0MHO6EpaRoryCsJu?=
 =?us-ascii?Q?DoGKEslzwOAc2qTEUco/nkYE52wk8NUCs64VA4wEroUWSRxkNDAC1tryVSqt?=
 =?us-ascii?Q?+GWk0EeA3fKOQUZJULypeAN8lWwiPKnBIs22SFH14BK8M0/68TMuYGxupHnP?=
 =?us-ascii?Q?i5UULkYlxILhimnV3YHezb3BUpcIcqTyjnXcyFsL3A7alz7wZtsN9fPbG9jO?=
 =?us-ascii?Q?1r9jyhVKqjlYWKVxA72cF7li?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8540b07-7181-4b6f-067f-08d93a86d361
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 22:48:19.8694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkTMtw8uEdaEQx8rwJXJfSUPFmO2P7x0oAHuQNmA8yN2eVRPcOrWj+9Ff0SAXgqp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 04:31:45PM -0600, Alex Williamson wrote:

> I'd expect that /dev/iommu will be used by multiple subsystems.  All
> will want to bind devices to address spaces, so shouldn't binding a
> device to an iommufd be an ioctl on the iommufd, ie.
> IOMMU_BIND_VFIO_DEVICE_FD.  Maybe we don't even need "VFIO" in there and
> the iommufd code can figure it out internally.

It wants to be the other way around because iommu_fd is the lower
level subsystem. We don't/can't teach iommu_fd how to convert a fd
number to a vfio/vdpa/etc/etc, we teach all the things building on
iommu_fd how to change a fd number to an iommu - they already
necessarily have an inter-module linkage.

There is a certain niceness to what you are saying but it is not so
practical without doing something bigger..

> Ideally vfio would also at least be able to register a type1 IOMMU
> backend through the existing uapi, backed by this iommu code, ie. we'd
> create a new "iommufd" (but without the user visible fd), 

It would be amazing to be able to achieve this, at least for me there
are too many details be able to tell what that would look like
exactly. I suggested once that putting the container ioctl interface
in the drivers/iommu code may allow for this without too much trouble..

Jason
