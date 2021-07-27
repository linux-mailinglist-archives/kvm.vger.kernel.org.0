Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB63D7537
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 14:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhG0Ml4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 08:41:56 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:39578
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231840AbhG0Mls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 08:41:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ev4AYwI1N9b3s0YpmLoAADlYtYmec+mOu1S/dj8rv1AyUgJk1WAqBzyN5CFdXLPqf01ndBT03ycuYGqv/iph79s8CDMCzInE8pTmDRGVYFmCjHDzHSWjZGUa+NdB4bdsyepgQjexNyzCgbbFPlLXwtc/KyN8GKXvHovWZBMkHnRsJoXyp6f5CgUot9ehYS0vmqNu6xbN1EcAc2hB5OaTSo9CRx3MqVVd9fJYkRiccJEHCwcyrcQFmEnrrIhxQXru+n2qR2/jLll5w61+D4jSM2/MAjOc5oByhLsNMrfJPPpByg1aTtUK7eZHghyhmFbNG4p0HUPDEJP8rtrN5f/Ztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRn9SpZpGFFNGVp/Q3C59sS8RFelpElqPJZnocEGMPA=;
 b=U55aIbZ4zhFLfsspUdRgNIYF6f89hy5RCYcUUxshXDkgyWDuCpH6bjaxSNn31RkUAE6oNYFu4bIuy2Y0h6YUvLKdKJnrIaU3hv0N5O2JOwXkxwMfsfG2i6oIYPFSYl9RjvM2J6dwnzrssfhHIrcmeDXANBl7DNsr0Rhn8EVjXndarCToP2GYPJoutOgqa7lHqnsGr8+45eEwGrojbXlA1/dqB59nmKrHfri0aT5gafmDA7bAXsv7E8ZWMK1BnBBdjWFwh9077JQ1Fp+yFO6FuacxossoZFlr45QQGB/oO182YPgOyWkLjiI1qmKa73YS1xTWYdJUcz4crmJfl0pfzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRn9SpZpGFFNGVp/Q3C59sS8RFelpElqPJZnocEGMPA=;
 b=G/ntDGC8xvI73i+92T4MpgD1lKkJ0RQuwT8ZJGDsjXhbpZI2wYeSihva7o+WKbJeCiXfmBi+tXsBXMr+divGFSZ24AV/sLphup7E5IvLkfpgj03FEcnEnNGB/3Utwhq56LJJ3EcQHpzNMJc/4uDFfQpfCRzXrVaqCOfbLolPHIyjhtrs8XrQfuCMIKgLjGMRyGMih3Yc9/frZueDLGvWCNs3hjI+Xvbw5VEQ0AG6iGd2aE3nDreoo0IDIHPWBaM60jnSTkGjAsHZEZf+nVTH8kDYoPuaP7za3yEj4SKrdMCHovlWr8J9e8KOHkMe5TO5rhZEVm9hA68kh0+si/10xA==
Received: from BN1PR13CA0003.namprd13.prod.outlook.com (2603:10b6:408:e2::8)
 by DM5PR12MB1514.namprd12.prod.outlook.com (2603:10b6:4:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.29; Tue, 27 Jul 2021 12:41:47 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::15) by BN1PR13CA0003.outlook.office365.com
 (2603:10b6:408:e2::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Tue, 27 Jul 2021 12:41:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 12:41:47 +0000
Received: from [10.222.163.31] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Jul
 2021 12:41:45 +0000
Subject: Re: [PATCH v3] vfio/pci: Make vfio_pci_regops->rw() return ssize_t
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <b555700b-ee40-9f09-690a-354668a6e39b@nvidia.com>
Date:   Tue, 27 Jul 2021 15:41:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9348de64-1239-4a4e-c86e-08d950fbe5ff
X-MS-TrafficTypeDiagnostic: DM5PR12MB1514:
X-Microsoft-Antispam-PRVS: <DM5PR12MB151420FFBF44D7B38A5780FDDEE99@DM5PR12MB1514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zo7dLH1UTwrezcf6m2517QZMUL4X53hNbJBOPQwYiW0WJmdgp8JY9vUdYTlYklCgXs+j/o47fnhfw0PBMVCSjoNCbOE54faJTXUpUeL6H786XW4m9l9N8uhPQkJHRLXhJXviJGRJ4Tv6LIVieYp+jArduHnkaNia+z/biZKvEwf70xDSBRL4l0q/haE51rqZ5ejnsoLj9B2hehkmIAuforJZWlnVU6Z9DOusU2tiBg8vezKkbsdyDbTy1daaA+yNXaj3mcvJwQN+c25DkgEIaMex9g4mEUOtv1L868As/deEeE+QTxMwLCjE+nNb0myTpDg5oSSLcp+3L3B/1MwF/yYZpIba7BwgfV+2CuREVVikVn1dz2cOv0AT4oQbnNUOgkP/7cH5Lflmw95z3PC3B03K/O3vlJVQq2DK7CvIHQ6qyfCG3hFPnz8OzdI9Nqn064KbOX6n+bgt5AGp3Htt4BCSUuqwwA62SK2gRH6Q+derlTrivBMaSsD+NSIb927WgZyRNlj5X7R5dtyUkEOPOBNA5JROJwokPqFeIy/oTXItUSsJ0wdO15klkTwatpGvXIXYLXtgrGHv+2kMc8W/0mOGnxSz419wPvCEyW35Yh9A21moeVJ1QdN5Voov7t1UHauNYK+U8Gk+HTLCHOn+dwQQGOG9JoTVXzEYibtNErtuK+UNK1ChENwUPk3+hKy/1g9t0JD43cQusHT0vfhri0/DVxavWjYWacElz++9Uyo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(336012)(82310400003)(26005)(316002)(86362001)(2616005)(70586007)(70206006)(110136005)(4744005)(36860700001)(2906002)(83380400001)(6666004)(16526019)(36756003)(107886003)(186003)(5660300002)(16576012)(36906005)(4326008)(478600001)(8676002)(8936002)(356005)(7636003)(82740400003)(54906003)(47076005)(31696002)(426003)(31686004)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 12:41:47.3755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9348de64-1239-4a4e-c86e-08d950fbe5ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1514
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/21/2021 4:05 PM, Jason Gunthorpe wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
>
> The only implementation of this in IGD returns a -ERRNO which is
> implicitly cast through a size_t and then casted again and returned as a
> ssize_t in vfio_pci_rw().
>
> Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
> consistent.
>
> Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
>   drivers/vfio/pci/vfio_pci_private.h |  2 +-
>   2 files changed, 6 insertions(+), 6 deletions(-)
>
> v3:
>   - Fix commit subject and missing signed-off-by

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

