Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0ED559CF0
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiFXPAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiFXPAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:00:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1906D826AC;
        Fri, 24 Jun 2022 07:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/mljMHKawugE+/W8I2br8rKJSeLaDj8Ck6WNhJ2XXL3IylZORHbRkxfsiKxHa1u2cQnsO2CWWiGQ1U6eCeR6+yBQI5AE+kZF1DC1uWr07OOASjkPPa24oLMigboML+nZe5XjDcav9qVHxF9cxxRL7GMHBFh4IxRelkvWHhzEjLGXUGLEHBWuOgMg/CzGa1F2LggKxbCKZtv9vNhOQTQJB8yJiBjeXFwYL6suLYbtw0pxPkEoS4R+UZaV8ArO6rP3/JABVtqKzbsqBd++OyI4IjrjIyfOt+eTP1BeA3kAeTQsJb+6UK+FrF1tYR9V0ylW5BUBvDaRW4QxSnuJqWXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0fsSVSon3ki73B/AbZ/6Bd+V1T33yqdRR27kTNfOKNs=;
 b=k55Ynb73FbNa9/zxitDJUoobOff1QNY7SYzhXPOSkVsUtAp8CyVqcCGUT3Xji1EUfowZTVVqoJzfh2f3H2ccoAJJhknhgKO+DGkjFXMQLSGtWpfijX6ApTctCD0TQ3ej1MDAsrvqE7968IGms7khIBhPw+KqiZtTTDopEegbLxF2F9sOT8+aPweFZByRhmYJO/F2UVkuSEafdXvHpXO8wfdmbWeC+G1ABgyoM80OqFGtMWVeS9vEduSAQXBvXx9Q6ynbydwnhR/W03J2RvsrkvSarygAjZRFQZJl74/OypfvzTrpR/Leh7fWyRnW8fKZqgYoNlIq02fqdofDGV/gCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fsSVSon3ki73B/AbZ/6Bd+V1T33yqdRR27kTNfOKNs=;
 b=ElTl3CE0uqiLzPk3HICicFD6Td6bGU4xDgGeywcFgDvqeAYXZOJj2svyg6rWUt491F0zKMR8rWm7QnhKLIRAmzkTyJlGudiyO1rrY4bzbL57P++iYIYF5M+1Ni/1ZrjX5xO15MQZqReTXsHfdStUqaRFgRr0xLbbGntdSaDjspI9tvkyXSlzJ2Ehvw/7uik2mQbb+mJxMIZNpf8eLiEwsTN0kLSDHdJYfPbJ4J8vBAFGG+cNRX33PymfPTfhoAg4UVI3DqOVzgPIWYWDWeFEErD+Ey7EZVtPjrzvTXAGBWvX4CENQSBMHJhgJnIlYFhZoBcgLEr/eiEdnWqFZI8n5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1563.namprd12.prod.outlook.com (2603:10b6:4:a::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Fri, 24 Jun 2022 14:56:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 14:56:28 +0000
Date:   Fri, 24 Jun 2022 11:56:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, cohuck@redhat.com,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220624145627.GU4147@nvidia.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
 <20220622161721.469fc9eb.alex.williamson@redhat.com>
 <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
 <20220623170044.1757267d.alex.williamson@redhat.com>
 <20220624015030.GJ4147@nvidia.com>
 <20220624081159.508baed3.alex.williamson@redhat.com>
 <20220624141836.GS4147@nvidia.com>
 <20220624082831.22de3d51.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624082831.22de3d51.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:208:c0::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfef6bed-1aba-4a76-e5ac-08da55f1b7b9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1563:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHDngdntIx74MJGDNNxu1IAuojr7hHCWpO/I7NqSO1alU8qXZt6pisVJF+/HNHPOh1UxLD3i+uk8qA5gJyDocOinJNYRGESNSKuusmAX1+Swodj+/ac/5emjmjZFw2tzf3zQx0bL5BFarCDEs4XAXQIeENyWMISmX6LhhST055jyf7XpItXmP+OHnOFoKdbae/N+mTYbKMjLhswYb/WUpt2f9INYXDk2WsQMJbwagDsAH/vI95XLlOwcrsaNDIDbG7SKyxWQpcCrXHNznIn2FSfmTbufJmaq7kOdpCaT9g8zTzzrJCgWtSoA63vkkagbyyVKlEi++mW419G7XHar6/2EugrxaUuXJ4KOOsLEnZive1su9sng70VAg7ddx6FNA35Kj3W0Zl2NL4tuWXEZEp9fopv0S6kIJfhZBi3B7PpZgPXOiz7E3BIh+7HbPRI6fxVBYetfwM0L1IEdhKVJO7G2eNU3zmaY5N6qtV5N/jy8g8zJ9++LyulPP9j65iUw+YvyjWHSZ5NNl5DJuXSFpuDwfeNgqj0ecTW7XUtSQyCNPVP4J+pt3lSOH/lDOX0fT5rN/r7NCmnIYgllH5rS0UONB+aSZElgfXYqiUBoA5JSNGYHXPo8M8okxE6+l0DF2Mr4CzVAVEKjbEpxwABipuI307tfHFcHjYMotJxNk+UAq/7CiOl2RmKInKPnLwNVlICN0/rko6ghHb0VuOfgT95BdHailQkXd82uxi1K3RRHxtWFL4S3Ku6FCZrCWMfC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(6512007)(6506007)(66556008)(4326008)(36756003)(86362001)(2906002)(8676002)(1076003)(41300700001)(33656002)(186003)(2616005)(26005)(66946007)(478600001)(8936002)(6916009)(66476007)(5660300002)(38100700002)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtWz71W9tSXMLED/GgQKxS5yO4SqyA0fg/qOd7/PCbhial3HQ/jVdLUUQeP1?=
 =?us-ascii?Q?qxISUGCk9ZEET2Ik8MyRjvOgKFhxBvQfnK4h36udPvUEAlQRMQ68M+a55+n6?=
 =?us-ascii?Q?U2B6rSXV5OdJD767GOgQUgzfWXuwsd5jhLO6tQncyHl3gXJ0rytn2BgHU3sR?=
 =?us-ascii?Q?TBTt1DbtK/eVgcCMM58NbmqNbimk0jkkiXr3Rx715xaSHaLyXxli3dskYwXg?=
 =?us-ascii?Q?doCoyXoYrDmx3qy2gZ5+nCI5xFae/WKyyUd0uLWLBkoLyVeDvu84aS8musyd?=
 =?us-ascii?Q?Qd2v6WOF8/wTF26qsZnJU7H3qvTXENI6OlS8INndCYa9kMbHR0syxZRPTlnK?=
 =?us-ascii?Q?qyGlpEaW0k1VS8ev2GmLgn99tCjbTRipDNZIjdb8lnxriWNIPJtt6s0svgVk?=
 =?us-ascii?Q?NGWg/OHYgmDop8rP/tsf+FfzLWTbuWxZPnTR+Hg0xJqLI6rPVjGN9T1PCWIE?=
 =?us-ascii?Q?B9AwOrejca2uphifeGxHC9v/o3B94PkWJlFcv6Cz8KPgHKPOxnws/jQW6R3p?=
 =?us-ascii?Q?yq1omNZbQr/LPz3vQXczte0D9p5Y9ky0MXE1WteYEP6q3afXHgo75lvHbaVD?=
 =?us-ascii?Q?UoD8BAGdoRelidAfRoau++/S7IWgQNr/GX3ae/R8MJMw7/Qxl8xKVLuIjGyC?=
 =?us-ascii?Q?mqIAuzI+7G3u8GL0P8QEhUV59TU3pd3FMPXs88zl1BJmwl30kcJsfhVBZIDg?=
 =?us-ascii?Q?bAV2egpUs3Q+uRYCBT0OoCnug/SE8XKGAFxsFitT+G4PA36Z98lbuj2+QqvB?=
 =?us-ascii?Q?2zAy/uijlNdQ8cpY64iOR3QJWEzZVQDxZeTFeQRXNcKMoME/g7SBzeKNwATU?=
 =?us-ascii?Q?NCArO0zcxB50Dd5SLwCLzn8ChYmkgMXnMp+hu6T2V3oR+eUO6154OYKYoG7C?=
 =?us-ascii?Q?iH0e4nhOrsuSfLRiOxv/iMDcmSWc+9NqiY7THycME7yH4SeFko6JyI/s6wwv?=
 =?us-ascii?Q?O08f0cudGAARFUUy6y0T6F8a7CSRfv45TSrURZWiLi3rJEKdHjZ0sKXK/rtQ?=
 =?us-ascii?Q?16rojAygxrW+HfMBjFV0lmLdKYbU7jxdY8G6grKBMpNdTlXd+Xp7gVrJFq6B?=
 =?us-ascii?Q?cVDv0MvVftJIYlEkzpW1hni4QBpd9sHOLyC/aSbo7r/FpS3Ocvw8RKoQ2/z7?=
 =?us-ascii?Q?BbIHp7J3y7LgqMqJE+ZBRYfF2A+PGn/o59lgtfHPE0rTfe+blMNPYOnwz+SH?=
 =?us-ascii?Q?YdFk8iuDujWw0sPJVLlBiCsxCBfeoa1mFkMC25x6WX6/AIiVVFhrwRhxTatH?=
 =?us-ascii?Q?K+V5zTTRdyz5WVKLcoRuQ6uQebddSgvfURQbJKnMCoQuO7IpyN7g6vky9+2P?=
 =?us-ascii?Q?FYreogLR8EkB1fiMpNkkj8pag2Zjx3D4fCdwRvFOfhVTHZy+VQbFWe2+3PdA?=
 =?us-ascii?Q?5IJN2ot4RPAOxw93FRHMgy7i6lhq4waq9rrmXc6+ziMqzOHCanqOaFuy1A07?=
 =?us-ascii?Q?Synu5BP3yxz3DKX/RJ+xhjsF8b3x8HbF016uHis3BaValdbcyxV+P8/fna3J?=
 =?us-ascii?Q?SxP0TyM8hek8Bpifm3P+DELNiZ3WtnQTcTY0ymIBlIyJhmuWkHrHywdm8b2B?=
 =?us-ascii?Q?u0nDGwdPC6vvRZJZDHNidRgv77ZpyRB+qGJjKdci?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfef6bed-1aba-4a76-e5ac-08da55f1b7b9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 14:56:28.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBLM7F/XRptyaAx+4+zzovttmXdNY3uyMKM90pOTvl+gjHVoITOQXmXowhdHvXVs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1563
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 08:28:31AM -0600, Alex Williamson wrote:

> > > That's essentially what I'm suggesting, the vfio_group is passed as an
> > > opaque pointer which type1 can use for a
> > > vfio_group_for_each_vfio_device() type call.  Thanks,  
> > 
> > I don't want to add a whole vfio_group_for_each_vfio_device()
> > machinery that isn't actually needed by anything.. This is all
> > internal, we don't need to design more than exactly what is needed.
> > 
> > At this point if we change the signature of the attach then we may as
> > well just pass in the representative vfio_device, that is probably
> > less LOC overall.
> 
> That means that vfio core still needs to pick an arbitrary
> representative device, which I find in fundamental conflict to the
> nature of groups.

Well, this is where iommu is going, I think Robin has explained this
view well enough.

Ideally we'd move VFIO away from trying to attach groups and attach
when the device FD is opened, I view this as a micro step in that
direction.

> Type1 is the interface to the IOMMU API, if through the IOMMU API we
> can make an assumption that all devices within the group are
> equivalent for a given operation, that should be done in type1 code,
> not in vfio core.

iommu_group is part of the core code, if the representative device
assumption stems from the iommu_group then the core code can safely
make it.

> A for-each interface is commonplace and not significantly more code
> or design than already proposed.

Except that someone else might get the idea to use it for something
completely inappropriate.

Jason
