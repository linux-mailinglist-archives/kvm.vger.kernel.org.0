Return-Path: <kvm+bounces-59838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B7EBCFED1
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 04:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 80A6634859B
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 02:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321401E0DFE;
	Sun, 12 Oct 2025 02:53:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307971CDFCA
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 02:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760237584; cv=none; b=i9mPtpdRDV8kG+JSExiIZLvDNCHevgH7Q76z1RaFnrwKFqv55DFvQRyeNAKPqjXJrgWTA/hRpCjeSkZy4LxqVDXuyfKH9F4W0UTGgA46xxonxxjRCKEDAdOqunW9coje6LhHoD1q6+8gIPW+IKUzvou9pbyuJf6Ps11ZWkadn9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760237584; c=relaxed/simple;
	bh=7BJjU8mvRZTO3CSraVklA+BVU855Jmx35bucmD12j8s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=lP0AD/T9WC7hboImOTU2tYEFCcB5zU3fUioQ/vjw7qG3dxlprRXOoIOJdGeNEsstKNk4yElINTrPhXdnZ/Q3CEZ3iJ0n73XCRbUOWqb28xQJECQ+BPVny78j8NE0xF4DEn1NlvbGyGS7A0Oo63/fuKD84Vwnm2CZ0UQUXq0pnbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42f610046d9so244570105ab.3
        for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 19:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760237582; x=1760842382;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POMw7ZBLU0e1mkn6ITfoldLxK4uCmWFVIYgnY1nu5E8=;
        b=DE8lNXgnKcpuWjZRmsqaSN3K5cNNZtwOTbBNCOHZ4XClFK7cHNOMt0xMmbm5PjdR7l
         1C0mYGt4FitCQ81I8ANF4A9Y+Ji7HKSv1RzHzGse52JSoskt18TKFCqLFrMxr1iW76e9
         GqwEkdzCavfkX1WrLs4n6ty4UTpjG1Kmr7AK17QtuF9whXVSrHJino7Lb2/l/fv+Mgha
         hTfON9uq0vLANDvR+FDxg1dGI/FxKO61OboXX3rhOXtR2ZIWas19HYOLCuO6bWdQNH8n
         uC0gQk5ZnJ5MnXSJrSLZ1MOfC8BPcIOCrB229pE+qCMGAL8sfQ8T2meWgkg4SqQ4ZBda
         7u7g==
X-Forwarded-Encrypted: i=1; AJvYcCV/MZR2x6HLopZ0UJFnxKAvgULYkz66P0gwWtLJS0Qj7aLJi44S7MYoj4VzjEtjBLc0UQk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT6DBcu3Ej81iaxly0OBm+dWD/k2rhdDu+RAKEZfU7WDjzu+uw
	8TJWiOen8ygMC5WEDTxVAmXdA/MOqFCKAwqIUxeW2/dRJQhXU54RTe+xR4V7MTS/KhkcQbG5tBe
	Y8E7rlYt6ldbi0B+/Dk21tKH2HIJMrePTZdn+V9RY4yGX3t5jUxo51UyCiKU=
X-Google-Smtp-Source: AGHT+IGqV0tPIVVdEjjAOeDHjFSsyZFT0ykscgyvsHYo2mV1t+Vehl/zrV8TZ9Q5Jm5BJ8acjYmW9IU1jCBhRzvqgTCKTWGetdYt
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1488:b0:42e:2c30:285b with SMTP id
 e9e14a558f8ab-42f873d1c4bmr168499695ab.20.1760237582254; Sat, 11 Oct 2025
 19:53:02 -0700 (PDT)
Date: Sat, 11 Oct 2025 19:53:02 -0700
In-Reply-To: <684196cd.050a0220.2461cf.001e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68eb180e.a70a0220.b3ac9.0010.GAE@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events
From: syzbot <syzbot+b1784a9a955885da51cd@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 0fe3e8d804fdcc09ef44fbffcad8c39261a03470
Author: Sean Christopherson <seanjc@google.com>
Date:   Thu Jun 5 19:50:17 2025 +0000

    KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1585c9e2580000
start commit:   64980441d269 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=26abb92f9ef9d1d0
dashboard link: https://syzkaller.appspot.com/bug?extid=b1784a9a955885da51cd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12200c0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fd31d4580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

