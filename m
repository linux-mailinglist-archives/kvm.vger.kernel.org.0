Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A174DDB5A
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 15:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbiCROOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 10:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiCROOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 10:14:40 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFE523192F;
        Fri, 18 Mar 2022 07:13:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPPKTsxicHIn9R6yMf0s9I0zLdNPQopc6QSAdCotkhsU/VCjtAA077VbpSqiUurfBupfbZZvpdmLyON5qFOYD7qEODcZWEjiyFAcWzJexQAuncIyyVaA1dVOQYU9EfsLioct1iQqIXl3DMf53Lxs8UBKJo4YrhR6JJ6OyPx4K+XrjGut7oGfNAbKfgw59RUQ9P0zyoYNkPaPzvJ/TesyyDpFn+pYsaunIgBDs2hmETdBamtTCQAf1k3plCnWw1jMX6HuJvmEC2Zj8Nr3EAVIv4CXV2Z5DKru0BA7ZaShO14y2eW9eNM9Pv/4V9SftYgkkalhXa+ynVfQ0lm4BzrJaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgK0PbSyMJqplmiXeYYGQDQjManoRwjI3ZbuUm+ik8M=;
 b=iZ4cNWdl3woSDiPRZP84OsknhYViqm8692u2l/f2t1e0VwbsdI2YQURN9dL9uOUX/gy3tWapOioSQfu/TCX+QTflr8kBDjHohQytEbf0Sd73B1yvNoJhCANHlZZW6PRqz04/U4lib7+0YpSM0hx6gx1pyHOP/x4M93nVLk7piKjmkg/Q4FdizZas0kQX19cqIkNfUxtR/nQ3ks/Ce/zmq3oE1pML0teceDYL9pAhell4ti+Mii3r+QqxWt+iZrAL1CQBtGQUOu2gtpNFUdTPBHfO9YUg1JWhZSvj8yB+JWcQdZD+hRCeG9curbkTE2emuZ5ijboriZePY/FxOVOT1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgK0PbSyMJqplmiXeYYGQDQjManoRwjI3ZbuUm+ik8M=;
 b=R0XPPLEifpts6NxaeGHbAdMYmXG11a6x3lw26u8tqYWiWZzngmqdA0Od6lXTACUCXtG+3ONhg9jE8oL9AyPImcb9rFIU3gRyr9BmR7Zj/Qe/jih31hGK+BbgF6UYLqxnYVJ6fcaedIIa+UQescu4OXlMJwwL2TCRcTwWl7kyTAXQWPHXud548/Beih7Tpo9eFCNIiBXvg8gA5D7JNDmzEBlEL+ai1tt6FtKTKv81apsNmtGLFprwpFFUyCivprKsB5Eg2BZCFGSXs0aGD57p+bWl4oxdcGuWY5c/L/FyjqMHW/XxTH3C7JomWnJXAB4XpeH9T/eYD8stm7JXn3StOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5066.namprd12.prod.outlook.com (2603:10b6:408:133::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Fri, 18 Mar
 2022 14:13:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 14:13:18 +0000
Date:   Fri, 18 Mar 2022 11:13:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Message-ID: <20220318141317.GO11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
 <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220317135254.GZ11336@nvidia.com>
 <BN9PR11MB52764EF888DDB7822B88CF918C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764EF888DDB7822B88CF918C139@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca5eb563-fd22-44bf-3fd4-08da08e97354
X-MS-TrafficTypeDiagnostic: BN9PR12MB5066:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB506636FEA3568F52FE11EA60C2139@BN9PR12MB5066.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bs4esLGI6mA0+haYrmko/jB4kMUHeHpx8X9c6+BoN8dGdGySLyB4oz6hLWxF2pFdue3jHcF6WcDCFlQ7dP/2HbsxLt4iWcegpFB6i+Sy8U823r8Oh2Pd5Y+hvurFeomoSJCmt+OV8tyaEAGN2xICTPp/3f8G71BfDi3L6efwyBf0ShWsO8l8Dgdz6b2L/wfAnJU56OXhW/WWR4Xx9djTxT1XJlXMSBH5xJWCBBEA5cVF9o6Rmu9D9PKUdF5rkin8n4a3jLXJnnGLrFcTZ9ILQ6PdH1YDrs4w14XSsccskzLvN6kjMJ9JPKHLXsmUiBs4A9YrVwrWmCAXM7/JVKtpLM+cnOVrwWwvGfj5YvZ9p3ZwWu3787OlUa6hvWnQvPiM0NAGOALqibd7IDwvmq/RtZ0OLI/AhcOXCd8NBIdhLUXQ4gxp2PqFuM6nuIFeHjrp+o8XsdeWvy5hCEty0pNgHGwTNuBhS4eMoDJm1bHSQgY4VgmWuSJgK0teXZ1JwCDMXQv7TwgIJqHz78t6mAtPytMYJyRHgjjqQbFkAju8dxzyhQigIG3LhSwTZcNDtJB4oeNZUwqZp9PdMsMct0Nj5/lS1Ni6/QrOweVeXeiMhMffmowumEyUrr59KFHnTc2G/JiSTtPWizttP5hjSBLRRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(316002)(8936002)(2906002)(6916009)(36756003)(86362001)(6506007)(2616005)(54906003)(6486002)(7406005)(8676002)(4326008)(33656002)(83380400001)(4744005)(26005)(508600001)(186003)(1076003)(6512007)(7416002)(5660300002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68Bg7QP8WVdu/0EzOwh7AI65RzUFkEoDFWkjflhq+cJclJFdFXGC2ASnVlKK?=
 =?us-ascii?Q?R6AS5VFK46BjoH6SyDNVVyzOO1/UeJvZ0aVJ8EMof3IkeTqM0wUS3bZUtHn6?=
 =?us-ascii?Q?8fFq+Za+ASgyFPgXPGJr/9mIGPdsdssKaAdYcSES+GssqKdFPq/jnsI7vWrB?=
 =?us-ascii?Q?IFtIjD2CPPkTdEiN+VaPjuMrfrFwDqBMKrSFLErJZbPQcbBfnVWFSU2i0zoF?=
 =?us-ascii?Q?x4Oa8ZoegLMLaUl133YSKKwXrfGRqlmCHSDbL82TZuT6WP3XsPQUpkPe7R9g?=
 =?us-ascii?Q?MAsfk4SoQU2tq5Bt/m0jGxHzmJ/c3SUtlWwBwdHHAz4zfh61NaNpkywXAnah?=
 =?us-ascii?Q?c/WWRy0vH/vVTWxE90PfZK8fIbJhSAJnQiAVyVniloIOk3pVPtg6LTgSb7yu?=
 =?us-ascii?Q?AzGfLCukEgSoWVGDQoFeQWd63AlrMOIPsH36xHoB0HuCjArReou0dVqaUUwR?=
 =?us-ascii?Q?byimpmE69+te5sav4mqIodMtrgYrN9m5bJNoSZ+tqU1RmPeE6PC2NFFNEz+s?=
 =?us-ascii?Q?e3r+0QmacosB72TUQJJWx4YmhEahiSBfdy+BQv3NS4phGZJrObaJ8Ur8sIfr?=
 =?us-ascii?Q?U8EofHrrcsGNzVInhu4sg2ZzZHFc/gu9pNEShQgO1YbobOI4vnYDdCQ7gnNF?=
 =?us-ascii?Q?fy2aOV+9xY/lFoAeSaU7oRJ4pGOnht/tEh34Y+9u0wjPU405y9dwUOL+MeKX?=
 =?us-ascii?Q?PGxUSDiANPVB8oCXrVrztA012gBXNYtY5Q1NYI9V2vgt6QQ5j0XjGS0WS0O5?=
 =?us-ascii?Q?34fdr401eVeRDy9z8bKbEERXfyksRpoxEuC9NWBdQjE0IEr3kBcvMtv+H7UY?=
 =?us-ascii?Q?jw6M7p1tQInJcprAXWaOE0x107mOxmsyGJ5tpj05yi5AC9guMTyeip3C8MwJ?=
 =?us-ascii?Q?AL0l8Ei27QPmLYoCEQrZHtk+L2pqxHPek6RO9sEJ79Cl3/y5dbEG2RE0V+cW?=
 =?us-ascii?Q?/un186hQY96tedQjCXSxQgA8/+y9s/f/ixj2UhWFgKFNP7iy+WQtwiOE9ZEa?=
 =?us-ascii?Q?WR24+C2wMWBGNAl64WQOkgxNg0X5QdVBIrTPDTaJGafVlYLDAw9xyWb9FAk9?=
 =?us-ascii?Q?EEw18PqVbkCw2tXwDuoBlVAjqSag+iYCcP0k5FVyXfbH2YnKVyiTmMsX1JPV?=
 =?us-ascii?Q?r4kFpdevfOwGwppGSQquliu19UdlUjYEEwOxl2lP+7kieSIEc/uW/D0MAvX5?=
 =?us-ascii?Q?5dOEhBk59BDuZ1VVh9oOVeMNl1fLbvCVWx6iP29NvCWI7J/pndQVbXSfd86x?=
 =?us-ascii?Q?pR2D+lpfI0IFJTaC1p10MWHVyC04b5HNq8qAE68ZGzAg0pp2lsTcKHsbCRqJ?=
 =?us-ascii?Q?ISHfDWTJZg++MtpJs40CJljAnBa5jXy6eyla3+3sI1Xe+mmjlLH1bGUS+ous?=
 =?us-ascii?Q?ZO96Pg/VphZcaF7HX0iy6zKhjHovMcv2Qd69Ldiagfx6fv76YXrqVSRFyBsP?=
 =?us-ascii?Q?CcTo4E7czJRM9adSStoVsh6ahSYGmLaa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5eb563-fd22-44bf-3fd4-08da08e97354
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 14:13:18.2743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnwlSr0xEeBt3UliTUBwHodjadpiet66ShF++m6Qq6uG1xX5vygFWexHwVJv+3TL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5066
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 02:23:57AM +0000, Tian, Kevin wrote:

> Yes, that is another major part work besides the iommufd work. And
> it is not compatible with KVM features which rely on the dynamic
> manner of EPT. Though It is a bit questionable whether it's worthy of
> doing so just for saving memory footprint while losing other capabilities,
> it is a requirement for some future security extension in Intel trusted
> computing architecture. And KVM has been pinning pages for SEV/TDX/etc.
> today thus some facilities can be reused. But I agree it is not a simple
> task thus we need start discussion early to explore various gaps in
> iommu and kvm.

Yikes. IMHO this might work better going the other way, have KVM
import the iommu_domain and use that as the KVM page table than vice
versa.

The semantics are a heck of a lot clearer, and it is really obvious
that alot of KVM becomes disabled if you do this.

Jason
