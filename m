Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDC658AB98
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbiHEN0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiHEN03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:26:29 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30041.outbound.protection.outlook.com [40.107.3.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1792CC8F
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:26:28 -0700 (PDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=P0WkzzauXA+ourTYylHA7goVGlKxyVFwBvZezKPU2QnYM97HKj1HluZ2S83JpwkXt0g34sjBr4+kInvQGmu7WtNTyzkS0nppTrUmm0hu2oMaC4ncnFLaBqgRsh4q3Y7chybpsEQZORcDP+q6k6RxhaklXd/OFmtzeblXpcw2haajJv7B6g/7DeKrQO6Edt+mc4K28PRGtVKMw78JNk6+6IAVDfHMhfRgb2eoBxSzUf3+hdftYmhVmUShQxsuwQ2QUN1q6KsqOjD85iKrIEUVBo+XJ0sc8fLPqZxbGY0yYJSEmX6/TPN2ED3Y4fXqn9NuWzHLjpzMEt5bDIFcwX410g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=nBColfHpxtVoPeKXMSY34tnGvo4VtPV7JallyOtyiP5hY8cMcapKHMqgOsz+tgqSTidbhLTMlhlWZNMGEv22KENYeIBLDfNXmHlEpuPwLP79Yt4Lt20EdhFvphH2AvJlfIV4DEbbDgdqHzfT5+E/lgKpZdrQXUHZwGTJcVDvqZcEE2t9UfnKuJUEYy4NqCxKLDIEtTocXagBbdy67csmBSmqBNBRc1X5ncyAk6BNWcMCjxY9I0bkymuytyJBC+l9ZqYCCNZACeVmkNggxgkjMmxoZBXybeMK6F9JvXLQpZ8pGj6JyMkb3Uhq/zv3KabcVagG8655T35VGIkthNXdNA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=G9t/htXVfON41/BR9Kbkqmau9a7aWU9aC4B4saIlDAQ1vtLYbNIf+ajofNKc2DVE5h8zLreLVz9pIDcsQT58p9+KQ6uRscIJTjieAAv6a1Hlxrx2XwfeaeUew/ya8G8MFuatb+9NQXXUHQI3hi0Db/JxSMefkjMLd1Cpkjt1cAY=
Received: from DB8PR09CA0033.eurprd09.prod.outlook.com (2603:10a6:10:a0::46)
 by VI1PR08MB4400.eurprd08.prod.outlook.com (2603:10a6:803:f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 13:26:25 +0000
Received: from DBAEUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:a0:cafe::16) by DB8PR09CA0033.outlook.office365.com
 (2603:10a6:10:a0::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Fri, 5 Aug 2022 13:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT015.mail.protection.outlook.com (100.127.142.112) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16 via Frontend Transport; Fri, 5 Aug 2022 13:26:25 +0000
Received: ("Tessian outbound 73dd6a25223d:v123"); Fri, 05 Aug 2022 13:26:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9491291f008b9d32
X-CR-MTA-TID: 64aa7808
Received: from 77fc60f9276d.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 39190DC3-7FF2-4B09-AD31-5346C30EB702.1;
        Fri, 05 Aug 2022 13:26:14 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 77fc60f9276d.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 05 Aug 2022 13:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS35MbdOfJeXlfsVMx68tRr4m718veBZVcpAhvQnzeH0uAdLg7Pma2vTihPlnfTCV8iUH35fzSWedzuhX74LUeb9mJC6Ho59h/hh3ey+6S0T90IFdFG9qMUNZAGVOgZXG43qPZlgfLwmmOBQZgmbYQRIz2hOMmAkVOh9k2fbJyq+vcLvSZquLYlOmUaVdyx2OP669hl2Q6tnURKpJTRo7wZdJyT9MilMveLLdSe8hOPxHVxpFGOn3TVST2yIyLVOsjX471Wm1731kJlLfDH9qkxaYARq3bdVoedePYMuWeywSRfgR6JzuoI+lMU2IJiqWmfd8Jth4Qub3GCcPBUmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=KDoKryvDexi09ZcJ5Zu6ZCsxhqGH0DLBKt29s9/VUr0A1wXU4qHP3DnY5valw+4XrCeLnDOqMr+Q7PqUZN9yiIcsACn/75Yvf2FoxlcZE8vAdHS5bj5F20yE1yuwiLKISyW/n2IdxFZP8N2T/uzWX5b8amPeIU9JmeqTeQF+M8QZkbQ9IRotxf6D7r4nn+kcooFl4LBpf27C5k9pahIhm+BY+TFEvQLfyNxVV2x2XRrVnvAnD/ahLacDpq4QQoIICqkMpI/He+emlZPwGxOsfpHCBmWvoZ4E7Yvm8heTCIkiMES8hbGvDWtVDIxZsuHbiaN2DPLc03nKSHbrQL4GGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLHCTlNxGtjG+uKWbUe0EO8yyXoW99z9qXgflzUi5TE=;
 b=G9t/htXVfON41/BR9Kbkqmau9a7aWU9aC4B4saIlDAQ1vtLYbNIf+ajofNKc2DVE5h8zLreLVz9pIDcsQT58p9+KQ6uRscIJTjieAAv6a1Hlxrx2XwfeaeUew/ya8G8MFuatb+9NQXXUHQI3hi0Db/JxSMefkjMLd1Cpkjt1cAY=
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com (2603:10a6:803:7c::27)
 by PR2PR08MB4697.eurprd08.prod.outlook.com (2603:10a6:101:18::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 13:26:12 +0000
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c]) by VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c%4]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 13:26:11 +0000
From:   Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "maz@kernel.org" <maz@kernel.org>, nd <nd@arm.com>,
        Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [PATCH] arm:Add PSCI_CPU_OFF testscase to  arm/psci testsuite.
Thread-Topic: [PATCH] arm:Add PSCI_CPU_OFF testscase to  arm/psci testsuite.
Thread-Index: AQHYqM7ulxgdpWdTN06xVkGrefvctA==
Date:   Fri, 5 Aug 2022 13:26:11 +0000
Message-ID: <20220805132601.461751-1-Nikita.Venkatesh@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-MS-Office365-Filtering-Correlation-Id: 2023cddb-8db6-44a8-98ce-08da76e6189a
x-ms-traffictypediagnostic: PR2PR08MB4697:EE_|DBAEUR03FT015:EE_|VI1PR08MB4400:EE_
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: S6UaC1Y8hxlbGfUg+H6nNHPm5NtyrwSleyJjVtwxBgGoS0M1ZjeUwSdU0v0jEkwj2xyOKAYUK6eACSf2ce0MNENcrVskHTfOPtUzB5fJKoMml2vmdU/psYjrqkrEDfwPXUVhFD+3Deh4vFO8Z7sawEK2eI7OBqJR+reTsEKwpJHdXvD41ZJ9jHn9aB8JBKCud1XMOYeiuV6wcbSx3d8ciPPMjYRElxM4gUBl5732du8eJ4IC1kB6IWGYmP8fq++hQimrVdRLlbHWyJcdL2I+Q9t4b1zyVDJqHWzRLTa24DlNCPPLi3FDBtSCW6wjPJWFnWFRD88DVU9iAvGAlgVXgejxWNG7qnBubSUvPKi/tUaPYYXDQMs9tK2HPhVNOg7ka/GcNKOhAYVIZdve6DhG6wSik9jReDBNeTXpa4L4dx0RlJM0jkMGR+eXWl46DmWx6QQTrqGmSN2ovxZRwg/AJA2FZyX62rvTZ+Ai1mwUvKxGCd4mAT7dlNmlcRqy5fK2hZLwKK5fOudeZw9y8s70xBmAWK+odFJZvet/diQq0LsN8UTktCDOWQPu5bY+PUJX+FYxqgbmtI1NNEqWv/zcREm4t1BFxsTEQC+C/Lh8M/iXITPNEVMH/UgYv0m9IrqAJs7SvAnS1caTNlUV/TAK4AZuBnxNn6bYWACOtSU6m6UK+CYeA4DF2zj0lUbOTbvGT6B6synbfQcJKtfJv48+aRzMCTQt7I9ZLj7SuuoUaT0GChafIVbPzaEVpfITmkR5n/6w4lmvsTABU/yc61vwb0ZvWeqpHkTvNVw/SJNiFU/anmlRsEgoCXAeyslOUqYc
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3485.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(316002)(2616005)(1076003)(186003)(83380400001)(36756003)(86362001)(2906002)(38100700002)(64756008)(66446008)(76116006)(66476007)(8676002)(4326008)(122000001)(91956017)(38070700005)(8936002)(5660300002)(26005)(6512007)(41300700001)(6486002)(478600001)(71200400001)(66556008)(66946007)(54906003)(110136005)(6506007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR08MB4697
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DBAEUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 948e0042-d565-4b93-63a4-08da76e6108b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhY5wUiyVM+yCWZ2HhWJazzPWb7LByrm1LbwupGwgLEarxuwQzUnTfK/Kj0lNBMlUpFH+2WgEUR57SbCoEvtogTNQoLZ6qAsdEaE2HS74lXGHTEcMvhihw56DoJRuTdcLPljd8YtRgrujKa4U/gaCaKT5WNdzJUZ8p+cNimXMfZGAEy3geCYpCgBIRtjnIzIwL5bf0oYk1riKl9vw8gwdFwAHA5WxZkJff88kD5pefxJiWgNQjwkOEHykah6asCqHlYChTrx2FlSzuirxi65MeZdDmsiYG9E0M1QE3JoOFbcr71UghTzwGcE7g9r6xJYe9kL2m4mMR8IoAVpILicu15UpC9+VN0LKfRtMHlzjgYB6wZtGs3OA6D0iq9eyt43iYxGIn5Cc0d4r78vooUyFrem6AqwwooWAE378alfYxpud0Ul2EEeVrG8ISSqq7Lu6KM3WKeRtz5PWd0izU0YoH94R80tYaDGoXyJbx7c7D0in+bSfqlvWecF28A2HaIV0lIZdzEU4WkLDOwUQHzHpL8JGweaLNnJCUgQopd5bnv4vq2DgaNlzxFevpZzyq0pWjRW959D+bd4JeXMXo60WYLdetPxaF63kwVlJ3eoLgpDnjijhMm4k0ngm/mYkeWIpv2inyqoi1oFNweSGnIAk7VDqq+f7j7rLe1UzxiiOu92jhH5j6v0ZnLTWOWY4dIRHUNonroahDy/6BSoJBCMC3w+H2opeprcQ1AJhrRCRctLT3d6ZI1Jxtf6QjBgZRznnSUIKdB7YcVmK56IqS7zA9pVwpN51oK+Hto4iE9J+hqeu66YQxzam6jfs+kPay0H
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(376002)(136003)(40470700004)(46966006)(36840700001)(478600001)(6486002)(6512007)(41300700001)(26005)(6506007)(40480700001)(82310400005)(2906002)(36756003)(110136005)(86362001)(316002)(54906003)(81166007)(336012)(82740400003)(83380400001)(47076005)(40460700003)(356005)(8936002)(8676002)(70206006)(5660300002)(4326008)(70586007)(1076003)(186003)(36860700001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 13:26:25.3686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2023cddb-8db6-44a8-98ce-08da76e6189a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DBAEUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4400
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test uses the following method.

The primary CPU brings up all the secondary CPUs, which are held in a wait
loop. Once the primary releases the CPUs, each of the secondary CPUs
proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
the status of the call is updated by the secondary CPU in cpu_off_done[].

The primary CPU waits for all the secondary CPUs to update the cpumask
and then proceeds to check for the status of the individual CPU CPU_OFF
request. There is a chance that some CPUs might fail at the CPU_OFF
request and come back and update the status once the primary CPU has
finished the scan. There is no fool proof method to handle this. As of
now, we add a 1sec delay between the cpumask check and the scan for the
status.

The test can be triggered by "cpu-off" command line argument.

Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
---
 arm/psci.c        | 87 +++++++++++++++++++++++++++++++++++++++++------
 arm/unittests.cfg |  6 ++++
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722..5485718 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -12,6 +12,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
+#include <asm/delay.h>
+
+#define CPU_OFF_TEST_WAIT_TIME	1000
=20
 static bool invalid_function_exception;
=20
@@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
 }
=20
 static int cpu_on_ret[NR_CPUS];
-static cpumask_t cpu_on_ready, cpu_on_done;
+static bool cpu_off_success[NR_CPUS];
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
 static volatile int cpu_on_start;
+static volatile int cpu_off_start;
=20
 static void cpu_on_secondary_entry(void)
 {
@@ -83,6 +88,19 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
=20
+static void cpu_off_secondary_test(void)
+{
+	int cpu =3D smp_processor_id();
+	while (!cpu_off_start)
+		cpu_relax();
+	/* On to the CPU off test */
+	cpu_off_success[cpu] =3D true;
+	cpumask_set_cpu(cpu, &cpu_off_done);
+	cpu_psci_cpu_die();
+	/* The CPU shouldn't execute the next steps. */
+	cpu_off_success[cpu] =3D false;
+}
+
 static bool psci_cpu_on_test(void)
 {
 	bool failed =3D false;
@@ -130,7 +148,56 @@ static bool psci_cpu_on_test(void)
 	return !failed;
 }
=20
-int main(void)
+static bool psci_cpu_off_test(void)
+{
+	bool failed =3D false;
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		if (cpu < 1)
+			continue;
+		smp_boot_secondary(cpu, cpu_off_secondary_test);
+	}
+
+	cpumask_set_cpu(0, &cpu_off_done);
+
+	report_info("PSCI OFF Test");
+
+	/* Release the CPUs */
+	cpu_off_start =3D 1;
+
+	/* Wait until all are done */
+	while (!cpumask_full(&cpu_off_done))
+		cpu_relax();
+
+	/* Allow all the other CPUs to complete the operation */
+	mdelay(CPU_OFF_TEST_WAIT_TIME);
+
+	for_each_present_cpu(cpu) {
+		if (cpu =3D=3D 0)
+			continue;
+
+		if (!cpu_off_success[cpu]) {
+			report_info("CPU%d could not be turned off", cpu);
+			failed =3D true;
+		}
+	}
+	return !failed;
+}
+
+static void run_default_psci_tests(void)
+{
+	report(psci_invalid_function(), "invalid-function");
+	report(psci_affinity_info_on(), "affinity-info-on");
+	report(psci_affinity_info_off(), "affinity-info-off");
+	if (ERRATA(6c7a5dce22b3)){
+		report(psci_cpu_on_test(), "cpu-on");
+	} else {
+		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=3Dy to=
 enable.");
+	}
+}
+
+int main(int argc, char **argv)
 {
 	int ver =3D psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
=20
@@ -143,15 +210,15 @@ int main(void)
=20
 	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
 					  PSCI_VERSION_MINOR(ver));
-	report(psci_invalid_function(), "invalid-function");
-	report(psci_affinity_info_on(), "affinity-info-on");
-	report(psci_affinity_info_off(), "affinity-info-off");
-
-	if (ERRATA(6c7a5dce22b3))
-		report(psci_cpu_on_test(), "cpu-on");
-	else
-		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=3Dy to=
 enable.");
=20
+	if (argc < 2) {
+		run_default_psci_tests();
+	} else if (strcmp(argv[1], "cpu-off") =3D=3D 0) {
+		report(psci_cpu_off_test(), "cpu-off");
+	} else {
+		printf("Unknown subtest\n");
+		abort();
+	}
 done:
 #if 0
 	report_summary();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b55..02ffbcd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -218,6 +218,12 @@ file =3D psci.flat
 smp =3D $MAX_SMP
 groups =3D psci
=20
+[psci-cpu-off]
+file =3D psci.flat
+groups =3D psci
+smp =3D $MAX_SMP
+extra_params =3D -append 'cpu-off'
+
 # Timer tests
 [timer]
 file =3D timer.flat
--=20
2.25.1
