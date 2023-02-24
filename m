Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48B56A1D77
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBXObn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 09:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBXObl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 09:31:41 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB5A658CB;
        Fri, 24 Feb 2023 06:31:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRP+cE3sKQZtIsGipo2XljNheUdUBVqkcLHLqtGu2BlbuvOvP1mHt+xcKqfWYFwa8wtrCZifS4YkrIWW5T2rWrYnVrhmS0IPqPTP9vLPRNzyClFROB/7yEyTcqgT8NNBw5ThCyhf3wOp0nkh/5b1kM2GOm26qNnoUF6SjvGtx376r3LDvb+f17gWs6UtUqYJFcX9FqAYLUKAFyv0Kk10SBnT/OhPlw7o//tH1CxKyXD8GUZwbaHt9w3DJwswDLlP/oh55j7gg4dNuEFfuD6P41XYYacsnnGkbY2eOevFfiqMraVaOoWzX1Am0UwhneGJFJlloRwu9wfHR4GAR8l8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e0DzuYR3QIHOWDfmQ5YKh6tZWR1VXDAFecOt4nBDc38=;
 b=B/5ATkAtCZncY5U5H0+4ZC1myfra44cTedaM5TQssWT4df5uYkrCT0N9XLbP8NuNyvUo4U+pWS3vkeF+ggWDzXgvz4UHcqMSehV+BnjcmsbxrqHw62+6zSVz5/Sc5VBgeUZOOwBBS+YXjmVH65xU+6+TnCeqDkcUojNQX2ZM85jZ7dfYocqKc+ZG4pNE0vpCTWnxXzbhscZaAbCBEE+F0QP+7rkiGk2eZdMP29ZvRIkw1hb4wFS4P/e7uXmImM4KwJ8IspJ1KX0fEVypW8fIDrM4eDtKQTPijP3Fc5RWp2DIYtk3cT96swnvCcAj/5R5yTunWiexgTJlKUSrT4JPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0DzuYR3QIHOWDfmQ5YKh6tZWR1VXDAFecOt4nBDc38=;
 b=oz2FyYIwNahKuOBo8itMe+fhEnVTrJNwA26gIHd2LQZcBJOWKgbnotZuw9DAAw1gKARbbygoI0BdTJLymuUKetshU7KwfCGTPFDir7WZVvwY8A5qlzbUNZ7a5VrY8v4AoMw8g0ZnomRflw8QNhlUHCgrH516r2b2yvVNEO+DKIPrwHQBrOJX96tCRw5UzIlBz1TWjTeMQb8Y+wjc19vKKAU8pmkOt9wS9l1o9Zc5f2pKU64aIUKuUoscH3Zp6xQdx94tGb31QXiltWmUnMGxn5pfKw9If59i8Hc+bsD/kFpUL0EhaTE0A+2CgBHHZ0G5LAZS15CzUayECFKNhf3HDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7983.namprd12.prod.outlook.com (2603:10b6:510:28e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 14:31:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 14:31:38 +0000
Date:   Fri, 24 Feb 2023 10:31:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/jKR/+x6ASp0LUL@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/YRx7jLuyEoLxZg@nvidia.com>
 <Y/hD7sRCLaD+/QlP@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/hD7sRCLaD+/QlP@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: YQBPR01CA0153.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: a2ff9fdb-4047-4b59-40d8-08db1673d662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLr0Ijp5jdxMNIhGp+h3BE2bVoA8D27qNneSrqp7bZTVeYHbPGaSTrIVf3u7UqBAeuLoAY0XWOea/XzzggmHBOoc+FIWJSnU4yhzPGfzGb4u1dQLypbS+k9RgaJgG/OfpeCEoSe1Vg9FoHLJi6Ma1GIWmiZGm2pmD4JsE7BhkKrIwBRB0CnFXeTasTDE6EpMeTMC+0iX3np9rR5VTtyklEMLC/jVCHy6SXZN6hvScNTrogbBqBDlQYTzHfh8fS83yQVHmirql6pBTPuKEWQrjOOrOXhWuCMcCsVhFko6PzYMmYlTymqXF3WZbKZChp1Rb9OWvM2dpvmluJkEeG123IM7PkmAmf7Iqv95kEdd3AKNlWUi7Hz+50OZVFr46VMPORxvanYvFputXTh3KK0BvP6zL3As9OvmCdzziU4LmzzqIF4LL5f+0XCxc2oheqHFf3B3dTTyd4gcBuQ3jQ7M+t14iiieItKBayCfgEIzQuF+QyaWJJX0av5Mwy9ouAJohk0d4Tfk7g0c+NjhgQBzH+TnPJCcRmcIA/Ex4bD0NJiK8565IsFR6pDSobsV/E6AvHJqcTMEBQIasID0RNgiz560HiK1OY9i3ZVyf2PNcPOZNKMbp8tPUoAEGSim+T9JEhlEHZkcMGdnnzfZ1F/vnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199018)(66946007)(2906002)(5660300002)(7416002)(86362001)(8936002)(38100700002)(41300700001)(8676002)(4326008)(66476007)(6916009)(66556008)(2616005)(83380400001)(316002)(36756003)(6512007)(186003)(6666004)(6506007)(6486002)(54906003)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/wggUyUERsYr1EE+cbyMTSt1TrKKjSOgSga5W3Uasis1AkLGnQvbIW9KbLc?=
 =?us-ascii?Q?i+HCLEfY9IQigW8IqtuXHztVeGSqsGjfbfTp/UJxhRAuCjuIu8cXTeLblH6h?=
 =?us-ascii?Q?bItJzfohZ5XQ0aput12WM1i/6ObgDe4dSdK/ECV72/7SzcPwcCnlY96KiZhr?=
 =?us-ascii?Q?AN38KVQa7sS1ftSsOGXCg0fKonh2/mLlmcZzkfQdn/6x68i2yq9sLu+HjNxE?=
 =?us-ascii?Q?vl0zdeis9VMYLbF1CKaReVr4GJ+DpdsnbafXogTUZG5EtLt89Bx+44IWmDJw?=
 =?us-ascii?Q?7UaeFLAX28AB/IWiO54obB8wqLILdrOs514NSix8VQnlH3Ov8hxBP+TZpqfB?=
 =?us-ascii?Q?34IIFLFPZH1aLheHXVgsoi540QDbISakyiWzwHGhTJsTaYXRYsqRM8vwE+vQ?=
 =?us-ascii?Q?+Ue9B8CLaHleZGcrzPJqJYQpx+rGVf9uu4iJWc7Lj786WkM/Hc/18t6C5pJc?=
 =?us-ascii?Q?ZkQE2fBTjcUcEV5VTupickeUwYM1RxOAuB51Ibu9sC1hZEWXparolOzwgokM?=
 =?us-ascii?Q?pbCT284GUvF0otFoP9eG5fIXom7yVYI7BuZlchCC3z5LU2yjpE6I1No7DDsL?=
 =?us-ascii?Q?dBAOSR1CjM1CPDnLeVu9vHhVJPXR3+d04mLajXaHs+bTqTaI9a2FFC5l+Mpk?=
 =?us-ascii?Q?RzZzU8IUavWw2364PyIvbcx/oSHQxaGviTY3azrtBAvSUm01OD68IqLP2748?=
 =?us-ascii?Q?empR4Ed+wNZN4cCN4NIHfySk08qZVi6q0jnt94lEqzhdJYQQOGSMpLbf5gXX?=
 =?us-ascii?Q?UchMQpt/5O6mK+LC9xIPoJNzP6k9e5BI6s7iSc8t1p4fL/qrpZ3ijpGhtMbJ?=
 =?us-ascii?Q?2Ljf2WZ+9ZanbQXZUi3XoethGIqfp4dNS+9bx6SylG7MN1zlL3iDulPQGzpn?=
 =?us-ascii?Q?qlXjdOC1qAH02S4gG1gfLWeGN1q827vjG0+4kUtiSXXqzdQNLgHsKi2JoHDj?=
 =?us-ascii?Q?0vU0cLF9aG7xPMJv3LremsjVMs98LlqgWvHI1fDakEW6gSdtjChdLrvq3bEh?=
 =?us-ascii?Q?+3aGwHVca8dKlLA2lxtNPRbiMPC+JKPavnIWhSG9GN4AtOD07DqgU42LIa5C?=
 =?us-ascii?Q?tnaVYTKGwGC40EU8JO2nXbW8aSvJ8peubQONG+ZifGnpX44NrO3OEOl2h39K?=
 =?us-ascii?Q?f3dl/xX2HSTTcu/IRij1HqRgNQBUJj9WWMpTDTz1wPytAan3pQAex0sAFaRP?=
 =?us-ascii?Q?zuzvUi2qPuVl6rsTUwc67gorhHbLqfjolz+1zPvFOFaFdBSyy+d33rRCc9CT?=
 =?us-ascii?Q?QgAzravO03qCGnDre+eimhwe66hPb/dJsDvd/jCWHQ6iHJE2D/x/uOF1r2KV?=
 =?us-ascii?Q?94BMa5/ezj4X+QREOZPd0/3WwnBRCty9yHftMYxhFuvXTRfbQ/eyn5MB/5vH?=
 =?us-ascii?Q?ofg9ZSgxioseUsbCwAwN0tF85DrEVukJwxdJqxGeNcy6gkCIq9hZvRuVphrU?=
 =?us-ascii?Q?V7ntfQDam6gDXjSWj5SI39vHhKeIdlfXKGcSZaG9zEcUoJ5HTSjfrKxaGSOA?=
 =?us-ascii?Q?5rzkeU21mDtwmmxm8M9ODaEoc7+Ngejxd7eQilrQYnUaAxqKVcDK63wd5sAV?=
 =?us-ascii?Q?g5um1hYHmVDvMq8jsq0k6k37rYi0fimrNRNjC1zE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ff9fdb-4047-4b59-40d8-08db1673d662
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 14:31:37.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwusn+EEj/GUfyziAh7rXsDOXUrlJsLcx71CIr6DnIu/Gxuez6lWo12oIpT1OH5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7983
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 12:58:22PM +0800, Yan Zhao wrote:
> On Wed, Feb 22, 2023 at 08:59:51AM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 22, 2023 at 07:44:12AM +0000, Liu, Yi L wrote:
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Wednesday, February 22, 2023 3:40 PM
> > > > 
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Tuesday, February 21, 2023 11:48 AM
> > > > >
> > > > > +
> > > > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > > > +{
> > > > > +	struct vfio_device *device = df->device;
> > > > > +
> > > > > +	mutex_lock(&device->dev_set->lock);
> > > > > +	if (!smp_load_acquire(&df->access_granted)) {
> > > > 
> > > > there is no contention with another one changing this flag at this
> > > > point so directly accessing it is fine.
> > > 
> > > make sense. 
> > 
> > Have to use READ_ONCE though
> >
> Just a curious question:
> given df->access_granted is now written with device->dev_set->lock held and
> also read with this lock held in vfio_device_cdev_close(), is READ_ONCE
> still required? And what about df->iommufd ?

No, if the writer is under a lock held by the reader then it is always
OK to use naked read. Best to document it with a comment

Jason
