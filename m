Return-Path: <kvm+bounces-64475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CA7C840C2
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A87494E8573
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 08:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91612FF676;
	Tue, 25 Nov 2025 08:46:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA92E540C
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 08:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060391; cv=none; b=IAdBrh/t/nHChJhkwL1HAb3zUS3qJF+6UKxQvo0q99ceDINTvJ4GXRj6hE65YqUuGO4ufBD9uBqL3+StSUNyG/Fnbi3NzIDoQNrSaeuvHl42UUr4fZ7qlAxoEHxix2QvQI6/xXomX/NL38EiBnENLEpjPHvRstliryl7rO9SvU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060391; c=relaxed/simple;
	bh=kd22nJv4RvgANmmKQj00hg71Ln3DNYCz/RxBRQMSssw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VdXNWbW3xElixr9La6sCQ6rqtn7MRTCVskYtKSaB/Oua695/ZYBlBM+rpxIlHtdX7ILzAgnTiD7oCHo3cCxWSZg8eezQfZmX4Iksg0GB4epWk69MhPOQ4YUtgrQ53lAsKGyoYiMaxZxVnS6xwLcpovzaTfLCQwkSLRTx1TAcEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433770ba913so53808445ab.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 00:46:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764060387; x=1764665187;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nh9GgnteYYIjUrmRY6HUXJtHNCaI6IhhcPFadschZ3g=;
        b=kBt5f0mB8eY102SqHABoJ1t915nhv0sY0aZ4rScUp+JtplNepk4tQ+rw68YEbflNma
         68yGN6tQIpWkNP1ZKW0qz9YzZ2Y8rzjuv5R9KWhMlRhYGNFJYoHTL+itq99aex1+a4+m
         qzRawIyis1VJHCzY55s9STulAlxYIn9JwLl7cDOb0kEtsH9+K09HQG64k97nbipDAeLr
         FH5vFTdCA6iETVYOYQ9JWWTnv0zm/lYtrJByVg7iG8wuc5XNAGc1Cv2CFF9pr3M32aJH
         DOcKB8/SiAOwQGGKZjEHdRwi/Rm47nB6pN9idLOkgE8K+NVaM6dj43a7DaeaCn4FLXy2
         7p5g==
X-Gm-Message-State: AOJu0YzIqHmat4IkaOKnbCQnTAQcrWZyttG4qR8KK/7br3l6kEKIWlrq
	Wwo0Q/rGCdQdesVl1V8e/rEaa2cwXDvQYNd/kYau0BXIz5pOwCsyc6SZaj1/C87IrNOnmw4+cIE
	+PGa9Kc1Ga3D9uVz38S7qquA3Kbls+KN4ISq0XoNTj/XIJZcyYaZbINBFqBw=
X-Google-Smtp-Source: AGHT+IEcbliIlvmSCIwZ0PAQ5+Jhtw97hQ/Xd0Vk0n0D0qdy2Cy55kxB3IJL5xMjv4NLj6BgTt5Z8lugB99rnBOaIszzl/uVWLMh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:258d:b0:433:810c:db1 with SMTP id
 e9e14a558f8ab-435b8eb43f6mr101540875ab.20.1764060387593; Tue, 25 Nov 2025
 00:46:27 -0800 (PST)
Date: Tue, 25 Nov 2025 00:46:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69256ce3.a70a0220.d98e3.00a3.GAE@google.com>
Subject: [syzbot] Monthly kvm-x86 report (Nov 2025)
From: syzbot <syzbot+listf5f7430ac4c1a68133d2@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm-x86 maintainers/developers,

This is a 31-day syzbot report for the kvm-x86 subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm-x86

During the period, 1 new issues were detected and 0 were fixed.
In total, 4 issues are still open and 76 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 658     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 190     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<3> 25      Yes   WARNING in vcpu_run
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

