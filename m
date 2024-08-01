Return-Path: <kvm+bounces-22997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F3C945498
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 00:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43FDC28454E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 22:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEB114D296;
	Thu,  1 Aug 2024 22:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lfo7KuAV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88F38DD6
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722552245; cv=none; b=KKKlZUE/lTbeHD58C7Yl5/QR+GtI2POTjS3p3xSfg1DDsFPIUqud8nWMhakfUcBvI/th4yIFVqBnvmBnCzpAtCzHk5yrAOKMkuV3XyF6LUte5clFEwFFkUOk1RIJauKxYOsk+5hS2+sHeSg9OmeAjgtZAfyAsLfIpD39TYr+ZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722552245; c=relaxed/simple;
	bh=lq3VBorsI74MMj3Lqck3lrsi3fdGR/6G+iOUm2eJ8wc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gBrwBtLauGbDkIJIuYzt45ENTeKB5E+oOpp9aVnInpA446FfL3s/D3zujEdx8bhW/Xk8uPisu3FUUIEwu/fk73gKRvyRtcpZ7MFuLyWZKj55vNXOa+o1reL3/zqXjkqz84JqsqN5ar5WhcyCD7kFYzbusjcDfdcjDs0e72mTHjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lfo7KuAV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70e9ea89b42so6743775b3a.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 15:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722552244; x=1723157044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p85cwU83Btirpz320PiS8rUe0YP6eP6Qw8YmMGvdQno=;
        b=Lfo7KuAVtk8v5trLNAAwaMual7t21JwO/W8EvOKU0ZqhtOygG0AUDcpCSM3HC7eesx
         9oeyN1l6cjjUqIlTsXVIt9RBveR4Va0r6NaEj+VMXqdLisWKGlJsYbgrCgeUqMIWfzt1
         vnt9dXXpVEt3/yjMiVQHjUXLQJerWv2YA2FqYdTY3AAEMSmsXm4Ar0ksVIKgbQ5/+8sh
         BSJyfc+hiIHE+diwGIR3csT0a1WrbefL1hQGJBtgIZO/8fpC/g5bx56NUWetJqOp/GWe
         YG9h+kGK6MkaOL1Zjl58JBgilVbOqydbpvitAQvN1pXIUOpGPIyqSejOUWDRXzmlvL1Z
         g3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722552244; x=1723157044;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p85cwU83Btirpz320PiS8rUe0YP6eP6Qw8YmMGvdQno=;
        b=IbqbIOOpfU1evNG8twTX1S5rEP+pzI3DsFjWMCG9I0r+d+v0l8brso5hj7EytRz7CF
         +UirCmq4gr5LU/wLJHj0HX9SSKRW6sJZrGcDTej33HsgKhzE5s2CcsEELVj97CKGVrNZ
         W1Zwzj8EZhXJdjkpYeHEfwx18Mhn1wOtPFuqzEGke4tcVM1PwyWGORv38U/zurmhkb4Y
         1tTHD5JYQ8SeWZJ8MzPIJ7xuwc7QOSrjcL578AqC6D3ssOztp0qou8vlOlva8bmSI2hT
         QRfAMjJ3wCxX52shVF1ZhCiahuLPvxuUjudzG4YLCwJoppdVDKPwelHfw6uQdyKwbQZd
         39zg==
X-Gm-Message-State: AOJu0Yy22NAwf9woXEhzrVjE1EdnCtjlgwKdNWSYMYfUrO/B3DJewZtF
	GaGZ7IvDA7vNGB3bosMTCe3Jzh5byytF5FkmR4z5txQ0rXFkcVwU1x9/U7UTqt+OAo9qRAw/2MV
	gGA==
X-Google-Smtp-Source: AGHT+IEmR7D4g/Tw8EyfOWI7dF5c0FZtLAEI5aDeLZlNzohQhY4pE4dwXTrp2wXUEy2kRsQwoPrBvaSEB/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:949c:b0:705:ca19:2d08 with SMTP id
 d2e1a72fcca58-7106d0ca7camr10974b3a.6.1722552243470; Thu, 01 Aug 2024
 15:44:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 15:43:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801224349.25325-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Early warning for next week's PUCK since there's actually a topic this time.
James is going to lead a discussion on KVM userfault[*](name subject to change).

I Cc'd folks a few folks that I know are interested, please forward this on
as needed.

Early warning #2, PUCK is canceled for August 14th, as I'll be traveling, though
y'all are welcome to meet without me.

[*] https://lore.kernel.org/all/20240710234222.2333120-1-jthoughton@google.com

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
Augst   7th - KVM userfault
August 14th - Canceled (Sean unavailable)
August 21st - Available
August 28th - Available

