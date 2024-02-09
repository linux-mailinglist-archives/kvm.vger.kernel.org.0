Return-Path: <kvm+bounces-8489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F38884FE61
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4E102882C7
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537753D54D;
	Fri,  9 Feb 2024 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m6cZG1Wh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79713BB35
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 21:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707513007; cv=none; b=te+gxc2I4UFrLWRd0DrEeZuJr4fQXJ1XnQI7XjASEdUwcbq7NuhXGcalWzGQJKoKNFchEt84yRT7ogFc+u2t/zottcNyeNcHJdBHo1CiQL+AJEB2SmJi4noZHQrHGE7rAljRxFPtFmvRiG6kA3IsIEubTPOPUwtpT9n+aY909cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707513007; c=relaxed/simple;
	bh=KstuKPq2QT85GW66iMsndzDPXM2n5zBwQdqmRdE546Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qYj6kHudCAgTE4nv8DeuVkrbKKFTrZC3rBp2vjOHaxY0kM0z+N0R5eER1g3/GhdbZ6v42UxdBGMBOo2GMihk0TWfE71/hHLLwt1Z1dXGIfjPAOtBePAb2YYJHMzHohtU3UxlxlmNfyIuyCIQr/n4Kdzb5+/MQk1/MfOsthJMlkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m6cZG1Wh; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e05f5ca521so1547876b3a.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 13:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707513005; x=1708117805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/yxtFfNqdOpZECGkWirsTXPLiH0zhA6e05fl9ilXSY8=;
        b=m6cZG1WhmFsvRLkiV26M3sjc3qkLd2+dpauSbP/5e6pt9ah0vUCdUEvGXtRy7rh6QP
         mXGdhfNp4mvMJ7koHUYPi4Rzp7tq7JTApFI7weJJVP29rxuGM07ZTJ9hn2tmlpxI65wm
         npCaeBD84Wn4vDzoMPNh24VOYs1PjrnlF7JnjlY0UX51T3hZ1hsIC76NH/WMkJall+YJ
         au5CGaANRNmkC5AtqBW+gFSuKeOlN1eXi22lCjIUckZEUbOBjjVze73s5DQVobw5ogQ7
         Nzdge0CXnbCOfK8FgNL/qQBImNK9i9PVokk9HyQJg4h5HrkK3H0bkyUQtaAhJ4KKtPVj
         +u8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707513005; x=1708117805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/yxtFfNqdOpZECGkWirsTXPLiH0zhA6e05fl9ilXSY8=;
        b=qNd4i7uMskfncBXL2SU349Qxr2HRjC3inAsh2NJ9rJee4cu2IsBWel3R3y3TCbKyUi
         V7gTEhgxmGD5SdsdjYSd/j7HPrdyEyChZq7HyFjfz3ZTg2p2uC3h55bmPA+fdIGiCCws
         Plfw4s21szRlcg+ailnQ7xs88TkeHZwKqr0xpd0XCUD2ofNRI0WcrX78reY0xD0UMmAC
         XWH5OegSLhAMwbIz7Djq96fuAaRVSeNdH3UE3sCA495EmHB5W/9ucvSgVJJzAQ0BCI6T
         sOOWNUgIp5+hvX/c1JVsqT7TDGRpqvktlu9KlvCMjN6WToKUWy4EvS4iXkZUvCUm8oo5
         GpXA==
X-Gm-Message-State: AOJu0Yz5jQUwKga4LU/TUyzJCC3Fry7iRHMEHqDJQRFIRUqLRxWVNq3U
	7n9A6FV1MJ95ccWUFCYv726U3ZnGT4Zhm5L2pZcBkwl28Kq4toT2UxTs9Vj4gokMtMrykFck/zH
	/eA==
X-Google-Smtp-Source: AGHT+IHOgP2a7+cFtV5Lwze8UHFIv1ebvvjea4R1e25mn6GRCrxKKHRCDWLSuG+51Jum8I4bEcmP8zW7Pgo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8c:b0:6df:e3d1:dd0f with SMTP id
 fb12-20020a056a002d8c00b006dfe3d1dd0fmr24307pfb.4.1707513005015; Fri, 09 Feb
 2024 13:10:05 -0800 (PST)
Date: Fri, 9 Feb 2024 13:10:03 -0800
In-Reply-To: <0000000000009c91ce060e87575b@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000009c91ce060e87575b@google.com>
Message-ID: <ZcaUq68756CcW74y@google.com>
Subject: Re: [syzbot] [kvm?] KMSAN: uninit-value in em_ret_far
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 09, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2cf4f94d8e86 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=144e8d01e80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4a65fa9f077ead01
> dashboard link: https://syzkaller.appspot.com/bug?extid=579eb95e588b48b4499c
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/589557edbfd5/disk-2cf4f94d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f2480533f00e/vmlinux-2cf4f94d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9463e8eac2ed/bzImage-2cf4f94d.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+579eb95e588b48b4499c@syzkaller.appspotmail.com

#syz fix: KVM: x86: Clean up partially uninitialized integer in emulate_pop()

