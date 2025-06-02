Return-Path: <kvm+bounces-48208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BB1ACBBFE
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 21:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2EFA1704A8
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B43223704;
	Mon,  2 Jun 2025 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="meH3T/1U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80659188CC9
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 19:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748894258; cv=none; b=HjgEJmFS5gsDZhu3ZzYNvBGnWhQTOpDa+Hb4J2RpwljbNLZPT2JaVrvveeLm99y5cHILpq862k4DdGOaX6ojl4yobnN9jkYCXc1l2/r6QlFMAnW/GO3pW+EGiLI/LO6nMwvOpq5JnKoUm4p5wsNSn+6hfhZ4cI9xlbW9LhVV9Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748894258; c=relaxed/simple;
	bh=d6rXMvriGn7F74qvpM6fJDhgm+iMCwCspQeTuBeU+E4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pmYkKpTrvFPaFHCemO6rxiN8jmOw50De0YKZqERBthE8X85lUMS26BwML42M3KjTlvdrhY0MBpduBEG5QS22VQXvl6gAhCDJJOOGhz0Y2Kdy5moV6eLaEZNy/Pbu+kKqD2YvOC2RimIQegFZ6RKZOOXmDQG3y7psoWmHXudy7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=meH3T/1U; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d84fe5f8so1111540b3a.3
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 12:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748894257; x=1749499057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d6rXMvriGn7F74qvpM6fJDhgm+iMCwCspQeTuBeU+E4=;
        b=meH3T/1UPRvx1c+45JfmK6rlJqs3IldeRUehW0EbYxqX9Rc5n/ywftp4sGwVXVtCk5
         VwHZ34Bphi5PwMYO/bohwVgOrEZLZQ+JKjmq2+8iECBQzGUlSJvhuCpfmU39jFByQsin
         xqiNBX7skHAd4e2XXnT8JLf9/SdLA+31WnHYjizhyl/wD0tXPRvQILLE/OC/jYaulT+k
         0PL/6G1iNlN3+xA0vgY+G8CgLMLgseFT82KQWeQM3Glsp9r348Edd+5bUQVk1hz7U/WW
         xBbhOAHWsPFjBR0jWnB6TD8Xka6IFNQ7G5Qs2oIACQyNNb5DO/aPUhTEwk9zCU4I4IZ2
         gfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748894257; x=1749499057;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d6rXMvriGn7F74qvpM6fJDhgm+iMCwCspQeTuBeU+E4=;
        b=CzRBxZs1PTmWEVVx53Q7o0/vJSQiHSgvnaO3AHKN139RKDDoIogAZ2NPcmK0bsKqEv
         MUrhtzwnWAaIJZIVD9X0/a51YvcUxWhvE+p8ZVXPwRgv81awinuCnX+1KUXMvoCqobzY
         cq2I9DcSCpyl/2nnNWPlaIgUfCeNujHST0tkxxcoNraUpoMSy08oolxLwy9dlkbKYAFp
         hGLNNqsGqqTnYWzEmf2xe8cUeR1dIwyQF2uhd9p6tv0LMDQK2zZq/j6or9q0q7SgZ6jr
         h/DvViV+Cu+OlVP32SfZdLU9oXvgyjgrZwcEj26xYlznLiHzoATwryvB67r+wK8J65iU
         0qlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRsWAB0BLpH0D1XSJw7RFgpPpbFjMm3elSSbJ4U+6bf522ypfcK9rdbPg/JSawxWOfE2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl1+Sa/PjySzL+MnseqRV85x23sWf8+ZTd8Y1L3nTEbpyV1eAd
	pKyWUsg6UXPqptYc43deNbJW4s8MgmYm1FmOsVAIW7OgIggcqoAEKHplarFGi3jmksJGl7HbYqQ
	eF2jolsAgXXoYvk/mcnrucuywGg==
X-Google-Smtp-Source: AGHT+IEhiReAYaMOY2n8mKP/bO9xi4dqlmeJq5b6LQZT+kOdJfiK515hi4mP6JUDpG+R9Ei5g3uPaHt2Ni5raxGTKw==
X-Received: from pfbih20.prod.google.com ([2002:a05:6a00:8c14:b0:73c:29d8:b795])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fca:b0:742:4770:bfbb with SMTP id d2e1a72fcca58-747bd9ef267mr21492058b3a.18.1748894256756;
 Mon, 02 Jun 2025 12:57:36 -0700 (PDT)
Date: Mon, 02 Jun 2025 12:57:35 -0700
In-Reply-To: <20250602172317.10601-1-shivankg@amd.com> (message from Shivank
 Garg on Mon, 2 Jun 2025 17:23:18 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzv7pdq5lc.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH] KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation
From: Ackerley Tng <ackerleytng@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	shivankg@amd.com, bharata@amd.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"


Reviewed-By: Ackerley Tng <ackerleytng@google.com>

