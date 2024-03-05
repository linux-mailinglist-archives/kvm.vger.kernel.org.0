Return-Path: <kvm+bounces-11010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70CBB8720FC
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2735D1F26414
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033E186151;
	Tue,  5 Mar 2024 13:59:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FBE85C74
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709647144; cv=none; b=U55NR1ylfOtxH0ug+gCh5olikfQSPXyDVTU0SvMqcaz0PN5vZpOfC1pvDfpypfJklcDTPyGBftUQV55IvwHFWzMWEB+wV22XPjW4Q10R9huU2iFCEqwcSgm22hOEAFu/8VdMMajmIVJGrjBUU+0PFqm2y3W9E4Dq0mjzLiYw4B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709647144; c=relaxed/simple;
	bh=7l33o63t817PVAJxkpl+CDCljilBzWublR/7OYtNxNM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=a0cF9OKjvy/aRUxJEj//37QVG70f7p63NCLZcEgcaf4qC3EcESK0gwUhxRnQPYyP/pOxqwVBDiV2nVF7y6KuEHrexiRPiXGDkCc3bOXXiJweN21cJtPAl1cXmU5a2rccmPwSrKqLDagL9It4MlTWgh7GxHE5Z31RNOLOFA3RG2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c85571a980so149485639f.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:59:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709647142; x=1710251942;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ozqm1QJ84yI8HdJqurYAliOOcrvYW5cx3nOSejB731o=;
        b=qh/JZoUEwDdT4SMTkR3kyG5dfDqeb8I3QN3ziM+dP/Yst4bucPu2o2W1hvihQMujsi
         XDNupVrQ2TWw2IN5Sx20W5yE3mpd+jApXmTawyazxHsIvGZhW1k7r9xRsRpxdld0RPwR
         OgMZJtKEL/1A3Klk1NaV1aZjWeh7rae6LNq/81fkStLqPZ+x9hxwSlw/q78SiKiIOnmo
         lHsH3z8XinB7jT+cKaTmw16hIQa1HRNeJHuIobIBp8LvMboXWH2uhoTq/O4hUi7S8rnn
         S2YUNTTk0x2DsOKAtBFLrVuoTOM992s5On+NLUneJ9Szb7bQA58fEpqoj+be8SDw0fdY
         uWdA==
X-Forwarded-Encrypted: i=1; AJvYcCVko/+/YPOav8Y31x0K7R/DUzWZOZRX1sH8CqvRxh3mBX+JH9pbcnw8+1j7GkmHVMoNUwdLASCJuXOYmgjqCXAnahr0
X-Gm-Message-State: AOJu0YyejfJg4jxOcDR7IN1mog7XYTWQMmgNy2BeM0hSk9Qs6LJ7Lxaz
	cmWw976RQMrdQsHiKGCaZ1c9Du5+Hmd1U20O9FH7oTirmJlO3rRrSqBF+meDhDtAu1kNjfn5RM+
	rKtMbsDHfYSC4J98Cw8UxMyMHrdRUt0tzJC4P+ANSjdLzBE0tz1GL5HA=
X-Google-Smtp-Source: AGHT+IEP8n8qSf96nLlSO2rFxSJmbyVVUTknjVpsBlFop11mtXH7lx6mogLF/UQM1fodPwn/6hIAi5kpU8HrhUOEGbHhzUj7aJDi
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:35a7:b0:474:d2f6:f0d1 with SMTP id
 v39-20020a05663835a700b00474d2f6f0d1mr81402jal.1.1709647142220; Tue, 05 Mar
 2024 05:59:02 -0800 (PST)
Date: Tue, 05 Mar 2024 05:59:02 -0800
In-Reply-To: <000000000000376d93060a5207ed@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a8bce0612ea3e3c@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_mmu_notifier_invalidate_range_start
 (3)
From: syzbot <syzbot+c74f40907a9c0479af10@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com, 
	syzkaller-bugs@googlegroups.com, tintinm2017@gmail.com, 
	usama.anjum@collabora.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 4cccb6221cae6d020270606b9e52b1678fc8b71a
Author: Muhammad Usama Anjum <usama.anjum@collabora.com>
Date:   Tue Jan 9 11:24:42 2024 +0000

    fs/proc/task_mmu: move mmu notification mechanism inside mm lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1638c66c180000
start commit:   b57b17e88bf5 Merge tag 'parisc-for-6.7-rc1-2' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=d950a2e2e34359e2
dashboard link: https://syzkaller.appspot.com/bug?extid=c74f40907a9c0479af10
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15785fc4e80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1469c9a8e80000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: fs/proc/task_mmu: move mmu notification mechanism inside mm lock

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

