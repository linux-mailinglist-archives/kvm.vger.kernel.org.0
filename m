Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056816A5905
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjB1MaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjB1M37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:29:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A8E2DE68;
        Tue, 28 Feb 2023 04:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZClnyIBG0EV9WspDJ3I0gN2qj7U6Hn6gOMFL9fLfGcDWF5xMWoR9QJTdnx3c9WHfNWYnNkXvIiPVLPraYcut+c+Srk1aztrpxE5y8U8X2GhA5oQKyPbkBp3vG3s/8SDOLnxI5RtUAXoKgwG0KxpE8t2SVQxa7AYsb5hxvM7ckcLUfW92FrnvHKx/IlfIcuzOMeQNt+tbOuJYGQk70GlYogTsTN7kNbLk83bMUyRXO8ah9jR6rJbfWgK1gYd3Rpu4ErUL0Wj/VNkcAZlimFlJ72AsbQvdUb67Gqi11WkYZyD8oYPX6j7Xjr5luSotGcq2AtcQ7WR0Yd0WDRtC9VeXOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8CKzdDTqqnraGdM9e8SHQSmk2H8M4q2DDA20K2hZ5o=;
 b=agsm7vCljp9SU3V1s+/wHjEutJLXp4HqIeZUzcKmGh74Zov0PaJ4hkHE4gqUmGybdSpCeTZLqxy7AwWZWSAg5gSPg3+RKwI3TPUMIFsR7+Qaw6LBmQjolVWArpj82SPRATlWRFHxEEwutGiaZXVIlUW/PIk4CZ6iL8WzZrDgaYvCkcvH+4XaH9PZNlaumtuiQy9OPXxlZGamsM7475rj/2eiSY3NkAnmIkM8bOFsWpeaHkUgyq9Bo0TnWOLLFVLGrZwMR8ih1MqskPgw/Iwrl+AHakTzvXjXIsEuQgmMPK/Ay9ulZogJRGj0xfNFsrvOtlVkm94m4xewnBkW5u7bwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8CKzdDTqqnraGdM9e8SHQSmk2H8M4q2DDA20K2hZ5o=;
 b=uex4rFkoHVpICAbe5x3zj86Ks/67Oa2mz12LvmOViVbz/zIcmcBbTFRoiQv1Z5DuEprPFaPqUcYJTdfiIM6Y/TUjlB270upjQRqrB+s5Rg6sAeQdB7zTLXuhLEDqUHuzIc4K5yZvcpmbcdFh33vQu/k5Pklckml185V3ndqeLQ4NOmr7MK841OI4HlzQ/uwuXIsE51ycjkgLjRLJHzQd5DpUnvMnUL8pBkgBDRsZFEJyblzI31PByn4+uWcHezWxwNoBYTg4wnD3LpDkUvazg3g9Y54IHOrRAre6Lu3Zn6rFxM98fFedpL9Oi+2il3pMKXFfF/NK9tWzpY4EZdOOkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 12:29:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:29:56 +0000
Date:   Tue, 28 Feb 2023 08:29:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Message-ID: <Y/3zw/F0AN74CYs0@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com>
 <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: 098db22f-08f4-4b01-696a-08db19877fdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xLUOe/bl3P37wV2ECeN/h/1dMsN6gvYDXARTT8gYwHsDUThHLBAz3vmxISmnW79cBxu0u7LiFSXttnIGfk6PBSMNMAbc03F3USp86ZyQCEB7ifs5mjFkCxwcCGYDHurra3l6lLSO2/oYXDfEivqdqWAjfwoSA5icsupphBXPGz9egEyByXgq425Kc2PdH9tEZ4CEdRnLNXq7aP7QtMGwa96Q51ezMN6o0S+KkArnU7DXmbMAJIyPTrMFAMi+I6nyZ7RJoW+/iyUL43PulPZE7Djej4FQbYgxp+KcoijjKvT7gd5qsmgvDtj+KNNvEP+8iYL2BGU3rKmxB683wkM93DfV+gM7u5X2653ZB7FidNPSW9amTbhLJacR2P9/XGH42BDkI3jPH4dJWqcQCqL/l/uYn7A4/9TZ/bEkSlUIKheAsos7lL7Xa15CFRvJF2MjS3hgRDuxJFtIHb2W6VLH14y+6Y7AmBMITojM7fghLxoxppbIsUKpgVUyuri1xrp1UkEnQ0LSl9SUyRX/e2kcURVm0N+hAwm2r/XjTzeJGLVjDt3Z/+r7TEPVI9JL+WuMDyqSOWYYyHhxf8DKxUJjzbIkwMojAxcvsPt6eiygY5KincEPu7oDBzNmYyUxWg9vbmBjVeRMcS5eMv+BOSjnqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199018)(66946007)(2616005)(66556008)(86362001)(66476007)(6486002)(54906003)(478600001)(36756003)(41300700001)(316002)(26005)(6512007)(6506007)(8676002)(186003)(6916009)(4326008)(2906002)(38100700002)(8936002)(4744005)(7416002)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFZPVHpsQVJ5eVBvTGp1QkE2aHBheUVHbGdGcHRyTnBOcU9PejhoN0wzdEZs?=
 =?utf-8?B?a1NsejhaS2FLZ1FzTHNIa2pkeG40RytJaGZxRFJMd2Q2RmRMVTU3RFpyMml2?=
 =?utf-8?B?bjcreHhhblJ0c29WU213UHJZaWhkZ0k3cGJYb0tvRjlnbDZIUVBGT1BRZ2Fi?=
 =?utf-8?B?RjZiR1VNcVNWanUxcTFScDkrVjUzU2dDWElpeFI3RFJkbWNrT0wyS3FBODhJ?=
 =?utf-8?B?YS9pS0RodnJmd251aU1TY1g2QTNpQkJkV1VwQTN0enJpZzA0MFF2RUdRbmlW?=
 =?utf-8?B?Z2tMNjVCY1RjK0tmcis3dTBZUmUveUM5WkhxWVIxUmllQmZ0VlowU3oxcEJS?=
 =?utf-8?B?QXpTYkNQajlSNStPRVowQVgwbGdnMTFoOXU0dXdhWmlXWHpibk1xVFpCbDND?=
 =?utf-8?B?TXlDaVcxbkxXSTRiWXkveHpMZ2JTZ0d1V3hiRHFVdjVHUkpnMXowK3JGUldL?=
 =?utf-8?B?eGcyMDlxRFNWS3lUZWIzR0ovRmZtTHR1MEFFWUViVHNsaEwxZzJKeExkQkNB?=
 =?utf-8?B?T0lBSi8rVUpaZDVSUERIcmZ4VTVCSVBNa3FwYjdjSXU4NEk0RzB4aklLWCtV?=
 =?utf-8?B?QXlMOStzS2k0U05ySE93cnJlM2F0azA4OTFxb1VwYnphVDJpdmhkUHp4bkcr?=
 =?utf-8?B?OFlUTHBHZFRpR3hib0QvQWZRbHpDdGZycVlydzlPbmlBNEltdmNjRWhITDdX?=
 =?utf-8?B?OUw1S2g2WTgwM004N1U4eTRVNkRhVVByNm1Od3ZYWjJ4UGxZTjk3dERWd1pK?=
 =?utf-8?B?QUFwek11NlZJVW5adUJtYlBlMnNUbnU5RGNSK3kwbkpnYjg2Z0hlbDBmZ3pI?=
 =?utf-8?B?MHk4YUtrL1Z4YWNSRURncmMwd09CTGYzdXZ0Uk11eUhrT2JiaVFOOVRXVzhk?=
 =?utf-8?B?OEpHZ1gzTnN2VHRTclRIWEJWTStYdUVycWxkeWpJcHdkSEVBUDJZeDF1MDA2?=
 =?utf-8?B?U2poSnovYkR0bENmdXJFOUlrQWpPa3VKZFI4dHpDZzk3NmI2dnFVVk11cmYw?=
 =?utf-8?B?VElmd0RqUzVLTFJkNzd5NUJrekJscUpIZkNTbVI5b1VTTjRZQ25rSU15bmVT?=
 =?utf-8?B?bmQ4UFNtQmVUYStVeWVlYnRaUkxaZlVTdHlrdlRsWVg1NFYxY3hZTmJsZ3NE?=
 =?utf-8?B?RDVhNEdBRXdjaWl6S2Voa0FiT3JkSkFQanF5aEFKYWx3L04rdW5aYTZGYk9u?=
 =?utf-8?B?bDA1OE9qYkh3Tkk2V1REUmFxVzE5WldhTWlwZWpERU4rd2JzMDNWQjFLVGRn?=
 =?utf-8?B?WnFRMTZNeGJ1SzE1bkhUT0RiU0M0RUdEZzhBdUxrTnZVQnM4V29TbXJHeldy?=
 =?utf-8?B?Y0g4QVliZHFKMlY2WUJ4SkwyQ3ZmZFAzcTlKQi9nbnNFa2xWK1pRNmxlWjdU?=
 =?utf-8?B?dC9KbUkzTDl5OGZ6eWZOakpGd21oK3pFcFRlYlhMRFVOYmVaZEdHaDJpWEU2?=
 =?utf-8?B?a3liWnBjOE1JTjc4NHZXaWRVZE5OMWVkVlJiRmpEdGR4UUVCS2lzd3pGc1Yy?=
 =?utf-8?B?TjhBd2FndzdMaUtSMUpucDdrYmF1MnRIQ3AvV0hwUkxxQ3JkWWErbzd6azVF?=
 =?utf-8?B?RGlhQmpIRU9VMXFGbFc1TUtoNDBsdnkzd3h0T2pQaTlnRkl4cEZYT1RPbW55?=
 =?utf-8?B?V1dKL05nTmZQNVlwT3ExR01HRVoxTnU5V0w0UVE0SFR4TngvQVhLbEtXMGw4?=
 =?utf-8?B?ZkVuUzI1UVZETU5xK2VyYnBlZndlMXh5ZTByRyswRURxellRUjNwazE0Mks4?=
 =?utf-8?B?R1hUeXpMai9vRjdlK3JydGdoSjZQbzdJcDJBbGFUTjAwRVlkNDhXUXg4L0dX?=
 =?utf-8?B?SDdFa2J6RkIzMFFHcWlEWjdCQjdYTEtDVEo4RHNhWDZLR2N4aldqUGJ4TFhT?=
 =?utf-8?B?TFExZmZIblBaZUpqMXArNXN2TG8vS3VNN3ZaQndFZERoZFhYY0RyVzl6Uytn?=
 =?utf-8?B?bVoxeGxyc1U1NGJDYXNEemwxemdMZXpsUnlLRjVjUXNONS93aUFUblhSRXVp?=
 =?utf-8?B?WVhCMFBRVWRXWUdxcVB4ejlpTWQvVWM1SER6amxwL21Jc1UwMktYZXpYY3J4?=
 =?utf-8?B?ajhzRWlmTUcrMUI1bHlVZjZpWkhodmtBWVF2dzZzNUwvY093UDhzMWFyZU0r?=
 =?utf-8?Q?WqQO08OkDt3AOA0sRD1gKi2BJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 098db22f-08f4-4b01-696a-08db19877fdf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:29:56.2027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGCe8qxase80R4VQegCMRbYw3HBnZPdufxypoK1/2aJnMZqGqeFAY5hcLYxP1f+/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 02:35:25AM +0000, Liu, Yi L wrote:

> > And the commit message is sort of out of sync with the patch, more like:
> > 
> > vfio: Pass the pt_id as an argument to vfio_iommufd_bind()
> > 
> > To support binding the cdev the pt_id must come from userspace instead
> > of being forced to the compat_ioas_id.
> > 
> 
> Got it. not only pt_id, also dev_id. 😊

Maybe dev_id should be read back from the iommufd_device pointer in
the vfio_device. It is trivially stored in that memory already

Jason
