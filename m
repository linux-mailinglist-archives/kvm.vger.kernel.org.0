Return-Path: <kvm+bounces-20734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7B591D217
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 16:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 527F41C20AEB
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 14:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5426315279E;
	Sun, 30 Jun 2024 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="el+PO6ZO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F026012D1E0
	for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719757204; cv=none; b=r/13FFLIbzDb2RXkVPElYaNh4L/5oXQcC2fk4qVS406Og7keFAlqgAsg0MF6eV+67fmYukyT5qebe/PjT9PlCEZlG+DEcOuOER1k0lgCT7MYd45nR0NBGvzQTlCj6VzFvbIjltAXxAo6OGwi7mJ+2P7x0KbtXhheaUk1/ECdoak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719757204; c=relaxed/simple;
	bh=eTc2YyVWuxbQUdkhQcyvQnlYMPaW5lHGn2BtXhfjlms=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=aiFDurg0C+5rTLrnNpPVnWOqIM8qioEIQ8FWGWRcvbFvs8N4aZk01Zr3yUYhmAIu8DExFcEVRxOWCxNmC3EAOvd4cx8xuwdXg0o+LcqBVcqhillb6+XC8SsYD4WvSirngMip1d6kCRnVmTGX8PDhoEzLle7L/L7CMH0yeJLMLQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=el+PO6ZO; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ec50d4e47bso21064311fa.2
        for <kvm@vger.kernel.org>; Sun, 30 Jun 2024 07:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719757200; x=1720362000; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eTc2YyVWuxbQUdkhQcyvQnlYMPaW5lHGn2BtXhfjlms=;
        b=el+PO6ZOWimg6VFmZf97gKpu3XMHXxbNJYZl7eHcIJJxHkR3XBGnyyyNHc6tmWnQJD
         HRb87e4SmLkT//VAOF3QR0bCy2iQedty5Icm//w4BAvEkIl4/cYYnU2iS51DJsi071z2
         H4nFKN/1NWEKyIRSPn9XH//oVfNzGIr6LNgSuIeVir0fqPI8KE7/5m8EwknOahNnwpHO
         ZgcZGkfu6usKYjdpOcKoeVoQbLDT/LW5rNhRz1mxvoayQNTwuRQJ0jlSTTVqyGPEOAK5
         DpuIBkkpBptk7MhlhlpshyQQPYdpg0Jdn5I7Ev0qie24OEcpzuaRv+9s/W3FV/5SeV0p
         F9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719757200; x=1720362000;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eTc2YyVWuxbQUdkhQcyvQnlYMPaW5lHGn2BtXhfjlms=;
        b=Et6dEylJ0wTVLc/xL4RMzPDE6PjoEkFLTCWyvsY8jaRS0sa6rSZr73cgGtjpMNubQh
         FpcO4UEkbzXYSboDbQFTNyEppoTnATrC35kvszXSzIXrkqlCR8Ksum9ug8z/10NLLOty
         knYJdDjO/qmLIeHmB+ApaBbeV5x/Z/VFDGse2IdLjGiWNj6YMmU10073KBCVDGzfCIuh
         sXoIxtdF8iTrEdYLCR3fcyCXpUqVpHe15H6Xa8uFrdNV5mLjzLEdIeSKrWyEJVUtXK63
         6YCYjFIwiphmrENFfcM0bwtf3rdpaKWuI6HJRBUqn5z9Hmby8d2au7904FvmrTOjeFIr
         ElZA==
X-Gm-Message-State: AOJu0Ywv6B6sRNfATsQneoY0YJijNtiu0hTpGP+gKWLt3xdHTN3rwuYi
	G6xsnkPodTKd5r6OcIpGlzumAdEyw7q7MLZKgfJSGSq455Hj4YQZaf85GbV2Crv8DpdQoI7GlpQ
	VJkC2fl5qU+dCPmEnqZcEdrOIC1wIO94O
X-Google-Smtp-Source: AGHT+IEBBPxQtR3yHslHxjTEZ9ZFs7FTRHd6GJsrXpesluLPr9FgQ4/ImBLl30DonJLBrfXaRQOZn4FId7RGgXvXosc=
X-Received: by 2002:a2e:bc19:0:b0:2eb:d924:43fb with SMTP id
 38308e7fff4ca-2ee5e6bc6f7mr24924631fa.41.1719757200097; Sun, 30 Jun 2024
 07:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Chloe Alverti <xloi.alverti@gmail.com>
Date: Sun, 30 Jun 2024 09:19:47 -0500
Message-ID: <CANpuKBNY0M+22K5T=UMz8iiqWwXy1jaWJNcOerrNK5Nhgqd1Hg@mail.gmail.com>
Subject: Using PEBS from qemu-kvm
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello to all,

I am using qemu to set-up a VM on a Sapphire Rapid server.
I am running linux kernel 6.6.14 in both guest and host.
I enable kvm for the guest and I pass the --cpu host flag to qemu.

My understanding is that there is some PEBS virtualization support in
place within kvm. However in the above set-up if I try:

perf record -e instructions:p ls -- I get back "unchecked MSR access
error: WRMSR to 0x3f1 (tried to write 0x0000000000000002)"

if I try perf record -e instructions:ppp ls -- I get back that the PMU
HW does not support sampling.

Also I see in dmesg that in the guest, PEBS has fmt-0 (format)
configured while in the host it is fmt-4.

In general, I would like to use PEBS within the guest to take a trace
of sampled instructions that cause LLC misses.

At this point, it is not clear to me if this is even possible.

Could you please let me know if I can use PEBS for my purpose at all,
and if yes what configuration am I missing?
Is there some other VMM that I should be using and not qemu?

Thank you very much in advance!
Best Regards,
Chloe

P.S.: PEBS sampling works fine in the host.

