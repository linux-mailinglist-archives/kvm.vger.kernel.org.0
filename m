Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367757648F5
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjG0HkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjG0Hjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:39:40 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEEA9E
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686d8c8fc65so518800b3a.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 00:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690443109; x=1691047909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiO61RFWQc576A2x8jBmto7Eq50nA+0j/FFgWXdA55I=;
        b=VNKaMnEOQNKlZR10dtEZyO1TSdS8k+fSD0DHogH1R6yudKKGkTFXMKAarSnSO2Kzhb
         xvD1EZKgScgBJoiuS8bn3iq9oS82m2GgS+xDRQL1LO1mZUI0h3QAs51vMSM0GF23EJ36
         kplgCIlhxqVOD1kJw6Ndxf2MuGlGp3gf7FYdVXtivp0O9KAty+FICxA19fmvqlbFAaNK
         VaYy5/5qDpFY1/9OGQo8WReDwdFPntnukR2eDMEbxZ3IC+hZuDnSxabg/c1oO/jw/A5N
         2zqYrcpUt7hQTCIvlGGKoh2gtLlNZHxV/k1JPuu0ENiemMNzGr+TMDNr5+hLTalPd13F
         f+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690443109; x=1691047909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiO61RFWQc576A2x8jBmto7Eq50nA+0j/FFgWXdA55I=;
        b=fZ0jZXeOI5SuwNkh6lsBmrRaHNYC2IXysKfQ2nZswlR9sW+SrEPJZbvXeQ6ZNVJOKJ
         AGhjMJaLTcxsxHtsIt2RVpX+gFYgPIJeMXTj8CtUx2BMEU9IqadwmhhyD05o2+FClafH
         BAw5fdjm6UEm44s+nulIwxDB3YOs1KlyWraNmvRLwhVx/6PIuUhgdFld3ZQk1tpuaHQC
         xhtJaDltizSByhHoDUvA65370CN47uQGrEbMxH2Zisre3AXTkBGaDhMEA73BX1cjyXsW
         gKmLU169NuPw8TD25+i3OSqoWnDQ0coX7mnLingniUKQkdhZfKmbK6Je1WuyeF1sZNYv
         WfZQ==
X-Gm-Message-State: ABy/qLbxlJo+UA8BoGYeXeSeu42/01u0isRqyChyPZMNPdNyn9qvErGu
        cc7Tm64325AyVo2M+QVrk9dsFQ==
X-Google-Smtp-Source: APBJJlEuLZxP0ZyEIi7VHNrW7mhtveHSO5fc5w71A22qd8/dfAl9uK20/rnFzi8GOuvgoOIN1lD60w==
X-Received: by 2002:a05:6a00:2184:b0:65e:ec60:b019 with SMTP id h4-20020a056a00218400b0065eec60b019mr4039381pfi.25.1690443108991;
        Thu, 27 Jul 2023 00:31:48 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78689000000b0064fa2fdfa9esm802002pfo.81.2023.07.27.00.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 00:31:48 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v5 2/6] accel/kvm: Specify default IPA size for arm64
Date:   Thu, 27 Jul 2023 16:31:27 +0900
Message-ID: <20230727073134.134102-3-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230727073134.134102-1-akihiko.odaki@daynix.com>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
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

