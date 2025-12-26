Return-Path: <kvm+bounces-66705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D171CDE743
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 08:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55A173025A67
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 07:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE8F308F3E;
	Fri, 26 Dec 2025 07:48:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5810B2BD00C
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766735306; cv=none; b=RzZ/GiaTyIFrihgnGoFX9k3AujWom1+muYuEF6IENzGj0/YalQUeJcqVJgiglEKYySzSbwRrGMbB/lT8p7XykkbeG2sb64x+lpyAH1op8QV0Zb93vrpZySK0KYLYBmw4aup7/fAoQbkFYAO3Pe8pIPn0U7xoYWnI5YnUTo/rovk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766735306; c=relaxed/simple;
	bh=vD3zMV+oMBjO9VvGNDc3XfgYhgIhzMowAClHfXaHniw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UBIe6h62ioD2L2ZtyOXtOTn5pSDpPaJV0+ggNJkCW0CnIcK+riF4Mrk2o5LvtgH63BEqoLdvEL/isAdA3iYxJxXHu7gXaNO9LrGK8Xn9Dgy1iaPDu5bl3aatMcMpfliBLz4BFr6xXpYIPE4VmHeUnY3PjZv4d09geuQwraPjfwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6574d564a9eso12497060eaf.2
        for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 23:48:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766735303; x=1767340103;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pb29fEwuLMAhYyTTd5TIwJftXFN+VO+j3FMeSxKUzeA=;
        b=JJlGslw9btpPwS7SgdCj81y/4LccLITds1ggzuSe0tONlzyI972FGN0/swGtQ3BXGa
         JuJISI2B2OG6WIUwKbcXet5p3PBZl0Q877JnT/0ZFpheFF9As54gUbQDPxM8hy5z9vGN
         gRz3UlM/znfD3S6FoW1miZeHsjAsTJ526E5Cyp1HnhpOruWu8ZYy/jM0mFxCUgo2eE2N
         hELhYv5keVuVPFA5CAXCPybnXXzK1RoEcK0AD6ACg8bU7DjnpImyoJFbR79dqdattjRy
         A9FWmm2LMdFNj/LgTiq+f/Hlo/WKJfTk31m/iCjA93x8Qu74um3EykQgGhooVAxAFndN
         q8nw==
X-Gm-Message-State: AOJu0Yzw620QAqmupsGEHaSZJR5ga8PGG7EKOaeP4t6EPNaO5NrIhVyh
	qpFQ7IRrMwqIiNfxM42qWm3t3UqLD6T4TvNRyJdRG1wZ38lJzj867Gg2uUtCXz09KwM0XsBTyvW
	ffmwjfWU5estYnSC+beWD0nbqx+8VshqOVBILmx2hOZQ7UrZ/RlT7ADiDdfE=
X-Google-Smtp-Source: AGHT+IGG6GoI0XBy0uU2zPFYgFwbTbk3mNYqmeui92eUePbs4sq0nBOwhLaAqAP7lCpFNIoB4w/9AtY9yNUITqRviJYDMLM4/ltH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1507:b0:659:9a49:9086 with SMTP id
 006d021491bc7-65d0eb44ca3mr7938726eaf.81.1766735303281; Thu, 25 Dec 2025
 23:48:23 -0800 (PST)
Date: Thu, 25 Dec 2025 23:48:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694e3dc7.050a0220.35954c.006a.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Dec 2025)
From: syzbot <syzbot+lista52122cb6bf1f01d3e77@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 1 new issues were detected and 0 were fixed.
In total, 5 issues are still open and 76 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 659     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 200     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 66      Yes   WARNING in kvm_apic_accept_events (2)
                  https://syzkaller.appspot.com/bug?extid=59f2c3a3fc4f6c09b8cd
<4> 43      Yes   WARNING in vcpu_run
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

