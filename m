Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71F6D7B97
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 13:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbjDELmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 07:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbjDELmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 07:42:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A893A9C;
        Wed,  5 Apr 2023 04:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhSty5x1hdUEtC8MXLWRCIwY5CBR4Ly6d59rGhkChYr4fKiG7l6+E0DRM1bJwLNT/JsHuagXvHKtBpAGQe4pfogRVIQxu37DKUOeNghmNMfzTYRKiYVGOWunfH01mUKGTyFrobzWG+QtDkFkOYQpWtHtvR+opAEQsxPXBZ2A8WzKaEcuUJIXtbh91k4CaeKJPivOm74Rvht1N8e50CpsZlWI6VnLXoMHlMATNx2byQpNqmiKG3udIZWTOU9ZBYAo2RKHXjvNfX4KJ3T5fWH9sry/g2RA5X6uNDDg8dYk+xZQFVsbGXbTdpwiBQZ8SWp/tvEJRw6zE8kqipKjJ6M/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1YJxFIiD8KjC8TiICLiusQLluf7zReRbQY+aTmtato=;
 b=U+UVtd9Celbzxvuio9PpPrlVckTMCwrQzEVNijfAPCN5UqyYXFdwPAyCoZ48L0SQ7iiF2hzP6n3f6a25Wwme9vOE5WRSbe7P2BGpzZOOQ9Ei2D2sL8AZ6qIWG+Asg5T6LJ3GxVc54cd0bMOaPEFuYFTPE3nKR3Iafb/UMM/tLB991mI+Ng59jxSYR77A1TGrnz3hYaXEfOSc10f0cjl3IaNERq//79txlCFqrtLsqNiN6Jc3BsoOlLha996CmSg2PGR2BYlIo9BXuLNN7fgy/whQM2Z28RZ/J1CjZu3GhFv0DC3sxOktArAgi6aMO2sW8mHqI2N3GQ96A7Ra1urXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1YJxFIiD8KjC8TiICLiusQLluf7zReRbQY+aTmtato=;
 b=VrdRPst3wL7C6ncmW9C+fcemjRUswTLcxBzGJkXDHdMK8488uLg4uvmtL9pDUxC5RuoYR5CBA8dC+oxwzsX3c9eHtIhaK9e9SMPAYuYRzsRorFG/2HHLhpbBHWi4puFCsYXWzT6pmqJokhc/7Ubcs64CpoqblK6V7M36o18PmovBAxabGy+Dd2R9GDtikP1t/o5MYW0KK9PFn2bRq6+iuMxEbUArGOIsjgzSeeQkfy15fGFoMyzXQtp9qi7hHetC3DKfsRSL987iOn+H76tixWzL2BP/+h6fx9s3Tv7pn9JX1nqQKUb0Wk4ID4wmbSHkgiZqBO94iPpUT4JGyqUXmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6456.namprd12.prod.outlook.com (2603:10b6:930:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Wed, 5 Apr
 2023 11:41:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 11:41:56 +0000
Date:   Wed, 5 Apr 2023 08:41:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 02/12] vfio/pci: Only check ownership of opened
 devices in hot reset
Message-ID: <ZC1eg8ZqwkfKuTDx@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-3-yi.l.liu@intel.com>
 <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
 <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
 <fc87191d-2e79-83c3-b5ba-7f8b1083988a@redhat.com>
 <DS0PR11MB7529441450FE32DC9578C6B8C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
 <5781064c-8742-d37d-57dc-7a7238e948d5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5781064c-8742-d37d-57dc-7a7238e948d5@redhat.com>
X-ClientProxiedBy: BL1PR13CA0320.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6456:EE_
X-MS-Office365-Filtering-Correlation-Id: 469917ca-7a69-4700-534a-08db35cac215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xau3pcGo/YL8RoMjOvlYVlK5BriPLcR3KwocWW21RQeTgDbfYB7FVAxPxA+Vetapu+HoBzf/G3I35wTM4MsN6xNR3hKiuMlETAcd1wKnkvAUoFvyt0ZuaogW8ADIPdg4E3OHOMmMxrT5q7+1LLCNyVjlQomMfoTJKmItxlVDOwsszPmA++/xnjv6Tsb390Z+GTa2stiIYL69z46KkMryihYT0qemhvjh/WIDSuTbmFhMjYTFnEkmsizC/fizPTzI6g++Z0qumy7d2EreptFJ1YKEhOORNpn7GnSupeQ9KB5USOqu0hBh2YvTjFsnSrT/Kkw9IFrt05yA4FepJfdWruZpWmnenKv0j3l9YmKZ1A3hbevLKJH7EQ4ZR69LzM3cVqUJ/rnC68PUHPl7gZfh22tLR+JU7/5Zu5nC9lCCmSp+DnxqwMT/r4BxjvMhJ+9P7xzZa3vB4mBmcZHK/C/nb8rrGTtjvEI9vP+uzLfQXUbZfhNRJFtvszCcKN8Waam8KI6B/r+hrvTu98Tschmi2bwf0IuexOkA+OFZD5tq93kajEgbkq1ccDkKdpl5wX3v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(2616005)(38100700002)(36756003)(5660300002)(8676002)(41300700001)(66946007)(6486002)(83380400001)(66476007)(316002)(86362001)(4744005)(478600001)(2906002)(8936002)(26005)(6512007)(186003)(4326008)(6506007)(54906003)(66556008)(6916009)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RDnUqaTwDruxPqWh956G+MlWI0yQWpeaDabQDpktlz4wCvVs0Aa+gJJLHQNk?=
 =?us-ascii?Q?wW2VmtDx7VAtMLraKqinvRJEa/HBhPjmev81oVrrOSsEAwZbOpvHmNRLAWZa?=
 =?us-ascii?Q?455Fynr1vVjZa6p+bWvcGSB2ALsOl9L7rwKEG+Ag3SH0QfrijeIBl960FbHn?=
 =?us-ascii?Q?f+aBBaL7l2poPeY0gzMpPTaWlUy1OtMNgoAjh/SlXXoJLiS+pErTM22ygs9X?=
 =?us-ascii?Q?ySTwq4JWT6ZeH0vA5Oh+Z6LWf0JKtD2ZEWT99JfRZ9VzWXFx0jPj6N6+fAlc?=
 =?us-ascii?Q?PlfH+gvqAVQhxVUEIfTntOzzie1wSd7KQAur8pxohg3XTJxIuaquPopImDg6?=
 =?us-ascii?Q?S/2cRxfOi3K1flDhIxeUp+QnPLA+nBlc0Vy5qiu19lvUe3gtEca9R2xDVqqo?=
 =?us-ascii?Q?FEws7AfiltV66kKzIR4GQ9FcmeCPRqbD8sOZapgWaA0H1DT4MwWa8bMMZh77?=
 =?us-ascii?Q?/IKT9Qxf0EVM7ViFcUMXeVvNNZSDiM8jD9NZuaEdTPkfwXpCEYTUUnfgD4j3?=
 =?us-ascii?Q?eYGH63eMrFA3wbcxpR2mmq7Ke3foPJeq5vVbGwbyNYwvsP8H+nB44GeyX04D?=
 =?us-ascii?Q?Pwy9wa/DscYYPBSxEO3lg+bVUXW1B67qkHP1u10uvxYQUvTZX8TV9DoJtdDq?=
 =?us-ascii?Q?I7r1B0bQXCCqIKwJSCmLoKf/RjnOxksjBMTDVihJO0qYMC3xQqA6OAsA0Ll4?=
 =?us-ascii?Q?apZzY6xHEZac9xZ3b2i2y3hSvVVIGThf4L5Iuw7nAMd2/cVqXcobchFIUT1W?=
 =?us-ascii?Q?bPxUK/DHroCQM+UpCY7WGIaXm0eYdAKNtA+ub9YRc7iti0ivbvpqchvSbYeg?=
 =?us-ascii?Q?rnko6qhuwWJIgrnzCQ3EA5bqDkpa0ABI9/5yk13kVNhV3MaoTT6VpY4IeXrK?=
 =?us-ascii?Q?zP8qb5xMVgzEti2lD/W5a4spFxSsM9iAQsgeWPC6OVdOvjYaluBbKgZLIZS2?=
 =?us-ascii?Q?2zobOflyXDB7FhcpNUybHnmdRdHo9o3TpINoClB/v1Vyl1Vy49cvyuSTF1Wo?=
 =?us-ascii?Q?ZfokSU9bbjBHByBCG909kr8JvsyX/yzDLqJ5FzGS1LKlJFTcGDbkq0FzpwRV?=
 =?us-ascii?Q?2uC0Y9pm35oJ2VFX6uTLJ5LwxP3xPRkcReIALS5Td6QFUFLAo9S04B80YB7E?=
 =?us-ascii?Q?NAgsnOfPgcq8CVF9aeevtEDLVp4gWgKySCnelD09NtoCpc1V5kwGny/7PqE9?=
 =?us-ascii?Q?ZIeJp6LwNRC9rgZEzWAcUA3rLEnS1Rpqhg0IwKoQ14cQGabidYbdk58lPvrP?=
 =?us-ascii?Q?iCJGxv/CtioZUAhNMjsl3gbMgxcLZKyv8mr1sUsAnSTtu6S4e7iFZcK8uXnQ?=
 =?us-ascii?Q?so+Fm4UYkWpdzi6ZJZz3G9tGi2zNT2ww8+xXTH0qDRBlb3D6EqfsVqfWtxiL?=
 =?us-ascii?Q?C6tT2Ua02PPjoYQSyM2OlK1J8Nvd8yjO+lTr6lQBUY6i9GKypLPPCa5Q+QGy?=
 =?us-ascii?Q?lmL9vDcldqfBhhYQBLNZrM30O735AREbFTqk99cyDECQvB0L7k96SyUqHctu?=
 =?us-ascii?Q?kiR828Skz8cyCG/ZLyK8T8DVTO0KgoqPv2pNJ/EOKqU9TkvdsZvDN2UJpjbI?=
 =?us-ascii?Q?MaB9C8J+vcu0js1iGvPBJsqvoowmzvs7mbp0xw3N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469917ca-7a69-4700-534a-08db35cac215
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 11:41:56.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEUbhCQWCte83lFo2axIswBYxKvS+hr5so6hpRwRlM0Uu+TUjnx8u7nrZhZYdHsb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6456
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 05:59:01PM +0200, Eric Auger wrote:

> > but the hot reset shall fail as the group is not owned by the user.
> 
> sure it shall but I fail to understand if the reset fails or the device
> plug is somehow delayed until the reset completes.

It is just racy today - vfio_pci_dev_set_resettable() doesn't hold any
locks across the pci_walk_bus() check to prevent hot plug in while it is
working on the reset.

Jason
