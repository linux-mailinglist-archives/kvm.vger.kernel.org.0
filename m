Return-Path: <kvm+bounces-63617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E3BC6BFF8
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id E5EC62A5A2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B444311C22;
	Tue, 18 Nov 2025 23:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TruRME2n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE937311979
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508493; cv=none; b=VBQGuYguFReBG2UE/MKZbOcjEr/gf8/E0MPro3cYPvLzyP3ZlRJUw7lpV+LqMIuIcyyWHwQnkua/NK9S16204sF7N9kYu3+jt4ivPNV6kDhKJOqrTfZhuEc7979Jixz0eiQj966NuVK73YkOM5dlAMXrv47tjLMYR5d9q/3Dt18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508493; c=relaxed/simple;
	bh=wPQfgjX0531jhkc4exlxWHTF9EoVdciIjz94itFwPzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=syjjwBcWn6vjpYuBPi8RQ/YTujNMSzzNu2QVryQ/xqX7zFoSSdHmhxNhEHsrQCWhzRq3BKhVpBn5S7SF9QXm7MDK9B+8jZST03V8hKLuoh7mUUH26KzG2ahC1iLTaepR+jIJRSeNbscPZtrfK5IqUe99ejLXWwXqxEsck/TjOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TruRME2n; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297fbfb4e53so108298465ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508491; x=1764113291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+kST3GQZVOqkvBR2T4YRgIuO1T/E8j+FWAZOyono9Os=;
        b=TruRME2nLzsvPovCrEAbZbHmiPecy3VGfalSVRiKGjPKqTLHJPgIJYNEDd6I8HTyhi
         s/SCsazCLDMehk76DkkN2w8vC3i7qTC2qmqrEZAHEKk3sLKsHxt/Vhp4dtXxUTOKlLG2
         1PrTop+wooFkx5Z2J4ewCoJibIXATNnUEitmd5A8v8wjN0ECF5Z4EGEtbQPs6B99VKV0
         HciaObdPicCk9WJrUKu2G/uC7D3wU8FHuwQbL05VhC6X+n+Jqc9jW2fMYEKRNCp4muP4
         kad1fw21UQAeHr10Fsi5sWR7SQ3nK3HR/X+sefrWnCk+c4LFyrIH1QrjP9riq24UKxvB
         nPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508491; x=1764113291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kST3GQZVOqkvBR2T4YRgIuO1T/E8j+FWAZOyono9Os=;
        b=HcgnkOukPshdR7/r1qSKYjZWO1N/B4e2kX7sammGEAYGJoDqsvYgOhdv9ynNWnUX9K
         PpkqtpzqmBTo/9T26MEauEEajKCNy7MIjZmMd8U8RobxOjoeES/qNv2sw1EMsWwOw54z
         6XtABC2Ud6OdLA5OiTX0Wg3XzZRpXaz2CvF6uKy7iwnHeSs4dfDh66E+HW6QLxjalLis
         qLFMOTO+K1alkhSA/y8jv/8iCyXfxYXnIryCkAtDCze6cwTTvbswI/JjRJKUwRWOl2hI
         QfCZcSqYTqwjyssOF/ddRIf102i4BiEiS4z6LFOCOesf+EBBsgCUK8ByPeeVcAa50flH
         sxLg==
X-Gm-Message-State: AOJu0YzRlVL0GExe6vG/edtQ6N9TXsYX+/jSVdH5sO5nkjtF/3aicMAj
	FMM+3PL7hHzHYJ6QJWlC7LtdJPAxrQUKPp9UlReQkXN48htNlR6krs/KEX+1MqfC/zjgeIhewDJ
	xe9QEzA==
X-Google-Smtp-Source: AGHT+IF3unDisEvIelp9tmK5YVXwfkrmx3vOlH83Mkhc+ZMl8nLPLeEwvX1pMv2rP6kGupum7JFPRZDSivs=
X-Received: from plhz17.prod.google.com ([2002:a17:902:d9d1:b0:296:18d:ea13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:a8f:b0:295:7453:b58b
 with SMTP id d9443c01a7336-2986a6b56b4mr208502295ad.4.1763508491132; Tue, 18
 Nov 2025 15:28:11 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:46 -0800
In-Reply-To: <20251113205114.1647493-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113205114.1647493-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350820887.2285264.85098693325976839.b4-ty@google.com>
Subject: Re: [PATCH v6 0/4] KVM: x86: Fix hard lockup with periodic timer in guest
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fuqiang wang <fuqiang.wng@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 12:51:10 -0800, Sean Christopherson wrote:
> fuqiang's patch/series to fix a bug in KVM's local APIC timer emulation where
> it can trigger a hard lockup due to restarting an hrtimer with an expired
> deadline over and over (and over).
> 
> v6:
>  - Split the apic_timer_fn() change to a separate patch (mainly for a
>    bisection point).
>  - Handle (and WARN on) period=0 in apic_timer_fn().
>  - Add a patch to grab a pointer to the kvm_timer struct locally.
>  - Tag the fixes (and prep work) for stable@.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
      https://github.com/kvm-x86/linux/commit/0ea9494be9c9
[2/4] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
      https://github.com/kvm-x86/linux/commit/9633f180ce99
[3/4] KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer
      https://github.com/kvm-x86/linux/commit/18ab3fc8e880
[4/4] KVM: x86: Grab lapic_timer in a local variable to cleanup periodic code
      https://github.com/kvm-x86/linux/commit/a091fe60c2d3

--
https://github.com/kvm-x86/linux/tree/next

