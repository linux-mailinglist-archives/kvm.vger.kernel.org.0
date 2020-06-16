Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009AC1FBC34
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgFPQ6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:58:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728861AbgFPQ6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 12:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592326729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2naFO3eclxh//d8xCYs/AzrLY0N7rdJ2y7/KIjLVWcw=;
        b=UzRJUaJPme5r91VRJgYXgYtUPsdl17b9wngTILn3mxi8mP8L6hO6zCZx/5Ukkv6tfdL2uY
        DXC92PfwSaA98O6ygwqHnIL128QR7bzTidlFspavE85DxTGPg6//scQiqAOHwy4G+YjONK
        M20z6ZZ/owO48Nbi5QWKCyV+BsFvUXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-5cKJ0fWnNB6C7W_m0zQ0sA-1; Tue, 16 Jun 2020 12:58:48 -0400
X-MC-Unique: 5cKJ0fWnNB6C7W_m0zQ0sA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C09F80F5E5;
        Tue, 16 Jun 2020 16:58:47 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-9.gru2.redhat.com [10.97.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF1BF19C79;
        Tue, 16 Jun 2020 16:58:46 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 43FBB41887FC; Tue, 16 Jun 2020 13:58:05 -0300 (-03)
Date:   Tue, 16 Jun 2020 13:58:05 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     qemu-devel <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH v2] kvm: i386: allow TSC to differ by NTP correction bounds
 without TSC scaling
Message-ID: <20200616165805.GA324612@fuller.cnet>
References: <20200615120127.GB224592@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615120127.GB224592@fuller.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


The Linux TSC calibration procedure is subject to small variations
(its common to see +-1 kHz difference between reboots on a given CPU, for example).

So migrating a guest between two hosts with identical processor can fail, in case 
of a small variation in calibrated TSC between them.

Allow a conservative 250ppm error between host TSC and VM TSC frequencies,
rather than requiring an exact match. NTP daemon in the guest can
correct this difference.

Also change migration to accept this bound.

KVM_SET_TSC_KHZ depends on a kernel interface change. Without this change,
the behaviour remains the same: in case of a different frequency 
between host and VM, KVM_SET_TSC_KHZ will fail and QEMU will exit.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---

v2: ensure behaviour is unchanged for older kernels and
    improve changelogs (Paolo)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 34f8387..ad825b1 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -735,26 +735,62 @@ static bool hyperv_enabled(X86CPU *cpu)
          cpu->hyperv_features || cpu->hyperv_passthrough);
 }
 
+/*
+ * Check whether target_freq is within conservative
+ * ntp correctable bounds (250ppm) of freq
+ */
+static inline bool freq_within_bounds(int freq, int target_freq)
+{
+        int max_freq = freq + (freq * 250 / 1000000);
+        int min_freq = freq - (freq * 250 / 1000000);
+
+        if (target_freq >= min_freq && target_freq <= max_freq) {
+                return true;
+        }
+
+        return false;
+}
+
 static int kvm_arch_set_tsc_khz(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    int r;
+    int r, cur_freq;
+    bool set_ioctl = false;
 
     if (!env->tsc_khz) {
         return 0;
     }
 
-    r = kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL) ?
+    cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+               kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) : -ENOTSUP;
+
+    /*
+     * If TSC scaling is supported, attempt to set TSC frequency.
+     */
+    if (kvm_check_extension(cs->kvm_state, KVM_CAP_TSC_CONTROL)) {
+        set_ioctl = true;
+    }
+
+    /*
+     * If desired TSC frequency is within bounds of NTP correction,
+     * attempt to set TSC frequency.
+     */
+    if (cur_freq != -ENOTSUP && freq_within_bounds(cur_freq, env->tsc_khz)) {
+        set_ioctl = true;
+    }
+
+    r = set_ioctl ?
         kvm_vcpu_ioctl(cs, KVM_SET_TSC_KHZ, env->tsc_khz) :
         -ENOTSUP;
+
     if (r < 0) {
         /* When KVM_SET_TSC_KHZ fails, it's an error only if the current
          * TSC frequency doesn't match the one we want.
          */
-        int cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
-                       kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
-                       -ENOTSUP;
+        cur_freq = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+                   kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
+                   -ENOTSUP;
         if (cur_freq <= 0 || cur_freq != env->tsc_khz) {
             warn_report("TSC frequency mismatch between "
                         "VM (%" PRId64 " kHz) and host (%d kHz), "

