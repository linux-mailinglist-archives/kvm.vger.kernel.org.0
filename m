Return-Path: <kvm+bounces-4172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D05E80E86B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 11:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FCA91C20B09
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 10:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADDC59175;
	Tue, 12 Dec 2023 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="OhcR7nR7"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2051.outbound.protection.outlook.com [40.107.135.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872E5E4;
	Tue, 12 Dec 2023 02:00:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEfBuEC2hEBs+1CxLORxunCUgdv4UI/zZORIQq2LAyoJF5sPhwc/Yp2+L6kogMsc7BU4rZnbblXLXLeyDqLMF+JK6AIdLaVnpIyGBkXdz02rarm48eC+xmNoO2PpPLjUTCbMNRlvZ3nSbatKoYLiA/oe2QZkk0LNKIWK0LYaTiIOIFBTrqtfj+/idng/1/FY2AIJuVXCnBoSZ93YeC6o/3uYyVGLwDCKSAgWN7aHYZgWltdVFv5hthwymyrc0Hr4hfsadKpMyoE0q2CfQ8fyGZq2+KeEvT8tS45dmJKNDfLiJodf2wypJhp4r1zipc/VEfwS/Wk58ZDScIjl3qPKZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpQXwji0BqzNCO8LTyDjolxJwTZZIdsvVHQzVVEB9A4=;
 b=bY6hOQldK+y6Xs/q6sCr9s8ckp1UlDneMW3ijT2HxWIWVpz8lS+3Vt9bBw7NfrS/qqSygev4K7UVRjtSgcfip/fw3szz4mUhybzkgpIdD5dZ9xemgvFmlBUxpiFeRcxNfpk3cvbEvFektgDSOB1HRuJF3jtTjjdFNG7e0ltByoA2/jYrp0aWz0AERY0TXkp/paI7wQ2fxNESBhvogOV0t6g/NRhCm5F5ZB7793SH43fYaCZVViHAIobpiVhEjt7LTW6M+vM/cu39ksp4N3+wNWKe2uMDU2ps+OT9hRNg1IvenaWa0sy6+qxe95nDi0oN3pwv9lu4Te9Pq89RAcXt9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpQXwji0BqzNCO8LTyDjolxJwTZZIdsvVHQzVVEB9A4=;
 b=OhcR7nR7xVxmB4eM73U/XilDjLAcKfFP8wpCSLbN8UXr/QjYP3RAAPn88JcV41Kwmhwp5rPOr9ymDRrdBxSnuTIVlhfuWxddSldgHJ+5/1K+2mRHK09zIDTkvhRV1UyLbSD0RnVa4H2Dfcvu7JlJdep2GwrMxR6+Ffzb/fQ9/9W08FP+hJuq5nTQBgQffcRht5KbSI0h60vJlyepATyxJZZsj6gQmkJ4+F0NVxdOnvqfsaBzsXCnyQnh7CYEnBknNyfqpqXIu1CZc5QRWb27c64y8Hy7kmx9OXTUEAB3SKu0FQKc1L7sFt+6Uoa3S6Rs3NQXnUHmgnvVsfdhTcQUOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by FR0P281MB1754.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:86::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Tue, 12 Dec
 2023 10:00:03 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::312f:5918:e76a:3b79]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::312f:5918:e76a:3b79%6]) with mapi id 15.20.7068.033; Tue, 12 Dec 2023
 10:00:02 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: kvm@vger.kernel.org
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/emulator: emulate movbe with operand-size prefix
Date: Tue, 12 Dec 2023 10:59:37 +0100
Message-ID: <20231212095938.26731-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.42.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0352.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7d::8) To FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:7a::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB1567:EE_|FR0P281MB1754:EE_
X-MS-Office365-Filtering-Correlation-Id: fcfb2943-21f2-4369-45c5-08dbfaf91c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5NDcdwH6bZlzoomCzzPE/OSPlfgd3pJvmFiSyAW9UoQNulwxR6bLYKDfExBQ3CXBbyfUqYA+ITy1PTxU0vf0TjIL5yuHGUdZgpKnUlW+V/c5pwnz07xJxSDTvLBSUSUEf3K55eWKddSL8AswKKS1322X7EltWybNpXFHphNFE0G9dr1w/hd/g/FxAczdC67OK+ITD4NLalTTc13dCIi4u2cq2JlcMIKQBXYYVxCLQ6job5ktCwjCn+TCnhBUUT2zNnVqkiY1jWERCDX30eIaFpdLhyxnV0EoE1v+gp5Jh7D+ijfL/emg7MS1qwMlYt5xyOUNst6m24EoNNKYMxYCyt5rZe/KmDpvoQRlDhvkbS3MNnO/PgmECi57c5lkaZxschm7cE1MOdVcsj2wb00p3MgbZADtcGXCoGCihGCPKDpowqr/KqaR89Fs5kgkdCetmB/8KRQDYIc5q93UzPX3zdtnExI8VXIyF2vgP8vwPJTk9qfwPyMGKGZlvtzbVDFCyIN9PvRK1frigsfRIDNcQGAL7VXXfm5EjLEZhvpf7wwhpyuRiEMrQh4wBG+LqPZWxOVT4ju8UcOTTceYKuQxzglQsjT2JJMyXvxOwR/dPwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(39830400003)(396003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(83380400001)(52116002)(6512007)(6506007)(2616005)(1076003)(38100700002)(44832011)(8936002)(5660300002)(4326008)(8676002)(41300700001)(7416002)(2906002)(6486002)(478600001)(6666004)(316002)(66476007)(6916009)(54906003)(66946007)(36756003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h5OyoDre7f9HIreByZbZw6j1JDC5BzpBXkdA6GDrZycgvghravkYTKU/mGKC?=
 =?us-ascii?Q?9dQTMFlSik065woUtsWErx4+u3CTGxUDgocqtFzNnyjHTsz+3Fd/DPmCnZ9o?=
 =?us-ascii?Q?lhF51B+q8+YOKtBbLVGDLWE7I6puNeXtG0Xll/5naCWNsldA/Qj2Lc9Wu7he?=
 =?us-ascii?Q?BypLc+eTTYY/Q/IvJ90ZjLMovaiCSpnsIrk8UYZFLnikmtPwbKA0j8XjlTh3?=
 =?us-ascii?Q?2svQLyT3OI82XBsIqoH/WkZhEQIW00Yt4XsAm708U57mh/qzckD+RIzRww53?=
 =?us-ascii?Q?hG2HANSA8y8RjGy/SQ6NKbXILOzS26GOnMpSBm1lYFlSler98nH4wwsjKYVg?=
 =?us-ascii?Q?7RtkoOi3q9MkLPgBAoTI4NPUfYKaYOgMLaFGb6hmTk2aO4FzIXf+TD8j18Zw?=
 =?us-ascii?Q?NQgPG6LSOThILARrOjdkz7hHY9nTuLiuEz2WQ0IkoyoGHUZ4jESsHd+9MwXg?=
 =?us-ascii?Q?i+DcDqwOJeNy+6t4QxlEuW3bsrwrD9m4ziYk49hT4Yc4ZL2o5wlD5+hiql79?=
 =?us-ascii?Q?oHcM2asmIkwdVZLzAVi0VCVQapo4IO/AbB2RnEsSUvV/jVsBVsd5+P1BA0zV?=
 =?us-ascii?Q?UHQ1IWCscWrl5DDUVTkCJjCA2PsvNLbQa2Z8oudVz9Rz5/GTCADYBiaIXmi3?=
 =?us-ascii?Q?51iJVl//ESnqRqi4S2ELf5OHOXrT8PwGrcSVlPY4VO7u77AvRtUKkuHPmzuI?=
 =?us-ascii?Q?/tf6x+W+tbbJ/NputV2nm2G5tqaieRVkbrlMqv6xiJsgL1P/dUCufsH+yxtu?=
 =?us-ascii?Q?WWzvqGmWOXlOd2wnkDoU8kVtjc4E9TuBbbwiqhK4TIPkrfU8FXUh9B6+p87I?=
 =?us-ascii?Q?qXVtwchfIxlH3Da4dVz6nz9nE/2BlCS7cEZcI3xEMrwR6McLc7lbXKFpK4Sz?=
 =?us-ascii?Q?sgzKxkXclyHJA8Tpc9nCjbHVeRlpPjeAKtd6IS/5uyq1qqBuBE/DpNQC6plB?=
 =?us-ascii?Q?RgISEY5+n0dqTjupBJrk4dilHWb8uQbiy4VX+25+7etdDyrU0V4k18jKjwo4?=
 =?us-ascii?Q?cQ/409Xd756dBT8ZEs8CIitSzrbVQzxztJF2q5qbd2YMJyV1c50QWAY7WRyt?=
 =?us-ascii?Q?l4VBJX2yGX2sZN8QU+MDj0VZRj4uaP1OLrrpf6t5SXUTLS0aHILyZO0AtzcA?=
 =?us-ascii?Q?TcHHU7QsHniU0cBMUgxmJqD6fVTbak7jsMKHVAgIRRz8+OKPkMk/MsZ0oAV3?=
 =?us-ascii?Q?7mDH0JhbbA0YEBHkxguVtQgwRb+R/00Z/b49/brWXqKH0hEzjl7HRHnpWLAq?=
 =?us-ascii?Q?aWlCWsfw5FpjZpUvWwwSsejg6yyWqxU1AEAFPITam3qJTKvSH5sriEURLERv?=
 =?us-ascii?Q?6qhrA2EtQxHWvbSxcjdihiKQ2LYlnqAsU6Z1TQELa76zb87jW/blETXMJEBs?=
 =?us-ascii?Q?GF+5SUF7S4Nc2PCbPEjFNP5jQajkhWODie2OJTyjdqeOxN6cMjZkaMFa8atC?=
 =?us-ascii?Q?BUGWlYxzyaD8EtC2fze0SzpCIL/jPelep92hSN36MP4h8eWukN3xDOlTKpuG?=
 =?us-ascii?Q?ffEaUCbG8E6RojCvtSN9TDZD6xXK5dO+OhZHTxmbDE5SmeaUnrdvQS5LcsfF?=
 =?us-ascii?Q?gKTDXcOSb98ASAUjgkemWUCQeFA7fsLyRVIYrgdszg/g0xAxBNm83RCwT/K8?=
 =?us-ascii?Q?8Wcfym2GIzsbj+gu22UZoC6s+sgBmj7Z9CBLgJ5AOJKKyn/ExecRq4tW6b3V?=
 =?us-ascii?Q?A2nqzc0AN8I0dijUWoPMHt2bHyqGcA5ftfQfBXknEXyGbUHt?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfb2943-21f2-4369-45c5-08dbfaf91c15
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 10:00:02.9170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0p8YRguIZMAI69uniNRCUdiJmKX23DOKZ7oERcRGt7obp7kpMe0xzPp6FjseB5g7q9PiwIHGIeTYr96yDXSua7yDLWZycLbCMLhNAZQCXJWLFHKytCwloqlHlTKPkH6w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB1754

From: Thomas Prescher <thomas.prescher@cyberus-technology.de>

The MOVBE instruction can come with an operand-size prefix (66h). In
this, case the x86 emulation code returns EMULATION_FAILED.

It turns out that em_movbe can already handle this case and all that
is missing is an entry in respective opcode tables to populate
gprefix->pfx_66.

Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 arch/x86/kvm/emulate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..08013e158b2d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4502,11 +4502,11 @@ static const struct instr_dual instr_dual_0f_38_f1 = {
 };
 
 static const struct gprefix three_byte_0f_38_f0 = {
-	ID(0, &instr_dual_0f_38_f0), N, N, N
+	ID(0, &instr_dual_0f_38_f0), ID(0, &instr_dual_0f_38_f0), N, N
 };
 
 static const struct gprefix three_byte_0f_38_f1 = {
-	ID(0, &instr_dual_0f_38_f1), N, N, N
+	ID(0, &instr_dual_0f_38_f1), ID(0, &instr_dual_0f_38_f1), N, N
 };
 
 /*
-- 
2.42.0


