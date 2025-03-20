Return-Path: <kvm+bounces-41581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFF1A6AB82
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52CE3188472D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807152222DC;
	Thu, 20 Mar 2025 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gh3CG3zv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2919DF98
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489660; cv=none; b=tPIOcELi2NUczlkBycGSaqwg9gQ/lyaNFaWSNIFbeTNP+sf8AcVWO0ACh5oKhEdRt+2ermdXm465DCgYwfAlNr6NSPU8x1i1M6EphFa3+Uyit6NdpwcoazW9jSjxMWx0G+CIkclIoeHL9XxXbv0MBMjDUD1ozymGqOH0+mLeYB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489660; c=relaxed/simple;
	bh=Qzs7lXSCEOdVamoYUmTO0qwA7wo38Km/t3XnMT38O6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F7/nZQMiJhNiUM+ExoL+yyLf4H72kU8ZWgo6Ilf1err3O7ctA0KHrSC/M8Vz80MYMq2gOdUnU5yN2jlw0Bnt/YLMDsTJ3uKI8Y9tsV3TjsEL/SS/B6gz18N0iiCcibQDOLnqIEjlahF9lrzARlQB5KYXqBnEKaJAVu1i5+sBVAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gh3CG3zv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742489658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qzs7lXSCEOdVamoYUmTO0qwA7wo38Km/t3XnMT38O6g=;
	b=gh3CG3zvQ9zPm+A1QMUlCUXvCJyIejrTzxGfDmTrcLM7oORcFsPyEJvn8yBlQeKsVdvW/A
	R0nXLkFILH/3MWGlZ/0z/dNpz0NzkyRtxjaHVPoVimiaVdtQ1LD6EEKdBha4T8wuSb/OZr
	pkyRWOEUTlWYzCIIV3YDDIQDCe1/v+c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-hvDgIiZ9MLuiO2QInSmNkg-1; Thu, 20 Mar 2025 12:54:16 -0400
X-MC-Unique: hvDgIiZ9MLuiO2QInSmNkg-1
X-Mimecast-MFC-AGG-ID: hvDgIiZ9MLuiO2QInSmNkg_1742489655
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39126c3469fso456200f8f.3
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 09:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742489655; x=1743094455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qzs7lXSCEOdVamoYUmTO0qwA7wo38Km/t3XnMT38O6g=;
        b=fr7dfSj2BK5XlQwYrsgv7sykMt7WthpJrjU2+WNhihj36dY/0r94q+d6zkI6IoKL4b
         saQrRLQC2KkHF6phGwG77Dndt+yD8UB47hrQmDhetK3LR9+K9hxsQsmjygY3f8Ua6lIl
         NkejTY/uf6/ZFngIHaoviTBZVDs1RoIfopEc383NE2+IqDJ7Nld6hbDnAdftR5N+Tovu
         47Gx4/P6bUVxFDANu950oI8i3x8jXnhsT1Ltjf1RXt5oz/wxT4am+Vq54nN2WtLE55V5
         mw/P7/eDy/scyUTyHh63kj/1qhRv6Ri1Y9AhpBSza+I3B36bFG9Jr/oRfOFHxJjZgOJs
         r48A==
X-Forwarded-Encrypted: i=1; AJvYcCWJhJVDnhNXYkdWUjKm1ZCR3ok6PWy4Eb3/4uAQ6zbqSmuLrUU42KNIQHpIrJeCnH1z0JE=@vger.kernel.org
X-Gm-Message-State: AOJu0YznhsRiDc7+/+Wu2ZuSNTw3YZGP+ap6sQUFNNH4Na8NsVvSdwyC
	WwGMZTqGKOJRjMI61LO7kQ7IoJeDUQvOb7QnNGnuH0VXbTPgWB0zw+UgdO3Ouco/bAmZTxQxr1P
	olsPd0AghmSpmkpY9qKJgtgKVsd3ynYN1ATkzKL87k0cfJs6gbBxlo95e5uhvXAR8WccIm3jG2n
	J+JXoHsUuI4SsBYKuf43iYxwWo
X-Gm-Gg: ASbGnctjZrK72wIIHGLkQoRPlde03ICv33O5j9+itmSDH7l0ebe4aDajTo/tbMad7Ak
	kuofJdCon6UW1brEP0wECtxKayKA7s9GrXIryVFLDSFHVpbmxwwxnnbWJZFSQslklFKayzfAiCA
	==
X-Received: by 2002:a05:6000:4188:b0:391:4999:776c with SMTP id ffacd0b85a97d-3997f932c74mr219921f8f.40.1742489654950;
        Thu, 20 Mar 2025 09:54:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj9pl7GARtWFq3jbXWirX8oR8zmkq+Vb5cM05rQzCwUuLwhvW30WXCS+Nl/XDDl7rMvPzTyG7iVBUS8ETq7S4=
X-Received: by 2002:a05:6000:4188:b0:391:4999:776c with SMTP id
 ffacd0b85a97d-3997f932c74mr219900f8f.40.1742489654526; Thu, 20 Mar 2025
 09:54:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy380StEE03G=RPjKoxtY89nLeufpXbjYwbRypzzrkQN+g@mail.gmail.com>
In-Reply-To: <CAAhSdy380StEE03G=RPjKoxtY89nLeufpXbjYwbRypzzrkQN+g@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 20 Mar 2025 17:54:01 +0100
X-Gm-Features: AQ5f1Jp_WB0jgmaoJDDes32ApEWmT6Y0Q3VLmJo-2VN8hWbZcGCzV2rcn3utTOA
Message-ID: <CABgObfYbgLN6aqDYTXq=t2G5+KsHjUmdFFCuwmzdEZSVDTrOxA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.15
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 3:15=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We mainly have two fixes and few PMU selftests improvements
> for 6.15. There are quite a few in-flight patches dependent on
> SBI v3.0 specification which will freeze soon.
>
> Please pull.

Pulled, thanks.

Paolo

> Regards,
> Anup


