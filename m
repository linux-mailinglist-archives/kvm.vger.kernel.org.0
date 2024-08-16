Return-Path: <kvm+bounces-24398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D999954D1F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 16:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21DE81F26A24
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BE81BD4EB;
	Fri, 16 Aug 2024 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6P9b19E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9411BD013
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723819593; cv=none; b=M4v+sNTSc5Dowv43nbi1RuQ3Xx/0EGkivOpHyvw3zfubLF6yoVEOqAmL/s7WVzMdk315vS+A6w1JTFToyXGM1quBn9fSeU+UIt0m8i7PiBmsUFaSZyQC/GyQjEa/6TvMSD+4iSeK+cdXZDJ/Pz1iyBwQF6qGYfbFGkjnMNtxyO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723819593; c=relaxed/simple;
	bh=OIHbGGWldLDg99pORcYtOuTtueMnsUUeEr5VLhINBO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YbDMS3PTDQOlKuJwDq+FKU6hodGdTgJd+DFXPnm7G5OSce2Bvql2VD6VMKV5J9EHstsRYAbLIQfgVn4GR51DCfrckfJ7KqaCOUknwqQ5fhR2L5fr96Ldylak8a62D/PgjxI4rQsA6ejFO7bRoCxvKQG5qHmtLH4kpPhnTU4b5ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6P9b19E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723819590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6P3wmI/BdIdkSTMmbckGK8/t74YD719k3jioQVh7WHE=;
	b=f6P9b19EZo75R7WyTYAN2WX+/R1NPPfD68EQjGH1c2sxxMU3NtFngp4iM0sS+M34s+NWiz
	CKLe5FU9eSeTyz2mJHgny2pXcUndLS5W+scBRZPTdE4GBeXNLQUb0gp4SPE/mfHyaWWPGA
	fbb0BNlvDcKWmjtvByEuLlTTL0ZHXXs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-jfX8ircLPSuxzR12obUZSw-1; Fri, 16 Aug 2024 10:46:27 -0400
X-MC-Unique: jfX8ircLPSuxzR12obUZSw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4500d2fe009so34077491cf.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723819586; x=1724424386;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6P3wmI/BdIdkSTMmbckGK8/t74YD719k3jioQVh7WHE=;
        b=qCW2dzIoJEUS2e/oNTa3FFrZgSe6+WQVPCYgsbCEecTttH7Q7bpza/LTLlrl7FQyGz
         3miSDkIp6Tyzrs6qxUxqoW5+BvtPIs9sLDIYvQwNoWq2/DD7RhYnsWIJCz3z/o6MQes0
         pUQnx39lTuJzRuZl6r3VilpsI4Q9AQw6Flv+2lWWroVkWdp2SGUu+F/JUvT6hmG2QOJ+
         hKMT9twDYvW8WBYt4N5ijhw8Z/gF1SjE2zvEzKCmfnu/0zqTeNxi/ugj4m+i7g42UFeF
         nPH+l/ZWdMM9W7v+opVFkQMVJGhhe5inWp/35da7sjiPobKXGUHVcsnWLgUPoJUmiDFe
         sA6w==
X-Forwarded-Encrypted: i=1; AJvYcCWMyxDzdwwa5zzPekQaGSlYb7pcQkxN0i80X1XoZM77CSKwu8u6AzaifEtsqsXXLQAN6EclojYPJ39xnlgGxoVlEKlO
X-Gm-Message-State: AOJu0Yx97468YMBNZCoS67ErnVMGWn0KYSsIvpONtbflsicSkjKrXsrK
	afo7ppq90TcNiL/JgMQOm+JLvnPHCZTHf0bJrCaD1swYonT+wDc/yQTYEUVLQPAtmolhKxrh3yi
	2rKOD8eYBYBwZ8UmyprF5+AkVFMmTwQS0D7lh2u+QvE21aYD+qA==
X-Received: by 2002:a05:622a:4aca:b0:447:dd66:8004 with SMTP id d75a77b69052e-45375295fa0mr54671061cf.27.1723819586728;
        Fri, 16 Aug 2024 07:46:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTxpWIbeX1lpDCrcgVsLa2TUXd8ClyT+8KXrXuoCrKuWd2orO10WuG6WnlNRerZqDnEMw3BA==
X-Received: by 2002:a05:622a:4aca:b0:447:dd66:8004 with SMTP id d75a77b69052e-45375295fa0mr54670731cf.27.1723819586399;
        Fri, 16 Aug 2024 07:46:26 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-177-15.web.vodafone.de. [109.43.177.15])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45369fd9de3sm17133211cf.5.2024.08.16.07.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 07:46:25 -0700 (PDT)
Message-ID: <8b73bc40-1a57-46d7-98c1-41b984b12ebe@redhat.com>
Date: Fri, 16 Aug 2024 16:46:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] tests/avocado: add cdrom permission related tests
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Radoslaw Biernacki <rad@semihalf.com>, Troy Lee <leetroy@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Beraldo Leal <bleal@redhat.com>,
 kvm@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Paul Durrant
 <paul@xen.org>, Eric Auger <eric.auger@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, qemu-arm@nongnu.org,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Jamin Lin <jamin_lin@aspeedtech.com>, Steven Lee
 <steven_lee@aspeedtech.com>, Peter Maydell <peter.maydell@linaro.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>
References: <20240806173119.582857-1-crosa@redhat.com>
 <20240806173119.582857-4-crosa@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240806173119.582857-4-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/08/2024 19.31, Cleber Rosa wrote:
> The "media=cdrom" parameter is also used on some Avocado tests as a
> way to protect files from being written.  The tests here bring a more
> fundamental check that this behavior can be trusted.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/cdrom.py | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
>   create mode 100644 tests/avocado/cdrom.py
> 
> diff --git a/tests/avocado/cdrom.py b/tests/avocado/cdrom.py
> new file mode 100644
> index 0000000000..c9aa5d69cb
> --- /dev/null
> +++ b/tests/avocado/cdrom.py
> @@ -0,0 +1,41 @@
> +# Simple functional tests for cdrom devices
> +#
> +# Copyright (c) 2023 Red Hat, Inc.
> +#
> +# Author:
> +#  Cleber Rosa <crosa@redhat.com>
> +#
> +# This work is licensed under the terms of the GNU GPL, version 2 or
> +# later.  See the COPYING file in the top-level directory.
> +
> +import os
> +
> +from avocado.utils.iso9660 import iso9660
> +from avocado_qemu import QemuSystemTest
> +
> +
> +class Cdrom(QemuSystemTest):
> +    """
> +    :avocado: tags=block,cdrom,quick
> +    :avocado: tags=machine:none
> +    """
> +    def setUp(self):
> +        super().setUp()
> +        self.iso_path = os.path.join(self.workdir, "cdrom.iso")
> +        iso = iso9660(self.iso_path)
> +        iso.create()
> +        iso.close()
> +
> +    def test_plain_iso_rw(self):
> +        self.vm.add_args('-drive', f'file={self.iso_path}')
> +        self.vm.launch()
> +        query_block_result = self.vm.qmp('query-block')['return']
> +        self.assertEqual(len(query_block_result), 1)
> +        self.assertFalse(query_block_result[0]["inserted"]["ro"])
> +
> +    def test_media_cdrom_ro(self):
> +        self.vm.add_args('-drive', f'file={self.iso_path},media=cdrom')
> +        self.vm.launch()
> +        query_block_result = self.vm.qmp('query-block')['return']
> +        self.assertEqual(len(query_block_result), 1)
> +        self.assertTrue(query_block_result[0]["inserted"]["ro"])

I think such a test would be a better fit for the qemu-iotests, e.g. 
tests/qemu-iotests/118 looks pretty similar already, maybe this could be 
added there instead?

  Thomas



