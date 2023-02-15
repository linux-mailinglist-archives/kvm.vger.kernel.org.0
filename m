Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1DB69819D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBORHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBORHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:07:50 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC255FDA
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:07:46 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4cddba76f55so227601387b3.23
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I40PJrFRqn61VwCmmZvurXKna/KGPzaaS+rQHZXZvn0=;
        b=l8u1qpGgi11tT4E8pv9pTuFXHM/7WY2MCiv2bszlJ1zxeExjqm25IM6hph3zf0n+GH
         ysvNzeo91bE0dHqERdOSLN9nkAhwpdM8rvp4LDTHjt0IYdwmbCUNot0/sh9QF2e0g+4Z
         iXxjc61Os8fGMeChQfy7xU38ALBiYCz8AYDCwTG4waTH3d1iDkVZc0yYh5UNBmH9BNIC
         4s4k2LCWdlix0TbeFAYqhetPtDE28k4vgwnqcFslAgOyUWGhqcYIEmTs3P2wcstRRrmQ
         ULTCsPbzrtYJpit4Rb6KoytvdVRvTJo64CyT87HR+oXbZKIrYwa+Kqzs6Ne5vw5YvgZQ
         r+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I40PJrFRqn61VwCmmZvurXKna/KGPzaaS+rQHZXZvn0=;
        b=noan4v8wxXli8HndF5bvCOAy2y7CZww3VHo4Jk0Ng0mXIO54GwdImq1C8fIAIv9Bn5
         w0+S9u4RUmZ3+7uC6ip+iAYqPGx4VecMH9/oYoV7UTWHyoCLaVkcaKF9yD15YhlX/Ja5
         3pS+buPhnP+lE5iB6+Frv95BSNn1aZjH39tLeGwSTgomGtuvJQxZfVpUlHDA9jQUwZjo
         7fmQf9fWx8gG2d9R7E7oPQ4vOZU1vsvderyoyYIY3EDvypnKoGu8/OwGt1va8By9ykQ1
         W720ne5kCruMv+krOEVm4/lKmL2gbWPq6FkvafFj9zEQMwzZO/kkjMmnYC/O3bAzLaSd
         wMKA==
X-Gm-Message-State: AO0yUKWnkow4Y91P7M0qDbaVPL9ckY7esGn5ipRsJrN4d2hrDnlqXStM
        dIS2ys2JS+VqS/IYqfI5/yJfnft4MAM=
X-Google-Smtp-Source: AK7set/bKyGjjQSPDfHloXqvYliTaSoAw87YpPgzxpVLEYaD/uIjcgxZV0daIcoU5fiuPAjFav357tj93Iw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2c2:b0:920:2b79:84b4 with SMTP id
 w2-20020a05690202c200b009202b7984b4mr349239ybh.386.1676480865897; Wed, 15 Feb
 2023 09:07:45 -0800 (PST)
Date:   Wed, 15 Feb 2023 09:07:44 -0800
In-Reply-To: <87mt5fz5g6.wl-maz@kernel.org>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org>
Message-ID: <Y+0RYMfw6pHrSLX4@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, Marc Zyngier wrote:
> On Wed, 15 Feb 2023 01:16:11 +0000, Anish Moorthy <amoorthy@google.com> wrote:
> >  8. Other capabilities.
> >  ======================
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 109b18e2789c4..9352e7f8480fb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -801,6 +801,9 @@ struct kvm {
> >  	bool vm_bugged;
> >  	bool vm_dead;
> >  
> > +	rwlock_t mem_fault_nowait_lock;
> > +	bool mem_fault_nowait;
> 
> A full-fat rwlock to protect a single bool? What benefits do you
> expect from a rwlock? Why is it preferable to an atomic access, or a
> simple bitop?

There's no need to have any kind off dedicated atomicity.  The only readers are
in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs are created.
