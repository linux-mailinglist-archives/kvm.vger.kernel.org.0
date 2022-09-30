Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2105F0E91
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiI3POx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiI3POv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:14:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B992A42E
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvFlIFLlXtyEWK5VClJco2FswDY6rESuz7hetIIiTvGR1UVf9XY9wtRjN5Ww4zsdTHivfzdV0JabkpQGgOL7roFfOEHIiSxXLurJ136M/HQn4qtxpKdSIzW09Z7kAscKOkIjDx7kdyBVUGP/0uVfASUwqSHDbZrkqZdZaxn7D8P94U9zUzAM+PA953XhqjFOA0EWS0WVD/Nqn6TO2O15P/hFF2IljcDEwwq5BFQl2648EvZdqc2GnOe5x5uXPf295LG3VKLWCiLRGV8+WQ0pnYg8ebvdf3bJr+5tRSY3fn4mU0BUuVV+tCBO9vt5VdC5UIZ81zhTY2/JJXtcUAfrRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny+56CN+17o+RsA99DTfkXUsCfsprdCXJprhUGwsgYU=;
 b=ZhdGzl65I3r6itSqiWzapNxfAJNHBNmT33byqh8HSIwxO3rFmg5T7ReP6Pd3e0ze7FU2EYUBWCjP32jR30MRIwzS/0ZvgzDg1Bz/15DUT7hX+BDIW+UoQigLg5b5J83DY70Hjkq0q8DPazN+NQf/fmHr5boDpr5AzIBnMOSvYwU+Sg4RJEefSfcyLB4Maia77B9c+3QzVsJ3C0q4BfCpyrVfye/4JeZAa6WZ7vR/Y/+KXukWXp2Udb4TIaj/KbDKWllFFMp5bFq/C3xni1EKVcnjcJ4e3xctmGdckKK/mjnXyVn8p7SCVMH+UfDBKrE6muECJ5ANUSgzXUB3TkgSlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny+56CN+17o+RsA99DTfkXUsCfsprdCXJprhUGwsgYU=;
 b=IWivGri9e9IJj4OZCQqEjJyEHWhjGTRqKUd5cwWIw+J6Rqk7EkPRDSyjLzxhYnq4GDjvKup6JyGSWY28eDpGgcoAz579Uv7JjgJO5viTPvUP35cs1to1ctw4drFmB6iDfhl2xyLbQ1QsRczXM5OToFz2YhDHRHkjGUEnrYFvAh0=
Received: from DM6PR13CA0049.namprd13.prod.outlook.com (2603:10b6:5:134::26)
 by BN9PR12MB5365.namprd12.prod.outlook.com (2603:10b6:408:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 15:14:45 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::35) by DM6PR13CA0049.outlook.office365.com
 (2603:10b6:5:134::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15 via Frontend
 Transport; Fri, 30 Sep 2022 15:14:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:14:45 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 30 Sep
 2022 10:14:43 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH 0/4] Qemu SEV reduced-phys-bits fixes
Date:   Fri, 30 Sep 2022 10:14:26 -0500
Message-ID: <cover.1664550870.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|BN9PR12MB5365:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e3cd187-e28e-454b-9036-08daa2f6824e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EOWTUvPdWBs1GQy5PlOIPZXhxFAwcOeIfLsR9B5uJT4Ur3MWCyCLCWCVydSwIgVUNRRl+oW3cKDwhxaCsUDFyqRXRIicSmrO4XPNCRYZbIkvpLzXoAw3fKYVZ4GMrYFuFlqJlov94JKTRo0t2dS1zbKiOOt9uvFNWWpT2+GgI1KTxzqd5SFPhVPRCidoid8edag+Zy0wIW7juKmOeRQL1c6E52zqpZYD7+yI5G7KRuQhFWw2zpnBTXrVI8gT/b4H7W97Ks5+WrREwvfrCxaP7yfwuNnbLrnIPNQqNY9OegzFwJWQCSjyQsDrEK5ra/da4EB1G/EGQlJ4/GkVT+icUxwx2Rg8SlANZkGeLqt4x4YclFdgVFn6GaGFUK+aJW08BrxziSgr+GpDLJFPEv72MoKBKetE1x/5Yf0OD+TZsQjGqQwnVXlj4m70NrcoXZIysE4K9Pv8cS4m08PxA+8t+kU10WJdLcqJmKA9RpRYCHs/lEqE+Xt0TiTXXjVyhc2QbsSP9//F6iUkXlRLLIzVo2NBY8WD5LWQ3fFIplbWlArrbNMucbE+vJjN28ECe1QoGaryVOeReoJvh+OwIMApqU5Vj8gYsHPl7UZSXsoQ71PTOkOkCHV1RB5mHYINi3GMGmwWqZmaeOYayRT001OgKhmIa/msmB4CRgWpEcR1IxjNTkiveEZxvPqq70ez15CQcBse3bDefIqNaJEARLq3vWwuJ/SsR7Mbp2Vx89mOtQOVHUUQwa9jChx0NXZlTjjdNXy0whOUgro3HksiplWuBk/ddzZ2PmMY319lAdqxvxouu8Tm4lUg7/Q10JcDHMog41XFmphm+5vE0/NiNV5yhw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(40480700001)(356005)(83380400001)(478600001)(81166007)(966005)(82740400003)(82310400005)(36756003)(26005)(8936002)(6666004)(2906002)(47076005)(5660300002)(186003)(16526019)(316002)(4326008)(426003)(8676002)(36860700001)(2616005)(70206006)(70586007)(86362001)(7696005)(41300700001)(110136005)(54906003)(336012)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:14:45.7094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3cd187-e28e-454b-9036-08daa2f6824e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5365
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series fixes up and tries to remove some confusion around the
SEV reduced-phys-bits parameter.

Based on the "AMD64 Architecture Programmer's Manual Volume 2: System
Programming", section "15.34.6 Page Table Support" [1], a guest should
only ever see a maximum of 1 bit of physical address space reduction.

- Update the documentation, to change the default value from 5 to 1.
- Update the validation of the parameter to ensure the parameter value
  is within the range of the CPUID field that it is reported in. To allow
  for backwards compatibility, especially to support the previously
  documented value of 5, allow the full range of values from 1 to 63
  (0 was never allowed).
- Update the setting of CPUID 0x8000001F_EBX to limit the values to the
  field width that they are setting as an additional safeguard.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf

Tom Lendacky (4):
  qapi, i386/sev: Change the reduced-phys-bits value from 5 to 1
  qemu-options.hx: Update the reduced-phys-bits documentation
  i386/sev: Update checks and information related to reduced-phys-bits
  i386/cpu: Update how the EBX register of CPUID 0x8000001F is set

 qapi/misc-target.json |  2 +-
 qemu-options.hx       |  4 ++--
 target/i386/cpu.c     |  4 ++--
 target/i386/sev.c     | 17 ++++++++++++++---
 4 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.37.3

