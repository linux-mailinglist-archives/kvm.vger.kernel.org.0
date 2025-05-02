Return-Path: <kvm+bounces-45198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10595AA6B09
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C712A1B65E5E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 06:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999BF266B5E;
	Fri,  2 May 2025 06:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="UHFdnLvI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31012BA45
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 06:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168779; cv=none; b=Lxf/4y0Rpq41FhitDzr+xAV30mEr5nVisDEtpuE9izlhN5F6nFRh9oRap2Yc9H8zPVdhs3Asnu0oqDIE2UmSrc/OKt4tdNvavOm+0fhNqC/lnCk+qWhgym2ufzYKtIw1KbjSMWijqnHMLOmVWQot8csM+3+nwi6L412SqqktFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168779; c=relaxed/simple;
	bh=xJaMzCithLabHS9Lc5tNkE89qzWT/WEzl0Ufn6NxizQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XSZj4EkoPZuP3fCUMGna3Xi/LKfbJ86IEmAgwo6Jp2Grjt+ozYE9ur4XZ1g/XmQJoce91GgoqpdlIDTXA2shQQ9idF2GIESb6F2sP5oLAN+Y744KxXQbHoypDuRbfZqHIx4eyN0hup9+CTII31LDUm+9S22oyABVabgnUmPVEis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=UHFdnLvI; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so9401415ab.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 23:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746168777; x=1746773577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jLTAl+FeAYSKQcQF7p9sJodq+vcj25r5QAMFCz6+Z3s=;
        b=UHFdnLvI9ETCly3+3RYhh2E1hnu4zcD1Qgi3ormVd3arcwurgEEkh6GrTA+qzJTm26
         eZRkcF8b57EbpVH8HTPQD9B0lMs3Q739qPWFcQWkSdWRC/JTDqGQ6QVtyAT4OMomm1Ow
         GymDAkXPuDJlDo9vz3uz9N1wLzrjQmm7JIDK8mXXhv2BfcAxABbJiAtZlGMZYhfdcZUu
         pUqNFACf1GdapklwO3FMKn+jitkmc8spzGsmOeWZ18Dt4se1OjKSh0Mzjrt+cgy207fK
         iL2181DNAj0njYFS06+dJyFDXUEJWOZA+sGEy/r+3r+n2EEoEqSnKJXb6WMpjWTnmRXR
         Dm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746168777; x=1746773577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLTAl+FeAYSKQcQF7p9sJodq+vcj25r5QAMFCz6+Z3s=;
        b=SZ+fNh+7YhkRP8hZqEii0dCTobZt65LfaEuplDMI5f9ABg3nnViCOuLcOaBbKmZ6ve
         k5c7KPif7QZdlJubQssW+xnftWnL/9SOUQRm4jODby3uX1BDeI11a3zuBmZHyGvkG9hY
         qIUdDAqWkkK7cOE7RmzKl3BOHwmLcxUWE2WlFKKZLccLSc/3J7voPd1Vb1ltS3NXh/59
         OypKMKJ0iMeM6Ls+G8mpub5qMg8bEpRLQgdDfqWcWRODcddTn8AeHrn3txSp9vOd3iNu
         ICIXUY+az8maNhpEZwtO02uDU4fJDD2xMdp95CuN/gMA1pE3/T2ggcntX0v/MKTzZDJG
         fwTA==
X-Forwarded-Encrypted: i=1; AJvYcCU6f3JCw9S+G+sFihkHz/ywYtbJ9ntEBTImNvUgPH4OydrL5MytloLjcmdKfXKrG84DcWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcvKt1yNAUTAWLJbSTZhuyNv4VSU2d2PEVUGkNwWm5K6kGeu9g
	+CnF81qjryR2a3WpzOnkfuY50OPE2XpocR8oNeQGyDIlv6XdVq66+GQTtIrSh/OcieyAIIr8Ikq
	dZYSwJU4cZlFxZ6IgssfQED4XRwnes+uFsmH0lQ==
X-Gm-Gg: ASbGncuyJQM78gfbNbgyJfzQJRJWC7cs6lRi22PB5WYQp0wRFdKxZX4IBM0YDZnhtTF
	rWcotAN40htz98Ui2kccyCB3sHWQ7xnN0ZR5KvpawW9iFPeufRUE2QMV2fpBFfwvlcagXKgEeq/
	2NAoLSIKH9mHUKnGfDjbatApwk7rDtbO8uqQ==
X-Google-Smtp-Source: AGHT+IE3Tx+D1sTsJd7eLqFty9WstV2/FtUKtjDrFtmODwKSFJySlTQeqvcdWL3dLUeN0h3IDPBFvj6uN+EjXA3kCW4=
X-Received: by 2002:a05:6e02:1fcb:b0:3d8:975:b825 with SMTP id
 e9e14a558f8ab-3d97c141a61mr20039855ab.5.1746168777040; Thu, 01 May 2025
 23:52:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 2 May 2025 12:22:46 +0530
X-Gm-Features: ATxdqUGAB19XvC5KYJ0fhdKln-jTeRa6jT7I7LFhf0qZedVaeYBhPkotn1vsv9M
Message-ID: <CAAhSdy09tkokvdvACCQACLdvppTTQHDOR+O4jtkhVP4PaW_k7w@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.15 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have one fix for the 6.15 kernel which adds missing
reset of smstateen CSRs.

Please pull.

Regards,
Anup

The following changes since commit b4432656b36e5cc1d50a1f2dc15357543add530e=
:

  Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.15-1

for you to fetch changes up to 87ec7d5249bb8ebf40261420da069fa238c21789:

  KVM: RISC-V: reset smstateen CSRs (2025-05-01 18:26:14 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.15, take #1

- Add missing reset of smstateen CSRs

----------------------------------------------------------------
Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      KVM: RISC-V: reset smstateen CSRs

 arch/riscv/kvm/vcpu.c | 2 ++
 1 file changed, 2 insertions(+)

