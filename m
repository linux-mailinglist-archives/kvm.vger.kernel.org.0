Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA269434235
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 01:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJSXlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 19:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhJSXlJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 19:41:09 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2626C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:38:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t184so7847791pgd.8
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 16:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2QsW5fKhp22EmYwLesRxP1OLU4KgoBD8JpSEUKHaa7U=;
        b=FF+oKNuXuU00ds8QRcbr8sqquKLJ4lADTJLozGgltzxK1vJNNa3JX+ICrkY1N3x5fH
         xb5TH5P7t7MeFi7+vruSFecBpwDZaBGidgcRbLz4uj4FlWxXFvErHYc6Tq9HNwHjfcL/
         2RlxSyk1TwEXi0zIB38Cqo/cvaeezCyd6SPhN3bCWZY17CN5WJZ2vfBY3+8Wa8OGSVtI
         WGasOZtksSYbDGJjHF5nUU2M5Gop3ebb57GX87eEuJsytHpw9607G+3Sm/TMVOPJsgzw
         /nPXMCdvr1WQ7JT6mFFCIA7gGJFX9fnYTujCkLs1TOYj0Ex4kvZP70hoBSpmMEiDDKoP
         5a7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2QsW5fKhp22EmYwLesRxP1OLU4KgoBD8JpSEUKHaa7U=;
        b=MIvw1bskhALs+RnDdDRKMdHKdoa7DHF5NqDqRZKQ96By+sImYyQjp71+qwu3Pq7NrK
         bn+Exsu6MyGYlVAa07uLLc6zb9io5MdgDrzS+9JsIMZvZR3X6kpKGr2REKn35RZ34mZ9
         gnRrULSuO9OAThwtgBgeiytDl4b9Bww6K8GCxd8+BRUqQLbQXpG7fwovjqNXp2nAbd8W
         gJVOVcpGWp8f6pkY1hvWkqumOUY8O2PvX11PvQoILPqxEMR6i48fQkhK7WcVTVGOI07s
         CPnu++sex5870jRl9lWWky5NFTZHC5EwytZRPf913Fl3hK7HRvuVtAX3/YzrFyf0Rvjq
         BoYg==
X-Gm-Message-State: AOAM532iQ3cnSyuSYx5aw5+flSny1jJRdSBTFq7UkUhndxBEBlS1WgE3
        uUqjQ6w0K2lqbLnJrAnZ5JgOtA==
X-Google-Smtp-Source: ABdhPJx+NMf/4ZfMDchDW6N8cMJnMUiaMZv4+dmhnJZoV4qJJH2iE4M9g2JQOk/S53ObxAEo0exQ/w==
X-Received: by 2002:a05:6a00:2343:b0:44d:2e13:3edf with SMTP id j3-20020a056a00234300b0044d2e133edfmr2744482pfj.72.1634686734917;
        Tue, 19 Oct 2021 16:38:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17sm3752720pju.34.2021.10.19.16.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 16:38:54 -0700 (PDT)
Date:   Tue, 19 Oct 2021 23:38:50 +0000
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
Subject: Re: [PATCH v5 05/13] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
Message-ID: <YW9XCp3B+ogPIl7i@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d0d2c6fda0a21962eefcf28b37a603caa4be1819.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0d2c6fda0a21962eefcf28b37a603caa4be1819.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> @@ -1267,7 +1280,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>   * itself isn't here as an inline because that would bloat other code too much.
>   */
>  static inline struct kvm_memory_slot *
> -__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
> +__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)

This function name is a misnomer.  The helper is not an "approx" version, it's an
inner helper that takes an @approx param.  Unless someone has a more clever name,
the dreaded four underscores seems like the way to go.  Warning away users is a
good thing in this case...

>  {
>  	struct kvm_memory_slot *slot;
>  	int slot_index = atomic_read(&slots->last_used_slot);
> @@ -1276,7 +1289,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  	if (slot)
>  		return slot;
>  
> -	slot = search_memslots(slots, gfn, &slot_index);
> +	slot = search_memslots(slots, gfn, &slot_index, approx);
>  	if (slot) {
>  		atomic_set(&slots->last_used_slot, slot_index);
>  		return slot;
> @@ -1285,6 +1298,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  	return NULL;
>  }
>  

There's a comment that doesn't show up in this diff that should also be moved,
and opportunistically updated.

> +static inline struct kvm_memory_slot *
> +__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
> +{
> +	return __gfn_to_memslot_approx(slots, gfn, false);
> +}
> +
>  static inline unsigned long
>  __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>  {

E.g. this as fixup?

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 540fa948baa5..2964c773b36c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1964,10 +1964,15 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
        return 0;
 }

+static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
+{
+       return ____gfn_to_memslot(slots, cur_gfn, true);
+}
+
 static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
                                              unsigned long cur_gfn)
 {
-       struct kvm_memory_slot *ms = __gfn_to_memslot_approx(slots, cur_gfn, true);
+       struct kvm_memory_slot *ms = gfn_to_memslot_approx(slots, cur_gfn);
        int slotidx = ms - slots->memslots;
        unsigned long ofs = cur_gfn - ms->base_gfn;

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8fd9644f40b2..ec1a074c2f6e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1274,13 +1274,8 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
        return NULL;
 }

-/*
- * __gfn_to_memslot() and its descendants are here because it is called from
- * non-modular code in arch/powerpc/kvm/book3s_64_vio{,_hv}.c. gfn_to_memslot()
- * itself isn't here as an inline because that would bloat other code too much.
- */
 static inline struct kvm_memory_slot *
-__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
+____gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
        struct kvm_memory_slot *slot;
        int slot_index = atomic_read(&slots->last_used_slot);
@@ -1298,10 +1293,15 @@ __gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
        return NULL;
 }

+/*
+ * __gfn_to_memslot() and its descendants are here to allow arch code to inline
+ * the lookups in hot paths.  gfn_to_memslot() itself isn't here as an inline
+ * because that would bloat other code too much.
+ */
 static inline struct kvm_memory_slot *
 __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 {
-       return __gfn_to_memslot_approx(slots, gfn, false);
+       return ____gfn_to_memslot(slots, gfn, false);
 }

 static inline unsigned long
