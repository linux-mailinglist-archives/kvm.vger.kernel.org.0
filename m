Return-Path: <kvm+bounces-61674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AAEC249EB
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E23483BCCA5
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FE5340A67;
	Fri, 31 Oct 2025 10:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BCyCbNq4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE633B6F9
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907894; cv=none; b=qeap6S/390xY3Ly9jispqhJBuqjv3pM0w7Uth0a020Og+6JZTG/mQi83B8nHLm5h9Kh3W+xlebj+ZiE6RkzK+B4Q49OGr76BUODCvqOqAWw1Ak2MJgl200+Rqa0Gl/kMs7Ezj7EBoeRTfAqxeIhCAVvH/4wP3ZdZW1LkUZMP/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907894; c=relaxed/simple;
	bh=bZMs4a8vX92ne3NN5DgjXS3aCKg0Od1YwPibEsvXmo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dv8eOgQfGz7RAkB262aBYz96ZNDwnSjucdwHmgKD3aIQ6UbDjERMkHbRJxK8mRBgzmzdqvOmv/GaAIOnNYZDRJbbb549nxdpu9Q7n2otvafCZ8v8zP3WPdPUwcAu0jI+lnytOvQrEzYUwb3VKxMheSspf9TEK8TCIJerBR9H49Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BCyCbNq4; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429c19b5de4so409119f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 03:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761907890; x=1762512690; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h+FnkYZFDp4Lw292UW1n71WG3c/3Nki6YoZZ9R9Pp2M=;
        b=BCyCbNq4l3D6luAQuSgey3U0ozHZ51gP7XnLogcxCUk1+KIUPf+708YFOUW7gDuO7Q
         OOxfgGw/TKk4cxlCYFpoIpK51dXnD9yoA8l3U91+UTWd48TySLTbUujiH9+PSnC25pjI
         9JKynTtcJuqgKTvBkwDFL7hmx30/OOm9zbOTevTdW5UMxIaxnIQoVU58WJBYaU2izv5b
         jioGzHfaDOYUpQfRSGNU4fwrvQwBNW3ijx1vE6x+1hiV+RnIXB/ilfe2qlcJ5mOJW2v7
         dJCkXX3edx4RIav+VRNl8Yr2NUenrbN8Uwag52L49chCmBeV08MwiZ8IZQl/utPMqjiV
         98Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907890; x=1762512690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h+FnkYZFDp4Lw292UW1n71WG3c/3Nki6YoZZ9R9Pp2M=;
        b=qtPvlEMBZB8uMFZ5fo12ZoonPc2z2i3bdDzleuXCtwAgzt69xSq3e2JJBNBQYbNvPV
         3Va1mHi3C8dgcI7wF9hq2ZpchWUFtRl87TSfByxTWPUjevG4xCX96b4iRW4YMC0Ipz+b
         HHGz6pC3LV+C+xcdZaTe9vAevPzRSG3zQUeKzZdVg+Iydvr2EwCz13r13Y8CeLyQ9ZjU
         HLoLyAkA0dWkgjfESztGZRaFctWYkOA6nk1zBPPe1GbpA9+oULeCopqKsIK5dV/kYlds
         L3HVq5FLHAArXlJAnEGH8QZyqsVEigxDjhOc+0RPQ+BWRSlWJ0l6lndQTzs6z+NKc7hp
         JXFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpq8xP2qUqY80VMSTLMY5bdH5perUXUZ92y2mwhCjRDBOk9dJNPVzQTPgbrq6TEK8TFzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEyDiChikuFRUxXfIKh8JlzWTmCTzvMIk3bXfPE+upo+MfVAno
	MtoENsyj8LUKgjDfZ3Rp70EkOlzJC5C+2rUeXpyOgxNrQbdHkav9oMhBVZfsGLiY3L8=
X-Gm-Gg: ASbGncu2Kt16m/HsLYHCLPZhk/25CVXXJYgXFRGnwijdd3+5wjM3thMJmYZz2va/iLJ
	+4vDrI0qo4D3h9pKUfrNauCFWMU2qMWSDq3VdLCok9lV5EtzkSimC/kjbQwS6qCrXo6htgYnDjx
	WIVjkYt3urXrXacTOuqQoi1TJ0cYvpPmol3MRk0JDttzGYU0OAbx7gzVU5JOqx+5MCAi+t8n5Gl
	oL5VsC9c6Z+e7ntu7gYrDg06zkQG7fXkCYVBo5mYZd4Q9K+2Uf3BGWfQJuE6XqVvECcxlBWZkuQ
	/6zgtZDitSqxNRD3d9R0UNUvqG22OBY3OBoJF83AK9GAIUor91fzmPPxcbaynJu3uSHGO+INv6d
	XHts4Jto4J868rUbJfqAB4lU+7NbdXtdAQawfqsADiIoY+667GHff1XBhA1nAm+K7LiYvS2txz4
	ATFQhwdgmpUiseoGkQkh/Z8z5D6F7tLAroCatRXBYpbJtxwI9eNOnoTuU=
X-Google-Smtp-Source: AGHT+IEOeJDIw15a3psdx2TelkDf96UtBc8hzl4XXKhv7GHOCpFC2/8U5kacyy0pDc0PbDY5OdloBg==
X-Received: by 2002:a05:6000:1a89:b0:428:5673:11d8 with SMTP id ffacd0b85a97d-429bd682cbdmr2545137f8f.23.1761907890219;
        Fri, 31 Oct 2025 03:51:30 -0700 (PDT)
Received: from [192.168.1.17] (adijon-656-1-155-31.w90-33.abo.wanadoo.fr. [90.33.190.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13eae16sm2872142f8f.32.2025.10.31.03.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 03:51:29 -0700 (PDT)
Message-ID: <0942717b-214f-4e08-9e2a-6b87ded991c9@linaro.org>
Date: Fri, 31 Oct 2025 11:51:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Content-Language: en-US
To: Igor Mammedov <imammedo@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
 Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
 Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
 Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20251031113344.7cb11540@imammedo-mac>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251031113344.7cb11540@imammedo-mac>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Igor,

On 31/10/25 11:33, Igor Mammedov wrote:
> On Thu,  8 May 2025 15:35:23 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
> Are you planning to resping it?
> (if yes, I can provide you with a fixed 2/27 patch that removes all legacy cpu hp leftovers)

Sorry, no, I already burned all the x86 credits I had for 2025 :S

Zhao kindly offered to help with respin :)

Regards,

Phil.

