Return-Path: <kvm+bounces-19380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E21990485E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA1AE1F254F1
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E494F9EF;
	Wed, 12 Jun 2024 01:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TWNW4uPm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8F4A12
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155356; cv=none; b=d6liGkTnys1QTP8fwhJJxRxn2nSLWn+sPciHCFxX1zvywhFkwMEQVhypzn/xE5a0HkXhpvvrYXUUC20qS/fCibdDnItfj08KY6+5y8jPd8opA7I/ccH/F+we8Zyt6S5WuUr84tKfpVmNKIUClbjaYeizbnm+S+MCfOp4YQHm6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155356; c=relaxed/simple;
	bh=WGnoUKkk0REcKP8DhUp6zDAS3aC/MvLXK96rqZdtGaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ht6SVUhEhfTdhJdWuhlzb1PdiFiQuV5byXQJbBISq/HbBBDEWTP+m5mWYYGzOxo2Od9DjA492BPkFmNZ7eqqRhnsSOEscgh3SXqiBk4EgC6c0SFwL+q1X4spne5yAkEGolwRvAEjfer9duivPDAbQYsUOhF86Fvtr/owFNVAUn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TWNW4uPm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f717559ed9so3003225ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155354; x=1718760154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gsl38OeWaseD0bhgbBqk9c5YeD4h+uI4W9a9RzJGJxI=;
        b=TWNW4uPmoCtD1IYxVlnGWtOFopz23CqzKM7Ta9ZhWtWOIaP0uB6qfDEhOaOu9VZ+Mz
         LVWoyGJ3eF6bYWJviiaKIiT50JNvwAJVQR2bN32yFE0fhjW1c85qZfkFSiXlQzXrby7K
         C2RiZkKz478f73eEHbCjXjr+fHb/ifYS3KjqnX0a9lJKGzGO6nnGo07fZyDRcXPKYOHL
         xbE+3cBDGqkWO2ojvSVT1Zp6X9ewrqsiuKI36CsVdlaFpoZLnOfQ3TRiR3gCxWNn9wnm
         1kAl6tINXhYadeBiwdECZz9d6sBwPzWAPG5NFFYvw7fvGk5R2AR5lpwA7VrqmhxNMM3A
         87cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155354; x=1718760154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gsl38OeWaseD0bhgbBqk9c5YeD4h+uI4W9a9RzJGJxI=;
        b=b+4X/Xmy/j2JHQzMxnnHj8Eo4MFR2mrYx8xO5RDIy2qIDRxfQIzN3hQtRjvueyq1Z5
         7kIzjqepkQn7pYJ2K7yhgjvTfo4aF1rs9qX31xY2zGnYv8IzRb965MkXq6KBjbvsiYpE
         3M0MBSuxRsyDJRIn2l/VBCN74C3zkdrJz96YlJGPPAWmadxkd6hKzyRFkT80vvU9GHa9
         uLPBYUXhY7VHpukOEHE57U1gzQ7LTtE56RuH14FlrvJnmdnmL/Rtwggwr2K6k8m4MoKB
         0pY3k/XUZCgEQx60d+DgxztAAw+avTG8FEpSwaGcN2qWSD7BY7yq+Kn2SjyfTFwEvI20
         2hYA==
X-Forwarded-Encrypted: i=1; AJvYcCW5ZmrIv6sUXT/qLfjuOqPRnu50H5P5DcncDcnmSZscjqYahx91Chf7FRpv/YZLBG6Ei7EaxE3QEonj0ocdfnZri+8i
X-Gm-Message-State: AOJu0YyGniyC+MPYIFBk0JfYM8SZG0VB6x3BJJZnbAaYJ67hoqJ78BEZ
	U13OWBzgXUMZhspqScSy3ZT+sIY8S3/WRNhHXQ0kGuNnZp4YhHZecf+LP1nRaSSRyE+QdYaG8gj
	/dA==
X-Google-Smtp-Source: AGHT+IEPXS0kQUQ/tPmBAPKKg/I7Y+RcRDR1CVCBZLmkEfVOXjdKLVUFBQyIA6kDe8AFI35PJE3jQvrv8rg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2281:b0:1f6:d661:1ff2 with SMTP id
 d9443c01a7336-1f83b1932d9mr505795ad.4.1718155354497; Tue, 11 Jun 2024
 18:22:34 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:44 -0700
In-Reply-To: <20240605050835.30491-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605050835.30491-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171803414611.3348413.15273837667155862569.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftest: Add a common check to identify AMD cpu
 in perf event filter test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Manali Shukla <manali.shukla@amd.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, nikunj@amd.com, 
	thomas.lendacky@amd.com, sandipan.das@amd.com, ravi.bangoria@amd.com, 
	ananth.narayan@amd.com
Content-Type: text/plain; charset="utf-8"

On Wed, 05 Jun 2024 05:08:35 +0000, Manali Shukla wrote:
> PMU event filter test fails on zen4 architecture because of the
> unavailability of family and model check for zen4 in use_amd_pmu().
> use_amd_pmu() is added to detect architectures that supports event
> select 0xc2 umask 0 as "retired branch instructions".
> 
> Model ranges in is_zen1(), is_zen2() and is_zen3() are used only for
> sever SOCs, so they might not cover all the model ranges which supports
> retired branch instructions.
> 
> [...]

Applied to kvm-x86 selftests, with a fair bit of massaging (as described in my
previous reply).

[1/1] KVM: selftest: Add a common check to identify AMD cpu in perf event filter test
      https://github.com/kvm-x86/linux/commit/6f19c3165d9f

--
https://github.com/kvm-x86/linux/tree/next

