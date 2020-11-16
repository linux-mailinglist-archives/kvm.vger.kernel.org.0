Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E0A2B5044
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgKPSw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:52:27 -0500
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:41057
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgKPSw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:52:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+2+J86PaLHjP0Ed7rZ4M0I24jPBgc5vOaUn1DeEbJPm+F5i6St90+G2rqmhZ35KyMeHMA72UvdXIg5lanjYLYR6gUeT67hWykUDxja+8wFPZMw50HU2NIbZ+b7IIlp/Y4WHJI+3RHZ4f5siJArkY7y0v/XRGxk25MxXmDjMgoOcJkSegLOb3EopKxJSM3Z+ixUwJ4vsPh42Q4iOwZqGo8Sf3CLxi6NoHBJek6IcGOYVndMWuH1QlNnikZp1N4RygnY1lU3ZGqhzUkzjwmdwbYUJdxS54MmkDaPxEQNfaZNG4aF2Utn1hr/O5fv88KP5bsfu3V5BhH5dP8/sBnx7tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wkX8dNPf0psqgmvvnMdCQVb1LlTkn3M//y8xpnxIFc=;
 b=I2avH1Evw2LxfgzguT0hzgWuNOdq1+mLga+pPlNxxrHjOiENtfyfEGteiz10+th5yjNWL5L6U/DkJvDrH+76gDUOOg/HdfgdVieAjqaqttXMkhs8qJH3yrAmxUOzoRsV/y2qeXFBIGoY3wuUaVrRPvc+V822bqzC7OCrRb+U6W+ysMrJg7e7Enm5n8m5F5XueekORlVwtUxUoD13xrZPOLcspIo/BwjNczi9SgjYmzG2Je3qwoEO/4VfZ9cRDtmHnCWy4H6rN+mgqOIp1k93rp+gcLtRe1TiKL0JrOHbHNABrWPCRetCj03p+ZDQuXnYpMbsL8n0gF9VEuS0blUIwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wkX8dNPf0psqgmvvnMdCQVb1LlTkn3M//y8xpnxIFc=;
 b=jPWrRQ9m56rsxOneMlJB6ZDSdqBeXuZ/MBoMHDYWGclnT3DIeYAZqddfaDM0TJT8m1vAKucIxPBHt+GWdTXd8REWeA+dE43yuM/SHOFXPfhoRQvVsP5qOHbsQxLUZHWmX6vSIlU46G/xSSHcp3NJlA31uDFVlElW4PAUqm8R1XA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:52:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:52:22 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 08/11] sev/i386: add debug encrypt and decrypt commands
Date:   Mon, 16 Nov 2020 18:52:11 +0000
Message-Id: <5b68e77ddb2ea8877f02b9256d34fc8532d8f44b.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0073.namprd07.prod.outlook.com
 (2603:10b6:4:ad::38) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR07CA0073.namprd07.prod.outlook.com (2603:10b6:4:ad::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:52:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d890182-dd0a-4d68-0320-08d88a60c09e
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB467064956E462BC6F1A16E4C8EE30@SN6PR12MB4670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIWkNaKLSiwyTwSAERtfyLHEqUkllT3PNrBmj6rkdlVi5/Te5AOAvDwbcj+3JQXBtI9nyHdWPly2HBpXzW9tnXiMXcgBg6ueT/eA1i5IcHSPu6MIrsNk1XhDtpxMzkD0Qar1Pwld+tleK/d7c2TcVtYLR9lk9TyjqdS8LTbet36fmfdHHnMTRW0HUxgPYG0c2jutsWfnrs4IRlFgD+xv4stX13BhEduqQTXKvmORLWkCLfgzu7UGbmVb5G7umLGEFrfhcTF5s7xu1hEqsAJsCyUPFtupPh1cf/Il5xel6FctMHltpe6Lb32MRFUGZehS6yVeQy507RWlLsxETfYrGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(36756003)(8676002)(8936002)(86362001)(6486002)(6666004)(316002)(83380400001)(2616005)(956004)(4326008)(5660300002)(478600001)(7416002)(6916009)(186003)(7696005)(66556008)(16526019)(52116002)(26005)(66946007)(2906002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tgTqTzq6K7oxeKulKxcN64SxPbGHISayg/gdSF7kg7F5i4znHiQXQt8Ks40BeYt5XKLLicETDBbX5GdgnJWJSrGYtrnICwVbgM7wnQ9p+mdNErZCbSJ+HuH/B34hkSSUxL6Q3JCGtgaMckEidTjlybkpK5TUQXuVyJSy0RDb2Tbt7IEOsylx2g48AE7FdOWZvxjL+fvo37YSyq663dfZo1GJfSFLMdm3JWLDv/3id//1TBeT2lE0MNE+AxLLFU62Vawldai5bcUiuIbtaif532uGzfhGRSFAM1BgH9lEzAm6OvgD4zwp77uMNU+ESVTIQIPDb3xoWfTpki/xh3HfOjeCu2HhBSk+wpJLQrnRorRSC+mf6KZxgIPy/XzW7PxIE2Yu9le9T8C7ADUt0yUth3YP6AIiEk4mUuhOKqeyTdwmlT8CJ5yT4EdNvqL5x8NGbrUmnjSqEOJdS8ZodD0cqX0WDMuWVzSySZmZztF+vjtuLRvyOQHoAasaweyLLxzkSamRzNAxRvpN6n8KWdwmq0z7LzCkElbYgW69G0gbiKmRUJOTdl7xZ1Mdm/Odr8Z1rQCs2wYqarl1gKG0oThqgc4oOMw8l8dM4PzmXPBqBvWDMHFLB+3z9/gWJgdXcLtwisgaFcudz3M4b5q62tP0u1w6D4Ka3TD+q1I34/8gzVWCd9YCz8DkpuCEkzMGO6hYpOmCF7zXuf4q5M9Kc5uJ759KvctdS+Bd3EHlMsn31ZyNOdgP0cLmPO1Pk1sOZzNWV2HtWokZnYbaN8aB0c+iaY8jBr8X/Faq+vF9bq5UzWgKQ72L5+H1VoyS2w8SijUU1g0a5woNKVnGx+RIJ1KmjaU8DcIfQCrnNqcgpnEH7eF3XryQfL+Jp7bKt1qtmbFlDPRRBOoXI4JPEJdSp42KMQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d890182-dd0a-4d68-0320-08d88a60c09e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:52:22.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTJiRt4wIc/dsmC+2/QjQin4sx8t+kMWcvSEqtL1Av341cRDDn2jWQVOipj26DLPyf8HR2a3J04iN/FLo5waNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SEV_DBG_DECRYPT and KVM_SEV_DBG_ENCRYPT commands are used for
decrypting and encrypting guest memory. The command works only if the
guest policy allows the debugging.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-all.c      |  2 ++
 accel/kvm/sev-stub.c     |  4 +++
 include/sysemu/sev.h     |  1 +
 target/i386/sev.c        | 58 ++++++++++++++++++++++++++++++++++++++++
 target/i386/trace-events |  1 +
 5 files changed, 66 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index ae85f53e7d..042205e3e1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2232,6 +2232,8 @@ static int kvm_init(MachineState *ms)
         }
 
         kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
+        kvm_state->memcrypt_debug_ops_memory_region =
+            sev_set_debug_ops_memory_region;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 4f97452585..3f1f0ef217 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,6 +15,10 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
+void sev_set_debug_ops_memory_region(void *handle, MemoryRegion *mr)
+{
+}
+
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
 {
     abort();
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 98c1ec8d38..6c37247915 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -18,4 +18,5 @@
 
 void *sev_guest_init(const char *id);
 int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+void sev_set_debug_ops_memory_region(void *handle, MemoryRegion *mr);
 #endif
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 93c4d60b82..3036fb3e43 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -72,6 +72,8 @@ struct SevGuestState {
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
+static MemoryRegionRAMReadWriteOps sev_ops;
+
 static const char *const sev_fw_errlist[] = {
     "",
     "Platform state is invalid",
@@ -679,6 +681,46 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
+static int
+sev_dbg_enc_dec(uint8_t *dst, const uint8_t *src, uint32_t len, bool write)
+{
+    int ret, error;
+    struct kvm_sev_dbg dbg;
+
+    dbg.src_uaddr = (unsigned long)src;
+    dbg.dst_uaddr = (unsigned long)dst;
+    dbg.len = len;
+
+    trace_kvm_sev_debug(write ? "encrypt" : "decrypt", src, dst, len);
+    ret = sev_ioctl(sev_guest->sev_fd,
+                    write ? KVM_SEV_DBG_ENCRYPT : KVM_SEV_DBG_DECRYPT,
+                    &dbg, &error);
+    if (ret) {
+        error_report("%s (%s) 0x%llx->0x%llx+0x%x ret=%d fw_error=%d '%s'",
+                     __func__, write ? "write" : "read", dbg.src_uaddr,
+                     dbg.dst_uaddr, dbg.len, ret, error,
+                     fw_error_to_str(error));
+    }
+
+    return ret;
+}
+
+static int
+sev_mem_read(uint8_t *dst, const uint8_t *src, uint32_t len, MemTxAttrs attrs)
+{
+    assert(attrs.debug);
+
+    return sev_dbg_enc_dec(dst, src, len, false);
+}
+
+static int
+sev_mem_write(uint8_t *dst, const uint8_t *src, uint32_t len, MemTxAttrs attrs)
+{
+    assert(attrs.debug);
+
+    return sev_dbg_enc_dec(dst, src, len, true);
+}
+
 void *
 sev_guest_init(const char *id)
 {
@@ -785,6 +827,22 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+void
+sev_set_debug_ops_memory_region(void *handle, MemoryRegion *mr)
+{
+    SevGuestState *s = handle;
+
+    /* If policy does not allow debug then no need to register ops */
+    if (s->policy & SEV_POLICY_NODBG) {
+        return;
+    }
+
+    sev_ops.read = sev_mem_read;
+    sev_ops.write = sev_mem_write;
+
+    memory_region_set_ram_debug_ops(mr, &sev_ops);
+}
+
 static void
 sev_register_types(void)
 {
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 789c700d4a..f91213c5e9 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -15,3 +15,4 @@ kvm_sev_launch_start(int policy, void *session, void *pdh) "policy 0x%x session
 kvm_sev_launch_update_data(void *addr, uint64_t len) "addr %p len 0x%" PRIu64
 kvm_sev_launch_measurement(const char *value) "data %s"
 kvm_sev_launch_finish(void) ""
+kvm_sev_debug(const char *op, const uint8_t *src, uint8_t *dst, int len) "(%s) src %p dst %p len %d"
-- 
2.17.1

