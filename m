Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D02464F0E
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349688AbhLANxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 08:53:17 -0500
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:47306
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349610AbhLANwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 08:52:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fx1LBhSHgkHqf9jfxY03x6AY00brWTLO1xQYvyZsp0zg65FH5VGx+0qvO7eu61aU+BSqG2XfA+otxDf160U3EXcvXStjdJWGKHIGlSnf53gx6vQ4tNHS8fauLnYG5c0RhsAqNBffgxgnCh3c5kfYK0rj+6vg9JKQtAmHE/8ID2a3tPNxHXy6qaQjQc2RqW12YLUds9KiAdvlYthjRVj89DZYCRtyJHPZgOkHh4TibDaZx4SGUPu4Ht3q1bnWIrvhHSpD4JcpKXGSZ7f3uxHlBoIB4yXF8u3+kh0z6w/IJ4UMRKZU1ZWcTsjGEmVsz2/SJHCXzvJ3vXWobQaSbFulNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBn5VGOvlDw9VVsyV7v/lf5wyah3JSNbOzglaN+v7F8=;
 b=NiIJrklNXOHP4TTYi0m4cNaELfdWTLqguU+l21LXhw3TxO4HPAz1FgsYS5oEzEnoVwwaMWu5ZcAoJaJ34ubED1qOZgeta7i+/oS1j/GsDCb++ifkkNLJ0sQheqKDyGnYZF0/YfV2g59CkMbLFaoqkdXfXOfw7FHFjWeJ5Q75u+o7nXrl2ivIYR+Mx3OV8aRAoaGP3ZlY2lKdl2UC74jXv+lrWR4CkHAUeJvsElxayPhYV2cC1zMvSVG6h8BTcP8QGn72t9nLmU2wYCY9a0pd/NYkxzPIDfzndYSiUQBPJ2G9twsGU2GvVpNV1Qxn64SOc7p2J84ClQc+HJvtZoTVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBn5VGOvlDw9VVsyV7v/lf5wyah3JSNbOzglaN+v7F8=;
 b=qb/aBr7yxUOGYy9YIqrFYd+k299PHl+OWSC/Z1nmdcYlSxFyonQx0qLAaUP2xLDN62H59JBNfVMeTMziq99f67FtkiOebSYYgtFnd3PhtIPW/fC34fsmlP7blBWbdmYwWfOlyw5sCPV6CAq8JGc14O5sRc3Pt+NwBvwtb8IC76e4VRjOuHMnNjsZXiVizDcLBK1dgCgX4u+Ukb3eyHby40QYUt0VsPU8BWxNZb0v4RYLxpRml7iPYm8kyxq0Eys8iiYrZHdUUJIyqIwZRem0D1+KbfO1qxwsOE+916+xTgaexGjA2pbc25FjoHzR9TZqZuWIWiO/HnT2AuEER6f3Gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Wed, 1 Dec 2021 13:49:20 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::1569:38dd:26fb:bf87]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::1569:38dd:26fb:bf87%8]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 13:49:20 +0000
Date:   Wed, 1 Dec 2021 09:49:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        liulongfang <liulongfang@huawei.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211201134918.GI4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <90226a3c13a2404086dc555e4aced7cb@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90226a3c13a2404086dc555e4aced7cb@huawei.com>
X-ClientProxiedBy: MN2PR17CA0006.namprd17.prod.outlook.com
 (2603:10b6:208:15e::19) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR17CA0006.namprd17.prod.outlook.com (2603:10b6:208:15e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Wed, 1 Dec 2021 13:49:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1msPz4-006FqG-H7; Wed, 01 Dec 2021 09:49:18 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24534908-a24c-499e-7567-08d9b4d15fcd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5088:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5088A4D879C4199880A6A76AC2689@DM4PR12MB5088.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7+ub/8WaTBbflJy1/gyfol/calN17JfWdueRvniTPZCW0ICiH+3SD1H8UfUQ1xVP/g0F3F8y0IYXHmDcyXLrnANTOOuOiwXUNoBjlRzPjOBjG527XKN7L/45JVc3oeIb3bxjMFw2DLydb+n2ANDsj3rV5T9l9DQaw8tk44KP1VYxlCWX/w+PAzybJnULG/OkI0vLhBK+QewiVAn+CuPCUK6Nkjvh0pjuKwqd2KHPtQo+O1oL9k5j9SEeURUTcIQ6Iy14acFtLiik1e2VBmOltbX1onViTT66+raEPNmuRpeGpb9xq36QfNFU5EU1trm0gj6cw4I2K9JD3dQP3FkeNTJvY/V9f/LY9dgjL2yOEvNhg0z0DtMYpHWAHmumIAvsgXXMsDWjDEhGBK/3PdM5CGuFF6PClt/6XaaB/QCNKXFitpb7ALewFRVOQGOFxE80rQqSmBWTk4FWuB6yrZVs5gnxr4kkomJoTTAfliJqd3GkDmFzkUZcFGMl0IvbMjW4WY3NA/flctP2gXdhFhBIH0I2D7NFhkrxDsYno5TFlXwr55CTDHeUnnyrBCBTn+A+NoVtu56Ld1pnTh1o9WzMr1qffKeh9SeibTC1eMv58/cLkU6I+1HdXBASbSpi4eq8t5QgiL4p8gNUFzbVdFcog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(38100700002)(8936002)(8676002)(2616005)(33656002)(86362001)(66556008)(83380400001)(426003)(66476007)(2906002)(5660300002)(316002)(36756003)(1076003)(186003)(54906003)(508600001)(6916009)(66946007)(4326008)(9746002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GZ4M2l2gSk/dOhHEdiVoq93wma5lruXrNt4BwLvK/8Z8KhyDBBhThNp4M+pi?=
 =?us-ascii?Q?EH8UHlqdAf1P7keKJTtj+A6kt2bf9seWLn003OjQVyUksZlGv2dZmCTUaDqs?=
 =?us-ascii?Q?Vjo/cGmO1gMhysRMlIAtxPQyMFcEwlNB9Hn9pZVxz2b+F0oM+VheUQG3P4oJ?=
 =?us-ascii?Q?o3AXUB0MkGTjG9OW5iG6CLk4E5TTHc8edDldyIR8Ww/PLiWzQsAPBm7W0kEI?=
 =?us-ascii?Q?Mj25AeQ8R+ozlYzF/WI187qybduCAB5EH8wA5+meppA/KAEQr8NXQLkt7rTz?=
 =?us-ascii?Q?ENGTYM9TwaYM8EGfv3KYZFYEeK5PV0PA3wto6dhOulZpWojxb1OjGwObhNCl?=
 =?us-ascii?Q?EpkaEnn20d/pAm74YxPlEoB/a/dq0+fqa87s/cEqXKtDV45Hlk5FM5fHwiEr?=
 =?us-ascii?Q?vFTszl9uNh/DEvdUQ+pklP9J422Tr4mizPEd3QOkbVbTn5nj1RJPDwcoYwH1?=
 =?us-ascii?Q?Hsl8LehqlTLdKRv+qDfrSvPt5hw82GQRNGDVIEmLE8X2ZHhzDV/BdXiK0QdM?=
 =?us-ascii?Q?c7ROiWjn24+NjX2zBgBy7m/oJdVPHS7XwfL9MG80Rx4vvOMXPLYgTYorMSHx?=
 =?us-ascii?Q?ETmkU1uu+la8goos4+F90wCR0mUbi/GB7/EBpC8W9ahuV5tO7IL2d507z9TV?=
 =?us-ascii?Q?kiJErYfX240VTjuEMc8qAaQP/cfP44BtdCfOJq64+DM73o1GJIPtSwW+89KB?=
 =?us-ascii?Q?GpnRS7MxVPc+8IvlVjefE7Hn/8n9ZOT9MgAOM5HPPc83RW0Zm85dzWDb1Pcr?=
 =?us-ascii?Q?GQQXyr4JGv0vjwH7cgD6tRbmmzZVHHdy3P73bhYln4UIGVBHCOsXI7M82BHh?=
 =?us-ascii?Q?0Km9E7dZ48hqgfVpN5Fw7lD+zcY1ZhNOLt0VT0abfjaofc4psjFD8HdVbKdE?=
 =?us-ascii?Q?XaeSkxM0YpokFYvwXc0KRFDLJxcxwouRmk0+3AQG6qbYVUAXWk4fRRI608sN?=
 =?us-ascii?Q?19UTg59w5Mck0QJ1TOi5RNkAU664m9ZaG6Id/yuSUBtSf1G7AAUGVkIiOhVI?=
 =?us-ascii?Q?8ef/JDn1DM/Mr39NbMFlHI3mLLp3tMOfz3pM2GckgET555gMty1qZRhq3dWZ?=
 =?us-ascii?Q?DYkzpMXB9rcmdHU67cudHrAcofvHPZNZ+RWXGsBj6LQ/TklFAIXCNhW3dWM1?=
 =?us-ascii?Q?bgCRxw2HdKSplQKeicgN1GgtrF+RV4hEL4fujYQiYnB/9a7eF99K4HOkPdyp?=
 =?us-ascii?Q?ZdGK0Xn+5Jz+TZ0h9AoINkM9FQf9iwU94mNcRCoBJXZRincv9AfGbEUGJEMi?=
 =?us-ascii?Q?mhWHdwnPqYPgchvmiDq7/Vs9DWqhGSoa8Tw4JuiMhZr5CT2XK+o3TgfPROEI?=
 =?us-ascii?Q?qcy6WSnVwW7Hkn9PNojWvzStFJ9nUV9sp2m5Kiw9Cez6zFeR3InN/VmWcF1/?=
 =?us-ascii?Q?u7ZoG/ER+RubiQLapKCP4p/71ZQNSghu7iajN2dO9P2EpImX+HmL+f9iiyU1?=
 =?us-ascii?Q?lLGhOB/Jzk62HaYs1aCYeJBR/aoiW3Q9kDPpbQJ5CtC+3pgy/xQwjG2I5MI3?=
 =?us-ascii?Q?peYjek9K4KVHN2axRrgzzR2rIS+BqALbqCne4W4GGchG5ezkouas6+zp0j0M?=
 =?us-ascii?Q?DbgSWd6PaJopjIRvPq0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24534908-a24c-499e-7567-08d9b4d15fcd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 13:49:20.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylS3Wxi/nOekv1DEissEIGHp0+Nsiu8pvodKafYhhkShdkKbTJ+fkeAlw0U8+Fkj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021 at 09:54:27AM +0000, Shameerali Kolothum Thodi wrote:

> So just to make it clear , if a device declares that it doesn't support NDMA
> and P2P, is the v1 version of the spec good enough or we still need to take
> care the case that a malicious user might try MMIO access in !RUNNING
> state and should have kernel infrastructure in place to safe guard that?

My thinking is so long as the hostile user space cannot compromise the
kernel it is OK. A corrupted migration is acceptable if userspace is
not following the rules.

From a qemu perspective it should prevent a hostile VM from corrupting
the migration, as that is allowing the VM to attack the infrastructure
even if it hopefully only harms itself.

> (Just a note to clarify that these are not HNS devices per se. HNS actually
> stands for HiSilicon Network Subsystem and doesn't currently have live
> migration capability. The devices capable of live migration are HiSilicon
> Accelerator devices).

Sorry, I mostly talk to the hns team ;)

Jason
