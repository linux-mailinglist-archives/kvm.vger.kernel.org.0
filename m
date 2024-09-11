Return-Path: <kvm+bounces-26479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5981974CD7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B11FB23343
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACEF155A2F;
	Wed, 11 Sep 2024 08:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="okVLn3Mn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDA613A884
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044003; cv=none; b=Wri4O2U7feWsAZ4O+8mumh1BmWIiAzfElUJ34avZlaMl1+EIA03oQ8jLBiteEHYLKZAOG7dbYgQOhPpkRuUKUz/E5sDV9viWrwjzAUaxTnNpNQIXAP3uriRQ1ew+rBXGyd+gLsmUjIGC476/tJ/370Ar7yXMUtbfID1uMfBgV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044003; c=relaxed/simple;
	bh=q0Lxt+2evzolt9mvqx4fFYI/3tBP2ZBWN0uRvIr+7Dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nt5W1zgPGoHQ+nXavTAD2pAwjEP6VHe3ca1pCGH5MCIx4dmc3pEb2uqP4l70hx6L3xVeMmYxhxlriXjyZ/Rwv82S7Fy6VBCmDNYdKtGZ+knwv+o3n/DeEddCcthPwVLA+WLP4KfbZ0Obcde+k2rjDy5Tm2v7JUgAw4Vr4V/6lS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=okVLn3Mn; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c3ca32974fso7240943a12.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726044000; x=1726648800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+JyV9LJm2Vf4wGO7Hd4ArlaMIqvRcHyLUasi+8n7+pY=;
        b=okVLn3Mnk5brTSHLiQ67Ggcc25yoMSOXfnC6In4M++JmTvD2JHO9ixEBNztEU+dJze
         x22Ne4oa5Wp4Y/Yu8ASoASzeMO11ZOwhDPDsutm0X8y/RuxcfB2+fOJZqHk1h+afl2hf
         cu5JfRjXcaNaANx2rAIVnPUsY38wfLDjq8CoFvniXth3JMA6+XqT/BXQFyIJTeVP1CeR
         xVY1DkFznR/Q8i2gebY+WE3bsGelE4+3kzB2HBH1nvFoXKNzFsnq9k2tZ/0X9CyUpCJH
         5rk0oUxpp0IoH45omHlQOrSLDh9P02QGe72CF5bqbYY9NbHcVFl1ePHkTkHSnw/6uaBs
         ZEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726044000; x=1726648800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+JyV9LJm2Vf4wGO7Hd4ArlaMIqvRcHyLUasi+8n7+pY=;
        b=AQdwc8LqnqSv0R3w8dYuCt/7Iw9zKgrqoyGUHAQ2/Ron7S1VijFOcl58Yj4SutV/AX
         vyUgK4SZkJ8cqd0TXaojVzpx5V45ZxbAJQy45Go87cE0mD1ZPoMViWvapHGut+bIGB6S
         hub5brO7yNS78E1GvoP2hWGnhpbk881rV7pGyaWkTm/oHXLr8M/G4HBKuMaQjeT0K1ZM
         aAV5mIH2VLdRqXXtDnADXBnMSh3RbzYMgdp01WkWmvY7POIaXjqXyvHcvRuRPmFmSdJp
         vjbhTYzdy3Evc4ZQ+YkCq75kWnMA6q3NR7v4w8t5kPEnwvrGTuktAhcpNTjUpc2oWX8Z
         43/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUlsgtRzL75Dd/hJrjOxGR+aWH/MQAmiI2si5pHoCmj4eT73wfMEW8gz4lmEDJFUZZgRIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1dIreI7xmN7u33iHt7OukKIGTOYXxYJKBgoiRXK6mwiYGgMj6
	lIrE9zpUOAM25d30JwdU8DP4Cw/tuUadiLlg+oV0GEOR38z4qMiMVm34l5jH99Y=
X-Google-Smtp-Source: AGHT+IEuEoUthM2OYCPbsPo/4/wEMjrSZwhG3gfLOvWlGcTJuhGUXemtOiCS/nVKmGgtKqBxFEkheQ==
X-Received: by 2002:a05:6402:26c9:b0:5c2:439d:2042 with SMTP id 4fb4d7f45d1cf-5c3dc78034amr12338656a12.5.1726043999447;
        Wed, 11 Sep 2024 01:39:59 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd52099sm5139643a12.48.2024.09.11.01.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 01:39:58 -0700 (PDT)
Message-ID: <cd6c5970-9a1c-4d58-b8af-483909c3c0ca@linaro.org>
Date: Wed, 11 Sep 2024 10:39:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/39] Use g_assert_not_reached instead of
 (g_)assert(0,false)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/24 00:15, Pierrick Bouvier wrote:

> Pierrick Bouvier (39):
>    docs/spin: replace assert(0) with g_assert_not_reached()
>    hw/acpi: replace assert(0) with g_assert_not_reached()
>    hw/arm: replace assert(0) with g_assert_not_reached()
>    hw/char: replace assert(0) with g_assert_not_reached()
>    hw/core: replace assert(0) with g_assert_not_reached()
>    hw/net: replace assert(0) with g_assert_not_reached()
>    hw/watchdog: replace assert(0) with g_assert_not_reached()
>    migration: replace assert(0) with g_assert_not_reached()
>    qobject: replace assert(0) with g_assert_not_reached()
>    system: replace assert(0) with g_assert_not_reached()
>    target/ppc: replace assert(0) with g_assert_not_reached()
>    tests/qtest: replace assert(0) with g_assert_not_reached()
>    tests/unit: replace assert(0) with g_assert_not_reached()
>    include/hw/s390x: replace assert(false) with g_assert_not_reached()
>    block: replace assert(false) with g_assert_not_reached()
>    hw/hyperv: replace assert(false) with g_assert_not_reached()
>    hw/net: replace assert(false) with g_assert_not_reached()
>    hw/nvme: replace assert(false) with g_assert_not_reached()
>    hw/pci: replace assert(false) with g_assert_not_reached()
>    hw/ppc: replace assert(false) with g_assert_not_reached()
>    migration: replace assert(false) with g_assert_not_reached()
>    target/i386/kvm: replace assert(false) with g_assert_not_reached()
>    tests/qtest: replace assert(false) with g_assert_not_reached()
>    accel/tcg: remove break after g_assert_not_reached()
>    block: remove break after g_assert_not_reached()
>    hw/acpi: remove break after g_assert_not_reached()
>    hw/gpio: remove break after g_assert_not_reached()
>    hw/misc: remove break after g_assert_not_reached()
>    hw/net: remove break after g_assert_not_reached()
>    hw/pci-host: remove break after g_assert_not_reached()
>    hw/scsi: remove break after g_assert_not_reached()
>    hw/tpm: remove break after g_assert_not_reached()
>    target/arm: remove break after g_assert_not_reached()
>    target/riscv: remove break after g_assert_not_reached()
>    tests/qtest: remove break after g_assert_not_reached()
>    ui: remove break after g_assert_not_reached()
>    fpu: remove break after g_assert_not_reached()
>    tcg/loongarch64: remove break after g_assert_not_reached()
>    scripts/checkpatch.pl: emit error when using assert(false)

I'm queuing reviewed patches 4,5,7,10,27,28,30,36 so you don't
have to carry them in v2.

Regards,

Phil.

