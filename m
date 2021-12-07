Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD2846B2D8
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 07:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhLGG0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 01:26:23 -0500
Received: from mail-eopbgr1300134.outbound.protection.outlook.com ([40.107.130.134]:36592
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230027AbhLGG0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 01:26:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFBcnNlA0574p36+oIrUtF5+srWnuYPIjdh/0DX3NMvIv0B1dU+QqvogAtiG2hkoNlWaJlDOoLO18EJRkPA7NlMF7YwofrqHIRv4ygV7q0hIz90r/baFHdMDuLSQYQTaH6ShukaElt+7VAjmic3OIjpw1hstx1BaZ+ihdMGcwOMxM1dxkr7OQAk+oBH+JEWxmr7nF2hbGQda7gj7qQ4RovCl1KciXVNJgwRsPpxxS2JgX87gPKagrM6aGXCcKnt5IMmbI5KG49UJZolkQOnDI0ZMMaCGiNpVIiRVupMHuVsi/n/zx1Uy8L7LHRSaTBo9URQsX+IcWszLMOlAB3OGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY+vuJNfvdvW9cCdpBrf2sow3gipSX8U76go3p7CLUs=;
 b=LhdSihEVbU/sfwWuP4snWqLX059PcTUZDwKLrGiUbgEqNVP06G2pxkQjqNffTjHFVQO3iBB9QEpVSh5j2Pi0r6mnrN9Owf9gDtvo9FssyQD4OcFxXLVAr6PICxlrAFxaSbheP42Vvcj/YngsFDkcbz4THCGCQwS1W4J/TIZKQM4anRODDpY6FCAvx0G1fV9EPd1/JZSNck3PKli7kbufzmJ557cC+nLDpvXxdFp87DCzoaOU0b+caIX6DPgIRx0sxrIYpwE6zt3CNeByePwgvLXEGoQ3VrDTXK4+1MYxkfrxWiqKR1VyDZ5n/zXxxaiiikdEDZM/3zfhLUVu+xM0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KY+vuJNfvdvW9cCdpBrf2sow3gipSX8U76go3p7CLUs=;
 b=d3fWgUFdWJHd2ebuIAg9edtfeT+QW6L57uthqzxRkKBDBRmLsQ8nZFKCgV7Lb0za8RP/qV+oUd/ELKaRB8oMEnPAsS3XezVCN5kxEV5JVBvesuV8Yu2ADFFXWXzOJC31mHeCIFlY5NLEUv8P1kweV+ZGNSakudqAC1A5+AVXvB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TY2PR06MB3358.apcprd06.prod.outlook.com (2603:1096:404:fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 06:22:49 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::6093:831:2123:6092%8]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 06:22:49 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] KVM: x86/mmu: fix boolreturn.cocci warning
Date:   Mon,  6 Dec 2021 22:22:32 -0800
Message-Id: <20211207062233.38101-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0178.apcprd06.prod.outlook.com
 (2603:1096:1:1e::32) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.vivo.xyz (103.220.76.181) by SG2PR06CA0178.apcprd06.prod.outlook.com (2603:1096:1:1e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 06:22:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06b55217-da7b-4731-3236-08d9b949fe07
X-MS-TrafficTypeDiagnostic: TY2PR06MB3358:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB3358C006E245EFC772023A97A26E9@TY2PR06MB3358.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtwBeM0WccDp79vl09odePJaMtsd9jtQU9pAOCimP9C7F7JpJAkXpyEOgxM9mfODgSG/dEx3/F4/y7sHkZ77B1ipi+lhVtgvncGVzEtnMeTZMoYH4rHWgy7li1G5aG/QLigKkDG7CRBLOLtFPSgPfI6NvRa6t8fPAJkl5z/a9BdJhJOfU3B3auhn8Rc8l8lEKg4C9WKkVclYnv+H5yojd/FXnYEcIcyNcUdFJAyRSMaGegL8nutYlbCU+HiItQTvy4moTKitVrYO8l6NwiaJsjrtSQkf7Trg/xk8F9fnCF6sdkvVkWSTMb9qj6aYe5dysSp4ZZ9fnxG5/7EHtY/Yg0GJnPy3zAjU4A2172D/xKN12upeUJPMunuFLsDoboTYkZ9nbOQJt8zhh9fYiWFN8CSx2m5E0EUBbeI77jj+Ac9ZwXhP6fA/FBfqTqrvP5ihToW7a5RQQyDC8jsqmmDeLJMsfbeLpARnHJIqrkqPeZP7PRM9AmHuw+ApMTODPPT2/nUdt9qy2hSyNWZOi8U80r8upl+DI10yeFMiYChI++JPEOJDqDadlOJ4cUZCOqDLLVg6ytzHXASNIG1XrhUrmlF1eBgyzVSUEir7byHipVQaw4h8ftMjqNKn1uS5K+MrzrxuYTVDyceMugJxZiEaS1oxqbWED1uo0sNN85QtiHTNp9G6/rzPiYudWJKZK1VO8h1mdV8M3GHIFTB1kOjQ7AGHWXk8r2SuR4sGCZSRBW+DBGddEck1Didv88p74ck9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2906002)(110136005)(316002)(4744005)(186003)(8936002)(66476007)(83380400001)(66556008)(1076003)(107886003)(6666004)(4326008)(8676002)(6486002)(7416002)(52116002)(86362001)(508600001)(921005)(38350700002)(38100700002)(6512007)(2616005)(956004)(26005)(5660300002)(36756003)(6506007)(182500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?akPFiSmNeifm8llK3jaJKA9fKbATBpbRpjxE18ebl7bD42qeEpnJptRQL66V?=
 =?us-ascii?Q?2wxLHypgbgqKPrtkr+lOERlBlygHduEchSeg/UUs/WP692mMeiWefVyXZTqg?=
 =?us-ascii?Q?0svZk7CVEu5EaPSBG7ezdfQrxrJf/O0ILtZYaNbLKCVySzVr4fntfOq7SV4t?=
 =?us-ascii?Q?Tek5ILuuZQG1C/yVNp+2qUEz0YY3E6o+G0aMLHkWFT2oH+hC33ga/Bl1WpHO?=
 =?us-ascii?Q?VVMuvgG6W6lsYRMUmsqiOqQxSmsuWOrTMz+hqXWOjifvtrpI6ntDK+/2hQ7p?=
 =?us-ascii?Q?b7SSQ89Bi1o39zhu1WdFQOV0TD+U+VbxNIOQM2hBp8trZs5MG8P62aB5Z7s5?=
 =?us-ascii?Q?/hM1OA6V8bkGa3lOO0/Kxqq2n5sWBQtNF3UippDRN5UzgCp/WwdrZcTrUtS/?=
 =?us-ascii?Q?MYiJYcwk6wzTaSCpQHPPzxdbz4avSDE+Z//w6GRbNpCzxd9xql3gkr4tbGtH?=
 =?us-ascii?Q?D8hbB9zOURuYwA/nwGwuPa6gyv/o+gNa/fj/FOG3wyatDdavmouNe1zceZ9p?=
 =?us-ascii?Q?0z4xxio9V7Gx+59ovwMeYFSp72FTmjpZLLUpDF6V2aFFvFzxT315lI0XuNoU?=
 =?us-ascii?Q?VkRWgFfZedkBxcr6bx2B+c8QDUZxXfhdJr7PkWQ9H2FvbQyLA7NHVapYShOJ?=
 =?us-ascii?Q?fbvh1KJyDkWiT3B+Eh/gD9DSqILQG0CugRatwQiaKwE1BFUsDZ8pVwHsq4f+?=
 =?us-ascii?Q?M+yEqVmQHJaTvKsBJJlOl4fyu09ps/ZIbvq+Non6lZY/7kUP24cTSEPN9IeU?=
 =?us-ascii?Q?acSaDQrQCW9st5MtF5d+oiMKteUY5cGa5vZRFd4ltSotnpItIQhoin23S1D4?=
 =?us-ascii?Q?1HBFQXadxtwXzJF/IXPV6UQoShQNHz6oFTed9YwVjPg7VsnhUuUSHyjmmVlq?=
 =?us-ascii?Q?uw+le8MGrmGYQ7oRhvmLTFZjEGcyVxBCGaeZW2jcc7JD6xXNjpTP1wpzBSaO?=
 =?us-ascii?Q?aH9+yUNk0WDKoNM9oxDX2brJufFPh1PFO0dE5VNmplK0R8Q0gy8H0zmTfHv5?=
 =?us-ascii?Q?VaW7HZtSityRuhmT64mCSEnpwpHvdXqqcUV4M4WorNVxXuj7OpDViKz7FmT1?=
 =?us-ascii?Q?YONEftB8uvl+IHUs+qE01ZLZzNrovDUnCGC4rvnm7U2c+gNji9F0VobNl8Uc?=
 =?us-ascii?Q?3b3MDxafgO9WySZdoSWl/KYbMxlQHRKadYql8sSK8t8A3XUoo1epcDSHFUFc?=
 =?us-ascii?Q?v+np6pRjk2cMKzJ/w7quhHYUQlSPzkuM/GstxoTlyxphV/du98wLyWBaky/s?=
 =?us-ascii?Q?SHkSIdGDODm7vj6EmIhHmmLmz6FGil7eraP0LMb2Ve7FRqCVnxnUFT785avR?=
 =?us-ascii?Q?TP7yJfo0Cu9Fm9gihEL/cMNR36l5xo/NlpLveaGsBOGiPERO8GFMaZx6xiXC?=
 =?us-ascii?Q?YWvdI+CbQT56yU17osruSdCjpPy/yKOdUYsmpFTPqSgX+05nJgw4NYOa4GTO?=
 =?us-ascii?Q?J/R5FmWaEH4F4IkpzZW43ePxaLE9fJauYIsTZskUylrfDpIH4jk82bsIkfyE?=
 =?us-ascii?Q?R1EZpllklieLBwtp1CEVBsops1eNHzsz9WJsGtuOoiF/Sdg+sq3X+pyiuOLg?=
 =?us-ascii?Q?OcY5qrU38gCzvuLNjQCAz65TL8fDwXhBIyhybpaKx3yfk/pBlUUA3YjTwwKN?=
 =?us-ascii?Q?52NDf2Hs6VI1RYiBBdYOqL8=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b55217-da7b-4731-3236-08d9b949fe07
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 06:22:49.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjsQ6OtRqr7LUb3aS3sYpXZPhycvF/YbbaZfNAnn2Mpdu46wUuv2blsOokmD0LHFt242bbPviLDgndDZiut7jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3358
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return statements in functions returning bool should use true/false
instead of 1/0.

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2e1d012df22..fcaa0bf8a1e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1482,7 +1482,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 	if (need_flush && kvm_available_flush_tlb_with_range()) {
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
-		return 0;
+		return false;
 	}
 
 	return need_flush;
@@ -1623,8 +1623,8 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		if (is_accessed_spte(*sptep))
-			return 1;
-	return 0;
+			return true;
+	return false;
 }
 
 #define RMAP_RECYCLE_THRESHOLD 1000
-- 
2.17.1

