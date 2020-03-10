Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E831804AD
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJRX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:23:56 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:41316 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCJRX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 13:23:56 -0400
Received: by mail-il1-f193.google.com with SMTP id l14so6877723ilj.8
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bpKs3XJUi+EzrxrD69z2rWEMUDijI2aX+JxbzZCOheM=;
        b=jC2v5tmmuEnmUgDs+1o340Pp6muc2ypEpD8eaP6r2cPOyHT0UQ2PlIn/QtNGxkE4+8
         cASs91MnMeo8ZYxW2c5PAIkJ0SDlxhG3iJTSsvPlU5s080/QYJohXagrGCH/GzpvvT98
         WHcXWwupWcsc+f8H82YAAoIrwBgVLBphe07lLJBYJ8HdcmX9XBOxeechO/XaWNXYi8YE
         Aa0OUiQKyYWYwEQds8gPprxAGBjI+WvtYntOAB9plQyYyp/YDkhYYJzjDXUGcvMxQWsD
         cxjeiHchLTmwjy7F8sJse27h8pR8rUkqcBaVeAUD8fgXZC+ckz7ZSMd/nZ5nPvp6jypt
         Kg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bpKs3XJUi+EzrxrD69z2rWEMUDijI2aX+JxbzZCOheM=;
        b=E7pUQDKec87/oInMY4JSiE0Dw/UvCvzmLvXDdDCH5T6t9b6Po6GM708MVLpNg+3I0/
         Cf23Upmdp/aBed/oecpfXIXEfKasQ7nMKdE7KD5suYQY7nisWfIDB7yAmHNu1uz8qr/6
         1vdfMwTmVrNXp6pgzN5BPotXXxYnekcbsVPcpAB0qZd7KYmIX7AWUxUQ7SVlMhEa8AcW
         J1FsKGQ+gxP/D74Ez9avqcFd4hiqnZaM+nHdvQoMEf7rw7hkGTcvIWia4ZlpI7qCaEix
         2ckCUwHRC0PHIencK4/UzrDIoJtrWRy32x9yEC2x6JgAoWqDuoPrtnbPHTLzHrbc6Ubh
         2EDg==
X-Gm-Message-State: ANhLgQ3z6gSlxIHD/ujv1vT/PsPdgzpgM7xhoOqC/352lb0vLB00x33p
        2XbGVVrdh190OPAs+tLprkciSTcoEM//V/x/hcIEtA==
X-Google-Smtp-Source: ADFU+vsdimCS3ju3X6q4TFVr0q8tJXbwYngqSmKvAnDqE7FFDwCj2Y7m2zWw0oFBeuLMLbJXXOmYlKV7766rSe/gNpI=
X-Received: by 2002:a92:3c04:: with SMTP id j4mr12290505ila.108.1583861035356;
 Tue, 10 Mar 2020 10:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-5-sean.j.christopherson@intel.com> <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
 <20200305192532.GN11500@linux.intel.com> <CALMp9eRxdGj0DL0_g-an0YC+gTMcWcSk7=md=k4-8S0Zcankbg@mail.gmail.com>
 <20200305215149.GS11500@linux.intel.com> <5567edf6-a04c-5810-8ed5-78a0db14b202@redhat.com>
 <20200310171017.GC9305@linux.intel.com>
In-Reply-To: <20200310171017.GC9305@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Mar 2020 10:23:44 -0700
Message-ID: <CALMp9eRjOd3=+koxGus=V0CLvz3wg-A1soa9Z4rvXhedQzCHcA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:10 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Mar 06, 2020 at 10:03:37AM +0100, Paolo Bonzini wrote:
> > On 05/03/20 22:51, Sean Christopherson wrote:
> > >> Ah. So cross-vendor CPUID specifications are not supported?
> > > Cross-vendor CPUID is sort of allowed?  E.g. this plays nice with creating
> > > a Centaur CPU on an Intel platform.  My interpretation of GET_SUPPORTED...
> > > is that KVM won't prevent enumerating what you want in CPUID, but it only
> > > promises to correctly support select leafs.
> >
> > But in practice does this change anything?  If the vendor is not Centaur
> > it's unlikely that there is a 0xc0000000 leaf.  The 0x80000000 bound is
> > certainly not going to be at 0xc0000000 or beyond, and likewise to 0xc0000000
> > bound is not going to be at 0xd0000000 or beyond.  So I'm not sure if
> > anything is lost from this simplification:
>
> Probably not?  But in the unlikely scenario that Intel wants to add a CPUID
> leaf above 0xc0000000, I don't want to have to explain that it might cause
> problems for KVM guests because I added code to emulate (alleged) Centaur
> behavior for virtual Intel CPUs.

And there is some precedent for that, with the 0x20000000 leaves.
