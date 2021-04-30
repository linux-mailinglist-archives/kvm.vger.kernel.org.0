Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2036FAC7
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhD3MoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:44:22 -0400
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:56448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232589AbhD3Mmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxIhrswjmNWfRG1IPgN6bhqJ/ilo9u3TZMvxWByRLyJaziSqirtqbXwSBiZcOJXS+MpiANFMMQxj+NtLcBgvbTEZpQd128hazH5RgK9sSBTjfsR6NcWlVldYPyYTeKObyj+1c8DE4jZYciLI4++jXf5KM3DF1iMDvEc5KQBU9LxtaL2rMmHI0JqMi8YQMhgguYcuObJVtx/3ZFTPTdcumKvGfLoSPbStOcWWBMQa4xOQi3v/13uh7PXYoexIBHzlNcgQmN7T98jPcxe1qy3UuTRGezQIg9cGoduAFV4gbp4VjZPo5CQ59MH4zoQ1g8auIVeSt7daAdcoaH6kwPrLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toP1TudS4MH64jEVgKeCkjhDIQP+Nlel2boNMlLmBEE=;
 b=Tl6i2U23pc3U9AxsP/TUlmmAGp7IXLBdSHqQEZunV/qaZ5doNW4qd+1ZnJNTGkuNaJiaQOHQ5znUH7UgjmJGbgBrY11iW+VwrkdVOv+sL7pwZPTDehuDXP3zyjPKQ3N8d0W6mwlglVrrP6oZqKW6my3MjIEOSsmN3iLs0ITj4YZ8bybZLj0k36UDiB7xJqOok48mNn4rydKRsk2iYO5aeHfJ0tEzG4dx92GQPehzQDGgksMzK4gK9CObLfaRLkRVvtkDj/y4Fzr7HxSGYuDaF2dwhUZ8Vt8EA4SrpBYoV5TbZh382doYTwMPauXC7fVjfREIgQUkfXNq0ptFr4JCVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toP1TudS4MH64jEVgKeCkjhDIQP+Nlel2boNMlLmBEE=;
 b=rqMd7nqjLEkPHVhosBfm+yQAZGIAeiZykwoUdl65kDa5rWPe/f554kfXFfW3eN9e61fA/5f7tSvqLV2qvVzZqhD/LifEWIcchSzV1n1mgSKveefqyzIqic5eX2ErKe62zstFvmyGp0CqKBfOPjRooQxi8tueMLdm4b5b8yPL3Ww=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:50 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:50 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 37/37] KVM: SVM: Advertise the SEV-SNP feature support
Date:   Fri, 30 Apr 2021 07:38:22 -0500
Message-Id: <20210430123822.13825-38-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3abf4c1f-33b6-4440-b57d-08d90bd4fa5b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268836FB77FDBD130CE2034CE55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xFj62jat9H6JRyN25bjnO3FXXh+bYKLEHYOeHb2jLOtNuCN1iRcq+ys5sZpElNVgNlvCIHsJXYjBBQ/U6c1j6eHHTfAAk6b9TLmBBjFk0eNkBJv2EMCGKRSI+aDDC9Ny3F6prR0Ui/DfHX7vVT/NIsjyvJe8UL0k435s/2lC7ZXux9TcQZ8gyilpSnXxYzx2fJtQjM+aNN08zDmXafrFebs/+iASuG6BoWOnBL23ux3CB3EbDRoHozBb46dO7ol2n+nfQNtq9TxfCkEkX6e73IkUxpsTwHmtsBwzbrdwq5JeDIxJYQCuCQfMY8Ynk4p2LPldfTa+/JUFWTKVvd6xbjWz4ZDaGqXYxv8wfC+XrUu4k+mS1kYgo3Rc+9OdWflQlt1MP9CLl8tQqsSFfpVHxbWzF0hIUxVzLd72bDDP3ot8Cw3NX2Ob0Glj7jQl+C6krdktE5sPVj/fhKzJW0E3y90+GlwJoI9c14UjqWvPnE+NY9vCroycVIcHbtCR0gUeJW4d9BGmKGe4/KcNr0S0sxpK4b33xuhdT+5oEB3ZylpEXIaFQX9YSNbXHYSziD2coDfkFvZYF5YTAkfLGSWF9CLIseYyGU3u3QKclwAW5IMmQxHUDPgnSCd23ODO7wgQ6yEVcH5FmwwUjsbQIh7cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(4744005)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0OsLLUGZWoVTuSQddENzcx8ssZY72P+LfAdyfG+lih3dq7ydn7kTMZ15tpfk?=
 =?us-ascii?Q?VgHKpWGEMRmAj0nB+z75/uC2PyKWSuBlx7fOqWsT7BsGVZI9Zcnn/ddNMFv+?=
 =?us-ascii?Q?jyIPZvn8TFQP5Siuzh4v9pvsYtqXyG+LYkMLl4iKSC79R4onX2uV8Jpor7Vp?=
 =?us-ascii?Q?0W/GZuCTL4QtRxbN+Jf3dhA8OlpPgWy9XNgnQUzkXxOHcsH997s+oykpH6qx?=
 =?us-ascii?Q?wpbJaZN8JiCQo8D5ptj0ZK+TYHW31WGF8BTeTNQVFUc9HX8LPKAbiIT+BIPV?=
 =?us-ascii?Q?NWxP3rw9M0uCpfjZv0GsJsjnaJlvV4fPdc/KncI38IJJbTeMVn3BSM8f38GC?=
 =?us-ascii?Q?xp8hWkbGceO5aphCtJ42WIxYzLj244yi6Avt+MKvnH8/HsCtfkyCAode2zWK?=
 =?us-ascii?Q?t7QhCwlchPnDLkJQbWUPqlrgHs1IG2nBKqyZkbjJZpeJdPCdVxhI87r+mAvj?=
 =?us-ascii?Q?HQXgv+d0e/7jx/v4IFi04a/I6a6K/vvXpQev7O7qX36f1MyNBxy0XJWbWfag?=
 =?us-ascii?Q?AA2kpoBWimO3y5gaf13QMcKCVH1GYf1dZA7HbEe/JKeMCKcPanDKB/biU06i?=
 =?us-ascii?Q?KfEKWpUUTc95KeefuSKYZwUFwB6cPSBryUjzPzAmYswii8rtZX/AVorrXeVm?=
 =?us-ascii?Q?yBK8MS9tyyluWyA2CkjsoYkzPEtzn1pPOp/P3zXeWjWD6aeYmq9TVWmgahCY?=
 =?us-ascii?Q?hy1BM6fLgEcT/K840euttE7NFCvDjioTozBfAOWpETROo97mh9WRwh+YGiUf?=
 =?us-ascii?Q?IWPF2DOh1x+eDWAeCKhDReW3HQ3eryj3gX9H9u/bhdwJMNalYK0KUDG0s5Lu?=
 =?us-ascii?Q?OO3C91j6Xd21rW+CUixqtWcmuNTQD/B9OBP60p/NtUvIc7YUQAeIvV2rmKNH?=
 =?us-ascii?Q?g3knpvy8UpvBiSfqPi1n1qigir9a/gC2dv+NFncopQP+3NBBXRR7OmtrNDoM?=
 =?us-ascii?Q?WA4FXWUOfVRmXx/QKiGbY2RMBEidbQ3XRQyuVeWUOKptIiLAIRC68b2Twuq9?=
 =?us-ascii?Q?gni6jqdUqO+K+LMCefA17QeO/rJhDRI9SX4ZpJvIj0hEKItLf4OADYo6gtY3?=
 =?us-ascii?Q?Yx7hEP7J1ELpQDNHLhENczzVyXxxTNJOWivLvuZUhHvyi1HNuCX5iJ7MxMQI?=
 =?us-ascii?Q?38fLgWenHttHGq9OOVovZNj2A6PTC3E0drHGIZG3GgIv++7CbDSTaEB730Y7?=
 =?us-ascii?Q?nLFd/Re+lcCwN8x6cNom/YnDjMcxCniJlhfPw0MsaQENhXKh4JysIjWkYLq0?=
 =?us-ascii?Q?N6dIYEvXpLzekQrSQ1dfT5PqxaWv4HHn0b9quYt0UuwHbE3PyXy64ExD3VdW?=
 =?us-ascii?Q?1BBHTgpehYVPhTNDnwL341A/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abf4c1f-33b6-4440-b57d-08d90bd4fa5b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:21.3281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCginHdoLRC6aWTHbkAZNZza4hcUbwtlFFkUYNYSXUSzaEWxPgTe34zSt2ffoppFEu+aUJnB98KTYwas8Rgm2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM supports all the VMGEXIT NAEs required for the base SEV-SNP
feature, set the hypervisor feature to advertise it.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ecd466721c23..f344ffd5afd6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -553,7 +553,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FEATURES_SUPPORTED	0
+#define GHCB_HV_FEATURES_SUPPORTED	GHCB_HV_FEATURES_SNP
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

