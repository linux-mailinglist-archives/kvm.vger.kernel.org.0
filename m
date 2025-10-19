Return-Path: <kvm+bounces-60464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28097BEEE40
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 00:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 403313486B8
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 22:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD385256C6F;
	Sun, 19 Oct 2025 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nY3xDoqt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E054155389
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 22:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760913517; cv=none; b=Y+CaJK2OiPaUbD/YIZyvVE1MtOIWWjpUj/yXDzD8Sxa8YXTbsPzusdfeids80RVfl6N0Xz2PGhwnJNzFR1dSnjIhB5nys62WJ6aYYt7PYYpAo5hyI+LSjCHkSfGy0j06HcSCfTlMoiOBK9wP+aQpnoo/Q0bQ6Bq8KBgYKPAGRLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760913517; c=relaxed/simple;
	bh=TFjawUHYW7DaCMbhCKbZfjwNgQE2IITzJ1JJend3G5g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Fi8lX0dDt3x+2SsmHwDbvvgrP0nF+0bwT1qlxJQOn/A59nRYipq89jHA163VO/VKAA8ywg9TPzDNSUEBFrxgiQ7e5I45rewg3g/VNwEibENe0urfdJL6N5TJAmTSVuK3yyTSnN11UckRo11QBZPeybotgYijKIJr0f5QwiWwlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nY3xDoqt; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so690084166b.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 15:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760913514; x=1761518314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fUlR3DVhrkXnHMUK4SdPqCGl1e6I+hLWWy62h9Hp4c=;
        b=nY3xDoqtMpJwoK9L1JuN0akgDCZyIM2ZC1LgRp0KbJTSp47iF1u5gi5nuiS9iGstgW
         +3lLShpmauGXOkFYbZGvnKqczSkTB/HRCRr9k/IaPr/wHnMGUTOpI088+GPLwHwMayIw
         Ha3zb9nBzKqZu7BtmPX2pciBU66j78J2Bydz/Rfmfs+TDawQhesO/zkymwYi+sfJBfoq
         AKoUM7djD4hXxfDbAHBKqlMwriJ0JqAsA10CNamAR4/yFukvFmM1y8IT2KwSFaI6oN8Z
         MlROEhLn9Qa0ol1LJcq7ah+/hwE/lI+FI4F4pAkgfUzbjtoP3zQaJb4VWYWapiC/kUDP
         h/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760913514; x=1761518314;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fUlR3DVhrkXnHMUK4SdPqCGl1e6I+hLWWy62h9Hp4c=;
        b=jGkNlDppaQyxSwXzIsBAoWRBdUmEq+ChZuKxez8ZvkUPs+zkFuqXJio4eKQtxby8JJ
         FRTb1EMAR4VTzlI3OVqysjZcgsSvc41Kf6c+sPvyh8GEPN5IbVTziZSoy1do36FysagR
         ikWly68C/xJsD9sIaD7DiovYM0BNk+FR0AqNIKL6ahcRYL9wXxH9J+rToWMj6dCzR6eU
         0YKkecwogU+6FvaI6cHN7k8QiPlI9EMl0NH7OK3gUSCbr3G4vFh0GXvmuxvfAUmNxvZ0
         gS7lldT6xIxhg3FYR8X0EZ5cd7E8aPXcbgRhPVBMGVemd2EcjUmgQgyAN2FJ8S/Fe60+
         jYIg==
X-Forwarded-Encrypted: i=1; AJvYcCUfc/sdqzyPiPdPbuAG2euCe6YTECGDoSxsSsVU2djT/hHZ7tgWotInhwOI4T1hKZ10bt4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgWkQfMc3aTgA1P7inn7dTigj+OX/Wdb1PyQY7D6KIXl7yZFwU
	ujxxqWxl69C+Qef0jAEDSrZwAFPrDyvFlOKN/zl0Zr+KUHl/pTeaJBfd
X-Gm-Gg: ASbGncsv76ucyS/J0DoCcwkbajKRRiLTMy2Xj47LBaI0CxONbyF5RASt8/QiZ/cxGSw
	/fqxzQAXvEkMt2/XOKEnc0IHHUjuGux07eVhOs4RVhp539I+vl6Sy+xc97uzham9Lk9rkzUmQ4e
	gk9i05M+rS+fRy6Q9Ab/0fNr3JG7RUOfPdU5uPGTP/qx1U8+jgli+AiMVRbR+uuESYAGjZJm1g+
	lvwGFbMI/+FO5dKgZnHZEvS6pteALX3QU9UqzfE/TdAV89T+ZgZU+gWFReT3NoryW8agxvg2dkJ
	+WokLA9ybsdeX3BaMdPWQymRNt22++c/x9LxosxS+n7/u+yglhvZpeEswRgUoNt/EgwYE4TMdiH
	xCHdoPygU9Et5+qMHCKl3//KBjE2+ZjPKDujXgJmFnDDGcX76F3UyudXYZwPNsba1jay8aRQ0Ow
	68w6dlj51NOp9YPkqDtGm0UzQ2cYB2XrNvdxUSDmlZ9ohqmhy4VGvkbrlLeqZoAd6mRiH5TfFtK
	t5nHvgwRSelNPqJboUoHkA/yoh2Na06qIi681TWo9Ad
X-Google-Smtp-Source: AGHT+IFY1AOFnz3uKVjIXWfRbHvZOYANfaygBNZ6f59WAGxWoNrkwB1vfYiS+VunXq5N8M44mfer0Q==
X-Received: by 2002:a17:906:fe41:b0:b45:a6e6:97b4 with SMTP id a640c23a62f3a-b64764e2fd5mr1237253066b.50.1760913513550;
        Sun, 19 Oct 2025 15:38:33 -0700 (PDT)
Received: from ehlo.thunderbird.net (dynamic-2a02-3100-1c27-9400-31a8-03e5-9396-b647.310.pool.telefonica.de. [2a02:3100:1c27:9400:31a8:3e5:9396:b647])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c48a928cesm5246447a12.7.2025.10.19.15.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 15:38:32 -0700 (PDT)
Date: Sun, 19 Oct 2025 22:38:28 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org
CC: Roman Bolshakov <rbolshakov@ddn.com>, Laurent Vivier <laurent@vivier.eu>,
 Eduardo Habkost <eduardo@habkost.net>, Cameron Esfahani <dirty@apple.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, qemu-trivial@nongnu.org,
 Gerd Hoffmann <kraxel@redhat.com>, qemu-block@nongnu.org,
 Phil Dennis-Jordan <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_09/11=5D_hw/intc/apic=3A_Ensure_?=
 =?US-ASCII?Q?own_APIC_use_in_apic=5Fregister=5F=7Bread=2C_write=7D?=
In-Reply-To: <3C9DA9B8-8836-42F6-85CD-AB60327363EC@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com> <20251017141117.105944-10-shentey@gmail.com> <f074aed2-7702-4a4a-a7d5-7abeb29ea663@tls.msk.ru> <3C9DA9B8-8836-42F6-85CD-AB60327363EC@gmail.com>
Message-ID: <BDA99DB9-7585-4C1A-9B4A-DC07AE78EBE6@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 17=2E Oktober 2025 19:34:36 UTC schrieb Bernhard Beschow <shentey@gmail=
=2Ecom>:
>
>
>Am 17=2E Oktober 2025 14:58:50 UTC schrieb Michael Tokarev <mjt@tls=2Emsk=
=2Eru>:
>>17=2E10=2E2025 17:11, Bernhard Beschow wrote:
>>> =2E=2E=2E In apic_mem_{read,write}, the
>>> own APIC instance is available as the opaque parameter
>>
>>> diff --git a/hw/intc/apic=2Ec b/hw/intc/apic=2Ec
>>
>>> @@ -876,7 +870,7 @@ static uint64_t apic_mem_read(void *opaque, hwaddr=
 addr, unsigned size)
>>>       }
>>>         index =3D (addr >> 4) & 0xff;
>>> -    apic_register_read(index, &val);
>>> +    apic_register_read(opaque, index, &val);
>>
>>I think it would be better to use local variable here:
>>
>> APICCommonState *s =3D opaque;
>>
>>and use it down the line=2E  Yes, there's just one usage, but it is
>>still clearer this way (in my opinion anyway)=2E
>>
>>Ditto in apic_mem_write=2E
>
>I agree=2E Will fix in the next iteration=2E

I couldn't use the opaque parameter in v3 at all, so I needed an `APICComm=
onState *s` anyway=2E

Best regards,
Bernhard

>
>Best regards,
>Bernhard
>
>>
>>But it's more a nitpick really=2E
>>
>>Thanks,
>>
>>/mjt

