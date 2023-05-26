Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21683711B07
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbjEZAIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 20:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEZAIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 20:08:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E21BF
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 17:07:46 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2537262fad8so200239a91.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 17:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685059666; x=1687651666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgwBf1vpedGR6Qn5q5IWeDAXWFWpxuHGkgwFvsEdueA=;
        b=RSPcntvLhDvt762w9zQ6wbJTgsueyfNVhOy2LeHkU2pQAuhmVebW/jli9EV2Uneg7Q
         BFRgQL4psymD4eB9vfLNDJ5tOWLVGXHygXF1rg3RBJXFDpuE+fgHXgMfG+HFil0c0BOt
         AbnDLQNC/Ve8E9X5cLzi+v37wr/xEPBYPiEKiZtrnZ+Az6myffEgKXvxWVzcOwuZuapJ
         PPvNbXu5skOI8K7R7kRX79MP8PEDA1J4EHHvq6/CSq81V0rUa/8D2Lx3oKMG2tUC1cDh
         fLRBXO1glR5GXl2nlTfVqBgXHLJzh/+D6MHaJ9SvZXrclK7AcJceiX5zGkAYdZ5sBKgJ
         Gtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685059666; x=1687651666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgwBf1vpedGR6Qn5q5IWeDAXWFWpxuHGkgwFvsEdueA=;
        b=Xcud/bxKALZQ1QRszREgDWuS+xWaIW7lMFTTK2WbqAkvCfnWZjjw0v9LW+IOJV20dh
         a4C1Iqt76qoOTWH0DNXS4Q//z1xKZK6FR5znEpPj9D2xlZcsOGXQw32nZ1erjqKJjWym
         YD36WQw/KG6csfZZJ6ok3iMi+FkS+YVai56VHdgr+f85lDzTTCff+tY1wratV4aN8WZA
         NcjC4msxrh3N9ufSiIvqYM3b60NU0s0lTnIlbtZnHmiDjTLdM+Qs2+AnOloewV6r+QDg
         KLIeFL7zYW6II5sRCUfFmFpTU0xcoqwSh7TYewdPz2Jc9ziWJj/2so5LEsZtPUCvjjTj
         b3Sw==
X-Gm-Message-State: AC+VfDxndncHagPjFaPBWNAfzpjG0CNXllmG6QouIsD2ueuV+E+YNAya
        hhoolU5vsxaTHZX+OFsD2ilNbtDNl9Y=
X-Google-Smtp-Source: ACHHUZ5y0DY3/z5sYSxQLn2fjFdAynG+vT9yVfye3FKuY1U1O7U65cL9yt3YnGPWoULEDbPez5Y4FR+w8pw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f490:b0:256:2192:2c58 with SMTP id
 bx16-20020a17090af49000b0025621922c58mr201955pjb.4.1685059665776; Thu, 25 May
 2023 17:07:45 -0700 (PDT)
Date:   Thu, 25 May 2023 17:07:44 -0700
In-Reply-To: <20230525183347.2562472-2-mhal@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-2-mhal@rbox.co>
Message-ID: <ZG/4UN2VpZ1a6ek1@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Fix out-of-bounds access in kvm_recalculate_phys_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023, Michal Luczaj wrote:
> Handle the case of vCPU addition and/or APIC enabling during the APIC map
> recalculations. Check the sanity of x2APIC ID in !x2apic_format &&
> apic_x2apic_mode() case.
> 
> kvm_recalculate_apic_map() creates the APIC map iterating over the list of
> vCPUs twice. First to find the max APIC ID and allocate a max-sized buffer,
> then again, calling kvm_recalculate_phys_map() for each vCPU. This opens a
> race window: value of max APIC ID can increase _after_ the buffer was
> allocated.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e542cf285b51..39b9a318d04c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>  		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
>  		 * map requires a strict 1:1 mapping between IDs and vCPUs.
>  		 */
> -		if (apic_x2apic_mode(apic))
> +		if (apic_x2apic_mode(apic)) {
> +			if (x2apic_id > new->max_apic_id)
> +				return -EINVAL;

Hmm, disabling the optimized map just because userspace created a new vCPU is
unfortunate and unnecessary.  Rather than return -EINVAL and only perform the
check when x2APIC is enabled, what if we instead do the check immediately and
return -E2BIG?  Then the caller can retry with a bigger array size.  Preemption
is enabled and retries are bounded by the number of possible vCPUs, so I don't
see any obvious issues with retrying.

And I vote to also add a sanity check on xapic_id, if only to provide documentation
as to why it can't overflow.

I think hoisting the checks up would also obviate the need for cleanup (patch 2),
which I agree isn't obviously better.

E.g. this?  Compile tested only.  I'll test more tomorrow unless you beat me to
it.  Thanks for the fun bugs, as always :-)

---
 arch/x86/kvm/lapic.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e542cf285b51..cd34b88c937a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -228,6 +228,12 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 	u32 xapic_id = kvm_xapic_id(apic);
 	u32 physical_id;
 
+	if (WARN_ON_ONCE(xapic_id >= new->max_apic_id))
+		return -EINVAL;
+
+	if (x2apic_id >= new->max_apic_id)
+		return -E2BIG;
+
 	/*
 	 * Deliberately truncate the vCPU ID when detecting a mismatched APIC
 	 * ID to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a
@@ -253,8 +259,7 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 	 */
 	if (vcpu->kvm->arch.x2apic_format) {
 		/* See also kvm_apic_match_physical_addr(). */
-		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
-			x2apic_id <= new->max_apic_id)
+		if (apic_x2apic_mode(apic) || x2apic_id > 0xff)
 			new->phys_map[x2apic_id] = apic;
 
 		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
@@ -366,6 +371,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	unsigned long i;
 	u32 max_id = 255; /* enough space for any xAPIC ID */
 	bool xapic_id_mismatch = false;
+	int r;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -386,6 +392,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		return;
 	}
 
+retry:
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		if (kvm_apic_present(vcpu))
 			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
@@ -404,9 +411,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!kvm_apic_present(vcpu))
 			continue;
 
-		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
+		r = kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch);
+		if (r) {
 			kvfree(new);
 			new = NULL;
+			if (r == -E2BIG)
+				goto retry;
+
 			goto out;
 		}
 

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
--
