Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43825BF214
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiIUAdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiIUAcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4966792E9
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:51 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dc888dc62so38030667b3.4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=MOTPXqlRM/VeyDMLdvanelesLQo1zQAim2hnWRvX5Ck=;
        b=YBqAHda81cZL+XoxjJlGZuZuboXTXgUC0z4uqSgz7QVH6dpNmadTy2MF1qyxWTzse+
         Bm4tIE92SduAzP3ZIMtRF2tHutR8pP7xlWpK1ArY4DnG03povI4wausutZUl5/iFFjm4
         TVHVZG9uLcywTpZWMGs36ucGtqVhhGObHn0VVjekmG1+dp+mNh3xufw2ncJL/mts4ZIh
         7z9P/A8X9TowwqnweXUdspRxboWu77JnECKkB3W0l/4PI0O4qSiM4m96bzkM3yIhCnUQ
         IS3oC/wRtMwluha1XcW0DRroQd63c6ike/sLIVwGS1L4peBPZN+rGOVKwA2aeOQ8Ropo
         ukqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=MOTPXqlRM/VeyDMLdvanelesLQo1zQAim2hnWRvX5Ck=;
        b=SckrHdno0hvUjVSoNl/lWtZc6C5YuP+uAaPnTthjisphPeuzRUzI0xIxEQv72qog0U
         lRuwmKEpsWjNWmiM2ohlJ2qpjFfwIM9ALBiVGNMoU+bK1J6lorQ0OGleu6Mzo3C9LE8G
         LYel3Hpc5+D6EpatqbmxpkCW5dgvGINJQb7QmuPc+J65wo12dB+z5RY6I8UV5GBuNgB2
         3vIpIpzg3uCtSx1BijscvxHJl4qYghV8k3whVX3AaHfik066le03OEfV6Yk8q+N/yu11
         cMoTGxHDBir/v0xv48rCu7VmF3yaMm4enZAHd3UZcYd2Cw+7KX2nbErkbdcTZt8+PUbx
         WeSA==
X-Gm-Message-State: ACrzQf2U8m+fLDxJ7aNqRQLqUw+qiHzcEvLmfktCcyb664UyqRHjEoJG
        RBUwO7z7pPOENZVwO1SOo9cAp7/lpNI=
X-Google-Smtp-Source: AMsMyM6m3bS7RPF5fQr/eH5ncPqvFCJtkoDqyUevH+R4X807matv5uzc8TD1ePhtwCCU0OlXVNBl8o1DpUw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9256:0:b0:349:e25e:9bfe with SMTP id
 j83-20020a819256000000b00349e25e9bfemr22039190ywg.111.1663720371023; Tue, 20
 Sep 2022 17:32:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:51 +0000
In-Reply-To: <20220921003201.1441511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220921003201.1441511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-3-seanjc@google.com>
Subject: [PATCH v4 02/12] KVM: nVMX: Make an event request when pending an MTF
 nested VM-Exit
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
        Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
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

Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
through inject_pending_event() and thus vmx_check_nested_events() prior
to re-entering the guest.

MTF currently works by virtue of KVM's hack that calls
kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
be removed in the near future.  Until that call is removed, the patch
introduces no real functional change.

Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 arch/x86/kvm/vmx/vmx.c    | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 85318d803f4f..3a080051a4ec 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6632,6 +6632,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto error_guest_mode;
 
+	if (vmx->nested.mtf_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return 0;
 
 error_guest_mode:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 94c314dc2393..9dba04b6b019 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1665,10 +1665,12 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 	    (!vcpu->arch.exception.pending ||
 	     vcpu->arch.exception.vector == DB_VECTOR) &&
 	    (!vcpu->arch.exception_vmexit.pending ||
-	     vcpu->arch.exception_vmexit.vector == DB_VECTOR))
+	     vcpu->arch.exception_vmexit.vector == DB_VECTOR)) {
 		vmx->nested.mtf_pending = true;
-	else
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	} else {
 		vmx->nested.mtf_pending = false;
+	}
 }
 
 static int vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
-- 
2.37.3.968.ga6b4b080e4-goog

