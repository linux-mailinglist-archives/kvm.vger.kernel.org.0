Return-Path: <kvm+bounces-34943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C3CA080C7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A16C6188BD31
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593461FFC7D;
	Thu,  9 Jan 2025 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bX6tzLeR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174571F9ED1
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452098; cv=none; b=b+Wv29MG8hT1kkoDhm0lDI0SkLmf/ilYIvZp4avaDBmQSLt3CNRo6s/aEFdd+pE6ZMvN2ZJeo2mrZlPzwvSsjX8FTUBVcLrjum18rTJ9WAELTjfvhybdIYNyQf4rRNUo3vcqJ/39CWHS1UsIabDCg1G3+lAS9yxIDMQBA9MMBHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452098; c=relaxed/simple;
	bh=k8uxNpfANbzKsnKB+ekR2JS8wirwWWhv9ItGKdM7sXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mf45w/eipBXLVuM3GbKteJFgIoRlWdA2+LZQJOPBHMjcHe7pAEnWVORnHP/FH2ATMpaoKw27IMoK7hCsyKu6gC7cdN0bvwTMh1BshAFtvsoH1M1ffZJuCmyN+zgwQjLmZOIeeG0o3v1w+3BR84Kn44BmIgXadFPQlnaZwBaUva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bX6tzLeR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2162f80040aso20415405ad.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452095; x=1737056895; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcpJVT6JUs2fS6zWLpYYaWH6+NENFaeQy0VEEx51Wo=;
        b=bX6tzLeRg2gS5qlZgXJQ383hDyXdnsQ73jnB3uIiYEDREeGqKPRKMotkzEjJrCZIBd
         01Z/JPNIZ15+KYzZ6Uq0SUrdtjbIb8SZwYXdlmGK4Sfwmo3oOy1Vq9sWFIp7Co07fdQp
         F6UhnbX25MdiVBBetHXjnRiqx5A5O+8+yGZJ2vdhGUyfYaygWEkHo65nTaCTqKmx4LCn
         z/4XG0BoWV3GVn+NQMv5eE5BSed3yyZUot1ZRoXC2h10rgTQRaNXcjHg0MGT/r3eow5B
         U8vrLVikodIIu6VaZ7PWOAv3Y4Gc1ntd7Dm5vD9L7QYTYy6Mx9XkHOXnJkOjd2fhwBKc
         QUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452095; x=1737056895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOcpJVT6JUs2fS6zWLpYYaWH6+NENFaeQy0VEEx51Wo=;
        b=QAPwIxCWs8rKqmfvLdRpktzJ1J/xFRT7Xdu4qytbjtvBb+W0AOEcPDq/SwJPqsdtr9
         22g0tQjzv6YtIEMVHLGaiDjpqFOuSCn6V4JZWbZS7RiQpI0wPQ2+Mx/+stMEk8KsocE9
         aWF1DJnc1G2pMpKNJoUOgcoQILKo6SIY9JBHNzKwQkDzrq+wUpWRUXcOSghZGxe5SdJ6
         oaiKG2oT4xXxEOVLUjFg68/W8BMa1p9POmP5TPXWWhJZF59xE/T+V25vfwvwquxM8ltv
         K7G90NvV1rtkkAuW/i0EjinQqVGE8hLmLo8P5xJpHmjstT8LqZFMzPKQdSXLWwARV2/R
         rRyg==
X-Gm-Message-State: AOJu0Yz35h8WE/l3/0Zo5egDZGLEfnHn6FRNHTPYs69YKJQmqg7xdox4
	1B2MrjpJMTPH+zkWj/nursAAmHdHHqm4RuqioneUMfOkeUYsO8S8VL1pIs0tHzg2hcXPRpdvsdd
	o1w==
X-Google-Smtp-Source: AGHT+IHIoPZ4ucYCoPUYYx2GOGZ10INnArviJx+sPHDKqU2AKoNdglR8M3Kw5/djPOvCilHPuCQeiuGWKEk=
X-Received: from pfbha18.prod.google.com ([2002:a05:6a00:8512:b0:728:aad0:33a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748b:b0:1e1:a0b6:9861
 with SMTP id adf61e73a8af0-1e88d0e21dbmr13169470637.12.1736452095505; Thu, 09
 Jan 2025 11:48:15 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:09 -0800
In-Reply-To: <20241126073744.453434-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241126073744.453434-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645116029.885224.17841818686309710089.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Remove unneeded semicolon
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, shuah@kernel.org, 
	Chen Ni <nichen@iscas.ac.cn>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 26 Nov 2024 15:37:44 +0800, Chen Ni wrote:
> Remove unnecessary semicolons reported by Coccinelle/coccicheck and the
> semantic patch at scripts/coccinelle/misc/semicolon.cocci.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Remove unneeded semicolon
      https://github.com/kvm-x86/linux/commit/3cd19f150ac6

--
https://github.com/kvm-x86/linux/tree/next

