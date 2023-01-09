Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E8B661EA6
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 07:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjAIGXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 01:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjAIGXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 01:23:10 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBEFBE13
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 22:23:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g20so5376492pfb.3
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 22:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YqeIKu6Sd+sjJ+iNsDcqylD6czn18ZYvBY28zrMySdM=;
        b=PljgJ03R53eDyuflbIGh3pRorQ3zHGvbx3FJ0RKimzGy0Tq5xOMiCjV1ePvZ35lHYe
         HlOS6VddEoMv04bG001SRjp0H8SRq3QVfVJ+xW+sU66y5bSN0/SgKhW/fU7AEzFWQBkG
         DZMfO7fqYB2L7AOCBglk2Z1D/UzyjZnv4hNhtWMLU9PEeBKA2DBLYnGAGHGCHPz24Qqe
         y7frve90kZB4peO6Y0ICmuF+r1Yi6gOdGT0zfwKw3Dw+GevAHRKc81xQluypoGzF3V3Y
         jR+Fqh8UMTPxeV0hl3POTVr+ckKwViJoZp/hSmv599Y8euWbOIO8zFPdZ/AUsAM71wpQ
         Gw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YqeIKu6Sd+sjJ+iNsDcqylD6czn18ZYvBY28zrMySdM=;
        b=KYc3MEeDtKkZNrA/5JZIYleWWExpqABVPdypS+yQniyFHxcvKCJJIIMlHdwb7z1pg1
         fpmqgJnKo6NY0bw15ZH1gbCIEgHlJsMMMrgCjRmXEDlMIN41gdx9YvkxVFwvgBVkiB9u
         I6w1w6EdHWkrZDE38EbIfyUJ7QrmjwyABtLHaZ6/0KYhuK696W/X80MhWcEB/BrhUs9x
         FEXDYn8STDB509R/Ag605qspu79PTBBqzosfUvRycUxWu3qhrXBKr+HftV9wScQ6Kb0x
         6ytTb2M1IqAmOjpwpbCG3xYM/oiwp02LYujl67Di1dkGnLClZ0m+Nr1j39UbuJgWlYup
         347A==
X-Gm-Message-State: AFqh2krxjpYXb2S70B8VXOD7xbX3TL44ONXUtlzzvi6f3A0jg2sKwq52
        DqvfU/dwijBfqrX/jn8xtH0fhg==
X-Google-Smtp-Source: AMrXdXv8ulwn5R5diE+Dj2M0IlSjayGIMXCpZLIOmuIYaXDKeZUY3ukTbynE8lQ/G6adLQkzcDP1OQ==
X-Received: by 2002:a05:6a00:21d1:b0:588:cb81:9276 with SMTP id t17-20020a056a0021d100b00588cb819276mr2016802pfj.25.1673245388547;
        Sun, 08 Jan 2023 22:23:08 -0800 (PST)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id i11-20020aa796eb000000b0056d7cc80ea4sm5207492pfq.110.2023.01.08.22.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 22:23:08 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] accel/kvm: Specify default IPA size for arm64
Date:   Mon,  9 Jan 2023 15:22:59 +0900
Message-Id: <20230109062259.79074-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 accel/kvm/kvm-all.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e86c33e0e6..776ac7efcc 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2294,7 +2294,11 @@ static int kvm_init(MachineState *ms)
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
2.39.0

