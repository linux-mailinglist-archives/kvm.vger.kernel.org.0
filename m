Return-Path: <kvm+bounces-61673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD56C24796
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D06D4F07A3
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB697338939;
	Fri, 31 Oct 2025 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eNtyhP8T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED359339716
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761906834; cv=none; b=QJPtHWHnMtyodjaxykkKmAhOICGED5rZnA947vxdjinPcbvBda4lDDs8+ddY0uwO2X7Z9hYZ6KkK/XQwcypwxVvxJjs1Em9iaiExzWMxfuvdmwX7QAmN90xnXcAl6mC54JTjVV3KqIQec54APXqXOln50v70NyrZSBIqdhDUB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761906834; c=relaxed/simple;
	bh=BhF30OUheZtacHIJ0cUqitMTog8Nlut6DmKOcQxVGgU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=al4mxNEfBJ4Du6lZllmMfDoNoWhNXE2ojE//SNhkFnFYa9kLnLQaf8f12DYSszdEj+cdM5TajFuA2zM8Q72no0XvjcUDGHhg7OBAmksjksbYezWqOvW4jevTyg4DHY7E4AqKn5iP2+OtT6C4Sg2PRbirgo7+hsArF3FyxibI4qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eNtyhP8T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761906831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n/jGLV9GwwmWLPtAFMtsGUdWiI6XWtoKi7BhNW1nFXU=;
	b=eNtyhP8T049fW5usrsNF1tPnnJbC+den9Vgve+1y9cNAyPbJ5ZvFJhLSUsPI7aWqrStEFJ
	AluUFrvw7wttIxIOaFeyCMXerE446GzV1uL+hf7VGQazN4Rpmoqk6UMioG52/Upyw/3t4c
	lu+txWBUY1U3WEGtGLgI43DIMUjX84k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-CBRrpUljNF2YKfX3uwCS9A-1; Fri, 31 Oct 2025 06:33:50 -0400
X-MC-Unique: CBRrpUljNF2YKfX3uwCS9A-1
X-Mimecast-MFC-AGG-ID: CBRrpUljNF2YKfX3uwCS9A_1761906829
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471168953bdso15754355e9.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 03:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761906829; x=1762511629;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/jGLV9GwwmWLPtAFMtsGUdWiI6XWtoKi7BhNW1nFXU=;
        b=JQrSQ0fNCF7+gP+o7enRliwgZsdY2ALcWulMzpnsj72YxJ6zzxsrfOz0VyvErbfZpj
         HuKxe6ydP5YYDWmgp/977ehdJgiQYPqAgMyoKmSDcakKDFEridVHtXLL9YhvmGarZf8r
         /Ksdxe4sXW7tOZGgqkUyPNMUToazS1x18chhssSvc2tAVsjwkHrie8b8VI1Iw4Cb4tEf
         ZwYw3YC240WvW7U1uwBOXtU23GXg3jXt8sHVu+pU08HBEBGBG7dJYGP/OlAmjxgONHSY
         f+KvNxtL8SkgQ8V6YWj6sQm3euibFkiVpcDd5WB1lQOgZ7rhWeyp6LLRHY/GJZZdc/Wc
         euag==
X-Forwarded-Encrypted: i=1; AJvYcCWlQoOUXwwuq1zzS0LZkvHdZNFQM+X+YYUTNh96aL6j6h6lMzuB7NyP5zmzrIULRlVr9CY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmHFzrkTdHNUff8tWEC3uFY52hNjL5uek2HC0/pbZVDpCJtRKu
	VSMpTY3gM96IzJyejnvnnZLLnU/bGwfbzrJfto9+LHqSjXbTBVp+rq48mFsFtBQF4/DrjWjCorg
	/JAob3PWp0uNaxzdnqQJGCQQOw1VQUXmSUIezUT6JyWf27Bahybrs2w==
X-Gm-Gg: ASbGncvR2Hp+UowpLiPUFvtrRMwnzRqO8XIbaAw+vvFaP2QJVGT9LSB1/Ox26OLu2NI
	DfnHVKA8FJ0gAta5tLkOtpcI2RErkdkIQ6LU2KOkLzOhgT4AXBFIDuwIjEcCe0txhAFltEapbIX
	JmrmgLCKLWCCpvOl6debOiKbUBI8W0cpLTtfGTuJuGhWdLr5UnwG28y2rCIXcE9ZEJd5Jla88tm
	xHLV9RIGIizxi8l5XSpSfh20WfPi4znvlQdNX0cA9Vwy2MLnw9Ro8Mn/TNXM7uKxQelSLcjOe/e
	mv1+szuJd9liZInk/8C06SsnXDaF0hKffALPjnSxd26dE4giqzmN/iPGK/zfDWxQWdGjbQjsAkU
	RDQbpdr7ptRY=
X-Received: by 2002:a05:600c:6207:b0:477:bf1:8c82 with SMTP id 5b1f17b1804b1-4773012927cmr30121145e9.15.1761906829108;
        Fri, 31 Oct 2025 03:33:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWCHcilNykTSLc62QxcCapaqI02WJ4rPlCIQNLJ1JMRw/+H68d09txCoHrM7hGWJDTD94b9Q==
X-Received: by 2002:a05:600c:6207:b0:477:bf1:8c82 with SMTP id 5b1f17b1804b1-4773012927cmr30120385e9.15.1761906828559;
        Fri, 31 Oct 2025 03:33:48 -0700 (PDT)
Received: from imammedo-mac ([185.140.112.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c114b93esm2889676f8f.19.2025.10.31.03.33.46
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 31 Oct 2025 03:33:48 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:33:44 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Philippe =?UTF-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Laurent
 Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu
 <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-riscv@nongnu.org, Weiwei Li
 <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, Zhao Liu
 <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>, Helge Deller
 <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha
 <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Jason
 Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <20251031113344.7cb11540@imammedo-mac>
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Organization: imammedo@redhat.com
X-Mailer: Claws Mail 3.11.1-67-g0d58c6-dirty (GTK+ 2.24.21; x86_64-apple-darwin14.0.0)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  8 May 2025 15:35:23 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

Are you planning to resping it?
(if yes, I can provide you with a fixed 2/27 patch that removes all legacy =
cpu hp leftovers)

> Since v3:
> - Addressed Thomas and Zhao review comments
> - Rename fw_cfg_init_mem_[no]dma() helpers
> - Remove unused CPU properties
> - Remove {multi,linux}boot.bin
> - Added R-b tags
>=20
> Since v2:
> - Addressed Mark review comments and added his R-b tags
>=20
> The versioned 'pc' and 'q35' machines up to 2.12 been marked
> as deprecated two releases ago, and are older than 6 years,
> so according to our support policy we can remove them.
>=20
> This series only includes the 2.6 and 2.7 machines removal,
> as it is a big enough number of LoC removed. Rest will
> follow.
>=20
> Based-on: <20250506143905.4961-1-philmd@linaro.org>
>=20
> Philippe Mathieu-Daud=C3=A9 (27):
>   hw/i386/pc: Remove deprecated pc-q35-2.6 and pc-i440fx-2.6 machines
>   hw/i386/pc: Remove PCMachineClass::legacy_cpu_hotplug field
>   hw/nvram/fw_cfg: Rename fw_cfg_init_mem() with '_nodma' suffix
>   hw/mips/loongson3_virt: Prefer using fw_cfg_init_mem_nodma()
>   hw/nvram/fw_cfg: Factor fw_cfg_init_mem_internal() out
>   hw/nvram/fw_cfg: Rename fw_cfg_init_mem_wide() ->
>     fw_cfg_init_mem_dma()
>   hw/i386/x86: Remove X86MachineClass::fwcfg_dma_enabled field
>   hw/i386/pc: Remove multiboot.bin
>   hw/nvram/fw_cfg: Remove fw_cfg_io_properties::dma_enabled
>   hw/i386/pc: Remove linuxboot.bin
>   hw/i386/pc: Remove pc_compat_2_6[] array
>   target/i386/cpu: Remove CPUX86State::enable_cpuid_0xb field
>   target/i386/cpu: Remove CPUX86State::fill_mtrr_mask field
>   hw/intc/apic: Remove APICCommonState::legacy_instance_id field
>   hw/core/machine: Remove hw_compat_2_6[] array
>   hw/virtio/virtio-mmio: Remove
>     VirtIOMMIOProxy::format_transport_address field
>   hw/i386/pc: Remove deprecated pc-q35-2.7 and pc-i440fx-2.7 machines
>   hw/i386/pc: Remove pc_compat_2_7[] array
>   target/i386/cpu: Remove CPUX86State::full_cpuid_auto_level field
>   target/i386/cpu: Remove CPUX86State::enable_l3_cache field
>   hw/audio/pcspk: Remove PCSpkState::migrate field
>   hw/core/machine: Remove hw_compat_2_7[] array
>   hw/i386/intel_iommu: Remove IntelIOMMUState::buggy_eim field
>   hw/intc/ioapic: Remove IOAPICCommonState::version field
>   hw/virtio/virtio-pci: Remove VirtIOPCIProxy::ignore_backend_features
>     field
>   hw/char/virtio-serial: Do not expose the 'emergency-write' property
>   hw/virtio/virtio-pci: Remove VIRTIO_PCI_FLAG_PAGE_PER_VQ definition
>=20
>  hw/intc/ioapic_internal.h           |   3 +-
>  include/hw/acpi/cpu_hotplug.h       |   3 -
>  include/hw/boards.h                 |   6 -
>  include/hw/i386/apic_internal.h     |   1 -
>  include/hw/i386/intel_iommu.h       |   1 -
>  include/hw/i386/pc.h                |   9 --
>  include/hw/i386/x86.h               |   2 -
>  include/hw/nvram/fw_cfg.h           |   9 +-
>  include/hw/virtio/virtio-mmio.h     |   1 -
>  include/hw/virtio/virtio-pci.h      |   2 -
>  include/hw/virtio/virtio-serial.h   |   2 -
>  pc-bios/optionrom/optionrom.h       |   4 -
>  target/i386/cpu.h                   |  15 --
>  hw/acpi/cpu_hotplug.c               | 230 ---------------------------
>  hw/arm/virt.c                       |   2 +-
>  hw/audio/pcspk.c                    |  10 --
>  hw/char/virtio-serial-bus.c         |   9 +-
>  hw/core/machine.c                   |  17 --
>  hw/display/virtio-vga.c             |  10 --
>  hw/hppa/machine.c                   |   2 +-
>  hw/i386/acpi-build.c                |   4 +-
>  hw/i386/fw_cfg.c                    |   5 +-
>  hw/i386/intel_iommu.c               |   5 +-
>  hw/i386/microvm.c                   |   3 -
>  hw/i386/multiboot.c                 |   7 +-
>  hw/i386/pc.c                        |  22 +--
>  hw/i386/pc_piix.c                   |  23 ---
>  hw/i386/pc_q35.c                    |  24 ---
>  hw/i386/x86-common.c                |   6 +-
>  hw/i386/x86.c                       |   2 -
>  hw/intc/apic_common.c               |   5 -
>  hw/intc/ioapic.c                    |  18 +--
>  hw/intc/ioapic_common.c             |   2 +-
>  hw/mips/loongson3_virt.c            |   2 +-
>  hw/nvram/fw_cfg.c                   |  48 +++---
>  hw/riscv/virt.c                     |   4 +-
>  hw/virtio/virtio-mmio.c             |  15 --
>  hw/virtio/virtio-pci.c              |  12 +-
>  target/i386/cpu.c                   | 152 ++++++++----------
>  target/i386/kvm/kvm.c               |  10 +-
>  tests/qtest/test-x86-cpuid-compat.c |  11 --
>  pc-bios/meson.build                 |   2 -
>  pc-bios/multiboot.bin               | Bin 1024 -> 0 bytes
>  pc-bios/optionrom/Makefile          |   2 +-
>  pc-bios/optionrom/linuxboot.S       | 195 -----------------------
>  pc-bios/optionrom/multiboot.S       | 232 ---------------------------
>  pc-bios/optionrom/multiboot_dma.S   | 234 +++++++++++++++++++++++++++-
>  47 files changed, 349 insertions(+), 1034 deletions(-)
>  delete mode 100644 pc-bios/multiboot.bin
>  delete mode 100644 pc-bios/optionrom/linuxboot.S
>  delete mode 100644 pc-bios/optionrom/multiboot.S
>=20


