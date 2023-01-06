Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A67660229
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 15:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjAFOax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 09:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbjAFOaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 09:30:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A35A1A059;
        Fri,  6 Jan 2023 06:29:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH3mqtH9ewsZKwzg6hoXjvF/5PIplCqHOjEkTw3wCxy9H2/bds27kRVziZCGkAsi8rL2NLqIfZY0qyHxwnD65Cbljhy5fEK2hVRMctZjgWjTfDQd426MSzIqUwxnY2Drb2XElJ5Pq2+e27zcn4eFHdnhvWajIzbkqXxv2/x9EkmUtROr3dFMmqZb3MLeIVPHpqRfy9mTQKlqvw8pPWW44DIJY9FFTwaZIVLxHaQq8jJ63vvgOR1hs+wpj9rjYhutQ5qzVBIkuqP6nw4lcuahtSx5M97DcTdQHvn7JR23RogX7fXiNBgnvcqeNyuagtIdoSm3uNBrGWDdvofCTgzoHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW013pNInwM8hEzFpLewBm6TyBkltMayJcGbQm1JEZs=;
 b=aPlVsA3MBPbriTVxSJhB71soboPUTa7DoBUirId5tpEJ1z3I2SmLooB7HJq8dzy3r4t00i/la3DBwi/Zd8vikzMHVGuNOO3m/UPnim5Y4LrOXdJEec0kgSeqZ7ECTTXI/I/CKf2LkiicDvMG+8QivsgansUPe2jDAWjYqWlo+OS6Yc84tVzmfsYPbxgWHmKG/J+6zBIrTUr/DX3XUICoQh0oyvm67ZAVFoktfDCdYAOYVH6VAjDnb+DKINoVODLn16JGicdUsu0N5ddUXcDAk1e9Cc4JM63TFKjewhhkXGIaxgciUBFhWDhJfIvuvPbCdBJ+3mKR5xjVwPCysNXViw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW013pNInwM8hEzFpLewBm6TyBkltMayJcGbQm1JEZs=;
 b=m5ZPw0qBbsfLa408XRAwVvadlwOUZTe5eqrMYM7rt8mXtHc4vRBQFEwLRlPxrfCcx87GQEpXaEGV/ZvnRBVE75nzDJu/adQwmlbniIvjwxOh46wocAqxsleuPlEedjX3uv80vtnP9LTT3+5BihaDzrWTQxbU+h1jkGSHSeZhutXuHnKHknQ6IWtJZkqNPa1qmWHNVecDI9cB9AHVVn1V6xv0L5xx5aGpIdi3GZIlHSk6kLvMASHxSy8FAGaNTVvEK5yUbPFzKpGmq5cISNydWQxiPjHR0ll4CmPfijkQjx/DwGR7QY/pYIgBjQUjJ/lyrgonjitlrias02Jxln4w5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4391.namprd12.prod.outlook.com (2603:10b6:208:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 14:29:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 14:29:56 +0000
Date:   Fri, 6 Jan 2023 10:29:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <Y7gwY1UJq3DNbjRu@nvidia.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <20230105150930.6ee65182.alex.williamson@redhat.com>
 <Y7dehnZSC6ukNxKU@nvidia.com>
 <5e17a35d-2a94-f482-c466-521afcab80b8@linux.ibm.com>
 <Y7dsJpudKGtM0kbl@nvidia.com>
 <d0e55400-d749-23a2-c88f-a2272723bc65@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0e55400-d749-23a2-c88f-a2272723bc65@linux.ibm.com>
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4391:EE_
X-MS-Office365-Filtering-Correlation-Id: f06921e3-ae92-4f1b-2a52-08daeff27bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWj6iaz47DyNBFX1ZEnfSin7N/BMflzn3nYMwnryMjXWMLlG+LyoiiR/uvV21WRiKpGVEj8bmrz5BU1FZYYN8iCy6KoSIYMr5Hr52mNHKmx8mG6bg5tlF8V1gbK+IUeooFe2BsFB3J/UbFglDxxMgslvBgC8isibCpcOwOTbKORTfQ6vWIbH6DWHyIgzuh5etyYyzZwSooeBHfyyuK0N0Mwpo4NXZvZuksOLD2KwHvgVtu4TULx/aLegRP2Ym9zGAHsGjRpk7tI3ZwtyTU7kRs3P7S/vPgXl44EJ6iJ8f5uNqpYoyoG1zW+O/7YsnEfXCEiIOr+RXcsZfPhY1eRt/DthVTLdZJ4uX5o6Mu2TZD8hAwlotktNzUonlBUjlo8VIvwjf58+h/RAK4RvUVtbAQ5r6vh9HrMO4x7QQHOaEBWWJr/kuPqg6OyTdJko7wyFuwrUV3JNiWYrGZaelD6afHhdMhT/ud7sqd+I7S7uMahKsySUa3yERg/rsTHeAxACUeZyS4AIt3LEfn+oaPz5XBZz5eZ8t+ORTNaj5i0hwD81mEOHWv8u8aAzwInZYlEqhQCPp/GfbmTFuPdGTv7IN9JhK8kKzO7pKMYS9paScoR8+wwZDfTBWX5RLecBiImxkY6dJhUX7kAVONpWdjU9wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(36756003)(41300700001)(66946007)(66476007)(6916009)(4326008)(53546011)(86362001)(8676002)(54906003)(66556008)(8936002)(38100700002)(2616005)(26005)(6512007)(6486002)(478600001)(6506007)(5660300002)(316002)(83380400001)(7416002)(2906002)(186003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p/Ck18YA0Qlf8SBSeNSZwyccZOw7awuTLlCV83esfcTdpgXUuQAK4PLc2JCY?=
 =?us-ascii?Q?6olzRWKQnrN3eAPoUX+E7OiZP/wNYWcvzlM1ATMhK9XJ6hcC56xoKfN6zP8b?=
 =?us-ascii?Q?1DbUqn8Ladf3sUKBL8qb6+ZJFzQtB5eS7M+9PIn4i9ZHAFf5tcvANBXtVt3P?=
 =?us-ascii?Q?nKHg07S8FAkE7JIrDVyrBFzp3am8SmsnCXaiuDb+WMzKiCChMz/1kTI8a9GH?=
 =?us-ascii?Q?rzFeQ2kRIoze3u4ThJKzAYdTKiF4E84ntsgCTaZOxb8g+ZmOFqdzrbRw9MtQ?=
 =?us-ascii?Q?HTurduO8HGctzjkpN2qXC/aDYwzkF1RguI6RVAEoqqu1AnQRREW62VOM+ugh?=
 =?us-ascii?Q?2Ik6/WQDgi97xvBmDiaq6NOr3fb+WfixAHrPXXys7JmihUGX5z387iD7gk01?=
 =?us-ascii?Q?kcZxIrI7mhJiXs/UCLbIvTFdHoIvWDRpFwev+MBdLdxO3/2+1L+v86DNXLJS?=
 =?us-ascii?Q?b9eI6zCsTQMT0Sa2PEi3+ihozCUci0a3RHCEB2DesdY/+rYbNyIaSfr++zaV?=
 =?us-ascii?Q?1l1klS1obfgX14W7ql0Gv2PQQQij9l14jcoYVmJxq41AYbJM0m//wKpI8mLx?=
 =?us-ascii?Q?cPqv2FSW86kAn6JdOphxe2K77bMyHSPHLqyWwYkZyG5W+5zNR6lx9vgADwlh?=
 =?us-ascii?Q?m1ff9h8Su94p9NjLExmbGtlq+yTLfVbW504oS0r4nr7DMnnut1QCCX/FdTqM?=
 =?us-ascii?Q?PYg04g2UrMawggMQ1xMbEZ5RESaduY5PjMjZ0aIJ09lmwcjkxv7c0GIaQsXp?=
 =?us-ascii?Q?jG0e5zOStqsHWoUNjaarB7OvdQtede9nV2N1cKBx/ovJXVV8wZDnvDKzCcG1?=
 =?us-ascii?Q?WCW7VPomkSKCPZ7Zg+0hIdo1eMaakTcfbv/642rddjLxEa4PpuWf2ui0tC/C?=
 =?us-ascii?Q?FxdNpCQFVgacu2ddp8Wt/5w98SeqXfXKO4yaC+J3KxNRpLUJe0EqM6Rzfsyf?=
 =?us-ascii?Q?a7TDmng+Ug30AJKolQB9HoY0Dm6gwG6/KEtngxFg2sasYkUhV21qtOSGDTwi?=
 =?us-ascii?Q?4ltJZiZWhbkwratq9ZkOPZKRphtN0dPU6PtWDl2yl1v3P+U2s/TOnXmRwJjB?=
 =?us-ascii?Q?XX5oNXvzIOuICvpw/cbK1FxP0jDxzxBRkeARcDrke+7Qbhn0Ir40aZs3z42X?=
 =?us-ascii?Q?hm/rg90xr36FnCafbZkK44k8uO/99gU2ndGoMLt3QChbd8nBvQT47gCuBbYZ?=
 =?us-ascii?Q?nr2THZjjDXFbcNDpN51lR9n/ZW5Lp3y09C8iwLUpXxtE+e0XSfq9dct4H3tD?=
 =?us-ascii?Q?EaZ7iT3a443ZOSEgi5Qaspjc2TxCl+ajgi3d9DD8QpWnbSPwBj4i5HEw5jfB?=
 =?us-ascii?Q?R/RtG9O9BbqAeMRBY6cc4bSxuDtSn6NFm7A2ayPYK/U2p/q94s2AxGTM+whi?=
 =?us-ascii?Q?oqirvinfw0sKz1i7X/lXvpXu8Y+OMEIV/MQWS8LvO3qTBtnmm6I0q4sXqUci?=
 =?us-ascii?Q?NPL3d4vKpzae1MHVMMGRo4LeidgpBa4xTCI4Wzk2eFSzF//T1nFet9eFcdPe?=
 =?us-ascii?Q?YslMdHY3WB8Wrz8BBSS3erCUAZTwD5/UGe9a4ajs5zsVK0Y6JWQJmItK+SS3?=
 =?us-ascii?Q?Gii+4Ay0a+QbgjCxCQ4dz3ARvrwkV+8JNZ1B/V6U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06921e3-ae92-4f1b-2a52-08daeff27bd0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 14:29:56.6116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWWFMHqorgxaYqXJOxLd0rDilPOubodAyp1a11KsadCX8Jyuvdtc0z9BYmchE5dv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4391
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 08:03:32PM -0500, Matthew Rosato wrote:
> On 1/5/23 7:32 PM, Jason Gunthorpe wrote:
> > On Thu, Jan 05, 2023 at 07:16:37PM -0500, Matthew Rosato wrote:
> > 
> >> Yeah, this is also what I was thinking, replace the direct
> >> kvm_put_kvm calls with, say, schedule_delayed_work in each driver,
> >> where the delayed task just does the kvm_put_kvm (along with a brief
> >> comment explaining why we handle the put asynchronously).
> > 
> > Don't put that in every driver, do something like mmput_async() where
> > the core code has all of this.
> > 
> 
> If the core vfio code were to add logic to invoke kvm_put_kvm and
> kvm_get_kvm, won't this introduce a vfio dependency on kvm?  If I
> recall, we have the drivers handling the kvm reference today in
> order to avoid that..

Not in vfio, put it in kvm 'kvm_put_async()'

Jason
