Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7679013CD85
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 20:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgAOTzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 14:55:20 -0500
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:63631
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729025AbgAOTzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 14:55:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIVfoLylm2LDzX9NLADrclAcX2eCT/9NH2pwQoxmV+j3+rJ62q8CNyViXiJF9j7y2Ze9vEg+YtTp1KFbaX0aVC8HtEcrvvMiDxh1ut7BDVrixDXmxXJI34BhRVRqt0H0rwle9vUUE2/7OsbGoh9BaNqlJmwa48G6xV9jxyuIPep4gnhF+gZIJ2LTuihOmpFZoXZ62QUTiSIM/J0nMucFX1dGxYOx5rh/J3/cdbTjlcDafuwIN0sKgeiBsX9fYgWO0Zo3p9M7cq52mOgrodQPxCauGV8UnmSgP2VD9s4RP5DPvK7CIDACM/6FEoHJZIkU+byYqs6A6hsO5D5rDmEQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXLV3KKkyDnoTQGl3RnmhdhFl39LZ6u/2gCnStrvHJI=;
 b=g4iWqEoOoljxEv7Eu8JI+QjMMMnNXz55Q4mny1vse8QOVv1mWsaE0ylNjpvD77DqRR31eHNPwV7CvvWq/2L0pjnVCUa8HOrs6e4bXsaM+dwTOVNXDFUDNZPsHfxgG6UDTFuNJnNYsz+ccAHBZwixzpvMTBeSyJ4sqg5qIfZtzB2lMXYixPaaxvmQ7k2G4M63kE9TxotJJ4T6rhVlHesUZwJM8ey6LXOxxRHSkEnO5jgW8IJrOIyriGvaDkbyQ4FqtbhkE4C0MwRD6PRFy378kTEf1Gy4xQWeMhRKNxBaoV9wYDLhPXZUR3YlyxW2rGsfFXzfHmqpQLszxrd8SHETkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXLV3KKkyDnoTQGl3RnmhdhFl39LZ6u/2gCnStrvHJI=;
 b=t2bx/heEc1Z3L6Miq98DipFS+x7TAXpKBuivnR52FWZlof3E8o7od8MTkzoCVTIUeSpLYBsz8gr8Szt4ah+111oe2XiJAEwWkVt9z7rBmdFwhYNwMXDogN40fkVSne1vm9kXnT/DwUiwaL4RBOzQSnF9J0J65VL37eZY2a9q7qU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Babu.Moger@amd.com; 
Received: from CY4PR12MB1574.namprd12.prod.outlook.com (10.172.71.23) by
 CY4PR12MB1830.namprd12.prod.outlook.com (10.175.81.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 19:55:16 +0000
Received: from CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd]) by CY4PR12MB1574.namprd12.prod.outlook.com
 ([fe80::610a:6908:1e18:49fd%7]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 19:55:16 +0000
Subject: [PATCH] x86: Add a kvm module parameter check for vmware_backdoors
 test
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Date:   Wed, 15 Jan 2020 13:55:15 -0600
Message-ID: <157911811499.8078.14507140648862605986.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:805:f2::46) To CY4PR12MB1574.namprd12.prod.outlook.com
 (2603:10b6:910:e::23)
MIME-Version: 1.0
Received: from naples-babu.amd.com (165.204.78.2) by SN6PR04CA0105.namprd04.prod.outlook.com (2603:10b6:805:f2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 15 Jan 2020 19:55:16 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a9bdd2d-a05f-4e4c-8586-08d799f4d793
X-MS-TrafficTypeDiagnostic: CY4PR12MB1830:|CY4PR12MB1830:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB183082EDDF3572A6196FE81B95370@CY4PR12MB1830.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02830F0362
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(189003)(199004)(186003)(4744005)(16526019)(478600001)(55016002)(103116003)(5660300002)(26005)(66556008)(316002)(81166006)(2906002)(4326008)(8936002)(44832011)(8676002)(7696005)(86362001)(81156014)(52116002)(6916009)(66946007)(66476007)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1830;H:CY4PR12MB1574.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwtvjXtpbDFUHuLxKm9AEjNon1LOY67OwRW20JLsLRX0ytcR3hcTONGOA0a/NbkgLPYfphMTLrNsAIULvQnTKDo1jMVRs4XpTm5Y+iknwfuaaV1sl1qy6uNoeFx2Gcso7ze59OeJ5T54wcY99S9Y1piJrn6kPMVlPE64R1rBi9m6Nt+8gU+uG2Hz82Fq1XFyez/m1z9nFoTywJKtJLClqDjUqNLWfHdGyxYdWn2pL69bItF5oOZKOkPCXNyoDPdejK1lDmCYtBTcih60wnL1CwyxS9erUH+CAkfjAop0GmvszxoY7N818hDNF6Gt0SjiXsSjzsQ7lNoVqdZyJESPY80il1s03k9TfVIHcclALcvs8XZeews8D1QOCHaiwO0RGLyLJV7r6rp61DqQG0GNE+S9X8Ph38cZKQ5g4SaevTm+MWniAgirDOFL0DhhlK0+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9bdd2d-a05f-4e4c-8586-08d799f4d793
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2020 19:55:16.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Z+gg6SQsGx3AzrN4MwlNRHgMNZBDl03IOYpM3HnBvP6xYakoGIGdhJYoijRRBaL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1830
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmware_backdoors test fails if the kvm module parameter
enable_vmware_backdoor is not set to Y. Add a check before
running the test.

Suggested-by: Huang2, Wei <Wei.Huang2@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 x86/unittests.cfg |    1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 51e4ba5..aae1523 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -164,6 +164,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu host
+check = /sys/module/kvm/parameters/enable_vmware_backdoor=Y
 arch = x86_64
 
 [port80]

