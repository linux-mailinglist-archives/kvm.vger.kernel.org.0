Return-Path: <kvm+bounces-37582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF9EA2C2F2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 108191678E4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 12:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7221E04AD;
	Fri,  7 Feb 2025 12:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Egozy/a8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4077E1E0086
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738932308; cv=none; b=XO+MNOx7FV+/kCJoWWh/qOD4nBiuUHO3F9bgiZXqRbDXmbUILXMLX5BJqSOpesXcLX6ycITHUQUBI5y9RNawiO51wHI2PEha3yCrrzR9MdDRV6XJfHxARQ6xHn/VHdercGQqVAB4tpHpYZ0NXv75UCsRH8oCxGfaMpGVHUq3l7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738932308; c=relaxed/simple;
	bh=ZFJV9eavS/P6UlPzUSunHgcFVItPnIAheGv4oZvJHpo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Vx53pgmywo+voWkWGYZLVdpXykt2hohhajbLFHCuD2x1H9IlkqS5bqgtlTYqqsyT1r52YDWwjGtNxmXrFa1kbtJOubXLZ+3U8yivmZKQ0rFRI1XUbv84N+9/uibmqbkzSIlC+Nqp3nNG4HEKaNwHclJaH3GVlbpwURBNZqZ/6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Egozy/a8; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ab795eba9a3so1971066b.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 04:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1738932304; x=1739537104; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/Fb3dBDoammeO+okTlZdAfFeuzuqVZK75C5fxLyCVwg=;
        b=Egozy/a8GJhBvSIFbXRtpRgRhCjsGs1FFlY/mjRb8eoP3cbcqZlG4a8ak2PM3z3WtS
         hQpbYPRbT/F82k56xwfxZR5ZnP7ARrOm3gXhaUWv6VFZOR9XlgwCKZXjdLpNfhnOh0gO
         CFeVbKZN3s80ZuCoI0yED1JuYd2N7O6nkp5IY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738932304; x=1739537104;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Fb3dBDoammeO+okTlZdAfFeuzuqVZK75C5fxLyCVwg=;
        b=rMgfx94X8rxBLY8sSSbEMoaKbvFL7xwta5qqlfOj/Q2sTQPkPaAmH8Ec4eNvg20VgN
         aQc03O3v5IvPKV3n5B9uyD2vs5ObG/qMx2QwDmtd/c0JEQkRwXyQGw3RYS4H+3pi0bL0
         Y3TyYAact1V3wSblfA8V1w8wU/AT9M9EdgYLm+RTSzGTZjIi7AjgmRs8K/IJyQyYS/I6
         SXFt/L2W5AlhDWjMiKAaod+1UhUIf/HVjMNQDVql/W40ku7YeixFS9MK1SJ0nf13vCiE
         rrrDWZ03ZzfJcEKZBYykxgQn1buYLJEeP46lzYThwTZziz3hxjXvMvSqHyZ4d6JmI7b5
         SpAg==
X-Gm-Message-State: AOJu0YzTnt1yVc1ZQ5kSntDdvt1eKoYhgnT1eIbueV7d3Cgk3SkxPMKx
	JGNZcMKFONZ+Bioq0q7CXbROFiAyQIjsbM9zVXdl1Y6vLvWmLuHgXE+9Hku5TMVN0Nh9QVYJlJV
	8DJyJRw+NmjHA1K3ggRC9JyjFdQDl915kOWLSJ2P4rQp5v+m2DrdFpiEw1TaGLjYKHQSgcV8HBd
	HV7CHntBWy5KWOTSoxrZ6/H2f3cpY=
X-Gm-Gg: ASbGnctBeJs64p1WzOmtuwBw30omnLRRlA0c6Pc/NFQdSVKn+wB0+UpVWwbxeSi5NlZ
	88XBjC9g3my18jpUVXQhCUIDKAzqysuB24pSO9O3+eN6CacoCkLOhroySQyPxf1hDCGULAjls
X-Google-Smtp-Source: AGHT+IHmDZIHFQq9Ptp6pkVjFj3Yis7/SN7u4OMDKszedzknHHNQPApjzK5xOiF+DrXmgZH1Ycxijudncj1/VnxZxWE=
X-Received: by 2002:a17:907:d0c:b0:ab7:b84:544d with SMTP id
 a640c23a62f3a-ab789ada45fmr292172566b.22.1738932303930; Fri, 07 Feb 2025
 04:45:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Doug Covelli <doug.covelli@broadcom.com>
Date: Fri, 7 Feb 2025 07:44:53 -0500
X-Gm-Features: AWEUYZnLwzOUwTNocnIkfHHJ0wMNCGl6hJcUGVq1biPYIbdEVjsiEFi4XDVszQw
Message-ID: <CADH9ctBs1YPmE4aCfGPNBwA10cA8RuAk2gO7542DjMZgs4uzJQ@mail.gmail.com>
Subject: Problem with vmrun in an interrupt shadow
To: kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

To test support for nested virtualization I was running a VM (L2) on a
debug build of ESX (L1) on VMware Workstation/KVM (L0).  This
consistently resulted in an ASSERT in L1 firing as the interrupt
shadow bit in the VMCB was set on an #NPF exit that occurred when
vectoring through the IDT to deliver an interrupt to L2.

Some details from our exit recorder are below.  Basically what
happened is that L1 resumed L2 after handling an I/O exit and
attempted to inject an internal interrupt with vector 0x68.  This
resulted in a #NPF exit when vectoring through the IDT to deliver the
interrupt to the guest with the interrupt shadow bit set which our
code is not expecting.  There is no reason for the interrupt shadow
bit to be set and neither L1 or L0 were setting it.

This turns out to be due to a quirk where on AMD 'vmrun' after an
'sti' will cause the interrupt shadow bit to leak into the guest state
in the VMCB. Jim Mattson discovered this back when he was with VMware
and checked in a fix to make sure that our 'vmrun' is not immediately
after an 'sti':

        sti             /* Enable interrupts during guest execution */
        mov             svmPhysCurrentVMCB(%rip), %rax
        vmrun           /* Must not immediately follow STI. See PR 150935 */

PR 150935 describes exactly the same problem I am seeing with KVM.
For KVM the 'vmrun' is immediately after a 'sti' though:

        /* Enter guest mode */
        sti

1:      vmrun %rax

I confirmed that moving the 'sti' after the mov instruction in the
VMware code causes the same exact ASSERT to fire.  I discussed this
with Jim and Sean and they suggested sending an e-mail to this list.
Jim also mentioned that this was introduced by [1] a few years back.
It would be hard to argue that this isn't an AMD bug but it seems best
to workaround it in SW.  It would be great if someone could fix this
but if folks are too busy I can ask Zach to include it in the patches
he is working on.

Thanks.
Doug

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/x86/kvm/svm/vmenter.S?id=fb0c4a4fee5a35b4e531b57e42231868d1fedb18

(gdb) p svmDbgExitRecs[5]->rip
$9 = 0x5b5f723
(gdb) p svmDbgExitRecs[5]->intrState
$10 = 0x0
(gdb) p svmDbgExitRecs[5]->exitCode
$11 = 0x7b
(gdb) p svmDbgExitRecs[5]->exitIntInfo
$12 = 0x0

(gdb) p svmDbgResumeRecs[5]->rip
$13 = 0x5b5f724
(gdb) p svmDbgResumeRecs[5]->intrState
$14 = 0x0
(gdb) p svmDbgResumeRecs[5]->exitCode
$15 = 0x7b
(gdb) p svmDbgResumeRecs[5]->exitIntInfo
$16 = 0x0
(gdb) p svmDbgResumeRecs[5]->eventInj
$22 = 0x80000068

(gdb) p svmDbgExitRecs[6]->rip
$17 = 0x5b5f724
(gdb) p svmDbgExitRecs[6]->intrState
$18 = 0x1  <<< should be 0
(gdb) p svmDbgExitRecs[6]->exitCode
$19 = 0x400
(gdb) p svmDbgExitRecs[6]->exitIntInfo
$20 = 0x80000068

   0x5b5f71f:   mov    %edx,%eax
   0x5b5f721:   mov    %ecx,%edx
   0x5b5f723:   out    %al,(%dx)
=> 0x5b5f724:   retq

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

