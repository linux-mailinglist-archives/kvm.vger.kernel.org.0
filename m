Return-Path: <kvm+bounces-41795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA488A6D8AB
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 11:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA986165FCC
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 10:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BDF25DD07;
	Mon, 24 Mar 2025 10:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u2gRqq4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F51A5B87
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742813626; cv=none; b=JdFJCiubx5gzLsAtqaoXQ/LWWLdZMxOyjDwALpjvWzoNdLMiOjaK4Zf7s+Tfzbbae0UL6VNs2qqqKvsZsMNHHeh4+ZaLmxwAlq/zAkvTI/09JrO985OktbQrLe7cqWMgkgX96Zn6dTqiOUWqz1xxQpTavjV0r+dcpciq++Q0I9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742813626; c=relaxed/simple;
	bh=KjVsYB/6NbKNMWPMw7dJEN7gZajXIZf6BXVWnnRlI4I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GpikAH40jzCoTzotnyw8x/g8sa6jeWF/0pTNjyYo5IOMQD2Y+6orerWUzRwYtUo69iGSeS6qcysCtGvwPlW4Pwa1uIkYRMielo30G6O7ZSbM0+G8AzX8BG2eAB8IQYsDi9G0XFy1wqsLvJmXSYNj0WLifPFyBaEONxWyYxnY59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u2gRqq4x; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-399676b7c41so2158321f8f.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 03:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742813623; x=1743418423; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRBBC5Y50DbrnY2KR5VRMIecYWoom7fg1aMey6lzMKw=;
        b=u2gRqq4xM612zQdS3dWg6nQFyzVa10fpHoXTlO+kz3hITmqKAZlltof+qevYCZ1yxc
         DV7eFO3UBTRQPVJoJX5GctNElfwrB/8r1X1KTQZLK0gOkm7bckrrVzotx6dINS/XVwnZ
         SL38Bav8DEUU+4sfETBxHyFD6RnFeQU2NgogmtM45SvtDHtpVPlCUZ3BO21xaKS5v/ge
         AFimaf+puDTnpaAH7gamOUoRo8sU2bZoPZ979FRnhrJyxskeaPQTBEka7QWQmPkPXwrX
         socKWRgglXcGkyrVx74vBkV8gYLs1JDuyAyOXWrr1s6sl7m8TkdLdqOw7YQYQNGDIgfr
         n48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742813623; x=1743418423;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRBBC5Y50DbrnY2KR5VRMIecYWoom7fg1aMey6lzMKw=;
        b=M8v//oW5puxaQAw8t/L7/mzLgimFlbCVWY9KIHspskwDlP9Xzlko0nYHhflOENVFjj
         K3N0NjGPVd2Vv/+es2kxc+WQ2l+OL2wZW6GaZzYQirwFmXEHbpt6jCUyLgcCwslttbQI
         s010iAFgAiVirHGYVqy6qOtZdXJIrpggctyzfmG0JSAg/x9aAoq9GiY//W01IxCf+haI
         HW7QndisWZKhCueJI4m6szju45tUViGnZG1fOEX9ncZSTtFsBIdp8zM3HTsfgECjsdX8
         UYzCsA16vQLSalcQIdhfYhWWI/sOJpWQ0dqHRnRgK+Y6HHhRs7RNjawqr/r8ILkxv9Zu
         Du2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtR/1ifN9WCCg04cI5+e21AQPpbs7TW3eGLW4sgkEf1mKyqK3T0Ns9tdejHfbpwAf1ibY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgvcmGO28KnpwLdlNCgWJy1TFdqs3wmGn3JIa9EhFFHWRnuqB0
	zZawAq2dXeKZwWVab/9i/KbDHF1iFWxGN7+VNnUgLzCoATVvQVJ+4UANbni7Xc8=
X-Gm-Gg: ASbGncufhDLqt2xBDW5dzB0U0qJKZI2bOdpfMCpYU1crkjQbboPHLq6TWRP8dD5Altq
	wwnJELwVyE3NOhF+Vh4ZhN/oRH3mku7ztwkMvvaPLhZyfw9gAXhWgx/eeffXVKl+y65ZAeN/DIR
	2PlUH9dTKCWwp5zoBScUtBao5DizhNRf0tOW56GyHVz/sTdC2IWM1pe06k/EoLAGkKZqGU8HuNH
	KOkbRVdPSsjFyK02UyE6tfpoPopTc7w7bvqC85Q2mHcQ7YjVDOIi64KGZ/Qw1Rkxm9kVCnhEXaQ
	RTyCyHRAtbcTGwFFqsCxW6hSZrCkPpd3OIIMNs3iIWsrtMkEwQ==
X-Google-Smtp-Source: AGHT+IG6+X0RvQWAACJrJUGE18q5oXGZ8dddeugBl2ClpDLyua8TAmKdOcrERT6mZXU5Gy8dfa/gpw==
X-Received: by 2002:a5d:588b:0:b0:38d:de45:bf98 with SMTP id ffacd0b85a97d-3997f8ef175mr10199407f8f.8.1742813622782;
        Mon, 24 Mar 2025 03:53:42 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3997f9b260fsm10435247f8f.43.2025.03.24.03.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 03:53:42 -0700 (PDT)
Date: Mon, 24 Mar 2025 13:53:39 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: x86: clean up a return
Message-ID: <7604cbbf-15e6-45a8-afec-cf5be46c2924@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Returning a literal X86EMUL_CONTINUE is slightly clearer than returning
rc.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c734ec0d809b..3e963aeb839e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7998,7 +7998,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
 		return rc;
 
 	if (!vcpu->mmio_nr_fragments)
-		return rc;
+		return X86EMUL_CONTINUE;
 
 	gpa = vcpu->mmio_fragments[0].gpa;
 
-- 
2.47.2


