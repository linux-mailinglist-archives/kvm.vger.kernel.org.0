Return-Path: <kvm+bounces-54793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC14B282E5
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E4876014E7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A53B2C3264;
	Fri, 15 Aug 2025 15:24:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9972BEFF1
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271474; cv=none; b=IfYDCBddmr0LPCTO+OkLsGmKEamluTQUmbUBXjx21bJKTVh0/4vHMtWTmcAPZJ/KnKEdu34QoSfeAsbZPmlACRKzfOojsl/RtG6xNkMG9BJlpLCo8aMkrwQhOB3CNV79Y92fDdX7Q8dXyy+g8pRD0T4xW/2x0eGpuDphRd61PbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271474; c=relaxed/simple;
	bh=tQ1PHm9SWlFPoQSw5LhxX2Vf55dtCDNr9DNH1mD2vQk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RoVNwQuZBJDVIlCqfKJLDZVBc9sqCoujA70MGXEP6mDnv/OLLqJ8RArfBvSc/Oncxl5JYn/vNwvhLQxCNknA5O21chNYYHN0DoC6wS8KAR1Zg/+1BwAZvX79S0K3c6FEVpKpfA1cPKsJoaRz9PW0CHCd8agaE69eGJOIYqrrwVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e5700b4c7cso23425875ab.3
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 08:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271472; x=1755876272;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3An1IRlggyZJ01ddy564k2J0NFqGWkP3JTvHFV9nJ1s=;
        b=Kic9m2qvWWgCMtZSjDB0Irs7/NFaa8TWanmIXilchRMRYN9EYbnR/AzoLpMUS7Mud3
         5e8XVQyhjE2Lez5ISwReAK96mWcneGIzEiqrieVISOUgf/YvcVnioU1uubKUka29el5g
         9zSh7+U+WF1attVPXpd2kfddoWFzI3ShHmXsavnHv+uq+kMEMa65F29v8BVe2U72ewWe
         9J4/QObkIHDn8Cqc+0TSRW9kiJuwZ0dgXc9SoFd8/7iEnLrOJlGqIl1Byj4hOHmh32td
         TIlPdyyr6tIPp3UWjQwyFUBUl4XB5p5yUkOqhxoA2kVq3JfpKsVbf3p/QkceAl5iyBew
         EDjw==
X-Forwarded-Encrypted: i=1; AJvYcCWsCIaO1QzIn7lxEK7Ohu96R7Zjf6nUDhq/w/bWsbG4PpTUr46wwOge/2/x4j9VlYKUuws=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe6NvcANfZoHFUH0wU3cC+mPKG6AH318AAYp12mcuVj/9rqz2c
	WKpGug+av+Y44/WGk3YqWPJO9mJ0IyZ8gXi++2r+M0c/arqJYFUS2nLoSho7oS+FJ2KR+VyYDo8
	iCHNbO+yzJdha//xtA8hzab7b5bWCikUola1d3AodCMgocY34NiQDuAgC6JI=
X-Google-Smtp-Source: AGHT+IEakOhgxRRfPY5H+tcDUiu14RwKBGYJsspvG2JWF62Kfi/uJ9cHZ/es+6WI+rEO1p7QmdXuW6Sxt9pIBEwsWGvL5PlCj6Rj
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2196:b0:3e5:51bb:9cd9 with SMTP id
 e9e14a558f8ab-3e57e80ddbemr43145025ab.8.1755271465045; Fri, 15 Aug 2025
 08:24:25 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:24:25 -0700
In-Reply-To: <20250814120237.2469583-1-dwmw2@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f5129.050a0220.e29e5.0019.GAE@google.com>
Subject: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM guest and host.
From: syzbot ci <syzbot+ci156aec4dff349a40@syzkaller.appspotmail.com>
To: ajay.kaher@broadcom.com, akataria@vmware.com, alexey.makhalov@broadcom.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, dwmw2@infradead.org, 
	graf@amazon.de, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, vkuznets@redhat.com, x86@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Support "generic" CPUID timing leaf as KVM guest and host.
https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.org
* [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
* [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomation CPUID leaf
* [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe0988e/config

arch/x86/kernel/kvm.c:899:30: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

