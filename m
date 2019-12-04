Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4C112CF8
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 14:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfLDNxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 08:53:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27405 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727828AbfLDNxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 08:53:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575467615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1bItY3VlK/R7QUzEfTiED1NR3XB+RxnbiIFivpcdxU=;
        b=GOLhE4d6Gu1iQOYUSkfFdGHTI60BAHAlp6+bSOgr/SCVgLXpJ685AX8WwWcxd6HD2Sm0IY
        9QZp+2XApcjYqnkbMnvkvIiFjnWZXb+BG5Uk6Hy+8qzKWH1ECGnXRL0DnGqrLKAUIfB76T
        gENWQiqobEfccIKL+ep+XRnVq9Fg/K4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-xDj0sPn2POmlY5kab7qRlw-1; Wed, 04 Dec 2019 08:53:34 -0500
Received: by mail-wm1-f70.google.com with SMTP id q21so2211669wmc.7
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 05:53:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JbunT/ja9JU/BRWbWg+UV5NSnnxoVIInWyWve9LRpWM=;
        b=b10fDSNTASC3sD5ikuCh0xpeQQN+SUhZC40W0ggsheRtD1sugIF7qN6xuKtgHQUpOr
         A1+u/ULBYewPz1/KdvC8R1inO4T4988MYRRriWDlFss4Q0yAX3jPnhFlRltFdzaH353l
         HJvO+I5qXcwTBmPztTErSQQ0nEaYGelst+8HCPt/jBvx/aAWfi3k1BrnSJHe26YbgcSo
         tWe5py+F+jfcL+UyYS/xcaF1t8SE0OUURt9E8lYLuofRaSDMvhN4hyYss5XnGDuUQl/w
         mWnyJUEYmlKZdvCcqV3LcTffJlLs3a3XEqgP/NLou0k9r6v3UPyDHdMXcY6AgIjJKg2y
         xPoA==
X-Gm-Message-State: APjAAAVQyTRJiFwf9mlWwnaoa6+4Baa7fZ1eb4y3FmhfegFBxaRKfEAt
        XZskPRc/rk9bXW1YhAcvQOQDGZqkewUjLV5uHCSdTZes2sRn5bMH3fkk9xy8nRj5jCvymzyuqMd
        RxV3GVfqwoyEH
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr39615092wmc.124.1575467612746;
        Wed, 04 Dec 2019 05:53:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZdYYEroqPepi9PWforByvomgCbHr/8nblFYn2wfzsbutFK2puEjUdP9HwGsntldywmwxndQ==
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr39615074wmc.124.1575467612491;
        Wed, 04 Dec 2019 05:53:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id d9sm7771644wrj.10.2019.12.04.05.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 05:53:32 -0800 (PST)
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
To:     Catherine Ho <catherine.hecx@gmail.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
 <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com>
 <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
Date:   Wed, 4 Dec 2019 14:53:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: xDj0sPn2POmlY5kab7qRlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 14:33, Catherine Ho wrote:
> Hi Paolo
> [sorry to resend it, seems to reply it incorrectly]
>=20
> On Wed, 4 Dec 2019 at 19:23, Paolo Bonzini <pbonzini@redhat.com
> <mailto:pbonzini@redhat.com>> wrote:
>=20
>     On 04/12/19 09:50, Catherine Ho wrote:
>     > Commit 20a78b02d315 ("target/i386: add VMX features") unconditional=
ly
>     > add vmx msr entry although older host kernels don't include them.
>     >
>     > But old host kernel + newest qemu will cause a qemu crash as follow=
s:
>     > qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
>     > target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret =3D=3D
>     > cpu->kvm_msr_buf->nmsrs' failed.
>     >
>     > This fixes it by relaxing the condition.
>=20
>     This is intentional.=C2=A0 The VMX MSR entries should not have been a=
dded.
>     What combination of host kernel/QEMU are you using, and what QEMU
>     command line?
>=20
>=20
> Host kernel: 4.15.0 (ubuntu 18.04)
> Qemu: https://gitlab.com/virtio-fs/qemu/tree/virtio-fs-dev
> cmdline: qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 8 \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -m 4G,maxm=
em=3D4G
>=20
> But before 20a78b02d315, the older kernel=C2=A0+ latest qemu can boot gue=
st
> successfully.

Ok, so the problem is that some MSR didn't exist in that version.  Which
one it is?  Can you make it conditional, similar to MSR_IA32_VMX_VMFUNC?

Thanks,

Paolo

