Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A4E615344
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 21:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiKAU2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 16:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKAU2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 16:28:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CE12BD2
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 13:28:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o7so11101275pjj.1
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 13:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
        b=JeRquhbkLaWQ4VXS0ZlfxU7Y8+xIVGl1+LdsPQ0hWDUsemLo7dmNUjfVG3XeWtQ+q6
         anOYfFqBxLnv8zuKUeuNSfJC6yWnnwaRxxvd3gf+tr+sN4tRYQJ9BFAcNmM51Nmm1y4/
         Ve0qZkEVA5+q3F865yXWV2l795oQInHr6YQ8EVAoPWaVtZSXmHDvtUvYOs+L9jwDIpH4
         d9gFRlhhChEJbDnUVO+mCaISyg5Rc3dqgckgKei9ZJmBfo2vdA09RgkQPWFNRdICRIjW
         QZ+tYvfviZe8jTh+Aetu+CrTUVBHson3qov5eGJuvniXk3JfoUiJeCHNjzBEM33zQVat
         HCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Q15eoBQW+ndVdEuHxmdR78/VIpdRnCY/gFW79Q5++Y=;
        b=VqzCZ4Ec3YgsP9ryubxfKMjU4BzRkgPrnq2lbxNXnT4MzIPd11wSDTh319gE+TyijW
         apubnOFcjqc1uORPSA9JEOd7MLAjVLZkQ7oeLbQvP09y0DCD16fwB+epIdjtIPYdUxvz
         K27fVnKFtk03bo5kUje514sRw0dIBVqB/T/PP0T4A3d3zAuEHjatZm5gXmtfkURc3wXG
         k+XUhkbeMhSokemPCNSezowJUHRMfPMw0BgCRE5JdwMfF0WYWvkND27uG3chEAoQsK59
         bmAc5SVzRyHKGGJCDyHca5cWBSUSOytBq6nktueDNMdG6tagN+rd/MRxNRFslPCRi1Gc
         3d1Q==
X-Gm-Message-State: ACrzQf2Rd6Xmc8Ptkf0VZHkW/LSJLxWvAjLsXNvcRM+0dFtSpwfZ6tsa
        0xtDduv/CiKvo1fsm5OsWahHFQ==
X-Google-Smtp-Source: AMsMyM7rdaSOxuZbjzEc/VEG8h7kZQ83nH1qpB3jBULH8y8Ns8Rm2Ic8D29LJAQbjO7QhKZuDJvUsQ==
X-Received: by 2002:a17:90a:54:b0:212:eb01:1ce with SMTP id 20-20020a17090a005400b00212eb0101cemr39243143pjb.236.1667334488515;
        Tue, 01 Nov 2022 13:28:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090a1f0500b0020dd9382124sm6315783pja.57.2022.11.01.13.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:28:07 -0700 (PDT)
Date:   Tue, 1 Nov 2022 20:28:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GBVML5MWXZE9Na@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-10-oliver.upton@linux.dev>
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

On Thu, Oct 27, 2022, Oliver Upton wrote:
> There is no real urgency to free a stage-2 subtree that was pruned.
> Nonetheless, KVM does the tear down in the stage-2 fault path while
> holding the MMU lock.
> 
> Free removed stage-2 subtrees after an RCU grace period. To guarantee
> all stage-2 table pages are freed before killing a VM, add an
> rcu_barrier() to the flush path.

This is _very_ misleading.  The above paints RCU as an optimization of sorts to
avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
is _required_ for correctness when allowing parallel page faults to remove page
tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
accessing and/or holds a reference to the to-be-freed page table.

IMO, this patch should to be squashed with the previous patch, "Protect stage-2
traversal with RCU".  One doesn't make any sense without the other.
