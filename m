Return-Path: <kvm+bounces-19677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78073908D58
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22CBD1F21E54
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44912C152;
	Fri, 14 Jun 2024 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aqoRzW6e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9F9441
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718375192; cv=none; b=mciKxYWp+jbsC/+HmsXUi7ro1461qxiXI6SoSeRG9dFsLBQi+6YZpChuKCicoNWc1zIv3cwsVfh1cpUfdxndvi4tG9ZKTxY4R4c8wdNzLwiJUcsiVqW7AfoH6ZHNWLxjX+i/2+pS8ONgrMjPmeOo7+zkq+lHh2TljPimpG6aTmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718375192; c=relaxed/simple;
	bh=7j7RKarou3hl5t6/ms9FZoofbPeBd/j4YY94NY9binQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RVLiciWOxH4S6gUYb3tsqDA2umH1zpWehwmOFZWL/IK3RPKhebozNoy3rLnII7A4uNPjSrH3fZeYlZ2SEIrDZIYLDh7CHPWES1Pikvhk1+4bUL5FbElKTtanPKAPdx7HeUz+Zl3oK+KEDc3vl2Ty4VU0U7gZ3DMGpK6XSdJXYI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aqoRzW6e; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6e4381588c8so1616618a12.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 07:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718375190; x=1718979990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nasyRkg2ILRh/YAYWbuYBMHiTq7JQ6y+XDBRzpI9vpA=;
        b=aqoRzW6e8Cjb3MEWw3FigFEEt6TJIPCDx7oHRIX6u0ctAw+jvSUYC3C1z4ZR8lnGRf
         /efBRxAIrZUsmqlRuO3dw8Ucv52QRnvBnZrkFddSPobw8fXbOiudG/oBeSZhxXrdw1XQ
         7VbjpQ9OsPsxVJdvH3KvFCPjeUhWgHwtLDwrQxtDdlR/6m63DBZZd2/Oz7a0G6o/AS5g
         1fpOWS/Xg/QRyDqL7fRk2CtJ3shIiBNTRrtFtC3lzcBgJaN6ulyHTFFCv1rcR/sOet5t
         cR9ob30n1ukqx5YXMXvfm6QlVKmI/I32kIrI5tYz9i558svXqZ8GPRd9apS3xxnRVZSP
         20yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718375190; x=1718979990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nasyRkg2ILRh/YAYWbuYBMHiTq7JQ6y+XDBRzpI9vpA=;
        b=Tyz0KvL8haXhbA40cyzlOCaG7+EqWsnRH/TMQ0HP71y3oOx5C3rMeqXuqcwh9alaOo
         DOYC75s8F4eyxUIbY9Uk99Lcb6yy4Lkgk7nC/eVv/SemEdNryZe67arsG5RdWXdDJfFe
         h72j7PmFsnitOLNYBd8AZP3CSDF+3qO7BYCSwy5JsfD78/fu6ydUKXis2tVxjg1Q+xwB
         6SFgXryQma+xQ8PwpHoPbAmk472vhLOuhmI1g+1nFSD0nX7myZHVWVZ0n/JNs5kU+65h
         zbyIshLp/PkVIl7pRwgrwjiXB96Xs2Im6nVO577I2toW0Th/ZZsa3VfYhvYspubz/vn0
         /UiA==
X-Gm-Message-State: AOJu0YzIpzQvPvkJr+8WQ4KJ1xjv34MWsFQzeqJfVvnWbsjI2E554DbJ
	sO0MaaoacD2azBOSnKe4wysi2vf13WLcs6Zop9faiNJ2BUI7k7Iyn4+OfytPOB/cafo2bChadO9
	QEQ==
X-Google-Smtp-Source: AGHT+IGjRObNpX9KIsl9WxDlcemHAgpcLuSHBB94Q+1V/qnvufd1b+w11daIuop/4a9V26lZY4tffs59NR4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:50c:b0:659:23db:a4b2 with SMTP id
 41be03b00d2f7-7019a3b9e51mr8263a12.8.1718375190093; Fri, 14 Jun 2024 07:26:30
 -0700 (PDT)
Date: Fri, 14 Jun 2024 07:26:28 -0700
In-Reply-To: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
Message-ID: <ZmxTFFt1FdkJb6wK@google.com>
Subject: Re: kvm selftest 'msr' fails on some skylake cpus
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 13, 2024, Maxim Levitsky wrote:
> Hi!
> 
> This kvm unit test tests that all reserved bits of the MSR_IA32_FLUSH_CMD #GP, but apparently
> on some systems this test fails.
> 
> For example I reproduced this on:
> 
> model name	: Intel(R) Xeon(R) CPU E3-1260L v5 @ 2.90GHz
> stepping	: 3
> microcode	: 0xf0
> 
> 
> As I see in the 'vmx_vcpu_after_set_cpuid', we passthough this msr to the guest AS IS,
> thus the unit test tests the microcode.
> 
> So I suspect that the test actually caught a harmless microcode bug.

Yeah, we encountered the same thing and came to the same conclusion.

> What do you think we should do to workaround this? Maybe disable this check on
> affected cpus or turn it into a warning because MSR_IA32_FLUSH_CMD reserved bits
> test doesn't test KVM?

Ya, Mingwei posted a patch[*] to force KVM to emulate the faulting accesses, which
more or less does exactly that, but preserves a bit of KVM coverage.  I'll get a
KUT pull request sent to Paolo today, I've got a sizeable number of changes ready.

[*] https://lore.kernel.org/all/20240417232906.3057638-3-mizhang@google.com

