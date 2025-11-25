Return-Path: <kvm+bounces-64467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0AEC8374D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02ED74E00F4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B30C287246;
	Tue, 25 Nov 2025 06:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QSKL4UTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FB223DE5
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051815; cv=none; b=cddEj4jjfNM6LU5CjXsLjkpp3TubQNc4I/5KbfDv3jQK7uH9As2K28dl1dSOPUso82XFWMabJ5+qukL330zH3WFVH78oxJnqAzq8VNRGznL8NzQ+ecFQdTlv8Jg/mnsQcJbH0u3FlCq5WHUvY3iUUypiKmHIHE08FEUm0/T4IoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051815; c=relaxed/simple;
	bh=z2zbG/QBQJc7P4Rdt7dS9v6X1+/yn4VhZj7b9F0rbCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u0J121OKaRgmn6uKCVmifejTQVu/bsUKx8dbE1hyfA+/cFUFJA3z+NwrAm8uFbaM6oJRGoH3X5wvm+IWHPe8044d7l1MlLDoZMV5avYagn5a9x5Yz4BZ5GcFUCMCEbaMOzOLgtaCt0/0/3cW9dXKMeskcCF7SyB1PtHUrOi0s6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QSKL4UTM; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47778b23f64so26927735e9.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051812; x=1764656612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOOQl3kZW1bVC+fk7t2YWU1R6hWEB46Dmnal7magMFw=;
        b=QSKL4UTMeuHuuFeZmeJf7dmTUbAWeQyczYFch/f0oOQ8NOBDiJuNzjAxPaE8Bp8/h2
         AGYT7socWV0PPOTXNrkr/p0VVA9/0HRcnSbM3RLA0hiG0jp3BKiJg/nkY21At7f0e9mX
         9QmDK7oxAYxwjat7Kw566GS/yKQ75g722Eo5eJ2EleepmW6jDv4bzVnLb/g8aguKIIhV
         n/XGFWee9o140gfF2UhXrrV84k64AYhvmMyyEiZd9Ww7fX/IsgxZCwI70u20PizHCBt9
         i0BRESTBOLOQ8jpZfUzZb2OPjWUnX6w18+PJ1h61QV6/dOZj6lf5mx4uIcsPPdBDGZK7
         yyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051812; x=1764656612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOOQl3kZW1bVC+fk7t2YWU1R6hWEB46Dmnal7magMFw=;
        b=fF+iv0DU7VgusQPZEyvPXzDYjmaCfGkiW0CalgvrmHEZw1PK+Knqov4UKXtukFbdVN
         kOWbDZp0C7pLT/OKld0M16vWPuJub8R2jbapnm2JBCbRjmVqY+bV71Quo2DODhjiNopq
         Zr4P1DUc4jzSszhuotd1bQxBfqSN30fIkqI3/HHUhl6ljZQmZouxsePy/Ep//yfQWO4S
         RMtptOrYE682lu9K/TbiYI315ndD5SAQABvKmSV1rJZE5aLRyJqa28Cb5pxnYPVr3vAx
         FZK9PZtJ+7WHq3PEBwY4YSyOdxQGJEaMGyHWLpTVl5IrG7t9Cyf3fqELhkX7ZmFv5gQg
         nPXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2hT4u+PBoZmgb+jr+l4niPyrLaYujbW1doARNAXUyKzMJiS/7GyVb98TbzPsRNzwCX2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrdSkgkzJXrarxODIaa3zC6VRf8lBWLp9/UK8VZJ0NGHiUlll2
	86PEhWS92qisEmVViRkrWT2Pg7+W7qUhpTwEQ4q75wiSC5KBpkslZWyqloHTxPPJwe4=
X-Gm-Gg: ASbGnctPfqXIk4z4aYbRSWrWKUvvkgVVJa8spTfo3hWl+SJp3b9c5Qj+p2Ha7m7AGED
	Xwydz4x2LQUpi9SwNScMaK8HYVXezn91APD4oRIlId4JKDAEbXZi4ZI1fMLBmCf9nr8rKe62pYz
	D2u14UUFvGdHYXXUONfaVVwHrdDWClpq7pMJsGInDIVdBbUuT1vqinFhC9LTCWt91xLv77fUj9C
	2NVyTzZXGIYFNvLYFOUPnpufiO8Lg+mO1oGhNCQWiAOHkRrE3W/tt2riWZWatxdlbkOmj6yjxvW
	nQCZ3R7vTrSNZzGryUYeIlnWLsDjjZ/dWveaSzkZz/g2F3TtbiKvxflqZfQ746MhKtw0/99wqj6
	M2sYZ1bJE28PNUoA3R348n6MZGuppuZ95dcD9gLbvKoRdu54i2omMzKXL1xMVXSxeR1FBn1XagE
	h2HB+AW9cDQF4oG1xhuB4JaZ4LEGMtCbrRh4UWxbAc1xEHIVSmDFIPiiG3RnjfnNWe
X-Google-Smtp-Source: AGHT+IGLa5fRK9K5L3FkUn0xfaMF4zkOQClpsNtdNtMutakIaGVpTMJc0y08tQVlCwv9gBeMm+157Q==
X-Received: by 2002:a05:600c:3543:b0:477:1ae1:fa5d with SMTP id 5b1f17b1804b1-477c1142268mr112956985e9.20.1764051811939;
        Mon, 24 Nov 2025 22:23:31 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf226c2asm231059685e9.10.2025.11.24.22.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:23:31 -0800 (PST)
Message-ID: <541f756c-0fde-488b-b386-814fb276ebae@linaro.org>
Date: Tue, 25 Nov 2025 07:23:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/15] error: Use error_setg_errno() for simplicity and
 consistency
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-14-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-14-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Use error_setg_errno() instead of passing the value of strerror() or
> g_strerror() to error_setg().
> 
> The separator between the error message proper and the value of
> strerror() changes from " : ", "", " - ", "- " to ": " in places.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   backends/spdm-socket.c      |  4 ++--
>   backends/tpm/tpm_emulator.c | 13 +++++--------
>   hw/9pfs/9p.c                |  3 +--
>   hw/acpi/core.c              |  3 +--
>   hw/intc/openpic_kvm.c       |  3 +--
>   hw/intc/xics_kvm.c          |  5 +++--
>   hw/remote/vfio-user-obj.c   | 18 +++++++++---------
>   hw/sensor/emc141x.c         |  4 ++--
>   hw/sensor/tmp421.c          |  4 ++--
>   hw/smbios/smbios.c          |  4 ++--
>   hw/virtio/vdpa-dev.c        |  4 ++--
>   migration/postcopy-ram.c    | 10 +++++-----
>   net/slirp.c                 |  5 +++--
>   qga/commands-posix-ssh.c    | 23 +++++++++++++----------
>   system/vl.c                 |  2 +-
>   target/ppc/kvm.c            |  5 ++---
>   16 files changed, 54 insertions(+), 56 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


