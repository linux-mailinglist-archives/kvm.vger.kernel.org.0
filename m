Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56797B0F86
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 01:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjI0XUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 19:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjI0XUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 19:20:10 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248AFF4
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 16:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzpebOPZUbrQ7LK9dk6nJoFtefZgz6K485iNGJ+u4MmzInAiZYB9aZc19Aa+FCEX6tv7MtFBfoRAgAJqhri1UYdowqBagkSgeXby/coG2E3q9KBE6AuwlD18UufENBhRkbcJfsxhgGSXTM+Bwy68G1zFB1u70Yalq8mf7FFBpHTpJN7cU/Q8TNb9gcFPg/tTT/vkWVNNm1QU52lI+vL/niC+LWonRdgUHo5oI67UVsP5TX6oUGP2u+k8KRUtwkwJXOZN4N/64cC6nkUdlmEyoLuKW2KQvWmn3MzUBLKKDfwP9Acs1BtqIGTfhTLiBdhRx6VGbnvyif3T0zu3IpkfDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wdj3nW9qJ5Zh8XWqpwaH3tBth8VPzN5d2aUPv9hKHW8=;
 b=ZSlMH881TPYB+IrsF63CxZ9lTvcM/zEajUjnuI3JLgyT+Dz/kdgAAqRnXHM2xCPcKT9TjGKWLYOmqICEq8VG1ZGOUbtG+i0qf9CaWDjTqFjk7EzWuItXuSPs2fKCiAa/rLuC06daZjS5O4YOn6g3HmpLfmkdMJa6Ryg9a1XIqvbPpAIpV7fMxkcNWKtAWe32FJyfKh9961I+jXZt8wYy/XXji9dx9DAunA7mYUHHvCezCbQlp5KLbmDymsLCQzhYZCAEj1mebUCSH1VqvCXrttJcf1EiNYkMy4irEMVEi7SM1R1L1+nzxIAEd/GwD0LNrH/wNJpbgj9py21RnKgdcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wdj3nW9qJ5Zh8XWqpwaH3tBth8VPzN5d2aUPv9hKHW8=;
 b=nyWjlujlmxUax1xGcyNVjSgdqt61nTn/N+H6uZZ5M6TBJVMdtznVStATKE1AQLg/xuzWxFRkNRXxh5uijVf2poVTuLi2U4mjGWN8BEdPenTo1Hq5PAPPsMfXwfdPAPogF9OZCJXj5lRTXJ7QXrjoJHOW3NaBMIVybjvQ9jjABPdpENK2J5FiD1NRgs+GmB9C4/JJQLAe9zJUo1dOg7cyJmn68LdAuEkqqzK4TVJRyiQ6eFWLiggg0plDMCso6STSh/pX8r3kAo1gqDtXVtud/gvg4RH1Hvbwsl9fmncqMGCJ3xtsMHwVJgGFLcMluCMuj+HGcBkiMKF345W10Mozhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5284.namprd12.prod.outlook.com (2603:10b6:610:d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Wed, 27 Sep
 2023 23:20:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%5]) with mapi id 15.20.6838.016; Wed, 27 Sep 2023
 23:20:07 +0000
Date:   Wed, 27 Sep 2023 20:20:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230927232005.GE339126@nvidia.com>
References: <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
 <20230926014005-mutt-send-email-mst@kernel.org>
 <20230926135057.GO13733@nvidia.com>
 <20230927173221-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927173221-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:208:234::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5284:EE_
X-MS-Office365-Filtering-Correlation-Id: 9256d0b8-808f-4155-ba20-08dbbfb0497e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvlKW8DeUPSTXMTAtZVOToL7u+dMfV0Jb+3DmAAcVeM07woJWpEMNQ9JK87iJOq1PUZf05E8J8aFEN6IbkmTZ+onNYyJMWQvJhlaTlWPbyfgUDDwk+E/F8aRmI8K4s+ZSZEVOGEMBbHbQk7gkm9QanA8s8ZYsQWxbIQYqNR7pAaS3hugPgWJxiFOcipH6ccFNbHch6CiE206NrhEeqBWeUh/oFxQ1rp1YdxFeRgjb14MsmC6N82KBV+XylGRrwq5X3jhi4zCGHpPNks5xWQIiwn2dKLPrEMjD8uECPRzeDInxFHyVsf6mbp0/GwpjP2OF2TBKdCLJHJzUxbsMT5SXTh0pFBhUdJwilj1t9q3CNt0Nar4h1nKENsdaS6ZRMSGXHanv7DWYyxIF/hA2tjG4+YhllMcEI3Nf11zEQJAFVR4IBXlo6+qhLITpqZq/kVTpqB9mM5ym+1V8ajK7Sly0N0d/mSWM8lepQ0vAMYHJMIaqZ+BfW60IFyoWzC4XeC+zNC5ytfPhQfme3d6awyiwrkyMCBv96xPjBT6Eh2itf8ScNd/6fX2LZsM260G77ZXLvgaTgt9FSJYjpzHVUVzegJnjCP/wDmypIQ/SYctdNViEggaw0gQNNGlApyhH27m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(136003)(396003)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(26005)(4326008)(6512007)(6506007)(38100700002)(478600001)(2616005)(107886003)(1076003)(86362001)(66946007)(66476007)(36756003)(66556008)(2906002)(5660300002)(6916009)(33656002)(41300700001)(6486002)(8936002)(54906003)(8676002)(316002)(83380400001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZwG+0oNmSRYqY9Fffsz2FOfw+I2gCiVnn9IbT1Z2EXLWLqc/mO63zdoc0pBY?=
 =?us-ascii?Q?iWggLG2BE/FQpbBpYuQ7+kqKm+eVqK6CNJSA6b05zph3aEyQXai/pNfD0u8W?=
 =?us-ascii?Q?xBMM3xODZAOR2OiiDemnOf7zeZFcdXpX3Xxvkg8Tt/+13jbIrQv4JcClnJ7U?=
 =?us-ascii?Q?bY/9mwLzKMfn0D8FbEh61nbwYFZpHy2uTJaYOZPJoENDd4vaH3ktAa36mPl6?=
 =?us-ascii?Q?Cnc7IawRsdEYicB0Mq/wG9VXjbO6DmUSC+jTDBFlwv8wReosHKbic1XfESHq?=
 =?us-ascii?Q?n8etKYv2Ds9vCFOoQnppmFLq3ePM69+ziayy6eMS853C3s44JrME/Ts5oQOl?=
 =?us-ascii?Q?vEAKRhDFMqvfhczPgQb54tTGvK9Kh+rH9+IWcc1TbbNKoWqwgZFhi4M0OfjY?=
 =?us-ascii?Q?zCN5YJkPHA8UWVc1HJNUwXrfve04fsNptmO3K/o6uTcWUa5ktqf05HoPVV8E?=
 =?us-ascii?Q?Z2K33Gl1FI86g+pWap9Vlx3ZofOyqJaTC2ZmWdS7YxhrG3SvYZJuxdKxjYRg?=
 =?us-ascii?Q?QJOmVeK1V3tFdwY6VWMGggudb6oaS/R+Tmx1aMh8Mkbg9Z4Jj2IVXPg+oZs6?=
 =?us-ascii?Q?2IiaRs+6o/t8ja+Vqa13PGsy8kh0X6yrqQ6KLnxsn3JF2w68lHqni5byBjVI?=
 =?us-ascii?Q?9x/n72/K1xOleYatedEJ1L1ILd10lK0rai5ewHlxsqeFH077f7vARJct8UNE?=
 =?us-ascii?Q?G0Iw0ExZ7wVG6WqKV0XP++vLtnMFnbVoR/TmAvZVc3titkmLHACfczc0qiDU?=
 =?us-ascii?Q?OE0eXM6LlQY2vm5qbw1qcef7T4LSk/X0msj0RtFCT2Z0RZKsjPEU9IpzlLz7?=
 =?us-ascii?Q?5iJYOnptvyDVYwp4KJC5zBPaLN2U8RCwZL/TxV9UJjvl3J2LEgzjmfJcMo4w?=
 =?us-ascii?Q?Wb3SZHTy2tNOe74YjZxRkN9sEJ/xf8JGoBqg19LmOW8x6YOSeZ04/1AIAmbe?=
 =?us-ascii?Q?zeysoyBR8LogCvsXzh0JIhhiMJl88m081GbNyZ/KQcj6rT/Y1qBZXBXYezC9?=
 =?us-ascii?Q?oX0hUmI9kkzZVr9CcV3pSECO3nRKSbH7IDbgE8sqvZeEdMcIBRmRN8b7qYxX?=
 =?us-ascii?Q?R84LDm6/qCBtY8GMlZrXM9xwx3ofuduNCiGJiPW2JA5WhBB9pWsWS7nVc3El?=
 =?us-ascii?Q?IEVB0/Np/4AdIExg2flzxh3kgIe8X4T7sC3S0wLXMBVmQfuZqe2abBTJsVAL?=
 =?us-ascii?Q?9uewyyt1I+nMGcNVSzK+y+HbQ2im4c8nba74q8P6tepvxCQvWcFLY2eDVSSF?=
 =?us-ascii?Q?uTnJdoJVTYGqEjgq/H5OTOd2ozJ58A3u3upDuaNOgJdF7ty+COs7AAGCQjI+?=
 =?us-ascii?Q?wNHTk6QWe/nnDr9/kfQaJ7o8PZYW15/Wn69Ifmz1EqB/8m+wCVCUgHgVdUd6?=
 =?us-ascii?Q?bREsoE8PMUSaVVPB2liYQaOY5BuR03m2zoOmNyGNyaEx6l8BfIaHJs2510BI?=
 =?us-ascii?Q?APcdGXT4viEqaqWhZQREnx/BWjmeL82v27MexK7ixUpv7BaegCCGdwYNb2mO?=
 =?us-ascii?Q?hwX7+R8mKyLKIrAxUasTs+TxyHpMxbFxGXpxDNS+1j+Wh0lOtR2KX/YMh4sG?=
 =?us-ascii?Q?ia0loSk2zQsOuQjDYmoYnV2Izf9If5ssCSWyMraO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9256d0b8-808f-4155-ba20-08dbbfb0497e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 23:20:07.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aU2VvICtS/wmMA/TAtZVKiYAidN7wr103hKhSAb3GPwB1RlcI/9bowDIu28QG/tL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 05:38:55PM -0400, Michael S. Tsirkin wrote:
> On Tue, Sep 26, 2023 at 10:50:57AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 26, 2023 at 01:42:52AM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > > > > VDPA is very different from this. You might call them both mediation,
> > > > > > sure, but then you need another word to describe the additional
> > > > > > changes VPDA is doing.
> > > > > 
> > > > > Sorry about hijacking the thread a little bit, but could you
> > > > > call out some of the changes that are the most problematic
> > > > > for you?
> > > > 
> > > > I don't really know these details.
> > > 
> > > Maybe, you then should desist from saying things like "It entirely fails
> > > to achieve the most important thing it needs to do!" You are not making
> > > any new friends with saying this about a piece of software without
> > > knowing the details.
> > 
> > I can't tell you what cloud operators are doing, but I can say with
> > confidence that it is not the same as VDPA. As I said, if you want to
> > know more details you need to ask a cloud operator.
>
> So it's not the changes that are problematic, it's that you have
> customers who are not using vdpa. The "most important thing" that vdpa
> fails at is simply converting your customers from vfio to vdpa.

I said the most important thing was that VFIO presents exactly the
same virtio device to the VM as the baremetal. Do you dispute that,
technically, VDPA does not actually achieve that?

Then why is it so surprising that people don't want a solution that
changes the vPCI ABI they worked hard to create in the first place?

I'm still baffled why you think everyone should use vdpa..

Jason
