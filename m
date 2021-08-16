Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA583ED766
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbhHPNc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:32:28 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:16960
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238754AbhHPNa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:30:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH6vE84/0/yY5wkfQiNvsNWxwtwLKLjnkVRyqAdSr/8goV8VwJI/4M5gzjcoGTuwsHpKKKswRf9fFBQJFl23m5/ojzqDa8mhXBH6iZCqbH9kFeIjP5QWSqhy+FM+W2ylCBluiXXoJOl/zR/WexpJ5zmJJJeNzp42If9i1+HA2qkjuKM6lL2mROk38igJkltuKTV4K2byEbWH0P/Bg/W3ia5U8TIGdLswGm8va1ywyD4yUE9iO5u+xaOadrJ43/ydwr4wwWLNlnszv8JroWZjm+9kpeJ8/mgeP6hGQ9XKyI1uG5roRlAzuPKRPn28z5KPWVK6R556kL6wSZq6fR24lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxrAGwgzL30APAe5l6Xa57GYHJT278T/HEKzpyocTDM=;
 b=A7AXOntSf2NBvEQOiDl+SA3z/kHALkV/dlYZHAZR6unJaipQAkR1F+m8uB1xPhqV1ep0oAezzKdi5ia+EJbw1s2bOmVO5gRUvNJhAD38ueO8DdA+toqKIyGzZdLfPhVO+owIDlIQoe6wu6tDiN/khzKEy3kbuzRJ2IiJy+tzVhuFwihsQ8jxi3CKAqHjF/bC49u/Fky2iaJ1EBN2SxKUuUSjkjWjjaYW7oDP9n7Vt3QYeQok+ZB3Tyf743g7PIrcxb5oiNQqjehmazOXVckNbIprXcSi1+zI8B42n2ijPdRnopd38638ylJTXyFegYVNkwOb4bSijS7bs1a44pIA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxrAGwgzL30APAe5l6Xa57GYHJT278T/HEKzpyocTDM=;
 b=PsykmZmLyV4HEmXzvJn94rs5qv5X04i4UdgPBBBmNdCctZBwWxHU3ha4+UquJByfOwBQhmDLTGSRsndHd4OAAMdMVjzf8z6VYx67mKvqLx5TkFsxsoW+esseoz/6fplpCX1mwIja74mTBGkserVI9krYGv52FkKvcM5ELQnHlz0=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:29:52 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:29:52 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 08/13] kvm: Add Mirror VM support.
Date:   Mon, 16 Aug 2021 13:29:41 +0000
Message-Id: <c81a02bfd698ed366bf2d61a36adcbb8ca21eb9c.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0072.namprd02.prod.outlook.com
 (2603:10b6:803:20::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0072.namprd02.prod.outlook.com (2603:10b6:803:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:29:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c163b72-0fe9-4bfd-0352-08d960b9edcc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45123159E473765A00948D988EFD9@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:194;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSkEt+pky5KYHeQq6uBplKiLhVxAP8W2A7I5WS0Hgk9eCinKYA9D3237IZgGXQ9kmnyAJ5RwOMIfvd4NiDw4wZOOECtZ9iVyEVUh6whShq3ex/IDOyrkYIynwm01x3cE04MmHzoBPnyosoH2BqYQzVTbLZO/Uj8O4tSsbjQ9n18TtGeS3WanqZYfxde1x5pECypfonjy7FB4/wXT2gVBVD99DlWvfBZQZIoZJ6enIISvz7HA0eEQC2BetgRG/OB0akzSK5P+E8VxL3EZALhofbGnq4iEaFf4ICI9uzDIDQyuSYkM+C8j6EqnKTrBEYfXTpyi0vX3G38wnTFfbWPGZdisgmMZ53AkoDUiL2Ly+zkemPtuRRkx8eOWclPvmXYPyBdFtGkTOQOat0bX6f1e/PwMb5qjVzrzLmT4UYwGbNUSm+zSe0c2E+jYmIZNCEPkZ4IrIBAkKqK+pbAPoE1BfOH3W82NS3wTS9+2vKRP74MGoRUHnEySpkmdIh/UAnHAkPlNOIVDrpYV5r58IVDoOf0iGN+dNtziA2uN8UTjHQn2ZTd9v12LO9+uH3cKi02VcDZolKrH1LlbeFBXIj6Tmz5hOpRf+mDSwVgrYiv1Ih3Z12/i2zQH6ZrG68vVLDQd1sP73XxbdrrR6c9E83hJcxIuZ7y9QJFbkEynDViIORa6q4SnVjdiLCJdN8okn3KJMK8OCJMMeTbVbbyaV+FeSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(6486002)(7696005)(478600001)(36756003)(52116002)(38350700002)(26005)(66946007)(66476007)(186003)(86362001)(316002)(38100700002)(66556008)(2616005)(83380400001)(7416002)(6666004)(8676002)(6916009)(4326008)(2906002)(5660300002)(8936002)(30864003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NjQM7iwBQyrkAkBDfbIbK0aR8j6UNxfXp2z/hc93UyGLA6epuQayGgcwLnCN?=
 =?us-ascii?Q?nzMKfg1TWiiOJGxdRSiNmjgJeNKG5+y/ayUswy71xmk3IN3hUUoGw7lZIvXQ?=
 =?us-ascii?Q?NDX5hom5MeKA+7ov4MHfccEpOD8iVq29WVvXj6qTXOnhYI5o8Rsgebu5JJwj?=
 =?us-ascii?Q?lJqXS9d9fzx35mMyw+VGjmw2bQ1gmgC7sSUSlvF1SEHfBHHbk4NSTzCdafMz?=
 =?us-ascii?Q?/HiSxtm8qmWxpFgfGJRan7BQgLtlwZBV6gD0mJIjHm0soe7yymx1DIRBTurM?=
 =?us-ascii?Q?7Zf8hH+e2cn4h/ERCzeHwiEuWuVzVMGnWug2ouLzzvuyhxbYnLP6EdK82wrt?=
 =?us-ascii?Q?VJvltBa1xXT3jhBe96dhMXC9k49ztdvou1dwZvq92h1zCHzSJYuooiX1RSlL?=
 =?us-ascii?Q?sa9Oun795/yeYfZEWdhrUZwKpi6GVXv1/etER/QIwAxfTNMiknP0dlSXQ95y?=
 =?us-ascii?Q?8c5GEzxnMoK1LiWYUKPg9QsLhlruoLrgHMpFV8r/K53qaKeK+2a9uxD4zgTD?=
 =?us-ascii?Q?10JOBj/AGCIE1yC64H9X7NxJSZkQMt3B+awVO5cac7GuUyxSnYukNvtZjO7t?=
 =?us-ascii?Q?ugwDXvro0KqXv3CLpUzEDa/B5tuFgik/TjNtUWmsnTBdYmsTJ8ST2vvoZmut?=
 =?us-ascii?Q?rJyGtZFu+Bu4+SzbOxjvU9/bzSm0ReZvCX5NerpTVfZ+NkgRTsnwpMow9S86?=
 =?us-ascii?Q?UcdtqqKx5cXQM4emKb4XRpPbC+J2YD9tgY8plbcec3pj9P/DJC13nyGrgVDV?=
 =?us-ascii?Q?IbOgpX7ZzXdepdJJT1e8EXB1gmjTz3wYIGPOO04smWkDLKLaj5ZZEGEgUMrf?=
 =?us-ascii?Q?iCAtUbbbiZ69RSbDQcVLlTuS32x0al7drenFP6CGNYB/wSvFoOS7YjTkPVeJ?=
 =?us-ascii?Q?5V2G4oh9T5/oJNVQSu3WocX1pTjlzjNvK/81LMQdmk8BUiPXxZwDW7LbLA7g?=
 =?us-ascii?Q?xIxbiu+vGpDKOeoo4ADzcX0VtUGRR6mEz5jPa42CExGpD4v9xhQ9vow1yWnW?=
 =?us-ascii?Q?ps0ADujZVEaTcZ7qVgsBl0JvrbnLBCug7kCkHqyE5e/znif2YpmcAFWMGSEr?=
 =?us-ascii?Q?n9i9FAq4D9KIakktatxnS6g5nym7gzifswHxAz2xypbbyuwqqI/kiLaRsaGT?=
 =?us-ascii?Q?kwPuloxHpVV9L5h46u1ns7X+fnEmfkbVBHqqoZsBfPsu9vtmc1o7Oys1Hzfu?=
 =?us-ascii?Q?C3hSEqfkQUMNP40HKG6SmW8EM0yHE6QKLo+iue/TJVhtOQ3YFnzGj8ptrk08?=
 =?us-ascii?Q?dNSHcRj4efT5yxTGh1qdYvMJgJ/5jrir0fhbB0Rs1RuqTZf2U8yGrif4vdin?=
 =?us-ascii?Q?prqLLTlj4XKhQ+i2xJTF54Ik?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c163b72-0fe9-4bfd-0352-08d960b9edcc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:29:52.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rWEPV03NRAUiRUUvi9KJsYFtUPQUqI/V0KV4yGKQSAPqJlHyywxul63iprQt4kYk8ldDAaZfyeEVfQdYHBwGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Add a new kvm_mirror_vcpu_thread_fn() which is qemu's mirror vcpu
thread and the corresponding kvm_init_mirror_vcpu() which creates
the vcpu's for the mirror VM and a different KVM run loop
kvm_mirror_cpu_exec() which differs from the main KVM run loop as
it currently mainly handles IO and MMIO exits, does not handle
any interrupt exits as the mirror VM does not have an interrupt
controller. This mirror vcpu run loop can be further optimized.

Also, we have a different kvm_arch_put_registers() for mirror
vcpu's as we dont' save/restore MSRs currently for mirror vcpu's,
kvm_put_msrs() fails for mirror vcpu's as mirror VM does not have
any interrupt controller such as the in-kernel irqchip controller.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-accel-ops.c |  45 ++++++++-
 accel/kvm/kvm-all.c       | 191 +++++++++++++++++++++++++++++++++++++-
 accel/kvm/kvm-cpus.h      |   2 +
 include/sysemu/kvm.h      |   1 +
 target/i386/kvm/kvm.c     |  42 +++++++++
 5 files changed, 277 insertions(+), 4 deletions(-)

diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 7516c67a3f..e49a14e58c 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -61,6 +61,42 @@ static void *kvm_vcpu_thread_fn(void *arg)
     return NULL;
 }
 
+static void *kvm_mirror_vcpu_thread_fn(void *arg)
+{
+    CPUState *cpu = arg;
+    int r;
+
+    rcu_register_thread();
+
+    qemu_mutex_lock_iothread();
+    qemu_thread_get_self(cpu->thread);
+    cpu->thread_id = qemu_get_thread_id();
+    cpu->can_do_io = 1;
+
+    r = kvm_init_mirror_vcpu(cpu, &error_fatal);
+    kvm_init_cpu_signals(cpu);
+
+    /* signal CPU creation */
+    cpu_thread_signal_created(cpu);
+    qemu_guest_random_seed_thread_part2(cpu->random_seed);
+
+    do {
+        if (cpu_can_run(cpu)) {
+            r = kvm_mirror_cpu_exec(cpu);
+            if (r == EXCP_DEBUG) {
+                cpu_handle_guest_debug(cpu);
+            }
+        }
+        qemu_wait_io_event(cpu);
+    } while (!cpu->unplug || cpu_can_run(cpu));
+
+    kvm_destroy_vcpu(cpu);
+    qemu_mutex_unlock_iothread();
+    cpu_thread_signal_destroyed(cpu);
+    rcu_unregister_thread();
+    return NULL;
+}
+
 static void kvm_start_vcpu_thread(CPUState *cpu)
 {
     char thread_name[VCPU_THREAD_NAME_SIZE];
@@ -70,8 +106,13 @@ static void kvm_start_vcpu_thread(CPUState *cpu)
     qemu_cond_init(cpu->halt_cond);
     snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/KVM",
              cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, kvm_vcpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
+    if (!cpu->mirror_vcpu) {
+        qemu_thread_create(cpu->thread, thread_name, kvm_vcpu_thread_fn,
+                            cpu, QEMU_THREAD_JOINABLE);
+    } else {
+        qemu_thread_create(cpu->thread, thread_name, kvm_mirror_vcpu_thread_fn,
+                           cpu, QEMU_THREAD_JOINABLE);
+    }
 }
 
 static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 4bc5971881..f14b33dde1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2294,6 +2294,55 @@ bool kvm_vcpu_id_is_valid(int vcpu_id)
     return vcpu_id >= 0 && vcpu_id < kvm_max_vcpu_id(s);
 }
 
+int kvm_init_mirror_vcpu(CPUState *cpu, Error **errp)
+{
+    KVMState *s = kvm_state;
+    long mmap_size;
+    int ret;
+
+    ret =  kvm_mirror_vm_ioctl(s, KVM_CREATE_VCPU, kvm_arch_vcpu_id(cpu));
+    if (ret < 0) {
+        error_setg_errno(errp, -ret,
+                         "kvm_init_mirror_vcpu: kvm_get_vcpu failed");
+        goto err;
+    }
+
+    cpu->kvm_fd = ret;
+    cpu->kvm_state = s;
+    cpu->vcpu_dirty = true;
+
+    mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
+    if (mmap_size < 0) {
+        ret = mmap_size;
+        error_setg_errno(errp, -mmap_size,
+                         "kvm_init_mirror_vcpu: KVM_GET_VCPU_MMAP_SIZE failed");
+        goto err;
+    }
+
+    cpu->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED,
+                        cpu->kvm_fd, 0);
+    if (cpu->kvm_run == MAP_FAILED) {
+        ret = -errno;
+        error_setg_errno(errp, ret,
+                         "kvm_init_mirror_vcpu: mmap'ing vcpu state failed");
+    }
+
+    if (s->coalesced_mmio && !s->coalesced_mmio_ring) {
+        s->coalesced_mmio_ring =
+            (void *)cpu->kvm_run + s->coalesced_mmio * PAGE_SIZE;
+    }
+
+    ret = kvm_arch_init_vcpu(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret,
+                         "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
+                         kvm_arch_vcpu_id(cpu));
+    }
+
+err:
+    return ret;
+}
+
 static int kvm_init(MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
@@ -2717,7 +2766,11 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
 
 static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
 {
-    kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE);
+    if (!cpu->mirror_vcpu) {
+        kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE);
+    } else {
+        kvm_arch_mirror_put_registers(cpu, KVM_PUT_RESET_STATE);
+    }
     cpu->vcpu_dirty = false;
 }
 
@@ -2728,7 +2781,11 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu)
 
 static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
 {
-    kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
+    if (!cpu->mirror_vcpu) {
+        kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
+    } else {
+        kvm_arch_mirror_put_registers(cpu, KVM_PUT_FULL_STATE);
+    }
     cpu->vcpu_dirty = false;
 }
 
@@ -2968,6 +3025,136 @@ int kvm_cpu_exec(CPUState *cpu)
     return ret;
 }
 
+int kvm_mirror_cpu_exec(CPUState *cpu)
+{
+    struct kvm_run *run = cpu->kvm_run;
+    int ret, run_ret = 0;
+
+    DPRINTF("kvm_mirror_cpu_exec()\n");
+    assert(cpu->mirror_vcpu == TRUE);
+
+    qemu_mutex_unlock_iothread();
+    cpu_exec_start(cpu);
+
+    do {
+        MemTxAttrs attrs;
+
+        if (cpu->vcpu_dirty) {
+            kvm_arch_mirror_put_registers(cpu, KVM_PUT_RUNTIME_STATE);
+            cpu->vcpu_dirty = false;
+        }
+
+        kvm_arch_pre_run(cpu, run);
+        if (qatomic_read(&cpu->exit_request)) {
+            DPRINTF("interrupt exit requested\n");
+            /*
+             * KVM requires us to reenter the kernel after IO exits to complete
+             * instruction emulation. This self-signal will ensure that we
+             * leave ASAP again.
+             */
+            kvm_cpu_kick_self();
+        }
+
+        /*
+         * Read cpu->exit_request before KVM_RUN reads run->immediate_exit.
+         * Matching barrier in kvm_eat_signals.
+         */
+        smp_rmb();
+
+        run_ret = kvm_vcpu_ioctl(cpu, KVM_RUN, 0);
+
+        attrs = kvm_arch_post_run(cpu, run);
+
+        if (run_ret < 0) {
+            if (run_ret == -EINTR || run_ret == -EAGAIN) {
+                DPRINTF("io window exit\n");
+                kvm_eat_signals(cpu);
+                ret = EXCP_INTERRUPT;
+                break;
+            }
+            fprintf(stderr, "error: kvm run failed %s\n",
+                    strerror(-run_ret));
+            ret = -1;
+            break;
+        }
+
+        trace_kvm_run_exit(cpu->cpu_index, run->exit_reason);
+        switch (run->exit_reason) {
+        case KVM_EXIT_IO:
+            DPRINTF("handle_io\n");
+            /* Called outside BQL */
+            kvm_handle_io(run->io.port, attrs,
+                          (uint8_t *)run + run->io.data_offset,
+                          run->io.direction,
+                          run->io.size,
+                          run->io.count);
+           ret = 0;
+            break;
+        case KVM_EXIT_MMIO:
+            DPRINTF("handle_mmio\n");
+            /* Called outside BQL */
+            address_space_rw(&address_space_memory,
+                             run->mmio.phys_addr, attrs,
+                             run->mmio.data,
+                             run->mmio.len,
+                             run->mmio.is_write);
+            ret = 0;
+            break;
+        case KVM_EXIT_SHUTDOWN:
+            DPRINTF("shutdown\n");
+            qemu_system_reset_request(SHUTDOWN_CAUSE_GUEST_RESET);
+            ret = EXCP_INTERRUPT;
+            break;
+        case KVM_EXIT_UNKNOWN:
+            fprintf(stderr, "KVM: unknown exit, hardware reason %" PRIx64 "\n",
+                    (uint64_t)run->hw.hardware_exit_reason);
+            ret = -1;
+            break;
+        case KVM_EXIT_INTERNAL_ERROR:
+            ret = kvm_handle_internal_error(cpu, run);
+            break;
+        case KVM_EXIT_SYSTEM_EVENT:
+            switch (run->system_event.type) {
+            case KVM_SYSTEM_EVENT_SHUTDOWN:
+                qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
+                ret = EXCP_INTERRUPT;
+                break;
+            case KVM_SYSTEM_EVENT_RESET:
+                qemu_system_reset_request(SHUTDOWN_CAUSE_GUEST_RESET);
+                ret = EXCP_INTERRUPT;
+                break;
+            case KVM_SYSTEM_EVENT_CRASH:
+                kvm_cpu_synchronize_state(cpu);
+                qemu_mutex_lock_iothread();
+                qemu_system_guest_panicked(cpu_get_crash_info(cpu));
+                qemu_mutex_unlock_iothread();
+                ret = 0;
+                break;
+            default:
+                DPRINTF("kvm_arch_handle_exit\n");
+                ret = kvm_arch_handle_exit(cpu, run);
+                break;
+            }
+            break;
+        default:
+            DPRINTF("kvm_arch_handle_exit\n");
+            ret = kvm_arch_handle_exit(cpu, run);
+            break;
+        }
+    } while (ret == 0);
+
+    cpu_exec_end(cpu);
+    qemu_mutex_lock_iothread();
+
+    if (ret < 0) {
+        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
+        vm_stop(RUN_STATE_INTERNAL_ERROR);
+    }
+
+    qatomic_set(&cpu->exit_request, 0);
+    return ret;
+}
+
 int kvm_ioctl(KVMState *s, int type, ...)
 {
     int ret;
diff --git a/accel/kvm/kvm-cpus.h b/accel/kvm/kvm-cpus.h
index bf0bd1bee4..c8c7e52bcd 100644
--- a/accel/kvm/kvm-cpus.h
+++ b/accel/kvm/kvm-cpus.h
@@ -13,7 +13,9 @@
 #include "sysemu/cpus.h"
 
 int kvm_init_vcpu(CPUState *cpu, Error **errp);
+int kvm_init_mirror_vcpu(CPUState *cpu, Error **errp);
 int kvm_cpu_exec(CPUState *cpu);
+int kvm_mirror_cpu_exec(CPUState *cpu);
 void kvm_destroy_vcpu(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 6847ffcdfd..03e7b5afa0 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -352,6 +352,7 @@ int kvm_arch_get_registers(CPUState *cpu);
 #define KVM_PUT_FULL_STATE      3
 
 int kvm_arch_put_registers(CPUState *cpu, int level);
+int kvm_arch_mirror_put_registers(CPUState *cpu, int level);
 
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e69abe48e3..d6d52a06bc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4154,6 +4154,48 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
     return 0;
 }
 
+int kvm_arch_mirror_put_registers(CPUState *cpu, int level)
+{
+    X86CPU *x86_cpu = X86_CPU(cpu);
+    int ret;
+
+    assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
+
+    /* must be before kvm_put_nested_state so that EFER.SVME is set */
+    ret = kvm_put_sregs(x86_cpu);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (level == KVM_PUT_FULL_STATE) {
+        /*
+         * We don't check for kvm_arch_set_tsc_khz() errors here,
+         * because TSC frequency mismatch shouldn't abort migration,
+         * unless the user explicitly asked for a more strict TSC
+         * setting (e.g. using an explicit "tsc-freq" option).
+         */
+        kvm_arch_set_tsc_khz(cpu);
+    }
+
+    ret = kvm_getput_regs(x86_cpu, 1);
+    if (ret < 0) {
+        return ret;
+    }
+    ret = kvm_put_xsave(x86_cpu);
+    if (ret < 0) {
+        return ret;
+    }
+    ret = kvm_put_xcrs(x86_cpu);
+    if (ret < 0) {
+        return ret;
+    }
+    ret = kvm_put_debugregs(x86_cpu);
+    if (ret < 0) {
+        return ret;
+    }
+    return 0;
+}
+
 int kvm_arch_get_registers(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
-- 
2.17.1

