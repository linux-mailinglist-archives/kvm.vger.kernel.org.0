Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AF331C38
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCIBSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCIBSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:18:17 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10571C06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 17:18:17 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id x29so7636951pgk.6
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 17:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BqD+DZIvHH7YPw/1ZQENRDv1EsYaakuAnsa/AEKRf3Q=;
        b=Hrd6e8WCMifdZ5q39xonuKO7wCdvps+knxuDZjQRUGo4Sa5bQqMQwdCdDA3qTX8VLe
         lGL2w+htvYCpJV3ywJ32OvbKNakp/5ewTHmzSaPEZE/1Z3/wQTLbgdqC9x2VF0dIbNjw
         /cWaA6UF7O5ACS8s1s2HXi0PONVQzQ/oksG/jTqVopWo8FtaaXZb4/zk937T0GIlQENa
         W43x8ESwo1iWhhOqJ56y2O6ybA+fgIGZhQFGyf3P3g6Dqo1B7yjy99sYgAsEScRqHz/N
         /FSIrzxfF4LLZcIEKdGMtud+pcR3V5E5LDoYeb4MN1+hW2hiYcFx+3q65dhX11fwQXxB
         jPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BqD+DZIvHH7YPw/1ZQENRDv1EsYaakuAnsa/AEKRf3Q=;
        b=Iz2YLA5KPrAOJdqsQsXjRMl8if2zUBjWN7TWZLLtlJcNjvZsIHYiili2cHyTG/Jels
         P/YTPVWZpnzeByZb12EbhH8j8Xz3fYcMXf9zTZZlPQnHhOEimtAkUlM1iwgidtiISu8W
         kVPM9d1R1fCJtP0Cj93jLL8irNrOrvyFcs2xj0yit0Id7T/78JSH1Gz1ASV/fGq3dUde
         KUwlWjt06lMag1JnXcAdm0Zb2sGMmeJ9yqO1tzA45l+0lW5pg7ImgUsXoTUngTnHeH6S
         TBaJ38+97iIg3vsFu7XlUMEsL4ZarPzUGAMjp5euOkoK69ASc+wfoq1i70CI7od0SAtC
         8kwA==
X-Gm-Message-State: AOAM532XrjpNdPOP2EwPdaCxtqslgq4cwHUMFekXqnrCzY1efYpgpck9
        2uky7bTWqbYWVuOplkjn1wd3Gw==
X-Google-Smtp-Source: ABdhPJy7Ui7Qq3O0g/aUgGaVF5rUnu8j0o48Uh+0gjg+aUV2HzJKBQOLppPZFevCD9/SPhC6qkp77w==
X-Received: by 2002:a63:225f:: with SMTP id t31mr14760442pgm.371.1615252696330;
        Mon, 08 Mar 2021 17:18:16 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id y194sm1255599pfb.21.2021.03.08.17.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 17:18:15 -0800 (PST)
Date:   Mon, 8 Mar 2021 17:18:09 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
Message-ID: <YEbM0SYpnfcTnfdA@google.com>
References: <20210305183123.3978098-1-seanjc@google.com>
 <f1edcb01-41f5-d26f-e8d6-0dbd09a1eb89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1edcb01-41f5-d26f-e8d6-0dbd09a1eb89@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Paolo Bonzini wrote:
> On 05/03/21 19:31, Sean Christopherson wrote:
> > Sean Christopherson (11):
> >    KVM: x86: Get active PCID only when writing a CR3 value

...

> Huh, I was sure I had queued this already for 5.12.  Well, done so now.

Maybe this series is cursed.  The first patch got mangled and broke SME.
It shows up as two commits with the same changelog, so maybe you intended to
split the patch and things went sideways?

Anyways, commit a16241ae56fa ("KVM: x86: Get active PCID only when writing a
CR3 value") breaks SME and PCID.  The kvm/queue code looks like this:


	cr3 = __sme_set(root_hpa);
	if (npt_enabled) {
		svm->vmcb->control.nested_cr3 = root_hpa;
		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);

		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
			return;
		cr3 = vcpu->arch.cr3;
	}

	svm->vmcb->save.cr3 = cr3;
	vmcb_mark_dirty(svm->vmcb, VMCB_CR);

but it should look like this:

	if (npt_enabled) {
		svm->vmcb->control.nested_cr3 = __sme_set(root);
		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);

		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
			return;
		cr3 = vcpu->arch.cr3;
	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
		cr3 = __sme_set(root);
	} else {
		cr3 = root;
	}

	svm->vmcb->save.cr3 = cr3;
	vmcb_mark_dirty(svm->vmcb, VMCB_CR);

I'll generate a delta patch, and test and post, just in case there is other
stuff that got lost.
