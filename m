Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F7B204F8D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbgFWKvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:51:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38634 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732272AbgFWKvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592909481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7T6k8rDooEOp5R0yTFBiO/Qp4O8fYn54pnxO67whtxE=;
        b=KarctHrYE5Np/mrk6518E8Q346eiZwVc7U133jg2Dq27kmy9RvPv84ieu9o5/aYBrKwVx9
        J1tVO+qdBrT3uOS88/KL1D6JGcxrwCUj3Yrl/CZYg1lc1+/UdD9Gd0yZEhSacEBo3A08p6
        VYj0+Z7kClEUNp5RdyQzzLbdXTe7X0o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-wfumROQmMN-Ij55J2IbkVQ-1; Tue, 23 Jun 2020 06:51:19 -0400
X-MC-Unique: wfumROQmMN-Ij55J2IbkVQ-1
Received: by mail-wm1-f70.google.com with SMTP id l2so3487356wmi.2
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7T6k8rDooEOp5R0yTFBiO/Qp4O8fYn54pnxO67whtxE=;
        b=VPhpcgSZBjIfOPR3AfWSvnfTQDgyl0rmTagmTlao9BNl7r72+nd9u+5eEMySduJFGp
         g1zhYxUDjhY6DaKF17p04M17beFuvgqPA1O40obgufU3eGg6WmDa/k+WL82SmPOsvUB8
         Qm4tO9lDMAcILAlMoK00Gwar2g/I0trB0c8vDKUxCc4DjEuz/SQHaTMQnIXpKk6nMSNU
         Q66LVf4rCBzZJWcpwybirb5n/tqxOgZFBCNPlqnusbYtAytYQtGNKefHoTaPxJ/VCsTm
         dVMNb94cOz6j3MXXZjcz3AwFu9aT/qP5LNxOpKfuu/+io3MyfFU40KyPEmkYgyAOnRJY
         AREw==
X-Gm-Message-State: AOAM530LBfOIgNBTlwC5/aXlwlZ2MY9hEYBwLHP5FJBriaiiarO1bXYY
        Tu37ZH+GIO8gt+Keytqsi7jR8k8NsCdWtbhl/wP3cmr5HD7zZJwHbVPVF9DFVKnHfY09kK8Z4OV
        +/sRd+ec6QNLL
X-Received: by 2002:a1c:49c1:: with SMTP id w184mr22722078wma.46.1592909478434;
        Tue, 23 Jun 2020 03:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKlUNG19p2ou+jCN0MXVN7uyCXrtT3qGTGAn5SMFlQPMWCuwgEDnxemEGRDjqST39js2Ao/w==
X-Received: by 2002:a1c:49c1:: with SMTP id w184mr22722054wma.46.1592909478207;
        Tue, 23 Jun 2020 03:51:18 -0700 (PDT)
Received: from localhost.localdomain (1.red-83-51-162.dynamicip.rima-tde.net. [83.51.162.1])
        by smtp.gmail.com with ESMTPSA id s18sm24085181wra.85.2020.06.23.03.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:17 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [RFC PATCH 4/7] accel/kvm: Simplify kvm_set_sigmask_len()
Date:   Tue, 23 Jun 2020 12:50:49 +0200
Message-Id: <20200623105052.1700-5-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200623105052.1700-1-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sigmask_len is a property of the accelerator, not the VM.
Simplify by directly using the global kvm_state, remove the
unnecessary KVMState* argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/kvm.h | 2 +-
 accel/kvm/kvm-all.c  | 4 ++--
 target/mips/kvm.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 3662641c99..44c1767a7f 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -469,7 +469,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
 uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index);
 
 
-void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len);
+void kvm_set_sigmask_len(unsigned int sigmask_len);
 
 #if !defined(CONFIG_USER_ONLY)
 int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index afd14492a0..7b3f76f23d 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2240,9 +2240,9 @@ err:
     return ret;
 }
 
-void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len)
+void kvm_set_sigmask_len(unsigned int sigmask_len)
 {
-    s->sigmask_len = sigmask_len;
+    kvm_state->sigmask_len = sigmask_len;
 }
 
 static void kvm_handle_io(uint16_t port, MemTxAttrs attrs, void *data, int direction,
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index 0adfa70210..cc3e09bdef 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -48,7 +48,7 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     /* MIPS has 128 signals */
-    kvm_set_sigmask_len(s, 16);
+    kvm_set_sigmask_len(16);
 
     kvm_mips_fpu_cap = kvm_check_extension(KVM_CAP_MIPS_FPU);
     kvm_mips_msa_cap = kvm_check_extension(KVM_CAP_MIPS_MSA);
-- 
2.21.3

