Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E210B63CC4E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiK3AKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiK3AKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E663A303C8
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlB+aaQmJ06nA0Uvn8LqN5lguoXIxjN8ddGC6qJtOvd51Pyi5+eovzxnDse1BKDUOmcJ5FTRsn8fXlApAjtt/HxQBGVzmr3rbt5SHGJ020FbjTiMN4mDs1aGKxmukNy4wectAYYHFpiFTAUT/0Z+Nj54/Iqge2z8POPbvB6YPQvNHcvOdMCSZFxVd5ABprQL2O2a4F/XnPyw5PaiWNdfsC5bVBJHhGj7JsvXHMQG7E/KwV2rEs5s7C+9yeJFvUDgppyVUK1Y/Ch2zAl3IcFnCIJTSBEQcH3D/g4ZyMLKkT50Tp+ansS1LY2K1AFf+UC0qB8DCPcwJsGAiRYkFJWR7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ulbPii82TZTO30IopSHaR5kxNLTGYjxk+DBiplYQYc=;
 b=nqvhuOGtRFfF/H3cBUl4JxFqvjzFqseJkZbtJxDfImhipw1Mgd2DgbMHNayPOx/vzVAO3HIXROxcoYr2F/8yqnS0WktSJ4ioeHMJkjDHA9KcI/O08lIfZtGZSXcxlQtQ50RuC2LYYwNX2qMSGSwpQYLwRc9cpnLW5qwZvPfU269+NiLCKRS3B3MfrIUTxkBymDPq5ltUEB4Hn7AYp3zdqP+KwVCmZsf3Xjn0QK+IZpUxTUZY8FvekeTw0ssF3OvGox4q65bOO2kP8yifzrWXmVuu71458vxJoSdx9B7AZAuXWB18jwC0PZSFNN1PaMcTYlY3/gUeFgEtH5MjjPzH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ulbPii82TZTO30IopSHaR5kxNLTGYjxk+DBiplYQYc=;
 b=jN+542bVrMRPxStzhTXAEB4QWAjJeLTgXJF20vPqaSLg/QARFju/+EI+OGjEeC4k437uLDgu28OxGX7xzxKLCjitLdDKwgJbVZbwZWcbo1cvj0sjXfATtI3UIQnPqDPiRjYRkCFW+D8MWwv8FmW1if89y1/ctwApqOs21QO4uewOPnAkuSjBqA91N7GwmRPxoXp4TU/tXasf6pCe7kko6voY86XeFeRrg6bCjbqsIAZCC2TjPEYsl/yiAtDXMemDglvWtCp1zhfozJHxnP2N0/2bFv4r6L1t+/4QdT1vIcwBb4MDTB43dZyMN1W3Jys6zPZKZTPvdJedykMLt+HByg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 0/5] Simplify the module and kconfig structure in vfio
Date:   Tue, 29 Nov 2022 20:10:17 -0400
Message-Id: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0046.prod.exchangelabs.com (2603:10b6:208:23f::15)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f902212-aff9-48a3-e40f-08dad267478c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dMn95dBmM9f6Ge3tgTypffvXmLjtu58iWZ5EcTw2asqlWzfc3kTjfBXCeJiCWWtBZ2QZFhKg/wpMaa2uQVJ475lOHgivS+n7UO177iJ0ufOydQ9Jpv9B65DktYZwYfmU5V6IFCPmFqQ1rCpDe/YY1prOQx8APZtjs+XKCfRW5E8us8at2umZWFHMujuGDH2usVd8Qswvp0wwUmzUSZPbKEb+GaC41DpQNZf7OOdxOUsEr4Le60TrljtuyAAkqaIzVBPi08fcuSAeMcA5xa7iuJjZXm7b4lOswf0a/DGu1akkj/dw9/tvkcpfUZH+L8p56hZtkwBx8V8fFKSltI9rzVkTzBg7CLlwOO8l1j+8+tOnn+BZ9TvC8PyCCTnSIPTnTl4dLGWdJiQbA8zm+JbKgPXCWZj4kBJbeFdZJUmtab4jffE+zrGiV2+hpz19XWI6kwq3QhuYi4949T0lZcfA7GHpTR6XLG9JQ6IpiF2+NK92Ev7HAos5iyUWlnk1n6NVgo92WChYN3UpO3rkr/EgCDB44zkIVOtj6iuxJs/OPavHE2zYiX9ABF2qyU0nEVaVv3IdkPMPiOjOgXeys/OtZn7L+75GCtwHtv9VGzrM+A/uEbtPEzU5g+cdwe3xuf/lcqN2KNISirRHngSezC63HQtc+keVilzeuoay5ALU6A3GkPDK6a3dMWIFFHeHxRY4iy5IG1n+SC2vCSCiydGAvqJsIOCpI6HMKJGDJsDLD0Athn4f2r5kXts7lslKBKlr/4QPGbaJ6Pf+z/OiniO89v23CCwirKnkq4BWm6S/IOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(966005)(36756003)(186003)(38100700002)(86362001)(6666004)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWYwOEZpdjQzd3BOMCtiaHAzcjhIdDVZZmNmaS9DUlVpdmZRazJ4ZXhvUkhQ?=
 =?utf-8?B?NUZsMDRqdTROdXArS3dxczJrZENYVWVmKzF3MU5RWC9qbU1mY3BMOGdIZ0Rm?=
 =?utf-8?B?VjgreURhVllmanRKUXFtVHpHZEp2VGlSQzJVUGM1dnlmUU1GNGNDU1JKTDh3?=
 =?utf-8?B?TnVWRm9GMW91UjJpK1B6K0h0NjNjYXU5OHZpRXVxVUo2cXlNbGZiWFpOcG50?=
 =?utf-8?B?ZDdCS1d5c2w2YUZnQlNMa0MrOTRiNml5aHd4dkpYMnZjcHVDVXNjbStVUG5C?=
 =?utf-8?B?cTNsUXhDMjQzbW40K0dGUE1Hck9ta1djK0E1YW53L2U1UXY2Wm14M0pIM3d5?=
 =?utf-8?B?TDNMa2xLRkhlUGFvRDNiRG0yZUh0RGhDeUx4Y21oYzdGbXcrb1dsbFB1MmJS?=
 =?utf-8?B?MURnd0U2Z1JINE5kaEV4Q2VJSm5UVC90MWZ4Yk50cm14RlVNZXA0bmpIZVpW?=
 =?utf-8?B?NlcxcVRNOWlRdlRjdGt1OU01ZGlsZDVaVEloemdSeVRpMGtjNXprZlc0TG12?=
 =?utf-8?B?NXVjelFNLzJabFBRYWdldjc2ZDdSZ3VSUkNETy9IWit2Zlc1enFuTWhZM2tr?=
 =?utf-8?B?clg0aDhYVU9DVThXSTVvNFM1ZmlPeU1BaDY5RkJieTRCQnlMaktBSU9zMmRq?=
 =?utf-8?B?ZDhHL3A2a0sxZWN1bHpoL3QzTnorVXlXNklXTUp6OS9BdDlRMlN5QnJXNnQ3?=
 =?utf-8?B?S2hVc2EvMmViY0hpM1Y5aEpxa09Bb1RwejdUVFRrZzM0QkR2bkhJOWtveVFD?=
 =?utf-8?B?VGtSdEdKZ3NLR282L0JiOW1ZMllsaDhiYUNqaUR1SzI1NEV2TVZhd3VITWVB?=
 =?utf-8?B?MEVIem9Oa09QUjhKamlmQ2hPR0R4QVRhMktlcUdHQkpueER2NVh2MHV1aHNY?=
 =?utf-8?B?b1ZCb2tYSFhmQ21WcWtlRTJFMEpYdnhlNTR6VmQzRkZTVDhLUld1QXI5NEE0?=
 =?utf-8?B?VUFvY0MrNHloYUkzbTUweDNCaUFWV0ovL1JsVTYyWEkwKzRCc0xMYWR2R2xN?=
 =?utf-8?B?bzQ0SVZTcm5jWDdxMWtETWJRaHY0aEk3bkxJMDZSaC9TcnVPNG5BcUZIRGhi?=
 =?utf-8?B?KzdHK0VDb1BrM091UXUzcWo4OFczek5XUDNDOFFkT3ZMaXg5ODVFY0tZdnow?=
 =?utf-8?B?ZFlVcUg2SmhtYmlMcFFBVlpvTDg3eVNnY1dvNkIxblRDeWV1UEc3NE1NT09V?=
 =?utf-8?B?WEFyVFEwRU1WUDk5R3EzZjVGNGpGNUQ5aFF5eEMwZzMxeERJYUdhM3ZIZ0Jv?=
 =?utf-8?B?N1poejEwSHN2ZEFMTkhyMXpBOVo2UW41d2MzWWxWSlZTRjFyaEwwQitKc1Ny?=
 =?utf-8?B?dWpwaVpHZWd3RnkxeHNwd20xVTN1Ry9hQ0JIMlBKQkhSL0RPKzhLb2ZiNS9W?=
 =?utf-8?B?WVcxdkpDZFg4NGJ3RnArZk16dTFCbkczc1hKWVlzQ2lhZTUrQVlTcnhISGNi?=
 =?utf-8?B?Tlh1Qlk2WTBidEhWV29LUkljVFl3WXJOQTI0T2JYNHQvd0VDWDBCcmdaOHps?=
 =?utf-8?B?R1hIOHJhNmpnWW9VdlZ4Y2t4eDYxMXlSa0FvcGVidU1ub29EcHhHeGtkYmlk?=
 =?utf-8?B?QS9UcStqejJoWkMwdWR4c0FtK1Z5NWZ1VXl3QzZGMWVqblp3V2pSZmJIN3Nr?=
 =?utf-8?B?UkQ1UHJmNUpnSXdYZEhRamJrM0JMTkJlK1hlbGpiTWZrSjQ5aWw2SGlOb0ha?=
 =?utf-8?B?WklQZXNteUg1R1U3V1FCQTBNazJrS09PZC9MN0hxZUFHL2x2OS9GMnZkRlZ1?=
 =?utf-8?B?aWtIVHZyOTRucVlkNEFhU3ZSRGp5SU41dmxDdmpVVDBGOGcrUmp1N0RSN1Nt?=
 =?utf-8?B?MjZsZzllQ1hhQTA5N2RwVjJxKzJSeEZ4YUZrTXVnL25FV0xqMytWN3R0dnpO?=
 =?utf-8?B?YTlkVjZZM05sVDJpbkdORzhCOUpoZmZMdDJDSlBHTXZVdFIyancrNEhWR2ZO?=
 =?utf-8?B?VzJ1amVMUVA2WVpodDNzdGJVdDIvdm02QTVHdC9JSEk5aHZhYzdKMk5hZk5H?=
 =?utf-8?B?NGpmNDdMdDBHYko4dEJIekRoUy96L3lFbnZkL1FCSHBtRm5DbUFKN256KzlL?=
 =?utf-8?B?V1BwMElaZUhtY2JHSDFVSmwyZUp3eVAycDI1K201NURuaXJWb2RXM2l4bXZr?=
 =?utf-8?Q?psKk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f902212-aff9-48a3-e40f-08dad267478c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:25.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jft25LMlzl4WRgt67kd7BCqFkk+R/r+VQkOkcdH7RZxtLg+0VcTysHt7+A86w6AW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Sigh, sorry, I've sent this now twice and I see it didn't pick up the mailing
 list in to To headers/etc which explains the troubles. My mistake. This
 version should work. ]

This series does a little house cleaning to remove the SPAPR exported
symbols, presence in the public header file, and reduce the number of
modules that comprise VFIO.

v4:
 - Copy IBM copyright header to vfio_iommu_spapr_tce.c
 - Use "return" not "ret = " in vfio_spapr_ioctl_eeh_pe_op()
 - Use just "#if IS_ENABLED(CONFIG_EEH)"
v3: https://lore.kernel.org/r/0-v3-8db96837cdf9+784-vfio_modules_jgg@nvidia.com
 - New patch to fold SPAPR VFIO_CHECK_EXTENSION EEH code into the actual ioctl
 - Remove the 'case VFIO_EEH_PE_OP' indenting level
 - Just open code the calls and #ifdefs to eeh_dev_open()/release()
   instead of using inline wrappers
 - Rebase to v6.1-rc1
v2: https://lore.kernel.org/r/0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com
 - Add stubs for vfio_virqfd_init()/vfio_virqfd_exit() so that linking
   works even if vfio_pci/etc is not selected
v1: https://lore.kernel.org/r/0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com

Jason Gunthorpe (5):
  vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
  vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
  vfio: Move vfio_spapr_iommu_eeh_ioctl into vfio_iommu_spapr_tce.c
  vfio: Remove CONFIG_VFIO_SPAPR_EEH
  vfio: Fold vfio_virqfd.ko into vfio.ko

 drivers/vfio/Kconfig                |   7 +-
 drivers/vfio/Makefile               |   5 +-
 drivers/vfio/pci/vfio_pci_core.c    |  11 ++-
 drivers/vfio/pci/vfio_pci_priv.h    |   1 -
 drivers/vfio/vfio.h                 |  13 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c |  65 ++++++++++++++---
 drivers/vfio/vfio_main.c            |   7 ++
 drivers/vfio/vfio_spapr_eeh.c       | 107 ----------------------------
 drivers/vfio/virqfd.c               |  17 +----
 include/linux/vfio.h                |  23 ------
 10 files changed, 91 insertions(+), 165 deletions(-)
 delete mode 100644 drivers/vfio/vfio_spapr_eeh.c


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

