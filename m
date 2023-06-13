Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C5E72EA0F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjFMRkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbjFMRkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:40:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CFDAA;
        Tue, 13 Jun 2023 10:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHqeDR1Nb78D6wPQ3BXRuhPu2J95SiuZCz1XMmTlna6OEQKF9hJhHUi+NSsp30S/vR6XrL5T+Wf5InL62eK3jPUzzwg3lpHGFxiM6yWbrVLNddmM3R4XkYfQ7iVDWVNY3K+V4bhkAIKh7sXS9fhy1uVI5nplCdez1Nn4z0O2ZKxI7s9rgR2usxncPErlugweKS3qo+Ka7tKbf5goGvm0zMcxaFsAEWwQWWLmLbP+WxAcE8ByI4cbcmVsYbvMC5qVJcDKcfH8yzos4pnHSzQSHcRXyjSTBNPWrqG4MX8/g8e5c+FdsazoipvTk0M/K96xJTyuMU+ZZP+znFlTtKo1ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVj50uJtxUbR8LsKpR2S9+yMnv5LAyOfTnZCqu6d74w=;
 b=lhW03x+8gIAG5uKYcK3hRZUlwj4hXSsj9KgHfNWYClfg+C7FlmGvlxaD5CA5EcCRZy+swdEG5a814yFucEds1FjqwGOmbhZI7Ebey75zpBFoF5jV08dwXq8k2gUwHBwfGtLZ0Ea/ddcAePEBdeVe5k6QETGMaa0O6uQ94lt+JEGAvHsXtIb9VdZIVIkHli3RHfX2D0xGLEs6z3iWiMEyH6ss2EdT+sFe/7bflvlET3opuDgx/vo74isLrtWUO0PPDICaE6Irg6c8KBX3d9rfKLC1EsZzgb2TdzBk3DKc+fZH/DELbXWPcO7S0ovUQYiX94OaSQci9hlg0HhlYia9eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVj50uJtxUbR8LsKpR2S9+yMnv5LAyOfTnZCqu6d74w=;
 b=Te2V/eIpcT1QGtR/N76xxY3HgtefbE4PRpcyndjrNXzsi9i/k6UC62iAtrTRO56/glqiMLKxY43jQ4tzFq63nKSqTl4KpknrPZqvH3bbJSqgOQ+DB4MHLGTgLQQdkusB/SKNgpciyU0hJkpdeE0/LDFH2e3kJ0JEoyUzEqgMqX+adDrOAI0je4dpJ4TflpHDNX0iwBr2Yhu5LH/rHkyp93m9KUOmIJdHVv8m5JwziaQoVXIEu/VGXi1ldkrIxDAOfuPZuZwMSUIGRXIlbi9kTYonxRSNxgdQBzBW+1nkim71VjlgKTadAYmXbnxboMpJrdXbsN7YuY3WdPveIU014w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8690.namprd12.prod.outlook.com (2603:10b6:a03:540::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 17:40:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 17:40:14 +0000
Date:   Tue, 13 Jun 2023 14:40:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZIip+nGKr8+jZb1z@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com>
 <ZIhXMmYjCyUdlGxe@nvidia.com>
 <DS0PR11MB7529CFADCF0D6D6451E4F92AC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613083229.44a3f3ec.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613083229.44a3f3ec.alex.williamson@redhat.com>
X-ClientProxiedBy: BY5PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b9f322-a4c2-4e01-a7e5-08db6c353e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 569GWIK6NbY84ZvZ4faiB/ED2kPl0F74scdPRGWTOi83GcrZy18qZS1iQP96ulmlcI7KFttUAGv7rjrtJRvv/kIcuEd11CTdlg9GpLcrM27+MQJpQo8cBohKxuCssrPoUBsxj5GpToMd3u0XLM/ZbzSemS1Tlj9W2s+rDUeE3UvzkJY3AA5aKZNBWEHjMOaRcd5Wz5mHzjN3Gr749LtsPqngFqNwdgvHs1fm/FF/GyjD3CM1IL40cERKirngK/foa897S6lILCkMG5unu+Frv05EWzhC0OQ7y6J4HWolI/8tGZnd68GuqkGmty+5quYJ0ezCQArvdu8ujlLgU5CdasnQVvQDMj2QqRCIOYelH+f+GkZw9JUNbF+jOCXFSyb21hwEnJwxp69GyrBnENFMghknscbXs4acsEadyClCprcLCp4OU+AwSWSytkeNmi5UxVAcQoaG9cHrolAnrz/E8OJI9BT9D7hRdU2FvwlDZiJkpMSDDAuSwuANLq3Ec+Qu+feHoY1hTWycZew1tWy0sQfloyaKBq2B8uYiKM7MqMf9z1bfD9RSQu1+QqoMbLh/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199021)(36756003)(2906002)(7416002)(86362001)(6916009)(6506007)(83380400001)(6666004)(5660300002)(26005)(6512007)(316002)(66556008)(186003)(54906003)(66946007)(478600001)(4326008)(66476007)(38100700002)(6486002)(41300700001)(8936002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LgvwNPrgXJorT6BCSwVBX7LGxzfT0DBqWs7Y5rh4c+WjV7xRXyPEXCRpvWH9?=
 =?us-ascii?Q?7g/uetW6ftc2NCbck0Pn+5P2TAeCc2a7MCe+yHGnzI5h9o5Dp5OtplOxapSl?=
 =?us-ascii?Q?aqbRZ+ZvPkGYERX1y3wqGrREabHT4OJSm00d8qSKEqpr2+hppk7qq8emsgqe?=
 =?us-ascii?Q?wlVFLnm62EMDD1r3WydkxBggxFbuML+UEKJ1HSvhiQjIpgWrS78XaAXyRm7a?=
 =?us-ascii?Q?r1ev01nUQq+X93tAvvZQ6qelON9Hal9OBhOo4mqFEqPwV08RvX+IuLc4cNKE?=
 =?us-ascii?Q?W4WzvyOYQYAMKCitHPwVv0msUKctAtxwwPTToHURqC+QvNooMwf1eLwRcz6x?=
 =?us-ascii?Q?KtnGeNEuC2sN7BO5B26s7g8+jBjI8Ho+Z2YVdOHL35k0AVpAgf/KwSczkMmR?=
 =?us-ascii?Q?/C1xJ/86JJRKZmlK0tNT6JLILJa7/uZe/2YgVfFYhDfp2KQtldzhNZ69/xGb?=
 =?us-ascii?Q?dlJSR7akYVXHxfe+fvc/u42csSAWEHRBf2+269TSEFjR1ZLfu0a/Yvstq4cX?=
 =?us-ascii?Q?Re8jyB6SQdnhy1KK2d3qOr8TeudlZYoEayPaka7hC8HJ7UWDb4uHGvfCpILt?=
 =?us-ascii?Q?X9tZZUxV9Cu5dwtboHro0BDq62QQbb0fXiJvH9oAybxjzZg8TihPSx0nO5OI?=
 =?us-ascii?Q?Qc65T/n+t11DlJLrm1qTVWwHqOkxYbnhrkLRS4hIkmYktCUBhj0QAf78vVXe?=
 =?us-ascii?Q?YhAUi7pdhU2k+xe0Dfpg6V4NnJFOGdIM5RpAVSaD5n/qzGFkOgR9lyxQONiX?=
 =?us-ascii?Q?Apnmx38XPuq9bjVcY0FIhNtjTJ0VilhvAZqto0fJOfH7gFBM+s0I3/PKBpnc?=
 =?us-ascii?Q?jVFWpRD6duvUFoFkukLlSbqDa6uAZNMLfC6wBSvrT+BkQtsWijrqQktb0bS1?=
 =?us-ascii?Q?yojdZDH0eSxnYTBb0Jn/8BetV4meyKk/HzMVX+MJmhhbz0jjXFcRRoQEffV+?=
 =?us-ascii?Q?4PReLNEtFueHlupdcdaK0jyfRyOWipRckfHHUsdwnbssSvUmyVtvuPkTI1F2?=
 =?us-ascii?Q?qt+uW4V5+pw1etb4nGcw6Fga/vwW+JNp+VUuNlbGR/QQKFRUXFsK4ynqm24E?=
 =?us-ascii?Q?YYi50ojS8qfeSIqsykFm/CgF35Q9p0kThZGvWJNI5AiPDP5ESP9zFDLYX/q7?=
 =?us-ascii?Q?sGNxVqR4sDlCiQyIXkbOgx80tsDpHLVxTvJVQND66t50Lwsc66oHnyb/NUKw?=
 =?us-ascii?Q?K6euNrhT8lfeP1+XFLLVoE4Vm+jKQNq5d0v5oi5Lyax4UGSJ2r8Q6wEyeYVV?=
 =?us-ascii?Q?lcGV2FD8LqegvKm+KyAwv6kTTYKk+tfENtHpcBmTmDKTbJTUph9N3Xec03Pe?=
 =?us-ascii?Q?hAWOqmIu1r68xtc0D6AKbousc9LtiGk2jbB31/a1RCy3SwFbowq74iNaedZU?=
 =?us-ascii?Q?Bll1T3DYvqBo/zjuFM/uhgabmyDZ2uqsymMAHuyRjgYh0zQqwSyBoe9HUfP4?=
 =?us-ascii?Q?jMlFl74rQRwGhYO3VOO6SIsJpqQrmSHZk6YKHd6puXigYego1hvCOfm4sc4x?=
 =?us-ascii?Q?Yb+2wFbPJ+Fg9o0QF1e5NpcLdQ6jjG5PH5WRfy5N+whqpvUsNEKqsFsMkQkU?=
 =?us-ascii?Q?URPkOvjF9jgqNMGD+NpSCsQy6R02dqItiZyFoGvm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b9f322-a4c2-4e01-a7e5-08db6c353e07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:40:13.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/iEmoD54tpWPUEn+xqRIQYqMe7cWaijIBvEr5m3EHiIlHyQJtRb20do66dtIRX4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8690
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 08:32:29AM -0600, Alex Williamson wrote:
> On Tue, 13 Jun 2023 12:50:43 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, June 13, 2023 7:47 PM
> > > 
> > > On Fri, Jun 02, 2023 at 05:15:14AM -0700, Yi Liu wrote:  
> > > > +/*
> > > > + * Return devid for a device which is affected by hot-reset.
> > > > + * - valid devid > 0 for the device that is bound to the input
> > > > + *   iommufd_ctx.
> > > > + * - devid == VFIO_PCI_DEVID_OWNED for the device that has not
> > > > + *   been bound to any iommufd_ctx but other device within its
> > > > + *   group has been bound to the input iommufd_ctx.
> > > > + * - devid == VFIO_PCI_DEVID_NOT_OWNED for others. e.g. device
> > > > + *   is bound to other iommufd_ctx etc.
> > > > + */
> > > > +int vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> > > > +					struct iommufd_ctx *ictx)
> > > > +{
> > > > +	struct iommu_group *group;
> > > > +	int devid;
> > > > +
> > > > +	if (vfio_iommufd_device_ictx(vdev) == ictx)
> > > > +		return vfio_iommufd_device_id(vdev);
> > > > +
> > > > +	group = iommu_group_get(vdev->dev);
> > > > +	if (!group)
> > > > +		return VFIO_PCI_DEVID_NOT_OWNED;
> > > > +
> > > > +	if (iommufd_ctx_has_group(ictx, group))
> > > > +		devid = VFIO_PCI_DEVID_OWNED;
> > > > +	else
> > > > +		devid = VFIO_PCI_DEVID_NOT_OWNED;
> > > > +
> > > > +	iommu_group_put(group);
> > > > +
> > > > +	return devid;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(vfio_iommufd_device_hot_reset_devid);  
> > > 
> > > This function really should not be in the core iommufd.c file - it is
> > > a purely vfio-pci function - why did you have to place it here?  
> > 
> > Put it here can avoid calling iommufd_ctx_has_group() in vfio-pci,
> > which requires to import IOMMUFD_NS. If this reason is not so
> > strong I can move it back to vfio-pci code.
> 
> The PCI-isms here are the name of the function and the return value,
> otherwise this is simply a "give me the devid for this device in this
> context".  The function name is trivial to change and we can define the
> internal errno usage such that the vfio-pci-core code can interpret the
> correct uAPI value.  For example, -EXDEV ("Cross-device link") could
> maybe be interpreted as owned and any other errno is not-owned, -ENODEV
> maybe being the default.

Yeah, this approach seems logical

If the function is called

  vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)

Then maybe 
  ENOENT = device is owned but there is no Id
  ENODEV = device is not owned

EXDEV is good too, nice symmetry with ENODEV - it doesn't really
matter since there is only one caller and there is no embedded errno
propogation.

Jason
