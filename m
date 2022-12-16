Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2733164F125
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiLPSkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiLPSjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:39:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8493F6598D
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:39:21 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d15so3157796pls.6
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0vRZJPkOwKTLq2g/qHrH/I0o3Kip56IuQdsKLuDR68=;
        b=FsvtuBxWXRXP/DLLAPVA55lTOHyCWe2iwh9GLQzL31uWdJbhlGviGEoTCEUAZwHl5Z
         c0R0b/5Z8tF4VR/f0jYfE1iiZ7Jutnit64zQy0LOQYLcAejEW6caEmYa4tDz10mZXCR/
         EGyccUIp7IH7yRwj4XDhdZ5DAAf1HudHRFwytASNhPsh4UyJSJLcAhvOEpEWxDKXujvu
         jkkU1Eez2W4D/Nfa9Ez9fRDgxERNnrTv5jVQf6syQM5gaowmCnpEC5i6QvXz+8AvaO5y
         F7qBecxNKh5jQ+ANgzeORML/P6mqtacacehqvKzoK4TVCiY6qReL4zPjYwetBftQWXXe
         HFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0vRZJPkOwKTLq2g/qHrH/I0o3Kip56IuQdsKLuDR68=;
        b=oasOMz+Bqx38Ri/yWm59AhsocLFKZghUoJAz6jJH9w1c2swPYTTdip1voD/+hJKIp6
         04kLU/oGeRojrZi6mptJHK8NBrNTOPI9xUcc4aq13xb3fxssIV2FbdswLk7hHlgz6yF3
         SK/nadRDjgO9mgva1KVachi3XP4Y+AZzRydcrLulmFvC3Blo0c080CfDmU6vc43AMaq2
         rfZZ2Nuq36KjFqZyCFSOqWXLrbdjjstXqE41xBMY1kkKbMKOiL35Qzm7HXxGvtIy4qKA
         a7Po+MO4BKDc+r3ui7C8h6Nz6t/3ajvyowkFeC/ClZvlCNVyfrT0VxXhcE7idk/tIx3f
         Z+uA==
X-Gm-Message-State: AFqh2krCOKRT0iMu0X0km51RM7DcTJx5MkyPyNLLYZxp9627NVbVavC1
        UTLv+OtKee8bx8AaUAeAvQY/zQ==
X-Google-Smtp-Source: AMrXdXtxB3j0JFnRl8top2g2UJ0iPhETE7+DUpQdooP8pi/SwOajFk7k6hy/dRt3AtEfGT3+glPT6g==
X-Received: by 2002:a17:902:e1c2:b0:189:6d32:afeb with SMTP id t2-20020a170902e1c200b001896d32afebmr541982pla.1.1671215960608;
        Fri, 16 Dec 2022 10:39:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709026b8300b00188fadb71ecsm1973084plk.16.2022.12.16.10.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 10:39:19 -0800 (PST)
Date:   Fri, 16 Dec 2022 18:39:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v4 19/32] KVM: x86: Explicitly track all possibilities
 for APIC map's logical modes
Message-ID: <Y5y7VK9yk5qbfKVN@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
 <20221001005915.2041642-20-seanjc@google.com>
 <96c369fb2042e8722256d36c9b2ccf4a930752d1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c369fb2042e8722256d36c9b2ccf4a930752d1.camel@redhat.com>
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

On Thu, Dec 08, 2022, Maxim Levitsky wrote:
> On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> > -#define KVM_APIC_MODE_XAPIC_CLUSTER          4
> > -#define KVM_APIC_MODE_XAPIC_FLAT             8
> > -#define KVM_APIC_MODE_X2APIC                16
> > +enum kvm_apic_logical_mode {
> 
> It would be nice to have short comment about each of the modes, like
> 
> /* All local APICs are disabled */
> > +	KVM_APIC_MODE_SW_DISABLED,
> /* All enabled local APICs are in XAPIC mode using cluster logical addresssing */
> > +	KVM_APIC_MODE_XAPIC_CLUSTER,
> /* All enabled local APICs are in XAPIC mode using flat logical addresssing */
> > +	KVM_APIC_MODE_XAPIC_FLAT,
> /* All enabled local APICs are in X2APIC mode */
> > +	KVM_APIC_MODE_X2APIC,
> /* 
>    Due to differencies in mode between enabled local APICs and/or other corner cases, 
>    the optimized logical map disabled 
> */

I'll add that.

> > +	KVM_APIC_MODE_MAP_DISABLED,
> > +};
> >  
> >  struct kvm_apic_map {
> >  	struct rcu_head rcu;
> > -	u8 mode;
> > +	enum kvm_apic_logical_mode logical_mode;
> >  	u32 max_apic_id;
> >  	union {
> >  		struct kvm_lapic *xapic_flat_map[8];
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index cef8b202490b..9989893fef69 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -168,7 +168,12 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
> >  
> >  static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
> >  		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
> > -	switch (map->mode) {
> > +	switch (map->logical_mode) {
> > +	case KVM_APIC_MODE_SW_DISABLED:
> > +		/* Arbitrarily use the flat map so that @cluster isn't NULL. */
> > +		*cluster = map->xapic_flat_map;
> > +		*mask = 0;
> > +		return true;
> >  	case KVM_APIC_MODE_X2APIC: {
> >  		u32 offset = (dest_id >> 16) * 16;
> >  		u32 max_apic_id = map->max_apic_id;
> > @@ -193,8 +198,10 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
> >  		*cluster = map->xapic_cluster_map[(dest_id >> 4) & 0xf];
> >  		*mask = dest_id & 0xf;
> >  		return true;
> > +	case KVM_APIC_MODE_MAP_DISABLED:
> > +		return false;
> >  	default:
> > -		/* Not optimized. */
> > +		WARN_ON_ONCE(1);
> >  		return false;
> >  	}
> >  }
> > @@ -256,10 +263,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  		goto out;
> >  
> >  	new->max_apic_id = max_id;
> > +	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
> >  
> >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  		struct kvm_lapic *apic = vcpu->arch.apic;
> >  		struct kvm_lapic **cluster;
> > +		enum kvm_apic_logical_mode logical_mode;
> >  		u16 mask;
> >  		u32 ldr;
> >  		u8 xapic_id;
> > @@ -282,7 +291,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> >  			new->phys_map[xapic_id] = apic;
> >  
> > -		if (!kvm_apic_sw_enabled(apic))
> > +		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
> > +		    !kvm_apic_sw_enabled(apic))
> >  			continue;
> Very minor nitpick: it feels to me that code that updates the logical mode of the
> map, might be better to be in a function, or in 'if', like

An if-statement would be rough due to the indentation.  A function works well
though, especially if both the physical and logical chunks are put into helpers.
E.g. the patch at the bottom (with other fixup for this patch) yields:

	new->max_apic_id = max_id;
	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;

	kvm_for_each_vcpu(i, vcpu, kvm) {
		if (!kvm_apic_present(vcpu))
			continue;

		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
			kvfree(new);
			new = NULL;
			goto out;
		}

		kvm_recalculate_logical_map(new, vcpu);
	}

I'll tack that patch on at the end of the series if it looks ok.

> 		if (new->logical_mode != KVM_APIC_MODE_MAP_DISABLED) {
> 
> 			/* Disabled local APICs don't affect the logical map */
> 			if (!kvm_apic_sw_enabled(apic))
> 				continue;
> 			....
> 		}
> >  
> >  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> > @@ -290,17 +300,26 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> >  			continue;
> >  
> >  		if (apic_x2apic_mode(apic)) {
> > -			new->mode |= KVM_APIC_MODE_X2APIC;
> > +			logical_mode = KVM_APIC_MODE_X2APIC;
> >  		} else {
> >  			ldr = GET_APIC_LOGICAL_ID(ldr);
> >  			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
> > -				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
> > +				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
> >  			else
> > -				new->mode |= KVM_APIC_MODE_XAPIC_CLUSTER;
> > +				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
> >  		}
> > +		if (new->logical_mode != KVM_APIC_MODE_SW_DISABLED &&
> > +		    new->logical_mode != logical_mode) {
> > +			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> > +			continue;
> > +		}
> > +		new->logical_mode = logical_mode;
> 
> How about:
> 
> 		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED)
> 			new->logical_mode = logical_mode;
> 
> 		if (new->logical_mode != logical_mode) {
> 			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> 			continue;
> 		}

This instead?  So that it's a bit more obvious that the SW_DISABLED case is
exclusive with the mismatched mode path.

		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
			new->logical_mode = logical_mode;
		} else if (new->logical_mode != logical_mode) {
			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
			continue;
		}

---
 arch/x86/kvm/lapic.c | 245 +++++++++++++++++++++++--------------------
 1 file changed, 133 insertions(+), 112 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5224d73cd84a..d017f49c5048 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -218,6 +218,134 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
 	kvfree(map);
 }
 
+static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
+				    struct kvm_vcpu *vcpu,
+				    bool *xapic_id_mismatch)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 x2apic_id = kvm_x2apic_id(apic);
+	u32 xapic_id = kvm_xapic_id(apic);
+	u32 physical_id;
+
+	/*
+	 * Deliberately truncate the vCPU ID when detecting a mismatched APIC
+	 * ID to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a
+	 * 32-bit value.  Any unwanted aliasing due to truncation results will
+	 * be detected below.
+	 */
+	if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
+		*xapic_id_mismatch = true;
+
+	/*
+	 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC IDs.
+	 * Allow sending events to vCPUs by their x2APIC ID even if the target
+	 * vCPU is in legacy xAPIC mode, and silently ignore aliased xAPIC IDs
+	 * (the x2APIC ID is truncated to 8 bits, causing IDs > 0xff to wrap
+	 * and collide).
+	 *
+	 * Honor the architectural (and KVM's non-optimized) behavior if
+	 * userspace has not enabled 32-bit x2APIC IDs.  Each APIC is supposed
+	 * to process messages independently.  If multiple vCPUs have the same
+	 * effective APIC ID, e.g. due to the x2APIC wrap or because the guest
+	 * manually modified its xAPIC IDs, events targeting that ID are
+	 * supposed to be recognized by all vCPUs with said ID.
+	 */
+	if (vcpu->kvm->arch.x2apic_format) {
+		/* See also kvm_apic_match_physical_addr(). */
+		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
+			x2apic_id <= new->max_apic_id)
+			new->phys_map[x2apic_id] = apic;
+
+		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
+			new->phys_map[xapic_id] = apic;
+	} else {
+		/*
+		 * Disable the optimized map if the physical APIC ID is already
+		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
+		 * map requires a strict 1:1 mapping between IDs and vCPUs.
+		 */
+		if (apic_x2apic_mode(apic))
+			physical_id = x2apic_id;
+		else
+			physical_id = xapic_id;
+
+		if (new->phys_map[physical_id])
+			return -EINVAL;
+
+		new->phys_map[physical_id] = apic;
+	}
+
+	return 0;
+}
+
+static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
+					struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	enum kvm_apic_logical_mode logical_mode;
+	struct kvm_lapic **cluster;
+	u16 mask;
+	u32 ldr;
+
+	if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
+		return;
+
+	if (kvm_apic_sw_enabled(apic))
+		return;
+
+	ldr = kvm_lapic_get_reg(apic, APIC_LDR);
+	if (!ldr)
+		return;
+
+	if (apic_x2apic_mode(apic)) {
+		logical_mode = KVM_APIC_MODE_X2APIC;
+	} else {
+		ldr = GET_APIC_LOGICAL_ID(ldr);
+		if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
+			logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
+		else
+			logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
+	}
+
+	/*
+	 * To optimize logical mode delivery, all software-enabled APICs must
+	 * be configured for the same mode.
+	 */
+	if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
+		new->logical_mode = logical_mode;
+	} else if (new->logical_mode != logical_mode) {
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+		return;
+	}
+
+	/*
+	 * In x2APIC mode, the LDR is read-only and derived directly from the
+	 * x2APIC ID, thus is guaranteed to be addressable.  KVM reuses
+	 * kvm_apic_map.phys_map to optimize logical mode x2APIC interrupts by
+	 * reversing the LDR calculation to get cluster of APICs, i.e. no
+	 * additional work is required.
+	 */
+	if (apic_x2apic_mode(apic)) {
+		WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)));
+		return;
+	}
+
+	if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
+							&cluster, &mask))) {
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+		return;
+	}
+
+	if (!mask)
+		return;
+
+	ldr = ffs(mask) - 1;
+	if (!is_power_of_2(mask) || cluster[ldr])
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+	else
+		cluster[ldr] = apic;
+}
+
 /*
  * CLEAN -> DIRTY and UPDATE_IN_PROGRESS -> DIRTY changes happen without a lock.
  *
@@ -272,123 +400,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct kvm_lapic *apic = vcpu->arch.apic;
-		struct kvm_lapic **cluster;
-		enum kvm_apic_logical_mode logical_mode;
-		u32 x2apic_id, physical_id;
-		u16 mask;
-		u32 ldr;
-		u8 xapic_id;
-
 		if (!kvm_apic_present(vcpu))
 			continue;
 
-		xapic_id = kvm_xapic_id(apic);
-		x2apic_id = kvm_x2apic_id(apic);
-
-		/*
-		 * Deliberately truncate the vCPU ID when detecting a mismatched
-		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
-		 * ID, is a 32-bit value.  Any unwanted aliasing due to
-		 * truncation results will be detected below.
-		 */
-		if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
-			xapic_id_mismatch = true;
-
-		/*
-		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
-		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
-		 * if the target vCPU is in legacy xAPIC mode, and silently
-		 * ignore aliased xAPIC IDs (the x2APIC ID is truncated to 8
-		 * bits, causing IDs > 0xff to wrap and collide).
-		 *
-		 * Honor the architectural (and KVM's non-optimized) behavior
-		 * if userspace has not enabled 32-bit x2APIC IDs.  Each APIC
-		 * is supposed to process messages independently.  If multiple
-		 * vCPUs have the same effective APIC ID, e.g. due to the
-		 * x2APIC wrap or because the guest manually modified its xAPIC
-		 * IDs, events targeting that ID are supposed to be recognized
-		 * by all vCPUs with said ID.
-		 */
-		if (kvm->arch.x2apic_format) {
-			/* See also kvm_apic_match_physical_addr(). */
-			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
-			    x2apic_id <= new->max_apic_id)
-				new->phys_map[x2apic_id] = apic;
-
-			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
-				new->phys_map[xapic_id] = apic;
-		} else {
-			/*
-			 * Disable the optimized map if the physical APIC ID is
-			 * already mapped, i.e. is aliased to multiple vCPUs.
-			 * The optimized map requires a strict 1:1 mapping
-			 * between IDs and vCPUs.
-			 */
-			if (apic_x2apic_mode(apic))
-				physical_id = x2apic_id;
-			else
-				physical_id = xapic_id;
-
-			if (new->phys_map[physical_id]) {
-				kvfree(new);
-				new = NULL;
-				goto out;
-			}
-			new->phys_map[physical_id] = apic;
+		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
+			kvfree(new);
+			new = NULL;
+			goto out;
 		}
 
-		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
-		    !kvm_apic_sw_enabled(apic))
-			continue;
-
-		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
-		if (!ldr)
-			continue;
-
-		if (apic_x2apic_mode(apic)) {
-			logical_mode = KVM_APIC_MODE_X2APIC;
-		} else {
-			ldr = GET_APIC_LOGICAL_ID(ldr);
-			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
-				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
-			else
-				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
-		}
-		if (new->logical_mode != KVM_APIC_MODE_SW_DISABLED &&
-		    new->logical_mode != logical_mode) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-		new->logical_mode = logical_mode;
-
-		/*
-		 * In x2APIC mode, the LDR is read-only and derived directly
-		 * from the x2APIC ID, thus is guaranteed to be addressable.
-		 * KVM reuses kvm_apic_map.phys_map to optimize logical mode
-		 * x2APIC interrupts by reversing the LDR calculation to get
-		 * cluster of APICs, i.e. no additional work is required.
-		 */
-		if (apic_x2apic_mode(apic)) {
-			WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
-			continue;
-		}
-
-		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
-								&cluster, &mask))) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-
-		if (!mask)
-			continue;
-
-		ldr = ffs(mask) - 1;
-		if (!is_power_of_2(mask) || cluster[ldr]) {
-			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
-			continue;
-		}
-		cluster[ldr] = apic;
+		kvm_recalculate_logical_map(new, vcpu);
 	}
 out:
 	/*

base-commit: 46d887a39567c4d1517518e4bdfcc10f34b5d6ce
-- 

