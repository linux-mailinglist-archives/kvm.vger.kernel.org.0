Return-Path: <kvm+bounces-60680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD5CBF7705
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C4B2C34C8E8
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D666334321F;
	Tue, 21 Oct 2025 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OAFwgZ9C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADA8342CBB
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061264; cv=none; b=TciAWEes2bqLBlNHNYcLC+7Y8zncbAekpJe+b7MDulyTQMqPB1mELyiY8BwbO3KWG+CmXNaF4+5LrqqfnTdxk+QuVxV4g/ShCUkr1po08J52VfUpRK4PKyxJ75UByH8d2kCgs0ZB7Ftb/7uCJToeXNffJSYIDR4OW7buFZ3a2lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061264; c=relaxed/simple;
	bh=yzfgr8r5pMONAvielKsS9LR/pZd5xI0u5V4hch38KIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKtNVa3oez1lMddfO2Ltb+YbQyyxFq0GcicQMFE6emK/EL7KkDuOaJXka4H93Cu8BFss6UYFxIjiU9FscjehSKWPYlcLJHird5CTTt4TKei6VC1BJs65TQhVGGqS4pIz5A9Jiuakia1mV6KTuf1boRb6boaMZK6uI8tnEY+DVMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OAFwgZ9C; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3381f041d7fso18249a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761061262; x=1761666062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aYMOR2erEiUXBTj9UeZLW5gSBgS0b2Pmne/I+g/6pcg=;
        b=OAFwgZ9CS9gKONnBHVTIRPewvoNgj3K875KN6aV+nnvWtTyLHkkWxZPdHISk2NpjIR
         dIzVp9sk1MLpKkedFdZeUp0SyQmUMkS/S0kOiFpnlDHBFv5Mw9X61eu1/NNphJONWGr3
         RQueB03Sv5WX8gPuI00r9fTcHBE9azapqPw5Aamtuf8Y6AR4dVPhbIpOBE96jhVuHJXY
         56EBnMTBm572qzHdY0tUnHOWWGQKPL/blJ5cjjaE7xglFg/juunvi5fcOzp+MWXL2sjl
         xVGaOp9Kvcx72jTJQUh4aKFl5AxyXFhBVOqJOYzwYeesH5z5pcdKXJKnMUgsvKeyCVba
         i6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061262; x=1761666062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYMOR2erEiUXBTj9UeZLW5gSBgS0b2Pmne/I+g/6pcg=;
        b=OLtfbSNjhxsLo/OLMfRSv0GkXcOv59K7nMMGrg8LRa5cmyzIqkTXlV2ARI25jJLv7K
         XO8PmDinXgu1nQQM5i0BSZ4KgObqIHxbG1OyygFctPJkNLFLRE/lxEgOhLq+0eaR0sic
         ydDrkTRIgIveyBFR+tR+UJb36LFsbIj9ZxNYJYD5kPcM2I8bTA1lry6up4ETBBPuFJmR
         OMYyl9Yr3HRWdultx3a/Vo5UPxQxDCZrcNj99q0NE+jKL4Vpqn4Cu8qEK/ZIKzvWgLYY
         lNci1g2/ViGdR1L9T5ns0EnAnW0K9mzGiCBswYNYPiU6voGlQjxhyVU01Ne0Y8PYXoR6
         RMPA==
X-Forwarded-Encrypted: i=1; AJvYcCVieytzuJ9/UPUN/wfixQ1P84djAWLwzXRC+1Ik7vjQxWEqkvSNQq4bZpX9bFqKZ6A3DE8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwMWUob5L4k+JsIAtT7ysBllhN73Bf00D1nkKxeBXDwPceh//e
	Z2k87hKUtgiQjgNuiVvvYg9Zz5QCuQ508BfHf5lUTmBRlh5j3h2VWR8N
X-Gm-Gg: ASbGnctHrq7GyAvuFa8fFzZoSlZBC50Avn6FVsHhXMw4iJ2sNyfb/LoQ5vJy8lSCBCC
	w7B04mXFQu0Z6XMsN7r+BJWnB4gTPfdk5ptBEqhfct0KwqCRr5GFTEHAeaIGrcJAgU51ptVVW/s
	anqhBG+pAoaWb6KpQE58Mx8FTXy3ZQ9eP3P9/h9aHqKsy3UTDA+XNPHKczvUbJ22Rz+LZyXPh4J
	RI1jZrD0mniuJwAmM1Risa8Gr3tzSOgGIPaxta9NGW2lxUYDnV5M9pH1uYe2awsBm2V3V2xRcAc
	Nc7zKGXMVFrwpzb/GfzHM2xZvDAq+jaeNrNiQIGmx2Ky6m5HiPIv83U852SLvSs+cXPn1+LKClH
	WvJaGk+pa/G+wkoJH/TALGfzJEqqm3iC37r4Si9WUEECYZ6j2fjNquWqCh6NJ5vzmlF7yRK5dBJ
	Qi1DPdkQkXwLshpbu2EQ==
X-Google-Smtp-Source: AGHT+IHEr8HED3OjmE1LgTRhk1PAS8obz4w9rYylsSzDH/CIDpOPd8lLds1qMLMc47DP+eJOlpelQA==
X-Received: by 2002:a17:90b:2ec8:b0:330:b9e8:32e3 with SMTP id 98e67ed59e1d1-33e21f08e2dmr206782a91.12.1761061261747;
        Tue, 21 Oct 2025 08:41:01 -0700 (PDT)
Received: from localhost.localdomain ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5de09fa4sm11293742a91.7.2025.10.21.08.40.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 08:41:01 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: fuqiang wang <fuqiang.wng@gmail.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>
Subject: [PATCH 0/2] KVM: x86: fix some kvm period timer BUG
Date: Tue, 21 Oct 2025 23:40:50 +0800
Message-ID: <20251021154052.17132-1-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangfuqiang49 <wangfuqiang49@jd.com>

The following two patches fix some bugs in the x86 KVM periodic timer.

=======
patch 1
=======

The first patch fixes a problem where, if the next period has already
expired, e.g. due to the period being smaller than the delay in processing
the timer, the hv timer will switch to the software timer and never switch
back. 

The reproduction steps and patch verification results at link [1].

=======
patch 2
=======

The second patch fixes an issue where, if the first patch has not been
applied, resuming a virtual machine after it has been suspended for a long
time may trigger a hard lockup. Link [2] also talks about this issue.

Link [2] also talks about this issue, but I don’t think it can actually
reproduce the problem. Because of commit [3], as long as the KVM timer is
running, target_expiration will keep catching up to now (unless every
single delay from timer virtualization is longer than the period, which is
a pretty extreme case). Also, patch 2 is based on the changes in link [2],
but with some differences: In link [2], target_expiration is updated to
"now - period", and I’m not sure why it doesn’t just catch up to now—maybe
I’m missing something? In patch 2, I tentatively set target_expiration to
catch up to now.

The reproduction steps and patch verification results at link [4].

=============================================================
other questions -- Should the two patches be merged into one?
=============================================================

If we end up making target_expiration catch up to now, patch 1 and patch 2
could probably be combined, since we wouldn’t need the delta > 0 check
anymore. But keeping them separate helps clearly show the two different
problems we’re fixing. 

However, the hardlockup issue only occurs when patch 1 is not merged, which
leads to the commit message for the second patch repeatedly mentioning
"...previous patch is merged". I’m not sure if this is appropriate, so I
would like to hear your suggestions.

[1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
[2]: https://lore.kernel.org/kvm/YgahsSubOgFtyorl@fuller.cnet/
[3]: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
[4]: https://github.com/cai-fuqiang/md/tree/master/case/intel_kvm_period_timer

fuqiang wang (2):
  avoid hv timer fallback to sw timer if delay exceeds period
  fix hardlockup when waking VM after long suspend

 arch/x86/kvm/lapic.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

-- 
2.47.0


