Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ACD2B5038
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgKPSwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:52:09 -0500
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:2104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbgKPSwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:52:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxRVo0MwzcujQBzSG7fHzJ3WYoVJMiKUz3ISxNzINx5xFqIVn8XXkRZ/vAAOCWvse6rzXF/SaCnG5QkUBvMhvUb8JOqRs39qS8bitUDP97gxVaU4JfHProACD9bohicZ5eyR+AL6Rx159b5La0B4tpPEj26pX3psEUlOGPJ5D+EUwRzGHwnP9ZcGvPrKOTF9ZdeV0b4OB0TQDulGsGr5Ax4cxDxQ/jKkm8qc8udgPzfLAiWadKDDmlXtZXld/DbpNAhL4QWK/m6TLo+ojin9B9RhpwX77EuxOPIiyheBpOcUZsSIf/PexH4GtHRTq5SwSJMUDVuZUZsxwSTX2+AbJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9k4kbe67Kn7PTnF0XlHPgduarMJ8ewLGQjj2pr4Wok=;
 b=Vr6URqplTMGFH89gXMbtYDKCPXdGC+GtugNq5+YU/f0Ie4bFBFmwU7ZtfLHYVQPiaFnXklnusUqwSBMT81OJq+rjD1/CRpHt69Ij+yy+p7fhAGR7lKU1JgYZrcy88DMQzUtpRcstsnY92Hebm2QHi0Nk2U+2ZlGd7cnLAl8eDcV0OyWd9MCsAViNKyyTDTlaItuP61GYQxaCDiK41Oqd0bPttuBd2Huliu6EqHBetdpHp9o3o67w4lqsurv8R4MPCsC0PA9CunpNJ8W2+6ifv+WHYhYT5P8kZ165MOcZEl8qOSHCbUAenjDrDexZ368oDgfqczbQb6KY6sKzWI2w6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9k4kbe67Kn7PTnF0XlHPgduarMJ8ewLGQjj2pr4Wok=;
 b=AuPqXiZGiNz32zVBXzQC3Fmyg3OJf6Vwkf+FhV+JOWKNIPiTauwa1lGEdwyLFrYNzBBAAuD+DdZ9k1bor+wDtRIWzPd7nvt/Oz/Cy+/29m3cjTLFGa2TiKuFZNrTt+G5oiPrdopefi5DE4C1NkVARCRhp/Vu41ddVvvxtFCU5xE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:52:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:52:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 07/11] kvm: introduce debug memory encryption API
Date:   Mon, 16 Nov 2020 18:51:54 +0000
Message-Id: <090d8c96ed71108ac34ce48dc84bdfba09df7686.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:0:54::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM3PR11CA0015.namprd11.prod.outlook.com (2603:10b6:0:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 18:52:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 799bfd96-0ce7-4c34-41b6-08d88a60b661
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45575E0718D8F90DFDBD994D8EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:142;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zXajTYxlnD3XHhOZAvoVh5glJS/9dy353fHFMCjY2bCZudWDx22SQUxMBqLe8mLY5JfBZLtpYaRvBHei1dbaCCev7flnNCwkZFGqzQOYFQadgAnvbGEyN77FkPNT2IKV9aBSfk6FemDCRrL48E5h9imiR0m/898j0O9zMKYoaUs34FJfYbZmqb9fMTEP3y7ddMAdKaiEp3Fk5m3Xrx4ExiAzc/VYqx5si4UMS5P4ilA2WPwz0tl/+MvrDXI6afPNCz0cdt+XURrJiG96Pb+hUGLLrN19a/v/xHlv+Juom9FYdaCIrwX9KFe0NlPhfHqYLFyDBXvKMxr/VwsRmKZEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: k+WnJDUK8cb5aRKLe5cmZt62xH4mSybijPK/cKOvN5ePsfOcf/qwvT/SSLR72iSI2R6uwp4CxQnTSMoKv0fcYy6gRT9HaDNZQImUCP4T2uxMJk6Jd/2EiOu0+BXV/jJ3Z5t0pJojmfq0r9m2uRb6HzT2WH78kHh8X5Hk3sQWR521C0121mZHmV4MNvFFxPKie2q3RWnrCDyVn6B04vwF+WBUTBOG3QjkWhinLb0gcgHvHXp2o8VKl8wmah0QzBb+SMJ2rgjw3xPhAQWxq8oEtrFNAbnpbHkZ5z0QCf+nxRsPprw+FtzHQ4CMNOLAc7RrLzvkdIl5gcSfkhN45++7JABgr5aWdhh2wPkQv42++HHxnNW3y58X4AqjW4hqrjPYqlnF+1knDU5Qb4f273Q4khQiO3Z7hl2q6j8zb88Pgo26+L8+fDxX9VN0Sr5oqftpwlivP7lvWfC9FzXP/253DVO05ZIDekgQx4u9/CfYpb92Qw6VOk5617GxyKUXUtq3N1UefoQS6ULCE5ZPUEc9i2G2QztfhaeGHzIPrpcd4CPsf7whqT344zACd2ef09B0Lhbza1+HjSgRG8fhq5hNRKy1DXVTEOnuX0VGzqNMVUwaYBtfDuYeC5PYorvKTNZKCKc7TlkgLn3yr2owjPc1GXQb4JC8NJsqy+At97P7NOAreV9tkeW8GNE3R37nlk/bxX4EOLQSEdWUlq6x/C34+EW/r56wHiy8v0rfg0iB5Q8iV2obxln5rQXbxGYydgH36I1iBLVnIYZ7a7cRlNovdzP0SPyJicc21JIk0DUvg9LZBI+/8NdGOm9iZ04Lg3B1WmIexgBpGeLu/Onstl9OAzLo1Yha04tuJ1aSGHTE++4IV1gCIxbDf30JqMfZQ5960Z1djVtLxDBS6Iiro/tm8w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799bfd96-0ce7-4c34-41b6-08d88a60b661
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:52:05.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4xeT5NDT6q0cQ3YhIbva6dcNwV/L4GxNT33UBzq3rb/DK0it0DWjEnMd5cKpdJ3uYU2hQfWh3/PammGOUu+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

In order to support debugging with Secure Encrypted Virtualization (SEV),
add a high-level memory encryption API.

Also add a new API interface to override any CPU class specific callbacks
for supporting debugging with SEV, for example, overriding the guest MMU/
page-table walker callback.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-all.c    | 19 +++++++++++++++++++
 accel/stubs/kvm-stub.c |  8 ++++++++
 include/sysemu/kvm.h   | 15 +++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9ef5daf4c5..ae85f53e7d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -123,6 +123,8 @@ struct KVMState
     /* memory encryption */
     void *memcrypt_handle;
     int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    void (*memcrypt_debug_ops_memory_region)(void *handle, MemoryRegion *mr);
+    void (*memcrypt_debug_ops_cpu_state)(void *handle, CPUState *cpu);
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -222,6 +224,23 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
+void kvm_memcrypt_set_debug_ops_memory_region(MemoryRegion *mr)
+{
+    if (kvm_state->memcrypt_handle &&
+        kvm_state->memcrypt_debug_ops_memory_region) {
+        kvm_state->memcrypt_debug_ops_memory_region(kvm_state->memcrypt_handle,
+                                                    mr);
+    }
+}
+
+void kvm_memcrypt_set_debug_ops_cpu_state(CPUState *cs)
+{
+    if (kvm_state->memcrypt_handle &&
+        kvm_state->memcrypt_debug_ops_cpu_state) {
+        kvm_state->memcrypt_debug_ops_cpu_state(kvm_state->memcrypt_handle, cs);
+    }
+}
+
 bool kvm_memcrypt_enabled(void)
 {
     if (kvm_state && kvm_state->memcrypt_handle) {
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 680e099463..bf93431e46 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -91,6 +91,14 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
   return 1;
 }
 
+void kvm_memcrypt_set_debug_ops_memory_region(MemoryRegion *mr)
+{
+}
+
+void kvm_memcrypt_set_debug_ops_cpu_state(CPUState *cs)
+{
+}
+
 #ifndef CONFIG_USER_ONLY
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index bb5d5cf497..1bde2e3d71 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -470,6 +470,21 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
                                       uint32_t index, int reg);
 uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 
+/**
+ * kvm_memcrypt_set_debug_ram_ops: set debug_ram_ops callback
+ *
+ * When debug_ram_ops is set, debug access to this memory region will use
+ * memory encryption APIs.
+ */
+void kvm_memcrypt_set_debug_ops_memory_region(MemoryRegion *mr);
+
+/**
+ * kvm_memcrypt_set_debug_ops_cpu_state: override cpu_class callbacks
+ *
+ * This interface allows vendor specific debug ops to override any
+ * cpu_class callbacks.
+ */
+void kvm_memcrypt_set_debug_ops_cpu_state(CPUState *cs);
 
 void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
 
-- 
2.17.1

