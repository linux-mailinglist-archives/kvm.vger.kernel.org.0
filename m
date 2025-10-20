Return-Path: <kvm+bounces-60489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D12ABEFF67
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96871895547
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207242E5B36;
	Mon, 20 Oct 2025 08:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TyU55ZF+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B32EB862
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760949093; cv=none; b=J4Fk8vsynkCbedD8639nHQKUVTp67QZl+k+QQhZTEsEK+iFwL6pAAe8+bh0th3+C0yWwcrJK43F5UJkF5fj2qs8PmZMjnYzJYANqmxSid0D+QVX591dBURBmgzA+9aE56yUIZNJUFvhG1erEAIlIe5Fvo9UPMvCYW7srH89s5vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760949093; c=relaxed/simple;
	bh=cYicjUyw4fyLwOO/HzjAc8wtZlZKk73qMBwKzQs0fmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGbe9CLqNs85DO89h3crXp22ikzyVAicf0UqTBaOGq3B/Bi4dZ8czzDIIF4hrwOm4YP6Xyx038BPjHCNaMTvNKSY2noZhS/tYZ7dFVJiCafe3svJuqZf1HGWG8mEIfRTr+2nqVafX8fV/hYl/PyJN6RDa+86l72UeE9zn7djuKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TyU55ZF+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f7469so31254115e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 01:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760949090; x=1761553890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kfk0zu0vmO9W22pWKATMNhqU90DG1WSCANu4coVqJ3k=;
        b=TyU55ZF+wEeLStpOQRAaI31tCJa0+Y2ZpobfWPuBbQX3CS3PGuzvPMbg6rfcrGyyua
         iHCB83+JFOIF4U0dZ5UH+xD1hE+p8zXBwY8Jj9jZgcImo8dBLDo0LYaiRTfaQkqHDnvI
         CupfnWxFa4n1SYs+yeedCdZqE7Ly1bRWZPq3GyPOLDlyD3mVG+D9xkEw6vl7c1yFrVkA
         x1yscgWGCQve85hVVatbZWv29oBTi+eMHjSlNU5cITChaLHuKU8LRkWJl15UR1c49hTJ
         jIHOV/sZ+uN8yTje4gRacftMOipRAfQWIl12XfvdozfZ+GryDohTnXT6xr3VNXSt1zdG
         F32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760949090; x=1761553890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kfk0zu0vmO9W22pWKATMNhqU90DG1WSCANu4coVqJ3k=;
        b=TtZneC+wptDckHCdJ2jOWAAGopOPpbTrqBVA3qivXKlHgu7OL0B5kGDD21JbJ23Yd4
         ZwK0Gs9Z91k013w2b+XjW6zAu5KFkSMunCE/cKLz6KBcMKErhl0z8wMCAoyczkc72oOW
         T9ukwrkeQLYvuU+X29ypXcznmj8SeMtYIKlj7evGmepe7YEb1IBVsgKRXmja4u+s38SC
         djSDG0E/FnMevXmKMn1xcna/uBSbnxE95xfZaD1GU/bsuTDXwtXOarF3tRtsHDjYBexQ
         7VdVxyRmHMt6zh/xwYKVMLBd11gEdbeURYYxeV67HnA35wU6wvzXKDY3KSlk2es+Ta8G
         rkKg==
X-Forwarded-Encrypted: i=1; AJvYcCU4PolWaZ4b3Powd+FU7OYKXXTVeJYGWb772JZwtl0/A2sPyV1vCcxF3RPD+oI4B8xk4Tk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1T0epAkA3ZXTsA5/f3Cz4QERqc+HMrIogqnglYKGy48An2L7z
	HWfuMu16i9uWmk7dur6YPLkuTJPb8v4BOt3t8+kfR99TqAkRFLDWfnJjJI8XZIpgi8U=
X-Gm-Gg: ASbGncu4o3ZxwcRJwpLtYcWE8av/oel5wkbi7hGrUGKpjJU9LKgS2qAKgTYjbFEVsYb
	X/slIajovS7NxQyFRPhx/xLBEXOUsQ7V0oNoNIOqA2crTTYS5katGY9OQ10o2dEOeayhfrjonxm
	G+8hP4LPfQUbkTlRM1kXN+skXj0tteet3RIWu31ALQ6rdgbXlkUlu4puICQxNK+aWV4S/4WbBHm
	Jq3YMKQHftUCaQEqbw3r0W8B8vYKgxiqZKnh1UeGYUKwbRMEUPfETO6EHbepPfDTqYQ9PgOvhOG
	qhuonV/jMbAD/UZFhNnibHn88sc/EC0ktVNATUCggoHWVquReyXAYjfb3UhCvbM7Yepj9OCi1dC
	7JVopA8XPl5wYJbGo9s64ayoyzSm4n2DE/38AMjPy3rg1UXl9rxTQxIio3uiGsnzTs9A1lrYVA2
	vbsanfgSbn/jhElMIxVJN7copTgh0OuDMfG+uwXtZJxBseJJEZsPxr9A==
X-Google-Smtp-Source: AGHT+IGMZtfmBcTewqhPn1UIg+L75Wku84JXFjnzM4sfO50VVAoNSP2FKvx8EcGUTSa8RrcqwmTWoQ==
X-Received: by 2002:a05:600c:524f:b0:471:115e:624f with SMTP id 5b1f17b1804b1-4711790c2d6mr85823025e9.21.1760949089797;
        Mon, 20 Oct 2025 01:31:29 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b6dsm129861005e9.7.2025.10.20.01.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 01:31:29 -0700 (PDT)
Message-ID: <4f8a640e-d1ac-49c8-8b14-743d248a91e4@linaro.org>
Date: Mon, 20 Oct 2025 10:31:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] hw/timer/i8254: Add I/O trace events
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
 <20251019210303.104718-2-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-2-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/10/25 23:02, Bernhard Beschow wrote:
> Allows to see how the guest interacts with the device.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/timer/i8254.c      | 6 ++++++
>   hw/timer/trace-events | 4 ++++
>   2 files changed, 10 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


