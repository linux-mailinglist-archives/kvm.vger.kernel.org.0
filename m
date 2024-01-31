Return-Path: <kvm+bounces-7612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00614844CB2
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3290A1C203F6
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4711F4654B;
	Wed, 31 Jan 2024 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i67o2CFj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F923B78D
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706742550; cv=none; b=UvF12fmTEapwrQqFO5MDgiPYysqr/EhcZQjO5QXgxiqr9gkJeL2TSh0xshY9pNnzi02kqmfWQPcwox8fSyftFtjV/KD5GhA5noySJ2E7dJ9gT0z0aSQHdI7bSBjuBiw7wyzzzMyf+BpCHXNjH0kDMAZk2LWgmXgFWdoiLM6PFgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706742550; c=relaxed/simple;
	bh=U3zze03rYR9J4ydeGjvVX+Qf6+csvmvvvlokpUg28Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ibk2ysFMuQ0J2j8vTwJgoPuz/dt0bv0Qkd1c2a8CvFOkJQ168YkmJQeHqG3WY21h9i2hTa389yIVYXCn3BFHk3IsV6RNq4yyToxOWnfmV9ew6ugEElaK79QyO2pViUCYGUf1Sj0euFXlzP9m8A0moipJOzSHzI9qaeIBJEcXM0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i67o2CFj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706742547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wn5H9c6FKbtv2kaoojksI6x/4GykFYB4EqXdTdRH6Pk=;
	b=i67o2CFjVfUf/xfsi2gEhw8i0gpoXKjnl7zclnJxDkAxpJBg1x31iqKfKe3s4T8vur2KDE
	hccvJbu0trik/cwrAypZUlOuIsOhnZi3Oo38ZgHjzBt+T3DNMZXccrIonqM36uZlToQYCW
	VRq9irHalpeP7L6SyEIZKV7qjJCiYyA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-3X6tnb3vM4uer-KAVdcATQ-1; Wed, 31 Jan 2024 18:09:05 -0500
X-MC-Unique: 3X6tnb3vM4uer-KAVdcATQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33aec659d0aso632312f8f.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706742545; x=1707347345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wn5H9c6FKbtv2kaoojksI6x/4GykFYB4EqXdTdRH6Pk=;
        b=Mt7jyy4VsrWjQhJWES3RQiWyW4XC8JlFx5GKqyzReRTa1W9uEbemE2Jdkvweh9KI1F
         3zNDBtr9Fs+/4gLXPFVQA1B3vRnfE9Knhrxj8m0yDP+bCi1INB7ARr7lAvumbQpOjtqt
         Ggd9GM226t4AMjG4RixKWGZfXxNibnhTcx6p2s4UKgI4FEczepKF4ojwwSBhVHrO7R+I
         qFUHCg8t7DPYzokr9JbLUFaxz8PEYprNgrNWR3lyoiej7m3cFDzAKMYaT/802ComxRBm
         /73HZH0ciXhgjzRfWQZY0rAdPkH5oHVUTSq0DJ9hBuwBZ8S06rg/tlPUK6EHQGt2OKPh
         TN0w==
X-Gm-Message-State: AOJu0YxMQhiJEac2ZTLXCmU0IU2DMjecgtvF8wTlaU7o1laxngjE3vc4
	lo0gcg55VimP9pv4koRAzX0ezp2rNjO+qIRpJbnrZzH0+3YjKEEgx7fGhBBCGOam/4+9dGZx7cA
	WrD/ptPVfJC+gwqcLrOYB0sl29XQCQlAy+r4ixOJDpFR42KMzZw==
X-Received: by 2002:adf:f851:0:b0:33b:146e:241f with SMTP id d17-20020adff851000000b0033b146e241fmr36412wrq.4.1706742544794;
        Wed, 31 Jan 2024 15:09:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKFqJlbUDXcFwA216i9Cm/Cmaahpr4+i21Re3cmDbw1k8bOGY9R17PpiVJWG0x+U+fgdI6KA==
X-Received: by 2002:adf:f851:0:b0:33b:146e:241f with SMTP id d17-20020adff851000000b0033b146e241fmr36399wrq.4.1706742544417;
        Wed, 31 Jan 2024 15:09:04 -0800 (PST)
Received: from [10.10.0.32] ([213.214.41.32])
        by smtp.gmail.com with ESMTPSA id l10-20020a056000022a00b0033af350fb88sm7797114wrz.25.2024.01.31.15.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 15:09:03 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Zixi Chen <zixchen@redhat.com>,
	Adam Dunlap <acdunlap@google.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
Date: Thu,  1 Feb 2024 00:09:00 +0100
Message-ID: <20240131230902.1867092-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Supersedes: <20240130180400.1698136-1-pbonzini@redhat.com>

MKTME repurposes the high bit of physical address to key id for encryption
key and, even though MAXPHYADDR in CPUID[0x80000008] remains the same,
the valid bits in the MTRR mask register are based on the reduced number
of physical address bits.  This breaks boot on machines that have TME enabled
and do something to cleanup MTRRs, unless "disable_mtrr_cleanup" is
passed on the command line.  The fix is to move the check to early CPU
initialization, which runs before Linux sets up MTRRs.

However, as noticed by Kirill, the patch I sent as v1 actually works only
until Linux 6.6.  In Linux 6.7, commit fbf6449f84bf ("x86/sev-es: Set
x86_virt_bits to the correct value straight away, instead of a two-phase
approach") reorganized the initialization of c->x86_phys_bits in a way
that broke the patch.  But even in 6.7 AMD processors, which did try to
reduce it in this_cpu->c_early_init(c), had their x86_phys_bits value
overwritten by get_cpu_address_sizes(), so that early_identify_cpu()
left the wrong value in x86_phys_bits.  This probably went unnoticed
because on AMD processors you need not apply the reduced MAXPHYADDR to
MTRR masks.

Therefore, this v2 prepends the fix for this issue in commit fbf6449f84bf.
Apologies for the oversight.

Tested on an AMD Epyc machine (where I resorted to dumping mtrr_state) and
on the problematic Intel Emerald Rapids machine.

Thanks,

Paolo

Paolo Bonzini (2):
  x86/cpu: allow reducing x86_phys_bits during early_identify_cpu()
  x86/cpu/intel: Detect TME keyid bits before setting MTRR mask
    registers

 arch/x86/kernel/cpu/common.c |   4 +-
 arch/x86/kernel/cpu/intel.c  | 178 ++++++++++++++++++-----------------
 2 files changed, 93 insertions(+), 89 deletions(-)

-- 
2.43.0


