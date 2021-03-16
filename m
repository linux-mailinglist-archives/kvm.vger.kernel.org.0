Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888CE33D4EB
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 14:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhCPNea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 09:34:30 -0400
Received: from mail-mw2nam08on2077.outbound.protection.outlook.com ([40.107.101.77]:39617
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235167AbhCPNeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 09:34:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFL0l45tYHm0IVh5suYFFlYEpY9XAe4O4GU7cOpEsnecjOuEQhNTGxMuKteA/Zk71VxlsAaUXjn5jE/vyYr3reC9gAS4wdT9KZM404IsI51zdkG8esRZTjCrCtbJUMb9fU/8OhPXHb2lAekB9OlTKFRdZOOwjC3yfzGwVy+Bq4eE9WRGKj5PBW0J9/Xd0D73jmKRqXy++Nxah68Q3Pbx+VSRvhFWn2vpqWw+IhTseikqHcvBlSC3A5RVhrhyiq/EJFsxd6Ahu4GVQQCQn6sy/fUQncV+wI6xLnUmzR32IAeb/53niwoYOMvQWL/RBJ2DCyrWcYwgwsr+yBIe51UobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FOkw/9vEpPT0VeQKr7qauMbVHN+mELMA1zBQltFGaI=;
 b=IESL0JS5U+c/daBRKFOTgT7VS90oFnxXAT54EWQ+NCczf3hmYmewmx0omMKWuvP+4na/yZXdlBc3XN8tGo45TMbOzi6mbNyrpz7x95RaKFwSZfdMFNKyShMcTo3XC/MD8lhoTmRsAzYrQMCtIRkvSMIjPA9mo+59vhw41vSLwp98dMoIwn72YDU7n3VHJQmEX16MSgX5nynoYcSxv/heiSUejetfmovJChCf5rqK384tTVlDntjH2uN1cAj4j76G5hI23LHY4lnyO/nk+hCDKFToaZBElsy3hTf5BqXy+R3U5ucde5wcMPj1nQ7xYtm7T3QMWbsUJF1YpJWUNGsdEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FOkw/9vEpPT0VeQKr7qauMbVHN+mELMA1zBQltFGaI=;
 b=oEiMEDfuZplMnr57Lj1sk8sP1uYQx6nSj0mYPPje+MaIA0ZflNSxpqzca6BVYxXGTo7Hi+2iloiCWWSkWzMFobuI+VwfRO34BSiowEBuzZnF6nx1qVvXRF4iuWJxs+yIxa9fxGyrboXslqKSoXinhRaAQmLExXO5BwRT9V1hNiKQN6tKNho5/2AR01+5P5uTHl9lib0IzK/YNiZP5mlxpav0fb7602YnNEtlf5eIYxV4Tx8lEpN5H2TEXhNHvYM3dCA8OJyQcovXtHXPN+AnH1PCpiz/oByMBDcy2dAs6E1GQxo3jdG9H9UzyvJH0I9A+cFTc3ETVW7jPpdQZpXR1Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0203.namprd12.prod.outlook.com (2603:10b6:4:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 13:34:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 13:34:23 +0000
Date:   Tue, 16 Mar 2021 10:34:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Message-ID: <20210316133421.GL2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB188641760EE646AF47CABB6B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188641760EE646AF47CABB6B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:208:23b::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0023.namprd11.prod.outlook.com (2603:10b6:208:23b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 16 Mar 2021 13:34:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lM9q1-00Fkpk-Lj; Tue, 16 Mar 2021 10:34:21 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b10bdf-4c05-4c10-c7db-08d8e88035d5
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0203:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0203C203C5C28EB9F67960A2C26B9@DM5PR1201MB0203.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UKq9T4RiVCfBctyhut4A7UIHa9XQpmJfa5b5fx8VgShFW53iT4E834Dmzk7OtjcUn9uJTPx9ueW9lHd5heFlR/MmjziGlPaWvmHEy4eOHW2WZqbUhN+QzI4Ssj8beg10FW2GXSvpjO+wUNLeJZFP9vWX2m2/4nMZTacDb/xT3vC+Nb4MMesL1F9GKaENBsLIt+s27ogBrsZcnmfNqIdHcAQ7JwRi/d2w3GZM9FiSg6Jygsx2r5N/uwxTth/bJpqeBMH+DD/Hmpef1YhAdh+0ODwrSz0eJDyRRDSnf4ABgBB/xbulX9a6PqnENPQy0G3M3WCh6kxGdDsKQJamTJ38VlHRunUP8pOIbhzQGK/MBq9hy/RieLXtimpDrFpaqEgWcrngFqA6vN6voAIxX3N6mASkC4qiuqVbHqHZD2ECj95iEqv1zDkvmTcWf8k1kxYYOS6ASHbaq/R1mOsO8m9gQmuoXOCmIKF3jbtA2UYzu3+y74323Vf+T9xZZe/f90063ecsvPPV0jTIWlKqrzfvIZ8WOsWqGM3mEdveNhjf44OUxI4lb8bxKWffuJ1h8Li
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(7416002)(66946007)(316002)(54906003)(4326008)(478600001)(2906002)(9786002)(186003)(86362001)(36756003)(9746002)(1076003)(5660300002)(6916009)(66556008)(66476007)(2616005)(426003)(8676002)(83380400001)(26005)(4744005)(8936002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ka13eQ+m0IWHlOJzvLMn6s85sfcFf/ZxIsmt7v826A6s2TCPNIK0BwA3wZuK?=
 =?us-ascii?Q?wydb6CMHU/HnVuv98bYukJKutCyf2G4yNQ9Quo/cUcC8xIMK8z96RUnMh+TF?=
 =?us-ascii?Q?c9//TJoWLoWD4Q/14rHsVz+L5JBvwcQ4cEA2clZkvO4AIAcqC2xw1MpfISKd?=
 =?us-ascii?Q?0/NHpSdySGD+VPz11m7caTfuz0DFAnNINTmT3CymhEY9H84kc4OoYyQTd+O6?=
 =?us-ascii?Q?g9+7PLihy0Bhc9glkTST0GpAcjNf+r8BwePCsNNcUjqtCMgTNd8XrUIEiHoS?=
 =?us-ascii?Q?UZhuh1JTTVq4e9ojlM3hmmb5II3i2UIOTRrTYKk86Vfsup+2GqYadzSJ9JK2?=
 =?us-ascii?Q?BDipomZOXsrLTDXuUamAX0ddlJyloWsstbkXkPAS+0R9Ube+gt8bp+2vhNXT?=
 =?us-ascii?Q?rmm8BaeyiXrvOwPijFQcVMXX82C9JFQUfLx1oZyYKBsCGNWLWnqGTFfXC3Lk?=
 =?us-ascii?Q?9Q+WgBk7Hp/+oo02f862Z+dVMIDJgFG5xAkBoVX0Pdznabto/kMHk1TfbWLA?=
 =?us-ascii?Q?WBmovdTq9pZ55huVTL6efJAIPvN6jGgLoJGS/e2aKrTn7CzGGdrWD41022gK?=
 =?us-ascii?Q?6I4oyoaZHvVpEwPrfTgZGlrodvAwGrk/9eJqHpEdvEUi65I8aIVC5g7Aluhp?=
 =?us-ascii?Q?wQCHxDd1zbaMO/g3EuL0AgvC0ogbd+vxEIqpT8aAnbg49LKn4+5udyc6/LV/?=
 =?us-ascii?Q?kjiYpW0Lpig6jJa0Ksy4UWeqy/geH3rdgqGctbujqb4WFjGXN9CKR4ShAU66?=
 =?us-ascii?Q?QMajDGnKQUodEDhVbnDLyFLOb6eogi/MemSansQuRB0H9kbyrzx9TJyMyVTo?=
 =?us-ascii?Q?DThRpnL7cPNMS71kQ97sMqH5wrKDV56gtaMe1AHE1V60fNNahyJR7aOBZRJo?=
 =?us-ascii?Q?ItYwCl941PZd95TbbhyRpwXq/M6K/9yiOvCo8ASljvo7OG6OjAJ49PtOsTgO?=
 =?us-ascii?Q?/DoE4+ybYTTnOZ9LmXG0FfQBDSxxe4Sn621ohdT2VIQoOX1NulnIJF0E8viQ?=
 =?us-ascii?Q?4OVtcaOpGlDUfolSNMDgV0V2AZo1QyDlX3hh7J042MPYRji9VLFVAlKq7tDm?=
 =?us-ascii?Q?DcXSnyfVdmLjOgFS6EPR1vn+jUd7ZNHTxA5ylV7jFQ+QCzp4T3XbQXMxd0Wv?=
 =?us-ascii?Q?/NgnWXKv+Ya4ZFtxNkn3hgZgFduDnyGbYPbTd+R1R+Es/ak66DN7DtPsPZ4b?=
 =?us-ascii?Q?i0TQn4vD8c6+UxWcfNaXqtX+MfDEcguKF/D2qIlcTlntQcyRbc0NQNRidYYe?=
 =?us-ascii?Q?iU0unL5JxRKm4yWfMjzmJA63pbwrtyYdNe8mcETy4wd5+9R6BRCb95MPefrB?=
 =?us-ascii?Q?D6p5h8x53aFwk9ZzI5NjHBok?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b10bdf-4c05-4c10-c7db-08d8e88035d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 13:34:23.1724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uB4SoUSS0YlrBXVupApD72cHcuMVEP5KmmIllleg6qAvoLtZ27hyBMjw8XlHVmbq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0203
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 07:55:11AM +0000, Tian, Kevin wrote:

> > +void *vfio_del_group_dev(struct device *dev)
> > +{
> > +	struct vfio_device *device = dev_get_drvdata(dev);
> > +	void *device_data = device->device_data;
> > +
> > +	vfio_unregister_group_dev(device);
> >  	dev_set_drvdata(dev, NULL);
> 
> Move to vfio_unregister_group_dev? In the cover letter you mentioned
> that drvdata is managed by the driver but removed from the core. 

"removed from the core" means the core code doesn't touch drvdata at
all.

> Looks it's also the rule obeyed by the following patches.

The dev_set_drvdata(NULL) on remove is mostly cargo-cult nonsense. The
driver core sets it to null immediately after the remove function
returns, so to add another set needs a very strong reason.

It is only left here temporarily, the last patch deletes it.

Jason
