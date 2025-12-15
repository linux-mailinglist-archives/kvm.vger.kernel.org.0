Return-Path: <kvm+bounces-65971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B14CBE707
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 643E33014DA5
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FAB02C0F93;
	Mon, 15 Dec 2025 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d9CUk2Jo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2hu8zjn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D343C2877E3
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765810355; cv=none; b=XYMeg+iytg/avlvMOUJN2qIxixyUcrQDZ18M9kwhXs2IjCvBKG3F5bB45iAzvhZOMECI3K6oexZEQjlleRoqU6UlwYhfIkDuAISfzqVhsHg8N/2+Cl+1nzpmXbLMZzHXYbm8uw3LZvpAhDBPBKsnjG33fRHixmivT59g7+dvoO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765810355; c=relaxed/simple;
	bh=Y1gzUkvbkzAczpe9qs/qnyxMcUt4gusMCLAwKCwh8I0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQfJ+2E+ZESdfUNnpTuU82A0y+lkx080rQeLw8ymSds5/H8KrPUGD70tddSWkicQQMADJSXLE+vi5U9N0e5i5vpbtIdUe1hEpth5k0kdcgy/TroM7iC+7is8hEC+JVDruhgW8gjkOvRR9gego9aj8VMcR9yTmMQipCKX4/cwz1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d9CUk2Jo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2hu8zjn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765810352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zF8JgN4tWbVCAWjS2x+UG6gULrYPoT5c49LyU7Nv77s=;
	b=d9CUk2Jo/ok5gs0BTzfaUnfPfgdOJXoibSODuPe4eACCa0OjLkqSL4OI7H+i/VIxX77R6S
	IhVOGml3dnt3xT3egy42nIVPv81mESr7yEpfbiLutGHCk+hUONECi6W2wt2sm4bgysHUxw
	VgXTi2xR3ySg3Anj/sDc6bpXhF8uVjQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-QyxzUixtMHWE9xeU07J3-Q-1; Mon, 15 Dec 2025 09:52:31 -0500
X-MC-Unique: QyxzUixtMHWE9xeU07J3-Q-1
X-Mimecast-MFC-AGG-ID: QyxzUixtMHWE9xeU07J3-Q_1765810350
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b73720562ceso362397066b.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 06:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765810350; x=1766415150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zF8JgN4tWbVCAWjS2x+UG6gULrYPoT5c49LyU7Nv77s=;
        b=b2hu8zjnuslfpOYGqQCPxaknyyFt+fllolx3Nx58qggOby0UN/yksO45cv9KWhwxTY
         +oJNKFx7sB9yTN4GalvzOohKp8Lug7eSO3KqtGXEVs8VPSUYaR7IvPsscIRv3YtMJyrn
         lxcdaM3BddCpEbjMWbj7zklZzvKkcFmBEVbjxk9nhux1/hthvOwbShS4rPIfCixq1TUp
         wV86cOQS+YxtUMNXgbzDCQQEWIzwl9ADf8M48FpaS0JNVDXy09SyDgnNrI4L+SsPP0Hi
         bjtNgNY0pfU4lSfEMOM2XyZdKfdTLPiCRsbUG9LVNkzfjZebWCb1iUa6bkOoBtR2H3af
         PqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765810350; x=1766415150;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zF8JgN4tWbVCAWjS2x+UG6gULrYPoT5c49LyU7Nv77s=;
        b=ftKQU+sX2ImPbLiOKauCzoWb82m+QxEUxm8MUZgY/1dIVSdRhOLKYFgr4d3BEhmCko
         dhRmRsjvF8cywYuDUO0+rFlw3CLl+8hULwpP6D7PpaQpBPpLayoL22krIhdT+Y1p4Cx8
         OUrhG5TrET5/WGmW3BX4/qKUnki+8bqljH7DixwH0rf6umzddPvBbJfebsdJXECu+C8g
         z1RdQpdsv0R68pis8yAg9YjNbVPnRka4+yXMAhAuaANbxLM7CorTMIEeclA0d4rjE/dw
         4oSc+ndcIILVnPGF42YmalGfqmlNFmo0++tSGcEADxowE+zYtJClXWh926nUtBOcOoeg
         Ov4A==
X-Forwarded-Encrypted: i=1; AJvYcCU1rn78rL170aKl2S8NukPUAfEIRPkouG7YbzAPDBA+fgjTKWJemxnR7VoPc5b3ES4cUP4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU9IGnZvWsCxs+LrurbzEf4TlSBmpID8U0XLRIK6/zVIN+w8o9
	brCKkhrfmftw6YFcGtm1mO31c+Y4jnrfK8vJFirAAjEwttu1XEaUKFEULBb0FrUfJX1TQdHeVsG
	0GYbW+SmyVs3AVcKAVzdZg9MUZluKqHwCPJkIhZZs3DNcPf69vP/F3Q==
X-Gm-Gg: AY/fxX7sAR0pjb4lMbm1VdVqeSlNpqqES/yp9oqdfB/zVAbNxZ93XpOZfFvYytOSKB7
	cobE0rdYkZLPF15ss10yo95FX9b3qBeY7VVImsFIhPsyyCdTkUpRb+TByWXDWtri7YbXwRizVB2
	/WRTSiDrm/vLiVYU9PrS34b2N1Ly96Pbsib7MvQwGMM/QApBVCLlZnKj2yysqob2owwtwBVP+oY
	Ve3rS9MEXKOeh8wjGLdc/flV+lx6igdwhZ/Ttc2NJYwv3DtJRHBFaOVu/VYtjBdHgsqwXfKSzDt
	CF2c6gD7am3yOnr9sfD1mmKKuTN1v7XCl11kJth+XG7pPfhBWEGJ4Sm2xoHAvr9hkErcb9BB7o8
	o8AXpUR64owRo/pd/QqVCyGopzfWLSjr07cdlAARh/zvqKQwcACWOX0BFIZEoaHT8SvbIBceuOa
	kYHd/3EfLdpKqj68w=
X-Received: by 2002:a17:907:2d29:b0:b70:c190:62e1 with SMTP id a640c23a62f3a-b7d23ad635bmr1137591166b.35.1765810349948;
        Mon, 15 Dec 2025 06:52:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHn8J0an9IDgB1tsnPyFoLwVTjx3kNnmLGSz0vmlk7BO5WUjHzTh7WRzivAGmyoQORHhuQEcw==
X-Received: by 2002:a17:907:2d29:b0:b70:c190:62e1 with SMTP id a640c23a62f3a-b7d23ad635bmr1137588366b.35.1765810349548;
        Mon, 15 Dec 2025 06:52:29 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b7cfa2ed80dsm1416551566b.16.2025.12.15.06.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 06:52:29 -0800 (PST)
Message-ID: <b6f193d4-b780-439a-80eb-bb8b43acac4e@redhat.com>
Date: Mon, 15 Dec 2025 15:52:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] qmp: Fix thread race
To: Marc Morcos <marcmorcos@google.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>,
 "Dr . David Alan Gilbert" <dave@treblig.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20251213001443.2041258-1-marcmorcos@google.com>
 <20251213001443.2041258-4-marcmorcos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251213001443.2041258-4-marcmorcos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/25 01:14, Marc Morcos wrote:
> @@ -346,7 +347,15 @@ static void monitor_qapi_event_emit(QAPIEvent event, QDict *qdict)
>           }
>   
>           qmp_mon = container_of(mon, MonitorQMP, common);
> -        if (qmp_mon->commands != &qmp_cap_negotiation_commands) {
> +        do_send = false;
> +
> +        WITH_QEMU_LOCK_GUARD(&mon->mon_lock) {
> +            if (qmp_mon->commands != &qmp_cap_negotiation_commands) {
> +                do_send = true;
> +            }
> +        }
> +
> +        if (do_send) {
>               qmp_send_response(qmp_mon, qdict);
>           }
>       }

We cannot use WITH_QEMU_LOCK_GUARD with "continue" or "break" inside, 
but we can use QEMU_LOCK_GUARD:

@@ -347,17 +346,13 @@ static void monitor_qapi_event_emit(QAPIEvent 
event, QDict *qdict)
          }

          qmp_mon = container_of(mon, MonitorQMP, common);
-        do_send = false;
-
-        WITH_QEMU_LOCK_GUARD(&mon->mon_lock) {
-            if (qmp_mon->commands != &qmp_cap_negotiation_commands) {
-                do_send = true;
+        {
+            QEMU_LOCK_GUARD(&mon->mon_lock);
+            if (qmp_mon->commands == &qmp_cap_negotiation_commands) {
+                continue;
              }
          }
-
-        if (do_send) {
-            qmp_send_response(qmp_mon, qdict);
-        }
+        qmp_send_response(qmp_mon, qdict);
      }
  }


Let me know if this is okay for you!

Paolo


