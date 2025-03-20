Return-Path: <kvm+bounces-41565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB37A6A81E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B44E07B085D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A98122259C;
	Thu, 20 Mar 2025 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="B+eBeDPL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF52023A6
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480123; cv=none; b=oTiIao9moI6Qp74gg7D1TRv8+JqeUEwTPo3BBb0F71md4r6ZWXiOmH9wRtfKl/IWfEY9gbOnJTGJHqg2foUw36xOE4PKvbi6TpaQP7ZOa8jLG1wvyZ4RGHJQOzE63zKt1isdqinv1gYqqhGBvwbqTgDN2EgOusD5A4qH72NrxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480123; c=relaxed/simple;
	bh=fV1yjLAbR7t1oyJZijuLOHxXpXwF7qb6O3metD+K0Io=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aLSjJLmIOetC+/ggogVvc3C5A2wwliR6mE1BYLE4KSqXMIGW7d5ZAKX4P4q1GU2Chg35CdtTET8gC0BMzy95/Dm87QPKPPZup1kdrxJfO8E5g3MTzQT376450pVajVfPp5p8UrkOqv215dXJK6ReAkbnOtvrCpGn5a3KMaeMpig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=B+eBeDPL; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85e15dc8035so16788739f.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 07:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1742480121; x=1743084921; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pOuUOTjtcVbSe8J5UUkNu5FVmT0qaTxwu9FnCnOOamg=;
        b=B+eBeDPLWJhzlNRR4uRExf1xc9lmqxFzikqlO8fudTyJBJ8kRen6ljbl8luvKRbFVu
         2iS2a1INwBerO3dhWrL7qscpdsPBSPK+nb7eJBSRRWblxfmurD29YsCSd8C1FMiBblBb
         X9PEWuQAj+XmTQLn4m9xnIvJ7wqRG892oWHccs+DCrx2rWxhr0mI01oHzerbN93UWp15
         O8sDC3sAlpRWl+l0Ina+MRaIVYUy4wLpqR4/rvC0pVL4cp9eoL4Jx0iBNHFkT/yPnbvD
         rHp3EBpklYDDgxu3d30OFcW4nrD4+ZbWb8dSmBNqzMWUmCSZKz3GZEySd+IRd9cQW6YW
         cJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742480121; x=1743084921;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pOuUOTjtcVbSe8J5UUkNu5FVmT0qaTxwu9FnCnOOamg=;
        b=GeJzL0ZCu+ZVa3MMQ+XHypUD1QwagpNVnjzkBr9ihWwSwyE7E5WuYBLbvPDV1Z5pkL
         ToSKi1RKcXUpfpEretZ6YSZu3/M13LYiAn+3MY9WcL8i7UdZbpYyWJzlH1w9nygbOriQ
         L7xrNEPQ5qpQ7SdnXZ7l1rAbSsZjVFj5DGYOBmhIRCXFR84nrUCny0DelVokXNOCS9P+
         fBdIyoQWxYyPHA2yGG+dlCJbre72C2Z8S5wyeqWgsgYoFZTr2Do86cc66EztDLWqagmk
         GeRHd8SVPhcJv7HegvYXWpMegBWF/6VUABhQuu/uVsNi7Guy5kBNe6exlbz3t/1EAkL9
         onuA==
X-Forwarded-Encrypted: i=1; AJvYcCU81co58oi5Lwz4YNFzoChAZNrNenlUjyG+QR2D2K+f2JGSP01HfGFidMjkck0GeFaZN9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAoM3/Np0PK+V6K57gKsLhAgZNS7/yfOaihg+JWY0qSa8yrYdd
	fuZqQ2eHWATDc2vzwrkkpvzLxG3lHT8KVQvrsrBIQQocGD34fwhswP2Qv2x4Yf+Rn9E/wzHX52d
	AUJf9CjZoCOmOCyxeQx2cl8Tvw1sj9VyZ54kGSQ==
X-Gm-Gg: ASbGnctxGpIiGOeNB3+srlQZwMFZ2RVpbk1tuxnbg+k+KvuPAM2A3bkDpPfXN9SLddm
	7P6nWIhihKRvftgwyAtEscy/7B5x7PQhZiZu39AK3kstdUOMyAf5LQSZZ8eOA/B55T36h5BUTr6
	Vf+eNWlQs0Ov4wZkR4IL8ZOZ+KV68=
X-Google-Smtp-Source: AGHT+IFK5YVWMg7oHmMx8fPJHlpZWuvdFWhVDFV08fjTW/MyiiCgPNx7YiNRyCTVAurBTzb3xFeOlwvq/fI1K8EDP74=
X-Received: by 2002:a05:6e02:370a:b0:3cf:bac5:d90c with SMTP id
 e9e14a558f8ab-3d586baad39mr81833385ab.18.1742480120521; Thu, 20 Mar 2025
 07:15:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Thu, 20 Mar 2025 19:45:09 +0530
X-Gm-Features: AQ5f1Jrt7GwUjf0k1HKl9UBx8575Wok6_pgNuJLSWasl2rfXma4VEBXKWaRUvPU
Message-ID: <CAAhSdy380StEE03G=RPjKoxtY89nLeufpXbjYwbRypzzrkQN+g@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.15
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We mainly have two fixes and few PMU selftests improvements
for 6.15. There are quite a few in-flight patches dependent on
SBI v3.0 specification which will freeze soon.

Please pull.

Regards,
Anup

The following changes since commit 7eb172143d5508b4da468ed59ee857c6e5e01da6:

  Linux 6.14-rc5 (2025-03-02 11:48:20 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.15-1

for you to fetch changes up to b3f263a98d30fe2e33eefea297598c590ee3560e:

  RISC-V: KVM: Optimize comments in kvm_riscv_vcpu_isa_disable_allowed
(2025-03-20 11:33:56 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.15

- Disable the kernel perf counter during configure
- KVM selftests improvements for PMU
- Fix warning at the time of KVM module removal

----------------------------------------------------------------
Atish Patra (5):
      RISC-V: KVM: Disable the kernel perf counter during configure
      KVM: riscv: selftests: Do not start the counter in the overflow handler
      KVM: riscv: selftests: Change command line option
      KVM: riscv: selftests: Allow number of interrupts to be configurable
      RISC-V: KVM: Teardown riscv specific bits after kvm_exit

Chao Du (1):
      RISC-V: KVM: Optimize comments in kvm_riscv_vcpu_isa_disable_allowed

 arch/riscv/kvm/main.c                            |  4 +-
 arch/riscv/kvm/vcpu_onereg.c                     |  2 +-
 arch/riscv/kvm/vcpu_pmu.c                        |  1 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 81 ++++++++++++++++--------
 4 files changed, 60 insertions(+), 28 deletions(-)

