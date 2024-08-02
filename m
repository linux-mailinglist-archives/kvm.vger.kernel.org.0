Return-Path: <kvm+bounces-23028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41827945D56
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D86931F21F20
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802641E2871;
	Fri,  2 Aug 2024 11:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="jdd4lVdN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98D1DE85F
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 11:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722598941; cv=none; b=B1kL/ucQuPLQMdjf1caX3eJeEekr5tzJ3LUR9ir2nnB5A7d2jx97KOeM074cnrbP43kNNCBCGvrKbK4IFusmccFiNhkcTsV5wEqkqUdfg6GBHvQf1iaLh8+7aVBb3e/X+1LOqEzaHOSPZURSaQ0hnp9SRatOIGkda04IwXq3W4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722598941; c=relaxed/simple;
	bh=F7VIKJtdHPtgNiKmHGwFwVvxOsv6BUcf2GMKiWTZ4q0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mXBlTYItqA+gJSHukYyyc55tbmbARn2UF77WmPZZIsg1xg+XYPRyD33ZvXv0bwdEITVMn1rjkN+yr7PCLWCy+i2irMbVjltcRCpxAcTr6rvWc50vvRukrGRqHT6gYx3ON+RajlAHiaJd3tPiplHH4tdQgjWa8P1jSDQ+YJstOpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=jdd4lVdN; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-39949ebafc2so30622265ab.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 04:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722598939; x=1723203739; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a5H3AeCfNpJSz2g2+5Oi/AktIYfYVa7hff+1WjAceu4=;
        b=jdd4lVdNBdor6OMTzi8Mx2Z6n/qgtbrKL7CdHoUano715+LJ5Ayd1dAyJEkaQhiRh3
         Mdzkt8RJfXUINm6yPkiPaUo8IhxjtmJrMfNtCCgYIoOgPrAFnJvLZl60Ntpw9GeKfN9/
         KIuZEwqpQycVVY1DkN83N8Y5Bpf+ycQixaPZU/agj0cD9zQRU3LgnAgZ+3FcUbOszSz/
         AGSQERQ0Nk/vlHYGYtYkOMgvG1BdLVIIsMz+/atYbauCSfwT6HFZUfj2TQIM1ZNPIdrJ
         oNNhiW64n3jaQfAxQt9HRJUEtVXNndl0bS9hIrSBuU/PSsgbu45ptudiITAUyWsn2utE
         d4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722598939; x=1723203739;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5H3AeCfNpJSz2g2+5Oi/AktIYfYVa7hff+1WjAceu4=;
        b=wacxtYma4RM9yxi43IVCcLYMQnPpWTKMj7Eht1tpbz78duXjrTtK3QLr9/5IATrinh
         blKBnMRpIgcyORZiRAf3qjJdX9+HlprANBJSqfuv6K/agH754vTafGJOjDrWmdtm1pZX
         EEy9lCIxolSykeESXfaTGRr1SGt2vACH/D5dMSJYq0gvBtJ5lpg3/VLuBI4f2+KGg1rv
         ob3u7n975cI/HG5ghQ6JvTNsDyN5oHSjtANYZUVUyKsTmeTAHw2Yfi68oX2igZ1kipBO
         6ZYCi5/1b/JJdV5cOcwTTX5eVvOqqfbS1gL+mlmjJrWS60/q9xXlt9Jn7sj0U3/ttMsN
         8UAA==
X-Forwarded-Encrypted: i=1; AJvYcCU+B2dOllMW72dGjvHDICvnPFldXMFb68iGZfyfkZT8D/WroHwGvWlpu1janG2B6M0EkyTYqok+OIGtam6Qw06IzTGk
X-Gm-Message-State: AOJu0YzOd5uBrpRm6CdtsGe8zywKT95NDmrJ51eMvr6Oz1DaEn0rA/Sx
	Vp7TEUjYrVgQcD0GY4jGMIc1sqy58Yh55lDljR0JyEWkfbQlhZJZvPzGhVB/WuTvvzO5epr1I8v
	CVu6pAPztDAGDedU1v+P6TYE9KWSECTOYU5KqFg==
X-Google-Smtp-Source: AGHT+IF+ejI/SVKE/t4Uk/W5P56djcwV8NhCicI1Lcde8YBa3WL3gElptRwgVZ5UcXVXfBkSVFxk28Ev5Le4Snmg7pI=
X-Received: by 2002:a92:d7cd:0:b0:381:2571:ca7d with SMTP id
 e9e14a558f8ab-39b1f79e0famr38010815ab.0.1722598939359; Fri, 02 Aug 2024
 04:42:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 2 Aug 2024 17:12:07 +0530
Message-ID: <CAAhSdy3ZhXmbDFrWneA9aA8ALYy+SgMpyopd_9MPzYgWksMLBQ@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.11 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have one compilation fix for get-reg-list selftests
in the 6.11 kernel.

Please pull.

Regards,
Anup

The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.11-1

for you to fetch changes up to dd4a799bcc13992dd8be9708e5c585f55226b567:

  KVM: riscv: selftests: Fix compile error (2024-07-29 10:10:56 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.11, take #1

- Fix compile error in get-reg-list selftests

----------------------------------------------------------------
Yong-Xuan Wang (1):
      KVM: riscv: selftests: Fix compile error

 tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

