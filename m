Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E215BEE38
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 22:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiITUIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 16:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiITUIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 16:08:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8386171C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 13:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJ4y3Wjo06qkkIPl1oOH9zHZr0kuEaHTxMWgt3GOrmCEVaiXsCDjmtvTzDUOqrnIlFNXGjDtvnIuKkmtQRz2+0rf1WbL8KW9j5UpcsQ4yA/V49yD2G8h/adXiCYiRG7DYQlWvMBi9NnLefF08w4133k4eMdyJVg8BjwzJ8OjmuBWZmNPDRg6AbGSApJUfi6hzYxvtPdsnPVX+TTWN2Kh5k586h4Nod4Fq8LLqJlAtWiXEJXWgLhogNQFxqYyKWhET6YmJ70Vwcbyk3vl6RtGqQzeE0bH6L5O9oVrBLGfCNTsqzvQJH1zN0oKqCVNmPqZ0q27y67prXqBi6otn0HHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awy0bu4hp5M5zA1+oI1z+v7a2t0+MBfsBmqRgK5dnGw=;
 b=H0cH/l/sjLqUUMNtY/vX42DuV7l6U/5SYNcCqzg6OPrNkCZ2oYGJVJxn3TaGo1pA1xRLki2HtSSzWeBWchIlb7Qh4F4DZSWDuIqiPhDwIHc08iPqG8XkAnvS9kYIbkhP4g6lLhbzIR/+KW8bWytCJ8GEdb3rESByFr42eaPC6OiwvttRJ6F6G9Kor3PxsojIywiKaUvS/bea2nBtBvLcuZobSdqYjxduSIRC8WdLFxUm/NoYFglyAFA4Qo5nMaAqJbXWXAa54X97LVF0iu5WL/FetD+LWdUdxVCwaRZghInDvslzyyykCsn7IEzuZndXs4VmuUX4qCLDN4r6Mi983A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awy0bu4hp5M5zA1+oI1z+v7a2t0+MBfsBmqRgK5dnGw=;
 b=qBomq/igZxBdhgnXHVZX6u3lT3uhw1FOn8Stu+kQgr1/tC/O2aLY8+H/stDZ3P6o38dtYMyPsBdSnbf0Lx6auhnizvZN1vJG8k5jdvgfpF7WuE/ZXY3yS7VNihcufe8FvNv4MzN47q61di+gzaiGoe2VxMscDp5dEOb81UFlRwCg8CLd/xLoAsVS2DSsbKXiRsYsC8YKsnSpOpmz1pV/MaWqk/tVW3XB95JWqEbShLYrMichgUz1IaiBEhkHRpWHuUnUTQu/WEvj6GJvHf4TU6/F+bex9NtstUW9c9Yk8uwLPPmFS7mCbMNUvrWiCl6UUZyVSehS3qDvEzKM2r6hGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4279.namprd12.prod.outlook.com (2603:10b6:610:af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 20:07:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 20:07:57 +0000
Date:   Tue, 20 Sep 2022 17:07:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YyodnOJaYsimbDVK@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB527620E859FF60250E7F08A98C479@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527620E859FF60250E7F08A98C479@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:208:32d::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CH2PR12MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f99d2a-6c75-428b-1383-08da9b43cfc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SxWzpa3oQN50igSaDKpDJaDouWlsX4ulTDCi/mJH+y1CcPE4zNeH2qlQnwLr5C5uUS5wtEJEfRiBamT7K/v8Uf5mHT8KtTuhXH8fCwIf8fC7M7miVrMcZZ9XRYUFhIe153rTLTIf4kTaV8ZRRgXu3tCu328/X37cdjVkjUKmwx5+PJ0gcdwhAJDZsMRO/jcA9cMuF13+OM8FZ33Y76tVrwF5qIuMtyDA/QVoYZLtROlRA0KXM2Zd6W7gsoTdZGHzkOePRTR70+j6wJrjxUMFQsWWJ5tb+i0pmUHv/7azkM5Sn75Dm61yY4iLKXtQVoMSu7DlWkzOaPR5H/q9pu5W4xSqEcUMo9LZE3o7amgM1U9miDyfhZKhxikH0iBCXJtQLI+pbR8e/tJB0RvbE5zi2/JpS6/ZVBUyITLYk5PbJF671oEQYtl+AeI7YokKpn+9E5OniOvvGu4JNcz9Y5m1JtxfHEV2Sotjuq+XG+oqgHi7eBuPvsmoi7heKuPKSxW0Alt0p0IQ7fET2arItUNiVlr5SL2a3rLWFro3gk3Lhai6Z3nPi4exDmheH2QVD5n44JNLLPJsx2EL49pJymDvRFLpiKVxHYYy1Dv/BMMu6mTp6fIJjd5e9m8G7oJefoNoobdsr1RGrRtqGuA+2ZN74RPS9hRzXiSWzO0nFHkWBnzNCJye6Rumh8FTE1o6uAhm/Fb3IFrtSHN50PHPD3ObC1ukd/pNPxQ6FsAbtJc8GIomfYTrFUhYKfWKQDH02kmC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(2906002)(6486002)(5660300002)(38100700002)(8936002)(478600001)(86362001)(6916009)(54906003)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(41300700001)(6506007)(36756003)(2616005)(186003)(7416002)(6512007)(26005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a3Zl6iZ0Gmx3tY2VcAY4/kT9por2rDjkmfsP663Vidw6aR/mF2r3e7Llg4RI?=
 =?us-ascii?Q?RnUBAykqgATJOXuou0F85gFJArDfNp4chawvuZwBafav6mhANya1PoGZfeeW?=
 =?us-ascii?Q?g4WFsIvPl5+KNuEF8tz1XlacWWtpp9hiQfRgfsuOOBYiaxoojBDCBn69RFgh?=
 =?us-ascii?Q?GLYPkeB6ECJFxkD1UtoXPKj6izrcAsY1roqdkIuWXzmeoWDOlHF7fgtx81r4?=
 =?us-ascii?Q?ScpUmNTTdFhuhLthagwg2MbXf6oqctOmNhc+GEAh4qm+PJd4/ntNDAGLIxUP?=
 =?us-ascii?Q?R2UiEZ6lp59oszQ1uwU5i/LufjJvzkSH/Q3TyHcbw4QEtbVYeM1ZayLHnVK2?=
 =?us-ascii?Q?b05y5NqBg5QrsEHV0W5IEhG+/Hb0i/kdmo+REA/8VA1rTBTpECVVrfty31bt?=
 =?us-ascii?Q?KbSxySkFIbloOf6NJAfFRN3lufAZeowaBCuwF5sR0t9+YeE/U2FplrRUHHp1?=
 =?us-ascii?Q?f8nxop6G7eG6/TuS9Nz9zDKriqSHo1kulr6vOvNt+g3Nz5zIQ8XpNFAAnXG7?=
 =?us-ascii?Q?rOjwuzQDV5pZ52DkxMiWW16ozgucefG8cwTPeSNsrTmStflx1forjgsviJ89?=
 =?us-ascii?Q?TOH+3Omy6pDHakydjoqs4kmS/L2bf3gbtYFI4RaRrDf30eh/DVX+0fzS1i+v?=
 =?us-ascii?Q?g5zjs81uRoLN+Rdkl1RdV54UXRkWoD7iBGJ8YglmINJ22o9vJoa1K4XdxUyb?=
 =?us-ascii?Q?8v3zXMvYsizCSLZs5JFTLqQ7Nklu4lCX0kpz//xvLUdBM3J46PA9NVs7Za/0?=
 =?us-ascii?Q?g2lKAPXSyvwe63GhuMCqryIIsLqqjKu9H393K6uq5LPyIqOkk9qn2JCv6a3Y?=
 =?us-ascii?Q?dFT6YJAEgtqsiE2yEsFPHSNsTm3NxzrqGAMu2BuiJdxCulCUurJiONPuPN1Z?=
 =?us-ascii?Q?X2aZlRVAQpvTIJ3SqiqEVJYTHJKtdT3bzRJJiFP4VTKnS4lHgX3aJ1cTiooH?=
 =?us-ascii?Q?xZEsPU56ZVeyhUpkGZ8Goh7rSNo3OrGTWaCNBBYUXMYqUlHY3v+igynOwLBN?=
 =?us-ascii?Q?zUgek/9H9osOHCvU0ivTsczN/01lMx7nL0fpg5ZKl0gSomHAxdKMbQiuOAZT?=
 =?us-ascii?Q?/PyX2ByZ9s++62uCMc4nPRrf4c1P3XPmu3JF+i/Q2x0lgtK2onBBjBzQ6lgE?=
 =?us-ascii?Q?2AVlLCHYVQLlcWyN1n00XqK4iRKP5lCSoFcd/FzpjqT1GJp/1BzfNivaiuWN?=
 =?us-ascii?Q?fhgaH0WDMDLvnl565POATIEHUg4GXBskkMNz26ONcfjXlZdpdVdiC4509Sd7?=
 =?us-ascii?Q?x7rQc9SA/00UzThMVF7JPuBddsAOCRv5qeyAFhMMXVlH7IlS/gJ/xCoTsLaA?=
 =?us-ascii?Q?3UuKQZh0DL9hc/gpDiMko9mnaeao86EuZHtix6q20TzPEOgHAfxeElQJsJbO?=
 =?us-ascii?Q?FMAdKreRNKt7vGsxLw7eWvVhYPHlkLJGghMv0Io96kTLV3aKax0fLjLtw/JO?=
 =?us-ascii?Q?tz+1+kY+VfQdDg3bx6vkhOgsErK63w3xZaMxpf3KxLb/G19pYTF0J81i9U91?=
 =?us-ascii?Q?MhZt9UOrKJCDLMbKafyAUMuku5DwkWnayy4HQhNBRsGP40iT7S5vvc9Y8Qw3?=
 =?us-ascii?Q?a902P28kgx9BEIMmDgPWUOFXE4IEWKHWm8mNRxBY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f99d2a-6c75-428b-1383-08da9b43cfc1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 20:07:57.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJbjNO8jqAB03I5Au4A/IL4aWQB1WJewQHdrXefJYiTpAeAjxvuXt0ZGK1wjFssv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022 at 02:05:13AM +0000, Tian, Kevin wrote:
> A side open is about the maintenance model of iommufd.
> 
> This series proposes to put its files under drivers/iommu/, while the
> logic is relatively self-contained compared to other files in that directory.
> 
> Joerg, do you plan to do same level of review on this series as you did
> for other iommu patches or prefer to a lighter model with trust on the
> existing reviewers in this area (mostly VFIO folks, moving forward also
> include vdpa, uacces, etc.)?

From my view, I don't get the sense the Joerg is interested in
maintaining this, so I was expecting to have to PR this to Linus on
its own (with the VFIO bits) and a new group would carry it through
the initial phases.

However, I'm completely dead set against repeating past mistakes of
merging half-finished code through one tree expecting some other tree
will finish the work.

This means new features like, say, dirty tracking, will need to come
in one unit with: the iommufd uAPI, any new iommu_domain ops/api, at
least one driver implementation and a functional selftest.

Which means we will need to put in some work to avoid/manage
conflicts inside the iommu drivers.

Regards,
Jason
