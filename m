Return-Path: <kvm+bounces-19657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF86908628
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA2D11F27717
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 08:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E22918FDAD;
	Fri, 14 Jun 2024 08:20:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB6D18FC72
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718353221; cv=none; b=sfLRa9nSUu2ZnpgI90lBb3Zc/KsxLQ8vFeK1qHOHdBKGAmb7bX16UZcZkwOcFe24MiIFH5G6/Wi1jEoMiJSkVV9X7kd1LeeS2iy6K+sU0GZEbUkZ/GK8eFb4EtWbtT5zBpprU0y+KJYa5Ra4QxadbdhqHcHlTfkxXAzuCos+Gas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718353221; c=relaxed/simple;
	bh=m8XdaqtXI0w6HM/U1eVRx3knXpS9a+JdhIoBK9Geo8k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ISDGYoR7FS46rGk7IoJORZUF561RWqa2PEznYiiXZ91uOR0TXVNe1gERXJrJcN2Etmt8AlWUjqXcr4VIXhmwxLQguthQUs/YeZcUr8CV/G4C8UrT/v494UPn8mkakwFeWW8K73Y4DdgyyFOWsfmsAFv2STN/0ZWDZF970cy6qeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7ebf00251b9so47675639f.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 01:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718353218; x=1718958018;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mw/gmD8zfhhWz2Q5eb6Jk78puOClrPRzMXMX9i+PUck=;
        b=UXIXYulxfNQfO1wL02MWNLLpD7PPf5ZiV0LFcB/5UFm7pHnHfnubWZIn0cyiFCeVr/
         CvzuF9wDZvPRHVXWCyW9aeYsG/x4xEX5TfJDP7mzjuX39fUxDmZH65kCriz1dAGuZb3S
         vxoer31pEqzX6y3+vjj2+tWuKOEROTf0yB1kafv2wVDZTDs3H/gAtqr1mN5fTq3BX2LI
         2pCdFPVPD3szFoHZ2255mHg/M6hMnRHXNX+ZBOIlydShGbTUX6gWazvwLDNCkcvsNy5Y
         HVhvC2pwjPUUsAWOakBS5oS5NkUB2+jDvPGbwlBjVqnmk2egwaqPEeTyyQLVkdC58qYL
         8pMQ==
X-Gm-Message-State: AOJu0YxS3Vbdd/uwahnjOO0hLlhpM4m9C00OPCKZvMaphtQL3Uh2q8Su
	2paJqzXRnirCbycuCXVDDPAzj8FQiG0vIMHxTzzTpS0fDRWO/G5qbkynJ8bvgoCwU9McpbiUM7f
	Lcmu97RYA1kOwDXkmM843zTCgIEJTBdr4AtI/U4eW7e+xoDdkO2IjZMQ=
X-Google-Smtp-Source: AGHT+IHB18E+8kcUAwZff/xbzCuJF99fWBw8Ydni7ix1UtZ71j5o875OuOmErMVjsVk5mz+02kXiI2NbYxq7lQqOkylyU3hzksdw
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:340f:b0:7eb:7e0c:d172 with SMTP id
 ca18e2360f4ac-7ebeb644af1mr3718739f.3.1718353218699; Fri, 14 Jun 2024
 01:20:18 -0700 (PDT)
Date: Fri, 14 Jun 2024 01:20:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003311d8061ad549c8@google.com>
Subject: [syzbot] Monthly kvm report (Jun 2024)
From: syzbot <syzbot+list25a0ec62c55b4b714cc3@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 2 new issues were detected and 0 were fixed.
In total, 8 issues are still open and 117 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2960    No    WARNING in cleanup_srcu_struct (4)
                  https://syzkaller.appspot.com/bug?extid=6cf577c8ed4e23fe436b
<2> 197     No    WARNING in srcu_check_nmi_safety
                  https://syzkaller.appspot.com/bug?extid=62be362ff074b84ca393
<3> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<4> 2       Yes   WARNING in __kvm_gpc_refresh (2)
                  https://syzkaller.appspot.com/bug?extid=fd555292a1da3180fc82

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

