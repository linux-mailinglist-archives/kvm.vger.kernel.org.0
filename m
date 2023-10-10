Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DAB7C00ED
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjJJP7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbjJJP7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:59:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E14BBA
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ie9W1/n+0WTxp3RWFhoVgwMEs4tZMwN8Qc/PiuiufVV/2YePr5S4b5LNBq+6mRiPpt4Oh5gvWLmJTSiHR95OQLn5umDmVcG8MTOhUI5vX4LJSPETEu9my4KTLTv4U0p3Lp/lFSnqmZKalHoWP2vqLp5FjdvXCSxcXicLxMIZtCVx/E3xai7O7aqVgQDcIK7oxfp6ZOeEBQlM2QL0oXt+YOIeiXg5zC4b7MJvEqk9LeqEgQm6bxphKLJKSv+iqGbzTvAVKb09JN6CZmk87LMA8/3/zTk/qY0owyazVoDSAvcsDTr9HU//rwhWeAkHWpEEyUaNH/2tshYCCrkTZcfYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=For5a9pyUD38pr44tCny0cEderMwi2n8mGp9UfgekTc=;
 b=Ks56q8I2QsOWh024Bu4owwL3WnUClfRK9CGuxA5w2cVLb2qu2OL7xo99rbK9UsevUMQ+0CSD6EDfVH0tULsY37XFy5rhpNa7qFvblZ6hjhkKWb+x1CKxn297jZiuocWlX7S64A1+IJZqcVM1nAW1yp8ZTddaXqxVNiAoWHlp94U++24hCJE1f/ata87j0vnOsiJ12rSz2jWJoicig8GEgI4YW9M7/W2CSfAEtVHEJnsvPLRNwpCG8TsQ80OPvyblPr62Cprj865RvvBlJZ8iYCW3orSleIglEUAOCvq1wSNaksnriisy4jI/KjcpHy4LLDZGkhCLoE36spBiD4XJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=For5a9pyUD38pr44tCny0cEderMwi2n8mGp9UfgekTc=;
 b=KwWom1fEU6HmRzpP7kntbh/Yd6WZf2/GkgU39V1iE+4JFsjAFuL3NxqG4mpuQUPllv38rSzjb9sTP4jRHfp/DNo3BoVnn+1b4EUCzJN3xce9HGlHxSaIWUsmaGLH9lb/nD364yexbJkBnolL8FSzTgyC6Szv/DWZsI5KgknCY1HWxoucppVDdbl9r84chHCx4sT4PzpoW9lYggNlFJgJCI6lUdBBSUx9pRQR8mkEpjVZx+JmBoCKZknyu2piu/HqJ+z2JOhtNuRsYUB/gNhhjdVt0leXEzUDT5vPmnSW+rs1sX+W+CGnpNoze5f4cwMr4KFFdEQkFtzGnnCnxJdYiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB8463.namprd12.prod.outlook.com (2603:10b6:610:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 15:59:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 15:59:38 +0000
Date:   Tue, 10 Oct 2023 12:59:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010155937.GN3952@nvidia.com>
References: <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010111339-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL0PR02CA0093.namprd02.prod.outlook.com
 (2603:10b6:208:51::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB8463:EE_
X-MS-Office365-Filtering-Correlation-Id: b140e7e4-b11c-4a36-d48c-08dbc9a9e848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IYjgUb+bogxVIgzrLso3RqYHAEsXnF1GDz4Po5Rnx5H56ydD7kYjz0duu9WVX0pUkcFMFBaNKCnqbZHHflCKB/iuLVBzpKF3fo4c9JZxl7Ywm3pGlkvAeIyaronb8duV5uWhUdMziDomBhZ/sXfdkOgZGnWQLp1BcnNtUZsVzLak4IY9v2HSffbKpUh0xuD+qkdOoTdU7q/3PEmLaCZ32yqxvsaLCZ6eNzUw8uJtH2gHk7CGO7A5sH3pEdrt1r1VtaFmF5NxqMY5QFl69s677LLYXqKtv6QymoftWJYOdCG49MdBLA0HO4ZfXK5znSnIlA4qQkqd+WuxLMTd3IWpt5UH7xAWeqLfH/9KmmcRuxSiZa1rYvRl6DM0cw8zpmukbxdrO17lsCAaIiFXYeMutnPLD74BAjFimxjwKaOqycYeDYJfyQushtRVg16jhFZew2VMuAF0+9kxlRWqnmwX06hevwqeGTKcnTQba4BKwRZxqdjJRY5P+wPbGi1nY7SCCj2868CKQ4VxT29pqPuHyvEG7ndWYNmbtj0n18TgSvqsAd81WtQhYrT0qjsM7tV1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(136003)(396003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(33656002)(6512007)(1076003)(107886003)(2616005)(6506007)(478600001)(6486002)(26005)(83380400001)(4744005)(2906002)(5660300002)(54906003)(66476007)(66556008)(66946007)(4326008)(8676002)(8936002)(6916009)(316002)(41300700001)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xXsEbcB8bXD96hTOl5Zpq6b5YiKRfS9VH428UPUj1wC/zexuRAZPCbH4RwWP?=
 =?us-ascii?Q?CCRtjmn+DVpgc5ZFl/WOBlMCLnW5raG2zvSYl3DHyUJQ9MrdV5zH8ab+Yxr4?=
 =?us-ascii?Q?YsA7dOpBCKM2gK1owU9StgtL5nHSTLCGMGubLMho7d5HUlqwcir2YB8Juc8l?=
 =?us-ascii?Q?GOESW54EETMcE1NvrT8c06j6CxoScVUadShSsJomjc2V/SSEzgc0lB7VpnWx?=
 =?us-ascii?Q?6yy2gFVuRMl26bI+ETEiVqKw5Hz3MMvrOmE6rWNHB6oU7IT9injFrJgQOoZY?=
 =?us-ascii?Q?gPTGusm+/XMnFwU5JWd45WEm2LeUQFZMCibglZHg4Wp+3nHggO2z2v8R+ChW?=
 =?us-ascii?Q?hk1UgCzTDueNIW6W1D3uz4NzViJjxo1F94ohT7HKIBD3+Ogy+gD6WhT4kvyU?=
 =?us-ascii?Q?IdN8YJ+Lcpwof2UMwX8N28ZZAdVJenHWoYcwr+xMA7Toi7/7BRSfnDAIro3p?=
 =?us-ascii?Q?WkSZRkopBa4XfK4cgYfmfWzNxiqb6Mf7L2vRn9tepDL5gwiykMFDY/qlMkxs?=
 =?us-ascii?Q?HbjiBQ3MyAaG3/93eqXLeaB6nAPj6cchguWdHx+om3pUEE7i/dSYPeOXtRgI?=
 =?us-ascii?Q?tZUWFDRTji2Pm3Nmla939DjNC9lCfUc4rij58pPCOdenDoFzKDqOcjGqq0pK?=
 =?us-ascii?Q?mLZuZdAccTqclX213RPxGmanDohGGf6aiBdiZg0lEjX/hX1Vgn5lQbiMXOA4?=
 =?us-ascii?Q?lIAIBP13hUqWyA5IAQWpU+TxCkWRJl1BKh67Bcm3b+Ib2ikMCxt06CeU241E?=
 =?us-ascii?Q?ggdDCpLZVcQQiC1jbHtNtE8XLBhNNt+k3jLaDjlMuZyRljlzLUZqs7Qje5wt?=
 =?us-ascii?Q?cqIh8jEJ25yEuuUW2s9DmbqJ6V0sPaSOhY/DM/d4dQgzP+TcdAvYb4JZJkQv?=
 =?us-ascii?Q?5HL0/bXyFERpg3w66wLHsLq1FhPGdP5LxvOV3D6CJSkgGCXr5wgRPi8tjTST?=
 =?us-ascii?Q?JcgItoQgykM0NFiB61SExtt/S01C08cRvOB1kS+RyQfget2XNasee3+r28VN?=
 =?us-ascii?Q?qx2ZqZr1bKb4Mvz/DJRxOdm9T3SM0tVqGXYUNL+SUGwHl5gMsnXjlnYokae+?=
 =?us-ascii?Q?P4q/DvpJpUicqtBSybzUlEG/qr5qnX1+zqFvmaEU/1x4IydVviOMJkTsoYqn?=
 =?us-ascii?Q?ZdyTz7uZP0WIzq4VChCk/tE4PHumZbo34EwowJzfsikgQM1VZy5qd5EgEfrK?=
 =?us-ascii?Q?5lt9KUD8nc/eaMmJQwNagcDiJosraki8WXAs02kpWwkxx3maIn1zJE6EXcRw?=
 =?us-ascii?Q?+CWUyPYOTRj7XeZ87IZUSlLtOSf3SMOES7Q/PXnQQktiKVI1Sji71TRiwOkL?=
 =?us-ascii?Q?ssRzel/cVQMcLqnbGCEChFLiCh5kg4QCudrRAXVuQPAeXDW2izXBD4TMtQEt?=
 =?us-ascii?Q?HtxEK45eSfqbImWwYDC1O8IMdbUlFKLpaG7cH0UphFK2HKUhp2XT6tCe+GzW?=
 =?us-ascii?Q?Nb71cxNbKxEKJ77duVjkDlPMmVuA4Ym9LEJDh+xbIe4m1w/oDZgudvQLRjWZ?=
 =?us-ascii?Q?0H/IR/kHdd6XiP9dryTgvPZzhaRFLqnPbKGTSGdIOih/MFKUr8zJQN1iYQbR?=
 =?us-ascii?Q?XOMEtfA9tiimq+8ryLEJLJNf2oxsCU6NPIzrs3e+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b140e7e4-b11c-4a36-d48c-08dbc9a9e848
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 15:59:38.8243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOb/d9S1YRT/Ll+psXCD4q8auWOVAMnJsfczqOaqGPtFwomC2Hw2heJUb2j6CFhR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8463
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:

> I suggest 3 but call it on the VF. commands will switch to PF
> internally as needed. For example, intel might be interested in exposing
> admin commands through a memory BAR of VF itself.

FWIW, we have been pushing back on such things in VFIO, so it will
have to be very carefully security justified.

Probably since that is not standard it should just live in under some
intel-only vfio driver behavior, not in virtio land.

It is also costly to switch between pf/vf, it should not be done
pointlessly on the fast path.

Jason
