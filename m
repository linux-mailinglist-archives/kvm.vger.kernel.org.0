Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7716053EA
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJSXaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJSXaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:30:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6955EDB770
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:30:01 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f9so231572plb.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qruOvYNq6YtcLgC8q9oi5W0wV4Pui1eBKPtr9rOj7ao=;
        b=pNS4i1/uTE4ZjPfTxUlttdhibsboeayO977TaMrS1sYkQiDeEdxdrNp8fYJxt/nlLl
         rY+UubEWMRQGyUBH2CE+gvS0hQUwfZ/g/f+7WQ6ctLMQLVeSVueJHSewAFzsjHLFpDjv
         0q8T/L/ZOjlxQwcPOUqlV8+Qcu76Jd9tybLqBjXd5Kc+YuYYIEkeQn3/nUUnm7j1b7QX
         kY3YVqJu2O4STBO5JPK3vMHrMDesVjvETNBxFs/zxcBLH4y84LB7dem38QmEhj3zJ1Wj
         /vVR/HnRTX4H68Fhk5dHUkhFlI0AlPNABY+kfiysYV98/fuDZZoF7SKrdyuyByK+7H2G
         ++8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qruOvYNq6YtcLgC8q9oi5W0wV4Pui1eBKPtr9rOj7ao=;
        b=C2KGt9rd3eO5GcN07gH+i9xWqI9zm0bzZMiBVbXYb3pp61FTor64xM4UqIzFSP05WS
         ps5XwwLo5IhlXq3X4EtSnkat6Z7ySG3at0160v0zJP+I/1sv1qA58SFELORGIZbM590O
         s2Guyk7GkIuLq1Hko3PFzlAR14jNtxdraerQpxyqc0nXvGtAlMsPZrhrVT3DGnNq/t42
         q6ClCcePfwPY+QMr9fCerJNM16OcMgGuQsNsheFLiZr9bUy3USWhqjfS1LhfPoVEyqFW
         kS5E6qImHxDGuUjVW5rIY/wbXJA4SyHPWkfUSYNvHddM/IDdR3R5O7SLnHvZEtr0v93F
         9j+g==
X-Gm-Message-State: ACrzQf2OOVr9Ovpv8NgFzLN109sdJwK9QV+lBR/hIpkwuu3e0/0rBgL1
        00kDiHt+OSLV+xhcWXUIMkq9KQ==
X-Google-Smtp-Source: AMsMyM51FW42zS56Z56v3OpmK3a6FlWgAAbvrNLxA+8YZJ8dKFrQg5/eqpzDYRzimT6KdDBkOpGsRQ==
X-Received: by 2002:a17:902:e890:b0:185:4ac7:9757 with SMTP id w16-20020a170902e89000b001854ac79757mr10900658plg.150.1666222200834;
        Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d25-20020aa797b9000000b00561f8fdba8esm12367909pfq.12.2022.10.19.16.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:30:00 -0700 (PDT)
Date:   Wed, 19 Oct 2022 23:29:56 +0000
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
Subject: Re: [PATCH v2 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1CIdN5kcJPaZdqv@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007232818.459650-9-oliver.upton@linux.dev>
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

On Fri, Oct 07, 2022, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel. Acquire and release the RCU read lock when traversing the page
> tables.
> 
> Use the _raw() flavor of rcu_dereference when changes to the page tables
> are otherwise protected from parallel software walkers (e.g. holding the
> write lock).
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

...

> @@ -32,6 +39,33 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>  	return pteref;
>  }
>  
> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +#else
> +
> +typedef kvm_pte_t __rcu *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	if (shared)
> +		return rcu_dereference(pteref);
> +
> +	return rcu_dereference_raw(pteref);

Rather than use raw, use rcu_dereference_check().  If you can plumb down @kvm or
@mmu_lock, the ideal check would be (apparently there's no lockdep_is_held_write()
wrapper?)

	return READ_ONCE(*rcu_dereference_check(ptep, lockdep_is_held_type(mmu_lock, 0)));

If getting at mmu_lock is too difficult, this can still be

	return READ_ONCE(*rcu_dereference_check(ptep, !shared);

Doubt it matters for code generation, but IMO it's cleaner overall.
