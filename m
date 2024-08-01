Return-Path: <kvm+bounces-22910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5857D944768
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBBE1B24E32
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481EA16EB7A;
	Thu,  1 Aug 2024 09:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AA/7Jpg7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783E285628
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722503026; cv=none; b=uLeydKLL82w7VloJy65JybBd5IFJ3hAzFSVo9EFFiqd+OqMAYEQuIw/Tv4AnphXjgAAtQqlke8wd12hbUNOUYtLbL9qSzmHgXaPXacnrpRtkIxXaKZHWAPebLv5VN6U3xtpWJHxIcPoyl1S3aXJ2ZBx4fkEa3v4DEC0bWuMqcMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722503026; c=relaxed/simple;
	bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fm3E5NL91bdLhAjBBM01rPPjNFdP+b/dOvG6JqODDdUTuBrVAVMWKj4LpOd6SAfHu7DcP9Z3eK5WZjBiH4lb7bYEEOYsezYOkmpFYOom4rd6yMmcjMFcbvjBFLH/E478Fm+4A4vwA4xxlTRsIQfZvEJhuwok/4OBTWgTGo2QAT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AA/7Jpg7; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a8caef11fso776694566b.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722503022; x=1723107822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
        b=AA/7Jpg7Eyh9xM4Ws6hOxh9v4pi+myeEW6A5cmrv5nm48/aJZRbogzmi5+vDkzzUU7
         EpHfmeF7d99ZjuhX5IqF4iiSMu+nEzyI9Evpi3EVCmQFnC2/S+wKAYcFMnK1E+8z/KB9
         9Sv7VISV/u6Oruy3/fPi9DCmRx0yyEEGYwuRNy0Vkumll/tk1qZ7MXzXhoCyRXfaJMh9
         shnGnJz8y6bDNGi37VjHrwc47+ufVhnp026eeiH6735Ow3zx61mzMoCkqGE5A9JT90oj
         y7Up8Bepvxixct3MY7N6xcO5owDrEhbX03Px7Y2cWZOGOtT6ELjSbmtADbA9ldCFlgOx
         Sk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722503022; x=1723107822;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/Nhi0sMK7PpCm2r/uuIU8M4tCHIO/lVeQuknqZEy3M=;
        b=veQNnfKp4f/f5vLSWzDbIkkquVnimwxwqpGF1MYN6Y+j5y04Di1w4OaMFkW9hd9Ngr
         7c2sVVgDumamUhOKXXT7imLLaF0pjTZo+/vubFDgIKy1FwBrPPzAI459CsqWrlPB+dHU
         AKIJMJtnufwvLR4XlsKFwi8bdMtRxtm+xZB14eyD1DIoKVQp7KKqjE8h4DfmQNJ1f7hO
         T2/koM+1OezO6O0fHDRe+OPgB2zcXohZ6DdCR/AMoIrFP7puPRLDI0H6wCyUIAw3xaWx
         QUlnhCh44peVHlP7v3NkhtFqfgKK/c3nHrMZqtNljZJkkxYfkF/rsRfHJ0Ch1yb2hg6o
         vp+A==
X-Forwarded-Encrypted: i=1; AJvYcCWFCPKapx4/lPECk+NEqERoa2hMGUxSBF8YlP4+JyzTsCim8XTJp+h/6gIbhLcd7wE90C0qxQxHecb3vwQRpoWazQTO
X-Gm-Message-State: AOJu0Yz2kA6YslbpYA7NaQs6+Ycv4NMZIfpFY4KKc+0HWw6J4LKxs2kA
	wpwpfIObO7lm50+/iflT9ZMxvhQrJYwyhoSAyrnxfIAL7Twy9kQnRCf7IqUoSq8=
X-Google-Smtp-Source: AGHT+IHhni1Uh+bJITVWfhi2vAVjvXUzKzH/nw0taqtk6cxicA1yt55vq2KJXrilVInru0VfNsUVMQ==
X-Received: by 2002:a17:907:a4c:b0:a77:c199:9d01 with SMTP id a640c23a62f3a-a7daf4c7df7mr132037366b.22.1722503021389;
        Thu, 01 Aug 2024 02:03:41 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acad902e2sm878292566b.146.2024.08.01.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:03:39 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 36EF35F80C;
	Thu,  1 Aug 2024 10:03:38 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 04/84] KVM: Allow calling
 kvm_release_page_{clean,dirty}() on a NULL page pointer
In-Reply-To: <20240726235234.228822-5-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:13 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-5-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:03:38 +0100
Message-ID: <871q38fwd1.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Allow passing a NULL @page to kvm_release_page_{clean,dirty}(), there's no
> tangible benefit to forcing the callers to pre-check @page, and it ends up
> generating a lot of duplicate boilerplate code.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

