Return-Path: <kvm+bounces-50793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00138AE96DA
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9758B3B1F8E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F06523BCF3;
	Thu, 26 Jun 2025 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="M4J4w3vt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76092264B3
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923306; cv=none; b=TwtHUOeKYiEa8UIsVuVHBuwdlsRQN/cgUKQz/1Wxw6pw0Gi3Vwgx9Sk0DE11eugSwP4Fqi9IGiC7mzJd9cNDG8ifnkjWAtDdpAr9jaCb+9qcQ/GCmUWcQ4mOB/9UPqOHkMInoh+j52CQXlSj5mdUjrhxQBeO9yIiB3vgD91v9cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923306; c=relaxed/simple;
	bh=j6Opc35X7leVU0nN3C3XsQlOnL1x7ewbkhtYcLhuFgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cvRx1nR3d+5Z2u3dTzkdbQuhoetDH0Oq32xifeZIMtTLJENXzAeDPQPRxhcuW4VWKYcg97nyWa+FY08hxWkLjxH42E6oL40jEPiWMhfZcxMbQ4WOcHsn8WjZZYW05wAVzeNcEoJVwUc0J/Hh/5nLCjaiKFMYikvddn97ufmDobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=M4J4w3vt; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4531e146a24so2943835e9.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923303; x=1751528103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ii+zWZS3RNOqzq3CZGEODgqk1meUnRXZz1gnHNAPn40=;
        b=M4J4w3vtaEXLT3Lx8wCXc0ULGWYiD8dLN3gfPKQfhl2TBg71cr1ntWK3hui1IF63S7
         PQ0Ro6IF6EZXk63zlFjQc1AqlSjvvEK452eS3Xb//cyFh47WLywBVGnw5DvVqSyt6jjb
         B0zJ35vCxri7YExHtAayNwWetmiIAH6VU1eBk2CvVT1glrGWoNBQZNTchAIKd9hw/4K9
         9FaAeyGjCsKN2L9Zcscbk+lfeVhWQaz76oicr1fGqTrO6uvk0BHF9KgzqiL0qZibrXDR
         SOvMdA0a44BYHwHBIXBg6lBqUCjuU61gfsjXgKJllwTUdOJ4VWk4nzaw/9J7uQ9tkGUL
         Uscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923303; x=1751528103;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ii+zWZS3RNOqzq3CZGEODgqk1meUnRXZz1gnHNAPn40=;
        b=O61y8JV5x2diYmwtq8xzHfvepCOSnTD9OYzirxWJMQ/c/NmNVQISdlgWp48ah3wNNu
         4Sfsxt5B/MY9ztDFC+NC6GI9DKRbVbdwhDPWvToGynDd1w4ejA+FE1pyK7D3eLsRXY7A
         i4gzIdRzixnUtojZ0WhpoqOWPQeOHk/6e7ASdAVZKTTvmnfDDeE5KNp7dNS/bVH/czFz
         cLRQTFLzneOLrjvCtHhqFjBBbvp9BqxEGXS42CVsdFEzj+UOD+7u/TWwOszsgyIFIaBp
         uC9uUjyf/8nfqF+TPd6B2N76P8+SIPubLW2ey4lmzBiUe5rDL/vQIvC7oOBZTp+lfeB6
         PNaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn8Zd23/nvuB3WLo/XffjcNT/j9e9Qs5z58+G+GMceg53oLRFX0qhfuEjNUCIoeT4nBc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz17o7FDFkLyR7NO3uN23X1X1zhEZ4Sa+qBqlmLO59l7Mr56YrI
	61F5x7GDT61+YiH4P4JLxu2O8mIYvU2SJkBN7d1czwq9LZk8XaR/tCof3O151og/5qM=
X-Gm-Gg: ASbGncsi/c8pYG836xeSxcs0XhhgNzHUIiQnqu1yXS5GdRfa5Kiv4/XKc3SqMSnw7T4
	WSa3A7VfQf14wUDINEtYU2nW5HnqxQi+UmM0i8lpHFNBpY/m20kUFndPwPij2lzNznfXkz8pwfY
	GKdOb+b+s8M8TAt+y3+pzbZdpACx18XVoXbY5giIGuXjPFgDyvTebanC8j49ph+x7R7Z9jwOveF
	+C3Bu3Mqpouz/tFe8scbW4+9/2wxFgSfojM8oz8LYScnIMcK7H1AShOPpfVHWEXatXrAIM5YSQw
	EESx2lv+WiTD+R9VIgxoLQ66+1VnlH+pN8GDMqt+v288Tv5bl9j9977q8H6GWAeZ82vwta/Gwgv
	H4y5PrRG7JPwsBP7XzP58o4UwX5mu+JVL3N0t42Zq10ZLyicgtmZ0Erg=
X-Google-Smtp-Source: AGHT+IHIdelXM/juBeZdBT2mpMG9IEAeg6WqVFuLaLCqevoOdj7pu44PT6QaSAm6TwE764TKwiDEHw==
X-Received: by 2002:a05:600c:348f:b0:450:cabd:160 with SMTP id 5b1f17b1804b1-4538b24401fmr9526295e9.3.1750923302924;
        Thu, 26 Jun 2025 00:35:02 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:02 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 00/13] Improve CET tests
Date: Thu, 26 Jun 2025 09:34:46 +0200
Message-ID: <20250626073459.12990-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is a v2 of [1] and [2]. It's merging the two series as well as
integrating feedback and minor fixes.

[1] https://lore.kernel.org/kvm/20250513072250.568180-1-chao.gao@intel.com/
[2] https://lore.kernel.org/kvm/20250620153912.214600-1-minipli@grsecurity.net/

Please apply!

Thanks,
Mathias


Chao Gao (7):
  x86: cet: Remove unnecessary memory zeroing for shadow stack
  x86: cet: Directly check for #CP exception in run_in_user()
  x86: cet: Validate #CP error code
  x86: cet: Use report_skip()
  x86: cet: Drop unnecessary casting
  x86: cet: Validate writing unaligned values to SSP MSR causes #GP
  x86: cet: Validate CET states during VMX transitions

Mathias Krause (5):
  x86: cet: Make shadow stack less fragile
  x86: cet: Simplify IBT test
  x86: cet: Use symbolic values for the #CP error codes
  x86: cet: Test far returns too
  x86: Avoid top-most page for vmalloc on x86-64

Yang Weijiang (1):
  x86: cet: Pass virtual addresses to invlpg

 lib/x86/msr.h      |   1 +
 lib/x86/usermode.c |   4 ++
 lib/x86/vm.c       |   2 +
 x86/vmx.h          |   8 +++-
 x86/cet.c          | 110 ++++++++++++++++++++++++++-------------------
 x86/lam.c          |  10 ++---
 x86/vmx_tests.c    |  81 +++++++++++++++++++++++++++++++++
 x86/unittests.cfg  |   7 +++
 8 files changed, 171 insertions(+), 52 deletions(-)

-- 
2.47.2


