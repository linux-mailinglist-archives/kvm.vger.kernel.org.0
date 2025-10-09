Return-Path: <kvm+bounces-59736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D89CBCB194
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D3AF04F2AED
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892A8280A56;
	Thu,  9 Oct 2025 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nYQ+c9tR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE2028153C
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049170; cv=none; b=k/7vEaoDdaJ6n5A2Tn5jUrmY6/ikDA7g9ok+dhWZKjGVGaCm2INM5RZm2q4z+RJbHAKLjPe2wygQLUIUS/wBaeaJNMgGuFRHAsrnQTgNuMCAV1QrnXtNGWykp3Uzb6gsiWhuBNcEZb7tnnKb/rGzZ0/OpebqEx2b4k2ckL7t2Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049170; c=relaxed/simple;
	bh=NU8MMIkrzdP2RFlhl7HtsD71stc8eg3Za5EuqmEUEQs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tBpAtxZzr9IBpMzabFHQ8p/A71s5IKpDUyCchSN7gUQxC5mRlBz2NL4OmaTZe37/j+s2jFyROAUTrLgjMjtfzw1SgjxevqlPd8Zt3wxbS+HcUWzAOBVFh7LKrF4cWPvAXr3aaNK5mdYn7kbSwYoi4ZPtMV+/cMoWqv2Ec8r2yF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nYQ+c9tR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so2275844a12.3
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049169; x=1760653969; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t/z9HFIaNaxldshHk70QL4ZXk5pmp482oiljiBf3lBM=;
        b=nYQ+c9tRBy8geoFsAa2QDJj7PjaxWFWPVd6sh9/Vl7dfbovxaMCYHCu0J/NThQtWt6
         SqBjCA78X877p63vMvnSK9L01ou0T2XCTwBwof1gi8W4z2t8YD1kC5/Q8l8CnD3NvXiT
         Hi178dtLTBk9Wzrcxlu5tEE6GNbVU8830czb+dQvSXT45Io9cqQvfn+hPh06UCVfeDR6
         3e/qzPlr+J6bEHtaVndausZxToLC5k1LtgpTRQsYW2r340q8mfVCabOzlobD2KbwL8ku
         38NM/JTwFKkWYQ0rh5LXjMA7QHoj4PhqRk+rQOpkOAuYwNvfnz1Q3Ao5oH/AAy0hSLec
         f5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049169; x=1760653969;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t/z9HFIaNaxldshHk70QL4ZXk5pmp482oiljiBf3lBM=;
        b=WzBHDIV/Y176ppWFM30EbU5YvNl4KoOQGrL7ms0/xXy0TgnwtkC5hJt1Yj2yTPIuW/
         rnBAqn+UcBPAruj9Zbmzujd0pRXANCo1dTh9mNwFxrjf1ahpLPhUeYxpTq9QE3TrfJhM
         4damN9TdRCXc5gsOrC0LrS5HMDbI7St4aQBaet0E9xxeczvrFxDi/9f+nK73oYkizhJ6
         258ZA75ujzGELKIVVBZ2le+fyf/fW97APvEFx9aXSRyvGjcIVRsPMsEHCMmFo1y4six0
         /4WOE9EZVkY3/y0SfcRw++jWp1eejxjGA/nZ1QZsAC5O6dL5KQtqKTnkhHFWtwYRqkkE
         YkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPYg/cbGEelrBN4eoUCLOyoW2qjpGOF5FXwpyyXVv5A7GQB4fdfyqv4STzJLNggzuHGHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMfND9x07lLB0C94neiZHH+DVoZfkiyP96IhmbnQBWv4qwB1Wd
	ZIEdnRWQLpP2oD98VQY+f/uutBVCUK+C0HV5vpsUeukXTV/E6ZhTzf+qPJt5wgTuijocP8o6My2
	02GHY1N/Jcf34EA==
X-Google-Smtp-Source: AGHT+IEwSFeBYteMcJZCnm1QgWZBLXFpxxLGHcnQyhjOAgyKeXkUhr/10aZl9D1dDA1qusaxBOUG/w/uYRV9ZQ==
X-Received: from pjbgq22.prod.google.com ([2002:a17:90b:1056:b0:33b:51fe:1a81])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a8e:b0:32b:dfdb:b27f with SMTP id 98e67ed59e1d1-33b5138e27emr12697894a91.17.1760049168082;
 Thu, 09 Oct 2025 15:32:48 -0700 (PDT)
Date: Thu,  9 Oct 2025 15:31:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251009223153.3344555-1-jmattson@google.com>
Subject: [PATCH v2 0/2] KVM: SVM: GIF and EFER.SVME are independent
From: Jim Mattson <jmattson@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Clearing EFER.SVME is not architected to set GIF, so GIF may be clear
even when EFER.SVME is clear.

This is covered in the discussion at
https://lore.kernel.org/all/5b8787b8-16e9-13dc-7fca-0dc441d673f9@citrix.com/.

v2:
  - Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0

v1: https://lore.kernel.org/kvm/20251007224405.1914008-1-jmattson@google.com/

Jim Mattson (2):
  KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME==0
  KVM: SVM: Don't set GIF when clearing EFER.SVME

 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/svm.c    | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.51.0.740.g6adb054d12-goog


