Return-Path: <kvm+bounces-68323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF2ED332C9
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2C3730FB4DC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052513385A2;
	Fri, 16 Jan 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ngrssDKo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03481EB5E3
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577071; cv=none; b=crEi4FMyYimJbQtnQOwBZuA+wtWAghx5yX1bxUQ6edkI0RJxKi62o2Vgk5It0kNXbzxtCYzjl4QII2BoVHN6mjFSTQ4yWrRA2q5k8ly2Uoa5oQsClfhEcn6Pb40OpD34zKw9B3g8eG4yVjoKd1WjnafCyIby+9HAGP1d6Qo21sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577071; c=relaxed/simple;
	bh=oGHJW+jnTTj5On4dCWmvTz4XTMHoxo4xHLBOqxCnxDk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I3hnVNQbrZUOgf3AEQkbfkqR0IzxrFcFDeyZFdqLX0ICRjqiryo9AsF20rE3+i6aMcQofMEknApqG+82IAQFb2vwmVbGSCjgdWDpp44j6XcumCYljGQQdgAilSED4D/5hi5mxcUYVe6MemXh/VHJnpZCKvZM9rEZrG3wRU1sdNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ngrssDKo; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c52d37d346dso1178281a12.3
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 07:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768577069; x=1769181869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkO6UKtF7mzNzEDO3CLARWqWFPlA/ZmXFYMjyqf5Fqg=;
        b=ngrssDKolM6vdAk12lEJgc4xQlsp/Tge9wd7nK19QJaDfHyUf+IXNhr7ZdM+ILSOpN
         AwWIzqKIhfvmYfbfZ3ur3pdxRJ9x6XrNZMpFaVtlKyJjSu11gebgeiqpB9S0KRLhUiFb
         g8zqKOgjv2kq2HNC6cF3oDMpK58fISNB0bKULPcKuNHaAbO5+tQZyhcAECffqBwUoHat
         p2SbqPTPShsnrXOl0e4InpgIbTIIpjKKrMgRX3xRfNdNwtvw+BfJKaaCpFykICjU360K
         gwP8DiBrroea3ISjrvMPVt1GsQcbttW5bBO4K2pwX9y0JBToljuK2zaY9zGyq2jUQJBt
         4law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768577069; x=1769181869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkO6UKtF7mzNzEDO3CLARWqWFPlA/ZmXFYMjyqf5Fqg=;
        b=UpW+/xuzmqX4xme2nsakrlAsNXMsY6icUqW5WqSDPIzhuZioTkATe63jSAPgskjpya
         ddj53AbmFl1Q9NGIMtomLnKXQMn4gmAMh6SX4YU5xjH6gyuEJhpQw3KaisDZF2LSZcNo
         2cSosQUgC1KRe3dAyCEQK00T5hseK0plRvcF4+Ew/8awUtpjnJNgky6ZVYC2aEumEPnX
         HFhsGMrBc8tFN9ZZy/ddr9C160ajV4vDhPD/qu6v1H/MIs+Iw5hJnG/J4PumUtbpsRxc
         CuwkEC3ZtfXbDplqlUiYSF6WstOPxvtLs9Bp9J7Yd70/JHK2FWEP44TVN6GFQQZEOLRk
         UGFg==
X-Gm-Message-State: AOJu0Yy9GoFOnRjlrWak9WUIJFMcTlUdnwb8hyXo7296rRK9BT9OfgJa
	HaMDr7DEgXGP+rEUXCJ7r3twnOguvHjudnmBLaSslNiU4ufXcGV8w3tgd81hILXPhQ/1MNoe72h
	SYDIakg==
X-Received: from pjbbx14.prod.google.com ([2002:a17:90a:f48e:b0:34c:3879:557a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e45:b0:330:7ff5:2c58
 with SMTP id 98e67ed59e1d1-35272ebb8ebmr2999216a91.7.1768577069179; Fri, 16
 Jan 2026 07:24:29 -0800 (PST)
Date: Fri, 16 Jan 2026 07:24:27 -0800
In-Reply-To: <696a546a.050a0220.58bed.0056.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <696a546a.050a0220.58bed.0056.GAE@google.com>
Message-ID: <aWpYK83klokXFuds@google.com>
Subject: Re: [syzbot] [kvm?] BUG: unable to handle kernel paging request in kvm_gmem_get_folio
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+6f16df7b5a49f0e01b18@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 16, 2026, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9b7977f9e39b Add linux-next specific files for 20260115
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10585522580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9c0b39f55c418575
> dashboard link: https://syzkaller.appspot.com/bug?extid=6f16df7b5a49f0e01b18
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/32edced7b806/disk-9b7977f9.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/dec5450e284a/vmlinux-9b7977f9.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/65783c99fb65/bzImage-9b7977f9.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6f16df7b5a49f0e01b18@syzkaller.appspotmail.com
> 
> BUG: unable to handle page fault for address: fffffffffffffffc
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD e143067 P4D e143067 PUD e145067 PMD 0 
> Oops: Oops: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 10212 Comm: syz.7.1148 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:const_folio_flags include/linux/page-flags.h:351 [inline]
> RIP: 0010:folio_test_head include/linux/page-flags.h:844 [inline]
> RIP: 0010:folio_test_large include/linux/page-flags.h:865 [inline]
> RIP: 0010:folio_order include/linux/mm.h:1248 [inline]
> RIP: 0010:kvm_gmem_get_folio+0x12e/0x240 virt/kvm/guest_memfd.c:147

Too slow, syzbot!  https://lore.kernel.org/all/aWk9PusYNW0iADuD@google.com

#syz invalid

