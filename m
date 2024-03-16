Return-Path: <kvm+bounces-11955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE6187D7AE
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 01:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49609282D74
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD76E1C36;
	Sat, 16 Mar 2024 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DhsaRMTY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C778E1373
	for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710550309; cv=none; b=aZ9TifbjK49BiVLAChCO3rpGXD4x3gbSiFzvsYCD259z1KHDQKQBZF9uwKdSttn3wfyAnoMkO/esMTMomQ3IsKwygjoEccR1A36JkLKq/XWm8zx0V00e9TRBL5czAIZKRj3Ay1bO7ekdUFdf08TI+O0HRjBXr9x0hdZB+WTQ+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710550309; c=relaxed/simple;
	bh=veGHBF3H13JsJeE4FDnKI5tpEmZeeZRyQgx+bxMNAi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=acaE6kZQz1rKwbBYt4U9fuL39WldlZmAkR3AumAnHRju09GkMaX2xKUeqy9nZsayVnj3RAQlIQYa+GXsfN5qSlnJK4VIal+01lNDXExrNj74zh2gc1Q8Rh86Jg46J0eXPJTqeknqsWcFcpqPRusyCXlovnQdOeyt8XUSMtQJaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DhsaRMTY; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a466f796fc1so319637066b.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710550304; x=1711155104; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=krWZ+WRoA2zaA7Cdw3TM52PMtly6Zf/um2GekWUiV7E=;
        b=DhsaRMTYKD6KBFla3XYneZZPu0dalWil4DjkZnfoVdYYdMVmS8ZTqybQi7qReC3Vcg
         4QrSbvc88R6Muy3Z4S6exncnF2j4I5Fn2ksiVY+wQ2QLLaWNEkrbLnLYNToUFSsDFhZ3
         Td43G97+UVvMp7GGkhv9ibc95ZrecoKFRT3PY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710550304; x=1711155104;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krWZ+WRoA2zaA7Cdw3TM52PMtly6Zf/um2GekWUiV7E=;
        b=JrUZXkP2u+YEMQ0CXOUv0vmTBChyMiYuyOf95QJOa2HJ4bEoETMfNfbST8i3SjBV2X
         9Trdu1f5TG03lg5K4scPDVjyGravY3aFgYTlrQdc34Wb1xSER5/m+mfUkrmHQJsBW8N7
         AS/tPRKWzKMwJxADZyzEmrxr/pwtHVnfKRhYD8jOl/QWcsl/earGUD9sSY0yL78RJakF
         7mRdW/hpV2kelVvrquaA+/yLs8KYyUg6gtlz5We8gGQsuvsp0/6hA6TWwvE823fCFdDK
         zkiX5+pIJvfThOdPca6F6n+zjgR3LlatoFOkumwKMYoXrXXKitF+fl2YvKH9xKENiY4I
         aq6A==
X-Forwarded-Encrypted: i=1; AJvYcCUv39y1skVFhs4miMOgtpn8B2QswYLI0BfY3vHB+d18ftSVov8D693abm/2UALaqL/JlXfZyjiQp6pEiqp7pRXMmh+I
X-Gm-Message-State: AOJu0YxiJjKQeqyGR/zP6hNAsWAAh8ySdsKtNVVnBNEtiknlQFzjc0vl
	5iHYUmz3zfSod5nKuX1pGDvl2pwW4/BOm0kmceQjjjEYr8idp4XlQ86LxzA0ZhIKTBDNVEA0ksa
	fKBipLA==
X-Google-Smtp-Source: AGHT+IGjo0MbaijL5OyoWKTxcxbu3fJ5c16suchb07OVZi4QlKjapwbAYnZoyQXcyhNCcLbbpKal2g==
X-Received: by 2002:a17:906:a18c:b0:a46:a17b:c44e with SMTP id s12-20020a170906a18c00b00a46a17bc44emr381354ejy.30.1710550304158;
        Fri, 15 Mar 2024 17:51:44 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id gx27-20020a1709068a5b00b00a3e5adf11c7sm2174180ejc.157.2024.03.15.17.51.42
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 17:51:42 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a466f796fc1so319635266b.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:51:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVIMbGGSa9CFJo3P79sGi5ByU0f6ZDeyQ6X8PRw/Q+AlKkokn4wr7LYDP1C3k1iB0t+nscrRVDud+fUqfZKew0YnGBa
X-Received: by 2002:a17:906:eb0a:b0:a46:59c6:2a42 with SMTP id
 mb10-20020a170906eb0a00b00a4659c62a42mr4188815ejb.76.1710550302338; Fri, 15
 Mar 2024 17:51:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
 <20240316002457.3568887-1-oliver.upton@linux.dev>
In-Reply-To: <20240316002457.3568887-1-oliver.upton@linux.dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Mar 2024 17:51:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJv-Y1ZXbusknXpQVTx_kWudtORoKQPc+Rh9F944+Rvw@mail.gmail.com>
Message-ID: <CAHk-=wjJv-Y1ZXbusknXpQVTx_kWudtORoKQPc+Rh9F944+Rvw@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: arm64: Snapshot all non-zero RES0/RES1
 sysreg fields for later checking"
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 15 Mar 2024 at 17:25, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> This reverts commits 99101dda29e3186b1356b0dc4dbb835c02c71ac9 and
> b80b701d5a67d07f4df4a21e09cb31f6bc1feeca.

Applied.  Thanks,

          Linus

