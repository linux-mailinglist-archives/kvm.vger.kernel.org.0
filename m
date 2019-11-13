Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C89CFAE5A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKMKTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:19:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfKMKTT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 05:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573640357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uRe8wHhBMDDzX3KOxjr8uoW4NYiTvpZK6wCNT5fI1PA=;
        b=dUDcAagzJ3jPjwy2BxNHZKP/frn8XNgWtUItWnJESOysTnGybHly6CwF3Kr9qVYQ+lScPA
        xCj1axiQjiuQQaXuv+cFQfa9vL1R1qrPQZQUBAon/yCJN69SMzCtrbwC6SdKFbtUY3Wvyn
        W0C5jCdM+MLnnFSYzKJkpKy1T6IE0KY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-jGYSXlsZPR-3mGTtxhshNQ-1; Wed, 13 Nov 2019 05:19:16 -0500
Received: by mail-wr1-f69.google.com with SMTP id w9so1309810wrn.9
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 02:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nFtt3jp4ZQIg+EhCBJghRSXJhp/M0r51X+zNE6hZvAI=;
        b=Q0hgk6ADWlD9x61vPuaIIyl01kqtEKAjyqhorK37XXiI8/qYtzUW6PqM5rwC38aFLV
         vf2RKnnVpTXFkuqkDxgpXDVLz+9Y7wlZvvvZjaOlboqc9QiR1SwGfKDQ8kwNe3483+rp
         FCGC2uSFkXoqssfI7u9eFm+tRZMVJ/4XfrmzJxT7+2Yru2nS6euiq/Uizvc/ADaA7gdh
         GP4XxhQqA98FMvSaGBH0yKjMSAkF/eyhI2Oyg8r2DtpTKoshGcR6uMDFDCmRQV1AG4bL
         KyjecrSsXS9ElN/ihgsbdWlZVQ0x0ioS6ax7wyeEjeQZVgTaTd+lkrjLzXd/yVkAxM1U
         0TUQ==
X-Gm-Message-State: APjAAAVxa1EedXIM95mX2v4RY2Sk2Q5KBgofMtFtCjTQ/bCSI8/RunzZ
        OkrHBbb6dqiTgeT9MhydY6rkI/iCkRcCRMjfsKR+b6wmHJKV45xbzc2euSdpq89X9OA0B15tvLG
        di+WiS615IIO8
X-Received: by 2002:a7b:c858:: with SMTP id c24mr2100232wml.174.1573640354818;
        Wed, 13 Nov 2019 02:19:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6fQSIlxkg6xPhhV4JBJ3SgC16/A6995o7JCp9t/K8ye8WH2oJvVq79EarLmmk55OAtUMMGg==
X-Received: by 2002:a7b:c858:: with SMTP id c24mr2100202wml.174.1573640354460;
        Wed, 13 Nov 2019 02:19:14 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s17sm1620809wmh.41.2019.11.13.02.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 02:19:13 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Roman Kagan <rkagan@virtuozzo.com>
Cc:     "lantianyu1986\@gmail.com" <lantianyu1986@gmail.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rth\@twiddle.net" <rth@twiddle.net>,
        "ehabkost\@redhat.com" <ehabkost@redhat.com>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "qemu-devel\@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V4] target/i386/kvm: Add Hyper-V direct tlb flush support
In-Reply-To: <20191113094716.GA57998@rkaganb.sw.ru>
References: <20191112033427.7204-1-Tianyu.Lan@microsoft.com> <20191112144943.GD2397@rkaganb.sw.ru> <87eeycktur.fsf@vitty.brq.redhat.com> <20191113094716.GA57998@rkaganb.sw.ru>
Date:   Wed, 13 Nov 2019 11:19:13 +0100
Message-ID: <87bltgkrj2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: jGYSXlsZPR-3mGTtxhshNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman Kagan <rkagan@virtuozzo.com> writes:

> On Wed, Nov 13, 2019 at 10:29:00AM +0100, Vitaly Kuznetsov wrote:
>> Roman Kagan <rkagan@virtuozzo.com> writes:
>> > On Tue, Nov 12, 2019 at 11:34:27AM +0800, lantianyu1986@gmail.com wrot=
e:
>> >> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> >>=20
>> >> Hyper-V direct tlb flush targets KVM on Hyper-V guest.
>> >> Enable direct TLB flush for its guests meaning that TLB
>> >> flush hypercalls are handled by Level 0 hypervisor (Hyper-V)
>> >> bypassing KVM in Level 1. Due to the different ABI for hypercall
>> >> parameters between Hyper-V and KVM, KVM capabilities should be
>> >> hidden when enable Hyper-V direct tlb flush otherwise KVM
>> >> hypercalls may be intercepted by Hyper-V. Add new parameter
>> >> "hv-direct-tlbflush". Check expose_kvm and Hyper-V tlb flush
>> >> capability status before enabling the feature.
>> >>=20
>> >> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> >> ---
>> >> Change since v3:
>> >>        - Fix logic of Hyper-V passthrough mode with direct
>> >>        tlb flush.
>> >>=20
>> >> Change sicne v2:
>> >>        - Update new feature description and name.
>> >>        - Change failure print log.
>> >>=20
>> >> Change since v1:
>> >>        - Add direct tlb flush's Hyper-V property and use
>> >>        hv_cpuid_check_and_set() to check the dependency of tlbflush
>> >>        feature.
>> >>        - Make new feature work with Hyper-V passthrough mode.
>> >> ---
>> >>  docs/hyperv.txt   | 10 ++++++++++
>> >>  target/i386/cpu.c |  2 ++
>> >>  target/i386/cpu.h |  1 +
>> >>  target/i386/kvm.c | 24 ++++++++++++++++++++++++
>> >>  4 files changed, 37 insertions(+)
>> >>=20
>> >> diff --git a/docs/hyperv.txt b/docs/hyperv.txt
>> >> index 8fdf25c829..140a5c7e44 100644
>> >> --- a/docs/hyperv.txt
>> >> +++ b/docs/hyperv.txt
>> >> @@ -184,6 +184,16 @@ enabled.
>> >> =20
>> >>  Requires: hv-vpindex, hv-synic, hv-time, hv-stimer
>> >> =20
>> >> +3.18. hv-direct-tlbflush
>> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> >> +Enable direct TLB flush for KVM when it is running as a nested
>> >> +hypervisor on top Hyper-V. When enabled, TLB flush hypercalls from L=
2
>> >> +guests are being passed through to L0 (Hyper-V) for handling. Due to=
 ABI
>> >> +differences between Hyper-V and KVM hypercalls, L2 guests will not b=
e
>> >> +able to issue KVM hypercalls (as those could be mishanled by L0
>> >> +Hyper-V), this requires KVM hypervisor signature to be hidden.
>> >
>> > On a second thought, I wonder if this is the only conflict we have.
>> >
>> > In KVM, kvm_emulate_hypercall, when sees Hyper-V hypercalls enabled,
>> > just calls kvm_hv_hypercall and returns.  I.e. once the userspace
>> > enables Hyper-V hypercalls (which QEMU does when any of hv_* flags is
>> > given), KVM treats *all* hypercalls as Hyper-V ones and handles *no* K=
VM
>> > hypercalls.
>>=20
>> Yes, but only after guest enables Hyper-V hypercalls by writing to
>> HV_X64_MSR_HYPERCALL. E.g. if you run a Linux guest and add a couple
>> hv_* flags on the QEMU command line the guest will still be able to use
>> KVM hypercalls normally becase Linux won't enable Hyper-V hypercall
>> page.
>
> Ah, you're right.  There's no conflict indeed, the guest makes
> deliberate choice which hypercall ABI to use.
>
> Then QEMU (or KVM on its own?) should only activate this flag in evmcs
> if it sees that the guest has enabled Hyper-V hypercalls.

That was my suggestion as well when KVM patches were submitted, but if I
remember correctly Tianyu said that if we don't enable 'direct tlb
flush' flag in eVMCS on first VMLAUNCH, underlying Hyper-V won't give us
a second chance so we can't enadle it after guest writes to
HV_X64_MSR_HYPERCALL. This is a very unfortunate design/implementation.

--=20
Vitaly

