Return-Path: <kvm+bounces-26188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E64B9728AC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810931C23D64
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1E5168C3F;
	Tue, 10 Sep 2024 04:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lxYoN65"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007F1553A2
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944286; cv=none; b=p+L+nh98VLCVikcM+HOsX5ciDdMfoKWpP3iOiC+wkb/4vJdUj5ndukf122i8RJcVemHGqirbS+/mQUJ84ZsBHMJA9+a/llkQBiYtK50G2iw0HDues9/KeI49wwEu9wYxz06w09jocEw/IKieHQNBW9A4cqkSWiHPStEarESrISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944286; c=relaxed/simple;
	bh=FANfRBs9745F/n8nS/13ygH9b5OMuZPiI9Otwuh9L2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJRR/4XQqtYi4W9cehpAdY/9NaLWncbfMloMkaK4P9OuYxVaCKAAPGfeCHvwWF06rcK8BrA7QAwsLTYjcEXUQhRipG0uwxFNuITO9k4RzqrfQ+QBT2Dcfcm7FhZ11zHxB4XZ+fbc3ycHRjfHBf9MRtkHjm7DBBWwLaSDHxrE32Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4lxYoN65; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-718db8e61bfso5377759b3a.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 21:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944284; x=1726549084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QFB1ugfLL0fxQUREq4PMsDAdlVWDpux+xApuQ6RvIss=;
        b=4lxYoN65hKpCM5Bh624ejHqocL/zx2V58uF9kP+9zrtrEBZ90FWOWadXLrxKzAirFU
         O3y5SUfajHIrCvoTUMRfwPCHzRAGQKDp4G/nmhsCXC89jNy54oN6K+6xCTC5ljqLgfpn
         8DReCWTnhHg1Ta/k2SjKtQ8GiVNonxbg+ICOiZJVYonvcltD58kqXIKgTQsXUCK9wMwx
         hrpYD+rhbI3p1HCB1UaQ9r7Ke8PtUfwMYsiIDd1qTCiRZJAeU+d9+gheYgFvzO2mVD3P
         rXsc1//XbrpC9oINQ/o+j5w7DpjVwxmWAOr+8+2Qnr7ROI2r3eIHQOCYpP7cir10heBT
         4TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944284; x=1726549084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFB1ugfLL0fxQUREq4PMsDAdlVWDpux+xApuQ6RvIss=;
        b=W8DUzLMDWIRgoVqA6gaewf0RJdfMcPd1pv4sCWqutG5HG+5FpYOBzJz33Am7AguXis
         98mKuU50AwYhSSuJtsrFyzQtXdDgP8zKUS/iwYHqVjSnWvKi/VUTZXTpaYqgqj+yGWgc
         lkDjvtIav5ZnNHk/4H0Uyenc+Z+O62TwLLkBtTk03oQsjYQwSia96pYlX5aJ/CxP5/XC
         pa4bCCjkVYrPgai5zo/7ujKURbqrV1o7ixbOkwMkqGIvWODD1tloJNarmzjTmICIuUup
         XpS/O4ZCrLvsK+g7J5zcZ3wfuJjs+VuokqDCOAJLXWZMmpT7L+JT/2N7LAd4KyuxidkM
         NZ7w==
X-Forwarded-Encrypted: i=1; AJvYcCXSG0I9Tn7LUaxp27d9v6R+2x9PxDKDWqII70gKyqGIWLKd6/6hqkmGmXqjJxV9jj6t9JI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8/5DW9i9pfqsTXa9ds3BCePbk+l+hJdH22zzA593RHPv1IfjV
	6YtXAf9v3O7HWK0kDX1ogQnAdhimnlzswJ4sFe/Y03TUrv5CcMYz9KFl3LzGyuGlEY8uB2wookG
	Rog==
X-Google-Smtp-Source: AGHT+IHJ3q9o7Hw+urLC6vWjslGKQ51olv7RabeHao64VlhABcBEZ2h5Qafdakqj5I1Dh9B1tnmEHf1/vqk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:98da:0:b0:70d:1338:8270 with SMTP id
 d2e1a72fcca58-718d5c35075mr86312b3a.0.1725944284049; Mon, 09 Sep 2024
 21:58:04 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:28 -0700
In-Reply-To: <20240905120837.579102-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905120837.579102-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594250677.1552518.5898875487744726113.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Also clear SGX EDECCSSA in KVM CPU caps when
 SGX is disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 06 Sep 2024 00:08:37 +1200, Kai Huang wrote:
> When SGX EDECCSSA support was added to KVM in commit 16a7fe3728a8
> ("KVM/VMX: Allow exposing EDECCSSA user leaf function to KVM guest"), it
> forgot to clear the X86_FEATURE_SGX_EDECCSSA bit in KVM CPU caps when
> KVM SGX is disabled.  Fix it.

Applied to kvm-x86 vmx.  At some point, we should probably look at using the
kernel's cpufeatures dependency chains, but that's no reason to hold this fix.

Thanks!

[1/1] KVM: VMX: Also clear SGX EDECCSSA in KVM CPU caps when SGX is disabled
      https://github.com/kvm-x86/linux/commit/7efb4d8a392a

--
https://github.com/kvm-x86/linux/tree/next

