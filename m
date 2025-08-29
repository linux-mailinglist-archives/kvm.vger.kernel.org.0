Return-Path: <kvm+bounces-56352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6EEB3C152
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D19DC58807F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D8E33EAF3;
	Fri, 29 Aug 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VursuOOO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47435335BB1
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756486452; cv=none; b=o50D2b8ywOf/gDWF40LCPwOqIhDg39IF4O9hliVOlUfZwUP2GhgRWmFWhtmY83wJIieHaE7TvS2MuZ92VN5aBcbwSu9rME5T60Kyk58tmAj00L4tvOz5flvTCr6uPWwaQM40BVuRimJE8WXIJ6Ub+1t/+yi5hZZFTYaZ94Vio20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756486452; c=relaxed/simple;
	bh=MEXEQ52BMDj9IaYiI6bg5Gi6IB7kkAuqnXds+BbFlw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tFWx5zdD87hKLQCuAu6wiEZZzSx8hO+kt/obryB+cq53H7GTE/qq3sxpStmqLmugioKDV3HuWtRSBZmFsQJoZkgr62sDqIXRLAUyjMzV8FIXRhIAoXuXJoBS1ET6gUubarke8/X8V18pSh2zC/kPxrHi4hytdjtgxir5EMtBXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VursuOOO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756486449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEXEQ52BMDj9IaYiI6bg5Gi6IB7kkAuqnXds+BbFlw8=;
	b=VursuOOOmKGZ58bYcdA1ETgQ6iwzCvzWBMIKVSgR/V38iUa7Yf11kbnsOpjCSiPRRusJ7M
	eKa5l2vg+qP1CFH8TB4zBhpc7WBnODi5xgCADXaHlvGhcSUmbmGT/vCSd8OZgUPOu5gwNk
	JWhML5+DAaaTQF4+l9qXuWQYKhIHFH0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-TFbRheQIOQ6yPkjxM2SOyQ-1; Fri, 29 Aug 2025 12:54:07 -0400
X-MC-Unique: TFbRheQIOQ6yPkjxM2SOyQ-1
X-Mimecast-MFC-AGG-ID: TFbRheQIOQ6yPkjxM2SOyQ_1756486446
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ce3e098c48so1223679f8f.2
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 09:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756486446; x=1757091246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEXEQ52BMDj9IaYiI6bg5Gi6IB7kkAuqnXds+BbFlw8=;
        b=qiBfFiL5/M3XtcdNxsc7J4vDef4gUULLdhZmYb1eXkd2oyarNAYQ9BomHZcvTWtf5L
         wPwCkTxzAZTmFewoRPGM7JV64qsCs/jxAxWhPr0/nyXgicAbaYLF9W8hXDoCu5hwkSPM
         o5JVVM6JtEIC4ikBNZ5Zq8EvEmOp5dJLnLI37NKtHEaOKPd3hKTiBslVaAeG2hqiTB0Y
         3xBu4udJRk4d5oAulqc5kmAoKUxs7KR6Acip2nSx9otIJSZZaBOYpqllQUbO/0ZDuAkg
         N8JU1WDm++omSxmqxyTr1IIoy64BgzAmdaVznLgukfuNlmely/CeQ1IEqIGS5mn8T0kT
         mwXg==
X-Forwarded-Encrypted: i=1; AJvYcCU/kKjxAr7LBa1NcNfwzA1JUN0Z+lwNn/tei02vD4N625it29JqLho1GDFhpa8E8y/A6fo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOSp9EWjlHHXAZPLcQtc4rfO6wWSUIw6ReTCKKqYhPsfyWfY4d
	ucfmx80omWre0zTZNkb6Ni1zT4EwCw1u+VwnFv1MwEbr15SY/PsJpY18moVv8qjyFJe2fUr0NEB
	4V6ZTtqiLBWAkbZG9xypVE00f4OEB0KGKhvyVySUQzmNfT2CMRWtkBBCGGgaksX3nq42s9HuOi1
	Q8z4HZJgfsYZE51IFTHgxJG3Mar9Pk
X-Gm-Gg: ASbGncu/YJhBdk5WfUMGE7493QMQf75P8rHfLPnq3v12UHDHT6jI2rBhtzP0Ufd8VyR
	BOChXycwBMhWI5YWf/a0sZZJX2jS6jXUtCSnmHoG5Bk08qV4mL8HGsp+BhqRNwk31iddN/UziVV
	B7U3vN01BXDImOil8Uy2HfaIEkObgwv9ppuuj04zH6fg4FN6H1+c3BkHzI+pSjxyQr4QnJZGxZf
	DmoVYAcNy9m/VbIayJXEzHY
X-Received: by 2002:a05:6000:26cf:b0:3d0:affe:ed78 with SMTP id ffacd0b85a97d-3d0affef23dmr1993385f8f.48.1756486445946;
        Fri, 29 Aug 2025 09:54:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdPZurYZfRUBnVOaS3PNxkM1C7NRZdnWpueO3B3+j122HOFXUPtz6Qia0NiP/HNj/vT0GqByycZDJiM0JglWc=
X-Received: by 2002:a05:6000:26cf:b0:3d0:affe:ed78 with SMTP id
 ffacd0b85a97d-3d0affef23dmr1993361f8f.48.1756486445512; Fri, 29 Aug 2025
 09:54:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0c5tScwHk8iLoF39dxFUSLg1RzST9=4EQ3C8KogvbM6w@mail.gmail.com>
In-Reply-To: <CAAhSdy0c5tScwHk8iLoF39dxFUSLg1RzST9=4EQ3C8KogvbM6w@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 29 Aug 2025 18:53:46 +0200
X-Gm-Features: Ac12FXyqjT6P2FLFlcMv7sZgiRuRQCFuk8fcYFJD6RjPe2yyKjWPc-kMv7i27Zw
Message-ID: <CABgObfa6b32FtpDwe-DDqHF_xx9vwePKj2CtN7wjG5s-pU2uMQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.17 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 2:03=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have three fixes for the 6.17 kernel. Two of these are
> critical fixes in kvm_riscv_gstage_ioremap() and setting
> vlenb via ONE_REG whereas the third one is a trivial fix
> in comments of kvm_riscv_check_vcpu_requests().
>
> Please pull.

Done, thanks.

Paolo


