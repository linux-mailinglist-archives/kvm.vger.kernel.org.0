Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD938DE36
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhEWXxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:53:48 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:59360
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232037AbhEWXxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:53:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3UlFqYbr5Jafo93qHDE72TSzyZCh/MgV8+yrnaG5GMma9TfvSh+ohoW6otC2kkG8RrGBpEmOxGofOQ/4Y9R9FPK+gFrQ56bp0L6jhNRfobWXHtDyCW5KhGW/f2YDAhsDMPnEJiDE8Ked/g9M9goEAtkUs9bEokADnKjQF1tUAc/Xbqh1q3wat/0IMxVfV4ZYU+FtQrmUmCs439PuZyFKL8Km1IWkzwij6D9YH4OKG/eV46jEA1PHIoGdc2aTiJ12exoBqFoF/2XiUmzLe2v3lNnO6OUTCeUz9nigaNxzSn0xnehWac4nxGvMyPor4m9bVb95jx6N/Vv9psC0E3HQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/PdYodxpeGx631hnuLZQJ+0bKahwPSepxcLEcUvr8o=;
 b=jBbJUpTU5poxRgcjWGtiQnWaXw2+rgrQepZPb4dBMIQwaG/8dyFGJV/v8qb5NVVtDhS8XrKcs6aJMkzV+K8z32D2cPz9uhWkuv9q1zhvZRWZ6I2BflXmuW5XsoH31ut2UDI2cCAzUmWpI+S1mUFrp/n0nlzYUxOi95u7rxpcKUlmhSk0dDflt9AqZrQFI5snqBk4URkBH51Im8lkat03oOhv1dSMCpMdvbP9y6DTAsLIC7hzFnv+2smpPVrxNJJ9IFy2VE6n/f0ttYAKW6dVrqAiSiZkoKpj/a6zQ4oWtk5VH1a9v+VNYkKfBGUAJA7PaRo++KhwNj379KcY2iiOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/PdYodxpeGx631hnuLZQJ+0bKahwPSepxcLEcUvr8o=;
 b=hHahBB5K/MH/X8i7JTDhJac8eQ7W3iVYFmc7WhKbDVJUKdt1B03qNaxWoEJ6DhZz80hOguHE/jsPsPvg8MOJ4XGOS3CO2qFzURPvZxhdiZMOnTpkgRWi4ykjUJX4lQKBTXW2oAO3fxkhpuI5IXm8mGPdvhTjkJtF18PwBd8n56i9Xio9E+EK7xnxQ9KvBaE2wDZ5vwiMCtMP0RxN6OnpXWBUe39b+FqlftH8zkd0wZPWD+oo85sXjvm/YCiO9zfQifu9PcMXc/d4qRRx6nnWLdzFzjZaLBrvczvTNHlyhYtvbE/M8pGmnVQEbREzgLYwNK9hdy6tl0wCl2jyXA+tHg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (52.135.46.150) by
 BL1PR12MB5063.namprd12.prod.outlook.com (13.101.96.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Sun, 23 May 2021 23:52:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:52:19 +0000
Date:   Sun, 23 May 2021 20:52:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 11/20] vfio/mdev: idxd: Add basic driver setup for
 idxd mdev
Message-ID: <20210523235217.GM1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164281350.261970.10539208268885731071.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164281350.261970.10539208268885731071.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTBPR01CA0013.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0013.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 23:52:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxtJ-00DV3U-AN; Sun, 23 May 2021 20:52:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8e3af91-2933-49ed-4786-08d91e45cce8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5063:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB506311DC36FAD1E181C0B903C2279@BL1PR12MB5063.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l79zH9OAhrGDW70bUVxgVdwb0TSDj9AGoRh3OwmaP0YaGLDz0D/mQVj2RIqdMiX8TyW6jJ4H2LlitYKx10T9YkwvdRqbZufAzUpTmXdYtYiJe2yEDQojD4ZF+4z0T9Ji9wQJlQrlxayhJIQrF9fdo+MyK+5b1H8ACz81QQJpi7a2N05ZtwA/hAYBvdjRApDXP+/aiB7LsI1tKZ0xrwwOC3jCuAh0EdISTVZ97nQHLQXtUP2WQNm5gY1uN3iQx76lXQD1aKuAGrLBdrZ4marHIbXPJAWv0FxlrzSUg3HGmftmkf1OKFXryTdF9e3dow27+w7tn7fuNHamS3UTETi740QBo3Xq2Nx+hZpG5O6Tmh8xTsDqitpUZltYC+YvVtml/G+ymOSyHXK55US37DEQH1B2+Mz5EHBYv4K4Hkj/hAB4rdQIY0qPMXIUmeudZwuixHB9aSgZIY4Z12yPtiInq21Uqk1tAHpmKlmIofRIEDivsrABMd1bealigq22pyIAyze5AdBy6nk0f0mPSsw85ICI1QIQRQ8fq3zs/Rr4M+vbM5a9YPEMQ9osvSvDZW+dzuF//OKLMNcSNMR9OE7ZN8OBQDqEJCSb8scqwnn5PJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(33656002)(86362001)(2616005)(38100700002)(426003)(8936002)(4744005)(2906002)(186003)(4326008)(9746002)(9786002)(316002)(6916009)(478600001)(66556008)(66476007)(8676002)(26005)(7416002)(5660300002)(66946007)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CBZgo6/uC7HC+WJeW76iQo26g23WsihaC6rLDsAaqn8wiBy7uu7TU95VCO3K?=
 =?us-ascii?Q?boTD+YpraC3cx+Rp0ILp3iFf/UQ2zjLvSj3oovtzKffAX3UOY68IV9JRRSDe?=
 =?us-ascii?Q?tXZGyEriwhhDMOfrtSytEPRTOq5NPfEFHT1fsN4RDnX1ppKZVrcdXTiQqZQT?=
 =?us-ascii?Q?C53FnpuTG5QDi8g/g+JnpRcUeeL3UbQ4G+jhLMrIL0oQMClHl97BjGYnKRRU?=
 =?us-ascii?Q?DQhDmSrTSBUL5+9reqZFAx7UcGlumL91cdIm+qLQPzUVpWXgzPtEAoW9fo8h?=
 =?us-ascii?Q?6A0D3aPkMGdXwSI05ZbZ/x29CfTXK/+MxMnscOwIfDDIltuIGHIxNXG+KPSj?=
 =?us-ascii?Q?4kEIm2NaSnvtQKI1OcgwmAm8Gr76sqLHnAPSjc+WbAAe3XiwSYL/8oVEWIpi?=
 =?us-ascii?Q?hM/yq0+DUsdhycnYn7/48SaShGtq8ByBnJz2ZNCchpAU8ZbVmlCLvjSdsb7K?=
 =?us-ascii?Q?/acPFZLo7XQYnGvk0/Yhc4aTYM8DFnRqBcfCpFi9z3I4ytCjp69ji7aJqY7K?=
 =?us-ascii?Q?6QfwjDD9Q5Wdjh+osAhSzB7mofpnxx0mObxqnMYmQF0bDHbX3liD7+WPiQ6T?=
 =?us-ascii?Q?u3XVCseI1EPTh8C/5BZ+UBf0C68CnbbUGuNA1S7yFSwRAlvV1SXfytMIh1AX?=
 =?us-ascii?Q?pGAKXSRy27I//xWpRp6ff9yvCzbqCc38FeqLvYb/rdAdDodjdLo8HI/qT51F?=
 =?us-ascii?Q?9jr1ukj7Z9diRPduBdGL3AdTK0D9ym73JIQGGKugQp27waycOsq+dQlTYFVq?=
 =?us-ascii?Q?vYPKesODwn8OGDGyCcIPlXI4AkvzIwFfvFSLAQ2SSO5jMpU5yFQ6Jy77TJ6R?=
 =?us-ascii?Q?OUnfosLC8Icdn97OUJKkwpqJwSutm6MeJ7j58UvcDfBOym4s5N1oDxfFk1vI?=
 =?us-ascii?Q?LJR0gKos9WdVrZqf417EMiB2UM7aYgoJCsFApCe32up52iwxIZ/VqDtVCLs8?=
 =?us-ascii?Q?DNDeGXnDV2vNnOOprtsajpxW8IMBv19xPo+jfVqEd0InNiwMsgi5xUJ3QsiP?=
 =?us-ascii?Q?j8QuSw5AcsEWSlJ39vYUTrpw1X+TZ61qn+/srcDFXWIAWyto3mpHFKxNO4o5?=
 =?us-ascii?Q?bLrzzyCmzkE/wukFWJYvWCd0r13fd7HEMu7b8VBOjlmsbjBIrP4cPmokKgl6?=
 =?us-ascii?Q?a1xGDX++kTRu7DbSobWEloTeCncnbW9ixri7zviy9K3M5j5izQU2zRq9w7GN?=
 =?us-ascii?Q?l6yJ2oRFxmRgSYh6mlutbjT4J84RNK9NcpOmyvSU1YUCgnTlXB8XHc3QVGf0?=
 =?us-ascii?Q?8iflY12HksqmJmhhJQcxoFfvaVDrYFhhM4q5C16xMgvU8CHbAaqYc+fGVob+?=
 =?us-ascii?Q?1vVrAMJiik55wdOfPs6jdzsN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e3af91-2933-49ed-4786-08d91e45cce8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:52:19.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEGql0/Nulvuz3Z4KjHxW/bBADjyB0Tgq5/QR3Xif08bwrCIVC86LOZsIh4VsHn4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:13PM -0700, Dave Jiang wrote:
> +static int idxd_mdev_drv_probe(struct device *dev)
> +{
> +	struct idxd_wq *wq = confdev_to_wq(dev);
> +	struct idxd_device *idxd = wq->idxd;

Something has gone wrong that the probe function for a
idxd_device_driver has this generic signature..

Jason
