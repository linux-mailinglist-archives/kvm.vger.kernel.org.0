Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F8697BFE
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 13:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjBOMiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 07:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjBOMiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 07:38:50 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C9E38B47;
        Wed, 15 Feb 2023 04:38:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmlUpOuQee7lYv/JY5ahT2zG48IpS50Vy35rPMH2ucKYFBbwQ9ap4K2VWu2NsAE89kj8k/4TpL+hVU7IVYLiooTirnsdBh5UtpXkjbUH4mo5XWDJa3LEelNG3vlvspX7MpzW736aWOmIm4qdGssGKqRO6p38sVLAhdeMYTSop1ufeIsPgBSXjhbjc8Uzew7MShjmvaYf/ZE6ADJhGIFznTycKnMaqH56xKGBxyakngqdu0tfkNEK696us7Waqqy41Bl/JA8REI9Qs6D2KDwrEPOXpB6+3hGFq2jZRShgbvqrPlNtasgKIvEIE54Lg7aa2g0YXPDtGtqCy1VvFzrPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rg4azEtohh6NYT1shWI76C/Qx9/ow7g0FvLSUp9p/Y=;
 b=giEmn6wU0YCOMYshDIwx//6iF9x8+AiWXhvN7uNL37gvQZvyPp5lH0NCSuSO2hlIoeLuTNGKfDLaTa5EEKNXYo0oGKMz4V5TVdRZ5bGwluQYcP675zbgZZMo7Cw3Bm/bA2t2eI/frOsaUPxj2axhMDtMnFzVD0lCg1x6znvWh/QTdHjG2k18BqAy/S6UGzfndVUqzeVoosap6gJMdshq48aJhDyrWyuGTOmij0/R9kBMZz1j90xIQK0c/9BI1V4XkP9vWonBSFMxEpgptHFdptrHaPfsMUPWfCqDE+khbbB1OO18ZvXDKeP7oTLhdF3OTrH5wMHHP3mrjHW04bimKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rg4azEtohh6NYT1shWI76C/Qx9/ow7g0FvLSUp9p/Y=;
 b=pkKoUR0dIIU4AHTmgNbaInelz6vmS2QjVRnblY/KTbfrMBPz9uAuVXkuYqA7G6hcQqpRuIyFxJrpV2G5NDkO/mvgBDAWZNkOgvid8ZlIo0MSDMGlu+N2qRP3XBZtfhoXyQphGcpTCbUHG9EyzRgyr0iA/l6M8JyJkEfbA+V4TouzBJM+WfaBRn0c4/wLDpKToVthhLpR2UwOINLnQnFhUk/NptnTq6TEZ76Q+gzTBrD9zOTjxAhgRjrANP+is0w8rFTdX6CaM5QFpRS2sDBRzhBIaiZDxCQyp66OXuBvdAwYK+bKs30rNe/6QRSoqzpYlTuH/ssBjyNoHi7YT9Vknw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 12:38:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 12:38:31 +0000
Date:   Wed, 15 Feb 2023 08:38:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Message-ID: <Y+zSRklKkL3rc2FB@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
 <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:208:237::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bd8771f-24a6-4186-743c-08db0f518bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llEzC51Tx4cPycIkVntN2azNifVmWIGSINRYkC9FgzbCxe+DII+Vjmq8CkXfl/n7BQJZ+NONhu+v/IcC/L0ijVdpp8zSzD/nOifxuIXA7TK/7LVpKH42ZUlIIUcUJ4DJKnyU+HzOTObUyDJiEAO0lLKj7oa+fkWD7U4R2LQ/N7XJKzfr+D8KiOZRT8fnjizXiH/yfEz6RGPRBfMghdDvNZWv25qeXaF2Zbcb+jxGpjLeFCX2M/X/u5wX8AJquYQ8zwHUnKHUaym1JgfisEsBdb4V9C2R1qjJallELskYWW45qjPo4qo3Ybt0U4s9JiuB7N6MRQqC3YCwaqcu8IfN6DWxl5WwJxSs0+2kxhOdtodEqJCgSmIIHou0bybbsiBRqyOQOIbdv9iTQI+FYpXXOgS8lQ9oDBHcrlf60NCcUqzLIXz+AB0xV8HeqY8es14hXhZ+nsZtDcw4dr2kx7y25m8YKNF8z3e37Cxv2F8KSzpH1RhKQDzwzGygzNWZaGJHBvnY6AbU8B7fRdoQyzrzmD5o8bmjxr/uhqfJy8mVfikmLXYBNsTCILpuSNb4R3Tb6aeVzwsYAzNLLDJSBpWQATv2y+WNNIwQSi+U+LkEi6BEFWKV2ZuY1VsFeLzbbu6nJYHgRrRq2rYIHflJDsUsAWmYmw4uBQfvzEIGfwAijQdU0A8d3dElpjF7iK9ic+s/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199018)(4326008)(66556008)(36756003)(6486002)(2616005)(8936002)(7416002)(83380400001)(478600001)(66476007)(8676002)(2906002)(5660300002)(186003)(66946007)(6512007)(41300700001)(6506007)(26005)(54906003)(316002)(6916009)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e+H5Qx8pUO4E0QQABcqsjY6pVejch48Z3EXJMkYVpFl8DYXF4PB/8VMP2npd?=
 =?us-ascii?Q?hFxdLnCjidIssLQr8hr/XefDFgbW9T4edeBnQgrZCmBPsOcrpMShVkZmxZNn?=
 =?us-ascii?Q?6GhLlglhhIKYTqY3FvqebIGBNlV6dX05fg0uMaPWXtVmA/aU4eL9vYCI19u+?=
 =?us-ascii?Q?f/IgEp39dB2mVayoyDiI/Eg99dYNfjPrkPIeKDcZ6EjKJTFxMmGC5VRkIeJw?=
 =?us-ascii?Q?ckXlRBQXnHdhatMP5qOalQkO3+M4QB8bl2UDys49wK0muMYuhYpsAmOkZJ5b?=
 =?us-ascii?Q?/46dIruCAEoHhb800FBULKlvGjtQ5eC4p/9fbD0oDgCpqgYuTHj6MAV3A9sz?=
 =?us-ascii?Q?Xf/Ods0Iydfn0ws1YK0iV4I0kBxVY3vXq9bv+aHjCpfAVpYhbs1MYOGvnMJb?=
 =?us-ascii?Q?GfIkWBfics1qAFAW/3kINtLIkaPb8IGgeOHH+vIMcf2U2SXP0VnpGhuMhYJ2?=
 =?us-ascii?Q?W96kK4cZ2wp3hWKRZTMW65IozXvYdtSMn/iyajRJzB6umOslFrTR368stuXf?=
 =?us-ascii?Q?aMI7N5744dEHACoj3HN0f0IhMg9K2EFPnWAzBgl1nBHxjgz+ddlGqk6V70Df?=
 =?us-ascii?Q?Mr9jclaySQn4sYUwM1QLdn5X7snX6a3hpg8f+KWKc22Z2f//wmwZzl1V1cCk?=
 =?us-ascii?Q?FApAGpvwdjIy3gBhrz38VKvBxakL27uR3B461TdBblJZGK45WUIXrrdmgWxr?=
 =?us-ascii?Q?9HVdqHNnmCNY6cI8sXDGpdcbEcQBUPh2noRQnRdrXEH/+WwO7gyl7UqwUuQJ?=
 =?us-ascii?Q?PjKi1sfCSTX66LdADgaVCprZPncMXg2IbGKxHNbyAcYKm/zOaCZU18J6HMmg?=
 =?us-ascii?Q?ekUNtn7QcNSMCyN1h+g3xKOAs3LiXKfl4Yn8LuvTqYAM17g6AP8pdKl8WIL9?=
 =?us-ascii?Q?ITwh70S1L6AhGPtqif7vt3T3qgRFw4DXkjIC4X3rt7PX6bBcsUlzoLbi0iXZ?=
 =?us-ascii?Q?0CjtHKFQgSuDhA+cwXZ1KGM/uRjs+adYDEyKxXjSYsI1K0MvpRe8FGuJFHC8?=
 =?us-ascii?Q?fxrB9klnMk0d8onnlxipb2xJ8sOhkBh6vA9bYINLVaV14dn/QGGuOMbfvoMi?=
 =?us-ascii?Q?/9d7PS33XyBu4ulQRuOh6hPvoo+bZZ0SQoNId3aGfHYzb8X3Pcj5MgIlBjl8?=
 =?us-ascii?Q?bABCd1uIdRy+qPI0QBWZgqQKanqfTNnVM7UyOJn5JM2h6k04X41RZFF4AUCC?=
 =?us-ascii?Q?3z9tPFGOwzZDm411vPEPXJwUxAVIVwlk1N8N1ydEPz8+xNuJHgY4Qxvh5SgD?=
 =?us-ascii?Q?kPVs9npzgHw704GHRDYsnIakXANdHedUuyGtIcJW7YV69zeQr32A7yS0GTBx?=
 =?us-ascii?Q?AU+fZuC7hhJTM5mRBCo0JFOYiJn305BmsFZoRbgmCatapLVqfTTti/S/n3rX?=
 =?us-ascii?Q?o7KzsXztm2p36ife1ZTMOvUl+lGv5WehLGu0pZfnWbFklh3LDdZKhiy9+xnf?=
 =?us-ascii?Q?qKM55idFAGo0AE20a1RpGa+CEH05MpbBY6ClOLZAvw1DpaeOzf0TXqKKMh/w?=
 =?us-ascii?Q?1iczEquitf4mQNpg4/pcnQoex22OovvpotGq53KDKkyln6wGeBvMSulUdSWh?=
 =?us-ascii?Q?YayWVvDHyoqjAP7x/FfvQlxQKRwdxfpRTl71ZQ4g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd8771f-24a6-4186-743c-08db0f518bd9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 12:38:31.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: elQcguz0GGDeL79vB4N9JqLij1pt2y5/gKnqmHr664gBCcAi166v0EflzWNMqWqE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 02:02:37AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 14, 2023 7:44 AM
> > 
> > On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > > +{
> > > +	struct vfio_device_file *df = file->private_data;
> > > +
> > > +	if (file->f_op != &vfio_device_fops)
> > > +		return NULL;
> > > +	return df->device;
> > > +}
> > > +
> > >  /**
> > >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> > >   * @file: VFIO group file or VFIO device file
> > >   */
> > >  bool vfio_file_is_valid(struct file *file)
> > >  {
> > > -	return vfio_group_from_file(file);
> > > +	return vfio_group_from_file(file) ||
> > > +	       vfio_device_from_file(file);
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> > 
> > This can only succeed on a device cdev that has been fully opened.
> 
> Actually, we cannot. This is used in the kvm-vfio code to see if the
> user-provided fd is vfio fds in the SET_KVM path. And we don't
> have the device cdev fully opened until BIND_IOMMUFD. But we do
> need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
> open needs kvm pointer. So if we cannot apply fully opened limit to this
> interface. Maybe an updated function comment is needed.

This also seems sketchy, KVM is using the VFIO fd as a "proof" to
enable the wbinvd stuff. A half opened cdev should not be used as that
proof.

Regardless it needs to be fixed for the pci usage.

Jason
