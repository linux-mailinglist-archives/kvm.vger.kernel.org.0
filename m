Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7719F481044
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 07:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbhL2GWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 01:22:19 -0500
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:31712
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238893AbhL2GWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 01:22:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JH4erF0GYX2+VKL0XeYF1i+mZKPWcQWfD/mXhpLuljLhin5ktblbJmRMiQBctGbu1akTd46Bj1Z05YnZJMQGKeZzP1ZO/jVbIGOmVpnpF8Pxz2t0TNbAmjF9FfK+6eNr/f5pLfqj5GVmtfav11vp+RQV4nLJGJn0iWim4wGYq4u8yp2fVGvE5EV9wCPUe5qZoTbg7MT0y6eYrqzaTXYcGk8p7kbJb3uzhaJnhMgWmmDGWahoc89SVxFe8O4ezgweQ2GVYfL2PseLX4mzkLo2qHEDMgGXFLJ560R8QVXYLQK19+B0u/VtlCA5gFLibIcFCZjbfQTI10KXaYOhVijhLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xq8jb/b0LiHLV3Gspbaz93u2hf9YJNZ7ZuxIz8J6lwk=;
 b=jkXNs1exXuqImKJSziOmDMIFI2MGX7mY8sEDAsj+CLaYpE0SH1vKYRuM0CROui93BviAfgwDqZLCh9lXtZ43FS7YmLlXHPmbwlg9vlTmp+0Fw0ejs3ch32DeqabTXJVbi3orDk/mIB3CUjq0Iz9bPsNbsTdBfCSmzirxR9DVY9W1HO6UVnCpBkWE/ZLTNSk0cpJUZ1Yqm1RrAPy4QOD3cwaduF9W+8AD2FzuG7zgMY1P+MfzbgIX7ZIPlbbyVH5K1G8MX7dVdjWeDsOxjDh7NY2Lt4auNSbnwfrRQUPOO+c0rOrbc8HERFVJPMOKbtIQtWiRrrr912nImVsmyswW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xq8jb/b0LiHLV3Gspbaz93u2hf9YJNZ7ZuxIz8J6lwk=;
 b=kkyL80LcwcDeqz1VHWh7a3baBhEC7lyB84mVWBbKEJcLL9jOBNrwbNqyrE6748I1YowlK873RXlMrvg5w2p0n+ac5or1vWgDmQ0qlAYml7GFDItLSRldJd7lF7Qq5KuQhH45YIA+BmIiwmvpCWP7fHPHw9M7eklHk71sFwKO24g=
Received: from DM5PR06CA0054.namprd06.prod.outlook.com (2603:10b6:3:37::16) by
 BN6PR12MB1155.namprd12.prod.outlook.com (2603:10b6:404:1b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4823.18; Wed, 29 Dec 2021 06:22:15 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::8f) by DM5PR06CA0054.outlook.office365.com
 (2603:10b6:3:37::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Wed, 29 Dec 2021 06:22:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Wed, 29 Dec 2021 06:22:15 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 00:22:14 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit tests for nSVM
Date:   Wed, 29 Dec 2021 06:21:58 +0000
Message-ID: <20211229062201.26269-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7dfa4b1-23d3-425e-96e7-08d9ca938edc
X-MS-TrafficTypeDiagnostic: BN6PR12MB1155:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB115503F33FC2EEB9B97DF2C4FD449@BN6PR12MB1155.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dHIUfJB1lrJ58bBWJBygH0FmWhyXdRkua6vguL6wLfUbDuYn1lPZvNhDY3N7vlJY56vr9SwLH3ektyWKCUHY2pCl5owxP9O6TnVbxPVeXGNH80hiK2UEWQvK8ogIGOfx0aLZkYSjUZvh99BEdIMddA6qIf6T+TA0nhtSwEJV08XTX7SAFmEGK+OlTQT+ZFj7VZ7snLY39UMe+4WXjbCGMHtVOnnxFuBb0pQUCZG5pYSebmUYk2uXryb/Gw4XFM6ZKuVYAwvax2TE5FxXcgSLAveVUPW2SKxQBLuPtsf3CFSJD0UkiBmRhR/X4HrljMy1Nap1X0/3PwkvXm+uESjcpnrF5uMpQtLgKhP0g4+t8wDOs78NSoyBLevy5YvddMxlQRWsKvrzIk0gGRUXYuuGXeRWvJS1iNB4KYlcZYY9RUAbvmwlFhUnvyHkW7bHK+vxgiw6swGdGxdfTaIOw53Jenk1ACdSCNsQWDr/ITygwkvH/l5cH6KO53an9dMr4Xds2eZ1amMEz1x6M/Z49IzvHc6jf0nKpxWY526C2h1ffW1jJH4D/9CR2ZcjfqB94MvjlMXiKGOnbksjmfSfMXR8GhOyS+rWloSmcLsEMdR+o5w4sakVN0VTTEVDxDmyLS0HKX/Kmt1GHcmU2ghsNXAgFBGVZdxC/9lzS4wCXt0pBdUCVkFgxlxjgoK2z+4EBNCCHpQGMbamYLmGdiJ8rIEtYnELi96tJlQbTnnlD85MA2S1JLNRtWQm+3YLxf6i4gylSTYatTX3mc0tmWIsz8qYYywUZBcEMxoOiabG+oUAXEc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(70206006)(6666004)(36860700001)(508600001)(6916009)(8936002)(7696005)(5660300002)(4744005)(336012)(2616005)(426003)(47076005)(1076003)(40460700001)(44832011)(16526019)(81166007)(70586007)(186003)(36756003)(82310400004)(356005)(86362001)(2906002)(26005)(316002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 06:22:15.4679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7dfa4b1-23d3-425e-96e7-08d9ca938edc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1155
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds 3 KVM Unit tests for nested SVM
1) Check #NM is handled in L2 when L2 #NM handler is registered
   "fnop" instruction is called in L2 to generate the exception

2) Check #BP is handled in L2 when L2 #BP handler is registered
   "int3" instruction is called in L2 to generate the exception

3) Check #OF is handled in L2 when L2 #OF handler is registered
   "into" instruction with instrumented code is used in L2 to
   generate the exception

Manali Shukla (3):
  x86: nSVM: Check #NM exception handling in L2
  x86: nSVM: Check #BP exception handling in L2
  x86: nSVM: Check #OF exception handling in L2

 x86/svm_tests.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

-- 
2.30.2

