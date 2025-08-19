Return-Path: <kvm+bounces-55062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FBEB2CFBE
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E788258802F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0281257829;
	Tue, 19 Aug 2025 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1740cC6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE7212577
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645461; cv=none; b=k/RdXPoLMEUIVVbP8BNqTsliu3gMBiWmxQDavoq5iKEZkcJu6YKmCgRhUwWCA6kIwnm1YAf08kJmRGx43Q6SJLWdtrj9GL2RrdF5edn8Ph5cGG/FGwZuilvkOhT80FD3jaIMEIcQYPyUvnpPqvYeKD+04s716rKxiq9Z/VPUB8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645461; c=relaxed/simple;
	bh=out9DGEgrIviYX5OQnXptMfYO2ioMjd8Ge42msARZc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=R9fe+weK2vskn2NqE/dOyxu82D0vD9On0J4hH24iNmrRr+ZuCZPT6F3RHcSHSvlMG2RAMEfpK6vcpufum6l7lUM1rG8CsVO/LhPg0SgxSPkMTNo5DFd9ePKpnb6lgX3bXJuU03mzTCWCETlpCHVt90suEJQi/9Uq1X3tKmbW1eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1740cC6o; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806dc88so146386985ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645457; x=1756250257; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KryB1aDOMDXsCkNpHOKPKNmk6DDPqkT43yEH/UgBA18=;
        b=1740cC6oU20IzhqJA83v65kjN6zYWxLLcLjRZYMS+wuccAf9LNk/Dc2joHtfIGELvS
         n1GrUw2pMTdjWccvnZy4Rk/A8+zRsBYXUcGnL1yKpXVPcehvvZJmnwuzn58NGV1TO5Ze
         bBl42IqFQ8Mp3LI4fhAEBhcomgXHHkym3l11q6w8g0TvD711GLRJZibL49RGyAARqibN
         WAc5sriTmQ7Rpacc+XYnngfh2lcoL6nZZmwK0nv6QNeb3hHyqqqt3rsotlfStcH1Sqcn
         ENv0AmbRFWGbq3SmAxFYl1Fb6PmX3c8LQLnVONwdeuMguNk51knEGRfeJwR0fP3SKfsA
         ygFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645457; x=1756250257;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KryB1aDOMDXsCkNpHOKPKNmk6DDPqkT43yEH/UgBA18=;
        b=HZ6TXXt4LK6sKOI59TUvIOB+7GaawQXNxR2/eVvj+/OHQYgy1QLNN9I+8O5NkUvK73
         zqrGU0XgfQ0pAZX8KOOTOUpqfWz579NHp01XFPaPLU3vu1qq/uEyBOtIIMRBDF/e3slM
         heQLnA7uSnA8M2/MFZtG/4vrHsyClN0ELxBDKqHlk/qrqYl6cf5I1/OBVNWsk0yfIadM
         ucSsnx3NQr3SwKnJfob0FTOrYLxr/WentY19eTjlyJmhb0Ni9VKeNmh8hdjgLNClQDcp
         +N8S/k30wG2a1234crTFSTNpPIn2tpG03L/OPrF9cOFaHwibh+QGMnL/qsuLd/r89V3o
         EryA==
X-Forwarded-Encrypted: i=1; AJvYcCUCUPDRRWMAl5/Ukch9LOzz4nqt1j5T2AtSlulbTVpglA63hPH+Q9MHYh1IX/exInUj0Vk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVZgZdnRm/aTHOzOrGPRwOmsU2CyNEsiN7BYjuSAJKCzifsG9n
	JcnspGLEaEWFRPI2/bVYLIJ+5KJOerN4dj2xqd/5WF/Kl6s3HgArd9r4y7vkV5WYmtOsb0Azyxq
	ukoaIiw==
X-Google-Smtp-Source: AGHT+IFJ402IKTEOa9VwlQFriR58PGWC72Iwqzb3n0Tzzk6lHP7IhmUL8jFd3gyIq/BVfta1N3jgZezYG70=
X-Received: from pjbhl6.prod.google.com ([2002:a17:90b:1346:b0:31e:d618:a29c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da8a:b0:240:7308:aecb
 with SMTP id d9443c01a7336-245ef21760dmr10035045ad.32.1755645456972; Tue, 19
 Aug 2025 16:17:36 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:11 -0700
In-Reply-To: <20250720015846.433956-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250720015846.433956-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564479298.3067605.13013988646799363997.b4-ty@google.com>
Subject: Re: [PATCH] kvm: x86: simplify kvm_vector_to_index()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yury Norov <yury.norov@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Sat, 19 Jul 2025 21:58:45 -0400, Yury Norov wrote:
> Use find_nth_bit() and make the function almost a one-liner.

Applied to kvm-x86 misc, thanks!

P.S. I'm amazed you could decipher the intent of the code.  Even with your
     patch, it took me 10+ minutes to understand the "logic".

[1/1] kvm: x86: simplify kvm_vector_to_index()
      https://github.com/kvm-x86/linux/commit/cc63f918a215

--
https://github.com/kvm-x86/linux/tree/next

