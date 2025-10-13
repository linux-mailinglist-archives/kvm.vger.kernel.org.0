Return-Path: <kvm+bounces-59928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B68BD5810
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D80363B36D2
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF53D2EBDF9;
	Mon, 13 Oct 2025 17:22:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989C23817D
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760376124; cv=none; b=uWjh+eAqt2lmHj8PxJUxG0UANi7NPeRkJZUnZ6pd5JFTS37MQBzWc3ZMG76j0NRuSy6imkKPU7KR9mZydYty7SLGy3PFzzeNDTGIbJmHdMPEANvPO8XhlffsVQGE8SyW9teKNDW1Kdir2v+xwHVr6BG9qXLzhUVqljclkJ+zTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760376124; c=relaxed/simple;
	bh=nsGyivXBri6OSLxxjOWh4WGz6wp5udKFYCtPrJccLx0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WSojGfOORBOieRkOQGPdypyLdDkm4o/NaehR55YYUc95v3TdIE28gEDV/T8iqKBu/ZateXUvC4O+z/O8HZKwK9wTQAAkJK0JShKlGpdRMPCXqdjGLE1VlVqaQlKrdpL0YuWb5QeJrkssVKvNsDaqACQaPC6/ggQiEnGavNq+W/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8ea63b6f262so2475335939f.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 10:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760376122; x=1760980922;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IcTIroVdj0btffajsp6gtGNFiSwIhJCy9rGpAqsEW7U=;
        b=Hyp+CaVPqgXn+xOspHfLXhBrFRrg0YjDYRZvVKqsE2tfl1x6agNBlzpp+ExK3EjfWb
         yABQT/wDWApmy3RY727ijkw8pBDnOZlxXKCaCkToMpJqp1VVvT3hdr2KkgWSI9gVkeZg
         xPMI9ql1BzRctwlsyX4JaMlXmonXVu2flj0QMSuzmIjMGA0PTYcs0cJN1KxdOgTky9wZ
         zv0bV2qvdM7D3pK1s16PW96QR20ZaDpxsVPeI9bqpRGCw/XUmnD8RefHDbORM0zdlnG2
         0MOIpoFU8DiwGPfTrI79/xSCnZoRvYy+ot8ydtXQdtUy/zRKmJSmtr0mkVZzIpDKmG27
         4XKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgT+Y6QGz0EvPkou6UUpU484QidZO/atGYS7/Z7JvGNZrKgN9m8/Q7XYifVrr+mExo1gk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi8YXGYIc028iFsaAozYly1+T5B+L+uKfR/tFDl0V/84+Tc0mr
	GIGHxT7lVz4PQkCUQbAwOWw7AaiyWVaHszyTNm8HjWiCpzL5oY10A2SXrhMX87if81kbhK/8HrF
	edYJvwkxNoghHGAG0nbC60Wh+of4xrKDS5sDRsQTu/gsXgpz/gaSTmmXOStc=
X-Google-Smtp-Source: AGHT+IEZjRcbR2oTuA8IpjN+806A9p5IOVdRGzGHPrW6anLmhQbTzqyftrRkrZNyyXGONz8Vv4mpSMargfmhISDHou3gvOKCyfV4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:a01a:b0:893:d33f:e5ad with SMTP id
 ca18e2360f4ac-93bd198c5d7mr2225638539f.18.1760376122164; Mon, 13 Oct 2025
 10:22:02 -0700 (PDT)
Date: Mon, 13 Oct 2025 10:22:02 -0700
In-Reply-To: <0000000000004d1b5605e3573f8e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ed353a.050a0220.ac43.003c.GAE@google.com>
Subject: Re: [syzbot] [usb?] INFO: rcu detected stall in dummy_timer (4)
From: syzbot <syzbot+879882be5b42e60d4d98@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, fweisbec@gmail.com, 
	hdanton@sina.com, hpa@zytor.com, hverkuil+cisco@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	mingo@kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp, 
	sean@mess.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit eecd203ada43a4693ce6fdd3a58ae10c7819252c
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Thu Jul 17 14:21:55 2025 +0000

    media: imon: make send_packet() more robust

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15729dcd980000
start commit:   200e340f2196 Merge tag 'pull-work.dcache' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2886ebe3c7b3459
dashboard link: https://syzkaller.appspot.com/bug?extid=879882be5b42e60d4d98
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156ff9f2080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178a89f2080000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: media: imon: make send_packet() more robust

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

