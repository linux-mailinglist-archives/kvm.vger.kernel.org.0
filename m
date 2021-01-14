Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB982F6ED9
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbhANXO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:14:59 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:1122
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbhANXO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:14:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SknHPJFSytA+pbAblFPvdHTItQjqNMvQ/FiyTgj+3AtbrYlTWMWBILTI4FrKaR4gbEwj/0DksxVyKW8Dn38exJ5yCWS3q0k1kLPsVXUA5OxBTNoTl+oishdSQDSivUoM9eSqW8FF9pU7fcFer86DqW8HtYy5VKCtBOMroQtDTDg+F7afJwcDs020HI7/AqLkSZF56N6xQZCCUAzn2wJteThzkrjnJwvDcTipDLaKQPKTaqLx7MErbwOyyhgjHPgiy+h25L1KEo1vjDNJZ95uEMRFcK+WLeWku8UOMCu4Lph6giUO/h7DQuqEjqokhs5gWFF85YM7Ooe6oufmNkQIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR4/S7ATo2WmVto3ZLWqLM2d/h/9jnloCS7eA9/vH1Q=;
 b=CDZ1ipkqLk3MUnkRTXINv5FVkRH8H5KyBdQXEnEqgcDp3u2ZaJrVM/L5TKPa0c9rqIj0x+azrw82NgnUw9QN8Lv1qbEAJP7jlYmBhw5YHuWCXp+3eZFZO1+SggWKiO8YGfQfln0ya4N/Y1G9gNurYx5vIzZqkFUKgVRLUQaodguMgFoYMCKNjIYHyZeGKPTDVdK1RHiCrqBGMJZKkfxplrIIqBOLYEJY9Ovxv5BOwn6x9MMR020Uy0+GDoEFzO79/u6ZAqr/oLWJ3cCqheqbFkL67Q7QX6lvgugzW/g/055kTvwyhkUqlX0kWGbpizMZ8SCFJKdBwVWinJJqeD0uNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR4/S7ATo2WmVto3ZLWqLM2d/h/9jnloCS7eA9/vH1Q=;
 b=5l2SnoWAJb9kydjcnoyXAQf3KQGSn3IdRajWpCdpieNmamR6D6LLUKq/KaqLUUojbzSx1JUd5knfPkxLwis7qxwH2yV4CxV1GTOkjcVMTM1ZBJ9SR9BIXMjog2KcfxdoY42Q9YrmdnPAnDm2XVemDcPUJaFz4R6b2xAh82xliUc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:13:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:13:46 +0000
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
Subject: [PATCH v5 5/6] kvm/i386: Use a per-VM check for SMM capability
Date:   Thu, 14 Jan 2021 17:12:35 -0600
Message-Id: <d0ef11c086690a3a876e07ffd9b7bf92665cd6bc.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR2101CA0020.namprd21.prod.outlook.com
 (2603:10b6:805:106::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR2101CA0020.namprd21.prod.outlook.com (2603:10b6:805:106::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.1 via Frontend Transport; Thu, 14 Jan 2021 23:13:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d48aeb8f-2bcf-49be-362f-08d8b8e20b82
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25038195670C371105FBEA17ECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1oclUrQfFT73OTNkqcZYCwuKt2KqdvoTuBae/FBSr5pnyWHDqDrncs9fYhibh1NwAJ18zcMBmiNFfQ44as90u20ICq6WyXZeAx3XF1oy1rVOiQh6tX5aKSTLfjd1EaszbgvKEQj3Sexc2Wo2FCmG3FM88APWvqXRzoZ3KOdTUW8H5mw94Ig54LxM2PWMxcpIGHCCfOeoJn3lwSr+IMpVjVk6gZ6zpHD7oTDBrBf583myDf70ljqwEYGRHlphnQS3lFyYzxsQji3jQhHPROVVGiSOb8VJ77a9L4Vgz7WADLJD5k0lhuh1wKFDuDq0f92rw8Ukbybqzbzhwp9axy/sCHrRe4+hW+L++fjyOmg78Q1XdVLuTE12RoJ2qSNE1EJW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(4744005)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2S12Q9u5jRlGFckMPfpYNdIrMzrAf3visZtI73PvnShlY3arBKUkvZEaFRMT?=
 =?us-ascii?Q?DUbdqJ70SJWFhahjdDwde6N69tSdXPCacG6vzANX+1gRLTkzf6E7dVTGg7UA?=
 =?us-ascii?Q?6UiMa+4MLOzbSC0K/9FJ3z5sh6JZ/LeRZDg6gtpayVZN39XMxCohnIW8zQe3?=
 =?us-ascii?Q?DM8srd0LuFr3wUiRyTSeVBk8j64b0086f4jLxPKYYe38e3ECMQYrMEvYpifx?=
 =?us-ascii?Q?URCoFqDiE6tFCYDNWxtooEBbt/lvN6m66KMUj6veR44+QjP60Yv+oxhGbe0D?=
 =?us-ascii?Q?tX0p0jTKVPVJKlgJ7kZ2RS7DeM+6wBTts3VvR/nUnCA5HM36uyEEZpV91A0H?=
 =?us-ascii?Q?uzxi5V4+RB+R9AQCEMh+IKTcv3IlwvofAkcp1ZztL9BTdUVYIT2jHbm1kiqf?=
 =?us-ascii?Q?/xJSG2v5xdCyqFyweY0tpFE+aW1inyAIOWQrd+essHw1hsrv+2Upg8oA16RT?=
 =?us-ascii?Q?TslrQLvrNeTZCOx7TK9+Hrz/0sCXwn4RHW1OZ1cpSo3ySKRZ6gLn23KbC1zr?=
 =?us-ascii?Q?LPn43QNxewi5/Th/dsrvbIdtey9ghj8JrK+zR6NKrc51NH+RtBBneC7JvoeL?=
 =?us-ascii?Q?qnSDr00Ton/YQGeduuxJP9K1U2qs5J2/OkbIbl/h2ihVMqlh2dsnY+alph2+?=
 =?us-ascii?Q?Fi7LcPfYOAv7oiol7lNHhuVB0h+YA15xCiFJSgx1goH0pk3cl4f5ruXmEakv?=
 =?us-ascii?Q?Z0m1ifpv6tRciJQ9MOswY+c/i9vmHJRQ/FWqFirSz+6dZMXB72LjZmhBmHZG?=
 =?us-ascii?Q?OvzvyJabJFCS/rreBUSx0lffZnMs1IhDwyeKdRVEXsknrrLd3KalVA2WWmP7?=
 =?us-ascii?Q?f3VP/wkzM0f48pzqsPQfMo2+7ZTJ+Z9kNiIxmn7+XYzk2/aO8nOfWwN5S+Fx?=
 =?us-ascii?Q?FII4AWCPi5xoH/dRI/Kl5xPRPKb37fhVtyvj/SphbqjZ08CpsrWIyAV2OKjD?=
 =?us-ascii?Q?jEIemIbfP5wEFrmV+rZJImDZAFSdqB7jE9VPp3O8XtbcstiKBR2/MGcvxOxs?=
 =?us-ascii?Q?qJj3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:13:46.7218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d48aeb8f-2bcf-49be-362f-08d8b8e20b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pS98DQ2L/k52nU8hmZGgcMBuaEmGO2BwqdcMcx+Ks7At7fMyRSfvBwE1sCzixW7/vQ6xojrhfk2nX6MTMpGE3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

SMM is not currently supported for an SEV-ES guest by KVM. Change the SMM
capability check from a KVM-wide check to a per-VM check in order to have
a finer-grained SMM capability check.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index bb6bfc19de..37fca43cd9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -135,7 +135,7 @@ int kvm_has_pit_state2(void)
 
 bool kvm_has_smm(void)
 {
-    return kvm_check_extension(kvm_state, KVM_CAP_X86_SMM);
+    return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
 }
 
 bool kvm_has_adjust_clock_stable(void)
-- 
2.30.0

