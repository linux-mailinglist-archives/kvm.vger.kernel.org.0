Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECA332D84
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCIRpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCIRpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 12:45:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF38C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 09:45:09 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id fu20so1263126pjb.2
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 09:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ddj7nKUPn1pV75cOckX3PbYPAps+K18BC++0gJune7Q=;
        b=sDmP48uYySkZp9vu5Jw6w6ZIZGiKV/YFHodszvUxJCgglWE+SCQM6TAOyY/FYoIQ5N
         igYMNFcHvfwXJklSRt95bQ9/wiNO+5ZdIxG3VdJt2wrhuEZp4ZxSFZwv1c/fPDwxBD1l
         xGWyx8v+H3/+AEsACUN22qZVdBF9e4ByA2S8jm0SgM6/zCcMb4lZ5FhxQmLya7Lv3tXC
         HcMefG/bbqj2JLYQY6mkrlt+6ncngDTojyHBy3cWAZz5HmPm/0SiJo1ifqGhXYVJYYC1
         YGwRFx1Msn8MqWhEmrw2WuCHtnnUaCgEc46WWWEsSgfAqfGb0/mmgvPRhh8VGM8qCWkg
         46BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ddj7nKUPn1pV75cOckX3PbYPAps+K18BC++0gJune7Q=;
        b=iy2LYie97vQ855PPl+FDoHRFIFM1hipx0uDUPQQLn8ZRk6nb1t1bfku/A04L3MVkXX
         PwK3FJ1tT959Lasswyh6tRSxaIiML+qOZ/K2wr6Ydrx+4FL1kt2VinBQ+coH1IPSZ6I3
         +IBwMvs39IBUkE9NI4hC06c84LmY6g++vyl+mnisE3+YjuxZmKedUYspyMT6kLbcnoll
         r3NEpKHXIxrzEnmIK0YmWB1bLzUb2PSS/j+MjomrUEr6CzOHC7Lv6E8rUGNfWvarXXWg
         qvV57SK8Z9TiXdV5M+eS58jwDDXb8HZyAw7gHbe4SQWBV99L4v3jKMMj0L8cE4JfDRQV
         4QwA==
X-Gm-Message-State: AOAM532H8VhFK6lZ69cChjAmb3csAZxe6qxP5PN2Qm9IblcCJ04mQm6o
        jTyio9alvu6F2vx1oIAqOpPhgA==
X-Google-Smtp-Source: ABdhPJzVGq3iCKaEQHLBSlEDjud8CI9SNe6E5b0RoZcqe3V2TX4I2nl5Cfw+7cJ7JQ4vTLYzijOPJQ==
X-Received: by 2002:a17:90a:7847:: with SMTP id y7mr5985611pjl.65.1615311908475;
        Tue, 09 Mar 2021 09:45:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id y16sm6083205pgl.58.2021.03.09.09.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 09:45:07 -0800 (PST)
Date:   Tue, 9 Mar 2021 09:45:01 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <YEe0HWlwXyNvu9ps@google.com>
References: <20210224085915.28751-1-natet@google.com>
 <CABayD+cZ1nRwuFWKHGh5a2sVXG5AEB_AyTGqZs_xVQLoWwmaSA@mail.gmail.com>
 <9eb0b655-48ca-94d0-0588-2a4f3e5b3651@amd.com>
 <CABayD+efSV0m95+a=WT+Lvq_zZhxw2Q3Xu4zErzuyuRxMNUHfw@mail.gmail.com>
 <20210305223647.GA2289@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305223647.GA2289@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021, Ashish Kalra wrote:
> On Thu, Feb 25, 2021 at 10:49:00AM -0800, Steve Rutherford wrote:
> > On Thu, Feb 25, 2021 at 6:57 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > > >> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> > > >> +{
> > > >> +       struct file *mirror_kvm_file;
> > > >> +       struct kvm *mirror_kvm;
> > > >> +       struct kvm_sev_info *mirror_kvm_sev;
> > > >> +       unsigned int asid;
> > > >> +       int ret;
> > > >> +
> > > >> +       if (!sev_guest(kvm))
> > > >> +               return -ENOTTY;
> > > >
> > > > You definitely don't want this: this is the function that turns the vm
> > > > into an SEV guest (marks SEV as active).
> > >
> > > The sev_guest() function does not set sev->active, it only checks it. The
> > > sev_guest_init() function is where sev->active is set.
> > Sorry, bad use of the english on my part: the "this" was referring to
> > svm_vm_copy_asid_to. Right now, you could only pass this sev_guest
> > check if you had already called sev_guest_init, which seems incorrect.
> > >
> > > >
> > > > (Not an issue with this patch, but a broader issue) I believe
> > > > sev_guest lacks the necessary acquire/release barriers on sev->active,
> > >
> > > The svm_mem_enc_op() takes the kvm lock and that is the only way into the
> > > sev_guest_init() function where sev->active is set.
> > There are a few places that check sev->active which don't have the kvm
> > lock, which is not problematic if we add in a few compiler barriers
> > (ala irqchip_split et al).

Eh, I don't see the point in taking on the complexity of barriers.  Ignoring the
vCPU behavior, the only existing call that isn't safe is svm_register_enc_region().
Fixing that is trivial and easy to understand.

As for the vCPU stuff, adding barriers will not make them safe.  E.g. a barrier
won't magically make init_vmcb() go back in time and set SVM_NESTED_CTL_SEV_ENABLE
if SEV is enabled after vCPUs are created.

> Probably, sev->active accesses can be made safe using READ_ONCE() &
> WRITE_ONCE().
