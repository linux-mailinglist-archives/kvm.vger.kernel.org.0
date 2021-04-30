Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C2236FA78
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhD3Mj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:56 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232332AbhD3Mjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ul9ZrRhBa0qKFXSvsxUFP+dRP4+IWUov+mDY0zdgpqRSNF7hZe3yb9hjwKVN3iqPW6/eRBncXDLZyZBYB9pdqq8qFNpcdwGP3/Laf8KOCrEC7N0dJoiuitbJHzdJjI13fjTDWUKPozOPfp4FFB7Q87lNuEe1lrp6A+lRh6lay9oppLm3MyV7+/li4T4eJ1vhrK3fpSAIRv0NF8m8rjUcBRt5LqoihnoNKTGeeX5d5qaS19YxJRMYR5pwUepf48H4Et3WMXjBRSfVYXxCADMQANtJJwFIv0Ju/Lbr1RWx1F8oHxxjqvyQlMwrIaBLdxE+IwlgUK4oLBEVjBz136hAlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i44ReSM8MQmWE/MFoOP7MFdrznCUvGyizGwNj2/3dJM=;
 b=NhXixHsyene63h0M6+4G0qBHvht0u9oaX0+loZtPBpPOcCn2am05N0DdPc/6IxyYyuAD1mGGqjJaFVHfdHtmXAvc/yLktlH5N+y1f3Syc0O+KzMjA2Fb+pYxk/ks9a/IFDwLnB2/GBKr1/DaCG7C50/0UpG+f9RpcRFw4uC0WddJgOFUrVUw8EAUYIXnqLrNmrtV9N1W79hf+iBCpnbmY9PD+mz/PENHCrvPRNkaXMW0/2UGlSmJxSEoEzAy/8h43+sboVco4uijvHGo0+ufIthEuU8/ASnPDN3/d2GR5RjGaxC4Odu+oX4jIwMQuIAFJi0xPzFyniqeykJMI2lBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i44ReSM8MQmWE/MFoOP7MFdrznCUvGyizGwNj2/3dJM=;
 b=TTsrUGGCbU7iCm0PynB0VV/7to3/cxKUPSWq3otuYvIuuLRhAmWAPrz3dnVWHz1F51SHg1fm/6RRzIAY91Q91nVgQyBnFFFcYeKx4rmOzjj6mZcLwIHm6tSlZZsdD9bfpSO3+iLiM7Ca0tlzY1awapAwWnfD9ORsfuYaztjl5P4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:56 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 03/37] KVM: SVM: Increase the GHCB protocol version
Date:   Fri, 30 Apr 2021 07:37:48 -0500
Message-Id: <20210430123822.13825-4-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98d08e53-2ada-4737-5a81-08d90bd4eb43
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4511A3688ECAC5BC8AB2D19FE55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTJtzZEN+WskXKh2OKq4SjBMY34v4LJwOyIYKNhkAJTcZPecH5h0a4mpWlXpbuyGfM+nMBOjFldq94N5h0CrG35VjR8UQ0JN8Q6OVzFJh8eAlVAdvarb49uvj2SsLb1lcTqcoyfyR0Yd/qHu57QVtgwL13J2WVrLY8kNqZ7ewG5IqZpkpcPipwpgGuiwAd7+DlK2nAHwUrkCrN/JM4fNZM5vJfWe9zNXSBDnG1sYdLXa71YwERNNYBy6obj1Bfpv6+rjCWADOLGHeC7iArA3lvCe2AANcJaQF7yIKWS6zGI6dg6YjlksHt6rG7nZq4Rc86/FSSsnaUnUzLY+5+EgEJKv+QUHV8TkwQs4KddbokmoOVEK1fqNeuVJjjoB55L2Q5/0rvpt7pJ23j/kq4D3mxeT7teHRT5/YbgP9V1XbxFv0/Pw0pLYZv3RxtJFuPIkHPXTreeIJ/njJ9ALCWVCrWhbLqBL/dzzt1BbJg1TQzMnIC/jTwl9Z8Ese7P9jOhcwqxSuSuIohHHOVNAPHwLxImw99r80AOORHofg9Ay0C3nxh8iD6HQuWika8TqW1q5IG1QtAi/ODmx1mFrtdZwXcRhTYyG+QOPvSXLH3G4yNRZl6E/SCns9xPWH3scc/ok2VhsvG6ByS9FuwzCL5TcLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(4744005)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U3JYmPJ84NxKHR0CYycpk7Ylm1RUMKCVy5xxl21VFHnrw2rvhS8S34o75Mne?=
 =?us-ascii?Q?5mLleqUK1euev/B/LcUnjaICKizfo4HA67pYyezTVfQPPJmWPQZoPx44rL6R?=
 =?us-ascii?Q?nDD9fcKSfAi4Z3U7zOQ+3Y+91HYNJnqLuy1kWuh1YJdpJ+YQ/z2BZHnJisE4?=
 =?us-ascii?Q?A1aBbh7curslL9bMdS/EazNdVYxsjmafgE1c5XrZg7DXmMCnqmtv3ynCDdON?=
 =?us-ascii?Q?dAOYO6rkeEzj7gunN7XosiEg9ZS3kg0ugG2ZmwBw99RbnWNrVGmufWsAextE?=
 =?us-ascii?Q?PGiePjxfZPqb9BayExsE3+FKF6oa7gMbaMHB1YUO9kYHcaYODGn8Lh5cypoj?=
 =?us-ascii?Q?mzehgYoH+VpRLH1N2SpfGY7FY+d/vdSW6/3lDyJYEnVg1yTVZUgdm4fwOUjN?=
 =?us-ascii?Q?dBZ3cdcMbTzavTWOV46yIdzMdaJPyr2JnGwWvzTgG9oQxNrv8JAV5xZUiOwS?=
 =?us-ascii?Q?4g713Tp1okQt9va98VWhUlT/EZi4lnH6+HjjSf5THBCJUBBYrpjrnI3h/9j2?=
 =?us-ascii?Q?G9L7SiLducJx/PbeuvkkpRn5PvtV1Yn3+SODCiwtzPVo69ktCQYF4GkDaToZ?=
 =?us-ascii?Q?vT+H+8qh/jTVbHCc/wLFwA3Sm+8Neiw5EzxyOF8jGmlT828QE9CjWxiWw72O?=
 =?us-ascii?Q?Kx9H9geokXuCC0LJCl6+sQtSXDBe0Wc6TmFWNa7wzoBDJcfilH0xUEcMEwLn?=
 =?us-ascii?Q?hsSIlK1yfscDT9NZvsjHLSCQnMm159/+oi9UE/IF6XuwTDvcdxbr6olsZVae?=
 =?us-ascii?Q?Sr81+c1WCj43ESVHWqrXHipuxBCGuVpl1kNxy8HEdW21pvGSttLWOMrTjGsj?=
 =?us-ascii?Q?FrlD65FEn8CXUOtWuz3RIprppIlgyK87aoQHRx1eQdk7NzIpls4APAazQMGH?=
 =?us-ascii?Q?CQixa4KddvFZythvuuy190WhAfjPjhIpb2YKukcMEqVMPspKhrzXZvHGGZqB?=
 =?us-ascii?Q?t6tjrToLhujkkc2oBonvrA1EpDP9EXRCcsveIiDtS6dM8mlM556/iy+B/60o?=
 =?us-ascii?Q?b/l1ZJCWT6CX2C5CF+ctazPOoS/PhUv1MDqUE3teKLrql6iI2FAg+oaSYZnC?=
 =?us-ascii?Q?XKgYxJJbpjrO00SF7eRuTAFgn2zJ9J3hb5Su3QICqJ10rgXO7t9ArumvG+KM?=
 =?us-ascii?Q?Us0DFSlLDBBv9pItPirF7OoRvXcvNHDMiEhCORY8jfN+QCjr1tmBRu1+GmXX?=
 =?us-ascii?Q?MtK6MDpGDK3qpPQNACcMA1BB4Qk+BCzViC1Wkgmh0PK14qtqxm5KT8kxD6sq?=
 =?us-ascii?Q?BlXnkE0eTCqPQJ2OxTM1ZbVMbFEDogWA+C/+yRbzQZ3fPIY6wG0Yccghd5WP?=
 =?us-ascii?Q?itDCw3fhoRcFckdKymv7tcII?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d08e53-2ada-4737-5a81-08d90bd4eb43
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:55.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOj8CgLLtpGioyuvwPW/AMC76/fJGqJr1LCLckOdUXumd/K//d1NbiD30fQ8970s7PhLrD3/uAJtmpZFkzuNlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2b0083753812..053f2505a738 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -527,7 +527,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 #define GHCB_HV_FEATURES_SUPPORTED	0
-- 
2.17.1

