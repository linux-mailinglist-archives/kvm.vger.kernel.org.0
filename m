Return-Path: <kvm+bounces-53568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B57E3B140BB
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12C65421FA
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD1B274B4D;
	Mon, 28 Jul 2025 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fq5BMh4o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904DB273D6E
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753721430; cv=none; b=mgwnmSe6bYTsF10J5XvRfR+fgGhQSHC8/NXuTeTFlqt+GXijdx4NWFqtHoJsSxxD5zbBxFCD8lOjYNVaj4No2nX1EChMyk+hzENCKXVM6yEdbAHwojZGsCipqTEOzmcCpM0Dv4oyt4jZ6uToQge5dYq/aVmh/aNsJ1qGfvw0HlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753721430; c=relaxed/simple;
	bh=krd6Kt/L5G0L6bxrRwfmRWwoqSRe3HGaFQKVpx631I4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NOTF1WP5fBpxd0RQxtMOCkmJ4SrVHi0p7VwD5YQEepWQOMXqoo9tQb6uMDPAVuHGsBwLEbpofwmONadDUFMgXXdN6fsbm/Wt4qSUMaeTGlksWqNMuSaRjz9OYbKuT1ftz/FVR13GlkEC4fcchUclcTx7i3L5lWGkUA8B5bFvxEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fq5BMh4o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753721426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krd6Kt/L5G0L6bxrRwfmRWwoqSRe3HGaFQKVpx631I4=;
	b=fq5BMh4oRwRA73VmaNkFYuXBHj/QuSUBOqBdBhaH9gnDKPzprrExtY3VVQXJu/YO8hWuXL
	o9Oy89NHtdtH5Cv1+xvRhmfoVC+ix1JlTG0t+4xEURwQtRudTP99KTDjzWJBmv1GXHFGTa
	hiNLcjnH7CYkuwm7bicC4x54W8Vc5OE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-tmojtVXaNPmqPPCoLOH67w-1; Mon, 28 Jul 2025 12:50:24 -0400
X-MC-Unique: tmojtVXaNPmqPPCoLOH67w-1
X-Mimecast-MFC-AGG-ID: tmojtVXaNPmqPPCoLOH67w_1753721424
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b783265641so1663831f8f.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753721423; x=1754326223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krd6Kt/L5G0L6bxrRwfmRWwoqSRe3HGaFQKVpx631I4=;
        b=tb2nzFwMvihMArjoPbxbEVbf6+whcVRrv/qXvpW8ch7lkJqCE/47SkDg4eEFFKldpy
         orh+KfgH3i+kknxjuce3UUuy9qX/I8opJIbN4ORedK5iqCI6xufHKMt5rocg1yWaX+1I
         bGfh08jCzkjhbZoIe60Vi0c1LG9z+bBHoyJUKhPqt/liqLqThOIhOofZ/6G2z+YIwort
         rbZdlajRYp77xy17DOk/3FScnrD11CW+U4LBDSvgo7W8ntxOXcUZqk8NdCCBV2+9Duf1
         IWvm40SjelHQtU9mV4g1/y9USnKlSIowpORo1/sDniYtUWJhhlwy7BFWZtfQ2raZU1IO
         y0rg==
X-Forwarded-Encrypted: i=1; AJvYcCWQejnmMhnTkF7/i6ls6pQTCLBWtddAZvr6IhO9gcHf+FuxC/N9dfm8lulVPbz+/YhPU7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YysWl23e4cS6fvMJLAvBYMnJNxpuRsj+uKeGn2AXwXhv1dc/1Zl
	GZOKt/2wcIE2OERzUNZW3e1ulSvv/OKH667oTUOko0i0ieU42HQp+OciYV+WA25hUbik+AfZV2i
	pa3LVVNptb56+XZA6eus4vCYRuDNplXnrXzxG0Z5uDjryih04nkywvKI43yXWeyvxy+svJiDjp+
	OldFov0ZEdK4SgD48UvHb7FwrV5CjI
X-Gm-Gg: ASbGnctixTkr273eWQGCgEhlCyzSj6p/18h3YhycdjKYWSEYBM4OoAkj0A0QZ5TNMxZ
	r0WDL9T9P0SmPayQZJMMf2CYL0ZH3KQ5TXQuxtdWuPhSRERunqk93WhQZnLxqpKJG/jJ+SB1ILG
	qEK06vtkTnNTWSvWvhT5JFJA==
X-Received: by 2002:a05:6000:2289:b0:3b4:65d4:8e27 with SMTP id ffacd0b85a97d-3b77664284dmr8049086f8f.29.1753721423483;
        Mon, 28 Jul 2025 09:50:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9AiNoGh1fFHMtVXbzZwnzqr6JNT8EGrYNFrd7vLtXR4YXPbw8TBf9CBFH0MTT1XEnkoJVr47qarAG9eP/TTs=
X-Received: by 2002:a05:6000:2289:b0:3b4:65d4:8e27 with SMTP id
 ffacd0b85a97d-3b77664284dmr8049066f8f.29.1753721423075; Mon, 28 Jul 2025
 09:50:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
 <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
 <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com> <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com>
In-Reply-To: <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 18:50:10 +0200
X-Gm-Features: Ac12FXzkdtm88_4dk2KzyvFSOMEmlVWQkf5aJBT83D16EQ1ktTyFz-doPwtE5M4
Message-ID: <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Anup Patel <apatel@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Il lun 28 lug 2025, 18:21 Anup Patel <apatel@ventanamicro.com> ha scritto:
>
> Currently, userspace only has a way to enable/disable the entire
> SBI FWFT extension. We definitely need to extend ONE_REG
> interface to allow userspace save/restore SBI FWFT state. I am
> sure this will happen pretty soon (probably next merge window).
>
> At the moment, I am not sure whether userspace also needs a
> way to enable/disable individual features of SBI FWFT extension.
> What do you think ?

Yes, you do. FWFT extensions are equivalent to CPU extensions. But all
this should have been done before including Clement's work. Without it
userspace has no way to support FWFT.

Drew, I see you have Reviewed-by on the patches; please keep an eye on
this stuff.

Can you respin with the fix to the SoB line and no FWFT support?

Thanks,

Paolo

>
> Regards,
> Anup
>


