Return-Path: <kvm+bounces-46463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F8BAB64D1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0000F1750BE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCBA20B1FC;
	Wed, 14 May 2025 07:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJNCYXMq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86641E503C
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 07:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747208960; cv=none; b=MBEETaFeVhx0JAmZ+/sY6htpGzcYvNwAwTUpwOyGq06hcVHtX4xykyopZIp193ZdmzKWcpYSz9Jtd2QIwGfIsdFb2CBcWyOBcW3hecG+g0HW1BYB8Y389ZPJ8bBRyrX/gYOxwW/PJg+iTurfl00j/2LG6ogCITLB37WBU+T1hUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747208960; c=relaxed/simple;
	bh=lzfyW5te2xA5XTLbpjnHt9WakjMUlZCEwN2zoYKHIxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m8/DLJVqE20olA1UV5ypkjKKF4hn4ENEm38ioY/nktdcA6kW7EzL0G6EWCyntssladU6Zek2Itm4/q3KvZZcNeYEGtoyzum24bmu0JxSIazyUZ38SAF4cByKohczmr0dgEe/eNiivLJqFoMyrzZT6XTRFg+BnFiOPzYT0hBfS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJNCYXMq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747208957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GY5pVLDJBE/QxHoyRscYKOYBVWh0U1cYp7B4seYFbNI=;
	b=CJNCYXMqPJ9jxH2JLydLDkHuZeCEdz9CA/vjoThMZ/ZN5bJoYQMuZ9Cd77eNSZM59hwiak
	ztxqLALMo01FkW7WK5bEgdzNJd78XSH7wenA5/lSAEK0AEAi0E+1aKac8rJ9b9QWXLn+4g
	lzLcimT8kTOplluN2tyQHMM/E7vycgM=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-C_6XAy2WPim3gpO21Q9xfQ-1; Wed, 14 May 2025 03:49:15 -0400
X-MC-Unique: C_6XAy2WPim3gpO21Q9xfQ-1
X-Mimecast-MFC-AGG-ID: C_6XAy2WPim3gpO21Q9xfQ_1747208954
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-739525d4d7bso5311311b3a.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 00:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747208954; x=1747813754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GY5pVLDJBE/QxHoyRscYKOYBVWh0U1cYp7B4seYFbNI=;
        b=JYaHUIeIrX6+xIHpS4mM3ANS911dJ3UQzLUxU/KrmM3ylj4RE9E0wE0W6KI0THiJmH
         ItIPwsusKUIZ3IbF3rwhUwDokM4zLy9TU46dleB4fCBNV/57By4TJPz/Gc56FACA0s/g
         3CXNJZRxHsRs/LtaB0AZyClYlJ2R64DdNKGscZyE39hjqpdwDYPbw+p+vNRFSVh7+X94
         RRz4aw1CAgcKqKd/rBSMmrLLdwi7OoxWWXw1Y7GJ3IDWbURQraB4tgLbon4ZfPM4ykzF
         wnYZnTxS69yehI14X/33uZNgEBltM1Dow8/rV1ovT9HXHB3eNLP+mIvH+0nTds4RH+iU
         0f9Q==
X-Gm-Message-State: AOJu0Yxmpgi+Pu9BTeYGmrXvHfQIknrSvbxY1d6eDldCinj1CbtO+aR9
	CjVRWpkJ1gWdGy7aqnayeCaexirlSlmxXn8oxgJoqbWo42MyIwJk0Jjyh0Cmt+s96Q92hjMuLQv
	y73rO97MkPVhDDdmAf2lEhyinvExohLp1QGO8BcZV6gM/nLltBA==
X-Gm-Gg: ASbGncts+WWHODbKocvbjUhOTejJVPBQMWxipQo6u+4AdiAYtp5f0H8a/nd8gW3XzZB
	jxOBzsu1CndooNgkkMHAWrBSObTw68NvGzull6gB0z8zuNGhu2AnGhr8kruzYhuXzLm2u7kmTXb
	HIJiPpZe1WggTIZ8rK+A3INl5CT6dR5eC4t4+B0x+dup42bcsFCclqWZx40qcT1eSWk9Y1t+YyN
	HVylpJQ7dAlpwKiuqlG4mqf777MkbIbEnA3qW7VRPajkctUSiP/1c+IIRSN/OrmErcx40KuOiuN
	vWGcE6SbvdSqc/JL
X-Received: by 2002:a05:6a00:a83:b0:740:596e:1489 with SMTP id d2e1a72fcca58-74289373d91mr3716637b3a.23.1747208953941;
        Wed, 14 May 2025 00:49:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxNAnjJT+LSzbpKrbMZgFeI/1Abe8EQQBbch700DZ2BLpon2TmE4Xe4l7GJrieZh9Qyjgk0Q==
X-Received: by 2002:a05:6a00:a83:b0:740:596e:1489 with SMTP id d2e1a72fcca58-74289373d91mr3716602b3a.23.1747208953574;
        Wed, 14 May 2025 00:49:13 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a10881sm9212477b3a.106.2025.05.14.00.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 00:49:12 -0700 (PDT)
Message-ID: <67fb8130-94fd-46d0-8f59-1c047ff0a881@redhat.com>
Date: Wed, 14 May 2025 15:49:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 06/16] scripts: Refuse to run the tests
 if not configured for qemu
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-7-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-7-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Arm and arm64 support running the tests under kvmtool. kvmtool has a
> different command line syntax for configuring and running a virtual
> machine, and the automated scripts know only how to use qemu.
> 
> One issue with that is even though the tests have been configured for
> kvmtool (with ./configure --target=kvmtool), the scripts will use qemu to
> run the tests, and without looking at the logs there is no indication that
> the tests haven't been run with kvmtool, as configured.
> 
> Another issue is that kvmtool uses a different address for the UART and
> when running the tests with qemu via the scripts, this warning is
> displayed:
> 
> WARNING: early print support may not work. Found uart at 0x9000000, but early base is 0x1000000.
> 
> which might trip up an unsuspected user.
> 
> There are four different ways to run a test using the test infrastructure:
> with run_tests.sh, by invoking arm/run or arm/efi/run with the correct
> parameters (only the arm directory is mentioned here because the tests can
> be configured for kvmtool only on arm and arm64), and by creating
> standalone tests.
> 
> run_tests.sh ends up execuing either arm/run or arm/efi/run, so add a check
> to these two scripts for the test target, and refuse to run the test if
> kvm-unit-tests has been configured for kvmtool.
> 
> mkstandalone.sh also executes arm/run or arm/efi run, but the usual use
> case for standalone tests is to compile them on one machine, and then to
> run them on a different machine. This two step process can be time
> consuming, so save the user time (and frustration!) and add a check
> directly to mkstandalone.sh.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   arm/efi/run             |  3 +++
>   arm/run                 |  4 ++++
>   scripts/mkstandalone.sh |  3 +++
>   scripts/vmm.bash        | 14 ++++++++++++++
>   4 files changed, 24 insertions(+)
>   create mode 100644 scripts/vmm.bash
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 8f41fc02df31..53d71297cc52 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -11,6 +11,9 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/arch-run.bash
> +source scripts/vmm.bash
> +
> +check_vmm_supported
>   
>   if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>   	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> diff --git a/arm/run b/arm/run
> index ef58558231b7..56562ed1628f 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -7,7 +7,11 @@ if [ -z "$KUT_STANDALONE" ]; then
>   	fi
>   	source config.mak
>   	source scripts/arch-run.bash
> +	source scripts/vmm.bash
>   fi
> +
> +check_vmm_supported
> +
>   qemu_cpu="$TARGET_CPU"
>   
>   if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index c4ba81f18935..4f666cefe076 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -6,6 +6,9 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/common.bash
> +source scripts/vmm.bash
> +
> +check_vmm_supported
>   
>   temp_file ()
>   {
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> new file mode 100644
> index 000000000000..39325858c6b3
> --- /dev/null
> +++ b/scripts/vmm.bash
> @@ -0,0 +1,14 @@
> +source config.mak
> +
> +function check_vmm_supported()
> +{
> +	case "$TARGET" in
> +	qemu)
> +		return 0
> +		;;
> +	*)
> +		echo "$0 does not support target '$TARGET'"
> +		exit 2
> +		;;
> +	esac
> +}

-- 
Shaoqin


