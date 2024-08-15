Return-Path: <kvm+bounces-24305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C7F9537F4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A36282296
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9171B374C;
	Thu, 15 Aug 2024 16:10:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1831B012B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738205; cv=none; b=YqBSGf/OqiMfor16IavJ9ts3+GeucO9GppOtTQg14sulOZks4nHx1O27ADEp+pCnpjn3hlmFJy3v3Ys58n9VQejhzo8a885ESNZoMHny76qQ7aaEY9njT/9cmscHMPkidXYnAuYMjGxw2osrquhN8s1QPo3BcNX58/m8bK+gsaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738205; c=relaxed/simple;
	bh=j2uYupfeKSgh0DfZRYYlMyC99HExdau3jIZqN4BrbAk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=A1xM8khtX3sP3kwwlB32iDOVZrGMwAaZc96q8Mhl8cDATmc20fArKQKW2ZcNz7rxXs14ja5coams8Q6bJvx5cqZWVWzOldKlq+uGLlO6dYWxRXr4LHtDNIpxewOPo8eMVyuRXVL4QAGg06blBKztJoLOpAO84jXiw2y3zB6NLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3962d4671c7so12775475ab.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723738203; x=1724343003;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+48SOAuLFWa3vOYJchc0yB8E8pO6GvAZqc/FFORHhSw=;
        b=JkEtoLGl8KF9zK+wNb0ktdui0DWgn/TCteM1Gox0zXNCrNAxCeKkq5nA8X4Hzr74+M
         xLKKNPYciuEan1uqSacsqsJFCgG1U6rpsPz+1OKY7wtZ3FHJpSut4VfJ2kV3ybZ1I9Hp
         A/JalKvRqC8a0oP65z2ZLNFKaWVWOQFGoIqEg93gQ8dK8vEGhfat8vSyDojL29Whxt4p
         pgLZV2j9fiK3Gcsxo1wbxS9zSTHqDjLtPHJabsOp4u/M/Fd9/qwtEPYMfmw3Pfm2frDl
         jqeyHk7USP14z4l7pazCE3IQIxQyBRvUE0T0e/eWu22GwO8qG3vQ81NWtJUW3Ib89oj2
         tghQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGEbuBrKbV6DOK30WTLyB3Q7aWfEiinEOXe9L0vCTwZkOVkP8p4lQOBACEUPcpMwjOqtHgs1l7yelWAIlhy93Tbx59
X-Gm-Message-State: AOJu0YwvBMn90btGigwPtAxu99z2baJzyXb2griI1kzNaeVdWTxlazA6
	PJ3s4x6QRHzArhrGE8khEi+qUWZzAiKljrbTHjWCEdNtiveBug8oEcaBfrzPwH1ys5IPUF3sdWY
	zOJKE9bWjJi2lNqiLKyM2Y6IjHg40GR9NrmLzhWUyh0WHEZNPFjY8UGY=
X-Google-Smtp-Source: AGHT+IFhijMKxOHvEmejfGCrN0UCTcPcB8Qp17m0Xsh3eQixZLpUkNfc3bISLAfaoqkI5L5Rer4110AXeccsAco0NPqCdduTR/JH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164c:b0:397:95c7:6f72 with SMTP id
 e9e14a558f8ab-39d26d95de3mr190845ab.6.1723738203044; Thu, 15 Aug 2024
 09:10:03 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:10:03 -0700
In-Reply-To: <0000000000006923bb06178ce04a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004754de061fbb1356@google.com>
Subject: Re: [syzbot] [mm?] WARNING in hpage_collapse_scan_pmd (2)
From: syzbot <syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, borntraeger@linux.ibm.com, 
	david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	io-uring@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	peterx@redhat.com, shuah@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit c88033efe9a391e72ba6b5df4b01d6e628f4e734
Author: Peter Xu <peterx@redhat.com>
Date:   Mon Apr 22 13:33:11 2024 +0000

    mm/userfaultfd: reset ptes when close() for wr-protected ones

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f2396b980000
start commit:   e67572cd2204 Linux 6.9-rc6
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
dashboard link: https://syzkaller.appspot.com/bug?extid=5ea2845f44caa77f5543
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10874a40980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm/userfaultfd: reset ptes when close() for wr-protected ones

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

