Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0224A29E
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgHSPRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 11:17:06 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:48186
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728446AbgHSPRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 11:17:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaMGN2BFVY1sqUMLpMYpOOsMQPuRMI2/MKxKwMj+lNXIFZ6IEh/j1UvMmITCiPFGTeGFREpOgX7xyNXyWlXpBkiANYPWGblzSof8WZqoH9crzKPxu1X0L18AKEYHeSpeS7tNLMYBqPjSJ7591nZdttGEeTtMPJaTT5Z5fUe1E4Ban0NeEvpBcBRlxfukZ5fJV8Ir3UAdR7bd0visQtA7Xoezupk2zUWRg1C52YTfPvqYVAGbolyRvJaja1yLVAl70nuSa5akokbG0QjqjSu+BuLyCSk84zin+1M1RrXyZnUOwAVimfzcC/aPkIOu1HCfe04scrqW1O20QtZbTTUTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaBwUVdU7124MaD/VHK1/mH0hgRrU5eEtfB/WJUuFHc=;
 b=hmxiex7//xOr1IvbL5fUTv71RqALp/9TsQ/D5JZOBD5Afhtt+ryM5dD1AUznBtAYRXpu1W1T30MrK0yFAHhtiMCPNXN1nbf2i1VOcFg2pMV8w7YZZnVGcMjqahIqAT98yXFJ45AXoto7NGzQ42/buf/oG+PjQvvQE1el/mong5jtnk5EteG1H9kUlvK7uUdhMsANWNknxE+fJJ4U+JI6UEH01fe8O/8uEVygLBr1Y5BHQzsNO2Zy0MgXdsEo+0m4a3ITmtLsGOnRVinbOhzD1ZdE/fL0BZWAua1cfMRuEwiksyQD13Ib508FqsHsLf8OSoRY77FbhAzb/jU+Cpw+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaBwUVdU7124MaD/VHK1/mH0hgRrU5eEtfB/WJUuFHc=;
 b=m/ZSuiRACzEUwrPhyiQRX5eWLbKqOOKSdfZ0NZCPErsA9nq5YCKxoDSqhnhfSeJ+mG5ysDzP7056oA879JahnC1xdu+9CQPXD2Gb8DPwCbYaOIrUoAeUcREzZBGI05+aDCJL+/Qy5NapR+PEDldpSw1i0iAsd2T9jqNFZhCSaFc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB3227.namprd12.prod.outlook.com (2603:10b6:5:18d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Wed, 19 Aug 2020 15:16:56 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::15d7:c2da:d92a:2162%11]) with mapi id 15.20.3283.028; Wed, 19 Aug
 2020 15:16:56 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        mingo@redhat.com, jmattson@google.com, joro@8bytes.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, rientjes@google.com, junaids@google.com,
        evantass@amd.com
Subject: [Patch v2 0/4] Defer page pinning for SEV guests until guest pages touched
Date:   Wed, 19 Aug 2020 10:17:38 -0500
Message-Id: <20200819151742.7892-1-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:3:9a::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0045.namprd19.prod.outlook.com (2603:10b6:3:9a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 15:16:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2713e4a5-dca6-4693-e030-08d84452e929
X-MS-TrafficTypeDiagnostic: DM6PR12MB3227:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3227D1D7E32342BD8CB6B644E75D0@DM6PR12MB3227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ai97bf3FBBu3ri67OmUy/cdg5X5fTaGlLi016T+mDCKseA59wgCuZ7x5Vbn8cpi8+RAkVqObf8zfdptnEgiZoCXHzea0v/jTtGu2YsDv3/S3tsOtlSbiKN9EmP0VeZRzigQUnQEd7lLaK0uX+P/CWrtSpdyOvE5g1eBkDqEFtyCqChEGdcv7WTAfH9cTT/etam3Dill0QlXJcq1qf8bNGyzZYMoqDbxEF1UQQB0NOepVXB+6h+EckGFmgQjwWcu6kDfrQ+qXgvHzYuWiDIPmLx5yt4un9B04TuJmIyaqdRGZVGSEg2trwvAm3h5H+/iRla3p2LAtiZz7pUaJyYnVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(66556008)(66476007)(8676002)(66946007)(26005)(86362001)(1076003)(5660300002)(478600001)(6486002)(36756003)(316002)(83380400001)(6666004)(7416002)(2906002)(8936002)(6916009)(4326008)(2616005)(7696005)(16526019)(52116002)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Kk+cJ4CKqf536MX6HlQEVwzkHUVgTcUycFx0FDEFUk5yRSfeyAjv7rv4mftbTEJcU7/wphbOKhdW3e/X7m5HH/9FnNWjpSoMIhrYA/n3FsVMYCVs9/a6VYD/QxnOpcAgt1A0pzJh/WxsIPTlDQZrLrxiRJTzeaCKeB64dalXAH1/1pM3zdHgzRh8X8u8QiPRSJbMknfmH0OT9ATE7NG9HppbbjAvOweeYg4ihZTVJJ/qmed5Vc5d1BYoSgwviZQ9+Pn0l7TkZK8u6/fWidD3H7IEb0tJj7pxX16DIOObb/5URd6lpFD8wr7ATX/2tDxfrPgjS4mZZaFGGUJ+ZUb8AmEt8bIgl1GJywUqlYRgJaYVqS2c01uDlmkRzY7zYKsn7t7xwNx0ItZxlqJ33iuyeuXaGb3m+wTMJ2JU46v+/wz+hTyFP8wPCerxBO/5cgozj0wkFC6v9SvNpngOw3MFhfYLR87jU4lRCYqXxkzi7cz2Zl85XzYnsiL7Vw9dqoBEnpb5BbGtfWqIrDJjlstR4yr5rcCdlH9FywUgOZghBOdYirkLa2xs6VmfS4tA6KGVm4XceN5W0N7rrN89woSSMMMYl4o6So7GI/8ToUgwf4frg+XUkjsPpTGJhfKeNKo+0n5Bm2iYXZXdqzUYrQTGVA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2713e4a5-dca6-4693-e030-08d84452e929
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 15:16:56.5056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yseAXuQq4HyJDqE98IaSFKSjBcs5gK7jSMYcGFb6/zHrX66qVTNayqkply1qEhYC+FxaObN5NHVrOfB8AMQj0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3227
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Overview
========
	Defer pinning of the guest's pages until nested page faults occur
	to improve startup time and reduce memory pressure for SEV guests.

	Cease paying the computational cost of pinning all pages when an
	encrypted region is registered, before it is known if they will be accessed.

	Cease creating the memory pressure due to  pinning all pages when an
	encrypted region is registered before, it is known if they will be accessed.

Timing Results
==========
All timings are done by hand with and Android stopwatch app

SEV guest size(GiB)  	     |  4 |  8 | 16 | 32 | 60 |
without patch series(sec)    |  2 |  3 |  4 |  8 | 14 |
with patch series (sec)      |  1 |  1 |  1 |  1 |  1 |

Patch Series Changelog
==============
	1 -> 2:
		* mmio checks move from sev_pin_page() to caller and the
		  set_spte_notify* symbols are renamed to pin_page().

		* sev_get_page() warns on failures which should not happen.
		
		* kvm->srcu is used to avoid any possibility of a race in
		  sev_launch_update_data()
Applies To:
===========
	This patch applies top of this commit from the <next> branch of
	the kvm tree:
	    c34b26b98cac   Tianjia Zhang : KVM: MIPS: clean up redundant 'kvm_run' parameters

eric van tassell (4):
  KVM:MMU: Introduce the pin_page() callback
  KVM:SVM: Implement pin_page support
  KVM:SVM: Pin sev_launch_update_data() pages via sev_get_page()
  KVM:SVM: Remove struct enc_region and associated pinned page tracking.

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu/mmu.c          |  30 +++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  27 ++--
 arch/x86/kvm/svm/sev.c          | 238 +++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c          |   2 +
 arch/x86/kvm/svm/svm.h          |   4 +-
 6 files changed, 174 insertions(+), 130 deletions(-)

-- 
2.17.1

