Return-Path: <kvm+bounces-59767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F4FCBCC6D1
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 11:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75DFF1A64F96
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BA02C326D;
	Fri, 10 Oct 2025 09:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0uWURX0V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E426A0F8
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760089629; cv=none; b=o1bEUPRqyFEXA1LSaf+HWH3g/YAZu7m/ZpGDw2fz/IujtgQ7Jh5dvCrsktxG66VMSveNKy2pc1vq74aJn/2dx7exLlLesUQHySkVt9A2/Sc3d1bYV4vr1Cv3sNsdOmgSy4ThbdLvsMJZF0G6aZaC8jOjq9mDAHWU64//1FwSl6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760089629; c=relaxed/simple;
	bh=YG3XVE8BDE+7g6BrUmvd0/0exOeskGKtZukXeiKO1PU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PwDB8nRy3paWnamC3dBZpbczVqFVdwoi/ci+6aae2XAAwjsAwFJ2yLJJFgrcGS899laBrKBquPcDdtlD1gHHisWbfL+lGUkKvusrYC5XyLGUGXWdK7jA+gKoIgDEagUSNBiLAp/mcevmGHGWnQnMLCq77Xt12dSlNXaX6JKVbOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0uWURX0V; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b2f9dc3264bso461975566b.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760089625; x=1760694425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqq4E+QcPm5gIESa9RU+pQ2jp4yfb8xgjlkjRCHokwM=;
        b=0uWURX0VTLjWlpzIsRy1hEBHLB+HamiSQB7JFGFpFAKfK9OofXRaXvjaqrAP8ZhzP3
         Se4ahc4JmACh04lRi3HaYJzrQvv+7cs1a8Kwt5oTIBZK9lzSWrw5O/+4fVSJr4BYjrpM
         dbKIprgmHfBeYtZSBZACRSqNT3PmlmC6vhf0tZ7vP4ivSYIAXHj4WImfk3JP8H1yGuPR
         mIyTCVPzJ2GrkOsMKKEa1leWl3pXigXFQ/T2BDX4dns6Hj9W9hg5Mb8GEg1seUdS+O7i
         bKw+wcsafNqWV5YKEe4xnTEYg9naM8/a37mQjWBlB2xfv/Ysq8X9inCsGAmpWJfAIuMU
         77Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760089625; x=1760694425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqq4E+QcPm5gIESa9RU+pQ2jp4yfb8xgjlkjRCHokwM=;
        b=B/FVBVDe04CdMXO0RRb/ZoSmSWubg+jqQ5jZ7kpq7nkvUQFqvWahp4qyxrla+1zpCq
         aWipo7phRn93Q93EUKD1O4kLSBUl8SAVFVj13P9DdTLqYsMrGmzcjoIpzlwa0UxnNSjc
         HAM+4kJRwLFMgtoeqrt2D0WHO3P0YyIzRI21NIi+u0xVkskSF8JJi1wS57nWNBLnmuv9
         nb/E/K85owPLwEf9rXTi2g39zPN1nl4LXo10R/62nv/mgFAlBH4tlo/GBpRqCvSGpzOY
         UAHSg3RfQqdU9wHlSGm5ga8HMzNV3xtuKuFBzMoQQyWn6D21EZ+PlrnAEnZctU8EKOPN
         Nk4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXjgiOssO5nHkXWlu5k1TgRgCws39EidxXf2F+1Zt7Svb6eu0VbTtgBiYRIp7VqeQUFwlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0spqFb5BOdt6IHuraRcYoTwW0OjYRzqqCKfs9KLL97McrReNL
	IkLVbxCvnTmZfLw4cAIpFH2UX40FN8dhMqKhPJI8dA7igvdWzildxnp92mIjzK47N7RCA+A55/X
	kcxQr4v4cgKh2KA==
X-Google-Smtp-Source: AGHT+IF3kyGZ45/SIomeQ10Oy0HpD4ltmqNTCbJ2I7tWbnIvSDEZQxkMPFlCPp/SVExbwW1i/qxQKgZbK/NQ5w==
X-Received: from ejab15.prod.google.com ([2002:a17:906:38f:b0:b3b:af15:535b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6e92:b0:b3b:82ee:def9 with SMTP id a640c23a62f3a-b50ac4c5bccmr1154491966b.53.1760089625454;
 Fri, 10 Oct 2025 02:47:05 -0700 (PDT)
Date: Fri, 10 Oct 2025 09:47:04 +0000
In-Reply-To: <20250930163635.4035866-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-2-vipinsh@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDEJP752Q32A.1YMQI5QN4IP0A@google.com>
Subject: Re: [PATCH v3 1/9] KVM: selftest: Create KVM selftest runner
From: Brendan Jackman <jackmanb@google.com>
To: Vipin Sharma <vipinsh@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, 
	<kvm-riscv@lists.infradead.org>
Cc: <seanjc@google.com>, <pbonzini@redhat.com>, <borntraeger@linux.ibm.com>, 
	<frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <anup@brainfault.org>, 
	<atish.patra@linux.dev>, <zhaotianrui@loongson.cn>, <maobibo@loongson.cn>, 
	<chenhuacai@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>, 
	<ajones@ventanamicro.com>, 
	kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Tue Sep 30, 2025 at 4:36 PM UTC, Vipin Sharma wrote:
> +    def run(self):
> +        if not self.exists:
> +            self.stderr = "File doesn't exists."
> +            return

Nit - typo here  s/exists/exist/

