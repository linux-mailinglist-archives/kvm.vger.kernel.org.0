Return-Path: <kvm+bounces-35283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EBEA0B4DD
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F4A73A2174
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEA522F155;
	Mon, 13 Jan 2025 10:54:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45A42AA5
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736765666; cv=none; b=HWFay+auiK/eroVycFs4nOgl9fGTZhfRl8WdRxelWFdPeAoW2QdOFLoc1QNjTS6SYooibzDiJkINMcO6QEq2MiOMx0EUo/eqthuXVnckCapYMP8i1Wox6Fkf4ICIdAEB/TSTxd8T+Y3e/991+Hjlm0jPQgVFXq8uwFXuPJzEdG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736765666; c=relaxed/simple;
	bh=gSped1d+GVN9tg5P7p4DbX5YOCWd8/Hj31M6zIrOOXY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r41zP2+gWwhyLDRQG6ZFZbi+2S+H5o/d2ukwT0lh5McBrVvNJ73OPf1szdhobxWZ/9XrchJicWJiol2zw1et5Wdb5akER9gOu82ga/AfEBsSShAyfkPKqJo6/ul15ZgezO0BqGlHKV5sVV56I+0aj88nk9rir4/51Y2yaEbNUsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so32659395ab.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 02:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736765664; x=1737370464;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQG1pLJvm2tQne7KJQEB5RexFMZuf73zr+c90WQW7Ko=;
        b=MS8qmshLXSVwfMPGnjKYJ/fpplymF3yViohFS1ckIBzyZoqNm1OkF/3/TxoTvNHk+7
         FSQVNh1q3OfTm82/KOzfpQjU58QH3OidMUTxEb5CyLE8KgSacugDflk7Tdpq9v1T88Lc
         iF3rGenKVB7s1qBKRqf479MGVZSmLMOGwUDYoT8dohWItomeb8N/1WAA1l99x2pZ64b6
         fE0VB0C3y1yXvOIskBtauHVMhwDS1F/cCKtTugDZ2aEzwlW+s3SnDoSvZctlxKh2lEms
         lqoJO9FZeO3ttEAydnw8YF/RHn6/hjmYbJMso82xIKsDJzeG2yOdZlWGfOZccDSVGBnw
         UMrw==
X-Gm-Message-State: AOJu0Yzzlb2BjKxxHFaEfnutH4GsVppkY+7822q83PXvzcC2WL+4kMxl
	KJRHt+0o5MkWeQzKefkI2D8eRaBi3zqYy5BwkjWg4xeT3R2xLB4AY34tExRB17Hu/HOeO190n8l
	wBj/RHnyOcAojcCYnnm0D6GSW+1gH9k2NWdwx39LXUIydS1RLrsn6fxQ=
X-Google-Smtp-Source: AGHT+IHMxdmseg56xqUEy0n/1DW12fORLyVG1RapBfYvDzVN4NTd5vFfJxej1XwVuCokuCcHxoUvO9McKldVZcptY7cdJZ06mp/Q
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:3a7:7ee3:10a2 with SMTP id
 e9e14a558f8ab-3ce3aa540e1mr156781715ab.19.1736765664073; Mon, 13 Jan 2025
 02:54:24 -0800 (PST)
Date: Mon, 13 Jan 2025 02:54:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6784f0e0.050a0220.216c54.004e.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Jan 2025)
From: syzbot <syzbot+lista788bc975da7a9b14bc2@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 2 new issues were detected and 0 were fixed.
In total, 7 issues are still open and 125 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 158     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<3> 18      No    WARNING in kvm_put_kvm (2)
                  https://syzkaller.appspot.com/bug?extid=4f8d3ac3727ffc0ecd8a
<4> 3       Yes   WARNING in vmx_handle_exit (2)
                  https://syzkaller.appspot.com/bug?extid=ac0bc3a70282b4d586cc
<5> 1       No    WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

