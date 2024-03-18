Return-Path: <kvm+bounces-12019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9514C87F09E
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 20:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E161C21348
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 19:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B67F57862;
	Mon, 18 Mar 2024 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vuTaF4Pt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046156B6E
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791747; cv=none; b=hCUHs69BWqRV7E7+6EJCRfOAYOvoC84bb8leFxe6FqZTBhtyCAD5iaE/8u02ck1q7tzS/Hn57AOKTdSMG1y0kQ3vmlQiKT7ys2K6cVLQEPYaIgwwgeNX2hN67Un04NGgWwTJ7QtARun0LRqHSZOrbq1aOYe77QElkM91FqH2hlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791747; c=relaxed/simple;
	bh=ptDNly2mR1u4U/DgudtT7rV2/hJ3LkgQL0DLBEZxZT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a3gBTMfhLSRTGabOehhRgYUKB3PSIAPiOdX+G+MM6dqZ9CK5itTcwhNumMBseUFS5rAHKvyilB/Y/egGHxtnGCLeoYezKLTj0A4MjvyEsH1rZuxU69OssEEt1zpGUk+ugMOESrsEC9PJPXtmvoLRXkKL8rzF58zVDcJI/ljl7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vuTaF4Pt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a0a5bf550so89212737b3.3
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 12:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710791745; x=1711396545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ipqvitjC9uEm68hGzWFl2YF0lHrCC+apeVtm/fFcGYw=;
        b=vuTaF4Pt5N/Ss3r9VnMCNNcohljycaK90eZD7OqjIeoiumnerFpmRlujqz3OeCbL5+
         IvHCVIRCLQXdmrcZOOyvuRxgIy/2hGSFhalQUwFJe0c4m/j4EcJ030bhhn8K4Eq/ypoT
         vas46l35WXafp5TMqQhf0P5Z2SnqsAkuClXJjvBNfGdyAEZtKZ8W6ouzDQt0w4oArP/U
         fdhtEMqFx7lBjcUrAZLYOhxkNQwX0Z1L8B/knGp/MNOR+x1XeJC6RkfS4C2zgdxP/XHt
         NRl39aTgX9OU0KC7AFoV4LrZCrTnQvBjIsTITeDTvKaf8wPMeM51i9qLXLBlUwARjexi
         fbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791745; x=1711396545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipqvitjC9uEm68hGzWFl2YF0lHrCC+apeVtm/fFcGYw=;
        b=Hcjoryh/A7fL++EaZYUV69yCs+Bemo94zEhYQeeKla7oprXswtoZ4uRlzgOI+bxQTB
         p1YAn5WKPNpzoy9fHPZ9NzGkRKJW9A7d9dgqLTfjvdOiNkj/jypzfAyyYhHYYJHPIn41
         qq0UBpdXD4c/ZNausSeWJYxHIULsI019RUa0n4ouy4YOvzCImFkgqA83BnfGistL3jXt
         NUeVyLICDCXpkrGPujfdVZD43ohdu0pKP4hdDjiio6GldNMarRKJGIVvGhK3ZgQsQPKv
         vC6oYQR1+t3dqLEu6YWlGn2biDHMD0iDMa+0BDio/SFyNKyJh9VP8eL4tHRO6Xwu7bsG
         vniA==
X-Gm-Message-State: AOJu0YyJCPqHFKGwxRYEtIC7aPitv3w9TowTv6RFzry5dfLAY0dtzycz
	c86PlkdU4cyu+46+sAZ2kUtRHhWuFEmTKXoK5pmK/1teXESFEaLVi3pEuoUBCPpes1PkiqM3Fc4
	flg==
X-Google-Smtp-Source: AGHT+IGvdwVwhlFdkTeipp6fK2bpShM+iPT0SJ15MmTUsXEgNjNUV1cPNngfo7RJmj6Ugft5vtSJ50yrooQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:240e:b0:dc6:f877:ea7b with SMTP id
 dr14-20020a056902240e00b00dc6f877ea7bmr4437ybb.9.1710791744833; Mon, 18 Mar
 2024 12:55:44 -0700 (PDT)
Date: Mon, 18 Mar 2024 12:55:43 -0700
In-Reply-To: <0000000000005fa5cc0613f1cebd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000005fa5cc0613f1cebd@google.com>
Message-ID: <ZficP63PYEiqZGKO@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in __kvm_gpc_refresh
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 18, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    277100b3d5fe Merge tag 'block-6.9-20240315' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c96aa5180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c6662240382da2
> dashboard link: https://syzkaller.appspot.com/bug?extid=106a4f72b0474e1d1b33
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14358231180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110ed231180000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-277100b3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6872e049b27c/vmlinux-277100b3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/68ec7230df0f/bzImage-277100b3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5192 at arch/x86/kvm/../../../virt/kvm/pfncache.c:247 __kvm_gpc_refresh+0x15e2/0x2200 arch/x86/kvm/../../../virt/kvm/pfncache.c:247

The WARN is due to a new sanity check that exposed an old wart.  I'll get a patch
posted later today.

