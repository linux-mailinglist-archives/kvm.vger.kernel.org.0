Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01F45A04AC
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 01:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiHXXbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 19:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiHXXbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 19:31:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044E8287B;
        Wed, 24 Aug 2022 16:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYr0n1Oop31xRzsdG4jYQjPGNUK8QY0R0oZLazxgqw6YmQm/VnmTIJnObxCG+6dTDL91Nit0L/0sqoRCitQxKe9kuBIKdCzLMBMkQRJ8dBiFv97JpdMzPb5+nzf9ykif3kpsUc+qGaDxVRAS1ib4BJpRFNDvv2tzaF/u0JQbvAL0kyfEAsapftfRcDxmgcg3HakDuFQEKP42laP+Fvlvfixd5lWw07Vv0HnQGteV3okL1xlN3Eax9fRIS/FNCmj5Wa9nN29R69SVxBuT+iOgbBnCZeJCypteH9/KfLIoNC1OuuW4T9fm66dFVn+yPrQRCWYtxWyZEAxuWwY3kVk8LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ru1zbkITnIFzBDhFmI4CkX+uFFYRNYAaxggYHNxULGU=;
 b=lP2sWwMNBy/vL/djUG+qPdaEEgoBrct5nTLu3Py0RtkO1HSrw63OTWkUI/X7+wz9qXDBMyB7gFAqjGj8CiSMY0cMT0pQGryBXdxRkmuXPlEingegMOertSpEFlwj5zwk4Vamt41ac2tSGwXF80pxoRasEhcvVr5avF3PpzZDjRHebjXDiIosLcJBnx2I++qhYeo3oS86pChOReDCKQHp3MxcixHdutYnc6XHQ9O8Yte20QtDkZSPYieB/s+Z+h22qQyVEOPSMkX0EjJs6Yy17c+CbQnQtPbutO+WNq7QhFVRO6061YYZNGCkYFAYDkz+cp1QwEHmQlwEqS4pkZqx5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru1zbkITnIFzBDhFmI4CkX+uFFYRNYAaxggYHNxULGU=;
 b=YpWvN65fS7gFPD+Vslr9RkRSe9jEMAVBkWG4ctOevUAAU2PaGznEIMSBP+r48w+72vLGPY30uvQo8IONMogLEmJtWCUyPaY2ITfnOMcp6jaP48sRfRQ2GLTV8/J5HsKqGNDXYql0NNuVK45eoDdKfcq0SOfRQjMydHvkXKXsnmuw9i0WWiZG97mPHOQZn40H7kbhAWcIgZmFgTz1bspkGKpqkHdKfHIoB3gWmhj/QkF1qHI/+eYzcWQ4h4NK1F6gC9tL3PhNNs7qUIgEiEjqmYBzsJCb9hCgyK7QriBbNPBR3MLh7sDRk1Hgh1pXqHVDheEOq3evnIWA/uRUqI6hiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA1PR12MB7294.namprd12.prod.outlook.com (2603:10b6:806:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Wed, 24 Aug
 2022 23:31:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5546.025; Wed, 24 Aug 2022
 23:31:25 +0000
Date:   Wed, 24 Aug 2022 20:31:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Message-ID: <20220824233122.GA4068@nvidia.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwYVhJCSAuYcgj1/@kroah.com>
X-ClientProxiedBy: YQBPR0101CA0276.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbcc189b-f062-4324-2831-08da8628c2f1
X-MS-TrafficTypeDiagnostic: SA1PR12MB7294:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0dkRS4lF4wplvTW7mjhH8v2Do442aiA7cGPNSzMCbcfBQSOCbDlO8MVQfJvfGr7vICV15Q678fA7MsTOcb+7Gpow4c7QFv/8gMyTJGaea6JfIat97YTgBthdmGmP9vj1AD698e1CYbd8R6nW3nuKg4XPFCCbkFmxmGzVpwW0SJADu20FwFk8Kw4WzPlUGhCsXc5GXctlg4VFoVoT9zb/a1naJS1kimp7bDTpH0fr2dI47eBM6jQOKReIMO7wH35+Hi6R+J4j49/EPXc/1Fakh0rXnV1Mv1LW0C3fU65kh1LoDcHkpar2IXp/KT0uR94pE+FfZ6zTF+4La1iSEG9/6jXGZRyCCUeeXTWZQX9oV+4okcLLBWgyK+zlyCepPeK6dx2IOQ0kEK4cyqJzO7T7wpwh+v3wDB84GWufXbJgrDodeBOcsVfqWMMZq2Qoq9+CzPppLQZQhBRfL3BEEcE/GYsmcvzoEXqZLmI7kZaiEqv6PKq0K2qEjzMGyV6nq5CXEPyoPFt7E6g0IiXDca+mXBVycuH8KdG2darQzCn6cNAOMAkFprW9zogK6A+RcbnNoTtwUAD99R6AWA3HUBVKnB5CmXi0Eswpb1EgU0fkT55vg6bW+SHHA3f9LjyPhaXFiT8aKgfUQv9LWulrOnyWctI+/lmnuoFT7NfXJQvG/YmOJTpaujTmtGeuhSYcdDFpMBKzTamR1H266OzarYggA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(1076003)(2616005)(4326008)(66556008)(54906003)(316002)(8676002)(6916009)(36756003)(66946007)(186003)(66476007)(26005)(6506007)(2906002)(6512007)(8936002)(478600001)(41300700001)(5660300002)(33656002)(6486002)(38100700002)(6666004)(7416002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4T/k79OXxraoaFX2QSsP7iq66x9QzxN2fZi1KtZW3bu4NtnsiY5PTEc5uRKW?=
 =?us-ascii?Q?HNb1Smu2+x1vihxMPHPCyQ2y6ArTdj1WbdkWtFhcEkaGAAX8AluhPP9KxjXq?=
 =?us-ascii?Q?FQudaMJ0N+8laEeg/JesMkEHxQQk2R5EVKCCCJ1NViT0/oPwWIklWZ6e6Zy/?=
 =?us-ascii?Q?rWFR62HiLFd+c5M6bLfdDXD8xJi52PEg7Nob/pbA4H6bTqHhaYdzaq+zxK5F?=
 =?us-ascii?Q?9meBwoKf5k7oDZcbyPLXiE6ybt32lAAwiDSpz1L2gQGPBWhZj2Egu5Ih8QHR?=
 =?us-ascii?Q?vZrX0vSNX0KkRbuqE/OIozoI0opNvrNKiqNg3UbFk1i9HAmArvf3KYfapQaD?=
 =?us-ascii?Q?mssfcjh260KeiIcaQ9AIFr4hMNWEje3NlnS6xiW5QbNydfkYBlKbGC6p0iSJ?=
 =?us-ascii?Q?yR5LjopMR4ne918BP7pETqrADUqFmBKI5qovgJs3yezxEzHVZHzn9SD/M4pL?=
 =?us-ascii?Q?ZANNsqXXRxocgYwVptzGCzD9qUhK2saXejKRvAPcOlLPy7CedepzFRu6BPMJ?=
 =?us-ascii?Q?DVuzqBeQ1Mo7cg12rYsDwnjegjDPe8EifR4sj6DSs36nOhKjHiwM259/e6vJ?=
 =?us-ascii?Q?37fs6vWp/wmiCTj6IKbCGfLiBPEBuvsSUieLYS9KODEZnZPQRb/0YEkIIDzv?=
 =?us-ascii?Q?vZARenswenfi9xi0L7P8ijvEOmrqxdab2zE007i5IQEVbnAVF8BNl7xcdGQc?=
 =?us-ascii?Q?yWJUPEEmcq1bD2BCKlXv6M4JUg5PmWjsksvAJ7TCl4f1WBVcMaEJt/dMa/4o?=
 =?us-ascii?Q?I2RVyAFphdPdInjCgMRnPcP4qiBUYcsQkK4ZktgKz0VJn1gGBjJV7qHUX7wb?=
 =?us-ascii?Q?ynAd0UuJO6DE2lCU9p9olnV0shSDBBcRwcDv7uwPE3wzH2uotGp0enOGkS/9?=
 =?us-ascii?Q?IJAI8C12xVE7hGGSC0LDRfZHmT2KTEZSP7BPCcNkHvMSwh86Sh1vcJoERyrv?=
 =?us-ascii?Q?YT+21mbVliOIClJiL13U1f2qcjy+IDhdbxETOf1sFVoOYDWlD95X/iO2WyMQ?=
 =?us-ascii?Q?oMOyUyBW79xjYF8sgVVacnEmkymAzIMX0LMANgDCnx0x7ehEP5BX9unxfKaD?=
 =?us-ascii?Q?v4x2/3gFHoE/cQoek/6qBrkQ68FA0dWcwizlxZ5DI5xo75gdvY32cbBCLOtb?=
 =?us-ascii?Q?Vy41leXnmankL9DR6zeGIPwsd/yv4AA6YvMkyHibzdqgwtl4W/ma6y/IF5y0?=
 =?us-ascii?Q?p8bEhHzkmHRzZqknoDaJCIceGbEUctJka7aqKv9p2gmAc677Otwd7luwt9ji?=
 =?us-ascii?Q?KRHX+Q0l3OrbAKOxNuucvlIsl/MD0lRDjP6DxMaKSFl5h5Td1vt8EkuMur/K?=
 =?us-ascii?Q?5brZ4vXGH4zbJGaYbrkkVacQFvqTuoqq4WS/3o89gPsTOQEm4THJuTz4YHzn?=
 =?us-ascii?Q?1GIGrAwYWr6fpRm9DakkF4FDLlTmxXWRCMYvJMfCOagEvatE2bP+0GhPtOsZ?=
 =?us-ascii?Q?nhwpwVyJPR7sxvObaEAiH1vt/QywAQ/D4vWzCz8ebFtpL4D0oKyy3kOsr0xD?=
 =?us-ascii?Q?zKHOGv07VubgJdQkKd5m/nfFevkA2ulSlj5jNgNXwsWGa/deU3qs4o6uvu+L?=
 =?us-ascii?Q?aJ6ttfRt4qidUb7cP4NhLjFyJvs3SQZjkoRTW00p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcc189b-f062-4324-2831-08da8628c2f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 23:31:25.7504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDWZdbHUpNa/fK2bU5OXwaPjJ6HTWzOZfS7NyTsbxWfchi646f9XrcHrEXBuJZnL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7294
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

On Wed, Aug 24, 2022 at 02:11:48PM +0200, Greg KH wrote:
> > We can share the RFC in case you are interested in looking at code flow
> > using the of_dynamic approach.
> 
> Please no more abuse of the platform device.

Last time this came up there was some disagreement from the ARM folks,
they were not keen on having xx_drivers added all over the place to
support the same OF/DT devices just discovered in a different way. It is
why ACPI is mapped to platform_device even in some cases.

I think if you push them down this path they will get resistance to
get the needed additional xx_drivers into the needed places.

> If your device can be discovered by scanning a bus, it is not a platform
> device.

A DT fragment loaded during boot binds a driver using a
platform_driver, why should a DT fragment loaded post-boot bind using
an XX_driver and further why should the CDX way of getting the DT
raise to such importantance that it gets its own cdx_driver ?

In the end the driver does not care about how the DT was loaded.
None of these things are on a discoverable bus in any sense like PCI
or otherwise. They are devices described by a DT fragement and they
take all their parameters from that chunk of DT.

How the DT was loaded into the system is not a useful distinction that
raises the level of needing an entire new set of xx_driver structs all
over the tree, IMHO.

Jason
