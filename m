Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E4A7B811E
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjJDNir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 09:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjJDNiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 09:38:46 -0400
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2050.outbound.protection.outlook.com [40.107.135.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF54A1;
        Wed,  4 Oct 2023 06:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2XXCkl1AowJHN+oH2ti1lRsihTnCBG0vmJbd5tUxNXwDqiCdbyPjOJSvZ/tXB3CxPdAzRy4NzisTrhhQv3gHONfmN87YynVbi1nQI/gpDPNcg9DhbKPOgi1ONHQ13XduSgbQHBpoB89nGc9FcQi8hGDnLOxU1lzZwkCIZhfbVYMBpvnLNFf4Pyl3T/xPD43LFVJ7z2Fo5+14ksFmGUYkbghPE1xlJKWmqgrdLEUIOsgQdCfjQrZNhXDsmg6KYYnEGCL5qEuUSxaEaTiLhN6jTDGhmVqQi6hno7eGWFfKMHz605qYpn8kApLxB9CrQsX3Aw9m4OxfNeJbVy88hcL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NWgznVaKmHnPH3KhaPdZCKgwDdwfBtSyTEv6J20VyY=;
 b=dESQyPQUD1hk+QWyAyzjEkLGp6Y1ukImf4eC2/YWuuRH4UzbPllhQgXGHch2n6Z+cixXZaIxBjsiCQB729Z4lSpwI6thPnkqxFLWKUOt6uxQkumwKgWyrtejFQz1J7fxT3OB1SPJk991+U2mj5omGWR5aDwWsY1LYzMX+rmWdlNqN2W9+UCmCukAeMCySneTjjl9h+BZ49L2MgO6zihNoEVJ7ZQCi8CdGs8K3rEaOQBGSlRF9LXwLpTqeAvKoDAT21EN29KUg+qr9tNWFFvEt8ywk7XOqmffycFX8qm+QUNFnwEC4SXrL8+S+xF+6Rm9/8N7fbeKpc95X9UfPcR9Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NWgznVaKmHnPH3KhaPdZCKgwDdwfBtSyTEv6J20VyY=;
 b=oeMXRk8qsn5B8uMRSdIujwcZP85cJ/HeKzuAWixaqkJynWXJbRMettfQ/eY7Uph9TEJ6DQPUf8dFEC1/Qv8A+3dBMKTenA48akfvDs3XVgWJgYxi0r92kjk0/gUnaPOr5yQ8VswfR+DWiBW94vqvtL7ypAxXifY5TKDvEX3eGwEo0iYjW0TtjLta5/i8YhLwyAsfBCwuNxpFPewFSUNHz6LXz8exm5D+U21/gP4SXrpHGfXgTYENzkgKTXdwHqCoGENYl6n54eT/+jHI2Bai+2PdeuFyrmUcWOzTdnLwSFezYoGeLfzU9LLJJwu3YFA0Krfj92z+n4NLgjnuKP8sSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:7a::10)
 by BE1P281MB1473.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.35; Wed, 4 Oct
 2023 13:38:38 +0000
Received: from FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec]) by FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 ([fe80::739c:5a5b:9c94:e5ec%7]) with mapi id 15.20.6838.033; Wed, 4 Oct 2023
 13:38:38 +0000
From:   Julian Stecklina <julian.stecklina@cyberus-technology.de>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Julian Stecklina <julian.stecklina@cyberus-technology.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Fix partially uninitialized integer in emulate_pop
Date:   Wed,  4 Oct 2023 15:38:26 +0200
Message-Id: <20231004133827.107-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0132.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::7) To FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:7a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR3P281MB1567:EE_|BE1P281MB1473:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f957fb-172a-46df-2c10-08dbc4df3703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stIKzbi3aNFznHovLYwW9HQVe0vNWBg7yca0cXyS+zebBAaAKQfGUYEBSpNHIzqG0eGR8xbPIjT2IH8zHns2yspJ9MQC/DdQMK/wsQTi8PyOgs7Wub6u160kmgjimnOnJUnl1ECyzyJWnSWCQODxlHccSYnEVUKXgeGcplSl4hTQ1Jh2l2hX8ZzbKlJprQR2u7VQsFMF3kLfNjl+MVOmJ9YmNzTcqY+rlJWHlnFxHQCBG3FFAJGHVwuH5uxWRXj0wVeUdTlhFXzaY397GH5/xtlDcYtKToplMVwIzzwbY2J0MCho6NQQXyhry6UGyIq8vw8GV21PFTnSfzvlVSvnKHPmxVkYm4xF2xDplvkUQtbgzib2GFU6dRDeI7Ox/j2zDFiI6ienq4mC0L8MI9U9d+hOALwbnWZlEVISwYszVwODUyeswrhAc84VRlYgGIejnhF3ZaaO96zwKEkrYSx9EHfr3/GTMLmMiYEg1BW1AwhHy4FMNcL18Mn4Z3XlLv6LHXjH+OR4BATS0I97RQ29ExMuF+eJcvp/CYqH8BxBzcfS5eGtm12TI0FbCKrqRvd/DVgZzNxsO5V0hoskkLiyDAEuxU33WScHTI1xxC7kLsPKUbvu786GY96nN2eFBbp/n5onpMLrIChiYTBv5e7isyAaefR5AGNhyg3FdsvQKHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(366004)(136003)(376002)(346002)(396003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(4326008)(7416002)(44832011)(8936002)(8676002)(5660300002)(2906002)(41300700001)(66946007)(66556008)(66476007)(2616005)(316002)(110136005)(26005)(6666004)(36756003)(6506007)(1076003)(52116002)(6512007)(83380400001)(86362001)(38100700002)(478600001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+MJXLOkVpsMsydJpcrmJUwlHKEh2+kpt/0V5J71FPAkcCZq+fd6fnJ/4M2cT?=
 =?us-ascii?Q?fvQAvKipPS/AcsmI9PxUZyWu/llWV2xP9+ROCMUwcDNQB5WGwfmYaNhwjLWN?=
 =?us-ascii?Q?WKL9mp4t2euUiJt2cct9nBKES/651SnTWWp7NbU7oDFadyE7D+UWP/d3qUum?=
 =?us-ascii?Q?I4lw6j6bL6AF4EjRcsjImL+OJlIPQd39/QBbnbMZ/YjwaI0ndxi3Nw4S9o16?=
 =?us-ascii?Q?4O+DproI2fK2kQ8ZQVI/PXlxMbJmsXw0RITFX5PmgU0fNRjwSLhV3tSgIEfT?=
 =?us-ascii?Q?BQiAl9RzyWqUi1Yo2DjiOyQojGHG785RvOfppjY5Vt3FG7lYS54cVQyfet+p?=
 =?us-ascii?Q?IjPw3qogjeSNcgw6absYP+Rd9fEFEtC7fU2ktNBM/EYByiL4afVScnPHsxr2?=
 =?us-ascii?Q?VLpG3UcyFOT1na9dm62mqvaFiOEz7X/LH5NBPVGB7iiWBe/A5+7NoOXTFbD2?=
 =?us-ascii?Q?Zed2Ed6HQzdp4X3kARScUCMtf0fhyiAP9qMi8jbj/+af7PQbZINWBaauZk5R?=
 =?us-ascii?Q?edrldrmxmaCSXir0/4JKQ2/E9YjY92dqq1sgeoJOyKBDRgdkYQSwEvAxuxoT?=
 =?us-ascii?Q?t6VKJLnL1W7FS4j7xa9KEn+fmXVMWCzUqqf0cLQZUX+46MIC/LRhi69gktDB?=
 =?us-ascii?Q?BNz7e8yGrj3o1i6r0SZKBXMl1CzxP0QSle5z40irgf5TRUn8PbK1FKLldO/g?=
 =?us-ascii?Q?Ea9LHdHXIqd/Z+uZ8a3ZdulIgY3nxUCTh5V12WXZUBYQHiUecANxSkZjO0Ct?=
 =?us-ascii?Q?ZmLWrCqP70RDOM/G4oJLRlgAz5ENLQ0l7tCr1GnMtOEIOFQZWOvRL7zZe/pa?=
 =?us-ascii?Q?EffokPeS0JurJtPyUueguBxrnlgznz5ICs94S/uGCYUMK7mRvQAMU2kwQCzN?=
 =?us-ascii?Q?uye/CzCHcLbYwNcfVkVfwTNhLCSDl01/BXrw4SBZRAgduaYh6uxfgoLT/EYp?=
 =?us-ascii?Q?irYudPdadWYmAgmQxi0qkqwz2i80hWfv+M+u7se78f8W8ut6byUkUARVq12h?=
 =?us-ascii?Q?z14SlfZDn112Ah5CezxhNCmpHOYi+lRX/IL67HbLnd0cmZKaudWR1xxo0YD4?=
 =?us-ascii?Q?i+bT5PySrv2NJSocF6ZAiNVvmfnZXQcQ0mEvr5sDdIeSJ8bQQ1D5NAq4AgfS?=
 =?us-ascii?Q?n/SsZsT0A3bvPmuDVA1es6DW7XddOIzKTUsTb0r5POig1ikrzrOVVqC0BxwG?=
 =?us-ascii?Q?taZwzusCck8KwRLIi18p6ArC3FG1KDzN7OFZlRhzfHCEgVWxQ9isqWTWEKgB?=
 =?us-ascii?Q?sBtnQuPgQyQaYHRcwY5fRFpxqiY9m1P4Aci3VNn2aupmgiCntG/8Tjwc+5Fh?=
 =?us-ascii?Q?yIyPR7eyWjXYgs+flEM6cODn3AKbWJocbLI2tb+j1FRXLK+87dvrGozC9+iw?=
 =?us-ascii?Q?EcckCA9U9adlSjo/XVubTNsWqNxPQvZS/w2bV7yzgZVajg79zMt/0wChPQv+?=
 =?us-ascii?Q?r7zhq7IVGPiSSTo6GyRNkBcqBmG4FFuCXlj/+0PorqGwDwv17IfM7u23xWWK?=
 =?us-ascii?Q?NCLfcPR7Jj4nKxJ/4DS5ej1TeTItpY/LrpEePSCrZ7BC03wdY3LZXmUQVT15?=
 =?us-ascii?Q?30UV/Q/qduuYsP+ntPpcCMbGnDVhBZSHAjVL57Mc59cX61f80MDBU7C2zZC3?=
 =?us-ascii?Q?4jUe89aYnl5fTBDTt1e67VA=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f957fb-172a-46df-2c10-08dbc4df3703
X-MS-Exchange-CrossTenant-AuthSource: FR3P281MB1567.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 13:38:38.4561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gZOMyfxfFjd7OKvs94mDcucoYNZIhE2CrCC7wpKqlkaizkuGkl0ITffsl9i5RKwTcHVb61R9wKd8tkCbStsKsAHfEa9GMBG/zYPREHhGpddyzOk3LwcCbcgaws1xY49
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB1473
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
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

Fix this by explicitly requiring a unsigned long pointer and
initializing it with zero in all cases.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 arch/x86/kvm/emulate.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..fc4a365a309f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1838,18 +1838,24 @@ static int em_push(struct x86_emulate_ctxt *ctxt)
 }
 
 static int emulate_pop(struct x86_emulate_ctxt *ctxt,
-		       void *dest, int len)
+		       unsigned long *dest, u8 op_bytes)
 {
 	int rc;
 	struct segmented_address addr;
 
+	/*
+	 * segmented_read below will only partially initialize dest when
+	 * we are not in 64-bit mode.
+	 */
+	*dest = 0;
+
 	addr.ea = reg_read(ctxt, VCPU_REGS_RSP) & stack_mask(ctxt);
 	addr.seg = VCPU_SREG_SS;
-	rc = segmented_read(ctxt, addr, dest, len);
+	rc = segmented_read(ctxt, addr, dest, op_bytes);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	rsp_increment(ctxt, len);
+	rsp_increment(ctxt, op_bytes);
 	return rc;
 }
 
@@ -1999,7 +2005,7 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
 {
 	int rc = X86EMUL_CONTINUE;
 	int reg = VCPU_REGS_RDI;
-	u32 val;
+	unsigned long val;
 
 	while (reg >= VCPU_REGS_RAX) {
 		if (reg == VCPU_REGS_RSP) {
-- 
2.40.1

