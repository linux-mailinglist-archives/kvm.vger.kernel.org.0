Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4448CEC934
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 20:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfKATnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 15:43:07 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:39626 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfKATnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 15:43:07 -0400
Received: by mail-il1-f196.google.com with SMTP id f201so3971116ilh.6
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 12:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBU5ywzGh6TtInbH1iFPI2M+KK4ROc/yEe/OrFQ65rA=;
        b=G5s2o+qE2yN4oKhlwwkVbARlGZto28NOBDCB/4Bf27tnuwQVZuD4+GLXOvlQVXRwh8
         j2sFShbZxuqJMXNHrylwRfk2Q6IQn0xQdmAPot0eqigrBsuRil45800MGX1uWt5k3pAN
         Mmmw2qr68e1SucxTswYSKojebkZ7VWTrDTSH7P9MAc004URnggyAth3AX84S2UusktA2
         lhFJCwMUjV3/guf3shRTwmovJnapC5wyoGctgzU0DbWRpQRe5Cy3U7wczZd5myfeQ8TZ
         1R+qufv4eJ7LKxy7h8xO5jaAbLMw2JYV4YpvfTbjWhwszktbba1KnD5PR84FdmiU8qnE
         O21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBU5ywzGh6TtInbH1iFPI2M+KK4ROc/yEe/OrFQ65rA=;
        b=dAhpf8SsiLSZkb4l0ojmc3QEYMkKKnolc2itCoYCXY3AU8MiFeYVvw3itZPZicHfn4
         +vNp02aDjmTgJaZgIo4OT555BbuNiYoUPU0cjuWTLHq8Gr26N/fBMW6eZcQoFIZWhM4G
         9EYBtbS+AlXmdeKyYOT4ow7xivNB91CraFjRT5V7KYEVjG2K88Yyyis73Tq0VuXCHdMv
         gC/puYxRR35EC3+BfHT8PMpGsfcvMUxHzvcYbUUJIh1/tun9Ob4X19ARygZ71ieFvlP1
         +MQnsu0mp8pD3HmTRjlgpZa4OKAgQa4NEAgEj8bkbjoVZb7AS192aPHXQybc2kOMfZr6
         cd6w==
X-Gm-Message-State: APjAAAVjT6T7mbhTyuTryJTiUKiDK/CzoszEjiibfjd3AEEFZ5TpBi9M
        XZxZG6hh9+cLOW0Td5pfOYx+hXw/8tYGSt7wqgQrpA==
X-Google-Smtp-Source: APXvYqxtCbVFAjBmVS7420DGm4ZfM8mRqAwCba4a2fXHBkGq9oZ1n0yenuJmxYB5FHp8FhIHgJdTcLkCLnXe8tEjTx0=
X-Received: by 2002:a92:de49:: with SMTP id e9mr11293064ilr.108.1572637386283;
 Fri, 01 Nov 2019 12:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com>
 <157262961597.2838.16953618909905259198.stgit@naples-babu.amd.com>
 <CALMp9eTb8N-WxgQ_J5_siU=8=DGNUjM=UZCN5YkAQoofZHx1hA@mail.gmail.com> <a5466e76-3a7b-2de7-ceb9-3d41bf5e4f4d@amd.com>
In-Reply-To: <a5466e76-3a7b-2de7-ceb9-3d41bf5e4f4d@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Nov 2019 12:42:55 -0700
Message-ID: <CALMp9eSnB+=0MYBkkyAfw1WK+ZmYFqpd7EDToFRmnbE+g3MEvQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: x86: Dont set UMIP feature bit unconditionally
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 12:39 PM Moger, Babu <Babu.Moger@amd.com> wrote:
>
>
>
> On 11/1/19 1:35 PM, Jim Mattson wrote:
> > On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
> >>
> >> The UMIP (User-Mode Instruction Prevention) feature bit should be
> >> set if the emulation (kvm_x86_ops->umip_emulated) is supported
> >> which is done already.
> >>
> >> Remove the unconditional setting of this bit.
> >>
> >> Fixes: ae3e61e1c28338d0 ("KVM: x86: add support for UMIP")
> >>
> >> Signed-off-by: Babu Moger <babu.moger@amd.com>
> >> ---
> >>  arch/x86/kvm/cpuid.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >> index f68c0c753c38..5b81ba5ad428 100644
> >> --- a/arch/x86/kvm/cpuid.c
> >> +++ b/arch/x86/kvm/cpuid.c
> >> @@ -364,7 +364,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> >>         /* cpuid 7.0.ecx*/
> >>         const u32 kvm_cpuid_7_0_ecx_x86_features =
> >>                 F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> >> -               F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> >> +               F(AVX512_VPOPCNTDQ) | F(AVX512_VBMI2) | F(GFNI) |
> >>                 F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> >>                 F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/;
> >>
> >
> > This isn't unconditional. This is masked by the features on the boot
> > CPU. Since UMIP can be virtualized (without emulation) on CPUs that
> > support UMIP, you should leave this alone.
> >
>
> There is some inconstancy here.
>
> static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32
>
> unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
> ...
>
> case 7: {
>              ..
>             entry->ecx |= f_umip;
>             ..
>         }
>
> and
> static bool svm_umip_emulated(void)
> {
>         return false;
> }
>
> static inline bool vmx_umip_emulated(void)
> {
>         return vmcs_config.cpu_based_2nd_exec_ctrl &
>                 SECONDARY_EXEC_DESC;
> }
>
>
> It appears that intention was to enable the UMIP if SVM or VMX support
> umip emulation. But that is not how it is working now. Now it is enabled
> if boot CPU supports UMIP.

No. The code enumerates UMIP in the guest if *either* it can be
virtualized (i.e. the host supports it natively), *or* it can be
emulated.
