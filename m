Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649B33AD19A
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhFRSAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 14:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhFRSAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 14:00:05 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93DAC061768
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 10:57:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bp38so18108060lfb.0
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=maDxaMkygfC98K2Jogz/weNvhZGyllV9okYERLKrWaQ=;
        b=hM4ZsTOU9ID7wdvLSCiQA8V5BpnwohQD4F+ZhA+a5pxc6iNnXJ3z9WGHbA1JXlG93m
         BT698mKiYn551XOkseFwSUGgTDfzU1qeujrJVMB6Wa1t31SgD+BDzAbKS7pR/uJ1GR2h
         d/leM993XVeAmOh6vd9/B3Un21AoweRzZT49n2INzXjw3pzD6Y/w22vZC3ULdyV1S/3c
         KmChb8XJiXdgWGJlSRH26KP3t/3kJNx79yPbtJUtR869kLxKtnpGG1ZOeFh1q/freNxh
         Op7GngxAAbdwgAgu+bdYxao5/uGfsrNXlYfnx9wmS47eJ1kVvh23lGRh1Z3muHgn0bbA
         3OgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=maDxaMkygfC98K2Jogz/weNvhZGyllV9okYERLKrWaQ=;
        b=r0thNoaVm4voDTmHj64zRL24f0EpK0mYSsXGo9bTCFmZtuztCDE4/3Mk/eDHeUYccd
         0mqo5dWKsx0IT1R6o4eqzZSkCrq7Y99dI39p2B5yEpJYo3fVT0PG7tO1XGmv3xo7NuDQ
         DQ9FJX9Wtb5W9w1Q0j6PtN5z2WxeUm9255+Nx5SOwhMs+sIAAe+eEdTKnnpwQCl2XdJe
         jDgPbnW50kBCBty+M/d+WFgJ7V9amMX9hdlRSNo2kF4Wl8qqwbf5pdH6rTlouyQVPIJR
         tjyzKOYU6PqGH0BrNYhEItoG0k/0nweQ2AIEFkeAEilST1RCB97/qvaGQB+m91/L+krl
         yyvg==
X-Gm-Message-State: AOAM533MMNOImQ7Mrxp6JcCK+viVmdj2QVnyzZrGuLEv4z58UkRZdWPv
        C4mXlDGPR6ZpdwT3Ejgs/W1yGEa66/Z7gHw2FpPO7g==
X-Google-Smtp-Source: ABdhPJyhz9sA9ZKTa4VM/IMLnRITWImb7PHMT9HE1lgCmMMbxqqMV/BzR7/LJt2PxWXftvvxefjxSj5Ss7JOXAxsjKg=
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr4273045lfg.536.1624039073748;
 Fri, 18 Jun 2021 10:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com> <YMxEqvKyGnZinMOS@kroah.com>
 <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org> <YMxYC8syYRBhbBAq@kroah.com> <22bb0eb6-1305-4af9-aecc-166d7e62e6c3@gnu.org>
In-Reply-To: <22bb0eb6-1305-4af9-aecc-166d7e62e6c3@gnu.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 18 Jun 2021 12:57:42 -0500
Message-ID: <CAAdAUtgG6awhfkWuDJMQn8-mWYbOSzFZD_amqB+gJ9RH-91VTA@mail.gmail.com>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats data
To:     Paolo Bonzini <bonzini@gnu.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Fri, Jun 18, 2021 at 10:51 AM Paolo Bonzini <bonzini@gnu.org> wrote:
>
> On 18/06/21 10:23, Greg KH wrote:
> > On Fri, Jun 18, 2021 at 10:02:57AM +0200, Paolo Bonzini wrote:
> >> On 18/06/21 09:00, Greg KH wrote:
> >>>> +struct kvm_stats_header {
> >>>> +  __u32 name_size;
> >>>> +  __u32 count;
> >>>> +  __u32 desc_offset;
> >>>> +  __u32 data_offset;
> >>>> +  char id[];
> >>>> +};
> >>>
> >>> You mentioned before that the size of this really is the size of the
> >>> structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
> >>>
> >>> If so, why not put that value explicitly in:
> >>>     char id[THE_REST_OF_THE_HEADER_SPACE];
> >>>
> >>> As this is not a variable header size at all, and you can not change it
> >>> going forward, so the variable length array here feels disingenuous.
> >>
> >> It can change; the header goes up to desc_offset.  Let's rename desc_offset
> >> to header_size.
> >
> > "Traditionally" the first field of a variable length structure like this
> > has the size.  So maybe this needs to be:
> >
> > struct kvm_stats_header {
> >       __u32 header_size;
>
> Thinking more about it, I slightly prefer id_offset so that we can later
> give a meaning to any bytes after kvm_stats_header and before id_offset.
>
> Adding four unused bytes (for now always zero) is also useful to future
> proof the struct a bit, thus:
>
> struct kvm_stats_header {
>         __u32 flags;
>         __u32 name_size;
>         __u32 num_desc;
>         __u32 id_offset;
>         __u32 desc_offset;
>         __u32 data_offset;
> }
>
> (Indeed num_desc is better than count).
>
> > Wait, what is "name_size" here for?
>
> So that you know the full size of the descriptors is (name_size +
> sizeof(kvm_stats_desc) + name_size) * num_desc.  That's the memory you
> allocate and the size that you can then pass to a single pread system
> call starting from offset desc_offset.
>
> There is certainly room for improvement in that the length of id[] and
> name[] can be unified to name_size.
>
Thanks for all these ideas, which indeed make it more clear and neat.
Will improve by this and post another version later.
> >>>> +struct kvm_stats_desc {
> >>>> +  __u32 flags;
> >>>> +  __s16 exponent;
> >>>> +  __u16 size;
> >>>> +  __u32 offset;
> >>>> +  __u32 unused;
> >>>> +  char name[];
> >>>> +};
> >>>
> >>> What is the max length of name?
> >>
> >> It's name_size in the header.
> >
> > So it's specified in the _previous_ header?  That feels wrong, shouldn't
> > this descriptor define what is in it?
>
> Compared to e.g. PCI where you can do random-access reads from memory or
> configuration space, reading from a file has slightly different
> tradeoffs.  So designing a file format is slightly different compared to
> designing an in-memory format, or a wire protocol.
>
> Paolo

Jing
