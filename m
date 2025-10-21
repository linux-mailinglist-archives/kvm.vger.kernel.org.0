Return-Path: <kvm+bounces-60686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 344DCBF7967
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 369DD19C2C47
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A922345CA6;
	Tue, 21 Oct 2025 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O10TesQP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E14345745
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062834; cv=none; b=gOU3JKvfcE2F3InnYd1zYUuZ73IDrwgsoX1hDHWOtUboHk0hYaeb2RIZzhF84wakCl6v4NIk6RchFxp8/E/gPiUpjulfEoiEvW0qYgCA0qCjZuj60WgtX5/vdlP79+hSa9SgEY/GS/EfxY5JTfULSgVaqezvIxJ5V8ryUTHuSBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062834; c=relaxed/simple;
	bh=Ry8B9yHOSQxnrob11FMWk79nZS24GC+S8iCX+A7ay2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oN8JgYyCNkVWlDV/P72w3sdhAJOhas1k67n5X6EEgeHOdmfj3UjQ34+0x6+078yReVodjrZjujSGL1uE1pGoHiFmGMiT6suHWzscen8zXadm2Bs2ilob6zo6AMd4Y4fSIqsXYDezktlTach0OftMYHeHZdqQCxTdQsiagpOzp1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O10TesQP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e542196c7so270755e9.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761062831; x=1761667631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S3XDryUWMlktinWjMVeX9cwrrbFOe+BNaPX4vRirTnI=;
        b=O10TesQPsVx4Hgbo318+SecuNnqr6I8z8JmITKLO6Bitc+l5JAMuBKt3Ra2Z1Qxwbp
         rfW8tbedXpwrPT1C+F5bgVnEBDYD3AzA4XPeoExQ2ZzFZeOJq6swDHUj/iqw0Joqf27m
         EVgjFrqk2D1PY28PK5fbIfZZOEK9JvBy6ISEw66tIMfZL/94rMW00QDHkIRNYfThs2UR
         Qy46ya7JbFo4odxEoeuQJZmuMf9/0fJnE1chIb4IYXdi4e7ChmhotmneHnBAQ2OpdySI
         lno/ciAHcNUEH74YNcLP3i1MYiYKsNbpkv1lQauR0/zb/XlgXgIIiZo1xeZ8g+3+xSEH
         54dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062831; x=1761667631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3XDryUWMlktinWjMVeX9cwrrbFOe+BNaPX4vRirTnI=;
        b=Xxr+TyDXwvVjJseylBfNbWx4fDOcwtY1+1h/RZcQUlPDIA3gcplhFTZKHPqi5BsyKZ
         ctD3EL820oslbAmQFOCPdWQfgS3Rbmt5O9r22VdkCzN8Z6zjXfzZh9w80c/+QnV3rYrZ
         /YP/1ULE2a1ouBmFqn80cvwS0mDYu8MqpzuIDXTOPkXsqEfu1JR6JJ8jn6rLECnWFeqh
         xG7m1tNWRf7/1sEWwQWXNby7kXSXH2LtNJpjQ9h2SFHyYyb9zLwe8OBfA6CGJnE/brXI
         X4XvcVwNBNYrcK1mug+Ec/WRsbkghScJUnFsj09tU5cZA+16BlqnZM4YnRVJtOmYDnk+
         G3Ig==
X-Forwarded-Encrypted: i=1; AJvYcCX+Me+wHGn7jqpIq7pPLSfjw1jxs3S4rxt6y3YkwNN1jKSV30DvQd3vrasdrBQ2KpMsSOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj+rsyID/EsHnQflZy+MnHUVk3efeTyNVIFEVVW+bUbJFlBwvC
	kiShQfn/D+ShmiLO2iL1JxTuyuGVR79e91dLs4FDcuvdSc1+3UHg7ejIWJdabkpNpdVTK4jb7Zc
	s2AlRPnE=
X-Gm-Gg: ASbGncv1exu0a6HKjdEH5OOuEco8iccPWU6HH2IDTmQYKxeEWRDYgR2hvUGrpWUlvYD
	a4Bms5fkninVAt94JPcAwTmlB57fQG3ovd6Zst2e7QXHbwnz9yDGbd7f3K544bmD/3+qqudpsUd
	++pli7Fqtb4a/ENqFvfUQ4Fyn7Iexqqzw2ACJqj0LG+R5CsgWfVnf51onaNp+XYZCncu8Z8rw82
	J/A8E00ky7qe024Xw6FjD8HNHI8HtVJ2h1HlgKqjOsXWr/McNnJYcKCyOvPGZB64kp3xyue7mnC
	5Z+Is0NOumSCKxhS3YWhEQK9vOWhcooMHvP3mek1k+JFXPvXjJ0dkmuJlAZged44JB1tq5FAc1g
	XYo2KvaWWtM3+8XZiSIoTOeGcQrPVVGUgZ+2wob7eNIwu+l+F7aPvS5pX/P4SWCZLexN8jmxgSB
	PiLFYRzfVvd3kPM2PdLP5GI42B8TFmuoiuNDkpkt8lvgCKaspKB2Qk6w==
X-Google-Smtp-Source: AGHT+IFTSxHOXBG2kQtyhLaqbkDJvdPVxrFwI3mIms/IDe5YKtq/OkNzeBFJx+Xy+94fCe8ah5JL/w==
X-Received: by 2002:a05:600c:4593:b0:45c:b6d3:a11d with SMTP id 5b1f17b1804b1-475c3f96e87mr1589135e9.1.1761062830808;
        Tue, 21 Oct 2025 09:07:10 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494b22536sm20411435e9.5.2025.10.21.09.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 09:07:10 -0700 (PDT)
Message-ID: <0e7af78a-6156-437a-b76d-8453898a5b57@linaro.org>
Date: Tue, 21 Oct 2025 18:07:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Cleanup patches, mostly PC-related
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/25 23:02, Bernhard Beschow wrote:

> Bernhard Beschow (10):
>    hw/timer/i8254: Add I/O trace events
>    hw/audio/pcspk: Add I/O trace events
>    hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events
>    hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
>    hw/rtc/mc146818rtc: Assert correct usage of
>      mc146818rtc_set_cmos_data()
>    hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"
>    hw/i386/apic: Prefer APICCommonState over DeviceState
>    hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}
>    hw/intc/apic: Pass APICCommonState to apic_register_{read,write}
>    tests/qtest/ds1338-test: Reuse from_bcd()

Thanks, except if Paolo/MST/Igor object, series queued squashing:

-- >8 --
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 67ff52a8b40..d981ca05977 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -29,2 +29,3 @@
  #include "exec/memop.h"
+#include "hw/i386/apic.h"
  #include "hw/i386/topology.h"
@@ -2352,3 +2352,3 @@ struct ArchCPU {
         user */
-    struct APICCommonState *apic_state;
+    APICCommonState *apic_state;
      struct MemoryRegion *cpu_as_root, *cpu_as_mem, *smram;
diff --git a/target/i386/whpx/whpx-internal.h 
b/target/i386/whpx/whpx-internal.h
index 066e16bd8e2..2dcad1f5650 100644
--- a/target/i386/whpx/whpx-internal.h
+++ b/target/i386/whpx/whpx-internal.h
@@ -7,2 +7,4 @@

+#include "hw/i386/apic.h"
+
  typedef enum WhpxBreakpointState {
@@ -46,3 +48,3 @@ struct whpx_state {
  extern struct whpx_state whpx_global;
-void whpx_apic_get(struct APICCommonState *s);
+void whpx_apic_get(APICCommonState *s);

---

