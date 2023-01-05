Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993BB65E15C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 01:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbjAEAOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 19:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235515AbjAEAOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 19:14:15 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251BB17436;
        Wed,  4 Jan 2023 16:13:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gl26cj2uvA7y4u/Exnkm2TGUIKsNr9vZWQdH+nm8MixkSuUOq1n5xOLzNfWYM274T1gPI68nIERBLaZU8dLUQzZwv3nE5GSnpmklahJ9wi4FOT8EqYYLh0avN/Akhb5aU7yceaCo1VxTsmU4xM7xbdo+zvbXS9MA+nSkKZiS/gEuIVQrL2xhleRvPKlAMdT6zyqRxxMaHTJ2ssuE44Z7nQKgx3wk0vYf3ZGpoG+9eFXjPd7DaYyKirjcRCX2W7b0SQAzJxVQfuzbjjjYZFduzYqIAgo09lGwot6g24fXJM4ZOqAZ+82ZQ6kwwdU2LotkqQsRaLGrz+5I1bk4gE9kwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V89MiAqblwWs32Xcy+/gCRrOegqPK6G0klisDcitduo=;
 b=OyWgaRIy/X96NxHXNQSHFTwLYYPh5IkiHRAmrymQ36IY4iBhCsUiT0HfA0yqvjbEgQZ/lJ7DE3ka8ANcAsjC7F8PlXVyM0EwFI/QQEcYJTjMNiKvW48LgNTaUnEeOFOvNAOydmpCR3j2IBCPNdUFeiW1d7/dgu1Ja+bv/O7rbnLOsR4rfjrP6SNaVQvAt6Gxmh7SsY6zk9YX7AoZspMDgs0yPjjNo4bLE93z7n89VbjeTtyA6KJb6XSNb7wy7Km1FWISAyQ1gQBGfyD/sC0YHUted3nBYvtXhOWxXkUgC+tpMgVrWQN8Mcm+YeSs/JdSFHQ2o56h7gJb+fl4VUf2gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V89MiAqblwWs32Xcy+/gCRrOegqPK6G0klisDcitduo=;
 b=B4XSBBWTDYs8gTn7fse4NDsStRmsliyGkqWzAkivcKrqMO4MoVSBWHZ1dVBTkmp7P/I2X0qgklTGJEME3J22w64OC2Y8GCeNv8PlUmGFwWvWQ/21qTBGWOE7iC4+cayOqmpZUcvLLoG0BkHB3oVN7EVpxmDYoO6K6BsKtm7qjHQIyBZKlC4hSvrwbH4zeyEH5UrWubJAdXfMcVE+je5HikArhX8iSsn+NMAlaRRmOdr6tanZ05dzzDYXV8r3Nh0KvECi7vuEQrkM32P1zjjN3gFHfzLExVfQUdv31Y79IZen2Takg9Ker2JJz85aVY6FDWaBA+bZ6rSkmPo1euvOQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6260.namprd12.prod.outlook.com (2603:10b6:208:3e4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 00:13:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 00:13:22 +0000
Date:   Wed, 4 Jan 2023 20:13:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v2 8/9] irq/s390: Add arch_is_isolated_msi() for
 s390
Message-ID: <Y7YWIFxyl8gD7J47@nvidia.com>
References: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
 <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
 <BN9PR11MB527666D2192E2C25FF8A36AA8CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527666D2192E2C25FF8A36AA8CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:c0::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6260:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c29a63-15a0-4483-825a-08daeeb1a7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d1aw08gMFsgPa/rD5REhje0OLKg12mKCE94v72V43K9LWeEM8NF0Ol1+f0x/LEuUt6S+65NdMyra9J4f9+BNVHcf7JWrukrYWq9D7Zd3kZgYQwCxT6lKt2i5/piLKcIzzUXNXCTP9NI+vZhxaJT74rEf+wDGECtX7slkq+v65RlcS3H/lsU847BPvZNosYC8nagdF+AiVcZeh1a2ebonq6tcBWz66FbSL3ayj3fsWl+9sOl8Qv4bidscqEGkDF8nKQNAlH3yEEuIl57yUXsTE56D82qDVWyUGOKhG+BcS/nJCVrNQcCvKxVwKUh7rwiDSTasmh9iSo+Os5Hi7YV394BbXnvASHjViu33F9OT8YlwCW0BmSX10JEO2LsTTOc2DaZftEnLfbX7JTIkokMjic0P0hcDaVpG67W1HIjTys4uqo5AGMApNQG4BKKhYPgOa9KmIAgQEczm7zsO978ajUOO3+jKL4U5tGO83AZY8juPAmmC+R07ZTXF+fO1GPpqIpwK87EwnDnjJcEZjieod5a3gp+sVZoXOIPa6ZWCjICCeix2wJvnfi5F7xtG8NimywKIfPDB0jUAuyYcBkBtTC0y5hlIJr3hGW9uEH/r1AeNJ3Uq1fXFzsAZZCPc5UHo/3FgA8EtReb7SetrsChRQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199015)(83380400001)(2906002)(86362001)(38100700002)(8936002)(7416002)(4744005)(41300700001)(5660300002)(66556008)(478600001)(2616005)(316002)(26005)(186003)(6512007)(8676002)(4326008)(6506007)(54906003)(6486002)(66946007)(6916009)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y3rqCIej3xgvhLDe7agbhVsLmuJSCEbsdgyyg/vgZdS/lNUZt4EGGoPBH8SG?=
 =?us-ascii?Q?Kma7R+K8jvjy1mg1UKapIeTq/M7/SRmwV/S+o8zf/2zy/3SYENwqsdU2eueB?=
 =?us-ascii?Q?uT7ZeEknPq1PTK2GlXL9MUeaL0ZJX1EgOAcLNkUCstz8vp3uGgFunVGTbtj6?=
 =?us-ascii?Q?XOX/Vh4UHq8zWP+SYooMA6i/BZV02W2FNO3vfEHl+pNdvpenEuOxvFSU6bti?=
 =?us-ascii?Q?vu76J7wQMUJp3NSiA2ppyiIM/QloA+2O4l3wmc57Ry3/v2KL/HKn7ZlEfGdF?=
 =?us-ascii?Q?adJwHXHPdaKxyiiJ7/UkbArQAF/H0S7eg6xWHpXIVbWsPerfjJWhQij5LSk0?=
 =?us-ascii?Q?3S13e/2SdRxoRLvON5eFMvmn8Z6ES4rZxXnrfsS53fgugPsFxgtNs+Jw1Rzl?=
 =?us-ascii?Q?bf4nuYa7k3rqW/HD1mY0LDkO6TNX5F4ZTITNHLNOGuTPOmDE4t6cUfxAbvxO?=
 =?us-ascii?Q?EWA06igHhnR/daqbtkTDKjxp9xIqtk5YpbqsQqb3NWxazraNaeXSK0WfK8+l?=
 =?us-ascii?Q?Ii2mHhxv/1YcharhhJHdcOa7zSpH2sUz2SmsM1EJQKseT6fGoYofFygOTS06?=
 =?us-ascii?Q?lKAVGFTP8NbwAFt/F+Pfp6gQwewpssqqCncZ3wOToge/MLQP4uiMla5y+pPw?=
 =?us-ascii?Q?1yJWQw0kSjhkLgCL9d21KM6lNxxMrPV2MdUyVj8zA35ftlwR1J2R6oJWwV2l?=
 =?us-ascii?Q?XiOMOvB7qeSubuiJl7tmkZglI7DEMNyLkBotNIXQPRcsD0mahI3gVCT92+l8?=
 =?us-ascii?Q?JoIrhdGKGRc7otANvJBefpuh5dDh/dxhiwfrDxIOghlvaVgfNI3u0Cyr4OfL?=
 =?us-ascii?Q?jU/EeTKKiuT+nmphTYaMD5I2qnkEj+rFbedMNnH+qEr5SRZxpW6ILoRNdzNs?=
 =?us-ascii?Q?bI0W36XUNefYiYTD+gk+Y8ITY8eq6khDmK2cx35volMgSDur5OG30tE2zicP?=
 =?us-ascii?Q?v01mcHsJcAzP4Op1hNdSllQoeQS7wJ7vVE4DUFeNStZ7qeGIVj8ZRnqplTng?=
 =?us-ascii?Q?idOEhYWdzoWQQB/g2sb2j+W07Ivl4oA5g4whNAbggquXwd1XJjJZNqXGeMJm?=
 =?us-ascii?Q?9Pwj194aUV8VO7gK0NO+/gCDhrso5svi/Bus54s9rpglrgLMiA/+uUt8fAbR?=
 =?us-ascii?Q?y/r8TxmvaomY1r2mQd8B4yCpkvjpn/IysodhmBdZIKl10knhecEirpTwjiW5?=
 =?us-ascii?Q?+KSixA5AyxsJgwUhjWiWzusoolDGPgyTZezbTtxsFhQ5ZsNjdDVuUTG/sigw?=
 =?us-ascii?Q?hgrD/D7CQaq3n1P2BuQVT/+LJQOpoegxFkxRsQfDU4QoJpJ9y6jRuETuC7mn?=
 =?us-ascii?Q?/CCZJ3ERdocjmpuoOX+AcNfxOxAhr7DuWsCB71MRqc4topVVReLDsX/vbVfK?=
 =?us-ascii?Q?S+oJHnNCIWRCPOIlx/3aDb+Fw6fsTVwsXZMB6kxjnZawS9e+pjEJ0HOBWm27?=
 =?us-ascii?Q?hG70d7AExhxk1TmQQ+kFMsV4DurdnJKtT0sLmcV7DlgY84IxluGErYBtIX10?=
 =?us-ascii?Q?ny0mb9m0GvrBWeKVUXtzYOxo5BLKuq9cWW4AITDYb6OlXEOB7lVunWuAL4uj?=
 =?us-ascii?Q?mU3TOiHSw++FMS9JZPLOB681wSIAHORzkQx6mu2n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c29a63-15a0-4483-825a-08daeeb1a7c9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 00:13:22.0292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNcaSrcKVthIvmSKcQw0/wioCCbJkhdzShiABPxvjt1ASCJOOkfua1P5UFCzHw4/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6260
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 07:39:25AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, December 13, 2022 2:46 AM
> > @@ -660,7 +664,7 @@ static inline bool msi_device_has_isolated_msi(struct
> > device *dev)
> >  	 * is inherently isolated by our definition. As nobody seems to needs
> >  	 * this be conservative and return false anyhow.
> 
> Also update the comment given the returned value is arch specific
> now.

	/*
	 * Arguably if the platform does not enable MSI support then it has
	 * "isolated MSI", as an interrupt controller that cannot receive MSIs
	 * is inherently isolated by our definition. The default definition for
	 * arch_is_isolated_msi() is conservative and returns false anyhow.
	 */

Jason
