Return-Path: <kvm+bounces-60565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBC0BF2B0C
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 19:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44FE3189F442
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E8C303C9F;
	Mon, 20 Oct 2025 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSnDrUTC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7EB31353A
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760980982; cv=none; b=NRbsvJvB60UyG1il+KuZ6MNUcqlyhNzX6NOJFL+92LbfVS+Pn1YpKmSm5y4NbMvT5OIcllyKKrxu6kDyIPzfdzf6BsYad/K5C+nWA2PTdVxjCHkpUWcz5YCzGincEi8/PDeKRkuLkQoAYwfhOAGqhetrKbnx5u5Oz5bC+FVELW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760980982; c=relaxed/simple;
	bh=cl6ZY5q78pg3Ljp1UYhRMiRVMzXTUx1EWXOecbIQxDI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=iTRZcJru+9fZSqLA0laa9HMl1qev56e72YF2exkaWRKsPDdKALM+dpbaffWxVRskLyyemj3Q+qabE4pj3HEGctbJf0yLcl//M3mYnJNMtdJgTXCHCl9olTucVFCagEQlzW9XGUMBaNGwHAqBgosH8YLz28NABeEIV5jnuqZf51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FSnDrUTC; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b3d50882cc2so883300666b.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760980979; x=1761585779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTVhgxwa5kF4SMLkuMH7FPHkTbClk19tO6fpJDEo4Tg=;
        b=FSnDrUTCkW/yhgrHu1vFMQ+J4OBBpn9UYvPwntrdgfOKSmK/+J3cAhMyc6QQcIudvJ
         Vf1l1GowBDSjIMafJtnxJWOXByh14Y7uB4cJIIDRIB64eZGKDApD+DALDl5LIw4/XNEp
         Af4v3CsGOaUjRQgz21flBo/tducB/YUlDNcXCUzeAReMqy3H919kYCq+0n97OXTn7LRX
         zuYFILEFw9Jdnteq1LVPAeggHKl1meRU/7NylIshKgs1e58Qr7E0tkRpW7RU9fX3HSuR
         wLChlRAzKy2fAPnuejxnqeYfstU+dCXynl5/B3pyW7tsrBjDoQ3EUu0Tex1oeOe/WseD
         /W8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760980979; x=1761585779;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTVhgxwa5kF4SMLkuMH7FPHkTbClk19tO6fpJDEo4Tg=;
        b=bkruY+Q/qJMhS7P/fNcGjp+Ol/3fzi40j5zwCvukEeWIf3siE8hV7diBji+2x9YLr3
         FsBfwgX2RDfiWew7HftJSRo5Rf9Akhj9j4NmqZNPk07YbbBPNGJZi/hPcF1cpz6ajdYH
         6cbgp9KLsFPeu5NJrO17t49SxW3WFnCoxBoJP2Gfjw5cuMMFTndAggsm4Q5NP7Jsf/qn
         4oNf/3XoiKgIf+yiwhRr9WAUj/iyCFzxTpDiXPbp6BveC5wEqOGqCutraCRjTZyJ4mcw
         RWUruTTeQE5MnaVErciNwK+zA8vYD2hzqZc/ZGJ+pUlDVICLwOyN4tj5UlCHIOyaBY/N
         mq5g==
X-Forwarded-Encrypted: i=1; AJvYcCVOWui6gfeVgU9TK2plJb+LvNtZO+CitaqdzG+nMkt6fq+EtW97PopDbRX/4OGqGqBWjPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoYqRzus6VvHilJO4/uESyakwuZeBGGXfGddoXimvXDeCIsbBt
	VCbERE37D5oDvOlEiUVMNBbe87ubLlmhT0y/CRyoMfVsKVtgFRKlwVHY
X-Gm-Gg: ASbGncsqlbd0vOZ/DxoAXMW2o3hDqWOPh6u2cOuVQFRY3jTYXGB2v4UjYfSDV8HQScS
	EZP1oE2We/A8UIwuMyMzs6pViwkvqItvxxRrU2GMQ8TISaNBx8gFlRwGZ9vUBzXeYGrhjxnH9fc
	Bi1JXRdLkMb7OqVD6xyobKuQAi5z/+6fSuazqRzDnmq2XkpoOCKMZHi3erBlOhSqCKCS33ZJ7da
	lrxVUuOg/Am1TQdamM5K9mgNT3i99u8FkEy23zYUP09E/ZBrdn+ZTRV4gHjHXpmRUtblgQ5JIe+
	07lrQTA7976KmvC1tEEO+sEwoJOy3KnekZRvuyQaCBQO9qrRtmuXXLlJBQ0b5S0pJjxOceaKozj
	StzDXyKuO1+hslgPCRyc3L0eoyWD8SwFMjFpTzIF8qQI98eNBfgkUQ/U2fScdVoeTaujzN1RU0N
	erDkDKz6YLpU4oI93hioYCqdFS1KGIiTX0SME4n1snAL2RibjqOp0=
X-Google-Smtp-Source: AGHT+IHgt2qm8Q0ImpaSATgiIuQagmL40lRaChwnudjfSuEr0i1VvBZQPTFmi2bUV3ztpQ8xhTOQUg==
X-Received: by 2002:a17:907:1b10:b0:b2a:5fe5:87c7 with SMTP id a640c23a62f3a-b6471d4570emr1820808966b.12.1760980979058;
        Mon, 20 Oct 2025 10:22:59 -0700 (PDT)
Received: from ehlo.thunderbird.net (ip-109-41-112-59.web.vodafone.de. [109.41.112.59])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e83976afsm850054666b.34.2025.10.20.10.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:22:58 -0700 (PDT)
Date: Mon, 20 Oct 2025 17:22:57 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
CC: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_08/10=5D_hw/i386/apic=3A_Ensur?=
 =?US-ASCII?Q?e_own_APIC_use_in_apic=5Fmsr=5F=7Bread=2C_write=7D?=
In-Reply-To: <3de8cdd2-ffd9-4f6a-ab2c-fa0782310746@linaro.org>
References: <20251019210303.104718-1-shentey@gmail.com> <20251019210303.104718-9-shentey@gmail.com> <3de8cdd2-ffd9-4f6a-ab2c-fa0782310746@linaro.org>
Message-ID: <7E49458E-C15B-40F5-A866-F0CB7813D239@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 20=2E Oktober 2025 06:09:22 UTC schrieb "Philippe Mathieu-Daud=C3=A9" <=
philmd@linaro=2Eorg>:
>On 19/10/25 23:03, Bernhard Beschow wrote:
>> Avoids the `current_cpu` global and seems more robust by not "forgettin=
g" the
>> own APIC and then re-determining it by cpu_get_current_apic() which use=
s the
>> global=2E
>>=20
>> Signed-off-by: Bernhard Beschow <shentey@gmail=2Ecom>
>> ---
>>   include/hw/i386/apic=2Eh               |  4 ++--
>>   hw/intc/apic=2Ec                       | 10 ++--------
>>   target/i386/hvf/hvf=2Ec                |  4 ++--
>>   target/i386/tcg/system/misc_helper=2Ec |  4 ++--
>>   4 files changed, 8 insertions(+), 14 deletions(-)
>
>Good cleanup!
>
>Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Thanks! I think it would be possible to remove cpu_get_current_apic() enti=
rely if each local APIC's memory region could be bound to the address space=
 of each CPU=2E However, it seems that the respective root memory regions a=
ren't prepared for that and I didn't want to go into this rabbit hole here =
in this context=2E

Best regards,
Bernhard

