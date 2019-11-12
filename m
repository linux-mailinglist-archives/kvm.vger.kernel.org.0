Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A035F85F0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 02:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKLBSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 20:18:21 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39005 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfKLBSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 20:18:21 -0500
Received: by mail-ot1-f68.google.com with SMTP id e17so12931848otk.6;
        Mon, 11 Nov 2019 17:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lBuSLniBfxOtbZPc5uBPKwf2C9wf9/68vgFfge/XIw=;
        b=WhQBWrx94wCGYhMrvqnfuqQ37he3o2NG/qpAkS0ZBzKwFCtEdURmWzVXyJVyTJLnXB
         kUbIPnwa67FsXTobd6wvczudo2cOpa+ukmWMeslnh9Eo/QwnalaF3SjYqnnoe5UFoMbQ
         sErB1GxroWw4ZcM8HzQ8dugQdtBKpD61mdo7rAYDhD0okeC0dQxOn2w6nLBkD8C46SMK
         9SjanOPjxmLvivuJh83AjC9RzrwLl8+RngtUYZXS6PSnCb4DY7ePOLv4aAsVlTsC+siQ
         4lBYnBQAj1zyV0PMldgVM4D8ab+YEHQCKHdvB+ZvBV7MZ+9+4ORUciFU9EdSuVQGASHR
         Y63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lBuSLniBfxOtbZPc5uBPKwf2C9wf9/68vgFfge/XIw=;
        b=UV6SednGSkY32eaPd1bwz28YzRUkJ2L//wZPL7im+Bm7SE+qWiX2zlXQyedoEPnX8P
         cymmjavmY2CF5VQ1pLGHtg684qp+CmqWohBVdnM6L2AU8FLirCNJJBfofZSeXy6wr5QR
         9Is7zETUbJTVmiXgGVstglubTpHtoN4lqDNdxEY1HXAlxtMN6qTH824RWCWL5P13gIT1
         nkVwAfqJKgh4rL6DS97GwNa4nc6O9d7RD2fMBlTgnHe8H9TI5oLCWH1IuPWTdH8dRwaS
         tGCxsNKc7kWdF0J9JVC9EUf17w9SfR99kSQ0AGcihrNPT630Y8teuVzzb7xKjOxGWOvk
         IlwA==
X-Gm-Message-State: APjAAAVFbA3ILWAgIXHdlvXMWZYYP+6+aOaxre5+Ry7UJm/h00lfrC//
        wey6Eg1s31hb+88yXTPiJEkRI89wdCgoO5+YB/k=
X-Google-Smtp-Source: APXvYqzs9jLymC/LGhXlFA2x2mI3e+pqq6h3FIftSS7u8rOxKwRI4UGUYb3QWmAyqw1Ka0WTgzXQm87m6FkzHlom0Zk=
X-Received: by 2002:a9d:b83:: with SMTP id 3mr22791896oth.56.1573521500347;
 Mon, 11 Nov 2019 17:18:20 -0800 (PST)
MIME-Version: 1.0
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com> <87mud2sgsz.fsf@vitty.brq.redhat.com>
In-Reply-To: <87mud2sgsz.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 12 Nov 2019 09:18:11 +0800
Message-ID: <CANRm+CyzwArrMokQHBOr1FDYmXS=8z1+hnbKnXAjoFvpBe67HA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Nov 2019 at 21:06, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > +
> >  static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -6615,6 +6645,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >                                 | (1 << VCPU_EXREG_CR3));
> >       vcpu->arch.regs_dirty = 0;
> >
> > +     vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
> > +     vcpu->fast_vmexit = false;
> > +     if (!is_guest_mode(vcpu) &&
> > +             vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> > +             vcpu->fast_vmexit = handle_ipi_fastpath(vcpu);
>
> I have to admit this looks too much to me :-( Yes, I see the benefits of
> taking a shortcut (by actualy penalizing all other MSR writes) but the
> question I have is: where do we stop?

In our iaas environment observation, ICR and TSCDEADLINE are the main
MSR write vmexits.

Before patch:
tscdeadline_immed 3900
tscdeadline 5413

After patch:
tscdeadline_immed 3912
tscdeadline 5427

So the penalize can be tolerated.

>
> Also, this 'shortcut' creates an imbalance in tracing: you don't go down
> to kvm_emulate_wrmsr() so handle_ipi_fastpath() should probably gain a
> tracepoint.

Agreed.

>
> Looking at 'fast_vmexit' name makes me think this is something
> generic. Is this so? Maybe we can create some sort of an infrastructure
> for fast vmexit handling and make it easy to hook things up to it?

Maybe an indirect jump? But I can have a try.

    Wanpeng
