Return-Path: <kvm+bounces-53564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC92B13FA3
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBF6B166966
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9E7272817;
	Mon, 28 Jul 2025 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bqnNJhz/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE3F1DE4EF
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753719196; cv=none; b=tPEMlFwqGMvmCeZq2jsqWo4/3dD+65ezt+DD/pXIjQgaj11S3G4rO36/uSSh+h8BbZWYhbNFB5d7pHVsvcVsfc48hxsPRJ4/e8SBq4JnOwHlxDYYeM/LtgI6pIi8r5y8ApPtiTUdnuNDusA6natjbZoEJ9hhYJ9A2NS0YXfgKLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753719196; c=relaxed/simple;
	bh=RLP9Yv8zFHrHgKN3RGtidBC9gH6sN8a1p9ybrChTv9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t4CyUvkuzjBaJk98AnK0YhXzzBWww6SBOuijsW8Co/p/nuNO36Di3WZDPsuEt4a9tXQN5uaSCaqcgO0sxbMvo5OKZzQUpkQ8hIe4kQIWv4o4Qi/hvWYzRhZg37oy2bTMKc/kWPDMApflNmVr0yw77JyKkyn+mL9dtIPEKdhU2DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bqnNJhz/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753719193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFSyKJdecv/1MRDq0uV/UWoK1UBfsR1Jl9RmuHJI4aM=;
	b=bqnNJhz/BR2uzb+uqQlD4ITheVHt8OO9X17b6XHV6imc2d67NaMxwH0sTzUjkyylHO39Gx
	DNlKaqNkqa6FhtQ/+HrJObQyYlRkWnz68JB5EVoUa3lMWiHSsUPdmlDQ4QUrwJ9JFLXMQZ
	KqOEODRglwA0CWhGgRk6dmDhAGrbSqk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-3bp-sVoHPQSGsXh2aXUyxg-1; Mon, 28 Jul 2025 12:13:12 -0400
X-MC-Unique: 3bp-sVoHPQSGsXh2aXUyxg-1
X-Mimecast-MFC-AGG-ID: 3bp-sVoHPQSGsXh2aXUyxg_1753719191
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b78329f180so1475056f8f.3
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753719191; x=1754323991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eFSyKJdecv/1MRDq0uV/UWoK1UBfsR1Jl9RmuHJI4aM=;
        b=HuyEk8+jN9vdtDzm2IT0lMpd6T3ZTpzvxwnNd5r7hM0bHfs7KL4KASxOwo7OBIcI/a
         qFPKGDY7X7SgCBLSatnYt1KM4XHbGXj6hbVmc3EKPtF7f2ZGQKAcZS4GPmzNPCnaPmhJ
         aLa0LZ/w/HkLdKgGT7/ioNX89J+jWGDtvr2quXCsYI44rWTOu8m6ueJKM02uZJjlfV3K
         1bTg0AbBDtt0PhHKeyXDPb+aX9C6w+GomJjhWRgwNcHJBWSTwGCcxGboQwn0rLAndW0G
         /4npsH4pOwaB9uhDntL+ezEleeeUBBmZk0EblkZiHE31JPtSJ1kvOxqy41EQPUGGU0mS
         P73w==
X-Forwarded-Encrypted: i=1; AJvYcCXgqou/Kpfu3MG15d5gmCZQBQcFdTujPYDCCX6IBYvi5a3Sr9WqtdxqG5e2bVwXtvt2v8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDJJnL/plEqG6UWoleT029GK1m+S8+UlUR2l98wigLvRYduKkV
	Fu92PNdK6sm5p10ya4td84DPF87UUru1byCrTzo+IGsUAbRHCGIFsDQP+KNJmrESvlC5tMD3eDj
	SqsEvquotDUVGO9rNRQA0JY8kRj4VtzLujYZDZF9hcTOB7r95IyBxdOKsu4uVDS2KmMNIFDgggJ
	KkZGn04kvqXf1Cb5/Q3XIuMOy3tAMh
X-Gm-Gg: ASbGncuYEAJxR6kprGsBkbgFofyBxhJdfBG/qHROXenTxrB0YL/va6xmArho+WrGR5S
	n2NQAvkgRuBYWR0lCp9hxnbFZz9ZuhbXIRX+HhLDcGnD5MkCLsUkGgVdlMSFN95XEUnCuZXIeG0
	sec+ij9jJGqsF17b1k/VpgEQ==
X-Received: by 2002:a5d:5d86:0:b0:3b7:871b:8cba with SMTP id ffacd0b85a97d-3b7871b8d7fmr3956580f8f.55.1753719190778;
        Mon, 28 Jul 2025 09:13:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWWWEK4FMuzka8/nfxF96/PztlXrkB6yJIpynbPb+zfrrEU+L+fITa5lHzMJzyOEcmb5yZy3SmKtEj2AkMJio=
X-Received: by 2002:a5d:5d86:0:b0:3b7:871b:8cba with SMTP id
 ffacd0b85a97d-3b7871b8d7fmr3956548f8f.55.1753719190400; Mon, 28 Jul 2025
 09:13:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com> <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
In-Reply-To: <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 18:12:59 +0200
X-Gm-Features: Ac12FXwUHOVXqDpc5CP8DQR9OWMiwskCL4EwTXkcLoTa8Rg2-Y0UmIDt4HRK2XU
Message-ID: <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 5:55=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Mon, Jul 28, 2025 at 9:22=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > On Fri, Jul 25, 2025 at 2:06=E2=80=AFPM Anup Patel <anup@brainfault.org=
> wrote:
> > >       RISC-V: perf/kvm: Add reporting of interrupt events
> >
> > Something here ate Quan Zhou's Signed-off-by line, which is present at
> > https://lore.kernel.org/r/9693132df4d0f857b8be3a75750c36b40213fcc0.1726=
211632.git.zhouquan@iscas.ac.cn
> > but not in your branch.
>
> There were couple of "---" lines in patch description which
> created problems for me so I tried fixing manually and
> accidentally ate Signed-off-by.
>
> Sorry about that.

No problem. Another (and more important) question, for SBI FWFT I
don't see any way for userspace to 1) pick which features are
available 2) retrieve the state and put it back into KVM. Am I missing
something?

Paolo


