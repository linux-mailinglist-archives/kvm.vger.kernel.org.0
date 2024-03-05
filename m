Return-Path: <kvm+bounces-10983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A36B0872086
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2BADAB2824A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15B685C70;
	Tue,  5 Mar 2024 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nyYYkv5T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0B5915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646148; cv=none; b=RCZrehV8Rr7+a4r319rTTILWCZ4aQwJtWcq1VLJoRsq6sFTc2/f2Iw00lgH5KPkeFoVF360oSAhd9/bqH1IEg8QBT2QrTdvR1ea4ooMTRoYFtmbPG74J/WOZc9f0IXX9meK3DyF9xkAroB6g8rz6fXEIffBgDEBR4IG6MegrGRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646148; c=relaxed/simple;
	bh=eHLhfDgOogjVHUo6amSlxecKkQJfo5wNJOFQOnEC/fw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XCCpCVYOZbHZU5qcdWYLi9cp4FTEqUXcVSwuZXHuhWXsK2P6vmygnqE2j/FrZujaZQJwCuAzDjHAxamZXK73P0ojhHeAOf1iBPh9elwqmH624i0xHm485s1xo9QrOovml62lpUVwHdjX13utQ+Bo4jNNoTNB3G14Mm3yoQ5Vl+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nyYYkv5T; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5645960cd56so857690a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646145; x=1710250945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oq7s+3d2WZzPSy9BYq/6Wk1gHRe7Pd/DU9HZZvyDy9s=;
        b=nyYYkv5TS1e5ygAil5371xPje/1KpEr0TlaIHHlBc9JZK+LHLjPAVr0V5L3PKZmp+k
         +JSD5R5YMsdue3l2tvituBzlLVs3j7b0m70ZYguad2EUaq4SRFkU5ML3LNf++WO3HgJG
         HhCDMoO5gW92aFRT5kuNVVktDmKedOb4Wqe9jr+MNTbWgvKeMKuh9o5AmLhiG33Be18w
         505HZitH9215VGlTnra7/q5Ylu5z9UrcVbZclJvRDURW28zZWU6cK2wlaNXS2GLZ6rvM
         Ms4pszpP4YiUkr2YlP/vlXrnFM36ARj2QBkg72d6oKxadhpQoUxGxCRePPqFLCe78EEZ
         t1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646145; x=1710250945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oq7s+3d2WZzPSy9BYq/6Wk1gHRe7Pd/DU9HZZvyDy9s=;
        b=e65iKM3QIaj5Wf+UMG7QMW372uMTWkOR8kpo1CL6M7kw+Hu6xzeSWGXNSDsHsfGk6n
         X7Bp5wK0J8u488iLFTpF0MSjltVF7obmWc1gVQjwQ2CwKJlaxfGVi0Rv2JHgwPRLRZGP
         wwF1t5AfbQ9nhO9+h2ipS7AiN1sci8zn0735aYdOCprgSqK7v/A+j8434ou5T3Cil/br
         7VBgpIbzbZm/b15mN70QafQlKcLYDNBAiKipYwGravYzjbbIzc16Nq+o9JRb7iVb7tea
         xO/o++gPEhr63Z4jnTfCNN1l19+bVeXjonEu4O4UnPbkQ93IUl9X7SgcsWXci3deNY5h
         21Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWLlgqhbr2ktkj9lpg99xfDJ7ZxyWfGvbS7kLWSKKy6J3q2iC5BxB69oy7Ye/pWs5bKgIMUfFz1yUYMtHZ62UZq+ZbY
X-Gm-Message-State: AOJu0Yx3sM0CI/VEFeGYooMsbTCg+d6nDaQKW6yOeVAu5rtiSsifw+bI
	N56q4t3RqeTpfoOnsSsqBZWR16fXETwZt9AvDG6dHWkWyH6ba+f3Ly3JqvdeME8=
X-Google-Smtp-Source: AGHT+IEe1H1poGp10OUoKEEQQFEBCbwYqRiDyQFYhfp+3jBcvYgWoJD/I5kDi6kDS6rgjGn/iJZtJg==
X-Received: by 2002:a50:d482:0:b0:566:4797:c330 with SMTP id s2-20020a50d482000000b005664797c330mr8941912edi.21.1709646145496;
        Tue, 05 Mar 2024 05:42:25 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id g13-20020a056402428d00b0056793ab2ad8sm549529edc.94.2024.03.05.05.42.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:25 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.1 00/18] hw/i386: Remove deprecated pc-i440fx-2.0 -> 2.3 machines
Date: Tue,  5 Mar 2024 14:42:02 +0100
Message-ID: <20240305134221.30924-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Kill legacy code, because we need to evolve.

I ended there via dynamic machine -> ICH9 -> legacy ACPI...

Based-on: <20240301185936.95175-1-philmd@linaro.org>
          "hw/i386/pc: Trivial cleanups"

Philippe Mathieu-Daudé (18):
  hw/i386/pc: Remove deprecated pc-i440fx-2.0 machine
  hw/usb/hcd-xhci: Enumerate xhci_flags setting values
  hw/usb/hcd-xhci: Remove XHCI_FLAG_FORCE_PCIE_ENDCAP flag
  hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST flag
  hw/i386/acpi: Remove PCMachineClass::legacy_acpi_table_size
  hw/i386/pc: Remove deprecated pc-i440fx-2.1 machine
  target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
  hw/i386/pc: Remove PCMachineClass::smbios_uuid_encoded
  hw/i386/pc: Remove PCMachineClass::enforce_aligned_dimm
  hw/mem/pc-dimm: Remove legacy_align argument from pc_dimm_pre_plug()
  hw/mem/memory-device: Remove legacy_align from
    memory_device_pre_plug()
  hw/i386/pc: Remove deprecated pc-i440fx-2.2 machine
  hw/i386/pc: Remove PCMachineClass::resizable_acpi_blob
  hw/i386/pc: Remove PCMachineClass::rsdp_in_ram
  hw/i386/acpi: Remove AcpiBuildState::rsdp field
  hw/i386/pc: Remove deprecated pc-i440fx-2.3 machine
  target/i386: Remove X86CPU::kvm_no_smi_migration field
  hw/i386/pc: Replace PCMachineClass::acpi_data_size by
    PC_ACPI_DATA_SIZE

 docs/about/deprecated.rst       |   7 ---
 docs/about/removed-features.rst |   2 +-
 hw/usb/hcd-xhci.h               |   4 +-
 include/hw/i386/pc.h            |  22 -------
 include/hw/mem/memory-device.h  |   2 +-
 include/hw/mem/pc-dimm.h        |   3 +-
 target/i386/cpu.h               |   3 -
 target/i386/kvm/kvm-cpu.h       |  41 ------------
 hw/arm/virt.c                   |   2 +-
 hw/i386/acpi-build.c            |  94 +++-------------------------
 hw/i386/fw_cfg.c                |   2 +-
 hw/i386/pc.c                    | 107 +++++---------------------------
 hw/i386/pc_piix.c               | 101 ------------------------------
 hw/loongarch/virt.c             |   2 +-
 hw/mem/memory-device.c          |  12 ++--
 hw/mem/pc-dimm.c                |   6 +-
 hw/ppc/spapr.c                  |   2 +-
 hw/usb/hcd-xhci-nec.c           |   4 --
 hw/usb/hcd-xhci-pci.c           |   4 +-
 hw/usb/hcd-xhci.c               |  42 +++----------
 hw/virtio/virtio-md-pci.c       |   2 +-
 target/i386/cpu.c               |   2 -
 target/i386/kvm/kvm-cpu.c       |   3 +-
 target/i386/kvm/kvm.c           |   6 --
 24 files changed, 48 insertions(+), 427 deletions(-)
 delete mode 100644 target/i386/kvm/kvm-cpu.h

-- 
2.41.0


