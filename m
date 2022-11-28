Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADBA63B09B
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 18:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiK1R6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 12:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiK1R6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 12:58:21 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1BC3C6F2
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:46:28 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so12956212pjt.0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 09:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yt+6ZsFhHbg9VXiMxe9kvr7coxEz5653nTiwyPOx528=;
        b=M602G5EP/uN3K4grhCY6Shfqyo+fxipZ4KWTTuEwvKP/eqEFyLVW8NRu3X89MxlYzY
         2YxMA/Xzs8zAJzyf6jPcLQ4GfFKkYV0x4ISr2XKqchK3Jx02Ax36vhA7NAHk+OlvcL9L
         dhUWN6THrPOaW9jyniNJVqtSlrT1HM/5Rs38XmlzlfhbjFUlDH1WUN9NFhgs4Woi2QUy
         dSaL+EXTRy9/9LYpnXYEof4+I3HUdFPAkdSlv4P+catGH0hbvukplczpguDKxoYPrmqE
         tG2tILO4kQFHaOVGFjY3QTXfDjAVfsUp3fXL8P/5duSeu2XyVbr48YvIGFiWBkYFgEMf
         SPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yt+6ZsFhHbg9VXiMxe9kvr7coxEz5653nTiwyPOx528=;
        b=bRUpXRCXk5pJlQraPla0NWNMlAVweew/bOvGoAkvlqmyHgej2kMTbylCI98iV8aL07
         X1Lu155c2wfVCvSWIl6eagjBPJFfhBdr6VDexHbOwSg0Yk775rfCuf6b7jv6qCWTkC4a
         u3KFW/+caXtlvU+SOB+sVF7T5VqDBK4zvlZ4ErS/luzJvSH4I74Vu4Wr7aTQe7BXgJcR
         m683Mtfc34f68w9lR7qy89/ujL7PIVskt8NM68hEjCPrKDRU/3r9RCHDf++f0rCXYSnA
         pcpUEIjLr/g1Pvgu9L1L+BAvkhpQZ65BIL8w9DvAnnytXhRU94ELccBtnGrlN5iOR6mI
         93nQ==
X-Gm-Message-State: ANoB5pndwi2MYa/iT/GnwZx02/S6VZqiYHcg6Um/RmG1ELengIuyM153
        qe6yOZu0LGBLlF6wSdt7d2aaMw==
X-Google-Smtp-Source: AA0mqf6RR+CKCljliuYRRA/Xk2TOOtJ2SX5gEyk55ktJ9yFGoMm9S7KlVOyhhodEO8xdzKB+0DNV8w==
X-Received: by 2002:a17:902:7087:b0:189:4de4:e71b with SMTP id z7-20020a170902708700b001894de4e71bmr25875312plk.159.1669657578962;
        Mon, 28 Nov 2022 09:46:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e5ca00b00189371b5971sm9176020plf.220.2022.11.28.09.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 09:46:18 -0800 (PST)
Date:   Mon, 28 Nov 2022 17:46:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: x86/mmu: replace BUG() with KVM_BUG() in
 shadow mmu
Message-ID: <Y4Tz5zd9qXBiR0Pr@google.com>
References: <20221128002043.1555543-1-mizhang@google.com>
 <20221128002043.1555543-3-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128002043.1555543-3-mizhang@google.com>
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

On Mon, Nov 28, 2022, Mingwei Zhang wrote:
> Replace BUG() in pte_list_remove() with KVM_BUG() to avoid crashing the
> host. MMU bug is difficult to discover due to various racing conditions and
> corner cases and thus it extremely hard to debug. The situation gets much
> worse when it triggers the shutdown of a host. Host machine crash
> eliminates everything including the potential clues for debugging.
> 
> From cloud computing service perspective, BUG() or BUG_ON() is probably no
> longer appropriate as the host reliability is top priority.

I don't think we need to bring "cloud computing" into this.  Linus has made it
clear over and over and over that BUG() / BUG_ON() need to be avoided unless
the alternative is worse.  E.g. the BUG() in __handle_changed_spte() is warranted
because the alternative is silent corruption of guest data.

> Crashing the physical machine is almost never a good option as it eliminates
> innocent VMs and cause service outage in a larger scope. Even worse, if
> attacker can reliably triggers this code by diverting the control flow or
> corrupting the memory,

Or if there's a KVM bug, which is waaaaay more likely.

> then this becomes vm-of-death attack.

This is true of any BUG(), and really of any unexpected fault while holding a
spinlock, e.g. NULL pointer derefs in the MMU are almost always fatal as well.

> This is a huge attack vector to cloud providers, as the death of one single
> host machine is not the end of the story. Without manual interferences, a
> failed cloud job may be dispatched to other hosts and continue host crashes
> until all of them are dead.
> 
> Because of the above reasons, shrink the scope of crash to the target VM
> only. KVM_BUG() and KVM_BUG_ON() requires a valid struct kvm which requires
> extra plumbing. Avoid it in this version by just using
> kvm_get_running_vcpu()->kvm instead.

Stale comment.

> Cc: Nagareddy Reddy <nspreddy@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b5a44b8f5f7b..e132d82ab4c0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -956,12 +956,12 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
>  
>  	if (!rmap_head->val) {
>  		pr_err("%s: %p 0->BUG\n", __func__, spte);

These probably need to be ratelimited (or "once").  Bugging the VM will prevent
doing anything useful with the VM, but KVM still needs to destroy the VM, which
means zapping SPTEs and purging the rmaps.  Theoretically, there could be thousands
of broken rmaps.

> -		BUG();
> +		KVM_BUG(true, kvm, "");

If you don't want to provide a message, use KVM_BUG_ON(), not an empty message.
Though my vote would be to fold the existing pr_err() messages into KVM_BUG(),
which would make the WARN much more helpful and would address the pr_err() issue
above.  The __func__ printing can also go away in that case because the stack
track will provide all the necessary info.  The only reason not to drop the
pr_err() entirely is if a ratelimited message is helpful for debugging failures
that occur in production, which I doubt it true.

And rather than pass "true", wrap the actual check with the KVM_BUG().

>  	} else if (!(rmap_head->val & 1)) {
>  		rmap_printk("%p 1->0\n", spte);
>  		if ((u64 *)rmap_head->val != spte) {
>  			pr_err("%s:  %p 1->BUG\n", __func__, spte);
> -			BUG();
> +			KVM_BUG(true, kvm, "");

KVM needs to return here, otherwise KVM is knowingly writing a garbage pointer,
e.g. will corrupt memory or trigger a fault.

>  		}
>  		rmap_head->val = 0;
>  	} else {

Something like this?

---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b5a44b8f5f7b..12790ccb8731 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -954,15 +954,16 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	struct pte_list_desc *prev_desc;
 	int i;
 
-	if (!rmap_head->val) {
-		pr_err("%s: %p 0->BUG\n", __func__, spte);
-		BUG();
-	} else if (!(rmap_head->val & 1)) {
+	if (KVM_BUG(!rmap_head->val, kvm, "rmap for %p is empty", spte))
+		return;
+
+	if (!(rmap_head->val & 1)) {
 		rmap_printk("%p 1->0\n", spte);
-		if ((u64 *)rmap_head->val != spte) {
-			pr_err("%s:  %p 1->BUG\n", __func__, spte);
-			BUG();
-		}
+
+		if (KVM_BUG((u64 *)rmap_head->val != spte, kvm,
+			    "single rmap for %p doesn't match", spte))
+			return;
+
 		rmap_head->val = 0;
 	} else {
 		rmap_printk("%p many->many\n", spte);
@@ -979,8 +980,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 			prev_desc = desc;
 			desc = desc->more;
 		}
-		pr_err("%s: %p many->many\n", __func__, spte);
-		BUG();
+		KVM_BUG(true, kvm, "no rmap for %p (many->many)", spte);
 	}
 }
 

base-commit: d74237e747db7f9f27e821e6683d58185e846378
-- 

