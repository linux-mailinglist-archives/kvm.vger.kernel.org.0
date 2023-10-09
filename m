Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5AF7BD6A1
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345692AbjJIJWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbjJIJWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:22:04 -0400
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2080.outbound.protection.outlook.com [40.107.127.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C7397;
        Mon,  9 Oct 2023 02:22:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7bgNIdsVEoMJVokMeyahoeORHAK1+iDIr7waJwGTCdkmt4s4oKTkbWK7CV3tnxUFMr0ZtyUabWjiKR3AphfGcyEPtuj0KYvuLS7Dw2g0sXw3AOdBGrICPCZ90LjmhZsXjIwtbsg1IBsk4gGTjpX6EXSqRccgCccMu0RJj9Eqd0sQDWnHAz4zI3dK8Y9GOFc8QmSCCt34wKmosCGgH1l+/xb0DTFBs3PkolsV9a08BrcbYnxLt0St7IWfUDat4rXkS8YutCGzYPRRCPyCi0RYIydvLwLrlcGOmvd8j4oKyKqITpq1Rxc1+SoHr5ky6FeEP6uVbuwGdPZ4hqq8K2yXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I53l7mF1CfzCDrShLVYj4T2MUvB1XEbRUpBGU7MAO1k=;
 b=M0+sRv2XJaYhGPOmc1WHcUDA3As85kGR5YNJh4G3pYnxRUsTpKh8WxbZS9qcxi0tDgudgu4WnsytVAheY2pOzrLHKxqECj+jBGn8WhV7lczn2nQCXRp5bJ1D0iNbQ6ghStHA5zlBJ5qBUDUATe8kJVAwgmykHOHyW4QNybA1iF/YcwAE6HNHsUFt/b9ucs7ZlPRft1Cy/5rpqHJgH/nkWqGmQuVEt8Dw/irV/MI/6SZC+QP2hgUw2rRE1rBMfjeuZZWcV4wcxvVHjYSzjqFLWAhlIlddHpk6kksXZDleQvJz2sHRo6WUkIrqs6BHVWZhWuCpY1A0CAFSzdOPn3wQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I53l7mF1CfzCDrShLVYj4T2MUvB1XEbRUpBGU7MAO1k=;
 b=wqaimBW7IVsfUBHj9QuAuYWzrpd1YZ0O9hHbx4xuo5xSNFPCxtLMKIK3xqGzTl9DRGWa7dstDsQdfHqvo0hFCERpyomAN8dUgDxU/PBl3BvJ1D9QDDKX/XBEAQ/IuBv2efWhki3VUtLpnC/e7prbpo4xnk7NkOrft0EPdzs5h4VgP5VcE/luk0GzLzlzQ2Ja50W3XCHqEUKOdlaZe/j62312PRm3ANBcGjXFNUGiEo7ECEZlzFqP9WgVWcv79E52HdtTIkTo7scTgmDzo4XzG9VcPkncOGZIIVJ5O6j2sDN4rXZdahJVWZ+tpivU+LF7OGzac1sN/UyBmX8IRZYk8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by FR0P281MB1983.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 09:21:59 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 09:21:59 +0000
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Julian Stecklina <julian.stecklina@cyberus-technology.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86: rename push to emulate_push for consistency
Date:   Mon,  9 Oct 2023 11:20:54 +0200
Message-Id: <20231009092054.556935-2-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231009092054.556935-1-julian.stecklina@cyberus-technology.de>
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
 <20231009092054.556935-1-julian.stecklina@cyberus-technology.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PA7P264CA0404.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39b::8) To FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:7a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB1567:EE_|FR0P281MB1983:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c07968e-9169-4ff1-a6ef-08dbc8a9305a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9q/nJCpQ5qgPX/s/ZRC+Y7po5+hwC2HgzzyW7DxLPFkY5cQh569KKDiohUkK1k/kUtz5DRDHndr7ijAna0PMe/0zXpaykEsZsZBUK/U1V93HhzYPXrBdME1BxmWLhBKHFkyMgaLBBjn4K6NKdGY5+gxgQTh7xZgQpqlLPjiPRYLKglOzE5IqGIELwS+0DHjAcIiwgtLWYarqoSHbXk9wXLF42YUJn5L1FktxPq7l4hsxeUbGlyEfzolFDb67fFWWXHDjuy6/4rEpjuWns6jf9mIWn/5wavGl2jw0vXEn5yzhP7wmDSZkmMoI+AQaPmbkWaEAYqGAEdMxbn6/Pj8lw6MNoF4yZO0M0wuz5JArPBk9IZX/R4iRi69enrb/049igWX4lwKkVH4fBtk/5e0yV14t7IBoGfkIqXuQfqHHCq3Q9NhgqHhSDrJ37iTZPc9X0e554hglwNjPxSeWrz9Tf+JP6T7352Gl9+3W5kZ56cbNzw60sI+Aq/13zg9jFjYFe52XwSDlOR2mstzYYY/nY0uG3MxO+PwW6/80RsV7J/1ltnro18+iSuAGWLlfJDTnUjd923SSDknA/D0s6T2Q1Ojx7FV0MB0Gd2CfLXF2n/DPuvMy6KbfVoTvdiCHSKkTMCAgDmXDP8Rs+p8KfiO6cjeV7mNVrYb5xYwOTQMVC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39830400003)(376002)(136003)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(86362001)(38100700002)(36756003)(2906002)(6512007)(478600001)(6486002)(44832011)(5660300002)(41300700001)(8936002)(4326008)(8676002)(6666004)(52116002)(6506007)(83380400001)(2616005)(1076003)(66556008)(66476007)(7416002)(110136005)(316002)(66946007)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rMrOBueGXmOWI86YffbwDGlNtTCxRXPaZ8vqMIGqITS6Q54uwOFreFrT+2Fr?=
 =?us-ascii?Q?vQNEAIemiQjKSQXsjGW6Zn1/55zEIZIoCNaCsQBWdWWzvQH/EFfjhxZ/ar/F?=
 =?us-ascii?Q?UOYAOp9LPcr/QPj8QxJxIbJmyfPzPV3Z1ZPfJlvP1rku1j9nQBPZl41oBedv?=
 =?us-ascii?Q?mqqHjYQ0JEp+2ift0V8F/60r/xp71xUzmcefNjZdRjP2yy/0+SFPfKVe5j8W?=
 =?us-ascii?Q?xXESQ9BLwfHRvAQ0cZVaI9KFS3UJL0qIrX1qexTOZ/jZpEWQWf4nFQqwiXR0?=
 =?us-ascii?Q?J+Fy0+DBi0Mn/E3RFaAKgUXOSPPUMxm4q18NGo1X0PTxr8tiMjJJdWFHsrBf?=
 =?us-ascii?Q?4+vkwX0P3KSxoKkji7qItjLJiEhThuj0+WjmvR9MtMONarXJYxvmJ8KWhprd?=
 =?us-ascii?Q?ksR0j0qVxUbBv8iZCjsT1zWXGJ+102D+9bLkCVS3MGKjjx8xs6VJ6bGxmnDD?=
 =?us-ascii?Q?m5diJCYBS6AyjRTYm9xnSArRt038YHxoH9YyIQknMxzzN6g2v6ALT+tI30Gk?=
 =?us-ascii?Q?Y4FXCLY2vWtMXWYanajxDBQFFl3m7OsOvIFCvIFxWaZkyIEUpLl+8aZtBhUh?=
 =?us-ascii?Q?X5hSBO9wJFWFnQcay+BikAh7eLqczBmkzeUiMzFkOnlEOonVGLTotyXb3LRh?=
 =?us-ascii?Q?V8F2yqRjtk/Zq9ZOtzDb87d28X8gKpr2B2VIGYyfNQHwsRXxsVHZ7N2xRHEZ?=
 =?us-ascii?Q?t78Fl3IrvFzL5Zb2O1uFy7Avd0Lh7SS+PMFWm+4qW1zJ17W0PmPkbUpXX9X2?=
 =?us-ascii?Q?v9VssBpLTU0kXkK6yjzdSaWOkDMqwuY8LS/fjZMckToIK6kJ/bfwQEHBtxOA?=
 =?us-ascii?Q?jyZU/zrxpKQ79ejmUGLcTcpPcIKCm9ei/i8IMHXgXKeGp9jBZlZONAOQrKhm?=
 =?us-ascii?Q?xwvtvPgMMqy7SL55GMw8CaCQMQFM7CT2yP0sAOQ4fxmMY72B/8c8R5jUrco2?=
 =?us-ascii?Q?/v/KU7KVBJ8Ujh82JYhLEv1TbGHcZQIMRMsf+t9EMYxhfCXW9MK/jiuTMBsD?=
 =?us-ascii?Q?rY0l4AkTGC7WRpKZ0jtaAYCa5aoJY0c8/nDjnYgqk6H9NIkMk/MosC84ikh8?=
 =?us-ascii?Q?VTMBx15qrbIHgdGuxgNujkykxHrXsCrTbjvrOGLfE3TOv+HSxfAdiiGp4mCT?=
 =?us-ascii?Q?JPk0Dx5eUZIAgpBydfGBYZ+D9Xrk9hqyrsJPY6eU12F8+OGYdV5meY5bbAiG?=
 =?us-ascii?Q?045TVo8eRXva5sQP2DOYtumFg6Q3BOBI9hZy3p2Vw8eWfZFJVSvElI3NUC0o?=
 =?us-ascii?Q?Q+m2yu9D4Km3Tf2zY43KdQKCX6rIclwNuxTQCOoKpxwMeNridGo/QHZqHdR8?=
 =?us-ascii?Q?QLigRIsuFyoxvUcXMFw1tsrRos0UI9rQ2KeALRQ8KD/t9ePDWwhJ2bB4Elkw?=
 =?us-ascii?Q?HeEpzUwAip3GqFfoVVeF6XLeARKGo8e43839PmRQ6yq+kZ9UrhextxRVVGSv?=
 =?us-ascii?Q?11TjfoONY1RUwpf6uzY7U6iVW8DYEVAJ9XRKxg0Ml3T6u8BvoYazjPCHDh6f?=
 =?us-ascii?Q?5doDboY3dU6r7H7E1XIaGwRaL/ViX9zYw1DLfvGhuhz9X40P5Izfnfa42CDw?=
 =?us-ascii?Q?Fnh3m2slWSOCPpgNusfwfykfubmR4fFNQbnxsTRZAdyp5CHUkmZSQYG8DOB2?=
 =?us-ascii?Q?bNs7Fw6la/l9jlgYeqCrOGQ=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c07968e-9169-4ff1-a6ef-08dbc8a9305a
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 09:21:59.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usZcrUmY7aJd0DqmsjdJQtdWvVdg7eze7J2d91fASy/mp7p6H/6MtVEdxbYbhInZ9uZ5qJyzl2CESc7ml/KzBTt6Nrogpb+D6yFXAfQjOXzH0uKV/wMGO8aJU7nuApuA
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

push and emulate_pop are counterparts. Rename push to emulate_push and
harmonize its function signature with emulate_pop. This should remove
a bit of cognitive load when reading this code.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 arch/x86/kvm/emulate.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 86d0ee9f1a6a..1b42d85694c2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1819,22 +1819,23 @@ static int writeback(struct x86_emulate_ctxt *ctxt, struct operand *op)
 	return X86EMUL_CONTINUE;
 }
 
-static int push(struct x86_emulate_ctxt *ctxt, void *data, int bytes)
+static int emulate_push(struct x86_emulate_ctxt *ctxt, const void *data,
+			int len)
 {
 	struct segmented_address addr;
 
-	rsp_increment(ctxt, -bytes);
+	rsp_increment(ctxt, -len);
 	addr.ea = reg_read(ctxt, VCPU_REGS_RSP) & stack_mask(ctxt);
 	addr.seg = VCPU_SREG_SS;
 
-	return segmented_write(ctxt, addr, data, bytes);
+	return segmented_write(ctxt, addr, data, len);
 }
 
 static int em_push(struct x86_emulate_ctxt *ctxt)
 {
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
-	return push(ctxt, &ctxt->src.val, ctxt->op_bytes);
+	return emulate_push(ctxt, &ctxt->src.val, ctxt->op_bytes);
 }
 
 static int emulate_pop(struct x86_emulate_ctxt *ctxt,
@@ -1920,7 +1921,7 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
 		return X86EMUL_UNHANDLEABLE;
 
 	rbp = reg_read(ctxt, VCPU_REGS_RBP);
-	rc = push(ctxt, &rbp, stack_size(ctxt));
+	rc = emulate_push(ctxt, &rbp, stack_size(ctxt));
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REGS_RSP),
-- 
2.40.1

