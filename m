Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0865F4BEB
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 00:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJDWaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 18:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJDWaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 18:30:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E3921E01
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 15:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHDjAVM3GNK6K2L/ikdFqnU8w9nYazN4wsWuV1K9ArlGLvLbv7yNq4qw501mcZ6nidsipvWpRgeWF1Xs4L8uNRKaa3KPoIbBOTZRuuUT68Fixl1XduF/8qdYo/aFJP0WSkoAe3e25l2XLSk7U+xN1CFgJAVTnrbpt9vl9Pcw0/mpGPLeiqtvLXa/ABXNzG+nKUp83JaJAy7efOBYEaRxeQq3hn0SzgfdgKLWyxlLd+UotCJUy/tXEaqQ3PN/qS1+q+qFImxr9933OVkn/o2wa4r2IsmkaMFSDv76PxWPvxOXEDdAuO2tOE/HvZ2GfAcIM2nc132wgpk0x/ESucPT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IawXminPp557HF3eF07DiRhOMDihpHhdBrAKeKW1gf8=;
 b=PFJNvSdxblBeMWW1X+wk/rGIig3BqlB019FLoy7VdKeVP44fWz0Mv1Q3Eju6wMw7mQNrba5Crfpincs30zauaqb+6iJDEqW3ltkeTQvOEX09wd3VBCirt1pPVv1ZmOfUn5LdXnECs8CaCGAnS+bjOJQ5rIFxKAR/KdzeqWEVnshAsxOtlfO/Rgl4IoZBnd75/eYPda1RJr3tkL0iPTrFpz95A5YAtXadM/df0YA1oYf3aIweEDD3H7KYyjx7jJnuQclB70l+fFrxmQKIE/zbvLUtb4qIHmg/UPDVU2GyIA6KXOEa2I7lPe9g5tHNS/Rr7q2qaXmHkwaVXSdXEhQ5oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IawXminPp557HF3eF07DiRhOMDihpHhdBrAKeKW1gf8=;
 b=U/x3s9VFolo+DsAjfHg9p6ywwaTR/N3cS4WuRws1hlH9xqIq62adHfwRa9pj6g3UHPGDp+cNm7S3AMskr7GmiYwzmkxtRFN3CIKorla3F1zjFUtQIHhnVzglXBJRzWRC+q9J1TQ6h9qJ3oi4VhHekQBCh4hMxQZKCnvZpjNpyGWHeZQYn0jRNdv7ErRd0l/QLtNJ80NAhFgEoRKOUXbRNwzdJ8ovwdaX7PhuOJSbYQ+TVmZ2AfD8+8IKIDQ6GFpnlPP4dBjatxeTCmsC3GEbIS+iYk8iZ88RgiyqIsOEG770t4Ge37UtQLf9+HMLTZZuwmKD6YaVOC/PybqI14azaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 22:30:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 22:30:13 +0000
Date:   Tue, 4 Oct 2022 19:30:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <Yzyz9Ih2IyanNMJU@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <051b7348-92d3-3528-3d29-4c9da1153d4e@linux.ibm.com>
 <20221004141957.5b990195.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004141957.5b990195.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:207:3c::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: a59f23f1-be61-45d0-ed4e-08daa658010f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9NNuhP53qa8/CcHAA4A4s45I5+QltMs687vXT+PyWao4IlkPg/n5PtOptu090jL4nn/tMhv8UnA7RdIDQnz22Sx4YrfcBGvInHAzmQQWwP8PZFe0staopU42fsJCTsUJzCLjVChXUGXTZr+qwl15wen/eSrVKZiA6ZVAtqnHSonU55PU+xGG4NfbjdlMpBsnJvdmEt672pv5Eo9lBh5UFjsv3reBZDhtI1QMHGWP0/+NVbr6vXwJdztaiyfTVsRzrJNiZXOTGYxMIJPQtbuaEfxbZ4pp8yLEkyYTChnjamEFv3SbEIW38umAeXE5q+f0p5RiockVGyDDl8GXBLxhqMUSrbxjAwkmO67Scl2xNBfVyfiWnWLvEU7FxoH5GVthn34rJnqZtrFaxgdwwSBP0abfV82diBR4n9a+jgJYj8Zvjgp7dSIGZQnsfL5TRImfIZ1OsYk7u+Zew0+MvLUcKkaUrTh/GKypv0kHMopJzZv3jzTPPDQmVn7WlCV2+ed52bJNPvz29+56M0pQH65Jo7TPvzmvy1Bi5LJX49rGEuuzFDgc2tsVq6aBh9nyjf/F9qvLyHH/WxukyaQiaVgnFIo1vnCTsQF1RC9fvjwiKALYI5VXT9RMPzulvQfCv/+kiZ8z0ey41g1/bnu/XKsr3ecct/uXOiA+HoXzbFYZqdsO9TjG026v7zSlv7qsQ6u9hw6kB52Eed7RPl3R+nkXNb4XCQTNG8Iv485qK/YRK61iZnyk20slMocnhThRTKyd0hfzAwI72QDg6KQ1c0Z3tzcKNvjoimlL8BfYSJD16c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(66946007)(6512007)(6916009)(26005)(4326008)(8676002)(66556008)(66476007)(83380400001)(186003)(86362001)(478600001)(966005)(54906003)(38100700002)(316002)(36756003)(2616005)(6486002)(8936002)(5660300002)(41300700001)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ct/Pq3bHMXvLGk7poQJUOYm+4YOTi+pdb2cDHix49zaD9W4zGaypdLfP9nfT?=
 =?us-ascii?Q?vy67EH1HtLtr7jmrQLbE6eXVFkpAgh5Bsizm2DlK4XVCmQTpl7jHy0els4Bz?=
 =?us-ascii?Q?+JZQKiA3Tsa5UI0G+Zsd07aUlvu+MbdsjoDz3YCDUO23749LJyClQZzU5FvC?=
 =?us-ascii?Q?+qH0b4p9Y53cJe+WwjR/FoTDdj0AmSRyWTpD0o0INs8hCrIftN3D46tJZgjo?=
 =?us-ascii?Q?F6oCrSThgUNR47DqQv/ll/OinTRU+Asgscdo9DF4ngKoMe/au9HYJrDzaLHV?=
 =?us-ascii?Q?j6+tpebjLZT6T26qk7NE5+KZahSGw7J3Q197I3TZ6th+BYwi15Qakei16m61?=
 =?us-ascii?Q?wD0LFduhhN0LKwyrwNPMUQcuVViY23TB4aieJSYidVvpvje4bf13/aCvUFtE?=
 =?us-ascii?Q?HhxHMEKqel5GXiJc9UYMuENm2CTfl7S1rx+YeOh3C2Irtwtv7m9mdkrcEH8K?=
 =?us-ascii?Q?YegzYDYsaUUGCjI7snHM5UCPVixzBFlyVmePV8WqaJgC+Ozhqu2ibMXpUIqK?=
 =?us-ascii?Q?/qVxrAKzT8IAnUT6rg+8YI7nTx6N82StsGYpYH2gOce4LU5DPXTyXnQWC0Qo?=
 =?us-ascii?Q?aIafSQFYSLar09LGUSVhp7KJS7yYqRjgZD0MGxnz+8LFXu8ZEC9bmEZvvjJe?=
 =?us-ascii?Q?ZGC6GlIWcB72y1AMinxEr3kIXHSAUtZKhYw4u+tVmA+1w7SRH+4x3bj1Qso1?=
 =?us-ascii?Q?tQA+1YeJwoBBehGdmafM6s3iCQXQbKSK2A/fkqKCm3AC02mdCxeOyrxPOQ0u?=
 =?us-ascii?Q?n27o0oXq/DVL/SdvSAkpYB3JrjyymQn4DDjfW/OPyq56mMog1zxKLpHArZYS?=
 =?us-ascii?Q?PE6AsQd6Newt1X1wdGQrzsUyX9+85Xdq+11pBpqdkavNdsuZRAHJeaJx2MGq?=
 =?us-ascii?Q?2Vtp9cO4JKL/qjbx0335iHWDqjCJSJCdBz9Dt62z0L00BTYs1zkwZkIMhW1g?=
 =?us-ascii?Q?+DJC+UgW5yb6iqNBC2dXkm9VQABdTH7p5vIFr5TAKOqQwK/Q52jTPwisbrg0?=
 =?us-ascii?Q?Upyss6IkZGG162d/8J4bSZ8jPe9d83O2csBwZ3066s8ubXolJYUYRI/ZdmAM?=
 =?us-ascii?Q?9gQHuneRojsCbaPNaED6MgxG7xyzNYhwjMmjBBvsy4NNeTDCp+TVOuUZEUiF?=
 =?us-ascii?Q?GBv4vfnCrtdRA9GhPqvigJAuyxnsdzAmOmzkY58ibCkTtTzEwHPxHhz13l5J?=
 =?us-ascii?Q?s+h1u+eCUuS4zBr9ZGgpenWredFEeDPOCfD1fUSlJOK7xXkUgF+N1o1RoZRA?=
 =?us-ascii?Q?qbNF+M9/NPfnu3C+zIPGn2gqXr9qfA9UD49PeaRz+ubE7QMQ+LXvqN/9zC3V?=
 =?us-ascii?Q?9LYlQ58Feun4Vm8v2LDqE1BHADRA7ihoejWY3riXpRkLdSxf1rR2/O7kKMax?=
 =?us-ascii?Q?7qG70vKEEIQ8YGw0IlvPYAcp/hU+SZwh2C2l8cQVbx4GChGM3v1aIa8nBZPG?=
 =?us-ascii?Q?VJqrcLyEiD3c31EaGzq/WruGsRu95OaMm2vAWqWZtFf8DayS0titvM1KbI1h?=
 =?us-ascii?Q?7wdx1qOCjVniwhQ+Idv3iT9SGEpyJ927PKRDMSvFeNo3zQNYu8JxRNI3ipGg?=
 =?us-ascii?Q?vMmBd8Ka2hDiyteZSmY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59f23f1-be61-45d0-ed4e-08daa658010f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 22:30:13.6030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oa/mc2yOkeD2hCJH8EuDHC0679OvIZeOhXZP9Qx3jgry1DaVdgbW43kPgmaWNQLq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 02:19:57PM -0600, Alex Williamson wrote:

> > >> v2
> > >>  - Rebase on the vfio struct device series and the container.c series
> > >>  - Drop patches 1 & 2, we need to have working error unwind, so another
> > >>    test is not a problem
> > >>  - Fold iommu_group_remove_device() into vfio_device_remove_group() so
> > >>    that it forms a strict pairing with the two allocation functions.
> > >>  - Drop the iommu patch from the series, it needs more work and discussion
> > >> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
> > >>
> > >> This could probably use another quick sanity test due to all the rebasing,
> > >> Alex if you are happy let's wait for Matthew.
> > >>  
> > > 

> > > I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!  > > > > Hmm, there's more going on with this patch besides the issues with -ap and -ccw.  While it does indeed resolve the crashes I had been seeing, I just now noticed that I see monotonically increasing iommu group IDs (implying we are not calling iommu_group_release as much as we should be) when running the same testscase that would previously trigger the occasional crash (host device is powered off):

Yeah, I noticed that when writing the other patch, NULLing the
iommu_group quietly broke release. It should be fixed in the followup
by moving the iommu_group_put

> I need to break my next branch anyway to correct a Fixes: sha1, so let
> me know if we should just drop this for now instead.  Thanks,

I suspect other following patches will conflict with dropping it,
maybe better to just fix it.

Jason
