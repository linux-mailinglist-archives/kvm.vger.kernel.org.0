Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E694C483F
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiBYPEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiBYPED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED56A1BCC;
        Fri, 25 Feb 2022 07:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A77B616BB;
        Fri, 25 Feb 2022 15:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834FAC340F2;
        Fri, 25 Feb 2022 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645801407;
        bh=8tgY1YkBbYTWTXyYR4O+XbrJwoQVpT2+sYNnsPtqvH0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dw9ap3JVLMMql71K82hI4mKsP/7YHWQoyfv72bwQlBiAVWxaiwD1wRw3F+VZXEvvx
         WQ875mGxuzYNn9YOGvOVhfM48/vJmXWbVWzJawe9/qtylmFhRFKzi/WIlticaLs2cM
         AIsKthZYoQsa2oyxoCpZ4YjBqEKyMb9wcdQRk1xHNA53poMUthPP4xAVhwDjyRsWdQ
         zUiWsfTNGn4gtWhCXAbO3yoH2GxxQrng0fLO7xpjNZyfrFAeZaNLFEQf/aFqJSVq2Q
         N6ip6YngC/8NKzFuprepndLFjNKU7KXIMlZ5Hj7GkAhONkklJjut0MRGVV52yDZV2+
         8foGTd4vToHxA==
Received: by mail-yb1-f174.google.com with SMTP id u12so6407758ybd.7;
        Fri, 25 Feb 2022 07:03:27 -0800 (PST)
X-Gm-Message-State: AOAM530jsifmsMEcJ7uw9GREOKQVuqa2wLuI207ootGjVhCeORZfI0gd
        +wmjmkHFPO7FwOWj4G1hBsH5vdRMgBuesU1Oz9o=
X-Google-Smtp-Source: ABdhPJwozR+tvIwdArnwynmJXvOgvPU8UZYk0FrDkdJKmQOdPasCTGp0ANalFhRoBVSWGK5vHEFvk0JS4lVatY3R8aA=
X-Received: by 2002:a25:24ce:0:b0:61e:1276:bfcf with SMTP id
 k197-20020a2524ce000000b0061e1276bfcfmr7488253ybk.299.1645801406586; Fri, 25
 Feb 2022 07:03:26 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com> <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
In-Reply-To: <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 16:03:15 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGbP+NGjqLndPS7EO_sazyoN7ot5siCR5hPTJfNYU2SaQ@mail.gmail.com>
Message-ID: <CAMj1kXGbP+NGjqLndPS7EO_sazyoN7ot5siCR5hPTJfNYU2SaQ@mail.gmail.com>
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     Alexander Graf <graf@amazon.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, ben@skyportsystems.com,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jann Horn <jannh@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 at 14:58, Alexander Graf <graf@amazon.com> wrote:
>
>
> On 25.02.22 13:48, Jason A. Donenfeld wrote:
> >
> > VM Generation ID is a feature from Microsoft, described at
> > <https://go.microsoft.com/fwlink/?LinkId=3D260709>, and supported by
> > Hyper-V and QEMU. Its usage is described in Microsoft's RNG whitepaper,
> > <https://aka.ms/win10rng>, as:
> >
> >      If the OS is running in a VM, there is a problem that most
> >      hypervisors can snapshot the state of the machine and later rewind
> >      the VM state to the saved state. This results in the machine runni=
ng
> >      a second time with the exact same RNG state, which leads to seriou=
s
> >      security problems.  To reduce the window of vulnerability, Windows
> >      10 on a Hyper-V VM will detect when the VM state is reset, retriev=
e
> >      a unique (not random) value from the hypervisor, and reseed the ro=
ot
> >      RNG with that unique value.  This does not eliminate the
> >      vulnerability, but it greatly reduces the time during which the RN=
G
> >      system will produce the same outputs as it did during a previous
> >      instantiation of the same VM state.
> >
> > Linux has the same issue, and given that vmgenid is supported already b=
y
> > multiple hypervisors, we can implement more or less the same solution.
> > So this commit wires up the vmgenid ACPI notification to the RNG's newl=
y
> > added add_vmfork_randomness() function.
> >
> > It can be used from qemu via the `-device vmgenid,guid=3Dauto` paramete=
r.
> > After setting that, use `savevm` in the monitor to save the VM state,
> > then quit QEMU, start it again, and use `loadvm`. That will trigger thi=
s
> > driver's notify function, which hands the new UUID to the RNG. This is
> > described in <https://git.qemu.org/?p=3Dqemu.git;a=3Dblob;f=3Ddocs/spec=
s/vmgenid.txt>.
> > And there are hooks for this in libvirt as well, described in
> > <https://libvirt.org/formatdomain.html#general-metadata>.
> >
> > Note, however, that the treatment of this as a UUID is considered to be
> > an accidental QEMU nuance, per
> > <https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-=
id-across-hypervisors.txt>,
> > so this driver simply treats these bytes as an opaque 128-bit binary
> > blob, as per the spec. This doesn't really make a difference anyway,
> > considering that's how it ends up when handed to the RNG in the end.
> >
> > Cc: Adrian Catangiu <adrian@parity.io>
> > Cc: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Cc: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Reviewed-by: Laszlo Ersek <lersek@redhat.com>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
...
> > +
> > +       device->driver_data =3D state;
> > +
> > +out:
> > +       ACPI_FREE(parsed.pointer);
> > +       return ret;
> > +}
> > +
> > +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> > +{
> > +       struct vmgenid_state *state =3D acpi_driver_data(device);
> > +       u8 old_id[VMGENID_SIZE];
> > +
> > +       memcpy(old_id, state->this_id, sizeof(old_id));
> > +       memcpy(state->this_id, state->next_id, sizeof(state->this_id));
> > +       if (!memcmp(old_id, state->this_id, sizeof(old_id)))
> > +               return;
> > +       add_vmfork_randomness(state->this_id, sizeof(state->this_id));
> > +}
> > +
> > +static const struct acpi_device_id vmgenid_ids[] =3D {
> > +       { "VMGENID", 0 },
> > +       { "QEMUVGID", 0 },
>
>
> According to the VMGenID spec[1], you can only rely on _CID and _DDN for
> matching. They both contain "VM_Gen_Counter". The list above contains
> _HID values which are not an official identifier for the VMGenID device.
>
> IIRC the ACPI device match logic does match _CID in addition to _HID.
> However, it is limited to 8 characters. Let me paste an experimental
> hack I did back then to do the _CID matching instead.
>
> [1]
> https://download.microsoft.com/download/3/1/C/31CFC307-98CA-4CA5-914C-D97=
72691E214/VirtualMachineGenerationID.docx
>

I think matching on the HIDs of two known existing implementations is
fine, as opposed to matching on the (broken) CID of any implementation
that claims to be compatible with it. And dumping random strings into
the _CID property doesn't mesh well with the ACPI spec either, which
is why we don't currently support it.

We could still check _DDN if we wanted to, but I don't think this is
necessary. Other implementations that want to target his driver
explicitly can always put VMGENID or QEMUVGID into the _CID.
