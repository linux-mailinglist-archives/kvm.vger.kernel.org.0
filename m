Return-Path: <kvm+bounces-52274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5FAB039B7
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 852CE7A160C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CB92367AC;
	Mon, 14 Jul 2025 08:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcqrduxP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC3123BCED
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752482633; cv=none; b=F6tYpDVx9YvYW1aR9PAX+C87g8Sots+LMJiVUBRi7umxtc6ailrEkQe0iP32IUawrJYZCsYcm2aU/vwE7/PuZp1U54RoWi2A5xgF9PZ9kQAsp0/QLATOTiljjhHMv9eamtqlMOKMRH6BeBtt43DWwapJpqHie2ZDqHQIVCwZg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752482633; c=relaxed/simple;
	bh=nKikz81r3l+aHUp6DieQEkL62kbMU6I327pUJe6ybZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XdgcUHU6+xLtzvc2IVDP+K+cYHKYaeJ1q0vjd5hjRxrDbA629TzGuPthubTNph1AY23px0NdKep5zgkurTcnuLGscQ7hCkpoiBLiyJ3Gn/j2cr3FerfHtOJfem3o4E+Pcx2d3FsBEqKH3CRf41NgDm1cPxDQBed+iKXer/d63Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcqrduxP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752482629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRhLUFEqvojdLmOsG0Ejy1GkfyZq+eqUAsj94u+Dgrw=;
	b=BcqrduxPNTi1lC/axohIc01lTs6Gx/kBuEkcX3jfQHl8mOdQdoMJOetJ4H3Sg9LylG+agP
	iawp2xMm7qhlXFRVUO7fFsCRMUKhhnDQoLID/DNsd05dSneBi9A52Renj/Sczaa5qI7zbC
	tT9NTwHUCA4AgDGb1EO3mu3gYE+VW0w=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-BSF6oWzTM5-up0IvqwCWfw-1; Mon, 14 Jul 2025 04:43:48 -0400
X-MC-Unique: BSF6oWzTM5-up0IvqwCWfw-1
X-Mimecast-MFC-AGG-ID: BSF6oWzTM5-up0IvqwCWfw_1752482627
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ae70ebad856so153253266b.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 01:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752482627; x=1753087427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GRhLUFEqvojdLmOsG0Ejy1GkfyZq+eqUAsj94u+Dgrw=;
        b=mQX5AERPz4gLQXM5GuMiP4MySsTg3YBN4t4NDub0TtfIgy0vuiUeXFjBq730qwFreO
         +poxb5ei7pLmEz7RoUy3otCV7PCz+zNM4NrmNTJH35+i4ZkljUM/cM9KydnoV1CUXPYX
         Gx8LazcKBSlnaxZyRs/st7T2DE8QPerKR9emWclPox/Xm7C+poErcVN6J9bcptuHmAxh
         cOZFdm24wunj11040p62Gla+xTpg+Dx//fVEYFYCLbcC6KaUB0TJr1R4wDpGmKHbQATm
         bIz8zqoKFTqfIZW8WnZh9Vjx8FMcLZBqhAAccMVAFurCr2QCLSHjLnUay2KT62lo75Ox
         aaIg==
X-Forwarded-Encrypted: i=1; AJvYcCXNZJZDYXsVWwSJmEbhp3L5t6yKbXjvvtzkXKgU9tApabTtlYek5Twf3z24d4Oqc6rx1AM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkqD1tJ+IXj7iusmAH49goakFfscQQQbMpGKNs1+0wLi7T7By3
	nZyMB/wQstVx5yDiRSZUv0q5scr6VDeAMCMH6LH8p5bTk7XEEpDrh4Cewzbvnc144Hya9/R1/7C
	eSlEhD8JdnvQPPIMZ79+JE/NH6eylF1++g/xhRiada2peRprml3bVGonZM3mZBhT8hCjPapWJph
	732refpPfSmzQ7kM2mePhPocCWQqEk
X-Gm-Gg: ASbGnct5b4XMi6J2eunDMKvZnkTb1l6OQ22QQIWn6Dzm729Z3gTK9RzjzoefsV19mEz
	wZ+45UrRKxMfN/u5ojEKexy54fop7byDg81xkbghfVojgIvjMPoKc7e+b9hoOnICM6q39uabPDr
	VthD1wqRLI+UZheyDmaVgYuA==
X-Received: by 2002:a17:906:478d:b0:ae6:d94f:4326 with SMTP id a640c23a62f3a-ae6fcb520ccmr1362644266b.57.1752482627114;
        Mon, 14 Jul 2025 01:43:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyp6tHCDEPwymTJwFNP12fJma5TYDhuC8m6nlnf+pWF04et2UyRfdJXz40rUF9nb6cenSI9JuCqjX2X2ZgfJU=
X-Received: by 2002:a17:906:478d:b0:ae6:d94f:4326 with SMTP id
 a640c23a62f3a-ae6fcb520ccmr1362640466b.57.1752482626639; Mon, 14 Jul 2025
 01:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1752229731.git.pabeni@redhat.com>
In-Reply-To: <cover.1752229731.git.pabeni@redhat.com>
From: Lei Yang <leiyang@redhat.com>
Date: Mon, 14 Jul 2025 16:43:09 +0800
X-Gm-Features: Ac12FXxatr64OrUhmel8luErrVbEIm_iqCQ2G7Fi9UrLidUG2qqfbpb6ijcKDPw
Message-ID: <CAPpAL=y4e=+H2rxHwwgbGvU+x10aTDVZ7ix+2YqVC3e6hd6L7g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/13] virtio: introduce support for GSO over UDP tunnel
To: Paolo Abeni <pabeni@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Dmitry Fleytman <dmitry.fleytman@gmail.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Jason Wang <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri <g.lettieri@iet.unipi.it>, 
	Vincenzo Maffione <v.maffione@gmail.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo

Does the compile of this series of patches require support for a
special kernel environment? I hit a compile issue after applied you
patches:
[1440/2928] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
FAILED: libsystem.a.p/hw_virtio_vhost.c.o
cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
-I../subprojects/dtc/libfdt -Isubprojects/libvduse
-I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
-I/usr/include/pixman-1 -I/usr/include/glib-2.0
-I/usr/lib64/glib-2.0/include -I/usr/include/libmount
-I/usr/include/blkid -I/usr/include/sysprof-6
-I/usr/include/gio-unix-2.0 -I/usr/include/slirp
-fdiagnostics-color=3Dauto -Wall -Winvalid-pch -Werror -std=3Dgnu11 -O0 -g
-fstack-protector-strong -Wempty-body -Wendif-labels
-Wexpansion-to-defined -Wformat-security -Wformat-y2k
-Wignored-qualifiers -Wimplicit-fallthrough=3D2 -Winit-self
-Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
-Wold-style-declaration -Wold-style-definition -Wredundant-decls
-Wshadow=3Dlocal -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
-Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
-Wno-shift-negative-value -isystem
/mnt/tests/distribution/command/qemu/linux-headers -isystem
linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
-iquote /mnt/tests/distribution/command/qemu/include -iquote
/mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
/mnt/tests/distribution/command/qemu/host/include/generic -iquote
/mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
-D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE
-fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=3Dzero
-fzero-call-used-regs=3Dused-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
-DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
-MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
../hw/virtio/vhost.c: In function =E2=80=98vhost_dev_set_features=E2=80=99:
../hw/virtio/vhost.c:38:9: error: =E2=80=98r=E2=80=99 may be used uninitial=
ized
[-Werror=3Dmaybe-uninitialized]
   38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   39 |                      strerror(-retval), -retval); \
      |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
../hw/virtio/vhost.c:1006:9: note: in expansion of macro =E2=80=98VHOST_OPS=
_DEBUG=E2=80=99
 1006 |         VHOST_OPS_DEBUG(r, "extended features without device suppor=
t");
      |         ^~~~~~~~~~~~~~~
../hw/virtio/vhost.c:989:9: note: =E2=80=98r=E2=80=99 was declared here
  989 |     int r;
      |         ^
cc1: all warnings being treated as errors
ninja: build stopped: subcommand failed.
make[1]: *** [Makefile:168: run-ninja] Error 1
make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'
make[1]: Entering directory '/mnt/tests/distribution/command/qemu/build'
[1/1493] Generating subprojects/dtc/version_gen.h with a custom command
[2/1493] Generating qemu-version.h with a custom command (wrapped by
meson to capture output)
[3/1492] Compiling C object libsystem.a.p/hw_virtio_vhost.c.o
FAILED: libsystem.a.p/hw_virtio_vhost.c.o
cc -m64 -Ilibsystem.a.p -I. -I.. -Isubprojects/dtc/libfdt
-I../subprojects/dtc/libfdt -Isubprojects/libvduse
-I../subprojects/libvduse -Iui -Iqapi -Itrace -Iui/shader
-I/usr/include/pixman-1 -I/usr/include/glib-2.0
-I/usr/lib64/glib-2.0/include -I/usr/include/libmount
-I/usr/include/blkid -I/usr/include/sysprof-6
-I/usr/include/gio-unix-2.0 -I/usr/include/slirp
-fdiagnostics-color=3Dauto -Wall -Winvalid-pch -Werror -std=3Dgnu11 -O0 -g
-fstack-protector-strong -Wempty-body -Wendif-labels
-Wexpansion-to-defined -Wformat-security -Wformat-y2k
-Wignored-qualifiers -Wimplicit-fallthrough=3D2 -Winit-self
-Wmissing-format-attribute -Wmissing-prototypes -Wnested-externs
-Wold-style-declaration -Wold-style-definition -Wredundant-decls
-Wshadow=3Dlocal -Wstrict-prototypes -Wtype-limits -Wundef -Wvla
-Wwrite-strings -Wno-missing-include-dirs -Wno-psabi
-Wno-shift-negative-value -isystem
/mnt/tests/distribution/command/qemu/linux-headers -isystem
linux-headers -iquote . -iquote /mnt/tests/distribution/command/qemu
-iquote /mnt/tests/distribution/command/qemu/include -iquote
/mnt/tests/distribution/command/qemu/host/include/x86_64 -iquote
/mnt/tests/distribution/command/qemu/host/include/generic -iquote
/mnt/tests/distribution/command/qemu/tcg/i386 -pthread -mcx16 -msse2
-D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE
-fno-strict-aliasing -fno-common -fwrapv -ftrivial-auto-var-init=3Dzero
-fzero-call-used-regs=3Dused-gpr -fPIE -DWITH_GZFILEOP -DCONFIG_SOFTMMU
-DCOMPILING_SYSTEM_VS_USER -MD -MQ libsystem.a.p/hw_virtio_vhost.c.o
-MF libsystem.a.p/hw_virtio_vhost.c.o.d -o
libsystem.a.p/hw_virtio_vhost.c.o -c ../hw/virtio/vhost.c
../hw/virtio/vhost.c: In function =E2=80=98vhost_dev_set_features=E2=80=99:
../hw/virtio/vhost.c:38:9: error: =E2=80=98r=E2=80=99 may be used uninitial=
ized
[-Werror=3Dmaybe-uninitialized]
   38 |         error_report(fmt ": %s (%d)", ## __VA_ARGS__, \
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   39 |                      strerror(-retval), -retval); \
      |                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~
../hw/virtio/vhost.c:1006:9: note: in expansion of macro =E2=80=98VHOST_OPS=
_DEBUG=E2=80=99
 1006 |         VHOST_OPS_DEBUG(r, "extended features without device suppor=
t");
      |         ^~~~~~~~~~~~~~~
../hw/virtio/vhost.c:989:9: note: =E2=80=98r=E2=80=99 was declared here
  989 |     int r;
      |         ^
cc1: all warnings being treated as errors
ninja: build stopped: subcommand failed.
make[1]: *** [Makefile:168: run-ninja] Error 1
make[1]: Leaving directory '/mnt/tests/distribution/command/qemu/build'

Thanks
Lei

On Fri, Jul 11, 2025 at 9:08=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> Some virtualized deployments use UDP tunnel pervasively and are impacted
> negatively by the lack of GSO support for such kind of traffic in the
> virtual NIC driver.
>
> The virtio_net specification recently introduced support for GSO over
> UDP tunnel, and the kernel side of the implementation has been merged
> into the net-next tree; this series updates the virtio implementation to
> support such a feature.
>
> Currently the qemu virtio support limits the feature space to 64 bits,
> while the virtio specification allows for a larger number of features.
> Specifically the GSO-over-UDP-tunnel-related virtio features use bits
> 65-69; the larger part of this series (patches 3-11) actually deals with
> extending the features space.
>
> The extended features are carried by fixed size uint64_t arrays,
> bringing the current maximum features number to 128.
>
> The patches use some syntactic sugar to try to minimize the otherwise
> very large code churn. Specifically the extended features are boundled
> in an union with 'legacy' features definition, allowing no changes in
> the virtio devices not needing the extended features set.
>
> The actual offload implementation is in patches 12 and 13 and boils down
> to propagating the new offload to the tun devices and the vhost backend.
>
> Finally patch 1 is a small pre-req refactor that ideally could enter the
> tree separately; it's presented here in the same series to help
> reviewers more easily getting the full picture and patch 2 is a needed
> linux headers update.
>
> Tested with basic stream transfer with all the possible permutations of
> host kernel/qemu/guest kernel with/without GSO over UDP tunnel support,
> vs snapshots creation and restore and vs migration.
>
> Sharing again as RFC as the kernel bits have not entered the Linus tree
> yet - but they should on next merge window.
>
> Paolo Abeni (13):
>   net: bundle all offloads in a single struct
>   linux-headers: Update to Linux ~v6.16-rc5 net-next
>   virtio: introduce extended features type
>   virtio: serialize extended features state
>   virtio: add support for negotiating extended features
>   virtio-pci: implement support for extended features
>   vhost: add support for negotiating extended features
>   qmp: update virtio features map to support extended features
>   vhost-backend: implement extended features support
>   vhost-net: implement extended features support
>   virtio-net: implement extended features support
>   net: implement tunnel probing
>   net: implement UDP tunnel features offloading
>
>  hw/net/e1000e_core.c                         |   5 +-
>  hw/net/igb_core.c                            |   5 +-
>  hw/net/vhost_net-stub.c                      |   8 +-
>  hw/net/vhost_net.c                           |  50 +++--
>  hw/net/virtio-net.c                          | 215 +++++++++++++------
>  hw/net/vmxnet3.c                             |  13 +-
>  hw/virtio/vhost-backend.c                    |  62 +++++-
>  hw/virtio/vhost.c                            |  73 ++++++-
>  hw/virtio/virtio-bus.c                       |  11 +-
>  hw/virtio/virtio-hmp-cmds.c                  |   3 +-
>  hw/virtio/virtio-pci.c                       | 101 ++++++++-
>  hw/virtio/virtio-qmp.c                       |  89 +++++---
>  hw/virtio/virtio-qmp.h                       |   3 +-
>  hw/virtio/virtio.c                           | 111 ++++++++--
>  include/hw/virtio/vhost-backend.h            |   6 +
>  include/hw/virtio/vhost.h                    |  36 +++-
>  include/hw/virtio/virtio-features.h          | 124 +++++++++++
>  include/hw/virtio/virtio-net.h               |   2 +-
>  include/hw/virtio/virtio-pci.h               |   6 +-
>  include/hw/virtio/virtio.h                   |  11 +-
>  include/net/net.h                            |  20 +-
>  include/net/vhost_net.h                      |  33 ++-
>  include/standard-headers/linux/ethtool.h     |   4 +-
>  include/standard-headers/linux/vhost_types.h |   5 +
>  include/standard-headers/linux/virtio_net.h  |  33 +++
>  linux-headers/asm-x86/kvm.h                  |   8 +-
>  linux-headers/linux/kvm.h                    |   4 +
>  linux-headers/linux/vhost.h                  |   7 +
>  net/net.c                                    |  17 +-
>  net/netmap.c                                 |   3 +-
>  net/tap-bsd.c                                |   8 +-
>  net/tap-linux.c                              |  38 +++-
>  net/tap-linux.h                              |   9 +
>  net/tap-solaris.c                            |   9 +-
>  net/tap-stub.c                               |   8 +-
>  net/tap.c                                    |  19 +-
>  net/tap_int.h                                |   5 +-
>  qapi/virtio.json                             |   8 +-
>  38 files changed, 945 insertions(+), 227 deletions(-)
>  create mode 100644 include/hw/virtio/virtio-features.h
>
> --
> 2.50.0
>
>


