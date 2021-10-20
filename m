Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0764355F5
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 00:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhJTWlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTWlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 18:41:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEA4C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:39:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so1624223pji.5
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eGCn0f41D4HpobJWo3fx2mTIugtvwU4VYQMdEwSg0U0=;
        b=af2oC3k0qcnhiF7y6ar4o729lYsprHHjORYSkiipWKcFN7EujBzRwlS0tM4+QKpWJM
         HqcOQkGTCWeDXiZlwA29Ae1wXUjBSOCCjbbdrOhFM47MmQe/YsRVnF2Lg/wS6Ug2mING
         3zAoiE0ZQx+QTxKNfElvnO45sIaMMOfwpe/O+JqMBhVPrKt8bz7fmKQ5gg7OI+Q5A9Ru
         mxFZrcimLWX+8JWmFs5hl7gLqPMJ4YtcCZLu5B+nkELZ653oUXVbG/cp+xOK4T9AR1ta
         bqJw5XNRe+OFARm/ngy0aTudPN2oJn+vRz95YcyC8SZeZrJc4p42SvWiI3yQbY2juzX1
         u0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eGCn0f41D4HpobJWo3fx2mTIugtvwU4VYQMdEwSg0U0=;
        b=fE1lUzsCF78ANxoAHIgQFqSpsEcNZL40ze8hnHZ70xivL+d6V2PS3BgTbAlJfeIOHO
         hUygptEN+u0TljclI1BD+DYT6y6b4+b8Vt/c39MENIyBgF/7fx2W5+Zmz3EkfcKcw4z5
         hh7aqWQorzrrg74exT1j2odTu70TgL5/PTZwY9yWmpLtHTce1C2YjkQ/J01Wbsy/5SqO
         jMcRwh1QQ0nPaqEgsK5fU2V0Pwk/T4hC2g1kCHcbl8cNYbTL79LC0iAWSa6qPDzqhSXG
         yDN+OqnQGVcxwlBuUN78gXH8lg2SSDA3ONWXXCfKH1h8nKQs/Rh36Af2zRLS/xKMfU8v
         eIMw==
X-Gm-Message-State: AOAM530I6SXv6U4oHOPqwd75vLPuSU2fKa814tfgXY9erqHj8VVTDlwn
        oSyEXTsjVkimizvfYX0qxjpnjA==
X-Google-Smtp-Source: ABdhPJx+QU7ObcFGp4YAIapaqa4lFYaMZDXOPAfMUKLdl4uUX1J2w0lDXSx4ODnf4X0d4Enkf0E9Mg==
X-Received: by 2002:a17:90a:73ce:: with SMTP id n14mr2074254pjk.215.1634769559470;
        Wed, 20 Oct 2021 15:39:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q8sm3956649pfu.167.2021.10.20.15.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 15:39:18 -0700 (PDT)
Date:   Wed, 20 Oct 2021 22:39:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 08/13] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <YXCak6WUfknV6qU5@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <555f58fdaec120aa7a6f6fbad06cca796a8c9168.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555f58fdaec120aa7a6f6fbad06cca796a8c9168.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> @@ -1251,12 +1251,13 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
>  		atomic_set(&slots->last_used_slot, 0);
>  
> -	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> +	for (i = oldslot - mslots; i < slots->used_slots; i++) {
> +		hash_del(&mslots[i].id_node);
>  		mslots[i] = mslots[i + 1];
> -		slots->id_to_index[mslots[i].id] = i;
> +		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>  	}
> +	hash_del(&mslots[i].id_node);
>  	mslots[i] = *memslot;
> -	slots->id_to_index[memslot->id] = -1;

Aha!  This code has been bugging and I finally figured out why.  Fundamentally,
this is identical to kvm_memslot_move_backward(), the only difference being that
the _backward() variant has a second "stop" condition.

But yet this is subtly different in the hash manipulations because performs the
final node deletion (which is a random node, that may not be the target node!)
outside of the loop, whereas _backward() deletes the target node before the loop.

I like the _backward() variant a lot more.  And if this code is converted to that
approach, i.e.

	for (i = oldslot - mslots; i < slots->used_slots; i++) {
		hash_del(&mslots[i + 1].id_node);
		mslots[i] = mslots[i + 1];
		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
	}

then all three loops fit a similar pattern and we can extract the node craziness
into a helper.  I know this mostly goes away in the end, but I think/hope it will
make the future patches easier to follow this there's only ever one "replace"
helper.

For convenience, with the s/mmemslot/oldslot and comment changes.

---
 virt/kvm/kvm_main.c | 63 ++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 50597608d085..6f5298bc7710 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1231,6 +1231,23 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 	return 0;
 }

+static void kvm_memslot_replace(struct kvm_memslots *slots, int dst, int src)
+{
+	struct kvm_memory_slot *mslots = slots->memslots;
+
+	/*
+	 * Remove the source from the hash list, copying the hlist_node data
+	 * would corrupt the list.
+	 */
+	hash_del(&mslots[src].id_node);
+
+	/* Copy the source *data*, not the pointer, to the destination. */
+	mslots[dst] = mslots[src];
+
+	/* Re-add the memslot to the list using the destination's node. */
+	hash_add(slots->id_hash, &mslots[dst].id_node, mslots[dst].id);
+}
+
 /*
  * Delete a memslot by decrementing the number of used slots and shifting all
  * other entries in the array forward one spot.
@@ -1251,12 +1268,16 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
 	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
 		atomic_set(&slots->last_used_slot, 0);

-	for (i = oldslot - mslots; i < slots->used_slots; i++) {
-		hash_del(&mslots[i].id_node);
-		mslots[i] = mslots[i + 1];
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
-	}
-	hash_del(&mslots[i].id_node);
+	/*
+	 * Remove the to-be-deleted memslot from the list _before_ shifting
+	 * the trailing memslots forward, its data will be overwritten.
+	 * Defer the (somewhat pointless) copying of the memslot until after
+	 * the last slot has been shifted to avoid overwriting said last slot.
+	 */
+	hash_del(&oldslot->id_node);
+
+	for (i = oldslot - mslots; i < slots->used_slots; i++)
+		kvm_memslot_replace(slots, i, i + 1);
 	mslots[i] = *memslot;
 }

@@ -1282,39 +1303,32 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
 					    struct kvm_memory_slot *memslot)
 {
 	struct kvm_memory_slot *mslots = slots->memslots;
-	struct kvm_memory_slot *mmemslot = id_to_memslot(slots, memslot->id);
+	struct kvm_memory_slot *oldslot = id_to_memslot(slots, memslot->id);
 	int i;

-	if (!mmemslot || !slots->used_slots)
+	if (!oldslot || !slots->used_slots)
 		return -1;

 	/*
-	 * The loop below will (possibly) overwrite the target memslot with
-	 * data of the next memslot, or a similar loop in
-	 * kvm_memslot_move_forward() will overwrite it with data of the
-	 * previous memslot.
-	 * Then update_memslots() will unconditionally overwrite and re-add
-	 * it to the hash table.
-	 * That's why the memslot has to be first removed from the hash table
-	 * here.
+         * Delete the slot from the hash table before sorting the remaining
+         * slots, the slot's data may be overwritten when copying slots as part
+         * of the sorting proccess.  update_memslots() will unconditionally
+         * rewrite the entire slot and re-add it to the hash table.
 	 */
-	hash_del(&mmemslot->id_node);
+	hash_del(&oldslot->id_node);

 	/*
 	 * Move the target memslot backward in the array by shifting existing
 	 * memslots with a higher GFN (than the target memslot) towards the
 	 * front of the array.
 	 */
-	for (i = mmemslot - mslots; i < slots->used_slots - 1; i++) {
+	for (i = oldslot - mslots; i < slots->used_slots - 1; i++) {
 		if (memslot->base_gfn > mslots[i + 1].base_gfn)
 			break;

 		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);

-		/* Shift the next memslot forward one and update its index. */
-		hash_del(&mslots[i + 1].id_node);
-		mslots[i] = mslots[i + 1];
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
+		kvm_memslot_replace(slots, i, i + 1);
 	}
 	return i;
 }
@@ -1343,10 +1357,7 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,

 		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);

-		/* Shift the next memslot back one and update its index. */
-		hash_del(&mslots[i - 1].id_node);
-		mslots[i] = mslots[i - 1];
-		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
+		kvm_memslot_replace(slots, i, i - 1);
 	}
 	return i;
 }
--
