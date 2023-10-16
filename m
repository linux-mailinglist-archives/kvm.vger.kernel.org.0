Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F137CB092
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbjJPQ4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbjJPQ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:56:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09621BFB;
        Mon, 16 Oct 2023 09:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx0wJeqnp5MHpuR83eivRCp1RyShMP32htPhVQo1cd54HSJ0eS2nBtP35/jnjBE5uE+LNI8HVVMecYYXE2iG/5DwXFjw+nifBDIjjFj38wCBafQ2sb9V4r6njEQFmdmmSxXBDSLF0rlEkpwulfr/Oc4e+61s96jxc7YFeny34FlF+1tTkKjAxJCOombOUUvGc4045nJZL8PSWP/Ust+xuXgm+Uu+zmqnv+cTKmxiSWzB/7GN/4iRTG7VivZzHn4iq+RAfbzOi4IvM6ys9xDYM9aUFk3rKPf0f6XeeY2T6W7RDh/siDZ54rM4hRTPmWRrHcABl7rp1+jXODf6uaQIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hjrB42UI9BqRucPzt4wp9dg2CzxPSiKZlrjnh6pUSo=;
 b=RUcU7xMHS5fNp2ERCxSjxv20BG/prkj9RGSWiRJMzJ6Kbj3PZneHWcuugHVTK3fUMH/KcVQOUpPBN9Wj447nnbhVw/IPlv4d+CrpvVooSUY893faFPZJNH2wyCXtNdgnNwcyd5wKO4XRqBE0FBu7d24qnfvBw2YR5Lw1LKGE6BzZcHgNmSl1p893AvdqfSJxyEDcAGf/lY/kxV5kf61KZ6okpZYR4BcgLYiHbgCQUM6D4lXaLl4+Nh+7MxDnBo7e/hMgbWSFbKDQ6lloM876wHo+jN8v3gfy1VkCVGGGTTS1TsD0FaqrVeTkaPasMzYYaTAkBkNS5ryFi/iZxu0jCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hjrB42UI9BqRucPzt4wp9dg2CzxPSiKZlrjnh6pUSo=;
 b=uQ5+XCYNYUsgB/aon/azsaI8f/AsTECZJUeh4mxajz7Pv1pAR3tC99VTbHZBtiY+j+jkCCsb7VE/Bj1UMPRxa17PJLT2DdnJ95OAW32k/X1ZyeRGq7dFhVBF/4hfbOE/8/f17ckpc2REHlZd5WIOFPYxQKs8xWkV18ldnnakqFBe3ByoBRA7ZSGTgX/dEEKHK3SRRpQqA3sozaL1Mucmyhu2MrOXiWVVbaC2MOJeeRaTki7eaaX8zeT5oNE2kztfwcGxmS0e4yMX2HCCc2gMFaI1ccXpVQx5z/MISDXn8NXcFt4SBqKUVydCtsMX+8hl7mq2kddb4hkM7l134bElSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7549.namprd12.prod.outlook.com (2603:10b6:8:10f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 16:51:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 16:51:21 +0000
Date:   Mon, 16 Oct 2023 13:51:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yahui Cao <yahui.cao@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, lingyu.liu@intel.com, kevin.tian@intel.com,
        madhu.chittim@intel.com, sridhar.samudrala@intel.com,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH iwl-next v3 00/13] Add E800 live migration driver
Message-ID: <20231016165120.GA441518@nvidia.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918062546.40419-1-yahui.cao@intel.com>
X-ClientProxiedBy: BLAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:335::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: dcb5559d-01c1-40fb-ea31-08dbce682020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItrG8ZQTGrFLgpu/jHn/SvNLQYc7L28pVz5ZfCUbSWRBchv7TiK12ZNmA0UM3GI81Hyk9k84btzPLIWFr6zdoPKfMm4x5Dylx2Vi4VRHTwBVbw1t+KJ48IquWXwpSPEOwNLwzikr/mLLjp0yc9u5scHGP+B8R7dJenOPTJF9yjHmhFNhoMHM+HWRF88GxXZMQlMPKUQBmX99TgPDSPZ80QuCIMomtLpxT/zZdcYZcu1306uRBqQZVus3KkoausE7u+T3FBDlEqCXe/zmRol03JaU7UcPD6KOoxstvbpYeBAdcmUBKtdPf2/Uqfikhib1VftSuyqxDi937/HX9DtVrBjEeGaj9SnY3A2sPT6+ityBwAo3gKq3ayZb0rR9qVGB9SA9WCAYP4dcbp3jddY/CKmXEpJd/RpgoeJbl+cp295VDsNopt/rJ1QJQXrAiLzr+UH/ce/8ka/zvg9Po11niBtptuPfjpzZIttwc4NI4x0TlQxgopsLBFrVoilpSFtqeCDtHizdIy6guXdSri2Lbmtlm12WGi0RFzY+4aMv6bqKrUbwRj0MjdXgaadcN/F4rTm9vBbVzLSkdzbrax8nzd/Up1tqyDcNbw2R6X55IaASaBqcILzSvITj2ECyDHS5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(366004)(136003)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6486002)(36756003)(83380400001)(38100700002)(6512007)(26005)(66946007)(478600001)(66556008)(6916009)(316002)(1076003)(2616005)(66476007)(6506007)(2906002)(7416002)(33656002)(4744005)(41300700001)(86362001)(8936002)(5660300002)(4326008)(8676002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vSMcOluMA7vwuJlaM3JjNnlt6f9Fp8Hw6xP5FFnyLbnIfuGuuaaM/Lqp1Qre?=
 =?us-ascii?Q?8EJaIzYZRr0HWLz3LSGA6AFzyImToDz8JhvKpK885me6KOkDXF0UHZUmSK2J?=
 =?us-ascii?Q?UF6P86WYAwJqMlgDlAnwqgiP38ZdNKdiUftcS4j5aBrrKPblUBOG9FXfuH6F?=
 =?us-ascii?Q?QAITcOI7Y19I13F1oHPAkFflmU1y+7VEjeDgLxyFAa/G1DMMKWKOIErkmXJU?=
 =?us-ascii?Q?OB33HbHbHk6h578r4ZNsYqbjSfRvAusk3mw8OIgKobVHZO+KqF22jgm3AToq?=
 =?us-ascii?Q?8Zu4jvcV73XIzmCDX0MslvWFyqFcX8/cu1zfwX2XLLHubLdbpcKA52mZjxoP?=
 =?us-ascii?Q?IWVxLOYSHg5TGCL3HG8oOm291dHXIKANfJdQG3TJdGHVN10n+V1XW4qpUo34?=
 =?us-ascii?Q?ZbSYfSpmjGrwA2ZoeQFJCKolbJ2kcUoXgk+dCynZEKOmWvfKuMOXS5KBr4Ei?=
 =?us-ascii?Q?mXEkcRN1eoYiScSS4XQI0Pf8W2EA1U2M7YzkB+tvoBsr0AYqjrg99Z4h0PAC?=
 =?us-ascii?Q?iwO9yEWt+cWV5hM19bab8G2snUaptWY/eHYAfWmiPNYhSapxj4xTyAMIyw8K?=
 =?us-ascii?Q?awm89CKs7pjNYfux00nz6C2jBub7uL8LJKXUFvBfT+GInOkwP9QQznE5KNU2?=
 =?us-ascii?Q?+xCA3YF/VHbkJE8bxDRdzJ6/FPaYDb2TYV20yuDVqzdsKRLIA63pCF3nnfKD?=
 =?us-ascii?Q?WegHsF0Fj6fmVosES0y+TNv4pOjfC8LUeZneeWxwD0Bf9MXCTkKSa3A4jCqz?=
 =?us-ascii?Q?B95MtAtx1w5CfiQk4RTdKBm5OK7+TBwy00mzt2CcW1d0bbRFU6mIkwWIFsO+?=
 =?us-ascii?Q?S/NMSb0sAyx8rG1E2aVkVYCxrZE7uk0YAxS3SaoYbVXBP/GKIIZKgQW9CjvZ?=
 =?us-ascii?Q?mAt7ug1CjKEChgjJ2ZdVK126leHHzjof9GYBRMFFzSqwKRr0fGq5JCjwZD3G?=
 =?us-ascii?Q?nmrFN8L9dJsbO8BYvjMaROdY0j2214atoklYsAZBS42tHErVRCK7zJOKhIvb?=
 =?us-ascii?Q?uLdc1LOXOAMh0GWzYfzFxetaXSwp+dltiHbz9VR/1b/lEiou9JzuVdbWWA7+?=
 =?us-ascii?Q?dwPyMsyOS8Rq7+INAb2WhOPQQaEc/CsbD0kN4HHK2RdDzSsrLWwY3XlQPTkR?=
 =?us-ascii?Q?5PRkPnfCVgUiKnklRw5TBmpmoC0KkLqfxJ1B+Dm/LEPWRVl5M5rosmmwfluO?=
 =?us-ascii?Q?d37QnRvK/qdzJj7TF2LDYKIqRhHiLdBwsyZ8pUuc1AgV8n3F6YQlGR2nbI2m?=
 =?us-ascii?Q?JGZ03bAW0buV1U9xTZUEnVaEU4HE5JR38rdNd/NcDw+YtNl55Wwe7tkh6G6B?=
 =?us-ascii?Q?5exmsAZ5Fs1ncvt0Qe6o4C9rIfhIOtNg5qLHQQrMFWdbdtWWd02HkOseXely?=
 =?us-ascii?Q?QlNAYuKYxHA2/cA+ElIcsNflYnD1Ap9GgHZm46oxRt1hqwBDOAAgpmsCRmnP?=
 =?us-ascii?Q?szobgQBaEdkcsdlVIlTRvBDNa8d3dgB8nRUMYPol2BmnH88aQ6L6JkwsUwB+?=
 =?us-ascii?Q?6bj8Ts5l9RENDY7mupRlhYnrP2G8RMUDEJYSit4pGR9OTGwX3JyX0eECn5J6?=
 =?us-ascii?Q?R/tMgiHoBj5DNW340OE/kvaiNFA009CS82xvfKvM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb5559d-01c1-40fb-ea31-08dbce682020
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 16:51:21.5544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpvTQH6zwtQrOOggey7rd4ggM7OreSXopFXIaaEHkwhVh1dKw+eX3XtAmPGTtRtT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7549
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 06:25:33AM +0000, Yahui Cao wrote:
> This series adds vfio live migration support for Intel E810 VF devices
> based on the v2 migration protocol definition series discussed here[0].
> 
> Steps to test:
> 1. Bind one or more E810 VF devices to the module ice_vfio_pci.ko
> 2. Assign the VFs to the virtual machine and enable device live migration
> 3. Run a workload using IAVF inside the VM, for example, iperf.
> 4. Migrate the VM from the source node to a destination node.

It looked better that the previous versions, I wanted to take a closer
look but the series didn't apply to v6.6-rc6. When you send v4 with
the compilation fixed include a git link please

Jason
