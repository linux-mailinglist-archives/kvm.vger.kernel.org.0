Return-Path: <kvm+bounces-62494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D34FC45913
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 10:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6DDA1347A70
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 09:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C0F3002BB;
	Mon, 10 Nov 2025 09:15:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F642FF654
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 09:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762766131; cv=none; b=op7Kq2Pr9WvxTQW5gdXcEaVapgZmnxXylUCmBF9iWkv8aDjcT81PXA6j2xtMuoQFtjcP3unq26OS26QyHaC8v+HLxtDXqB6XlrHcqHIc5H9b1zgQD2oIyw/I0ZTb5X5RA4VFFSqtp7X/hcQNHGH5sf0o0xjVma8Ybdw1T8I3W1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762766131; c=relaxed/simple;
	bh=hU8lRhHBVaW8VtmWXIeuWHXSF+wMCmFrP+xe5ussH24=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PA/Y3wfAqei1mFxlUTB4+hsYVjHg24qp3Lw0rdEzbQnMipt3zYihN0GoVB8NA6Ydm5XaFdQnnmVkuRefq1vt0n+5nvbLwjV8M81jefBLq87leIUSxUb0teDSC6R/zPwIBvZT+q/SLck7mTDKPtM9w2mrAm4z8wNIpLnRKHbNmzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9489e3680bfso145637739f.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 01:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762766128; x=1763370928;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9uDtDaHnWs0NiVdeiClq6v4P14hxaHVQylJMPj15OWw=;
        b=kwwmk7X0QHFvIJA3TiMss4ooPhJFv+TzG94Xm7Ix+G/54Hl4zkLKRabakpqmDvmEh8
         ktLzeyS8MWhW4Vuh/87RQvpfXCZ7qzWpw0LMiP7+RsvvYuSRQka53wwUhNeeWzChbZpv
         y5ekeQUevpp/aEJVNca7FdqVNc54UQKvBONrxbcfeHXQDb6ud9FxgXjZodBHQR4UiWCF
         xABb6tQCvxuBLHK4nIPwfnFGgbfqGzaIffn7hieIdU5ZV3lFY763O/VYibymc0gAewA/
         tpeauzF1J2Pfd3EehxRDNaKq3YOhGbMT/A2XOvCygQTij6SkzC2P7FkCdms+EJMRbV2n
         EHGQ==
X-Gm-Message-State: AOJu0YxhhBYOGo0wcuBJjlJSY5nowa1S/zOihPMNByBfdLwXZIUK9Oof
	Y74yL1caxEA/zpHawC3Ng/xq/a64SJFrtmE+C708XLjQ7PIHmuMgJgxcyWtuZ7w90KaCi90/UfZ
	tRqtrlpF3OCD2WpfdpvLyUdrOXwTth5e1PEO0XwAM7L67rdwR84oXK+9Hzps=
X-Google-Smtp-Source: AGHT+IHLVT7tJwSCEaz15LXZUteGNdEXBsFeAbZlRm/KWQUI5sotn3DXPvEgIO7b4idr93wHM078RCeCnBkYXZ1l21AOk8QE4uyH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d90:b0:948:83b9:a347 with SMTP id
 ca18e2360f4ac-9489603d373mr962485739f.13.1762766128307; Mon, 10 Nov 2025
 01:15:28 -0800 (PST)
Date: Mon, 10 Nov 2025 01:15:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6911ad30.a70a0220.22f260.00da.GAE@google.com>
Subject: [syzbot] Monthly kvm report (Nov 2025)
From: syzbot <syzbot+list1971c68c6b629b221d3f@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 0 new issues were detected and 0 were fixed.
In total, 3 issues are still open and 64 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 657     Yes   WARNING: locking bug in kvm_xen_set_evtchn_fast
                  https://syzkaller.appspot.com/bug?extid=919877893c9d28162dc2
<2> 31      Yes   WARNING in __kvm_gpc_refresh (3)
                  https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
<3> 4       Yes   WARNING in kvm_read_guest_offset_cached
                  https://syzkaller.appspot.com/bug?extid=bc0e18379a290e5edfe4

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

