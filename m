Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D4393182
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhE0OzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 10:55:20 -0400
Received: from mail-mw2nam08on2046.outbound.protection.outlook.com ([40.107.101.46]:1200
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229793AbhE0OzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 10:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDxIO8Xi9W6ZSqAUSA5vcj6n9v9N2e93Y9+P1LdMnlJL9xgBexl+fXdRmEaxn2QV/ZTSBIdTWG5q3Jr3BvT7PdGJecFH08MIm3R5rWpFRF8kuC/sO2NYuPog15495XEmZiw0t960wQOqE5/x+wJ6dUOlwdIyfD3ijabL8kVKE/kqjXnCHNRzSePswIIgME1hZ8FN8JwNpJiZp5RzItdqgTKuJ5lLIGRIZx28MUQrR0M0P1Sgd5R/3UAsmcQRNFLnTiYvyQa43wljfPdEfa/BRLxNy3c5uuM4kHsRnKF2lVYOrH7e7aybWh5Z0T0aXVljlXb4aoi36eyvOLk/KU99JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK60PwYpj3/BE9rfhV+XP/HnNQW3aZFTyqYDNBV8jOc=;
 b=b5Gy1+jTWlTaSx0fAT0ZFvKewYjFXU7omvQM/dQxwN9WXyvmunRYywARuuTD+yoP3xWlnb4JBGogwZspij+b39idRB2i/unHHLgSeu6kS35tiq/SfRZTmW+e8HiGgYzWigUh++ykf2RVY/9zxgTwtmxHANqYLIg/NNknpknZaZAMLoU9z3fHMi79CbQxjmdBkOKTW+8b06Iz7Dc6xxWI8DLrubfHaO2T/14EvCb21lFFtjAoigODDc2cEEo+pejSdgs29cYMHdF8yHzxEvPFioSCpFAyiSX9ph77o09h7zQ0zvEQEMeEOq82i43tcjrLsAaqneeUqO/dJe7BO2h7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK60PwYpj3/BE9rfhV+XP/HnNQW3aZFTyqYDNBV8jOc=;
 b=aHHDBCgo/P1IjTBYzLEcvwwHoRnbDntZ9rtoStl8/VjAbZOcI25OgeD62iTIZiEOAaF+BZaGhTsnt8aNbU+o0IytFBVjW9Bn2U8WqLeGyieynxXRpOmOLUQitioN0oNGvfUDxp4H5RotXs1chJdXYbbC65yS2OeLDRJpZawnCKy/h4lckJBIjnbzmTKuL/3pDpvZCY2BevHHWfoTH8jh+ikvM/Srao7Y0kFWIkLzCfOsXuMle2aa8FexW+dpTylGgU540ndp9VSOwSW1KvL0PD8sbV0PUtXRz0R6kTqjAgyNz8aB5bxtlLTjAk8JPotDi73MciIunAAU5QnTsbooCA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 14:53:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Thu, 27 May 2021
 14:53:44 +0000
Date:   Thu, 27 May 2021 11:53:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20210527145342.GE1002214@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de>
 <20210428140005.GS1370958@nvidia.com>
 <CAPcyv4hnjX-HtoG08dPbPxJPeJyvnO-WaJosoY1aSRqm5oo14Q@mail.gmail.com>
 <20210526004230.GA3563025@nvidia.com>
 <20210527114452.GB18214@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527114452.GB18214@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0113.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0113.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Thu, 27 May 2021 14:53:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmHOI-00Fait-Ah; Thu, 27 May 2021 11:53:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1f37161-b95f-4a9a-83ff-08d9211f394f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53025E22F9CB440CA6B85F8FC2239@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QLf5Eg0k311fER23mX2tAlfjySI/8VCMrmEaye9LK+Rq2Bpn77W6Ei8R+JJbgQMW9x+5/8Ulr5fmuVZ73hRiakKv28tgX0MAEKNknDo9TMqiBBk7hhkJ6YOAstI85aL5FIFz8CgM7V4gH/XokLdbrf0JGoVnkS2A9Y00d9jezKTK3hqhodG5LuNk/Airqn4MZJm1RySeBm1mKnVLgBuKDFMAzLEcinWSCB1Cjsa2wpEHZQ/zj7LzSRFNi17BLXA44xPfX6mFYTMfBMejBc+qapk6bNzAun73EIYJ7L6tDksBl/KzLlT0OPEFqonQDGPE8XsI9OOIBxj8QOFNIl610sV+BX0strsN7j6wlvX+uKL+gzvI+L3jbN5NS02FC491dBrTGd06t46JBkaXqb+OP6uJfFId7PtvppnvPExfpoN+F6x6Gf/kNzlgNVoDW6Mq8k2yl5jspKuJYiO2AVK2Dp1d+AtDCPKIlfgB5Y0gm7N0rb4KvOd0PkWrgcjLs6YoK+VHaWGZWCc6rReayn8xkVdVa6O5+3TGHl0iZP/4pUrre25DDbIlEKwpUwAKWVnqhWUvgc3GQziXTtH6E8pLLkybyn/aCQ32qpOm4KBtRwR+ROy234evIyTWciMOcz3uREC3cpH88sB+3o8tJuy0KUk1SUxMOS9x+pK7ASrwMog0KTFxYVwtM7ejbrVVT0qE5UUarZEE5KPG7mKAEcHk/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(26005)(33656002)(36756003)(2616005)(478600001)(316002)(2906002)(38100700002)(4744005)(8936002)(9746002)(1076003)(426003)(4326008)(86362001)(8676002)(5660300002)(6916009)(966005)(66476007)(9786002)(54906003)(66556008)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cz6hYg7ue2BADC7iVhDpddxxMTkYyawzmHLxu+Um0G5x8Qu8YTnLqvBQgtwf?=
 =?us-ascii?Q?p+KXdu7YHy5dbmuhL8GIAUL5kPNZc4FbpmqRQUUKxI5V+fVaGGttrByoZmcH?=
 =?us-ascii?Q?hNerkp8jUCYMjhaCgBUqr5ZJ6MmRXbZ7BVAUWrVbjwzvSfAQLkEutI26vSe5?=
 =?us-ascii?Q?9FzWCV97G/LO7ZA02OqBk+rgJqLJOgrSSwBCQUwS3i84UqlXtlNWf240dDYV?=
 =?us-ascii?Q?pwl4QPFX8CchqZ5+3joI2reD48Qj9buJh0Zz6AC1GHy8BJNtrxVmTsRyy3WU?=
 =?us-ascii?Q?9/kL24/ThEP/Qcg/v4lpHAdsHWYT+I7Wni0zvvr9KBQwnyjH/6pKeCeZwE+R?=
 =?us-ascii?Q?IjPaSOnf26AEgQ9//DMjMXPnSjA6WxamnlZqBfltJem//Kw18Sd1fsl7o+1N?=
 =?us-ascii?Q?MLZomz2TIFU3O1hQDwjogEjqB1Y2unAlAaCShYLgvL3J5D0pXKnMs7NaBdAL?=
 =?us-ascii?Q?lrWGZYnHRt22Mj57wf8xp4QBBJwxmuM4p+NLx24cxLBDnWsLoDOleF/IY0uy?=
 =?us-ascii?Q?b5M5tynePK1xYmr7GsAhRGlca0jAk/+HOZwPhlz+m4NMpD/0rHVHAvG3EWfY?=
 =?us-ascii?Q?RLLStliF011MvJF0Ag14n6+5CJHYhmRDZxKwReIEpzL55N64+V5aO3KsCeFU?=
 =?us-ascii?Q?/rSTfrS76XVIACZUJQMQ5XSEYAEmIS7gspLKz+8ZEB1ZmiIra9u+IMHs2NPY?=
 =?us-ascii?Q?2xq2fWDK3cgV0xqrQuUHn1s6KitppOUnOQqEfqOLtbg20W/Dw6ftsz8F8coN?=
 =?us-ascii?Q?+5BxJUCWI4AmVwM6daJjGm1v+5sSUGejVDMeNh2qJJb4qJSG8FSf6LB8l/6u?=
 =?us-ascii?Q?PfiA0GSIn5PZZ8v6C1wfrCmz7hjHY9wE/ewQIQ5yoTJIYTOk7On9vjn/XIzv?=
 =?us-ascii?Q?Dqh8x/2bn/hWfO6+kw3/VhJ9giHl8BMUQzJ7ny8o9tnUaDSRbgqCuty7WIRO?=
 =?us-ascii?Q?171EQX68qldPIxBUyNaGMFvZExJEhH8AlzaIlMc8nZDzlEKKgdIInXnVShTx?=
 =?us-ascii?Q?e4VlZjhHtaUSpG0qLs0ANMq1UjTpI2dTfIYCZ4JeXXIG1dfLmRsqE+LlzXiE?=
 =?us-ascii?Q?lxFN7YxvMp57Iac+a57FGBHmzQeWQdzR+2LSp51smHmV73sKP4yH4FgnAvc3?=
 =?us-ascii?Q?PBNpjT9LD4MlKmxxlOWBte6BRZSAAF65xIQ32kwLOt/OgpTaIdIZEhnO3Pnw?=
 =?us-ascii?Q?D5f8qKp2M0Czzth8IVvhTRTJRHr8Tnx5Hnicx4faprAdorYoM8fRAxZ/zFH9?=
 =?us-ascii?Q?tlzGgFv1SlUAeJPDGBFMo5up0I1VLGTcvoX/fPMtrXArbY6CjlAWKWWqxclT?=
 =?us-ascii?Q?v6JH2guDKSPVAxtFhABknmxu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f37161-b95f-4a9a-83ff-08d9211f394f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 14:53:44.0264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hk/JShx1MiwgJA1UsIY8jy7Dq6U28S94GIqaYrrQgaLMBZCttEcymk9UkCGDxopZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 01:44:52PM +0200, Christoph Hellwig wrote:
> On Tue, May 25, 2021 at 09:42:30PM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 28, 2021 at 12:58:29PM -0700, Dan Williams wrote:
> > 
> > > I have an ulterior motive / additional use case in mind here which is
> > > the work-in-progress cleanup of the DSA driver. 
> > 
> > Well, I worked on it for a while, please take a look at this:
> > 
> > https://github.com/jgunthorpe/linux/commits/device_driver_attach
> > 
> > It makes device_driver_attach() into what this mdev stuff needs, and I
> > think improves the sysfs bind file as a side effect.
> 
> This looks great.  Please get it out to Greg ASAP!

Thanks, I need to test it all carefully it is pretty tricky. You are
OK with the funky in/out flag? That was the most ick part

Jason
