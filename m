Return-Path: <kvm+bounces-40125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC3BA4F5CE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7120169DEA
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BAD178CC8;
	Wed,  5 Mar 2025 03:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXY1OvN/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111528F54
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 03:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741146802; cv=none; b=dcymehOA3/6ei9zpFHT08LOqFK7fyABFLD0d4/KPhqlQ3U5eajSpEWIdQWWWw5dt46PLUFlZ5X/p4yJRtM37QVRglgdG2etHCT7n274x/N73FGiHd8J3gEpeYfPyNYD5XK4sBdzTqnTy/HB4czTAqzfx3qscN/m5xsHI6VuQ/yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741146802; c=relaxed/simple;
	bh=KYu15OTxtFs2mF10JuE1RcryLYxEkKONS/St8WU9dMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzr+xRsJ7t/X3nnZH0rhX4HJadhtmVP2IWfLqoLWNSZoCQcsL0jK9zNITzj0Dg2YYHxNLRwJ8p3OFemdPVXVMOwfhU6DyppEMtPmzLBLY4PSSv2WFcMPqRx2SHDRkN2Y5X7UaQU7h9UviosUpNCYYqhcVw+HJgbJxWjPV3m4owM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXY1OvN/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741146798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mJRNWDqZaDl0D1j/RlDn06NEO5jFGolr9VYIE5+CIg=;
	b=NXY1OvN/rhS34ZM5E5L7oVpgC1wVUWzkhXLTJzFsZlwV7r51m1fyNceQ3FFSrHDMr7S0no
	qDgSQbABITHcbAdW72EMVle2IKz09NIF5SrX5GXx6X8ObiOfz4w9xzyPdMTeJLgUg3jQ89
	bHjGzgh31KR8vvsXF4kMnGHs1Xs91ng=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-oUBGxFWXM3qBo2qsWfeNWA-1; Tue, 04 Mar 2025 22:53:17 -0500
X-MC-Unique: oUBGxFWXM3qBo2qsWfeNWA-1
X-Mimecast-MFC-AGG-ID: oUBGxFWXM3qBo2qsWfeNWA_1741146796
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fee7f85d03so10746487a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 19:53:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741146796; x=1741751596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mJRNWDqZaDl0D1j/RlDn06NEO5jFGolr9VYIE5+CIg=;
        b=qtjrNCmGCKiVMgbLIW3ZJIpZeTMlXvi35s/Y4Ci8wd+CcpQZXSW7ZYaUqwa5n/cxRV
         9HxOwTgLMN394m41fpnFe2OoWf0oVRxqz5P9bJFWcti8+HfeA4Kn08sIkRVc80mqeiJy
         GzRi64vSgSf0v6scLu7OPh3HOJaMRkQWAudqnaMvUziVz5alkgjolvnTqP47942KgB+5
         bqNSFZBpOUWyyzn4aMXec4/OU9eIMCwxuamTqmukmLCXgNpfGEWYwwMTUfHcQuq25jRp
         To60MX2ZkbQ6pQqtaS+YIyMycxBuo/5VPguwf+Z1RO1S7pxUbEOtsnPtrxBFw+XlPrRk
         zJbw==
X-Forwarded-Encrypted: i=1; AJvYcCXnJ+4BbhMTaGe9CoEEevaNMwiXvqsgTidS1EI91Rif+BjeuDqUI+9R50Nx9V/9FpuCdrY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb2rzqxpEeRg36zOqeqblzR9SLBEKQJigLajHXHQ8jo7DIokM/
	xRwp22+1d11xDjgFITckH9p5lUx7ciYods1VJUJdZ++aJJrJwKMWaG1UCUjEGBPVYl5EK9SJVJk
	+A/4N5bWIklVEBRDOqvifr+FhibDnZIVaDehi/ijKN5p4MrJU7g==
X-Gm-Gg: ASbGncvLK5jMcEBhx0TKI3UsH6EoC8oqc4YO5VCpOJcq8LLXHm5XUcohAqhC8ClOJvW
	xELQfHPwhb5Gj6c1dsy1QyiUEMxKZ574ZbmUTTxK6USNOLbHEtQIZOUXZvNl42tSqtWiBtD+75q
	SmBLp1E488QKAPVwsUwmw4JbscAGCRYAl4Nqbdzm5g7U9FwjYU5zAceZY1FZAToVv59nsDZHCPW
	4ZZw2Adqvr2Xp7j2gRazMrz1TR+WuFy0SdzoCJxD+Fm4P9TSd9GbzalGpUfHxjpMfmvTEISG7Jq
	6uSRlLldo7zGF54=
X-Received: by 2002:a05:6a21:150c:b0:1ee:cf13:d4b5 with SMTP id adf61e73a8af0-1f3495afc1dmr2823098637.39.1741146796422;
        Tue, 04 Mar 2025 19:53:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFuyA16zIv02ugj3FPLruOV0ZdxdHMNTCUw0ZHSpkP3eGnIKTFgv0oqMKMfRXj1Nc/YwnybSw==
X-Received: by 2002:a05:6a21:150c:b0:1ee:cf13:d4b5 with SMTP id adf61e73a8af0-1f3495afc1dmr2823058637.39.1741146796108;
        Tue, 04 Mar 2025 19:53:16 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7ddf20b8sm11041231a12.7.2025.03.04.19.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 19:53:15 -0800 (PST)
Message-ID: <af65c1ea-202a-4a60-ab13-0c325385b7ec@redhat.com>
Date: Wed, 5 Mar 2025 13:53:06 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/14/25 2:13 AM, Steven Price wrote:

[...]

> 
> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
> 
> This series is based on v6.14-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v7
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v5
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> [2] https://lore.kernel.org/r/a7011738-a084-46fa-947f-395d90b37f8b%40arm.com
> 

I had a chance to test it by following Jean's instructions [1-2]. The guest can
boot up and kvmtool also can boot the guest. I'm listing the repositories I used
in case some body else want to give it a try.

[1] Jean's guide to build software components needed by ARM CCA stack
     https://linaro.atlassian.net/wiki/spaces/QEMU/pages/29051027459/Building+an+RME+stack+for+QEMU
[2] Jean's guide to build firmware needed by the emulated host

host
====
tf-rmm    https://git.codelinaro.org/linaro/dcap/rmm.git                       (cca/v4)
edk2:     git@github.com:tianocore/edk2.git                                    (edk2-stable202411)
tf-a:     https://git.codelinaro.org/linaro/dcap/tf-a/trusted-firmware-a.git   (cca/v4)
qemu      https://git.qemu.org/git/qemu.git                                    (stable-9.2)
linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git                   (cca-host/v7)
buildroot https://github.com/buildroot/buildroot                               (master)

guest
=====
qemu      https://git.codelinaro.org/linaro/dcap/qemu.git                      (cca/latest)
kvmtool   https://gitlab.arm.com/linux-arm/kvmtool-cca                         (cca/latest)
linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git                   (cca-guest/v7)

Command lines to start the host
================================
[gshan@virtlab723 host]$ cat start.sh
#!/bin/sh
HOST_PATH=/home/gshan/sandbox/qemu/host
GUEST_PATH=/home/gshan/sandbox/qemu/guest

sudo ${HOST_PATH}/qemu/build/qemu-system-aarch64                      \
-M virt,virtualization=on,secure=on,gic-version=3,acpi=off            \
-cpu max,x-rme=on -m 4G -smp 8                                        \
-serial mon:stdio -monitor none -nographic -nodefaults                \
-bios ${HOST_PATH}/tf-a/flash.bin                                     \
-kernel ${HOST_PATH}/linux/arch/arm64/boot/Image                      \
-initrd ${HOST_PATH}/buildroot/output/images/rootfs.cpio.xz           \
-device pcie-root-port,bus=pcie.0,chassis=1,id=pcie.1                 \
-device pcie-root-port,bus=pcie.0,chassis=2,id=pcie.2                 \
-device pcie-root-port,bus=pcie.0,chassis=3,id=pcie.3                 \
-device pcie-root-port,bus=pcie.0,chassis=4,id=pcie.4                 \
-device virtio-9p-device,fsdev=shr0,mount_tag=shr0                    \
-fsdev local,security_model=none,path=${GUEST_PATH},id=shr0           \
-netdev tap,id=tap1,script=/etc/qemu-ifup,downscript=/etc/qemu-ifdown \
-device virtio-net-pci,bus=pcie.2,netdev=tap1,mac=78:ac:44:2b:43:f0

Command lines to start the guest
================================
[gshan@virtlab723 guest]$ cat start_guest.sh
#!/bin/sh
key="VGhlIHJlYWxtIGd1ZXN0IHBlcnNvbmFsaXphdGlvbiBrZXkga"
key+="W4gZm9ybWF0IG9mIGJhc2U2NCAgICAgICAgIA=="

qemu-system-aarch64 -enable-kvm                                                     \
-object rme-guest,id=rme0,measurement-algorithm=sha512,personalization-value=${key} \
-M virt,gic-version=3,its=on,confidential-guest-support=rme0                        \
-cpu host -smp 2 -m 1024M                                                           \
-serial mon:stdio -monitor none -nographic -nodefaults                              \
-kernel /mnt/linux/arch/arm64/boot/Image                                            \
-initrd /mnt/buildroot/output/images/rootfs.cpio.xz                                 \
-append earlycon=pl011,mmio,0x10009000000

Thanks,
Gavin


