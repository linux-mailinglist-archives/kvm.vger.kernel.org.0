Return-Path: <kvm+bounces-64484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BACDC8478F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 46E5634538B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7613301707;
	Tue, 25 Nov 2025 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rSBc8FXn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484BA2FE56E
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066451; cv=none; b=SbAPHg0WOYIztkjTzKGnmNPKJR5OQEYnMgr5uIu+8PUSfup1V1/cUyqKMvRfR7LEYbO9tjApTnQfX2mHWRqMk8DVJxBsjLmOOPI3aBObeNhvd5phF0VyGUDyNJGm3smkVLf5qVzLu42s57oiyHYba9FcosZXpZfiB9jnls6Gvx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066451; c=relaxed/simple;
	bh=X5NmVu7/ohl2pNbWp30mT1Id3eYYnQINX5s9mwtm3qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVdnbX3aVX+Nc83DoDK8PCATsPYezuJuWGSRYogREsYyeZHWqolBYpmESJDG8UO7BKs/IMvq45P5nMFIiVmndj4HaYHv79JDsRokIk6PFOzda737O0KQv0fUjkJ2/crO/VvMGs0u8GWx/P7BIozOuBu9kMfjCxJSH/Eb3SrMONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rSBc8FXn; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429ce7e79f8so3001173f8f.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066447; x=1764671247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dsNRN3M7tLf1Kcxi1KCFkpYYf2qs5k6tXujcFgV5vT8=;
        b=rSBc8FXnA7OxXP3i8u7yA846mR2CEJ5gxn/PPwyl7vZ7Kt7LcfN2+/W/HnYy2SISIZ
         K+AH6v+VJgB5OZAjDtdiaF8HmXaDvgpyi4s6N49G0WR0aT2Id1q4mqEbpyEeDQgIqvaA
         2+ilM9tPjco/9ucmGzBG50fUwHkjkzaMSkgyRSnyYakAww+exJvuTn5R37OjGRJ+4nvj
         rrvlC1EnKhPPKFyG3b1hnSZhdftririH5bnoCzNhJnw/IW4WBvvgJSGwoebKoXrVzVRv
         OO/WqzekeyBFvW6p2N8jcIts9/AbLV/iw1zoespKA+fMC9wNDcUVVmQTh5icxrGRqWG7
         +EIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066447; x=1764671247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dsNRN3M7tLf1Kcxi1KCFkpYYf2qs5k6tXujcFgV5vT8=;
        b=btooRtiKCYZYrS2fB7aCfXzvOXhckvZQO45AgLTHHu3RMLYSyp/uxGlWjse5p4sBjZ
         0K1ge3jD7WDoIV/11iOQtliTQ17HWNchPS3qH4M6O0B1JbehrWoLqocZq8B9HPvYB5rY
         s8zBN2ErBDP1BklufMgA6RXDANguHkhKEx5kcZjrYp9AOp2Eu7axp+scA1ZBij3/QH2E
         3kvbKfnprlBVCEOzg/nGfgdRRdQrFrDFUGJuBPiErjS012wGgCBs4n9JiZ6KkclHzkiD
         g15bGlBSczAw3wJZvDCfYmf33bv4ihT0og26Rav9mi4rAwxMwv8ObZBbiprmIi4GPFQU
         JFcA==
X-Forwarded-Encrypted: i=1; AJvYcCXtZBhrVLbIxqgWcjzR2sMmr0AhE+njcNJE6pk7cuEJOzCbPrHRVi3HQhrMIi8MLqlUIVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQxSIflm6/e5gUbylacI858m56Keqi4q7L03Rnm12xzBzr00iv
	x0N95lg8DE6dGVzqkolhqUTS/uce9JTEB7OAO65TDLNi93qz8830KXcQO6XjZ2s1I5w=
X-Gm-Gg: ASbGnctjGlUf8zezdVr1+tRBAYythQ5K+KxWkUJZdtHF+QltzrZj1zfybrEHBDeq+VQ
	GEGp7QTSF6aufm3ocLvOqkPjPQ4Ko4PzzQZELUWrZs9EljDKWOXIlxC3NnwgbbbPpX7mC/Is3h3
	Z0cSxxU9rEV06oiKDHbbOTTaTby1n5YguElnTGaGV7BcbjDoq5DfuQLjN5Fn1FEii1o/mH+6oBV
	jay1RnW7Y9oo764rzxNhCDU6OFF50aXWryx58nxyMStf1/u1ESazSv1EMEMOUAV5SeziIXP+uNi
	VPtFKuTMOunhdEG8aqNimLPd2FOkIFz3r403vGru3+bBcxEsJKiVxtjzZhRK2+4Z/EUn1VMJRd3
	pgPZrwK2Vn/CdgMmDT1zmq14QsyTdw3MKGGae49Ynx9WrMtIbrvKEBYHTROphM8u6IMyNWzm2RI
	9cN1ksct+pgJCOFXybsFp7a5htbP8kE/hmb6Ucuga/cqiZvjdl1t+3uA==
X-Google-Smtp-Source: AGHT+IHKKU4ceMuaE95csztZcp8xaXOFHTU3Bea9HWqGWegeju5+IOQNhIe6zGPw+m52NYEXgQy3dg==
X-Received: by 2002:a05:6000:2dc3:b0:42b:2e94:5a8f with SMTP id ffacd0b85a97d-42e0f35913amr2072165f8f.52.1764066447520;
        Tue, 25 Nov 2025 02:27:27 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a81sm34239083f8f.26.2025.11.25.02.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:27:26 -0800 (PST)
Message-ID: <f34353af-ebe5-4a43-9982-385b4113c983@linaro.org>
Date: Tue, 25 Nov 2025 11:27:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] ui: Convert to qemu_create() for simplicity and
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
 <20251121121438.1249498-4-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-4-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      failed to open file 'FILENAME': REASON
> 
> to
> 
>      Could not create 'FILENAME': REASON
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   ui/ui-qmp-cmds.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


