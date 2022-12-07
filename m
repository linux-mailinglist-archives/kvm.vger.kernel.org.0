Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F70645E7F
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 17:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLGQNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 11:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGQNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 11:13:11 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D563F4A067
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 08:13:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y4so17471947plb.2
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 08:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpxR1PTMWS3Amx0aRq58+f4tsWCZcZnYsG2feZry+d0=;
        b=Cp3yXXnkeblAnu8W1rSv0WkmnPoliQNXcW6cVlxwBtomn1Wyoaf7J/JOFXJDTGzk6l
         v3F9czRTh0qbK7/gmEdURTw/IK9A4R3zZItuBs4i2q8Bzs2aE9aJD3rQ24FbSubDYv9v
         QSRlS72u4Lj2EgOzZnkIsN0S05aIAYddH3er22NRP/2ZmGmzu1ISqyUn+EsOeBeCUWMW
         U75FwcOLTVqbTMTYOKTekhpAAhruuVlwbLZZoQ5n9cpFLooc6PA/MS4+taOM8QoNe43U
         wkLmHyla03eh9NYDBm7HNzn6Y6Liz/7dDIFrrPzvudDs6MFJwVKZQR0dW/+cHlvnDg2e
         vXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpxR1PTMWS3Amx0aRq58+f4tsWCZcZnYsG2feZry+d0=;
        b=m7Kvj4eLD5GqfLQktl7HqqOru8m8exFV2GlHlR3bNUfz2PlIHSoiRlIHsfbKVkHkrj
         MmFrNRm5Q5gKJHgI3WAa7UfuxI3nXVuibUoLkMAgnK2AZxiv94Boj1Kan8NjQhsG/TV9
         keNN56P1t0w30zz+5dvZOWVeKWQkIR8rR9EFgsvjzsoh/O/AP+fT4VeLRXS8LI8LgGDx
         j6BYA5Gs7dr/3hHF5dem+534hHgK2u+RP9+zwSJFKCChaJetCK2ezoha85i+MjKD6SL/
         OYwadeqiwwScvs43ez2geFFjFbkV1YgmEHPhcldJTb9aA84dyuBOJrYVausoip/XxJd/
         eEsA==
X-Gm-Message-State: ANoB5pnEX/6VS0Tn3GVwl125TYzsh1AULD6KFl/MNoaFGBHLBzoKNQZL
        p/o9DvEJXfvCKrqJETJljx9SJA==
X-Google-Smtp-Source: AA0mqf4lFybpW2Ej0EN6IrV8xrgLjwNbPBI5T5JN0hhEHYdw0y7sXW25tuvI7yxwT9O96Zgf8atKKw==
X-Received: by 2002:a05:6a21:9996:b0:a4:efde:2ed8 with SMTP id ve22-20020a056a21999600b000a4efde2ed8mr1710800pzb.0.1670429590170;
        Wed, 07 Dec 2022 08:13:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m5-20020a63ed45000000b0047829d1b8eesm11654097pgk.31.2022.12.07.08.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:13:09 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:13:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Adamos Ttofari <attofari@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: ioapic: Fix level-triggered EOI and userspace
 IOAPIC reconfigure race
Message-ID: <Y5C7kja3slowNfgT@google.com>
References: <20221207091324.89619-1-attofari@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207091324.89619-1-attofari@amazon.de>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022, Adamos Ttofari wrote:
> When split-irqchip is used KVM uses ioapic_handled_vectors to identify
> which vectors require an exit to userspace IOAPIC. Unfortunately, when the
> IOAPIC is reconfigured while the interrupt is being handled, it will use
> the newest configuration; therefore, the EOI will not be delivered to
> IOAPIC.
> 
> A previous commit 0fc5a36dd6b3

No need for "A previous", the fact that there's a stable commit hash means it
happened in the past.

> ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
> fixed the race for kernel ioapic, but the issue still persists for

s/ioapic/IOAPIC to be consistent, and because the I/O APIC is a proper thing.

> userspace IOAPIC:
> 
> 1) Userspace IOAPIC sends a level triggered interrupt to VCPU0.
> 2) VCPU0's handler reconfigures the IOAPIC to route the interrupts to
>    VCPU1. (This can cause userspace IOAPIC to commit a new routing table,
>    eventually leading KVM to unset the vector in ioapic_handled_vectors)
> 3) VCPU0 triggers an EOI, and it's not delivered to userspace IOAPIC
>    because the vector bit is not set in ioapic_handled_vectors.
> 4) The loss of EOI, leaves remote_irr in IOAPIC set. Eventually blocking
>    new interrupts.
> 
> To avoid the above scenario, we

Please avoid pronouns in shortlogs, changelogs, and comments, as pronouns are
often ambiguous.  "it" and "they" are ok if the thing(s) being referred to is
a/the subject and was recently introduced/referenced, e.g. in the same sentence,
but "we", "us", "I", and "me" should never be used.

> should apply a similar fix like

State what the patch actually does, not what it "should" or "might" do.

> commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC
> reconfigure race") Which

Lack of punctuation, followed by random capitalization.

> is to add all pending and running vectors to ioapic_handled_vectors.

Please describe what this actually does (intercepts EOI for the relevant vectors).

For the changelog as a whole, some maintainers/subsystems prefer leading with the
"why", but I strongly prefer that changelogs state what the patch actually does
and then provide the background/justification.

Copy-pasting from a prior discussion[*]:

 : To some extent, it's a personal preference, e.g. I
 : find it easier to understand the details (why something is a problem) if I have
 : the extra context of how a problem is fixed (or: what code was broken).
 : 
 : But beyond personal preference, there are less subjective reasons for stating
 : what a patch does before diving into details.  First and foremost, what code is
 : actually being changed is the most important information, and so that information
 : should be easy to find.  Changelogs that bury the "what's actually changing" in a
 : one-liner after 3+ paragraphs of background make it very hard to find that information.
 : 
 : Maybe for initial review one could argue that "what's the bug" is more important,
 : but for skimming logs and git archeology, the gory details matter less and less.
 : E.g. when doing a series of "git blame", the details of each change along the way
 : are useless, the details only matter for the culprit; I just want to quickly
 : determine whether or not a commit might be of interest.
 : 
 : Another argument for stating "what's changing" first is that it's almost always
 : possible to state "what's changing" in a single sentence.  Conversely, all but the
 : most simple bugs require multiple sentences or paragraphs to fully describe the
 : problem.  If both the "what's changing" and "what's the bug" are super short then
 : the order doesn't matter.  But if one is shorter (almost always the "what's changing),
 : then covering the shorter one first is advantageous because it's less of an
 : inconvenience for readers/reviewers that have a strict ordering preference.  E.g.
 : having to skip one sentence to get to the stuff you care about is less painful than
 : me having to skip three paragraphs to get to the stuff that I care about.

And similar to the suggestion that was made in that discussion, the changelog for
this patch could be:

  When scanning userspace IOAPIC entries, intercept EOI for level-triggered
  IRQs if the current vCPU has a pending and/or in-service IRQ for the
  vector in its local API, even if the vCPU doesn't match the new entry's
  destination.  This fixes a race between userspace IOAPIC reconfiguration
  and IRQ delivery that results in the vector's bit being left set in the
  remote IRR due to the eventual EOI not being forwarded to the userspace
  IOAPIC.

  Commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC
  reconfigure race") fixed the in-kernel IOAPIC, but not the userspace
  IOAPIC configuration, which has a similar race.

  <wall of text>

[*] https://lore.kernel.org/all/YurKx+gFAWPvj35L@google.com

> Fixes: 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and IOAPIC reconfigure race")
> 
> Signed-off-by: Adamos Ttofari <attofari@amazon.de>
> ---
>  arch/x86/kvm/irq_comm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 0687162c4f22..36d65997a212 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -426,8 +426,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>  			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
>  
>  			if (irq.trig_mode &&
> -			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> -						irq.dest_id, irq.dest_mode))
> +			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT, irq.dest_id,
> +				 irq.dest_mode) || kvm_apic_pending_eoi(vcpu, irq.vector)))

This formatting, or lack thereof, is extremely difficult to read.  It also
unnecessarily runs a fair bit over the 80 char soft limit.

			if (irq.trig_mode &&
			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
			    			 irq.dest_id, irq.dest_mode) ||
			     kvm_apic_pending_eoi(vcpu, irq.vector)))
				__set_bit(irq.vector, ioapic_handled_vectors);
