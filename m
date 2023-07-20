Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61F375A7C6
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 09:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjGTH31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 03:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTH3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 03:29:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C162107
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 00:29:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b895a06484so2897585ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 00:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1689838164; x=1690442964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu0o/wcEkbfTyvDOhAFRVRnQlN6I6R0hj4RBolX2hdg=;
        b=oVH5QTZbrvnHyydotdMaw7OEyZnGgENiFoLjcYkF94dYXXrP5cCqtMYTXhtgwnqgtU
         1laKHVI6VGEr6FAFlMN6eCvT87ouu1pt/yFRJ+HeiTET0IsHJeWKomR5VOcrFpYla+1a
         jkveSDT7ASJdJ9zykl1PY+3ByvNl2O5gcHPqXgUP//cd40PUzYI3GoDX2oDfAsDk2RD2
         z2vGArKL7EXDROz/73thV/lkO9tEGscXjjc1EhPW9FGRX4+AYPnUjSfcTonBmPgPNo0z
         wWaBza1jE6vXrOs1I2SOiTdnE4em5RZ4a0SxZWsk7P6iWAGK3W8lTWrARYT3G2OJfmWH
         FuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689838164; x=1690442964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zu0o/wcEkbfTyvDOhAFRVRnQlN6I6R0hj4RBolX2hdg=;
        b=OKW0YtrWrwER67jJFvlr1uIfpb7F3wMfhMf46e65yDLhr0KaG831JhhXeiI52i0Tt6
         sFAs/2nETyOSIvlNRRw4uJC005lR29PozaOldA9b9EW15aszFGXg1o0qozzwMt8CmQxq
         EPiES2Kfh/yPopKWToaLMSYcdNmHtg+k55wnORLzhtWrxLQksYxDD2/T0cLI2st29f28
         a2DMzIb3PQqhte7GvJGm42oK257lo3EremJbHrfIjjDTj83uYN6bet2FfDMazdNQ1p2O
         Flx+fPevzafQUMORm4RXm5oJ/BDz2o2EBEZ3P0a0ycjBbIyObdFq+SidMzrM3OOuKsXa
         aP5A==
X-Gm-Message-State: ABy/qLaq78Aqn1XAyxunggPGJ5JBBswXCv1pv6sxrR1EsFSH8kR7zyZY
        jB5bHJQ+lZM5VF1F3tyS/qhxxQ==
X-Google-Smtp-Source: APBJJlFhGOYHcvYIXC/iflDORll+mgeCYw2iOdPaeX9f8sxzj4VRPaKE5N19hcP12/8zHpBL9WY1cA==
X-Received: by 2002:a17:902:ab57:b0:1b8:59f0:c748 with SMTP id ij23-20020a170902ab5700b001b859f0c748mr1160084plb.2.1689838163988;
        Thu, 20 Jul 2023 00:29:23 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id jh5-20020a170903328500b001bb3beb2bc6sm548433plb.65.2023.07.20.00.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 00:29:23 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH RESEND] accel/kvm: Specify default IPA size for arm64
Date:   Thu, 20 Jul 2023 16:29:01 +0900
Message-ID: <20230720072903.21390-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

libvirt uses "none" machine type to test KVM availability. Before this
change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.

The kernel documentation says:
> On arm64, the physical address size for a VM (IPA Size limit) is
> limited to 40bits by default. The limit can be configured if the host
> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
> identifier, where IPA_Bits is the maximum width of any physical
> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
> machine type identifier.
>
> e.g, to configure a guest to use 48bit physical address size::
>
>     vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
>
> The requested size (IPA_Bits) must be:
>
>  ==   =========================================================
>   0   Implies default size, 40bits (for backward compatibility)
>   N   Implies N bits, where N is a positive integer such that,
>       32 <= N <= Host_IPA_Limit
>  ==   =========================================================

> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
> and is dependent on the CPU capability and the kernel configuration.
> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
> KVM_CHECK_EXTENSION ioctl() at run-time.
>
> Creation of the VM will fail if the requested IPA size (whether it is
> implicit or explicit) is unsupported on the host.
https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm

So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
incorrectly thinks KVM is not available. This actually happened on M2
MacBook Air.

Fix this by specifying 32 for IPA_Bits as any arm64 system should
support the value according to the documentation.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Resending due to inactivity.

 accel/kvm/kvm-all.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 373d876c05..3bd362e346 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2458,7 +2458,11 @@ static int kvm_init(MachineState *ms)
     KVMState *s;
     const KVMCapabilityInfo *missing_cap;
     int ret;
+#ifdef TARGET_AARCH64
+    int type = 32;
+#else
     int type = 0;
+#endif
     uint64_t dirty_log_manual_caps;
 
     qemu_mutex_init(&kml_slots_lock);
-- 
2.41.0

