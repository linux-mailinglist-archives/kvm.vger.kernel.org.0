Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FF7740C3
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbjHHRKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbjHHRJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:09:30 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B08AA630
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:03:48 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-403a85eb723so45270651cf.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 09:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1691510626; x=1692115426;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wVHMVd+UGwwv1IwoHwspyTOxr+24lKkFzSE6HxNFPxg=;
        b=iom2ly4UKw12D/wDScHsij0fOwygQ8w+Sb4X6vmPKl4eweXZtQLRpRM+BVfsAUdKxi
         T73GojYyAlbRU7kAP8prdxs5EZJ7Emjj6la3ZiAcwuoEacTzhbKaBZDoS+x04MO1PluL
         tpl1mHlsafx3fUtq6gdCOzurc407ZV+4AAAMNPN86oVo69S1xjut+51GBKHkIuojSgCk
         7yBIkb9O6/TX0wklHT6l9AWONmzdaIyGhg+qcWqbPGLlF1aw2sqHTGpRweGICdbSdPyg
         p1csmxuDrU4hOjgBrwGt5BpJeDYC5urBv9WMkzcKgM8i3gLjERcNiXY2jmZDUC/aVu2K
         0MCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691510626; x=1692115426;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wVHMVd+UGwwv1IwoHwspyTOxr+24lKkFzSE6HxNFPxg=;
        b=ajsWEkP00eJ2eH4VTyP4DHzDcZLaVKitWp+UmTAoDAAA1e+VkDsrGxrBOLVKjdLAV/
         v0DiBekZ28ItsAYr4Gc+rbEmW5eDq+7OKnm8N+nDWM8rgWDBsBCv4DAEqSm+TfyYAvEM
         uPWTzONZVFxq0hIugS8wze0JEOn6fQOMHCq8i0knzngufEgi7VmjZwV+fGIfXH+EpFD3
         zaobflhg1v6o3uyjICzth0ziFiDW+ijMIPy/NffvPLUZbZs2xMHNyQD8EwEl847tnfhT
         Bg4DHIKenB1eu9H9mFZ7XPrltm6fpd1C6441g7kG6L1ZcLDgwhBpPEIPTlhxrnUJkmN6
         QTSQ==
X-Gm-Message-State: AOJu0Yyk6tRMZjnFTl+xeS8ao/RvOyfszbo5L0zY60Nn42kOCrt9SahK
        udd6gEFbwDyhhUd8PwINbUbO3Kw+yhzDzjij4vmE0w==
X-Google-Smtp-Source: AGHT+IGV7Oh2ytm8+Qvna1OQK456rf+196h62YyEq/DjjvdcQNWEMSEIT0ycw0yXF1es5dvZSiBYvA==
X-Received: by 2002:a05:6a20:394a:b0:10c:7c72:bdf9 with SMTP id r10-20020a056a20394a00b0010c7c72bdf9mr11951154pzg.29.1691480742019;
        Tue, 08 Aug 2023 00:45:42 -0700 (PDT)
Received: from ake-x260 (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id t7-20020aa79387000000b00687087d3647sm7641915pfe.142.2023.08.08.00.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:45:41 -0700 (PDT)
Date:   Tue, 8 Aug 2023 16:45:32 +0900
From:   Ake Koomsin <ake@igel.co.jp>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC
 access from L2
Message-ID: <20230808164532.09337d49@ake-x260>
In-Reply-To: <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
References: <20230807062611.12596-1-ake@igel.co.jp>
        <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
Organization: igel
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 07 Aug 2023 17:00:58 +0300
Maxim Levitsky <mlevitsk@redhat.com> wrote:
=20
> Is there a good reason why KVM doesn't expose APIC memslot to a
> nested guest? While nested guest runs, the L1's APICv is "inhibited"
> effectively anyway, so writes to this memslot should update APIC
> registers and be picked up by APICv hardware when L1 resumes
> execution.
>=20
> Since APICv alows itself to be inhibited due to other reasons, it
> means that just like AVIC, it should be able to pick up arbitrary
> changes to APIC registers which happened while it was inhibited, just
> like AVIC does.
>=20
> I'll take a look at the code to see if APICv does this (I know AVIC's
> code much better that APICv's)
>=20
> Is there a reproducer for this bug?
>=20
> Best regards,
> 	Maxim Levitsky

=46rom reading old commits (3a2936dedd20 and 1313cc2bd8f6), I interprete that
current KVM implementation does not expect direct APIC access from L2 guest=
s.
I assume that there might be some challenging implementation issues.

To reproduce the problem, we need to run a micro hypervisor named BitVisor =
on
KVM. This hypervisor, when running on real machine, lets its guest access
physical APIC directly. As BitVisor intends to run on real machine, when ru=
nning
under KVM, it conceals all KVM related features reported through CPUID. The=
 L2
guest will initialize and run as if it runs on a physical machine. We also =
need
an Intel machine that support APICv. (I test on Intel 13th machine. The pro=
blem
should also be reproducible on Intel 12th machine). Current BitVisor's SVM
implementations always monitor MMIO access so we cannot reproduce the probl=
em.

BitVisor VMX implementation under UEFI environment by default hooks the APIC
access during initialization. The purpose of this APIC access hook is to
bootstrap AP processors during UEFI ExitBootServices. When booting a guest =
OS,
the firmware sends INIT signal during ExitBootServices. BitVisor then boots=
trap
AP processors, put them to guest mode, and unhook APIC access. After this,
the guest can now access APIC memory directly.

As far as I understand the KVM implemntation, when BitVisor still hooks APIC
access, EPT_VIOLATION occurs when L2 guest accesses APIC page. The EPT_VIOL=
ATION
is then forwarded to BitVisor. BitVisor eventually accesses APIC on behalf =
of
the L2 guest. In this case, APICv works properly because the access is from=
 L1.
After BitVisor unhooks the APIC page, the first access to APIC from the L2 =
guest
goes to EPT_VIOLATION handling path. This handling path marks the APIC page=
 with
a reserved flag, and causes the access to retry eventually. Subsequent acce=
sses
are then handled in EPT_MISCONFIG path, emulating the MMIO access. Interrupt
seems to disappear after this.

Here is the steps to reproduce the problem.

1) hg clone http://hg.code.sf.net/p/bitvisor/code bitvisor-code

2) Enter the cloned directory and type 'make' (No need to worry about warni=
ngs
   at the moment. The default configuration is good enough to reproduce the
   problem). We now have bitvisor.elf after the compilation.

3) Enter boot/uefi-boot, and type 'make' to compile the UEFI bootloader. We
   need mingw for this. We now have loadvmm.efi after the compilation.

4) Put bitvisor.elf and loadvmm.efi to together in a folder. The folder
   is going to look like the following:
   ~/x86_test
   =E2=94=9C=E2=94=80=E2=94=80 bitvisor.elf
   =E2=94=94=E2=94=80=E2=94=80 loadvmm.efi

5) Run the following qemu command. Replace UEFI firmware path and other
   parameters as you prefer. Make sure -smp 2 is there. Otherwise, there wi=
ll be
   no INIT signal during UEFI ExitBootServices. (I use QEMU 8.0.3)

qemu-system-x86_64 -cpu host -enable-kvm -bios /usr/share/edk2-ovmf/OVMF_CO=
DE.fd \
-drive file=3Dfat:rw:~/x86_test/,format=3Draw \
-cdrom ~/Downloads/Fedora-Workstation-Live-x86_64-38-1.6.iso \
-M q35 -m 8192 -smp 2 -serial stdio

6) During the launch, enter the bios config by hitting esc key repeatedly.
   Then, select 'Boot Manager' and choose 'EFI Internel Shell' to enter the
   UEFI shell.

7) The directory we specify in the command should be at fs0. Type 'fs0:' in
   the shell.

8) Type 'loadvmm.efi' to load BitVisor. We should see the following message

Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
ooooooooooooooooooooooooooooooooooooooooooooooooooo
...
MCFG [0] 0000:00-FF (B0000000,10000000)
Starting a virtual machine.

9) We should now return to the shell. Right now we are running as a L2 gues=
t.

10) Next is to boot Linux from the live cd or your prefered method. We can =
see
    the panic related to "panic - not syncing: IO-APIC + timer doesn't work=
!".
    The panic can be reproduced quite easy. Even though, it happens to pass=
 to
    timer check, or you specify 'no_timer_check' boot parameter, it will st=
all
    during SMP bringup.

The idea from step 6 to step 10 is to start BitVisor first, and start Linux=
 on
top of it. You can adjust the step as you like. Feel free to ask me anything
regarding reproducing the problem with BitVisor if the giving steps are not
sufficient.

The problem does not happen when enable_apicv=3DN. Note that SMP bringup wi=
th
enable_apicv=3DN can fail. This is another problem. We don't have to worry =
about
this for now. Linux seems to have no delay between INIT DEASSERT and SIPI d=
uring
its SMP bringup. This can easily makes INIT and SIPI pending together resul=
tling
in signal lost.

I admit that my knowledge on KVM and APICv is very limited. I may misunders=
tand
the problem. If you don't mind, would it be possible for you to guide me wh=
ich
code path should I pay attention to? I would love to learn to find out the
actual cause of the problem.


Best Regards
Ake Koomsin
