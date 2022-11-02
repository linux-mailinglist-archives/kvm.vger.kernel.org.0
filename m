Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD566171DD
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKBXUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiKBXT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:19:27 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3B325D2
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:19:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s82-20020a632c55000000b0046b2491aa95so93084pgs.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c745/GhVAupZOShsaNtc5Y0Jm7uB9ydr3S2itBPefjM=;
        b=pj8ZAUMzpQAWjfpeZGv/CFSzOSSwAiDNlmMCeDtMJXA3Ia6uRvLVcV16Cymca0aHXC
         PM6wRe31jjgcVPugCvX2WsyNtqvMLIJF0v+Ys/n5Nq2k4svZOYnhn3INYaYp+USpd+G1
         514pS4WDUrP9flgT5BLdl+/qUHO2eNFQZVTslZCWnmYA53yd76i4Ah4L5OS7bjh89Kxd
         agD1FqGzCkHp/1xQ5FePUye1+JugXCV19Z37h3h0SVTeBVE4gWePoOlMN/4jX90JcqtQ
         h9Xz7vnqCR6lnYHkhGhaSKxff5kFMXnt6v8GUJMP6nlzvcT1qM4okUu+0Q4ETJu9vS+7
         8iTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c745/GhVAupZOShsaNtc5Y0Jm7uB9ydr3S2itBPefjM=;
        b=sF2Lw0+sHwCDlXmyw3ejhIaGT+x4EjblhMcVi1rKtXMmzAOlRkJ7/awaBowbaJkOPm
         YIDQc8fc2pQOTUOYfqKQd07uQGm6nsbX+jGQ0Vm1Yj9K7Oe9KEniK1ws+apXIUOeH5Dt
         bcBOL48YHgphVZXdPqESx/zwLKimcbDvEVJXN9AaYGpKjgu3EWmRi/VcdQn7nHCnE40+
         3s3B9c/m9fAviXKjxz2/y9H6DXIanWDkqjNKi4/6B9gcOAlYXaO6dTYjYVqov1sjguE0
         Wbh/RVzhsWyyLUQONOBvounyxzBhqVJFAdp74cUPJV4Ppaz35QyYCEb0R8bXha+erYEH
         kKfg==
X-Gm-Message-State: ACrzQf2HBIzhGjdT7eKzfgWsb63HH2GNUlFuYk1lxkT2F9wTGr/1yZBt
        CTbumWmFMLQwJTweL7Yhr+8IXooxSJ4=
X-Google-Smtp-Source: AMsMyM50bKDX4r1Ac7K4343Hy6JzbUn/G7PmXwa6NG1xDlxuMg48/hoXRC8GNkJYnpu6i2NofBL/D0pMfb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8a97:b0:178:1939:c721 with SMTP id
 p23-20020a1709028a9700b001781939c721mr27564226plo.108.1667431161027; Wed, 02
 Nov 2022 16:19:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:31 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-5-seanjc@google.com>
Subject: [PATCH 04/44] KVM: Teardown VFIO ops earlier in kvm_exit()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the call to kvm_vfio_ops_exit() further up kvm_exit() to try and
bring some amount of symmetry to the setup order in kvm_init(), and more
importantly so that the arch hooks are invoked dead last by kvm_exit().
This will allow arch code to move away from the arch hooks without any
change in ordering between arch code and common code in kvm_exit().

That kvm_vfio_ops_exit() is called last appears to be 100% arbitrary.  It
was bolted on after the fact by commit 571ee1b68598 ("kvm: vfio: fix
unregister kvm_device_ops of vfio").  The nullified kvm_device_ops_table
is also local to kvm_main.c and is used only when there are active VMs,
so unless arch code is doing something truly bizarre, nullifying the
table earlier in kvm_exit() is little more than a nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8b7534cc953b..f592dd4ce8f2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5961,6 +5961,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5970,7 +5971,6 @@ void kvm_exit(void)
 	free_cpumask_var(cpus_hardware_enabled);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
 
-- 
2.38.1.431.g37b22c650d-goog

