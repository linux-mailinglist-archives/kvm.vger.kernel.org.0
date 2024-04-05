Return-Path: <kvm+bounces-13711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B661899D66
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 14:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D52AC1F23082
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 12:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813CB16D323;
	Fri,  5 Apr 2024 12:45:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344E16C86D
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712321122; cv=none; b=MwSi+Ky6gIof4Nuh8WjMkS4vJa8dU3pLG/POiZDJsK/NRfygX0tsHStBI31xuS7b3Oq6oidCJOA4ae0G1o3qDmMqdtxnBh4tecsXIdka3GXw9TKP5BW5TzNnrv2ZX+0Dl5sn+RDn3hl5L+C/r4dNQ62vjhoWHC2EjxbH/ybgGRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712321122; c=relaxed/simple;
	bh=Dphsl1wEb+tj7NHd0/4Ylex6ZvS9e5NcNE+l2QxlXTM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SfhnjSpBU8B1vXeL+SvdTGlXBvqFzbhKtXP9lPRQPc/I4VeIcFBYFYttkWaB+VMktymussMfJGLsOongAa+dWBtlscILWKPklF6YVGZI7lIjqbmvv4V91OVm+hCVLpyF5cgLUjUBIoMjMxvqUfdGjnpXqmiziqiKU1p/Yb558Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c7e21711d0so157767639f.3
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 05:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712321120; x=1712925920;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rIDr1iAoSIhWICRRsyfBYTI+CbbsPmNqERiJNm4bnzE=;
        b=CUOq9MIa8ACRjcX8bLSZY92rDUAp5KnOgkXnAiqN951WSd5uUswiUkvtDngu9S9plC
         0nsvwCzBQu3RoZ7HVKVFRpkScsGSrNdNiPfkBTuU1e28bEPwfjOJ7uuIt3+RGjqHDAiC
         tTNj9Amof9ndejeKdp+1o00zAqUFhzWV8wpgUmIbqN9HomSav1E1zfSY8H5Ljq77Cl52
         rmgn1oS805atNjfHqvLvsqhBf+cSAiH/HLeSWUy1P5/o6NLgr4Z7c0qyNVdhk5XvM1AS
         +FoMkJhffsvk5x94pq7y/MwoSQu6IWMHhK4chIGLnDgwjJMGQs/ym089MsJC3wVqgLYI
         olrQ==
X-Gm-Message-State: AOJu0YwFWSEUQpEJpLGET70IvrlVehI4C22yNeBn+G+J9Qly1gzzEthS
	n3ifUqC2duCwHVPslzdnY97r6BcUV9CGR0dcEm9+wWpH8tpQxBp/tuWTMkOUMxUohMdiw8gX88y
	ex3AHwEkEZKq88G7OpaFJQyP3aawEjYMo7Tyz/C6YFy696FSYgw+B1Bct5g==
X-Google-Smtp-Source: AGHT+IHI0E4ZS0sxatzkSZIyeEbtV/5q5IEz++DvGaVS1MOzYLVM19Xa53LLeDDXfYn9F4bNxqBd+BotKSUIedvm8jCsMHzyI3GH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3792:b0:47e:e557:ba45 with SMTP id
 w18-20020a056638379200b0047ee557ba45mr39982jal.0.1712321119894; Fri, 05 Apr
 2024 05:45:19 -0700 (PDT)
Date: Fri, 05 Apr 2024 05:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017d4bb061558d4b2@google.com>
Subject: [syzbot] Monthly kvm report (Apr 2024)
From: syzbot <syzbot+list367f2137b2dd1518ad84@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello kvm maintainers/developers,

This is a 31-day syzbot report for the kvm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/kvm

During the period, 4 new issues were detected and 0 were fixed.
In total, 5 issues are still open and 113 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 147     Yes   WARNING in handle_exception_nmi (2)
                  https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
<2> 113     Yes   WARNING in __kvm_gpc_refresh
                  https://syzkaller.appspot.com/bug?extid=106a4f72b0474e1d1b33
<3> 3       Yes   WARNING in clear_dirty_gfn_range
                  https://syzkaller.appspot.com/bug?extid=900d58a45dcaab9e4821

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

