Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECFA712C38
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjEZSLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 14:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjEZSLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 14:11:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF66AD3
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 11:11:38 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53445255181so695366a12.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 11:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685124698; x=1687716698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1czSb749PPHSXCGQjgTLDqahZzp+8s0CvC4A6wIAuKA=;
        b=e26jHa3fnX/vNb5sBBJ9nDykDi6oMgta9fUhBOnZ0cuCZ999V6QWNhYYrXb9RxdpjZ
         KR9f/7oodk0wFD+XDD+8xaIuDlSIT1BWos6uk3ZdNieiBIKBHBQK+Rf8GIJL9/h3QvVV
         N7lqjQjs8u8dzboWTe2M+9bM9B7Wz84bsuAlapDKau+BpRFrQFh4SfWUgyvHMkqiWPbF
         v2nLUdfzdsBkEW5nTUFe3izHAUoF4phorhyXray80YYI+A4BmJ6b2D8SL9uY3U/jo5WK
         XDPBfhBkXGmU7zRY2DVjWbG/WsKj75+dzG4kx3uQ75gf49fPCdU3Ic/0lEGFTb9Esj+w
         Wvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685124698; x=1687716698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1czSb749PPHSXCGQjgTLDqahZzp+8s0CvC4A6wIAuKA=;
        b=LEywn14/BCA+E2oMjdmQojOxateUTDzdtyrbmit/tU+RuOrk56m2IID7WGMh6q7wfO
         9d6RbGCpJa+T8UzWcZu+qatp7nxjGdWVtHbOvZBsh2IQQU8ZL7VCyibIHM1tfamnOxZ1
         ufZjgp+38FzJFWQg/UG3cQQwOKjbT4QZu3VvP4NbW0SuMgIDqTMyx0rON+dTm4mbyhhG
         ztbDzTut0umekDJZp2pRma0ISqMK38e5frPmSDaDsINPu+0bPu203ZBfkivm9grQiaJp
         tKqi/5SShm5lLZMttss3Jri26dKQk9NuQmE8kX+IjHuxZ0pKJe6A73dCXV2xLtBwSgNs
         0s2Q==
X-Gm-Message-State: AC+VfDyQTqIjE3fseAAVrAbcAMDu5NJn/XIurueCHsMg8IjN2+L+uh+3
        DQK0ujbJlLRQFkPqSfBkoysHnwMFlGU=
X-Google-Smtp-Source: ACHHUZ77ygLiF6HW/ajvXK/m5CX7x9fKOQZDUZYawjML4RsRcz8ozk3dpJ4VY9shRG2/L1ZFiy3qRKBda44=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e217:0:b0:503:919f:b942 with SMTP id
 q23-20020a63e217000000b00503919fb942mr54656pgh.11.1685124698157; Fri, 26 May
 2023 11:11:38 -0700 (PDT)
Date:   Fri, 26 May 2023 11:11:36 -0700
In-Reply-To: <f4c2108d-b5a0-bdee-f354-28ed7e5d4bd5@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-2-mhal@rbox.co>
 <ZG/4UN2VpZ1a6ek1@google.com> <016686aa-fedc-08bf-df42-9451bba9f82e@rbox.co>
 <ZHDbos7Kf2aX/zyg@google.com> <f4c2108d-b5a0-bdee-f354-28ed7e5d4bd5@rbox.co>
Message-ID: <ZHD2WFeYmfkpuzJQ@google.com>
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

On Fri, May 26, 2023, Michal Luczaj wrote:
> On 5/26/23 18:17, Sean Christopherson wrote:
> > On Fri, May 26, 2023, Michal Luczaj wrote:
> >> On 5/26/23 02:07, Sean Christopherson wrote:
> >>> On Thu, May 25, 2023, Michal Luczaj wrote:
> >>>> @@ -265,10 +265,14 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
> >>>>  		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
> >>>>  		 * map requires a strict 1:1 mapping between IDs and vCPUs.
> >>>>  		 */
> >>>> -		if (apic_x2apic_mode(apic))
> >>>> +		if (apic_x2apic_mode(apic)) {
> >>>> +			if (x2apic_id > new->max_apic_id)
> >>>> +				return -EINVAL;
> >>>
> >>> Hmm, disabling the optimized map just because userspace created a new vCPU is
> >>> unfortunate and unnecessary.  Rather than return -EINVAL and only perform the
> >>> check when x2APIC is enabled, what if we instead do the check immediately and
> >>> return -E2BIG?  Then the caller can retry with a bigger array size.  Preemption
> >>> is enabled and retries are bounded by the number of possible vCPUs, so I don't
> >>> see any obvious issues with retrying.
> >>
> >> Right, that makes perfect sense.
> >>
> >> Just a note, it changes the logic a bit:
> >>
> >> - x2apic_format: an overflowing x2apic_id won't be silently ignored.
> > 
> > Nit, I wouldn't describe the current behavior as silently ignored.  KVM doesn't
> > ignore the case, KVM instead disables the optimized map.
> 
> I may be misusing "silently ignored",

You're not.

> but currently if (x2apic_format && apic_x2apic_mode && x2apic_id >
> new->max_apic_id) new->phys_map[x2apic_id] remains unchanged, then
> kvm_recalculate_phys_map() returns 0 (not -EINVAL).  I.e. this does not
> result in rcu_assign_pointer(kvm->arch.apic_map, NULL).

My bad.  I was thinking of the -EINVAL from your patch.

Hmm, thinking more about the "silently ignored" case, it's only temporarily
ignored.  If a x2APIC ID is out-of-bounds, then there had to have been a write
to a vCPU's x2APIC ID between the two instances of kvm_for_each_vcpu(), and that
means that whatever changed the ID must also mark apic_map_dirty DIRTY and call
kvm_recalculate_apic_map().  I.e. another recalc will soon occur and cleanup the
mess.

There's still value in retrying, but it's not as much as an optimization as it
first appears.  That means the bug fix can be a separate patch from the retry.
Oh, and the retry can also redo the DIRTY=>IN_PROGRESS so that whatever modified
a vCPU's x2APIC ID doesn't perform an unnecessary recalculation.

E.g. this (plus comments) for stable@

---
 arch/x86/kvm/lapic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e542cf285b51..7a83df7f45c5 100644
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

base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
-- 


and then as a pure optimization

---
 arch/x86/kvm/lapic.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7a83df7f45c5..09e13ded34ef 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -369,8 +369,9 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	struct kvm_apic_map *new, *old = NULL;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
-	u32 max_id = 255; /* enough space for any xAPIC ID */
-	bool xapic_id_mismatch = false;
+	u32 max_id;
+	bool xapic_id_mismatch;
+	int r;
 
 	/* Read kvm->arch.apic_map_dirty before kvm->arch.apic_map.  */
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
@@ -380,9 +381,14 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		  "Dirty APIC map without an in-kernel local APIC");
 
 	mutex_lock(&kvm->arch.apic_map_lock);
+
+retry:
 	/*
-	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map
-	 * (if clean) or the APIC registers (if dirty).
+	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map (if clean)
+	 * or the APIC registers (if dirty).  Note, on retry the map may have
+	 * not yet been marked dirty by whatever task changed a vCPU's x2APIC
+	 * ID, i.e. the map may still show up as in-progress.  In that case
+	 * this task still needs to retry and copmlete its calculation.
 	 */
 	if (atomic_cmpxchg_acquire(&kvm->arch.apic_map_dirty,
 				   DIRTY, UPDATE_IN_PROGRESS) == CLEAN) {
@@ -391,6 +397,9 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		return;
 	}
 
+	max_id = 255; /* enough space for any xAPIC ID */
+	xapic_id_mismatch = false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		if (kvm_apic_present(vcpu))
 			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
@@ -409,9 +418,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
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
 

base-commit: 15cc2fa07b5867ae5a6f17656a6f272cfb393810
-- 
