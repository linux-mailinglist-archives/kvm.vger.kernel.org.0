Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E54EDFD7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbfKDMRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:17:06 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46333 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfKDMRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:17:06 -0500
Received: by mail-ot1-f65.google.com with SMTP id n23so3928511otr.13;
        Mon, 04 Nov 2019 04:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47JQeuFealI4jSM8NIAlNeCFyhat+1KtTcPGYTc+/B8=;
        b=FPu6E5dGuSRTF6T/chyqu3HS3QEMsl5rfwZPsGs0ptx4/DFVAWuoxW4eupR2kW6pLB
         YzkXisGoHccl2mdW/jxtTSupOn6Xz+LQask4MV4S3TD3xNI27X2Hq1UEatMuGosoPXE8
         rHgxMMVgoP96+VFrD3+hA6OKb2042UKfJtHTcJ3re5M3lPEmsZ12f7RKIPCmqdQ8h4mw
         QDvRZgP5bRoAg0DfUyjxAljiCDCMN0zJWS/Mj3xNjCNHp+c2d6xcfOLFJPuhN5U5RN2D
         0AJMjvEZdCFcuNzb6YjqqqssJUTokMhoHpdp+Svm9U5mWxOcEdC4PqFDnTqky2UrKLSS
         C/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=47JQeuFealI4jSM8NIAlNeCFyhat+1KtTcPGYTc+/B8=;
        b=e6ni6SIsngQd3O4btfQmt0S4W8O2cOIlDbieYzCcfU8yALSUU4UL+oc/zBiV8Tx3Uz
         x0IepCY5APOjzbkBo9Deqetn0Un8JSA2ZgXkzmadEsOr06gUzjWg2yDmeJxBqEUFhcLm
         JCZZWx2a6jG6lvyEUePbN3QYIxSC3dZGF3mpTQ8jfkfX6DID0oOY+TDWoo0C1IGfc+rJ
         Nj7k/s+Adwe6jK5uaGp0Dqa9s18aiFV/KhhUIJdU9n2YHSJwUaOxG3x4F0u+JWesoVKd
         PWxB4yEgW3wZ55t/7zXlVCT+ADLCvkdyLeymMYQAtM7GUW0n6XhKdre4Y72FjLwdrGMf
         MuAw==
X-Gm-Message-State: APjAAAV/96etiBSWJ/BER2AdiIJ9wjnj5pgiMJu9rKc4CkfH1RPTma37
        6dHWN3TkfXExfF52mn3EumjTlPC2AI5eirDTJKI=
X-Google-Smtp-Source: APXvYqy9eyChpvYwt1pJ3TRds008moU69SaOBiaC6RH8bQb1NPio/GjYEzuL+cmwtrnLMDcu8iGwlKWXjA/XvAmUyuY=
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr17403056oto.254.1572869825122;
 Mon, 04 Nov 2019 04:17:05 -0800 (PST)
MIME-Version: 1.0
References: <1572848879-21011-1-git-send-email-wanpengli@tencent.com>
 <1572848879-21011-2-git-send-email-wanpengli@tencent.com> <c32d632b-8fb0-f7c6-4937-07c30769b924@redhat.com>
In-Reply-To: <c32d632b-8fb0-f7c6-4937-07c30769b924@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 4 Nov 2019 20:16:58 +0800
Message-ID: <CANRm+CzkbrbE2C2yFKL1=mQCBCZMfVH8Tue3eXXqTL5Z1VUB5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: Fix rcu splat if vm creation fails
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Nov 2019 at 19:18, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/11/19 07:27, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >    =============================
> >    WARNING: suspicious RCU usage
> >    -----------------------------
> >    ./include/linux/kvm_host.h:536 suspicious rcu_dereference_check() usage!
> >
> >    other info that might help us debug this:
> >
> >    rcu_scheduler_active = 2, debug_locks = 1
> >    no locks held by repro_11/12688.
> >
> >    stack backtrace:
> >    Call Trace:
> >     dump_stack+0x7d/0xc5
> >     lockdep_rcu_suspicious+0x123/0x170
> >     kvm_dev_ioctl+0x9a9/0x1260 [kvm]
> >     do_vfs_ioctl+0x1a1/0xfb0
> >     ksys_ioctl+0x6d/0x80
> >     __x64_sys_ioctl+0x73/0xb0
> >     do_syscall_64+0x108/0xaa0
> >     entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Commit a97b0e773e4 (kvm: call kvm_arch_destroy_vm if vm creation fails)
> > sets users_count to 1 before kvm_arch_init_vm(), however, if kvm_arch_init_vm()
> > fails, we need to dec this count. Or, we can move the sets refcount after
> > kvm_arch_init_vm().
>
> I don't understand this one, hasn't
>
>         WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>
> decreased the conut already?  With your patch the refcount would then
> underflow.

r = kvm_arch_init_vm(kvm, type);
if (r)
    goto out_err_no_arch_destroy_vm;

out_err_no_disable:
    kvm_arch_destroy_vm(kvm);
    WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
out_err_no_arch_destroy_vm:

So, if kvm_arch_init_vm() fails, we will not execute
WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));

    Wanpeng
