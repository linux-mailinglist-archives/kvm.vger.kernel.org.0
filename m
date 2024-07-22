Return-Path: <kvm+bounces-22069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 489259396E0
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC87DB21957
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710825FDA5;
	Mon, 22 Jul 2024 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v6RmGCAW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394664AEE7
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721690466; cv=none; b=fEgLD3UYiLFlDZ1InhA+nm3TR5ZncyL8WityWT7ZWFvK+eC1yeSDe6QBlRIWyfYZ4wh2gImfbbTxpCiklEaFYKncWzqPgk5SiDbBu92YgconuIYyngQ7NKXZPVcQm5maGnTBWkH8FSbnI9nPCoAmyYCNjOiCldnJXh1jKEGso2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721690466; c=relaxed/simple;
	bh=yqe1JrnMrO5mqfNrVADVKFe83l6H8QKZVp+3gYO0bRs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tL9CDuAOhg/9GmsTfExo170cPNbzo5XYqpagz7lx6Y+8iyrqH14yfQ+68iB1g141T+czxVKFAAquu85ZBQS9Uxq8FmM30ek3WilM5zBX045f9ph/faoUdsLeck9GLJl4mB0RexF0Nbg81kJFaINhYpFgfoMChXjUobSeusj5omA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v6RmGCAW; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e08904584edso3472593276.3
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 16:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721690464; x=1722295264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hsx+ucI/xQ+z2qWD6nDUc9Qat/vsR74GS5uVQf6Ei5Q=;
        b=v6RmGCAWxSwmxewWuGfhvPsZDpqJDOHR+M7z42KHJ31uMbFzbLrC+NkSHZFuKVNKoH
         Qf77SBSshpOBAkRpR5vACSN10Ai5nVTnuw9bVZ1grWoN1ArQk40/YwndrRyZDTw9S9bX
         7vUZODrOheQyNeW8bNCg2KMuksihyI8482Gkc404xl1QzUDhjLR2tiPlfBe0Ptv8efyD
         gNbnI7a7ORciupA8cb+5PnIAEn/ncACG39yIK+hFvPlDwN5exPeEtVfTqe4D4VluKbpQ
         dM+9nUD24w2SpcilCmXsNaNmTQP67bTsCt8NmHq502Qs4GFYElhQ7kc0MFvF7nnu8mfW
         4RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721690464; x=1722295264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hsx+ucI/xQ+z2qWD6nDUc9Qat/vsR74GS5uVQf6Ei5Q=;
        b=QKNtUwILMsBGKTY3SiKBV3w92gofnRfhAd/3/Gt0E2B6V/M595a+mSRI57PlumNVH2
         qE6ZXBDRrVHs2e7bVSnkJNO8RDz+UuUPMUADJH6WbO6RD4YjINPJg6GvLFyjQuLNiXOJ
         dnOvduDE+/dtGxUHscd52mDXT7TR96F6z0y8OlXbwz6C1Xb7JiGTw4Sib1pzYV7vi869
         ShzAjmDY4Y1B28GqPnCW15nNJoSp09g1gXi+gAhZGTqyCaiXyTXy8li5ba19TOmm01tE
         ZzZwr7SVPq0NEpvAD/9v8ilGwWNVnjYO2v8d8U7rEs335CX+lW94nxTIkpl0OzVILlUw
         aGnA==
X-Gm-Message-State: AOJu0YyNtZotv9rS/uHJOxqCIfnbrCR6twXn6ejSfhNO5oPwO/woVhjI
	MEplG5vh7+AlvkeCGOiZaKutDdK+TpN9SobgDP7Iwgm0Bgur3brUdJ6ptA7BdX2hNTye+xe+xFD
	TPg==
X-Google-Smtp-Source: AGHT+IEFgZbSL5O3JSumRL9uNKAO7nNzfUWzmLNZVZqJB3Yl806Rq1CbWZwkY2MDtTgNyi9bl2sJxDOD3io=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f88:b0:de5:3003:4b64 with SMTP id
 3f1490d57ef6-e08b57ba7dcmr1854276.1.1721690463919; Mon, 22 Jul 2024 16:21:03
 -0700 (PDT)
Date: Mon, 22 Jul 2024 16:21:02 -0700
In-Reply-To: <bug-219085-28872-KtqhT84gS6@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219085-28872@https.bugzilla.kernel.org/> <bug-219085-28872-KtqhT84gS6@https.bugzilla.kernel.org/>
Message-ID: <Zp7pXnf2baQWJHcN@google.com>
Subject: Re: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 22, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219085
> 
> --- Comment #1 from ununpta@mailto.plus ---
> Command I used on L0 AMD Ryzen:
> qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu

This is likely an issue in the L0 hypervisor, which in this case is Hyper-V.  KVM
(L1) hits a #GP when trying to enable EFER.SVME, which leads to the #UD on VMSAVE
(SVM isn't enabled).

  [  355.714362] unchecked MSR access error: WRMSR to 0xc0000080 (tried to write 0x0000000000001d01) at rIP: 0xffffffff9228a274 (native_write_msr+0x4/0x20)

Do you you see the same behavior on other kernel (L1) version?  Have you changed
any other components (especially in L0)?

> Opteron_G5,check,+svm -hda c:\debian.qcow2
> 
> It's reproducible in 100% cases
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

