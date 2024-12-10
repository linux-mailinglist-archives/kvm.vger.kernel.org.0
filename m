Return-Path: <kvm+bounces-33400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23BB19EAC9E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE158188BEE8
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4B321576D;
	Tue, 10 Dec 2024 09:38:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97F215767
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823486; cv=none; b=lr/0nfJBh6T/yKdHKG5+NkOXidPysGfoft6cmxt3LPly/Kkz9ww/L2pgFV/tru0MhWiWFN5J95M0EP+Wrrt9osGe50wbJ28w/rIGEUJH3fe41+CVZvf4a+J7Gl6OXBwd+oFfolnhFT9mr8PwcYRUuD5NC+KBMfytcJTQUQtvAiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823486; c=relaxed/simple;
	bh=hnH4kevc6kex4L+RzlRqFCWeJulTQq6H47qyNdG6MMU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qJqYdFXqFnT9H+o46xVB3YkeeS9UiOMk/4glkRP4ci9IwVd4v2H7mXYWbYD8DPK4+1CgOZ7CHaBzHICL+uKI/DWZtMfZJYz4UUzRjDvyOwxORCuuH3Wx2zcBbUqbkllK0k4B1qiDvvLGhONYQEKs5TUI3VlHThIdMn7cAUuOpWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7d60252cbso51638565ab.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 01:38:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823484; x=1734428284;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0eziENA1csK0hH7tHldiihGt97BRbYtyrISTtW9X48=;
        b=w+z31uNyMFyWH8gEderyRqIf0j7ctNFRx37SgV49Z5G3/MU5GDzV7hOsuK0mqrkyV7
         Tr/PpKaolD9rmGitRmZffP9zj7uoVylYNl+afsvj/fliLOX2vlf21afn8Lj33RXkdFyy
         IhOJNmu4/oClw/B8GEcFV9LRKsL5ewl+qHQ8OG/n8a/VO/5qHbIe/TrqB1FPkvCTHNVU
         JHJTMFdkr9PaQNaDKJbT5MdC3I+BFbxOiFZURqCmIilrshR74ia17Pi6aOaO+WJACM23
         QPfw3UOT6XA2ESqS56V/7KpSNDdooBHdQkN8Ohw5S/Y1rpYfnLMkDKRZvJ0KQf5g4BnI
         6zxA==
X-Forwarded-Encrypted: i=1; AJvYcCXNy/KlHURnVHj8dCAoHQFFV8ExTrPRGoiMfxwBmKapuLsC4z4pnK8H1Ul+lWB/IP0R37E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9HpXFt3q9u2MO4CM4ccefgogwp9qHjsDX608Z/2NsGO6w3HiG
	uv3NyviCmrthRWowTPXlaDa5renitGSTXLX3xaPJfRGIQlKehe8TrtXDHnyuVIfWa2EdUa4Bgnw
	n1q9Uj3Nujex0sF+YRBsgp2bTklZ+PsfNofD7eeaIaxQzOpAhatgPiLo=
X-Google-Smtp-Source: AGHT+IHIzZV1uS4FARf7vLtejhT9vxSjcap83WYIYeYrAO4ZSQLSUIg6JmKOPCjRtDk7/akheUbpa+jYYegxUly+YlWJRFjvtaQk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa4:b0:3a7:ccb2:e438 with SMTP id
 e9e14a558f8ab-3a9dd3bc479mr26328655ab.11.1733823484045; Tue, 10 Dec 2024
 01:38:04 -0800 (PST)
Date: Tue, 10 Dec 2024 01:38:04 -0800
In-Reply-To: <671bc7a7.050a0220.455e8.022a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67580bfc.050a0220.a30f1.01c7.GAE@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in vcpu_run
From: syzbot <syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 45405155d876c326da89162b8173b8cc9ab7ed75
Author: Sean Christopherson <seanjc@google.com>
Date:   Fri Jun 7 17:26:09 2024 +0000

    KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ac34df980000
start commit:   ae90f6a6170d Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13ac34df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=15ac34df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=1522459a74d26b0ac33a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158d0230580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f8de40580000

Reported-by: syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Fixes: 45405155d876 ("KVM: x86: WARN if a vCPU gets a valid wakeup that KVM can't yet inject")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

