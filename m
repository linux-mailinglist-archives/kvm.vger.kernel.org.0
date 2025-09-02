Return-Path: <kvm+bounces-56557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C955CB3FC04
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 12:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F3527A5227
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F261B27F75C;
	Tue,  2 Sep 2025 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qJTFascF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0D16F265
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756808231; cv=none; b=FGDNDbAGhHCkoeHNrLzNuKiqznqI3qgh/JzoKl1N7c9DCJ1SyueH2R7cB7CuynARvHYy0vgtjuSraEtn8/gG5UJwRH+xaoivhO61mphlKSoRjKs8YS1ZOFb+x4cvQoTcp7sbVxTQfsw4pKKOBeyB5vPmzlkHrm4epW4HHreHK5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756808231; c=relaxed/simple;
	bh=YFVnxk/9cQCoq4PZNn3WwT1JlD495LFTXniEAf9xfGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=it2wZrPbyQET+axrDTXSuCdc7QyhHgt6fIwFnIQMLoTnAnUcqSdGjKo9l8ksQH/BRklspAUUDyVq5KdFLixOP5L7fOj2lYnk0Yk/ZusXFleNOs0XtxxbeNJHLUEFwdxUUYyXTOfR8HlsdffBGNJcqQdQsswNWRk2oh9j3T2sb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qJTFascF; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3cdfb1ff7aeso2563875f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 03:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756808227; x=1757413027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rly+1aW0RM04C1ueHyEUX9nrFXkquj1rDqnBJ6wqqvo=;
        b=qJTFascF9Ftl2Qu88YgqwXGnqZASpAbcsPdpTVcLVX9zzOSaA3JtIuGsLb70tHGNop
         BF3bnSzqFPOg/pTSsTB2WuqYlu5twNTkaIo6JHueEFSqHQ2oG0wZz4D7rwo/Vl/b8TSD
         IKK/KDxNvOyyqN1EdTRHYhVwuOy30u2JG888w3vblN0gE0Y4ymWuXuAwkyx8/VgrcM73
         6E9bA+0XOC4WV0gXFBfCHPokq46dmziyB+gyx5pbo4i1YQ+vQdySWtcwA4abQZl04wH3
         0i0aCu6bQMK5rhheGLeuH8PNC/Ca9tJKU8xv8h+st4xrNyK233dtTE2zlDQpi206MNfX
         aC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756808227; x=1757413027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rly+1aW0RM04C1ueHyEUX9nrFXkquj1rDqnBJ6wqqvo=;
        b=fNvctdWrR30t6FMU0iwrE4eIeL2WaNR6YQN1TkVmzd3aFjbWuSiI9qd/+Vah7K2zhV
         uj5nzQebUUq6IxxWMmF09a0TIUOT/8D3CbuysvxmqlRHGhX3ZHQIRyinNGZlJHhaPPaz
         iwEHb21R8pgy87ldudzVpA/Hv4iyBp86W3D9+r35Cva8R+fwP4Xqwviil7QuDPVhDhQk
         qUImCxthjchy2inpcCIGwJoh7Av/ELN9InmH+BBTz2KUMBdrCDLpTQQM4L2rmgFNKiuS
         RK++dH6PPdSMAnKV8uEhKKC2a3zDPFnHgdimPv4zyq6DEFeqV57+BXs5BIYus0QkNAA3
         iDWA==
X-Forwarded-Encrypted: i=1; AJvYcCW8bjc60xZaY9J8RliB1AUjn4XLrbuCJjaAbOB8IabIJolL+YUzAWnsiNxSr/D1rTDl7qk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE3xYh0QYAg4qSI7QmvFZWNnkBlZfD3qdsK6HErhhJQme3S0bH
	vx9HkBgScqWwctqSuqeDjgzfYZcI2Cs/3ddsQxSlnZ/OdhHSmDYJum0ZJwnFujgSeY8=
X-Gm-Gg: ASbGncvamRHdF/6gzmefishK/GnQdDiAOmhlyP+wCgPsODLLHiKCsehm7NeQhnpVeLv
	RpMpeOq/ozk7YMSjcdfH6ffRIrZ4ceMLfhZ+3RkgOfO83u5J0LDuLYcbfM0or4sBorzsE7W1qRc
	XxUVTxSaFnJI6gcf7kZl32/3mR7UZDEQ9yKU1/M8Dgbsypncoehx9kMgpC5Yr0vEGfQLGGuDMev
	LB86E46NOsSnzyP6c20kLJUlrIoH2q8hs9pWNRt4eJh92Au2ITH8KFCQsC8fl7QsvtQEcENwWOP
	ZLV+CpwE1nSy+4ztT2ZPIDrbDo7RCQ38VfT94TSF7Wbys9HcKp0R8xrOk5Hvj3t6s5fa/h8eAJp
	DXMp4hHihYpJTjILaTIJirb4CvQgGlKSFcOqI6wVEbxGXG62jgCWvafdl6m/67fMo/w==
X-Google-Smtp-Source: AGHT+IG1SDxYeJTEFH/Uf3DiNgiTUn5lT8oKqC2DBWuRYMa6RC1Uot1Uv82h4RbRq0osnGIylno0WQ==
X-Received: by 2002:a5d:5849:0:b0:3cb:3ca5:8717 with SMTP id ffacd0b85a97d-3d1de4b5ae8mr9336141f8f.23.1756808227560;
        Tue, 02 Sep 2025 03:17:07 -0700 (PDT)
Received: from [192.168.69.207] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d15f7b012csm15900909f8f.63.2025.09.02.03.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:17:06 -0700 (PDT)
Message-ID: <bcfea710-57d7-4588-a96c-a8f27bb4ddfc@linaro.org>
Date: Tue, 2 Sep 2025 12:17:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] system: Forbid alloca()
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
 Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
References: <20250901132626.28639-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250901132626.28639-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/9/25 15:26, Philippe Mathieu-Daudé wrote:

> Philippe Mathieu-Daudé (3):
>    target/ppc/kvm: Avoid using alloca()

>    docs/devel/style: Mention alloca() family API is forbidden

Patches 1 & 3 queued, thanks.

