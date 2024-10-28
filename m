Return-Path: <kvm+bounces-29859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2D69B3419
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 15:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2A80280DF1
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650C01DE2DC;
	Mon, 28 Oct 2024 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TSei5zFp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389C11DD0F2
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127332; cv=none; b=R+zML/8LB/Gpe3LUQdoHXxB7596OiTqR19kIqYK75aaHoFbO58Tozbd9BcGcTlTxBxwZwKRSvghSKwT2qIecE2nnEgg3AkTd6DCGlnN7meXSRbQG4qnjs6sdWMDxEkZU89a2/m/AfrtarSaNM1GvCGSmhwqWMQTWvQCKUoF2ytE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127332; c=relaxed/simple;
	bh=3I/c1iSHfDGPSB8Vg4G3/uhCl6rDJuP0ZIYONyN2iRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NB7PncxuPT8lPhgDYvQOpTMH9QQ/mlXtS8yc99KucOM9nUnUnzW2z9J7GTjP4uMvPjYC7bUsmb6TzdNNrgxhTTCc0DHRoB2AERlc6fo5UbZIXw2y53BTeFuAZ71SRz45GT7PKhSfGhpQ2Dt+rpjDuwGvIyIh2kU9d/JldbQ/FQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TSei5zFp; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9a68480164so611235566b.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 07:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730127328; x=1730732128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Iun/RjX690GMZEyAyGhf0q0//IXeU/3+RYE93HP2ik=;
        b=TSei5zFp8sqO8bh52nEw+OLAqgFIDIODhUbpZUcHkY4OlFTYMoXSEf3ikqad3NkoS7
         JPz+H7vbS2Rc5LDLa41Kz+woNk/PxLuxq6UFnCD50KpnJ1TM9oibDm5lZBRYfsOT2EdP
         rzveWKRj2F+OuL31Ml3hHKIgNTCsIfrwornlIi76ak5S2jP3ABlPhYE3G5yyIu5y+3Z5
         RDw+CZKgsDahF04aCo4pa0Jw4QOPqCHRDTSt6U2t4mlJz922gzRHqVQd+cJIhoorl63f
         2xJ/vG3+Tkff6vJWNLWdzj7of8kIkXkNzntsO9b2L/G+TDbKyJpFFOM6iMz4ehiQHViV
         wQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127328; x=1730732128;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Iun/RjX690GMZEyAyGhf0q0//IXeU/3+RYE93HP2ik=;
        b=Pp7EOQarUqw1iU9380ro1mCOPfaOLjFmTu7ChTH3e1HL50CeHy3cK1+6yNb/t7Ca66
         KpYcr0APcpHXntSiBzRynNc19ahI4f+OqS9e98+mE1p1xWSXABXUy2EmKy5Fwc1BjVLP
         Fs+LRwPn5snl3WnIAF4bEwa4/t+1fxLwjs7yOay5UHrUMDXP0//GB7PkXyEkXcRmHen4
         lU7F98s1qx74MqUy1Saa79PTnd7CTJpjyV78NEHZdi0XPVo2fsAUKU4oOcHoIQGM+1kl
         pkt6R8GAYguqNEZvCq+r5a0tEVQg25yoR/XQzHAGwzzQFuOF2ncHiBrNP0jQXlzbBzxd
         9/Ew==
X-Forwarded-Encrypted: i=1; AJvYcCWoneQTiWCCEVAckFSHbxD6C0Zvq3umBlklhytqo29EpgXnCxBqjEtwgcxS36F/nyAzQXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0mF8Kv3ptgQkYOIRSBtkUG7Xoybg6PARHs0nRNsY9cYM9Sh0B
	Rl+SBKctHdh3v+8RRbvlGRcAeBjirmq7cq9dRwZriOgNTkw1zwl8ULePFQblKSM=
X-Google-Smtp-Source: AGHT+IG1u9a2TBkIJGXQu2TDn2MLnBYwYgjbkhmzFVSLRK4+krixIOTdIogv1lXP+QAyAO3JziQlPg==
X-Received: by 2002:a17:907:72c2:b0:a99:f67c:2314 with SMTP id a640c23a62f3a-a9de5ee34d7mr949087566b.35.1730127328041;
        Mon, 28 Oct 2024 07:55:28 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7465:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f298bc1sm385999666b.137.2024.10.28.07.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 07:55:27 -0700 (PDT)
Message-ID: <d2185390-5967-4abf-b2f7-13a26bd4443d@suse.com>
Date: Mon, 28 Oct 2024 16:55:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] x86/virt/tdx: Switch to use auto-generated
 global metadata reading code
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, adrian.hunter@intel.com
References: <cover.1730118186.git.kai.huang@intel.com>
 <7382397ef94470c8a2b074bbdf507581b1b9db7e.1730118186.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <7382397ef94470c8a2b074bbdf507581b1b9db7e.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 28.10.24 г. 14:41 ч., Kai Huang wrote:
> Now the caller to read global metadata has been tweaked to be ready to
> use auto-generated metadata reading code.  Switch to use it.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

