Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4E53F9BC6
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbhH0PfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 11:35:02 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:55686
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233303AbhH0PfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 11:35:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrnxcH561cZWYjQgj7IUvbs6+IwbHJj8X2wQcUfUTHuCs8fmeeY6uRpnTLII7HttAFRgrkOU8DeWCjfQB6tmAHU+PZ1Vqi3k0P3+j05ORRt3UgqGqOJMh0iZuez7m9mW1ntoo5Z7whcpM30x01ViUjpPf47005Af2PCz/RLFs+OWbl9o4r0h0JCIi0TFDzjF9jQgyevmgyXvbYymeXvzEc8dIfA+7GWetxFTANGioOTdhEI/Tfv2PQnuTyEsCO8R6ZVbj2MfcyqoPa9eSxT5pXPnjeo1uaxTpc3+pakUrUuFBd/pOmeEYQz3csnaeBrYzj7eGFstAlE8VV2AdSR0+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRAZJoGe/ZLkMREEbBRSnPAhIXAXEgG2xAnA1uXEBCw=;
 b=oSrR+5Lhr4PcE3VIejLzqzMYzPwGYYZEBU+EZJdNulLG2ZQTqbiJGM9Te4QSkPj2CY2eRoPvy0dAoTes0XQwj2i94lP0hPU1QZ3EROmGdM3Yw9f31Gjcm6ZVS+1yZ9in4FnbJh4NvwhUasckR75XG+vu+r4Zki8PNeKOUXQ0wBIDmsS7+cA6R5aS3QcT6Rj07fLUOGT32I1aeRy11Bt8fKL+xwkoB+VhOVAKLnSfdj4tKavHciBuYuD4CmbHeZhkMcLJJeRHDbvzBN3ofWaN6lHpeIhusd14PGBIUN5wEreIbgBbAEgvAtzvzFtA1gVZx3hIH4/jIzHNrrP5zGYAVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRAZJoGe/ZLkMREEbBRSnPAhIXAXEgG2xAnA1uXEBCw=;
 b=fywHwnkZp3dXi2ywyRkY40lv9aRu6JiGgReC3Z3a7z/L3SIV7BMrj6OP1QzrA5dq0dmOvlDLwvzgfom0Hl8bCzFoEadRdrUw5q4utdtNuNoU2dPDR60ps5LJ5Tf2uBeh3UIsvTj5pcXG2S7imDwu+TjSszqXeBtKMUzq6vThjh23ho6GNAqrvTTgFNA65e+fWANjet79QRqsBj9Ov7sfhUhprYV96txT/5D8MqJN3O28qS/zf865I9DUO57lsb5FAIWHeh1j2cdq0D1m9PGuU/LXXWU03V8vMtUv6CWieBDT0BSRBF2FLeJZHvn/HjBBU85VcPFpt/VHMhCIgXKN7A==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.17; Fri, 27 Aug 2021 15:34:11 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52%9]) with mapi id 15.20.4436.024; Fri, 27 Aug 2021
 15:34:11 +0000
Date:   Fri, 27 Aug 2021 12:34:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [vfio:next 33/38] drivers/gpu/drm/i915/i915_pci.c:975:2:
 warning: missing field 'override_only' initializer
Message-ID: <20210827153409.GV1721383@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202108272322.EipbBEAp-lkp@intel.com>
X-ClientProxiedBy: BL0PR02CA0136.namprd02.prod.outlook.com
 (2603:10b6:208:35::41) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0136.namprd02.prod.outlook.com (2603:10b6:208:35::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Fri, 27 Aug 2021 15:34:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mJdrt-005j8D-RN; Fri, 27 Aug 2021 12:34:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46aa2e74-8c10-4a77-83e5-08d969701df3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB51366F3BF12B09AC0D1E3315C2C89@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3r46rFlWROVhE38GrUln+aTinC1g5Qy/BnwvsLjnAv3qSZJJ+UxBc4WcE3AYtu4b/lX9RhPcTWB0ITzJ7hDLFiTU3MlxTswaL5TQgkOj+Ek4Jo85MPs9lL+bRQmFkAdzqbrRAf5GUCihyQU6WCbyHPXeVYz0W+51+iyWP6uTB49pLMYvkloCEL7RU5kQ3N6VgSxatxAUZJcaepWIFI2W5MbEhpid9xg0NKQ0L3ztUKnUXMwTtK2h21nHZkAJrdMl0arE8D0Z0cd5iTw2FYF/kl7tqjYHuBysKE1lF5yBV9iSjMy+wNHG5qaujrAZfsCvPuttNrG46KA7AzeDjPct1r2cN11r1xLNSBXMs7fNGdfP0sz0T/BLEapzMGf+GJxD3Ont0zm6pWbXAt+0rX6XkS8YqBeZFoJzQ24mxOtxaWQU59/Pn/NVEnCU6b/xExJ0KydvhYaFxMCgRTKnZ9btjusXfa4OyztVRcEqSK+uqvPPU+ZFM6EUpsnqNTisd1XWuBNV8rPZYj99xdjUq03Sh4wfXRK/mpKd3hrFZacJwHWcYOkuTC7T++oAR6FjdpxteAUMDX5Yrm7Hpac7A7/lNP5nldeZBzKrip82pVaxdWVIWUaXEi7kzjLBpJElfWinUD7T26h4g+rYV1dKo7JY0nNQiZEzShx96NnqhdISMhewprb7Ln6YUf2JyE6ctYr5RuHiQTHByGSLsJ/Nwf+zq+dKHSkaahkaN8548/WBwqCboiKaR8rT9zoOlpdlkdpM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(966005)(66476007)(186003)(66556008)(8676002)(1076003)(5660300002)(26005)(8936002)(66946007)(426003)(478600001)(86362001)(36756003)(33656002)(2906002)(83380400001)(9786002)(6916009)(4326008)(38100700002)(54906003)(316002)(2616005)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?152cP/mGCOjFszuOzYd/GLP+p6yz3SRdl3pPZzmQlipyrX2Nt0CzmX7niEHl?=
 =?us-ascii?Q?ZZ13wzC6oadMLFf0ZiuBXLJZ3CdDXOcys7kcxarmTIh9l2lvcbNHNM77z5qS?=
 =?us-ascii?Q?ED8HFIXdUh/C2IIxcdoYa1HQvW+7ZzABr1kn/xJ20tAcpBz4yVjWbHEmFXyL?=
 =?us-ascii?Q?0DvU9V4YJ2JqCbKExACeWJA/gZIz/cGwhLGdB5sXtvW3RFQ+HB2H48rxmhIU?=
 =?us-ascii?Q?yZCBCMHRxdAFQbNbOQsO/BppohTVf53cN5MsjP5dJpGeJoi/OqvXowUSqYTu?=
 =?us-ascii?Q?J2UdaJGCMyYdR6T1ilem0vB0yp9imQ/scKtBVb+TqdpM2jXdgYycpnbRqdW6?=
 =?us-ascii?Q?XZrfzyKVwA1vyFpeEJFpvg+REbDQnToxaDHIhAkPxPWh4ocQQoNkE60lLwuI?=
 =?us-ascii?Q?faxv6/2INNio1lJJ90DcIuWLDiYccdYClgWezseXhisWpCfVGJu/6tmjjFdX?=
 =?us-ascii?Q?YlXeidun4ky42SJs1/OD+EnUJkO+xrlCizjTRN/tn7jBqQFk7fJdAHF3xb+a?=
 =?us-ascii?Q?GAE//z2Ejryt28Hj9h5TXZ4x4XWrfvxjfLmnYNXt1YM21nPrDpSSn953CXa/?=
 =?us-ascii?Q?Iw6RBZsKjKawlwGI94UZxNben3BU5YxCPItOU+9TLIJYqmqmiICR5c+K2wzD?=
 =?us-ascii?Q?81HhUI3o51GxS6wi+FwbT6nnS8XG9pBzaszmbUbEwCzFVX5k1Vvi57PmralJ?=
 =?us-ascii?Q?+CXAuAnOJkwwhVugMf7CLBS95xbawz2dHkGOt/R1YPtUDs+xrexRozorI8iM?=
 =?us-ascii?Q?HMzJf8KCPe4qrmjcR1EI9tECNJalhFfAg2pZHZHhLkYQBcSykXmKg/5uvEk0?=
 =?us-ascii?Q?UiSOD/wXJxPXdioE7zBQ7uFEvGrYyztQk39AYP/ADtMx2eBhrboiVvShQqX4?=
 =?us-ascii?Q?nhHv/Su8xbayVBOdYJwU07WKOMJZVRvXuiUP260MJzQSsJYQ6zL+5RDsujlV?=
 =?us-ascii?Q?SgcrXvcODBcvcZfJ6QC8VLAVkuRMLbYIeTYPyaceZ4pKcs+JscsRfQBVKlU+?=
 =?us-ascii?Q?CLnLxLEC9DvBqnhE98yenYcZ/YvN4UssKxFQAh1njEs+z2HXkStAPUhSiSoZ?=
 =?us-ascii?Q?duMXFkT2DAL502B4xsLzbPKJEAA5Xp97mMdM9/HpbUKVIrUkL1fpyjpF91Bq?=
 =?us-ascii?Q?0mY0LglHGFwTB3Qam30EvaKiBipGV0J/jBGCeNfncA6t1GQ13UO/kA1ULjj+?=
 =?us-ascii?Q?Cqmh/pRFt5HVrZBGQXVz2JVNVQ3vdNE39ZcATm4lLQOYgPzdxQU2dBgNuVtz?=
 =?us-ascii?Q?yJB2S1bEkowM1dsquK/Ek1RITSnbUO1pEx0+SRYoTBb43SiZko4Xy75hAMcm?=
 =?us-ascii?Q?hiorIFc5wE4+IUxMXZZweONe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46aa2e74-8c10-4a77-83e5-08d969701df3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 15:34:11.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ngm5M+Anhru2t8ZhNscbVa+lt6zCbuZ1mj2fP//PzvwuBXqtwI5V6mcws8iRRAN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:36PM +0000, kernel test robot wrote:
> tree:   https://github.com/awilliam/linux-vfio.git next
> head:   ea870730d83fc13a5fa2bd0e175176d7ac8a400a
> commit: 343b7258687ecfbb363bfda8833a7cf641aac524 [33/38] PCI: Add 'override_only' field to struct pci_device_id
> config: i386-randconfig-a004-20210827 (attached as .config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 1076082a0d97bd5c16a25ee7cf3dbb6ee4b5a9fe)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/awilliam/linux-vfio/commit/343b7258687ecfbb363bfda8833a7cf641aac524
>         git remote add vfio https://github.com/awilliam/linux-vfio.git
>         git fetch --no-tags vfio next
>         git checkout 343b7258687ecfbb363bfda8833a7cf641aac524
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

Ugh, this is due to this code:

#define INTEL_VGA_DEVICE(id, info) {		\
	0x8086,	id,				\
	~0, ~0,					\
	0x030000, 0xff0000,			\
	(unsigned long) info }

#define INTEL_QUANTA_VGA_DEVICE(info) {		\
	0x8086,	0x16a,				\
	0x152d,	0x8990,				\
	0x030000, 0xff0000,			\
	(unsigned long) info }


Which really should be using the normal pattern for defining these
structs:

#define PCI_DEVICE_CLASS(dev_class,dev_class_mask) \
        .class = (dev_class), .class_mask = (dev_class_mask), \
        .vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
        .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID

The warning is also not a real issue, just clang being overzealous.

Jason
