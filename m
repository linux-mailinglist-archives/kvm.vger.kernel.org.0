Return-Path: <kvm+bounces-43092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DB1A84775
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 17:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E2D69A01BB
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 15:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FDE1624D0;
	Thu, 10 Apr 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTN4dxpn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA80F16FF44
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744297851; cv=none; b=qi3mKwy/3fRMf8USplaE83A6mBX4HIOtetntC9sToUOtsR0rmMpllXte1SA8kzen8KUA1QIHVzh4TN27d6dLAbNvKDRdFMXjuxwixEn8c2hTHIkmydtpmIbwoEurw/95VrFj9+EhwoXBo0u2ZD0oaTYCysCaJnM26C60Z4gwdFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744297851; c=relaxed/simple;
	bh=ng9xh/PG1LUIBqUCqRBp1J3efi6ls83MH75OfUbQ4+4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=s8FUhNo4PBy8WenuU09LcYPIrTYBfSQ2EcRM+M9+fjRxHifeed+VMGl0O+oQTUjkJJxKJIPQlCzWW3+3YNDBfx5OptDMcPW4HlTwlW4XDueVaFL9ODXHDpimvBk3hwX4AhvtBXPt6I1ecZR7CbD50umwEzSL+7egnyOkhZ1y0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTN4dxpn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744297848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EXKgyYog58kyfqHQcoNTtvL08JiFX/6XLrBhO7Ve8ts=;
	b=KTN4dxpndtc7uw1Xg1FlmFSV/ktvhDpf2DIA4bzaoO/KR41oG+PQgVBhNkHlgCBDHNXZY9
	Bnv73xEEm+MUojQ+ww3yqEmqdfsa9xo/1aHiEP2zL3NyQsZuTh+jIYFw6q2C80OdKfI4n1
	doqubiTOdjGwAjSJCOnUCCo3X9xstiA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-QQ1ygJI6Oy23v3xUz2MERg-1; Thu, 10 Apr 2025 11:10:47 -0400
X-MC-Unique: QQ1ygJI6Oy23v3xUz2MERg-1
X-Mimecast-MFC-AGG-ID: QQ1ygJI6Oy23v3xUz2MERg_1744297846
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d51bd9b45so6427185e9.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 08:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744297846; x=1744902646;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXKgyYog58kyfqHQcoNTtvL08JiFX/6XLrBhO7Ve8ts=;
        b=V81pukm5nG2tE9zT8ZsddSq7yVm9sH05Rd6Zegw5x21wFUTZRFFsaKP+6+Hgds98bd
         X7NL3fzbkKM40ylD6swmlnuDi1cw+rKt4VXXmS+uMan6UiBFQOvK9obc1XnCUnqF8/Jz
         NyTyXianLwKpZKYNiGWWK+atPlKSYkB1pfWnvn9NxzGXANsouT6cSxutLxWS4nZzKIyB
         aY56PtrZ+ZKPlbOFfU+qOdnmXZr6FOjpjTSS/yn9nNB8gvpnQeZt5xEFBRUv4r8wGH80
         VaSrr+GTdOfBrcBJbzo8QSX51Fi6JWXuB8TgdoJQIb6vfaY6PwSwDATHsrO/BGcKlv2E
         fySA==
X-Forwarded-Encrypted: i=1; AJvYcCUrJtZIT4NsG60DSebWBFtzkjNyjC77w/VzVc78UWKLRGji3h7uiU4SGUjh7UtO8T/Pnd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPIbCz8b3bJZlV6yVCpIvYJpviSspDJZ18xb7NJtygJC3Kwdbg
	CvHIc3dBu+9dEYj629QlEXwJGHu5JKxqeQ5twSknON55VOfDTCMqy0X8EZANH1avyz4b4akBm8Z
	AuzSLQY5pE9d5ptXQKjprNxSl0Lj3Xrggy9RWG15HQKedP4Lk8A==
X-Gm-Gg: ASbGncvXDUYzkVVhdnmZ0RyjGbxMo1tN9zvoMiJ9TyAqXzSqMq02QzeDGwfkkm7O/Lk
	deJeMFvg6nGZZ+R1JdwL/zwIt6FNXiqriAsR5I+muPgWuCYyU07CuFTz+M4M1NXjQeJ/9VstB5L
	Ic40o4gU6v/ZONnqefsux9zSqp/TM4Kcc0VfKK59mwNFCY0HARF37GlabraMplcn9GIfXnhXe26
	yyKG07iEMOcSgq5+7SodgylVuBJiKBUPKy+7+SmzpFliIVU7Wrf08Mbum+ewdzdH/fsg++mIDHP
	etisBilPVjMML939DMw8LiESH5KmrfozQQKM8kKOmGOkdOT77UmNDBzgxavI
X-Received: by 2002:a05:600c:c19:b0:43c:f050:fee8 with SMTP id 5b1f17b1804b1-43f2d96d12bmr27394525e9.20.1744297846042;
        Thu, 10 Apr 2025 08:10:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxwdlqvMr0+eJqJHcy2sApkT2sXjxRivRro1I+Xe8jUjWmS3HlK9o9rH1isaEbTm3IHTMmxg==
X-Received: by 2002:a05:600c:c19:b0:43c:f050:fee8 with SMTP id 5b1f17b1804b1-43f2d96d12bmr27394165e9.20.1744297845618;
        Thu, 10 Apr 2025 08:10:45 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d8938a860sm5156906f8f.54.2025.04.10.08.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 08:10:45 -0700 (PDT)
Date: Thu, 10 Apr 2025 17:10:43 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: arch_timer_edge_cases failures on ampere-one
Message-ID: <ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hey,

I'm seeing consistent failures for the arch_timer_edge_cases
selftest one ampere-one(x):
==== Test Assertion Failure ====
   arm64/arch_timer_edge_cases.c:170: timer_condition == istatus
   pid=6277 tid=6277 errno=4 - Interrupted system call
      1  0x0000000000403bcf: test_run at arch_timer_edge_cases.c:962
      2  0x0000000000401f1f: main at arch_timer_edge_cases.c:1083
      3  0x0000ffffa8b2625b: ?? ??:0
      4  0x0000ffffa8b2633b: ?? ??:0
      5  0x000000000040202f: _start at ??:?
   0x1 != 0x0 (timer_condition != istatus)

The (first) test that's failing is from test_timers_in_the_past():
     /* Set a timer to counter=0 (in the past) */
     test_timer_cval(timer, 0, wm, true, DEF_CNT);

If I understand this correctly then the timer condition is met, an
irq should be raised with the istatus bit from SYS_CNTV_CTL_EL0 set.

What the guest gets for SYS_CNTV_CTL_EL0 is 1 (only the enable bit
set). KVM also reads 1 in timer_save_state() via
read_sysreg_el0(SYS_CNTV_CTL). Is this a HW/FW issue?

These machines have FEAT_ECV (as a test I disabled that in the kernel
but with the same result).

As a hack I set ARCH_TIMER_CTRL_IT_STAT in timer_save_state() when
the timer condition is met and set up traps for the register - this
lets the testcase succeed.

All with the current upstream kernel - but this is not new, I saw
this a couple of months ago but lost access to the machine before
I could debug..

Any hints what to do here?

Sebastian


