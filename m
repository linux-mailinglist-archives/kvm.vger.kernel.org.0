Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37EE59FFFC
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbiHXRDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiHXRDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:03:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B121093;
        Wed, 24 Aug 2022 10:03:39 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=fwD8gIsSLIJlYeapqDqrrW7O5NBG4U+hdfVlxRoKauUyVbz+JAD1UG4K1b5b+s8dIfKi/tgfVBf10DY2Nn4tummi7SMuehc287q5TGMC3DpdlUQ2p/lLGMHUUtg1WhC83pUL+UY63fK0cmioK9GMTihQqJVMhwetEvD392fcHnWgs/hfOILAhoH4FhYCYVYuDjn9nr40FWF0YZ0frrG5jT5AZbXmt3jiHyqn1Ly5FYrEaBqCqgH5Gx+arcYJ/+LCKlD1A1APLwoGp72vWCsqExwXvgNqc4kX+G+FEqi+VLF7bxfsUsAvLbX4mft2E62ow7/AQm2W8yAEENBZHQChMg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=l7bPmvvUg2A8ieISpe7vACulbTInuxmFeLbeA1+rphNfUWfsJJSJ1bmqhCetLOt06Mkj+gbkNWQ8X29+hR8Kp41H70yyc0hM601M6rw/hwniQzayofPE6nAZgyJ+w5RH+y8CPBN0QNZdflV6/hb8MIbC1imDifTb6YAvcPDTLcMIxZ43rlh6w6fNnWMFy/HmkELM3X4fM+xDZD2ySx3/3VnH8EKw1hJAMld6ja33hK4GhcsIENQn6O+Mo9KXLPZ5Wn6KLjbc1mW7SKr/j4D9ackCgUC1E9aTLAn93qUfLXVnQ8jneFM930KXXJd7CRfzSeQg535qDeHqBw871otj4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
Received: from FR0P281CA0110.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a8::6) by
 DB8PR08MB4171.eurprd08.prod.outlook.com (2603:10a6:10:a4::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 17:03:34 +0000
Received: from VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:d10:a8:cafe::40) by FR0P281CA0110.outlook.office365.com
 (2603:10a6:d10:a8::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 17:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT018.mail.protection.outlook.com (10.152.18.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 17:03:34 +0000
Received: ("Tessian outbound 63c09d5d38ac:v123"); Wed, 24 Aug 2022 17:03:33 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: b84da0a500443880
X-CR-MTA-TID: 64aa7808
Received: from 95073a54352b.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 102F230D-1C71-4112-8E95-81DF39D91E61.1;
        Wed, 24 Aug 2022 17:03:22 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 95073a54352b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 24 Aug 2022 17:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OySV66iRQUFC2HySUIKfGJS+KmVDtfrNMZlupcxIWDwu284/ecQGqp3JlmWHUl87j8L2FKTTiEA9Ac51keAQxfziLxjrPL3D9ZhY5Vp/x1cTqpc3AjCyXJtfQ1t1nkKb3kgSsednNLO2u7GgM+Z1ZBC6lyhrDhn7iy2LVltA6Fb/FrRrV8xXU/fw3Kk3p+SnRk4XW1+4CyUxvv3F8fC9/CCpmCwwjxRJmQRyZEnVWMEKt/fJsYBr0BRaaF4q6MWB3IiaNJ0zT7h4XasnWuvoKcLpjTVIXpeOcZYwNTipYOlGdtzUYqkASVID02cCP1Pstml+DXgm6zvFsh3hK0w/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=Ugh+jmB5c8pxYS+A1VnxgWYwZ+197U4B/gyM3UutxU4L9BvyT3UGoDYaRVvNviWCFJnni+uMKkGPTovQQhbQwAFUjJbfRJERWhpkHW86LPQpc3H0KauW128XQEFxfkozWHQlmfGLfO0++5rHYYIaZ5aTH85vqmUmWoQDutDWyI/PCMJrriqxDLj6HACB0c9cwbnlEIa2cvLP58URJbFpGRAwLxLZ2yXhFbYCOpN/orPuUr6AbYZvbVhmAoZWIx+pJrQiZl7QwsGQQH9gUNkNahpcr726dhKPAcxZ/6PVUHYYN7RW4qpmAiik9i3rmu61hsIVb8/4RCdDth0PF3tbhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UnLEWXSgT4DQTcGUbDdRxvIjcrMpuFfUSeoH7DIAOA=;
 b=gGf0K13V4/YG4AzmRS8GTSwB6RF6WOAI0akyYgCGu6pOnu4dbKYETPW37X4KsHgtnTFxQqEeH3HBTFS70XfI10S23c8rdpAu7/DaNuP/Q2YiI1cbNN8tzDyiGov5tBhvG0tykGT2ccNMDIBUViggmFYKFzajUeKDNKC14kT37ds=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM6PR08MB3029.eurprd08.prod.outlook.com (2603:10a6:209:48::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 17:03:21 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::bc0f:339f:d2d4:e559%4]) with mapi id 15.20.5546.024; Wed, 24 Aug 2022
 17:03:21 +0000
Message-ID: <437ad644-a6f7-4b5e-ecb6-e8ddf4e4dc75@arm.com>
Date:   Wed, 24 Aug 2022 18:03:17 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
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
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, nd@arm.com
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-5-yosryahmed@google.com>
 <319904e0-3722-8ab1-cf74-491b9c32e23b@arm.com> <87zgftra6e.wl-maz@kernel.org>
From:   Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <87zgftra6e.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::9) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-Office365-Filtering-Correlation-Id: 5c7547ea-cbb3-4dd8-8bf0-08da85f2944f
X-MS-TrafficTypeDiagnostic: AM6PR08MB3029:EE_|VE1EUR03FT018:EE_|DB8PR08MB4171:EE_
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: mnXNg4j7/7IKN/PKwmwPJYjAtiOVoo2n3eRh7kORhw47/4psRfOHZZdcWyE8M9Q9liV6wqQj0ntxuZANPL/muKSyeP7qg2HODa3wLwW4bdbBKaQ+odzdWYhbPXp0pTPfFIZ7w1RaEIhq/pJGcUI8egYE7Eg1eX9jyfyswDHlqLsTb7gTuVtBMNTIdUVycmXa5eN5BcWtGYWuwS4Vop6T++RxxwV9FdXNs0yuhWFT9DtPoXQdslJ0bQpajLLIiuH70wA6xwmLLqCxUxkelvyLaV0lyfsE5u+uSbqMdrqA2H9EAST+Ye+26MW+7YCMFTd5CaWwa2Ahc3vNkRtl6PNwaseJP4yY33hb9cJgmlNOkOKvAL+9d3NN0ef/xnZ2mRrSCLEDA9R9cEs28J4ZFgUmAOIliqeBcaEWjXEJnjGUWi/8HsZRyhyjPA5BSPkOPmIpXZ37VhJIYIcJm1UdDQYuyuOv3IguSJxFQ6LWZd3j+bKVF3KLleXaCKmcJUK9ck+7Lh4mvYy646zW540cjQWLxhgR463jXqVDJSi6zJv9fidkJ755lI9mJXl7bf7opbPgpEvuiWo/QXtuObimrvD+ecvKCuCI71eewTt0XE0KITRUCxEhaLcYoAo2nAbHozvMkiKc9I9bez10/k1k6UoZLA2EeZGEZ4/vn/JAKq4wWNDI9VRZr+H2tCyTFJCBE1jlDpHcHABqqskdc1u4yPNSRUr0btiLg9ouEqEcN1DvgQhEJT5GQTkMqJNNRxfO88sY3vDs8zl/93mQqXAgPt/SR4zxFmXO+2R9xMGzX5IrgR0=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6995.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(36756003)(6916009)(31686004)(54906003)(38100700002)(66476007)(66556008)(4326008)(66946007)(316002)(8676002)(186003)(5660300002)(7416002)(478600001)(6486002)(8936002)(53546011)(44832011)(2906002)(83380400001)(6512007)(26005)(6506007)(41300700001)(6666004)(31696002)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3029
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8399f2c3-5317-4fa7-6316-08da85f28b96
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UpMW4DFrgyYmqULs2hCj/Co0XD3e2fIRRxmBT7lu9Uvt7qaUubKfHY8kjWzzFVPaubaEG/wrzJeKpH3i0O+cudoSpLpMJoUJNAdm7AC/gzymyvShEiW53zbPYCv2eMKjGiIC068UMInMPA6pdlg20Vp8v66VNL1THcxg5QMndxBniAWxh/9jVc0T5FAXvb1PkUauFDLmgq3e3xUSJfHekF7eSw6cLtUdaAWln1AYhFa7NChy95WrxpCtKnIeedqllwzIaaasHJHISnRobO3QJcL2/5S7OBhmLbWv8MNiKfowrc/opYIxoCt4e1kiOHLMkgdN54pMga3ATieyGH7VhjTMpRe6+pAQZYBGCNoNSJghJWEAaoiBQYco6H5typJINtFemfZp53t08AQJcbWE0FueRvsczAxNcVixiy92SLI4k821ACI9jjLq6TcOUSALWXK0POGtI3CCeCs80/v+BL+8OORE72A8q/+oMiPG5fRBmz0OjwpavSwVxz4PqTwtWLXgZ1Z+g+k5EqLlPeVb/Yko8y/CMCUqk3M4fjLeMywy0RhPvpIT2M1T465kZxqy1beivAlB/HQX3eHnSCxRAHNmxuG056t/u34GF//NZdHI+AXN9vxuYtPg1zc2gaVuTudgBmMBIBUsUV1R/YMgwQyor/9T3QV11AdMzv0FVqioHn41DZ7ny3TLZvsAR+W4VyQLYv0eZb5txDpyrS3/pe4DKn8B9LjviOlDjYLzZDL8ZA/qvWGMdFvptVCTDmI2VU5RXbiRpZrnh63rflfQIv1ZP9LW081eC57l+vvtlm8u5ZPOfZQadb+prXUNrCUy
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(40470700004)(46966006)(356005)(6506007)(83380400001)(40460700003)(40480700001)(36860700001)(81166007)(70206006)(6862004)(82310400005)(2906002)(82740400003)(316002)(70586007)(450100002)(478600001)(8676002)(6486002)(4326008)(86362001)(31696002)(5660300002)(54906003)(186003)(41300700001)(8936002)(2616005)(47076005)(336012)(6512007)(26005)(44832011)(36756003)(6666004)(53546011)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 17:03:34.1205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7547ea-cbb3-4dd8-8bf0-08da85f2944f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4171
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/08/2022 15:24, Marc Zyngier wrote:
> On Wed, 24 Aug 2022 14:43:43 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>>> Count the pages used by KVM in arm64 for stage2 mmu in memory stats
>>> under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
>>> to give better visibility into the memory consumption of KVM mmu in a
>>> similar way to how normal user page tables are accounted.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>>> Reviewed-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>
>> I see that you are not including the memory reserved for the host
>> stage2 table when using protected KVM. Is this something worth adding?
>> (See arch/arm64/kvm/pkvm.c:kvm_hyp_reserve()).
>>
>> This reservation is done pretty early on in bootmem_init() so not sure
>> if this could cause some init ordering issues that might be tricky to
>> solve though.
> 
> I also don't see what this buys us. This memory can't be reclaimed,
> and is not part of KVM's job for the purpose of running guests, which
> is what this series is about.
> 
> If anything, it should be accounted separately.

OK fair enough. It just struck me from the patch description that the 
host stage2 might qualify as "pages used by KVM in arm64 for stage2 
mmu". But I don't have any understanding of the use case this is for.

Sorry for the noise!

Thanks,
Ryan
