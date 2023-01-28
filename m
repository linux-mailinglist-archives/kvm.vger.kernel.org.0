Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4288067F2C5
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjA1AI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjA1AIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:08:17 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E76D2
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:07:57 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id y11-20020a17090a86cb00b0022bec81bf5eso2737345pjv.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOUBv1CbMhbA9QMXcwSv38kdbvkOS2fj9m5j0bVapWQ=;
        b=kwnRXlmhOebkv2e8lT/IVNCRJVk0ktvuclqriGgTNgn9JAxnzF79aZacW6aY+4gG0H
         kTS4jZYIlb551nLvP3Mhm2mRDA4W7+7UKmbfg31dUkx4pXXBqJufr+tDUMuUA8qtwDks
         WUVn8ViYO3jjMHwVV4B1JhQ8Q+0mhI5caS4ww+T9Is4kRbaNrkoB/VdCFHCETllMlcdA
         QBDno+AF4DxBaZHHBy8QoputEJObR2lBKJ53nT82YSipE7J/4uqmKZe53WrLxCL4vu8g
         nr01K+8vkXFTMXb1j6B6+r9wX2hjTf9+C4kfL5sQWANJPFOhQN4EDn+60YcyKA8bB2VZ
         WiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOUBv1CbMhbA9QMXcwSv38kdbvkOS2fj9m5j0bVapWQ=;
        b=R8cAxInPVRv0WsVSEQzkYeDwg5JTjbBYs4cvMmab7LVGV9P4+lzS1h8NjPUeUU50H0
         h3C1nuCq3+HgHeeMXSvgR+ntXyQHK97YjEpkkdmbiW5Qttni0StnvdkwhDsUdtYbpknf
         4OxJPHuMZy8lcPrEs48PdmPNSugI5X3xwG39XS6etWlM7HArsjfbENBXWCATAsmCIhCN
         Eh0iEges7nFxyHrjCthY4yeIxcmPGyJgLa+ExiuFMNbIs+qEl/5VQjPiF8KpZWzJk5Kk
         ukVlr0nLq7SBErl0BXry3n799bcZy/umOcdVnWQzOXsLadVX1Io2MOTnNehxnd6mWMR7
         ta7g==
X-Gm-Message-State: AFqh2koqSMFdBvraf1NDYvS03nWpR78F5Mg9+vEScfY4hHL0uuy0CvVM
        9B4twYgftJAzeYNaIP2CUlPhNSVNSHo=
X-Google-Smtp-Source: AMrXdXvygPTGHYvQRx4jFHoBlzIz+H0j6EoKcOSLy/QmIban3mzNOHPNWlVEKu7/FsOwM2AiVGKrITNXmyE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2cb:b0:194:4c4c:7571 with SMTP id
 n11-20020a170902d2cb00b001944c4c7571mr4637757plc.10.1674864472481; Fri, 27
 Jan 2023 16:07:52 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:07:45 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167458541726.3402179.9455013966732427622.b4-ty@google.com>
Subject: Re: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 06:09:05 +0000, Sean Christopherson wrote:
> Move NMI VM-Exit handling into vmx_vcpu_enter_exit() to fix a (mostly
> benign?) bug where NMIs can be unblocked prior to servicing the NMI that
> triggered the VM-Exit, e.g. if instrumentation triggers a fault and thus
> an IRET.  I deliberately didn't tag any of these for stable@ as the odds
> of me screwing something up or of a backport going sideways seems higher
> than out-of-order NMIs causing major problems.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/7] KVM: x86: Make vmx_get_exit_qual() and vmx_get_intr_info() noinstr-friendly
      https://github.com/kvm-x86/linux/commit/fc9465be8aad
[2/7] KVM: VMX: Allow VM-Fail path of VMREAD helper to be instrumented
      https://github.com/kvm-x86/linux/commit/8578f59657c5
[3/7] KVM: VMX: Always inline eVMCS read/write helpers
      https://github.com/kvm-x86/linux/commit/11633f69506d
[4/7] KVM: VMX: Always inline to_vmx() and to_kvm_vmx()
      https://github.com/kvm-x86/linux/commit/432727f1cb6e
[5/7] x86/entry: KVM: Use dedicated VMX NMI entry for 32-bit kernels too
      https://github.com/kvm-x86/linux/commit/54a3b70a75dc
[6/7] KVM: VMX: Provide separate subroutines for invoking NMI vs. IRQ handlers
      https://github.com/kvm-x86/linux/commit/4f76e86f7e0d
[7/7] KVM: VMX: Handle NMI VM-Exits in noinstr region
      https://github.com/kvm-x86/linux/commit/11df586d774f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
