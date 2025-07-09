Return-Path: <kvm+bounces-51945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F071CAFEB99
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD14C189A238
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F612E8897;
	Wed,  9 Jul 2025 14:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="049eQRP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC1F2E7F39
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070037; cv=none; b=dwUjZxWpCviGAv3L2qRzZUYETYNz3vKbYr/5Fq5/nFrchku1rXUhPaEP7TRv2DKI9K58SMfGOcGQTK7InBL/6ksvmP1OexMn7WNJ+wZ9CGbAEUlpu5OKZquJOx9RA8CGmoeiOV4qst/uczit3e0OOJCM8wPCzyoZy/mAQyBasr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070037; c=relaxed/simple;
	bh=wPv9CU2zeuEb1myHv5loO7O5iv2t1aD8aURMiOBzn+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FrcZNjqYNPsZ8QUCG35ctnMx0Wh20qqVCfwLAYca1lGDSTl+q+39GfJ9ru9+Mqu0s6Gy6N/xTgV+a2ffxbg0mmhCq125OVdKzMYtmiqpzI1ROXo8zzBrd6fwHWTQt2A/SZzk7p/jTOygKAlxC8BnXMYTfDn4D+56N9eE2S+Owvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=049eQRP5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so5142753a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752070035; x=1752674835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mH6+wRQc6/x9U67SE9dbsf8SKx9qr1rE+pQ3r2Tg9Zc=;
        b=049eQRP5PxQBAMp0gi+4vrvqZ9WZXvFAuQ/CkfScUmvvPKRQ/lIDp1k0kMdos6MS05
         kkmUmkc9Y5yrwVS/JoSLi6aAmXJmeo0MIY0ftYpdDXOmp7fyJa07Y/YlKpnA2t62f3P0
         Uo1/2mr0G3HG76PxYwwYoQWzPcqQ3v3rz9Kw2lhO+ceO4LUmzXve4amMPOVuvS5IIfKL
         wQHBk9esUxADcGyOdqnjAoSoD5A0IOzP6Qd4SRTplmOz5E7qFnB3OKo5dqoYqyKUsDdf
         c0OFdb8C+NgChevn3jerSrfY88sAXJK8L28PN6fnZ152fPIPhByL8NjGfFU/eWQegSb0
         wTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752070035; x=1752674835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mH6+wRQc6/x9U67SE9dbsf8SKx9qr1rE+pQ3r2Tg9Zc=;
        b=s2fwL7QDhfPlS1Mv9xk0pfSTpajHEkhoqE2mL5czBroX8X4Mx6bXDxFrZvIDd0r2V3
         r1ZOdc7fw3qjQPMDgpKhh9HjKjQ9GgiSQjATBs3QLu12PWebm3L3p1TapP3i7s/oX79G
         f3nr2MgpvSmk2W/xcf6NvyYqX8KHham21UxXc76EU8Mqk7dWi6EfBgyxKE9X7Al8P4b2
         gu1Z/3w+KTaHNOAHFjLSHeS03slxYi0cGKcD8TAMQ4vheh5E9chTdHn/BoAbQhHuUtb/
         5NpPuYbHsQyYWZd6toYELTtnR6W18L6yGwoolosA5AAsPK7MftUMVnD0MqMdVeBpxEGz
         CTQA==
X-Forwarded-Encrypted: i=1; AJvYcCX5ufV0xwmguVSOU5p44dobNiNIpwehJuTQntjG8DMVGmwUlJ5T2WcCf3TH64tIBgdXI0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAkANvG65dG76e0TWQ6+ZI3lcBweDk9E/gNMFMiKD6F5Zy8T8o
	DB45K5nD5IhH6eyaecrgN0D1weUATbnmh3fSsNvdO8XTulEekGegxZ+BQgQkH5v3BVfKwKkQvYD
	PhR4j/Q==
X-Google-Smtp-Source: AGHT+IE8JFRsysw8nP5Xtj4iPUoHYgNgZEhlop9LjO/MxRQiwvx5s9x0fMXiFzQg6vRl2H+bb/+6YfNBABk=
X-Received: from pji6.prod.google.com ([2002:a17:90b:3fc6:b0:311:462d:cb60])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f86:b0:311:ea13:2e6d
 with SMTP id 98e67ed59e1d1-31c2fe31041mr4208350a91.29.1752070034793; Wed, 09
 Jul 2025 07:07:14 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:07:13 -0700
In-Reply-To: <20250709033242.267892-14-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-14-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53kUYo9CY1fxcj@google.com>
Subject: Re: [RFC PATCH v8 13/35] x86/apic: KVM: Move apic_test)vector() to
 common code
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Move apic_test_vector() to apic.h in order to reuse it in the Secure AVIC
> guest APIC driver in later patches to test vector state in the APIC
> backing page.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

