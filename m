Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424F66D8B12
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjDEXWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDEXWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:22:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9CB72B5;
        Wed,  5 Apr 2023 16:22:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff53Q1VoIPIPscGQhLsQUV/sQkCb/WnBKkplBHH8mKzP0L+kqrLVR2eTEssbXTd8DWM/3seaTX4v+oBsxhAWjmu8L7VeIpJ3rfaZ00yTZQoNWCjlGGwH/Xt/AzcVcwYFlJA5KcX4N6u2AiBWFVnvh0odWC+N5NbKEam8VdQPvrYxJ5yzrJIiqY2Se/lxpfG05/nSOoJ/xUn2WZLyh8i8BZk8y5dNHqZNt9nXxriKhq0E5urf9rw1Ga+ERGS0GsMpREmz0BwOJNvidfHMOwmSjjsnOlmU4aWJ/l36YBp0ggl1u5dGYJ1D5188SIpSnOy9Rd1dSpGO5ZQYWce3srrEPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MgMVPp2CywF/qHIP7HuraEUwLi3YjwFGTxkJNt/gK4=;
 b=jXO0pb+huIMg27l6kbz61nlB7/IvVpnb2NKL/euP97cSg9U2TFvT6HwzrHynxl90pQ0oqBi2DjTMt7DWd8Cw+gh89w/oAi06dqtVhXz02du0nDT2Y+Xdmw/XIVOX6r3NQ8uk1ZkKOljezywLjg+bukvZRoLvs/rMvVCgBJ8zyZlwdpHky8WM0P/UZXu7gf35MfSnDpknpsZro7w0vZvSCWA1YeAIUi+SNXsoRffr+N2upA2P2dyFhyWuWWYob56J1zZYvc7qChbFTlnMSUXwo/xLG2Ai/HvMWy8cI0l5kvHsnD2prJsu3DmSk2d60WQejrEwtBJQKH4+n1zKNsvjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MgMVPp2CywF/qHIP7HuraEUwLi3YjwFGTxkJNt/gK4=;
 b=J9E4y/QIFOLnyLmQch8Fbwmmm25np4WERIQorSzQm7JOcdwXNZAoNOabtgZ7o+QpaSFRKIzdfLR8S6HMSQucV5y/uqXtKvr0BF9vCk/D5EevYxJPrOcQqhiTENk4tUXMIn2qgEP9Fs1NfNTv3rM9idouX8zb0UZsClKhefhpEPk7HfZP7TESLP6PpltYrZtuKycQVsIH6clWvwylaRk2cP1/18g0hPa4ou4qTfeibod5aa0x7YEl8hUgyljHCmeQ7DI+rIcs6TbfbgqJlVYPiJplYpDZIZwpb1aXIxpws4NHTgd7e6ORfFIvWZqUvasy2ARbEh9xsq/xZCJ66Jb5/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Wed, 5 Apr 2023 23:22:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 23:22:42 +0000
Date:   Wed, 5 Apr 2023 20:22:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZC4CwH2ouTfZ9DNN@nvidia.com>
References: <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
 <ZC2jsQuWiMYM6JZb@nvidia.com>
 <20230405105215.428fa9f5.alex.williamson@redhat.com>
 <ZC2un1LaTUR1OrrJ@nvidia.com>
 <20230405125621.4627ca19.alex.williamson@redhat.com>
 <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405134945.29e967be.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0354.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5447:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d4e642-299a-4213-ee09-08db362ca77e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/0IyKtYWDaxkQGsTDgYCbnLTDw/c0bHic3ZyCPvzFNaeePFIYOdkegw9Zg3NAYEP6H4ZS/z1z14jgpymwDOkACbSD1Bhz/QRS86gg8sZg2s3N76RMYivYx+iUw2kxCg27osE1LgJ3y05QYE0h3QLT0gNELGYPQF2McX56UzUftDCHZx7rzc15JmEwxXAzLOMzHfJOi+JgOUq6i+5AsiLnJS4Z1Lcw64w1AJ62c9Q1koXRnQzAmue0kteBIk9YB8wf4yfIXciR1NEV6A7oYnFi8CzHHW2t1ub5yG6yBgedjawGk2iWdzGizuPwReYskeKItqgmFVvu6KJjDW4aQ3Gt51w00wAkzcoCtKfdKfjyawCplDo/8C6FYINZIFHSN2JWzBr/tinWgCYBb1VEi3KMWHO3Y7HrE4a6a9C6ihS9AbKFpM83kTlG5xkR+q3rG06/yVrJjV3/+p1GSeayVt4uvfNUQZF1p0m8WFdoMm2r7up439RPdeLcYmFf+pnnAsADDyqqGA/T9mKymkrxxhMgUYPGDYDP2A6MvUmrG5jd6D/CaKf1TywFrzUJuBNQlD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199021)(8936002)(316002)(8676002)(4326008)(6916009)(41300700001)(83380400001)(5660300002)(7416002)(38100700002)(66476007)(66946007)(54906003)(66556008)(478600001)(2906002)(186003)(36756003)(6486002)(2616005)(86362001)(26005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jgnOk7rbo0Czkxt8tfjJkdBnHSOXXNk7VslNBmkPnD6JnWrndl3xgx8LZHRc?=
 =?us-ascii?Q?H4mATXS05G4oxxYC8qOGson3qmAdDDjh8SHdtrIjfjIWlsNLlq7Wk4dMaGpm?=
 =?us-ascii?Q?aaaYhVPCN2y4w/vQsJFIf6kUfXtWbtyz388wzOLVaWfQHEHuFZ0bSQXsCgrG?=
 =?us-ascii?Q?20ypws2oLN0qBdOqZ0NSmHIGwcd1+9RFKkFK177kCFX79avuNauQ6GSvdMd4?=
 =?us-ascii?Q?Avs5KpQO01CEv9Akc6p5O3ukPT+aHerPtUUM1IPpFRl6SjSrg8oDgCIvQjhu?=
 =?us-ascii?Q?C0Zmpkd+rg+7yms9Mh8UVLjYIMT8EGguok70opCi5zIilaeYqhWpu5+xIfYT?=
 =?us-ascii?Q?vivKV9+/xCCkUXJZ8ms8r7Y7eWtB5TYLo0PtEgbPSoQzG4R3bX19dg/WagBL?=
 =?us-ascii?Q?3YM/IFp46ltJie/Tj1q1FEI/rH3zDZzWgW4tzP18JCqaOL16Kav/N2uRZZ7X?=
 =?us-ascii?Q?WWvIrWGdzBKG7umhB/v/vJwieTZNqcY9mD7bWps/zgqjIghmaWHuFnauhsAW?=
 =?us-ascii?Q?3T9moFMPlW5cUS1I4vgmFBsLgFhF4SJ7IEOjF9oEsY0Tt/2wuTrjWZHu2QEN?=
 =?us-ascii?Q?BE+JGQYKW1pEZ5lx2LAox2urUSoLqKJpYiElryU9qQpBpPdZPhM6mKbIz/IY?=
 =?us-ascii?Q?ADDMLdkdvRJ5pGjuHNE9/o2NysmKLmy7nS6KOvSBUVReIbp1oO2phCnSf8DV?=
 =?us-ascii?Q?WHT9fbVQzCZ/LF7eYqGdC/2Hrr4KI/dZFrQCh6kVfOgMm8GY/ZvGKjR9bm4J?=
 =?us-ascii?Q?uM1KPusSj+nn3vK+lhmQ8zcDJtLyS7l59TQPceALOh/XWixgoN+aEQuBO7uJ?=
 =?us-ascii?Q?/ULlOBqxpzAt7hro8PwYh5m8PJws9FzpfZNV2NJIPXDKceupmCJebtQO11JC?=
 =?us-ascii?Q?TMBVGuBSQnsNAEAJmFTzdolKztPovYFt5ZMIl3l1IpNRxzdNalBqJBX0xnU/?=
 =?us-ascii?Q?yvxpSDcR+uyYImeqyovRpCKABa+hKWlaMC3OKjBol1KOI2cWqTmAL0cv2LAC?=
 =?us-ascii?Q?k6OsWap0Vj2bX74X+rLPI1Oaa18leG/zfS9BBB2CZFeenITd6cIP84wdG32T?=
 =?us-ascii?Q?ZIHhOKN5JW6AWBUpDzKGawvIez+DueFiOYxFDdRmg+Lgj65q5hCsYKuBFufV?=
 =?us-ascii?Q?q/02JJD5uhWwEx5s5G/AEi8ypjKbfExsgSl8KyVVJfC0y1SI5ts9bQ4YIx1R?=
 =?us-ascii?Q?ZF69U0cvWd4B0BOa79HXZ9wUL9xJlN63HDLbui6UoXKpMfwR8c0ENT9b7B+2?=
 =?us-ascii?Q?h8u/cyQVebpultla0AyM5f0wLAHuxd5GifHMZQ2RpMvNpyWmW8VvDA3CnO6g?=
 =?us-ascii?Q?2bxv2X9pos6lhGjIRhuz3lSBkvzuPaMjLXttwYJS/fPMFRobM9dIqwUzaJPQ?=
 =?us-ascii?Q?NKWpkFnd6VWR/ZIeped03y8zzCMnHC8hhrZ61kRVJQkAOGVcQw7aYE4hn8JA?=
 =?us-ascii?Q?16PVjX7bdnd2YE93TX/Dvb3oCNX8bXhJHGaG9posiIS7vAXqAW/atghngtk+?=
 =?us-ascii?Q?5d+GdNT3mVLzASMU2dAuFCwXyvfqJIm4tG/YxfyRoMujwP8X/qK1cn6CiJ9/?=
 =?us-ascii?Q?fet2OzdSF2n8ho7nHlSZEJeeDM5qHFlGp3f2zTwM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d4e642-299a-4213-ee09-08db362ca77e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 23:22:42.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Dk+jCLlsJx6Puqu+c0updLW61XHV7pTVqM0zV26XO0R3wErxrMhS1USqnuVErXo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5447
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 01:49:45PM -0600, Alex Williamson wrote:

> > > QEMU can make a policy decision today because the kernel provides a
> > > sufficiently reliable interface, ie. based on the set of owned groups, a
> > > hot-reset is all but guaranteed to work.    
> > 
> > And we don't change that with cdev. If qemu wants to make the policy
> > decision it keeps using the exact same _INFO interface to make that
> > decision same it has always made.
> > 
> > We weaken the actual reset action to only consider the security side.
> > 
> > Applications that want this exclusive reset group policy simply must
> > check it on their own. It is a reasonable API design.
> 
> I disagree, as I've argued before, the info ioctl becomes so weak and
> effectively arbitrary from a user perspective at being able to predict
> whether the hot-reset ioctl works that it becomes useless, diminishing
> the entire hot-reset info/execute API.

reset should be strictly more permissive than INFO. If INFO predicts
reset is permitted then reset should succeed.

We don't change INFO so it cannot "becomes so weak"  ??

We don't care about the cases where INFO says it will not succeed but
reset does (temporarily) succeed.

I don't get what argument you are trying to make or what you think is
diminished..

Again, userspace calls INFO, if info says yes then reset *always
works*, exactly just like today.

Userspace will call reset with a 0 length FD list and it uses a
security only check that is strictly more permissive than what
get_info will return. So the new check is simple in the kernel and
always works in the cases we need it to work.

What is getting things into trouble is insisting that RESET have
additional restrictions beyond the minimum checks required for
security.

> > I don't view it as a loophole, it is flexability to use the API in a
> > way that is different from what qemu wants - eg an app like dpdk may
> > be willing to tolerate a reset group that becomes unavailable after
> > startup. Who knows, why should we force this in the kernel?
> 
> Because look at all the problems it's causing to try to introduce these
> loopholes without also introducing subtle bugs.

These problems are coming from tring to do this integrated version,
not from my approach!

AFAICT there was nothing wrong with my original plan of using the
empty fd list for reset. What Yi has here is some mashup of what you
and I both suggested.

> > Remember the reason we started doing this is because we don't
> > have easy access to the BDF anymore.
> 
> We don't need it, the info ioctl provides the groups, the group
> association can be learned from the DEVICE_GET_INFO ioctl, the
> hot-reset ioctl only requires a single representative fd per affected
> group.  dev-ids not required.

I'm not talking about triggering the ioctl.

I'm talking about whatever else qemu needs to do so that the VM is
aware of the reset groups device-by-device on it's side so nested VFIO
in the VM reflects the same data as the hypervisor. Maybe it doesn't
do this right now, but the kernel API should continue to provide the
data.

> > I like leaving this ioctl alone, lets go back to a dedicated ioctl to
> > return the dev_ids.
> 
> I don't see any justification for this.  We could add another PCI
> specific DEVICE_GET_INFO capability to report the bdf if we really need
> it, but reporting the group seems sufficient for this use case.

What I imagine is a single new ioctl 'get reset group 2' or something.
It returns a list of dev_ids in the reset group. It has an output flag
if the reset is reliable. This is the only ioctl user space needs to
call.

The reliable test is done by simply calling the ioctl and throwing
away the dev ids. The mapping of the VM's reset groups is done by
processing the dev_ids to vRIDs and flowing that into the VM somehow.

We don't expose group_ids, and we don't expose BDF. It is much simpler
and cleaner to use.

A BDF DEVICE_GET_INFO and the existing reset INFO will encode the same
data too, it is just not as elegant and requires userspace to do a lot
more work to keep track of the 3 different identifiers.

> > This looks like a very complex uapi compared to the empty list option,
> > but it seems like it would work.
>
> It's the same API that we have now.  What's complex is trying to figure
> out all the subtle side-effects from the loopholes that are being
> proposed in this series.  Thanks,

I might agree with you if we weren't now going backwards - 
ideas didn't work out and Yi has to throw stuff away. :(

Jason
