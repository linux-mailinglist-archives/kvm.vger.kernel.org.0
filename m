Return-Path: <kvm+bounces-16678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 602798BC84A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF8801F21050
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9A5127E3B;
	Mon,  6 May 2024 07:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="en+wlDF2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4B757EF
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 07:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980346; cv=none; b=qj9FyXwCzENpOpgpkLsUNGV0hOQXEVWc9ML0raQXiKtDZ+FVlOqDhMTjxbbeh4UjzCubj/PsSRPjZHHGvDerSC3MtV1Y4tuDZn6D0KKPd6AakUQWWNDEwmVsHvtcJBGafBZ58nTrSmbQFLajVv6+Dur8KcYpy6pF/yHw8SSCZX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980346; c=relaxed/simple;
	bh=Nc2g29Yqo8901HMBTMKNfdlsjbT+dYpNb5xKFeDNSok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3fYdRqjqx3OyGwHpOY4bYiFqcKwIrrHKRoBgPCeCfud0tuz2t3dFVJ47puxVrU1N7ZoSD0n4d1fWdtxvaZJ++ODPaZLFRfaM33ss52jndM3EqtROA5Kt0wopmT5kKKqMUGXUfRCbNypVK0kry+1Psxy2DRUWLS3FJ3p5cG+i7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=en+wlDF2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714980343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SZ0Aala6XBf0FrBD9ExE2XGN+wlQ/S9jAS2cHopSo0Q=;
	b=en+wlDF2WfZmHijDp6K4x8+lOKbNEHYmq5h2gmMQlnSbDocjPSQ7SH71cQWwEiGClbXyiY
	pMFba++gEhfeznmlRluuqldQ8Cy5ylyraJx/7Xn27k0cJbYFUkyNzvryEmINuF0FvPvlHj
	lKRl72tXoLJarBOWsOTRCwTPyq9YPFQ=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-fJxg51vVPsmAwW64iXy42A-1; Mon, 06 May 2024 03:25:42 -0400
X-MC-Unique: fJxg51vVPsmAwW64iXy42A-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-7f05639bf82so1483449241.0
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 00:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714980342; x=1715585142;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZ0Aala6XBf0FrBD9ExE2XGN+wlQ/S9jAS2cHopSo0Q=;
        b=EaLWUNRaa1uocdzzhQvk+E0wy2FEDwCtj4jnx8IE5uydziMgkH4xGGLdgobM38hEPu
         3naYFp4817p6EhQUrOxWpYwUEif2ZoeofsIr7u+be5zDWcRBbIYiKYeJKfsVvrHMGHI1
         +hG1Gr/FICeEoSki448yL8LBXYcWobEFMuLBVbyILpcU4xT0q1+2udwbQkpDwHdP2cKk
         Fno+bKOEPxxSxTjhRZjbdN/99rCUjUdg6M42GUw+cGzTZZ5gSQuv+p4wbi2+c+uY8m0A
         DvaYiei6owWoMAMYqcuSNeAktfIISfWGMh1YI0takRXGS+Lngl1+/TTcbbqnVZZmqfkk
         NxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9dtq+TVMYWZ8BIJSMBaT6Yeq5CjNxuJ/w51Shf4xf0pdeYJ+elgnrliBggCrNzyO4U7Bc+HScwr4w6MRrcnennKzO
X-Gm-Message-State: AOJu0YzThVB6091o4XDZeJAGX8jUU4CkiAwFC34fNVPOEmAtGr5vTv7l
	WxhxNGhzR541bJ7xPsbrM67FE7G0NzE3uYkT2jvj+FzEZRN9sirohz0xslwYky06GwUL3dFQ/GM
	6HH3flJADLzdU28ziJU4qBpwr0B/iMbQe9LQxdzB0HhNGuRUmgw==
X-Received: by 2002:a67:cd18:0:b0:47b:9ca3:e03d with SMTP id u24-20020a67cd18000000b0047b9ca3e03dmr11321213vsl.11.1714980342000;
        Mon, 06 May 2024 00:25:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbis0k2mVzbZ3JQqHmVCBLlJpUtAr0VgRaIB561EqwI92qR6A55x98Pi75o2ge8HOHAPFEmg==
X-Received: by 2002:a67:cd18:0:b0:47b:9ca3:e03d with SMTP id u24-20020a67cd18000000b0047b9ca3e03dmr11321203vsl.11.1714980341669;
        Mon, 06 May 2024 00:25:41 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id p17-20020a0cf691000000b006a0cc19f870sm3528402qvn.9.2024.05.06.00.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 00:25:41 -0700 (PDT)
Message-ID: <aed85321-7e8e-4202-9f91-791229ef9455@redhat.com>
Date: Mon, 6 May 2024 09:25:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 02/31] report: Add known failure
 reporting option
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Laurent Vivier <lvivier@redhat.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-3-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> There are times we would like to test a function that is known to fail
> in some conditions due to a bug in implementation (QEMU, KVM, or even
> hardware). It would be nice to count these as known failures and not
> report a summary failure.
> 
> xfail is not the same thing, xfail means failure is required and a pass
> causes the test to fail. So add kfail for known failures.

Actually, I wonder whether that's not rather a bug in report_xfail() 
instead. Currently, when you call report_xfail(true, ...), the result is 
*always* counted as a failure, either as an expected failure (if the test 
really failed), or as a normal failure (if the test succeeded). What's the 
point of counting a successful test as a failure??

Andrew, you've originally introduced report_xfail in commit a5af7b8a67e, 
could you please comment on this?

IMHO we should rather do something like this instead:

diff --git a/lib/report.c b/lib/report.c
--- a/lib/report.c
+++ b/lib/report.c
@@ -98,7 +98,7 @@ static void va_report(const char *msg_fmt,
                 skipped++;
         else if (xfail && !pass)
                 xfailures++;
-       else if (xfail || !pass)
+       else if (!xfail && !pass)
                 failures++;

         spin_unlock(&lock);

  Thomas


