Return-Path: <kvm+bounces-33379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E75FF9EA746
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 05:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F1512863A0
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9DB1547E0;
	Tue, 10 Dec 2024 04:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="aqIYnhLY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2879FD
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 04:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806106; cv=none; b=OKATlkWb4fY6KqiSFUmZtTLYpkwqjubxiMGQzwj1e1ltR/bZL1TOMSXQXF9yjmsIqKvde/Ueh0cMB4087D2s/YFualQPEwnOT5ytn/24UojIBm4y85XArTIeXFkqr4XUkJUnvhn3dVPMpiEZKjgeQs4y1PB+3uWeSYe43UIL8UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806106; c=relaxed/simple;
	bh=SUCCx8f3+eJRw27xx1eGSeC6r4pGN865gf1+41yf3qw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TIqne+SnnIINhnJp8k3wfJg/xFBGSk+f3UOgRCSFQcAzUFjoeIGC2FFB8r37JMJ4hA8UczJ3xUZHq8bDplAIPYadxCIVXMLjThil9xzsL+CXnTAgqrSiBs5Am2pfD84VmMJGJCdJJHtkTIopyVBXr5dE4GT7KfaLKVQ9lr4/9y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=aqIYnhLY; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-844c0547717so8174339f.3
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 20:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733806104; x=1734410904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M2csR8E5N5DuUzvr0exzv44MtFLG21MkT7CwIoGlZUw=;
        b=aqIYnhLYK2E+Dr3HSBQuNJivRpsxap/0HYbeCYnX5qWOSjayKWUIx4laR1QFl5X6i0
         O6GTSyBht1QYvQZ3r3ONyRqKzbuRobLMsub9AFWXEkQe1aMTWG0wAxZ1LoGg5bhZUvjd
         GJVZZYrTJWCZO6E9xdBA7g6Jx7H0YzNXS8BK0gKf+l6jBgtdXpbs9IOnbQjjt/+t4OWS
         go5xGSGRakdbbzSxZPxt8D55xe5KJs1yTYwlSmVjCaV5SuKIxPns8W35l2tz2YQbvXEn
         J/vJFMvzNoi2TO3GDA0mb8ErIzsUYMekxLQRLVyus0kPN952EkvhMFzFc2LLa1K2uYDJ
         ygKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733806104; x=1734410904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M2csR8E5N5DuUzvr0exzv44MtFLG21MkT7CwIoGlZUw=;
        b=HFRaEt2zUPeLuXEhkzuOkTa3OVotl77TnzdQw5oG2pq0TlZG3vzGJ+JWWdf67fzeH9
         EXnYAu19zyvBt3rMbFaDBAqwoYVLDWR8xXkASLKQVW/4BG8+Vsf8bdm+Tiicm9yxAGhC
         7sy7TAy2HmlHUv7cuUCtkmwykrzDToGuG3uBZxvzCz7MJG//7XxY3cY+sPqUEKZyUdBU
         kg1iTPqb0EcDTYZDlDfOOWNKcG0/TrZ65yavsslnLfz4D0K8LbCyRpvM1FJ5otcToXX7
         SczKiOZsJ6Hh9ryQ48WpW97vPied7suFtHTaoJQ1jTKdlq9sI5p1v/YbEbUcLsaEzY3/
         33rA==
X-Gm-Message-State: AOJu0Yy3bCbDFEwaHr+n7JLmgTtPK507gnL40BSQlEvkKlcu8FXXd1Nf
	QnwTQMnKK7r/ZvgxK+4rRpKZcLCQ02nKq8a9FRKEMR8HcN7WpjMaJtp1AiDmi+ufM6j5w8aRjHF
	vDjScV1DjcvuaZCAjbYBTE/bN0NGIHvtjd8TedF9RH2/+tRFneTLrZ57zuw/gGdnaz4bi0QHPXU
	hblJ4LjJsNlGzEBP6Y9tCnzqFXm7FNxIfAdJKUmfqH
X-Gm-Gg: ASbGncusYUH6Vc7hjq+5cAgI/GJpt+yLsvS0zzNUoBJ63DbpZtJny/2DNQJHc0atgmH
	4hPsf0TsOAiYhLR/Ii8b/kBayr74cLVwUVrMbJ4YDORWPBmSJyhEuLR20CzPEyn6OOFK/9pOzds
	yzATVZ6EVrwICfzSLcZ/YJLzkgCTKXwE0nY2iU4/i8WxC6DkIxhxbJMfW8N8GNf8Vww5XJvXKuM
	2vT9/oM5Nsxt8B1po21sDBCM3S5zUhIhbebzbwHzq/8IlZQEOqitKKbsLiz82aR1D8gOanhY4nY
	FY6GkrPRdpWj8vJZaELdul1skxS8Sns=
X-Google-Smtp-Source: AGHT+IEoOieqgzfkYR/RS7gp2EgAo/a3kicZ/is+W9euUhDycJqqPmacT4RtapLpts4mK4p7+Agomw==
X-Received: by 2002:a05:6e02:13a7:b0:3a7:8720:9ea4 with SMTP id e9e14a558f8ab-3a811d77228mr164187895ab.5.1733806104014;
        Mon, 09 Dec 2024 20:48:24 -0800 (PST)
Received: from sholland-0826.internal.sifive.com ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9c9da809dsm17022405ab.4.2024.12.09.20.48.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Dec 2024 20:48:23 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: kvm@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>
Subject: [kvm-unit-tests PATCH 0/3] riscv: Improved bare metal support
Date: Mon,  9 Dec 2024 22:44:39 -0600
Message-Id: <20241210044442.91736-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here are a few patches which are just enough to run the SBI unit tests
in a bare metal environment, under U-Boot on boards with a UART needing
32-bit MMIO (which is a rather common configuration in my experience).
Though I wonder if we should prefer the SBI debug console extension for
puts() output when available.

Samuel Holland (3):
  riscv: Add Image header to flat binaries
  riscv: Rate limit UART output to avoid FIFO overflows
  riscv: Support UARTs with different I/O widths

 lib/riscv/io.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 riscv/cstart.S | 16 +++++++++++++++-
 2 files changed, 60 insertions(+), 3 deletions(-)

-- 
2.39.3 (Apple Git-146)


