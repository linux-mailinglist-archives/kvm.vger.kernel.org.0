Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C6647ADF
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLIAmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIAmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:42:11 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF928950FE;
        Thu,  8 Dec 2022 16:42:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBYYy7wKCTsLwuex5XSGbD6nLYdy63xn0Mrd64Dvt23n1nZsLxHITfGGBgghydiqeLRAeKikMLtJd0Th8x0bl6sIGqHm3RY9Yz1OlIxDVEhu6eYBWAQDKoJ6A1YNNj93xGBnuG2B+lG+QfbWdxkuqAkuv7R3nI6FelijpV9Cyqqonyy59TowbMDXfy5tZaL5auszoqz5iSwT3J5L7lRjp438lT02juVW+CI93GdcheFLuagjTM2xaO93j/kSYZYac3JsYR4T538JcEsA6EnKimMJDUrg5Mto1HaJciTiQhamKhCC8SutcUDU4xyOa29oR6BLeDSRoHBb7lc4WFHqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHOG//jIvKYH2qFfRkuGHBhMf5KDA5+kQeIKnDOgFVc=;
 b=c3svNkpWguEidaPMAlCuSjmd5uIfOuPP4bWbZvMjGAhsAOZHjNK1K6d8n8sSAA/Yr9er+kBg0IYsO75pFsc+NPA6HMagcN5na7Yiq6kxNakdas97KLVneHiqga/VXYZQS4vExa5xpXG/zyy01YwdlhbmWZI5taaubPxUbLv3F5AvIXP0rzTx5le3aMQcCzFcuaRHbdv/NjROvKwXdJx1jvkqFYKDtRbjI109hVUdwVm8VamsnyKo+BU7KzVpKJPYkmz2xG7nZnronrhdHMSU2oBeNAOXQTx1cmqgypeFdZGeNjb3iIH2sdRtihwr7aB4mW6NGzeISLlOXcIMy8YGsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHOG//jIvKYH2qFfRkuGHBhMf5KDA5+kQeIKnDOgFVc=;
 b=tCwokMcN/jHPCdY7sFk+BM0G6bkuuaXmDbcTrU2HZnctQ32PYNLkQ+1CAQzzQjPaiSpFOqE6HvTKxmTnWzDG+YBzlmF22WDsdZlVSC6k+B1t78RxLtLhSTObDN0rdaTcBy8X87wZM6WdX6ol+6tTAwl+faWF3qkVSaKA1qLJvS91qOwOOHYnKQiDlgUu1b6QQ8/9+JsK4Fzw6rYfPXAs4HEh/hgE+EfIuEFdGU7K/Lj0t62vKCSwezIn8wprG4l9wvegzZYAGuntiwNG3iskrKfN3DTH31pKZ7b1qBVccq6I/aOmtOYdahbbGiqGoPDn/Fvx3rP02a3hppXEfz6p1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6481.namprd12.prod.outlook.com (2603:10b6:208:3aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 00:42:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:42:07 +0000
Date:   Thu, 8 Dec 2022 20:42:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Message-ID: <Y5KEXpg356wO0dqk@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com>
X-ClientProxiedBy: BL0PR1501CA0032.namprd15.prod.outlook.com
 (2603:10b6:207:17::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: c60f168f-1d40-443e-494f-08dad97e334a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOzpe6Snvcdcv6UKQniwqqIx7cZ3zCqsldgtnt1KN5niRjX17SyObwDyno1urryT4ztcfStzz1aHfzcbuKz0A1Y2kpHl6zoSB2TDQzXcZoRq6rQIo1gSm1goojWoeG44bgIsbMxD/VOkZkixdo9GTlO+zFpTcQN87x8SuJNfqhfMb1bMfKrU2D21GBBnS4nLETEDCUuDNIvmyGo/+NdCY7i3AN8AoJ6hH552FKBojs9cbiR+iKfiK81+ZldL0IwQO9d01jl9FTwDePBpRAJlWiY22ITUe6K3/MPk5xP1Q7gQDwGd9E7pH7wyCcCFY/o7ksbqG1J0xya0xo+81A0zrr70vNT0qdFGTO3VYxa/qMZzYWntghvci2Sih9r4s6lG2aIJVZqDJwcrMct5MiZVdibf+zL6vvEOr7lyCEC2L7xlQk5pUjfSN004b7XYrX+kqyUybmCmkMW5cDKYmYncvRlySY578J8aA36r+9DYutgSq90uoa8IQbtZWSITxrdmPoTv2xNPMY8Oz+/6zezVTxgPS8v9yOwriGYJ1ODvQIhEc4NHUj83dG2yNNWnHeeTh46zdez6kozZoUibDXGEb+OQ7uCWruBI48IbjMUCkzq5BXX5xPQ4+lQvQewYcEHI/xiHKfBbAmT1yCzLkdXSag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199015)(2616005)(38100700002)(36756003)(8936002)(7416002)(5660300002)(2906002)(83380400001)(54906003)(478600001)(6486002)(6512007)(53546011)(316002)(66556008)(41300700001)(66476007)(4326008)(6916009)(8676002)(186003)(86362001)(66946007)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2XacoPIwKnF1ecrdX4Q/M6ivKDcfdBrOikMVogwVPE08OESnzxUBIm8SzikD?=
 =?us-ascii?Q?exgW+X0bw6WDJO49VRHQMjGAZTGERcJku0S+vmqJL/0OdrUz8tFGtLe/HSL2?=
 =?us-ascii?Q?f4bI34TrSDh5Tpx7yQ/vpk6czpdU9LltWZEKdaZJQoDJsuXrmleH60TJtXIs?=
 =?us-ascii?Q?Yv6ERvr1NkUbJlW+6l/DJ9SmxWq1SV4hMVsbvvW1xwu5jKMAUjVf0CQYDmZ1?=
 =?us-ascii?Q?5gKJLyOPubbJ1FTg4GVjRyqq1atgN9yMd1Pk8ENdJrT3z1cxDSv9kUG1SBWZ?=
 =?us-ascii?Q?JgEZmT8AHnDwWxGt0YdqzBj03AQdp6l5EutTbn/qRVkpH/QlzkZCCArDlxm6?=
 =?us-ascii?Q?s7E0oFVncCE7S6vnA/IcOUZEiwQPFgab1GiIIdDL3eKmzqivGe3A1K5QsGbq?=
 =?us-ascii?Q?dduOrg2SxmM39gVVAFdBQObOMk6YikdVoTNCW5pxWmFUFQ8QA27uyG3XD56u?=
 =?us-ascii?Q?iMVN3EQBdbrn7AgBEXljp5KIPg5GKrj+WGRbc6ZfYY665vex5nMMKGnVQw5R?=
 =?us-ascii?Q?zfbJZh5guQeB93ZBN5uExcgn/nXVfCFwzMjVtr2FSxwZondWciyHYX+C7Ovt?=
 =?us-ascii?Q?e774ZurAG7wl+9C23ZRNh2Q73Ip75X+58G9+eKsKufR4v1cQ62PKmgsYFFv6?=
 =?us-ascii?Q?/gwDqud12z3KauVS52WFAR1Cuc+hYPkHg1JqvEraXSOeHUjw8uH7y6vGDODT?=
 =?us-ascii?Q?XruPC0isacP03x2nf+diUAt4ZJIiVVvg5D5a5/m2n/eucGQAxixW1yryDM+I?=
 =?us-ascii?Q?4HAO4RiqKJLB2D7VdKOlNzlX058YR/BgB5NfDSw/SYF7wQ0s5roix7NIxhTA?=
 =?us-ascii?Q?/oCABMgRcaNBpkX3bqixbpOdfbT57xkP+a9AYtzvHtnNDeR/Mstx9z4+7ar4?=
 =?us-ascii?Q?3vukewW15Ybmsc/EFgknXEj6WgvTNsWXf+ekw1iInaimo9KRrfjonn3/5roX?=
 =?us-ascii?Q?MYh4IiwFaEwua+Dibxwu4zFNgTKvB/JzZJnGdQ0W7SkBQUzPXvRE0xb2wDNl?=
 =?us-ascii?Q?L4v4rqar5XZr8I96DQOVr5olTPdEBskDPce99afz7fLGIwCjh7SZaajG6ywY?=
 =?us-ascii?Q?6Kfw5XqkqbifxPAM+N8gv1Mh6b6OYZXjWhkVA8c5FTwxZPq5BQD+izVgrzmI?=
 =?us-ascii?Q?6VbN5j4EyD6aQlPXal9z+TvxUD4GJMiH4G9eTzYaiUX+bt5THCD/672sXAHE?=
 =?us-ascii?Q?fZ6h0KDmAJ3+2XjoNTBqbeHWPj0DKh/tpv+/DM1kPy+eZ4eAWbl1Sn5jzX5G?=
 =?us-ascii?Q?L0pAvaNcVd0oMhxTfQj6jL1vvk9rfMMg6XH2+m95lMdL4KylZHR4XZdPhAQ5?=
 =?us-ascii?Q?4UM7Aek6utMzIX+bzMflWgQdNoQngZACXw9MGGVOrZS7qqbwV2t34MdkfYvz?=
 =?us-ascii?Q?o2AhKUEdygnYlL8GxL48i9/OM7CubClTPD00hCVpXG03xuSa+JlgEJzuUA//?=
 =?us-ascii?Q?S7UoBlW/L2X5+UG6O4VppB8T/aogZ8YqV989hkrO5Xqjpk3h0i4Ry3vWW9q2?=
 =?us-ascii?Q?O6l5MyJKoW6ZWNR0OD39pHx9i1LrS2WBysywV2eTf5pPosrnRpGTojh6ODU0?=
 =?us-ascii?Q?cv6xygLKit0Llx9r6t8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60f168f-1d40-443e-494f-08dad97e334a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 00:42:07.8621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jAXAkNM7WsaPalK+lBnZPdtzGbOrELjqCZcftJsXW2q5IH5EGDu7+7Do2xz47div
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6481
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 06:37:42PM -0500, Matthew Rosato wrote:
> On 12/8/22 3:26 PM, Jason Gunthorpe wrote:
> 
> >  - S390 has unconditionally claimed it has secure MSI through the iommu
> >    driver. I'm not sure how it works, or if it even does. Perhaps
> >    zpci_set_airq() pushes the "zdev->gias" to the hypervisor which
> >    limits a device's MSI to only certain KVM contexts (though if true
> >    this would be considered insecure by VFIO)
> > 
> 
> There are a few layers here.  Interrupt isolation and mapping on
> s390 is accomplished via a mapping table used by a layer of firmware
> (and can be shared by a hypervisor e.g. qemu/kvm) that sits between
> the device and the kernel/driver (s390 linux always runs on at least
> this 'bare-metal hypervisor' firmware layer).  Indeed the initial
> relationship is established via zpci_set_airq -- the "zdev->fh"
> identifies the device, the "zdev->gisa" (if applicable) identifies
> the single KVM context that is eligible to receive interrupts
> related to the specified device as well as the single KVM context
> allowed to access the device via any zPCI instructions (e.g. config
> space access).  The aibv/noi indicate the vector mappings that are
> authorized for that device; firmware will typically route the
> interrupts to the guest without hypervisor involvement once this is
> established, but the table is shared by the hypervisor so that it
> can be tapped to complete delivery when necessary.  This
> registration process enables a firmware intermediary that will only
> pass along MSI from the device that has an associated,
> previously-authorized vector, associated with either the 'bare-metal
> hypervisor' (gisa = 0) and/or a specific VM (gisa != 0), depending
> what was registered as zpci_set_airq.

I suspected something like this - it technically isn't the same
"secure msi" thing since a VFIO userspace with no KVM can trigger
bogus MSIs against the kernel.

But it has been this way for a long time, let's just document it and
leave it be.

Jason
