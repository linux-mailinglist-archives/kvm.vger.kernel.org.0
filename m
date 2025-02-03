Return-Path: <kvm+bounces-37117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 789D7A2557F
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BD1C1882CA1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252551FF5E9;
	Mon,  3 Feb 2025 09:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bs9c1le+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A5F1FC7FF;
	Mon,  3 Feb 2025 09:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738573802; cv=none; b=QoQjIjZgnQ0x4h9BDDqaMvKAmxQfpklFcUprreg3ikOZBodKhfIJ4LmzG8QV+WZ71FQ43Y2G/rzzSAbJgGCD3E3b3x5DZ0SP2uZIFMhVo4Lt+OApVgAU1e5kxzuybzgpl9kDOLv6aknJeGtmMxwFm8iYnl3e2k72lN33JDMSynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738573802; c=relaxed/simple;
	bh=HWPee587ujvEfUgQdiy5jklaVRSCUSN+J/F1ysoJPKM=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WqBFq61PqrXWSraM7kbomr9UsZWjl7ZIskl+P0YgJ0YlWjEfqDtVrJjPaRncvtW8X6JQeJy8xFEHvG1zUBWpL5E3oyjoSGkhYT2cZvYXswsKsB6bA5nNu5t51CM17WwgPaEomk6vbLq0bhPDEv5HM2AReu6ouwIb15nj47onTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bs9c1le+; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so6434729a12.3;
        Mon, 03 Feb 2025 01:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738573799; x=1739178599; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YfUOM0B8I52BtFVglKEUvMQla7dCUbGJVgngj++BrAI=;
        b=Bs9c1le+wmTwNl4zqkHeBYz02egFfoC5tQO9ha92Obn1BwdxcxA9r8cZScb4ZxO6Uo
         vF0CUCQdgetV+4WLttCgiozMbJ9mQKx1a0upln0Escthp508qgj+RXbS/T1FFA5D3xRm
         sKgMG8NaQui3314U/KTbI6PWrjcTKA9VIiidhDyeXwqIKha3qaohv0J2s5/dpzR/WNHr
         9McY/zM448YRh8yt/7rgpYMhwrJDJCr/YM9yeF+wvocEdT+WD7n8ghdQR+2Xcclhb6NJ
         nx/qtmlCUShl7yDIFJ926CyToTspMDlxokgdMYcdAgeXPZrqSjaFT8uWMkJayVJ43mNP
         vWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738573799; x=1739178599;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfUOM0B8I52BtFVglKEUvMQla7dCUbGJVgngj++BrAI=;
        b=TmA6Jd64rvUGTwTJ3PI0DIl1RG/c6EihtrZp62kJUiKyDPGrNBM6YoBARj7sfO6jhV
         +V7Ew1R+Qep/0EgPVsxKGxxXmeVCgp6rY0fqS5/1y9yxYoPMPof59vDFlYfC3nCG+Sve
         xbcZrlG8Hy0JBAw8UOPv8dtAoza9ws+HqMuiCvWTgeNxKY6bgtDAcds3aDOdsttN58ec
         BSzQ09D6j7zVM3QE6c7IkP90bm1JjWE3IGXBvJpnsKoOckO+QedLlJC1CklsrDKSFI/O
         6QztFOdM17mSam2a5LAVdI4OknDR2jYLHcfHlE+vHJ2pYPttt28tPnQOVVEhjuEVgzSP
         sQUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFABgnEoCxzxTGVxXM5u9NP5QG0zl9wYL2o29R72/a8pOhHp9rxUoDAkgRULAucLDrspuYhaWywuIUoes=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc4T4wTG2vj6DXKUS88eT104Ugz13BpRTEN2jSLH5vEQ/e4QeG
	otV8LsViGTko4Tejrn8G6rKM/snG859xoyBZwnr5M8kWWa5ylJeu
X-Gm-Gg: ASbGncuURuh95jz1sMbo/WGnubQiiyhshmT7WYYqRAhAoyFYefwyIqzbeSuPDsRNUQP
	71uqVNWPCOuPGzUmd3GMuxDkexHs5NCQ1w0TSlTMFlguL9SmEL6yYDlhqRitS2p7qPvb5H0Xdt5
	WVHA7MYi4A5cYcvSnm0uykyT4b7TerAF4hRkNI3S/hoclAPvYyeTD4phF0r18UQ0rbHt2gNSzpn
	W/2bH0HMY6en8CQWC9TMsWH7Eb401ZITUBuaFFlQIOX91P0SFY9k5ij7+uAeDoqzSGZekiGdYaM
	U3yZekLcporBKlC3/3dQIuKokox9y47BbUZ2auGlT+6UCtAc
X-Google-Smtp-Source: AGHT+IFoKVWnfYTQiDzGoQxjSrU1BRcqvEVkgXqrU6nCe4H17y7PG7LSnZ9+iDtcdZrS8Gv4snEV1Q==
X-Received: by 2002:a05:6402:51cf:b0:5d9:f042:dab with SMTP id 4fb4d7f45d1cf-5dc5efc4d4cmr26350221a12.18.1738573798539;
        Mon, 03 Feb 2025 01:09:58 -0800 (PST)
Received: from [192.168.14.180] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc723cff72sm7374897a12.15.2025.02.03.01.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:09:57 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <86c5647c-dbbe-4224-91d2-df2a7193d620@xen.org>
Date: Mon, 3 Feb 2025 09:09:56 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/5] KVM: x86/xen: Add an #ifdef'd helper to detect writes
 to Xen MSR
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250201011400.669483-1-seanjc@google.com>
 <20250201011400.669483-3-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201011400.669483-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:13, Sean Christopherson wrote:
> Add a helper to detect writes to the Xen hypercall page MSR, and provide a
> stub for CONFIG_KVM_XEN=n to optimize out the check for kernels built
> without Xen support.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c |  2 +-
>   arch/x86/kvm/xen.h | 10 ++++++++++
>   2 files changed, 11 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

