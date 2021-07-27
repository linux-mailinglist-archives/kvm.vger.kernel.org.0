Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24363D83B3
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhG0XJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 19:09:46 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:58756
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232198AbhG0XJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 19:09:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxFegEcvkd3iS8q2AUr8ay2PhSHr44IBG8TSvVGtvV8IoHkE3jp6lNdYatIBTJarQv+a0jJESfx2TS8GjZIwx7tuvXHHuW3U1gu3Lf4hhtMkMzI5OiZEmYpXEnDdyDuGmj6EjxGiDLFL/J2LGpyOMa2/9lniYaXs1+20k75g9dQ+tSArPa9TUKpOY8l/y1VX9txIP6k6lle6k5sumtf9KGsk7JOR85NZfh1VuabrglJAUSP/sdDMTSF0CRslHuBTSTbGovQZa35EZgzjpT20LEPvB4rk3poiNqfNeQG4UXx7PrALd0CokI3k2lG464yuxmeUODsMr29NdXF/NdX6eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JgEBvEMBkcGC2YfFwAgfLUuq9e+tUQ+KVfNhn5O40U=;
 b=PWcoh5uwrYK8uOfbW04D5oHonHT6zm8iqHdVbZpz2d+JslWNfwdsQmiZVVKp4Lz0TL/3Vcy5DpBHEvQvYhGMDfsKkK/jxWUfSqNSnHfChYxvOR6auBblO/UUw9WyaAF3YrUqm7sOZNovT4xHhleM6S0Shi63Je3+hZFoPNAdHp3DZ5BgV/iiNw8bD2nzV7HM577fiy7DknAxFeGSTsdVXRyZrBEgQ8ubxEG61ImH5JxSbWJ3Db0BcjlxdC4Nu1Yf9gRKVIgBdl9ln1o6VF2dZe2BN/kDLLFMC+4wVtDlhi4n9wDuUNvZNbo4SWjjhI6cWuoFscJCtm5WBJNKPnMvCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JgEBvEMBkcGC2YfFwAgfLUuq9e+tUQ+KVfNhn5O40U=;
 b=kQ2BKKrpoW286Z817Hm8f8lxdl6MVPqea9tIo0mNccA0AejcS6Nyv6QaraHRapKtHsQ0bi8Oc/SmbWsn/m5sswAf/y5Tfpk8vhvf/9XuhCqiNMkqXVfSUpJs46mlkVVgiTl+9V40GNP0AD0ElqvsJf5dK0NWSSBiafqS+8c+wydRPBXRdfU5XYLuFapXI+eHqKovHfE3ilVW+bb4/AwrWYH8UKuLJiD6PHDy9mECCka9fAA4OvgEhp8HxblchBmfiPY2TtKP5nmGFfZSXf1iQLb1rsAytTjSImFn99p9fYsJjlwVUvQbedJPCYVW6Bt+oWUApjxMqQe3mhFbjWM2yw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 23:09:42 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 23:09:42 +0000
Date:   Tue, 27 Jul 2021 20:09:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210727230941.GL1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727155440.680ee22e.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:610:53::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR17CA0018.namprd17.prod.outlook.com (2603:10b6:610:53::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 23:09:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8WCj-009F6k-5N; Tue, 27 Jul 2021 20:09:41 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75f69c2d-7e14-4c34-9daa-08d951539ddd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5191E9053C372A4132E1B5DBC2E99@BL1PR12MB5191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQdkzGItopZvzRpW57xuTMTlxksqTBRD/EU2tXYdud7HVv3cwsNyAiC7Rxr7NKfDIaAL0sEndpy0Oi4kCynwPVFceHd34Bj8b2ddxHZOSp4ptkbEdUL3CJTcL7mZeZBkFe/Qge4V6shjouXYsRrhBs0Mvb7DywzJ4nLgvKojr26JMw5qyOq3nOKbu4xEtSxrBvW+R9EDnDayNg1/Ip5Uh4IGsZv5oA+xnms4wCGk1Pt6dW5Dr98IKPuIctiSPHzRKgOtils1ye0w5F8F3M4o+C27d/H0POqC5xDB7jTRN4bwb/B4itEG23FXEvlpITOmKKHhGOYJZvpIq0muSIV4m6FSkaPR+vFjPQ+HUr24ZGmN9fTX/eH3tNse8aag6EXBI4hoVg9hX29UrUZwuf0TEJiqxh6sim5msovywr0X9d3DQeqkEjrrGVOZ1xMMpF+2Gl6hPRMGwS5yOc4w7Os8p1mF8XCD26LD/7cfzKa5SBTA6V3kKCqFSe+pQIrJsZ6QFYX8Cw02INftvqu9d5/LnY6djk7p+nltI/PF5cAbUcn3XjxcvDh6cC7FdPoHPQ17Lg8Yy5ezZrz42PmgdUvmAUVQy24uxYKqbRlL8c9b1QwgKx52RqRGdg4HqsFNBHhQm6HEPPHZQBPoU9oWFII8Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66556008)(478600001)(66476007)(26005)(2906002)(66946007)(8936002)(8676002)(38100700002)(33656002)(426003)(110136005)(316002)(4326008)(1076003)(5660300002)(9786002)(9746002)(7416002)(2616005)(186003)(86362001)(36756003)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jdmgmilqrjhu3NAJteZYGfyXKschlxRd9ELb1XHljKcPL1YeAXze/09lID10?=
 =?us-ascii?Q?ohdOZm3FctPdPHJhCqb1p7+AaJb5uFSmdOTRMZ1u1KpCYDAgIGuSStPD/qaT?=
 =?us-ascii?Q?8FfvZDkA17JOv08/YPPwOuZseD1koizc85Uri9CCbgHLE3qZ8r+wSa54kpOc?=
 =?us-ascii?Q?0WhzKhmd0KgB27UPc+u0Wb0WJZvM0tRuCHUI7qvc8mZovwymo4gy0ExW93s/?=
 =?us-ascii?Q?9bqCAQMwc40pWB8LM4oopQRT56Aayh1ZRS2nurG2zsz7naczH79IKuMh3nTQ?=
 =?us-ascii?Q?QaevFFte9RyiREdUSQm1FtkO75YQrcY6KQ1at7vtwwqsoojK/fcz5HKSpdEN?=
 =?us-ascii?Q?BuTMeqIyI03wTQQOur4e6qgetB/BFT1OHNPwWd7UEuje2/lwModAFJFiGptZ?=
 =?us-ascii?Q?adCA+/B/NOz9L7bok6qePjx7qT+szuGYqqlWsnKY7Ta9DwsAHVeipI8MGa23?=
 =?us-ascii?Q?uvVrz6kAyEKK6bJTdhMj/MaYPUD5YL1CEHgPwZMqUasAb5ayNlnoY/EkWF6K?=
 =?us-ascii?Q?FLrjox5b/zHAFqZxWbrs6XRSjmGF63i651/Tt/A75vXlyz2hh/7GwS1dXifK?=
 =?us-ascii?Q?x7/HTjdiW8M4FyNZoT64fuVlUZrbSHc0qiYLVYHOifRh0PdEBLlB3Wg6FWSD?=
 =?us-ascii?Q?DQXn5BpKvAIylNgBYxXTe6X+Lq6jp+CNOMnhPT+kreHw1v4lK8SDjXT8EQtz?=
 =?us-ascii?Q?r3+L604jmK7NiIjneOQ27e/CesUFz6oQYWqWAz9VYtuKqkoil/+a3Jsm4WTQ?=
 =?us-ascii?Q?fFlzGKaPSam6xnd1y6WrBEqq8Ltl9cRAO3LSjZssZswzUjDFOkAC4jZIhUtR?=
 =?us-ascii?Q?jskEXCuBKwE4eBBuJjxdQCbhuUoDvUgd5tr9k0QR1lqOPF65UAMhtLnr3zBq?=
 =?us-ascii?Q?2Dc3Ijp+G3dRBMJHD2h2rbM7AZ7IcKQh6FMcxSO0vFv9IGJOitXfBF4rNs3k?=
 =?us-ascii?Q?QzcgpGwDu+BKgkXOLE4yP4iiVTEPhVHrjvNxolm9pcrwuYteFMIUvf2sxgra?=
 =?us-ascii?Q?nXWTPMDeOcEMGaAUgiQzTyKndhB5zsEt9XBauBI9hY65+KzH2Zj13WLyhEFM?=
 =?us-ascii?Q?b5TvidwxTT4KlYpjH8qVyWdy8U1Lapm3lJ/ZXR/KeNq7tKFU0EQAFN9Ic+Xv?=
 =?us-ascii?Q?G2UgRy31SCNPMNiEMw6TzPPUjkRCeF0nRjRuXRwqh32Er6/YAEFXP0VMkP+4?=
 =?us-ascii?Q?gxBVRnnnCfq4CB3sZcD2POh99cRb2IIGoMOOmKwk3c+0niyAsA/Aq5cyP+wt?=
 =?us-ascii?Q?dTnIZ92dZqtFOzIbgMpPOGgG01a3/CrUTgAG5gojraGl+hF9TLeEGhMF25Uy?=
 =?us-ascii?Q?+LAOMXCWollpcu5vY90Vdl7Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f69c2d-7e14-4c34-9daa-08d951539ddd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 23:09:42.4428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUOKY/VHpHg9UcgKOLDytc5ykn8iBcOGwt6n2CAejMHQBA3dPMn/0kGKI2YI5A/P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 03:54:40PM -0600, Alex Williamson wrote:

> I'm still not happy with how this is likely to break users and even
> downstreams when upgrading to a Kconfig with this change.

I've never heard of Kconfig as stable ABI. Christoph/Arnd, have you
heard of any cases where we want to keep it stable?

As far as I know we should change kconfig to keep it working properly,
eg by having correct menu structure and sane kconfig names.

In any event, upgrades work in a reasonable way. Starting from this
.config fragment:

CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO_VIRQFD=y
CONFIG_VFIO=y
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_VGA=y
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
CONFIG_VFIO_PLATFORM=y
CONFIG_VFIO_AMBA=y
CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET=y
CONFIG_VFIO_PLATFORM_AMDXGBE_RESET=y
CONFIG_VFIO_PLATFORM_BCMFLEXRM_RESET=y
CONFIG_VFIO_MDEV=y
CONFIG_VFIO_FSL_MC=y
CONFIG_IRQ_BYPASS_MANAGER=y

Which might reasonably be from an old kernel. 'make oldconfig' prompts:

VFIO Non-Privileged userspace driver framework (VFIO) [Y/n/m/?] y
  VFIO No-IOMMU support (VFIO_NOIOMMU) [Y/n/?] y
  VFIO support for PCI devices (VFIO_PCI_CORE) [N/m/y/?] (NEW) 

Which is completely fine, IMHO.

The menu structure ends up looking like this, which is pretty good:

  --- VFIO Non-Privileged userspace driver framework
  [*]   VFIO No-IOMMU support
  <*>   VFIO support for PCI devices
  <*>     Generic VFIO support for any PCI device
  [*]       Generic VFIO PCI support for VGA devices
  [*]       Generic VFIO PCI extensions for Intel graphics (GVT-d)
  <*>     VFIO support for MLX5 PCI devices (NEW)
  <*>   VFIO support for platform devices
  <*>     VFIO support for AMBA devices
  <*>     VFIO support for calxeda xgmac reset
  <*>     VFIO support for AMD XGBE reset
  <*>     VFIO support for Broadcom FlexRM reset
  <*>   Mediated device driver framework
  <*>   VFIO support for QorIQ DPAA2 fsl-mc bus devices

Jason
