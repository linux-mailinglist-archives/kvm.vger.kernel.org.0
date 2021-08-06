Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7723E2E25
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhHFQI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:08:58 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:53164
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhHFQI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 12:08:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKKIqmNVossn7/1oaZBztsLu62kf4+6cIAPpeIrD4Js2noUlr3YNGN/za2moNZWy05Hb7eaxgaJ/EmeMtxE8rlyD195/kDHEnZrkI6Al+GW8v1Q2+Wt7WTYfNWpl60p+Xpfy6/BaavWWKM2NYaw4JZV1GatHfF+KV2BQ0SwA7sZx3qScQ+GnwFa1jMGPs0izLN41WmLjbn/n+QtjeO4hthGdoFuYhXMuRAI63/iSknKmRqWPOAj87ypkfpk16E5KEKJ9TNu4yojW1nwSUcoYFRNU7ycJSkmTWEDNus0zqJPON2bp9Z1HmOJhvwfJKMM58Z5J08fUnXYjr7wSU5vKNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPH0cbaiq7gaA+pDjcRsHUdgKgYc00uG4UUsUPkmATI=;
 b=bL7uRy7+7K/zin/3mk2qcIMwoTVOtjVbmQVWo4r12mBQN6g0OkoEUly59giFSsKanJFU4vxVHnBN3tn39a/Oo9bDAluGuds+w7OANHCiUeLRn20byuYcPW90yi5TR/Kzm/83fAx/EHMCL1qrfQaBLs0eAyzfny6aEX22kP750oW8S0yp4DsAjl9JfHh+5UXZB95B9oVIGMMbcT5lNDfGPkk05h10FjV9pgOh+DkWX79Iye7DTW/6J2JP46AJ+9ipx3iyti6XWqezfgq/r8YXTs+VHj4vjqm8cRCxVXZiDaPsJaLPRfHnNi+hQ8mu6n+JjY/MiRA818tx0ruvnLWSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPH0cbaiq7gaA+pDjcRsHUdgKgYc00uG4UUsUPkmATI=;
 b=5uWiB5xGUSQJUWQzKHK1acT1uEgQv7X8i9BSdnqP1hWV+MPCxtaogmEoUqCOp3VKh9c7gWkPhtEFyh0wK3xhswJmazptO8LPugzWiQKLcwsa+B3T+27QaEoSp5avrrSdlFTm6RTP+BUXpwtykq2LC4cwGn35DrSZAOHDJKIwPOE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR1201MB0206.namprd12.prod.outlook.com (2603:10b6:301:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Fri, 6 Aug
 2021 16:08:39 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7%7]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 16:08:39 +0000
Subject: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
From:   Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Fri, 06 Aug 2021 11:08:37 -0500
Message-ID: <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
In-Reply-To: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0170.namprd04.prod.outlook.com
 (2603:10b6:806:125::25) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7PR04CA0170.namprd04.prod.outlook.com (2603:10b6:806:125::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 16:08:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efcbb110-9b21-44cc-0934-08d958f47428
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB020608DFDA50A1751A24FACA95F39@MWHPR1201MB0206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZk4PsXHC4x9WXMbBlOoO74njAoTeS8xTXGFzgCE8F7cTPVAY1gAq70UWkROr95f0JPBGSG4WmztW90m+3Co3MjkM4GGCBy+sxq8zEWpl6NJP2FjCUl50lSazo6ueC/LyCJYVbTMrrojtYToQ15CZjlKiEkb5Lb4hwJ5gnbbltgurARP8R2Dztea03OfSPZyWs2nwJl+UtE4OX68h/G9SozLkVTD2mkCBgXdvA+3XYNWcODOUkfNHnPZNEtULyaHrEWM1wrCk2AWmT71RpRlp2F9yYn9Ah0HcsEOvemFSR16tKYBZQCYrQx30DbPX7BbpnJyDMGA5ez6gvXmC/I0ZF2+V4x10lwmsYWGclCQWTV01kvNcsUamltTzjnnfAJoaGTO1KkIymQdZhsr726/hKnrR+qmKZf5E6aqgWZbAyhARZ7Bnh1oxUVPA6r9QxBpa8N3DSfKOFkKeFErUuJxRzLieisj2EAY/2h3douY52eWTjIAJ8Akpm4bc8xQ2oknVJONTIcv14CqZMRl8GsSIj8+l1bFEq4RgAPJaUGxGCzUF7rPKhQbTMNpLW2Ys2Wpg9f/zmS5wii0tCGFMC1s+m7C4AsmfST47Y3ULl+LTvMouoY1OhDEjT5Wd5Y2wCvkn6wIdu1F92+Iymwk7nG3JrAN5Seg/FwrU0ixRScqft9CmF5PQg06wI8oY7q1g5iJJmQ7vn01QGteqGhdRGbuxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(396003)(39860400002)(346002)(136003)(26005)(8676002)(316002)(103116003)(16576012)(8936002)(2906002)(186003)(4326008)(44832011)(109986005)(38100700002)(38350700002)(52116002)(478600001)(5660300002)(86362001)(33716001)(83380400001)(66476007)(66556008)(956004)(6486002)(9686003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFduZWdTcUYwMCtjdTc4NFJGUG1DQ2M4TE1BOTFxbnRvMHNPdkJDenhlL1pH?=
 =?utf-8?B?MjFZZ1Z6YWhjSGJaMW8wVGRkUWtwam56R0NhM080WjhKekNZNjc1Q0FZRzNQ?=
 =?utf-8?B?R0tzZmo5ZFl1YjhaS3NDdERJZHovU1ZOa09YVFBJcWQ2bE1Dc2w1a0NwWGsy?=
 =?utf-8?B?U1VpVXZHb3RJeENZaG5keGV6djFCREZhWGlHMFUzT0QycWxRWkZ0ZU43eXNz?=
 =?utf-8?B?c3orYUNSSzBrZ2RwM2lBSzcrN3hxMUFZVWhxRjBlbTExN2VnVmwxVWN5WEpO?=
 =?utf-8?B?VEVMSnJ3V3VtcXRsc0YrZ2JnSUQ1RTJmKytMWU1ob1ZYNmJQYmFzaUZ2L1hO?=
 =?utf-8?B?QVVhb0xCQ2poOWI3RmMzeGQwOVVnRXRRSnVkTHhtRU5xVzhiWmJSMmRaSnFa?=
 =?utf-8?B?My9Qdi9maXB1T1FRc2krYW5DcGJiREVKU1ExejZPNkhzc3E0anBrd29uRFJG?=
 =?utf-8?B?RkdHai9BLy9RQkRwZzZSTW0zc2dZV0ZjOUg3QWJ6T0twMEEwc1BSODVUc0c0?=
 =?utf-8?B?T3dFYkxub2lUc1BvSUFtaFdUdUw5Wm1CSStOTGM0UEdIaXE1a2VweUtwTHZW?=
 =?utf-8?B?dE1UU3lkUndBc2EvVU0yRDlreHdabUtNZDBQK3JZUGhqRVVia2NvSmNVSVY3?=
 =?utf-8?B?aHRYSnpqTnhvYmFia3RjbDNxVURiaEhDMGp4M3ZqeTRtMGsydUpoQjZjc0Ft?=
 =?utf-8?B?ZW5BVWI4cmZQQjdWQ21jSENoVWVBc0lEMEMxaGNvVFIyZW4wMVVLRHJ0UTdZ?=
 =?utf-8?B?R2xBZzh2RUNySTVTWmpTTWZCNHVYaHhaeFVQZWV5Zms5MjU1eFNjYUtYTXB1?=
 =?utf-8?B?c3U0QzZhdlVoWUtFK1dRMUM0RHhFQkZoZmVyaHRhbEh5R0UvWWFYN1NYV1ZG?=
 =?utf-8?B?bUphMXFVWkFKNnR1UGlXMjlIT3JnclNuSDVicXJhV2h5RFdESUhNdkR2UG5y?=
 =?utf-8?B?L2lQbVlLeXlYTGtDYjlIVTVPaDNXalhyMHhIWUdteUNORHBPV0o2UnV0UUl4?=
 =?utf-8?B?bjJFK2Q4R20rU0hnSDJycExDWTBBZUpKc1ZHRjZhTEk4NVg5N0F4LzRBcmYw?=
 =?utf-8?B?b2NRaTVyVW0xK2hWWUNOSXRRNkdnOVJSQ1k1QXRIZVFWMWRGa3R6WXZUejhD?=
 =?utf-8?B?dmVUVlV3d3p5NlI0RHBCTmhadStRYzVsSm5yVDRJVFRVTHlJWGhrU3NsRmNM?=
 =?utf-8?B?VnFQU2p6ek8wM0lmZkcybzdzckhFSGdTN2JoOEFreUZlL2s3QjVDVUZVK3pO?=
 =?utf-8?B?b0pZbFhURllMeHYxVEx6S1BLK05WVE0vMk9hYkRDaFFQNm4xUXBXVXM5OFVn?=
 =?utf-8?B?a2lrMGxUdXRVRE5nTXAzRGEraVlhVm9Ha3ZWZXRoNmhST0VZdWs5SjBjQ1JQ?=
 =?utf-8?B?NmpEMnFjTzZ0WGJWL2lVckIxMjlCSmVtWmdQL1NpbW5CQkNPWUdQRVE2UUc1?=
 =?utf-8?B?NldXcWExbzg4KzhzMkVXbEtSSXRJR1hIem9WejMycndCRnRKSDFHUGhLcnFw?=
 =?utf-8?B?R0tlMXp4OHY5SDFIU2dvOXkzbVg0aTh0VFd4UUZtcWVkTjgvVTJpTkUxalUr?=
 =?utf-8?B?Lzg5amVtRUpHZnVTN1ZMd2Mvem81VFdkTlhOYVJkTkxnOU1ERGNJOW1oNkZM?=
 =?utf-8?B?R3JrTDNQYTRzQlFQNVM4elFkcG1NNnAyNWlwcHMzOE4xQUlNa3EyQm0wQUc4?=
 =?utf-8?B?aDY5alkzcEtWdUVvd3JiOXpvc0UrLzFGRzFvVWJpZ2hQUU5vNzluY0ZCcnpT?=
 =?utf-8?Q?FYHRHVd0Tp/vTIJ5KVDypmP4F7vsc8qrCJdCHIR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcbb110-9b21-44cc-0934-08d958f47428
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 16:08:39.5045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cvbVC2Wsv2rsijY93Swh5RCZ2oK2ZT1M4XwTMW7Ko0XO0FkIo+5i+Ij3mm1xt3cD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0206
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <Babu.Moger@amd.com>

The test ./x86/access fails with a timeout. This is due to the number test
combination. The test cases increase exponentially as the features get
enabled. The new machine adds the feature AC_CPU_CR4_PKE. The default
timeout is 180 seconds. Seen this problem both on AMD and Intel machines.

#./tests/access
qemu-system-x86_64: terminating on signal 15 from pid 20050 (timeout)
FAIL access (timeout; duration=180)

This test can take about 7 minutes without timeout.
time ./tests/access
58982405 tests, 0 failures
PASS access

real	7m10.063s
user	7m9.063s
sys	0m0.309s

Fix the problem by adding few more limit checks.

Signed-off-by: Babu Moger <Babu.Moger@amd.com>
---
 x86/access.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 47807cc..e371dd5 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -317,9 +317,9 @@ static _Bool ac_test_legal(ac_test_t *at)
     /*
      * Shorten the test by avoiding testing too many reserved bit combinations
      */
-    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
+    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) + F(AC_CPU_CR4_PKE)) > 1)
         return false;
-    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
+    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36) + F(AC_CPU_CR4_PKE)) > 1)
         return false;
 
     return true;

