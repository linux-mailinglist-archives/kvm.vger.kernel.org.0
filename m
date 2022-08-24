Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAAD59FC34
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 15:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbiHXNty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238755AbiHXNtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 09:49:32 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC65C9AF9A;
        Wed, 24 Aug 2022 06:44:37 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=S0OfJIj9oaEbohcmJZPFRIGagh96SumKlVjcI5SL866xS3AK4LCefc3JvyTwKHMT6KqgqrZxN8qI8fLDR0EmMeD2JDc0dNdH/xcw97iECEmPtAKJx03lb9/gyRyDm+zGecMtLitRzsNZynZqW5yEy8gZybuZSp9NjMF10quG/ZWQjpcifAr1lIehbQL+cu2SybxRjswbVd5CdN9oIii+L+M1s/tv830rw2F6f+evlH5X13RQnuR+AQRXqARMfLMG8YIrXm5XXlkyAxphKxIlLAq19JsOzehlVK1Iscvcs1N7Yo33WJV0jvQ8YTQXNIcKXpFy3tc6TsIuPIHhg4B6fw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=XekOgSeeQS2M/RMNWq8TRYfDEaOEDLyXmyX+vbKXUD1IvKHVt9gW2DjZRI/P9ZdGgXd/W9hw4aIUmCpeOQIiYnqTzNQoBAKQa7jT3bGYXFamKSZ5dRJGEl2atFCoqXkTJa9dIAI15mT4xOIYaIOjHoD/KdYTlCmVxhBAmLm/eAJDSk9H2lElPSfLZisRRsO9J0gr04Km/p0qcZWGIqWBwHGeXGIO3N2U9OwjaPvoY6zzR5OFm+6IBf5e4uIoaPwB6LX1oJHLc5uwaRNzwj+yXyoabkdnUACooBA3MhvhEfRwLTPXU8fOxbVUSa0fVuXW3N/drT+rdQqld8q3CuilnA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=timeout (key query timeout) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
Received: from AS8PR07CA0021.eurprd07.prod.outlook.com (2603:10a6:20b:451::14)
 by VI1PR08MB3615.eurprd08.prod.outlook.com (2603:10a6:803:79::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 13:43:59 +0000
Received: from AM7EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:451:cafe::c9) by AS8PR07CA0021.outlook.office365.com
 (2603:10a6:20b:451::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 13:43:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=timeout (key query timeout)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT039.mail.protection.outlook.com (100.127.140.224) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 13:43:58 +0000
Received: ("Tessian outbound 2af316122c7a:v123"); Wed, 24 Aug 2022 13:43:58 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8e4f0ce82f4219da
X-CR-MTA-TID: 64aa7808
Received: from 6219e544a6eb.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2745645B-60D2-4855-8413-531A8A5ED5AE.1;
        Wed, 24 Aug 2022 13:43:51 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 6219e544a6eb.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 24 Aug 2022 13:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f37uPng9LYNB/D65AnwGi7GTzcpYVxXhZUjPkL9dcIiXF1J1WeUI6SKZiX80RIyXQ4f9VCa9Z4jAQI2wvl3JWbc/Zkf335MHe6UdtNWrDZjDqSXrhBQQVsnQ81MAGtmYO29qe8h2wZNP15eZd6C5svf/2q2UV+vHCUXAe/obKh7YFycDNN/v3iMSsqK9LRB+NLc5Ne0v0Kq9mzWpWYkK1c1j/8Y2qjpzwHzTfTjXGMbvO2y7krbYzP431B3kKkZaV9Z1v8e/+JanPwLn9biPGYyY7/EFrrANTRfGVGqHHfARUJFq4Ux6tCcuJ6rfPRr6WYfnr4RtAnpFsjLVoWaGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=oGOFwLaWN3Z/szBg1bXRPqddJFIFdNacAdkbsqFcl6g19whmuwDzF1+dBvkrPlOaZXKy7XRKTT5uxvHGHGRbHEgM4vXwF2Amx8yfAHJJ0QRTrlIJQv8wsg8vs6jj+ge0IIor+lMJ2SFvO5uCpPrRuVMdgU2UBe+laq3ve9a5KnsJLtcXCKbtW8WrEQaG2+1Y6iWJo/3B5ydSnwq4lUFjx1WkUENn3/97mMIEVKZZ6WME7xX78T+E0sv8h3jICT0N48MLg6hoFGnmT7ryqborznMiJLfBSYXDgLcE9taqp0sTJqgg8ZyxJCFjFSkhH0W8xz81CBXDbFhLCxKneMkyTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny0RVwBuBXUc/FcCoAgN5AtwiUXmoinaWxS/N0eMdYM=;
 b=gN3riQNW3YK4E3DJpvnIT5cm7Os/GVq3CTeY1a1maZKqWAwp8Onu0Q5+7lfTdU8v3vUrYR7BstjDhCvTA1T4GN57+T2bTXmsg+NVvdfjVLntINXd4YTS5eN06qoovxdUMxYMHHqUTVEvoZ+T9c2kmKGQiKatRuuDkal62aIGT/s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AS8PR08MB8371.eurprd08.prod.outlook.com (2603:10a6:20b:56a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 13:43:50 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 13:43:50 +0000
Message-ID: <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com>
Date:   Wed, 24 Aug 2022 14:43:43 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
From:   Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
To:     Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        nd@arm.com
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
Content-Language: en-US
In-Reply-To: <20220823004639.2387269-5-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::23) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 86b22beb-9470-4b82-22c3-08da85d6b282
X-MS-TrafficTypeDiagnostic: AS8PR08MB8371:EE_|AM7EUR03FT039:EE_|VI1PR08MB3615:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: OcHCa2e61BRfhsscsZd2nybAR3We5PpWjd2RSS1PJGQf6DLbk0CEzy/AHCuJ44e+Me9XyY2p9zxuMVBrPim+RA3je/dH21x03D3iY9JfRrTnbMDaLIzra0Oxn0yz/tdr4/NRyRZqv10dkO5+1yrS05Ai4Tq6fb0J98jkmkpEK8VIjJ7Ojy/LE23U+C3XPUwXQuOWsEqNoELU01qZAcI8p1VHhd/HiZfF0P74IkdmkLm89GE5rmwa3iyG+l4nWHbWRbAnYflepdykuzo59GMK4cgj7MJe5TkOwyiIgzh9+QD7v2B+PaoKQlwRfnr3YvlyRO6MBuFdiPq0bagtGRWd2HplzC1qbtoWvZ2rOAGasATvjYEtWkTT+m2xDBh86UHrVYT1rvGtdWRB4Q5CGV/aBgNvc1KmSAi6Be8/piPGsqlS2HQU/vuU3OFbjp8pJ3fuLeo6aIqi9TyKwNcxpWTwJ+ZgAuZXffH1wYyMpku3q3dqZvktmZ8j43ID5LuKb+YrMFWW3X7CfZZxHLtEUykaWlvjXEz94dLQgaxaevr2GpJZY9DO5I7BeMR1TtE/OSulbfMHiIzQoW0XDxdnExEvVLRP7GnVnZVSvcoaZNX6oFudhqIm4X6xKYCikcn4Oz17STTRFNMRIWYKr1kyoRiJPkpWYyJ0wvz0jmj+qiHF1hRCv2idtuouYcUaFjJyYzX6xDvLwRug3WsFDNixoyX0EaHW4IeZYf5sDDDNuYkvPxJTups6HpdtgAmoWIlgbDEbP9IM+AVRGeRFpKUk1yU4Pb+5qSkgUiIV2rEgZxd0qemlkClvByFU52+Le4NJbEve
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6995.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(7416002)(44832011)(86362001)(36756003)(66556008)(4744005)(31686004)(2906002)(66476007)(66946007)(316002)(41300700001)(6666004)(8936002)(110136005)(6506007)(5660300002)(478600001)(6512007)(6486002)(8676002)(26005)(2616005)(186003)(83380400001)(4326008)(921005)(38100700002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8371
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: d8dca33e-7ff8-4320-2151-08da85d6ad01
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7Qb4SjlVVWPG2eQWMe4ls9tae0g55S7BCCzTlGL7ePMhc/5uYYFN9RybxWrH4X+1RQVt2PRZwVw0tMnC5744ZDBrmxXbScYLBJ3DG6AvHlGkzIXBSG24N5d9n38feA7SfpmYZKZ2ZQx2yu5An2ablw3tACX8Sv7PFybwkPC8I5JJmhja2kyqd3rNUblrvOQS5UyoECkI64GU0GeFiV9WZTDmC/+Y5SNpFBQTUUlCn2eY0LmCp1nWif9M11EyEyMH2QH2m9xNHmt8NskJIowOswE3jCl29sgXgSv2n8hZCq6Q/rIKmIrOPycK5Mi+NYkqG0KkH6pa6qONgLnedm3kgBmMywUv6mm5yNr38eohI72YpHEgrOdsWKBcjwBBan5FcDabJRwWNToERoDDSqVD+yF4C8FbJ4n8n9IqHPg609DBSG16ypvZwItQlHxASprmFuxFfnqghOdldtvohaBwjZwoKC1uSXhJUIQLk0MEJEm4YzQRHAXTBRCpSOokpLDmizxRyO0Nhi65L/YYTQ1jo/lcbJrs1Deu/mijGqBOaJ2FAqmi6eOxagLFbHqZaVvrk5yt6QrGQqfuV7wuM96uxAw4BtPC8Ees6O4Nm+iIhaHg7m8piLyOrfa8PzHdk70Fgw514iSXP9Bqlx8YJy2O5R78MgPXVeJssK4Y2yhkar86B5kk24yOp0L8zvpnmFQbcV5wjy2J7gppcHgD5unbh0rY6M5oqa9vTYKPb6M9WHK1rrMC03itqloMbHsXGpmxyWLHU/MCCePBtEq6Tf5C6nPzOnXfSH0nmKjRu5GljIJaYC+A9ERmlr2ZWQkcXCL
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(356005)(921005)(40460700003)(83380400001)(36756003)(47076005)(478600001)(8936002)(40480700001)(26005)(336012)(41300700001)(6486002)(6506007)(31686004)(6666004)(186003)(2616005)(6512007)(44832011)(70586007)(70206006)(450100002)(4744005)(31696002)(5660300002)(86362001)(2906002)(36860700001)(82740400003)(316002)(8676002)(4326008)(110136005)(82310400005)(81166007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:43:58.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b22beb-9470-4b82-22c3-08da85d6b282
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3615
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
> to give better visibility into the memory consumption of KVM mmu in a
> similar way to how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> ---

I see that you are not including the memory reserved for the host stage2 
table when using protected KVM. Is this something worth adding? (See 
arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).

This reservation is done pretty early on in bootmem_init() so not sure 
if this could cause some init ordering issues that might be tricky to 
solve though.

Thanks,
Ryan


