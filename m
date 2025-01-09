Return-Path: <kvm+bounces-34940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1142A080BE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00333164ED0
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62051F8F08;
	Thu,  9 Jan 2025 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JqDWhsYx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2E5198E77
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452043; cv=none; b=L0rSdkMXMSkmrVj5xToP+R+Yh1RYDZkfCZhHg3mhRrxqHEIO+OZ+b2JKWq24HFPPUjRH/ked/7N3WSGZ8OlhmTbTF+O0htMoXbr8Id8ZMvRSluax7rn8XbCwsZXyBDBFydk2glZe8Q5+Gmt4r6QzF7KRoB5oI7pVBcivBgoDTmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452043; c=relaxed/simple;
	bh=QMJtvDLsG9Ws7SbNiIFCjE5oPZlHJ22IOkyZHjTlvXk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OxUgCRZ3Dnms58AJ7ESl3bKgmpTEhRP1msxexbKw/2R/KZZC1+iPm/30++ejsuz2RMHMXkCmXzF8atunImks257LSK5hqz9FqoenHdaKaQxxuoD2IegjheCb1RxXc9ZrOuQTDR1jfFbdiKHZI9LZ3T5UdIfmgdWE5fXQEkaV4Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JqDWhsYx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so2324323a91.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452041; x=1737056841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3r2n2lztKn4ILN6wEm1Fa5xg3mTCQxvirvmLRxvyVxw=;
        b=JqDWhsYxSX/AMTm/OkFk9SPub9itX1dHOiI7DZIK8rWtsIIQdr2MyFy9uD44TvwBC8
         1Oxw+HqLE71A4Jn3MxjUDJ2hu4nooW1J5xU54KvMSHVX3Ycl2Bs8ORYJSnZp4yYug1M6
         Ml/DvIr/yh12LeKJWV5Z/gc1T5gP0WqYXxu+zzrXgz7VWMQDBLssStJYtSZq9UPwY2j2
         6QRJPZS6+lXtlMiHK3/6Pv6JfRVJTqdVnDsqQDt4KkDk6H8FkE8kZ+wOEofS2i5X7DIX
         TKML4rFcFlhIwcBi1OH7JZTmOMBDvObVdI5IORX/HU7veqwIM71qxym53YkFyyeHV+nD
         XuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452041; x=1737056841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3r2n2lztKn4ILN6wEm1Fa5xg3mTCQxvirvmLRxvyVxw=;
        b=PPyzG1+E4TG3csRIcY85SXOEVDRtSNKZD7drLA7UXz+ucSriFFHIF0fzw/xF2LMlXc
         +FG5mYig9pm4kpNWbrmGJPXiuwEkxDDfs36Wd3I5djrUxPz4xOdNs1z2a+kLLQoH+N9g
         U9CnHvWDA8wWb6t7Z1JPO4JWFjwoXw3MBX8IYPRJNQ8mQ5MFM75B5cXgjiXG1pWMl113
         zqlvtW/EvfbuBjUi3UE7F6vd18jKtv79EAlL+BHtDtA+5W7asMvGecmOOsOZdBRmVgjZ
         28Xr9XU/x3Cdys6ipTGTRNI1SlutisurUTe01cBHVJyCut0xUMx/mmeWdE0oGWK5xl8R
         Q3Mw==
X-Gm-Message-State: AOJu0YzBB/qiDNUf/q35xlUYVnvuGU/51jzIDrhjnER90Q46CIMzThoB
	BFh9pT4PwBxzcB0gQfX8/Aaq8kJdVT0LEDO0r2S47slYalX3RZBjQJGuh1jbMC3xmUfubpeBgVI
	KLA==
X-Google-Smtp-Source: AGHT+IFVZbs+gJDRLq8BKkvX+z/OODWxwWvs/uwPFkz/jUJ6+xNuAb/Ui1cP339s7DCocAouTuC9ymhf9FQ=
X-Received: from pjbqa8.prod.google.com ([2002:a17:90b:4fc8:b0:2ef:6fb0:55fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc4:b0:2f4:43ce:dcea
 with SMTP id 98e67ed59e1d1-2f548f1edafmr11562401a91.25.1736452041088; Thu, 09
 Jan 2025 11:47:21 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:03 -0800
In-Reply-To: <20241221011647.3747448-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241221011647.3747448-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645175967.888731.7554447818595629812.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Avoid double RDPKRU when loading host/guest PKRU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 20 Dec 2024 17:16:47 -0800, Sean Christopherson wrote:
> Use the raw wrpkru() helper when loading the guest/host's PKRU on switch
> to/from guest context, as the write_pkru() wrapper incurs an unnecessary
> rdpkru().  In both paths, KVM is guaranteed to have performed RDPKRU since
> the last possible write, i.e. KVM has a fresh cache of the current value
> in hardware.
> 
> This effectively restores KVM's behavior to that of KVM prior to commit
> c806e88734b9 ("x86/pkeys: Provide *pkru() helpers"), which renamed the raw
> helper from __write_pkru() => wrpkru(), and turned __write_pkru() into a
> wrapper.  Commit 577ff465f5a6 ("x86/fpu: Only write PKRU if it is different
> from current") then added the extra RDPKRU to avoid an unnecessary WRPKRU,
> but completely missed that KVM already optimized away pointless writes.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Avoid double RDPKRU when loading host/guest PKRU
      https://github.com/kvm-x86/linux/commit/4c20cd4cee92

--
https://github.com/kvm-x86/linux/tree/next

