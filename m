Return-Path: <kvm+bounces-24967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5449895D9E0
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1C891F21D60
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6001C945A;
	Fri, 23 Aug 2024 23:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKWMxrvM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192A81C93AB
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724456919; cv=none; b=cQnEAL2wXUjuuAkaitKTGFa/cAVsCjt7u7QjMlROmkbBNo/MusRBjyt+XMVLJSzizLKyeDw4/+SqpkJBL2YiUjPd2alyAJvFRcPkm/WGfbF7KD5OCMHCFBkVF0y3h1px8avcy20dEoyIyj2HmavIGDdAdL1cFI4TQQsCvjv0yi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724456919; c=relaxed/simple;
	bh=yTs+plIBCInK+0O79AAq+iqlWNkn1V7hIneyhTJ5kXw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gRGBDx8U1QyJoS6iK/i7GgJPzFKlrXej7CMGEYJKIpJptLQYyGqOwjBRNE2ZQFbq3xd8QLmoJyFrVS4gPffMZqClXnsQ231GKZFyCje3SIK9sXbomKoJ1Xd5QY+uoqsUGU/T1E/bjE3QXF0BlKFn2INS76WUDY6rg1KyxISOsT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKWMxrvM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e02a4de4f4eso4020222276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724456917; x=1725061717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPEf290WPK/3AGbs3y/5156ZOO9zlpoap+WdNFLRkig=;
        b=BKWMxrvMrJzx1F7iPyyDWfKXnS9oXv1G80sDx9pPIWywqfGeLD9XmQcmKjZ6Fvlc17
         JrSAYa7VicQxZBISkuWgQKp9GllbmDFk7T0CYhjEpoEgaL1aVA14iQ3w1WRUfILDmLZb
         qKbE8flwh2H+2JQQjhMLI4Nlqrq0wfJ4++/8P2knwbHhCrxQyTyk+FMB8yZusSS+ZG2v
         xt1fotCzn+47GwE7FkH8pycXHmCmKm3OWFGj3DmQcl+J3uAbwU0iS6oWaJ2mct5j735W
         iz7jQ3gDiQFXamy0q9NC9gkcxdrk9iiD2NESc/Sh7DjKIHzQ0flm77omU7vptwa844UE
         n9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724456917; x=1725061717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPEf290WPK/3AGbs3y/5156ZOO9zlpoap+WdNFLRkig=;
        b=ARtZwF/5xfFalq4LEnrl+Trf7E9j8teajy+2f+ybbioMcReZHAFyr6pdQQ6lB9Fg7I
         iIz3V6wglPbM0oqG82sDzl4Eoxmn5+SuoJs50PeqJAW4x3yswIu74FFxo0eP91PWrr9j
         em7DGBh+TmyTS4ygAUPRtAEAf8OtcuyjBqVQzTcpwH/co8eohb2J84nh7pG25tjQSQgO
         peASB8JKDAsksw/0tsFO41a6wNqKLkwdIvgmDRLBgfVR6s1jaQQAfyjso9RyroAIiXyc
         08yki8x/jxZxBYcgdACVYpgp55odDpAdHClcLzFXyhsCHZw46RKbpQjcWSnJKdXjwSbG
         Z0Eg==
X-Forwarded-Encrypted: i=1; AJvYcCV9ur8YJAUg16kxEfLlzB3Q8ugmU9h+qCrrREHpqkFl+waDvQxZwJQka23LzNyLypeB3Is=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtTQQQoKjcYuTKNNQgyVV4sXxzBs0aVJ1o6SbRtE/3hsY3vlk2
	fNhU8CtCebBm0tBanPUaEpEzctA4UyAHLAbyuRG0+tjngnyf5XEM7I91oKc7Np0wpyzRp9LNn3F
	3uw==
X-Google-Smtp-Source: AGHT+IFZVQyGUAEgfkUcHSl+iO4j5CBhDHRlmbrHgERH+zarpw2I8db1rsxkUHjUUdfeTTTxK6yWJWMcF9A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:160b:0:b0:e13:e775:5a3c with SMTP id
 3f1490d57ef6-e17a83b0933mr5176276.2.1724456916885; Fri, 23 Aug 2024 16:48:36
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:43 -0700
In-Reply-To: <20240718193543.624039-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240718193543.624039-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442195625.3956685.13979535644680422623.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	Ilias Stamatis <ilstam@amazon.com>
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, nh-open-source@amazon.com
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Jul 2024 20:35:37 +0100, Ilias Stamatis wrote:
> The current MMIO coalescing design has a few drawbacks which limit its
> usefulness. Currently all coalesced MMIO zones use the same ring buffer.
> That means that upon a userspace exit we have to handle potentially
> unrelated MMIO writes synchronously. And a VM-wide lock needs to be
> taken in the kernel when an MMIO exit occurs.
> 
> Additionally, there is no direct way for userspace to be notified about
> coalesced MMIO writes. If the next MMIO exit to userspace is when the
> ring buffer has filled then a substantial (and unbounded) amount of time
> may have passed since the first coalesced MMIO.
> 
> [...]

Applied patch 1 to kvm-x86 generic.  I deliberately didn't put this in fixes or
Cc: it for stable, as the bug has been around for sooo long without anyone
noticing that there's basically zero chance that the bug is actively causing
issues.

I also reworked and expanded the changelog significantly to make it more clear
why things break, what the fallout is (KVM can _sometimes_ use the full ring),
and to call out that the lockless scheme that the buggy commit was preparing
for never seems to have landed.

Please take a gander at the changelog and holler if I messed anything up.

[1/6] KVM: Fix coalesced_mmio_has_room() to avoid premature userspace exit
      https://github.com/kvm-x86/linux/commit/92f6d4130497

--
https://github.com/kvm-x86/linux/tree/next

