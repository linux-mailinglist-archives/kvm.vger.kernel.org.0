Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1009B5026C1
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 10:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350064AbiDOIkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiDOIkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 04:40:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7D4B644D
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 01:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVh36rHAjPYvzjpZWnPyl7SnczY9GrQ0s92k79ew6OyRmXVcPzoQD6jp0Cb8exKJTiHn29rTYPltYt9FDKdIdgXDMGIiM6y4qE/JqfLsxbGrklI03Kq33HOBlFxBKvt85UpoJ0oHxkbjCDR2P/7eVq4fxv2CcXP5riLHHJraHvAKwx/357HOuBurT9bnpsOK/Jk4vjSnu0DmxWxD4fjikKpeZ82i1JTTUS5WwXc8l6eP16XiUrQztTFcepvtsEr6LWykLVepC0lhNMg0xPydo35F/tkQg2dgm+U6oSnjKgjxE5gwdMsSqBYBy9/60Me2mDzmivTp6/xuNBsTz6zYGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAX4alm9HeuUUT16qusEd0qE86RyY6LTwwdJ2jiWols=;
 b=Ui3jt73ywKlQHLOVI5UUzjWKj2x2j08D/Uk0dRQVvKUbLbOT6y8PZUyWvMiFGk/LrsIGa3oIzdg5TrLi1RO4YaDlaebuExOKlJ7U+NKKdNx03xz18SCJdJDWImQZM1vy9YD+nK/pxDMC+Jqc0v3+5sucVtheeQiErT/EiBc2ZD5OvsFYjlRvTw7HA3XIdSpXvamHI/3u/1+GoMhgeT1OD+d+u8P3R5iaL5dgKIkKZmTCo3F0sOBNHviM3fJmw32R/1L3oGc/ZhT0oIZFZWXgPYoItLKLeCsNFpks2yQm6ATRo5pRh23dTmZAtt4UUtEwi4yfNiu43X8MuTkz1x+saA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAX4alm9HeuUUT16qusEd0qE86RyY6LTwwdJ2jiWols=;
 b=V0yF+QkcDmG2j1o//dkKVXEsWJQp7fGYDCvWBcBz1UNYkbm4TdLudJCsBIW3uUl8qtQK2IpQIF3o37GyrYrAX8026untEM/iF6BVvOwxcIgyC2UXRlr4NPyE0bzvzCSQqiYc4aZGcARwnU9gjUYgLy4/UWnFq40PYDVFhNMzfZn+3uEUv1mFTQhediFKwpi78Vm35ciDMbBoGqgTo01NAjdO5o6NE9CSnh1JxWaGwqSf3sBsJtvWN0z7bLHx974hoHkaYHp5eSZQZfTOl+5wTRdMSQikZpfPU8G8o1qfr+zrsG1d6+awqYKgQBYF52JB5v4rOJk4RRHZqXrdoERRPA==
Received: from DS7PR03CA0145.namprd03.prod.outlook.com (2603:10b6:5:3b4::30)
 by MW3PR12MB4394.namprd12.prod.outlook.com (2603:10b6:303:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 08:37:45 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::5a) by DS7PR03CA0145.outlook.office365.com
 (2603:10b6:5:3b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.21 via Frontend
 Transport; Fri, 15 Apr 2022 08:37:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Fri, 15 Apr 2022 08:37:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 15 Apr
 2022 08:37:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 15 Apr
 2022 01:37:43 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Fri, 15 Apr 2022 01:37:42 -0700
Date:   Fri, 15 Apr 2022 01:37:41 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <qemu-devel@nongnu.org>, <david@gibson.dropbear.id.au>,
        <thuth@redhat.com>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <pasic@linux.ibm.com>, <jjherne@linux.ibm.com>,
        <jasowang@redhat.com>, <kvm@vger.kernel.org>, <jgg@nvidia.com>,
        <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <kevin.tian@intel.com>, <chao.p.peng@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <Ylku1VVsbYiAEALZ@Asurada-Nvidia>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f56baafa-9b07-4f0b-ffc9-08da1ebb3668
X-MS-TrafficTypeDiagnostic: MW3PR12MB4394:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB439458E686C2637646EC001AABEE9@MW3PR12MB4394.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DyiEUgtP04mcRqlNQDo1kdsrE8sMksNU/qE9qe7jDUWZZlbVlFXsCsflIxtY0Y/fBuUfkEWZJP6s7Jz7xwWYKwo/A1W0QdbQrHczcRCYoIZdEv68QXkHwbB5lldxIsmhb/mJUevSAalsk5BMm5zrqudpujkPMKOZecR09aCxRKTDrLrqSmHaIuOunt6WKvHxqtWwM7WPKcYP+w1Q+t4CXONTfd8lqeAELZdxEvIf7h/QWnjrK0ROZdKO++wRZyB1/oIyy74Cc2BKLxL/9U4BL6L0p7DHdm8C+ursaTXZYdN+DZbsN1HlEsw4Lei53PL+CDaW/abQqG3FgUszCJbnEtfNcgqkyaDSfknCU9um4bBAJoTFMCafNggMJ/FY8vI2s9oMZkwgYLJ+SC3DkrgUZH6hJz0tPyN8DUNWLMSC7i21wZLQ3wHpGzVQnWfGMjGr+eKzvlPH1v7GL9XVI1JwJ9t+2tSOhwKSf0MB3L5kUjlc2GxF9IcuViBjw6R5Zm7mmukOwnziHJULGVMyZfBeUTdpz+H1Xi8jmA48IgdhYhzP+XhkpcAX51w2rbfcGLp+8v95WroT17bwPXelespbY7zehCKfH/ubYySBp9nq2zyUw8tFdoa3Jr4Hn/NZZ6pMdA49bnCuoMarCTlhMD1ETlYvLmpShD0rs5jkhOnWEPACpmSMbb0NOVTMaLAgihlC5RHP6zQQ3je7UvDf12ABw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70206006)(70586007)(426003)(47076005)(336012)(55016003)(6916009)(83380400001)(356005)(4326008)(8936002)(54906003)(8676002)(26005)(186003)(2906002)(9686003)(36860700001)(86362001)(33716001)(82310400005)(40460700003)(508600001)(4744005)(316002)(7416002)(5660300002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 08:37:44.5665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f56baafa-9b07-4f0b-ffc9-08da1ebb3668
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4394
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Thanks for the work!

On Thu, Apr 14, 2022 at 03:46:52AM -0700, Yi Liu wrote:
 
> - More tests

I did a quick test on my ARM64 platform, using "iommu=smmuv3"
string. The behaviors are different between using default and
using legacy "iommufd=off".

The legacy pathway exits the VM with:
    vfio 0002:01:00.0:
    failed to setup container for group 1:
    memory listener initialization failed:
    Region smmuv3-iommu-memory-region-16-0:
    device 00.02.0 requires iommu MAP notifier which is not currently supported

while the iommufd pathway started the VM but reported errors
from host kernel about address translation failures, probably
because of accessing unmapped addresses.

I found iommufd pathway also calls error_propagate_prepend()
to add to errp for not supporting IOMMU_NOTIFIER_MAP, but it
doesn't get a chance to print errp out. Perhaps there should
be a final error check somewhere to exit?

Nic
