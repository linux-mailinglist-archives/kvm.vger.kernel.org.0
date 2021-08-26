Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3132C3F90BB
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbhHZW2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:15 -0400
Received: from mail-bn8nam12hn2202.outbound.protection.outlook.com ([52.100.165.202]:17408
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243799AbhHZW2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beoRXoISE9z2LBU1N9jQ3FAjglJheapKaW8/gNrCCGBoAyCjwFxeKvdrezfPF71e17REJFxRGJ2/rdnPpDy0HfCkMMXVl3l4wmEvC1PBd5drWLtWCVMUVe8g2Wu0FC46ypKgZvBv7lFkIRhkuZ5Zd2jCS6GPPhnNPnozswqMKdyNUvkDK6BKG71BRkz21eb2xI7Hb4CCt1x7X6aeSMKXRFJ50qojPQhzp94TViZoVZbudI/c0rW7XKdzSRsnrZV5+bBi27LmoPtFSMiNJXcVavW6QVQvlebkrrIKTmM9Dtm8O28UQNldDIBXVO5x0DK0alnqX6sM0jNbSkLeegXKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y0U6T3TrceInT8zsv9jg8p9uixc2V5XYlE9SNVdYnU=;
 b=lf13FypuL4aUerOCXCqo3dTUFWUg3fLXh7CautEz6zWKbQSvkFrL6q0J4OQqBiZiLHblLoTk8YTlu/KTLrv6pGiS7dgwA4NE0XMorfFNd7WHAjjbS95tjdP6OgTTKmeeWgJ6Peyf1Gb5aCLA4HSWSD29QcnaCvfCpkM/GbLpdsBUbGR38AoBkJIKbtUX+r+FBsWbOhcAMBNcbbgDNR881K3kMbMT4YHU7nHNPQeS7QNrqFSiRP4DlLtWdKiDJBMbuO+uCl9rYdnk0jCla3UrGsJ0lrzcEKKrAMqxHBicptbXOV6IUNStT8knwTGHOFdxC1dvnofEtJD7MlL+u0r5Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y0U6T3TrceInT8zsv9jg8p9uixc2V5XYlE9SNVdYnU=;
 b=rwWHUHt4zpNNlcXpqb2JYZtV1GDBaxTIUoW2esSAJv70QIAWxKF5umaPQWCdeDd8hEWILAzYRssjv5MdA2C4h1BsOFTfVqD06Tvbe8WQFGXkn4yt3pgN1qswX/dlaFMbFnhrbq2Rn405T+FyWsZoGu3WcPrOObuw9sxM/6seqZU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:25 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:25 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 06/12] i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
Date:   Thu, 26 Aug 2021 17:26:21 -0500
Message-Id: <20210826222627.3556-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::29) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 26 Aug 2021 22:27:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c83bb0ef-0250-4bf4-6d62-08d968e0ae02
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3925D19B7A704A5878D4AA9395C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iuFs9INAzndsl4LFujevoznRAI/3MFO0FuyS3rg2d9oyL2Qy5sTmjk9s+pPX?=
 =?us-ascii?Q?YmRJIC6Do+yjqO1dnPQ9THh2S/zn9+B2vH/IGtwMh4g6qTGbDcwaX8fK43y0?=
 =?us-ascii?Q?eRPd6HutwC0n7uAf/T/H61IiWxwYw5uoTuNWfoqQEwTGvL0m4PQT6ZOUK58Y?=
 =?us-ascii?Q?mYrzNS41D9j4BceOf38HGA2y6mtHJ6z4SB7otFFWTUTd2+5sH4PFJP9WIwho?=
 =?us-ascii?Q?RnJzaf538g8kLm/DJd7oFVR+K35JrSQ2j/YbYJZU2S9zEjVAl+qzE86D684s?=
 =?us-ascii?Q?rbvrH79YPZy4jzQ+DPOFwOBydHJFHptUgmXsBOfkh4O0sj9mRb2l8Wjy+mxn?=
 =?us-ascii?Q?JyUTAD/IIqa5TTl+nMUOxeP+cYmdsaMYqN1TwX5vOsvpwVIldVllgGcUK4Ow?=
 =?us-ascii?Q?d1ZvcoRo6GKt25R4Lwhdjo5fIjdP+0MLS+Zwv+XAnlOd3q4BSkUedkixolOV?=
 =?us-ascii?Q?EjOBwSFhBu2LF8CIL8kDQJ5GRpmwQOo6BVX7xBbZhnB3Ll291bVkwx5pZCtP?=
 =?us-ascii?Q?5rT8rIAh8g0wR/koQynCPIoZZLQNMAhBNiJ9divffYPezzK57O1HI9cdNuxo?=
 =?us-ascii?Q?ws8Iruw6xBiQ2DPLerya7RDFKpf+eKxMr/JmYXaGWHNI7Gj36znfnYu3zOgN?=
 =?us-ascii?Q?J5uyUeI66siAj+oQ2u2U62ZKUJQ5n6Qhzi5xOdypghhBqZKhMoreOBayqxZR?=
 =?us-ascii?Q?YA6bsb7xlpkhERqXm6F95SmynFhOzcrNj2c6Von2Fi9ysbDxf7gXOuzx+gvO?=
 =?us-ascii?Q?EY5l25jj0xCrdIPYwsGM4qxHeKjBAYJUBZR1+D6l+GZEHHPYDGt5cr4oZM8d?=
 =?us-ascii?Q?H/BYlnoZV7n1D+yCCfwVo412MhahksLVqjmieWbDrrSI5iDWuxLaudissZnk?=
 =?us-ascii?Q?UuZTzrypL7g0tVBQs7o6NUmDzMkxJW/Np+kfk0iECWSazC7x4HBXtEmonHr2?=
 =?us-ascii?Q?XTCox13o4NPh/hP/WNSTp9sNuVCcbBOT9EOzjuBpaivBxAtxdPRdG0Ul6RCa?=
 =?us-ascii?Q?ukWWqDUlghc+dYewShw37SrhdG1ry3t1usU5Js6CsbILVXI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(6666004)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AAzUXDvXqH0ST0/i70b+8UE7ob6KOpI5CvDG867qTHuAvTRZynHGXHWf2WCk?=
 =?us-ascii?Q?tLl73cn34mCoWr/kA5E6s+Oh3MTGswvmhU6d/kEmdMdESXXLGf5QVBe5j99s?=
 =?us-ascii?Q?uEpwWzE5fIl0exn6czEA1LyXEFvGvhB3FrVG+mJXcM8/lsfciqUVyn7kBxZ1?=
 =?us-ascii?Q?Mt5IUt3LXBZXc0QQLkfkmBlak+8pFcOyN0nfN2pz6ajUjyWmK1/y76qF8VK8?=
 =?us-ascii?Q?DwpmxFmbL2B0PPPRU5D7RXaftC7ZqvuAw4nu0Dvc59vpYgP2EdqgZisPFh8y?=
 =?us-ascii?Q?MShCXwfWooy/i1y80d487yOvur2O4KUS1cOzT8Zyc7DQmSzbm7DVO+Sfgg8Y?=
 =?us-ascii?Q?raDohLCWyMMFjgE5Bl9jzLp44y77OKvXo5JZ0wq32v1ey+vWxzS/eQYyqYx0?=
 =?us-ascii?Q?Altk4qu1CCzrvdC5I5Z3jKf77BR9Q+2dbvfrT0wxzNw8C4Amg5236lMo2zEy?=
 =?us-ascii?Q?kz1rHh1rHeotYMsreoCtHgURuMdaQfoMp27N6LoHP8fjiAr1fPrYOD4rJCRe?=
 =?us-ascii?Q?1eQUgZe5OmEjuDEh9ZT/KSsoYKxH1bzzFsRTTeABElXrS7cscc/vplRSJkwZ?=
 =?us-ascii?Q?6gyYLmIiu81Ny6i40WlNm2ct3l9Vx6mf1uSgVQWpdeUsvEEH3RD7x4REiPQH?=
 =?us-ascii?Q?hv8zWd5U2gcnC1dKpJNgBGRuPcOrHkEqrRuV/zXaKMTfTvvGFHQFQ6HMoPMX?=
 =?us-ascii?Q?63NDsOARedtaHUW7kvz7LwB5YTpARpHFS7c9AqBYXaFz+kLw3p7AO0Yw5zJ8?=
 =?us-ascii?Q?hGYiduP1yxUiE7257TEdhnfQAJ15CI4D0xMnH8r56ILedEnZ1v5H3R2N9iFP?=
 =?us-ascii?Q?pkqwYE+8a6D/Dn09slVLtgCH2KhalqjZSmf19XEXepAx4eJcc/sGrcFKDqKP?=
 =?us-ascii?Q?m+gPnTJ9jKcJgMaea2cfGshfFRwa877g0R3jrS+cF/4tpJCcFOS1J3GEc8wJ?=
 =?us-ascii?Q?lFOrTGDAb4DtTQw64vSvCw6rUJDMuOHfTbdLNI+qZAs8NX0jnTPnrPqDCQeD?=
 =?us-ascii?Q?Q8xd/jHIGUepgBA9kjPYx0ziW6Z6xH7rpXUrV5R8suSP9hKMby8NWO6iQHVk?=
 =?us-ascii?Q?jY9UciBOQHEPMYTKbAP8m9ZmqM34IFZac3EoaqKQ06W+lCw28C7jl4HNOsuY?=
 =?us-ascii?Q?Kp1lSiPEPB2/YFrunDSF2wdSfEtWnPA2HOuiKPOq/zjbX4KFyTSEmiInfX52?=
 =?us-ascii?Q?EV4p10lO4Ok0U7rweGHdlEWta6n2u8C66w8laaulun5/LFXsWlQSixWVRmqQ?=
 =?us-ascii?Q?vNNFrOMLYtfnW8EuyY6c0VbjpFBhFzKLWdsjIlvVhWSIo0GYZfrwFw/ASzJd?=
 =?us-ascii?Q?Wr7Y7EPTMNySXm3N+tSdNy5k?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83bb0ef-0250-4bf4-6d62-08d968e0ae02
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:25.2526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQ1FcZe+kg6owZGglcQ+OZpNXKzlGjMJq4mke9LFqYfOoeoKHiyxAQeja++0dokCpnf+rKih7DqqALaUaJe9NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
image used for booting the SEV-SNP guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/i386/pc_sysfw.c       |  7 ++++---
 include/sysemu/sev.h     |  2 +-
 target/i386/sev-stub.c   |  2 +-
 target/i386/sev.c        | 40 ++++++++++++++++++++++++++++++++++++++--
 target/i386/trace-events |  1 +
 5 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index 68d6b1f783..54ccf13c0e 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -149,6 +149,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
     void *flash_ptr;
     int flash_size;
     int ret;
+    hwaddr gpa;
 
     assert(PC_MACHINE_GET_CLASS(pcms)->pci_enabled);
 
@@ -182,11 +183,11 @@ static void pc_system_flash_map(PCMachineState *pcms,
         }
 
         total_size += size;
+        gpa = 0x100000000ULL - total_size; /* where the flash is mapped */
         qdev_prop_set_uint32(DEVICE(system_flash), "num-blocks",
                              size / FLASH_SECTOR_SIZE);
         sysbus_realize_and_unref(SYS_BUS_DEVICE(system_flash), &error_fatal);
-        sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0,
-                        0x100000000ULL - total_size);
+        sysbus_mmio_map(SYS_BUS_DEVICE(system_flash), 0, gpa);
 
         if (i == 0) {
             flash_mem = pflash_cfi01_get_memory(system_flash);
@@ -208,7 +209,7 @@ static void pc_system_flash_map(PCMachineState *pcms,
                     exit(1);
                 }
 
-                sev_encrypt_flash(flash_ptr, flash_size, &error_fatal);
+                sev_encrypt_flash(gpa, flash_ptr, flash_size, &error_fatal);
             }
         }
     }
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 94d821d737..78e3bf97e8 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,7 +18,7 @@
 
 bool sev_enabled(void);
 int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
+int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
 
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index e4fb8e882e..8b35704937 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -56,7 +56,7 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
     return 1;
 }
 
-int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     return 0;
 }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 51689d4fa4..867c0cb457 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -946,6 +946,35 @@ out:
     return ret;
 }
 
+static int
+sev_snp_launch_update(SevSnpGuestState *sev_snp_guest, hwaddr gpa, uint8_t *addr,
+                      uint64_t len, int type)
+{
+    int ret, fw_error;
+    struct kvm_sev_snp_launch_update update = {0};
+
+    if (!addr || !len) {
+        error_report("%s: SNP_LAUNCH_UPDATE called with invalid address / length: %lx / %lx",
+                __func__, gpa, len);
+        return 1;
+    }
+
+    update.uaddr = (__u64)(unsigned long)addr;
+    update.start_gfn = gpa >> TARGET_PAGE_BITS;
+    update.len = len;
+    update.page_type = type;
+    trace_kvm_sev_snp_launch_update(addr, len, type);
+    ret = sev_ioctl(SEV_COMMON(sev_snp_guest)->sev_fd,
+                    KVM_SEV_SNP_LAUNCH_UPDATE,
+                    &update, &fw_error);
+    if (ret) {
+        error_report("%s: SNP_LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
+                __func__, ret, fw_error, fw_error_to_str(fw_error));
+    }
+
+    return ret;
+}
+
 static int
 sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
 {
@@ -1219,7 +1248,7 @@ err:
 }
 
 int
-sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
+sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
@@ -1229,7 +1258,14 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 
     /* if SEV is in update state then encrypt the data else do nothing */
     if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
+        int ret;
+
+        if (sev_snp_enabled()) {
+            ret = sev_snp_launch_update(SEV_SNP_GUEST(sev_common), gpa, ptr,
+                                        len, KVM_SEV_SNP_PAGE_TYPE_NORMAL);
+        } else {
+            ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
+        }
         if (ret < 0) {
             error_setg(errp, "failed to encrypt pflash rom");
             return ret;
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 18cc14b956..0c2d250206 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -12,3 +12,4 @@ kvm_sev_launch_finish(void) ""
 kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
 kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
 kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
+kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
-- 
2.25.1

