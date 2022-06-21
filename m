Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCE0553504
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351916AbiFUOyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiFUOyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:54:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186D237F6
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 07:54:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso13682380pjk.0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 07:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ePpQR91B1wy0uIyvmn3lmteXD4y16fGYbzlfAq99TJo=;
        b=coFv7I5Y78JhXoxS37XR9c+mZYbk7SXPwuO7aREgBr4Q4xY/8nD/BF5WkQBHENLFnR
         M2swZ0YHKkbeZ6TusTYTCyinn24BoObIO+T5wnAXl9f2sGVIP8rG2F0nAbxkmCVGoPfH
         dAA8jbBGQ+fJqAoZJEhloFcXw4ggDv8whrRonPLp5/G9ruQkcs3nglSNUwAkZ1SThAWs
         1rcmQq3sdA0WobCN3wZET42yLYirfqnABm0YdtxHceX3EHLEBkMtv0LKHMPI3jgadxxF
         dsa+Azc2y1bTS9+0PGwluDhQy+WUsYOcrTtvwmmyLjgGWHBJwb4h86H6/giVMU3D/eNI
         BJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ePpQR91B1wy0uIyvmn3lmteXD4y16fGYbzlfAq99TJo=;
        b=UpTzrzZ7dGM9nY+64MCR4qTcp1kowIgk/ox+ifwxOYZnu8iImyClkclJS+jWR6mfkL
         qp7tCVSYHvAwKkYlXhC2Y1IDzETmW6js1rgGdDIwuVAIVMwQby8L8cwIdKORkqk/Bowc
         cPIH9Cnjpkvp+4RmUuku0o5LrXPmDPxyYweHDSMxzBdRfJsSQQ/CYwEUw/VeXxex61u2
         WDy/71laBQ8NrxRQq3MSX8v2jx0bb5HZ1pdoOiOQ21NdOn+vPzHXm+KyizPFigWLyTi3
         BT+QAIX4AKcvzvinTvSYRAlrtG7ntMHnj4ATXAPGeiTcdRRGR7+8B43HI3/CwEzwUHkW
         rMXg==
X-Gm-Message-State: AJIora+0z9u0qt27ygbJmec+QGCuJ80KcTd49GfY3T6D7eUCdRgDXnCZ
        iwlvAyOS6bpz34cvub9wgfMWqg==
X-Google-Smtp-Source: AGRyM1vbuWPmzs8GSCKmhq+oi4jC8RW6CP9GBVkjErftz4qJu7wc14nAXYcvbe2B5lTWXF3n/kUg1Q==
X-Received: by 2002:a17:90b:4a82:b0:1ec:bb6b:38d0 with SMTP id lp2-20020a17090b4a8200b001ecbb6b38d0mr7523665pjb.213.1655823262366;
        Tue, 21 Jun 2022 07:54:22 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b21-20020aa78115000000b00518764d09cdsm11307136pfi.164.2022.06.21.07.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 07:54:21 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:54:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
Message-ID: <YrHbml1HAfDtvMfn@google.com>
References: <20220618001618.1840806-1-seanjc@google.com>
 <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19bba1a0-8fb7-2aae-a65a-1111e29b92d3@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022, Paolo Bonzini wrote:
> On 6/18/22 02:16, Sean Christopherson wrote:
> > Consolidate the code for making and getting ucalls.  All architectures pass
> > the ucall struct via memory, so filling and copying the struct is 100%
> > generic.  The only per-arch code is sending and receiving the address of
> > said struct.
> > 
> > Tested on x86 and arm, compile tested on s390 and RISC-V.
> 
> I'm not sure about doing this yet.  The SEV tests added multiple
> implementations of the ucalls in one architecture.  I have rebased those
> recently (not the SEV part) to get more familiar with the new kvm_vcpu API
> for selftests, and was going to look at your old review next...

I had forgotten about that code.  My idea of a per-VM list[*] would fit nicely on
top, though maybe drop the last patch from this series.

[*] https://lore.kernel.org/all/Yc4gcJdhxthBKUUd@google.com
