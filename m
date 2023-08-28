Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF778A79C
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjH1IYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 04:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjH1IXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 04:23:54 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2080.outbound.protection.outlook.com [40.92.18.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DAECF8
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 01:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQ3MsGH7dxyFXvAnHFy25SUBlMfYjaFxcssH7uy/OoHtSY41poPLK9rVZlJh+BaBoBLotb8qVuxrYfvuN7kRbFsCIwZbXy1vNY2zRT2KH7dgW4EJoN1itL2EWf0/9+kZOcCTZEPUCjHcBCV+sBNwicem2W47DZQT+7nKuUf8iWw9u0nygP51RVG+hcvaSbuzL+cPFsUqUtIqV++bHDfd6EjISnaU4iog2DklRqaMUe/tVXgWFm//HoRn4PI2sQILyKJJv/rjBycfFW8un54MEkQSluY6T0L5OiYmSyXlh1w7PlG5TF8YfjHnqNMjypxSusio2wP9eZKH9LEYBE4o7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHLbtrHS3JmLLeRIJcIqJKU02U/YbbCgPid0CBqYSW0=;
 b=Z6zZIqlIFv8XCFV4sT3Ko/QbjRpJQVl6xVRtQV8WrqZeUngIL+F6+daKUHrR6fwhKAdLJ5MDl62ffo+/e1yeTvU2oonEiAx/2i39q/8o5/LUU+NkkbgtXrBFxclh+qL4vJU4NF03xJKN5RcfEwsAZimXIuEHIII3KKXXpWDkmPvgYKjvjhWePxTJzZQMKKd8pxeFmQw5ayM6WVJOy2/71MTg+BUBuItR6nBFFascz0uVZXFT4ZJ+hxf9sqR/tTxSxtjZ1uqc2ZO6/tkGf1QElRuJlbe+DcvZA46EVDz1Vde3Ez6vTQfAPOBuC5F9gAEae/JpUlTgiI2HHc+nGxtyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHLbtrHS3JmLLeRIJcIqJKU02U/YbbCgPid0CBqYSW0=;
 b=cIx4MTYXUZ14EZB85Q8Fi306SJSyE6AfqSR5HinpizsJ9wR86SDRvQgwlfprfNRVxXEwlnLKe+T+4i7FcII24tIz/CXnScAJfGpaXjSS1/YbDnzUqir4+GSCyJQjkX/HgbwnQtSY/65mQ4Wg7jdPBSXWabf7Vbq2kbtB4tSoArk8D7D7Pb5QQj4PbkPFwmNL6PeNt1pXokn7/fSKNznvE1Vl51dC3qtJmRjdJtaCc1mqWhnFPjzAN+RYAEfMh0U5/QhLtTf3X/7MEbEXon98MXrw4JgY+PhVb15TAv/s5Zp7tvKZmum9T3G0tfnlGUDh2AYlo1oF3bpKasY25kePUg==
Received: from SA1PR11MB6760.namprd11.prod.outlook.com (2603:10b6:806:25f::14)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Mon, 28 Aug
 2023 08:22:27 +0000
Received: from SA1PR11MB6760.namprd11.prod.outlook.com
 ([fe80::df85:2db:d56b:38bf]) by SA1PR11MB6760.namprd11.prod.outlook.com
 ([fe80::df85:2db:d56b:38bf%5]) with mapi id 15.20.6699.034; Mon, 28 Aug 2023
 08:22:27 +0000
From:   alloc.young@outlook.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        alloc <alloc.young@outlook.com>
Subject: [PATCH] accel/kvm: Fix dirty reaper thread crash
Date:   Mon, 28 Aug 2023 16:22:04 +0800
Message-ID: <SA1PR11MB67603CD7B742F50678EDDDF1F5E0A@SA1PR11MB6760.namprd11.prod.outlook.com>
X-Mailer: git-send-email 2.39.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [9+DJXloxmERZguKQAUJsVjU3/588wANMEatKQszgLkA=]
X-ClientProxiedBy: SG2PR03CA0091.apcprd03.prod.outlook.com
 (2603:1096:4:7c::19) To SA1PR11MB6760.namprd11.prod.outlook.com
 (2603:10b6:806:25f::14)
X-Microsoft-Original-Message-ID: <20230828082204.1238103-1-alloc.young@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6760:EE_|SA0PR11MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: e16dc2b7-562e-465b-8d9a-08dba79fea40
X-MS-Exchange-SLBlob-MailProps: 70qbaZjg4mvG1DVpcZ16y0G0e8zk20SA5z8eNdbbqXO8KZYrIiWQvvRs7zw+kNL+E0ugxk3BEyEKuBc2IpjhirY424Rdak3qwhljrEsghWX+cXR7xp+teEoITS2b1k+0X7xEp7d63G/lAoxdkGgWphlvAvQ3G8cql4N5Oi30RXs1Jh1Vqin7cQ/5ofCcSkWolaNhzcq0Ufh8ltl1d4V9sqQZNzaDXbFh0ehuiNW5HfI5DVZfgZHSA17uFWKlhV/hkzglp5I7cDW3S1wHrw3so38VQy1yPtWwDvvFNqNwCXEYGc5EoJmup4/lDN3U/dTxNGIm/nQUaZYrXWTXMbLmC10xGjxKbSWARJiD2i+HUDxKOYGOpj1d+D+Hz6ECrmdZX4Y70Zrq+pwy1N2JrdEzYhSOCmm9tDWiwpJyu0cj8F72c9TUhgRHpdvFd+Pl11mOf2L/v8Y/11KvXiKzsiDYTHi8EVWjWQQimdajaSHvSeLPyQxCBH1nfpEyJRiglQb9Tlq/9oHz/aPP86BKWKH8SlPT8rsKfsHxktobm2y5PEvAC2O2F5tNmFYQ36OVisaj2S0XBj6s6cmUMxrI1dE/dtTAcDqNhYq1myPyuEnx40in/mFGw5Q9NDKIS4jalJ8lIcRXsSYzkLrrUa5RsJO9sMUW+XRTQb2l2hHArcly8+BAbqWmgvV1hh179McAaX+OOEhjMZPPrfZ//MPtnZW+Ug8Qf6lR0EriuX82iTDgvnP3K1TDqQ4Sqg==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMTonJCNuHfYCdizz74JdrF3QGIVBjYYtUT8qcgqtHhEOFPut+9TgksrTVQwJbMC4bpwWPUNhFcGsj+aYeeNcUr5P48XKMVynybqoifn86zVrIaHw8oDa49vlxCJaoMjyfX6rMP50kBGrJelHb9+yLj4XKRg4Szk890W6RrTk0hZdUibSa2tME4+0x67qHZGexneb/DJB71z98noobtzv7vzFMylbUu/ML95gZmvlIbfxz86+qRELS9/ithVBQvhi0LVRt+BiXS0Obi1bBFousiA8cGVbyGc/yHKRvIGmWZeTqW4xbK3tShXZUrOjQRxPJe6MnZ+xjqz6Cek1qBKIaIz81d2GE9zS8lJ0gI7agWXkOiGFFMEsVvDCwvyV8/FclpS0Gl1tFadnJDMqoUXinWsjz9ddfV8xxjSp5y96p1JANnYGe3G2gW1Q/D3qgJ7bvDDOJSGbXUNLkgQywttjNO+hpPNVi0t25W8peN7ri9WhHHWSf9lpeSf+SbvZAlZQGqVzMBcankzW7GmP9EoDAlfgzIcbieDTcn5SU4XYpYjS709MDllyt7VDJLNuxligIrrIzzkx3Ln4O8ZJ2TXQJtOIvH73yF2yQlVx8B7I946NKqkSa8Ezq4Y+lis1JIb
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qc3+h/1PCOMTF8M2d55T8Fk4jLB+keCqg566JCHMfQg3eTImMSF1Wa58xwHV?=
 =?us-ascii?Q?i2S/QBWzLg3yK7EW5XFJt26OwMuIlSQwboyEJ2VWZJaEOLl5ukYpKxv3yNct?=
 =?us-ascii?Q?b+sikjckpv1rMJju5v/R80WjfR14NeonJLTwlLp/yREzy3pYkqHvQ7gtsEVH?=
 =?us-ascii?Q?cuCA/0hqOpaTc6l6WzV0fjejDL9pppU/YDfAAtSoH2c3UljThq1Y4mePyz/v?=
 =?us-ascii?Q?A7I8ys2tHqpsQCz4HApYa1Q9GN5EcnYh855d0tFY9ql9QlhTzfnOsYgHo2yB?=
 =?us-ascii?Q?Q2pwfA1eC5AzMuXY1LaMBqAbpoznUK+luLOrLLHvB5eZ7KWHCvLB9XsaM57w?=
 =?us-ascii?Q?S9nysKziR79Shw6UNbPCPweb8iS3wCY/TwdyhtIekZZ5KYo6p4fw6/Jeh8Fh?=
 =?us-ascii?Q?uAyMJCeabsDt5nK6W2QTlb63do02y/FD8SKpmBN9G8eJORCLvXrTGBbnTiRY?=
 =?us-ascii?Q?N6Btb9Wt7IqnhA+ZaljjnIJZsEcw/blWZqp+gGcP5ahnSzAwGkhveeatDEGb?=
 =?us-ascii?Q?YsTc8IChpyYYK5VGxWii/j2Z24FFgBx2/j63paZ8hKaDOy3qo3aFNlmdjoGx?=
 =?us-ascii?Q?gG5qfgtWqIfnQ+A/vnTY0XOQYw6r4JgBm3huFYTndn0qijX6aZILWvq7Kjnj?=
 =?us-ascii?Q?MMp1SJNAjcS9zi8TC/XV/ZZpIQMo8Io5QZUY512jIRz6sGmSsNgHuzbTCitq?=
 =?us-ascii?Q?CZR32YCxt4VafOICjFo2ZN0p8G7bJTiAEOFaBbA4mGa/U0Xe4oxvd1cYKDI6?=
 =?us-ascii?Q?pKI+TpfMe84vqvp9yZwC7xJQ8/aYvGGKzyGjUnvJOVq0y0rCUNLu8fcbhmtU?=
 =?us-ascii?Q?yjU4ITrD5YfuCKGI2983rVFAN9tBxkXq4a7k/PadjW/G8B+csP0ifhWWPsEm?=
 =?us-ascii?Q?giue+YxN9JUo6K1762BFr7Q8UMPHiuRM3CylaD37VwIVIxMraQfsfiYB24jP?=
 =?us-ascii?Q?MgdTUIOvFr9u2AeAVxDVqQk3NP0BUWwYtpXQF2QjqHhNE0N0CpC/NFXtNWkD?=
 =?us-ascii?Q?q2TZpSBYPo5xKXx6f3b9YJcLNjcvdunr1cCRjCjS+NmpwfMsMplyyAW0qgCB?=
 =?us-ascii?Q?8cf7DQRkkan6Y5etFionY3tFqZfEkusCB9Y0G0hriYtPc4w0EH94Q3GGMdHB?=
 =?us-ascii?Q?Ngomt2lFh5qk/uqwtDpOY0o5eS8w4cAGH2uDQTHg2oGpKK3Ui/CatVqQyYdl?=
 =?us-ascii?Q?+oZfpkZnFVq2nJ6ePcRIsyQLFOpEXEOOjmzfX8mRRDNrillzH/RdzpC00+M?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16dc2b7-562e-465b-8d9a-08dba79fea40
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6760.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2023 08:22:27.8483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: alloc <alloc.young@outlook.com>

kvm_dirty_ring_reaper_init is called much early than vcpu creation,
so it's possibe the reaper get a crash before vcpu mmap kvm_dirty_gfns.
Add a machine done notifier to ensure dirty reaper get run after vcpu
inited.

Signed-off-by: alloc <alloc.young@outlook.com>
---
 accel/kvm/kvm-all.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d07f1ecbd3..5ae7e27a72 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -51,6 +51,7 @@
 
 #include "hw/boards.h"
 #include "sysemu/stats.h"
+#include "sysemu/sysemu.h"
 
 /* This check must be after config-host.h is included */
 #ifdef CONFIG_EVENTFD
@@ -133,6 +134,8 @@ static QLIST_HEAD(, KVMResampleFd) kvm_resample_fd_list =
 
 static QemuMutex kml_slots_lock;
 
+static Notifier dirty_ring_reaper_machine_done;
+
 #define kvm_slots_lock()    qemu_mutex_lock(&kml_slots_lock)
 #define kvm_slots_unlock()  qemu_mutex_unlock(&kml_slots_lock)
 
@@ -1454,8 +1457,9 @@ static void *kvm_dirty_ring_reaper_thread(void *data)
     return NULL;
 }
 
-static void kvm_dirty_ring_reaper_init(KVMState *s)
+static void kvm_dirty_ring_reaper_init(Notifier *n, void *unused)
 {
+    KVMState *s = kvm_state;
     struct KVMDirtyRingReaper *r = &s->reaper;
 
     qemu_thread_create(&r->reaper_thr, "kvm-reaper",
@@ -2742,7 +2746,8 @@ static int kvm_init(MachineState *ms)
     }
 
     if (s->kvm_dirty_ring_size) {
-        kvm_dirty_ring_reaper_init(s);
+        dirty_ring_reaper_machine_done.notify = kvm_dirty_ring_reaper_init;
+        qemu_add_machine_init_done_notifier(&dirty_ring_reaper_machine_done);
     }
 
     if (kvm_check_extension(kvm_state, KVM_CAP_BINARY_STATS_FD)) {
-- 
2.39.3

