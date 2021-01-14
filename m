Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2092F6ED8
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbhANXPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:15:15 -0500
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:37125
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbhANXPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:15:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l58y2zBBdQIQ6BDh2ccuigLQPxDXWZ05bqNFg2ljWfH0Tdq0vEauqBIhn63cTD60fWcmYngzKFGstoGXMOLHJ3mOpVIQY+3LlBG0rmdoWdQeWj6zVhKOgztaZTaqqu0rYDRLyUPmzs5Sh73N+WiaH9tNbLJuKKWb6oKk19T72APDd5NfMveuI9VXAGHJPLX2n/l6eJj9Gcfvoct2KdzjbWVh6ypfqpBrzgJDTl8KfuaXc5eqzEI+xuZqVsjoWteil0H4Fy6FGiy2GP7b+80ZhnBqql6Id/LCGQ9KDFGyePOa9csx41mBO9BbPR6uoIDyajWbPIoDBUSdnx/Tp9o3dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7yg6pbXOjy6pWpK7qw208nKUA0YEOXcTqQdNTJlFaU=;
 b=KKQ2AFj1Awh5vMga7xFbR5E6oW+S17lEDQCj0VgyeTKr/B5EZF3QzAa2QwTmudEefjHTbUd+AW+LXDV/qzg9ogXGyQO5q+XVSarZSZ3uFy1OgDy19SDKlSBg5fQaK4o0gLqcGePuDcW9CkmYyZrn8lfhoyE7gHpTr6Y984eYY/Vjm9kH07jYMVBR7NAwdzZik/ixKbwz7lLPm8rGMnBr9QkyFm0FgIc319ZWlM/ij35wYh2ML4Le/vpyoab+K1SsP6uGCC20HZSP4BughYKxsUq10RX1hpMcBcAKZBYkMeHoHkSLO+2XELzGRWQ8gE4p21YEViVe1MbfIt6cKfPaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7yg6pbXOjy6pWpK7qw208nKUA0YEOXcTqQdNTJlFaU=;
 b=FOmdjW3a3iECjkBdxeO09AsGxMv6EcsKcyW9AXaroVMZKIPTZS10WX205/97k7RfIGZ+t9Cd0RyBvdk6yIpxbha6lrZhpSHcduZJi44tGyOn6aXoGRbK3FqE9vyx0iwjZNi3oeoVvyeAoD96HNICJ9Q4VzX7A47ZyeI5+cHU1kU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:13:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:13:55 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5 6/6] sev/i386: Enable an SEV-ES guest based on SEV policy
Date:   Thu, 14 Jan 2021 17:12:36 -0600
Message-Id: <38989f30c7243296111352d769e4e184f3036cbb.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0067.namprd02.prod.outlook.com
 (2603:10b6:803:20::29) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0067.namprd02.prod.outlook.com (2603:10b6:803:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 23:13:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4d511acf-fcc4-4521-a258-08d8b8e2109b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25031F8771319970ECDBDE28ECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aelx9WzHq/74XZiYITgIYqHGwdpkLuv0i6zQ7OYb2xK2iJJjfLZxHU5IA6XleIEJ0DUcw4n5gveDp65jMKGl1NAIWxYp6rE6/M9g3EGpRjxl2HgXb4z9fJhG4JOAOuKRv3A7BEpdxyeZI1US86jaL5S/ak5rUalw3SFtRXQBPrunx/COtFzsfqvtIotXAccuDZm/wSAZuZ6CEGWBsmkuNIEjvG5lD0PaM1/FAJ90OK87A9XINXuOO+erTEQc6MR73nEaQiTg0+mKiAQN9Y8J5js+d75/kljIioCiz9VWbQi1gINc4DwVPy6wtH0tk3BhBs0Oq/mKa89lTlMTY9vbUxp+/xLcIeqCWz8d2XroXBPmckKHB/gjoUxh3rEPpfqZ3MbEFZS1CawmRvkv5JdCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(4744005)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PHhcUXa+218O0hsX/8tK5ePsjgCOKMgF6VOXHpIEtUzarV6SCUR5jQ+4LWhh?=
 =?us-ascii?Q?E/MpE52wCGpSbq0yX6mcXoeIIGXX7Mzu7ft5crg6MSgh4z95QJzfLE5NT/XP?=
 =?us-ascii?Q?BExeGsyt66zAa+ZOCXT2cdHQo8m/Ji+LWaehZy+eEx3tdhHusBa38kjuR/qU?=
 =?us-ascii?Q?5ZhGx+UsfA2gBx2TxGyRo3loxjoHLxvhbkXH602yI6JYkZVktYwXXG24uouw?=
 =?us-ascii?Q?N5g4dt7HU02VPNkIxC23uwdtR7Sb3a5/cTReIpR4It3nDC843qIhxR8Pu4o9?=
 =?us-ascii?Q?Q27TvkkXWCltPgy1480mckYWJDx4rkDaH87U2Faw/wamibOPhg/9KHVCi6cl?=
 =?us-ascii?Q?GQYLnh0y/F9/SqR+euTJw6rQPAxuZa1kUveWYbgrA1QEvySRbPcXU9Wi4apo?=
 =?us-ascii?Q?+pRaSC2LoP5ltwoazeHP7+cJnMyfKzjTTDS6A2OjMS5ysX3ZcWyxibPkUJxT?=
 =?us-ascii?Q?04srcox0OsWax9JMesH0ppgSHL+blhYiX3cOjyRDV8spsoARuoOxBaCurDBF?=
 =?us-ascii?Q?nwlTwBwY/wCig3znAxFhdFXY2erOMO7gmih1KqCvc25tRuN1bgPzEGG/up7z?=
 =?us-ascii?Q?YrIgPzPoM3PYdvdAbrXrrjW4z15Vl+tSBL73KqdWbX2CYCUvc5PuxBgGDC3G?=
 =?us-ascii?Q?dlWftkKXivyt1JapghsoIafSyI4p0CC7YbT1ffpgMj92LuT5lxK+JGGojkUK?=
 =?us-ascii?Q?Y8g9U5kfGGGfuHNkzrYyc3N+OURg2Myr21Y713vL1VD2a2D1sDLqxEviBoz/?=
 =?us-ascii?Q?GEYrhS9fCckDiCC9V+XR8okNSysiHM7vOFvmMTdb93yt5q7cyZ+lZiaLkAAe?=
 =?us-ascii?Q?UmARXIdkEOl8JFxX1A175966ykPFTbQLjYmxyAP+6T/EmrxY6g/Isi6ISDkd?=
 =?us-ascii?Q?2sZoaEoaab3C6TbE/KG2CsHyVhM5tBE4DOE/rb6oupNcQzwn93wYnM7WcDYj?=
 =?us-ascii?Q?PsKp29Vd8RhGoX11FBxVahUePINYVyCVy1wbj1gMoMhYSMnqc5q5wEZmrcay?=
 =?us-ascii?Q?GV7Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:13:55.2400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d511acf-fcc4-4521-a258-08d8b8e2109b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hI7DBP9zfZhWRuhXx1BomP1qT2Yuwv8TxfwLwZ7j2aPFTkC23ynZb4PbabMz+JmO7pTyEwQ5+OCSwoGBffRlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the sev_es_enabled() function return value to be based on the SEV
policy that has been specified. SEV-ES is enabled if SEV is enabled and
the SEV-ES policy bit is set in the policy object.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index badc141554..62ecc28cf6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -371,7 +371,7 @@ sev_enabled(void)
 bool
 sev_es_enabled(void)
 {
-    return false;
+    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
 }
 
 uint64_t
-- 
2.30.0

