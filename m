Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EAB6C66A8
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 12:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCWLdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 07:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCWLd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 07:33:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7852C1043F;
        Thu, 23 Mar 2023 04:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1YiV9qYCrkWLEmx7mbl0n0rKq+vIyDipFDNLUOWefxVYB0f9PlKikjbIM740+QC1Nj32705OkDzu903JyNx4tG3q045js3PiJHt6nLd51l6YTrpXDYf4q/MwZJGM08B/d7hIP+usBQLPIa0yCrawKnXPz8qG112ME12nmX9SJ3g5SH32M5ng0DpoqxqQmo4p+lnebxlLSLvjLx0XtubIqKqvqb664QoYTwcaexWGXXbu5+u2ZiSkLuGX/1/cHAntPa4Y5y2naBz/k5UxKhYM21cauNFfItE1G1VfLGBm5zMyRguqbX1REDFZkQNBcMt/aLCv8f7/l8blyLsZNCS+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNryYGjUqxbEHVFMTJ9N89uM+/J5UUaFISkKIOcP4e8=;
 b=MaDlzB2j14xhSrIWpwn3LczSaDqxkJ0aGL28fNJDS95Ys832fNtwGCBo8uwRhvNk9x/HbG9n0SCLZIuOKjoaj4Jnj9w1qy0DIpKF36lPMEUX7Gzgx9TIDKbzIuzSOGwVzJSM9B2a0ZB2q3kNhs2qKbNu1+QrhQJtGACHzCKMYPrEksC22BsjF1WIvt8ouy2stfhGh2WGNGPRz2uuYVjNrPOwXS2bzKFprcy8QBUkp6cWYlsObWUn1nwgV7bvkF1Xn6L5wQjgqRLvL1lmFlc3wFxPBwUSOL+Puu7xb8n+Z3O70kOpPaOU1xfcem+Q8aGuoJuHRcsj47LLnhg0ZOjk7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNryYGjUqxbEHVFMTJ9N89uM+/J5UUaFISkKIOcP4e8=;
 b=ajgrLa7Pbce4PlUlYMVgvZbsxeuFknkeuS+fBEEJZ44LvXnPSX90d+RCSgy13N/v1s0MVVVk6eQbBs5ur/JZqxl87xGW1N6DMnavMvk2arug6BWRhi9mOZ/YFiJfP2BOkD7BG0uWZ3RvWC2drJDl6922vg6gfjztHqPmEfHO7OCFCa7bvqz4lS3E4e5I+37w1500WJiZW67HnfRwpFBbaXSFaZo/rah33YAZzGrwjoyLGgxXxAaZxH11bm8PyM+FjrAYfL9G0nZaXScNIWzPm20eqHFurctCifS2yBRXkH+GcwRJAyDqEqILzSr/mms7ylPVd3MIqAq32/gBUA2CYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 11:33:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 11:33:26 +0000
Date:   Thu, 23 Mar 2023 08:33:24 -0300
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
Subject: Re: [PATCH 3/7] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBw5BAWmNQgayVd0@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-4-yi.l.liu@intel.com>
 <ZBit0rBhEtUx7y0c@nvidia.com>
 <DS0PR11MB7529A977D2E82247AAF53264C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529A977D2E82247AAF53264C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0167.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: b6278c94-5966-443c-ae42-08db2b926af8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQOOmvnTVXsqlp5b4VXN2R5/iiN1qD3VzxvRU0Ja1QJTxLmLZ07bI7ZWd6q/hr2U3DCNfde3pMxB9kj7Ibw6BTiA++dMKCqV6aNqeyP1j7P19ChLgLGgGfBLPLOM9AmKnHlkV1BcMYswvd10zcS8oaogCjLWyU0Y523K5MOkPyK/TVmR1dBjTLL6IR+lsrZgaAWN/nOuX/v34GMR8LLWy3pC9H3U1v/BbAJ0IH50lIuB63HeHV17sanrGVtrhXFU5t06HHIgIDm5x73rq6HBjotSGEp9iZPReE9yqhdhDr+bA95ZetbOLqWwFsFVDsm11ICbPO/6Cyz4emekWShklv8Waz+lnCpoLe2t/lfZQS9Nu3c+LQE7cpB8xAZCTqBiLccpHQXaQ9Uhe4VnDDWp5vI1FZvadSEQDr9WYh3WmFpDtAMWzoySr++0E1IOtQVCoR6co/8Kgbun1LhViMPRLo+yE5CpVB0O+YpU+J5/L5fl1cecTt+mnLLGVbCtrXXC2dh8kZVVUH70WueWh+OGlE6z7SPJoQ2yBJJsSNkdTzhgatin2uzZ2trJZYjp3YS5Z23uPaZYm+35jNGKQ1NgWYJe2QhlLwAil7P0XRgVa61HwAn5QgOKUhEauniAWvjN4QHLV6klOJXFIJAbOg/9AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(66946007)(66556008)(66476007)(8936002)(41300700001)(6916009)(4326008)(86362001)(8676002)(36756003)(38100700002)(26005)(6512007)(6506007)(2616005)(186003)(316002)(478600001)(6486002)(54906003)(2906002)(5660300002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?imRZV0rhrVLA6dv5+X8iomgjSrXjsfclU4qVRfi7Vm9cWZC139/jFx7ZAtfr?=
 =?us-ascii?Q?o+7UahlHQawhjaEbvIgsO1js/3KcVWbrN6L2WaXhPz7QtMs+3kMpaEWbd1sZ?=
 =?us-ascii?Q?0zB/IQIVZsE5vv0bBoGmkebmuyIJTxZ7R9iwzxzAKPvQv8IVXnSWUDKTiPT/?=
 =?us-ascii?Q?ZP9QBiE7jvf+svV4xWYbY5puBeLC1428RYuSkoB/Mn39vLZ5X+xVLDC+gCJE?=
 =?us-ascii?Q?N9KTI1WN12430UBIDTpBmVevBmVBR0821D0YJwFOw+sYNrVyVy66FP3WBUiq?=
 =?us-ascii?Q?KM4E+QTffOijSQ+Heg2yD4aFb3AVTWF7QVoJSbkc5GBjY9trskCQtkwDDHmc?=
 =?us-ascii?Q?J4wuGvl6TP2yeoB7v7EDN8k1hP1tqMPYGe9UVCHhGz8ERCCLGM5rhSQvPoGM?=
 =?us-ascii?Q?6KKRtYso8kv2bqrWWEaO0Ht0FGDEap9CzNsisOG5lrGrxs2fnvu2kDIT2K5t?=
 =?us-ascii?Q?0GvP+EWWOYXNcQRssFv+qvTXs1EBWW8UkQHucg4haPbSYJZ2PgV+Xn+w0nnk?=
 =?us-ascii?Q?AtTG2UjTFQbD2gN9xOzjlgIXaaBcG+gowGvP6Kl7Vfj2HKdtOil33Og2KTQo?=
 =?us-ascii?Q?HYo0f08qSPepSCpL/e45vIhZ8xgQEuw8TGnUih11kCBhixyQ+cCAaiY4L0x4?=
 =?us-ascii?Q?YYjxV1kGikdxHL4tOI1q16k5hWMiqw2zbC6xnY6pfyjcw1ipsZnOc9S0jopc?=
 =?us-ascii?Q?K4iWR9tDaAG0I8unq2T5pjExqdhWRJI/94p3yk2FbrktSwYq+MeI+hqwzLW0?=
 =?us-ascii?Q?dWFFPNyweX4goKqvZ6Ee26qcTengDfmsHb+ulJhb47uxRGrJROohnEWL1/XD?=
 =?us-ascii?Q?p9OTihb540cbAuvSbOimAHx/BXjWH0XTfcigRu2fLryFkpESF9d575p09kWZ?=
 =?us-ascii?Q?N9sl3NkNQxw5xm5AlcehNLT2YMC9jQVjsgjEuPpWWKf11oSusoXIOiOuivd6?=
 =?us-ascii?Q?2xPoBJ+tzNOgaXa/vJXSayD+NOTec96r8SA3034Kv1Tt81+I5bvLHXDGRo/B?=
 =?us-ascii?Q?jBzUHf7tA/m65+8mADFcjubLRSspNPslErYvau0+sYYCZ7dPKCvRK2/MtxCI?=
 =?us-ascii?Q?rwal2nowv0AGKscNFZIw+cBRTdmfWO6MTTia1ors4nutZpZeJQ0Fj0V86UDo?=
 =?us-ascii?Q?R6QkCXdgqDNCavpAitGSAzDsac8Eub5NxV6Ac/NRpp47AhipYUAtwb87A5dq?=
 =?us-ascii?Q?ayUW9Dr1yW3Q3mF0XWJTfb70LcMvVhgYnfMeJJOM7qURV/rvvqjFjyB7kyk6?=
 =?us-ascii?Q?bDBE6g75yfUcq9NXmfRT0dYvOtjG4eiVB4W2Jxqz+C//aBgJXGzogJwXGbB2?=
 =?us-ascii?Q?yQAXI7YY15xJpfC8G83WqKRkbIIbunmYSVk4zyENf+Tj7SuocoNz7vgKwg8x?=
 =?us-ascii?Q?XXtmOhmMKPATqAkh8Hulv5lsLyB7eZjdsiOcOZqQv2r56bxyuW5ZEhmiRCps?=
 =?us-ascii?Q?cKRgNcPs+uen0Wd5EiPiqzyj/2GG38Wew+Q8j1AvX/cLvqGasuTtwMZSUAhb?=
 =?us-ascii?Q?da/F0H2Gx6WszBq53MYTRNPhv5y1y+XJijji71LE4YIg7zgmJwVdKsXb6bYi?=
 =?us-ascii?Q?+ZVdk8iQT/wuW/G0dz/QxOHXUEqyZtRkWooxPJly?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6278c94-5966-443c-ae42-08db2b926af8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:33:26.4833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUlMhWWn2RLi08XUgvIDd+CGIjEiMyRwM/FxyU281SQsqLZAqK++pJsznnyC28W8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 10:21:48AM +0000, Liu, Yi L wrote:
> > It would also be a nice touch to include a new vfio_pci_hot_reset_info
> > that returns the dev_id's of the other devices in the reset group
> > instead of a BDF. It would be alot easier for userspace to work with.
> 
> Yeah, just as we are chatting in another thread. Btw. Do we expect the
> new _INFO ioctl that return dev_ids work for the legacy group path under
> compat mode? If no, then I may need to organize this series after cdev
> series since dev_id is returned to user in cdev series.

It shouldn't matter, just go through evey device, check if it is open,
check if it has an iommufd_ctx that its the same as the current device
and then convert the bind object to a dev_id.

Shouldn't matter one bit how iommufd got attached

It isn't usable without the cdev series, but it can safely be put
ahead of it.

Jason
