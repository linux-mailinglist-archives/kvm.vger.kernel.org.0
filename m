Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846B543E541
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhJ1Pgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhJ1Pgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 11:36:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EBCC0613B9
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:34:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b1so2808440pfm.6
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ObU0mLn8cgLGt35bHM9Ve7PBUotjGGEWKnNtAqnV8Y0=;
        b=Dh2oRVWq7FNB4VxeeBx+DY+B7J6W36/D0YFmfA4JinPWULNj2JAyVIdGN5W95l+d90
         4Uu/ZwJdWUivmqUAxVTynE14t1JCgr4B8VIlvCnfQRBjV/9sZBN9FbtVQViBrcsIkfKk
         FKX6ULIrvBdeMPobrWIP7p55k83rg/EH2wU4GD4W9e2j7rIISQUbKASJH6T77kFM7m0Z
         Qtlmy8wjfeMDEMJrWpV2K5PFqGDN6VxYLPZtUxrtHEs4QyogxcvUebO7UVfiBHutG04k
         U0NkfKu6Je8Pt6shzy+xbyjZteg84KZAIk3v/fR91ZfKR/MAff+MA9k1aMrDIiCOqEqs
         s/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ObU0mLn8cgLGt35bHM9Ve7PBUotjGGEWKnNtAqnV8Y0=;
        b=CEk3YgjPgakmUkf2yRG2jKc/CtPzRh2Qomap1MaXNmLXVl32b7bG93UZk08bAqNHV3
         gOqUZOt53jWXg1oAE5l5XVANE87qeKToSp1v9ABcLwwAVX6n3b7Ps7RmnicnaW1+cQFU
         1JkDsh65tGSl8hVGA3RCjrSg4xLDpJAj1HQVFs1RunU3w7QrdjkxxwjbpRLgIZ38y5LZ
         YIvGIFl3WCfqxrazMh90NwHVGAwC+oy9E6gXZnpN25wu1XMjVKvVRk6he62Dd0p+0p2P
         Ys75tq8CpE8+8prfOTWACFxzCyBjLWAtDnnp4siyGSlxLBo3SbZgw6R5dYQugZv8/QNh
         KXjQ==
X-Gm-Message-State: AOAM531zYA+r+RGHKY+dClX2KxwzFZGXxJMf/YtcRWFkZjKnGl1jN8vG
        nUjzaCeBl0bW3vP8aB8TidAaGw==
X-Google-Smtp-Source: ABdhPJz6jdrYVfnN/6E/mwaWkSEy+zhYc5xKvC8pKY4AVCJGv9Uh9d4/rKPGgqsum0tyEq6Ye9Z/qw==
X-Received: by 2002:aa7:9427:0:b0:47c:3b8e:5253 with SMTP id y7-20020aa79427000000b0047c3b8e5253mr5166508pfo.69.1635435265242;
        Thu, 28 Oct 2021 08:34:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p12sm4586055pfh.52.2021.10.28.08.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 08:34:24 -0700 (PDT)
Date:   Thu, 28 Oct 2021 15:34:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v2 21/43] KVM: VMX: Clean up PI pre/post-block WARNs
Message-ID: <YXrC/X6b+tgn6cJ9@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-22-seanjc@google.com>
 <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Move the WARN sanity checks out of the PI descriptor update loop so as
> > not to spam the kernel log if the condition is violated and the update
> > takes multiple attempts due to another writer.  This also eliminates a
> > few extra uops from the retry path.
> > 
> > Technically not checking every attempt could mean KVM will now fail to
> > WARN in a scenario that would have failed before, but any such failure
> > would be inherently racy as some other agent (CPU or device) would have
> > to concurrent modify the PI descriptor.

...

> Don't know for sure if this is desired. I'll would just use WARN_ON_ONCE instead
> if the warning spams the log.
> 
> If there is a race I would rather want to catch it even if rare.

Paolo had similar concerns[*].  I copied the most relevant part of the discussion
below, let me know if you object to the outcome.

Thanks for the reviews!

[*] https://lore.kernel.org/all/YXllGfrjPX1pVUx6@google.com/T/#u

On Wed, Oct 27, 2021 at 8:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 27/10/21 17:28, Sean Christopherson wrote:
> > On Wed, Oct 27, 2021, Paolo Bonzini wrote:
> > > On 27/10/21 16:41, Sean Christopherson wrote:
> > > > The other thing I don't like about having the WARN in the loop is that it suggests
> > > > that something other than the vCPU can modify the NDST and SN fields, which is
> > > > wrong and confusing (for me).
> > >
> > > Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
> > > loop, it can be as simple as
> > >
> > > 	/* The processor can set ON concurrently.  */
> > >
> > > when you respin patch 21 and the rest of the series?
> >
> > I can definitely add a comment, but I think that comment is incorrect.
>
> It's completely backwards indeed.  I first had "the hardware" and then
> shut down my brain for a second to replace it.
>
> > So something like this?
> >
> > 	/* ON can be set concurrently by a different vCPU or by hardware. */
>
> Yes, of course.
