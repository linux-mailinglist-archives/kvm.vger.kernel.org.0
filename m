Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C403484EE8
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 08:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbiAEHzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 02:55:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229880AbiAEHzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 02:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641369299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r7i6B8t1nWVtw9i2H6WQZCRJZY+TMUrJj1olsg47kKU=;
        b=ibtP7RhDsM/gdgQx2FG99VcVqkZHhgFY7vUuYhoXsvEFsivO08ujxsCxiRdQFCfdGSHT8P
        0HFQTwyKB8OqrUnRVE1XA5QmVTm3MC7lFwUFd1tYxWkajPeOPlUUxn5znp+UDasxXyz5NX
        1utz/oAZL9ux5u3+Zk1ZiPF2094+LmU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-h9pRe-nxP2m-H1ItSYTw_A-1; Wed, 05 Jan 2022 02:54:58 -0500
X-MC-Unique: h9pRe-nxP2m-H1ItSYTw_A-1
Received: by mail-pj1-f69.google.com with SMTP id p1-20020a17090a2d8100b001b1e44000daso1773211pjd.9
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 23:54:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7i6B8t1nWVtw9i2H6WQZCRJZY+TMUrJj1olsg47kKU=;
        b=uDqbD17TCo0k5R5ADDizIWLPVnYlr+NfWJYSxD3WT81pRpDzhyAgcniqpoMvqYZW7j
         /uBPrYcCRw65R5BhLxIJNVWoCPRO/RQnP1QruKDeUiBEm5eWc/3sghPkkpxwh/bwG8hm
         u1ei3AChr43xtqQ1sOwUkGJGnSDI4GSPhz+QPGoZezfnKB6WpPVNHs+nTmJVXdqIVzTG
         /Bxauneupz2B95BxV+ESQcAQ52JKSxQ42WrXWYsnAq0fdP/OJPv0uw5ozgAbPA3bah3w
         IqNRMCnSZNeAxXt7/9jBFypcUnY/M8272jisEelewQjfJnBC4XorwZOsCpe/MA+XlADA
         lJLg==
X-Gm-Message-State: AOAM530U77OOT/1epx8UNWARkOoi9ShhkM/JtXgLv8uFtzBlJkt8UNNc
        qoKHHVixcqBWnrMjfm1veFjZLGzbS8CtZ7z2kuxIG6z58Og+x8c4d0OzNjXqZsaWxlVwyMRNUiu
        dx4+x4R1HLm93
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr2660161pjb.99.1641369297216;
        Tue, 04 Jan 2022 23:54:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy2LjVMREPqGtSVNwHLoQOV1DxMok+wIGSci3rc0gn28KLtBG38RdqUVQgBboBdUBlbBuf3mA==
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr2660138pjb.99.1641369296934;
        Tue, 04 Jan 2022 23:54:56 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id p10sm43629520pfw.69.2022.01.04.23.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 23:54:56 -0800 (PST)
Date:   Wed, 5 Jan 2022 15:54:49 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <YdVOycjyfi4Wr9ke@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-10-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:14PM +0000, David Matlack wrote:
> When dirty logging is enabled without initially-all-set, attempt to
> split all huge pages in the memslot down to 4KB pages so that vCPUs
> do not have to take expensive write-protection faults to split huge
> pages.
> 
> Huge page splitting is best-effort only. This commit only adds the
> support for the TDP MMU, and even there splitting may fail due to out
> of memory conditions. Failures to split a huge page is fine from a
> correctness standpoint because we still always follow it up by write-
> protecting any remaining huge pages.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Thanks for adding the knob.

Reviewed-by: Peter Xu <peterx@redhat.com>

One trivial nitpick below:

> +u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index, unsigned int access)
> +{
> +	u64 child_spte;
> +	int child_level;
> +
> +	if (WARN_ON(is_mmio_spte(huge_spte)))
> +		return 0;
> +
> +	if (WARN_ON(!is_shadow_present_pte(huge_spte)))
> +		return 0;
> +
> +	if (WARN_ON(!is_large_pte(huge_spte)))
> +		return 0;
> +
> +	child_spte = huge_spte;
> +	child_level = huge_level - 1;
> +
> +	/*
> +	 * The child_spte already has the base address of the huge page being
> +	 * split. So we just have to OR in the offset to the page at the next
> +	 * lower level for the given index.
> +	 */
> +	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
> +
> +	if (child_level == PG_LEVEL_4K) {
> +		child_spte &= ~PT_PAGE_SIZE_MASK;
> +
> +		/* Allow execution for 4K pages if it was disabled for NX HugePages. */
> +		if (is_nx_huge_page_enabled() && access & ACC_EXEC_MASK)

IMHO clearer to use brackets ("A && (B & C)").

I don't even see anywhere that the tdp mmu disables the EXEC bit for 4K.. if
that's true then perhaps we can even drop "access" and this check?  But I could
have missed something.

> +			child_spte = mark_spte_executable(child_spte);
> +	}
> +
> +	return child_spte;
> +}

-- 
Peter Xu

