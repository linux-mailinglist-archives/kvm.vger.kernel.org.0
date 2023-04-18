Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99646E652D
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDRM7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDRM7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:59:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA278F;
        Tue, 18 Apr 2023 05:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcBC44hYGruM1El+02uf5UfTnRPJ3Nl3Zp9tzsVoE+tcVxO1jhwG8xeMvkqREVtNC8qeMTcp3Mi+XQ82DUvSXdG6HUl6d5/viQyCvq44qTJ6tsDAZ2dlUFArbYX/wyla0xfVgSvTgyVDc5ATzupu53Ymz5Uq3Rz1GDN7y87w130IaliJUJqNbnVV31ATUALNOi8rUVuMjGagOhn2IwferGZ+uzr46wRXX5HNcC+TOW4oEpti7f2tlM7hjPIAgAHlfiVu1ugGW5PCGqjaUosfztk2nFl6OLAnPUpwmXKJHMxaqC7eUB3st/VoaB274YTFQe+BI2qTsW1rTb1Dgig+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urzKkmna3a+uouA9rlW9mQWUWF23aQDlcAK4A1VPRaY=;
 b=nY2BEsqRp1TGWGrbNLx3WqyXodCcVntgEsswTHNMsXAir/s3aY9gg/odcrqmn+nCFDUQZQfRdN2MEyJ3Uh+YBfinYf5nRnX4hfrdvPH2Hce2YJh+zgA73p3pIEdZlq5jz2gzPbJNeUbK5xamRzrxZvS7vUl+cqPCJMtlCGj/T7t1NWFX3+V/MrTAvDVgUGwHtlnhvAr4B83Qb9daHpiWpgk5KSDPMQ/M4TeovbXgbsUpbP9fUoKiuAT2yti5A92jZwvm5GAr30gAhmuyJ53tV7JPx75jQIKib58fALhejApVTim2TJ5WWIfMQ24MVGcV7WdXrwsvFt/bQrqtrsYFcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urzKkmna3a+uouA9rlW9mQWUWF23aQDlcAK4A1VPRaY=;
 b=It/Sou1QjWpBHaWi7P8PPbhKb3aawito1MPfAgg06WJDnWhqjbMdDznwkXgiI8DLucxIZ5F3CMYicPArkmy/e0k+MZjJ8ExbdJk39Sc9hf81V8IGL6BjlSZZYstmzA8Vo8giBspgDWsOS51im9HXh35cMYyzLdLf+d35jHaJirj0MIc/bGqdtYX9R//nzD/NynaxJ1WgyzrdmQjThciLoSQg/dI7BGF4RV84wHwfmglfzYy/AE7qZ4No8P1B6/ChLqzR7QeeTSGrlyjhVm0dUPHaCvjmkL9u0myftkaF8cGyKunn8rjcicYWI50ED7IDcqMvBIkmCdC52Z/KknMV0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:59:28 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::94b9:a372:438d:94a2%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:59:28 +0000
Date:   Tue, 18 Apr 2023 09:59:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <ZD6ULhNHryJVvtJ5@nvidia.com>
References: <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230414111043.40c15dde.alex.williamson@redhat.com>
 <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230417130140.1b68082e.alex.williamson@redhat.com>
 <ZD2erN3nKbnyqei9@nvidia.com>
 <20230417140642.650fc165.alex.williamson@redhat.com>
 <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230417221033.778c00c9.alex.williamson@redhat.com>
 <BN9PR11MB52764F6F00EFCD6EF9ACC71D8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764F6F00EFCD6EF9ACC71D8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0259.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::24) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DM6PR12MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: 0413db62-4203-4eeb-8faa-08db400cbe30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FMD13a+54G8WVEaY1rRStDVKVMI0f4Vv4S/kqtHe7cgfhCwI9rsdSFLP60P8uT5k0myYqi5vUrzi1LOlb0FXYxnvN6RLXAl2vyM+PtuBTBGXu2HJLIOW2RMZgkRc2d8MjzPYuS/Pz6N+ED3U8BzrhKDiwsXqQOw+WvOfVMRvQYrpAfAz6yW9LUBCQPQ29VUAD23DmYVaCm+VdB5qAZ6zFBUoxGxXda34d21l1nz/T/uBEu1L0crMOrhZbqcAE3V8BibGwcXiLfdnIiSzmaYi186WO+3v9Qyw9ecZ8QFVi16WAqJEC55i/CKO5xMRkGG0OXJtXEYjWvHOMF0R7VwoF4usunVzWhS0xXMgb/Q66FMoEWjQvZKiy0tEwXcCqGbzKxamf0L1f2Mm9G0NVPmjJAQDzNvYYoBPwxsKh1YXfVBYaCG60WHaeXgRfUVvNVSfIII+wtzLBeoMnZJUNXTZK0uU2Vn9nKGLcQTXkT7dJQekzcKczqzNtFqjIl+FsIFCWuFZFLy5PnteG6zwaL6vKtKn3qx/KtsCPB+ko0FXGX0LrVZg0AJRYx89YfwYcP3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(38100700002)(7416002)(5660300002)(8936002)(8676002)(2616005)(83380400001)(2906002)(4744005)(316002)(186003)(41300700001)(6506007)(26005)(6512007)(66556008)(66946007)(66476007)(86362001)(36756003)(54906003)(4326008)(6916009)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ihe15JG6IwjOwJuxEKXTSBWqXR0ptzxYQqd+qrigMgjnhQ0jMeQPw3sNd8Ud?=
 =?us-ascii?Q?9FKnd+D+apLOjtALDi3iCK8hs3fAsR3vH9ms2EABMPBHCnAHtN2DBbZKooLQ?=
 =?us-ascii?Q?KPrwpmdr37fIhoyrvproIQKQnUI9uTlyva2uzsk2PpaPN6t2H6J+ffXucJG3?=
 =?us-ascii?Q?H1oYwsV9NkBtrp1g7BKkhi+tzGBsODD1ANtif9ivpHZMb0wFnm0whxCRtT8K?=
 =?us-ascii?Q?TDNJSn5nsPIcwDYcByiz9SO/qHooKAEiv9EaSO6uvOGVNHYOuqr1NjNIlDpH?=
 =?us-ascii?Q?GoIeNLSfSmx/DKxm9Xh/s2U74McucgTI5ywl1dasyGurDOzSoCCWK64D5/66?=
 =?us-ascii?Q?ZVFBoKISr7ILXIBTp1tC8UADEPBw/kMxj+ug+NNn1KeYRvb6zSLQ1IQVkRSu?=
 =?us-ascii?Q?+uscqLBsTWseinE0DygymXJQfrgyprOxggZE2sRRSe6cyPRW5oEiaQ6OgxO1?=
 =?us-ascii?Q?UbwFFH6mENjoNy6IRh6jivYcuzb4G0f3bcAgMvAF30y4EWUhc1KumWs1IBx1?=
 =?us-ascii?Q?Qyis3Nxzz3FDey+kPc6K8xpe/38RZKtQ5SEZnuQi5dxZI0TdpZDKiW3cLg0c?=
 =?us-ascii?Q?gJhNQ2UK33CksGxuVfP8RVH7ko7w1fvVD4ILKELGM/qu1xQi/U6PEjO17w8w?=
 =?us-ascii?Q?/Z7nXUHM2rp9AJCNH97YTkwQnJonehQ0HXjezupXxP/NyLwLA74mmC69Oyo1?=
 =?us-ascii?Q?M9BKBSd9E/I1P/4YyPgwKU/NuVBz4uwii49EgCV0iKI+07VzVZ3nazUMyrWg?=
 =?us-ascii?Q?zX4hKToQ18uV6s124Xv3YI7bcKQEQqo4COBslUUrcZPtbISAG1VuY3Sr474i?=
 =?us-ascii?Q?elFJL+NwPSQzngz2As4El4eNpxtlvgg9H3MAWTHhrebsylXzCHN4boMoPqzp?=
 =?us-ascii?Q?HxDvtxTm3YXkOKWy1KYollsyhCNpKMK3jiu6o3SPD80DokiW++ycXhbGWyTm?=
 =?us-ascii?Q?JiN2NLmGjIrIImrQFK1pvCzhRHki/66gKkLof+9Td/2KR9hb+UjvrC2qn/Ht?=
 =?us-ascii?Q?92Q6cLHbZShjBunVcpWH0mlj4tNi8BIeakxAKJwR7Xs2zxFfhfRozwDMoPvH?=
 =?us-ascii?Q?3WNzBtr5Qi0+e/4I9595OdxIGTNyYGAfGRduoLavRLcBAjXpT3WPOxPeYK0N?=
 =?us-ascii?Q?WWP1aJ0OhLsJ7uzAQjkU1KvvPjRXxFIJpqg5h2iIzt2JU13q6NSG1j7lf8MB?=
 =?us-ascii?Q?AhP8mPXqlqeRadp2LqF68ufR64vcrVb1ALpDfdsBfl+jp2zMkHBikAZ+0HcZ?=
 =?us-ascii?Q?j7tH+A1P3bXTCjikEHCxdN3+n7xOhdK0Pd62eDOV5GcKVMnJXb3jhrDpVc6t?=
 =?us-ascii?Q?Fso4gGy7ltjuZR2i4uiPsCwjhphflzvW3Bv6dc9AEDXUUfEga8nwOn4YRlyT?=
 =?us-ascii?Q?GQ4hw68dEtkwH5xW2s4b2YPepJC9f3W4pQ/XlOO07kl6RuwbvdOiD8wHG3Zq?=
 =?us-ascii?Q?fGItO9+1Oc/2hWzM1n6E3uClYqoO4+l2hMp5Rsq1bu/w40skMcuBLGL/jrkp?=
 =?us-ascii?Q?fYLcS9RujfNSbleR+Ic4/Z91efMuc/WUUBo0ZkCTVWh9us8Hf7M9gLubQD2E?=
 =?us-ascii?Q?4KCJ4ON6yX8PExQZ8nnjPqhbo49WwQqhHhUueaQB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0413db62-4203-4eeb-8faa-08db400cbe30
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:59:28.0197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65qoBqwYjEakPonLb+yE7zoKBgA/oYU4/xzLv7JxqXyF8AihXoEI6Wmk2iPxw3kd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
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

On Tue, Apr 18, 2023 at 05:02:44AM +0000, Tian, Kevin wrote:

> Yes I chatted with Yi about it.
> 
> If the calling device of the INFO ioctl is opened by group then behave
> as it does today.
> 
> If the calling device is opened via cdev then use dev_id scheme as
> discussed above.
> 
> in hot_reset ioctl the fd array only accepts group fd's.
> 
> cdev can be reset only via null fd array.

Agree
 
> It remains a small open that null fd array could potentially work for
> group-opened device too if vfio-compat is used. In that case devices
> are in same iommufd ctx with valid dev_id even though they are opened 
> via group. But probably it's not worthy blocking it?

IMHO not worth the complexity to block. Security is maintained if we
use an iommufd_ctx check.

Jason
