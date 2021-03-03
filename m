Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4A32C704
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355559AbhCDAax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349972AbhCCS2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSKZ4U4zBdXHSKAtMYPcidB9tymokaAa3vsPtMUAjQM=;
        b=UwKdpZ1nWDEUR9Na3W8c6y3X7eG9HptX0N+broIzxwpVqjJXUYmUZoNbMciL6g4PgvXVLD
        rBdHKpIYeMLCrylp58Y7ClJA/nGvQIv6l7/LieJKkrDtT3h4cj2z+4OeSov9MXpGa+Tqln
        PjHLsd6KfeY16ukxzN1NaBuoWrIxXUY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-0GCsvNzBNFefE902uqd7SA-1; Wed, 03 Mar 2021 13:23:02 -0500
X-MC-Unique: 0GCsvNzBNFefE902uqd7SA-1
Received: by mail-wr1-f69.google.com with SMTP id v13so12194834wrs.21
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:23:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JSKZ4U4zBdXHSKAtMYPcidB9tymokaAa3vsPtMUAjQM=;
        b=d33wMCDZ2wIhiRNO4GKAmJ8V5/nSgD3GaqMZp2ub8FUsTdKj2Ol4sz3/3dRIDzyYUA
         pvpgOL3+uXJJRKYJqQwxCqTHRjBCwyfMBa47Af4rRE33qqBSMbZMDXw64WboKalTMpOj
         2OISAy1m1kPmLLb6Te8buq8inBXrcjSSjbskx0887IPQPxT2+49Zla91dqmgbLZsxhfq
         HwTat3g5Editt62tdtodXg+4HbrZKVD+BsE55lfL71ouW14+mYyR+H9tfeMtAQTF7f8H
         lhrLkUR3g5LaOnHuHjWaQqHQZkdnu9bgO9z9HEjqizyRPVgldAr/ywcynySpRrpw/e0C
         yxPw==
X-Gm-Message-State: AOAM530SdgS75/O3p8nAhGpdADzQ+XUmeDfsv92dRB/X6Ec8x5aZ/2CM
        u5EwxzxV5tcyHc//9ORj3YOsYce3LWps4ru4yAIkY4ghEkE6ZGDNyVSw0GI7pjmzlWqicd7vQqH
        OzfsrLGnWP5Cf
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr295363wmq.56.1614795781333;
        Wed, 03 Mar 2021 10:23:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkfTopuTz8+rr5+ZCkXuINfRYff1lmKq7JTlmgWuTa8IXYSH/Sikf55e2yiTGalQ+YvZXOhQ==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr295331wmq.56.1614795781060;
        Wed, 03 Mar 2021 10:23:01 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id a131sm6749075wmc.48.2021.03.03.10.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:23:00 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 06/19] accel/whpx: Add typedef for 'struct whpx_vcpu'
Date:   Wed,  3 Mar 2021 19:22:06 +0100
Message-Id: <20210303182219.1631042-7-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the 'whpx_vcpu' typedef instead of 'struct whpx_vcpu'.
This will make the next commits easier to review.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/whpx/whpx-all.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index f0a35df3bba..6469e388b6d 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -148,6 +148,8 @@ struct whpx_register_set {
     WHV_REGISTER_VALUE values[RTL_NUMBER_OF(whpx_register_names)];
 };
 
+typedef struct whpx_vcpu whpx_vcpu;
+
 struct whpx_vcpu {
     WHV_EMULATOR_HANDLE emulator;
     bool window_registered;
@@ -173,9 +175,9 @@ struct WHPDispatch whp_dispatch;
  * VP support
  */
 
-static struct whpx_vcpu *get_whpx_vcpu(CPUState *cpu)
+static whpx_vcpu *get_whpx_vcpu(CPUState *cpu)
 {
-    return (struct whpx_vcpu *)cpu->hax_vcpu;
+    return (whpx_vcpu *)cpu->hax_vcpu;
 }
 
 static WHV_X64_SEGMENT_REGISTER whpx_seg_q2h(const SegmentCache *qs, int v86,
@@ -259,7 +261,7 @@ static int whpx_set_tsc(CPUState *cpu)
 static void whpx_set_registers(CPUState *cpu, int level)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct whpx_register_set vcxt;
@@ -448,7 +450,7 @@ static int whpx_get_tsc(CPUState *cpu)
 static void whpx_get_registers(CPUState *cpu)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
     struct whpx_register_set vcxt;
@@ -712,7 +714,7 @@ static const WHV_EMULATOR_CALLBACKS whpx_emu_callbacks = {
 static int whpx_handle_mmio(CPUState *cpu, WHV_MEMORY_ACCESS_CONTEXT *ctx)
 {
     HRESULT hr;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     WHV_EMULATOR_STATUS emu_status;
 
     hr = whp_dispatch.WHvEmulatorTryMmioEmulation(
@@ -737,7 +739,7 @@ static int whpx_handle_portio(CPUState *cpu,
                               WHV_X64_IO_PORT_ACCESS_CONTEXT *ctx)
 {
     HRESULT hr;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     WHV_EMULATOR_STATUS emu_status;
 
     hr = whp_dispatch.WHvEmulatorTryIoEmulation(
@@ -780,7 +782,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
 {
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
     int irq;
@@ -902,7 +904,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
 
 static void whpx_vcpu_post_run(CPUState *cpu)
 {
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
 
@@ -929,7 +931,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
 {
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
 
     if ((cpu->interrupt_request & CPU_INTERRUPT_INIT) &&
         !(env->hflags & HF_SMM_MASK)) {
@@ -968,7 +970,7 @@ static int whpx_vcpu_run(CPUState *cpu)
 {
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
     int ret;
 
     whpx_vcpu_process_async_events(cpu);
@@ -1331,7 +1333,7 @@ int whpx_init_vcpu(CPUState *cpu)
 {
     HRESULT hr;
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = NULL;
+    whpx_vcpu *vcpu = NULL;
     Error *local_error = NULL;
     struct CPUX86State *env = (CPUArchState *)(cpu->env_ptr);
     X86CPU *x86_cpu = X86_CPU(cpu);
@@ -1356,7 +1358,7 @@ int whpx_init_vcpu(CPUState *cpu)
         }
     }
 
-    vcpu = g_malloc0(sizeof(struct whpx_vcpu));
+    vcpu = g_malloc0(sizeof(whpx_vcpu));
 
     if (!vcpu) {
         error_report("WHPX: Failed to allocte VCPU context.");
@@ -1475,7 +1477,7 @@ int whpx_vcpu_exec(CPUState *cpu)
 void whpx_destroy_vcpu(CPUState *cpu)
 {
     struct whpx_state *whpx = &whpx_global;
-    struct whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
+    whpx_vcpu *vcpu = get_whpx_vcpu(cpu);
 
     whp_dispatch.WHvDeleteVirtualProcessor(whpx->partition, cpu->cpu_index);
     whp_dispatch.WHvEmulatorDestroyEmulator(vcpu->emulator);
-- 
2.26.2

