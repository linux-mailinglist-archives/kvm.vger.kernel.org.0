Return-Path: <kvm+bounces-65775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDABCB635B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D68B8301FA50
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45CC314D02;
	Thu, 11 Dec 2025 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZHvPl494"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD1841C71
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463195; cv=none; b=Bd5dSyzJuD9jwv8UMbpinc1oG4RbJyQ0TkLZsHe8waE3hXJLN1SNgC8rBTt2AIydVuti+X5FxpHyp7C3qFmeFs+R96F3WsqnsAtMUFNNi53xCbtIcPYcgxEldUbldJgAPWXxDudXjBg/Ju0374xm3bD0wcyyXfJHj1ZIuM983wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463195; c=relaxed/simple;
	bh=pH0grjH31CDI3N9u5IT0YdRprtooMUrejJx2wBJ99CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzu2PM0xC3/hTCBusDyC/ZqWofbu823sztU9kieoOnTX+0BtUCEcDrZNnyc1ygBLCzHOkZudAZmAgUR1jcrsK/CRVEE5V4NLETGxH02lXy6hxf0eykJ1pkRBt0cgV6Nh1IcbQI+0YpedQpd22hSsgBqQgAY49oaqc7hbxleKlZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZHvPl494; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6492e7925d2so178700a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 06:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765463190; x=1766067990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=N/jL1YSbYaIBBIOERYl8YB7U7TlF2NInjFoc/failig=;
        b=ZHvPl494NpQVwUboTKnIKyHHkx2NX9g8iapVDrXl9LZ7rnbBRidzLx6w310bg7Xzk3
         2jD5ADgo7y62wuH72Ws92vDUP53AmWX6QhjqlUD3KQctKau3xN5NxO+rTInsXEWD/EMJ
         xwJCxbLU3SdwSI4O8nQKC/GFzcsvNY9DzJyTi7QNvelGgfdnVIXYYXPt9OW7AJc0y46A
         K4Tvf4uhyCE+i69zIURWI2HfwmgW1YfiQ/8hwaUN3wyv67iYRKC4DK/0diny7oje7Ps/
         BkTuMSJTGMSyRJWQpmlRLame1hf/vUZ58UMCvIKSoB7QCWHvyvtmT5KkOk/ICqDy9YV1
         22KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765463190; x=1766067990;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/jL1YSbYaIBBIOERYl8YB7U7TlF2NInjFoc/failig=;
        b=oTVZyxIUS4RB+JWnMviXlB0e6wUtKmHyyMXnNASX0HhVgZHjURx0DKl8LM1FlF+qcM
         5CxBxEpI4Xw+nsn1akSEjpqODSBEsqQ7GlDN4hY5rjTrU4HUN8IBf7HjYQItwNGwFSzz
         kweISAaTkFmKWU0FtvX2lpkr5qJjUjBZqjEVWKsbn9FUBjCF4Pjfs4rud1sH4Bx8DvhD
         dGxEMJkfhm9VBY8e7vLJUXmMvnUt3HMN9mZGeDRU6s5uMQrDKAVKkAIQF2ziG5NKbPEg
         sSP6dWkVdiNT/n5kFXGLxK/t6ZNh/hHFRSk2OdefdckV0svFlbclysJvo+7TsjT2w4mO
         XWCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmFmotP9cspR3tlNYBiWRxqQ1ZMGww5HQxODpvPTG2a4XTn45egKYscCW3B7+dn9m6uJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXP/r8ARzpWwrDClJZ0ZFLuXcb04+wcJG1ANIZIHLFJ5AaAnr2
	zcR6AdxrrpW1F98BI0enxN6Jo+pVoJdC2pffzwuH/UhbFvItCqnZlgDfdt/Z2REwy1o=
X-Gm-Gg: AY/fxX4AHG1285haabXU0D2eNjLXyByHVr70kP5UohF9YMdKDivAuU+6rpbw91rWh4Y
	+m11aTSHWBLyQfquofdcbaQGgtkoq/ZEI/Pqtg4QBzoQXyE28DiVtfQY0OAlz5qZtiouCZ/w18y
	GFl6Jrp2cEZ9fn571jAuI6F5ajRCqeUj3hAj2FKBEJ5f7NtorY1l+l3YcGZtJXO7Yp4KqmBJlZr
	u+VJfRdM3qMjaWLW6g9n8Y+kaxFQpp4Xbl2ZYYVyb4B+H6frGFQjEjsLOrEc22cqKrq0h2K1jI4
	HNANmf92YIO890LQy1j7i2i/Nd3YNdTC+Fk3HUhBEcdSmXfXJUuxM6PQZhP9KE5KW+58cR0JAjc
	va+q8qekaJWkcuA/7xGf5Jvku1r1ezDm9E3EviEk4MDHoyUxcBbK7BEwAMqserUqmSLKm1FBbSr
	BW/SA9AAVYgc+dyg==
X-Google-Smtp-Source: AGHT+IFjunigvCBwBHyJuyPaWGpfLjBO6a462hMeuzqJr+xkLEjwHBjrDvPLtvW5SmaHr++ZkKdXUw==
X-Received: by 2002:a05:6402:280f:b0:649:838b:61fc with SMTP id 4fb4d7f45d1cf-649838b651amr2401934a12.22.1765463189997;
        Thu, 11 Dec 2025 06:26:29 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498210de23sm2703371a12.28.2025.12.11.06.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 06:26:29 -0800 (PST)
Message-ID: <fbe2eaba-811c-465e-9d99-20d0f0fd3d97@suse.com>
Date: Thu, 11 Dec 2025 16:26:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/9] x86/vmscape: Deploy BHB clearing mitigation
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-7-d610dd515714@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251201-vmscape-bhb-v6-7-d610dd515714@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.25 г. 8:20 ч., Pawan Gupta wrote:
> IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. However, branch
> history from guest may also influence the indirect branches in host
> userspace.
> 
> To mitigate the BHI aspect, use clear_bhb_loop().
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

