Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B83F3A681D
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhFNNkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:40:25 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:37952
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232966AbhFNNkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:40:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZVsSv8e6cJzriqljjd5jvWXTVoueL9bDNXhOkJj+X0waFq2WmQsq1uJutx95hHwgy37zV4tDAtB6M0W1r24LbTkZvyfZDmXjOuWaLF60BSeKlDVXo4TQK46MsgROnX7z08dbqHCSRsbnfrXGXQCctwD4U+PmcVlEZ7s2zE4hIcllkTBSxr4rYD5kYDsDSy1ntC8dPUzfGLp1E0qKiBraABCSUZpR4Se/PzSj/SeluWnyhkfTVtgqD47BPu17/UaQBMHuSWT/cr6ffip7p3kKSxj9phQ9Z/7xpRzAJT8NApzqTBnQOskDL0gN//QTRnh7qgzrk0alUmGs96IR18IKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikqX3Z5SQdfU/Cq9/yU42ZzpmojnYj484coD6T6xhlU=;
 b=b285oBbDtldW7p0TNeNuPBKvezmFKft7hIQhwDltj4djGiz7mVm05n8S5ZBEwAN22A19d9yNwZ0/emJz81BLUcQChys4w1Oxa/uQNE9sJVj4Etnhtk6lQyL6tZbM867OA+0FZlo1DYMLvL/QCHYYJop5aDW8cab3C+0++TqMI4HL4aiCtiqUuliQsHpA0thU60IB3kky5YMcKhJgrMIitL5oeevbQRgvZakse/upjZmZyY0ksTEhE7biQN0k8t4HQwTrcDifPMsyGhayVTZyTpuS9/FFBrb+ZGWH/wGKuy3zV+q630AdbPn35qSdvE8Nny3E7lcbJy6+/b7+R/qPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikqX3Z5SQdfU/Cq9/yU42ZzpmojnYj484coD6T6xhlU=;
 b=nOkKMZKjpbaUGAEXpyMLX7PTRnm3mMrfGqMOXR4uqqOoMH52mBoFRmOVfLuu53JMDG/+cGyOJhRWJyh48xCNSlq8XNVifMq2tRMKDg/kaq3YKtIGtFUMvW+jh7tzBgk8WYo/A2sOzd6IeABVrluSiMKxb6sn+kt8uNZ0RvypUFCVb9bMDRdldHLFOfS8ist7STV3s0MFnlmlTMCBd6ffV5VR6mN3UVtjOqo9hryp5LobjLV5QqiLUaOXtvjlDZzC/Wv9WfvrO4w0KJ+OYbcNy1vq6nsCUq5Yd24eEqvIpjB/Ty3KgKYj7iUoos+rCABBm5p4TCOIP7Zutmu2MkdgZg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 13:38:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:38:20 +0000
Date:   Mon, 14 Jun 2021 10:38:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210614133819.GH1002214@nvidia.com>
References: <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
 <20210611153850.7c402f0b.alex.williamson@redhat.com>
 <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:208:15e::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR17CA0014.namprd17.prod.outlook.com (2603:10b6:208:15e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Mon, 14 Jun 2021 13:38:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lsmnD-006dAj-B8; Mon, 14 Jun 2021 10:38:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b3c7ee-65af-48d6-db5b-08d92f39ac6d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53639AD14217913689CE80D1C2319@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KMaZdPTUVOIob8vWcGdTqQn6ZphBqjJEcW5A3w6laZis+ykmG2p+TMCsKKwg9N6QTPU/fQ6q9ihIPACnUhXxU7db59CtTJMS5Mzx0j4UcZN/pzFfhihI69ooGsB8UkVCEkU8XjaogHg74JfSGWHwjQL6FHpC6YIC92xwMx0yMEHx+Vpab5csSSthzQvLaF0DH2bWRQOKCrcvmC8T9YaDt60vGIwHe7IdigcaYReXn6hKAKgwk0zxMLoHZk+zOnMSFpXlsRxNEGthbhWjE5ttenaewyKvdlX/b7qPNuon/9tfOJVwWmBW4vp3Vsw08/LoX3da21pecJw+IQnnxx87YRZRboJmhz0ObOht3aHvs40I2EEaOZirnhaJjX0dQqHLQnhr48OVGP/L7SuWIwA2Dz58gLpNdVlPgKCAMS2cTSnpGuu7kEJNiJMshoeDale2uv/1MyQtldOVescrnP6cqAHnwmujpsZD9yVWTpjnO37EzxSK8l2wbMdq3qcpJJQs4Q/bLn1/zMMGnFj9h49Tk2Bu8V9duNfSx5h0cz0MgGOLDgHRnSpPouzRLsPExhR6bmdxAwbAR9hXuBOMXYgn3UiNWaJS0Tde3m4ziJLlUas=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(26005)(54906003)(8676002)(36756003)(186003)(478600001)(33656002)(86362001)(66556008)(66476007)(316002)(66946007)(5660300002)(38100700002)(83380400001)(1076003)(2616005)(2906002)(6916009)(8936002)(9786002)(9746002)(7416002)(4326008)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c0PtKz+QWHiHKdXJJop1VVbwe5XwYmbViXYpkZyDfZL5odvbPtKo64+opuM/?=
 =?us-ascii?Q?yPojGgcWz1QkCNBggNOHCzuGLABEhjQSETX72N8v0Wysu8Ym0Oie73m8HXxZ?=
 =?us-ascii?Q?O+YLprEs+nBWdAmYOPf/7idI7PwxNrwLmn/vcM5YdV7gRzyfKxEGHNu+OPvp?=
 =?us-ascii?Q?ybORW7HFd83wXKSMZHYSATwLrVjO72SOWnj3zldBgFP29ASp5QS4s7sh1uUS?=
 =?us-ascii?Q?GnygjxtaJzYezq9hM2Hkj/RQMST5IlV313Z8uBn62mmGfk0hQBbg6ywXwKcU?=
 =?us-ascii?Q?WN6fk/kQhB5ILPxgWsw069pk+uwYVkOxs0mzNKQ1N33s4opBC7nAvU2xXkPw?=
 =?us-ascii?Q?GAbozYVkqEdCl1N/QzRnxr6VrRwPxTPdaFp7S/eUVoDWqoNU1z9AQMatTuGC?=
 =?us-ascii?Q?ERrk7DORW7ldHGI/dRr2qaRdlXPIGpk9ICJnxg6GDXhlsjkjEkm5SBUD5E2d?=
 =?us-ascii?Q?Nhle2SbDbuS0LN/u8rzYAdzFBGUuPuzfFCRH3QXeDVyRcB/a18K+u/NU1FtA?=
 =?us-ascii?Q?u0a3FvxnUnrNXCOVDPc6bmKXVCY0wuqc0MR0KFCbPrbIrvSJsp/l0VXMhGVd?=
 =?us-ascii?Q?Nit4RLAjULMnSz84YZfaUyv2vWqX3dQNpQ8Wkg98n+6cFB/rQuS9Zp4IGl9v?=
 =?us-ascii?Q?it1zZAOENMDw5xQyOaJwYEhPHM5Yo57V+szbE2eFp06GTQLddKhpps0AhTIg?=
 =?us-ascii?Q?URohmMbsNGYNcjsDCAN4AEhlrmHQLcoWZyKnrlO0svdYg+tNFC+tT3mxpRA8?=
 =?us-ascii?Q?jmVb8q7oB2e6q7rRTw1SUrb/PfeonPpKaINw4/0qEEkwKqezUhGj+mSToBgj?=
 =?us-ascii?Q?nyUz4FDcMJJnrlEBaG9dEKUVrPMZuJLusJ3bJoDIWb8BTSA4CHn6ZO2Q/FI4?=
 =?us-ascii?Q?GzDkxJ/RAeBbiIdkaLZrliz4/NJzN+9kKHTDGssHwED2fed7sbxuqZbVRm8j?=
 =?us-ascii?Q?dWIZkmcs42W18q8RlWog+pJP7Kl1cPop1ZSqqABZqrFllkLbYvMyjPtJC87a?=
 =?us-ascii?Q?aozokeEaHoxwIwsYE0jcshT43DYzSFTu5OZu+1e0CNM91UB0qbH84kqqLLHa?=
 =?us-ascii?Q?RpHGF7gVchoSvGTw7KIjbjz5XwpiKLuu9ZStlah2XcaVF/1KI4Dm550Pqgff?=
 =?us-ascii?Q?bNXDxml6TTVDkDO3X8XrC6Y5FSG47ane0nw0eCqAljl0f0HbSgWDuM7mwBTd?=
 =?us-ascii?Q?9hETefPx9StVOUFNprfu2gHIYArlZ3q5DAEh/EuZ06az24q1GAYexKAS6GxU?=
 =?us-ascii?Q?Jt0xIED7PdafcGaVLsKuWa+pDBa5j/XxUru7qDpcGsTJvP/UFo1PN3Y++xvX?=
 =?us-ascii?Q?ts6xTKrdGrDAkoFJ2IKrSnjW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b3c7ee-65af-48d6-db5b-08d92f39ac6d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:38:20.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFa5PTwD028a8anGZAo350/4tw8RIR/uJe94UgDeBRQiqgyBP/sxVIWOMwP1QPtp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 03:09:31AM +0000, Tian, Kevin wrote:

> If a device can be always blocked from accessing memory in the IOMMU
> before it's bound to a driver or more specifically before the driver
> moves it to a new security context, then there is no need for VFIO
> to track whether IOASIDfd has taken over ownership of the DMA
> context for all devices within a group.

I've been assuming we'd do something like this, where when a device is
first turned into a VFIO it tells the IOMMU layer that this device
should be DMA blocked unless an IOASID is attached to
it. Disconnecting an IOASID returns it to blocked.

> If this works I didn't see the need for vfio to keep the sequence. 
> VFIO still keeps group fd to claim ownership of all devices in a 
> group.

As Alex says you still have to deal with the problem that device A in
a group can gain control of device B in the same group.

This means device A and B can not be used from to two different
security contexts.

If the /dev/iommu FD is the security context then the tracking is
needed there.

Jason
