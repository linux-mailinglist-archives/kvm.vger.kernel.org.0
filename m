Return-Path: <kvm+bounces-16546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 595768BB5D3
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15091286813
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCF37E579;
	Fri,  3 May 2024 21:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FTkdwO2Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780EE5D8EE
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772041; cv=none; b=ENtzoqQayZltxPtgRI5j0ywzrkpjbZIJE0cGOHLAF+VLzf52Ty9ikSgJCRo+p6xv0oOgaiXqFq4qSpyKEewnQgFvhPZ5iEi83qC+Gi0vBSeE4LV5ZwMW4woObM5ki2va/nmOlMee+Q/0TMzNKD1IuX3Z4vRIXfelNzF6CmDA6jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772041; c=relaxed/simple;
	bh=36cC8g6JzA71GzN4T022yAAHjxmmp9DkEXU0+S/limo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqkEXARhdCdjCwK22poiD+ay8xYx7jQdAhJp+u5VTA0PZ+R1GZf/d4TO7poyE3kuBMa6mU7w5aRq8i7q3AOtt8AE9UVOtWHJmUOYu6fx6oszSrN+XiaP6CnGNaH5QvlcGVHC1VIMlrPhB91aweXYPkcFO/yEgEldeHf8y0048ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FTkdwO2Q; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be8f9ca09so1356607b3.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772039; x=1715376839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0iglmd5+pvv0IzZJ2EwpPcomRjeC9m/a/ZDXqUlyNc=;
        b=FTkdwO2Q0qFQI+x4EFaBNyldzsnFxNAEnfuardp4NYCPiKCYBwJynVK4HR4dtGvuTD
         I+giQ9wcxHqax0J8QCj30ocNXI81KDHIpecjPLt8XcMU40OU3E0SSZpPUzkUWLJxMyKh
         cLqbI4C6oUlCBNTqHtMKobRwlngFLlh3m5e/0NgHUdzM/9SuHXJo7vGyPVsL/OXDWSZM
         iBCgato1w6TXbOg+qv+zC4hZatJlq263lAh14lAzkX4j/qnUd0V72LBQ0wthMt4COofC
         Ac470buC1Eky41+o2DVi7QN5xODs0Y+mXZb2NwrFxFwQcBVP9HOfOIIHKBlJ24/u9czX
         btGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772039; x=1715376839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0iglmd5+pvv0IzZJ2EwpPcomRjeC9m/a/ZDXqUlyNc=;
        b=T3kpGPAzBqfr99LuGvu2RgG2oJXh3WZ5nZO4fnzo2pjA3FCysHRooYsyeQXzqiAQcs
         gNFtp49gDryks6++XRZAdZyPQYFWyFZSKin79zE5oSpjBe7qwJVW6z1mMh98BabUR2V3
         UQw2ItCRCEFXSGcvwIyAdDNmh/4i8LnAgqTgES5kjb2U01oSrFZ/uqKRq2XNkX3zsokJ
         3vdJAsqURbO7rE7jAUylSynJuu2wPoH10A8Qj+GlKCYmt9ferD6/KEne5st/VUQTHALn
         gCO51TGYYP922pA3K3mG42AHiFp13ZckK6ZxAshM1oChYpKSMjKZD5rwzG0w3ONk+5RK
         qiDQ==
X-Gm-Message-State: AOJu0YwycxIbp327g7+NwmrVI9h0Wys0KVlBwRP7iqaUwvnfCTdZM3qX
	zoSfVDZqsq/SH3DSgZWJOhzH+/KhwdObKjBzNRMxHzlDCW6R+5dUeaelr+uQkmSOdYxu7qFHs6n
	KAw==
X-Google-Smtp-Source: AGHT+IF5dXs1fxVhjzOwO9GU+QPtNYVXc/pRtCAsau9j2ShBcSUB/AOahcpvakyScMkodl1gAz1tf/99wUY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e6d5:0:b0:61b:e50d:46c4 with SMTP id
 p204-20020a0de6d5000000b0061be50d46c4mr1000932ywe.3.1714772039570; Fri, 03
 May 2024 14:33:59 -0700 (PDT)
Date: Fri,  3 May 2024 14:32:16 -0700
In-Reply-To: <20240408231500.1388122-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408231500.1388122-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <171465959389.758834.11674247619237178621.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Allow, don't ignore, same-value writes to
 immutable MSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 08 Apr 2024 16:15:00 -0700, Sean Christopherson wrote:
> When handling userspace writes to immutable feature MSRs for a vCPU that
> has already run, fall through into the normal code to set the MSR instead
> of immediately returning '0'.  I.e. allow such writes, instead of ignoring
> such writes.  This fixes a bug where KVM incorrectly allows writes to the
> VMX MSRs that enumerate which CR{0,4} can be set, but only if the vCPU has
> already run.
> 
> [...]

Applied to kvm-x86 misc.

[1/1] KVM: x86: Allow, don't ignore, same-value writes to immutable MSRs
      https://github.com/kvm-x86/linux/commit/1d294dfaba8c

--
https://github.com/kvm-x86/linux/tree/next

