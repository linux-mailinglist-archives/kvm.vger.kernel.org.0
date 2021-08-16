Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669D63ED764
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbhHPNcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:32:23 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:59104
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239058AbhHPNa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:30:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMT8P2M3vWG1UISIj7GoVld/an6nprOVvj2f4dO/5YBLmkuHSPIWElZ66aNl52XJxCLRFO7zQOubHhPgXywL/14YqUkAQVMgFLA7kgfElInlkDdzWIfKWO5CQkBZPr2wJeJcyd1VvU0lI5M5Y0Bq87JBh5Dt66GoGyVVR+NmuncEVny/XhLJ1iG2iKaEYtKDxkBjV8zk6D8QZGOnvlSb/Wu3qkC4qFl1pkzVkJGSMHx8dOlArra6EH2z6vRrg/d2bYdLHobsYuUt3/i3CUBi9c3NMsUwHlmARKyR+R+xViY0vBYaJOoZ2TacUO62F1SI0bEAxmqPetisxW8moWktag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kyr2iEPWOnduvOBFmnbYcRn7VS6C8JYB2gGFQQZT1X0=;
 b=BawsDCfR3PBfCMEOkeqjTtl75a8FKlRKtKqJU6chmhtJrV6ZrUbXbdCVdlWvFmnh4TUxggXxq5c3IyEoNfXHWaYNr3y9Az8ONTIocNhRcySywh9KOQyI8uiAQijIIX80m/eDC0M8dZ0ld5HqABmZt5f7rq5GLHMzGzPWRIBWv+rSHub+3l7Y9jFie3Z4TI/t1TUdNpHS1kXrevIMEiWKy5wngYEGtXj4m+Zh4ZgFw4LlwAJKO9hj6X2wyk+YGFKgnb17ZfcYk6aDadLfnAgicAVTZOfzEqNaZUguBSOE1qbfVWYGcrPZBTBnrNQ0chm9ZgJjLgkNzxN7pywkTNQNZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kyr2iEPWOnduvOBFmnbYcRn7VS6C8JYB2gGFQQZT1X0=;
 b=PLnoiqCkNflQX9iw2P13l1ThdQz0KEHRBMSt+K6Dsm0PS7siu0QBqz5F25qV3WIcGqBJUvMu7TkVnvVnCOD4ytIIbqTMuxydvEC2XJmkROua8BJoMvAq4MrEzfdqQ8nYqChoy3v6N8v8rpYIS6/9ZNP8K6UfAYiWLcVDHHLukMM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 13:29:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:29:22 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 07/13] kvm: Add Mirror VM ioctl and enable cap interfaces.
Date:   Mon, 16 Aug 2021 13:29:11 +0000
Message-Id: <dd4fb978e10c1a07a65e176a32cb59feb1b78244.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:806:d2::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0070.namprd11.prod.outlook.com (2603:10b6:806:d2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:29:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ad602e-145f-43ce-7314-08d960b9dba1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2366D4A313614C18604FD6638EFD9@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:57;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baLDtnTp68wDK2TOECgmBx1fm0lQHyre9D76e85XqgheOXD/GnicI1PVkNmPe9iZg2U9kLmYZ4JbYqPAUWq6Ysg8NWUt5bpEIZimJP7MUwBmFo0xivB4G/lgxICskHjdUBEZHkfIticxcvXbDPS6rf13L5Veq2pql3C7P9thqsFKSUQjETraJ83/WtYzrL46X1YftKVx1mNNASD1UVRTWCbz/Y0anuci7aJ9LCd/FHVB7L3bAEZH36+l5OMGL8Wh3z8zoi3dy7oEMLFxgSW4rHY1cEwdVRygbGC9XF+xhYCL5NdD/CN6O/cXsMRLHl50uvFQJX1C9XPyxpwb91H5bOZolL6+STuFSqUT6TGbKmBFaPhdjVLtMXqotZmr2/9bZLs2526/83+SH2nAbkUuHCL/IlUhDKBibfnjFrl/31ycVzw2nqS2quF+kD8mmEiAYsnOGJqUsnz/ui9NyBp/5v2G7ytPieSnfoh4FlYjQ1vg70ufmLmOeo1ZAbv4nm2Cfq+MExEISY9a3OJ1fTVGBkSJC84ABRhwVaYfproSJHz4JxZeTyRAnFzfVua026nKtBXod4JPe187LkWtH70ogO6vIFYgytKFMPsif+B7AJWPfubV7C6Q6ZPO/jmbxWodjFAAX1a1EARUfyKohJYnsOXSHTgbUQ5j0yBJhY4YeVboTIKYexEW1EV1jWG0jajFa2DWuoJNcX/27Z6ah6pnsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(7696005)(38350700002)(316002)(38100700002)(956004)(2616005)(6486002)(2906002)(6916009)(52116002)(26005)(5660300002)(508600001)(8936002)(36756003)(66476007)(4326008)(6666004)(66556008)(66946007)(186003)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2y33Nk1uHocThnYwm6X+rs8jTIyuISppq8XcHf/XO1LC7IlzqJTdJQQoqGWD?=
 =?us-ascii?Q?LAfK0r7RlpzGgD42ARPI+sKIFf8Y9WJ7qSMfR9vDff1x9u7JYWfiQClmgtoy?=
 =?us-ascii?Q?i7s+QXyHSWowOr2CfToSd/PBaKQfMNAHBUiifLYLXNbdSRIrVwDHuSOONJVJ?=
 =?us-ascii?Q?kZZtqJqUkSws4GryY0GPganG3UddlA0uuEhpmNtdeg7eosBKmh69YRVhoYPd?=
 =?us-ascii?Q?9WCFdF2TX0ip2wIB29zawx+FNTkoCIb/Lp4sicWSP1+LDkj3Zn0hmJVP6GXw?=
 =?us-ascii?Q?wpvPbqBeusA/K5dmwAJ8pehz0HuGG8fCULjPh/1FjVPA9bt7sqTZ3pAjILZh?=
 =?us-ascii?Q?dUmMXk1HkGj3OZ1pHldurYk6ZkZ5vsLlIOX+o6ZX/fWKqjAzUEgRRk/x5eeG?=
 =?us-ascii?Q?c2HG5ACVrLKXXnkzgcf8SeZWCqY8IleTslBTIkBS3lXpJ8hYNlI7CWAtR665?=
 =?us-ascii?Q?x4OTh8XyJpyl7mr7JMYSk/5wlXzGUzMkvl8HfJTtH3pO4nVN8YLKPxkDYc8b?=
 =?us-ascii?Q?q7hZVDyeoh0epSkBsN0c3YAJYjXdcxPsbRajjwP0a79Pc+XLsBQuQCKIlnRM?=
 =?us-ascii?Q?oFtBUOg8bZ8p9mt2tq04dkXI2CvN23zSBbNJb4rHqK0fQaXdxuKSmZY5cbCQ?=
 =?us-ascii?Q?PaFPyTsIGG4YjCHBXpUdht2GoDIMfW/nEzRIWg5hISzqMi1HGuiHa6uKreR+?=
 =?us-ascii?Q?2sNlr7nuX69HQpGVXNlm/bA1KeJ1bFbmMbnZPfiTlTynDWAhAnCRHPFouafp?=
 =?us-ascii?Q?hf5coJI3Tk9MDooaH1PMMscLOtaMheYonjxS/6eaisFNYGT89tuVzap3GIzV?=
 =?us-ascii?Q?zGoj5b7szpLm9BiCyNIRO+bmiVgnM3/ByOXCvxYcbDMqE9WPGL7EskOHYUFT?=
 =?us-ascii?Q?ELoiVJBoDbLk2LD13xpu3JaiEHwOtgEUbDnfddWIhe2QUZXnIGheBdiZfjOG?=
 =?us-ascii?Q?TZcL8xOPD4EKoZn4gk+68/xb5fPkXLmHhZ1SyobdoH0aCUOSZG+N4/Yn63dN?=
 =?us-ascii?Q?Rpk4AS/y5diygycDlWpROd+rjZi9CqiMbJOVBsEdxd55r7p+s/6VZlUhNVOl?=
 =?us-ascii?Q?t6urQDKqnq9LG7nUoo3gvSAkZg/yCym2Bpz0TrAXFaYhj81oojtcwmBUNwQW?=
 =?us-ascii?Q?5gG0ML3H90Amf3jc013GFIbzqqXKDTQtHzTw7LEJhgv18ib3Co03Ole6JIJ0?=
 =?us-ascii?Q?Ity3ev+p6/2eWQp3tY0+e0J1+9VDAVC2kqNGQKMRrPTMNOTT00aCn3Ws+EEq?=
 =?us-ascii?Q?Mp3tL4p4S3ka1aTelwDlFzMJJHR43PT+TjNKzpJfGAf6r45gpnUMdIQAtnqH?=
 =?us-ascii?Q?7wHN/SdbnIa6tFloacr5l/4X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ad602e-145f-43ce-7314-08d960b9dba1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:29:22.1222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wl8tNpTxPcKroUi7RPDs077bQNrzTJQIAWjpPCaeSKz+fzDk6hgnpVI3ZAoc9hiMRSWjIhi54/A4XnroPM8a5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add VM ioctl and enable cap support for Mirror VM's and
a new VM file descriptor for Mirror VM's in KVMState.

The VCPU ioctl interface for Mirror VM works as it is,
as it uses a CPUState and VCPU file descriptor allocated
and setup for mirror vcpus.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-all.c  | 23 +++++++++++++++++++++++
 include/sysemu/kvm.h | 14 ++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 0125c17edb..4bc5971881 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -149,6 +149,7 @@ struct KVMState
     uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
     uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
     struct KVMDirtyRingReaper reaper;
+    int mirror_vm_fd;
 };
 
 KVMState *kvm_state;
@@ -3003,6 +3004,28 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
     return ret;
 }
 
+int kvm_mirror_vm_ioctl(KVMState *s, int type, ...)
+{
+    int ret;
+    void *arg;
+    va_list ap;
+
+    if (!s->mirror_vm_fd) {
+        return 0;
+    }
+
+    va_start(ap, type);
+    arg = va_arg(ap, void *);
+    va_end(ap);
+
+    trace_kvm_vm_ioctl(type, arg);
+    ret = ioctl(s->mirror_vm_fd, type, arg);
+    if (ret == -1) {
+        ret = -errno;
+    }
+    return ret;
+}
+
 int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
 {
     int ret;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee12d..6847ffcdfd 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -255,6 +255,8 @@ int kvm_ioctl(KVMState *s, int type, ...);
 
 int kvm_vm_ioctl(KVMState *s, int type, ...);
 
+int kvm_mirror_vm_ioctl(KVMState *s, int type, ...);
+
 int kvm_vcpu_ioctl(CPUState *cpu, int type, ...);
 
 /**
@@ -434,6 +436,18 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension);
         kvm_vm_ioctl(s, KVM_ENABLE_CAP, &cap);                       \
     })
 
+#define kvm_mirror_vm_enable_cap(s, capability, cap_flags, ...)      \
+    ({                                                               \
+        struct kvm_enable_cap cap = {                                \
+            .cap = capability,                                       \
+            .flags = cap_flags,                                      \
+        };                                                           \
+        uint64_t args_tmp[] = { __VA_ARGS__ };                       \
+        size_t n = MIN(ARRAY_SIZE(args_tmp), ARRAY_SIZE(cap.args));  \
+        memcpy(cap.args, args_tmp, n * sizeof(cap.args[0]));         \
+        kvm_mirror_vm_ioctl(s, KVM_ENABLE_CAP, &cap);                \
+    })
+
 #define kvm_vcpu_enable_cap(cpu, capability, cap_flags, ...)         \
     ({                                                               \
         struct kvm_enable_cap cap = {                                \
-- 
2.17.1

