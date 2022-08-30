Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26F5A68D2
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiH3Qwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiH3QwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 12:52:18 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC02630E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:51:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWaZKGRsgki2RhO9t2bkz/kipehZD2kiX2TosCrVTtzMyjV+1rR036f4g6IXvT351NkP2I6hjPwynM2zh4q164WGHJ3LFX/mHnafxfilHgX9m13wmgmgoyxgol6W5T9cJ5WyZXq6Ene3TGxAYJ3AzXu3a/t5a+z8H1KEbRZ2gK8mZqfdYyMf9oO5ey++J/i+Bu3VVIR5fl+zGC28S3WXP04f7LQti7dEv09Nm07TcfhFRTRnokt9OPlWXLKrm+SmsDW89PGmRgykgW7ILQZkQUI1d+BykeqNcLlXHEFU6BMP1SZjWCtpZUdTqrfHXXG4m8Y51HP0Dm0XjrrctUT02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8Ha3CgC/+nMeChqxR7ZupMH4IlD9/Y7GhqbLNcwH4g=;
 b=S2Q9+K/Gxvdf8i44DWLM4nrv/HzUjWbZstR5xoAutL5yubESmCtr1jLIWeQ/0GZclhW+en5jk2LOW/3YyaXclru8BtIHF5pxGIvE2INDY8twOupSRTK/xq20+UlzMAqhhUErUHbFknLpcvgy1I8KOih7t3wJ5gexWyWW+RqSP/i+wxs3ykU6npA3qxXLHj9WfNWx65HV1O0RCeFZnZ19Scj5YXOp/CuCIkkYhr+NjcByNU6H0AZ0lSG+JvnAfvB2mxACZ6gNfNhDq80KBglu712Yw6zLYWlfXTMjTcCjwrmWUZFKakMH0slbRS2Yy78pKCbbXw+PzlcLWFRCslIIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8Ha3CgC/+nMeChqxR7ZupMH4IlD9/Y7GhqbLNcwH4g=;
 b=kjrmxz7MoRpAJjmOFf9clhkaYquXE81CIDcnDWuWyS1xn7ZOsnyGIyoPA7FrWgeXndWl7RzVSm1Exkcyn/NIPfY6SYXob7m2T4SUGn7qxcF2eRgd7mWc29NQWR9TNyfXam1hbBpaFVdwEPLdFKXgDgk0O4RE3YW7UA/6dZrK2S9H71f2NVhTOcSyDulpGEeZfMdTOhv3FFiEMoi58nQESOL15ApOgq/tb15hYkJxWSNWjJPo/V+3yy3VzDddptL0Rz6LHR8vdMn7VxDcSeoPinuVSCYZZY4GxnJyLH3WV3HKFeayudo+qs8ofo3gC0Z3FXcmxVPk2jl9NYMMQykMXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB2809.namprd12.prod.outlook.com (2603:10b6:5:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Tue, 30 Aug
 2022 16:51:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 16:51:19 +0000
Date:   Tue, 30 Aug 2022 13:51:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Message-ID: <Yw5ABqI20sMyNiG9@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YwzbB5NZGOqOsOVK@nvidia.com>
 <20220830104231.0bbb7c89.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830104231.0bbb7c89.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0034.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d373087f-30fa-4b8f-b011-08da8aa7dc8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2809:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksqWtH6o1iFRh4QVIP2yD76rLygUIjsmGNosqD5+8ZOfBYIPqBPR1Ikw7ibQjU/UOAco/18hK9Tv0HNpV4wzyRMYn4il1LjSNj7Ud9We0DHTwQamPH+4COol/AmQeI/48AO7Z2STNz27sZjoQcBR15JqsOlzLcrGAepZRL8duyeuou7hbtky1biGaxQwOzcczRNhz6s1/8GfbEIenz+435EGnJldZZWBfk0YuW7aO0zft2l2Co8flL0IqLD6zRScoI2rYKS7ahFKE8D7UNku/nNoKK2bkeWQa1sZV0WoVM53b9h6KYlK5VA0rpRqTj7W9pgsckW2/B/bfxuA0UbOgNPLVDqzxTXAGAlgO6rDlrLWshlLx8SUpx6Ja/mwYCLccAQPhgC3sii8FYZkPBaXI0erEzDQ774lLrwws66rtth3ADav0Kodcawu2/nsr1aSYSFvVN/7WC/jo3dY3PWO/gM/5jeMHmLt5X2OB6mWU12/5aCMNPtkAIUS9YOAA4o4gEEPZzCA3IG0Tj/JmIF1+0/fzX0aM4sGYHFsC8BwH38SgBnYZmB1TRk7/kQ9x5p6MkwoR5HsiHcKgVFhPj2LIEfwkgGxuS9dy98DHKae49OWTlrGfXct5h6YqNsjfZkCWLFrHN3UmBskzsdQV9G5GUamodTfZjwv/tFHkmJMAbAFZESMJwHOgCtp6OOQBdvBtacRh/1tlF0suD571tNI+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8936002)(8676002)(66946007)(316002)(66476007)(66556008)(4326008)(54906003)(6486002)(86362001)(6916009)(478600001)(5660300002)(36756003)(41300700001)(6506007)(2616005)(6512007)(26005)(2906002)(38100700002)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uBWfayDElf8W+ia2vifpW/teVSeDKBdpmvGxaaOqtAwvwmL8xTJMLDE2TiJt?=
 =?us-ascii?Q?8ILz2KT8ivMEOcdZff05yllrK5A02JTS6Rnod264hzW4mSOliQ+72vKLMAzn?=
 =?us-ascii?Q?ZB6HtiTWlsmUhjQTkxuU3p/Xgcq+beCiHVhAgUD4Z02UYX6jhQqtRskDWcl8?=
 =?us-ascii?Q?6uTQI+jcpUpMDDWJiS8HrS8D/lWmv1MT6TVHwf8KSh/K3pfBzAN0JHLkHtLf?=
 =?us-ascii?Q?QGXNETh8J//BZM3eFVo9cJn52eIXgITdsV7eXWK26YULNcVCDPNxiV97T2iL?=
 =?us-ascii?Q?rCub10UhO0dN6BIwKJc8kx/YFrQmvtlocwE7354ndJZglm76Bs4m5nDGMprd?=
 =?us-ascii?Q?ayadH/yNyC8wg2uH/v5Mv1JrPCD2tHx8++rlew2ziHIbo1uvH1xpwft2vBZ/?=
 =?us-ascii?Q?aqoOap9zblToSWSHohPSMVSM0FO2Poc/n+MreVG2n/Kcau9Ud7f4ybuaT4/W?=
 =?us-ascii?Q?wdN5CzitgKiPdp2alkVrxJwhBEYkD+Hli2eQTij4pEYEJ2TtYgQFnve9M7g9?=
 =?us-ascii?Q?ETxNIR9Z5a0bsjamJVwXbpxgkop+s00QEKQLtCVMpYmtWshpCVs/5u4yp76Q?=
 =?us-ascii?Q?e9+Nbe7X1rn5KSxAIMC8rTHUPlvTIUmYbN9TaPw9E2IWeAorbOSU7o06IdaT?=
 =?us-ascii?Q?Rr4lYY4JjSNmpZSEMTo70zRu7mzklGsRfzKe86Xe1qlQh55NozQGsIqpmqt7?=
 =?us-ascii?Q?JmzNOqQrej4ArJvvKIjRwmmUqHdDLlbc5VBusF+ekSqpv9QErqWxqELswsm8?=
 =?us-ascii?Q?RgKEU8sC1RoBeoF96mST4ud/Y9Z0fG+U5dIOci0O2ys8Ezd9wh6JOM3gfNgg?=
 =?us-ascii?Q?rkYB8SVWpn7IlWhR+gac4ZE49yI1vCYU0iMLtbM7pTz38W/Rcj9FFTYSuOWc?=
 =?us-ascii?Q?2ZsKUKRY1uS4/hnjf8LYexvHczbdGkkIj5/XRrFXAcGi2/WBg2tlVPFVgYpW?=
 =?us-ascii?Q?V7z0foenLiGidt1Q252+aW5KP6Xb92dZyE2HiYT6rg8/BG5P//ra+Du9qKhv?=
 =?us-ascii?Q?EdfEk0J1VLsxL5w6ZLzgf9Qj+ueZaU5LIQsrLonJlunz1l1MHiGPSGR6uf9/?=
 =?us-ascii?Q?ftYoF93v63xpK4m1IdPCpR12lDzm+t72ahQKWNUVJvJMV3BbqvJB6J49Ijs1?=
 =?us-ascii?Q?I2XI3agFO/p0eyBjyqQnTR/L9d0Y1v3wfJYFzrkhG+npG2zYiW0g6HPNWXDo?=
 =?us-ascii?Q?bIA1ozRONvyNQrNefjaKZEDTrI2ZF6xfIm5mZSs7l49S6P0OIx+1gaJTIkYl?=
 =?us-ascii?Q?sPv7Fb/ehHIDlwbFgXrCebttAHWP/DKwnTwWjr0YXTdYyP8de1IzJgzqrHOu?=
 =?us-ascii?Q?24VEJRoUCC0/LCN3Winm/y69qoRFKib9wCcW9PH04pwMB7GrYWVXC91sXY0e?=
 =?us-ascii?Q?g7d2qGkLSdOPaINhm2Cym9EMee91cIG09sFBTSldwFP2EmE4uDewHWOa3GWV?=
 =?us-ascii?Q?3DdRzHzdTt5EoHEccYCUGRThKnKwKfSojVuixj6lPWQbQAPT5yojSZ4SUgGi?=
 =?us-ascii?Q?b2+O43nRiM56BJhdSnicSuUEk5JoNpNZnn6igeWfIPMtoiYtIfvZ3PQo56RS?=
 =?us-ascii?Q?N1CJiMajKWbL/WD9d6gSV9ndG+I3UMaQKY+tqlIL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d373087f-30fa-4b8f-b011-08da8aa7dc8c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 16:51:19.2756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBs9bQLHfJJtArJt5Y6NTDu52TKlKQJcYZm3ChP00y1x9Xt4CG/7O6WlavHIrPWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2809
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 10:42:31AM -0600, Alex Williamson wrote:
> On Mon, 29 Aug 2022 12:28:07 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Aug 29, 2022 at 12:41:30AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, August 18, 2022 12:07 AM
> > > > 
> > > > Make it clear that this is the body of the ioctl - keep the mutex outside
> > > > the function since this function doesn't have and wouldn't benefit from
> > > > error unwind.  
> > > 
> > > but doing so make unset_container() unpair with set_container() and
> > > be the only one doing additional things in main ioctl body.
> > > 
> > > I'd prefer to moving mutex inside unset_container() for better readability.  
> > 
> > Yes, I tried both ways and ended up here since adding the goto unwind
> > was kind of ungainly for this function. Don't mind either way
> > 
> > The functions are not intended as strict pairs, they are ioctl
> > dispatch functions.
> 
> The lockdep annotation seems sufficient, but what about simply
> prefixing the unset ioctl function with underscores to reinforce the
> locking requirement, as done by the called function
> __vfio_group_unset_container()?  Thanks,

Could do, but IMHO, that is not a popular convention in VFIO
(anymore?).

I've been adding lockdep annotations, not adding __ to indicate
the function is called with some kind of lock.

In my tree __vfio_group_get_from_iommu() is the only one left using
that style. uset_container was turned into
vfio_container_detatch_group() in aother series

Conversly we have __vfio_register_dev() which I guess __ indicates is
internal or wrappered, not some statement about locking. I think this
has become the more popular usage of the __ generally in the kernel

So I will do a v2 with the extra goto unwind then

Are there any other remarks before I do it?

Thanks,
Jason
