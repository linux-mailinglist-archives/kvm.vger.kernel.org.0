Return-Path: <kvm+bounces-14282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DFA58A1D4A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F8891C2435D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD425165FB2;
	Thu, 11 Apr 2024 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QSf0d64F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38F81635DF
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854665; cv=none; b=if74WVExuKBMNYoMNmbcPo2aS1QoNfsVEtwYpUCG05T4wwX/DQ9b3vG3Q6Rj3LApRJALRV/RRAznU6ghAQTQz3oPIil9RlZs+Bh63Khqda/dWaCe2QT484PVYIulEzOZPnepNdu/efnEneY5YcL+yEJv5Zrc/Pp/d8CXH9VRJRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854665; c=relaxed/simple;
	bh=mW9Wy5zwtCPwddAQPsiCFCBdlF3xxhTlbzOesWPW9Dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+qfG2ShJKNtDsLLscykvXskG+BFnnFwH2V41UKAmVPy7/xlPep2Sn27TVcVwd5ywDsBiF6zcope/qBf24Kaz34p3oxsAiqCheqc+UAenIP7rMe5vVP2l6OIOjaI1sj1VTW7x2fBB41Bc1EUDYREY1hCxQ4N/eAArb7/Dm492d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QSf0d64F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712854662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzMoeKDG3HLVO21BydyhZtfJookrt2+0z0ZoaUJK4l8=;
	b=QSf0d64Fwo686YFOfs59mCSQP1948Un0RA/fQ3Yiu9BZfzEx1iO4abhyTd98Cu2cYnHx5M
	altpxNCL/do7yMPLufPTpDs6+a19E5FUoHcy5LHTkDVMesac9On1XS8or3LU9V2mFiF/t6
	RCkMkz83fe59JTi1rwNLhnnXZrVqR0Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-qtdOOnmfMtOxjmxdjBic4w-1; Thu, 11 Apr 2024 12:57:39 -0400
X-MC-Unique: qtdOOnmfMtOxjmxdjBic4w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-417df7b0265so373055e9.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712854658; x=1713459458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzMoeKDG3HLVO21BydyhZtfJookrt2+0z0ZoaUJK4l8=;
        b=u0htUPsCO37f2hf9j77iP77MJ1ynmTxLhq1TkX6uNHNbXqa9fLEcyU21PS85Rm6BCV
         rnrkH8QUnh2rP62XxX4BU53Rf++Q5biUeNLE2NQWcttFgqAurNTjCJipZ4gSOc8P749Z
         CqF5mgaf0vSB9NcRF+63z3uGl6slXX1F15u5qEUBMrl3g+X3h92fd2WvHjK1DXq04LWp
         rxfWvZW1FQZb5ULuHKXwSSbCIoPmdj4ikViKIzh09xIBrnoPAFgMJ0FFi7o51RkvOyiz
         2z8JIWDb8Xnd3jZiXqJAt+ixYPFHlYldyFVvLDQiOOrFXe5+3xN4fI2j3YLOgR8EC6uW
         +X2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgn3kWODPk6wna+H3BnvyKgL7oP40Stfm+Hky4JO6XJu++yMURTMSH61US09KDYqCSAtCAHnau0yB742+DPggreQV6
X-Gm-Message-State: AOJu0Yzot4gQ7SD5utMLnMf4I1H22x98lasiEsrQrqbJGMol1CHfa/+V
	2WIlEAw1bAEnqxlJnX3FZErnxYeGumbGXq4NDGm1KhddCvyLB2VFBprNs0E8CIs3DLrTAQyqFTT
	IXB58zXex72TwpRN7h5ZIp4ghoQxNepJPx4yntG2CFy2lVKX6roTWItvzzA39GKisd1ac6HlmCv
	OrrP3nR3IN3lOAEAQ0lMjcqzhg
X-Received: by 2002:a05:600c:c07:b0:416:b75e:ffb9 with SMTP id fm7-20020a05600c0c0700b00416b75effb9mr294482wmb.19.1712854657978;
        Thu, 11 Apr 2024 09:57:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmoGFz39xTCvG23vKtpQgogb148s+KvVt7/U1rBvktp1dcwHHxjM7spsq3rgOmQW5LGi5xUnT62q1v5vcy7Gk=
X-Received: by 2002:a05:600c:c07:b0:416:b75e:ffb9 with SMTP id
 fm7-20020a05600c0c0700b00416b75effb9mr294473wmb.19.1712854657685; Thu, 11 Apr
 2024 09:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240405115815.3226315-1-pbonzini@redhat.com> <20240410143020.420cafd47bf8af257b2e647a@linux-foundation.org>
In-Reply-To: <20240410143020.420cafd47bf8af257b2e647a@linux-foundation.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Apr 2024 18:57:25 +0200
Message-ID: <CABgObfZiEiLbbp35gNmSGd9vNr03__Eep+D_Mj7r2o+XbF96TQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM, mm: remove the .change_pte() MMU notifier and set_pte_at_notify()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Nicholas Piggin <npiggin@gmail.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, David Hildenbrand <david@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 11:30=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  5 Apr 2024 07:58:11 -0400 Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
> > Please review!  Also feel free to take the KVM patches through the mm
> > tree, as I don't expect any conflicts.
>
> It's mainly a KVM thing and the MM changes are small and simple.
> I'd say that the KVM tree would be a better home?

Sure! I'll queue them on my side then.

Paolo


