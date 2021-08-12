Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8F03EAD58
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 00:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhHLWri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 18:47:38 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:9504
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238399AbhHLWrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 18:47:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESSSZXzegywExf1wb3WGX5eOh4B3rb+yi7BW5m3Au5fEbIYJfeUBiXx475nCqfkqWWrRpxZVx4jlQm6F676jOhI/+TVpCWx/K+p3vkh1t0LD5prR/gCCinxmie3s7UhCUazBX5WE5nftBBTs78IT4rJc/g09C948gRA8XIJD13qOJtLl0bDbzUczClHRBjOz76KcdCgFX2yPZpnauSM+hwpNNVL1syo1oNYqf4rcLyCkfmrfM8jYCqySJDc40L9eaKo5/2vH/4rHPojE8AiCu5Etlv1wxW3ex5apRdPR3vIaoTlBs0LQrVhYdTP4mEJALG/y63oXUvgzyvCDZ7tYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02R5cXxsEh1F3qCsJALrTO0tr6W4fOR9Ikyoy6NV9zU=;
 b=UNtpz+92DujR+U25rGvhgY/quHJVkfCpDKz2NG+4Ij1w+PIbO+pGkKaRbPnbLv5FyKCfPkXqMVrdUwRqb58oZswEeI3m+9LxWJetJHVX3CiGoMznw9chZ8p6WtEJalwj9bvWOAZ2cOiD03WGODyvNiDJPpgaK3IPpi+4ZGXj6KGXVfqVGL1UX1WuunMtSQ53IWjzYwIx+4Ad0nwi6tZ/+Nk9PAdB1uhgWCqjXWCC5/bcWLIIP6IlNBy7+Ij4U3v+A5UZv6vqDi1rguUei0dZQa9TmLmM6Q/tAeMGYZEXIP8akddV0WRMh7sxf6pE+TX0Z/q1FSoQz6vZB2QKwAh2jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02R5cXxsEh1F3qCsJALrTO0tr6W4fOR9Ikyoy6NV9zU=;
 b=RiCDfYxfti310kgzOQ9xUj/ADt/VqW/iyg6Ynw8RvsdqkYFMOrcXCB69JFEukloMZHYTQZCq4FcwJ6oN6XRVgCxK57d8eSWTEjQw1OX+rgHsdJKrhIfLFE4+30uRcKgfqWBhdm+8ANlZfDzs+QBLpl4BJmYCUYfqqOo1OVQO1RU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4555.namprd12.prod.outlook.com (2603:10b6:303:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 12 Aug
 2021 22:47:10 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.026; Thu, 12 Aug 2021
 22:47:10 +0000
Subject: [kvm-unit-tests PATCH v2 2/2] nSVM: Fix NPT reserved bits test hang
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Thu, 12 Aug 2021 17:47:08 -0500
Message-ID: <162880842856.21995.11223675477768032640.stgit@bmoger-ubuntu>
In-Reply-To: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
References: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0096.namprd12.prod.outlook.com
 (2603:10b6:802:21::31) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN1PR12CA0096.namprd12.prod.outlook.com (2603:10b6:802:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 22:47:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94e18909-6afd-4e5f-8e37-08d95de31ea7
X-MS-TrafficTypeDiagnostic: MW3PR12MB4555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4555DB3B984D7CCD76A8199595F99@MW3PR12MB4555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4me2tAh7D5+TdO65b/sMgXDmDO7xEoWp0VCkgznoC5JtQxxBIC4gNCiP2Wo+81isi2sGXOzOT+H+brGxC5kLEclr+frqOlU+h7RO5XzmEUmBza2HDh3rBjYSDY5cBwa/iROoI0N4dQHM5Ngwu2ipApdtW9Us0EL3NjPkuac7FmUe701riX2BUzWSIaG0bu955aEVJbUv0AG4JFBDF0/8vLmrImabu70++4jrI0mPvi8xU6SYfdMJiirgnCDyK+6675sSZW/U9TApNy+kTI0/cjPYVdq9aWcUpbAy85ecFnLs8rqZvcR8R9+UbSSIJLUTRaYlB+9lvR2fhNQn9hniTHniyHXjNzh/+cy9WckwjtY1IDRnO2KgtxP7KmIilRhBiDknNUpn/qssGSPJCDSs8MaGBkVP0hFhW+Km/XKLvH5mziiRLH157YERd6DlnOpSIoSO3tkRhB8L53sgIKSJkv3G0whyOivinD83cIAx+7LzRSzQvHLWATAJ62jLYYE3qxxuute9EMX1GurGEB6PACpZ+zRzU70T9j//6+kQHCwiEjueiM34J6qbVD3D/tZxSBSP6RbvZKOYUgrOoj9D5JlHSKQyYrWoEvsyia8XNLOnvMW9OIGYfUn/BYhqssaTfT2pLBaIj+tmbsW0J8viqXSaXdX4dbxaeJDVL7W4vcVg1iNOoHGqZEb9mshuHdXCC49BANO3Z9AChzWrcKph5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(136003)(39860400002)(346002)(366004)(83380400001)(9686003)(8936002)(86362001)(103116003)(66476007)(6486002)(66556008)(38100700002)(956004)(38350700002)(33716001)(16576012)(66946007)(316002)(8676002)(26005)(6916009)(2906002)(5660300002)(478600001)(4326008)(52116002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2hDY2tnbDNKc0JSZ3JhN3NxdHpQTEF2ZkQrREdacmpmbHlKUndHa3B3SC9z?=
 =?utf-8?B?dFdoVEtXKzAyaVhIbG1YemJJdVNuOFFmbTJ1RjNWSHJucDJXMmVKVDl3RklB?=
 =?utf-8?B?dzRUS1M4S0pyVjFmU1dRZXpsa2ZqY25nUmVaSnNJSlJNUXRwZjZBZXFhdXdW?=
 =?utf-8?B?L250TGpCVzFZMHhZT29yWjBFemFjUDRKaG9SeEdoVmo3QWp1WS9xdXpyaWpS?=
 =?utf-8?B?U2Q3OTd6V0c4MFpyV0tuMnp6UXBBeWtDOHN1UndpZ1p0OGFSRGNxeUVpZVFW?=
 =?utf-8?B?N3FRTWV6SFZRSWhjWkdzSERHU2FCT2pLOGJ5b2ZkV2tXQkpidGl1NmFROGFL?=
 =?utf-8?B?emM5WmdmbnNnZWczeDBSTFE5TFZiUzVyV0RNcWxlQU8yK2FtY25SWFc3N0Nt?=
 =?utf-8?B?eXFBdEVkYkNNRmxUQzdBWEsvREI0MmNFcjkxdWg3bzJ5SGVReFNhN2dLZjg4?=
 =?utf-8?B?T3pnYktLSWtWdDZyTTBxOFpMVWJBNkowblNCbUJxditVUHd2Q1dKYURRREs5?=
 =?utf-8?B?eVJXR1h2WnhkdmM1RDY3VTV0cktWSDJrUFhIZGkzZnlscnZmckk1SklvYkxM?=
 =?utf-8?B?Qi9lYjh4aWRnZUxlMmpnYms3ZUpSMXozOFkvS0xmdHVoVE94ZkJzUmZEbHhL?=
 =?utf-8?B?WjRHY1pNWS91alNURGFCVllvSm9QejFweHZKS0xBcEkyQkREUnZNQy9VYmVJ?=
 =?utf-8?B?TkJOMkNmalRaL29KclIzcE0vaTRpZGkwL1hwVkYwcGJJTGxLSE5ydHd1MWVz?=
 =?utf-8?B?UWxjMis5ZmU2MlNmS2xNMXJMTTRWcGcyWkNJMzJxYklPcGxBRDlTMHNKakh1?=
 =?utf-8?B?ZFhJQXQ3T3FFZDQxN215MWtFQ01KWWg4OTN1dEFpRURPREY2UkxCVExtY3Nj?=
 =?utf-8?B?Vm1PMFpKVm5RUDdOdlNWSFN0TllqdXhjTEFQZ3ZDenkzT3NnN2R3N0xZajMv?=
 =?utf-8?B?WmwzWTZMQmVoNkNucmJIQ25FaUFvS3JyUUY5SE9wT09tbUl2UnVUTU1GTko1?=
 =?utf-8?B?emZDWXdYd0tpY2xqQlU4L2lsSXh5WlgvOERpNlNuOGlPMWQ4VWVCQ1lTamgx?=
 =?utf-8?B?NXFzUTJBS3BiY2dSWDc3dUFVN01xRWVYWm9tZGIvdUdQWGx1eVhOTDhDL3dM?=
 =?utf-8?B?V0ZhWDNmMWMzTHgxdzFIbTdFZFN4NlNjRTl2L0VwaE5NUGp1UlgrK1FmZk1M?=
 =?utf-8?B?VjlTUzF1U1JmTGpLZTVadkw0WkpWRVRKa1dnNTRqMUZjZmZqZ0NGcDZ3eUhy?=
 =?utf-8?B?bnEyUEpCdVpkVmxYR1B6Y2ljeFozZ0JrSGF5bjlwK0hyMzVJU3RHMGxFVzJS?=
 =?utf-8?B?NmI4OE16SHJoVzZISzQzNGcrY05RLzVGYnZaekZvcGFPcVRGYW9JSlVmcVNG?=
 =?utf-8?B?b2JoTDhVQkFJWlB0bEZ5d21wcUx1V3o2VGs5TzZ6OWh1cXgvMzlzVVRFUTlX?=
 =?utf-8?B?dGNzcWlPMkFJeVhMbi9nTXRQbW1NTjZ2Wjd4bU0rNXYyOHlQcTUyQ1RzRnQ0?=
 =?utf-8?B?RUt1TWxWV3QxV0VOVzRlZ2Z3ZzBBRStrQjV1ZUxWNlV1ajArLzFLeWk3R3F3?=
 =?utf-8?B?NUZ2UEVvTkppcUJwbkY1M3V1SlQ1MHhxODhMYW5ZMlpvYnNMdFN1UVBWeVhn?=
 =?utf-8?B?cDVDY1g4RlU5WXJGMXZyc2J5cUxPRHZyQmkzcjFrc1BOSGl2OUl0N2l0Y0du?=
 =?utf-8?B?bC9SUENpcTFLb2lqdzN0dVpLVW42WS90MlBWSjRnYW1jZGE2bXZ3SWJhYXBJ?=
 =?utf-8?Q?fOjZ5L9RVY24grb0/H3PMZNNEvUaHl4OY7BYkJX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e18909-6afd-4e5f-8e37-08d95de31ea7
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 22:47:10.3808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Qov1jMlYQA9ItOKVvs+vTNs/p+ij2wG1wi06B8DarFhhLDvVzCYLNFcbjSVZhyx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <Babu.Moger@amd.com>

SVM reserved bits tests hangs in a infinite loop. The test uses the
instruction 'rdtsc' to generate the random reserved bits. It hangs
while generating the valid reserved bits.

The AMD64 Architecture Programmers Manual Volume 2: System
Programming manual says, When using the TSC to measure elapsed time,
programmers must be aware that for some implementations, the rate at
which the TSC is incremented varies based on the processor power
management state (Pstate). For other implementations, the TSC
increment rate is fixed and is not subject to power-management
related changes in processor frequency.

In AMD gen3 machine, the rdtsc value is a P state multiplier.
Here are the rdtsc value in 10 sucessive reads.
0 rdtsc = 0x1ec92919b9710
1 rdtsc = 0x1ec92919c01f0
2 rdtsc = 0x1ec92919c0f70
3 rdtsc = 0x1ec92919c18d0
4 rdtsc = 0x1ec92919c2060
5 rdtsc = 0x1ec92919c28d0
6 rdtsc = 0x1ec92919c30b0
7 rdtsc = 0x1ec92919c5660
8 rdtsc = 0x1ec92919c6150
9 rdtsc = 0x1ec92919c7c80

This test uses the lower nibble and right shifts to generate the
valid reserved bit. It loops forever because the lower nibble is always
zero.

Fixing the issue with replacing rdrand instruction if available or
skipping the test if we cannot generate the valid reserved bits.

Signed-off-by: Babu Moger <Babu.Moger@amd.com>
---
 lib/x86/processor.h |   11 +++++++++++
 x86/svm_tests.c     |   28 ++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index a08ea1f..1e10cc3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -531,6 +531,17 @@ static inline void sti(void)
     asm volatile ("sti");
 }
 
+static inline unsigned long long rdrand(void)
+{
+	long long r;
+
+	asm volatile("rdrand %0\n\t"
+		     "jc 1f\n\t"
+		     "mov $0, %0\n\t"
+		     "1:\n\t" : "=r" (r));
+	return r;
+}
+
 static inline unsigned long long rdtsc(void)
 {
 	long long r;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 79ed48e..b998b24 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2671,6 +2671,14 @@ static void _svm_npt_rsvd_bits_test(u64 *pxe, u64 pxe_rsvd_bits,  u64 efer,
 	u64 rsvd_bits;
 	int i;
 
+	/*
+	 * RDTSC or RDRAND can sometimes fail to generate a valid reserved bits
+	 */
+	if (!pxe_rsvd_bits) {
+		report_skip("svm_npt_rsvd_bits_test: Reserved bits are not valid");
+		return;
+	}
+
 	/*
 	 * Test all combinations of guest/host EFER.NX and CR4.SMEP.  If host
 	 * EFER.NX=0, use NX as the reserved bit, otherwise use the passed in
@@ -2704,11 +2712,23 @@ static void _svm_npt_rsvd_bits_test(u64 *pxe, u64 pxe_rsvd_bits,  u64 efer,
 
 static u64 get_random_bits(u64 hi, u64 low)
 {
-	u64 rsvd_bits;
+	unsigned retry = 5;
+	u64 rsvd_bits = 0;
+
+	if (this_cpu_has(X86_FEATURE_RDRAND)) {
+		do {
+			rsvd_bits = (rdrand() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
 
-	do {
-		rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
-	} while (!rsvd_bits);
+	if (!rsvd_bits) {
+		retry = 5;
+		do {
+			rsvd_bits = (rdtsc() << low) & GENMASK_ULL(hi, low);
+			retry--;
+		} while (!rsvd_bits && retry);
+	}
 
 	return rsvd_bits;
 }

