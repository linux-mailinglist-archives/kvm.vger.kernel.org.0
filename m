Return-Path: <kvm+bounces-56969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE6EB487C4
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 11:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0D4E7AC7E7
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 09:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670D32F067F;
	Mon,  8 Sep 2025 09:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMf7Hi4N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A4F2EB5BF
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 09:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757322357; cv=none; b=oluOgQV8IOwdfKXtJP0xS64kL3pFJ/M2E6LjQMQUO5reXbFylEOzUxpsVxcVyqid9+Lgxe6/Ic21IgJUO22CsrX7t6/kOIUW8MTbggPnkIfCVO1T9pKot5OMcrZ7CndyhLIy61wSZD5EZCkwjtHadxY4G8UzsiL4exh08Kd7WoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757322357; c=relaxed/simple;
	bh=P7ve4bSvP7D//DVLn8z2qtyy/eqBVe8bFLdQw6y81a0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iv/o/FovFD5gmBtATqLJPG6uiHhAgViRn7jV9s4OzCI2EU+xrS5AURuZZrZJ20CxMRkZvdP1Ysw0jxrKIKG3JH0cAPn7aMF80FpNNTdPR876SNxOFDaP+x4YZHZ8yPDmXep3qzggTkkUnuZsFWoxPIGd18sYgHPLj+M5jElgOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMf7Hi4N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757322353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CCKOAqyJnX/UJPJicswImDhbccEcHQgSYKYFWGw4a9k=;
	b=WMf7Hi4N8DMy3tXCIIcJ6B0Ks9PB2Nor+jNE5KHSULyRa8A/QiAI+quhvbUG7b0qSzrVEy
	HTWp0uZrGZmkn/HIugwQHWm6rqz2ccbPE96+yQEYOlaic7LaLEE+FMiGLryRigfNX2AIGS
	orJEVXNXCXjMPJvXSkZOgRtYaaapjc8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-oqh8QnlfPECfcyk7JGUFgw-1; Mon, 08 Sep 2025 05:05:50 -0400
X-MC-Unique: oqh8QnlfPECfcyk7JGUFgw-1
X-Mimecast-MFC-AGG-ID: oqh8QnlfPECfcyk7JGUFgw_1757322349
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e2055ce8b7so1485025f8f.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 02:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322349; x=1757927149;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCKOAqyJnX/UJPJicswImDhbccEcHQgSYKYFWGw4a9k=;
        b=QboaNGEjIm+qXUfZ2mkYaHImDE931SnHJwCrMTi5s/fCkoVXyMNCaCpt1ff0lZrqDX
         +aIh8/8ihALuHwMYmRcCc5bdIRbXDwKdx69/P348q5FfIyveDZbNmvvIe5gr6r+aRJYn
         aPUtv83+vFUuP2r0fYDlWlY9BxY/bBrceiVhUn9kTzunyvLxKGYtj2DXaRBlIA2qeHD+
         J8ZinYdpllJ9T7DrzfvQFTK3kGELAkm5aGzFKjC24X9LueOCm6UW+iijvzxEhspQQsW8
         dozSQvtpHxrH0ZhF/tOnIuwcus3TM6CA5CAeFJWr0+jOFpXEbtTqM2twIiUyR3GEj5kg
         c4PA==
X-Forwarded-Encrypted: i=1; AJvYcCVWXhaz0znEBlIKLpFYEgRdnYgEIT+OZBheZNrW8kGc605cBf2qH7B462adyolX7QjBtrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD0+pbLQBJcEj0KjsE+zKAIevKc7p+ZeH2YIxuytILq83yFEuh
	lqqeNqO0yMBf8gBkG6TqpbalJN9xtIbHJaYCSKxYWTUPATEnGAv1kfgMbquKQI9spaM1az+Z3kJ
	G1C1Qu2NNICRgZ6u35eKrPsHgrImGvU2Ef4mH4MhIVwZ7Q9bi2zvPzQ==
X-Gm-Gg: ASbGncu7cRaD+dzarshruZXdpkuGd7COLQSeaxvN2Hhn21/amHHIHyCbahtAnFRB70t
	3dmLb/0c+kVOXG15+TdxNTNxkqc68TX4JniaaiUzJPw3BmyOA4QETP2mJ5NqnZs86zBdM96nM23
	jAySSPayYuPLIJuYkAdYcay614uxAqx9iFaRSa7vs1C3/lAcEVJusyRYsTu/FOwhV/307i3/PdJ
	uq220sG9h+SZK+oz5I8TKEJD0pIawXTnd6G4L4ite2eDhvH4+yGaO39votzj5BXTQy2n0JVzbOM
	ZOsDdIIr7EYAXPhhSQGTzYSLoXirluyOGPM=
X-Received: by 2002:a05:6000:2909:b0:3e7:44f9:131f with SMTP id ffacd0b85a97d-3e744f91924mr3349909f8f.1.1757322349176;
        Mon, 08 Sep 2025 02:05:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAtDjoTu66KftpdkoNBJ3Mi4sooxHp7L/u6879vG7/2W23K/UfayFxyfeL/kY+x1C2acs1Kg==
X-Received: by 2002:a05:6000:2909:b0:3e7:44f9:131f with SMTP id ffacd0b85a97d-3e744f91924mr3349885f8f.1.1757322348768;
        Mon, 08 Sep 2025 02:05:48 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3db9b973869sm22277715f8f.18.2025.09.08.02.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 02:05:48 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>,"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shaju
 Abraham <shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
In-Reply-To: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
Date: Mon, 08 Sep 2025 12:05:47 +0300
Message-ID: <87a535fh5g.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Khushit Shah <khushit.shah@nutanix.com> writes:

[trimmed 'Cc' list a bit]

> [1.] One line summary:
> [KVM/VMX] Level triggered interrupts mishandled on Windows w/ nested virt(Credential Guard) when using split irqchip
>
> [2.]  Problem/Report:
> When running Windows with Credential Guard enabled and with split-irqchip, level triggered interrupts are not properly forwarded to L2 (Credential Guard) by L1 (Windows), instead L1 EOIs the interrupt. Which leads to extremely slow Windows boot time. This issue is only seen on Intel + split-irqchip. Intel + kernel-irqchip, AMD + (kernel/split)-irqchip works fine. 
>
> Qemu command used to create the vm:
> /usr/libexec/qemu-kvm \
>   -machine q35,accel=kvm,smm=on,usb=off,acpi=on,kernel-irqchip=split \
>   -cpu host,+vmx,+invpcid,+ssse3,+aes,+xsave,+xsaveopt,+xgetbv1,+xsaves,+rdtscp,+tsc-deadline \

Is there a specific reason to not enable any Hyper-V enlightenments for
your guest? For nested cases, features like Enightended VMCS
('hv-evmcs'), 'hv-vapic', 'hv-apicv', ... can change Windows's behavior
a lot. I'd even suggest you start with 'hv-passthrough' to see if the
slowness goes away and if yes, then try to find the required set of
options you can use in your setup.

>   -m 20G -smp 1 \

Single CPU Windows guests are always very slow, doubly so when running
nested.

...

-- 
Vitaly


