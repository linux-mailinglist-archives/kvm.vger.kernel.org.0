Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4363F5751C6
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiGNP1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbiGNP1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:27:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E1D4BD26
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:27:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso3438597pjk.3
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HI9CgNWKgeW7231dCtqDTX0fqqchygptoI0IPLenPck=;
        b=e2QCE6urif/v2vTYEnvTvWpG3mdbVuUdheNQ8U6ByRWeKrbSH3KdcZLbXXwJ/3KQqm
         jdFhhuFZ1mIn+1x4Cmb+UQu7YuQRJPfpXo4ce7GkPS7/faKIhAUpd4rn2NlyQF3M0rLG
         cyNJde73IBC8abl+ufVa0BinXByGg1iKiEP3TTl0cfoQyG4KbDGA374S0AGEew9MpXKi
         vJiB7SyRp1ylrxb9Plxv91HsSVf/KKi48odD9fI/uncag5qYQ86IVHNfRBa+Jh/mVkb0
         sVCZPSCFIGLWqH5+IboInA9ejoSfureqUNRantXNf+JjrX+3ur22EiYc6JoDP70pPd7m
         1E0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HI9CgNWKgeW7231dCtqDTX0fqqchygptoI0IPLenPck=;
        b=gkz3RFyHi+GaKIcICk1rsgu5UOtBuOFxsizCHtio5GdmaKcY6D4T3EaneBV7wjz34w
         9g7kPKKLrT31IMVCSTG3Ltu+zuntKnyufni1rTNGmBRsjyVg7/4YWgz0iPsH581gGbvq
         BwzoPbgCOIDUU3EriBajItcr8uhN/Uwug2L6ssrl4AgYa6TI3cM2axYqVAkw6FGhUL1K
         iVzHDxcelDeOvW+hRB8ZS4DRYGTUnr2PaMF+w3773UhwY9hIbsfTMrXt2xBh5QmXVXxr
         tqjsrlLZZLyEKFPvXh88+WjwM7LdX1zZqE64T0gdgRpeD3eDQ7+DUJh62ngm3RzQilxJ
         jaPQ==
X-Gm-Message-State: AJIora9hSbbn1ZBR1hcWpRCI0uqXEmXvZ2IqjtJ0ohVtHc+BC7s1Eo6O
        TOytHD8vV6z/rJ/2yItE0h4Fiw==
X-Google-Smtp-Source: AGRyM1up4WSZl6YMWYTzJzSHE6AZ9dtjfL4oS6Irek7Mq6UdWej33SDmamidR9vXa335CphMOwqBbA==
X-Received: by 2002:a17:90b:1bc1:b0:1f0:3830:8c99 with SMTP id oa1-20020a17090b1bc100b001f038308c99mr17029550pjb.1.1657812441261;
        Thu, 14 Jul 2022 08:27:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b0016bfe9ab1f3sm1626758plg.36.2022.07.14.08.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:27:20 -0700 (PDT)
Date:   Thu, 14 Jul 2022 15:27:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 0/9] KVM: x86/MMU: Optimize disabling dirty logging
Message-ID: <YtA11dFqXG6Ou5WE@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <dba0ecc8-90ae-975f-7a27-3049d6951ba0@redhat.com>
 <YszQcBy1RwGmkkht@google.com>
 <52ef13d4-068d-bd2c-11aa-c7053798aee9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ef13d4-068d-bd2c-11aa-c7053798aee9@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Paolo Bonzini wrote:
> On 7/12/22 03:37, Sean Christopherson wrote:
> > This fell through the cracks.  Ben is on a long vacation, I'll find my copy of
> > the Necronomicon and do a bit of resurrection, and address the feedback from v2
> > along the way.
> 
> This was superseded by the simple patch to zap only the leaves I think?

Ah, right you are, commit 5ba7c4c6d1c7 ("KVM: x86/MMU: Zap non-leaf SPTEs when
disabling dirty logging").  I got somewhat confused because there's a stale comment
above the inner helper:

	/*
	 * Clear leaf entries which could be replaced by large mappings, for
	 * GFNs within the slot.
	 */

If we drop the "only refcounted struct pages can be huge" requirement, then the
flow becomes much simpler as there's no need to recurse down to the leafs only to
step back up:

	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
retry:
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
			continue;

		if (!is_shadow_present_pte(iter.old_spte))
			continue;

		/*
		 * Don't zap leaf SPTEs, if a leaf SPTE could be replaced with
		 * a large page size, then its parent would have been zapped
		 * instead of stepping down.
		 */
		if (is_last_spte(iter.old_spte, iter.level))
			continue;

		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
							      iter.gfn, PG_LEVEL_NUM);
		if (max_mapping_level <= iter.level)
			continue;

		/* Note, a successful atomic zap also does a remote TLB flush. */
		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
			goto retry;
	}
