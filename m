Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255C0390D7C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhEZAoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 20:44:04 -0400
Received: from mail-sn1anam02on2044.outbound.protection.outlook.com ([40.107.96.44]:41907
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232571AbhEZAoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 20:44:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYu3lMpT7CwQE8+0NUNZcHams/iHpdCVqSUfIq98rY+nDNAEcKEH7H89WHdnxpTUuDzTP+Chku56Ge0oOlDi0a6CDDA1go0ZaTTpxZXa5gO9heqQPKBd5ebdwbB3j4leUGDayePPW9uf65PT3uRo1qT3TFAp/iJWTLDiZgYxk/uTz8MA4sWzgq1h5qY/f+ArCxYvJiAFVzCaxZzALtI6bSHc8JI1o++1KvT5UPUsoBtV4Etk/pwrbV+WAjIKSBtEIUQ1BchgPdMGfNTQZVfdOeuIbJfKpz+2RDRvNdBb1Mm7cu+UsegPqd1ohcbpfsYXPkg9l+Hcl13YtI0/Ap5g5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JBpRWFX29jDEkgtmV3fbgR1hKUNeoRcWH/a4g0uJT8=;
 b=fvHvN8Ve72LntxBcrLvTiHg4CP4MNc9gZ5uW8vm8/EtO3qSkfcIyt1cRRfHPD8KQ13ZCMFY+cec6fZkBfph7hbh6Vi4QXHnzsOyLTWe1RwJLCG0CTrE/v05nzuhH60CZNedfwDfXjwHmw3GnZrl88hbweUiD252EvmNAkJ431BwzAT2wE5ESdhE2ro5m2BjAjI8UONf+L6fYY19rOO/tZZR0871GIUsBT/bmP7myhXGVP2Cfm6UuvZoXJpL300tpABKTerPiAuQMv5ISNJ2P5xnbbsNCv9OhhBkrOQz4v6nQgEW3LQVjm3XCwxV98XVBeJlbyIhEQYl7LjbIhOJ2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JBpRWFX29jDEkgtmV3fbgR1hKUNeoRcWH/a4g0uJT8=;
 b=WsxLHbhpaLYhk1BjF/kcTyVzZPkhwCClVkBMao1AHixA2d2FlYtPa1as8Sdb3sG6IMs+oUJHA45sy7O2mmBKh16NIsMkBuhdVCNcE64B9GLcPEUqLeynPQ68uR355OlEmSCmPCiwV1p5Xio1gHyE1UIdp8c126Mx/8laq6k+U6B2oCVtcB4VXhcufi8YlqIPK8jjG/oYDSHAcYioJQcO0Mnta0mFAJKVDWRBSJe8p7cteVb6YIGXtvaBwjr49syt3wcqIeDKRnUeh8yWQaas3ZgKEnhzF2eNdzCzafgcZj7HM1TDzB5fSRwxm80WZbPYua6xVl+4fJ1vh6mT5pDKTw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 00:42:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.020; Wed, 26 May 2021
 00:42:32 +0000
Date:   Tue, 25 May 2021 21:42:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>, dave.jiang@intel.com
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210526004230.GA3563025@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de>
 <20210428140005.GS1370958@nvidia.com>
 <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:610:5a::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR08CA0027.namprd08.prod.outlook.com (2603:10b6:610:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Wed, 26 May 2021 00:42:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1llhd0-00Ewxp-9K; Tue, 25 May 2021 21:42:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05c8db78-5a24-4f01-acbf-08d91fdf257b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB527151DD8C5D06D5BB9BE323C2249@BL1PR12MB5271.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gcvq2JeAzqkrL9UKsW6nZbjpPWFsyGMypFKCkR46bBCZGtoaAXqsTM03SjzBKyUfHXUqC49PlMIDxFnbIhhadK+leL1Nam5xghvfKsAPhNqly3JtVLLNozHrp//24tw5WrNoLWQBKSYSji2SXWLLZyovPz+L1pLLqi8eTGjGPIRFhuRG3+CYa0DslFtcpCkpsJcPDNNFMQ9x+bQt9xqxGzy1gjrzdvT2xrDP1HM82Jl2wHhETePBBz/kghyGncHa2PBKYiF3nfdNgp5LSooz6IlnWQBmlNmcTKJIhooAvq0dQLbOXqThBLMFBfFeWa1SBvD9p0XsZqRsT63fx9RlECWCreh/OxAh+t6iwRwwhz01tQMIozdxFwollg/Jqvt4yCfJbDFRS5JST+DlhYb92Ve8hLg6c75rhJdF0v/qGkNRC5M5MPbpVjLll2leN3OWXzehP3GPaLs7unyAKv7hQk8VaDnvymi2mMuSbAvljtVnby53GFz3HXkSmkpZImv9C29gY1fqkL8sgLTBRdR3dONAT5nhLZDvahRtodfDQMOEkyOmgGnOiG2LTT68hi0ukUMn+z1oJQX8QKPS9LpD9e1NL6NoPPVSFOkKJCCuMaGwfO+vSnQXr5VRUKQIhQe23WUoQ2txybMkBnVL/MRg6lU9Se7qZ/BJhSbNddXEx6gareqtXyERWvJ7I+C1+cQRM/XtaVO/LKSjnnSJnBzqzlDrrt7X7Egj53jEy+67tlY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(1076003)(4744005)(316002)(66476007)(9746002)(38100700002)(36756003)(33656002)(8676002)(6916009)(26005)(966005)(9786002)(186003)(66556008)(66946007)(86362001)(54906003)(4326008)(478600001)(5660300002)(2616005)(426003)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s7JnS0eLS3CgIFS0Qmq/DbWNOzc7YYNp+ucFfF0+1R7x2TuOgBcIzvF6pjYW?=
 =?us-ascii?Q?3Ib1z6UVAPx4E8qiyAWZQBheKP4SSPiBqW0IarT+lV0LZh+b9q4dXWQ9jUOH?=
 =?us-ascii?Q?8epRtPbNUQlgCBxb2tdF2Bv3a62Z/rT3fdgjZUzCG+URi/p+afNUtZD1loDk?=
 =?us-ascii?Q?HFAUYDlhbGPa5y45cZ/VpUnBRjU/I2aJPpQDaN9ZpF/Zlue1niZ5U/O9j+YX?=
 =?us-ascii?Q?txY0jpEKhBNabtawed8doJVtrzRP1hUfgKS9E2fhvQudTAt57mA0MSl02mHz?=
 =?us-ascii?Q?kdRJ9ILc37Mg1vNzUYpwGr8RqKVR9XGM+W613PA5ln61Ls6KWOn6TGaTE7Gi?=
 =?us-ascii?Q?F2HpODyzpv4I/icB+56tl+oH7b1hjFl6zDx+mxqTurzPYRidr4sncediboMg?=
 =?us-ascii?Q?f1HFQ9P3d/DlzR3SPyeYbFvYO6q0hnv28r4u3vf41CeTju+iKHR/WUYAw6Pj?=
 =?us-ascii?Q?MwO3+txtQuN5KoYXqheyCcUVDJ7EZoXwSDp3kXtWRC63BzcMUpI/yrth5Mc6?=
 =?us-ascii?Q?ulOgrSD9bTG+DZIHaxFwADrBYVmVCD1+gZqTGcduNqwUVvoq7AZfgMm2o0pp?=
 =?us-ascii?Q?gACsKJKD+SsrDMMGJIdx49k0ByIvFSCId5d9OT410/mCEFkY4CPiVX05x+qz?=
 =?us-ascii?Q?WSnrUg18CYMovqmk4FWtXczSyfKDzQgcxuR+P98Jbb4UFj9AT8lJpPQPQRWg?=
 =?us-ascii?Q?JXl0MutRHBsyRFoMNmSyA8Pm5vAi45hEUKP7WELYstPGNo6XTfe9q45B7KOw?=
 =?us-ascii?Q?8EPnGAKKneEKX6CznRTmZhUAg2TP+jbnAcGCdnrKzgSyvYhxxhX20g3zfymy?=
 =?us-ascii?Q?TUiqN2yepYkeUsmr9sp7fIcsIAq7M7D/Q0U+EF9JJp5fyZsoOFBnmvPwXPpE?=
 =?us-ascii?Q?98/OU9hJFIUdk1cMK7IHQebbGOXFnUoW7SFxAUISEgRt8TK/vBbEZ/xcRxBt?=
 =?us-ascii?Q?Ge3IjEI0SZWmmmdDEFBgviIygxxnqQIllpm1DQV+gYaN2mENBL4lkuyU/dmX?=
 =?us-ascii?Q?fgWR4x7VoVfbMSIP5YlDjrxdgCshF02LnogaHn3FRAPF/R8JGYi1QB6jRAZe?=
 =?us-ascii?Q?lh0dWwb88TuJakWe/Zu+66FYGJCpLhPadiekJv0IHWRlXnj1HJmDlbTUn20P?=
 =?us-ascii?Q?BGXEplvGdfI66W8+RHN4FefRoOQHqmWbpaU3W0o0FP7DFcWsBp6gA/GYpwaQ?=
 =?us-ascii?Q?BJRdXaT6EGdUwlppMiX9wCK/SG7iww+CZUIaXOlF8Qc0Lj+pzmLqnJWRM4Xr?=
 =?us-ascii?Q?+cGMBFC/dm+COIeKUnaF7sInK/+WUOZaj/haTNIXrDesUB1zf6u0maVcQGmZ?=
 =?us-ascii?Q?FC9P13ZHxRUiXYwT7ijUzFrv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c8db78-5a24-4f01-acbf-08d91fdf257b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 00:42:31.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF5jpr5sAjfl7/f+UJ/srZ0e5k7/752zgmzmnZgpoUAy3mwLHrskEwF6jG47DNoJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5271
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:

> I have an ulterior motive / additional use case in mind here which is
> the work-in-progress cleanup of the DSA driver. 

Well, I worked on it for a while, please take a look at this:

https://github.com/jgunthorpe/linux/commits/device_driver_attach

It makes device_driver_attach() into what this mdev stuff needs, and I
think improves the sysfs bind file as a side effect.

Is it what you need for DSA?

Thanks,
Jason
