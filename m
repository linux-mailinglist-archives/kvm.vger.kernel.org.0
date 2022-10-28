Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7E611820
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 18:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiJ1Qvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 12:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJ1Qvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 12:51:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3818198441
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:51:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h2so5322939pgp.4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sUnyfcJ4wqSO0xrTWs88o/JJTjjWDs2reti8Xe/IcQQ=;
        b=ldL5pcfBfn3omzF9slxHxojXuFGUDmy5v7rvR+xOn27cGZqDgXeDSAkaRfB8MfsoYW
         gWG2NjXidjE4A1C8/QkcjcLxYQHrJIQFPQ6be1l8ULN9NlSJBaPeR2ZjHlib71W0w+7N
         XpvVD0R6JlnDgZI9I1fAkPBHcE8TX2aPKtCMI+iPCYWy+13yw1tZQWGUEzkbfc0NqYS6
         IdOE+74TYzdhdzcV+aH3pqQ+yXLh1c9Um5V35VZThCVo/nSL6uwaxVds6H4gOF3Ffj+u
         IEbNlEtPr61tAD0vuyICQBzWqlDqDpesXBXwCYcgGTjaMW6+GfwquKP++NG+nrUurMqc
         qWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUnyfcJ4wqSO0xrTWs88o/JJTjjWDs2reti8Xe/IcQQ=;
        b=0t++NrnyftTr2E/17dhJA9iHdAr3zGQ/kcGd7Yk8xzQh4QLNN3zffgoXjBPzCQ6IsV
         9NVbxjSZ8OUer0Mr8oD984QT2ST6U2csNAEQp0nwW1I27uHeO0S9uX/dprGMGkrmysnH
         k+16LomDoaK1S2kPCkPVMr4iUZgzabAWp8Trz0758tyhWlL2UmO2XrkUWglCEok1kJkg
         K2Cr14B37UyUOzWR1xPXX54SuiR7bbLea1U4kMX2vtQdc2ZYDRjI2smhR8Fu/tGPtfYc
         VY/BKIQStd+Z4BZiHyTjyPzBVDD07fN9xR+tgHyfCKDUDGFxZHNGz5rm1WikDGAQwc/y
         b5PA==
X-Gm-Message-State: ACrzQf0qdtTR8HQOJ/c4xVmMkbED3as5U0T/j4+LRmlCSnsGVQXYkr2q
        rETg8aBH+BA7fS6c658xie/VyA==
X-Google-Smtp-Source: AMsMyM5Ryr2eWmEIIA6XfONaasJIcUlq05GHYZ5aaMlzGaWeANzSZA6GZ295dwKjBXLv7vFYiD1Rnw==
X-Received: by 2002:a62:1a97:0:b0:562:5587:12d6 with SMTP id a145-20020a621a97000000b00562558712d6mr49177pfa.37.1666975891200;
        Fri, 28 Oct 2022 09:51:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c1c600b00177f4ef7970sm3305243plc.11.2022.10.28.09.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:51:30 -0700 (PDT)
Date:   Fri, 28 Oct 2022 16:51:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1wIj/sdJw7VMiY5@google.com>
References: <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
 <Y1ghIKrAsRFwSFsO@google.com>
 <877d0lhdo9.wl-maz@kernel.org>
 <Y1rDkz6q8+ZgYFWW@google.com>
 <875yg5glvk.wl-maz@kernel.org>
 <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36c97b96-1427-ce05-8fce-fd21c4711af9@redhat.com>
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

On Fri, Oct 28, 2022, Gavin Shan wrote:
> Hi Sean and Marc,
> 
> On 10/28/22 2:30 AM, Marc Zyngier wrote:
> > On Thu, 27 Oct 2022 18:44:51 +0100,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Thu, Oct 27, 2022, Marc Zyngier wrote:
> > > > On Tue, 25 Oct 2022 18:47:12 +0100, Sean Christopherson <seanjc@google.com> wrote:
> 
> [...]
> > > 
> > > > > And ideally such bugs would detected without relying on userspace to
> > > > > enabling dirty logging, e.g. the Hyper-V bug lurked for quite some
> > > > > time and was only found when mark_page_dirty_in_slot() started
> > > > > WARNing.
> > > > > 
> > > > > I'm ok if arm64 wants to let userspace shoot itself in the foot with
> > > > > the ITS, but I'm not ok dropping the protections in the common
> > > > > mark_page_dirty_in_slot().
> > > > > 
> > > > > One somewhat gross idea would be to let architectures override the
> > > > > "there must be a running vCPU" rule, e.g. arm64 could toggle a flag
> > > > > in kvm->arch in its kvm_write_guest_lock() to note that an expected
> > > > > write without a vCPU is in-progress:
> > > > > 
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index 8c5c69ba47a7..d1da8914f749 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > > > >          struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > > > >   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
> > > > > -       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
> > > > > +       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
> > > > > +               return;
> > > > > +
> > > > > +       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
> > > > >                  return;
> > > > >   #endif
> > > > > @@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
> > > > >                  unsigned long rel_gfn = gfn - memslot->base_gfn;
> > > > >                  u32 slot = (memslot->as_id << 16) | memslot->id;
> > > > > -               if (kvm->dirty_ring_size)
> > > > > +               if (kvm->dirty_ring_size && vcpu)
> > > > >                          kvm_dirty_ring_push(&vcpu->dirty_ring,
> > > > >                                              slot, rel_gfn);
> > > > > -               else
> > > > > +               else if (memslot->dirty_bitmap)
> > > > >                          set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > > > >          }
> > > > >   }

...

> > > A slightly different alternative would be have a completely separate
> > > API for writing guest memory without an associated vCPU.  I.e. start
> > > building up proper device emulation support.  Then the vCPU-based
> > > APIs could yell if a vCPU isn't provided (or there is no running
> > > vCPU in the current mess).  And the deviced-based API could be
> > > provided if and only if the architecture actually supports emulating
> > > writes from devices, i.e. x86 would not opt-in and so would even
> > > have access to the API.
> > 
> > Which is what I was putting under the "major surgery" label in my
> > previous email.
> > 
> > Anyhow, for the purpose of unblocking Gavin's series, I suggest to
> > adopt your per-arch opt-out suggestion as a stop gap measure, and we
> > will then be able to bike-shed for weeks on what the shape of the
> > device-originated memory dirtying API should be.
> > 
> 
> It's really a 'major surgery' and I would like to make sure I fully understand
> 'a completely separate API for writing guest memory without an associated vCPU",
> before I'm going to working on v7 for this.
>
> There are 7 functions and 2 macros involved as below. I assume Sean is suggesting
> to add another argument, whose name can be 'has_vcpu', for these functions and macros?

No.

As March suggested, for your series just implement the hacky arch opt-out, don't
try and do surgery at this time as that's likely going to be a months-long effort
that touches a lot of cross-arch code.

E.g. I believe the ARM opt-out (opt-in?) for the above hack would be

bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
{
	return vgic_has_its(kvm);
}
