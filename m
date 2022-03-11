Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445664D6829
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350756AbiCKR6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350493AbiCKR6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:58:46 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7E178925
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:41 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id y3-20020a056602178300b00645d25c30c1so6779531iox.6
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=reY3JxO0Qz3iJXrFE+fLTwQO2MuKL1UPGAjn20Lqoao=;
        b=n/M+lnBk+N7zApRlOssTP+KALpqfkDUpxmbbZf9OVnsbAGTF24lyWr2yvrKj3eJhHh
         KlwuG3VKWe3524zQ0pEL4J6TBwFwPOoRAebN3n0vpides8mGXB+EbYFeJmmkZfQTfGzZ
         XYvyGdDyjkXVzSAzkiq91lVWeQmg14E+ZshflwW/ntyiQxAJxwuPNucacslawQCbPYYm
         WD3ZFVMIGBG78tv4VKrrv5Q/SbGCWnBDtlQP2/T9o/33WqeTY/4Pf+YD0SNDX81gEwaX
         G3KYqOFofFz3jHwq3lO7/3gzvWvfYvIGk9aFdVJLuYnlmsuLWzAaO0YJUmB9pJCY0LLG
         0zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=reY3JxO0Qz3iJXrFE+fLTwQO2MuKL1UPGAjn20Lqoao=;
        b=OiKI6s2LmE5gmNqwR8gMPYvMcWgrZhnGNtzAFf8n+v+gDnnO6RNCX4DT7HIsHF2/BM
         eQFgWbsC20xX30vbqMSW04dASF7cq9X5OoJcZ+kFg7P3GIrNJvjxydibNAuCosMvO9CQ
         XvXq3Kf1hULWf098cfbLc1NThUjmDdFZKFp6NULzZiVqLdMqBo6CBm2PcqE8VdJxNrD3
         n412pE0P8Hhqv4H7gqQMbtvwo9VFxH7vRvIUz8ZjBbf27RryTwQZnU/wfnctSst79IH3
         Q/ko3TOExbWMjQOE89cmAkALT8MSLeFtnwmQ8zR/DAZxp+hY1Fcx9wm1e7UGmu3luM1x
         pkFQ==
X-Gm-Message-State: AOAM531CvsvgFgmhzv/MOGa65uKdfKtn0AssirzIxy3xxxok4Swhu85j
        xdgO/kAqKS+sEa0ZWYRaz2MWEsER1Ic=
X-Google-Smtp-Source: ABdhPJwIV2dE5aKw/FZ4JxGUOLBoR07htZIM8UZWxJDfUBN8z5M+T3xIKkUCNUzF/rey8m9ZGZWSrRl15SE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a081:0:b0:317:b141:29ca with SMTP id
 g1-20020a02a081000000b00317b14129camr9018933jah.275.1647021461237; Fri, 11
 Mar 2022 09:57:41 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:57:14 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-3-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 2/5] Allow architectures to hook KVM_EXIT_SYSTEM_EVENT
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain system events require architecture-specific handling. Allow
architectures to intervene for exits unhandled by the default exit
handler.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/kvm/kvm-cpu.h | 1 +
 kvm-cpu.c             | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
index 0f16f8d..75e42d8 100644
--- a/include/kvm/kvm-cpu.h
+++ b/include/kvm/kvm-cpu.h
@@ -20,6 +20,7 @@ void kvm_cpu__run(struct kvm_cpu *vcpu);
 int kvm_cpu__start(struct kvm_cpu *cpu);
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu);
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu);
+bool kvm_cpu__arch_handle_system_event(struct kvm_cpu *vcpu);
 
 int kvm_cpu__get_debug_fd(void);
 void kvm_cpu__set_debug_fd(int fd);
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 7dec088..d615c37 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -23,6 +23,11 @@ int __attribute__((weak)) kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 	return VIRTIO_ENDIAN_HOST;
 }
 
+bool __attribute__((weak)) kvm_cpu__arch_handle_system_event(struct kvm_cpu *vcpu)
+{
+	return false;
+}
+
 void kvm_cpu__enable_singlestep(struct kvm_cpu *vcpu)
 {
 	struct kvm_guest_debug debug = {
@@ -224,6 +229,9 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
 			 */
 			switch (cpu->kvm_run->system_event.type) {
 			default:
+				if (kvm_cpu__arch_handle_system_event(cpu))
+					break;
+
 				pr_warning("unknown system event type %d",
 					   cpu->kvm_run->system_event.type);
 				/* fall through for now */
-- 
2.35.1.723.g4982287a31-goog

