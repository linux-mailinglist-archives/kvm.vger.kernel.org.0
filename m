Return-Path: <kvm+bounces-8190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1950484C303
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45E0E1C218DB
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF86101CF;
	Wed,  7 Feb 2024 03:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCbXwnM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2983FF9F2
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 03:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707276045; cv=none; b=SsrEH15Xv6kqFlsVQV90389yQhxt6nr+Txyc9HgiBzR+QNJEla3pJ0EGYdDWsaeOGuhCQsvCfqc21hSEthuihpnCJ9NJjVKOh7gIkbAYHxMmp3di4rxytrqwh1gOWbMmOc0XsVOXMVOCYFwm/ASIOzG6VKjSAxGOhA4Z0DVDSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707276045; c=relaxed/simple;
	bh=VVWU1hTHdDiHcMV+44gh4MOWuxsDTk6kozGbwxsOEB4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/kSDUDMFKATMp9IMsw9MGXCDNtFRRZQjXBFek+4j+fSMzVpihVOxOpNB5z5XKr8DWeylG1fgWHkZWWNJXmZy8vHqJL82OVT2oSqg1YTk9/ya0J83zZh5Gj4BMCuqKkiG1Kt8y9yotR3NctibUkGKnkL3ebrf9eSMB5GWLUdqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCbXwnM1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6040a34c24bso3453497b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 19:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707276043; x=1707880843; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ApcLgLGrxwLEuYf7+iIf/mNSaHhoA2l57UsnC6CxVWA=;
        b=RCbXwnM1A83uV6GI9gS/PEnbZTtxDZzwUS7HK/1MRmcMfHkcocbpQhaIx7QobYZ/fE
         fnYs3FGnVDPk0Xx8R4nInEuE7MS34oeQIYr6elgdJIKsFb04Azd99GdCJsXzx2rY7S+R
         zW8Z3nRlpfYbsvoShBosLPD02BqulFozispCJrJ7+tqL1ZiUr57/UbtCIEg+pNzDKmrV
         26xora0KFkBrk7NPixM2JVYIZLzv8++JY+GxjwhtENILsHowkUAf627Kq8JIfRg1jo80
         0SmVwnLMsqt+PA329AX5hPCl2TTSRmyN/K9gQUh+bY1tiwzkef1HZUbsloMQFOTPrNXF
         irHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707276043; x=1707880843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApcLgLGrxwLEuYf7+iIf/mNSaHhoA2l57UsnC6CxVWA=;
        b=xU5OyxVqGSHlKcCPFNhFAhAWmQNds0tydRE3hATQ3IUHeN5TsfVNN85VVlNMumFsRU
         NVgVKpuAMBYOVhKlIuDo+rRHAVyPWuAuzGX6su+z2q7pJxYELiSRmjq0ab5enSP/1a5u
         o+cpzZWnrowd1YoCJvQP9KRTXgyofPB/AqUeH7Rz1hkDGY/TajQH4TS7m4xS4wzYFh43
         2zTEJ9YL+m/dcU/vFEBcSU7RXnbPT1I+j9sjzXURnJt+64dqVFcgF5MKg6sX24TumEak
         jTyAOkqZFXSE2mQPHo5MnJuvFBJ6VNTGBeHXd6w7sBCH2d0LdZiEzktqTLhSjhvMPTLh
         CBRg==
X-Forwarded-Encrypted: i=1; AJvYcCX/ahysXSnio+7QAjEpe1ItjWvGMJ2dfP5spZ+r99RlDL2fxvYRS/5HkRqpxTi0Uta2HEV/lg1QrTainsDC1IfGJdZD
X-Gm-Message-State: AOJu0YyryPmO8lIqo8hQlHNoPDkLxFcxvSbpLfXUh8n5QEMXtfnVG8BI
	2xouUHTYqDs56BLvxdHRW/SUcHG417jR+rnW8/k75x9vQ7T223GVGwudNAkf3/f/YdEN8z2IVp6
	PHA==
X-Google-Smtp-Source: AGHT+IE6+ak0PAgn0IRrGPuGwJrHJbNcaTNHfZcp6Flwwm7fwcPNynluNR+UQlMh0RNPJUkPjXawe1UpPx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10c:b0:5e8:bea4:4d3b with SMTP id
 bd12-20020a05690c010c00b005e8bea44d3bmr656047ywb.6.1707276043260; Tue, 06 Feb
 2024 19:20:43 -0800 (PST)
Date: Tue, 6 Feb 2024 19:20:41 -0800
In-Reply-To: <20240115125707.1183-5-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-5-paul@xen.org>
Message-ID: <ZcL3CdGHv5FQHBVD@google.com>
Subject: Re: [PATCH v12 04/20] KVM: pfncache: add a mark-dirty helper
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 15, 2024, Paul Durrant wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..f3bb9e0a81fe 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1399,6 +1399,17 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
>   */
>  void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
>  
> +/**
> + * kvm_gpc_mark_dirty - mark a cached page as dirty.
> + *
> + * @gpc:	   struct gfn_to_pfn_cache object.
> + */
> +static inline void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)

Any objection to kvm_gpc_mark_dirty_in_slot()?  I want to make it clear this only
marks the gfn dirty in the memslot, i.e. that it doesn't mark the underlying page
as dirty.

