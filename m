Return-Path: <kvm+bounces-59270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF889BAFB4A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EF031923B0B
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513C4284665;
	Wed,  1 Oct 2025 08:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FB79tHok"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA271E3DCF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759308102; cv=none; b=dmP7cWqe9paRgQWqr7ZPfl5wlyvuqV2epXcSmTyo6zmx/b56lx3geyx0mvSsDtuVDxWSG/ggzoHz1+ydhT1quI+6iLzGOCw+b1nM8oLnbTpMnaZtEPsXaTX5I6LR0gkr6r4U2V0spXPLl70AH1tL9hxTxFwdMixde7zPEm44oSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759308102; c=relaxed/simple;
	bh=pt+nZvnNhIgZZp/HZKdLK+QnZ6VP3XibZuLZOYSJVcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cq53Uc5HLklnfI8Qid9PJC2CYluukGzs39DudCKdnp0rzSBHf8jsaab3Brx1YjlLZOv9GC6Upm6a6CxwfL+LboIaOQ3yX02zzIFQQ0+oxC4+3XoMxQILxj6rc5FfR9J3zOJGL/Ok+Gn3h+5TGIH33SFYXynDThXjJ/I8tcvOt0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FB79tHok; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759308099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OoxPbfNPOVDhTmTUjEeR9wPvseI20Xeikoc5bFV+ZYg=;
	b=FB79tHokiUFQfUaj6WQBtTC1xgpiagv32dBIZh1eIH+QCM9Obx4IG3CTKITLNB4NxaP3hg
	/wJOSMjqmF/jR8I7JiG9y/Zy132bn86wQRZumX/gQEcWnLOciq+fbyB2VASPGlhyktTEUo
	Q5OmiQFOeqyyU6naMnsRB5hIHITqg4o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-4dmfS0WqN0qrXku5VdsgUA-1; Wed, 01 Oct 2025 04:41:38 -0400
X-MC-Unique: 4dmfS0WqN0qrXku5VdsgUA-1
X-Mimecast-MFC-AGG-ID: 4dmfS0WqN0qrXku5VdsgUA_1759308097
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e303235e8so50893905e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308097; x=1759912897;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OoxPbfNPOVDhTmTUjEeR9wPvseI20Xeikoc5bFV+ZYg=;
        b=sA2Fr1PlBXNdpOeyrXXWwcECYaogc9UUbKAkxbkkZ+SDfrxoCKnsgoJEaEu9+N8WLT
         0w+9RnU7XE3SuukocQy9kVgSV5HdlCUgTxcJ4c10qDZP4XWqotkTc0UWxkMM7xVxnGXw
         w+ns8UQ+mbEkQbzyTrmNJzP11Aj4r2RyxlJNS5l8WHYpM6Hyw+h06ZymC9Nfopy8HWOQ
         Z51spgzkuyZq9jo5zksS8P+njOoz669I4eMBmMETZV974onr7qGUeppu+Um77ZtOAdBZ
         KY92TWEga151mm90CqUrGx034767gkWIQq2jkh/lIZwkGTpFWbsQ1aEo4gA9a9MJFzVE
         XWRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn9OtL2FLd4dGcmprvbOxzdtGHywdgiB4JwDuNfup9oDxEnXbOTbQItRNsyqiYhTc2Dzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YysNge4PoLp5LP5YfytOdhY8330JHyCvyVEWE7hLe427Rn+RrnB
	AUeFUx8AhI7n1F4xojYBfpJWVE+F2KR3dE4eej5fSsLnCCWs5vKLY7Jbzq/NRr4CQz3RXrPlRao
	+ORaPe8CjS5VBsRnvg9tFZFJkFl26uhP5qNaCU/uMci+6pxDDySH6kA==
X-Gm-Gg: ASbGnctIdIu870Gnwi0/ClpuqCgI6J4tcBbdjYVbBwc7zMwmSH8Ren71Td43uHGfcvH
	Ywmzic6B0VvIsPXTRCF9bnakBW1wjuq+KQmyyiuQyPaLukRtiuxRQH3r9OqMcRnIbTLTVCU7Aqb
	D2xqEje/e8/ln1j24TPu0bzTo1ekZphjtqn0kOxrMXafgBBeI/wDJ61+nY3h7awW5bjW7WnFLha
	dcnfvVneY0IXd8hlG0U0GTqFOY50oxNEeIIEl2WWxhxEXr1yRiJVY+/ThrShD+/glN6kfBWb2qe
	ZEuR98v8HnJ/N3acXZUrPIuAfLTw+Akj0sVMlMRD+79zeQQ6G0VzmrLugzGjpsAQU4IaZqA=
X-Received: by 2002:a05:600c:4e52:b0:45b:7b00:c129 with SMTP id 5b1f17b1804b1-46e612e6f9fmr20481935e9.35.1759308097326;
        Wed, 01 Oct 2025 01:41:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8QJAuvtlCsccWP6Z3nHhGp8ri9bfmSgiuHkBCRTAQ5VY/+kdMyl+7997vo9nNzkJh4eB3wg==
X-Received: by 2002:a05:600c:4e52:b0:45b:7b00:c129 with SMTP id 5b1f17b1804b1-46e612e6f9fmr20481615e9.35.1759308096925;
        Wed, 01 Oct 2025 01:41:36 -0700 (PDT)
Received: from [10.33.192.176] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602eccsm27512661f8f.40.2025.10.01.01.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:41:36 -0700 (PDT)
Message-ID: <07c0b947-8a17-4efb-a0e8-0f17ab70021a@redhat.com>
Date: Wed, 1 Oct 2025 10:41:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/25] system/ram_addr: Remove unnecessary
 'exec/cpu-common.h' header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Piggin
 <npiggin@gmail.com>, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 qemu-arm@nongnu.org, Jagannathan Raman <jag.raman@oracle.com>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-ppc@nongnu.org,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
 Peter Xu <peterx@redhat.com>
References: <20251001082127.65741-1-philmd@linaro.org>
 <20251001082127.65741-2-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20251001082127.65741-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/10/2025 10.21, Philippe Mathieu-Daudé wrote:
> Nothing in "system/ram_addr.h" requires definitions fromi

s/fromi/from/

> "exec/cpu-common.h", remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/ram_addr.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
> index 6b528338efc..f74a0ecee56 100644
> --- a/include/system/ram_addr.h
> +++ b/include/system/ram_addr.h
> @@ -29,7 +29,6 @@
>   #include "qemu/rcu.h"
>   
>   #include "exec/hwaddr.h"
> -#include "exec/cpu-common.h"
>   
>   extern uint64_t total_dirty_pages;

With the typo fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>


