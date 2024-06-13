Return-Path: <kvm+bounces-19609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 67907907B66
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E940EB22B95
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 18:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767C114B96B;
	Thu, 13 Jun 2024 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2US+rGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4714B064
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 18:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303510; cv=none; b=gxSG3EIyZZnZujld6DgSjoEt5x6a/hklC1tIq5kkRfErfDGCbu3+4kLhrDCk+vfirWHPb3TtLiE01Jf3e9itxw0uuu0nfjsv4qVmghIg1xOdk5UUktGy/hY5rFM9X6mAI3OORMYfb2EAg1Kirmzi9mHK57+68lZuW/410eUPVD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303510; c=relaxed/simple;
	bh=FAMe6ZfN8ocTQz72VF1wxp4zgj8DpMNIJ5NFawO1sOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=brn5rqL58A2lOgy40C+jnUqydHRGXdINcpGPc1zU4+LeKb0uwnCJqoFdAt7lxuPv9aau/Zm5vfwDZWsnUNaOLMHVATn+lMUi5QblCajry1kmw8OgOMxzCkC3jPuMAUlSkEGmXEKV0Mf7csCEf9uEaZrtzUG9+YGDEl29Ucvu0vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2US+rGJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfede368fcaso2332005276.3
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 11:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718303508; x=1718908308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FAMe6ZfN8ocTQz72VF1wxp4zgj8DpMNIJ5NFawO1sOI=;
        b=t2US+rGJT+tw1WrqvQIBP3/7VKiEg6tkZyQEdACI1XLRpZJ7vM1pp0MVy1geqUYTDG
         ahLUJIggTcbLDrXBns+jVg83aog7ieHnqoe8PBTb3XdEhGMKK6PnCs6N/e3m4cX2EoCR
         XGkJ9hekRet6LaNoGChWGsBmhHVFcAWBRMHoeTFhWdroW502g3kH4EJJrS4HrmzIJNiZ
         VOqj/bboWESATyHP/eNoLfvioKkAbr10vjErh9yBybIMcTVGBXuml3ldCKIrZ6tYWWZB
         agc8AxR+aUsEBPacMIN32OkblTs8oQcvMkoeqkteksCAMAlPZhB6rFJY3Tjmt4pYOaKb
         OkrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718303508; x=1718908308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAMe6ZfN8ocTQz72VF1wxp4zgj8DpMNIJ5NFawO1sOI=;
        b=FPpNdBVuyEo9SL1PVrxNT2Inm3gEQYCgCBPL8R+1cwqFYsGVIwjcmXlgakeb7BrJcG
         Rs2tlDe+Cp0/uvbAjr5jAf9KX92zpm8GI0eB9MIyqIzWrTZTiL6yiGX7Tv2kD2IK1+Fo
         Yr/X7/R58kVP7/tByh7k/Wa0tPWkFQtep1TOEte8WaF1PeBXKxYdJuSBaGkis04YbN9h
         OWWeqpSekIfs98xKuriduyYCKDnKUSUQOw8rfMGJVde9bReYZoOaLeFs0958w60L4uCG
         rvxOr3teb+nOX9MQuT/ZGbS4hua5JOkbfgKpvpvELFpUetT5YK/tZr42RRz4PB092yyE
         MzqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHAfs2eD5Up2Awzi8aAOxTWvnFVcp2W4SwxRcbTQKTZi6z/UQkEupRdewii0c9Rbgbwqzqs9raVrnX8PnDrZitl0WK
X-Gm-Message-State: AOJu0YwZy+4lSrLUp+4huT+SMMJ3+oW0dPcx4E3tuLlP5yhDXMP+R89+
	4RnKjOsASbu0uMrT0dcQT6YpcpOThYkzTk4U5Izoj3kO0ZojF+Vg+l/tQ9I/a+rj6d2mT85MEHX
	TEg==
X-Google-Smtp-Source: AGHT+IHJdhDYs97torwnnhU6KnlaCZsdrWccR1M8UsNd8oy3s5V+SSgGLN9j20SAhn7b35SEH2kqBCITkow=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8445:0:b0:df7:9ac4:f1b2 with SMTP id
 3f1490d57ef6-dff153d7f58mr42781276.5.1718303508321; Thu, 13 Jun 2024 11:31:48
 -0700 (PDT)
Date: Thu, 13 Jun 2024 11:31:46 -0700
In-Reply-To: <20240207172646.3981-23-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240207172646.3981-1-xin3.li@intel.com> <20240207172646.3981-23-xin3.li@intel.com>
Message-ID: <Zms7EnytQfy_y4mw@google.com>
Subject: Re: [PATCH v2 22/25] KVM: x86: Allow FRED/LKGS/WRMSRNS to be exposed
 to guests
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	shuah@kernel.org, vkuznets@redhat.com, peterz@infradead.org, 
	ravi.v.shankar@intel.com, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Xin Li wrote:
> Allow FRED/LKGS/WRMSRNS to be exposed to guests, thus a guest OS could see
> these features when the guest is configured with FRED/LKGS/WRMSRNS in Qemu.

(a) please describe what these features are, and (b) one patch per feature unless
they _must_ be bundled together, in which case there needs to be code to enforce
that.

> A qemu patch is required to expose FRED/LKGS/WRMSRNS to KVM guests.

Omit this, QEMU is not the only VMM that uses KVM.

