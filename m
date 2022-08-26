Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE245A1D9D
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 02:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244611AbiHZAIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 20:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244161AbiHZAIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 20:08:44 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22530C88BE;
        Thu, 25 Aug 2022 17:08:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku0Qia1O7KMEPDnjhTV6JHO0WeYr9MDwWxceYdLqGq497jCGMgs+CzRALn+hPbMDrR9H8FazjC63Rgk+8LtWlZlGg05SaoSNUPH4R+71F9jQDq+7D0q/O3jLQ5ICEP7/YEItwmT6kyWPZAepCVnNt9G7wtI6+7GPuF3RiHwHwKvTjOmZ5oT4v7sVOv1M3mgn0VmPD25thenY9xFYG/IbkvLqRIcrdApb7/JAWhDHUSNB7mp8igZdZ4EYQRXbSwzwt5ebf1jO/aeOGDKwc1d3cHKcXjjsj89hgkFFJG4HbqJgsmflnVjIqr92vyY+y3JrSb0++wrIGLJJJSULf+hYkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQgwSDnbotnPTmknADKeY+EkkBgHv4es45bKT6i4JC0=;
 b=IoOPOInsOqlkeQ9qomWd+mfisT/mJ99LEFcAa7uxs7vYAM9ymLxIRj+9lge4vY/a3qOnFYVUTFtOaoZgfBUsq589iN0l7HMMVpBZGRTzbXHp8+Z7Kf0cDZxvNHJ2cS7mycZNNkOZrkr7xT4VB85AkVhFHuqb872WaSFobzIklxPJsK8hR1hcAfwv6SPP7vrvhlhhVqQTpc9IXP0MiiHHLLoi1PpnQ18RU8IWnsTL+gjCVeOAzwL8r3EolOruMWVTH5NsP1m+6mLfcPBzZqsCg9pacMzGhS+HvrWPQIjHn3hFpxiFiTn0+YHpEkze1kkMHzu6VPH+BKfxmuMqRa1vag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQgwSDnbotnPTmknADKeY+EkkBgHv4es45bKT6i4JC0=;
 b=GSRRZTlB5doUoWpYmO77N9ZN/ZS9BukHmLdphR4MQr/6tupXxRAG5xM4krxr7NlYq5oIRzadrxOq0UWXP97/6gkpP0wEYMLGKUl8EYuFhqCKU4j4Ko13TOHt+oPONhFrA9Ib5AC4JYDsMWxaR7TESLa+4tw+i39OPIuo5Ku8fm8QM2hwD+d723KiUiZERdkpm6LXf6zjRbz27njgXd/h4Pe3nLBKHxSq/8NiblxorXKp+REYXFh3gqe+aJDe4hOLr8aCypH2yF28rLUXZWFtk4f4aaCeG6HYOx6M91FxfWvuNzJi58kw9tJVONbCBUI7RuJvbZ1/lIe3vwyf2cEJkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5502.namprd12.prod.outlook.com (2603:10b6:a03:300::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 00:08:20 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 00:08:20 +0000
Date:   Thu, 25 Aug 2022 21:08:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
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
Message-ID: <YwgO8oCNn/QFM76V@nvidia.com>
References: <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-3-nipun.gupta@amd.com>
 <Yv0KHROjESUI59Pd@kroah.com>
 <DM6PR12MB3082D966CFC0FA1C2148D8FAE8719@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwOEv6107RfU5p+H@kroah.com>
 <DM6PR12MB3082B4BDD39632264E7532B8E8739@DM6PR12MB3082.namprd12.prod.outlook.com>
 <YwYVhJCSAuYcgj1/@kroah.com>
 <20220824233122.GA4068@nvidia.com>
 <CAGETcx846Pomh_DUToncbaOivHMhHrdt-MTVYqkfLUKvM8b=6w@mail.gmail.com>
 <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6ca5a5a-8424-c953-6f76-c9212db88485@arm.com>
X-ClientProxiedBy: BL1P222CA0007.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0ac167-a2b5-4543-6aa6-08da86f7153c
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HTzkhWFVJH544bScjA36U/GljkChlTMSDMydsE1gGw7awYiRws3es1dul0nYN2402XLoFp4E/mQFNJjCSsbxQ9Layv3ZlEVe+Xss6D/WmRnq2V4IGIdD78mndkPayPo6Sq8Jkt6TYkV6BLEoLIGxNQZ6Uq996G9hgJ+dedQL+/VRz8klHYEJp2F9Ep8SLUsAB8wFtpfimEaYD4bBdLtZeX7LXaHmck8zH/JueqsWKA7wnsdqDxVtCMm5/wQrMVSyFFClj0LeKApj0qzVsbXcN0zmf/nGiDWxiqJJUToN+4+BvITcFLj4dXpY79TSkr9DjbP2kRBTOyw+KJzgvWCIiMyb0KDU8lRK44flI9fQMrXovGGRV4UveJphXhXbVCnRCcMg9xadNYAzQeOhQ9CUv1WEXHCU9I5/QRzZC8hy+wfVSeJE2IxYoCDWstjG2YISwTg5dnBmg6zLpdk1V21EFHOgsQbWO4eV8ekjxObCFrONBTp8UAEqnu7CZG7i8V1DU0bvA+U2fMhyZCWEHEnU7F0dO1Wq/uvMhXDKyEa4HtdIuY1GupKFk7lNyNIH9NKUsO6nCh1M3sjOvn6kYaKLg6sHSuXzo4ZebJueRp6EGbrJuFAcXVyGQoEZz7iFQCrIgFGdnv0oLmoa42XzcklhErR7/MedBt9TPgMHoRxgSvkB2lrSKUoOMvr3O8IXHmbUKCnHUMy+tLwlwdUyoJSO5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(186003)(6506007)(2906002)(7416002)(8936002)(478600001)(5660300002)(2616005)(41300700001)(86362001)(66556008)(8676002)(26005)(316002)(66946007)(36756003)(6916009)(4326008)(66476007)(6512007)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AgIYYZXYCHNfqG/vSnXbeEGF4QpGpojcdrqMXth5eBCYVLiRJ1QAASSN+o8/?=
 =?us-ascii?Q?4TQo/5BPmxg/0m7kCV446okLuujFvVhK4GKo0jNJa/+k3jbhZFh6F49G3cEa?=
 =?us-ascii?Q?L70zMhESyNt5nw/3mtf14ikj11XNKp9kPtXp17vls11lv6u/P8dy3F1VCaKP?=
 =?us-ascii?Q?PKMgpZm38fhOpG8aRMpudOBOkQFGIInJc6VxHUjLGxbflljpO3GoXiBLKtqz?=
 =?us-ascii?Q?ofGCCgXBrX8hZ7UMVWkohMSvjhEQuxMe+eLVv+aLj6J3voT/UValsyRn+ezY?=
 =?us-ascii?Q?vpI+CKhTK8TCeAQZ49rt3LQowMahE7PtCvvreivTfNJw7iG13EWndpratTRK?=
 =?us-ascii?Q?oO9tzlgCezaZRrzQBtKXSfYvW/hW8GJfWCdVBDlIyTpfrpnmXocA4Y7d4Aiy?=
 =?us-ascii?Q?xBJ1cclRGNPJsJcTU88thhsLycmyzHvrEl+QDNKYefcTViuuGVS2TgrGwS4F?=
 =?us-ascii?Q?8OmcoiXWaRvt64zfil3jXpnew57p3BLZ5U9rf35lew7nn4+/HaPKWcy5o62N?=
 =?us-ascii?Q?Ppmx7WORgMKxeL5ybyoArOmo9d2Y5f78jJJnT00yJb6BPNSLxadIgOYUN5DN?=
 =?us-ascii?Q?WveRQj6qo3VxORayzi26qIaPZdr6xTp5TEYhLCF/8iE9niv2oXWKfOZ79KTS?=
 =?us-ascii?Q?y7PwTlocwepgO7LPIsm9lrFg+1IZ1HLFHykZVbtaOkoeJDE9Wz8sU6dxMHTS?=
 =?us-ascii?Q?FRtQR1ZzEeM1Y8Azqm3nYnMw3t+Z9aA/tbcyTmE/O9AvGBzM6aWUdiKDdkJ2?=
 =?us-ascii?Q?uE5hjsF4lm0MZFiL0VqCofnx3duLo7L3gzfQ9m9+N6Q/dRTY6wpGQPCRSAc/?=
 =?us-ascii?Q?jZMcOXASh7cjBy2omswQ6hgli4q8nX4yFGfhQa7iFscB472+BRvIquyRzGNj?=
 =?us-ascii?Q?UneM1awhVkGwzUZAMEC0v+HXybcJbR3CzngDsOSr3853mJSgWjOFZoPM7D/y?=
 =?us-ascii?Q?ffqvicaX94ByKwOV3M+WYIw/ZwCtOZClYL9am8+JnTWVT/slrrdzK3Nv4CpT?=
 =?us-ascii?Q?xCdsCbN6+k0/hT7WqmOIp09gNyfTt8xx00f1T+J7nlgbLTl7QivqxXfRo1Gu?=
 =?us-ascii?Q?5O8A8CsjQHIBvnRvHNNmDVa5z/EwyhM02Kh5Y3NEdA5X7yBsT2vgPVrnWoEP?=
 =?us-ascii?Q?xzatx62L9X2RIhNe6AAYNXyAuUFV34WtW0Q/nXh22FRJa4AmknOTu0vdcaKj?=
 =?us-ascii?Q?j2w7PLnYtsurWniwwlCZWYv07IASxRhPV/RiHX4FQTmorv6i0EnhX6e33TpF?=
 =?us-ascii?Q?IUxhC15ZrB7SSfKhtUfbtk6oM1+1asrMuvpKwf+Yt6G5I0tgGIsXu1M/rzAE?=
 =?us-ascii?Q?lBGps2zfLMOUnykV7QhQqePYsU50BGoOI9Q4mKm1e++yYUflJ2tAbR8Et/HZ?=
 =?us-ascii?Q?4/sl82gnaRo/8pZaIYlLgnClj1U42IJCjKGaD/6CDxiofdTIi2KzV4xghWyI?=
 =?us-ascii?Q?R5QYZPwA/x7ngevG28djRWK8DX5EJjKUvSl1V12+ZXcpMH3IcJzMg72GW5IY?=
 =?us-ascii?Q?zmsjq1UlGtbnYB+YBFoDqcfl7frXH6QD0PsM4m6EQatdZPy4aFD6mxaQ5I7I?=
 =?us-ascii?Q?oGLiCtLcvzcQXWyQJi8BKfVOB6HX9oSboDEn7TDy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0ac167-a2b5-4543-6aa6-08da86f7153c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 00:08:20.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbwfFVF9m5oLQcesN4qSzg9l0rlOqRCedGAFnPYrOkdW7RyPVr5aD+vbi/ygBUTd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5502
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

On Thu, Aug 25, 2022 at 08:57:49PM +0100, Robin Murphy wrote:

> To my mind, it would definitely help to understand if this is a *real*
> discoverable bus in hardware, i.e. does one have to configure one's device
> with some sort of CDX wrapper at FPGA synthesis time, that then physically
> communicates with some sort of CDX controller to identify itself once
> loaded; or is it "discoverable" in the sense that there's some firmware on
> an MCU controlling what gets loaded into the FPGA, and software can query
> that and get back whatever precompiled DTB fragment came bundled with the
> bitstream, i.e. it's really more like fpga-mgr in a fancy hat?

So much of the IP that you might want to put in a FPGA needs DT, I
don't thing a simplistic AMBA like discoverable thing would be that
interesting.

Think about things like FPGA GPIOs being configured as SPI/I2C, then
describing the board config of SPI/I2C busses, setting up PCI bridges,
flash storage controllers and all sorts of other typically embedded
stuff that really relies on DT these days.

It would be nice if Xilinx could explain more about what environment
this is targetting. Is it Zynq-like stuff?

Jason
