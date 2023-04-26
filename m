Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B556EF4CF
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbjDZM6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbjDZM6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:58:53 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568AE1FC4
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 05:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jnzzxvd4RZUragIQOwA5IyzKck1QQqZZURlMEg9rikAVLkJhWrx0sjYDlby+JfO8Pd119QuXg5Wji7EhZx/Nz7ZaSh+SZuf5H/wANmRBkN78yMcphu3XrugGkjoerfuzi6wGm9Z73Jd3/jYMXar6iQUf3A3CuugIDPeuXNmHIyVGnaN0geHc4TJbnTfVmOPvkfr6dkE7CtFKC55vp2pAV124y6YaP5aaYCf2ZM+pY9UekEgWHl62kjyQPXr2ywbEYLdcJ1AFWnUMBgpNVe4BV+9W/+Yo6iIgZpn3edbLTZ988fctp3lnBpr0x426OZBHImkofrN/LHiL3ecytVSOIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDYqniTU+PiwIaQVv0w9L8YA/fhf4JwAJqwAC61L8UM=;
 b=K1P+fKkeGvEbJ9A7Xou2rSdWXuNcuzaGbKttokanhARilZeUlsH6SpjuHbKZ/txdfinBC62znkctgmUOGauR/HBj0zpVJww+ZSu+8MI+wrAhV1AyctSSMbq3DzWuXipf52efM55lTse3KBWcp/dQXxZih9lOLropufyU/rZaKw++byq+AnGgFmR1kSfwDD9AzQZ6f/XadaV9wktLEcAlym/xG1Q85UkfGM/YZA9EgfNQjFIEh0Hwx7jibcV0kg3NVpZEJAfbE8HWbeYe3wdjsGNn+kYR4pkxujAsgej3MLJhcHxMRSnJH9Ffb/3984cWSAACUYkcwaukAzE/6wYVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDYqniTU+PiwIaQVv0w9L8YA/fhf4JwAJqwAC61L8UM=;
 b=lLt6dJYFdRBr5vx7NVxi2hAjx+ogEGxM1+2tU7SS3S8d/6b/qKMdILuIsn1UhFqhUXQzy9+rE7BFo2uY3xb8YS8a5Wae2bSk7cErcvvaj6pEyhL8g0wYb8Wtt4ThLWmLs2v/udoQO5tPt0dYWJq5eeS2VrjKpMki6evMX1SMQXZLhb97EnJZUe9CBpK3/0WNp4MdoEaL7almmCNHswk4SMHx2JH5y8QyjESm19oEU2chVRpiZ1wRZl2hsga6RvbW+L5Wh2GzfXaO9XYArGFL44cbJFMpuO6ScY4VEUfnrqh0BCCOUMcBwd6gx9ZKrzg8MQp+LsG9fDUOsJulgoyqAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 12:58:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 12:58:48 +0000
Date:   Wed, 26 Apr 2023 09:58:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEkgBgAjhW+bWytg@nvidia.com>
References: <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
 <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
 <ZEf4oef6gMevtl7w@nvidia.com>
 <59354284-fd24-6e80-7ce7-87432d016842@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59354284-fd24-6e80-7ce7-87432d016842@arm.com>
X-ClientProxiedBy: BYAPR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:a03:54::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4114:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b6a6633-2f5b-4495-c625-08db4655fa36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4LT4m1od5aCcHdTw7Y6BkG/aMsPQtlN6GaFsK+Tdg4hFLDuxkeOFUbBzUD1Eek2v4d3hUffjoj1KNfpKTTQnkQmiK8SOLKTnsGlbQzDuu5ETz8+OEqX6qIrXLN+4S10UZxD/+8VxN56my9Siic2SuaB3MCoTn47lhmvERiZJG6pqg+k5DMIyIcQKy0MvH7MSEOdAX0OUleuRaJZ63AVFYreD3NVd9v03KgJXn1yIObRdiXWDbCF50NQeQzcJzjWlB7QgP5jwWRUTKl+oTa59wWPQ7o7mqNHdobUX0XQFla+cDH7MS7smguiB49JaKiTg9JnVcjcSoHXRCwCobsJOTjuwulBOiEzoMNxmQ/+Nc3+Eqx66U3vCMs36gJrYL9knPtxNm7CDemxmoFbbRNkufPy/nRmQ7Z33QH43pnCHI9rlOqOgBGjiqcGi09zYgRnjja4T4guK/5JaXRI/Ofeq+mymXRkBJev0uu/Fn4SqE9XVtl+R8F2mJyZhzPnL4/2jfnpyb0XG8N5Ztgj+HbnuwrJLPHJhc6ie2rgND42Zna7jZaFLrC4dNEWt/tpvidjuSIGKzz3f8ghKtSrWmn778htmWr2VnupW/jWJb99MRKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(66899021)(186003)(26005)(6506007)(41300700001)(6512007)(5660300002)(6486002)(8676002)(8936002)(2906002)(66556008)(66476007)(66946007)(86362001)(38100700002)(478600001)(83380400001)(54906003)(4326008)(316002)(6916009)(2616005)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hu1scGYjAKcYLFrowIYWP6/L6usFH+iD/oxLP4NPUFJNCRufAcE7Kt8kJQJc?=
 =?us-ascii?Q?GmerQsGTDsebwfuRZANyxU87uH8Tqeci14XmXYo0kv058PEZPQVacJks0nQP?=
 =?us-ascii?Q?UFMhOpv39DcXCOoRuknZ7d3S+7yCZcDt7u3z3N5PV9ehzkd6pOQjyCRtKC7G?=
 =?us-ascii?Q?WjWPvICmufcQYpY5h1pid3+2Zp6VKU+QIresKyfqde9T9+bOs+GyaA5CN6ru?=
 =?us-ascii?Q?YaogrtFUx467qH0xQjjDuRj3e9UnF5O283XaRuEOgh1WYPwvwaKnWsbJ0Cc8?=
 =?us-ascii?Q?d9tLvh4hm9H/v4/6wbSDnR/XBR+6RxPBMvMmyYZEDcbLp4TVxas+vQfOewAD?=
 =?us-ascii?Q?s1ZQZKO8lV9DO3C7YtO0OYJFsMSkuwXv06pvn+4a50vJfJTXLDtz1SMpfRsO?=
 =?us-ascii?Q?hTntHhm5ALXtZ//witIwgq5HTWIfowcwOrGq2RkDka1ZB/Y45U+8mQVguJ5E?=
 =?us-ascii?Q?tAzAzS3mV739sZ/b/sQ47n3gIzVgjgpPpc3l6bOduPw5z7BcnCaNXQ9jjbcw?=
 =?us-ascii?Q?VwrNL6Pr4d9Q2tDxffI0DXfIUBy6Px2z5tzZ6RRaBHS3Tq4ajk7UhOVW/+5O?=
 =?us-ascii?Q?gRNJkBdVXPfy/QcAUvUmdDgOxD0hqE+IvisLnTniO0gfi7h9vyIlGVAVlpZb?=
 =?us-ascii?Q?mFle15x7aiIdvPNbfHC86NLU+xV6Is+GpostvcOZCnvcPz8WCTbW9KQlS8/m?=
 =?us-ascii?Q?zNtp+eDzUe6Y0OdjclqIgqQbv0ooJX/c++Xth0g33uggtcyQPosovEeRYZ5H?=
 =?us-ascii?Q?EM2NeYQK0/xtgLkNkxHSi27RjLFFy77Zw4aVw+QaDIkbfn/l1K47BW7T9G6J?=
 =?us-ascii?Q?imD2Je+k2/ObWK/JwtmBxMXxkyC2g+FjjjCtEfyN23bHElvGHfO5xUZmCO8G?=
 =?us-ascii?Q?xUXNGnjJTR9g1BNtU1cZY7Kxzz2oVHfxxm7xFSVeSmkzMEEaQ2ChX5JQuCF3?=
 =?us-ascii?Q?rk4GcpCu8WLGJ/4NeQd3/BhIHcBhOFN2L21Y/o8/JnlifevRL3Wk4YtrSsgL?=
 =?us-ascii?Q?NdfBTiORR0orF3/7/VEftMChCgahKfcv9kCH8KJN3tMSVC0fFRxBugwjpKa6?=
 =?us-ascii?Q?CqNNbA20OdmaPkjFPwc0+wGPFBq/FLca3u1NrS+Y4yfrkRGm1w28GZfzx3yp?=
 =?us-ascii?Q?TCqDN+0QpJc4+89RPrFRDU5dePEh5skMDzlzPCFcT1CrP9hy4UpF3M7eu3BG?=
 =?us-ascii?Q?n/0TgBzYvf4gDJ0jv2YgFhhZUcZsMpMdIXuKfCc8rUwzWK8PAsQAV0R9lR+Y?=
 =?us-ascii?Q?4eVZiqEoFKcWQX2sPV14MhcOQ6rganJeFfCQX3X6/gd3os3GV15u8Puo0XGn?=
 =?us-ascii?Q?0cqZEOb2qwvF54e8YumWp58011lIDIzXNmUOO0W2avYofjZ3whS1OM7CJFSD?=
 =?us-ascii?Q?Wpg6ejxSQEdihnCeFAYNbJZ5QA/rlqUGcsJpEHa4BPZjtHxyZpVC9KGXDbBb?=
 =?us-ascii?Q?ov3ODmPuyBYnOKV/+J0p/CYF6Ig84SkWV/MTie0DfGNybR2Ht4KWGUEy0B8K?=
 =?us-ascii?Q?r13PXDjSxlenc8BADlx6GFR3Ji+EnYs2mMIpybyIqu4gM/IT+F6JfDyvp13D?=
 =?us-ascii?Q?RG+Fj9SZPkqn81ZjPEVue8J8I81Vt2j/ZsJN38ic?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6a6633-2f5b-4495-c625-08db4655fa36
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 12:58:48.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b2Liu3+V2e3ou2TV3eFgC2aQY+GeH958vFPnyjLvjXPyjfWSQKSYdvuS0shWXbvg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 01:24:21PM +0100, Robin Murphy wrote:

> A real *virtual* ITS page (IPA/GPA, not PA) as above, because the Arm system
> architecture does not define a fixed address map thus that is free to be
> virtualised as well, but otherwise, yes, indeed it should, and it could, on
> both GICv3 and AMD/Intel IRQ remapping. Why isn't Linux letting VMMs do
> that?

At the root, we don't have an interface out of VFIO for setting up
interrupts in such a sophisticated way.

> Fair enough for VFIO, since that existed long before any architectural MSI
> support on Arm, and has crusty PCI/X legacy on x86 to deal with too, but
> IOMMUFD is a new thing for modern use-cases on modern hardware. 

Ah but iommufd isn't touching interrupts :)

I'm scared we need a irqfd kind of idea to expose all this
acclerated IRQ hardware to the VMM as well.

> > > ...I believe the remaining missing part is a UAPI for the VMM to ask the
> > > host kernel to configure a "physical" vLPI for a given device and EventID,
> > > at the point when its vITS emulation is handling the guest's configuration
> > > command. With that we would no longer have to rewrite the MSI payload
> > > either, so can avoid trapping the device's MSI-X capability at all, and the
> > > VM could actually have non-terrible interrupt performance.
> > 
> > Yes.. More broadly I think we'd need to allow the vGIC code to
> > understand that it has complete control over a SID, and like we are
> > talking about for SMMU a vSID mapping as well.
> 
> Marc, any thoughts on how much of this is actually missing from the MSI
> domain infrastructure today? I'm guessing the main thing is needing some
> sort of msi_domain_alloc_virq() API so that the caller can provide the
> predetermined message data to replace the normal compose/write flow

We don't want the VMM to write the MSI-X data. This isn't going to get
us far enough. Talk to ARM's rep on the OCP SIOVr2 workgroup to get
some sense what is being proposed for next-generation interrupt
handling.

There will likely be no standard MSI-X table or equivalent and no
place to put a hypertrap.

If we are fixing things we need to fix it fully - the VM programs the
MSI-X registers directly. The VM's irq_chip does any hypertraps using
the GIC programming model, NOT PCI, to get the VMM to setup the IRQ
remapping HW.

This suits ARM better anyhow since the VM is in control of the IOVA
for the ITS page.

Jason
