Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7D71F4A8
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 23:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjFAV3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 17:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjFAV3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 17:29:39 -0400
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAEC184
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 14:29:38 -0700 (PDT)
Date:   Thu, 1 Jun 2023 21:29:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685654976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knI9AIkV5UPc98gICILs0zDsv+6LfXVKGVQS/To328I=;
        b=hIZZwDG3D74IbuDYvfgBJ4WCCM6DB8SSgtKfWF+92G2+2bqm7w2rjTTlf1JxJKQ0O3oKGo
        beJ/55KEYSDw/GQM9ELraMazMDKtWwW+Lfj7Iu7YEphpsyyfcMa2Y0tq/jUuqE/AQ4Bbf6
        q50/lSein0U5FROit7jlsA1PomEVumE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 05/22] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZHkNu6dWV+5iqTuy@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-6-amoorthy@google.com>
 <ZHj25HsCExz/uCo/@linux.dev>
 <CAF7b7mrK+SgyxjYqMyJC0PA4C8SFRX_Q=x7Db+Ck8i89wzvw8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mrK+SgyxjYqMyJC0PA4C8SFRX_Q=x7Db+Ck8i89wzvw8w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:30:58PM -0700, Anish Moorthy wrote:
> On Thu, Jun 1, 2023 at 12:52 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >    Eventually, you can stuff a bit in there to advertise that all
> >    EFAULTs are reliable.
> 
> I don't think this is an objective: the idea is to annotate efaults
> tracing back to user accesses (see [2]). Although the idea of
> annotating with some "unrecoverable" flag set for other efaults has
> been tossed around, so we may end up with that.

Right, there's quite a bit of detail entailed by what such a bit
means... In any case, the idea would be to have a forward-looking
stance with the UAPI where we can bolt on more things to the existing
CAP in the future.

> [2] https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.com/T/#m5715f3a14a6a9ff9a4188918ec105592f0bfc69a
> 
> > [*] https://lore.kernel.org/kvmarm/ZHjqkdEOVUiazj5d@google.com/
> >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index cf7d3de6f3689..f3effc93cbef3 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > >       spin_lock_init(&kvm->mn_invalidate_lock);
> > >       rcuwait_init(&kvm->mn_memslots_update_rcuwait);
> > >       xa_init(&kvm->vcpu_array);
> > > +     kvm->fill_efault_info = false;
> > >
> > >       INIT_LIST_HEAD(&kvm->gpc_list);
> > >       spin_lock_init(&kvm->gpc_lock);
> > > @@ -4096,6 +4097,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
> > >                       put_pid(oldpid);
> > >               }
> > >               r = kvm_arch_vcpu_ioctl_run(vcpu);
> > > +             WARN_ON_ONCE(r == -EFAULT &&
> > > +                                      vcpu->run->exit_reason != KVM_EXIT_MEMORY_FAULT);
> >
> > This might be a bit overkill, as it will definitely fire on unsupported
> > architectures. Instead you may want to condition this on an architecture
> > actually selecting support for MEMORY_FAULT_INFO.
> 
> Ah, that's embarrassing. Thanks for the catch.

No problem at all. Pretty sure I've done a lot more actually egregious
changes than you have ;)

While we're here, forgot to mention it before but please clean up that
indentation too. I think you may've gotten in a fight with the Google3
styling of your editor and lost :)

-- 
Thanks,
Oliver
