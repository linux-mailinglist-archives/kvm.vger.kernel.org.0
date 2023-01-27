Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F8967E3F6
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjA0Lqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjA0Lpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:45:52 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFFE7D9B1;
        Fri, 27 Jan 2023 03:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T4rpun+mT/zPp4XRSj3yIBLvDhCB0Z4b27exMQi8r4=;
 b=el8E7ULEYiPkeG85m9DqLJRI97TzTIzXqATpWs+iYcSGomXVglUfePrU2jYGX1XtuO3OqN7cwu9BuqCgMoy9GfWyXC8YxIuA/RQGjGl1xYGzybK3qcFzTebjkTCkUmLPh9g0/VyFOY4auTruelODtKE689kAVI2bjpk5kp6Bkcg=
Received: from DU2PR04CA0207.eurprd04.prod.outlook.com (2603:10a6:10:28d::32)
 by DB9PR08MB9850.eurprd08.prod.outlook.com (2603:10a6:10:45d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:43:02 +0000
Received: from DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:28d:cafe::92) by DU2PR04CA0207.outlook.office365.com
 (2603:10a6:10:28d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT010.mail.protection.outlook.com (100.127.142.78) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:43:01 +0000
Received: ("Tessian outbound 0d7b2ab0f13d:v132"); Fri, 27 Jan 2023 11:43:01 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c4868fa8c4408566
X-CR-MTA-TID: 64aa7808
Received: from 64b8f445e458.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id EAB6B48A-58FC-4A68-8893-7E96A2D08957.1;
        Fri, 27 Jan 2023 11:42:55 +0000
Received: from EUR03-AM7-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 64b8f445e458.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:42:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etK3qgSeruHU4/LZ4G+WlPeE71Oe7um8H5sLbPQYSp/USAi1xz5W0z4rkS8RigRECUIH+GJXeRfPm+KAzPz1nKG1wHfovrrqGgzD1ghZmjDHeuBnPLjUmSrldZa26V1PIjvptwicTQZQCRoxPOgjog+meHOwUH1xBuNrZrG/dNLgVTHLtFFlRICDrg1UJqmCf9+2giDyaL23Ai1XPVkWKDeQf+EQLv5G+BDnvdQamFuhCto8yu9e9JdbthUomGpxuAzQMnjDn7rCTBRGtNWWEVjJpq6Tul/P02Wdp9n1pkbrbHMTdWnGdDSC8bItQOqcp7fMg0kXmJxkkh/MvL2Rxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0T4rpun+mT/zPp4XRSj3yIBLvDhCB0Z4b27exMQi8r4=;
 b=L5e1XJWnJixb6ZQIIWYGJgVrj2Q6s3bIqnXMTwHeRAT7r0GMykh59Jr3Vw1ox1qJUc5pCNUZ9p6D38fWXqpSlcvVzUk0c3MpT9OzN0Afl8y9og8yrOY+qrYjG7BfVUJw060Y2mUq/I85rVJ5KadIyE9d/9El3uyhBRa7kZ4++BAiuKIB4xJPDZ/YGSLJUMVWOg8GWlmRQZcoIV9lCcNslukYa6UPJdixzVX/h4w41dDBvfArdExjw8Q3lohd0eF8+Eq6RNgsJ17jI/cXuCAw5E8aVEL2hqlh8Uqy6jIjwaor+n/pEIGeD8MRLF5kOyOH8mLNl5SJija1sXbpmGgzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0T4rpun+mT/zPp4XRSj3yIBLvDhCB0Z4b27exMQi8r4=;
 b=el8E7ULEYiPkeG85m9DqLJRI97TzTIzXqATpWs+iYcSGomXVglUfePrU2jYGX1XtuO3OqN7cwu9BuqCgMoy9GfWyXC8YxIuA/RQGjGl1xYGzybK3qcFzTebjkTCkUmLPh9g0/VyFOY4auTruelODtKE689kAVI2bjpk5kp6Bkcg=
Received: from DB6PR07CA0067.eurprd07.prod.outlook.com (2603:10a6:6:2a::29) by
 PR3PR08MB5657.eurprd08.prod.outlook.com (2603:10a6:102:87::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.23; Fri, 27 Jan 2023 11:42:53 +0000
Received: from DBAEUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2a:cafe::4d) by DB6PR07CA0067.outlook.office365.com
 (2603:10a6:6:2a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT046.mail.protection.outlook.com (100.127.142.67) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:42:52 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:52 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:42:52 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:42:46 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Thomas Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        <linux-coco@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 17/27] lib/alloc_page: Add shared page allocation support
Date:   Fri, 27 Jan 2023 11:40:58 +0000
Message-ID: <20230127114108.10025-18-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT046:EE_|PR3PR08MB5657:EE_|DBAEUR03FT010:EE_|DB9PR08MB9850:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f226b06-45d4-4a9d-37d6-08db005ba55a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: UsfsmbNNTGlyOhMoOsykrLly5ru6rRbtZP5CWveMKVCt+o+mPAVvhgIKByZqJqI3XrWsX7y2XlV5feZw88KDrtPX7B9p57Rs/TBbOEt97XUobPV4qK4ITk+J3DW9Tfxsln0NnbmXqsjI4dEAsZlJFB+mXVVg0qwt48AZ3KEd1ZEpe3jJyY5uUODp4nNV9LhE9t7LBhKMn9aLzvnvJ0KVXrQV9NOSo7K2OZR92gQEaEL8So1zuqKnfYf9obdImvmiL15RyifETjCn9OpSYPGYcKXudo87jZnau5PqOnOKCe9Kd/iTG+g0K0HbQNHnCluDGvQPmIHC67zWegrIuAyTyzpJjnNEx4xayMkkkjLfmEJe38K2Ixh0Wbnr6yNl2DeRnAqQItsUpwqe2JBWfS/ev+xMGUzW6SQcf9EZr28iI61kFfLeUjsJOBGtJJtX/XU3OGmrJORr97UQwXRtRZTnSJ+tVp4+zF9hgYrrTcxJatnCHkJq3UMyM2GYzHY+mk5RtC4w0Y17gWPmpH0w8bTQwwnFOFUs8KrAW0D01d9xB39tqcDGKDiZtzBKdWLqKlHnp7o56Ib7i1/ZqyRqvJLBMLXZTWfi7BPjMb+9tPJ5IOJ1q1kQ5/q7IuZspxvvC0auOkTKWMVS4KbWZNw/XArFIaKJ/5/vqYZCtJweMPllGeqE2kJxJw/bjNqBZGmgVJ6Yk2q6S/dgg8ttYKZNpaviVQF3MIcKUc2DhCilTt/YWFXg/SOVDLA3KDj8h1N2TmO8
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199018)(40470700004)(46966006)(36840700001)(81166007)(36860700001)(36756003)(356005)(41300700001)(86362001)(336012)(5660300002)(7696005)(40480700001)(8936002)(70206006)(4326008)(70586007)(83380400001)(7416002)(47076005)(426003)(82310400005)(8676002)(54906003)(110136005)(316002)(478600001)(2616005)(44832011)(40460700003)(26005)(1076003)(186003)(82740400003)(6666004)(2906002)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5657
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 6790246f-9a4b-4038-da75-08db005b9ffe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VIaEWWT4A2jXDfYZ4ZIuRlLXcTCy2SKR+KXPF1wk2cvic2m5bKqEyIlU6973mXVbYaob62Vtz3PjPGmMEDHb87IJ12PQY4lCaCCS/FHDsRFJzHzZmUOWdtiXPKAKNB2uXuTAD2JNj3gU1aKKOqOkGRwgK0ESy5G06o2QUrbbn4SAiO3uHXs/uKvAJ1hj7fklQ0HV8522G/+KoqwgSr/TacFHAyedSs+9GT1EvpXAyvIEO8xjuwwgWmEtC6kb8wNGJPxGc6q5AK6YcXJm+iK7719pxJXuZyQhMlQQim6HadZBOEXteUGoR23NbopLhTH9e4THeBjXh/5pWTcZklqGZH1kM8CR/hDUx6NHSTXYozG2DZC6TQJoXWqCS/rZvkLvvdtA9FM70TkuhTSq8MIiqKFaXuBJLpaPWNy4T6ds5jrVo2sqt3RkQofnuQ3KJzbOnZ8SSrfEWADgSV3uokxOI2S1255WhvI5RB+6FMGSgcsRn1kbprY89VLoxmT16fLaXMUBLhRfczPcYlF+WMh9HK1ALK5drHQeBDv/sv3T1bEZ4v7x10rKMiqgDotrme8PaAR7tDexqhG8VLptQTFJKSA9f0wslF09Vm5BA0SGmR6x3a9CYnUmndbEHWj8YMd8M3igXe898uAHUbBH2gf3sqraEp6e5w9wnRMiR4GEQ3Ozgmj11OgZLBb4MnNi59d2q2ftyzYnYL2630+zjRqqfUG90O2R05vp7IW5BReXdDo=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(5660300002)(70206006)(8936002)(44832011)(2906002)(41300700001)(450100002)(4326008)(70586007)(8676002)(6666004)(82310400005)(54906003)(316002)(110136005)(186003)(26005)(36756003)(2616005)(7696005)(1076003)(478600001)(40460700003)(81166007)(47076005)(83380400001)(426003)(36860700001)(336012)(40480700001)(82740400003)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:43:01.9234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f226b06-45d4-4a9d-37d6-08db005ba55a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT010.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9850
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for allocating "pages" that can be shared with the host.
Or in other words, decrypted pages. This is achieved by adding hooks for
setting a memory region as "encrypted" or "decrypted", which can be overridden
by the architecture specific backends.

Also add a new flag - FLAG_SHARED - for allocating shared pages.

The page allocation/free routines get a "_shared_" variant too.
These will be later used for Realm support and tests.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/alloc_page.c | 34 +++++++++++++++++++++++++++++++---
 lib/alloc_page.h | 24 ++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 84f01e11..8b811b15 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -53,6 +53,20 @@ static struct mem_area areas[MAX_AREAS];
 /* Mask of initialized areas */
 static unsigned int areas_mask;
 /* Protects areas and areas mask */
+
+#ifndef set_memory_encrypted
+static inline void set_memory_encrypted(unsigned long mem, unsigned long size)
+{
+}
+#endif
+
+#ifndef set_memory_decrypted
+static inline void set_memory_decrypted(unsigned long mem, unsigned long size)
+{
+}
+#endif
+
+
 static struct spinlock lock;
 
 bool page_alloc_initialized(void)
@@ -263,7 +277,7 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
  * - no pages in the memory block were already free
  * - no pages in the memory block are special
  */
-static void _free_pages(void *mem)
+static void _free_pages(void *mem, u32 flags)
 {
 	pfn_t pfn2, pfn = virt_to_pfn(mem);
 	struct mem_area *a = NULL;
@@ -281,6 +295,9 @@ static void _free_pages(void *mem)
 	p = pfn - a->base;
 	order = a->page_states[p] & ORDER_MASK;
 
+	if (flags & FLAG_SHARED)
+		set_memory_encrypted((unsigned long)mem, BIT(order) * PAGE_SIZE);
+
 	/* ensure that the first page is allocated and not special */
 	assert(IS_ALLOCATED(a->page_states[p]));
 	/* ensure that the order has a sane value */
@@ -320,7 +337,14 @@ static void _free_pages(void *mem)
 void free_pages(void *mem)
 {
 	spin_lock(&lock);
-	_free_pages(mem);
+	_free_pages(mem, 0);
+	spin_unlock(&lock);
+}
+
+void free_pages_shared(void *mem)
+{
+	spin_lock(&lock);
+	_free_pages(mem, FLAG_SHARED);
 	spin_unlock(&lock);
 }
 
@@ -353,7 +377,7 @@ static void _unreserve_one_page(pfn_t pfn)
 	i = pfn - a->base;
 	assert(a->page_states[i] == STATUS_SPECIAL);
 	a->page_states[i] = STATUS_ALLOCATED;
-	_free_pages(pfn_to_virt(pfn));
+	_free_pages(pfn_to_virt(pfn), 0);
 }
 
 int reserve_pages(phys_addr_t addr, size_t n)
@@ -401,6 +425,10 @@ static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, al, ord, fresh);
 	spin_unlock(&lock);
+
+	if (res && (flags & FLAG_SHARED))
+		set_memory_decrypted((unsigned long)res, BIT(ord) * PAGE_SIZE);
+
 	if (res && !(flags & FLAG_DONTZERO))
 		memset(res, 0, BIT(ord) * PAGE_SIZE);
 	return res;
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 060e0418..847a7fda 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -21,6 +21,7 @@
 
 #define FLAG_DONTZERO	0x10000
 #define FLAG_FRESH	0x20000
+#define FLAG_SHARED	0x40000
 
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
@@ -121,4 +122,27 @@ int reserve_pages(phys_addr_t addr, size_t npages);
  */
 void unreserve_pages(phys_addr_t addr, size_t npages);
 
+/* Shared page operations */
+static inline void *alloc_pages_shared(unsigned long order)
+{
+	return alloc_pages_flags(order, FLAG_SHARED);
+}
+
+static inline void *alloc_page_shared(void)
+{
+	return alloc_pages_shared(0);
+}
+
+void free_pages_shared(void *mem);
+
+static inline void free_page_shared(void *page)
+{
+	free_pages_shared(page);
+}
+
+static inline void free_pages_shared_by_order(void *mem, unsigned long order)
+{
+	free_pages_shared(mem);
+}
+
 #endif
-- 
2.17.1

