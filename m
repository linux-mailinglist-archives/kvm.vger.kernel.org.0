Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF668A087
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjBCRl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBCRl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:41:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D455B2125
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 09:41:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5tlfV4QuXHJxcIIH6L8aHaZvOK6hm3AkbtVNjYoe2+r63qWNU/PJBesKHW+gYjvGZgsuS58H/AdrrCHndJ6Oibvs/M19uqSrG5Sze+pzxOIOcqxI5Uu59X5I0vttdqkw0b3aaYt5tS7BlvfFUmsjxCTThPJ97j20np7KRHLwhSP/8EuQDYe5s9hCouceZyt+gqI7nFbEN7DU9e9/fGeWy+oeXQskx34fjwWntXO2K0blMdfsUono8h1ZZ0T6dhWFQaTGp9uGXzPLR9u/7UlbamNA/4rLOb/ROZ4pV/UkST7h2ZdhiE+9mTy5bZbsYhVnhkDAePZiofbMWP6yAVrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9tJRIajPhbRlCIDevAJjZf/OMV57IRh1NDB4Y+N9VY=;
 b=lJk2MnuAuiiVFB5Ka4MhpZYUGUFg41pITqMVAeTt/ErA/7fdXSUYs9yCoUotq5bcHg+ZztTPRAZ8DOooGZvGeBPbfHY9iXwt8MdxkT+KFCQD7m5dIH8zVlHdP9LaFfp2ViTst5X/QaGL5q/pY6dzs0rmzLVInBWv6u18h1zBqFJeK8PKgjjRVsAnsNGWD/w2Z5Hovy9M46Q/0vko1NQmwRPhDAopIHxC8+BAOjQrUMYAxHdQSX+kPHE2dW/Ru0Wp9KILRdsLQE6t9j4tje9sTfSSoPvrJh8Qcp6k0rY+hla2GnuoubO7/V+epyHmOjl9WAptgbwbt2ux1yzlvmAUrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9tJRIajPhbRlCIDevAJjZf/OMV57IRh1NDB4Y+N9VY=;
 b=EE9pLTDm6PiJdUf31gfytNhXqPWf2pQW519XvjeZYgo0CY2d065wiOL9w7GPf6n1NXlCRV/cinFJBwJERPi3k20fXYOIYC9VO0e/lDnebbCtNl6fpPqwLs32Ud6Z2M2eZTje9mlYlU6dlNZaNue5h691FryZHJs5PMKPqfF/+MEmgUbkBpq7A6vn2Ufvjtei7W9ksB66Zn5CUl5zblRbAYdwK2wvh4WufwT7TDHY6WrcnpVbUtS6nj0j/9jF2AmN/KHW2onJbtNlJV33k/o/cIALzUJ+DNy2o60W+m7HosZwfPd1TxcCJlIVgkvLEfZk484uzns6az6Wu9anaP7ShQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8188.namprd12.prod.outlook.com (2603:10b6:610:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 17:41:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 17:41:22 +0000
Date:   Fri, 3 Feb 2023 13:41:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y91HQUFrY5jbwoHF@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:208:32e::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8188:EE_
X-MS-Office365-Filtering-Correlation-Id: 47b72d0b-de60-4c52-fab4-08db060ddda2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vtg3kJMrGXZX7pp169qvE6FTrweqvJd7ojtQTPPiiH1yRaPAPxJKkDx0dNw+XUpIWSkZ2aqUUnl/RQtBp35OPVaadSlRPvAH1SEjf8gy0xeA5hoc0+wmPDwvpU7ZpCrT0deL5knvakPhub8fMrEiuDOjr5yzF6LgeImsNSZAadHRfhJf8zZRAmX7mHnMep+UrJ8qJfGS5BbWYMjtOd9UhoQWnsRpvwW949yuqsz3cFq12At8riLa9eX1EiDQLCCkJEHYaFwFnSh5W5AFavEsmx9kPnKuafxEWRWmPeONp5FmVTL53KrfRzxjrIx8/niVc0MyN/pV+2+kLVLRR/akbi7TVCzDLOYBQFvPTHytdHPvvIzEWSgFtw7SNcAbuvaum3NHN4Hc6VCYbjUsw41GXhOEnqHT63gYFPlM/YGRy+VzTPped76ucMfwzb5/33WnPdYJ9NLe9bwFabby7fOptRIlRQgpL5lRsA69MXkzNGF1comoGKPNbudXj1vZLxr8klmHVy5fBJCX5xAjblBQo0lKaDOx/czyX4kA3TQPISre/RLSKd0r6+3qomReAWGzLCf0E4MJuAt1FLGjT8MvMmMb7S1cs9SPlwnTlQys85rdp430E2E0tr33DIv8zn3h+j0eUbVGIBtmyKB48DqgHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199018)(36756003)(86362001)(6486002)(8676002)(66476007)(7416002)(478600001)(4744005)(41300700001)(316002)(54906003)(5660300002)(66556008)(6916009)(2906002)(6512007)(66946007)(8936002)(4326008)(6506007)(38100700002)(186003)(2616005)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wRgvH7B/sACXuDE4H02NFK/lhTC7BEhVA6n5R5hapIezcoqOR86Ofmp3Lsr?=
 =?us-ascii?Q?REoKek4BCT/GWOP8i+1EFB3JjnTAdzqKwyOhptZ4nsw3mdaDXzuTQ2V5Ezy5?=
 =?us-ascii?Q?kLR3WxDnOPfjsvDQ9GHl8v6wBaZlxEKvYC2pzRZQ/baSgwLu0w2MPB1gNsUe?=
 =?us-ascii?Q?JqtwRT66meEtrXXARxvkYYdAr9N4oVVW90NKFwYYJkpOWlWrs7SWfrDqC5HH?=
 =?us-ascii?Q?8LZTNJG7Ga8YhJxz70rbSk+kfOVuRayeoMNGzCh7RiFP2L4XKHxZuZj08V3p?=
 =?us-ascii?Q?02RQk46BjrzDNO1lnm4hQsdr7lpn5+xqfKcBA8LX4xWeonqglbq6CFQ6u0r0?=
 =?us-ascii?Q?q2gHmZ/jHvhfoeRRKYOjePlxLviGyLYftauQnq+byuGXh1OxPWvGvf499ISW?=
 =?us-ascii?Q?5i3h+eqT6WTw6EbckuJ/gtX7IJSG+/01cPaAvrdLBoJGj+LzCc4LTob+zqRR?=
 =?us-ascii?Q?J1B5+l8bqxgMdhM24aNohe//G6ptz04KLTIFXtNSVow+Zs5TcvlmBzosEraJ?=
 =?us-ascii?Q?iWsMhawF+SshQLcZHPmvVXyESBGfsi+ZsFfR6oPZafB0q7ZZZIFPFQDN8TLq?=
 =?us-ascii?Q?lR4URZV5HGT+CG0lXcr1cVwT+u0+ai+2Xl6RbXKBa3WOe20IX7Q4cTuZgibE?=
 =?us-ascii?Q?SdpTnB4RomfqCDinc/zHAjKQ//bnZniYKypch7n4S4wPtBqPzYGsDc+0HEUM?=
 =?us-ascii?Q?OHb5wFUdrGCCIirqoGfn0PMZUZg7Rkpg5T6EqBKoBQ87A7UiZh+0kMxlMyIF?=
 =?us-ascii?Q?RdQhtpj2zdwMCzaBVrzFafyddPLM6faCbWYv1ITrz6hj7pU6+V+ZEjbR+UhV?=
 =?us-ascii?Q?5F43mOtBajNhNf9w44FxHmExbVNUmxnKsu2wCmlmcuREK7OFVXAAiT5mgcdZ?=
 =?us-ascii?Q?lkHzvjK5D29mRZXQKxUPUtmoFlaskg0Cc3uV/rpI+714nGXHvPCXPlAoGY/p?=
 =?us-ascii?Q?FDWFFx93IxqWX9Q3wAYi6dAv81WOe7jYQGuoJGKOh4yboW0sebAOCnP6qoAl?=
 =?us-ascii?Q?De5Zj51dYN2wBomUmqsNRcDRXrm0GlZIXI4Wtrkw+lCLg+NlD5MrXbPaUUf8?=
 =?us-ascii?Q?UCORZ0baHGoykqTnNL9F2Se6/sdKQOQLVyoBHMhEIBJci9sgjgs6pVJXZfh1?=
 =?us-ascii?Q?Od3Yfm+jqgxDxZdDHNl0Nt1cCe5I0NEGQCiQB2gFvlfTthWs7LQWMvykOBHH?=
 =?us-ascii?Q?1IViJvS5ChQxmRe9BRE2E2Ka228NlIkRLk/YtYEFcitu6BQIA1PyvX+Glj68?=
 =?us-ascii?Q?Y3dHDVmZX/WXVf89XBjI2EEj/BPqJRSQlfgazsHWG9xIIA4FiCDjGs0EVQPc?=
 =?us-ascii?Q?hNSoN/DmCKWkEB24TLDQRqQBgDzOSsh9rcX23IRep0iCV1BiugNn2zzsMpIh?=
 =?us-ascii?Q?i8LkHWSQDEuZt7QtngIZ7Mv/wq0zXmIDuE7jD2Ao+nTLUCBdjpqBQ7jhWPGk?=
 =?us-ascii?Q?Gg9aY+7zJ3mpuN5FA7uiNZmSjwMmlOWm1cNuwoN5lX1x1kPzOt25t8b0ngUx?=
 =?us-ascii?Q?FJ5d7O/VzmRn3k8JTlR//cAOuVceUddvfV+lbkX+VdfDVcuWkMG2DhQlw1Ol?=
 =?us-ascii?Q?e7ZR9H73Z58lbITxc59RK8di8xp0Ua3l2daYE0gg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b72d0b-de60-4c52-fab4-08db060ddda2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 17:41:22.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5gH3J+QsCyBHi58he3YwrFo6UE8CypjfmPUSkMOqElIdQ5GLdlwkRO+s8eMgykf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023 at 05:34:15AM +0000, Liu, Yi L wrote:

> This seems to be ok. The group path will attach the group to an auto-allocated
> iommu_domain, while the cdev path actually waits for userspace to
> attach it to an IOAS. Userspace should take care of it. It should ensure
> the devices in the same group should be attached to the same domain.

Aren't there problems when someone closes the group or device FD while
the other one is still open though?

Jason
