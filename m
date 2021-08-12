Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0F03EAD57
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 00:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbhHLWrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 18:47:32 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:38880
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238412AbhHLWra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 18:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq3auKGplhYmyaIp3FkSrepx11DrtAdqZW29G132xAYN5aeaOdaHZ0aYMrpfWcVR/rdLvsg0D5Jbl541k8PoKR7YuYIQS/WU3zxV22R7xUGj/T2EsWWal9Vh/qf4h6XlF1fvSwn4m4KSPrqVoLKm1ptp95XmWhFyd+cV6Q6N9ydIiTvm3l1/3ODBLSZwN48+qZRlL7IP2sg2z/qKeLPgKhWY0BYaMsTzCMXw9V4WKKL04Jdr/xC72bZDoV2dMLDsv/fIZUKWMgPEeJE438nQoPIPFUsGO2vdpePUmlFQJEjgYA/QX2v2XXzDfKzbfpsenQ4YEI6jDEcFci2D/ji2dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT91SQCKo33BAXE2AFLA0tEtdJ5LjsgIFhy4otfZVpM=;
 b=nsaMAFxIVSOld05rEE7lt0CGY85tT1gOLx6sTRZ82vwG9TJkY/sY3wjwz9ow1z1Ahabj+zfzZnJqFwmXAjWqY4K2dpVc2MCcTAnBxkaSOFiMVM1+L8Ft2sCfJn0Z1wEfmlGZ2N01qKo64V1NYICq6l+IGOdKGmUU9/i2ZGyIwnlbykOlTmwYuYL5PFqKyZw3kO4V4S9kaCRGA7QlR2NKH//k1HKSkXusJA2sSND+r/N1Fla1fSghopWQt3zlUIjlBFG25fwTmVbkiRnLPs93wtUHAHrRSTZEaTNtPrFPjT6aO+fuaieJY8sNnnvp0T7LprpA/WALkOJ6b21nOguMrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT91SQCKo33BAXE2AFLA0tEtdJ5LjsgIFhy4otfZVpM=;
 b=P+52dTL2Exp1PZ8xCFGnKPv8+fTcqT6t+p5BKV+FBEdN/T9mGWi7Bg5OF/x1sppRoPMjySbS0NnXhz95b4f+RREpAUsS93fUlKaE0R98qjlNWvcCAd+2eoUSBhpqspad6nrpP84XI4V3L0q1x7g4+WvTIwYM/AgirMVVMf9SUo0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4555.namprd12.prod.outlook.com (2603:10b6:303:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 12 Aug
 2021 22:47:03 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.026; Thu, 12 Aug 2021
 22:47:03 +0000
Subject: [kvm-unit-tests PATCH v2 1/2] x86: access: Fix timeout failure by
 limiting number of tests
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Thu, 12 Aug 2021 17:47:01 -0500
Message-ID: <162880842111.21995.9414122849581561486.stgit@bmoger-ubuntu>
In-Reply-To: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
References: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Thu, 12 Aug 2021 22:47:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce030ca8-d55c-4c13-12e0-08d95de31a71
X-MS-TrafficTypeDiagnostic: MW3PR12MB4555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB45550AACA6ABC921651826CC95F99@MW3PR12MB4555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxWGygamGWXSDe8M5MSopluINWu/gU43eliCq1J8KnP4HjpRv83Z+u3UF596wLqHoQvxDw3Lr1iW9U6t5GbEqoyXRaWlY+bAS0qhDKytTb/yGYcam2YP+/2vS9lk7YoNOGvMRYrybQW99GdPqIX7mrBlx3nlXZPOLq8ccB0nbXrcwClY6Kh6fGnIGHJkYpu0a8HZTQ0awIz+UGinttALFmtrC1nV9BEhOsdH1suvJ+TFHJUVFkt+HeLPeqCYBObPP+nPKGOgQ7I4r3k1kT0aiKHKNafqxgW90Y8zJrutzFygGhoSCQi+37FI5Ayj/3hq3/KtZrqLhLtriZn7Ivhsd3VROjRpbQo5N+gIvySmabudjAONef5A4DQJPKr6JuhzhJ8T2kszGoLic9yYMcGWW5IHO72As446TTJCVnuSMthz+dwkhhbSIlxz5GPvIA6XXwi+wXr1ONIUScmEBMtCrKXV+ahBcD0x5sDo+wbDtswq7iEPgZLbxL3uJEeCyukvTPBiEFRqLNTGetkknNsoWFNr8Y4P8NkENuU3xJuqC6kn+sOrc2U+P6jBJzE3LB+RDUwHC2AzDFFo5ANHIix7Zd2/w3gf8oDp/2MUhVkznWL48S4V0pUQ1NXxJUXoCmChlQrqSEk8y2Oiekpiq/F7nIVj8pp607SrWpHiKUX04NoJjnKshXPUE3H7JhE0lAvzRv5UV6GftlcdGcbW6IpghQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(136003)(39860400002)(346002)(366004)(83380400001)(9686003)(8936002)(86362001)(103116003)(66476007)(6486002)(66556008)(38100700002)(956004)(38350700002)(33716001)(16576012)(66946007)(316002)(8676002)(26005)(6916009)(2906002)(5660300002)(478600001)(4326008)(52116002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGRacnlIVmhTeWxDM3JqdWp1M244dDRKUUUzYzduVmhSbWEwL2g3VWtwUHBB?=
 =?utf-8?B?MmR6WlNyQmozSXR1TCtnMzEyMDd1T2RDdE1JVzE4Q2xadDFoUE9iVnBxZnFo?=
 =?utf-8?B?cHNBeEtkcTg0OUFFdytZQXBJd0JJMjZxdEVGemZPY0xHSFd2TmVDbWgrbjZ5?=
 =?utf-8?B?MDhjK0ZjL0dmQmMvNnozOWk0c0pOVlZKcGNyamF2YXZINC96RUE2TlpHNGFX?=
 =?utf-8?B?SWo2aWdaMG0yNUdkeHJpM1A5cExjRjJYcC9ESUZ0WFFTUjUrN2FiWkYycjcx?=
 =?utf-8?B?algxMS9PKzFQWm9odzc5VE5lTkdWU1NzSittTnk1MmZJU29semZBZ0FMcVFk?=
 =?utf-8?B?WlZ6TDN3K1VHSEVCNngrTzYwSzRCb0l6WjJxWXR6cjRWVkZKSDRuc3hXaStw?=
 =?utf-8?B?OU1LTmxQeFJTUmhiRjI2ay9zdjBJSTk5Nk9oWFhScE0wc3hrQlR6dE0wOTVu?=
 =?utf-8?B?Q1h1blB0NGNveXN3R1B0UGlaSlpSNVFqNk5jeFVJWUpnRkpOdzNkWXViTG4z?=
 =?utf-8?B?SEdPRGVoeHBNWU9scFY4L1dOQ29xbXpDL0FlQ1pydWtNZU0zZ3hOb3IzMVdD?=
 =?utf-8?B?Z1lyRGNtU0E3djNuQU9UQ1JDMWIwaWVMeTUrak8rZWdZU1lTQ0hVSVpqSXRR?=
 =?utf-8?B?dXAxN0hSRExKMmRPZXMraTFUMU1Eb2szeGs3SnpwU1JRZTZHMkhQVk1hK25H?=
 =?utf-8?B?SkFEd2xxbzJsMGlBS0lzU3FhMVgyWm5Na0tOMXJTWHVPc0xDK0VJWjB6UnRT?=
 =?utf-8?B?azVackJBbjI4T25pMnV5RUZHMklUM1BTSGlxVmNJNTFjYXdqOHlsd3JCTGJT?=
 =?utf-8?B?V244VzY4dFhlOTNGaWtQM3hlT2hSTEVYK01zTjQyU1EvQ1UzUHNDUUdIa3NE?=
 =?utf-8?B?ckZlR1dBaTZIckZxZW5lallEOUxZT2RsV0l0NTFqK1M0Vzg1TUg3OHVkTjlz?=
 =?utf-8?B?WkVjT0I3dlhIcGdZTEF2dDY4bEp4Mld4RHAxREVaWTk5Q1lqOGVBT3FvUzli?=
 =?utf-8?B?Tzl6dnYxYk1MVVUzMEhNbFhpQ2JIQzFXNWY0ZHg4Ym5xMTdOMnN1R0tMTXJH?=
 =?utf-8?B?MWhmVHRSRkE4MXFLYi9DMmNsekFHU0hIOEtPdEdGSE1KNm12NUpJQXgvM0VV?=
 =?utf-8?B?c09hT25wWGpMOG1OMHA1K3BoSnBPTUNONEVWMUVZZmpZb0dOdGJqZHQ5UDc0?=
 =?utf-8?B?YlNtLyttVkpYcFg5V3pjOC9zb0JxSTVkOEhnMEswZ1NCVFhiNVQ4aVU2cE40?=
 =?utf-8?B?NEFJeWFEeVVONVRESUFhQXo2RUhveTc4SG1YTFlrZGZJZlBjTDVLdzBLZjJ5?=
 =?utf-8?B?YkdhcENGVGFITXVzRzI4Q1JyOVVOVmMrNkVpS1JTbDQ0UHJDaTh2MEJ1dFhN?=
 =?utf-8?B?WlB0V1RnZG5HRXFZeHdSaklPb2IrYy82TmtnSGxIemFuSHJjYi9HQkxnV3RY?=
 =?utf-8?B?Z2lmdTBTQXhod29BYkVGYThHM3RDZnNEM0tpUjcySVEydjJBMGU3ZFMzUGhW?=
 =?utf-8?B?bEwyallZSHZlZEpqUUZkTUJ0dkNyNFdEOURxRW81VnlrUjB4eTRSSGNuU2Fn?=
 =?utf-8?B?Wm1rd0Z5Nm1HMXlHaDBBYWt6b2Nsa0tXSCtxU2hxNWk3TkJlcmR3dEJJYWR2?=
 =?utf-8?B?QjhpSFZBS09HWUVndXd6emlqUnZwQTY2NU9jeDVxYjZjV2hQYVVLTTNNUUh2?=
 =?utf-8?B?aVpITWd6Qi9QMEowbVhLSStWdmN0em8xRHZsSHdwOFpSbVdncVA0TmE4bm0r?=
 =?utf-8?Q?STbcgAoqieTYjFQZivFGvX68N3mE/lhf6Bhzitg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce030ca8-d55c-4c13-12e0-08d95de31a71
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 22:47:03.3139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZ39sA6Lrf+IVdh3+PyQTPtW101HQOwHtIgefBfob18+qlRRroibTSawrNobcbm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <Babu.Moger@amd.com>

The test ./x86/access fails with a timeout. This is due to the number test
combination. The test cases increase exponentially as the features get
enabled. The new machine adds the feature AC_CPU_CR4_PKE. The default
timeout is 180 seconds. Seen this problem both on AMD and Intel machines.

Test fails with following messages.
#./tests/access
qemu-system-x86_64: terminating on signal 15 from pid 20050 (timeout)
FAIL access (timeout; duration=180)

This test can take about 7 minutes without timeout.
time ./tests/access
58982405 tests, 0 failures
PASS access

real    7m10.063s
user    7m9.063s
sys     0m0.309s

Fix the problem by adding a new check to limit to the number of tests. The
new a check limits the combinations with more than one reserved bits. With
this limit, the runtime goes down from 7 minutes to approximately 2 minutes.

Signed-off-by: Babu Moger <Babu.Moger@amd.com>
---
 x86/access.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 47807cc..c71f39d 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -315,11 +315,14 @@ static _Bool ac_test_legal(ac_test_t *at)
         return false;
 
     /*
-     * Shorten the test by avoiding testing too many reserved bit combinations
+     * Shorten the test by avoiding testing too many reserved bit combinations.
+     * Skip testing multiple reserved bits to shorten the test. Reserved bit
+     * page faults are terminal and multiple reserved bits do not affect the
+     * error code; the odds of a KVM bug are super low, and the odds of actually
+     * being able to detect a bug are even lower.
      */
-    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
-        return false;
-    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
+    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) +
+        F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
         return false;
 
     return true;

