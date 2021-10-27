Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0238F43CC86
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhJ0OoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbhJ0On7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 10:43:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EDEC0613B9
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:41:34 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so5349611pje.0
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 07:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6OXSnlnR0rRr4zd42xResiJ3HjI4vG4520z7JUuMyYs=;
        b=BjRC0MDFBU5q9E3Xn8qZmMldFXyvZ//eySha9xAzB0jmoDoGvnBh5rZJNDCpSwdREy
         9EoAYcD7qkeaNtvcOM9mdpbf0o5Zx8GfPrl52oPVsVupbvte1MAYXeh2gVgPvsjmKTcr
         OvG3N8s6IdOwoiORDWmu79MSfTC8tCdjVwsKVWNIZ01jMG+JmYVN7Tn36JxeYZuyLkmP
         l/68I6qwCJelKOJxW8ZO7A5e+myyHTZHJETfMvox2BFMDLmdkBWjqGYYnYuVXEvP/t+D
         dTunWvGIgVZuDjHHD1Ty/XEe2DuBSz3CLrLeXdA9pKLBh6KsJK0Pre9s46e4k0Dr+ooy
         7X+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6OXSnlnR0rRr4zd42xResiJ3HjI4vG4520z7JUuMyYs=;
        b=Gsdk7sXpfkqDBS85TyjGA7YYAyrIrsZnaRXIdIDtyGfRPhtqUDWWsZEj07rRJa7LRI
         XZW4BS+5Az2dKjlt6rs2Yyyv+gwWGxtRZD1OGzbnf+ubDqSXmB6YhPoOtCb0myddvtu9
         p+Kye7+57Ovd42dQG5g7FgxR8eKU1a3i5oPIEAJDEbEajHxrwQDwo5n4h2ucDfZaxs8/
         0WVIlhmIjhiUN7CAWTozkZv8i69IMhPjDCIASAW2jhYMwT5v5IzR8DXmQRmBGNbJw0O4
         9rqsIJbRQsQQjH+dVHb9dv7yXFy38TqSIJCW312WrJ14ZhhzIHeK+OdsTUGcm3sD/Cbc
         Fwhg==
X-Gm-Message-State: AOAM533KdBhCxnnF4Eoc5a9ADlAaOHQA6kJ1tytPy4Db8NXtGIrHQJr2
        qaYIePMpfmkU/DKLP8gFpORwIA==
X-Google-Smtp-Source: ABdhPJwpvrRMvTZfA8g36IWigq/Ddl2lTxPKT07H9cOHEBI6XhDgd4CVWZEorIKgU9/kACcZuDTlgw==
X-Received: by 2002:a17:902:e812:b0:13f:3be8:b15a with SMTP id u18-20020a170902e81200b0013f3be8b15amr27601253plg.49.1635345693861;
        Wed, 27 Oct 2021 07:41:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e9sm203521pfv.189.2021.10.27.07.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:41:33 -0700 (PDT)
Date:   Wed, 27 Oct 2021 14:41:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
Message-ID: <YXllGfrjPX1pVUx6@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <614858dd-106c-64cc-04bc-f1887b2054d1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 09/10/21 04:11, Sean Christopherson wrote:
> Queued 1-20 and 22-28.  Initially I skipped 21 because I didn't receive it,
> but I have to think more about whether I agree with it.

https://lkml.kernel.org/r/20211009021236.4122790-22-seanjc@google.com

> In reality the CMPXCHG loops can really fail just once, because they only
> race with the processor setting ON=1.  But if the warnings were to trigger
> at all, it would mean that something iffy is happening in the
> pi_desc->control state machine, and having the check on every iteration is
> (very marginally) more effective.

Yeah, the "very marginally" caveat is essentially my argument.  The WARNs are
really there to ensure that the vCPU itself did the correct setup/clean before
and after blocking.  Because IRQs are disabled, a failure on iteration>0 but not
iteration=0 would mean that a different CPU or a device modified the PI descriptor.
If that happens, (a) something is wildly wrong and (b) as you noted, the odds of
the WARN firing in the tiny window between iteration=0 and iteration=1 are really,
really low.

The other thing I don't like about having the WARN in the loop is that it suggests
that something other than the vCPU can modify the NDST and SN fields, which is
wrong and confusing (for me).  The WARNs in the loops made more sense when the
loops ran with IRQs enabled prior to commit 8b306e2f3c41 ("KVM: VMX: avoid
double list add with VT-d posted interrupts").  Then it would be at least plausible
that a vCPU could mess up its own descriptor while being scheduled out/in.
