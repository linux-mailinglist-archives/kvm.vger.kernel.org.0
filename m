Return-Path: <kvm+bounces-43830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A3CA96FE1
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 17:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33AAA1885D5E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 15:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF72028FFC4;
	Tue, 22 Apr 2025 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6IV+lrb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0383284B5B
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745334186; cv=none; b=jaG6etWa4PmDGnY8uaV6jGWdffbNe12hZPlC50MaXBJ1pNi53gY1g117dvZq+wieav+4dm3f5sGu3RPGqJlPWBqm1M39DfAPf2UrGBskK5AGaX5USJ1t20SW2/pWhw+GR8lX9bbAogFqraohuFEnovAlpn74yNECyenpHqrYCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745334186; c=relaxed/simple;
	bh=a9oHiuIRd+Lat23wgyOLQVKu0davNOYNyV1lqgu94Hc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XpuN+hxI8PhKxgkZSrJGE19j0csRHaqzwui9j0zPupMsVo70B5zkG8dwhYhXMYRtvUnYcnPG7O5Pe0/22rLTFnZq4AlycGe1tG18hrEYXj2wI0dvswnvxaHXvr8fecVKChWkFCn6820Mqr4euqEcZAMey4b4XgfkQbcFFduGtmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6IV+lrb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-308677f7d8cso4887706a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 08:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745334183; x=1745938983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR743ev6ExzRYE8cINx+AM9cywgAmFfoIc+SqezuNJU=;
        b=I6IV+lrbYv0t+bvIaiG0TbVyWJT40Lj0vRqcLzc3/x+0dcZml1AnFM8HQY5Ii0wkCK
         EFI9GLLncA7Nf81PeY4qYgGpbEdk6GQtvjHUrP43uS7sYSItfs/Hp/W+equBtADhN9iR
         H8kGG/d5XAZylKSAL++q+ioYsECrBM0IYZU7VUdqcrJGhPa3joqiDrIgBusCnfsOOjmZ
         /a1Dr6t8bvSNSFRCHQvERf4r1hilrZRf/fX4p3Lkj5VzPiie0d1c69yQE2wP4ATTE3E/
         J6p2quspRGpvtugOYU1sLARWmrmhAeltWiFl33W2BwncgY4q3qCNTdFwpdJXyCO/Kkkj
         To3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745334183; x=1745938983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR743ev6ExzRYE8cINx+AM9cywgAmFfoIc+SqezuNJU=;
        b=lztj4OWsgif5hk6Wy5TBP9P9CeWlx8T8p3JIP5nSXV5Dcozud1om3c+O5qXCZfZUic
         exC9ONWyFuKAupGiwsVxlD1SWivFyJvTqUlyjR6VeVLb7sbMcgVwfB7nUcA2gw/OdB5t
         2vPF5q2SrtROIMLN5q4rLTKthwcrkZfzAVMZgIMKjIzgaa/YrsP6z0YyNKuDlgekhTUj
         qQUR1XgZjhbBfEIHW/huz/h2xuW99lu2HFNcrRVlWMAEqpQc91dNUzYMSKR99glzSUOQ
         vW+5Cg4ccRpRe5quAn4k/fwjFxYrkF6BI5i4ATMoI5oN/rL62uYxemZBUKkUcZA+xDql
         1TNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwSTjhUmBuwno2msWZD9pEXJXmh5TrWCV2+M5wmCppRLibdJvR/DuY/YbFV4z1rEA1MAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPJ6D65SNmUkZnpbamLngF8gM53QEjUisiTB5Evw5xiwogtTOQ
	7jxfm9U2Qlp3T+3y6XUs0BxazmBBOTkXJAfQiM3PqAbX5zTQTZsCwdjFJ7Tv3p7uhIsPHhwlu7O
	aog==
X-Google-Smtp-Source: AGHT+IEIapJZJRM9UWSGs3HX5eEFDXXhucM1QTXJfnPOK/9YTrDfsNmQubNfg9xjcSY4LHTjaYmG0pXn5/g=
X-Received: from pjbsn11.prod.google.com ([2002:a17:90b:2e8b:b0:308:861f:fddb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a0c:b0:2ef:31a9:95c6
 with SMTP id 98e67ed59e1d1-3087bb56439mr25794718a91.14.1745334182926; Tue, 22
 Apr 2025 08:03:02 -0700 (PDT)
Date: Tue, 22 Apr 2025 08:03:01 -0700
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422082216.1954310-1-xin@zytor.com>
Message-ID: <aAevpauKYWwObsB7@google.com>
Subject: Re: [RFC PATCH v2 00/34] MSR refactor with new MSR instructions support
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org, 
	jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org, 
	namhyung@kernel.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com, 
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com, 
	pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org, 
	boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Xin Li (Intel) wrote:
> base-commit: f30a0c0d2b08b355c01392538de8fc872387cb2b

This commit doesn't exist in Linus' tree or the tip tree, and the series doesn't
apply cleanly on any of the "obvious" choices.  Reviewing a 34 patches series
without being able to apply it is a wee bit difficult...

