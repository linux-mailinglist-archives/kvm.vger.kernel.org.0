Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAE6FE545
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 22:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbjEJUjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjEJUjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 16:39:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4675FE7;
        Wed, 10 May 2023 13:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpUr6FxLFxkNjfE34rQW80RaZMXqHWFZUvM0cwhkHyak0nVnyQTG3PyJV5OLeJnBNhzfnAZtnWZ+ghnhHheiqA5YYSARc/9UmMQ2K8Tq2VjUKADhxhE0CefMxcwQOVmJ/WDAtKkfTffS6pqjlL4ZMd2JLCF9O5RycftbiaTVWuuON9DtDSaZ7iATeFtmcg/6nAukMQuebCLRQfvUyjZ4V7a/cuxR19+gP+BCa6ZyDR7EKEdRALrQ11+3oEVklAeVbfgHp/5L5YHQ/lDrKW8/kNH/xgg4NHT0SGU0w9Imi6kMS2Ey28C7LkSH4pvmZugFIRCdRuTTmdl9zcDeuKll5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO18wdob9o5FWDIdL6PN6i3D2KtD8/yY9qEr+5x7l0I=;
 b=oTAMrF0QPH6/VnUbs4vxSTypXByho626Vf0CqKtdCEuwguZNSSLwLOfH2UQDHv3Tb1fUIETOOWmYgWqvD233+VDzwcB38e1bnMHpeYVyoPerLvaJDBRWeXcPeaBJqMDqjIZCrcJEUyPoUBsDXRhjfKOZkVLPttJaxGOcK+e4W1yUNEWtKBUhsGBaDLP/gBhjxFe/hmbHYhWAP7PLidj68iNrU2RlZsKfMxl1Af8uOCogbsHJf4YlBcUWT6nO8cPsYANKXCe/vEO6TOkEVWd5MsvkXyFPtKPM86LXVV3EKxqx1zibat1AQ8nbdHcL75SDl5Tb5CIqFe5vqTWe0ICRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO18wdob9o5FWDIdL6PN6i3D2KtD8/yY9qEr+5x7l0I=;
 b=a1BRNnmMawsnY8e+RjLMxo9y42WqU2By+m1yC9zJdkONFpMHUVK4DZ3iYpO/PMrcMpmEHkreREORUyC7GgXaZ1XmdlTPHqIclpnbHrwwKE8H8STknWcjHX+PZRGo7Kq84SZV3BdH8RvxB4VWbyv0+jotAhrkcIxdbF/8q50tY6oAvR+omjBRbXKI5lcSUg/sUo2qhbuuS9AX2/3DFuqS7gEkBhDaxDayT/FTW8UH9ox8NfU5fZ2gMcbK/+i1lF0M32tw7yanFLCNIvCXgE9rGuFOo88zU/L+AXTZtxkQGA/yEf/5ylidrqpE6gsMXQ63uH+B89zWy5qZbJpH9saygQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5947.namprd12.prod.outlook.com (2603:10b6:208:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 20:39:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 20:39:20 +0000
Date:   Wed, 10 May 2023 17:39:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZFwA9vAJAaoUi4xE@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrThMhUnsYOE3WP@nvidia.com>
 <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230509183111.6a4a7f39.alex.williamson@redhat.com>
 <ZFrsYZPRpHqVyjcZ@nvidia.com>
 <BN9PR11MB52765638CD15BBDC762100EB8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765638CD15BBDC762100EB8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW4PR03CA0222.namprd03.prod.outlook.com
 (2603:10b6:303:b9::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5947:EE_
X-MS-Office365-Filtering-Correlation-Id: bd140a69-8b7b-4729-33ac-08db5196a1a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjdXHwxRTQnAec/KrfBuv07egssDo72SsvRGLgH6wuzX57CX5h256fG9Cm9pzFtkY5hRiHIv/jd28bx0+VGkK739rjOwF+G99dy9dPZlF+PZEmB/rw8seBSmDODV0ERmyR1cuwNZBwcfuO935RvDdRil9eeidJBGFPKmjApiKUS4kUXpWpNF8gUkKvHBM1KjTOWlEyOEmP50tbk5Cs5wQ8ZHHlLismj2p1oQ1XU7KHLHzq9oF9NBTCXVYOG+ivK5NzfQPvD2/lo4gySVacbMjvt/5ZdJnfxuT3HZDJj/53CUoEAfSQUm2DzkkqM6/komFyrivvjPs6N9WaP6G8bMPT4zwNIheXlCDNmnQdNea/gQZfKtPuWS1oAsgljG/M4frnaM3z6xl9BIDHqBp1mLyh1pebwuutNY9BbDV3PbIo7qsOd71eHyAt8USTT684bppB+MtstfRnzEsuhuW6465kSH5Pkm0OveSj80QhbX/wDWcNgvlteyvng6HOi7+pwyzygkynMcWssL6mWtr1kqMbusykrAN15ntHSBdzRTVDaBUvfA+Vi3o3LOeV7tqaD3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(6486002)(54906003)(478600001)(186003)(8676002)(66556008)(6916009)(41300700001)(6512007)(26005)(66946007)(316002)(66476007)(2616005)(2906002)(4744005)(86362001)(3480700007)(8936002)(36756003)(5660300002)(6506007)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5SyZAJdFYwaY2IxK55gqvNGuZAx401AZrLyYyx5wRm2TrICaKpM8CbF8laTk?=
 =?us-ascii?Q?ths7Pp5yappV1eqoXu2M8oZ7EmywQUYnjHCwOvgHy2xzMPv8N0zEP7GlywvX?=
 =?us-ascii?Q?KZ4eN1pAftR25pEUZAjppwtD4ZHfaPvI7WJYlXcMnSUW1OCpR/AX+EcxK8dA?=
 =?us-ascii?Q?w/fA3VBW3f4phkNxWaXGEffnAMUN+6iPpNQtnDP5SEd0xecuRqArty2c9sLG?=
 =?us-ascii?Q?eEfEP71ECa0ioBmQmQwUkJaF5U/MAgtHMt2ToSPIyYK0+dRzgpHTYWzEMvKz?=
 =?us-ascii?Q?UScIc2OPz8sGwRfnrgutydgv3MVghBW9Du3o8GyvN5PDz2c61/J5tyYAwhnp?=
 =?us-ascii?Q?CUqE4ZjxmSjUTVL0XN7P8dqo0EdEybqz1obUJBXGx/m/7SJZMAPnsaVuRpex?=
 =?us-ascii?Q?x9jCO/KmdK/iEWZjg40VIY5pLAikga9DECPJ6oKl3LhgmGGaZyS8dlkSReua?=
 =?us-ascii?Q?Nbiz0g7eNo4TaaSGFCuifn6DEVSblZVIQp3M8g4YT+zSG6p95z6P/WQ6ZdIR?=
 =?us-ascii?Q?K0SlCD0vKd2FVXQl77MqegIatJVtV+8Q1xB3fsjbh7RWAitGZkk7vRsgNY7e?=
 =?us-ascii?Q?NZcDYOHYpE3XsIHIcb6l0+h4vp8aDNVCuOpb2Ac4X5ws+IF9FgkANtDbBiP+?=
 =?us-ascii?Q?JdUMHyuXoyrcFScqKpFZnR1DHx79YoR0FbbzH8fcoEPGVsJJqPB6KlzGp0RN?=
 =?us-ascii?Q?gqhx5hW8Gmv8Nf6KaJ9eFvPzpXn4eqIncZQa8o3E5Pee0yunB0vk1K/bvAhj?=
 =?us-ascii?Q?YfjMe4uzu0KI5e9srGCEoo57A7CpFth5UjZr3q6AzuDu3OSZosKOceWqpEAa?=
 =?us-ascii?Q?XMC3N3kk39MXuc84M7G9PK2ffSjGd89p7C0BvM+kephnE7gGGEwrcHAbX0hA?=
 =?us-ascii?Q?AyHpslme36XMNImcbyOZV/7vpt2rvfE52k5maRJ21CEsR7wbrrYeX+QdmFG2?=
 =?us-ascii?Q?pUpthPKRUonT0yNdHoU3fNoVxIFDDvifmCM3IGzuqL0V3iBTMaVfEarTn949?=
 =?us-ascii?Q?MF3LIHvHk621x1lqzLSnbRyWFSM2x8pE8krRoMRTQH/kgAKhX76PDqRPWaCq?=
 =?us-ascii?Q?LLMGlmDrgWOMipXgFsYE26qLODYUVetlDRcQ8DQBy57UU80ks1k/r9vXwLrD?=
 =?us-ascii?Q?pARW0BfYFt4yY9hk8lunx7IaQ0SMb455GmHhAW0+zKV3JDK7RoqDXvvipoiP?=
 =?us-ascii?Q?kTULXy955aaM8+NbAOjsbqts0Yh+JZsUKcdSdh7NtkbvsolrLPWq3hUgTgb+?=
 =?us-ascii?Q?x/dTr8ijp/yqwOtBhs7t9soAEo58IPL20e5lipvDViNy4hP/u2EO6aIpBhNW?=
 =?us-ascii?Q?DZkVRqL6aDy0fjmCIA6iV+rzJvPjoibjmtItpuboYfkvjU3sC+0+8y6iyvC7?=
 =?us-ascii?Q?xZdvh0HFqbFUZVsFXV4CF9o49w5Jtt1chRKgQS2ESRK65h6S/uMmKxFbrPz/?=
 =?us-ascii?Q?G0DlCe++JtXOp3IjgMmRvc9u821ESzaYLVRwkBuALuwMBuzhYBK3Qj2lunVU?=
 =?us-ascii?Q?yIaKokUaVOej1MR4Zg2C5261mwQJ2DLVJXKx3L+r04YO/mm9hJZEDnNdK0Yi?=
 =?us-ascii?Q?61FKO1tAnscBmH3sx6c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd140a69-8b7b-4729-33ac-08db5196a1a5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:39:20.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtA6CQ+4YxxOefxZ0ql5z14pYCEOs03WNp5UA4ilDXXsPNjikI/RrG7eibYJqGcR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5947
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

On Wed, May 10, 2023 at 02:16:05AM +0000, Tian, Kevin wrote:

> We don't have a control knob to hide/unhide a specific PCI cap
> today. It's hardcoded with proper virtualization policy in vfio-pci.
> 
> Following current convention once vfio-pci adds the support for the
> PASID cap it will be exposed if present (for VF it's the presence in PF).

We probably shouldn't do this - the PASID cap should only exist if the
VMM is actualy able to handle PASID throughout, and currently no VMM
does this.

So we can't just have the kernel unconditionally add the cap. There
needs to be a negotiation with the VMM

Jason
