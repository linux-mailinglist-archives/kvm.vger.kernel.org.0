Return-Path: <kvm+bounces-11015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A133587231D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CA4F283AA9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 15:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9279127B7A;
	Tue,  5 Mar 2024 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gd03VV3q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D3127B53
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709653804; cv=none; b=Giic5DzY1KzrG5v2FBYlCvqDgnl6nU3RN4Higvh2yeVLnPcq27yGOuRuA+CB2ZkNyPG5D/HHLWFvfvneIVGt448Z+3uXIBLVnSgq37NyJg2/AvKuKLGTKZ6om/K6WUe6r/v6JWmzoIsKeHiXb5p+CI0UdWq/Kt2Nf4hrRyhLT7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709653804; c=relaxed/simple;
	bh=+XtwfPPzlgnB4RBNy2vV+a4eTKUlSTn4IPZnnwRh+SI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q5RUDVimM3WCtQjENUGvoCHpJomVkd0CjM8fa5Nn6aXmXmjGxoaTATieaVgBj+dzXpGOhlv1gdzf/VryOFf/KRP0D/s629fzpZ+gkbGaidW1SiRX9ZjZLGpWYofwpOzZzwH5qYDEIy8AkvXuDUrTO+RpYpSxRY3hmV8tXs1Utc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gd03VV3q; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6096c745c33so107901307b3.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 07:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709653801; x=1710258601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASWwD/q66AKnfmaM1STdFVXHI6YQnXzwPo0Knx3FJaM=;
        b=Gd03VV3q+0RVjjmQBQ/Z28hvbxC1yrFWH+Jiq7FUS8nhWLW5vN9dNitLsvnH/NURG+
         KO99Jzg+pE5xGZZkT2nreM8TVMUVYMYa5JVgxkUq9vhkclGhsWUrUyVzv2BM0t5Z5kzL
         bl42fPqKTs9aFyFE9Ihx2UntsVSoOOp0KeRAWH3kk/VH33n6aeZDnvQS9EKA0/yHx7YL
         YeqH0IiQI7fKfFg2ROi/BSqUX+udEUs18ZYsHAuLdDdECycAh6FuUjtZ4pkkeLO0G4Bi
         pNC+ja9xM2h/g5RmjgJmIIcZUDAGjY+dDk3QClMnFFKqMpIGkd4HKHiFTHCQkwW4LA5k
         V20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709653801; x=1710258601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ASWwD/q66AKnfmaM1STdFVXHI6YQnXzwPo0Knx3FJaM=;
        b=KGvHUQl+H/IUIoOj9EG6r8y987c3Q/iDN5IEW0xaBHvzS3vKQqUfHGJc/FGbu96/Nm
         w9Bcs/bA9HYGMDFofFofHzeV5qU0M5Oi91LlQwTvCOQxLZcBPC9UjdSnJVbtIilFTy+T
         fmyqY4W67s2/Hot/qnrNOiQRT6QOH8qPjsInCzqgRaFKi4S2TkTaEcxy8pOU6DJW6v66
         gVngaYUu6435ynp3fo+CVLgy48HX9mnN+EnUE5AztlSB2Bj5Ltas197EFZL61Q+Cjhj5
         8PkAdtSWGqgOzqk4A3Mrkyuu+XQ5SlKnJcaGPY4KxzoQVh/thypP5Gyk3TsGLgG0B4FF
         kiyg==
X-Forwarded-Encrypted: i=1; AJvYcCXrFjW4EcN/jiqr/9EjvBrfT9cYV7S5a2y1KX3J/3bqS6WimEvy2mDCQ4fxl2l2Fa0Qo6p4jSf4R/VtBz9DWX1/8fTl
X-Gm-Message-State: AOJu0YzL3gOWQBQy8sdASXgiH4v+6Jcst08+WsTbCnz200j/8wUcmSmP
	OlnG6pl7bvT9f3h0zam+NwyvP/uW2I9V3AKbhbw/opMoExjlc1R7gYhqEijPLbBcMOdu6jokz66
	xLg==
X-Google-Smtp-Source: AGHT+IH5NhL/twNWnmBcbZsXxhVpApXcvivMmR/ALiJ03As9pm7V1yl7lux12oyyZ8px2D/3xX7jGH1MZkM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fcd:b0:609:33af:cca8 with SMTP id
 dg13-20020a05690c0fcd00b0060933afcca8mr3473082ywb.2.1709653801455; Tue, 05
 Mar 2024 07:50:01 -0800 (PST)
Date: Tue, 5 Mar 2024 07:49:59 -0800
In-Reply-To: <0000000000009a8bce0612ea3e3c@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000376d93060a5207ed@google.com> <0000000000009a8bce0612ea3e3c@google.com>
Message-ID: <Zec_J7VKp_4QAP0Z@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_mmu_notifier_invalidate_range_start
 (3)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+c74f40907a9c0479af10@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tintinm2017@gmail.com, 
	usama.anjum@collabora.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 05, 2024, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 4cccb6221cae6d020270606b9e52b1678fc8b71a
> Author: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Date:   Tue Jan 9 11:24:42 2024 +0000
> 
>     fs/proc/task_mmu: move mmu notification mechanism inside mm lock
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1638c66c180000
> start commit:   b57b17e88bf5 Merge tag 'parisc-for-6.7-rc1-2' of git://git..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d950a2e2e34359e2
> dashboard link: https://syzkaller.appspot.com/bug?extid=c74f40907a9c0479af10
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15785fc4e80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1469c9a8e80000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: fs/proc/task_mmu: move mmu notification mechanism inside mm lock
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: fs/proc/task_mmu: move mmu notification mechanism inside mm lock

