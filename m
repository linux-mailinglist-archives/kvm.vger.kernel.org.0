Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B798441EF5
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 18:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhKARFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhKARFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 13:05:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6D8C061714
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 10:03:13 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g11so5575638pfv.7
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 10:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9jmaprMzfvGM//cnEp8z2O+LdLStElBxBjXYKcZ//K8=;
        b=TACkdrw3Njw2UEI8tDBiyiovjrgRFZ4pTA+hbyT+PmaovNH/Gb4iSqOkLIH4H9jWxK
         MDvhKzErzFWoyvH3MnVTWsWqjbpJB/ZJxqpU/q+l/A6hnxBdrWbgTbj8C8uHr+mer8Ag
         fSxl4WN7+p9oc3t8O+MpYHtPbR9zbvw/0vTOkbRMcgsztl9HGgKITLJmegI4P7X68rf/
         18R93rp1oQYoym4gNAI4zAqdQIl5NuW1Vq1W8lZ+ita1ivqutySTEIjhRgPqCqDnNkB8
         Ipf4AuZyhNf4kwuowtM89Ls8l/39aU3VTX+0/raA/E7dWKax7ljM5qlXJo1tFnwF3h3e
         Qlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9jmaprMzfvGM//cnEp8z2O+LdLStElBxBjXYKcZ//K8=;
        b=dyIqDVtwPi2A77t1lz0x/EcydmweKIX1ZEDVLyh/XQl4MAo7UTvx/PISrzjx3tDxXz
         jrR9lVBqemCWppKz+KuLlDlKvIrWh4hYq8R4Vgxb0XV1YQ5VbhZjduOw7oYqLnVja5bB
         TsAn46KbWUf7IGMxFmTrvzaL5J1ZvELbBxnaypJAYAqeYkvkH7jkDIH4W0oVW0KL7zo3
         oNbnel4BbB4CLHnusa+Y8Nbo9c524H3h6MKsWKOo7RDtA0BF8pIcbLXwbf1GYSmbi1Ck
         ZVbokjXgco4foGSp78ld7BmvBesQKitL3hRFHkHXkOdwdvXjU4hEY046yO3YUSzPUsC4
         JjvA==
X-Gm-Message-State: AOAM532CNtejpxJZGK1YF3Sud+OjfRA2vxAo69uDQVB4K3KWlOPy793z
        G++sncDsWdq/4M8U9PZCisvQvg==
X-Google-Smtp-Source: ABdhPJw6UT48ybineUn4i5nfJoy7XGT+zPIgLcT3KdQxiM0cHg8GMpehYFNC3S+NG52IiKq2aQqp4A==
X-Received: by 2002:a63:b145:: with SMTP id g5mr22685481pgp.355.1635786188318;
        Mon, 01 Nov 2021 10:03:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x9sm37310pjp.50.2021.11.01.10.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 10:03:07 -0700 (PDT)
Date:   Mon, 1 Nov 2021 17:03:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: fix instruction skipping when handling UD
 exception
Message-ID: <YYAdxzI6f+pkymKX@google.com>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
 <8ad4de9dae77ee3690ee9bd3c5a51d235d619eb6.1634870747.git.houwenlong93@linux.alibaba.com>
 <YXgu3pvk+Ifrl0Yu@google.com>
 <20211029105749.GA113630@k08j02272.eu95sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029105749.GA113630@k08j02272.eu95sqa>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Hou Wenlong wrote:
> On Tue, Oct 26, 2021 at 04:37:50PM +0000, Sean Christopherson wrote:
> > On Fri, Oct 22, 2021, Hou Wenlong wrote:
> > +static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
> > +{
> > +	if (vcpu->run->msr.error) {
> > +		kvm_inject_gp(vcpu, 0);
> > +		return 1;
> > +	}
> > +
> > +	return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
> > +}

...

> The note in x86_emulate_instruction() for EMULTYPE_SKIP said that the
> caller should be responsible for updating interruptibility state and
> injecting single-step #DB.

Urgh, yes.  And that note also very clear states it's for use only by the vendor
callbacks for exactly that reason.

> And vendor callbacks for kvm_skip_emulated_instruction() also do some special
> things,

Luckily, the emulator also does (almost) all those special things.

> e.g. I found that sev_es guest just skips RIP updating.

Emulation is impossible with sev_es because KVM can't decode the guest code stream,
so that particular wrinkle is out of scope.

> So it may be more appropriate to add a parameter for skip_emulated_instruction()
> callback, which force to use x86_skip_instruction() if the instruction length
> is invalid.

I really don't like the idea of routing this through kvm_skip_emulated_instruction(),
anything originating from the emulator ideally would be handled within the emulator
when possible, especially since we know that KVM is going to end up in the emulator
anyways.

The best idea I can come up with is to add a new emulation type to pair with _SKIP
to handle completion of user exits.  In theory it should be a tiny code change to
add a branch inside the EMULTYPE_SKIP path.

On a related topic, I think EMULTYPE_SKIP fails to handled wrapping EIP when the
guest has a flat code segment.

So this:

From e3511669c40e4d074fb19f43256fc5da8634af14 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 1 Nov 2021 09:52:35 -0700
Subject: [PATCH] KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with
 flat code seg

Truncate the new EIP to a 32-bit value when handling EMULTYPE_SKIP as the
decode phase does not truncate _eip.  Wwrapping the 32-bit boundary is
legal if and only if CS is a flat code segment, but that check is
implicitly handled in the form of limit checks in the decode phase.

Opportunstically prepare for a future fix by storing the result of any
truncation in "eip" instead of "_eip".

Fixes: 1957aa63be53 ("KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..3d7fc5c21ceb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8124,7 +8124,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * updating interruptibility state and injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
-		kvm_rip_write(vcpu, ctxt->_eip);
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
+			ctxt->eip = (u32)ctxt->_eip;
+		else
+			ctxt->eip = ctxt->_eip;
+
+		kvm_rip_write(vcpu, ctxt->eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		return 1;
--


followed by the rework with complete_emulated_msr_access() doing
"EMULTYPE_SKIP | EMULTYPE_COMPLETE_USER_EXIT" with this as the functional change
in the emulator:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d7fc5c21ceb..13d4758810d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8118,10 +8118,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                return 1;
        }

+
        /*
-        * Note, EMULTYPE_SKIP is intended for use *only* by vendor callbacks
-        * for kvm_skip_emulated_instruction().  The caller is responsible for
-        * updating interruptibility state and injecting single-step #DBs.
+        * EMULTYPE_SKIP without is EMULTYPE_COMPLETE_USER_EXIT intended for
+        * use *only* by vendor callbacks for kvm_skip_emulated_instruction().
+        * The caller is responsible for updating interruptibility state and
+        * injecting single-step #DBs.
         */
        if (emulation_type & EMULTYPE_SKIP) {
                if (ctxt->mode != X86EMUL_MODE_PROT64)
@@ -8129,6 +8131,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                else
                        ctxt->eip = ctxt->_eip;

+               if (emulation_type & EMULTYPE_COMPLETE_USER_EXIT)
+                       goto writeback;
+
                kvm_rip_write(vcpu, ctxt->eip);
                if (ctxt->eflags & X86_EFLAGS_RF)
                        kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
@@ -8198,6 +8203,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
        else
                r = 1;

+writeback:
        if (writeback) {
                unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
                toggle_interruptibility(vcpu, ctxt->interruptibility);
