Return-Path: <kvm+bounces-32526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AD19D998D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 15:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EFF0165EFA
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 14:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5491D1D5AC9;
	Tue, 26 Nov 2024 14:24:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810F43398E
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732631048; cv=none; b=MScptaTAqlBQ/xApoF43NVEzPuNl1inxZoNtDfq0msJeKR7f/LWTOGsphmeRFrPmESAHfQPvzBhKK/+kHfWiBEyFx5iskhQR+3nb9QnKYmRwT7FeZFiWdQ54Uhm+etQsxmUyydYL8AfQ+EOj7w78FsKsvXvRcS6i5DZjsBbaicQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732631048; c=relaxed/simple;
	bh=zbXV+L7MwoLZKChDBfQNPpwIHPvIgYaxAMf9TaNMm6E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=otv8o2+wiKr9S3y0KlCdjKSnVBFsC4vd3RTGUEXI2XFtyGE/FdeTWySmh/T2cRvpXycLDW11cDRxZn95lE/nbL2gOQUQe99VrxkDuVuJE08BPOZUgPGeUA01c5Tg2ZdfcxU+q0W7Pm6bV/DIfm58W6ty/h/68L9KMDCYLgSik7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8419946e077so249751439f.2
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 06:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732631046; x=1733235846;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RbwSlpx0JxOOG/QIfPBgxR7FjegQyCdVo54JAHKqNU4=;
        b=XJLl7AuHFVMhFAupbp8zSboMfyljgDXRAYcuurFMgfVWJK94go3X+tlPjk/wtZmGTN
         MgrKO4syN1Ft3BBCYsD6ut12HoUVxsYrhlMlT3Af/4kJYeEE21CDmZ8AVj93PUHM1Dpo
         YvcDy3KCi3AYc9k4n+dxDAZHBf1HpbMszMQRtcYCBKQameAuKDkRy3rg0UptKhshSquG
         IfNkM2OrYUCW+bFoUKcP/TeMVhsskSSINhMqv+hXXg8hzVoA2MXy1ABV5jeM47BO56re
         vzmvC3ZWZB+/a9MKJQIeFdroBVoZkjXNm2CTxEYp7T2kc9ihV3hPOajY7Cpswm/986dI
         MHQA==
X-Forwarded-Encrypted: i=1; AJvYcCVRGrgvZzgpLrkeJ8lqRPu9p0ZsQ+SyxaKhQSP0tRkS+ltKZGqs4/56CJ6N/0GDIo1dK0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDrGDpdt5CyyXXMMiy1wO2qgqlG1ONxQ4Idvj85Q5vH4ynDqDM
	JvoRmWFVuZb5OxOF2xY+QD8ifvQRxqGrYUkxWuUvKF0OAjQxTpA+MwDOXdjv+WcbDI6fObsWlLK
	NJRIHAaRNbOJmXaB5Zvok8zi3jvBA3u0y+RgmFOdj0sv+8lh0n11uIVo=
X-Google-Smtp-Source: AGHT+IGFP+jT1z0zEfotOxocuElKBVsiZu+rEtdAdSP45JbOgsdPy+Gm91Sy5bDiK+msbCwzbgDUFbDFaTU+8Me573D36Okj1pYM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1789:b0:3a6:ac4e:2659 with SMTP id
 e9e14a558f8ab-3a79ad6917bmr191836395ab.6.1732631046684; Tue, 26 Nov 2024
 06:24:06 -0800 (PST)
Date: Tue, 26 Nov 2024 06:24:06 -0800
In-Reply-To: <673f4bbc.050a0220.3c9d61.0174.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745da06.050a0220.1286eb.0018.GAE@google.com>
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in kvm_xen_set_evtchn_fast
From: syzbot <syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com>
To: bigeasy@linutronix.de, boqun.feng@gmail.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dwmw2@infradead.org, hdanton@sina.com, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	longman@redhat.com, mingo@redhat.com, paul@xen.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 560af5dc839eef08a273908f390cfefefb82aa04
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Wed Oct 9 15:45:03 2024 +0000

    lockdep: Enable PROVE_RAW_LOCK_NESTING with PROVE_LOCKING.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=162ef5c0580000
start commit:   06afb0f36106 Merge tag 'trace-v6.13' of git://git.kernel.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=152ef5c0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=112ef5c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b76860fd16c857
dashboard link: https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142981c0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1371975f980000

Reported-by: syzbot+919877893c9d28162dc2@syzkaller.appspotmail.com
Fixes: 560af5dc839e ("lockdep: Enable PROVE_RAW_LOCK_NESTING with PROVE_LOCKING.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

