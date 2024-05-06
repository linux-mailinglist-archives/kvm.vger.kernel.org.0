Return-Path: <kvm+bounces-16730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CEC8BD049
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E64AB2398E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 14:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8EE1384B7;
	Mon,  6 May 2024 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p10uVEWb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE27113D507
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715005777; cv=none; b=d/Wr70lBCjxDMi/Hl17eIzSSSvHA0gZ+VdXQltC2VQvxplAb5O0CYXxE+ibfkFFZE0PtyZ7/pN/DPfTPNpCra4BiyAzM97+M8Z3K/bONaPO6tQlX/679AKr034IoPVI8bFH+s6qb22ADfhyYwf5sA50GqVYjn2znRXKhppoRYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715005777; c=relaxed/simple;
	bh=2bTzqvRdjSqcFgQLMItbHeN0WOxgGUp331G815/yj4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlTPfYlCO0iFbGeQU8wQVchSYJCGrGjIN9n5/+Jd8KJxlD/Fdi0lJgeR6pV2CN4rwWTLnj0OYrBh6Ug/JHRJJerYWgB8FcyKe1XMUJJ3GTE75QXB/0uUTz1DzDsuHH9hLvlniWIgX+FwteMnQhzyiUc7dfDEvLp+mfixSFylLgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p10uVEWb; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-34eb52bfca3so1382058f8f.0
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 07:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715005774; x=1715610574; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ba7nd+UfOBYkqEvqsJujD4dIxGkHfk5SM1/9sfXvRGg=;
        b=p10uVEWbBErKHPXbFHtLV4G4um5tkIuL/B1hXtuSKGBOxPGpL9thciri2zr7e3PAH/
         0VqQYyl1U2rjiwi8PTpV5ijGbIchFkE3J1jgrl0LJI5C2chozKzR3ozipzms98oXN5aE
         3QxdODM4oXhMiyawKWPDP51Tdn/Rli38XCIABeh/oHaU8Ifeiu072YeSd1Y0/P/A8M95
         9x+RxneUWoBkz9CVK+QwhC4HV+TQSCzLU5AgbtzRYYsX5ldgOckcZXxIwiPa/cUOj3ur
         QqVxHBuONp6G9mxuuX51o1zgB0uw+fxk0iWcejbTOuGsC/AZCc67vCZwGNoxP2Y/xkih
         qGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715005774; x=1715610574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ba7nd+UfOBYkqEvqsJujD4dIxGkHfk5SM1/9sfXvRGg=;
        b=mVTZt6ABUePKHS89PpqxB3p4p0FEmH9Jp4Ns3l4N3GFYPkJyqlWVR3WgbblILLCFaX
         YoyCLY0KvKgmBvXONhbJC1GSOlDLzZhnnK5YBLm8nTHM9ezI3ju6FGZaz+PFnjUnOVPa
         dbdzCNfrvkoHtw0QoQGiCQ2cXpACna6wnbBnP7SqeyyLEkH6uN7qI5mdMIqDkN7OcqlY
         w6d3iaFN/lCQxxvixDa8tLkKiksPnsAb38EW9yIJ/M5IcCzLlCQaVVp3CD7F1BaOrOyq
         juyd2IoZLFHk0FB2GS55Ak9/shMgv7nO5MnHQ+KLyLKcI+FVPhXfGZCSkmqrAQAPVIp7
         fZZw==
X-Forwarded-Encrypted: i=1; AJvYcCXU5eLPPD9l0o1037HTNFhzxxAHGw3a0P+5Tq29QqYpEsdu/yQZo0a3oHtgb84oFlvM+Ctjh0b1IK1FX7vS1ZoQDQZT
X-Gm-Message-State: AOJu0YwqavUuWEBvaKEecloCAZgUmGck2JV2lOv1rJmYWTHvp4FxKt/r
	yf0zCoJJ00JCBRtKh62A3c0e84Vjx6hYYGURt9HfJJV2WgbUytnr/v6Tdla3ub3zVBBy5VZPiUa
	F
X-Google-Smtp-Source: AGHT+IFu9jTJzOMdEtdPRC073tVIICl0ogjMziKULhaxYUUNf5yt9pqu26+0Xf79jIkH0MWsE5nTVg==
X-Received: by 2002:a5d:5483:0:b0:34a:35c7:22a3 with SMTP id h3-20020a5d5483000000b0034a35c722a3mr9032998wrv.20.1715005773952;
        Mon, 06 May 2024 07:29:33 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.211.4])
        by smtp.gmail.com with ESMTPSA id cm11-20020a5d5f4b000000b0034dd27adb2fsm10821339wrb.107.2024.05.06.07.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 07:29:33 -0700 (PDT)
Message-ID: <6de106f2-1061-483e-97db-96b09e5b40ad@linaro.org>
Date: Mon, 6 May 2024 16:29:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/22] hw/i386: Remove deprecated pc-i440fx-2.0 -> 2.3
 machines
To: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-riscv@nongnu.org, qemu-devel@nongnu.org,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org
References: <20240416185939.37984-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/4/24 20:59, Philippe Mathieu-Daudé wrote:
> Series fully reviewed.

Ping, is there some issue holding this series?

> Philippe Mathieu-Daudé (22):
>    hw/i386/pc: Deprecate 2.4 to 2.12 pc-i440fx machines
>    hw/i386/pc: Remove deprecated pc-i440fx-2.0 machine
>    hw/usb/hcd-xhci: Remove XHCI_FLAG_FORCE_PCIE_ENDCAP flag
>    hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST flag
>    hw/i386/acpi: Remove PCMachineClass::legacy_acpi_table_size
>    hw/acpi/ich9: Remove 'memory-hotplug-support' property
>    hw/acpi/ich9: Remove dead code related to 'acpi_memory_hotplug'
>    hw/i386/pc: Remove deprecated pc-i440fx-2.1 machine
>    target/i386/kvm: Remove x86_cpu_change_kvm_default() and 'kvm-cpu.h'
>    hw/i386/pc: Remove PCMachineClass::smbios_uuid_encoded
>    hw/smbios: Remove 'uuid_encoded' argument from smbios_set_defaults()
>    hw/smbios: Remove 'smbios_uuid_encoded', simplify smbios_encode_uuid()
>    hw/i386/pc: Remove PCMachineClass::enforce_aligned_dimm
>    hw/mem/pc-dimm: Remove legacy_align argument from pc_dimm_pre_plug()
>    hw/mem/memory-device: Remove legacy_align from
>      memory_device_pre_plug()
>    hw/i386/pc: Remove deprecated pc-i440fx-2.2 machine
>    hw/i386/pc: Remove PCMachineClass::resizable_acpi_blob
>    hw/i386/pc: Remove PCMachineClass::rsdp_in_ram
>    hw/i386/acpi: Remove AcpiBuildState::rsdp field
>    hw/i386/pc: Remove deprecated pc-i440fx-2.3 machine
>    target/i386: Remove X86CPU::kvm_no_smi_migration field
>    hw/i386/pc: Replace PCMachineClass::acpi_data_size by
>      PC_ACPI_DATA_SIZE

