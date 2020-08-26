Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625062537FC
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgHZTOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:14:00 -0400
Received: from mail-eopbgr770083.outbound.protection.outlook.com ([40.107.77.83]:22217
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727772AbgHZTNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:13:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oE+NxzmJ+mLhkQOvN+//MtPu5m9MdOVyh24GXJlpG6pkQB1uLTs1TwGPhThualoX0T9C7M5bE5y949+BIiWcZyhlWpjaHaUNoj1P7lQK5jHLHUYt6H5JneyUafUElTYKxPe6KEc8wbJB79owTqPynKW7CP6kYZ70BJjnSOknad2jBew0ydmJjSG4JWzy3GDnyv0Wjw0Hk3yjeOmOYaxIhbYwkoSNiyevJSeDQRlKHcWE8Q1uv3uxUKrW2WebnbQgjuT7tiCrFEWTuGvnS/K4XH/gPjmq2OtrtUmfeCVGQUNZrqUaMY4nfh/DpFZDtk2cf6mRNyfUP4U5upkgKpAD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnA8rp8+HxgO9is7tLLaDPXB8cL3FzUpBFn/5y8ITMY=;
 b=hmyVWBBtyC6VI0zlLmaH7qc0EbWriCG43fqO4Dx3eewo5Uf6sUt81HNy0ibZYt1Wo9b7SWFww+WLAhoLLYLw9ramQXHrrdcg6OgJXnoIUU+5aEMWFFqA9P7C48dCcXqm83f1uzMcjOfZfenYErCFpQvw1lTVcBpQv/8Anlbo4hL4gfFhZEHHAk7AiJ0t1a6lePgJqC40PpMI0ElPIvL7UTbK+ps4mQe+X3xNwUJ5qFgdBMaO9gwjHr8h6gh0KRQa4Jwg0f3iUZe2o2iFFNpn2iNe3K+JUBHS4f+GoZCy22iqcv/7P0R6KqvGtMWniXaeIzvOVaf2KVh1Jh23rlVWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnA8rp8+HxgO9is7tLLaDPXB8cL3FzUpBFn/5y8ITMY=;
 b=vFRBgGPwOp2K+5m8T0MoMCj/9lBWh7sE2tZehh2ZpaAPIJ+lO4hVGPbbdF/j5ABgs83cLhI7jBhzSpu99KcSQic5Jlu+dqqiIweJFR0qb5H10wX5kJO5GpBCSVCp4NH4fxNFMuy93lEGmfZvmukl34DnE8c1PuM5iSvEPU3r+OY=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2384.namprd12.prod.outlook.com (2603:10b6:802:25::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Wed, 26 Aug
 2020 19:13:54 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 19:13:54 +0000
Subject: [PATCH v5 01/12] KVM: SVM: Introduce
 vmcb_(set_intercept/clr_intercept/_is_intercept)
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
Date:   Wed, 26 Aug 2020 14:13:51 -0500
Message-ID: <159846923148.18873.3524447445230117185.stgit@bmoger-ubuntu>
In-Reply-To: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:5:174::23) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM6PR21CA0013.namprd21.prod.outlook.com (2603:10b6:5:174::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.3 via Frontend Transport; Wed, 26 Aug 2020 19:13:52 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd3a577b-397d-4031-d2f5-08d849f42c63
X-MS-TrafficTypeDiagnostic: SN1PR12MB2384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB238420B9635D0282EB04489595540@SN1PR12MB2384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5oeM5eEZu6M5UHPOM6lVRZlWJN9Xcc/+x4HIs11Y+ujDrBddVSn15U53r8PebT2f/5ewYsQhIQQBeth2unnulZezV1PWS/mPliop9bhbhFVYdv7IPpx35UpQVodAPzD0s5e4/sfzueIjTR7+RBYbeGRHpfnIsZeFEdLKd9Wh5iVLO1WsNOcRz/PPWNYErAfj0JymYL1z2FoDXYoZXFSRXodUTdUIjYYBxIufH4iyVZSNspEuG+rHpDNYXM+9nyArMavo6ksSxSghhJ9yExbwjacvxwZeKYJCtzvQS4CEtxHtrpQdI1RRzwxDLFbBpElXHBYD6H+GbIuS2SjS0SEdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(136003)(376002)(396003)(39860400002)(103116003)(4326008)(186003)(66946007)(5660300002)(66476007)(66556008)(44832011)(86362001)(33716001)(9686003)(52116002)(7416002)(6486002)(8936002)(8676002)(16576012)(2906002)(316002)(26005)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c/pIvlwkvV2zIdW+tHu1rh2/z9e+ykuopNWRetMEt5DSPiu3K8V2cOnH+4ikIDJ4GxlD+oJ5p8JILUXUpU/FhzwApL271G2yPPpoXXrJcYdKe2vio0e4bgVzhg2f0+86fz25h73Q4f0v6YuBfEM9ESffWX9vzNCCOtAXGgylIVQEU0DJaCZNfWK46z/+ObqaxMHAlurXEQoG3qlZvp049kqeBz3uRSvNlGgW7zMmEmRdPgXeCxyDqIQDeHDbj00ggRcC4pL7Kl8+X0aIZtOrXVIYyRovcaaBUAp/GyIJwzVphJQ5X9XdwjanOwWLmIJuM77FrznlQjG5BxgwZ6DPbI212Eg7Sxl4hxOogYr8q6KxC57gvbmHkbruUZHu3rGwfs+4k6m6niyKPK1U5wHB6z+Su8g9i6XuDCL7j9qkG6dzEA9OnU0L5+VdXH1PCS0hLXOBi4VYD9bQPi/2LGtdQx63L1weKk48HN+vGenjOY14Mg0zJeO2qjrZ+8yFdj+8NxNfzDPsp5Ny7Gf82+A42soq+EwvzAmz6UWuLwYNIpzFRXeW4v2ehWaMp09XbmKlmbCL3BuZ59x6elE+asr3+VUoJKhA4+WJ4ceYHOdZjPASOFIRLus8FqK/GQSvoORi2BCGmsj0aMWq/3CmrNpiKg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3a577b-397d-4031-d2f5-08d849f42c63
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:13:53.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01Musu7qnrRF8+S2QFrymTzQmq/KGSWVYO+bB/G+ARNN5E3hl3YDuBrZk42DNU4b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2384
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is in preparation for the future intercept vector additions.

Add new functions vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
using kernel APIs __set_bit, __clear_bit and test_bit espectively.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..1cff7644e70b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -214,6 +214,21 @@ static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
 		return svm->vmcb;
 }
 
+static inline void vmcb_set_intercept(struct vmcb_control_area *control, int bit)
+{
+	__set_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
+static inline void vmcb_clr_intercept(struct vmcb_control_area *control, int bit)
+{
+	__clear_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
+static inline bool vmcb_is_intercept(struct vmcb_control_area *control, int bit)
+{
+	return test_bit(bit, (unsigned long *)&control->intercept_cr);
+}
+
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);

