Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021403ED744
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhHPNaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:30:39 -0400
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:7937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241405AbhHPN1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:27:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSDnXX2tVVVIY4PoLLdHwK8BH/HR/YDsmlLX1sBJEJZF9376HS+IAVByVhaDWbtPv/erlRli6BUbE/zYCG487Fyx8kcnJ0jHCOnhVunkHlL19dWbicX+m0QLSSs4e8Sk3AEGwlYqt9FJ1O2TKHOaWVsGCh7Q9DjjVKYU6mhGST8f1yJ46zDJwX1s+/ZphNTXRnZnq1Ba/Yi3E779zsajzFfBnh5ywkeZZbjjVo/ugbz2U+MhPst0Mu1Te1X94hU65QQm3Q8AGbEQid6N0d9wiDaSd70Yhc0ZshgxglAFaMdYi3O2NUtvHK/fhOyJcTFjPVRT7yPr8HNgALnlR0FGsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VYm0aSpOM2l7u+TrZayoes453FcNcd0ansBvjhb9C4=;
 b=e42TKmOm/whtYyF0jN3GzptJg1ZPwUl2uWNjS5L1YMIFnfNshgpalzVObaf68ne9JQMBrc59hESrPWHpgOLaehZFaQQqxbd0eUK+SQOKI0Sb9WfljW7qQlpM+Op6h4XCP2PT6dWUlbNRnus8H4unBpOp523qYexMeZ2hubcF6SMHc8K66De+3bLS1FqDFzBP9IfrABmXdcglateySmL0o+FdUatjDsYIKkFQjKBPxZ79nmFHgxDXI6hKSQP/5DK4u9Gba2sVy96z3sCjy1Vdkxh+a3KMlpLfWeNrHD7Lg+peY85JI/fbF6vv0bYtpLmy+4aX2yzuZQSLYqvGEvIyUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VYm0aSpOM2l7u+TrZayoes453FcNcd0ansBvjhb9C4=;
 b=FPR2P1bVk9kTZ8JFMJc1Yk/WCj3KE9wZJbC1bPN7cZc1WWMK2BQ3ioPOSef4vpeWuAXX+MzaOzAN6Xa3YCStvvroUVuJgVr1mVOXFupes0j5VHx4V4Q4BZm6W3TpvmCDlyoqkh+HHM5GNquHFXl6Z/s8WntbsTQB6hfAqeffZXU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Mon, 16 Aug
 2021 13:27:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:27:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 02/13] hw/boards: Add mirror_vcpu flag to CPUArchId
Date:   Mon, 16 Aug 2021 13:27:03 +0000
Message-Id: <687f95793866eb1724c501fc67069b7c2422edb2.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0053.namprd05.prod.outlook.com
 (2603:10b6:803:41::30) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0053.namprd05.prod.outlook.com (2603:10b6:803:41::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 13:27:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f76e3bf1-aec3-4252-081c-08d960b98f7d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB276705C91E0F82827EF49CF38EFD9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ej84nE+AJ9ci15aQZr4X2+PHfZN5Cq1ojm0Fxy1rrGj5yKOSZGAl0ty1ibXkQzNjRTtCQ70PA1j4TFve+IEwlDUGhG/gfxbpYdzdXOpPj+/bzJbXz0MJZcAo54v4hdhaH6zhCcnl2BYEwy6Yinlrv/3hnUH0rH4l3vo+In0xZ4Fhxv8Rq51LtL1UifdI+LHaVAJpZXn4db/bTaENh5cVo2cn49ByK/lwUVtd36JlER6Im+PkK4xX9Fia/6PVBHdl/iLIN2vOZxL20FL+WrNiK84XXlQzdiPHoJnu0U2ZxKLN2qSgSoEP7aNR8kzmS5IYjzVZ+uR+YnAUk87aNd0JbpEookNoG28fElprQiDhvPFUSEan1QhjsxZVlD+81gpqA5IV1/SV8Juv8adtCMPVD8XJLV2sd6T1Kla2bSowUYn9cVAS1LeufVvMq4zvs4OtPJMU/+fYUd+TaJOs8+j/t1youhKEC9JhXnH+tJkuaCk0UYU0JfZBj6cLcC++Ma2Hat8SjHX/HXbvyug5I4NA7gJQWOJufRkA3nF5ZAZZ4YqLgMJbcGvQwfSgVNJxRpaCOMZXv8xBKyj0kzJ1MCznu9h0+/fXa/Mk2Xjewk6IDQNVm/+bCtlow2N8VTaYrVRRaZva9Fo0AQTxky7jxgEoZj5dfA0ypiJwr2kdTr1S77kbf8Smh/h4zjxvnzkLQq2GScym91WoI0tj+XeI8ZEP1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(478600001)(2616005)(26005)(956004)(186003)(4326008)(7696005)(52116002)(36756003)(316002)(66946007)(7416002)(66556008)(66476007)(2906002)(5660300002)(38350700002)(4744005)(38100700002)(6666004)(8676002)(6916009)(86362001)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?safRTICyTr2nn7oU3+uoToPq35tYbIEmvKYOyRJlXvdZbiJ3dGmvqB79H+lw?=
 =?us-ascii?Q?5hV104kf0aLzwmWkIA9kQBiBxQLr1hR2L3NHdpupiosx4W5HP+ibS+CRXtr/?=
 =?us-ascii?Q?VgvMPNQHhazwbY8sr2xgL8g5YfnSBY/Qh4E9qHnnrxEe3AE5mA8gSy4r4Tw+?=
 =?us-ascii?Q?7VHgmyfFq4dtIirPnvS4l9cT+Ibm5sKJS3AAy4LI9lZVlKYAWqclOifmx3JG?=
 =?us-ascii?Q?HSGODX3uHrGVGW9M60KkzALCN7qv6jNT2ompE0aDyQiY5UUj4Hqe8LbLAu8f?=
 =?us-ascii?Q?emPFKLjEiowcarnem7tTOUdHadbYrACnUjfo3B1EVtl5ya4+Km0ca2kr3U/J?=
 =?us-ascii?Q?odVI9fxG3m0wj9XvMbSHcHyM1+k5Od91WENZPsUYVDimfJJg4cE2fbjjNZoo?=
 =?us-ascii?Q?wJKUXnNW2prOZy42PvMJixFGkgVRFBsC5Pjv1homZkjhKo3G1sYJb1ng7pY8?=
 =?us-ascii?Q?mYrlKxESoeF6htBT7SkTH9h1sVRXnQLdLEEHRjrgLauxJHGYyqkNG4fuA4hH?=
 =?us-ascii?Q?4+IEdDedky2fld0KX+Qo/OH3X6la/fXq8BH/2zzuMEyyg13hZUlZCIn1ZnWm?=
 =?us-ascii?Q?i0KHz2Io4VLGcTqEKczzo7gk89HZC8//qnKM7WApCJYGHJHtQcyvD1pp11s4?=
 =?us-ascii?Q?9H1l43WCwjAgJWinx3poP4CrtOqykVweJQtkAiqTTJDurfsUwcvmnKkU9J5q?=
 =?us-ascii?Q?TPiXPneFd+goEKOWpOE5q4FYhdxhqYEN9NnbcEawIs/6QR3yFppndgjtkLCd?=
 =?us-ascii?Q?+nVZeinaPzOAHe78psUa5r0aizUpC0ek4a/eRqZgO57cBJXeye2hLSKuIDTM?=
 =?us-ascii?Q?6LifSILTPBroLdTbeHP1r086GqIKBhqRIrDuOV7LNduuQUAqO97fPWBkoaW7?=
 =?us-ascii?Q?9SuQ+2Ra34yc1kuEuSl7ej7culL/wXc5NZKTgR2LIM/wLawM8Rle++aa6sqq?=
 =?us-ascii?Q?IEc2lglhx9hhGC/2Y6RtO7aMkLmMzavDH99A87k2wBGxBSosKYSqkUzZQVFh?=
 =?us-ascii?Q?kq+Sk7dJX52spAVWo/4WgDadRAKdus+JkEhXC8uKYPserF2DDrTYwM6XKnVT?=
 =?us-ascii?Q?W3QsaRDqMTB32FN6CJdfYqHgaM8rfJZuhUUnf8eiappWCe9uLtI4yGApFL5Q?=
 =?us-ascii?Q?T1WfFItLpmJ/BaUy4kC/zLQ9OyXq2h7OsLBuxWOBRgHk2whfOduUHIstqand?=
 =?us-ascii?Q?mkrPw6aMM93L/xWSDqx1V3OF5fmdnJAw0tgxJOBXBrw7ZTlEUyW+RNEncx/x?=
 =?us-ascii?Q?p4kXojFTtJiNk6vfU1Ohnj7INvsI+EVyEaxn0HWHNcUhJph2/jU0SwLEORdr?=
 =?us-ascii?Q?DNhlYLWkpDhWYVZgk2HEvHJw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76e3bf1-aec3-4252-081c-08d960b98f7d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:27:14.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voHGeVxY1h6O059gmeZR4ZQ8XDVVi1rDDuM3mFU2YId3TchhuCarJ0/ZGKgZwEMtxgjWrj64XTFDVKFqievu1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.vnet.ibm.com>

The mirror_vcpu flag indicates whether a vcpu is a mirror.

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/hw/boards.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index b0e599096a..f7f29a466c 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -89,6 +89,7 @@ MemoryRegion *machine_consume_memdev(MachineState *machine,
  * @type - QOM class name of possible @cpu object
  * @props - CPU object properties, initialized by board
  * #vcpus_count - number of threads provided by @cpu object
+ * @mirror_vcpu - is this a mirror VCPU
  */
 typedef struct CPUArchId {
     uint64_t arch_id;
@@ -96,6 +97,7 @@ typedef struct CPUArchId {
     CpuInstanceProperties props;
     Object *cpu;
     const char *type;
+    bool mirror_vcpu;
 } CPUArchId;
 
 /**
-- 
2.17.1

