Return-Path: <kvm+bounces-28663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0916B99AF9E
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 02:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF1BB1F23E10
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 00:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95FA28F7;
	Sat, 12 Oct 2024 00:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bmcyO5A1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FD0ECF
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728691598; cv=none; b=fediskcWgzpm0w5Uck0LUpTqUkzD6miuKSk98WmhrceGY48t3dw2pFccrcUgf1AtMbb9Haay4f6t8hU+FcTSWAJaFvqNhBg0uirVJ41sdo4UEPQctEIsvCouSoBtHxg6anuaGATbUG1L6OP08QpHx8VRsZN3rpHLbej28PJ301c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728691598; c=relaxed/simple;
	bh=t3TLNz2E4rgMhV27LFTKr+9sh/ErwejAIcLrZeG/qJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=im/TqoyGE3TtPFZTCvNiNh+3HZQKPExT5fK1AXKRU1bLrV0Z+e1MqM3vYGF2tK/A/Duc3GVQop7LEd17yi8IJq7hRRWiAFpTKMMwOOAuRp/SKp0gNP3HhfNYsWOS8fmiOW9laIOyVfnXPuTX5lylvm3dVCaU9rwAbnHgHQWPdi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bmcyO5A1; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e370139342so238407b3.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728691596; x=1729296396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/nRmpiTGInlZNsyI3l1+i6JO6oRaqAjuAzuB7Mjk4IU=;
        b=bmcyO5A14ORv3MUxSEyMj+QSL85zoQUr0SBHVORYZas/pjpIPtHg0mL7Yi3uWGwO5h
         4peewKDfF5wwz4PN6M0+VB8EuIIFNKTPW/zDlIn5HE8Uz6Uit0CwTG2cGX96pSZ5202l
         Q8BGjSn/Q85ZcVRYAn9fE9E7Gl4QEZb9vEF+J/ak/DoGhi5Wv+w2fcqRtFO7QhJEzP81
         PfXdJmnErYj6CBhd7gqrUqE3mM5gT4IQItrROE3sXaM2OydLpJ1wBFehYcY/EbML4TZ2
         tU+rhYGi7f3qoC88snwQS+TqU/lyaLHOiWi5VY84FsfZKUSlHYJcOFSMlKJt+tErNVbA
         FuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728691596; x=1729296396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nRmpiTGInlZNsyI3l1+i6JO6oRaqAjuAzuB7Mjk4IU=;
        b=T7fTlRoTnmWqbPu3TH6u4wdBrILa48xgmzyVupI8Fk3pspN4TQu1N4foAQLYKhNJXN
         zBInBkekE9jVhBYEWEErdBzhNmqlKw6SS30YAYulPsYjGJTiH/nP69LeK5tVIYG17xz0
         /9fC9BVizolDOQlIDt4eXkyI8ScqgqVLVc20iJuE6ISKs3+ybv/iyNfFi+zagt2ju7sx
         rxUva0sqUCjYcSrIdkhVnyPxKJKzxG33hgBtzwKK9CXXbfQSdaW2khqHaCYrYwAkR17j
         fF57CGOx6wJOWUKxlt+WQV+/gq6W7GBMk+lG0FIuxd5SP7nQzFfnz7XOeUmQYY/goFF+
         D/4w==
X-Forwarded-Encrypted: i=1; AJvYcCWIstjFaZWyHd3GjmcjDruHDEBpzSz/J7fIGGqgLjDizjP41T4HmGGdg7GzD1WEF9/YMv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrOAPAe7jY45AuF0ChU7ykAuCVJRa5FDGHzZ+Qg2UDNcuhmzvv
	Kr4+8QOKF+/mH/T4sJj7WLpl/u0gupq4ioJEOiGd0bZNMMu3XKW08xNDn+IEl/z1+v2DC7oNYvi
	sNg==
X-Google-Smtp-Source: AGHT+IGmg1G8D3iaZFPKbxx+zXZg3+J8J46ueYAFXlaPRYj8EeGFAmMz8qDSVUrjhu3L0gi/qS6ZwxDhQbU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:63c7:b0:64a:e220:bfb5 with SMTP id
 00721157ae682-6e3477b451dmr1379997b3.1.1728691595692; Fri, 11 Oct 2024
 17:06:35 -0700 (PDT)
Date: Fri, 11 Oct 2024 17:06:34 -0700
In-Reply-To: <Zwmyzg5WiKKvySS1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240927161657.68110-1-iorlov@amazon.com> <20240927161657.68110-2-iorlov@amazon.com>
 <Zwmyzg5WiKKvySS1@google.com>
Message-ID: <Zwm9isnme2YLcuhq@google.com>
Subject: Re: [PATCH 1/3] KVM: x86, vmx: Add function for event delivery error generation
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, jalliste@amazon.com, 
	nh-open-source@amazon.com, pdurrant@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 11, 2024, Sean Christopherson wrote:
> > +	kvm_x86_call(get_exit_info)(vcpu, &reason, &info1, &info2, &intr_info, &error_code);
> 
> Wrap.  Though calling back into vendor code is silly.  Pass the necessary info
> as parameters.  E.g. error_code and intr_info are unused, so the above is wasteful
> and weird.

Ah, but the next patch invokes this from common code, i.e. can't pass in the
necessary info.  _That_ is definitely worth calling out in the changelog.

