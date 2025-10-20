Return-Path: <kvm+bounces-60479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 758C0BEF699
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 29ACA4E6652
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53A12D190C;
	Mon, 20 Oct 2025 06:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BVyLvFnP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E441DE4E0
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760940567; cv=none; b=mH0LkOzS9HXwstgm7FC67oOTXl9ExqoMGTZjbeDUeFC1LhhHE6hIqZpYBQUuUzuyQaRuYrXUc93tg4la8DD26JESV50RS7A4/+aCTfZ9GQVJ3iPUOPVAnbjGI6YyPQJHpKrcVFgN05zbU4Xrrb6winyF/nynA568RZJFOcK/ikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760940567; c=relaxed/simple;
	bh=K07z7IQuUy3xSlk3DlaIRchekKzbk/TwcGeim4FjTlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqfIHJ8uFi7j9eC8C+aSICyZlXpdnSHzo1ksmI10g7L5yHaZS6RN5eP7jCylwkblXwNpLGimlds6XbIz+JmnTeiVEyq/06oVTGjr0ka0zkGmFD5trjbR1p4qzKi706HPnpwBjI9SxfcI6APkY6Fi9JhET9pr6zKvScIeMt3G98Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BVyLvFnP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3f2cf786abeso3018910f8f.3
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 23:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760940564; x=1761545364; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xK3vQr3w7c2275t0XHP867DUAg+tgBdfWMCxjmYkzF4=;
        b=BVyLvFnPemSkvqs9Mqfi6NB0wGd7bfKSDT0Cdy5CYbUI/1X96IEP7ok0ml3zoR9HmS
         ht6/6vVzOhXPkyAcJlMjH9+eIAdiKoaCcdRQfmHnxuM2/QFB4KIUTCE30w9pIzgRhfHc
         zg9YXSNxyBdzQKrWTsnmNuT46CgSkFIXKgOAO2wqlFV181bhfyN+ZkpGxXSs7EHwgqHM
         wcSb2fj+6lgqnCLjG9W6joK5fDm16sANCOPfwEFB+Z+t7RqI8kYUJjXAHVixSmOHVsrf
         pxVMPgYFHUOPhnYqFLO/CktNcp6lhjwLhdVc/sGsv4xCVg4LEZoPTWx2UL4QQMhT+Nyw
         nsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760940564; x=1761545364;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK3vQr3w7c2275t0XHP867DUAg+tgBdfWMCxjmYkzF4=;
        b=XJESLgfsjbfDs7V+PArYkT0mREH7HrLSUYz+HriPCuwMNlDIEgMeNGn4W3ZHbtgjbp
         INp8Q1GlFpc/mhmTfzDq/sjBmalWxpnpRQ/+EMHmMFliDpc8hDQ1ak6DpUoq+8vQOxuI
         XH56jfKGks4Ip32DpMGRuurQjO4jpIZ1ZKutUJVS7fesTPQGUCOrCwoVgg9D0xpFhgna
         Y8LcPaI2l+VXbbtlgsdgIA32G/QdgKIvoHVpr/oC92Siy4k0r+comH5a7lCKyqhsEa5v
         lk8cR14Q16B4pcN9nKxmIxjnqpurs7ipQ8Vbo6x9BeY7Y3YABksFjt264S/GTVS95Jde
         SzPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8DRMi8nl5iJp2Hsi/O2xvxIRDSkenHonSq6TIGpdyyuKedTCdCawgjsOyha+GX7hPKA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0tLpfBAR/PlrXeGgERjNCLuI87flJt4UWikED77w39glSU0Zd
	1nROWw0yjD/Ks0KdWCYKRmfejQ2UhNtHMvUTGRVe9wrRO+L5/U9mQBTy/vcGKs85TYU=
X-Gm-Gg: ASbGncsVZMqgauj1SOgroLXGzx7e5EPZQ3QK+aSsKTroKYfKWROUFzqTvIvQ0MTzYLt
	fs4ZGAFlEzSIO66jeEvLZRc0eXo+cVAcMGojJ9U7/Fy4UrLTdYNRu0rLaSndU55UeGmuGWAVHjt
	Zk89XKlT7pX26ICO0+i7BZn0HyYJt/waC2T8gbmb5Cx4yDVXQ98m2pjGAXFu3vogvmxIl5u4/J0
	mq8l327MHdv/tqEtZdeKD2fxnbjcgeRQYhQB3XLPR7dvOcLM4YRrKYXY45HwHZppdbTOLqqZOlV
	ab7k88akdmlRbvwZ2JDMxTOUj400WuPUaDPMNcK6tFYniRLYtuZlBk0aCu0nnpdI/sha3UbyHjS
	gJrASLGTa5WT6NdhtDf29A79Wo4y5fY5sn6mtgCl24oo7lq7GOo3aOJCJa0N9ld8c2cQFgsdTQ2
	eyPp0xZXAodSdar3ulk+nWwQ16s2uqi0QiBaCqV5KRih8=
X-Google-Smtp-Source: AGHT+IH6aE1/9mNQVtfezNv1vXAOqDvkNrJ2zXOqGMeA57yHsWkWEwgHEm6EoTlGntSTI5kGSeXAlw==
X-Received: by 2002:a05:6000:40ca:b0:427:a3d:71ff with SMTP id ffacd0b85a97d-4270a3d7470mr5688361f8f.58.1760940564209;
        Sun, 19 Oct 2025 23:09:24 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0ec2sm13357109f8f.3.2025.10.19.23.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 23:09:23 -0700 (PDT)
Message-ID: <3de8cdd2-ffd9-4f6a-ab2c-fa0782310746@linaro.org>
Date: Mon, 20 Oct 2025 08:09:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] hw/i386/apic: Ensure own APIC use in
 apic_msr_{read, write}
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-9-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-9-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:03, Bernhard Beschow wrote:
> Avoids the `current_cpu` global and seems more robust by not "forgetting" the
> own APIC and then re-determining it by cpu_get_current_apic() which uses the
> global.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   include/hw/i386/apic.h               |  4 ++--
>   hw/intc/apic.c                       | 10 ++--------
>   target/i386/hvf/hvf.c                |  4 ++--
>   target/i386/tcg/system/misc_helper.c |  4 ++--
>   4 files changed, 8 insertions(+), 14 deletions(-)

Good cleanup!

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


