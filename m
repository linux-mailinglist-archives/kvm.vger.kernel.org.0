Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01136A3D72
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjB0IwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjB0Ivc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:51:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0B23652;
        Mon, 27 Feb 2023 00:44:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Seg6W8/ULpnnkp7jw2zvrn7PmCR4hlYihQuSOvbawf9/5s2BxjutvRP3uwm4Z5J6dkV2ew1Drdv4w9DGKhWDrya+L+6uZvOPbf07XUDSWSg2ve/WGIBLAJxEjlxju5FKn+4dNpsXRBCm/7wZk8I/Iv7SD/DgBmvBoS8eMiSXj4OzlO+zQTsqRIBfluKPR/cZYmyADeHoxmfofxutRJbBswhnan8u4ml+Polu7dldOkWfqmwqHm6UrZUQH6UekjY50Txz75bTtBiiH5TwMoBwVbJTPhZy0ajROsqlOdxcadytGv8a/tERPXNTgJaxeU183aZ88aC4z9cZMV4hFP/NcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quQzSxoaA04Q4hplPZTYF++P0g/hUtDayzv8PGpOC+I=;
 b=hTik2kua63rCPbqbcc1iL9eccCLtgxjeoDU3a84nDbRNk5cx2QememzgTZe4q/VPSpJYiZYpP6+B/ice/lH7N+g4leIl5ayTIXpFV5QeNSX24b8m1qw23042R/CeWGDuU955JdRRDUStYM5KHcZt+Ga5TreyXZcF7UidCwWH2+Z5P59PwDGAIUb+ovO8aroxC/qhRNE03dlx43hIt5jay4DrLMkfn+uYPD5T+kRGKVYZZBLGQ9ZQwGJfg+HRlOMbSqXqHysDJW4rsSfAqStSgJcvbmtd6QIC4yiovy375cVRHisPHC9DUQCYMEkS3kUK7u4pTrU7POMJIqFWjJ4TwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quQzSxoaA04Q4hplPZTYF++P0g/hUtDayzv8PGpOC+I=;
 b=fpoqefpWHWOvcr1GOaqH5my8j+Rb/JxNsb1c3y5ixueS7QuF5YdzqCU5SkiHSxyz76iWRhjXsViQbwzR4AM6/CSsMwQ/nQfV6wILnOs3IgLdd2xdN9pcb358NdJxUbmspbP0feu5y3vX2kYNd7+BhDK4uhZTVc23SK7WwJgwacM=
Received: from MW4PR03CA0138.namprd03.prod.outlook.com (2603:10b6:303:8c::23)
 by DS7PR12MB8231.namprd12.prod.outlook.com (2603:10b6:8:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:42:45 +0000
Received: from CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::6d) by MW4PR03CA0138.outlook.office365.com
 (2603:10b6:303:8c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 08:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT100.mail.protection.outlook.com (10.13.175.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:42:45 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:42:40 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 05/11] KVM: x86: Raise an event request when processing NMIs if an NMI is pending
Date:   Mon, 27 Feb 2023 14:10:10 +0530
Message-ID: <20230227084016.3368-6-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT100:EE_|DS7PR12MB8231:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b09f0c0-15ae-4f02-44c1-08db189e98db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+bNI6njI2sO2T81id/9HMv8mf/m5NKVUOqHC/1vJ+OkR++cCotNRKWKz9vqiRg1qN0nbxLhtMvXsbvbtPrFtqp76e5lHlsXYr/+XdsYpSESu3JrJIS46hKtOkr07Qy/hq5ur1bhkAmcnmsUZ7ZorfMX5N+IyTBPum7TjePuBS5NRrG79aViKs+anO2QMrKXP8o3wiAMlMOXD1314+eW0QQnxrtDrmv88MUEkczD9esnSCYv2voUg3dvd+WboJ3ejV/i/j3Wz7C3n3SXT1yl6XIA2Ih4Gi73yqLu5EA62yXL8F94FQwnJXjzsXcRLkPtQeVBnAMxF22iY7N5HwakwygLFLb/xFwNNLQWolzRiH01g2OsBCsZE5+4iIdEehmIW7Uu2ORagnTpeFYnl+Fz5HN3YMHh6JaiViEdq9u11uuv7OyXAUUpbZqlJLN+LrLjzLjH80xRjBs87QMoFIIBjK9JnZ6B1g5oDeIgL2ku2uTuPdk37a2IBM5z/1X/67TkEuDWtJcSO6x9mpG8YPzv46MTZq0wvmZU+r+XdHo4GbHoPixZSW35tGWjX4VdnHPmcRjFmc89KCw1J6oCRis3n3noN7YULj9wCD0H9M5K1wgsEERaHhxTNnZrB4pJBtn/bPNmLfQI9T+slucGGdI8uZoYS8bDUViYrMVvBEznJyFmkXirAB40Qd1ShoaOAHKTRwSnPOAdLqKDG8uw3L/xy2MoJTwPSI4BXOQa+exIXU0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(40470700004)(46966006)(36840700001)(8936002)(2906002)(5660300002)(41300700001)(44832011)(70206006)(70586007)(4326008)(8676002)(110136005)(316002)(54906003)(478600001)(7696005)(6666004)(82310400005)(36860700001)(426003)(47076005)(26005)(16526019)(186003)(1076003)(336012)(2616005)(40480700001)(86362001)(82740400003)(36756003)(81166007)(83380400001)(40460700003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:42:45.0057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b09f0c0-15ae-4f02-44c1-08db189e98db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8231
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Don't raise KVM_REQ_EVENT if no NMIs are pending at the end of
process_nmi().  Finishing process_nmi() without a pending NMI will become
much more likely when KVM gains support for AMD's vNMI, which allows
pending vNMIs in hardware, i.e. doesn't require explicit injection.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f706621c35b8..1cd9cadc82af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10148,7 +10148,9 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
-	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	if (vcpu->arch.nmi_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
-- 
2.25.1

