Return-Path: <kvm+bounces-65958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED55CBD4BB
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 10:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3DD82300A6CC
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 09:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75298315772;
	Mon, 15 Dec 2025 09:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FQ1vUlVo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5530CD83
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792619; cv=none; b=G6NmIitx9LYQquHQXJvEw9QalzTL35+L8PC308e4kRM2HO2Ne1zERS3if7dERmNMlVTVUqBxk5ZVN94z4vFWUzG8VOLJwq1o9q/yKG4yPjmKtyXAnoB03jIJ1ZyercUE4uWGImlj60UfBZoDujea4BIlsckNFOwJ5Q9fTDOLfOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792619; c=relaxed/simple;
	bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFVWvGugPcr7YGL1GXGufYDCXSB7aYevKhrqK1apoJnlcTKvqIgndeOYbpz6DINUvxVMa/MGwi1ZB+azj4ii6LGqBcfzpBCqi+yJYmOyg9d9XMgGYFXR0h69SCCzyYfGBlfXFWv+yvPpwNkvPkQaZtNsB9Dk5xTPJ0sHCsOSYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FQ1vUlVo; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6447743ce59so2900260d50.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 01:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765792617; x=1766397417; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
        b=FQ1vUlVoRRDDxBY9/fCaVACb202gdoVmYLIOSqdYdaKSgQZHPPQjdjpjBbNfoxwMVv
         ZM0odd7iUoH7tOPk5vA0yLQBZMR18mbT7+1slQQCp493XZ7wOxRbvZ+0LLwai+P5V/37
         UpgBbjcOA0uQQmRMxi+TqrBi+VXEQ+k6LYs8ISPO+wQrH57lYI13iXlyDAxGdyGF01zp
         UhwAoe9kxsOkIoOGRQsHMRWkQkw3nxolHZ4w71CrSNaqOOS6OAGBbZKr0IC/0E27Avpo
         dS2w1sWOQ/1dJqF7RTmzmYi6MM0McVslwaYmgImsxduYWqdi3/zb18sOHwF/g3lLMCMe
         N3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765792617; x=1766397417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuV++rBkrNA/kKc2HZDb0IcKwxQSZL9qjg+wv+qXbvA=;
        b=lTM2nktVCcMeL8bXjNVrpbcbYG2J3+tJ8ogHyCx5FQJmTnvGSblpAMjgTlgc5nCSut
         E5AcupEVV3tGuuX1aXIxHjF4BR6H58Afb1UT72NdMSqp7gg/K6oz5CNnXJPh1NidLXi0
         AihehXdhwMKEChxLo7J+R5Vw74M1zr9nwGgnat4/eKX9JoFRJ6yuY/MxSdG4k99r0bCT
         M+5HzY5BTNlUk4vBU669gP/rAM71JAN5kIYgo+td6QndjpLadb8kO9lLHt8EhAoIqWVa
         TgNuQLnu7vhNd+1hgO3/OWQIS1yE1x9QhEaPi0UU9oU3gBnaHXbLbTj35ajga0pel0Km
         9aqw==
X-Forwarded-Encrypted: i=1; AJvYcCURBCB24L+rHeY2LIalsUSkRoQlrPM9aH1hyTuv4L1urWWZGpRDEQZhUwcx5OccQGQMbDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvMoEF4W/dCJj8q0N2MiRlHoq6CAToQKSlgKWOrOykzQhTv+gh
	ru0LvV6WxUjhE6CRM2H0tzQXf/whrJUOZRwQwL47pxiebjnKufEdAeS2B2xooeUD7d453rgsN79
	XB2frznA0SbTsBydOBvc+27iqvAddq8EtkbPi/Ic1vA==
X-Gm-Gg: AY/fxX7z5FxvjYx4PMbmkzd5dgLPmC3MLZo/8RdMh+/8jKDAzfHztsgTF2vIm6jm5X3
	YQtRMzad/aDvKlFBOHymHZWh1tbvDy2Q1/vZiL7rZvgiyR2/Urqdxbh7p8KP14MNta4npE1Wjth
	+zG0b/GxzI6fptgEMpO1hBbY7tTRqNV0d0XpUBLJEi3osqCPhz9Lcu6sgV7zPcVZlIDRqhZMgQA
	9sOptFU/XlKcMK40GkBD2BRPu/RxTz23K7WeAqAabqo+JrCNxODTVwRn3sVUayh3HvNUwDS
X-Google-Smtp-Source: AGHT+IGvRV+k5PpJ3mHqjVXWNH0ySYLSRmzIZa/3PhuG05Fhie+VpbBy/JBhrcR8TEOdgUG1Nhjy1u+B7Rb0r7A0s3U=
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id
 956f58d0204a3-64555661ec4mr9123217d50.72.1765792616925; Mon, 15 Dec 2025
 01:56:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251212152215.675767-1-sascha.bischoff@arm.com> <20251212152215.675767-32-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-32-sascha.bischoff@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 15 Dec 2025 09:56:45 +0000
X-Gm-Features: AQt7F2oZumKMouo4dd8tGmO8LzSkjWfV4-sM3jXbB_jFEwXZwbdvqQR53He-UZg
Message-ID: <CAFEAcA-fgWOUu7yWfGNGyy0BwTPxH1ht+E5SQ4tjJf3U=w7e6w@mail.gmail.com>
Subject: Re: [PATCH 31/32] Documentation: KVM: Introduce documentation for VGICv5
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Dec 2025 at 15:24, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> Now that it is possible to create a VGICv5 device, provide initial
> documentation for it. At this stage, there is little to document.

Is userspace access to read/write the GICv5 register state also
in the "will be added a in future patchseries" category ?

thanks
-- PMM

