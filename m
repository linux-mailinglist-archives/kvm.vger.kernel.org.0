Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F02419E54
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 20:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhI0Sds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 14:33:48 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:61903
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236012AbhI0Sds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 14:33:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVmFFFYQN+YDxK7yfiRKLo6wbNIh3a1cB8TPmtYwXE7xy/NrrC89WUgsCU0Lf2mUa1D51Qdzj0EObogCM7ygIdpKsZV0e9oxXfq+loEI9nadn33o+jEAJ6MT5y4VETG1fHbXwnUPyZFFd6X9ZCMA3sk76lWUGb9NuHS8Virumgeeth5BF0rDFAaroiGvxrp4+vn6P0PVHLKobg/JhaI5NtJIAZwEEggLRPiQGNYlOmtSNiiaevhnBfqhfnbyh0CbqtKNfdXPwvzXQv0W1jNStJLoZhiU1FF/23zv6WKj1G6txTJcJi0udIGe0V7GeHfWlsxhXORoZmPxP1qJbw9KNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WW5ooCygGrUakVDpH4aA+5b1vF0nhNZ6+ILbdlPsu+w=;
 b=lvskQnoQ1yQevHvC7vllmP+T8Dh+8+VFeqNexIc8Oe4lHP/z2mPiW/zfH1l+RCz51Je4gOnLU8wmCpCQsW8aXYgMB7F/QSn+79T+wTY/vNtuP7hRYIGRuSfMknzgxF6tCNeE5lG+K6NzCkMpiDx6ab1CMnzBLPXcVmXgYLAkxs2y+9nAeZ6DPUFxZz40miqNfFZgyhkqg/uIUOmN1QKnuyOxgZewUhbC9Ji34zocPCdnhvWHScc/dfdmdmdQ0KhD6Zr8ICeSQY7B9l0VDj4szKQ8/RCGO2Fgg/vZLA2FMG+nQEfXar3qe0Jzr0cLLpY3AJz/ZJ5jBUiNfGjMna8nKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WW5ooCygGrUakVDpH4aA+5b1vF0nhNZ6+ILbdlPsu+w=;
 b=BDYOB2RP3JH8UbtZoYUdXIrCdu98CXqZ86MUaBA6NXGtNjw3GB5+XwLYtYqMiZztAlRM90vgsvc52Dm9yOkBUaqPIx/dwumIK34mAwiqSm8EEPa+Ow7eHal/OAsizbL9qbiGlwSTVdfJPBL6P+TZvnncuu95UvqSlOdnqxiaKU5/r1bT1835vdi0WvRafPNqg4auq5t9il0CJfVu9d6sx0g6Y9kvBd3IHH5qZHm1k96/t7EeaXhEMaAWDJB1qrbWW8zM0xq4gi97in5VAiv4ZRAP5E2VJ6d2gCbH2HFfNVfoy5SMPnyhKeLP7DTcUJuH4kbBuA9YKGV6I6sFHt132A==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 18:32:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 18:32:08 +0000
Date:   Mon, 27 Sep 2021 15:32:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20210927183206.GA1576241@nvidia.com>
References: <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
 <YVHqlzyIX3099Gtz@unreal>
 <20210927160627.GC964074@nvidia.com>
 <YVIKr48e8G1wSxYX@unreal>
 <20210927182224.GA1575668@nvidia.com>
 <YVINv17OEHplrpeS@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVINv17OEHplrpeS@unreal>
X-ClientProxiedBy: BL1PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0224.namprd13.prod.outlook.com (2603:10b6:208:2bf::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Mon, 27 Sep 2021 18:32:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUvQ6-006c4s-Tv; Mon, 27 Sep 2021 15:32:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b94781e-5625-4f86-9153-08d981e51cb6
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5554FFCD272E2CF383E75055C2A79@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivwo7hJHqmD0lRE0cTt90+xQ98/OIAMKAxfk6Zd8DJIf76kMW6zYe9xUjvxUzoSueBGgdeRIn4qLmPGkKLll7jMyQcir9ktcOIfX72oyFvzivcSguhavpYz/wN/OjRN9154KuvWVvJODlDn0B7jHLw9tq8o4Inh0NKfBM0bY07EWO5S6U+QyWA9HfDPTxgynj/brBFxqvFjhks+Rwf1t8W7KJ5BsEryePujeUusOFzrDuk2Gza76+fNCR9EnvEyR0bHQHCfWbT41smJcnqz7UawS+6NB9XG9aCpYtGCaORXai3yTIBktBSt6wi4bWsC3XNq+fWKzNrHpR6RpMNjIV+o61DaMSKJ1RHupzY6+YzhspSkWPUw/Zdfn+freI1LtZvOiWZXb5muTuYQW83wJQG95iXSDbQJzE26z4kfHhpvheRu8l553DvZIV2itb5/dLsR1Y7KeC1nPziiW44gLgNLrxBE2vpqYvzQww3T+qC2WmLoXpkaAAMpPy/zYMrv/Gyqdb0JyoYoCvC5I7L5J47eP/8JW7RpqRbAd0K0vGcchd6A6XuqyfolSqbthwPdZYkisuBBmNQkQZjUnRtdOLhts9HpFSw/mBDr5b1v4PeioHNcQWUC8m+ggxLHmSq0gfqj6wM5NkS5bNXvND24TIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(508600001)(33656002)(26005)(36756003)(6862004)(186003)(4326008)(66476007)(1076003)(66556008)(66946007)(9786002)(9746002)(38100700002)(86362001)(426003)(2616005)(2906002)(5660300002)(54906003)(8676002)(6636002)(37006003)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WBPy+5ylFhEb56ePMrHXtogaRAo04HYABITEr7nn6nMDtEI0hrVLJuMeOu/l?=
 =?us-ascii?Q?1+6c/DuEztMlDPbuznB7/ED3ffhMcQ1odLiJRKVrBycI8wTLMmSc42ck4m/Z?=
 =?us-ascii?Q?ROaLw51Oti93MFWGEmilhdh3AKRvyCADuBZACuYXJolAqIDsFcIVrl2ohLOZ?=
 =?us-ascii?Q?5Wuklche4D7Fs+mCspanw5xoB1/1+lgfxNo8sfO7E4IviHrb97iGinfe6azY?=
 =?us-ascii?Q?m4ZT0kywAiYVqV6nazWs7dmRcGQH2y/BwWWc1F3vlrKI2j8/xBFqt4lqAuOx?=
 =?us-ascii?Q?6I20f/DcteQvXWFlXNqxGMcgEkT3Eh2vqIxc27FzfEkT7RquFg70NaLubNEq?=
 =?us-ascii?Q?2z+hdAtaQf9HFloGsEdjDZTySjd/YNSr04DI4jakuw8qCQq48lYdIG29HV6t?=
 =?us-ascii?Q?7Ckqe4BXdGTWT6IZtYk783B1kuGop+oycJYoWfKwozr1UKFpBXFcdan5Ed4K?=
 =?us-ascii?Q?PIB8j/HdF1NMon8Q9coELk7HV1VUp0EosPuQva9ql/RQVw1t17C6q46HBgpF?=
 =?us-ascii?Q?gh71UwLPDEVVbHt2UKodET2cicVAo655QikvifHEVBgqvoaLi4P9bVuZ9emL?=
 =?us-ascii?Q?VG8LSYFUBK1E/+RgbESMLUeUtAqHL2++o2WVVQrmWyJkGuD9tl11UreCzi1w?=
 =?us-ascii?Q?kIP8GZsOTIrE5I3ESl7G7GhT8ZccV/l2GAUzXZ6WxN4Le3Ia+UIeszBwY1Bi?=
 =?us-ascii?Q?2ERvwj39SBbOM3l/v08srkwfdTbqDr7NvRyY8aITGzuia4xv0GS6CZeL1CFO?=
 =?us-ascii?Q?YeMacNMLqoWWu/n+qc8lbpONj2BIh7i+A14D1h1g3nrHcplb8G6N/Mnv+JrQ?=
 =?us-ascii?Q?RKnm61Gdux781a0y5mxS8wiIqcNRrkyJ+ns6sP+zLwWMOCh2/2SXA6CMkFd8?=
 =?us-ascii?Q?vlHw1dH2RVci0uFTQVb2MhcfL9wt0d/2/mrHzZSyijeUO+rRu5TrrJ7QJMZH?=
 =?us-ascii?Q?iDzSe1RdxMNdABRG9r4fqiJu8/tiNIpAjNwXL4/bM4b2XJT0xqCnLZOKS4e1?=
 =?us-ascii?Q?p/VyTP0XWPhJpYh9EXrqjqL41fuawgB1pLM/j0N7r+hXOXIR/5IeC2ZOoF2i?=
 =?us-ascii?Q?4GR/DaECb5F38ckGLQNot9aZtvoLgd8q9fHCcTeU6EehHF+pLSD5uRDidi7E?=
 =?us-ascii?Q?VSM7oTdM2G4zjHFrBDuQ40IOBFId+4dNpQM1w8MVeXKgEe814DfrXWdZR2mI?=
 =?us-ascii?Q?qgRea+eae2Rpb1LTe/yofqggrfYYl9t6K3YhmNK+eb5mzYNapOUwm0MMakNR?=
 =?us-ascii?Q?uFRjaqECrHjR/jrj1vgfrziq42e40q+7ftQ8tX7XRTcUmJ/SDixIcxonNKX6?=
 =?us-ascii?Q?LCeXqmGWI4cam6DUdX7JGY/d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b94781e-5625-4f86-9153-08d981e51cb6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 18:32:08.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8E031iIiQkMSK7M5yTN0DUO2AR5pyy1W8WE6WGbJxfI5jmxeh2pWIZNF8fz5dmak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 09:30:23PM +0300, Leon Romanovsky wrote:
> On Mon, Sep 27, 2021 at 03:22:24PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 27, 2021 at 09:17:19PM +0300, Leon Romanovsky wrote:
> > 
> > > > The point is to all out a different locking regime that relies on the
> > > > sriov enable/disable removing the VF struct devices
> > > 
> > > You can't avoid trylock, because this pci_get_sriov_pf_devdata() will be
> > > called in VF where it already holds lock, so attempt to take PF lock
> > > will cause to deadlock.
> > 
> > My whole point is we cannot use the device_lock *at all* and a
> > pci_get_sriov_pf_devdata() would not have it.
> 
> Right
> 
> > 
> > Instead it would have some test to confirm that the 'current' struct
> > device is a VF of the 'target' struct device and thus the drvdata
> > must be valid so long as the 'current' struct device hasn't completed
> > remove.
> 
> I'm curious to see how can you implement it without holding VF lock.

The VF lock is fine, it is the PF lock you can't take

And you don't need the VF lock or the PF lock if it is called in a
context that blocks VF remove() from completing - which describes an
entire VFIO driver.

Jason
