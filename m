Return-Path: <kvm+bounces-16541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A828BB51D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 22:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AB281C22363
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1482038DE1;
	Fri,  3 May 2024 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uk4zWjEx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F91266D4
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 20:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714769980; cv=none; b=GLzac85caj8Na1+xE/ENngBvnuk41rckCRyyGBDabBrUuEfT0en3uyLLUZS99bF3v6OW7dd1sLui4ejVKb03pVnCxi5OxhH/WmnZq8KqMLzwON/jYL/mehAqTGuRipqyumnuvDdUvY/YVpaJaICmFsIRxrrcsVXoWMlBqwuIAvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714769980; c=relaxed/simple;
	bh=qtFuIsQFdM2j/r+pMmXrk3bCs97wDemTm6+/WdoHAVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f7iQp3fWBluqYFZKIqX/BWQEcmdc6GL8EUXo47R8jxLviax8OKSifRCOE9N3pciZinHb+5cR7ExChmuKT7e9GTDZdOyxABSRehmWvpq0777/YleHYPZ6k+kXlgMpos1WvH+171wmD9tcL59W5a8sTlifn97iqlpmYwO46rb4O5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uk4zWjEx; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so188988276.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 13:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714769978; x=1715374778; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QtLUEpvsyJROtchfvhmmIxlXdhNW7heeQ3g3uz5Bm0k=;
        b=Uk4zWjExORqLdA4WC/ADVmwP/ANqkjJMmiqT7+/6FxecfIj5+YVXaMLp5bJ08hbDda
         +V3W7RMYpdi6OHGDyvgZT/VkMg9Fl1+THM9rcKT5U5APT7iN3VsJ2msjX0orYxz/bpQn
         KlOumUXP/YKviNJ8WfFm1uDC1Oy4+x8nI50pjUCllH7EvyrchwNQ0QgC7cHXXq7S1iTV
         ZCS6IiO7zTxtlxajGovWs6Nn/7e7S7E4GUOqyZkXsNwEXeAUxBKwI5LsPD2gPCV43hQt
         XAXDWPZQHsEWSPalxQR9NRMiKa1qRJzryNxWMX+AobHWpW6Honiwy2kVmlc6LTIwoMfP
         lRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714769978; x=1715374778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QtLUEpvsyJROtchfvhmmIxlXdhNW7heeQ3g3uz5Bm0k=;
        b=fGuuj7CqUfD/YOrHBO/fO3S5nqGpEWHtHxhnbq8fW9w2ok2GXqFfirV8xEYVq3YFeH
         vcL88yvduYpZztrm40cvki+gIO6RwtFYQ7ECGT8xOJh2Tjq6BLYPkRX+0YsVATQhe05O
         IrZqMvyDDhEdciovMXNO95GwRqTPuc7gzFZpV6NBeUV9VleO8KaeZ+U4/LIDYBXCvsMu
         0eoQ1xs37iLmLmil7SZkAqhdt4uT+E+X3Wb/Dpr9BzBBdxohGJxhsANw3dUd6/XV3d+z
         X5NT7+7gp3RPtQk2gR8FszZr7STKafvQUVnkF9RV96rw5U1gmDxpgiHetT8qohnWfNG9
         xWfA==
X-Gm-Message-State: AOJu0YyGucDK8lI0fWLVQvcce3H8rzAkGpZF+fUYIziq0wRXscovxbBs
	N7gb945EX79mKb+vd2n9qKKtY8zorYF18/cz936p/6vzGyo/Bx/DSIeMkVOz5afjfeiQiLanY9o
	SQQ==
X-Google-Smtp-Source: AGHT+IGXRmjZ10br/anwC0a48PRH1DrgrHbY3zRdP5lAU21CAu2MZkJ2oHf+DJasfW0RtwJDSTPBf+LGMX0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18ca:b0:dc6:b813:5813 with SMTP id
 ck10-20020a05690218ca00b00dc6b8135813mr497816ybb.9.1714769977794; Fri, 03 May
 2024 13:59:37 -0700 (PDT)
Date: Fri, 3 May 2024 13:59:36 -0700
In-Reply-To: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
Message-ID: <ZjVQOFLXWrZvoa-Y@google.com>
Subject: Re: [PATCH 1/1] KVM: x86: Print names of apicv inhibit reasons in traces
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 14, 2024, Alejandro Jimenez wrote:
> Use the tracing infrastructure helper __print_flags() for printing flag
> bitfields, to enhance the trace output by displaying a string describing
> each of the inhibit reasons set.
> 
> The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
> value, requiring the user to consult the source file where the inhbit
> reasons are defined to decode the trace output.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> 
> ---
> checkpatch reports an error:
> ERROR: Macros with complex values should be enclosed in parentheses

Yeah, checkpatch is a tool/guide, there are situations where it's best to use
common sense and ignore checkpatch.

> +/*
> + * The inhibit flags in this flag array must be kept in sync with the
> + * kvm_apicv_inhibit enum members in <asm/kvm_host.h>.

Comments are nice, code is better.  And in this case, it's quite easy to assert
that all inhibits have an entry via BUILD_BUG_ON(), e.g. by defining a throwaway
array and asserting that ARRAY_SIZE == NR_APICV_INHIBIT_REASONS.

It's not so easy to add such an assert for the VMX exit reason because the numbers
aren't arbitrary and there are gaps, but for APICv inhibits, the numbers truly
don't matter.

> + */
> +#define APICV_INHIBIT_FLAGS \
> +	{ BIT(APICV_INHIBIT_REASON_DISABLE),		 "DISABLED" }, \

To reduce copy+paste and especially to minimize the number of typos, use another
macro, e.g.

#define __APICV_INHIBIT_REASON(reason)			\
	{ BIT(APICV_INHIBIT_REASON_##reason), #reason }

If the DISABLE vs. DISABLED annoys you enough, feel free to tack on add a patch
to rename the enum itself.

> +	{ BIT(APICV_INHIBIT_REASON_HYPERV),		 "HYPERV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_ABSENT),		 "ABSENT" }, \
> +	{ BIT(APICV_INHIBIT_REASON_BLOCKIRQ),		 "BLOCKIRQ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED), "PHYS_ID_ALIASED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED),	 "APIC_ID_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED),	 "APIC_BASE_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_NESTED),		 "NESTED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_IRQWIN),		 "IRQWIN" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PIT_REINJ),		 "PIT_REINJ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_SEV),		 "SEV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED),	 "LOG_ID_ALIASED" } \
> +
> +#define show_inhibit_reasons(inhibits) \

s/show/print, no reason to introduce yet more terminology.  And it probably makes
sense to use a fully verbose name, e.g. kvm_print_apicv_inhibit_reasons().

> +	__print_flags(inhibits, "|", APICV_INHIBIT_FLAGS)
> +
>  TRACE_EVENT(kvm_apicv_inhibit_changed,
>  	    TP_PROTO(int reason, bool set, unsigned long inhibits),
>  	    TP_ARGS(reason, set, inhibits),
> @@ -1388,9 +1409,12 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
>  		__entry->inhibits = inhibits;
>  	),
>  
> -	TP_printk("%s reason=%u, inhibits=0x%lx",
> +	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
>  		  __entry->set ? "set" : "cleared",
> -		  __entry->reason, __entry->inhibits)
> +		  __entry->reason, __entry->inhibits,
> +		  __entry->inhibits ? " " : "",
> +		  __entry->inhibits ?
> +		  show_inhibit_reasons(__entry->inhibits) : "")

Use the inner macro to print the _entire_ sequence.  The fmt is obviously going
to be coupled with the macro regardless, and so having the macro handle everything
makes it a bit more obvious that the entirety of 0x%lx%s%s of being taken care of.

All in all, sans the potential s/DISABLE/DISABLED rename, this?  Compile tested only.

---
 arch/x86/include/asm/kvm_host.h | 19 +++++++++++++++++++
 arch/x86/kvm/trace.h            |  9 +++++++--
 arch/x86/kvm/x86.c              |  4 ++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..8d9d9a0e9685 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1273,8 +1273,27 @@ enum kvm_apicv_inhibit {
 	 * mapping between logical ID and vCPU.
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
+
+	NR_APICV_INHIBIT_REASONS,
 };
 
+#define __APICV_INHIBIT_REASON(reason)			\
+	{ BIT(APICV_INHIBIT_REASON_##reason), #reason }
+
+#define APICV_INHIBIT_REASONS 				\
+	__APICV_INHIBIT_REASON(DISABLE),		\
+	__APICV_INHIBIT_REASON(HYPERV),			\
+	__APICV_INHIBIT_REASON(ABSENT),			\
+	__APICV_INHIBIT_REASON(BLOCKIRQ),		\
+	__APICV_INHIBIT_REASON(PHYSICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(APIC_ID_MODIFIED),	\
+	__APICV_INHIBIT_REASON(APIC_BASE_MODIFIED),	\
+	__APICV_INHIBIT_REASON(NESTED),			\
+	__APICV_INHIBIT_REASON(IRQWIN),			\
+	__APICV_INHIBIT_REASON(PIT_REINJ),		\
+	__APICV_INHIBIT_REASON(SEV),			\
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 9d0b02ef307e..f23fb9a6776e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1375,6 +1375,10 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
+#define kvm_print_apicv_inhibit_reasons(inhibits)	\
+	(inhibits), (inhibits) ? " " : "",		\
+	(inhibits) ? __print_flags(inhibits, "|", APICV_INHIBIT_REASONS) : ""
+
 TRACE_EVENT(kvm_apicv_inhibit_changed,
 	    TP_PROTO(int reason, bool set, unsigned long inhibits),
 	    TP_ARGS(reason, set, inhibits),
@@ -1391,9 +1395,10 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
 		__entry->inhibits = inhibits;
 	),
 
-	TP_printk("%s reason=%u, inhibits=0x%lx",
+	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
 		  __entry->set ? "set" : "cleared",
-		  __entry->reason, __entry->inhibits)
+		  __entry->reason,
+		  kvm_print_apicv_inhibit_reasons(__entry->inhibits))
 );
 
 TRACE_EVENT(kvm_apicv_accept_irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b389129d59a9..ea1ef901fb8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10011,6 +10011,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_apicv_activated);
 static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
 				       enum kvm_apicv_inhibit reason, bool set)
 {
+	const struct trace_print_flags apic_inhibits[] = { APICV_INHIBIT_REASONS };
+
+	BUILD_BUG_ON(ARRAY_SIZE(apic_inhibits) != NR_APICV_INHIBIT_REASONS);
+
 	if (set)
 		__set_bit(reason, inhibits);
 	else

base-commit: 04b1c6b4841dc319810db044e887219e05fae27f
-- 

