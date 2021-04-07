Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A100335745C
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348715AbhDGSap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:30:45 -0400
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:43680
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233113AbhDGSan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 14:30:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUYPjh91yCPmvOEbrWvZMudw6Sj2T1m06B33bE6GiFUMqzTQizgOmncTpesev4UM4QZxRTAekV9pXcwhBALaD/GKt4tB0DxTmoL/q0iGtKxIhWDCzdXcCyxgHGQ91Z6cAd++ycjSbKtWA7MFMVX2HfcXqEeo9hYsmb6Cm0/CzLhW3Q1LObhnOpT+RuxkIOpiTwV55QQKPWhH8FVkqf0irb5lzimLjPC53+jVZ0HicLYLnqu/QaRwSSXKsZ92aRjFoSRCrBgaD0dOW5A1D44/jnBXcVWsNJj8T3JYhqtawCpIrdQ+NI/GXMHa0vP9JDfiCekZ7MIueQW0CFvXWltZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nFsiljCVkRSABTCl5yc0Q+RvI109GEFBRyaa7gJk3Y=;
 b=mGgXptWSu7Uz5e6hJFcyCQH6hlSmK3tQngdrZeYiatgJtPniC3SDHc6WmYblsprp5N67JlSHwNN0h+lpGFP+M7JzUHhEEQ5/m0C3BIXaeivx4LeaMIQ6nnEBvWNIJCujftDtdPvcsjsK2uehC4reOJZiKCl7hjk9dYaNEcg0daJYPTTWhrvz1gn3Y2BXcP7ZzJEzg8VonjmZbQp3EIeuOH2aq3pt6Hja4PjcaYZtS7yeYEzERVPBsi5VraC61mlXkip/ycj9r+hVfcHNEYEI4H2ycpcbCmhogcp2UtH7XibDMnYcI0RDaL4RT7dPN5H+W2A2gLaufBKaQjQQFouQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nFsiljCVkRSABTCl5yc0Q+RvI109GEFBRyaa7gJk3Y=;
 b=4H6xQCK+QUTK1Mv8CkjrCA/FklHc1RPXvfl2av3cm5j/L3BtScP956vUFiHXV7SKSKdUP3BWIOW/2aeeW41yQrdzcaqzZH2ZBbUvpw6UVSoDyQbr+25lO7j75lwVQtVZVhfMquRRC9OP+Tto/s8raIPdjS6PUKXh0idDFR+6/Yg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3692.namprd12.prod.outlook.com (2603:10b6:5:14a::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.17; Wed, 7 Apr 2021 18:30:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Wed, 7 Apr 2021
 18:30:28 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
Date:   Wed,  7 Apr 2021 13:30:15 -0500
Message-Id: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0081.namprd05.prod.outlook.com
 (2603:10b6:803:22::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0081.namprd05.prod.outlook.com (2603:10b6:803:22::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Wed, 7 Apr 2021 18:30:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e72b4499-5111-47a3-5d08-08d8f9f337dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3692376F04E5C5F56608885CEC759@DM6PR12MB3692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYAGC0fHJNCAVP8ez/fotDxoh1AzAXYi/gVjafFPpGSHVv8wUAlC3wpViVFDEBhAjCMwDWDWHchHzWjiLru1pUJuYV1FHwU0e7ltGkNc+yBB2dRD4aHI4yyZp4rJF1EVTEnHnVC3xbclt1zSuopraiA2JOWzVAvZa83ne42l2ohEZ1oux/8WgkZS5z0uJpnqAZyrtJWTtxv/nhwrqdJN/Oa/KAZc6pu9Gq1pl5dI9TQ8XFgy8cjyEFC7E/hKK4gcwoJ5AhqL0Lt02JOZS9gHzg29c+jhYeJKCM/yTWHYic0PZANk0rFyvQ3xarq8g5G/Ze37rRrqRsAAaGl/mQiwUPe317UWVChTWafSgY+GaCf8tPqo43raXKXZyzjqpoMB1ui4Gjdy3dxWUdzjHyNNAT8iQvGzbfCEICNnkB6deRriR/QNKtHswMqdNnBDZ9A4qjmLuONL6pbHey3XFPr3N4jIUMeVJuCxOzCE1YmXQ8hOWcAvcYqtEX98JfOycmEe0dDlin7tdhuwVJZ7UAEvfsOxkO32S0JPO4XXzIIeUAWkJQ9Dx/HPVbeT0QN23y9JbH0UOSnyaWxG+gyyL2hhL/OsEYNLiD9wH2oY/mdz4EpJhOjRQO8stq10P9UbtAteNh/sdajbAsy736TWYpsHsh+OXlIV4XWXwOh6U0a4Zqr2rS2n3jCgnNVo+LcOfT6t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(38100700001)(16526019)(956004)(26005)(186003)(6486002)(7416002)(83380400001)(478600001)(2616005)(36756003)(4326008)(66946007)(7696005)(54906003)(6666004)(316002)(2906002)(5660300002)(52116002)(8936002)(8676002)(66556008)(66476007)(86362001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C8BOswUs00gn6dfMrJtEMrqNyvsZke5/h1ROEyqi/PLG0pNUyUD7ynXH2eqD?=
 =?us-ascii?Q?bbF1gSmI4u9XswsdFO3addk1w+h2giCXjdrQmpAnsWP2br/t4VaEIaO/ytoI?=
 =?us-ascii?Q?VApBk4+T7zMiYOJ/Sp1g1I9kzIDojR8br//hUHBxGa1qef9sysSj4GhOtLyB?=
 =?us-ascii?Q?qWSt5c3cArFa/sEbC79EnGtwtEz9XmsrHUJlWVa+tTnqe4pN/1kzDwmOxBV2?=
 =?us-ascii?Q?sq4YGsIOvudX+Eje3IzSY7GbHwGGh6HFtvifqMutZ9kpjvMoO91Kww/3iJfq?=
 =?us-ascii?Q?oQJ18Mz1dvNaDLoXpMHYmuD5MXih/MetYGsukobQ56Ahl6+tPJdztf8lLEjA?=
 =?us-ascii?Q?jNNOHQjupw6jljw72ynO56WW0GJdQa1fZl98xZJVcb6xUCW3BnUC2JH7g4O9?=
 =?us-ascii?Q?SeNOIhwQiGBO+n9b0dYLAGoWnu0zKguflKYGvUse7pqX+vDmCsFMdAWJ6/hN?=
 =?us-ascii?Q?ghvnxZtRPNw2D+FCe+NkO3ktjimiE4uIsx+sIxQE/QtpBhoNFMYkz/ZX+vxE?=
 =?us-ascii?Q?tEdNpd+f6P4wKHXLt/s/sacJOFKLg/k40NHdFnK+LHAwUB8u/NhkFDuDfv/R?=
 =?us-ascii?Q?T5e2uh3DWZVvcSVK17yleWEGb+Muj10zIBfS7t7Tj68HsYbKUEVaPEmhJwNH?=
 =?us-ascii?Q?r/2bqDaiWBW+g+WombIevqPFUv/4agvp8R85taxNN8scSByVIQJCWDVNunw4?=
 =?us-ascii?Q?ogqMDNEefYGan3cyKU973TCFJjw8y5frcEL423mtGNusam1QyGfaefPRuRdO?=
 =?us-ascii?Q?qmnjFHDCVynGgAlZMNwPMEs3lGzL5g6fcZOgyqfwyvymD6oNe1/uUNYGaX60?=
 =?us-ascii?Q?4ag670M9gF6PKtl8tLodzat57KZlXs91Z1ZbmTYPwpeXx3F4R6jC0+NIH1PW?=
 =?us-ascii?Q?W70Xg15AoQbEpH6vQT6dwnz3OK8W42rj4dsRQJL0Cg5c0G7asKXZ6ak8+ctw?=
 =?us-ascii?Q?j6uSNhlr+GhpgSEFz++t03Fb0x8lb2N/2VvSYNS6MHUgJjBRIUy8knJQ2MeH?=
 =?us-ascii?Q?7mMphpo35Ztci2jFjg/wxME76ocXM9/H6jbbx9ZlfnvlNVmwUCA6kqwFZsuU?=
 =?us-ascii?Q?aOT0XRwxeMcDUCb3thAfgZxHyhAZECBy4BiOST62Ewho5etlSq3QCr+Kn4D9?=
 =?us-ascii?Q?xN1bjg8/eXS/7iz1GWGvtpMLGukl/apHWXQsydwd3o1iwdxbkLJaV8z08y1r?=
 =?us-ascii?Q?CUKkaPOd3dLEk+jaO1gx+YMwHp0Yn7BEjH9rM676kDutn2xc4uZuEDoUQjx8?=
 =?us-ascii?Q?iYYVFSnu8ahkjb+uQ/kdNJ4L0OSeclL8wwDCBIjLGHfvflF9lOiFEFYNsiTN?=
 =?us-ascii?Q?HBlHkfrlFzvW/LRHYkG7rcq1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72b4499-5111-47a3-5d08-08d8f9f337dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 18:30:28.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFzSiS9sBNEWAcp0q3W5bcipFqhHt6D8tPx39Il6zAhDRpqyAHGkm3S3GXyvS1Jwilb8txwZDPD90Z5aVcoSgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3692
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB may not be mapped, which will result in a NULL pointer
dereference.

Check that the GHCB is mapped before attempting the update.

Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..13758e3b106d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2105,5 +2105,6 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+	if (svm->ghcb)
+		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
-- 
2.31.0

