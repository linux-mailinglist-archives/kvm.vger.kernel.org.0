Return-Path: <kvm+bounces-44592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 455F3A9F7A8
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E096F3AE0F4
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF73293476;
	Mon, 28 Apr 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Hwt3GJtH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AFE60B8A
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 17:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745862346; cv=none; b=dxh7O7d2LYcntQ98D/99ZeudHtNmuuLrZfQrGutpVtZueMmn8ijKRPaX+X5KgrOXd2gIZSU8NWhTay4/teE0Y1ir8KSCYzxYxfnsvra/Rx7DsN11EwiZY44v5tYTKdf3wQ+5ODGd3WPfEbZ/2QWfaoZ4R/Lx8f1tXTfF+wgY8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745862346; c=relaxed/simple;
	bh=lSCgDLFkm+uTp6BBbwhp0BqZSIhLiEfIj/xbmsFVQEQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=QfL1G82auYKK1CQIH1YizSF1ZnEPV38GYmRCo22kT/BIcnXdsJvdCgCGUqIA42nEyrXbSLpyYjF1eSexuqMR3ivb+Buv6ZLeC1vUKdrWOuxK9t05Tp1tUsopbdz13ltVTOCNq+CpRqsi4ypitjPquI2gqR4l2mzlIL1bxO9Vxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Hwt3GJtH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d4ff56136so5724515e9.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 10:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745862342; x=1746467142; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/CANhKWFmJawB0p8jQ/NyjybjgGkYzY/3LSqUuDHX0=;
        b=Hwt3GJtHh4j5IJHmVgpYNdakLAlsIO87ZYX7XBNZtOLvgv0Io1+LZ01V6ua2QFtNaJ
         GvJ+qWQ8FtildThMCkmoWnT4i9Prb3kb2senYv/F75eZGghFscWJJj/KZhOB3vq4fLOf
         ktzof6xBZtngYUPqjvzo4XTqq2CXyOeIi0HpT4r0CWvAzhjoBGXesjI0H91JmseEAfmt
         kbn8KUutFLahP5xWtAaF12BNxgqf05+Jz1IoYlQGlRuU3bd5dunBzK2hp3lgLrB+MUG3
         ZFjq/vwZc4O+oiy9OD/B92Q18vhh8jE43SqnAF+n4VqyBjw5XjHr8iOF5t/ugSHy/o09
         mKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745862342; x=1746467142;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v/CANhKWFmJawB0p8jQ/NyjybjgGkYzY/3LSqUuDHX0=;
        b=YjbDueUuSvjF7bH2eGBdoO2Ds5jFtZXJJ2AjrMG2mjbtU9e+KjSvN8EF3BU/oZAhqm
         MCT0/Wvw6LG/KNVJmzyMe6U0g+0f0BbN35zgr5Z17WGSj7sDiAdRqVRFZ+i3jMQT64YJ
         XQcSB3rrMYYK2dU56fCDPdEw+TKr+JK8xCkdJuHLqYMRqwHZsKExyX3xk8qrbPG4eEyC
         Ljy/dC05LGwBB6ShIIQLJuISprOGfNSMUHFIxlKrHkrpTiDgwNetKzYk8rZ0eZg2Qy5V
         mDv0FSucA3xDt+w3TbX/EhWwhEuffwfG9rOon4Hqcj6FAVShOoXQbp/0deU2g5xiQqKO
         BeQw==
X-Forwarded-Encrypted: i=1; AJvYcCXcUooiuDdJ9s3uIJbiAJv1JtF1Ce72390VG/bnK9Zc7lefbvBwlAPOltlHxApm4CqMCm4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/YV7+6B1m9kQ8L0mQa7ajaUqkwv43B7jRyuAUXnPceIWB/7j5
	/DRfr8TlvkVsjSl8pM4eBBzFDajMk/vbNY1kZeuHcEjGqOkaskawTbCKzkmjeQc=
X-Gm-Gg: ASbGncvUw5i3eeLJmc9D1UFfsEPtzt5+gRhNENSG1Jtabn+mfY5cxbUPJyYI4a5BkTv
	/kpXX08mqVVLrY5lP4sgMEGcGX4tyXaFXEyIvFGSAvJhjJe8i7Eve9W8l9/6qBt2SkmTHnD27GH
	QRhxf9d8B6CegnTdKJ1qetDF6QNpuqWGu/6INzdHQuNu26FyHkzaBiXoMZo6jGk3c0mdYecQYMZ
	ibR2jkS1EhYoclkyGfpB5FJGxreH95zF3C9EdjVgaOf8EyaHd8L6JOnqiMTsQsSSOybvIxqapIe
	Pm+NLkZozvGZtF59uMyDJ6rA04Xs1WDiawJOW34sCFVF7aA=
X-Google-Smtp-Source: AGHT+IEvyyRwv+siNkS/+KKa7cPTZaQ24k7dR1L6NM8zAaZ/ZacC5UiUMQME2xFD4O4sKzfsTBeP0Q==
X-Received: by 2002:a05:600c:3b82:b0:439:9fde:da76 with SMTP id 5b1f17b1804b1-440a634912dmr44268285e9.0.1745862342603;
        Mon, 28 Apr 2025 10:45:42 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:785:f3a7:1fbb:6b76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46a54sm11977490f8f.67.2025.04.28.10.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Apr 2025 19:45:41 +0200
Message-Id: <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, "Atish
 Patra" <atishp@atishpatra.org>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Mayuresh Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
In-Reply-To: <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>

2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
> On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcm=
ar@ventanamicro.com> wrote:
>> For a cleaner solution, we should add interfaces to perform the KVM-SBI
>> reset request on userspace demand.  I think it would also be much better
>> if userspace was in control of the post-reset state.
>
> Apart from breaking KVM user-space, this patch is incorrect and
> does not align with the:
> 1) SBI spec
> 2) OS boot protocol.
>
> The SBI spec only defines the entry state of certain CPU registers
> (namely, PC, A0, and A1) when CPU enters S-mode:
> 1) Upon SBI HSM start call from some other CPU
> 2) Upon resuming from non-retentive SBI HSM suspend or
>     SBI system suspend
>
> The S-mode entry state of the boot CPU is defined by the
> OS boot protocol and not by the SBI spec. Due to this, reason
> KVM RISC-V expects user-space to set up the S-mode entry
> state of the boot CPU upon system reset.

We can handle the initial state consistency in other patches.
What needs addressing is a way to trigger the KVM reset from userspace,
even if only to clear the internal KVM state.

I think mp_state is currently the best signalization that KVM should
reset, so I added it there.

What would be your preferred interface for that?

Thanks.


