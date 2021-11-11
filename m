Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995CD44DCD8
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 22:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhKKVEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 16:04:43 -0500
Received: from mail-bn8nam08on2083.outbound.protection.outlook.com ([40.107.100.83]:6395
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233819AbhKKVEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 16:04:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LplBoZdFVsmIZBpbdO+1PFMVWSEez4Q7TZQNodP+2UFKgtb8hKuGpTBvsRGB3hgaIkMrRJs2tJEz1BUtGFn3d2V7s52RUv6/EWOiYhkbO3di3lbvdlwKSH0ukLduaMNl1rayJ3Mq+D6rP0qk+bVm/19oOX1QeBUV4yOH490SwnVdUBQKybRkdC9LZmgUuWzRRwMHZFZZtkBMYKOMxNLj17voMsu+dSIxrUF47b8blJkZ4be0XxFU50KeaEjkS0MY/0GHFJlhL1oGahwKUvXD023MhmBW4dTHZ5c7Nh6HPvIsnWZ5LSwPjbv0k6rusYv1NfTImpB7I+8k+pi5OcFcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSZTccM7CTZzlsVE8T6oPql/YDy76xD7dhVmzjVUC7Y=;
 b=KK85MdVQKWJFD3pCMBkmnUpCb28R16vg8CaSG3P3OCmgKBnGXSmHezsTjjwjvu1VKqj2YxNKLNtTTj35IPiwgkGl/OwXWo+kaOMesLz/1iuOwld6USX4zJFQA8hGmV3p9moeXC8ooD5MsUXEPgvHMPFRMz3UzxkW97Jt6Usg/3jL86VN44baXqE5JugS/aUT/qmT+KIq+Cud/bkhccPIcBCc6O/ahkSUz/vXFQJFrQmHQPpgs1L7Vr1itVSya/mrWjcao/eH+omP6/W9enksCtf6YZNJj7fhV7V69fnWCuNOFIv8OtN7schIKkEDA8SCXJq7bTvF6M+wXZX5eWkisw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSZTccM7CTZzlsVE8T6oPql/YDy76xD7dhVmzjVUC7Y=;
 b=AECIylQl5QBee7p0mr5/bP0CspLmu8ZTh0fqEUJz5/eLl9BAdj2JM4Rj3LfPPVfkBa9zE8W/LX13bQnPNnBe5UFRYVgCRfHhtJ+4O9sL3gwgKhGz42eQlaleHorGv7xt0jBj83GbnCgZUeR2h/j7oHVdT+WYjO26CMQEl89rLGY=
Received: from MWHPR18CA0052.namprd18.prod.outlook.com (2603:10b6:300:39::14)
 by CY4PR1201MB2550.namprd12.prod.outlook.com (2603:10b6:903:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Thu, 11 Nov
 2021 21:01:51 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::dd) by MWHPR18CA0052.outlook.office365.com
 (2603:10b6:300:39::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Thu, 11 Nov 2021 21:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.19 via Frontend Transport; Thu, 11 Nov 2021 21:01:51 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 11 Nov
 2021 15:01:49 -0600
Subject: [kvm-unit-tests PATCH] access: Split the reserved bit test for LA57
From:   Babu Moger <babu.moger@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>
Date:   Thu, 11 Nov 2021 15:01:49 -0600
Message-ID: <163666439473.76718.7019768408374724345.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 808550e5-96f5-40d0-d521-08d9a5567be5
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2550:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25505836ABF6955C9A7595EE95949@CY4PR1201MB2550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qry19HimuarJuXypekKD5SFLGF5mLA209OSSQCd7T+575vDb1+diDOeX7dLJ5GBsg/oGnUfjetrY6cJQQF1YFRAADrppp7unq0laWwP15tqDEhGEwxv/sWvS114F8vppUexAosXAuKHHvOHLUiJZqzjmiyGsYJhgHwDJR6vPwm+LGt8zAb3KqwhaafkQcZ3LEwnyhQDoIHyY+aKVvO/AWtybbMmBFqzulodBgJcdeQ+aXlc4RCG0Ukh8TIhzu+uF3MuMeEX1GQO6/2Kji15Elr4bo4fEjrWRFc+7xr8IEs3yK7SyPHVmxdsXI4R4uVulRKfUDTbf6KzCFeSh86+Vck5ILWi4Gu+5+K4XhWAj4BFj6ZqlKduC0AZuA+C5zUVer24r7u0v2tor8tPlPO9zHJt8oJ+vFIg/Oa7Ht0wa5c0xwSCsVS2DB1RCUgprDAsK1sgqXdtF6BWQFb6XmtE/uBXyTVyE826k7LNiZ3kWPSJAJIuowP2jXyuppl0u7/NVU3mwk9ZUeoQ3hWwHoUn3XB3+wFXcpwON4RYu5dN3/chQItT6zqIPAK9jHTeSCF+egG7BuFimhlgO1tmJYftR4wAp59gH6AhEhxbNm6zzMSVZRmW0pAd14WdadLQU40ABAtgfapKZtVxA5coBOdlYH6yzDnVArV51Q94O/lkSzcag8f5cwTqRFhFVgrsTVALxBM9jHsgFnAtFRow16ySWkSh4BmMhuQymhNC0sul3rUBy1GHc8xwb6EU6ca85cByfRDOZyDrl3U/nv4h8rxevsg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(82310400003)(6916009)(26005)(426003)(44832011)(4326008)(8936002)(103116003)(8676002)(47076005)(33716001)(16526019)(186003)(86362001)(336012)(508600001)(5660300002)(70586007)(16576012)(81166007)(316002)(70206006)(9686003)(83380400001)(36860700001)(356005)(2906002)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 21:01:51.2367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 808550e5-96f5-40d0-d521-08d9a5567be5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2550
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test ./x86/access fails with a timeout when the system supports=0A=
LA57.=0A=
=0A=
../tests/access=0A=
BUILD_HEAD=3D49934b5a=0A=
timeout -k 1s --foreground 180 /usr/local/bin/qemu-system-x86_64 --no-reboo=
t=0A=
-nodefaults -device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=
=3D0x4=0A=
-vnc none -serial stdio -device pci-testdev -machine accel=3Dkvm=0A=
-kernel /tmp/tmp.X0UHRhah33 -smp 1 -cpu max # -initrd /tmp/tmp.4nqs81FZ5t=
=0A=
enabling apic=0A=
starting test=0A=
=0A=
run=0A=
...........................................................................=
=0A=
...........................................................................=
=0A=
..................................................................=0A=
14008327 tests, 0 failures=0A=
starting 5-level paging test.=0A=
=0A=
run=0A=
...........................................................................=
=0A=
...........................................................................=
=0A=
........................................=0A=
qemu-system-x86_64: terminating on signal 15 from pid 56169 (timeout)=0A=
FAIL access (timeout; duration=3D180)=0A=
=0A=
The reason is, the test runs twice when LA57 is supported.=0A=
Once with 4-level paging and once with 5-level paging. It cannot complete=
=0A=
both these tests with default timeout of 180 seconds.=0A=
=0A=
Fix the problem by splitting the test into two.=0A=
One for the 4-level paging and one for the 5-level paging.=0A=
=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
Note: Let me know if there is a better way to take care of this.=0A=
=0A=
 x86/access.c      |   23 ++++++++++++++++-------=0A=
 x86/unittests.cfg |    6 ++++++=0A=
 2 files changed, 22 insertions(+), 7 deletions(-)=0A=
=0A=
diff --git a/x86/access.c b/x86/access.c=0A=
index 4725bbd..d25066a 100644=0A=
--- a/x86/access.c=0A=
+++ b/x86/access.c=0A=
@@ -1141,19 +1141,28 @@ static int ac_test_run(void)=0A=
     return successes =3D=3D tests;=0A=
 }=0A=
 =0A=
-int main(void)=0A=
+int main(int argc, char *argv[])=0A=
 {=0A=
-    int r;=0A=
-=0A=
-    printf("starting test\n\n");=0A=
-    page_table_levels =3D 4;=0A=
-    r =3D ac_test_run();=0A=
+    int r, la57;=0A=
+=0A=
+    if ((argc =3D=3D 2) && (strcmp(argv[1], "la57") =3D=3D 0)) {=0A=
+        if (this_cpu_has(X86_FEATURE_LA57))=0A=
+            la57 =3D 1;=0A=
+        else {=0A=
+            report_skip("5-level paging not supported, skip...");=0A=
+            return report_summary();=0A=
+        }=0A=
+    }=0A=
 =0A=
-    if (this_cpu_has(X86_FEATURE_LA57)) {=0A=
+    if (la57) {=0A=
         page_table_levels =3D 5;=0A=
         printf("starting 5-level paging test.\n\n");=0A=
         setup_5level_page_table();=0A=
         r =3D ac_test_run();=0A=
+    } else {=0A=
+        page_table_levels =3D 4;=0A=
+        printf("starting test.\n\n");=0A=
+        r =3D ac_test_run();=0A=
     }=0A=
 =0A=
     return r ? 0 : 1;=0A=
diff --git a/x86/unittests.cfg b/x86/unittests.cfg=0A=
index 3000e53..475fcc6 100644=0A=
--- a/x86/unittests.cfg=0A=
+++ b/x86/unittests.cfg=0A=
@@ -119,6 +119,12 @@ arch =3D x86_64=0A=
 extra_params =3D -cpu max=0A=
 timeout =3D 180=0A=
 =0A=
+[access-la57]=0A=
+file =3D access.flat=0A=
+arch =3D x86_64=0A=
+extra_params =3D -cpu max -append "la57"=0A=
+timeout =3D 180=0A=
+=0A=
 [access-reduced-maxphyaddr]=0A=
 file =3D access.flat=0A=
 arch =3D x86_64=0A=
=0A=

