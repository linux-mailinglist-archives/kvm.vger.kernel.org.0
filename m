Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6139475DA53
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjGVGXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 02:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjGVGXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 02:23:11 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2D0EB
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 23:23:11 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b9e478e122so2382217a34.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 23:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690006990; x=1690611790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiO61RFWQc576A2x8jBmto7Eq50nA+0j/FFgWXdA55I=;
        b=hgwh4xKwD6Cu9z8Rs6iTIcQTBX5rYYn71p9QkLR9APikor7gEDD/qjke1FXbNnmBBb
         yz/6yGgg2hmz3nsJRUKsMeKrnosf8i9Dqlp5AQoVrMJDDS1xzziNIDm5rPEuuCr62frx
         mBrrhE+ODRiwmsjt4NudoC0PRpebzUISSExHamYBQzfmd3QTs2Kr7MLkpts3wbclBb6I
         /HWPPU853maBPTYhnDtPyhhQ5OTXU9QsK8boN37SQj0jb6QP1wX0SN8QdUh0iDw3Kmia
         Ng9+IRGnIQFZRTNzCxgGBxYcR0juQ1NTUoa/5kFdLWGtcUxzzr6WxR9D9/KvZsbDTgK0
         7UpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690006990; x=1690611790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiO61RFWQc576A2x8jBmto7Eq50nA+0j/FFgWXdA55I=;
        b=Sm5cPfLmUgiisluB+JiRB/mNmcygRcibfKKQ4OfDca48EolI7QXEBksFBdMuqdTqgd
         xgBaRSYOH6gH4lnVmF49Mi7ZA5KBKXXFaeqvc/Q5RZs145fKsIe54vUZ5wE+6LLcJ9MT
         0KbwkqlS5L1+59nL+vvddkplkZjtCtRFbWLfJYzwRwPIyQae3zC1SjciO3qLZYIBW+2H
         pLGYbxG4+V7tSOunW/HKYBLonzDdaaMREnytgXwaHIG8fQ+/mlhqqpSvj96mKhQACMAn
         jWd1syzbLCgxi1f/ZVOuxtCRZTqSvhsQgiqwlozfTPh6AqBIbA7OBTaGuJsEhUZRyG8C
         9jog==
X-Gm-Message-State: ABy/qLb/hrWCwevcdOlyoRwt8Rr25bFp5F9bf0NMTpOm/NBdPCZXAN8E
        2vc0UwEYYsHvS9AJkBwRlxfmCQ==
X-Google-Smtp-Source: APBJJlFx/BbAL9U7L3DQNcKdMjgZcUpugIrT9Drk1prgfJT3bAqq+laqFqqlYxqRm8MHiE7gs+Kq7A==
X-Received: by 2002:a9d:7319:0:b0:6b5:e816:b64d with SMTP id e25-20020a9d7319000000b006b5e816b64dmr2450464otk.37.1690006990385;
        Fri, 21 Jul 2023 23:23:10 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902989000b001b9be3b94e5sm4509198plp.303.2023.07.21.23.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 23:23:10 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 2/2] accel/kvm: Specify default IPA size for arm64
Date:   Sat, 22 Jul 2023 15:22:48 +0900
Message-ID: <20230722062250.18111-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230722062250.18111-1-akihiko.odaki@daynix.com>
References: <20230722062250.18111-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before this change, the default KVM type, which is used for non-virt
machine models, was 0.

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

So if Host_IPA_Limit < 40, specifying 0 as the type will fail. This
actually confused libvirt, which uses "none" machine model to probe the
KVM availability, on M2 MacBook Air.

Fix this by using Host_IPA_Limit as the default type when
KVM_CAP_ARM_VM_IPA_SIZE is available.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 40f577bfd5..23aeb09949 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -249,7 +249,9 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
 
 int kvm_arch_get_default_type(MachineState *ms)
 {
-    return 0;
+    bool fixed_ipa;
+    int size = kvm_arm_get_max_vm_ipa_size(ms, &fixed_ipa);
+    return fixed_ipa ? 0 : size;
 }
 
 int kvm_arch_init(MachineState *ms, KVMState *s)
-- 
2.41.0

