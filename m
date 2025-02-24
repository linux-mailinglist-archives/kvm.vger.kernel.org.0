Return-Path: <kvm+bounces-39062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E72A43159
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 864B318886E6
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8155920DD40;
	Mon, 24 Feb 2025 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wYSeCmcL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C4820C492
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441349; cv=none; b=l9SUxJJq70UaBgiNDgPgx4y9QqBi00dz13MMXDkDEo08rEmRKOjo44TfZfNEiMV5dEnRRBUHWwWbfF1VPWOHcZDbLds0tnRDVaBsikuJPiLLcSQBDBjbA3OU4yhYmVuMQKuSHuqkrR65QRzBtj5ryGN95kDsfdxKR6bWNLHcx7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441349; c=relaxed/simple;
	bh=eD5WSaoS4BIVKcmvcj9oK2wOfjdwtX85NN6YC8D+ij0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cU5Qx5YJyHqIug1/B6XbJ+RrQSDfpt7lR+aUQlkAdtozpjqhPzGqPTvJUYUN2GKcHNsuEnCkJFz5Lnx7cpXiCEJaWS9NZbfdkFX0BGq+jmIn0WdRaZXt9BsCA2sKK/V0PLFmF/oq5kvF7u3trAPYzHjf4sZID3aEmXRG98/q5bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wYSeCmcL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so16473076a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441347; x=1741046147; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VUFWBiQUtkyxtQjLqO6VHI65Q9aVoo/tjEK11vAPqoc=;
        b=wYSeCmcL3GThc0D5SzB2cumaV2YiGvDo5OEr5PkRPctISC9cMfamdXKC8Brtff0fjK
         d6TogXP+4ECpq8EpU9FpZHhpmRzCuY3EBkne7i37dbfOu1Bq7f0JTrdvKA7l56KzZXrI
         fUEesCFI6zbwb3nLuI6mWO+46LfLDQbtU939u/IhcpP8HOr06mllCV9QpC3QcR/O/yY9
         KjJA6u7lWjuRsE95+Wj0oP6o46LgQNbh54Lmcfwc9R5Oj8SpvxQ+PtN+LV0y3RmWOUZG
         Pvk3p7y7XZFnqSxDiflDrHdokmRq8rtrip2GpZo3einuhX9w8dE80ZDMj/j0jDi1c5MH
         Jp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441347; x=1741046147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUFWBiQUtkyxtQjLqO6VHI65Q9aVoo/tjEK11vAPqoc=;
        b=PYhL6lMVuYyXcxa1Q83eEMzkg3ngpV39dVpJJiOwUvBMP4w+osJQm5o6Yg20rb8R44
         03h5ttZZlYWkas8sPuga7nZRI/N9IO1quz5Crz8DdKYXsTRpyEjNeTW4scD9o+yP2iwK
         UgtnWX7ccg+Gc/jYTpDgwNIlH/f9qJyaD0vm9OyyOAGh8bN6tuw2boV0zhDoNkchLj4e
         +rfXPLopMw+nRP7Cv+MBXQqtFHoDhAkhFhwDsgyRreXJFxDoWxVj6KX6AwzEBskVpZri
         6o14XKcV2Q2vlMt+gW2GFzDBSqKyB7o/Ju8E2oyWg2x5sa/g/gl+JwmG2U8ZIN02JfVQ
         LU4A==
X-Forwarded-Encrypted: i=1; AJvYcCWsRi1qmRMg8VUanaxJ9PysSph2pbrZ/uLLtdxb+ZZZ01gAKX1yDbJRxNSsSkBNmUgR/nY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZkAEJqNkjI5uhiEWN4CdvJImJ7yjfttcqHtj7S+PcYu41E/+x
	5E4X9HToE93+BzLeyy7x5G6TC+oE5HJiegPZOu4W1U9QIgk8obtstK1Akq2TGaA/sFSdlWncwo4
	NwQ==
X-Google-Smtp-Source: AGHT+IEskcg8NGcMgI3lzGvHxN+7n9pLx0XcpaLq7IsEpPM2kCgPZOpZWimEzcKRut1Ut1sQ02q7DWsQk2M=
X-Received: from pjuw11.prod.google.com ([2002:a17:90a:d60b:b0:2fa:1771:e276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18c:b0:2ea:bf1c:1e3a
 with SMTP id 98e67ed59e1d1-2fce86ae2cbmr28015424a91.12.1740441347216; Mon, 24
 Feb 2025 15:55:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:36 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Free vCPUs before freeing any VM state, as both SVM and VMX may access
VM state when "freeing" a vCPU that is currently "in" L2, i.e. that needs
to be kicked out of nested guest mode.

Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was
called") partially fixed the issue, but for unknown reasons only moved the
MMU unloading before VM destruction.  Complete the change, and free all
vCPU state prior to destroying VM state, as nVMX accesses even more state
than nSVM.

In addition to the AVIC, KVM can hit a use-after-free on MSR filters:

  kvm_msr_allowed+0x4c/0xd0
  __kvm_set_msr+0x12d/0x1e0
  kvm_set_msr+0x19/0x40
  load_vmcs12_host_state+0x2d8/0x6e0 [kvm_intel]
  nested_vmx_vmexit+0x715/0xbd0 [kvm_intel]
  nested_vmx_free_vcpu+0x33/0x50 [kvm_intel]
  vmx_free_vcpu+0x54/0xc0 [kvm_intel]
  kvm_arch_vcpu_destroy+0x28/0xf0
  kvm_vcpu_destroy+0x12/0x50
  kvm_arch_destroy_vm+0x12c/0x1c0
  kvm_put_kvm+0x263/0x3c0
  kvm_vm_release+0x21/0x30

and an upcoming fix to process injectable interrupts on nested VM-Exit
will access the PIC:

  BUG: kernel NULL pointer dereference, address: 0000000000000090
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  CPU: 23 UID: 1000 PID: 2658 Comm: kvm-nx-lpage-re
  RIP: 0010:kvm_cpu_has_extint+0x2f/0x60 [kvm]
  Call Trace:
   <TASK>
   kvm_cpu_has_injectable_intr+0xe/0x60 [kvm]
   nested_vmx_vmexit+0x2d7/0xdf0 [kvm_intel]
   nested_vmx_free_vcpu+0x40/0x50 [kvm_intel]
   vmx_vcpu_free+0x2d/0x80 [kvm_intel]
   kvm_arch_vcpu_destroy+0x2d/0x130 [kvm]
   kvm_destroy_vcpus+0x8a/0x100 [kvm]
   kvm_arch_destroy_vm+0xa7/0x1d0 [kvm]
   kvm_destroy_vm+0x172/0x300 [kvm]
   kvm_vcpu_release+0x31/0x50 [kvm]

Inarguably, both nSVM and nVMX need to be fixed, but punt on those
cleanups for the moment.  Conceptually, vCPUs should be freed before VM
state.  Assets like the I/O APIC and PIC _must_ be allocated before vCPUs
are created, so it stands to reason that they must be freed _after_ vCPUs
are destroyed.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Closes: https://lore.kernel.org/all/20240703175618.2304869-2-aaronlewis@google.com
Cc: Jim Mattson <jmattson@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..045c61cc7e54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12890,11 +12890,11 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mutex_unlock(&kvm->slots_lock);
 	}
 	kvm_unload_vcpu_mmus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
-- 
2.48.1.658.g4767266eb4-goog


