Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA3F59FC30
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbiHXNrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 09:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238647AbiHXNqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 09:46:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E49E9836D;
        Wed, 24 Aug 2022 06:42:49 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=PxvFaIPDf/9QJVoja447Oxf+Fce0XALcMjRtkQa+i+AhYgRwQgN1b+fgBNUbxnRu+PLUftIvwlSaZY7B2FRQyoQaiUVuPjoJGmnAb2mjHs8wPx/XqiulF5IpyBBjQd5CFwV2uEQq1yLjYx5EPHB7unMwU2GNpV/GPeacUS5bAQuqm7O223WObYc2cukvOI/fegj1jGMby8dWt+IsTHVgSYuzJ3kFBpQa/e2bdMJ0ZFJUVzATegUtaGWgofZ/UOrAumT7ZzCi0bbSTxlgsxvzh/J98nGxatvzujiHse4GbRCKw7CWSV71g8d6jH12JZioh2h+gRBli4vVm5ZpAYSOPg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=Ut80eTtUX2SkDxDF+0yLCqtRnXfkWXJgCAxwsHPZvctKksPEQ6fSu6w8gKjKvX2FHPt7SnLsEAVECUfI8bqttPPb/3DE1CvLss5ah8UEzlQ/6zUcFWlDkUhO6QWQP3iuRk+JU0p5xeQK2PqUrMLonD2Yc3Yr9SzuNHYS4p6te+hVV1ABLjWhuL0dOq2CpA2pJ95thDv203iEPozr7w3PDhtp0u/PvOlM/WybUdxpWPAhjN7ALxMWZn4vi3SuB3BdIROY8p0ePIfUH0EhPmWsgJIyKitT5KgSj1ifnbA2YOZsAklpDaCtz5U3yO98i51wGZc5jtm4h512k5EzMUe88A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=2Dnu/yQaOPnMvsog7c+Q5GKZuzvmuIUdZMsEOklil0M49jnr7hazZ9kZnsP7oItBXvjxEXVvb8r5Thxm6oNGXAu/83ZlvJ+3c6GA7rR52eLKpzq0LjU8r2NFhcZ85/ksWwmXKXUrE7EQNoVN0o1TKrTUr2/3fNu8WHN8NmnU8ZA=
Received: from AS9PR04CA0171.eurprd04.prod.outlook.com (2603:10a6:20b:530::11)
 by DB7PR08MB3036.eurprd08.prod.outlook.com (2603:10a6:5:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 24 Aug
 2022 13:42:30 +0000
Received: from VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:530:cafe::b1) by AS9PR04CA0171.outlook.office365.com
 (2603:10a6:20b:530::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 13:42:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT056.mail.protection.outlook.com (10.152.19.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 13:42:29 +0000
Received: ("Tessian outbound fa99bf31ee7d:v123"); Wed, 24 Aug 2022 13:42:29 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: dda6bddcba923024
X-CR-MTA-TID: 64aa7808
Received: from 300ff34e6f6d.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 407FC9D3-4CAB-45A9-82A6-AE6267AA466D.1;
        Wed, 24 Aug 2022 13:42:17 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 300ff34e6f6d.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 24 Aug 2022 13:42:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCGvbLCJO1HYa//Uuwn9sHn2nmfE6J5xmWtxR602Ep6YMbW90XrsocBdcoCIQ/0NLh2Mp4U8YgfKrQF5G8HWR5Tx4dS1B7pyZy2b7pOnGbqYKbZx3KeNdKMj24E05AxU+di6CgaFRTm/3mQvE9pzjfFcEY6h/ruin/fR0AAwH8eDAA8nnhQtdqhCRlaNe9JhexvStFXO0bpcvnsaU50XFeifwG9htdYr00Ek6CrRV8D7xyY04GFqyJ08v/ERKpplL3/xXga9Q8SgidUIbG/HhGQxI4WNoXEtGRpJOtpb+689I5dU86Kfr3s4LMnNcRGHlxdlyppkuccg8ypu06Q0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=H4AnQMuRSbIx9LnhL7ut8SfpoPLW/NoK5UUW/x3ASWTslBYmy9BYpRpQql66cJ5ryRnDOm96c3Lsyxr5x+yNUYQanpSyrflOonOJObi4VhhCOfFxrcyjl/DWMRCCe/zeeQEU67Rh0AEr8LYis176fSwRbJOsrD+6y9O/uDDWSOfFqYINJs3oNNvTuOqdE2rjMM8xEa2Se0hFTq4feYs1kUWy248AYWmPNsiHUmwNrw8/YVIsSgqLkdWqUmkuJevMOpUoQ62PrxqThP3ErXtl1EA3/6xctc5irR/mT8j7WYqQp2yXNOMpeg9i6H9R5Rmactf/b/opVrodrHfM6lonGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8QO4NfCRvPIxHD4KoVawSEO35sm00qw6iLvrhxKuD8=;
 b=2Dnu/yQaOPnMvsog7c+Q5GKZuzvmuIUdZMsEOklil0M49jnr7hazZ9kZnsP7oItBXvjxEXVvb8r5Thxm6oNGXAu/83ZlvJ+3c6GA7rR52eLKpzq0LjU8r2NFhcZ85/ksWwmXKXUrE7EQNoVN0o1TKrTUr2/3fNu8WHN8NmnU8ZA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by VE1PR08MB5278.eurprd08.prod.outlook.com (2603:10a6:803:10b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Wed, 24 Aug
 2022 13:42:14 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 13:42:14 +0000
Message-ID: <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
Date:   Wed, 24 Aug 2022 14:41:49 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
From:   Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
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
 <20220823004639.2387269-2-yosryahmed@google.com>
Content-Language: en-US
In-Reply-To: <20220823004639.2387269-2-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::22) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: a08f522d-b099-4572-81fd-08da85d67d56
X-MS-TrafficTypeDiagnostic: VE1PR08MB5278:EE_|VE1EUR03FT056:EE_|DB7PR08MB3036:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 5QaZrytaEGdys57g+8iflDV5L5qmJhs+bsBtHXx6faGJY9MlfHx7VAjFExNpVneFzjuw4Gr3CQ7FUY4ilWY33jxG5Mz34lx5fij4v/Ggv3yus5xJU1/XrL7QgmibIxBslLPocKP6aN7/Un5xKFuOIxo1bPlJqzttTd9CwOQ6hh31oFYLy2DtTLH9eJkRDwH2946XtXRCHbhQCiUoflvKxdhmpF6OMqwC0CFL8vCkFLm++3ZXHge6oGfltOuxDRKQuZtY7FUYyrxgyacr+J5c2boIwLDYW5LK7+HML8rTm8VaISSblrSuw2TXVn5686SFGrH5gt6G29twI6TLPJhRG3XoOgtZ1rsDdrUl3QyrmFXNE2PXflXMrg3DCt+uNkEU/RiX7/CmPeNjid0X+lsEiYLX5FOfXAfIOUvuPy5r8PJ83cZdasxFA9nYN3LM8C34/KgpkJt88NeoPIq9Z7kjscTdcn2b92NtUVtBd/V+6txeaEmkkGNDDtFaX9sAC+eIdtc6rfH5p0HTpB0OA9sRZfTS0ajmasKff4A1RCx2N/k0N9jnmEkti4O0bH/xe/W4qeeDAfa7XISz8WdKIDhMHlp9s0ydRb+rKy7o1tsovY3PKNuvswuOGbcomBv2FWgMkU7/NFIXY1julYD4ZbFkNc2wC7kfV4pha5WH0e681ojq8ZAK1oVB0R1AsHl7XlR6gVdRiOqeLXFeiAnz2u7sJKgpNtec0Ex35ZjfuXpjAWiRu7IrYFPbXvqiJ2+k7OcWgKVEcA7hJusMAb7T+7Cg/Lq1JLQQBVGJxQJb3q4mX3S2JHOyTlnQaXzkpgJ2oV/y
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6995.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(31696002)(86362001)(186003)(2616005)(921005)(83380400001)(38100700002)(8936002)(7416002)(5660300002)(66476007)(4326008)(31686004)(66556008)(8676002)(2906002)(4744005)(44832011)(36756003)(6486002)(6666004)(478600001)(41300700001)(316002)(110136005)(26005)(66946007)(6506007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5278
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: ca70c4cd-609a-4ad6-2d7f-08da85d673c7
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZO+wi4xNL9Zu2BdOyd1h3IC38ynp2vkIiFqJfmPBMqFUPnL92IxMz7Ew1uXYGKtTyf1o2Yuj0mbFhvot0qgbouq313Qsa8I/ltUqjXW6Shn5tsVuVK1/iVa4x7bD6LZpmh8s+xRfJpYf3Tmf/UmfLw8tcZ94oJIpiKy+AZYd57bBYByQN9/OVD+qklWE8nmH0IZVuIHs9I2msfLSD23gtUtYXOQfwNpp3IbUlzpBMq4ql5hDy5DYOcDkNnxC5SUHX1fK2uo/v2Vg4r06TXKYTBFABzVcWxFaGmesllkKD3N6EIjpi/eJCDCA5sVmUPToC+XTL7l7+jd/BiFs1c47Z+VbcM8TwuI+nkWWaELY33eRvYZopBfctfC4ermykUACQakIFi1g2IjD7cnFc+KtlMFxMNwbML3oG9PMb+B0aIm/7+1+4NuW/V9SpoRLfkqWHbLvUcBFGme43o2bZ9i/zEAJnZP4bR+sG2uUM5uusurYWw5l5Xey754gkt4NN/bFgp2Wgiuj/rqEzSu6dVzpqU2pZjY8tLWqmIFXflmMnb1EJU1tyQ26LAz/nPZ/1mqddfcy+ukmeZrSvSen4lR7AKELpJWQ1EhaxqlqVhMNIYcTOru2EsmDl6D5Bi6qW30talEDWHPPOTo+Xe6xbQpsVNpaeK6kLEd88k85vhgMpWKMwLMu/eIsSulk6pD8LOPkMns4qAV3ki3q0BBgNVV+sc1ZKvYbtswR07OfEhLG2rEmbBP2e3Qeo2xl78PrBeN9M+QgYNYynT7FnVeuJ95duy+WQfLkSTgb4mTJnbTiWPeXxLuVpdsJRJQUG6mK4MaE
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(39860400002)(346002)(40470700004)(36840700001)(46966006)(40480700001)(6666004)(186003)(31686004)(6512007)(8936002)(4744005)(2616005)(6506007)(47076005)(6486002)(336012)(478600001)(36756003)(26005)(41300700001)(5660300002)(44832011)(86362001)(31696002)(81166007)(356005)(83380400001)(8676002)(70586007)(82740400003)(2906002)(110136005)(82310400005)(40460700003)(36860700001)(921005)(450100002)(70206006)(4326008)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:42:29.6931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a08f522d-b099-4572-81fd-08da85d67d56
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3036
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index e7aafc82be99..898c99eae8e4 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
>       SUnreclaim:       142336 kB
>       KernelStack:       11168 kB
>       PageTables:        20540 kB
> +    SecPageTables:         0 kB
>       NFS_Unstable:          0 kB
>       Bounce:                0 kB
>       WritebackTmp:          0 kB
> @@ -1090,6 +1091,9 @@ KernelStack
>                 Memory consumed by the kernel stacks of all tasks
>   PageTables
>                 Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +              currently includes KVM mmu allocations on x86 and arm64.

nit: I think you have a typo here: "currently currently".

Thanks,
Ryan
