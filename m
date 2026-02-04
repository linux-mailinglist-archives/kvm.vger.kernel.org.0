Return-Path: <kvm+bounces-70258-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WE9IOBaOg2lCpQMAu9opvQ
	(envelope-from <kvm+bounces-70258-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:21:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 609D1EB925
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 955F830156F1
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094FE423A8A;
	Wed,  4 Feb 2026 18:21:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8542317B
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229264; cv=none; b=l3hjKwgbbyK/7/yfMZ6CaZpirWtWsj+CT9twHuPE9flLtUYivAPW1rRY7+QFf/svLg/AagSTZSKyn454SZglnnEX5Tt1zTEo3S2vLBRV8F7Py2U3PD6XfDrFKHOq4iQAkZiWDVrTszvUJUPZGgbO1RIYXP8c1+FIYsYkxUzTkSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229264; c=relaxed/simple;
	bh=9sn/y5eXPv5nhZOueDCi8EXj6e8a+gB37Qyi/18QUok=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ZLPd6GRkv8pzr0iYoMdLQLumtoy5XIkPw8+aI4gGqaAVNLjlVA5yvyDRdnbgtsbmfuJDHhAmonm+0ItNS81237SaqAUfzyf7U3Ke6VhsS4vhSaIHJjrKpFUW53xPob4ICihE5SBrk45fal+JR/rWNjbcS/TUjiPL00XgWZX2830=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6630c8af251so365421eaf.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 10:21:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770229263; x=1770834063;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MP+qRj+t0mElF3G3xQisDzxCgXnelyoHkg0TVSCXRh8=;
        b=GDUzqF0h61om3cV9Ck9cdpN7CwBGvbAsBtjLggaBXhcOyZm12GbjgEFEPcHRJL421o
         yt5+irTj4t4Ugl7Xg8VQyVOA5rIhkVPJqhkFiHWIA5+t0OvktFu8uzNlieGgA+pY+N0u
         3Vmt3Q74jTeG7c9hifxpWVA5QfvCb0+/lDhg7Xv644GVMzknF6dPlob0V2fw9spcryVd
         VZKo+BNxYgCvJG6WQKH/kCqF6plJnXeUhC8K7ygTi5zZfgqES0FHT0jI1IjpCkceG0A6
         NabBga1AJIujHw1pR7D48CviBqdYBCUycoWGsaV4Ozu5G3pDLjgKgaY7NT6dJbgQ64FF
         zxvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5h5tS2+N41jf9dALzezUW8bytAuFNQqM1cXJ031oxsudRhdqQxcAHEwQE8ndUr1UFwn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrrDtk2j5gsDDXpthUTQWARhaV+7x4b+VW4XQY5HDbnuM3iuDW
	Njd9YszBpFLRJ1lvJxRe1zlNBLO0cWEWb8jIeK68zz+FkzG0+z9u5sShtxIVx2Uc3EjhpCRUCxL
	2Yi/f4T5exoDRtceJ2mRgNSGuHnyAOL/swVPtjI2YZCe8ifZgXuUpoz9z3/U=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d06:b0:65d:1636:5432 with SMTP id
 006d021491bc7-66a23433acfmr2036411eaf.65.1770229263270; Wed, 04 Feb 2026
 10:21:03 -0800 (PST)
Date: Wed, 04 Feb 2026 10:21:03 -0800
In-Reply-To: <20260204170144.2904483-1-ackerleytng@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69838e0f.a00a0220.34fa92.0012.GAE@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_gmem_fault_user_mapping
From: syzbot <syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com>
To: ackerleytng@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.64 / 15.00];
	MID_RHS_MATCH_TO(1.00)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=3aec2f7e1730a8eb];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70258-lists,kvm=lfdr.de,33a04338019ac7e43a44];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 609D1EB925
X-Rspamd-Action: no action

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com

Tested on:

commit:         0499add8 Merge tag 'kvm-x86-fixes-6.19-rc1' of https:/..
git tree:       git://git.kernel.org/pub/scm/virt/kvm/kvm.git next
console output: https://syzkaller.appspot.com/x/log.txt?x=1778a402580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3aec2f7e1730a8eb
dashboard link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13b847fa580000

Note: testing is done by a robot and is best-effort only.

