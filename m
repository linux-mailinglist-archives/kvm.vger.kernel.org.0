Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B126C628A62
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 21:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbiKNUVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 15:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbiKNUVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 15:21:00 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BC12713;
        Mon, 14 Nov 2022 12:20:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MutY0FtJDzEOHIMAwlZ1zPjRF8JKCS32XRRqq8iWOxzDtUWScW4ofQxMu8pC7DbLPbDUnitnTDPtYMXnFRA4wReKJMqilCE4tyA5T3WkqVnwBFVZVNghhDuvfjSCo5mKdhsQOS7aWL7H7i0dFKGjU5ElqM14vv7+OLB7XnJ3jElpKvJf2KaRhE6Qx5FSRCAgE0LJjGxeRRBC5StnNhyVliCT9c/+Mf0uxifpudMP5suVNLt98IK12fqNGwX9ahEJ0oU++WCbTpogp6aupWTPLuVcVGNuoJNXbe3VAJWqR08an7YzeVIeSIsk33Y6/jjFwGaBdNII7p7puJlDmO+IDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfUXSP07zqs+SkXBFMXbdVRUWpvfh/LohaAi0IDUIw4=;
 b=hwrr8UPuK4X637skhOS2AfoRp4gVArCH9/lsn+TSOe5bnG9CCoeVHof2qDmdWlWQC0T63W4zBNtpP5eixbccNClU5HP54gB24U5Ker4m5vTSBn4Pid4mKNukGf9ZP98mmbDXjz7StU4CZgZeT154JQ4WK6JzqjqTDwI53dYlXaUf3qJ3/pnK57vS96DQqNfydWF4YBDv+GJPYi13fXVLl9vgd1oqwkxubLm5PxFLWtaE3tWHaCI9R0p13QuNDV0gJq+ypbsu1ZZgdQOkJHo/tbHEfJjhM+ZzCp+bT4B9zB/owePF+EjnqboQ4G1qP00kIYZdlFEdGOxc9W23gAqXrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfUXSP07zqs+SkXBFMXbdVRUWpvfh/LohaAi0IDUIw4=;
 b=wp5uTRNxukQ+N/ZvkVWzn+4SS+ekH7CF0Sz4QegmapwJpG47neJba+DdHZPG0vmLi7bSKFjflfu1yCkrkT0oAC5EisfrOjGSXs8ASURAwisbHp5hG054DFczSRfpkXxTIAZCiVC3rec7oIS23pkWpRcCrHTJOrRVrtYQhPyvQ4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from MN0PR19MB6407.namprd19.prod.outlook.com (2603:10b6:208:3c0::20)
 by PH8PR19MB6835.namprd19.prod.outlook.com (2603:10b6:510:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 20:20:56 +0000
Received: from MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9]) by MN0PR19MB6407.namprd19.prod.outlook.com
 ([fe80::db4d:6649:2aef:bae9%5]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 20:20:56 +0000
Date:   Mon, 14 Nov 2022 13:20:55 -0700
From:   Greg Edwards <gedwards@ddn.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Greg Edwards <gedwards@ddn.com>
Subject: [PATCH] KVM: x86: Allow APICv APIC ID inhibit to be cleared on
 legacy kernels
Message-ID: <20221114202037.254176-1-gedwards@ddn.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.38.1
X-ClientProxiedBy: CH0PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:610:75::12) To MN0PR19MB6407.namprd19.prod.outlook.com
 (2603:10b6:208:3c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR19MB6407:EE_|PH8PR19MB6835:EE_
X-MS-Office365-Filtering-Correlation-Id: 246643af-c8d7-45b9-8081-08dac67dbcba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: voGaK9j8Vc5vusOg5liI5/FyF0w36KGdulMfTOYiNUX/OKFKWV1FK48BNrNO7Io5aO+t1lgeb+SmOaBsV6FbWkOw0iSaGyYGSFpueVK7Gt4/7hteI2Zfkiz5UFiEE70tCI2r25MvJU1dA+aJuZMq6iyuiKrKtbPXze/XF7k9DMwEmJJUVaqkp00MmLVb2t2GGXwV7grE9dYKXXuIHTeIDEA5bvpUZuVGUhPrhmcSxIHsokz7wPUCZ23vULKJMQ/op6VZXg2ZRTZeGS8Zu0RmsPadAP8ApcxGll43YItSvlGPs2+IZniwuX5shwfkfyZjKOUv/YAy0SkMBmwKMwsbV+GNY+RJ4e2Wnb+CV8E3no8kTWgx7hM9X61+8hEmqRZWiF1EL8Rzowwf+lu/C7ED/y6lSq3LeHkDc4fJeycSSA/yqFafjyNuTTPiNGzlVehZaZRB8cAdtlkNiEUrprd7K+2FBBb7RaLNDomuVUPYXGvBrVU45042ZsKDzy/jxrI9Qxoji2m8lq2/Mh3Ejcb6lkuMqaqdSUv7djpe+6VoS8nmaRBsnPjplMD8dXAA3GGjDHiaCe4NiEwCSgRGi0YhnP6M/xGkHSu7kjCbronXuve/hHKThN4tDeJpOBdHTIxXFAM12pfKxkxfdHpmea2iMFDV6X8zA14G7WzT7YNfpGk1Y2nj7cyhPXGihvpyEwSwv0aonYouNWIdpomRHGG87h2GLutdiZAudvOWMOybQ+h/pNq0SK+NLs08finko9Sl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR19MB6407.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39850400004)(396003)(346002)(366004)(376002)(451199015)(2906002)(66476007)(66946007)(66556008)(41300700001)(2616005)(1076003)(38100700002)(316002)(54906003)(5660300002)(8936002)(4326008)(86362001)(8676002)(6506007)(6512007)(36756003)(186003)(478600001)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gRHllQ/s9Fv4NCsKHfl9vsvvyL+AVlc8uU1zsDDx15I5/WewKdxidyZ0QPey?=
 =?us-ascii?Q?fd3qN4DSFtRGe0eIGmxQjmWcxspCJxnwb4y5aepBxR29GrmDTCok6sjIb/H7?=
 =?us-ascii?Q?hPC5poV0NSoKjc4OL5zEX7moT3IgapOsLPFHSxVumJCOsXTt492b6IEa0hq5?=
 =?us-ascii?Q?4U7Q6AFVF2ieH43Mp1WFi6Y8GnH5aFx27aTfRK6F+z+nHAR9zEBoWx63FJKy?=
 =?us-ascii?Q?ECnfNe3OptOS6X1Dzh1CDBETakJUU+dSQcGJHDTCuiDVCHW+hUsdvz+nV2gQ?=
 =?us-ascii?Q?QCcyNz81eDTipvMV3FaNGTVqO1wfuYiMivpsAKURaFDXRUXlWD4qrzcjKzuX?=
 =?us-ascii?Q?8lF7iDczSyOWQ632ai1GOdeJ8lnV14BKlZ7MbX+DQCjFG+1HnHX2CtvQxLQJ?=
 =?us-ascii?Q?vcmKzVgSab/XRparBeszhb55HuSrYJSsoX1nbvTypb7ziiu6gFLJysecrLmX?=
 =?us-ascii?Q?pOcWsq3u2OkZoHEGBPUi130n43YV0H0lMOyRYLQ9OB7zgdMEjiS31+Vb/g9Z?=
 =?us-ascii?Q?cDhlxWKUtDQTnreQ0DsoyCbloE//3rq1kNIBvnj1zXNE3TSVDGGEUxoLZo63?=
 =?us-ascii?Q?t6zV/ZWIyaPjnnWbb7K9gIPnWIoIBZtg9Gox7YiwBRxWFY5OGmOPhk5cdXTS?=
 =?us-ascii?Q?17Kt9QuLddfv00y/gbeT+9IdRTZQB4WWYRhMtbWRRfMak84o1m9WHO5fJSa9?=
 =?us-ascii?Q?ss03vZq9dtIpovQ8/ZFoOD4aB39TkFT6u/j610Y9t4EbkMvoDaS1sE22AUn4?=
 =?us-ascii?Q?ZJ2fFhHj/d+/MS599cOFfO3cHVJBpYx046z/vVkh5XPtTAaz+VMKG5AZ9JIk?=
 =?us-ascii?Q?c60sJmgMS3tj2ZrFaiuj1Qsztu/k/R4imoE7dgt+5l4n4BbVihwlYtIiYZC2?=
 =?us-ascii?Q?IjDokd3eRMnq0vOQr2AJnw2kuHomkVhI1xSV17raMFj7CNOlTrndQCQzV6SC?=
 =?us-ascii?Q?D0q6/ziBcEyHSO6gE9V0zQ1RgzXOD/j+HQUSg2V1dAEg9YrYfdiVQo+pV+BH?=
 =?us-ascii?Q?/Mk95P2bDiw5z3XTY/1+NtyMC7ZQKxNluDEEI06OoZ8hphh0w2lmiWo6KAWw?=
 =?us-ascii?Q?tIGJzoWVXO4y4HSWjLm08BrjvWSnqxbC0PpY27L7xxAgyNDwMUPHggts98OJ?=
 =?us-ascii?Q?/IIf4gG05mC3Opid+naM5efpmO7eh2wGfNz9UWq9QLA1nca6BRz0n4M+V/Wg?=
 =?us-ascii?Q?rNEuOUn3y0hmPEVCM/Pm38fGKHE/B0HJmJEBCMFFktUULv7y0YdIdqrNuNfy?=
 =?us-ascii?Q?fxBR43zpySruBe6AxVPzvLkhYczSJgEiXduKjD2LUZdbiY4ODZa6KpiOgp9G?=
 =?us-ascii?Q?OE1Fq/MZ7yAKkWjeHPpnwG8cfGU9cZrRU3N4rBlyk1HEh3K5BUlEKQAvbS6v?=
 =?us-ascii?Q?o9xjA2OnfEN8a8JdT/XT+S8Jkv/br1eHgaSNeP/cSMUrUSNdm8MPrgP3/JUC?=
 =?us-ascii?Q?NpgKN5vB9Xw3yTdnx6ScN4PZbaTl+1Eu2k+OWxDr235lhYrPHUHTW899SlbD?=
 =?us-ascii?Q?YpMaWNqA06cKllvqO1e5djO9XQ4tHQWTIdoLaCJa8vYnPWQu+z5qDj3M3NFC?=
 =?us-ascii?Q?8Aj5GxvPNW/zmdicV5dOoQWHbEkq1RPqzF3MtaKVLH3Dtujo61gS2ogSP4BI?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246643af-c8d7-45b9-8081-08dac67dbcba
X-MS-Exchange-CrossTenant-AuthSource: MN0PR19MB6407.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 20:20:56.6678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFCkLIdkFh5/Rk+2S7JEefHa6VMUYvBkMvg74mPFom7Nt3gLlvEUrJnhzbm01EnDZ2NIeykjbuJRm65iZprPGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6835
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
verify_local_APIC()") write the xAPIC ID of the boot CPU twice to verify
a functioning local APIC.  This results in APIC acceleration inhibited
on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.

Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
cleared if/when the xAPIC ID is set back to the expected vcpu_id value.
This occurs on the second xAPIC ID write in verify_local_APIC().

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
 arch/x86/kvm/lapic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..4064d0af094d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2075,8 +2075,13 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 
-	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id) {
+		/* Legacy kernels prior to 4399c03c6780 write APIC ID twice. */
+		if (!kvm_apicv_activated(kvm))
+			kvm_clear_apicv_inhibit(kvm,
+					APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 		return;
+	}
 
 	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 }
-- 
2.38.1

