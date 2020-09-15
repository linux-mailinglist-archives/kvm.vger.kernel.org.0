Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44E926AFC3
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgIOVbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 17:31:51 -0400
Received: from mail-bn8nam08on2083.outbound.protection.outlook.com ([40.107.100.83]:29249
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728080AbgIOVav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 17:30:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4wz7gsGCwHH3N6SYOFksxI722vG6OONX8HDR3lWkp14pi6B8MZcWuc9oUWRDH3hoZ9efPawV4F1wIX1KkMG301DIr6lhmPODQGtByLyZvQtZKRmRioex2vK0vJFpIsAUTWb9lGx3ozRIvaEFpTyb2sfcXFnQB6cDzKb/taxlHnnrtXyvQyeqjsqVZNwJ2LkkCcKepgBncSxAiTZ/TfMhRnPjXbnXP3K7vfeODLGuj/k2KUxxgH8oDTYEd665WQz8yqcXC0NAYcoaRRlI2hj1P5FUEmAnkWyg+Uo1AZtERvKkdxRBEWh69TA6Kp75YhO39bHtq+H+BDxGD1Splt8iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwUL4IAYHpyXvJJHQEV+j4J5TbqEfkYMfCqoG7chKXE=;
 b=PTx4WhBNnGM89Z+HJq9pQcMgrXy4mYPnLp9GGRDTVJYQyDI9ec7AWOWG62wGpkDnd3lIgqRVMohXL4yKOtiGfopQFjvV58lkzQSgMjnukPTz464VKSdJbNsFn+4vI2+WYHSEd+0k4UaX3g7+VJkxvCyoc0zhHnCKGIovHRkOpdpP7BMuvaxDxd1Atezs9c0sVgpDpJp6gsY3M1yS6cnxRy6sz6EYTnWq23uE+YytV9xNFoQ6ujXZllnD9Vcm4yS2iSZEAsYQWV0XEwhMGVrQuCyYZWNEJGLlBi7ZEOlT0RBVTigSb/hKtLRw69lzVb8WpIq5C4FyWSJJQ9HkooqyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwUL4IAYHpyXvJJHQEV+j4J5TbqEfkYMfCqoG7chKXE=;
 b=Uk6gszkL/eDiX8tXdtJD1rlwe2+9yj7h09zBidK0zPQbu2UOvZ4CjOd42TfO1s7llva1IQtaT0Yy62Qdm9MIzZn9cWuf6AaDPMZ8ioEra5AL+Wrsc7CuuKAGfJBo13oBQbP2Q50sXWT2a+9ncrrSSesjMr4oDOnZM39RtSvE/ow=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 21:30:16 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 21:30:16 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 2/5] sev/i386: Require in-kernel irqchip support for SEV-ES guests
Date:   Tue, 15 Sep 2020 16:29:41 -0500
Message-Id: <59ca62e1527a854fc8c411fb01bf0f55ee13aeb7.1600205384.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600205384.git.thomas.lendacky@amd.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0053.namprd21.prod.outlook.com
 (2603:10b6:3:129::15) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0053.namprd21.prod.outlook.com (2603:10b6:3:129::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.1 via Frontend Transport; Tue, 15 Sep 2020 21:30:15 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8434a1a4-dec5-43ea-d2bf-08d859be89be
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB16071FCE9B025799E42F3805EC200@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tgiEkMy1imv5MAlhFkAr+Dsdtwys5kLUDHz8xALlQK4kP3Uq/0zhZfGVWntmiKw2nu3U4vuf6jN8ZwZsifkhAe+ytuFUNPKd8xSAuITC6G9iVg9GNpeUVq/AsE20UX9jGMEOxWC6pa1qR5/YALgQL90VJLdtm/WeT+2S6tRGPGRqf8rHsQ5DiKahtkkCytHJWWTB6rYH60k5l7Q8FFVwXF/P22iqWuNXhcCt42XX/7DB8EIsYcD7Rmhow/s4F5MZYuFyAfot6jcpqG4l8wLdT+dpKp0rdQYkSXeUPO+TQPjeY6UarsvXnDEsvs78txT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(5660300002)(956004)(478600001)(6666004)(86362001)(52116002)(2616005)(2906002)(7696005)(36756003)(66476007)(8936002)(66556008)(66946007)(4744005)(316002)(54906003)(7416002)(26005)(6486002)(4326008)(8676002)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FGZPTAE35glA00aZnnUUzL6GK6EP11xfDDzr6f/XFCsj8vDhBm6ghCxIFoaoU2VdvLe1uCBsnT5upU5BNFC1/uZFzE1t1khr/Juw5p0uTIDvr8OUV1C74mOkyjnBUUsfUwuaotKqe0GZHWSRiEMPtRMZBE1jikXepWOBDT1EsgNtTdy+wZQcYPZ4Am3fBgwgJbw4eJ5jfEUSmdXDSeabcyh3wz9ur/zVH902yflj7JXErijo7uU93g2n9ycoU0MImIW7NhlgkWAinIxtUaw3Bx9FRtDUqtIB1YF49OEEVqQVpse0dq9NjQ4o2hB/7yNkajSqrDgCPr6JHz03ge8cKOZYQV2Zscj+0SstldN2xAG9xU/1GsnzDx99LvpePHdqTijgQKcZ6EqxlsMMyi30IjaZMKYbN55ay24Kvde+GbtNVh7Ix+cCPqPsZEevqzIz6i3VAdpCsZqYRiXlGKyTVuUhRaQWY/N9RNGF/z/ylrplPIaD5/+m3L6McsX6xa0THFkolKvsIJqTxMoed79xuTW8WDqToVjktd76NrDF+PxJn4hgr1rZt2wsRB+pvZlfV3STe1w2P0f1de/w5PErJ+vpfptN5bXOcc77r8wct5wjUXfK1MTlx+qFusbtuO6mDDVNw72dgSgVyr2myfWbxA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8434a1a4-dec5-43ea-d2bf-08d859be89be
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:30:16.4816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQsfTw+AAXbg2cFx+5hJ/M8WbNVJyKfTB8MOUXVCb14SfhNE55IdzZ4h5z9IZLnx2wPQljr8DneArV5WV+o19A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for AP booting, require the use of in-kernel irqchip support. This
lessens the Qemu support burden required to boot APs.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6c9cd0854b..5055b1fe00 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -776,6 +776,12 @@ sev_guest_init(const char *id)
     sev->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-ES guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
         if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
             error_report("%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
-- 
2.28.0

