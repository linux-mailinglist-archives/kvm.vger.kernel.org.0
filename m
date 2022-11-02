Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55661728A
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiKBX0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiKBXYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:24:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7411F11A32
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:20:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id my9-20020a17090b4c8900b002130d29fd7cso2481074pjb.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7o9E6ByEEHcjl3SJug2mMi0pvOLBLqCZLDtYGdzM9zU=;
        b=igGQ2Ishg8aW6R16oe+upaVPlGZAayIzpaWDE8opgJQMS6iOjhkUCLTlEhQKtzbBll
         IdlAKyPdahqXXt0dn4MTEFgukQG0ZCIqNyG5cI01/hw0JIAYQcoPp2BpnzUD0jxS7Ya/
         +nFRYynF3Dt5MSnjg1t4pKoFk0Qf9803yI4SDdLZfxDyQop67DTJX+MNPzB4mGdTHTI/
         UetXl5t7icKMI/ai8krB+aFqS3nK2vJC9U3C1mIJKmfCvYut3D46hBaxcevJzvvlHDGm
         CTwO6YCLjzVqPj4Wwm3tv83DTC33l/N5jui9O7iqtMw8SKOspotJDO5ne6iRoF09KXOw
         O2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7o9E6ByEEHcjl3SJug2mMi0pvOLBLqCZLDtYGdzM9zU=;
        b=fRaYmXPgSsOsGwJONmjWo5CL7o2jhuTgWGqhy4eD/3VoRFOToeWmNLEe8ICWoYLsuY
         QkKSs3TLE+mStfe9b/xLxtjjwg2rk+e0h8765G0ZQhFTejezlcp6y7CV7zUgRdZd1twd
         t6wQh19iu1gMfPNYlxuFxHr3OwtQvTuuUMDns/nBqCV+laSAwjOCx8VFV1qCB91Bt4pI
         4/Z4KDT0gfe1uJj2s5EsQ7Sn9LabzZs13ji+Oz/Gk24USlqXvqyaId4vmGa/0yt73eZ0
         1OpKVuRM1tsc3nHu3zVe69T4kzgUw9c6aK7KAKOI/nEuuqfQyldwLYGTYRX9b2HYRVkP
         xPNQ==
X-Gm-Message-State: ACrzQf2TbDLpO1IpTopz+ldUF2rT/PQ8nNqCo722SGu2Qau7hfDo0zMG
        LS6H1+eYdhDWpaHqS/KmjNjKe4GX8uU=
X-Google-Smtp-Source: AMsMyM6niBK+tgCsXQRPRS+/qtLS7kuATd90vG4p7xHoZHYxFybBPWfrbfk513VrCr/GCHaNPNf0pglufE4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c7c4:b0:186:5ebe:38e with SMTP id
 r4-20020a170902c7c400b001865ebe038emr27249054pla.33.1667431222881; Wed, 02
 Nov 2022 16:20:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:19:07 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-41-seanjc@google.com>
Subject: [PATCH 40/44] KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Drop the superfluous invocation of hardware_disable_nolock() during
kvm_exit(), as it's nothing more than a glorified nop.

KVM automatically disables hardware on all CPUs when the last VM is
destroyed, and kvm_exit() cannot be called until the last VM goes
away as the calling module is pinned by an elevated refcount of the fops
associated with /dev/kvm.  This holds true even on x86, where the caller
of kvm_exit() is not kvm.ko, but is instead a dependent module, kvm_amd.ko
or kvm_intel.ko, as kvm_chardev_ops.owner is set to the module that calls
kvm_init(), not hardcoded to the base kvm.ko module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: rework changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c8d92e6c3922..4a42b78bfb0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5966,7 +5966,6 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
 }
-- 
2.38.1.431.g37b22c650d-goog

