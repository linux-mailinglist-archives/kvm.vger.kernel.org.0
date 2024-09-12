Return-Path: <kvm+bounces-26718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA11976B77
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A97C328702A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EBA1AED46;
	Thu, 12 Sep 2024 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKwNGbpo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759461A2844
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149832; cv=none; b=hzVydw8Tjm/mtFn62WV4SxUGwQyRFstTyJulacBRUPypDtppVZnb5Rbggbfp/YlkE4Vv3QZRNADSYb7wvP51rbbJC+bnnHmWcCsPxkIaKGwYcoiWXlSieIhX0k2P/O3VGI1AQ6AIyVQ/KhCvflXWi+PqWITfhjTAzzeEXYvUVNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149832; c=relaxed/simple;
	bh=f4ub2ioH2rAq4LrWkvf3tWt0xuhXdG4XmLanIfAoLdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tMHwK4yC21ujXhEyRcQbPZ49znjDXCU2rAN2KcEJY1Mi5TFjZEtigIumyXTT4yORFk5R0ngm9FcxkJK65hFI7R60cY+B6/kX/6UDXTejTjDJlzpH/fBNq1MiHD4DY8gf2FnSnIWMfyBv+3rccRBYOlaYsngjkwoK/IqKAxtHPw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKwNGbpo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b41e02c293so26581887b3.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726149830; x=1726754630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJF8OdeeEbgD1lB1UBEPz4l4GIXf0/aw8YXbCeOR8js=;
        b=CKwNGbpo2/WDq5/P2EeFcJLyFVoobjdYbNX4rLK549XnqMmjHaaAI9aqi6XWXQZ6Go
         Umh64ffg0GG2pBKCy+5c2UoYbSPqsPJKGMf13YtKs/KCHMtzZJ5hhdFPsMajQtpL+W1t
         /sT009ZxHAUrwDLQwsvlOnjMAepIJnu7mb0BmbDurGjr3tNyg5HYyL8Icf6oS8RwjBhP
         YtMAoDBr2GMa4XEo8PcEybFYw1L+h94Ups+/oxKmyTOMbX1F9+cI6TE+ejGhGML98njS
         wr4RwiZrHL0n89f1/3rWWrllrdxv55ErJf6IPQW/VatIIDp08PDmrg11P1RXwu2qgZTn
         E7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726149830; x=1726754630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJF8OdeeEbgD1lB1UBEPz4l4GIXf0/aw8YXbCeOR8js=;
        b=I5/kLt5QUXXWG6eAjKKtS8jtBEW686B4qwg8A8Pj1yOgWyP0Bd1Kztmny555GsH7qB
         Z3vA9WmLLXveL+2w5dbSZUQcEj1oV5ruI1ap4Gq5lIwh+qr6UWPdQ9FNXGjXoBa3xUzC
         PH6SxUX7yMwsxo+9gRmP04jTOTF/W2wMGA4A1vYIx1MZ5R62F6/mTINC+E5hyvyjjFd6
         6Tq9XT0icIQS9ZptTdFqwb7uE6O+Nm3Ecj8FDD4/V49Xg7IJNdXURQVo8XoEFDAt222A
         a4qieHgp8yuuwY55vCToK7VlBmA6SjP4MWQ8RSgNed24v2Zrcx9DET+IHoiEsUwfNQsV
         u9Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVsqGwfXDgdOfiadSvP73H09lhW+kSGy+MnhUh+sEqBNQBJZQPy19kCYLEGWObuTZQnYFI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzjy2ExYgPMvzCAKHJpLiEmH+v10pwFpM9uw7fjV1WtuaSEtDk4
	WzBvKzEqUlwE1kKvb/OnJh40bWxqNW1HbZIy9DnwFxHTFPu03DfoKGSg8BZX04sVVY7MwRIr/Il
	SLQ==
X-Google-Smtp-Source: AGHT+IG9MDMwcr2ud0GqvqLu65vyfg3SEL0UKjpaqJLZjzXIU9brTD+du2LqNfe439QMw4Yu0UCoNCtm5zw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:209d:b0:64a:d1b0:4f24 with SMTP id
 00721157ae682-6dbb6bb7dc7mr477817b3.7.1726149830238; Thu, 12 Sep 2024
 07:03:50 -0700 (PDT)
Date: Thu, 12 Sep 2024 07:03:48 -0700
In-Reply-To: <20240912-757a952b867ea1136cb260cf@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240912-757a952b867ea1136cb260cf@orel>
Message-ID: <ZuL0xEIB1ol5epEE@google.com>
Subject: Re: [PATCH v2 00/13] KVM: selftests: Morph max_guest_mem to mmu_stress
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 12, 2024, Andrew Jones wrote:
> I gave this test a try on riscv, but it appears to hang in
> rendezvous_with_vcpus(). My platform is QEMU, so maybe I was just too
> impatient.

Try running with " -m 1 -s 1", which tells the test to use only 1GiB of memory.
That should run quite quickly, even in an emulator.

> Anyway, I haven't read the test yet, so I don't even know what it's doing.
> It's possibly it's trying to do something not yet supported on riscv. I'll
> add investigating that to my TODO, but I'm not sure when I'll get to it.
> 
> As for this series, another patch (or a sneaky change to one
> of the patches...) should add 
> 
>  #include "ucall_common.h"
> 
> to mmu_stress_test.c since it's not there yet despite using get_ucall().
> Building riscv faild because of that.

Roger that.

Thanks!

