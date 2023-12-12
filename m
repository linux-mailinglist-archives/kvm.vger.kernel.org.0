Return-Path: <kvm+bounces-4156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E1D80E5AE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 09:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9996B20BE3
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6B518646;
	Tue, 12 Dec 2023 08:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TSaqNQye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7970BB8
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:18:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1d098b87eeeso47244755ad.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1702369114; x=1702973914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1T95QWqyyB3QrSdcTdS83OdNBFUN2mcUfmPVVpeEvD8=;
        b=TSaqNQye4Z8rzOBY2IWwP37ITMRse6sIfRkY7xA2ekySH3Ip8RzOsDVyZINcTci4zp
         qZsKev/8q69sD5DbInSHD1NQHS55dXExEigwbSVGLvJGsX/ScbNC5r+h2+iQdmeEwFYR
         Nfq1P0iUvgt0DSA5AScA3iHHngkWkOTzPm2nymdhu9MKwnD7qFPq4uFZ5e9gM/jLylW3
         tHmcl903QY04J4z8OGej6zLXvfioQsbNeLD4HyLVXiatP0gaPnPyVJ6lIHstQpXjaqHy
         tov+3UlMwIIZYq0zEeqjf4U/s9D9i6WoeK9c3mZcH3iRqslqOGeHd49sFeQ129iDvOxD
         oq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702369114; x=1702973914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1T95QWqyyB3QrSdcTdS83OdNBFUN2mcUfmPVVpeEvD8=;
        b=h3naoz0j8db0BDHpQLyj4jSBFH8B8DrXWJbuH/qDsCMoSl1iMroefQi/HmhHsEHfe7
         5Z4ya6QtzYEYZMMNwF2DNakc2d0hL+3IZ6pLYucD/rFptWW60LZO4l8EGLW+bWmBAzK6
         oXXgDzJmsxd5fwFXyl4hX1au6/Frjr5OvP5kXY4VUtQr03kjWwnXO5HDnM8WwClivtTO
         v2RfEnsHIcmgUcoiwoqAI/foHVEG3Yj9OYFtKkRfhIEU+kLcodkzpI8T5xsEji/EHsOd
         9KyXdT0OI4h9lORpkuHyEOo78QpwLQY+Ay9i5qfONqj3gxcfkLFA9lHpQlWcvBBA3hUU
         wpgw==
X-Gm-Message-State: AOJu0YyqA8ygoNXa/ZWVHsJlZMLosRpdZaFYTTIHlvAxo2PzGYp/6s2O
	J04LZiLh93wvcqAo3sZT1c98pw==
X-Google-Smtp-Source: AGHT+IECl1GgbPZCq4cTTUNez9QilmNaeqnLGkNCJnpE9EtezYZ99xe6htdNeSY+PPh4Uk+g8xR7bg==
X-Received: by 2002:a17:902:b683:b0:1d0:6ffd:9e25 with SMTP id c3-20020a170902b68300b001d06ffd9e25mr5670806pls.119.1702369113973;
        Tue, 12 Dec 2023 00:18:33 -0800 (PST)
Received: from [157.82.205.15] ([157.82.205.15])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b001d07b659f91sm7986764plr.6.2023.12.12.00.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 00:18:33 -0800 (PST)
Message-ID: <947ad8b2-14fe-456b-b914-6e1c86dc27e4@daynix.com>
Date: Tue, 12 Dec 2023 17:18:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>, Eric Auger <eric.auger@redhat.com>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-4-crosa@redhat.com> <8734w8fzbc.fsf@draig.linaro.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <8734w8fzbc.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/12 2:01, Alex Bennée wrote:
> Cleber Rosa <crosa@redhat.com> writes:
> 
>> Based on many runs, the average run time for these 4 tests is around
>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>> default 120 seconds timeout is inappropriate in my experience.
> 
> I would rather see these tests updated to fix:
> 
>   - Don't use such an old Fedora 31 image
>   - Avoid updating image packages (when will RH stop serving them?)
>   - The "test" is a fairly basic check of dmesg/sysfs output
> 
> I think building a buildroot image with the tools pre-installed (with
> perhaps more testing) would be a better use of our limited test time.

That's what tests/avocado/netdev-ethtool.py does, but I don't like it 
much because building a buildroot image takes long and results in a 
somewhat big binary blob.

I rather prefer to have some script that runs mkosi[1] to make an image; 
it downloads packages from distributor so it will take much less than 
using buildroot. The CI system can run the script and cache the image.

[1] https://github.com/systemd/mkosi

