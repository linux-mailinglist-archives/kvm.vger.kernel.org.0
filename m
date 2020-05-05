Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B021C62F1
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgEEVVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:21:00 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:6207
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbgEEVU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSbvotpTuVNkTv+dhk9NJpmoWteDR7K0GQpbDCXsX8jfLM9Q5KSPjt220wBRJrZ6kU8MwxgH85GrDPcVrcx6bAdsaPkCQ9nouwBh7SW8cv0h1Cm783oL7cw+VU0MizMg/kIUttFGPQvY1MflDVreuSKn+1MC4ONgvrAMhvZA7wTX3jbIwHK2pVu3h5IRleuuRft3da2qTqEkL/aSvSQfpjw8794jnpW9h52XMtuj/7G9kw6f+0U9qpYkSY24Uler9uN7t9M3rKyLYcUBZ9CM7sM+KeO5/PkeNfoQDLLOmcmlTlqDImNIVLbIvgy47EzuvKCRDqyHaJO6hoa4LcK+mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms5T1TbPWzXX58Hb+fiuk/V0KrkIf2MtQZxaywTUg50=;
 b=lhpA+mGJM1heRCcioo1EYYJGdctdkreQlSpivuL/FnGmYU7sjn+RRbZeaiVujZTEL30l1mmGtZSy2pTYmNJABGRYEQ4gfDPdv2u8fjn+qgTaXXmmVNiUTeEFu/jCGqvluaSvwxplfqxZ9PiBeyQuuLHM+jckojVswHdmLS2khlIXpAnYljhjwhYvzjk7zbgiNsjNGhld6z8OQrZqfZPRU99fiUJQ1p9413vAl67oSLpTd6fMzd/mbogdGn489YmHQvRSyPOytOKyJLhOgu6nSgoDGLAVu3/JkPk1o5CwF049+qJ429OFUo8QdXSauJcPnOeanW+Bq5jLQEtPVsSFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ms5T1TbPWzXX58Hb+fiuk/V0KrkIf2MtQZxaywTUg50=;
 b=vIfssTlGpJWyqawm+0azAZ5FU9ir0kxBHfzwGx2BEX/NQ/k7rTLtJW/X0OuNO+Ejq62T/XTzYA+0+paKuxjnVCzKUfD20qOtp/4t4F4VIc2cMvTL3vuMzI/LgYCS1ipyFUQc7nqFY8pc38zQdAQiwGB+FUOg+ZRryOv26DqLDNs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:20:56 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:20:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 16/18] KVM: x86: Mark _bss_decrypted section variables as decrypted in page encryption bitmap.
Date:   Tue,  5 May 2020 21:20:47 +0000
Message-Id: <02cde03d5754c84cfa0dc485f62d85507a2a9dd5.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:5:177::28) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0051.namprd02.prod.outlook.com (2603:10b6:5:177::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:20:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f85d8190-8302-4953-c3d1-08d7f13a333c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251868043A2A07BD128D538B8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9yVt5MHIdBqPfsYM4vBI3Vd2bV5RclYWWxX8JZG3I6aM+F0CmYZreruLfAOVbzr0UHfx3wAFlImfRxp+tVAyyPk4vU2b6W11/nbmgPs33eAXEyQpOISVwpB+wsrgbCIyahnLPK3fysgxm1JkepWM46ViZs6tkMnBqGtIJvXIknQ8aoxJRoLPqOV1PbEu6bR7wAo7eBNFrL+gje2dAfxlcA5C80TVNgRfwVlcEM2Dcc8QUWz9joeALurLLlf/s0YmzyzWo4UK7/AKT/EAoMoQticVmqmhjBIUDJiTTgMHQMycOz3qIpXShM2ctmDIfhCB3Xl73852AAMv3+f7naeYV1I3XkU+0WGwPFpXEUNDqDxfCn7E+n7/UZ/3YckZ/u2bzXMb+7OPzNBY8jH9PrNOrrJy5N6bVQbgB8HiL/aB0jAqCTlP2nSbINexJ2i3GG+ttukh9A+Q0sSjWTFKamCIRdC867A5dL3hHZtZBOim1S39ui8W+JLDchI0PEsZnJw+qhNJbAQodmESagGEhS4ayL3e/WFv0MvIUVbkMnTxV5c30+onDl2AWpsggZgm75HW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(33430700001)(86362001)(8676002)(66556008)(7696005)(66476007)(52116002)(8936002)(7416002)(4326008)(33440700001)(316002)(66946007)(16526019)(478600001)(6486002)(6916009)(26005)(36756003)(956004)(5660300002)(2906002)(6666004)(186003)(2616005)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iEk/Jq3RFY3W/pk3IC+QiOWRv+kmPciLZ+MLgesG3w0I05+BPn29N/GyNOFQcS2QT1uRNzr1RoGaaM4BQJaO156J2kxZCeTHSO7A7316lvz2nU69X0BE//bGKufChL1y6/FajCdKznf4gPoF+IbdsM5laTYxDVmJ2aJeAR6B5qZ1AUpVq7Ha/sv4q25VUaaxVrF2oRCsPt0UvAnofk8yDRHUnAZ+XLGzAQRsykp09X5kTHxp7ZsMBHSBiG05jiQq/Zx+m3wg47moOCWZCNuf6KWmnK97KKQl2W++vXwkUatAurLk1sqjkeWx7K1sZs9xUkb7tu/Y2Anrv5S2/Ulxv0g3P72SvBrDWtAk/4vQj6VEKlkZgLbBLEmCEr50xUmu3gi5pSX4BaD3jPQOY/z81xCJEa7egHG3ezJTd2GRkt3bbfmLCCPe5huwbxA9tNH8VF/WY2WvKOWC4Qd7FQCiUuYnNSDgqa2pvw9xosJ808V/apMnKmlsnH6tVi1adFm0uuPa1nM+jjdzo6o26XgtXo0duloOGmU2Z0GFffbrzNOMTwI0z3naUQSf4pT76gaAXjfxqKMU5D4wZi0XMlL0sBpry7U0Bmg0zpe5wq1X623U+MOgK/0xWyeKN6Ew9I5s0FKqQWifEIVUyS6QVHgdnFcDz3h7tppTUpfnBsLyn8Cm9VfRZ/1SYi+vaEmjYCrkt6lqRx12wSQX3Xu0ItIKx7e9ncjskBiqGJlCQec1k5InEUKOClTz2xrk1P54ZHxTf6txyqnYLy0LiZyRqcWGBSZZO9Mu4V9vRJMQxRlgKNg=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f85d8190-8302-4953-c3d1-08d7f13a333c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:20:56.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Vsj6iDNQHVI1EdEmumq0aL6h63xP7wmFWPtk3Bn031uT7h3tD+LKfPNg6Qxy0rz1DO2YKye4HHxP1YDxw9QHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Ensure that _bss_decrypted section variables such as hv_clock_boot and
wall_clock are marked as decrypted in the page encryption bitmap if
sev liv migration is supported.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvmclock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 34b18f6eeb2c..65777bf1218d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -334,6 +334,18 @@ void __init kvmclock_init(void)
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
+	if (sev_live_migration_enabled()) {
+		unsigned long nr_pages;
+		/*
+		 * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
+		 */
+		early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
+						1, 0);
+		nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
+						nr_pages, 0);
+	}
+
 	this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
-- 
2.17.1

