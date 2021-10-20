Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD93435699
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 01:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhJTXuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 19:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhJTXuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 19:50:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63520C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:47:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f5so23898916pgc.12
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 16:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bOUeTsDcXhm7TJNqn143sHU4ERmAQ0pYmYiDC759W2M=;
        b=DrEb8sPiMkTDPfsnEHRrnPB0wb47WvT6x4J+Lt9CFj4UEj2nPLeHl+U89l30vlkfpZ
         Fa2voo/V+vJtOv0YoJ+Db4kZdw81ttwyTWsZKMKw/wWCZmm7oSk8nMu0JM/G8RNKj0rf
         0ZwGH6kK3hb4+NVHgKoh9mcFNG5ZVfJD70Gm73oDjxYC4yYE3crsIIb7BWaVuuL6NJ1w
         KD9clg31/hywD/cfunvAVOltOe9ca90XXwFxAStXkp0vzPtGd62eJB2gIb2ExbAqHcJW
         S4thy/cMTjJNSBPS0eNg2AEgaVZe0j3nFASlFOM8eodEfAqEsEw4kGAWn5/fe4+aFE0k
         TWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bOUeTsDcXhm7TJNqn143sHU4ERmAQ0pYmYiDC759W2M=;
        b=xopONIQWGWmYgk3dhkmEEgEuuRu1HVoaXuP06ecwX6tkr6mACDIMpqmnMCEQc6GS2f
         qpC0VzDW3Rs/v2BKWQc4hwJGp301cxS9z0Mhys/fUkn+GGh99xgApo35+qUjFXPVizF2
         9od7etp/eczgCWQqhOVx47B6Y5OlHLYo7jDeeVYolF4qthAGaQcICbNSHS7CnBs/KXeF
         s91tj0ALF/9zMMtTOLNXf02zvMpDXLPNetGNomfws2YSDuXEdiSKGGuFLQ7EOQCXVr26
         N6gQpsjmyrmfCCJtkERjdQFQLEOo93vif1QW4/cHr0lDutJ1/+MYBH8su2OPE8sHdtlf
         C0oQ==
X-Gm-Message-State: AOAM5332yh5I+Bi0MSBRg+TXoYceA0XjTeMbU4v0kwQOsYCeGAseeAy4
        DSVs03a7NK5OSEBDHpqq5g34ORp4bSxNmQ==
X-Google-Smtp-Source: ABdhPJwLJLjHlGZPTJE4oePBZvIFDk7ZNwfMkMz6ALQraHoEMVIdX5RXOzUtzvMGnG/5cGV7c/57dQ==
X-Received: by 2002:a05:6a00:230e:b0:44c:4f2d:9b00 with SMTP id h14-20020a056a00230e00b0044c4f2d9b00mr1862894pfh.24.1634773671531;
        Wed, 20 Oct 2021 16:47:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q8sm7069581pja.52.2021.10.20.16.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:47:50 -0700 (PDT)
Date:   Wed, 20 Oct 2021 23:47:47 +0000
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
Subject: Re: [PATCH v5 12/13] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <YXCqo6XXIkyOb4IE@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <062df8ac9eb280440a5f0c11159616b1bbb1c2c4.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <062df8ac9eb280440a5f0c11159616b1bbb1c2c4.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:

Some mechanical comments while they're on my mind, I'll get back to a full review
tomorrow.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6433efff447a..9ae5f7341cf5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -833,6 +833,75 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>  	return NULL;
>  }
>  
> +static inline
> +struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)

Function attributes should go on the same line as the function unless there's a
really good reason to do otherwise.

In this case, I would honestly just drop the helper.  It's really hard to express
what this function does in a name that isn't absurdly long, and there's exactly
one user at the end of the series.

https://lkml.kernel.org/r/20210930192417.1332877-1-keescook@chromium.org

> +{
> +	int idx = slots->node_idx;
> +	struct rb_node *node, *result = NULL;
> +
> +	for (node = slots->gfn_tree.rb_node; node; ) {
> +		struct kvm_memory_slot *slot;

My personal preference is to put declarations outside of the for loop.  I find it
easier to read, it's harder to have shadowing issues if all variables are declared
at the top, especially when using relatively generic names.

> +
> +		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
> +		if (gfn < slot->base_gfn) {
> +			result = node;
> +			node = node->rb_left;
> +		} else

Needs braces since the "if" has braces.

> +			node = node->rb_right;
> +	}
> +
> +	return result;
> +}
> +
> +static inline
> +struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)

The kvm_for_each_in_gfn prefix is _really_ confusing.  I get that these are all
helpers for "kvm_for_each_memslot...", but it's hard not to think these are all
iterators on their own.  I would gladly sacrifice namespacing for readability in
this case.

I also wouldn't worry about capturing the details.  For most folks reading this
code, the important part is understanding the control flow of
kvm_for_each_memslot_in_gfn_range().  Capturing the under-the-hood details in the
name isn't a priority since anyone modifying this code is going to have to do a
lot of staring no matter what :-)

> +static inline
> +bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
> +{
> +	struct kvm_memory_slot *memslot;
> +
> +	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
> +
> +	/*
> +	 * If this slot starts beyond or at the end of the range so does
> +	 * every next one
> +	 */
> +	return memslot->base_gfn >= end;
> +}
> +
> +/* Iterate over each memslot *possibly* intersecting [start, end) range */
> +#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> +	for (node = kvm_for_each_in_gfn_first(slots, start);		\
> +	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\

I think it makes sense to move the NULL check into the validation helper?  We had
a similar case in KVM's legacy MMU where a "null" check was left to the caller,
and it ended up with a bunch of redundant and confusing code.  I don't see that
happening here, but at the same time it's odd for the validator to not sanity
check @node.

> +	     node = rb_next(node))					\

It's silly, but I'd add a wrapper for this one, just to make it easy to follow
the control flow.

Maybe this as delta?  I'm definitely not set on the names, was just trying to
find something that's short and to the point.

---
 include/linux/kvm_host.h | 60 +++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ae5f7341cf5..a88bd5d9e4aa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -833,36 +833,29 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return NULL;
 }

-static inline
-struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
+static inline struct rb_node *kvm_get_first_node(struct kvm_memslots *slots,
+						 gfn_t start)
 {
+	struct kvm_memory_slot *slot;
+	struct rb_node *node, *tmp;
 	int idx = slots->node_idx;
-	struct rb_node *node, *result = NULL;
-
-	for (node = slots->gfn_tree.rb_node; node; ) {
-		struct kvm_memory_slot *slot;
-
-		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
-		if (gfn < slot->base_gfn) {
-			result = node;
-			node = node->rb_left;
-		} else
-			node = node->rb_right;
-	}
-
-	return result;
-}
-
-static inline
-struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
-{
-	struct rb_node *node;

 	/*
 	 * Find the slot with the lowest gfn that can possibly intersect with
 	 * the range, so we'll ideally have slot start <= range start
 	 */
-	node = kvm_memslots_gfn_upper_bound(slots, start);
+	node = NULL;
+	for (tmp = slots->gfn_tree.rb_node; tmp; ) {
+
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
+		if (gfn < slot->base_gfn) {
+			node = tmp;
+			tmp = tmp->rb_left;
+		} else {
+			tmp = tmp->rb_right;
+		}
+	}
+
 	if (node) {
 		struct rb_node *pnode;

@@ -882,12 +875,16 @@ struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t star
 	return node;
 }

-static inline
-bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
+static inline bool kvm_is_last_node(struct kvm_memslots *slots,
+				    struct rb_node *node, gfn_t end)
 {
 	struct kvm_memory_slot *memslot;

-	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
+	if (!node)
+		return true;
+
+	memslot = container_of(node, struct kvm_memory_slot,
+			       gfn_node[slots->node_idx]);

 	/*
 	 * If this slot starts beyond or at the end of the range so does
@@ -896,11 +893,16 @@ bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *nod
 	return memslot->base_gfn >= end;
 }

+static inline bool kvm_get_next_node(struct rb_node *node)
+{
+	return rb_next(node)
+}
+
 /* Iterate over each memslot *possibly* intersecting [start, end) range */
 #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
-	for (node = kvm_for_each_in_gfn_first(slots, start);		\
-	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
-	     node = rb_next(node))					\
+	for (node = kvm_get_first_node(slots, start);			\
+	     !kvm_is_last_node(slots, node, end);			\
+	     node = kvm_get_next_node(node))				\

 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
--
