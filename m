Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A949E697EB0
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjBOOqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjBOOqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:46:45 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F09392B3;
        Wed, 15 Feb 2023 06:46:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jd3+YthiVOp2YsOsh0ZvAPTpWRudoDf3QNKCdatnYME4HcyHsKO8mN6+w1tF2uB0MZw4Yzqy1mcquG18ThNL+eL0e+nXsQFeO+bt7zvnzXWkVoFXEHF0ionIsbCBLYAdBJvOrS5LrcAD8qGT//FbekKqQszMWhU7nYCcuqR9caK7UEO76BpJGerVAS8JKWS0H55iZjgrarrxt5QY3LMrRBK2e516So2ifan8d0BrCWCw+6kapbyfdE5wCj6jXJJ5lgNR/izii5xIUXykko/3+yoDvJusZOhYQfHkCwyiPvFt9OfB81dNZEUCuDP4L/AiJ1B9ROH0DdOBvlsp0xwVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6agjH7GPwSZimORMJ5ftRDDNJL6moNpVExJiGRMP82A=;
 b=Y+v/oaJgDVuvj41hHvdm5rdLSc8ci7Du5aMBAL9Ee4nXjHIaNe2ljp7Uc8AsEOdnAuriLC1KaQkUJBbNubsljvNwSMh/YhIqQgcdY69b5yLDvuruqphIPCeiI3G9T0v3jmw7M1U133+5NFcjbXpvTftft/Znw/tXW/CoZOF/exTRoCNvIDNAsNSnFKtF7xmDh4RamxE9XCsamHodbR11rse38eRg5SNHD3re4ktuCpJy/fK57nq5D7XtRglpqq1A7YZSuEdMxvsEp/DLSzY4wNCt2PyQYaSdBe0QnwGD0VuQs+IRJRctGrpdwIIHJWCSEGozm2pR2eupe7OJDW9w7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6agjH7GPwSZimORMJ5ftRDDNJL6moNpVExJiGRMP82A=;
 b=LZhdLuHhpbNPVNaeuS0LQ9tNAaVf86szpddsoNN/dG99YeNTAOWzAFi3GliGuhb88GKG+vEN642YQ6/xp6x0XLRaNE+Cfx4Plt2WjU8Sb0Oe1pXmj9fEgCOhm88Yosg8JewEnw45RAgSUXtM1bQgL/fK5XYf7jOBU3HQBbrIe3TFS18xqQ9I6zfdHIxAdYWEsQSQZ7sB6HsqR0C0kk+TY2peW3NhjSCIT1TWKq4aF0xrAa51r3sWdXTYwzVrQqKaasA85fWc0xC/xq6W0FY5VKWB9hxmvvVLQfiD+6oDqPadg9KyD0i+bA8LFuRi5P+GcPsBqNr6FPE3cI95jiHyFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7122.namprd12.prod.outlook.com (2603:10b6:930:61::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 14:46:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 14:46:36 +0000
Date:   Wed, 15 Feb 2023 10:46:34 -0400
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
Message-ID: <Y+zwSn63eA7HrefO@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com>
 <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+zSRklKkL3rc2FB@nvidia.com>
 <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75299F5D92AAC33FD8690694C3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:208:e8::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7122:EE_
X-MS-Office365-Filtering-Correlation-Id: f7850911-f956-4e93-30fa-08db0f636ffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hFR6x/ZMPCi9IaKkOLcgdUGtUjnvlDtpxkDNjsHQTpKU/JRX4tD+Z88EN+p2MxTiRe2nsTT4dboe14C5NApnpKevGpH99SWJJ2S6ikQXey721LJYxVcbdCZGi4otrQecdGij86trzneOkhjFcrTqFaXDA8PZc7SrR5J7HKKsuA/tzMRZra25K9p38EGOgNmXMnVn7Wm4gSMb2pPAWNnB26Nts+tbDojVwCvJT9LvIiTwW3u9vdn7Neog2B55CGI5IkXVCSxy8jjIh/jd/upysVADc5G0759s9RwYgz3XWOVgj6aMhivUwntF3aStVlg8xCnbUXfHjrl0c1K+6feRF7/nXwl8WMLT8hM/7cNYOxyBQaV/0TFsZ2RYvap8ek03iwYZs0Iwrc+sEAvv2jkhfPW6Y1RV6QLDZXIH9AKz46xdjstVNAdUWWa2ShFyKv/sncw8pMzOIC+DDNTGxOrJXDcEmIxERv2HOw4k0u8JeGmB0kPncgHAcuVgdPE+PkowejA0NwFl3SjbXRYC/2R+1S8bBG8zpMxuy2vLfDQ3D0xjcWs3Wngw7LA4Q0JsSkIXO6mXNec5XUurlw9g1F6dliCi6OB8/GatrrajsermO+Fm+de2l6Jghmrwqd4WE/T9Y1u416CfInqdqGVu7XQWgTwfTKpCdkSvdBmbDaI8sJhza/akqeo0RgQFX7wtBJwxFREF22gYi4wzSJrYY47rZb6PGDOPchZo03+k3mSuQiU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(36756003)(83380400001)(66476007)(66556008)(66946007)(6916009)(8676002)(4326008)(38100700002)(6486002)(316002)(41300700001)(2616005)(54906003)(966005)(6512007)(6506007)(186003)(86362001)(45080400002)(7416002)(478600001)(26005)(2906002)(5660300002)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Adz2SjAsrI/TE8Z6sg/DiXpbR3/tn49HDa/DB3Gdp23T6SUaXBFIi0JkRVHT?=
 =?us-ascii?Q?deQQKZW2le9QpADQ0qqy7Kt6Kobet7gtIvSueLzeZ86nUP2d3xXnedkh0qfd?=
 =?us-ascii?Q?MORW9XIErYVcFaBoDRyGezFx4OCAYUaq57GtLz0wPNfqA6eNn0squO/mvpCE?=
 =?us-ascii?Q?VpIB7XFOfj7Pp4FAcCyUfg22oTTOzeDuHHSPoSL6HYuTOwIQFSlmeio5zgHl?=
 =?us-ascii?Q?5bKf8kVX0/uTVPK28TGOiZhpiNTnKD3TfaMnpBUGFRRdxPdpKIGz/q7jxba3?=
 =?us-ascii?Q?FQEaj4KAlYYnL2SfBSFdrA9/JstnqBkCMtBb60avzOWeudOT/1QWPH3mf/Zx?=
 =?us-ascii?Q?sV6qhP2isPkPxSTI9eZpsWPhV0GRfMxmWm1FiGIGfNcFIyhvD6jMULwQ0HLW?=
 =?us-ascii?Q?fARpgT/QjGTJOKwx+ohj+OakvkIoniZz2iIl19IGbLi+5U57Qed8S2hDB5J8?=
 =?us-ascii?Q?ZHUGsJde0ObwBG/7JLcg35JbtpSBhmexGxeDYrjKAPdJXQHxTgTlkfq1BaaU?=
 =?us-ascii?Q?dy7Y4rBLXEi1xVnZ0J4K6gdriHR/owN1xgTPxpFBo4jZTni+BkWLyRg61z6w?=
 =?us-ascii?Q?zxV4i8tRYOW5iSghgWUEyLZH2xQFVs9yEEZnP6gdUYXDqEv08khonovtlMbA?=
 =?us-ascii?Q?JgcMskpc4uMiLij/pPrrUhW/cIS0PCMAgil4UR5wAXr6AuuVjCGcQs0hgrrJ?=
 =?us-ascii?Q?CGYpUsQ8FdseVSa0byolqufIRDSQTZZOYCjK8Fd1RKdzuVI+A6Ho4iwv1LNi?=
 =?us-ascii?Q?4GHNPIAynzzkITJZg+wa/jFHJDRlhrpjyahqRAHcW+duYpDqX+0MXO4tlaVG?=
 =?us-ascii?Q?71QHcY6tHHSSqf+W4QbyxS33jkehpi2j2lbf/5/Ayouo1O6wq7nrCpj+rqqy?=
 =?us-ascii?Q?o5GgL/HDJXXZFyC2EJV0/Uxl3/uej2PkOFu1qDJcnrGwRDCeoxtFk1lOBylD?=
 =?us-ascii?Q?TwZ4nVVNlErhRGJFf2WVoB/W4wsCsrbGaCuFQ15XGxsRIFQo4jDmGXMXVwjf?=
 =?us-ascii?Q?YYSRAwPHqaIclX2m1IzQPdBBcTjTKeTcF/dmOkCVwFV9T8Umaqp2/AyITEgI?=
 =?us-ascii?Q?v+R+a8Od5EnW2ftWxhe+ajTiHuSjCGpgj/f+2VlolgdAbDsJHNOs/SMSBMVE?=
 =?us-ascii?Q?+hbQIbttMfEO2addHiLzi+kGGZ+ET/KEdGmTsG1wssdTdpeFh224LUnzgj+R?=
 =?us-ascii?Q?tfyYJ+rClMmO1qU2Yyws33GbwaPuno4rokow4TB2Yda0i9QjETPg+7KEqIDT?=
 =?us-ascii?Q?26modb/8SOR1BxuqzPeCw1EgE/s3ZiKBsjgrQGEKdcdxBoo0DFUwxqKRXee/?=
 =?us-ascii?Q?XRnO+91ueA4arhcdYL9hxwuPCmrwoxDHN1y5YtGYqwtz0kY4vv8c7u25elAg?=
 =?us-ascii?Q?lv6FNO8roaGa1qBczOzkCAPzdD+Rh6kzfxI6BRpWoG31XqrcX70tAgy0IVtG?=
 =?us-ascii?Q?5bZA42CnK4olv3J8HO0G8nyG3RV+2muiYpa+8tJ2q2hjleW2E6NaFNdBo+ln?=
 =?us-ascii?Q?hJwM5aM408QYE1NWoZJt+KQr1fnRLOIBBxm2ukg9fKFDsl0ZRuzut6QxJe/c?=
 =?us-ascii?Q?0OvZi3liCXDvzbOj55cmOmWVmHkhz0vFKtE1J5zv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7850911-f956-4e93-30fa-08db0f636ffa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 14:46:36.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gnUl+dVNWeBSBKEby2TKbyqZ45eYkIFOVSdbQJ+jS8k8nA9ucK3K22VKeQhAJQQy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7122
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 02:43:20PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, February 15, 2023 8:39 PM
> > 
> > On Tue, Feb 14, 2023 at 02:02:37AM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, February 14, 2023 7:44 AM
> > > >
> > > > On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > > > > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > > > > +{
> > > > > +	struct vfio_device_file *df = file->private_data;
> > > > > +
> > > > > +	if (file->f_op != &vfio_device_fops)
> > > > > +		return NULL;
> > > > > +	return df->device;
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> > > > >   * @file: VFIO group file or VFIO device file
> > > > >   */
> > > > >  bool vfio_file_is_valid(struct file *file)
> > > > >  {
> > > > > -	return vfio_group_from_file(file);
> > > > > +	return vfio_group_from_file(file) ||
> > > > > +	       vfio_device_from_file(file);
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> > > >
> > > > This can only succeed on a device cdev that has been fully opened.
> > >
> > > Actually, we cannot. This is used in the kvm-vfio code to see if the
> > > user-provided fd is vfio fds in the SET_KVM path. And we don't
> > > have the device cdev fully opened until BIND_IOMMUFD. But we do
> > > need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
> > > open needs kvm pointer. So if we cannot apply fully opened limit to this
> > > interface. Maybe an updated function comment is needed.
> > 
> > This also seems sketchy, KVM is using the VFIO fd as a "proof" to
> > enable the wbinvd stuff. A half opened cdev should not be used as that
> > proof.
> 
> From this angle, the group path seems has the same concern. Device is not
> opened until VFIO_GROUP_GET_DEVICE_FD. 

Well, classically the device was DMA ownership claimed at least.

> But group path has one advantage, which make it ok. Group can only be
> opened by one application. So once it is opened, the devices within the
> group are somehow obtained by the application until group fd close.

It depends on what do we want the KVM proof to actually mean.

Is simply having permissions on the cdev node sufficient proof for
wbinvd?

I admit I poorly understand the threat model for this in kvm beyond
that kvm doesn't want everyone to use wbinvd.

> > Regardless it needs to be fixed for the pci usage.
> 
> For the pci usage, does my below reply make any sense?
> 
> https://lore.kernel.org/kvm/DS0PR11MB7529CFCE99E8A77AAC76DC7CC3A39@DS0PR11MB7529.namprd11.prod.outlook.com/T/#m7c00ae5dcae15f42b6dc0b3767c7037b99f53a56

You basically end up with two APIs that test two different levels of
openeness (I have permissions vs I actually am the driver owning this device)

Document it carefully at least

Jason
