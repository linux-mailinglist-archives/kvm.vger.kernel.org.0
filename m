Return-Path: <kvm+bounces-57570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9683AB57B26
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:35:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61CF2188E747
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396893093CB;
	Mon, 15 Sep 2025 12:33:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16067305E3F
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 12:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757939615; cv=none; b=eHMqcJCARTAZNr3GHVf3hZnskOAXjtj09MydjUqLHj4s1O89R9qt9l4smGvjWIFGjIJYsJai2fQ0FozPAlRPR028WukMZHjCTb3Kkhwb3XNrdGFuhMzcMjuzB4/RqS8RP1ldHPNZAluL4nWT7QrAgzeQKe6g22GHSeeFUDXWGKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757939615; c=relaxed/simple;
	bh=mkfxhxO5ScFXWsiUPniKXa6nzPgwAWZ4l03poV8U9+A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oSHtF4Y8YJA7g3J7MwFwB+0hwcM+jkmZaUWZ0Bi2qe4yKgONne96UJ80u1Uf2z3eBps8enzJvrIMhlEetK1PiXiC1ZIWmCcCwNT8JYIXqxCHJ1Hz8LBAA/M792E28liLYs/13D35N3DxIunSCfrgPLIIQDm13INauelGYco61+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-424019a3dfaso10441055ab.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 05:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757939613; x=1758544413;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GKK4zDUIxsAmsfDEa3KR9K/Y4eq48dkCLdUH7Uw49FM=;
        b=Gt/hsprK38aWv5xx+34rAhHWCgGiy/3G9uJg4wR7IyzBdEW736xeEPodMv6pzFTLmj
         T3kICB0VobtmcLQDw6HmrEL9QBYA7PhfcHWj35CjYnHO0VgI0s6vopvuqwWW8CvIUD+l
         E5o+WETvtVRzjDq2Uf5mAxi3nM7LfkoECgL4ucfNUzFPoFKlqcq6d0ewemlTad4t17ov
         yyxKlS8iJQXkWnHM34O3BljWMENdZDdUray5r5qjoMxoCsUMS2dkz1rwJoWPoLKdY8NY
         TbAncHa0W2P3Ut3zkQ/nHVr22Sx/JxkRea833miXC8D8Cf2/PCPK8tIYdooK9dzsfYbf
         uKbw==
X-Gm-Message-State: AOJu0YxMaC9AygnuPjqq2Lp4c48iiiGDFcChPcylBZGLYioPOP35eHVn
	zAwcYCcJNeZBlfP5b29D3A44IviF0E2gh8mDvfUnGIa5Z7uh7Mw7k4Avx5nDRm0J0OAHGhGzlWh
	vSzqeI0F1j6HUMQyEG+3PlzDuAfnF7qBwW8I3esDanUG9DO8c4N/gPtj93wE=
X-Google-Smtp-Source: AGHT+IFTef8u8kJ5d86e6D/xRM+920v/pXfkePhDr57nCgIHu0rgSkAE+v8ScINcUklMNz2Qpda699xqVeueGr8dqIebQxY8n8kI
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a07:b0:413:5e19:aec4 with SMTP id
 e9e14a558f8ab-4209e278566mr116167385ab.8.1757939613224; Mon, 15 Sep 2025
 05:33:33 -0700 (PDT)
Date: Mon, 15 Sep 2025 05:33:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c8079d.050a0220.3c6139.0d14.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Sep 2025)
From: syzbot <syzbot+listaae77a5bd21f06f0ffbc@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 0 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 74 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 642     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 27      Yes   WARNING in kvm_apic_accept_events
                  https://syzkaller.appspot.com/bug?extid=b1784a9a955885da51cd
<3> 7       Yes   WARNING in vcpu_run
                  https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

