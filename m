Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49989740083
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjF0QMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 12:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjF0QMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 12:12:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B862946;
        Tue, 27 Jun 2023 09:12:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnGCxfy4VWhmBTz+5Smzahj5s46PnOTEzmuY6KmOx5lhbQt/2obKaOL8nHbvWyg6lDKve2HbE+eSi1OuYKDEmPHC2FPNeJEuTrGfoiVpKbbQ0ztyRHFfjOFtB1Jav4RoLTg2yQrYKT89cJFPZlR64UuV6ChZyE2Rke7mHmx6xp/Evh7hrqKnM2ODCv/iGF7ulPoKX6BVw4il4j1K8HbW4nN3n3gsUKTJB/z7pGRZOaGgeQ4o1vuuCj/E9MI4rf3nsGZ8DIrTE3y2x4iZ6Di/WNjF1lWQuE1I8pOmBXtrw06IVEkza+K8OxBTTIVZqRLoIAmdceC+dxu3XAZTAe50Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usH64A1UBa1dsorqmH+3l/68SB2bsSPIVP0UtqdqGJs=;
 b=Epeor8UrX09JnWix/hsh3yN72Q70ibKsunLe767L21O9oG4ozousNWWGKCUHb4Xtlqm5B+7RZS/Gjw+8/tgJ34Pe2ajj1WAabYNrM0TKoplx9Ye3zpwiiW8Lg0sfVbtOjiBtXpJPUkT9yBwY10fA1XD0TmTDCs6wV0ZVPs5S6MnRnbl6ZvW3QNY0Ff3Jf649HVW78cuwM5gxP/v+PuhViiz38rO85DYI1Qh+3TEDdG5onpyx28+MpigTJlAfzetpli7zT/Nu/TMe9egztfNmCJqRVnHfu1HHRpqp2hkAy37ifoSvRNXk5MChQSnFNz/XqXy/sxiGaIgrNgumEqW3Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usH64A1UBa1dsorqmH+3l/68SB2bsSPIVP0UtqdqGJs=;
 b=ZtTKj8+muKoT5pDk0yMlcuTrTrJwCkrC54KxVqjUl1uSFENuRZx596oOQMV5Q1hmwOe78rAMzclycqR8xibsx91XTUjmOXlgz4Cu3rRLfTgqwKHNfL479B7uRT7B7kdgagBxFGxIrAy6cQyZLIMdS0I+AxJcdB2kB1A877ACj/jP0c8zo65VHloZsAMrjuRLtemDUJ3z50pyKKEwOKe6/Hdfx6xSft+Sq+86lwdC0hD6o6TFu45KM/aJ5kL7CPbUdE2sMH7VmBbluwC4TgxjmvDBc7h1dtEKXx3JcRitumMYbasTo3VPzu42lsXBygTKtGN0vsXaZa2MKOqw5nFnzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 16:12:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Tue, 27 Jun 2023
 16:12:15 +0000
Date:   Tue, 27 Jun 2023 13:12:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Message-ID: <ZJsKXoK7SF359Tb2@nvidia.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-23-yi.l.liu@intel.com>
 <20230621155406.437d3b4d.alex.williamson@redhat.com>
 <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0123.namprd03.prod.outlook.com
 (2603:10b6:208:32e::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: 08ddea43-1092-4cd9-572e-08db77294618
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCP0F8bB8Io12JlHczDWn5/NYZaHMFFyQPNBLmiRybKu7K/NnhxSj4OAf8pShK1IXH9eistoFoprjXilwkWGkWqVpFfeS2C9R1oTo28Yi8SsN+6fFH66TCcbaCWiZyJyb4F+XBtUHEAHG2iHYaJTiiCm+S0LL/DUMcmx0RDaxV0ynjv2cENKaRxXX1K3WdqirfAPTdcidA7jujcYhYI+xrQtVzUKQSbAQk4Mi4L7qgtkUOVY+BrKRrylBCDZCzvhXhdx0KOJzUdBIqNVmHtNHe9HnDilbaBAOYVqJn3EL8LsZMycF+r4/ldPBLThSayDtR2gHOBGqVxCzae35fZ9NWz+sHkCMHRcIr14OcuMXWPYowQMp4tK522dp5g6doAX4B+sYV8xSL6ahcSnoQyzmyUm4CdnIJtc3ET0s4/LkpHcoWjhk5n3jcMX8ROROHBoR2YrxhXZrW2YgmSjAFfGPntKyD68IJJ8Y9+7HZVPqx1WWr40ym3W9D9JRZaMLxwqSxAfjeNmcUMU1CKcBP22s3boZXDcbSzn57wI2Uk/QJYZakJ/zSJYZYf8r8KXIjEW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(2906002)(86362001)(6486002)(38100700002)(83380400001)(2616005)(6512007)(26005)(186003)(54906003)(41300700001)(36756003)(478600001)(66476007)(66946007)(66556008)(316002)(4326008)(6916009)(6506007)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nk5kUWFCR1FiUFo2RU9oVjQwV1NHb21WS0pqOWh1cDhhRWZ3cnNTK2d4TEFs?=
 =?utf-8?B?UFRqVFN5WXpBMTZSTUtYSGhFQlZiUFV5WEpQMk93ZUhKMWk4bjlLK0ZGOWM2?=
 =?utf-8?B?UVZGV1hPMlJnVVhTVlRYcUJYWnZ4Vi9MNGZVTzgxZDhyYW94WGZKNFBNa2RS?=
 =?utf-8?B?QlBoSHArUGp5MEd5bW5SU3RSTkZXUTRQdFlYNkp3RC9zek5yem5TY0J6ZldC?=
 =?utf-8?B?T2EvS1Izb0duelhtcTJCOFJKZ3FBcWNJRTVpc0NSdU5ROXJkSlZWUTBMYzIz?=
 =?utf-8?B?dFdYNnhzcmo0bWs1Qmo1ZjVCTlJkQ3dJUzM2V0JCZEpLeWczbEFvWDdORUp1?=
 =?utf-8?B?dDkxd3B4WnpkamdNUTNSTHNUWk9iOGVkR1UrNFh6OVBieTA1bVliODhhQ0RX?=
 =?utf-8?B?NW1NaDZXN3hWN3FCTFdZVGVmcllVUmM3RFpYY00yT25MZjU2V2Jjd2lNeDcz?=
 =?utf-8?B?VGVmaStWc1NTczRtL0k1U04vU1Fpc3NGSWJRRjAzYnBUQUdBNzF6dVBlWFBQ?=
 =?utf-8?B?ZjNXaFVPdnVmN2MreUdGSGpFQ2hrYXlaMjhnd1NaYlhKemt1b3RSRGlRZG5F?=
 =?utf-8?B?STNVRWZOcWljMzZzdlFkZzVza0lMMGR0cUZ4REMvZUJqMGU4a3pJSUhIaTR2?=
 =?utf-8?B?WUhSdGdjTFU0SGpIVjh5T2ZIaUR2ZGt5Zi96NFNLMG1ZV01BM1daOCs2N21p?=
 =?utf-8?B?Y3RCQXk3TE5iVjZheHpwcURzSzlEazJsZTVTYkxYNGk4TjhycEljSFpqazdT?=
 =?utf-8?B?Ym1sVWlJdlg5SXU2QllZcDlIMFJGVkthTHdnUEVKOEExTjlGRWNGbS8wZmFo?=
 =?utf-8?B?empCMHA3RE14cGFlaitIMnh0VGpoRU92VUJySGxmL1RPcGVPT0tjZFgrVmNx?=
 =?utf-8?B?aUJTcitFd201VjJ5N1VmbmNqMHdONmVGbzdkQlhPeFNRcGVvVzhWT2RyUktO?=
 =?utf-8?B?Wlo5Q3pVOS9XaDdnSWNQVWVxeHl0VGFNcFM1Zm1UUkhRRjdzRWV5WEFzT0JE?=
 =?utf-8?B?L1JMSUVmWFFhekxESzBhNE5sV1BMdFRrTFdnTmtFeU5nUHhlMm9UVkxJcTZw?=
 =?utf-8?B?a2pPWXowQVpBYytXZDBqc2JBTEUzR1BubVlSVHBNV1VXZW0vRnF3MGpzVlRB?=
 =?utf-8?B?aTAxQlMzTVFRYlgrOStmdllKYVk4Z1BubG5XNGJ6dnA3dWpTZE1MbEU3ZGhT?=
 =?utf-8?B?VmtITEtKaE8wek16aWVQelF6V2F6ZVI0cURob0tha1FjNHFYN2xxU1IwSGpn?=
 =?utf-8?B?Tjc5eVBoRVdpdVd2RS9tVzM0RlZSUER6K0tFL3VPamgvUmluS241ZFFwU2Qz?=
 =?utf-8?B?eUpwSk9hTk9iUzdDc2JPR1Bua1JmdnlVZDNKbW9GTkxUR05iL29SZ0psRU4z?=
 =?utf-8?B?dHNTTmVJQ3hPYVhEa3RoU3pUcGxwQmRBVTIvcnVJVURrRnVMN0MyS05iODJJ?=
 =?utf-8?B?VEVkVENmOVZ2TERoVnBEc3oyQjloYXhLSkZpZmxWN214SUczdWV2aDU3RmxW?=
 =?utf-8?B?Zzc0d2tVOXdZK1F1MkowN3JoaUI3MlpCRCtycHliZTZZYkRTUmZFbFRLQ0Nu?=
 =?utf-8?B?eERFVUdkb2ptNFhaRXNwT0dYT2h2MjZueHQ3b2NGV0FhYzJ1cVVBZ3IyRFR3?=
 =?utf-8?B?cmlaSVd5elprZnEySk5WZmRvRkJ6VVljNWx0K0F5VUtJSmlicjJNcEk1ckxN?=
 =?utf-8?B?SmRDcXhMRGxnUS9WaUI0TXpjL2wySTRoVXZYMC9JdDNVeWZlVUQ1VlExRkp0?=
 =?utf-8?B?NUEwUi82eExkQmJFL0Vnc0tJUlQwSDNSRzcrY25UUktqa2VzdmpDYzFQZ2lI?=
 =?utf-8?B?bHNHZGdlWnpzQ1dHOVZwZFlwVDlIaXAvZm9LaXQycjR2c3d0MXZwZlpTLy9W?=
 =?utf-8?B?bVhpazRzNW9EbFlkam8zZlpFK1Y3cTdiNWlRaTlWemxpZEh4WkVla3hDNjN4?=
 =?utf-8?B?NHl1R3l1Tnd3RFlZZHRLU2lzNGxCZ3c3OFpZRFFTOUY0cTRNWjk0eVFINFJZ?=
 =?utf-8?B?MjV5Z01yKzVwWXlkR1pCbEpEQjhSQzd3L3AvS3A0dmlXajlON1R5aDhGQ0Zy?=
 =?utf-8?B?aW5HbWg3NmM0d0NYd2JvbkdwYUw1RitBU1BkcDdabmxkZzlNWHcxek1tTFFR?=
 =?utf-8?Q?vv5PBlV6PALh/LTxKdKteJO8M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ddea43-1092-4cd9-572e-08db77294618
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 16:12:15.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtvFp6rZGhUus+QWn9ZfUH1UL0liAamMilc1/o2aLmGWw4N9BfoAFO2EdxzCpmKS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331
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

On Tue, Jun 27, 2023 at 08:54:33AM +0000, Liu, Yi L wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, June 22, 2023 5:54 AM
> > 
> > On Fri, 16 Jun 2023 02:39:46 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> 
> > > +VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
> > > +Hence those modules can be fully compiled out in an environment
> > > +where no legacy VFIO application exists.
> > > +
> > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support device
> > > +cdev either.
> > 
> > Why isn´t this enforced via Kconfig?  At the vfio level we could simply
> > add the following in patch 17/:
> > 
> > config VFIO_DEVICE_CDEV
> >         bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> >         depends on IOMMUFD && !SPAPR_TCE_IOMMU
> >                            ^^^^^^^^^^^^^^^^^^^
> > 
> > Or if Jason wants, IOMMUFD could depend on !SPAPR_TCE_IOMMU for now and
> > the existing Kconfig options would exclude it.  If we know it doesn't
> > work, let's not put the burden on the user to figure that out.  A
> > follow-up patch for this would be fine if there's no other reason to
> > respin the series.
> 
> @Jason,
> How about your opinion? Seems reasonable to make IOMMUFD
> depend on !SPAPR_TCE_IOMMU. Is it?

The right kconfig would be to list all the iommu drivers that can
support iommufd and allow it to be selected if any of them are
enabled.

This seems too complex to bother with, so I like Alex's version above..

> > Otherwise the series is looking pretty good to me.  It still requires
> > some reviews/acks in the iommufd space and it would be good to see more
> > reviews for the remainder given the amount of collaboration here.
> > 
> > I'm out for the rest of the week, but I'll leave open accepting this
> > and the hot-reset series next week for the merge window.  Thanks,
> 
> @Alex,
> Given Jason's remarks on cdev v12, I've already got a new version as below.
> I can post it once the above kconfig open is closed.

I think we don't need to bend the rules, Linus would not be happy to
see 30 major patches that never hit linux-next at all.

I'm happy if we put it on a branch at RC1 and merge it to the vfio &
iommufd trees, it is functionally the same outcome in the same time
frame.

Jason
