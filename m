Return-Path: <kvm+bounces-19757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D018590A6C1
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5276B1F24BE9
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 07:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A22187358;
	Mon, 17 Jun 2024 07:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="hzdDpVN0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8990012B87
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 07:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718608565; cv=none; b=lUJ1lafl0FMRbIIM99KQ/ShRtIrnQJJF6/c9I6gQwQu7RMZ4ryS7wYLwRxGZ3Kgv86c9X+RPmsn3l9RSqVBP8R+p/60VoeztFzGqf/6Zq99MwvE4bil33I2G/k6WnczsXDNiyD6JwBvYWj36q/iyP+tiS8OagDiylLZafJthNKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718608565; c=relaxed/simple;
	bh=cuDSBdpPdzoRMpfLksgkThnD0jKS0PgMjGok1vgiGpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lY6sXf1mcR9F77iQNX17htfeECcZoBzoiEYs3LPyJkqgjviG6FIcPmAl+JT8DQDHU2WBgFRiVPSM98pmP3q072Oxv8mnFnWv095SQvqiaVyP1J1BqLc42aBflcsC8ylMG+Z/i1DV8dsCBx3h/qPfh/aB4Spf1LGwaG7JcSszuGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=hzdDpVN0; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57cc30eaf0aso1496461a12.2
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 00:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718608561; x=1719213361; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QsFvZw6+tVhrenFtiZxMq8S/1O3E/Vsbhy2LABani3w=;
        b=hzdDpVN0bn0lPO9whpDC/On8pl5JzOBALWxq5ung5ZMoX4zhIS3VO8uost7xKSYDUB
         oanblp6IRdDHtDYs8+3AcKc8xs/zshFsM8h1UHkXAzIsn8KNug/OY7kXDueEHYHtOEtg
         O9Nddodr+W8PLxL5oKJrrIkP5qi0lh2qOjNjIFdLkjZUFc6G8nDmt/fhVx19eYOIhNAo
         XEuzWizrw1jGbIjFDsImRDIf1nOiL2gHxyLmhiJcRP+XXEz+Ag8+5QoS3H+V2WL+K4A6
         D/UiAKwWlTTxXTdxWcnust+5GPGY3FAyVwjeZZ3jM2TkqT3AE1VywTFonktmPjqEO31D
         UDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718608561; x=1719213361;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsFvZw6+tVhrenFtiZxMq8S/1O3E/Vsbhy2LABani3w=;
        b=VjFdGhlpsqs1hm5kI/SMmLSdW7HHBi2751PQk1DvPifm3w6QJI+DcS94rI1WrzlTb9
         O1TMqytYVljeiQJVE2TUi6oyemO4JGmKjImU168NKOb1mz3FzjNS6ZkHcXAjXsPLfZqf
         PcfgrGWHch/bpxdWu4wSeAYbjb/fTofhOiJ+97XfMzALV1VBY2u6lKHD40QDWj/DRj7x
         qlo7AxLDug0tVEc0j7ASKW8dhWeYj7zqXjA4TfiNcpp0NXdYKfnFfnHaAUPv7WRDELw9
         1WNjEuYLXsRYsqyM50yDS/PIL8o0lTCqezr8bi9VeXzA8rNGirVSDSbzxn2pGJp5JYwL
         AthA==
X-Forwarded-Encrypted: i=1; AJvYcCVY4I/JkKyFG+xU6+8AjNHWY25I5oQErNpHkp6OItzo6lpDElkIHW5ZxhnGhUeuRKhha2iHkPNDcrLuEcMKnoH1xaY3
X-Gm-Message-State: AOJu0YwOVFljlre1KZxn+CbXymNPD818YBLnLeY2E+imy5LamXbNThI9
	Eer6M/vIKW8sV438HefY9unr46kRaARzOQn7N5e7YczHZiU1WLk1gEeHkYaGbQA=
X-Google-Smtp-Source: AGHT+IGCpClrLBYRoU36HVh+/jPE564yR/kr+8wFpIdgqMLQyygVCvp2CPZRL76mflg/XzuQdHigbg==
X-Received: by 2002:a50:d5c2:0:b0:57c:77a1:d1da with SMTP id 4fb4d7f45d1cf-57cbd4f98b6mr7794454a12.0.1718608560476;
        Mon, 17 Jun 2024 00:16:00 -0700 (PDT)
Received: from ?IPV6:2003:f6:af09:2800:d77a:f11c:c1c6:8f79? (p200300f6af092800d77af11cc1c68f79.dip0.t-ipconnect.de. [2003:f6:af09:2800:d77a:f11c:c1c6:8f79])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb743adf1sm5987828a12.93.2024.06.17.00.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 00:16:00 -0700 (PDT)
Message-ID: <c823dc67-9400-4fae-9816-4f25e2d74c0a@grsecurity.net>
Date: Mon, 17 Jun 2024 09:16:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240612215415.3450952-1-minipli@grsecurity.net>
 <20240612215415.3450952-4-minipli@grsecurity.net>
 <ZmxxZo0Y-UBb9Ztq@google.com>
 <e45bffb8-d67c-4f95-a2ea-4097d03348f3@grsecurity.net>
 <ZmypzAkNLr3b-Xps@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZmypzAkNLr3b-Xps@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.06.24 22:36, Sean Christopherson wrote:
> On Fri, Jun 14, 2024, Mathias Krause wrote:
>> On 14.06.24 18:35, Sean Christopherson wrote:
>> However, this still doesn't prevent creating VMs that have no BSP as the
>> actual vCPU ID assignment only happens later, when vCPUs are created.
>>
>> But, I guess, that's no real issue. If userland insists on not having a
>> BSP, so be it.
> 
> "struct kvm" is zero-allocated, so the BSP will default to vCPU0.  I wouldn't be
> at all surprised if VMMs rely on that (after looking, that does appear to be the
> case for our VMM).

Sure, zero-initialized by default makes a lot of sense. I too would
assume that CPU0 is the BSP.

However, I was thinking more along the lines:

--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -136,6 +136,7 @@ int main(int argc, char *argv[])
        run_vm_bsp(0);
        run_vm_bsp(1);
        run_vm_bsp(0);
+       run_vm_bsp(42);

        check_set_bsp_busy();
 }

As in: having two vCPUs with IDs 0 and 1 but the BSP with an ID outside
of that range, e.g. 42 in this case.

That's still a working setup but without any dedicated BSP, so may cause
some hickups for real operating systems. But, again, if a user does this
on purpose and things break, well, can keep the pieces.

Thanks,
Mathias

