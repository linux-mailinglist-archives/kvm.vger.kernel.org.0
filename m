Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A72C6E50FD
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDQTcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjDQTcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:32:02 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D73F5FD6;
        Mon, 17 Apr 2023 12:32:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6MyCLgXeoY9oPEw7+hMJlIRiinZje02GhH+XHKA66lwZgdtcfDdK9WsLoXbWIpamvi34cXgWyJj9F06dkjUo8szPNTkAsXgzuq+dLpMyeLSqTrY41Fxl0cJiKupC8z/o1IzA/wrqjfp8kXZwRwdxAq3XdOA/ejvW3j5SElrj9hjkCZDSCTcq37Oz32HjG/bUTIUvJRNdWZDlnJdRzzZ5+jyPUQchSvLyrDogZ+1cEt3+QugDK/ph0KJTFZmgTqR03a8RUuG60zoxeal8vQBLL9uJ5YTv/JgKlqUKc9uC4i3jYk0Q/i0M469oDDuhRDAERmb55ON4L5/IJdY5kHgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MunhYH5pcGE4RyNguXu8EdBlYtDZp4zNieIc/Jcmy7U=;
 b=llA1yhSjFJ6iH0mmin/42wva8L+HIzuJ0S6+G5r0JGIoCTwp77v9rjFxwnypg4Yy2eFQNUgWPlTlKiHBR8pgU4GLL+afzWL/z2bDHEwSz+Wd3pQH7UYc4Xz8GBCJcAwkmpr6b3uqO/J1KJ9wb21eQ3NPQ+ZBASCnWPGVUB18AvqHmuCNoVPGqExRF4HrEcF9hfC3/0+VQYgtxD+zPKBIk5c6tZ/1d0QVpaQWzjeGpLceFsoAumYF/N4PdvX9uEolT3FaE1D7rLJvbrdY5YMpKT8QGV1oSsRXCTu68nCR6M2DZm1FQTMNAwOhZnbq2teAIU7xtuEYBk5N6xjhZX1J9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MunhYH5pcGE4RyNguXu8EdBlYtDZp4zNieIc/Jcmy7U=;
 b=eZFsowTrnGJ2cPPuLL+eKm5boIBeYrFg8A40nrmWovEh+yBBZp3WUX4rfVL1ZIDLOy+ESo3qAkNGVkooYSbEAJ7eAPet/Pceo3ZH3AGa6GWtRrVRv0rY6s9ux4U95jyApznlH6j6XjrrPCAvj9YEUA0+5NDaToiRiAyyugMKYIODq9cKpUMaBMLh8crYuYZst+hixPgIwaH0cEgG/3ABga2DAODK+ipLutFGEnAZjlwzvJwAhCF3US3P/SR/HFL/MpZIgZuQ467No//3+qJ3z0WftWLEOyFNnNiZoM7LzdCa59UG2qSDEL2O47WvFP0NY94CLr9dZOLG/J6p2TrqUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB8274.namprd12.prod.outlook.com (2603:10b6:8:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 19:31:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 19:31:58 +0000
Date:   Mon, 17 Apr 2023 16:31:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZD2erN3nKbnyqei9@nvidia.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
 <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230417130140.1b68082e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417130140.1b68082e.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR03CA0403.namprd03.prod.outlook.com
 (2603:10b6:610:11b::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB8274:EE_
X-MS-Office365-Filtering-Correlation-Id: ef86ba37-c9c0-4504-3b7f-08db3f7a68a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFf3pEoDVfe8zIjWN8VEXEJ7ncAruGvO4NGu3sP7x9jY0FZi7gtgFDU32XfqjdbBE3833/QFGn/gUrJBkSGl4ey+M9eFepcdbe2xpSgo0exL8JpiuTqGrhIDEvPiygI7ryR85htGhniw2FTuxLml+ew/aYDbLa5iwG81MhqjUUoKJoV2bDy6tz3IQj/jpSzmPYdnfgD84d2m6R6nGEtfwYtKzo5pXJOD91jULO/0DKVXZeJ3cNqo9+vLVstuS1hFc1i2p1Hu/+wRcGBi+zoC13ZGyNmcMfTEGeGc3qK1Of1O2xeKwUU4rp0w0Ui2nNkuzuZG+DzigLhSucjOxXPjbZSFKUJAUS3dxrTw015b/EDtJ8VoYeG3x55vyO/JzO+L3OtX26afRzhtGyDVKqXS9zhpmpzVug231eLUAUK3BC8WPJ0SUhTt8molZPuIh05g/bYxwIt/TlBpoIi4h1ofUzbjHvOub/9VNa5xTuQ9gZT72l/7oikJKnMJ7K1hrFPtFWUv9Kj5PA8Axu5ODo4yMZTqEm0a3V7ymuuQ9vL/T/JniMhmC1zOmkB2jun/5QgT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(478600001)(38100700002)(8936002)(8676002)(316002)(41300700001)(6916009)(4326008)(66476007)(66946007)(66556008)(54906003)(186003)(2906002)(6512007)(26005)(86362001)(6506007)(83380400001)(36756003)(2616005)(5660300002)(6486002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wb8TpKEDP4FvcYKqvhay+Ch9oomA4qFJI3G0SMoirlFfzk/zON+vmgLcwEsC?=
 =?us-ascii?Q?xzYfcsvc0ATv/s2NDOdMjWRrWyRRhRf733v+9zDtYNj84IL+2W3fMUG+Kre9?=
 =?us-ascii?Q?GFEenHrW4/ZUwElRWyE6KROVOWODNVJjThNs73eyP+BzsGjzkG6gONd4xHQh?=
 =?us-ascii?Q?ctk73fVDKE/o4ZuTfnmpzkUCdTAJrnvaOs50h7Cy0FiU3pLTKSI2xl6uSerZ?=
 =?us-ascii?Q?1LOLyWLqbAOujwX4WhW+kUF3hARozgkeaWwn9PEs0H6dNKu8LwtAQhJ4/b90?=
 =?us-ascii?Q?zElsQzLui2Vid8W8ENbfPVP5qwZoy+9gAribkWzkYtxy4yfjKjdqe3tKWKHP?=
 =?us-ascii?Q?ob8ce1vwvTynIta2cWU+pSBP8D4zIbE0d+SeHAo6lrJ9wWu9C6vNYc0xULta?=
 =?us-ascii?Q?y4j7HzwOYSCcyIkeFYrBHYjZw+V9JMDJyIcRqQKjQH4cKfQzGbIO2TOrkqeb?=
 =?us-ascii?Q?R8sC8BYt95UtzO/Cf8ATaNItJFkkGTzkjg1/D7V6nnp/2bRXQfQJWMzQeRQD?=
 =?us-ascii?Q?JWzhSM1XqbqxuoOWOEaoIvlrJdYl2eGN4yuq9QRm6mdMP9iZE0bjwiaYo4n0?=
 =?us-ascii?Q?UaYhElvfN3KGSLq4BIDppFUlSQJkml4hvSa0Jj+xWmRMHJevmK9nF1c1eHtl?=
 =?us-ascii?Q?57hZnAzgw5inlB9Hap6LMnT8KxhkQovSJ5j6csW5SYpjui+aUQ2gaqJAZeLJ?=
 =?us-ascii?Q?QbkFwY1TGyfwjx6xPro5qxcZcgcQY/NgDsS8lQ9Q552gYoQQr/71faVfau8q?=
 =?us-ascii?Q?2w8h+F35etv2BTm+znUEdF5iHQt6wAF94MJfLKXyb7iF+jBPg28Wbc9TYVR5?=
 =?us-ascii?Q?GcOWXuJ5r71VMQ5XaXDPh/SLlVg/9Z/RO97BEz2ArTEQXDjnzyHKtdN32+VL?=
 =?us-ascii?Q?k2KwxCP4a0wo9pfJ5pYffVMVXj8TJd+zi9AyxCKHCFZl4sgddBRMrBEeQwRt?=
 =?us-ascii?Q?u7WZRdQcwVzu6sMgsiZ8kUecsnTDPJlc80Op1ndMvp7CtkFPVLJBa9ThVghQ?=
 =?us-ascii?Q?7qF+/yk5tvpoKKyVGEYCZrfrT0ajhZKCN3pQTexsWUQ28uJwmkXumjwEyddZ?=
 =?us-ascii?Q?yBh7KTAITzlgtTMFVkTL9T8Yl7u24f6fUHYD71niSDfRnWts7ZAQAIKzGZyR?=
 =?us-ascii?Q?8RQGAXnLvmsQWyJUPZryV27GncSqBPBx90+XJ5KE1ABPrnrBcQ7u6NC5bAmv?=
 =?us-ascii?Q?9JXKApSgbALKEb48TRkI9a5LqIW72w15AQnes6CmgpiMqOsZX9P+GqWGZBoW?=
 =?us-ascii?Q?6f694lCOWhrCXP2bCXPIEQ26x7Fct8tHY9kFvvbxScfyI6kZ3dmGFkEUsvso?=
 =?us-ascii?Q?hGJAD86xKlhGMURvkwIO+Jq3UwYqPi9P440C4uJvf3l/3Zj9lKd8RgsDzFeM?=
 =?us-ascii?Q?ej9+otA8H5sUlYN9aZ+NQsASBZ6ZwK9WAugJO1PNfCd2N4MVBt3TlFsWWlXL?=
 =?us-ascii?Q?qYaQZJxtYtRailz2aX5qZ/10rCwDvM/vlQcfafSxJi+mG96X3L1xv7xHbAj4?=
 =?us-ascii?Q?U5P/6hEZK9TTupkXhIbBlGhSsD4q1mZBTYA5VC29vYbnz2srOXruCvIOFJsU?=
 =?us-ascii?Q?00bgzS4vZs56JKMgcZdLKMH9p/hsz/TYzmwLcqVF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef86ba37-c9c0-4504-3b7f-08db3f7a68a9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 19:31:57.8915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO0ZVZrkWizt1geRlze3/RJBys82pd9h9W91CatsYD+oDc1s84K99DEfz638gLyE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> Yes, it's not trivial, but Jason is now proposing that we consider
> mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> this means that regardless of which device calls INFO, there's only one
> answer (assuming same set of devices opened, all cdev, all within same
> iommufd_ctx).  Based on what I explained about my understanding of INFO2
> and Jason agreed to, I think the output would be:
> 
> flags: NOT_RESETABLE | DEV_ID
> {
>   { valid devA-id,  devA-BDF },
>   { valid devC-id,  devC-BDF },
>   { valid devD-id,  devD-BDF },
>   { invalid dev-id, devE-BDF },
> }
> 
> Here devB gets dropped because the kernel understands that devB is
> unopened, affected, and owned.  It's therefore not a blocker for
> hot-reset.

I don't think we want to drop anything because it makes the API
ill suited for the debugging purpose.

devb should be returned with an invalid dev_id if I understand your
example. Maybe it should return with -1 as the dev_id instead of 0, to
make the debugging a bit better.

Userspace should look at only NOT_RESETTABLE to determine if it
proceeds or not, and it should use the valid dev_id list to iterate
over the devices it has open to do the config stuff.

> OTOH, devE is unopened, affected, and un-owned, and we
> previously agreed against the opportunistic un-opened/un-owned loophole.

NOT_RESETABLE should be returned in this case, yes.

If we want to enable userspace to use the loophole it should be an
additional flag. RESETABLE_FOR_NOW or something

> I think we're narrowing in on an interface that isn't as arbitrary.  If
> we assume the restrictions that Jason proposes, then cdev is exclusively
> a kernel determined reset availability model

Yes, I think this is probably best looking forward.

> where I'd agree that
> passing device-fds as a proof of ownership is pointless.  The group
> interface would therefore remain exclusively a proof-of-ownership
> model since we have no incentive to extend it to kernel-determined
> given the limited use case of all affected devices managed by the same
> vfio container.

Yes

> Moot, but there's actually enough information there to infer IOMMU
> groups for each device, but we probably can't prove that would always
> be the case.  If we adopt Jason's proposal though, I don't see that we
> need either a group-id or BDF capability, the BDF is only for debug
> reporting.  However, there is a new burden on the kernel to identify
> the affected, un-owned devices for that report.  

Yes and yes

Jason
