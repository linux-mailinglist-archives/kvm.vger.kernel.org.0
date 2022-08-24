Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CB559FE66
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiHXPcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 11:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbiHXPcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 11:32:13 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407BC1FCEB
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:32:12 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 12so15349109pga.1
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=UZnSHBhLdMOKtTsvoHUMcnhpm7mRfzt47Yx1rwe6TYo=;
        b=ZLLZ1sQgjDCQZCR6iPbiV+dqJNVFlqF98MJZe+fMBspnKcQ1UNH5o3QOOx9DF7zBKA
         4NTZQU8BcU6LZoqrr74W5W2rChziUMwFRSTTGrC513hiwIJ39DS6AjzTbmueQdO2STE0
         t09KkGjDmYbiMqWw8kicU5n4mAAvwqsvfR4L8kRTE4YxLV1mXG0u1f2lpXeh4xy6gdFe
         Wv/tpw2JwZvjKVZthEj5z4x1vSTS+evVhLMdntp8ICLZ2wM3nwRTCYJP9MatbCfSirsX
         fcVMxPNOyrjAZQmeXvPefg+H+k8Jj7MzekfI//odudIng7UsH3Qp7cbIUqf69180zIUj
         AbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=UZnSHBhLdMOKtTsvoHUMcnhpm7mRfzt47Yx1rwe6TYo=;
        b=sa15YeXUFmAeTkT9j+EkdmUZ7oc/QONYdqvgnBzXacLe989pF9dPxiLDXOFIJSeptm
         UZs/KOR+K715eFI4iazlyYKiwVxdQlTajKVaQrn3H2QYneLm572D9kHULwvOsGfb+FQY
         oFpy6pk1m+hjXbzx3N+UzU+5zfSh1iJQhz+Xw3VlljH5QXEb5HUP8wO3TKXCjFqaCI02
         npN9rBf9xCs9BcZv/WSEe+0f0gI7S/xZWJhYZ0O3a64DZYv6E9AM5+cxTQhaRYwhPVhy
         Z1PqLVki6NXhY5ZL9Y65pk4AB6LijWPPW+S8lHU812uEJaCaj6Vd1xWv5u2d/tvO3oPa
         TQ+w==
X-Gm-Message-State: ACgBeo3mY3Wq+FpsaEDlCGznfyTnKhQhbssR/Dt57PqSzl8j/f2zt07g
        PlP4TeH15SSCp6wPt4fE8nM+IQ==
X-Google-Smtp-Source: AA6agR5QWDXsHQ6VWlCNVAAXtH2sA1tM24WXPqXY0c9+lwwnmRBfulv0M4b7+RjikXl1y2MhtN3W7Q==
X-Received: by 2002:a63:8343:0:b0:42b:3b1a:89f6 with SMTP id h64-20020a638343000000b0042b3b1a89f6mr859171pge.26.1661355131607;
        Wed, 24 Aug 2022 08:32:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090ad3c500b001f53705ee92sm1567101pjw.6.2022.08.24.08.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:32:11 -0700 (PDT)
Date:   Wed, 24 Aug 2022 15:32:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Colton Lewis <coltonlewis@google.com>,
        Peter Gonda <pgonda@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v4 5/6] KVM: selftests: Make arm64's MMIO ucall multi-VM
 friendly
Message-ID: <YwZEdzHtWEfCpr7B@google.com>
References: <20220824032115.3563686-1-seanjc@google.com>
 <20220824032115.3563686-6-seanjc@google.com>
 <YwY9BYDUeiT87/Vs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwY9BYDUeiT87/Vs@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022, Oliver Upton wrote:
> Hi Sean,
> 
> On Wed, Aug 24, 2022 at 03:21:14AM +0000, Sean Christopherson wrote:
> > +/*
> > + * Sync a global pointer to the guest that has a per-VM value, in which case
> > + * writes to the host copy of the "global" must be serialized (in case a test
> > + * is being truly crazy and spawning multiple VMs concurrently).
> > + */
> 
> Do we even care about writes to the host's copy of the global pointer?
> I don't see how the host pointer is used beyond serializing writes into
> a guest.
> 
> IOW, it looks as though we could skip the whole global illusion
> altogether and write straight into guest memory.

*sigh*

This exact thought crossed my mind when I first looked at this code, but somehow
I couldn't come up with the obvious solution of using a temporary on-stack variable
to hold the desired value.

Something like this should work.

#define write_guest_global(vm, g, val) ({			\
	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
	typeof(g) _val = val;					\
								\
	memcpy(_p, &(_val), sizeof(g));				\
})
