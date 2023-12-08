Return-Path: <kvm+bounces-3893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6043809917
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:18:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6191928208F
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652631C33;
	Fri,  8 Dec 2023 02:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TmLRKPZc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E75F1720
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 18:18:08 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d0b944650bso10785125ad.1
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 18:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702001887; x=1702606687; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x/RQieb/5hgEZf4ihBfemqOm3bIAp8/aW/Hee+PAMyI=;
        b=TmLRKPZcGWfygIV8QYasmcXnA7UJZbBlqoPhsSmPmlzvl0bZCF6mIHrKhsgd106sPo
         +bR2k8diUnPM3rzE2YPplBK0fJj5u3qFf7mY/Y4Ybl9FAhsnqW66iaB3oNM91wIFU6Sm
         YQVOU1CiyIxDCcHLBKjLJRSdOpYrhmW5cjLu9cKaLxihtDFTtmEep+rRi9am/5MK3aJF
         3N7tuR2aCkDKXg0q8DFVYIoKPrgDYPlxVVRRKEC1JWU+DwRiQ5aSuOsxyL/RDL2Iu1Vr
         qtlcHAgvfKylIPvPNObiAJPZ4X3avvY0C/0qJrwm7vWUqjykZ3ROCqq/+r6L+tpHuAf6
         NcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702001887; x=1702606687;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/RQieb/5hgEZf4ihBfemqOm3bIAp8/aW/Hee+PAMyI=;
        b=Q2fDXnlih/n5nC/KO6/288tK2KTvumZPBNjGmmH0QlUbwwhapOp60/1vGtxNawTCfs
         RCm9HPZ3lwlDwIDYtHz77m6YuPCoFl8aYmuHq6SoF0apnSLldm65ZlBIdTeTT1b0S4lT
         65f055G3QyUhvv1diDKA+66a0xeWVETZ0fyZiy4s86eUekrV33FdCChDeRZJLJw9x1SV
         NdgWPYto6KD2G9nP3boiwoaY0b4bV0xxqPFBbI4h/FCAc9c5KPVjf7W/KNGP95csty6g
         lx+WyQolcZGihyurW4DuY8PDLek7wclGq0GiLjY7hqk+oyXnPnI2m/gyqR64o0AEVbrR
         Iijg==
X-Gm-Message-State: AOJu0YwMFx4ET9NtkGfwQR/DivvOruIotN0+FiSQms/hoF7Wer+MBboT
	wH0F2ymqr0nMOjIUHs6ZrQyrkzhu/TE=
X-Google-Smtp-Source: AGHT+IGL5urnZA4xoKYLDChi+OFsiyF9tC+qN9RWgHap2zKqBiBinNmjyAjI/HL7V1qK+N91zHcRX4D74FM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ceca:b0:1d0:9376:c8e5 with SMTP id
 d10-20020a170902ceca00b001d09376c8e5mr40324plg.13.1702001887529; Thu, 07 Dec
 2023 18:18:07 -0800 (PST)
Date: Thu,  7 Dec 2023 18:17:37 -0800
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231205103630.1391318-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <170197059584.1607462.12996412883406610294.b4-ty@google.com>
Subject: Re: [PATCH v2 00/16] KVM: x86: Make Hyper-V emulation optional
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 05 Dec 2023 11:36:14 +0100, Vitaly Kuznetsov wrote:
> v1:
>   https://lore.kernel.org/kvm/20231025152406.1879274-1-vkuznets@redhat.com/
> 
> Changes since RFC:
> - "KVM: x86: hyper-v: Split off nested_evmcs_handle_vmclear()" patch added
>   [Sean]
> - "KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h" patch added [Sean]
> - Use evmptr_is_set()/nested_vmx_is_evmptr12_set() helpers instead of
>   nested_vmx_evmptr12() [Sean]
> - Move "#ifdef CONFIG_KVM_HYPERV" inside certain functions instead of
>   adding stubs for !CONFIG_KVM_HYPERV case [Sean]
> - Minor code re-shuffling [Sean]
> - Collect R-b tags [Max]
> 
> [...]

Applied to kvm-x86 hyperv.  I massaged a lot of the shortlogs to adjust the
scope, shorten line lengths, and rephrase things using more conversational
language.

Re: the scopes, while I like the idea of "KVM: x86/hyper-v:", e.g. to pair with
"KVM: x86/xen:", I think we should forego it for now.  The Xen code is fairly
well contained and doesn't have VMX or SVM code, let alone nVMX and nSVM code.

Hyper-V... not so much.  It has its greedy little hands in everything :-)  That
makes it rather difficult to have consistency and correctness, e.g. these three
are all nVMX+hyper-v specific, yet managed to end up with three different scopes.

  KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h

  KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor

  KVM: x86: hyper-v: Split off nested_evmcs_handle_vmclear()

And things only get more confusing when KVM-on-Hyper-V comes into play.  So kinda
like we do with the TDP MMU, which is too intertwined with the regular/common
MMU code to get its own scope, I think we should use existing scopes and then
explicitly talk about Hyper-V in the shortlog to make up for the lack of
precision.

Please speak up if you disagree!  I don't expect to apply any other patches to
this branch, i.e. further massaging the shortlogs isn't a problem.

[1/16] KVM: x86/xen: Remove unneeded xen context from kvm_arch when !CONFIG_KVM_XEN
	  https://github.com/kvm-x86/linux/commit/87562052c965
[2/16] KVM: x86: Move Hyper-V partition assist page out of Hyper-V emulation context
	  https://github.com/kvm-x86/linux/commit/cfef5af3cb0e
[3/16] KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}
	  https://github.com/kvm-x86/linux/commit/50a82b0eb88c
[4/16] KVM: x86: Introduce helper to check if auto-EOI is set in Hyper-V SynIC
	  https://github.com/kvm-x86/linux/commit/16e880bfa637
[5/16] KVM: x86: Introduce helper to check if vector is set in Hyper-V SynIC
	  https://github.com/kvm-x86/linux/commit/0659262a2625
[6/16] KVM: VMX: Split off hyperv_evmcs.{ch}
	  https://github.com/kvm-x86/linux/commit/e7ad84db4d71
[7/16] KVM: x86: Introduce helper to handle Hyper-V paravirt TLB flush requests
	  https://github.com/kvm-x86/linux/commit/af9d544a4521
[8/16] KVM: nVMX: Split off helper for emulating VMCLEAR on Hyper-V eVMCS
	  https://github.com/kvm-x86/linux/commit/b2e02f82b7f7
[9/16] KVM: selftests: Make Hyper-V tests explicitly require KVM Hyper-V support
	  https://github.com/kvm-x86/linux/commit/6dac1195181c
[10/16] KVM: selftests: Fix vmxon_pa == vmcs12_pa == -1ull nVMX testcase for !eVMCS
	  https://github.com/kvm-x86/linux/commit/225b7c1117b2
[11/16] KVM: nVMX: Move guest_cpuid_has_evmcs() to hyperv.h
	  https://github.com/kvm-x86/linux/commit/f97314626734
[12/16] KVM: x86: Make Hyper-V emulation optional
	  https://github.com/kvm-x86/linux/commit/b4f69df0f65e
[13/16] KVM: nVMX: Introduce helpers to check if Hyper-V evmptr12 is valid/set
	  https://github.com/kvm-x86/linux/commit/453e42b05571
[14/16] KVM: nVMX: Introduce accessor to get Hyper-V eVMCS pointer
	  https://github.com/kvm-x86/linux/commit/c98842b26c23
[15/16] KVM: nVMX: Hide more stuff under CONFIG_KVM_HYPERV
	  https://github.com/kvm-x86/linux/commit/5a30f97683af
[16/16] KVM: nSVM: Hide more stuff under CONFIG_KVM_HYPERV/CONFIG_HYPERV
	  https://github.com/kvm-x86/linux/commit/017a99a966f1

--
https://github.com/kvm-x86/linux/tree/next

