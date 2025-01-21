Return-Path: <kvm+bounces-36161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7745FA1827D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 196143A2C65
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C1C1F4E41;
	Tue, 21 Jan 2025 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ct/3TdVn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC291922FB;
	Tue, 21 Jan 2025 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479004; cv=none; b=KCbLFKyih0Hkl8XjZn8xxFVdQ87uRyeU1Tc6dfA1HIzP/kLwbc9zVsRw45yaXnfvTxEFJWNsYnE0lcZga4zpWGuk1xibaCxFNTz2OW13MXelwFOzFBeOfmSBy2xsUGUR5mxNBUBKedPPEzd7R8MNWz1pOjf0FasRuWLx6uVPYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479004; c=relaxed/simple;
	bh=nTsL6z4n3ipvojdaCs7f0TEXc9N2safqo7KfRTUsEeo=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=GfxCmVY8wR/T3N0mmN+83jQ2Dh7VisjHlbD8m1bNRskfXvK6rMYD6lljDTOfosg+RmSrLqqp1I2VPlNhu+5HnpnuEDGrlHhgJ6UkV6tnjtxsVHesbjsLLKl/SaK++IR8vp0+f7ECQmWR9Gr1pXWW6NCzT3f63KOC2y6797n9m0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ct/3TdVn; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-385e3621518so2722611f8f.1;
        Tue, 21 Jan 2025 09:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737479001; x=1738083801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oPYMhPHyht6dFTKsF2mZrpCtdkwhoXBUojhT9raPQPM=;
        b=Ct/3TdVn75JgcUegJyAkMngzfRoaOYGmndd7q0RAkUvtkNjikwh/3DJ2NtYfTzSOU1
         EMLvGkFHnyVD0i0k/3PKkXU115We0Bj1owGc5m+7aP1wLKXiOpt7wVv2neCKOE3e9h5+
         LP0kuHF6ibb/CHiwDCyTR+4nvFSMY3xyTiqGoDbdNEz6S0+cfftNRNLDkp+19LrU5ICo
         Mk4V/eSw5BBgjY51X8TH6GSIGPct9hBzl2x4Z774GKQ0pSyRGHsAQl/IYsItf1Z6nJD2
         tSJIDk/GW7VwnA4HkJGjF6WHVFvaA9Sv5RrLGhe3/GJa+RcneeKt/qhcha25Dy+JGrrI
         JWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479001; x=1738083801;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPYMhPHyht6dFTKsF2mZrpCtdkwhoXBUojhT9raPQPM=;
        b=TSv+V0lSPsTV6NIWwMcIwCByUqAL88mHfdJxacwuQJLGBgY0YRQdWiJ31FgL2APwIL
         SoD9sW7aZ9C2jR6jhL7lYCqPSA/MkSCXMyydzzR9RLJJcpi4C4ai1rf5Rd5BbOsf6AJs
         HaGvgA9+PoA7GDTQKbQ0mJmUVCONNlrKHkhAeKzDEx1OpHMm69qwN16UQHvi3PIC+TRq
         3W7Xf0LwObi9fUKA0HQfFJzBkraOjoWtMQrs1pyN3kwhxXuZDo3+bRJKQQjEwFcSiIm/
         MR3zQrza5rKgN1d5FN9STuYNWZwKlNx9ibVLv+gmDUTRIMmcmJXWf+NOQPyztBfOf26Q
         7y2A==
X-Forwarded-Encrypted: i=1; AJvYcCWCQTo+nf3N891eia9zxH7CnXT/pVNGy7WzT8hl22dks+uDf5jQpP3OQ3rAfa5kbZH/5RjDHt0SgmHrZ/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT3WLRwgkY7JfcXt7NSZ9X9YWpgH2zkEfqLBvuVACUZfPlxJZ1
	4+3YmbIY39v1gNCgHNXS2y+A10yCfWC3bRAOW9zFIut+nR0Cxt6f
X-Gm-Gg: ASbGncvXEJEfDp4cHR79az0GbJW/8SyVPJWCiXCAUTBAgn7u15MqsHUwdJwuEs2z6qa
	n8WBsTfslVNWvS9Eoj3YwpTfMnLdS668/aa6Zi0AoUI2Y75RWEpd/8y92flCNOZqlbJVU0o+3cF
	HyvJ0iW+pV5OJt4f91bdnlBIxJOaT07rAq8ZZU/D21qq1a/9Rby4Y0WpESgr8exAfsqg4o6fi2T
	oOa3ne7KGFf85eRolBjk8OY+SmKiECIhO+6Wy4m8IwbRnYJKpYZBUOuHpUcGGkcRK1sWB0jHoke
	X3emXXPolhc0B4B9O6Cs6rXWeQ==
X-Google-Smtp-Source: AGHT+IG64sN1ZFuK9cz4xUyb7HE0K/OebYaJgvCyrEi+HLqDbSBQkA/qBKX92cLN+R4opN0FAJjVcA==
X-Received: by 2002:a5d:64a3:0:b0:38a:624b:d55e with SMTP id ffacd0b85a97d-38bf57a684fmr20347202f8f.41.1737479000897;
        Tue, 21 Jan 2025 09:03:20 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322a838sm13742728f8f.48.2025.01.21.09.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 09:03:20 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b3c0d243-da02-42db-8885-4290d6859c45@xen.org>
Date: Tue, 21 Jan 2025 17:03:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 08/10] KVM: x86: Remove per-vCPU "cache" of its reference
 pvclock
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-9-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250118005552.2626804-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/01/2025 00:55, Sean Christopherson wrote:
> Remove the per-vCPU "cache" of the reference pvclock and instead cache
> only the TSC shift+multiplier.  All other fields in pvclock are fully
> recomputed by kvm_guest_time_update(), i.e. aren't actually persisted.
> 
> In addition to shaving a few bytes, explicitly tracking the TSC shift/mul
> fields makes it easier to see that those fields are tied to hw_tsc_khz
> (they exist to avoid having to do expensive math in the common case).
> And conversely, not tracking the other fields makes it easier to see that
> things like the version number are pulled from the guest's copy, not from
> KVM's reference.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/x86.c              | 27 +++++++++++++++------------
>   arch/x86/kvm/xen.c              |  8 ++++----
>   3 files changed, 21 insertions(+), 17 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

