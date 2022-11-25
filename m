Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DBB638A41
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiKYMiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKYMhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:37:42 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8794F18B
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 04:37:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYb0jwa5LKhthNEtsECqKPfm2t+Cp4vEOWWA+MTMm91D7SGW540+R6NF5Q8/kxfLfCbRyQfDkQFqhh1WSXf/c6+CUgR51dd8OVUS9/Qxo8GNOysaSjUrZ5GnBsrpQulu/aNghvpH4hSxlfnXnjIkfgFYwsj5uF4YTHfOPRsNNqyCEvt2PhKE73kHBJBaOLtVL388iNMagiIrKxtqK0211xUF0zQ98AhGKgvrww9NHWdh40MGk/0cSw1IWKiWPSmYoxPgUNYZ4g1ySrtwK2RNYaEu7FqeODOfnsiycQT5Tix1JPX/aoD8g4F4bvIlLtxT8ta87w1rlOcL8t0orYCPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xizMNSwZPZqgerFFQeE2Mb/LDkHYt+b4sl3MDemoAyQ=;
 b=Agj6w1JN+giS0mgcmUKXgZygmbAbewuRmXWSpa+Cji1UAmGBPvI6zqZupBVI5x+8J45C2PS8hxiH0jPEJF03Hy6g6q76sDFtDE4LN/t/oV25rVQYItQ5fteJTmsMWRlheSCJJPjaSOGAbUHcZi72jm1yVzJbtpa4kgCYpxV0SD/XInXTCG1h7WMbi7autrtoqTYLUnphUTzbBtXrSkgIBufMZp5vm7V/jBvduUlFxzNtj13eMUPaSqk+lhl13u0Th/wSZzsZWvDJadM3IFZHvD+KHlAlFmvWa7Yg1GS9P686Zilbq49bMY4zFhdSt3mfv0O62sErlSR3bN+KqDbdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xizMNSwZPZqgerFFQeE2Mb/LDkHYt+b4sl3MDemoAyQ=;
 b=hzUbTk/wTto67bjXEhOE6hY8rMSaN22WU2lAROO13DDfbCG94xSEa7jkMOcRcydIDraMKN4BnWv4MeJU4kP0lNObH2WW0bwUJBBQyfsxlnUvSdjgdL95yH8xEz4PpahCPAEggcUOngkE3UEgnDts63rSGGH9n/IsG3ruZnAmxUn7gWXUAqvmoG9PcKsY6imxVv8dn49jlU56d+V03Ls9VtjBv3Cu0dcvG/le55z/pJk00N2ai2sQnKitqyzWXEg4bK0zcd74hQFglNANNl3WsR8xcdwDMJXJJZiTHg0Y4P7abMZzACcMXup0uGX44wlualya87Z97gQu08J5typihA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 12:37:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 12:37:07 +0000
Date:   Fri, 25 Nov 2022 08:37:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Message-ID: <Y4C28lraaKU1v8NE@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com>
 <Y3+GHbf4EkvyqukE@nvidia.com>
 <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
X-ClientProxiedBy: MN2PR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:208:178::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: e018babc-72dd-498c-2a96-08dacee1c3c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7eRu36mqqW26oEAbRw1EM4Ra1K1TaK5HVl/gvJLX6wNjZfNA8gAP+A0EAHPc1yeGr+VkUjkBrjkzsYykYJe7VQmUfeRy26zqW1lISijnhO8DvQoyqRfoELQaBpPw+i4VtklqpB0CsiJcZhi/Ss3+l3GyW9AgRLqV4Yevk6oTeKxH9Vb/5uM0Amrov/vQeE2WY7WWES3TqQjhZVSQLlAibaIz2BuAuUmV/CGub1mgeLAGoTUciAioS+06RJRdaWT35DB55gP9mBtCqC6OoWjTCVY7y83we9YflhDkeN20eXUh5kKnST/RW3OOCkaKABnz9IexNMAdatYO5pBmPBX+m6pV64aC47C9ZBWxxRGQanczHUrkpm6ArdXfeP/q6OKrq53m6cCMQWoOFBJo9P6PPkeW2MS1w/eTo/wywhlLp/x2Un7R+ujFZZjH+mMRWgBYDUafwFjKc5F7+ZjJjByn6lXD8RTF2bho902iGdw20JrqOTZF/wmWNcu4ouMu/Wz652RvxdHZ5/9VrpP/03fZO06TVE2SEpcojGOXP+vzkeDow8cNbi7UPNXlyct1DaGX1V0yymo3d9+Q5g0bbZrZxCiZyVNQPvOIAX5umW4eVnDC57Tf31k3KZILGtHzey3WIxoObBNEaw6RgEi8jXSsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(2906002)(66946007)(83380400001)(36756003)(66556008)(8676002)(4326008)(66476007)(86362001)(316002)(6916009)(41300700001)(8936002)(6486002)(478600001)(26005)(6506007)(6512007)(2616005)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tSqx4/+VFen0xWKWXjPvV0fqCQmFrxSe3mMyEMpLbVlzHEeq8PH/cY8isur?=
 =?us-ascii?Q?jGxw635kelWcoVQThFVkg+Sn6Pq/lr5NYvk9jFSN+khRFzKXySv+FBud3Clq?=
 =?us-ascii?Q?IiVj2MEw6X/n88eYWqMtDyHVZOIK7y4dv4F0ZjjpafvBvu9xO49js58BG8ph?=
 =?us-ascii?Q?KO6I6zab2+1o34PF8LJnBXyKmoPr58a7wnPn1CVGoOytey6VWz6AWOaGB3WP?=
 =?us-ascii?Q?9mNAs6hVQRnd5ft+1kRqE+i+l87StWvZ8x1WBD3ZuPBeV58aG5WGEXS4qB28?=
 =?us-ascii?Q?RFizOAlKD7p/vbIIRId2hSBDBPxMr5qcvFt3d95esN2vTOltJLDJ9mFEyG4U?=
 =?us-ascii?Q?Ykjcga8tIv56yDiDLTvrMy3gV5clbTFI0ZnEuHBmCbze4BNWTl0lzqIuvoGU?=
 =?us-ascii?Q?edtnYZiwXSi4jOhunxSOzQSirnMCgoMU7fKVX56SG7JBEkIvSa4EuSWsG/xY?=
 =?us-ascii?Q?YdBbeKmrnUgeKXPVmcksJodms9DfypRZSV4tlHp0CoVTa66WTAjtwqD/q2q4?=
 =?us-ascii?Q?tR6VMGu4EqbhWENtWrmukoWgX98Cmw0fn0gHs2fFUifgA/TyyHMP7WlAJvht?=
 =?us-ascii?Q?7dx8AvKofLaT9212ydSqWTrIjo+fXBRerJ/Ml1sfGwZ8VWYcmNnIlbyHvYXj?=
 =?us-ascii?Q?xIAQXTb7BDOCH/e4A0RvfxPHfxPFUwcvJKRW3FpXxHNdo5MxVHajZ626FP/B?=
 =?us-ascii?Q?O2qkVr2S2Mjt08Zi23s3rpU91B052k2drKBts33mZWuOfo7cNoFEmfeenmtr?=
 =?us-ascii?Q?iEBXkxaXgA+ST3OtO6H0zndpcfI6xDdkJWWYZ7R8HeOMXMDXGz995dsHdLrM?=
 =?us-ascii?Q?7rfwV2xCSrZwC4au+QEmFpIPoyeqtJ2St0xmfT4TBS+oV4lTODiegV+9FDwW?=
 =?us-ascii?Q?MoN6HTJ+5DrLYIoHsbg9TN+SlxrpwIqM4nx5fYjkRvguKamUwOFo9XY2Zp5e?=
 =?us-ascii?Q?Li+AOOX7+HHPbHKGiYpNARrfIVxwJ2lk7Pp7yZynCf5mef4dv4Dyaq0iEc7U?=
 =?us-ascii?Q?joVorKbAFb/FVXD34mzqHbiRvfznBtVWJSlXYPK3kH+Ny1Gbhy2r0Fl/Mf2R?=
 =?us-ascii?Q?ITkkiNqnh8+bydG4zsjaU1wiEd2VerpS1K+pW0VLDlIGcIT5bKna/3ktg5hZ?=
 =?us-ascii?Q?BhSixrkxhsRhydLkcdVZYS9EBsMzJ4w0BW20SYdUJOaVUXCW+Mgo3mone06q?=
 =?us-ascii?Q?MSd7ib8sNBfmA5Tx9IeTvCszvqoeyJ3gWZhZWNNUUb3+gly8bhTS1fR2L5vw?=
 =?us-ascii?Q?sNMT51lA3DbHT1+6sDudTPTsZQ5CPIWcetHogsLwAjVjX+tSOt/h2l3k5B8E?=
 =?us-ascii?Q?FmTYJpIhBoakZjND2Hktbt0vJKb/hakwmGXyif1SAfLyhHA2qccz7EjOGlY5?=
 =?us-ascii?Q?326MJCYJvvB2ZE3dRYU7bboqD17lli0Vu187X9+AWKFDU+8Xh+9cQPyEHREL?=
 =?us-ascii?Q?t5AYKzzmGDZ4VdTNJNaJklnDnQ7uDwkvcPAK4tta7LLJfY6yxKumLpXUpWqd?=
 =?us-ascii?Q?9VoGilcW4vp/GB0dC7edxeJrnaL++gG53/Lj47mpmjXDgetSpQ4+1NP6QqlF?=
 =?us-ascii?Q?teDliAhinLsDVB0kCgU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e018babc-72dd-498c-2a96-08dacee1c3c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 12:37:07.5507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYI/kAPcB4gNKz5EQNKec73f3uN/Cs9LQ33KC/BQwxm/VtU/i2cvL48xII827+2P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 04:57:27PM +0800, Yi Liu wrote:

> > +static int vfio_device_group_open(struct vfio_device *device)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&device->group->group_lock);
> 
> now the group path holds group_lock first, and then device_set->lock.
> this is different with existing code. is it acceptable? I had a quick
> check with this change, basic test is good. no a-b-b-a locking issue.

I looked for a while and couldn't find a reason why it wouldn't be OK
 
> > +	if (!vfio_group_has_iommu(device->group)) {
> > +		ret = -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/*
> > +	 * Here we pass the KVM pointer with the group under the lock.  If the
> > +	 * device driver will use it, it must obtain a reference and release it
> > +	 * during close_device.
> > +	 */
> > +	ret = vfio_device_open(device, device->group->iommufd,
> > +			       device->group->kvm);
> > +
> > +out_unlock:
> > +	mutex_unlock(&device->group->group_lock);
> > +	return ret;
> > +}
> > +
> > +void vfio_device_close_group(struct vfio_device *device)
> > +{
> > +	mutex_lock(&device->group->group_lock);
> > +	vfio_device_close(device, device->group->iommufd);
> > +	mutex_unlock(&device->group->group_lock);
> > +}
> > +
> 
> above two functions should be put in group.c.

Yes

Jason
