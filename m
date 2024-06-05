Return-Path: <kvm+bounces-18973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B75C8FDA5D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D07A1C20999
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9B916C68C;
	Wed,  5 Jun 2024 23:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSQr++8s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629D816B720
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629691; cv=none; b=IIXwBZ4l27HmabN2UJK4FoS2jM7ONy3EGgtMQRgjEDcQvSlsVQ0RkO70IG/eCS1RNblqEg8ZSDTrio3bS/dY4KL31SLQGNWDU9egrGc+qvv5DJtPN2s3/Es0EJsUasrEVPVQQf3m/OOr/sUY5B1iqS23jqmca6rHUsiF6Fh8P6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629691; c=relaxed/simple;
	bh=ZOrN4zg+K7N7kSE1fOSYgRToVAWCxMLXo4wd79OV2Ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=f5QL9Ip2Dc9W0tuJZE+OV676CywxX7hXo+zyRGjJWUWJr3PzJnsn25CMwybpu+FNIblmkjliLzbnF405bKzYOVgWD53hlDaeUVFZiOv4QYzFVHs1DcJ+IXFAUaYnUFSQIsYya2+KgeU7EH7zBMvFr2vU89EvYm5jPK117Yzx5f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSQr++8s; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6fc395e8808so304488b3a.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629690; x=1718234490; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p9lQV3bwp+WyhcMuWrhuXkd+DPwayumfVlw4EupMxAA=;
        b=cSQr++8sXBDSUCXmi2Eff186ffHdr1ybe9CjBCmcVeFso+YdYNQM2an4CSZp5LN+XB
         opf17V+LwhAtYyU0qS7rSlIUl+FRWw3ir+N7fmd04mQLupErUvCx96OvbP6t8a47HItu
         W5KrqM46S0umumkowFKdRKEX7zXIt8Wv/p+BNyhHyc91QFWHgZMbC5ZkSU5PmB2aTQSi
         WYzklY7CCfm3AeQOhkPzwOJK+MLffMfblIHOGVL5Hznw6G+4bLDkHepAjmVbsXf0B6Ke
         GGqroukuW2iE8gJYh+QVNXUOm/rIyXZ5xXJimHeYHnNxeiACT6dj7PY0LZCDXoKUXVwU
         O9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629690; x=1718234490;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9lQV3bwp+WyhcMuWrhuXkd+DPwayumfVlw4EupMxAA=;
        b=Mh5od1gRa7V6rjlikxgd+3ncXQOJPWcKG88vAbFvt8+YlAzz4FdncMvYXK1q27oqAM
         NbKRvAQq/UcAVhUPqNC6DfS0oZEFsOTVGA3uU2k4GBprrX/iH28xih1c6Y7padeogfzF
         +N7aC5yoUAntVP2CetRaD5Xc0IOxmIaW2IJLTIKkVMpm6K+ltikleHi996YLrj/78gwO
         HqYpyy6XITb+Js+9cNEBgf4ppK0Y9qujd1TcuVAapCaWFznXzSb6wWwZHFJ1nLkxP3kN
         I/9hivLnZENN664qNi1fqN6sHSDicyNh0w1m5/XH0XF5wfuFAt01U5E27o0Pcitq+Ps+
         q4bg==
X-Forwarded-Encrypted: i=1; AJvYcCUUFgt0GuCzhC8AzwuEQjzdPUudb1urpQuJbQyZsLn5xjHYeLJOhokzu4TfDdV95dew3jISieFnly4FFCzofTQkXcFB
X-Gm-Message-State: AOJu0YyR/ZkUxXcsDdzLLD2CPjrGS1635REEoehVsdPyISQHxhOynh7W
	Ems2Ow8jvjlAf6COwrw7csYjXFZ8S90lc7TlgV5/0/R86tcRGexzi7ptb8TjG247fQ6t5xn/cjU
	VqA==
X-Google-Smtp-Source: AGHT+IEKI7U+HXszu267lZY82OuOx+0KazRsf/APybW90AxPH4ncyviH+COLcRoHf7IxDGAIOwWek2UB38k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1798:b0:702:2c5f:7614 with SMTP id
 d2e1a72fcca58-703e5bcc6c1mr146357b3a.5.1717629689552; Wed, 05 Jun 2024
 16:21:29 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:40 -0700
In-Reply-To: <20231218125559.604107-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218125559.604107-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762782273.2911499.4536767399145940803.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/msr: Fix typo in output SMR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Jack Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 18 Dec 2023 13:55:59 +0100, Jack Wang wrote:
> s/SMR/MSR

Applied to kvm-x86 next, thanks!

[1/1] x86/msr: Fix typo in output SMR
      https://github.com/kvm-x86/kvm-unit-tests/commit/784dd85d25d4

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

