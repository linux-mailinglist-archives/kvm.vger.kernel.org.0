Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B72C53BE61
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiFBTIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiFBTIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:08:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B66113D;
        Thu,  2 Jun 2022 12:08:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmGL5XXPkwjo6syV+jKgHGGg8BGzC4pYtH0pVYmvVEIomGbOPTf/AyRY+vgkNf4DvnV257qTDptiLlNCj+juVXFOfJPT2iCwGQtC6SMq6pAdAWr1pabsvgh+x8dn3blUd3zuszjY2kgy9ciWonemcbaPJsexWKPomxp9RYctkfo8sucao3tgeg+l7estgp6uJs0Nf7bcv+Rwdg05VTp1eIqVk3rfayqbOCQi/mDaojGzfFDRa35oTzCZEXVKQqe4RGgp8gmG2vTFKLlGNs0kT4ZerLqLzStnbzOEGPLXr/TWc5ttUDm1RKKZHjYbXh8ZdmcVXRTZvzuvJxj6cDolxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hR7+/zUkdyH3BLA6AYayn/r8IX2lVsswRWYfGCjJjIU=;
 b=nz7zdEwxRKrh2M5rChVjtCvJb1wHSSM8gwwaGifMPQwT7mAu0579/OmMmTG8lP+l/WNvDKBDdNPyYi6737XPoWvXs+snjAzVBYn4P61J/XZvmZpGNApbmVkPxQ4mbiOVGmVbFsrSv+eT2xtIhutfqqEGNBh0p1XGpY2VPXJYu8hESIPpexlCX944/As40AG3/xDHfvX9B7iSEFyUan4ScH3YB9LlCRuPr5TGx7ePC/I5PYLzU5Z/LNMGznHsLLvxW5ReoivU2bQIwkH7/5xCXbdyh5MQGkBakYl99HTmJuesahsFIKD5Oq6e1mieX8wh/O3Z8w6XzzGAAOPewdvwLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR7+/zUkdyH3BLA6AYayn/r8IX2lVsswRWYfGCjJjIU=;
 b=A5+nLPdjfMn7nVe3v++NSCJTm6U/RyadxT8zWeNevkom4eow7GmTpSXyM/Ey6XouW+ajGQZ7kZhzH2X4Lik7YtE2tLEIg5tFTV4epgxO5O+3S3vVxYa05Az9wHrJsTdlo5tt21opFm4LstpqrXWomjo7yxpJKgmOxKTz8X/gzQWOd9yKBOHI7728RI6Y0+SHkqkNAjK6Rv/QW8ofqkyeftdirMsqfPX8tf76MpUDXh63zJXl5sqWuFXQubRYENBeUB3EXCPtV6lVaHmRttamkhY33kd4zffGurzNCHE9+uaO6lOz3azG1vYJFJC90L6HRJtAe5z/Gv/G5wFJRYA+Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4716.namprd12.prod.outlook.com (2603:10b6:5:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 19:08:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:08:41 +0000
Date:   Thu, 2 Jun 2022 16:08:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 09/18] vfio/ccw: Create an OPEN FSM Event
Message-ID: <20220602190840.GF3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-10-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-10-farman@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25d6f5ae-01df-4570-2514-08da44cb4ec7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4716:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4716087A0A037D31C9F3AB2EC2DE9@DM6PR12MB4716.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRnTaWrVPg/1sjc6v+OGfJY6aVxCOTZK39e7IJboDczXgj+WeSV8FIAvgssgyqk261q637wFUaL39nZ1yIzLPWMK7tVvr0f58Vh2U+nD3R6NGBV54op845NgjwvvBGFMKb4uUzYnV/GeRDorD/mYpHax8P1qPFX7O1aq1X+95/m9rIr0kyDCr5vx823zku0DM2f+T1NTRF3e2O8nvZH/tafd64RY4tDkp1jZM7qFRMhcoXYRn3VuiYhsLwDQxenHayghQqEfVrYsA0UMCVm02O6bz5z745VFO/ZYxnG3D83ZPVOjG3uPoqb3w8vpvo3I4pz4wq0SeouErE/BWO/mrso6mLi0cDdno92ebse1Em8MSJPJHcLOpsMSsqVs+LcETNr0Zjtb2t5SVQWjXHX8zZn+GEExrZR8JtWrq7Rbza++QqkJFxSVwtU8GWcJEngn+VDbI8elLh8mDuAZazFoGD+x3aJsvLqvHFHN5NsuziO9ehnfIjFxHzvw1wkec53XAv7rMvXCA2kxbaYr7iY5+xiGQBC8hNsHcd4T65iXATIOg1mFa2T/DAM6ULXr1QfuxBdHNa1uJETPXUes6NIBchNxHWdpTboNy7qiKQZoGDa2hdd9gQGPc4G+QIPW48qd4xfNzoaaJXrs5+z1zq4+Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(8936002)(36756003)(86362001)(2906002)(5660300002)(6506007)(508600001)(4744005)(33656002)(6512007)(6486002)(8676002)(66476007)(4326008)(186003)(2616005)(83380400001)(316002)(54906003)(6916009)(38100700002)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtDmI96aTmvTyKDMdWhLXMek9zGDkz+fKNj4Ko3ZLaX3369dSP/+Ux1zYKrG?=
 =?us-ascii?Q?yTCZr0FjxJ7qcO5EEVrSQQs9eXjXrM8NrIrli9ncAMB2BGmFNmLBH/aEmJmk?=
 =?us-ascii?Q?TNGCzcXBTebF+Hz9XMhBen63HSuj4+8/BqOEStUTUDPdD5jxnroQ/JiwrEG+?=
 =?us-ascii?Q?a6eMvqx7dMv8UMT1lkBCXssO1aMV69avHp/TARu4iIax6h9Af099/FHV302G?=
 =?us-ascii?Q?QmC57zhLiq0tNqNB5/izBLS3HWWannvBuD33MDFAzhI2DM/Hk8XRV5ZTlPSb?=
 =?us-ascii?Q?dqADo0ROHZ/Vfs/8tuKZMtu8QIl0sZtBY9qkf6+dCAA/3oLslA+gZOm6yJ2Q?=
 =?us-ascii?Q?zkruA7Szr6hI4n+iSnsApnkFKJp+6y8SWiqa1KMfyyc4N9C4t+FklbaFqzgx?=
 =?us-ascii?Q?M/zF40eKBV6ygSB7dF3S1mAEZeaECPyW0/XQ7ihmrAFEPNMCYh9LvlaFcaWp?=
 =?us-ascii?Q?0M0Ph+CaCKk1XStvzOOlCMr+8+gu7/3Aabtkp69k1WuPo+zaFxT/hDrIkDdw?=
 =?us-ascii?Q?xEgRShI1wk+y5UoFftZ9NIVZbnQgk52bhoHdETQJ2Qk92tLyZwEy+tTr03Dd?=
 =?us-ascii?Q?oEW7sXtDYYN4c1sBOAhTng72+RVBg5D6loBQVWut2NE7l0bIaIgoSC2UD1j1?=
 =?us-ascii?Q?G0kPfe6lDsnssK9SOZz3sTm+6hKEMoz1z3oq2qNcjZx3Qbz3YW6iShMBXzvc?=
 =?us-ascii?Q?Rw1s4bmiEdeAy0Kl89xtWkvKVLm1CzGRmfuNAw4IhraVbPG4L4+uWl7oEeJ3?=
 =?us-ascii?Q?BNIBcvg7hcnKSKsC3gGoax5eIYR++LqDGlzQ/LLLzkKo3+dQtGi/Dzt1fP/S?=
 =?us-ascii?Q?exHH+aXQGiiugCpkPKMuCDT941WMnNes7moq4U5QwhCTibFpZfJLQhgmJdSL?=
 =?us-ascii?Q?k6mEX8AV6mcUue+wKXDYkvdam1joLmVKT+5GdwwV//z2eL0YTDwrvvx0eaUd?=
 =?us-ascii?Q?vvR3gmk9eSnuVucGVajMP8nVCWG0ImQOsoMOmJLxN45OzQFTg8+Gpa42oBnu?=
 =?us-ascii?Q?xXQt5QVjPdbzCpnUqM6VsLVP9cza44Ah1iiX0YbIxtBxTVt3olF/VIT7vkZz?=
 =?us-ascii?Q?kIXLJq/yzZ492Yf8UQ5jg0BggYzK40tGJVW84rjgGxT6yxrsQxYgqEsV92QW?=
 =?us-ascii?Q?1MMXgFIk0qO4jkt/haIbKdE1+AhxfemZyDseffWk9e193g/tK92PUgyi6izI?=
 =?us-ascii?Q?7rmejmXX4mEknwT1DTwGfobXSUe2X8s6GtHJlm7OHPGRjEavlW+Ic1h5wkQW?=
 =?us-ascii?Q?GAqvLAdylhUrdkH4+DNl3nfIooGTqqhvDQszjAQ56Rux06abquPN+vBAKSHB?=
 =?us-ascii?Q?/7RhbJBiG9fSrUcsp+I5ikbUjScRv2nKpGuW1gFl04i7iwMnDIv5li77M+Op?=
 =?us-ascii?Q?PevU0Ajcd7+e43oXpxJY4ZMOexciHYb5U02CwUtB3+ae53cLCOdC/fpUz5zV?=
 =?us-ascii?Q?DAxxa0JbcTf9bSGCPlgFISjMj5fxtRXEsZDpKh03VhAW64fFYye/SiTflLDD?=
 =?us-ascii?Q?sk138IIEhD9GThK3JteMasXQddmiNXbjDUPORvpCexj2VzNnac/xyyRzcadu?=
 =?us-ascii?Q?DYAA3AkgHoxJDv9mr9ZD9zu1Ju/IOt/fJ2ycEX16/+fQmYpjYgvyOR6nJyXO?=
 =?us-ascii?Q?3gHkVzFApay7vQR5RyrjrKYNo73+d/pBWFcRqycaZxetgiArVhPlGIwkbYdp?=
 =?us-ascii?Q?zmNUfWCoYp/PVUL0cfWOy8sdZyEo87RoLczFeYcd7tUtThxEKukqsA6zW/AA?=
 =?us-ascii?Q?iK8/umpA4A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d6f5ae-01df-4570-2514-08da44cb4ec7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:08:41.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSt//9WrgR61MichyFHX5RF+pz6zccg5HiO4MjQisx3eI6nyYzLB3BONkBEiYk/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4716
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:39PM +0200, Eric Farman wrote:
> Move the process of enabling a subchannel for use by vfio-ccw
> into the FSM, such that it can manage the sequence of lifecycle
> events for the device.
> 
> That is, if the FSM state is NOT_OPER(erational), then do the work
> that would enable the subchannel and move the FSM to STANDBY state.
> An attempt to perform this event again from any of the other operating
> states (IDLE, CP_PROCESSING, CP_PENDING) will convert the device back
> to NOT_OPER so the configuration process can be started again.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     |  9 ++-------
>  drivers/s390/cio/vfio_ccw_fsm.c     | 21 +++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_private.h |  1 +
>  3 files changed, 24 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
