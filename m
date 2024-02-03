Return-Path: <kvm+bounces-7887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D70847DA5
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73AE71C229CC
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B33479C3;
	Sat,  3 Feb 2024 00:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EQIz3FI5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E3A4432
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919172; cv=none; b=fpWuxx7Ju0zAGKvnxDHDRARKPvD6M7u+l8Wl806YuWmeL5cgSON5F7Q33nsqSM6/ScDypNX8kTLjQL2exoUcy0lTggAbCpkiiXMgcEzR2SOZnXDA5X3JrTlvLOwEUuOqKVpOuqoZvtpYYUGejwmmEwdCmgbCP41qSUY/g3vhswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919172; c=relaxed/simple;
	bh=k+JGmJT6pmw6BssMNubU4nZj2bP5QOThSW+G9JE+WGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oNMwPgYUgPSBOpoVvdUq8Cd4Xs8JRZODjCMPaocWX+RMZMbEuiRU6XEjljP1VxeROJEOfzx/4rYBqtnGC/0iryr5tlw1ELvu+fgQpsaYpMJlc49U5qt3ncLHEp6GaCWP4JiCNr5STfOLidMx1LhE3iIlXBxhY89J5j87KgqGYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EQIz3FI5; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b2682870so4327345276.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919170; x=1707523970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RFHy4J7jDQ4d5j3WCPCBh8/2qvapIS45X/oK++3Gn9I=;
        b=EQIz3FI553KtrbtE7faX2fAxLHjgbVtobjQSZ7frcWj78znQRvN9qWTlCRG6jerUzp
         nNSBiwXxBCUv895JeGGE0lnVgD4gIgWLaEUaafuPHVjT3BOMQN4nK7Tc3F1JIWSJsG8I
         1zi07p7OhPzo/o14WsBnGprFhr7g+UKwrgKCOEGiLtcIQkQ+NH7Ky270nGhi58LWVsXu
         49dNDBf+eRDDIioISEZftX24forhAG2dlZegRXCW4pwtVyRhsqs3V8jv0V1jeNfWMM8N
         kTsMX92ZXaACOOVwgMGj8SxJEMo2y6sNH711c05GVA2Xc0Skr/CA+BlLZwqHyhlyMV29
         jzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919170; x=1707523970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RFHy4J7jDQ4d5j3WCPCBh8/2qvapIS45X/oK++3Gn9I=;
        b=s+kwXatbLiTLFh4bo+yAbdgSWhvibj7ISyaq01TsEhEvYrRsHueARI4J8Mr5XiCXyh
         rajAlfKiGuwcwZsqdykYmZAQ+YW6yes1EmQ9eVWu789gV+eEYwuQhuLQJTYEzfiI6kb0
         3VZAfnixmB+SUnkI3ZQAeZRCes1kWrEM3t4bMOf/T09X0QdTD87axSI6DzaXp40u4jD1
         1zAJO12SQPUnFnmy49WUsQ5kq9Fs/6rS6zfQZWJjHTHErEHtgRFSQ5mua5GKr65Y8RY1
         EydqxwTMbYKSKtYCzpzXqkazs+NCmQGNaejsp/kobkbZZy4zBYO1Z4jYIsrwNiGE5BSw
         Gs3A==
X-Gm-Message-State: AOJu0YwfAZ5/3PkW1qPLvEMXgVagtVnh5lv+sNLcDhii1Thm9kHIX7pe
	RYaW7QzVgFMGiLdeHkgW0MrfPQ4xf5HbHDseWQsa1v8OqYqOZYqS2qW/1Uv2N/RgEL8GMPCIH6D
	UMA==
X-Google-Smtp-Source: AGHT+IFtgRuypcYnht+yj6Dzn4uM5bNp5pQWc4eKniN9iWD0/HJITWw8l42f5Qj2/gotmpENlxiLRrKUbe4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2192:b0:dc6:fec4:1c26 with SMTP id
 dl18-20020a056902219200b00dc6fec41c26mr29129ybb.1.1706919170350; Fri, 02 Feb
 2024 16:12:50 -0800 (PST)
Date: Fri,  2 Feb 2024 16:11:31 -0800
In-Reply-To: <20240103075343.549293-1-ppandit@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240103075343.549293-1-ppandit@redhat.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <170671742789.3944893.6069307090680601894.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Prasad Pandit <ppandit@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Prasad Pandit <pjp@fedoraproject.org>
Content-Type: text/plain; charset="utf-8"

On Wed, 03 Jan 2024 13:23:43 +0530, Prasad Pandit wrote:
> kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
> request for a vcpu even when its 'events->nmi.pending' is zero.
> Ex:
>     qemu_thread_start
>      kvm_vcpu_thread_fn
>       qemu_wait_io_event
>        qemu_wait_io_event_common
>         process_queued_cpu_work
>          do_kvm_cpu_synchronize_post_init/_reset
>           kvm_arch_put_registers
>            kvm_put_vcpu_events (cpu, level=[2|3])
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
      https://github.com/kvm-x86/linux/commit/6231c9e1a9f3

--
https://github.com/kvm-x86/linux/tree/next

