Return-Path: <kvm+bounces-12611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D265388AF05
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 19:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 886821FA2B7E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9E63DABFE;
	Mon, 25 Mar 2024 18:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4IDJebwM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616E11198
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 18:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392743; cv=none; b=b68zmqUC2xxOHU6b9Z/o/k+0RvQchjU2R6Yb4q9MSNqzFmnjzqJtB/yN0jsupBLW8YhvK4qGe8gA6pINwHuzL4zuT/Zv3hNag03jpo0bTKzZLmBWfzvxjF/2BfHlBAY6g5hp1ssXcfqHV+6HgRty/tPPQYFPJ2O5VkSINvl/qes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392743; c=relaxed/simple;
	bh=KHLZ6HkP4pw+A7mxbFi6YybGXgz4wVvrWW8vKcgQj58=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nxuetjs5hbRP3pbQ1AgaD/fN491VKPuTgmW5CV7CnCJadsjXERTqt00bZdOk5iZ8YjfqSQNwACDsXm9A72Qq7jY6Wltgg/f30ClQEYKis+7Xm7pS/lG7pnuEE+nQn6g4CMmF/m0BhX7cyO0bmZcb7rSrkRYfFUqiomoWUeAwbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4IDJebwM; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-56bde8ea904so3616a12.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 11:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711392740; x=1711997540; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KHLZ6HkP4pw+A7mxbFi6YybGXgz4wVvrWW8vKcgQj58=;
        b=4IDJebwMDNxBh2tmhf7i7mFi1VkxETYNkjZfkR4tpoXg7knU3xpr94KwjCCdpycQXn
         2I0dizNYtZ6GhzOOmZkXQYdnrOPXgk7jYCw5ujTKhs1EWzx0sDed19V5KgSzL1MPb/Np
         O3Mv0hZSZfo5bkABttgtb694HrgMp7Ysca9EI0UYy3xQeJV5LlTGcsuZ1goYcVfeJ/SB
         //RQ7T+X3nrcMy+yGVscoE4eZhZL3k++77M4AK2GrVWaSpLf7dogqFUrFHm/7wGzaK6N
         l2P9mQQmjoFKHJ650y/0B5a0QPotsHpi7ZHXy5TWw2aNrpy88WqQx3eUimogER13UGho
         7W6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711392740; x=1711997540;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KHLZ6HkP4pw+A7mxbFi6YybGXgz4wVvrWW8vKcgQj58=;
        b=sKcvs9obzRbud3RTkZWace12B9TYK4LPTS6oYQ+pC+KP6YjAerDTnMnBAq8Xj6IAAL
         ELQVEhA3TNjPRHSTDgFX0pzPyDM6Lv/twuPwnO5PTY39Z+mzgR5/vPRrOFnH93v5LiMw
         2BAMEn5l6hW6UMtr6bE/yb5jMq4bM6EYSD/CuqZl6sIgerwjv8foTBOxMp/MU7j7UMem
         lzCQfalpucxEOrAXHl1N7feESkLDLq4f9q582bRxJ+Jh7q9OZuNVq4fcIePMYBYbUg0u
         VyiGCFikZbWhyM1FsLaHx0N9lnagCi1P7RzVtqIse2VOeGFlyrnFF/Q8OywYDOY1Zj21
         GJ8g==
X-Gm-Message-State: AOJu0Yxqku5cL4MhzooUUaC08CAoae4LDINlDdbw+1BwPqPTZ1rRNyYc
	l06rOrXB4WXiArHYaG6K5wcKaCUEgo9W1+TaT+Ymvnk8WIcebBIEb/bQWtbbnpuqoRIO36njd8d
	eZkWbn/louPnMGvrj6r8sS0rV5zAy2DuUXsobHGoFaTWLjiY0P6Sq
X-Google-Smtp-Source: AGHT+IG26daVNtFQdB2yfU0z1CletLKqycj97c905eZhF98sUsX2WuR6SvKFJc4FmmqLOG5S2R4wOpiGjy5Gg8mvZ5M=
X-Received: by 2002:aa7:db46:0:b0:56c:12c7:3ebb with SMTP id
 n6-20020aa7db46000000b0056c12c73ebbmr202697edt.2.1711392739504; Mon, 25 Mar
 2024 11:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jim Mattson <jmattson@google.com>
Date: Mon, 25 Mar 2024 11:52:05 -0700
Message-ID: <CALMp9eQPAfshFLXA7Jtm0maoM5HHrii77C_KEgh4Q8j02TA4ew@mail.gmail.com>
Subject: kvm-unit-test x86_64:msr fails on SKX H0 (0x50654)
To: kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

We are seeing this test fail on SKX H0, because the hardware allows
writes to every bit of IA32_FLUSH_CMD without raising a fault, in
contravention of the specification.

Are others seeing this failure as well, or is there something special
about our chips?

We have microcode patch level 0x2007006.

Thanks!

