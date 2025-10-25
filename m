Return-Path: <kvm+bounces-61084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A0FC08A84
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 05:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE50A1C263A5
	for <lists+kvm@lfdr.de>; Sat, 25 Oct 2025 03:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8898D253B71;
	Sat, 25 Oct 2025 03:42:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79359220F38
	for <kvm@vger.kernel.org>; Sat, 25 Oct 2025 03:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761363727; cv=none; b=OaEw7oRn9XiETKSF7Wt5Srtg5DxO7O8QOXTWA+gAlp4GWmFf7hcr4dKucxT0mBYH00DTO2WHzoRx3u6qqMphojyW/cU79Vp8eRghzZEVVBBOjhVpT/kJTKWqsCkdhK5rHfivdEhWEuTTeh1ong0Dn7HP9QxuQ16jI6IYl9Bn75g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761363727; c=relaxed/simple;
	bh=SzP+ivXKYs1J2Q2yZCagZUFPpailgNKQgiqUjWShWdc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bkNfPNw9U/mDOBX3QTJIEKHzk4gKCLrL5WJbP+DSVw+bW5HjbQy8GGhbOTQzdvPzOAAci8LBbrXpyAlHvcWRqSjs5Y3SyLHqvVrd6nSfERxcw22D9wQXBRpbMsexfMQk92dXOQFAVNc5L8uVN7CStcQM83/wpjZkrw06CxvhVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9374627bb7eso483373239f.1
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 20:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761363724; x=1761968524;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C1gAk8yaTaRK74hcvRqkvBNHoM4DeFcCFZCfbuJzKtg=;
        b=CbxmQ5igUMtgiWJc5vIWuIlwX2pTWZnutf8JBA4VYesq4B/uTSN4RO057RXDbeTT1x
         3Xobxx52BnyCb3lMkuSU4b/jNVErs36/H65iMv1uBgJdnWYOZreVquigdrYf6q4CrnKG
         tW0aAwajiDiG6J4UJTqkt+4Pbszum8eou282IPI5ILBChXyRjHRuP1JZ6sc+0+KTdOvD
         2uDUvCjokKDhP69lFnzXM30xwKRSdYEzbS+AMkq1Hs0i6NBIda5Grs1YrtXDOzlwlnG9
         aGfpzOsb8DG54bL82XLXxTVdCNijT+4SDoAWCCmjeNdwvTop2rTrwydcjLqt2xE/+h3J
         ezpg==
X-Forwarded-Encrypted: i=1; AJvYcCXNnfP1yYjsIPWetD7Ys0s5sJr3iUaHaTIBLF/q2PyuvnD6W2k0BSuDogMZLNd4Hk5MHCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH+C36Ja8DB3OFxXrSALcDsOtftKROBsRq28tRufDaGjRbT1+a
	0ka4clkxMYe3nNSdLADKNd4Tvsr8u/ZsOiRVna0euLrbx+CaAPX4Et7Zesjt9KHmqkfdvpfDSP1
	NKMxHXCs9t72IgUTmwb2T2o0FjG1iNrIhr2nX4nnHcrOw6dRnGt3emh8L41E=
X-Google-Smtp-Source: AGHT+IGAAPxD6J7kBArbJnHS+iLGIEgMqqB2QN7CguVVoXBr8Cvn62ylon9Mf5kewthZfsCshsRxEjwe2AI0Kl0jZ9L69IrYjT9X
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c242:0:b0:431:da98:3519 with SMTP id
 e9e14a558f8ab-431eb54cf37mr61562235ab.0.1761363724676; Fri, 24 Oct 2025
 20:42:04 -0700 (PDT)
Date: Fri, 24 Oct 2025 20:42:04 -0700
In-Reply-To: <20251025015852.8771-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fc470c.a00a0220.9662e.0012.GAE@google.com>
Subject: Re: [syzbot] [kvm?] KASAN: slab-use-after-free Write in kvm_gmem_release
From: syzbot <syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com>
To: hdanton@sina.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	seanjc@google.com, syzkaller-bugs@googlegroups.com, tabba@google.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com
Tested-by: syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com

Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15da53e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcaf4aad77308158
dashboard link: https://syzkaller.appspot.com/bug?extid=2479e53d0db9b32ae2aa
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=161c4258580000

Note: testing is done by a robot and is best-effort only.

