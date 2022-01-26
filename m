Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16749CE8A
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242871AbiAZPdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:33:06 -0500
Received: from mail-bn7nam10on2069.outbound.protection.outlook.com ([40.107.92.69]:6529
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242866AbiAZPdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 10:33:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfyn0Q1cgtIpB/2/5PG2xrXqBnWBlUhzYR1LQwX6Yd4NFDoWNQHi8MQbzCfrK0zaIzX06gqIYe9rel88QXA2mqcZ9jTV6nq/PwX9Zx7JBJ03u3c/dpk7jH/w0A/yNJsNQ47Kg8BnrpF9/gKfVVFnmw4Yd6grUDmTsoGe6BP///XIKiAdYu5MMuppLgd9dUS24IaO8tbeG1W6AHPyrPCfrgwNHQg9kjNS3AlRNjtN5Zsk90y2dtpRpepFIXyXq2ElYjt8aI2wEuBBXVgFdZ+n5sqoMDLPvbdreibAtYi9PfXeUWbx4plZRm8ShhsNiUI5kPGvnzgVLQbFLYue4OuHhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vghmAfHS+CVRT5oIJ7vlIRfqc8QZ43E5ccH1Tv7f/Nw=;
 b=b9tYvD4H3M1676GYtQyn2ue2rmzFpD3JT1FMKOnlUGBdUpl9FXXzHiwAf3Fqxmb7G6pGZ/ofypcHkHY0TY9/72/6PSFFNsU3Js6DFjYz9B0rZyZg1G7/tvN+Z8sCxAT3PGHPWZIgphh/qSI88qtFmKUKpX9GFH5XsuMOD2xKCZmL+0nWwbf3I4kZhQd6KO0fihv+QkOwY6E6THMYSK4TCwMq/YUkaylDGCOYVdX6EzSUaX/d496Opdd9RAjdtd4XULjYtLEF2L/cFkI502dr6P0sXjcVqLVocizI337FeNH/ST60vSswPsdfTwA1iXTJsuMxnO1qo4w1cfYhLTBN1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vghmAfHS+CVRT5oIJ7vlIRfqc8QZ43E5ccH1Tv7f/Nw=;
 b=H44VONpyooUoeHwpXmlnHMynaQYZcms2jD3egPl7T1pPt0Y9hfC/IA7UAJLrW5xRO5EnY5D3D0HLbwevnABnv71Lc9GSG+oU0WS2CUdaa/qD1H5Vxj/dKyDJZKqTHCQkhkzyMwh/I7QJxkKBA7ZXOJi8cwqHE0G6VgofNzMSacWBMw7rK3imoiqX1I7KvMT8mPq//uF8Fmg8nlS/4nUIPXKdkf56bwGLU4QhddYkFh/APNfGZIZJbbj4uyW+4KDIcF2HgNa7Il0t0WnUitU5HTJSgfpYXSKPsdt090urqDfV8Y6PtSMpm5Z6O3yzhMoxCgvNdP5Vvu/JH+FWkdB5/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Wed, 26 Jan
 2022 15:33:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 15:33:02 +0000
Date:   Wed, 26 Jan 2022 11:33:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220126153301.GS84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126121447.GQ84788@nvidia.com>
X-ClientProxiedBy: MN2PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:208:e8::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74539ea3-83ef-4279-4dcc-08d9e0e123d2
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2490:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2490DB25D5AD17443491FD80C2209@DM5PR1201MB2490.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBVvtMldSnR1D8LpF6bVrl0+NXcuL8xCB60g/OLu200JCJEmpMOF1DxGP8+ePRBZ/Dg484YrhtVHXCfV0BbH4kr+2N/Uv78EvDGiEaEXqxtjP3T/bHUYqfeCmdLwi2bdGSuXePea3pqIR/ACSgcqw2LKORAfUz1nqBYq72QWkY7pMmk2IHY30Agky+i82iFaQ/WGG1PSWaijSjkkAjObXrDooO3a3QF5mqXt8yFIrtlW7OBQZxRH4ZmDfRXLcI5n3WNILGsro3fLNhZJ0y7lHpKwZm/FKln4za1JvxhbL2OrbFs1JzqMARu/EFolxQzvRsuGXG+NlPLq/sq1CWKCRdzW/vli+zv+LrRttQPqbJduEFyorMDuytxUskwUN46ukwCeG6LPYiDymFIICSup3EpqsG6uMHIFHyjO/8Abj4+JuI3998o4GH8OuItsfBGcgH/wbxdd5SxZA43jBnbBsB4TQBX2ptCtFmMRRCsHZn8F1+uqWYsspPgt70HKI/Dpq+Z6ER+r78gb+TMtKQwNBdylkkIB7Etim9XeXhCmv7CvNXOjm/cMUxiyjsELvDjNfjis2ViSsb6Yff+PBx7rOmQhi8dFDnnJYA+NIzMqEbTCYxyC98h2MpglmRwdZbrBHT4EJww4UTz8dRB33QPsXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(2906002)(66946007)(66556008)(186003)(6512007)(316002)(1076003)(54906003)(5660300002)(86362001)(26005)(6506007)(4326008)(107886003)(36756003)(83380400001)(8676002)(6486002)(8936002)(2616005)(33656002)(38100700002)(508600001)(15650500001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3n7EUFBhjsEh+5Go4svZxYLUmFp9alfy+rm0of9wcDZ2Vj7MypxhndJDSkDm?=
 =?us-ascii?Q?bYag5nw0uPOopGKZuzllIY2TFKOvQN3s+o2XKIJB8di9q3QFyJS11XiU7wod?=
 =?us-ascii?Q?30W3cRJ9lThgi7CdEuVeS7HaPIZTEFtoYi/QQeieRUk34vk9wD7GEC1WRPZh?=
 =?us-ascii?Q?cgwEQ5vHqkYWGmyVy5sv7QP6bOElDhx2toD/CDL1PBJq8XIrjI2sDcKG9rKF?=
 =?us-ascii?Q?HDf1w4p3IKAiiUrvNYga4YLCft4GG86EdHpnZM26MSyBRnppJfyZA5TCU4gZ?=
 =?us-ascii?Q?PJIpj27agG3vAgdPG+fUKUoq0MHBA1GoWgInaLuHoHpGcXvhXHzEQPIJvXJR?=
 =?us-ascii?Q?1VRDM3k/bQ0yQsFiizqSkXoTzX4dsXEStbLRgXvQdzNouy+5n6A/CewmFu+Y?=
 =?us-ascii?Q?raq8J06M+B/WOUimUxjgxQaKY2JdLhdnn+gBYl2faDbFvflvf2XIB0U+oR2S?=
 =?us-ascii?Q?uyZ5TSS56pRHxfXkhPHPUbTboixmkS42OSCRLhjEHXND054jj71ovxiIbg2y?=
 =?us-ascii?Q?x13mrSwxmMtDs5Fu8uahge8gmm1ylFLzreKVo/OmG88AZj70n+d35uddGNpF?=
 =?us-ascii?Q?7L22pnTkHeMC//U3JW7t+wj+v4BKYzr08gUinGP5yAJRl5iZyYSHpLIkAH2Z?=
 =?us-ascii?Q?3heODepr+HsTyEy+2Vd44R0ka+P+R+krmcAReiDObkbmQdb+b9auz5fGnPm7?=
 =?us-ascii?Q?qnAhDVLcRGsDh/1J7neyGBdif4io5m1LUIxd3gHPJ1/7yPoSXTRnhZ/bKRcM?=
 =?us-ascii?Q?VnN1kAK+Q84+cDVM79FUWoxE15WbBews0pzGoMPGmQenKvcEq3vpcEBy9pdd?=
 =?us-ascii?Q?7NODn4mXuWS/gIROk/lqMjSu0UxDKOQgZeNr7DBtw4ZE+D01+SamtR8cAqdE?=
 =?us-ascii?Q?Y1xobjkDHJyQExjc/pUrnwKzpYPCu4qz5S+uKl5Elic3uqRos1ls84vR/nk5?=
 =?us-ascii?Q?+VF8Suf5aO7DHpIYbQZngCv2/9RtweDpppL5Q3EY2hePLAca8QMIGHaYTaHc?=
 =?us-ascii?Q?86tGLEAn+UswSslfl+LHxxEGRgdpz3qB5e1ywT7GN8MsSyVO2xJg9aSFHdZ9?=
 =?us-ascii?Q?/NOZz6CtYBnQ7V6e8eUsk/YF+ulfZeZ/e7V8NDEE/w86RxjXAEMvVpNHs69I?=
 =?us-ascii?Q?f5eo8K2SiHKE0Y2+hKMGFFeOg9kjMVDFaNgJfqL6OQW4cGJrUR/ESK6bdUxg?=
 =?us-ascii?Q?M4XThA6PbDjwyYLRuqXZQ3rRpKu5S7LxTuQJRrXn3IksZ5tu2Rvj/XkD+LdG?=
 =?us-ascii?Q?kVaRBpIFOuU/ZYHVrzDq3lHRKw+Fpiz5XEAIO3GK2qO22EprqAUmZI0961cE?=
 =?us-ascii?Q?+tl1pl1TE9ymU7KP3SD0y9Ker3VFTREFuYohRJM9LoEbWst8Nv55ZBctXFhd?=
 =?us-ascii?Q?1T+SBIEAoTsXdlZHxFMyXE9Voj9b34IBzDF8V905GnELjX1OS7tqbqy4AoxV?=
 =?us-ascii?Q?lCehixP5KN16fFWD/tiVZbKD6eBr5MfvfA3tnzlO4xrwP5fjGX2Iw1Mrb4tG?=
 =?us-ascii?Q?EyfJFISApzDzmFnrM2hdTcrtYyiFQwHkhNPg0oqEW4AO+u5/LJfXa3OuxgK6?=
 =?us-ascii?Q?qNMhN3lPqCffZ60qwDA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74539ea3-83ef-4279-4dcc-08d9e0e123d2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 15:33:02.4134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZs1cs8AqgZvnEhgM6QG3dmbONPcGter8xbGJw9SMcoEk1cHglPYNINcIouSeTS1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2490
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022 at 08:14:47AM -0400, Jason Gunthorpe wrote:
> > > with the base feature set anyhow, as they can not support a RUNNING ->
> > > STOP_COPY transition without, minimally, completing all the open
> > > vPRIs. As VMMs implementing the base protocol should stop the vCPU and
> > > then move the device to STOP_COPY, it is inherently incompatible with
> > > what you are proposing.
> > 
> > My understanding is that STOP_P2P is entered before stopping vCPU.
> > If that state can be extended for STOP_DMA, then it's compatible.
> 
> Well, it hasn't been coded yet, but this isn't strictly required to
> achieve its purpose..

Sorry, this isn't quite clear

The base v2 protocol specified RUNNING -> STOP(_COPY) as the only FSM
arc, and due to the definition of STOP this must be done with the vCPU
suspended.

So, this vPRI you are talking about simply cannot implement this, and
is incompatible with the base protocol that requires it.

Thus we have a device in this mode unable to do certain FSM
transitions, like RUNNING -> STOP and should block them.

On the other hand, the P2P stuff is deliberately compatible and due to
this there will be cases where RUNNING_P2P/etc can logically occur
with vCPU halted.

So.. this vPRI requirement is quite a big deviation. We can certainly
handle it inside the FSM framework, but it doesn't seem backward
compatible. I wouldn't worry too much about defining it now at least

Jason
