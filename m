Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A44608E37
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJVPsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJVPsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D40250282
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDSXo8hsV8NzzkWo+KouABAzM9HOiQi26MuXJl4LsjA=;
        b=QK0AZ7vbjsk0ALDQ3FQRy3VLy9OODV+wj+t1iEy3us8gjbPgtPp4Qv5M/s1JTddqTM0Grv
        dRDM5E7VrFqyyfhTG4xTyTuVgHNsRN8UIEXRuWG44NDkjBqMN+HId5oTFrzlKIycM2ocQj
        qF4iBD96uUo21xF9udDbJMG6CUqJi+0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-6wXycPoUPqGmjo96iTbJBQ-1; Sat, 22 Oct 2022 11:48:23 -0400
X-MC-Unique: 6wXycPoUPqGmjo96iTbJBQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD53585A583;
        Sat, 22 Oct 2022 15:48:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F96D4A9268;
        Sat, 22 Oct 2022 15:48:22 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 2/4] KVM: introduce kvm_clear_all_cpus_request
Date:   Sat, 22 Oct 2022 11:48:17 -0400
Message-Id: <20221022154819.1823133-3-eesposit@redhat.com>
In-Reply-To: <20221022154819.1823133-1-eesposit@redhat.com>
References: <20221022154819.1823133-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear the given request in all vcpus of the VM with struct kvm.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 Documentation/virt/kvm/vcpu-requests.rst |  3 +++
 virt/kvm/kvm_main.c                      | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 31f62b64e07b..468410dfe84d 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -36,6 +36,9 @@ its TLB with a VCPU request.  The API consists of the following functions::
   /* Make request @req of all VCPUs of the VM with struct kvm @kvm. */
   bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
+  /* Clear request @req of all VCPUs of the VM with struct kvm @kvm. */
+  void kvm_clear_all_cpus_request(struct kvm *kvm, unsigned int req);
+
 Typically a requester wants the VCPU to perform the activity as soon
 as possible after making the request.  This means most requests
 (kvm_make_request() calls) are followed by a call to kvm_vcpu_kick(),
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..c080b93edc0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -355,6 +355,16 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 }
 EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
+void kvm_clear_all_cpus_request(struct kvm *kvm, unsigned int req)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_clear_request(req, vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_clear_all_cpus_request);
+
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-- 
2.31.1

