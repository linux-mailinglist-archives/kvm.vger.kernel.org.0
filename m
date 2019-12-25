Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4842812A57B
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 03:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLYCE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 21:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbfLYCE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 21:04:59 -0500
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516E22080D
        for <kvm@vger.kernel.org>; Wed, 25 Dec 2019 02:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577239498;
        bh=BuguSI11fNOvxai3NtGegiK14Ns5/ESx5Q8SFpaFMqw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CLO7ywUTzsyegrBMJ3q6ULQ/6a4ZW6wck5hw5XQVIQBxbSA2Ra1bPOSJJYkv9zvHM
         kszxBq73vBkmd0F8QK2zaereijEVhgQRzj/pSGWc/6CSDdj2kNaJLFEoRctc1jEGRQ
         U4FK8Ar9hZMIPmxZZ6N/Prh5jR8jaMHjoVGVJAmQ=
Received: by mail-wm1-f41.google.com with SMTP id m24so3465451wmc.3
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 18:04:58 -0800 (PST)
X-Gm-Message-State: APjAAAWYlnH7nLxGeIdV3OKcCcMgoHDLjq5w6h1RBU5rod97JzNnL0si
        FCXowqaj6z1cvTgckrscbqFX8FD4qkdDoQHdLBHTaQ==
X-Google-Smtp-Source: APXvYqzyLAMdv/OPYL6BGanONxXB+KbVeLYDEBOfDn6wfw3gr+hZTJlIwv7oquVinsKjN6rXCYtfiKm3rktaDqONx84=
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr6696557wmg.38.1577239496558;
 Tue, 24 Dec 2019 18:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20191220192701.23415-1-john.s.andersen@intel.com> <F82D153A-F083-432B-864C-1CF6A02C19DD@oracle.com>
In-Reply-To: <F82D153A-F083-432B-864C-1CF6A02C19DD@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 24 Dec 2019 18:04:41 -0800
X-Gmail-Original-Message-ID: <CALCETrXpLxdnzQjjJcaEi6B8NwLR7uv2REwcdM5ZXFUQsXgM6Q@mail.gmail.com>
Message-ID: <CALCETrXpLxdnzQjjJcaEi6B8NwLR7uv2REwcdM5ZXFUQsXgM6Q@mail.gmail.com>
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
To:     Liran Alon <liran.alon@oracle.com>
Cc:     John Andersen <john.s.andersen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 23, 2019 at 6:31 AM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 20 Dec 2019, at 21:26, John Andersen <john.s.andersen@intel.com> wro=
te:
> >
> > Paravirtualized Control Register pinning is a strengthened version of
> > existing protections on the Write Protect, Supervisor Mode Execution /
> > Access Protection, and User-Mode Instruction Prevention bits. The
> > existing protections prevent native_write_cr*() functions from writing
> > values which disable those bits. This patchset prevents any guest
> > writes to control registers from disabling pinned bits, not just writes
> > from native_write_cr*(). This stops attackers within the guest from
> > using ROP to disable protection bits.
> >
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__web.archive.org_=
web_20171029060939_http-3A__www.blackbunny.io_linux-2Dkernel-2Dx86-2D64-2Db=
ypass-2Dsmep-2Dkaslr-2Dkptr-5Frestric_&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8P=
Zh8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D=
-H3SsRpu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DTrjU4_UEZIoYjxtoXcjsA8Riu0Q=
Z8eI7a4fH96hSBQc&e=3D
> >
> > The protection is implemented by adding MSRs to KVM which contain the
> > bits that are allowed to be pinned, and the bits which are pinned. The
> > guest or userspace can enable bit pinning by reading MSRs to check
> > which bits are allowed to be pinned, and then writing MSRs to set which
> > bits they want pinned.
> >
> > Other hypervisors such as HyperV have implemented similar protections
> > for Control Registers and MSRs; which security researchers have found
> > effective.
> >
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.abatchy.com_=
2018_01_kernel-2Dexploitation-2D4&d=3DDwIDAg&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv=
7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D-H3Ss=
Rpu0sEBqqn9-OOVimBDXk6TimcJerlu4-ko5Io&s=3DFg3e-BSUebNg44Ocp_y19xIoK0HJEHPW=
2AgM958F3Uc&e=3D
> >
>
> I think it=E2=80=99s important to mention how Hyper-V implements this pro=
tection as it is done in a very different architecture.
>
> Hyper-V implements a set of PV APIs named VSM (Virtual Secure Mode) aimed=
 to allow a guest (partition) to separate itself to multiple security domai=
ns called VTLs (Virtual Trust Level).
> The VSM API expose an interface to higher VTLs to control the execution o=
f lower VTLs. In theory, VSM supports up to 16 VTLs, but Windows VBS (Virtu=
alization Based Security) that is
> the only current technology which utilise VSM, use only 2 VTLs. VTL0 for =
most of OS execution (Normal-Mode) and VTL1 for a secure OS execution (Secu=
re-Mode).
>
> Higher VTL controls execution of lower VTL by the following VSM mechanism=
s:
> 1) Memory Access Protections: Allows higher VTL to restrict memory access=
 to physical pages. Either making them inaccessible or limited to certain p=
ermissions.
> 2) Secure Intercepts: Allows a higher VTL to request hypervisor to interc=
ept certain events in lower VTLs for handling by higher VTL. This includes =
access to system registers (e.g. CRs & MSRs).
>
> VBS use above mentioned mechanisms as follows:
> a) Credentials Guard: Prevents pass-the-hash attacks. Done by encrypting =
credentials using a VTL1 trustlet to encrypt them by an encryption-key stor=
ed in VTL1-only accessible memory.
> b) HVCI (Hypervisor-based Code-Integrity): Prevents execution of unsigned=
 code. Done by marking all EPT entries with NX until signature verified by =
VTL1 service. Once verified, mark EPT entries as RO+X.
> (HVCI also supports enforcing code-signing only on Ring0 code efficiently=
 by utilising Intel MBEC or AMD GMET CPU features. Which allows setting NX-=
bit on EPT entries based on guest CPL).
> c) KDP (Kernel Data Protection): Marks certain pages after initialisation=
 as read-only on VTL0 EPT.
> d) kCFG (Kernel Control-Flow Guard): VTL1 protects bitmap,specifying vali=
d indirect branch targets, by protecting it with read-only on VTL0 EPT.
> e) HyperGuard: VTL1 use =E2=80=9CSecure Intercepts=E2=80=9D mechanism to =
prevent VTL0 from modifying important system registers. Including CR0 & CR4=
 as done by this patch.
>     HyperGuard also implements a mechanism named NPIEP (Non-Privileged In=
struction Execution Prevention) that prevents VTL0 Ring3 executing SIDT/SGD=
T/SLDT/STR to leak Ring0 addresses.
>
> To sum-up, In Hyper-V, the hypervisor expose a relatively thin API to all=
ow guest to partition itself to multiple security domains (enforced by virt=
ualization).
> Using this framework, it=E2=80=99s possible to implement multiple OS-leve=
l protection mechanisms. Only one of them are pinning certain registers to =
specific values as done by this patch.
>
> Therefore, as I also tried to say in recent KVM Forum, I think KVM should=
 consider exposing a VSM-like API to guest to allow various guest OS,
> Including Linux, to implement VBS-like features. To decide on how this AP=
I should look like, we need to have a more broad discussion with Linux
> Security maintainers and KVM maintainers on which security features we wo=
uld like to implement using such API and what should be their architecture.
> Then, we can implement this API in KVM and start to gradually introduce m=
ore security features in Linux which utilise this API.

How about having KVM implement the VSM API directly?
