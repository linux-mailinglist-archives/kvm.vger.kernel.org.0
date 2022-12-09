Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551A6483ED
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 15:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiLIOjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 09:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiLIOip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 09:38:45 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D2B3A2E0;
        Fri,  9 Dec 2022 06:38:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIQdJz8zOXuFkd0risRRqCfl9REdUeohs4yw/c6nJAa4rLYhMwsnKF/jIZmhEQF0hsVEvw9NFT4wv/gUM8dFPKI3hrtgMxJu7NcSDdYnLNm4tuhlo6Ot2/OxhfmWRcITmwvK67tI7gxWH0ZMAHxHaTlIR/2eIYzNLmVaxm2ggT/9VfXbVHJfDXgOzSkAahL1do8/2ci6DgbhoSjdY9bQ7Lq63CYvBWr6JNnCJmxovfq7xNmgFSSzyBM20c5YsMJ79JKilGQZH4wMSOcHhhjZZekP0ZMB0wKgiBKQ34fT39KMa7qhMfZSYshSIxV9yUMiTonwOxZkP9kU2ezOBy9pFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVzm1ku8LmbzD3EMIVo0YYSyCNiVaq80kH+fXN40ax4=;
 b=T1j/asIEPP8GwxdeDQTQc4tAfDpzBwIyJst5x5LPJDRkPmeuwSsoNiMdsL5Ds4lyGdzxqsmtHO18AfJn+fuVJutzbJTLjo5aDmbXtXgyOZ83SV0ZUNcGE0PoVXHpJHiIhpSghDi0CK+EwiXoMoy25rOojk2/cgBq0VuFLZpn2dUhbFEIccxTKFRKUA6H7ChVUfnFx286SxAiRF7ZmhDVAb0y3YrnqeBx/ltdKEWzuDR/21SrNJ0dNPotyLWKYPHx+iMjjABrizpQ4LcUTc9ErBGNnkSuUgb46ECzpjNmjmz/2wVFZ72i5XY8avNxnBDt1725TdIv9yKR/K/6Xq16BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVzm1ku8LmbzD3EMIVo0YYSyCNiVaq80kH+fXN40ax4=;
 b=VbP7M3T+pEK+aIguJel/23s8iFYOcM36qRuZGPQ2chZxVpTAMrVUMCr/zOByEQSuwYXadFocoPpFpzoXuSQIZKiJ8OD8tIPYB+SIFZCVMVXS4cgzp/eV0Ljc0A65enA3MT6z3ijyhawJBcq1K3E0caAYIf0bcFcMwYApzlJeWHoCWXkIuOVUuEopuXpXxP0fAFYxlXwOfjJY4xC38bmEsBfXc/8kH00WqhPahT07hhov2l5HMqgRiCwf1YD5neZYvu+AOT7sDtdaZunaaECItnkmbHZFpH66ce9bJFllTYfxW40wKCVNqhvv6Ic6v6frovoaY3KVrHZsr/idBsIAuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 14:38:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 14:38:30 +0000
Date:   Fri, 9 Dec 2022 10:38:29 -0400
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
Subject: Re: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Message-ID: <Y5NIZTKqtlzVeNMJ@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276B4F1DE4D31CAF8ADAC408C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B4F1DE4D31CAF8ADAC408C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:208:23b::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 18160298-bf5c-4c9c-1d9d-08dad9f30a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jT5DNSgodVNkE1pH3z2WfKrn5cEqc4HCy6pYCNb1EBbvSb3zCqqXTGPzPSsDzJewt/wP3vo2cFyQa6/PPmWPwxIiUU9DuFP4wrkyVMeer6kujnHCxa4Suap7tC2ZfKAHvo5v8OrDhMLqKBD9hF++e9FGO443K97CUTHHHKobL16QNALvNfQbnvhKgALVxeEYVmH22WF3PncevjRdE4WWGRS2ZHfhvZAYu+7dpfjAWUYrsxDEttbeZ2aPAhDveJ99IoaciYpE/m7MagZMI+9QoUn29FO1BXoLkuPwmK+qNX3LxLKV1AmdLi49Iu1Pej5v/3u6qcF0FGXswv/cxHD4KB7x5LhhKc/adOJHkVIa1uruhHCP0SL08r1BAk7aJIO2u6iQd17qQ2vG/7/o185cIF/lWwKIsVm5ZvclHILvxnhJQG6dyvtgpNuSRgmfYFK1ZvjQwJVPpIJaVt2DJr99ikzGCfV7HQ3QzkNeBqetgyXyRq9b8iFdN1ujS/IZmqXkQZehPGIsdXUGMk9YUT0Qz9zmIWpTiPa6iFuZGe49FPxEERHyEOgSV/ZMcbOiquB+pJMjfoGoFlj+icaiN9HckoKp14wsV/Bo50PZKuxaQNOyQEjTmdccNwilXxC/WpOjlnAulOW14k3mLNd90OFoOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199015)(6916009)(54906003)(316002)(38100700002)(26005)(36756003)(478600001)(6486002)(83380400001)(186003)(41300700001)(6512007)(2906002)(2616005)(4744005)(66476007)(66556008)(4326008)(8676002)(66946007)(7416002)(5660300002)(8936002)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M2yWFuvlbu4HV5Eyx93hnlwDnFj8nQHG0l3AJrnfEv1K2uby8r96Pm9PitKl?=
 =?us-ascii?Q?pp2tF9HzX7X7kJkPidbDOQLDEjybDpCZLHyYQKx3B1ZBB7UjsDnd4amxivvg?=
 =?us-ascii?Q?z1NlYxbmGM71BPANKgKyYVxhnGv7JgqhOneTsmh/4jOB9WuW7VrSCgOtteer?=
 =?us-ascii?Q?9nHyT45viq4vpdYI0AcdIILMCfX0+d+NZYfzv2Fg4y9u/ioz6ZWheZgas4e0?=
 =?us-ascii?Q?Xbb+tTLCIQOWRMIMNz+ekjmbrzZVfnPzHixOYguIr1ax5O5PzmV/KKvgLEnt?=
 =?us-ascii?Q?OOtNEnH1k+/PxSg0fLWGHOQAXFo1XVSLrt3JmCwnkn3RZy3OllRWT4Upv+JK?=
 =?us-ascii?Q?6uwV2dWzC6ah03GloFStEBSTxLTjqhKz15RSyfd8saVZrNSGEwbRSPXcRwM/?=
 =?us-ascii?Q?OYfmSYQISfCVajYk65GjJAOkITjbXMxFdHfe74mzuKUw54lk0B+EP0Qyx6uU?=
 =?us-ascii?Q?3zXwPyRpaR88PvjhqgegofjIx359FXRRR9Vi4YgAGDHrlIOQ2XtDKyaEveLb?=
 =?us-ascii?Q?GVZ2/LVZCFRMB0w87MmEqPGcS9ukETaMCyvQLa8waL3fHuv7FZNhnZpxVvv3?=
 =?us-ascii?Q?C+XUh2Cq+1qOS9Kv44uFimF2cjGNsJ1C0iRbHWzMRa/FaRR2wtCwcmjNmvHh?=
 =?us-ascii?Q?HrhkxSHfmq8cVlxC9FxfS/dJTNcYObnXcnUYIVueq2nPDlETshGGk20CWaOV?=
 =?us-ascii?Q?UsWcHNBrm2klqUh3wktdlXUeVYqUrvWOMTsvDdShrZQpyScBh0jlumBnruJn?=
 =?us-ascii?Q?Ggx014n9rFtCnbLzU6S2S0VIF9NQnENfLr0wr1TwTcjr3IPwXSjlSwCg+1IQ?=
 =?us-ascii?Q?h+B7Ufqx+aXVlj/imxQRjzW6heuUVuLxo9YaiumaK8b8Hh25eSQcaCf9XNEY?=
 =?us-ascii?Q?SY3hYwoqA0Zph6sfDPg3vvpYebNCg3F/QLliqpaCEAJpChHJPEat2vbodAJb?=
 =?us-ascii?Q?5oOEWzi2vl0yzLrVHC5DSx7D4grL05fHywIVxItFrouspdZKfnBtOXGoJqhs?=
 =?us-ascii?Q?O+T0TetYuMIluaFLrxA2dPdVXzKGFFZ9gqoWh4nvp1+s+aaltxO8FA2KZm8u?=
 =?us-ascii?Q?bLNCzJW+3ZB7Zf/bG0K7poOY64V/Kyj8nr4deTSFSQY/tKqgg/bv6U5VpkhG?=
 =?us-ascii?Q?rz4NsuFGKzO4KZfr9azI20MetFxAVHhHbbJaTl7kcsxdoeQtehKyeM4+24UJ?=
 =?us-ascii?Q?vps/+jYI5CkD8iiPQAeq/AetkrzqePkv7d8RBd1cdEeRoFJalr/Xhb/w26cU?=
 =?us-ascii?Q?75OS1AXhnlLWGgKJ8IRAFxwbppkYtjuaBabBjTxA32dy6b8uWZMIEktVhO42?=
 =?us-ascii?Q?KGrqgNvvICYt9iFpJWBdH3F7YkyDosPlRa5VoSNvtBMts7Hf6gb268Apa7q/?=
 =?us-ascii?Q?3vOg5PQUePJF2p07CzPGzGhPbju7sRXlKq0Xkh1l0vKhsFcn1ICZfmVZjmjc?=
 =?us-ascii?Q?Wmy5c7RY33ewA5TaemwjBA0bAsnHXFP1rCkOkjfwD+6/r2tcmzJpmvbhtkeE?=
 =?us-ascii?Q?hTP5AeKlUhOccF/VfgsptMyap0blEDLO+n6SQvhV+BFCZrF9Jw7yzSHEHaGR?=
 =?us-ascii?Q?NbtbKU0sIGNLMr5VTGA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18160298-bf5c-4c9c-1d9d-08dad9f30a50
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 14:38:30.2148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPlhn4G0ovdXSkN/D6wZVfOfly1hXCnONciTKQkDTPvvua5Rx0gYmYvBDWO++qzQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 05:54:46AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, December 9, 2022 4:26 AM
> > 
> > In real HW "secure MSI" is implemented in a few different ways:
> > 
> >  - x86 uses "interrupt remapping" which is a block that sits between
> >    the device and APIC, that can "remap" the MSI MemWr using per-RID
> >    tables. Part of the remapping is discarding, the per-RID tables
> >    will not contain vectors that have not been enabled for the device.
> > 
> 
> per-RID tables is true for AMD.
> 
> However for Intel VT-d it's per-IOMMU remapping table.

Sorry, what exactly does that mean?

Doesn't the HW inspect the RID to determine what to do with the MSI?

Jason
