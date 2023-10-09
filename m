Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221217BD6A2
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbjJIJWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345692AbjJIJWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:22:03 -0400
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2080.outbound.protection.outlook.com [40.107.127.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AF6A2;
        Mon,  9 Oct 2023 02:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WY3dW2XYEST8sOIiz9X2EhwIpiaMac1eIOb3UihA9bkXj0lilCQZPMvUtJ511pyCSTILV1YL9aWsj9fbnfRnaSr31RGU2f7Sr+wO2rx92gunSr3/3BXj6VHw19mu1sQxM5D3yEN1XqaQPjXnn5XWeY0JWb0v0RCczrnCnB/or9l6YWjfVsJDphWaao9Q6hiVDcCCy8Nk7C+cnXMDrLnaYX4CJKjv6Vo//NbMwU7IrCVIwQyAEVdkr7A0c24ilm3uoAVDzpxu9cV8a0Jq1k3eGO38Iv78HDaCStvT4skqUst7JorhvAAjJ1Bt75MY3bUCM8VxMURDoQ8H65gtyyAJ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPvahczNfvcmActLmgOBqvbEW/CePOBHq9GcQJYj4ME=;
 b=RbLOlpOrJoEkdzuIcNwqK/FHdz+/mik9aatplLxQivUxn2VCHzvWGhbpGZHxQv8k5yW7kIyWSKtrLVJPm+gyLiHJjbFRo5zb3tCqMaZdIpZ9WyLARjDIwDbR2+CFDCaKkU9day1uy461Eh31vtE1vD9bx7NTkG4dWnPe4WOjrILPw6KKPzGc0/CQSLPPogT/XJNoKetLqfed0XYuXtY6ttxOB2hrXBNyiDGdbiB/cQfR9+lZho58CixF7Oy/iKyhT427voQLqBtpWk/t3jriqSPIQik/x8pEClVPEbZYABX9jndJkK17HPIOWPczysDlnNyLbXG9d0/8+HskWsO8UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPvahczNfvcmActLmgOBqvbEW/CePOBHq9GcQJYj4ME=;
 b=kjAR2CQnXPve5ighJZ2Qzti4fV4Uub82qN6zbyMTD1SqWwVNf6gIPn6aFKIpyf365nVA6XDWAUETfC6igv4JBiUkRWq3WYDBuBlZA5BuYYjfcPo80QtRFgmzyPGpFft0FnpIP1hjdDzgZ93mVdKFi9eKolp4OZ5kR2/2mPhv8A2hE2Kp5lLn5cP9ZN+glhI1owa59ZCJCr6ywHEJjNujwJ22N14Jc/0PaXM7USf8QDnWbnWbe/lrvsUM+uvkD68Ylg3seTb3+3EGYsSZ/DQ2Ck8NITz1Uvjzeq/J9pgSA0MJ2/kmiqK0JL3egzT3K5BC1p0myollhdmd7LEjj7+T/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by FR0P281MB1983.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 09:21:58 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 09:21:58 +0000
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Julian Stecklina <julian.stecklina@cyberus-technology.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: x86: Fix partially uninitialized integer in emulate_pop
Date:   Mon,  9 Oct 2023 11:20:53 +0200
Message-Id: <20231009092054.556935-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PA7P264CA0404.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39b::8) To FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:7a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB1567:EE_|FR0P281MB1983:EE_
X-MS-Office365-Filtering-Correlation-Id: f6f3688e-01f8-4c6c-176e-08dbc8a92fc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7RYUAR8FYWag2Lo13Eoa8joZCUER5BawlTcOoZNOigZZs1Oy9v8DiBAB+JBJkHLpkQam9IxRwGX1uvQhl2hycNf3R8Jbn8NNPYDjPbIKmpNtmKoI6irpP62nYD+B8H2G6fz2o0WpAXwsli7yNqzkRpE3+xePIiwBvZBKkRl99YjgUxYmBSGB2uhv95C/GINv8GjL0n58TkEVE1Psx9QUQRas9ltzi1kcvGlY+ddNX022dkqw0O25EpVC/vdbS4K/j8S/IyUekC37tYH+oLTvoz+nBLjE2WDnTwmopleSCVC66zAc/k2wDmM8qet6XmCQeWG1RvDPwsgzaSxXPBhj4upTkNOUWVIUgDGMaa5Tb/P7DnPZjL22C7VXEwykxaUyNfyGBZND3sAzpDjJRS+gO8X5MUTRnVVyYmF3Oegm8rQxy3OOaTKBxiHbJfIPkAy9gjHelgBTcCk8G6c9KW9y1v9cWrjdFxTk5YJbYqqdopqO6EfMkcN2P6xOT11lq0JjP1MpV2QkmYKy3PoS0GrKYHGfev8o7PI8INm8aSkfGACR0LnOVSpw3gADJgh04hx8FvYZeVFOMlDA1zACdnYiP27bUVROAlCy5kRKH+5t+64pT7iazoYFvjhZ2OtDdu/nt2z/sGsnBVqxxXLf5IKCnLooSWsRbebos04pkbptyPse2we4QlbVABMfV1IZR0w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39830400003)(376002)(136003)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(86362001)(38100700002)(36756003)(2906002)(6512007)(478600001)(6486002)(44832011)(5660300002)(41300700001)(8936002)(4326008)(8676002)(6666004)(52116002)(6506007)(83380400001)(2616005)(1076003)(66556008)(66476007)(7416002)(110136005)(316002)(66946007)(26005)(38350700002)(341764005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JtX4E3lBZZtvAYey3T5aWUgis7u1XcDGTX+qxESgsLXcYCG2DVy7tjwueedO?=
 =?us-ascii?Q?fFLd4ecC154gEU0lX38L0zBX2Ka1AoIFEdjxUy+1zEhrBj0h8q0eQdTLJ9rk?=
 =?us-ascii?Q?9U2Eah6vBWq2Y/zsyv1WrVQ5uF1ULV6KK8j1xrVNAtoVIJd0PdDbOituUqUf?=
 =?us-ascii?Q?KS9qFmIFTob2Zgmzx1oQ0o+2eWfP8FxvbjyG55uWURHnSy02TsDE/XrBadef?=
 =?us-ascii?Q?ZzDIujocwI1Qw3p8LHv8qsAQ8PvFB02qzYToe+7k1ST6ZOhuTccZSl/rxWSi?=
 =?us-ascii?Q?RD79CzK5mgvkMpl4RF28tP7YWhshE0GLfyuaog7mk4E1ewAGYLYcAVMGUubU?=
 =?us-ascii?Q?6kegVaZeO8d4egI13Cn8FDt1CyaJrbFysJo+I2kYE+H8f4MXTnrNYfN/tyrA?=
 =?us-ascii?Q?Tvf0n92p54a6BUltjjimDOUWwxfGk2srUxZFJLoI3UN7YE7D6KONe8mDd8Wm?=
 =?us-ascii?Q?agoZcdXfQyzFroRyIdF2nbJG2QJUEtu/WTeKGeDPBTNua7hMzo93PcePFH9u?=
 =?us-ascii?Q?cyKc1YkcJGTKBTM+4+/VSQBzT09dtvSufNKD7BVXHR8xCRZ7wF3d1ahN4ptc?=
 =?us-ascii?Q?EoKdf1SlOprXX4Ec/OaQcq1/+gFSYf7MZX/0zEJpXdN4/1SUMztrDfoWyQJ7?=
 =?us-ascii?Q?bOjwByrd+8g8R4yuz2/GdyvDqAdO+LlrtgtSvK4/xdB78pTo4P1TA3t0cHN/?=
 =?us-ascii?Q?wCJcgrVDL/FZWaPz/rDqmpp7QVT4rMgyKhSHKyz5uaGmKu8Eqc66Lf8Fwptj?=
 =?us-ascii?Q?Fc2R8hAEz6ejZzUkLIZUe3FGfjPDHBX5qu1dKPjvlwBauw6EPOj1CesHKJXx?=
 =?us-ascii?Q?Pa1W7x7p6tph0VUs2hbjgtsae7vktW6LwGxX+v7iXQLgFBk0eKb+tKlRlePs?=
 =?us-ascii?Q?lL6ParUvO2V0Iw0bX9KrOYHww0keriTYnpJ8qCjUSXPtHRIzwchT2Q2+XnSJ?=
 =?us-ascii?Q?dH/rTE/T24dhFIdBjzX7hX5em7BVipp8VIcHBU1BdWgfqKbkp2UDG6xqZCd9?=
 =?us-ascii?Q?VpDiIlgiVJ9udRuAVCF+Cdg4swsyhaHzFXp6Ifso7KiOcC2Cu3UYMabFZSkq?=
 =?us-ascii?Q?bWSD8bxNC/ls3aH7YWfaio8q5Bz92EuQYPbBRRYbjP8FT0zsh17k2XPUxuFx?=
 =?us-ascii?Q?5F5LS+nu9nw4nQdtXY9nHcNKzs0zJgKdPIC/fYhaSufoAFAPrK04BqulFd+s?=
 =?us-ascii?Q?u5qcipm9eOuRCt63GJjk3fszu9pE6Hf8/bT9aDN2PQKVOXXfUglvLYNkC4DN?=
 =?us-ascii?Q?B9zEaFsnXNv7VlFM3iDGkSZmBzCyiCc0YQ5AxHmTttwfw1svxwiMLljxbjah?=
 =?us-ascii?Q?w+hlauXHCKOGf5kEkjKQ14TeZmXvggk6EypYqP1EWRKf64Zw1t9vZyuyC1z/?=
 =?us-ascii?Q?a1g7BRxzYQIkMDf964TfbPBJcWcCdnJPUGj3LAiU1alqfoQuHfqbtRlwAC00?=
 =?us-ascii?Q?hNuz/TpaIWJGAzsNEvdRocI2yScco/OpBhcEZR1eHIYj4GKnsvF0ERk0qhxo?=
 =?us-ascii?Q?w73Y5LT2mbr/Guj7JvCGBEDf1fwqQ2QOEHe2VN72twnm2TY8OH4WNYABleF5?=
 =?us-ascii?Q?zegMoTEEA4FUQbwzje44+gEFWuG0IQZ3/Q34omIOua6o7/WdwJQlvz537+4l?=
 =?us-ascii?Q?a1mZr310JboriVI7roc/BqQ=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f3688e-01f8-4c6c-176e-08dbc8a92fc2
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 09:21:58.0757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+xVXPRHQSvemYDgoFRPqMHzgpR0hBwiSiFk3MA+2q32pgHMzyf8tjZx2VOUvHXT+Q/nRxYgvN+K5sWgZY5IX9ku2+13N9xMySDP7QI76v005TdmZenqxt9/MSoePv5S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB1983
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most code gives a pointer to an uninitialized unsigned long as dest in
emulate_pop. len is usually the word width of the guest.

If the guest runs in 16-bit or 32-bit modes, len will not cover the
whole unsigned long and we end up with uninitialized data in dest.

Looking through the callers of this function, the issue seems
harmless, but given that none of this is performance critical, there
should be no issue with just always initializing the whole value.

Even though popa is not reachable in 64-bit mode, I've changed its val
variable to unsigned long too to avoid sad copy'n'paste bugs.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 arch/x86/kvm/emulate.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..86d0ee9f1a6a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1862,7 +1862,8 @@ static int emulate_popf(struct x86_emulate_ctxt *ctxt,
 			void *dest, int len)
 {
 	int rc;
-	unsigned long val, change_mask;
+	unsigned long val = 0;
+	unsigned long change_mask;
 	int iopl = (ctxt->eflags & X86_EFLAGS_IOPL) >> X86_EFLAGS_IOPL_BIT;
 	int cpl = ctxt->ops->cpl(ctxt);
 
@@ -1953,7 +1954,7 @@ static int em_push_sreg(struct x86_emulate_ctxt *ctxt)
 static int em_pop_sreg(struct x86_emulate_ctxt *ctxt)
 {
 	int seg = ctxt->src2.val;
-	unsigned long selector;
+	unsigned long selector = 0;
 	int rc;
 
 	rc = emulate_pop(ctxt, &selector, 2);
@@ -1999,7 +2000,7 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
 {
 	int rc = X86EMUL_CONTINUE;
 	int reg = VCPU_REGS_RDI;
-	u32 val;
+	unsigned long val = 0;
 
 	while (reg >= VCPU_REGS_RAX) {
 		if (reg == VCPU_REGS_RSP) {
@@ -2228,7 +2229,7 @@ static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 static int em_ret(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
-	unsigned long eip;
+	unsigned long eip = 0;
 
 	rc = emulate_pop(ctxt, &eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
@@ -2240,7 +2241,8 @@ static int em_ret(struct x86_emulate_ctxt *ctxt)
 static int em_ret_far(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
-	unsigned long eip, cs;
+	unsigned long eip = 0;
+	unsigned long cs = 0;
 	int cpl = ctxt->ops->cpl(ctxt);
 	struct desc_struct new_desc;
 
@@ -3183,7 +3185,7 @@ static int em_call_far(struct x86_emulate_ctxt *ctxt)
 static int em_ret_near_imm(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
-	unsigned long eip;
+	unsigned long eip = 0;
 
 	rc = emulate_pop(ctxt, &eip, ctxt->op_bytes);
 	if (rc != X86EMUL_CONTINUE)
-- 
2.40.1

