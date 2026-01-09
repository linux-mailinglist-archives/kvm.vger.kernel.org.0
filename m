Return-Path: <kvm+bounces-67638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B2BD0C19D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C7EB302C845
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089422E173B;
	Fri,  9 Jan 2026 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bukmJ9M+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208601339A4
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767987941; cv=none; b=HPMnBmnfa8GJnccWrnLubJafJ0iOjCH/Af7Y7lsDiGKPt4p3hTpX/NONk2Ckdj8pTa9G5vghbiEULHaCwjGqJQR+WRz3omIw9lICY3w1GRZUxypvjCc/d/l106Beku2OgrXw8FhdppmxMs9g93J3ne9f5pIImQr/QZNNzVXlnJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767987941; c=relaxed/simple;
	bh=OD7gQX8OqcZwOQdsMQFIGsiJO3fMQ86FJF55riIiPy8=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=LVnD/pRPwQUfq1THJhU+JFqgkE0POmDvQUfbFGck72kT+saXtthKjur6lF8pOTZHR4S4pJ1csYOnbmd2KqdLGLj0jdzxSVjf1vlLweDcHiwdf7YFBa3pVR1IoFtiJYvVrRwzN+p7pa/wz8qWFLV5g7fblg25auvxmcgxIMv6M6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bukmJ9M+; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7fc0c1d45a4so2613710b3a.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 11:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767987939; x=1768592739; darn=vger.kernel.org;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2dC8TIM/96ihOVatRnyS9ZGTmtEtkA01mUCq/XSBdsA=;
        b=bukmJ9M+E6fRu9wdyN3L7BbobsURK3RsQaQSc2ZEGLdwgXWEYYqBWlQvlOtT2rn1+y
         7OdJghKWQ58E65HB7Te1TEByb3ANTAa7cuzsDHHI6gLu8wlhSsSTcfobMvVd+/qAfj5L
         wI9MSNj/QZ8CBq+6Shh3qepbQWAsm5zZ9FwrJg6ceuGvOshISM57HtcEvC1g1Ot49/JA
         e29WX1zxlAnp2QRd1iooPEWNYrUdu9TUTgPVch1cheptiLkgrOvMXFaYH0WGp65T5PSS
         IalVYSoB2HwdMQo/kKsiEfU8+qTI88C3PUHPjyNs8gSWZUqaf/UwbbVE6rDdXC+UHDHH
         Lpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767987939; x=1768592739;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2dC8TIM/96ihOVatRnyS9ZGTmtEtkA01mUCq/XSBdsA=;
        b=MNL1EiI7Lj704rwWdQy1D8Mlsj4r1j+k3i0vCdHlWWaToqtaAvDJiDH23hFjIerQQA
         hrSuNjsy6yG2Rr4jFW4GrMS6AOQAjWWaPqXG7QM5yrghzjhkOjGdGOp+eBuKcv3sYmXY
         1vmVh7O52gZEydTIKSX/aXCfNl3TPzC4GzAiHiW8cIqcmX0QyI1i3GxaBhfUf6qIip6M
         rCRUrnAGwKL7+Aa4JmQbVDaVJUtM+x4BKhrhHQTwLpk0dzNG5qFgcgPbw4ByLG7zd/IP
         FiNBKcdBO/paOyRH+pyPtyPSGVDD18GWbGSopvcQUYJXnWPWkbOn604xWaJicTGLaUp2
         B49Q==
X-Gm-Message-State: AOJu0YxTkwQkbGvImOk++3f6lIXxy61BUrezKefOf8ZrefuXdbaRURAa
	Uc7AyoI4AX6Ex9q4X2cM9YK0+IjWemrXbdsZJdBGizdqGV5cFtdJKxKvsEdzvw==
X-Gm-Gg: AY/fxX7CKG9qDRVfoSI6yGE/ksRkAa9I9+2AmePJBHxJFVbh1LyUiSrSAg6LU2QmYvM
	+hAk09qTlrGrTcdB6yI5UTOIR3RnfxaoBJjrylK8us7TMj0b0zjgIPpwE2A9GEp0eKuxM+WTX91
	nzg/+GdbIYXjm+23Nwa5i/yVbK/d+g1p1BW3Ey+kolvFXAG2nBObNzvuFPc4xp3roFzUY8C0za4
	HTMRSSuIugvDTtZsevlLHN6V/+hezjiP/co6LYWNtkbkGgCaCE2R/Zcoy3unItvS2iTj3022/vp
	99lQd1cpTw5orj7gOAIZ/f6GNMCPMaw7MoaksjYkPW9GZ8mThx5xYdxlX2YU9W4PpEIa+X7kQF3
	epXlSqzrxhkgWNTeLNLta9O/rga0sE2w2bkGFVpPy3FVM5prYBen2iCwJrkrkVw4LPO+Wsha6tr
	jKVccHFopUCQGXYekmqHCaDO0wooNjLOiyb3zPBYhG1tn5iryHq5w9T39SSw==
X-Google-Smtp-Source: AGHT+IFDbQ9MuxCXC0+IMsK65f+VSmqC/5zYwFc7ERrinC4j/GSXahEjTn0fYekXZrPDDQ2FqTK//w==
X-Received: by 2002:a05:6a00:4190:b0:7e8:450c:61b4 with SMTP id d2e1a72fcca58-81b806c7a73mr9012895b3a.36.1767987939365;
        Fri, 09 Jan 2026 11:45:39 -0800 (PST)
Received: from DESKTOP-85LD9SI. (118-167-223-132.dynamic-ip.hinet.net. [118.167.223.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e46339579sm2551196b3a.18.2026.01.09.11.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 11:45:38 -0800 (PST)
Message-ID: <69615ae2.050a0220.47ba6.c4aa@mx.google.com>
X-Google-Original-Message-ID: <aWFa4I1wdfdmWmBt@DESKTOP-85LD9SI.>
Date: Sat, 10 Jan 2026 03:45:36 +0800
From: JiaHong Su <s11242586@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] KVM: hung task during vCPU destruction in
 kvm_clear_async_pf_completion_queue()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hello,

I found the following issue using Syzkaller on:

HEAD commit:    9ace475 Linux 6.19-rc4
Kernel config:  https://gist.github.com/AxelHowe/7fb5b3917d2f4a18c1d8cefbfd5846ef

A hung task warning is reported during KVM vCPU destruction.

INFO: task repro:9778 blocked for more than 143 seconds.
      Not tainted 6.19.0-rc4 #8
      Blocked by coredump.
Call Trace:
  __schedule
  schedule
  schedule_timeout
  __wait_for_common
  __flush_work
  cancel_work_sync
  kvm_clear_async_pf_completion_queue
  kvm_arch_vcpu_destroy
  kvm_destroy_vcpus
  kvm_arch_destroy_vm
  kvm_put_kvm
  kvm_vcpu_release
  __fput
  task_work_run
  do_exit
  do_group_exit
  get_signal
  arch_do_signal_or_restart
  entry_SYSCALL_64_after_hwframe

The teardown path blocks in cancel_work_sync() while clearing the async
page fault completion queue. The wait exceeds the hung task timeout and
does not appear to make forward progress in this exit/coredump context.

C reproducer, full dmesg output are available at:
https://gist.github.com/AxelHowe/f09bce07178d13a2ee095f30eef8327e

Thanks,
JiaHong Su

