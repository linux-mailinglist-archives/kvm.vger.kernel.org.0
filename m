Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B01165C222
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 15:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjACOkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 09:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbjACOkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 09:40:06 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B629F12094;
        Tue,  3 Jan 2023 06:40:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQYY1OmubI9D+fMh02O1LMruTU1hVE6g8ogYOjaac2qNP8o0R7d1KTWQFPLaxzsIFQWOMexWG6QyHpudFDjUkROSXxbd8RUhjNCDQm3A3EY9GgXaKjBHXllGkFPFdFmvgmKewU+f/EWlr+7t2exHe+jwDrJtAyVX2/dsl1MSw/OgFpifvYY6Q8BThp37PcsRCy6MZjZuwO3y9Pk8lduPF/AG8/b1Xmro9i+cqeXJ1xTc8dr2wValXuQjO1B1/LQT5cT7Vc7Y7GzBREX14t/ovRtABKW7d1usHH3dQc56uRWP/6Jw27yUGJPXVPh3wstyBSs1TPRyvJXr+jUhIQLETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/XhCnrerFhVuNV/urO1JtZtpre0YTanYRVZg/FOr/0=;
 b=Z65mx2AhgV1ReaVk+llwL1TuL2sO5LfO6cZQMAkd2WUmJzG4MQsQ+/kJeDa92vrN8xtaT+WQZP3ixIuTFTeE0ZKAHzbvrMD0cYR85g4gwX/2JVzLqk/w1P3DkBvATBjeDCONHI2YuvySRY1iMy/QbSa8XlUwmIF8VwE+4WJM0cHrEKu20Jh/Y/eXRFrHsXZdNvDwke7qRYVOpCaxx2+Kc2ZyrGurDt5hHPkSx45b9tJLmW/ry0UmLHVBLOkv5sm0DUWErKGKZwMC61syuqN140O3j1yjaejrWPzEyUD34n+t7sHOBtoKh2DiXBLMbcHO4xKvKdB2EVKYyVBbSJts4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/XhCnrerFhVuNV/urO1JtZtpre0YTanYRVZg/FOr/0=;
 b=WzGwLdBed/S2hMigG/b9Vgp/OqVkiV8G2OKjpvQ0k0hppprzVL1CI435weooPRh/C+qGdS2vKOXnLzXell9jw9hCARPZsylTDx5R9/4ZqDIvDSJNl98eAyJaL0EPmpmwg2SI7zfTDmsw346GOvv9m2gYFVnB4E4/x1AXhi877iA=
Received: from DM5PR07CA0119.namprd07.prod.outlook.com (2603:10b6:4:ae::48) by
 SJ0PR12MB6688.namprd12.prod.outlook.com (2603:10b6:a03:47d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 14:40:03 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::3e) by DM5PR07CA0119.outlook.office365.com
 (2603:10b6:4:ae::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Tue, 3 Jan 2023 14:40:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Tue, 3 Jan 2023 14:40:02 +0000
Received: from beas.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 3 Jan
 2023 08:39:59 -0600
From:   Wyes Karny <wyes.karny@amd.com>
To:     <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "Carlos Bilbao" <carlos.bilbao@amd.com>
Subject: [PATCH] Documentation: KVM: Update AMD memory encryption link
Date:   Tue, 3 Jan 2023 14:39:31 +0000
Message-ID: <20230103143931.120939-1-wyes.karny@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|SJ0PR12MB6688:EE_
X-MS-Office365-Filtering-Correlation-Id: fdcf3e1f-b959-409c-8196-08daed986615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2E0hz2/QC+ZZpq3SEbPK+OlliBBH/vO7nPBWTTd1hN5Eim3GukOJuAtXKiZB7f4+6/oky/dKSKI029b6Cl1ylSkhjgJW4yC1UiCnJWyug1tMeGWc2hbJuprOHF8Ba13MUk1/iQPbLABfpRoTEjsOGETk265la8Ht2OOd6WTUgMtZrEW+X1pmENo5niA/SVMtZMtZD5Ubl0ntfOvE3mVdRdt6NQckD+gyHhj9HNIqOgmwnTyEItsBmPzgHz37CJoqQ8WPOcwteXV7yRFg5+KhraftT5mFMVaWXWMAhcVXmjbRJajF5cffbp9IKlbIrYbhtIe7tMxyR8n/RR5ROsPaZq2DAJy8qCqdYBtgDn+t/1qULr2A0sRY0Wt4CJMOcZLjHfbbsgsL4nySRp+efG4eLHb/VLnbLhJqLmpmcwxP2QDZulRLrd279URcZLEkn/VI74MWYXUowxqCFbMO7u1ivc4uxkDcvgw7ykXkArj3YQNNKbtXLKLE9hFrnf/dmxdTZnGyiLLPgq9JQCSSYDHYdU77cJPBjyYh0mlzKtYAF/QpntG1z5bUbWiT5926uo/MhLgVvLDtL5nQCKEd0ZEsLRTMbzOmWYjuXJwTd3edQB4c3tC5GMsyOYWBNQ9DfjAoRWs8OqmOxlqXh/GYFq6ccqnbrUGbc2kb23v7TThZNu/9cHnDr0GzzLerj5lQQk4qMUkF7r/lBcyk1wlwKtTXCX/einZLK5LF0VjQh4B3icMSOSOqet3xwNttJ8RNavTiLXFZmPiaHmvkRyd31A1sgSDbFumc1F9H0D8XJIMld50lNYQAJAz1xoCOcC8IplTWFOjPW2vwiN+kdP0rtJErAQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(81166007)(70206006)(8676002)(40460700003)(336012)(4326008)(1076003)(36756003)(41300700001)(47076005)(70586007)(426003)(2616005)(54906003)(316002)(2906002)(356005)(110136005)(86362001)(15650500001)(36860700001)(5660300002)(82310400005)(82740400003)(6666004)(44832011)(8936002)(40480700001)(966005)(83380400001)(7696005)(478600001)(16526019)(26005)(186003)(22166006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 14:40:02.9218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdcf3e1f-b959-409c-8196-08daed986615
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6688
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update AMD memory encryption white-paper document link.
Previous link is not available. Update new available link.

Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 935aaeb97fe6..487b6328b3e7 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -440,7 +440,7 @@ References
 
 See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
 
-.. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
+.. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
-- 
2.34.1

