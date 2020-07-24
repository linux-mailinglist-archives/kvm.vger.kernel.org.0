Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA91022D27D
	for <lists+kvm@lfdr.de>; Sat, 25 Jul 2020 01:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgGXXzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 19:55:14 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:27873
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726572AbgGXXzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 19:55:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us1wIUHTlnr/KO4jXt/cbZJYGr/RDRsrLXaSBcAF/6xGozvSDTvbGbTHPcnimvTq8Z2uyImSRnpOWerSvk9kPErYyXOcwwez9dvchuXzChIEiPRpvyJ4NqLEiOS2z15FtMqeCIg+p9lv70Bbv6UAI25ldmVzm7WOd1Vv41EFtytDYh9DJK43mcm1VNQRKFmZZz3mr7i79C+9++LmRU+KHE5VU2rTjq0R2aYcLs6vSVJberwHF9ssotKsv2TkRvv+kudRVYGgLpsXr00l9MBoO/B8FsusspzZV7E8y8dI2mUmg2QaaAN5b0aimx4Ai9gX5W1jva6Yge8hnVl4XLk1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGtT5QqGB4oN/X6bFy5IC5r2x/LZGO/fJsE6jNDCjNI=;
 b=aLCr5CvukMIW4Vo17xA12qXoyDmySqi+SFU2+W+fyCHJh/kUTdYGGxvxdODGZgoVtbmvkIEj+wjA+zNsifHcTQBs0vbpKzma5B3tBNuPzBVdlHYeU50nzL0nLibBrGZuLaxn5wB1bWdDtSCiz6FxXAR5n7TP3UVI5HMzCK3lW3T8jHaY1RsjT5EYGvVTcoAQaevy+TfIhozvynl9hg4b9kcOEyTPFVw1SLhsN5esEDPCIkYiMPkxkAMAa7KwTpG+m/rvh4MafAx3RCVPaJ6NuyO9CN7ATdBzrBLISqrYOpYUDEZYZNTpr5zZU921qJrVA+SfUZP7csjF4SXkfnhx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGtT5QqGB4oN/X6bFy5IC5r2x/LZGO/fJsE6jNDCjNI=;
 b=LI9ii7q0n8UNmlXoNtpdsnoF8UkHN9tTmCj8fDWBxceEQ8/TF8NsMh+dxB04utjIeVZWMULBSdkY88mxx+n+rg3Hns4rnxfjLPror78nS6ByVmPP+k4lTYmhe65l93GO+TJOSwjBwkifQH2gK195iAa9NPJAgqfodL7mj5ptJX0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DM6PR12MB2652.namprd12.prod.outlook.com (2603:10b6:5:41::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Fri, 24 Jul 2020 23:55:07 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::815c:cab8:eccc:2e48%8]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 23:55:07 +0000
From:   eric van tassell <Eric.VanTassell@amd.com>
To:     kvm@vger.kernel.org
Cc:     bp@alien8.de, hpa@zytor.com, mingo@redhat.com, jmattson@google.com,
        joro@8bytes.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org,
        evantass@amd.com
Subject: [Patch 0/4] Defer page pinning for SEV guests until guest pages touched
Date:   Fri, 24 Jul 2020 18:54:44 -0500
Message-Id: <20200724235448.106142-1-Eric.VanTassell@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:3:9a::19) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from evt-speedway-83bc.amd.com (165.204.78.2) by DM5PR19CA0033.namprd19.prod.outlook.com (2603:10b6:3:9a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 23:55:06 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a7cf54c-7fa9-442c-ddca-08d8302cfdea
X-MS-TrafficTypeDiagnostic: DM6PR12MB2652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2652D09E269C04EE1FD9DDCDE7770@DM6PR12MB2652.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54gkVV6eGLtIRA+Frlave6BdT8hJhe7eMFxIWvlcHwetalfjMZR7ejNJJDFUffoln2Y7gHfGxZlcwXKJiAIh0Hqq7cBjN4z08UhV7kgOdXzlW/qs73hBHlTmrJw/nRlRZX/FQdiAd2cydaemCqy0a+oqtrfdBEGpz1/gMAcRE0hpzY4HQtnfxJ/UlP9NLMMzSYZATgDvxHGyOPU+rTbZOGRFHTd6vPhtQ9Uq4sIHcupqKsE4vnej3pq/XvLCH+oV1ZoBjQsDH4rUDvVwysNBbwVTJtfGsnc/37rXzDw+G7FQ2TCO6mMMRVHCAZMhr47hcz76brFsVEzlJH1NYcNQ4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(6486002)(6916009)(36756003)(8936002)(8676002)(26005)(86362001)(7416002)(7696005)(16526019)(2906002)(316002)(186003)(478600001)(52116002)(83380400001)(66476007)(66556008)(66946007)(6666004)(2616005)(956004)(1076003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LmBuXZB/HGOGSnG47ki5VaZfDqKGUk8wSi/VBcE9zb3zpNmbQ8s357nIOmkrG+k3mFCsxCawUdSfCQdK3UYWVp0OjrnWd9sLE11HIWd/OAF7ef/DeFyVYq/9Z8CUtrfeU4PW8k+2pLLtq361RBaqFrJcttwUMdTxfaBGe6+y38IpaPH5bR7E41H5BpPjhYA3OiX1C90OvTsmsnMMsiLqJpeh85ZLdK/JewPMa1Ow0EUBEOooSMORPPeevQrmmRvpirvaIvXeaWZ4Vwb4C4n/FfMo1EItPtkVJNuqbZ3N1QS2VkuxDftVLKEPgpwiydjxURTpLxabutQZiy+uJYE5hFmiALdn441l4S1G3z+SyvHiAo3Bi3IQDBCjUNobrdEbXWKxqTGH4drp21SDKDJKebMyiBnhHdr/5PecBqW+PeTbpCHXzYJ7dTnd4G8G2VoZVpTLzfhDPchb/hvWT+eXDA0x4go49q5jhOHO7jNVmFY=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7cf54c-7fa9-442c-ddca-08d8302cfdea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 23:55:07.2396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osWG9O3P8AV8iO4CaUHbcUx+H7xU5gOM9eeZpOV+SzUx6CIPE9/xcSZV1OSvsQtzU3csuyozoeBc5AolUbvqDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2652
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

Applies To:
===========
	This patch applies top of this commit from the <next> branch of
	the kvm tree:
	    c34b26b98cac   Tianjia Zhang : KVM: MIPS: clean up redundant 'kvm_run' parameters

eric van tassell (4):
  KVM:MMU: Introduce the set_spte_notify() callback
  KVM:SVM: Introduce set_spte_notify support
  KVM:SVM: Pin sev_launch_update_data() pages via sev_get_page()
  KVM:SVM: Remove struct enc_region and associated pinned page tracking.

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu/mmu.c          |  31 ++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  27 ++--
 arch/x86/kvm/svm/sev.c          | 232 ++++++++++++++++----------------
 arch/x86/kvm/svm/svm.c          |   2 +
 arch/x86/kvm/svm/svm.h          |   4 +-
 6 files changed, 169 insertions(+), 130 deletions(-)

-- 
2.17.1

