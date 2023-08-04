Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C521176F68E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 02:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjHDAlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 20:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjHDAlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 20:41:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87E44BD
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 17:40:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d07cb52a768so1727381276.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 17:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109654; x=1691714454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMeEbdNzRBMhLJX7Jj1oYrb1Y8jq11YVXHG0dUaROQw=;
        b=QtCPDD7BDigbfVlhCztgjtEtpnDhuzjp5LSRitLIFjr34xmXnNNjyeeBDF8foMn2pG
         hhTw6XAuK1GgODmFVQRdtAG0sX4RDeye2JXeKi++Y0PaeGfhJqO5c5FQEooPvhIJ5WqY
         wFTSe6DGDQF67+7f+2cV8WpTxCesRd/hn8+G/MrCLm/rcf7Fcp0ZghW6ZZTwTcLqiWH1
         vBSRPNSW0GhAzvEDLzSyq/vaxpn337pMeJmsfMPQqHIWnrDAn6zdAuca6wwF6NX/jWOW
         0gkvpGiT0oKgDRiWQfZiNgXUiA60N1570jkoa8TIhuz+se+DwZ6s0v7BO0EBx4XmWLWv
         AVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109654; x=1691714454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMeEbdNzRBMhLJX7Jj1oYrb1Y8jq11YVXHG0dUaROQw=;
        b=eF31WPfPV6jr0aK/8qf2qlTjcU2wZ5KOWCvJV5W/OihvYWfTZxjoKK7yt+14gmlSY+
         aVMSnes8EVI0KLPzRlNdLYiI9Z+vMDFn9yTPJAu+qyNgRXE14tqtEUct5Pmh42Zwhkpg
         yEgWwAO5OYkSsnGcb/qu35gTnG9QRsg86C031hYBS7N+QSHGbtzHue5vxOF3ac04vmMz
         rRLqwrVilyV+6DHT2qzZKV3OqCUz/h+o3M23JtbUYhCrBiMcpHbBwfSpZrncRmcUzUQy
         jAUHUs4a77KDlpffxujGCZtoFeDhvQ/afVmvon+ZglSXOlsFW9YuevderdCHcye7Sa1y
         ZJCw==
X-Gm-Message-State: AOJu0Yz8l5GTSfSMRI4bMXMYtcDZGYRYipXBUnfOR19OzLr5S0NAwUml
        oztVrvoa5X32VdDZXRItu+/13UGtwv8=
X-Google-Smtp-Source: AGHT+IHW9WCL8mnGZuXC1EYuIAH1ZEQoIKy7JnF6jta9YkxED2VsAMO1v9zeszNokSE+bWRDMql19Nhiksk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2f52:0:b0:d1c:5506:9761 with SMTP id
 v79-20020a252f52000000b00d1c55069761mr692ybv.1.1691109654397; Thu, 03 Aug
 2023 17:40:54 -0700 (PDT)
Date:   Thu,  3 Aug 2023 17:40:26 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169110224628.1966361.853135096516007767.b4-ty@google.com>
Subject: Re: [PATCH v4 00/19] x86/reboot: KVM: Clean up "emergency" virt code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jul 2023 13:18:40 -0700, Sean Christopherson wrote:
> If there are no objections, my plan is to take this through the KVM tree
> for 6.6.
> 
> Instead of having the reboot code blindly try to disable virtualization
> during an emergency, use the existing callback into KVM to disable virt
> as "needed".  In quotes because KVM still somewhat blindly attempts to
> disable virt, e.g. if KVM is loaded but doesn't have active VMs and thus
> hasn't enabled hardware.  That could theoretically be "fixed", but due to
> the callback being invoked from NMI context, I'm not convinced it would
> be worth the complexity.  E.g. false positives would still be possible,
> and KVM would have to play games with the per-CPU hardware_enabled flag
> to ensure there are no false negatives.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[01/19] x86/reboot: VMCLEAR active VMCSes before emergency reboot
        https://github.com/kvm-x86/linux/commit/b23c83ad2c63
[02/19] x86/reboot: Harden virtualization hooks for emergency reboot
        https://github.com/kvm-x86/linux/commit/5e408396c60c
[03/19] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
        https://github.com/kvm-x86/linux/commit/119b5cb4ffd0
[04/19] x86/reboot: KVM: Disable SVM during reboot via virt/KVM reboot callback
        https://github.com/kvm-x86/linux/commit/baeb4de7ad12
[05/19] x86/reboot: Assert that IRQs are disabled when turning off virtualization
        https://github.com/kvm-x86/linux/commit/ad93c1a7c010
[06/19] x86/reboot: Hoist "disable virt" helpers above "emergency reboot" path
        https://github.com/kvm-x86/linux/commit/edc8deb087d8
[07/19] x86/reboot: Disable virtualization during reboot iff callback is registered
        https://github.com/kvm-x86/linux/commit/59765db5fc82
[08/19] x86/reboot: Expose VMCS crash hooks if and only if KVM_{INTEL,AMD} is enabled
        https://github.com/kvm-x86/linux/commit/261cd5ed934e
[09/19] x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
        https://github.com/kvm-x86/linux/commit/b6a6af0d19ce
[10/19] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
        https://github.com/kvm-x86/linux/commit/22e420e12739
[11/19] KVM: SVM: Make KVM_AMD depend on CPU_SUP_AMD or CPU_SUP_HYGON
        https://github.com/kvm-x86/linux/commit/554856b69e3d
[12/19] x86/virt: Drop unnecessary check on extended CPUID level in cpu_has_svm()
        https://github.com/kvm-x86/linux/commit/5df8ecfe3632
[13/19] x86/virt: KVM: Open code cpu_has_svm() into kvm_is_svm_supported()
        https://github.com/kvm-x86/linux/commit/85fd29dd5fe4
[14/19] KVM: SVM: Check that the current CPU supports SVM in kvm_is_svm_supported()
        https://github.com/kvm-x86/linux/commit/c4db4f20f3bf
[15/19] KVM: VMX: Ensure CPU is stable when probing basic VMX support
        https://github.com/kvm-x86/linux/commit/f9a8866040fc
[16/19] x86/virt: KVM: Move "disable SVM" helper into KVM SVM
        https://github.com/kvm-x86/linux/commit/76ab8161083b
[17/19] KVM: x86: Force kvm_rebooting=true during emergency reboot/crash
        https://github.com/kvm-x86/linux/commit/6ae44e012f4c
[18/19] KVM: SVM: Use "standard" stgi() helper when disabling SVM
        https://github.com/kvm-x86/linux/commit/2e6b9bd49b70
[19/19] KVM: VMX: Skip VMCLEAR logic during emergency reboots if CR4.VMXE=0
        https://github.com/kvm-x86/linux/commit/a788fbb763b5

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
