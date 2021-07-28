Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88E63D86EB
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 06:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhG1E5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 00:57:07 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:9363
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229546AbhG1E5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 00:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RltIEuXiBcYiavKIeKQ0TUXHB/T2apxOJq3DfptsR+feLH4NFJTx8pwC3MhFEfbOsGDjp6maJgjSadleZusg0yVnuRWnaftF793fIoPY5DgveCCV1au8fBtPmfetC6B3zMjAKeH9PqH6S32rLL1DImlAZkQPf3fr/UngXLoPYHbtaKc4y0LlnkcZnp35AlZniopBrxF7GzPragkjbt2/YCJLgMqelns9ypg6pulmseCfu6vXJxxjeJxI+YYC1OEt5frMSvtjnEEMKPQAzIeXXQk63J/Jwh3JnQLUliG0BH1urMh7E4DyTJiqWcmiM1hedQou2M7icv0cdik6A+F5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UjjBt+xDnNQ6Rk+4iHYnLXeE0X6mM+IUr+pD7PdDsI=;
 b=esH82sG1MFJchV8hbx40VP7cINNtjYUnwGxgUZ8QehBWKf1d1LLCKFr9H+NktqhRnDzLJ+G/yCVa0bRVpT62K+3NnoHL6WyZ1Zn3USsfe8i/ZecswMMkMT7H5+vBrnsUEmg1xj7lIO3Ty63dmbWHdslHvFaUetF2J54QXF3G20BgkLL2J0tK6pD6Rsk0op750GNSO0r9sS+wqzzCHfHd4NW9D4RXtH3knZ84zuMHYIOcFgJRr8sooMaD/+Zu9RBqTW70GWPIsLwD+qSjI3L2rccAS1+6fU7h3tzVhY2Go4CK6BfD0Ruy8hsZ8rKaFh76qCu4YjYFw0aR98F+1w0U/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UjjBt+xDnNQ6Rk+4iHYnLXeE0X6mM+IUr+pD7PdDsI=;
 b=l2pQzJO8udiTw+hFok9HrhjGcD7ZqrgXcEOyUisFVk0yBCoWxlCENruwVhMeIbJYh1ZC2WIP1ng063ZVYYiJX7GQx5ArOnMMu/fP4gjzxVVGOZ6ocAlQR+8E5xa6JE4tNismnhQ7pL5JruGakE7GBtU9B5S8GMpaobE4JqR1+B3Ceq7IK950HInX9Kt3+60yQe8e/4Aj1Wrv7Omi1fGR8QKWE3/KFtgnGPXRVpPfGkU+j6oswuzuaRauKQEdSpYCjIcFKfRnckX+COyVI9u6dF1ok8YaEGy9wi4h7ppsxqWB5Frwxlok1Jub2vERoq6Lx55GPMb5fJ1uRE0+N2WgpA==
Received: from MW2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:907::28) by
 BN9PR12MB5321.namprd12.prod.outlook.com (2603:10b6:408:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Wed, 28 Jul
 2021 04:57:03 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::5c) by MW2PR16CA0015.outlook.office365.com
 (2603:10b6:907::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 04:57:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 04:57:03 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Jul
 2021 04:57:02 +0000
Date:   Wed, 28 Jul 2021 07:56:57 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <corbet@lwn.net>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <maorg@nvidia.com>
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <YQDjmep/WQmOx9jD@unreal>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210727230941.GL1721383@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b2c4f94-01ee-4957-42ee-08d951842430
X-MS-TrafficTypeDiagnostic: BN9PR12MB5321:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5321926D1E7AC66E9F97E142BDEA9@BN9PR12MB5321.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ke1IKEcf2gGG0c2yn0DrciFMs5ZCmiaeuPogm1M4Ol4ibWwnLraFMnk6qEPL+ts1Epxc/caae7wq5V1MvhKmxuqezaKvLqcUvVJvsIAC2lV5CehO9zk35fdWNL4dqh73a2vNepUMpQH1v/mDCbFAynZXHhOzskz8fiTz6Fx6X4IvVxKfK/L5dHGyONidlBPA6Ib///a9MLVqYm9vM40qvCX1kdFfnUDF9UOCqmZvHsV2O955+tPb5lOCDyBQrNDVOJTvZ6EQPsuq0I8aKKLIO5xCIuecRAXjoNXgr1V+xPAOPQBMmzmZQTMAgpBf8KXoIAK01fxb6K0uK0a//TqpizsugHVaFGbGqDSXc0x9gcBRCf0KhYUbWJxsIEAmOyW6EGDk6QBXwpvz5+8k8CrXEYcXsOYyrRBqxYs1l2mWpOnUO9zliKG+yxcMVKYXBwm5asgsiPzsPgaUdlTrITPIta99JHl18H5uUg4HPHxflCymtqpQoqgaV8pmKpUSDNzjscP6449QGfF0Cf7Nigu8haL9z2PqK9hKy/UvpwldzdPO3ZEtHppU6i2R1v1T5/vapR+yObgvmOoYdqsBflBtD/4G7TnGKLcHcDJzJV4Q8+tpdCapKfu+F30C5JSChEJkrRC4aJEjIbMgWWQUbDg4m59cFIO1HITc93kwxNlGA842BJIMbDzwBvB4gQgbajGqbn82rw67w8SvQEX23txbA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(36840700001)(46966006)(83380400001)(6862004)(47076005)(107886003)(4326008)(508600001)(70586007)(356005)(36860700001)(7636003)(426003)(54906003)(9686003)(86362001)(8676002)(6666004)(82310400003)(36906005)(8936002)(33716001)(6636002)(70206006)(336012)(316002)(26005)(2906002)(186003)(7416002)(5660300002)(16526019)(4744005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 04:57:03.3252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b2c4f94-01ee-4957-42ee-08d951842430
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5321
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 08:09:41PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 27, 2021 at 03:54:40PM -0600, Alex Williamson wrote:
> 
> > I'm still not happy with how this is likely to break users and even
> > downstreams when upgrading to a Kconfig with this change.
> 
> I've never heard of Kconfig as stable ABI. Christoph/Arnd, have you
> heard of any cases where we want to keep it stable?

Of course not, otherwise we won't be able to do ANY cleanup in the kernel.

> 
> As far as I know we should change kconfig to keep it working properly,
> eg by having correct menu structure and sane kconfig names.

Everyone who upgrades through source code and needs rebuild kernel
should be proficient enough to enable/disable kernel config.

Thanks
