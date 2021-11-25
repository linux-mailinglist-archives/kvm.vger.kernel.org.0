Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B373445E12D
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244587AbhKYTya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350347AbhKYTwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:52:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BFDC0617A5;
        Thu, 25 Nov 2021 11:46:44 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637869603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xPaY7H5MeXd/VBzGflDkJzF9Px86MwziChYTFnEAaGM=;
        b=D9ehhctMdpNiEpkdetxYHbJ6CF0Uf+WZwNcjJgBj0EmuDorLnMmubAn+Y415QaP+hIYXmp
        lGiNbEKfHKkd+yN7oSC4iCrJ/Z7r1+IMCt9U2RcnyfrKWWRE5Vcon1bCpy8o9UE9QiRJLK
        PbAnLVEs+D8TImVA8JVAHKiI+cp+2DLedLbubh4zhF6umy3UykxYMtTLIksprkm+tc1PVh
        f9M38DcI0G5PurSsW+1T3Ob6Qk1a5bi93drK1tPFIv9huEPTxnCQG4y8gB+BNaHkkIiJi2
        M5s7EJUKn21Vf8CFccoMG4+KIoA91OfJ2QhyLYLB6VRxTJvIaJmZX+lw9HX3yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637869603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xPaY7H5MeXd/VBzGflDkJzF9Px86MwziChYTFnEAaGM=;
        b=TLpNGuocyBxtHHUH5vFr9qJBrqAi+todGKd/FI3Go8uSJsvuExNffr9GA9QDVaTDRU0+nG
        eP50V/VgqTB8RqBQ==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 26/59] KVM: x86: Introduce vm_teardown() hook in
 kvm_arch_vm_destroy()
In-Reply-To: <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:46:42 +0100
Message-ID: <87a6hsj9wd.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
> destruction path, which needs to first put the VM into a teardown state,
> then free per-vCPU resource, and finally free per-VM resources.
>
> Note, this knowingly creates a discrepancy in nomenclature for SVM as
> svm_vm_teardown() invokes avic_vm_destroy() and sev_vm_destroy().
> Moving the now-misnamed functions or renaming them is left to a future
> patch so as not to introduce a functional change for SVM.

That's just the wrong way around. Fixup SVM first and then add the TDX
muck on top. Stop this 'left to a future patch' nonsense. I know for
sure that those future patches never materialize.

The way it works is:

    1) Refactor the code to make room for your new functionality in a
       way that the existing code still works.

    2) Add your new muck on top.

Anything else is not acceptable at all.

Thanks,

        tglx
