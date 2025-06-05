Return-Path: <kvm+bounces-48522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFCCACF278
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6F716AB63
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57ABB19F480;
	Thu,  5 Jun 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gvXIbrgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10118C031
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135776; cv=none; b=NRPJhK3jZ6a1JF++CLRVe3wjk1GFMlX1X0BLXi1HbcJ9uYP0geO2y2pMHMLryieQTpKLmrOODOOOmEq2XQoSeDjezLsvv0wRAiQsNTExpmgwSoGKHtDoP1w2sjAaQ2bjXrdmt9fOiehMIZyUKKHgVDLgQ1rxPPcMM9CwsSinsLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135776; c=relaxed/simple;
	bh=/9oGjbRjnfueRQJIZGhA2Un3eglBFE6JP5x5vleF0JM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jKj7NARPc/E0L7JbrubWxGVQ3p/vmVmVmUZN7nT5Hqse2O0CpUTRN6FNko0CmjftNM4zjIAogQ3jluGT+SP9Mk97iJ0cvCMi+3DipoyXjvOWocGd2R/WhUTrAa7FdpWvWHAVt7JqWQUc8FQhSQP4FSTrYGNee2rPPckAAFVcfWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gvXIbrgr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c36d3f884so722550a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749135774; x=1749740574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7VKfd8Mda9jsQ2KQuKEzreTAair58/eAqehxmumcIZc=;
        b=gvXIbrgroQwKDO+dorJqSO6uGKtmlciHPzATAbOrRU7SjgXs4hkwiRGSy4X1xpEv0U
         f61Ub7rVj/qrdQgO0lrIInbSTTWxxCHFLhwZzOJdlC05hRn9aapNI4FT/4SSs0cCA2HP
         v+q+Mh6dpIGCRqvq0LNONPhPX61LMSiaUIfTziLV/WPrSE3r+8WvGLU5mm9VBxvQinPn
         DCiPn4/l3OcgwMXQAmIJI98+t2fKfIKCNwmjexlg8ENRrc6Zi0mnk8rcqMlEaQ5vz3vv
         NmFrYOTSApm89zKyvKo67XlcEucUSS4CfaXeLFaeqBxW+NeC9O04cL6VFNthwKGmfiAo
         EIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749135774; x=1749740574;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7VKfd8Mda9jsQ2KQuKEzreTAair58/eAqehxmumcIZc=;
        b=punGHj23JR1QErsuoRKdhR2d2Pld6RV1JUWN6d7IL7P8EA9D3Aq/3RukQujMD+hr9w
         dwVRTkbmebYMedxUzyhf1pFXsoiEtLfa26gmz7B4IC1xql32xBlLs51tTVnZ1aSg3ODL
         qLpK+e/dHTep3tT4sf7lDb1CoaKCPITqjcbwHeOxtXrkvbvDRUhF7XoqTLHoMPLTjnR7
         a4BDoQDU3IGe4SC5TtljeRMjVjYsywtFFxPH7/8AI6RCgEJq3X1EFAeX9Gcvq/9gvI88
         IA9sZ/AVEALQkqLnxyeVtYp4Mnfnqc91W8Z0TyPP0RJdT/DcAjKobgRmd4O6OIn41PQ2
         9LwQ==
X-Gm-Message-State: AOJu0YzUNiuRER+xCOl43FCnAV2wOxyjXM5GAq2RP+Yojmfoa2OUTo0s
	5tzUKOYsRmyQ3/10WktaUKOnD6lLgIvPcLfUToJxNec8KzI9+zLo6GNSDVE+ejAvVT/c1G66JQz
	tyj+MTQ55e1lpw9oOEYnnrn6B4Ia/hopCaJlUl3/QR1WNmQxWf5dy96n/6T99ovOuTPLj2ClgaD
	EEqLybzS6XamqfxfTGd4bmaDjF71ia/I5U4FJ8FJYxOuReI1UuccJApuHjZkA=
X-Google-Smtp-Source: AGHT+IFnu6A91F8hyb9IYuCWMuLpnU44IExyUHuWukUU1F2elsZVdXzAgW0uaSCuWvSNDeFg1ZN4aJuYGs9ROhHb/Q==
X-Received: from pgbdh4.prod.google.com ([2002:a05:6a02:b84:b0:b2e:ce0c:b3fb])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:734e:b0:201:85f4:ad07 with SMTP id adf61e73a8af0-21d22b98d7bmr10729217637.33.1749135774020;
 Thu, 05 Jun 2025 08:02:54 -0700 (PDT)
Date: Thu,  5 Jun 2025 15:02:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250605150236.3775954-1-dionnaglaze@google.com>
Subject: [PATCH v6 0/2] kvm: sev: Add SNP guest request throttling
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"

The GHCB specification recommends that SNP guest requests should be
rate limited. Add a kernel module parameter to ensure a system-wide
lower bound rate limit on a per-VM scale for all new VMs. Note that
this does not preclude the addition of a new KVM exit type for SEV-SNP
guest requests for userspace to impose any additional throttling logic.

The AMD-SP is a global resource that must be shared across VMs, so
its time should be multiplexed across VMs fairly. It is the
responsibility of the VMM to ensure all SEV-SNP VMs have a rate limit
set such that the collective set of VMs on the machine have a rate of
access that does not exceed the device's capacity.

The sev-guest device already respects the SNP_GUEST_VMM_ERR_BUSY
result code, so utilize that result to cause the guest to retry after
waiting momentarily.

Changes since v5:
  * Reverted the KVM command for setting the rate limit in favor of
    the module parameter solution. The default is no rate-limiting
    to maintain existing behavior.
Changes since v4:
  * Fixed build failure caused by rebase.
  * Added ratelimit.h include.
  * Added rate bounds checking to stay within ratelimit types.
Changes since v3:
  * Rebased on master, changed module parameter to mem_enc_ioctl
    command. Changed commit descriptions. Much time has passed.
Changes since v2:
  * Rebased on v7, changed "we" wording to passive voice.
Changes since v1:
  * Added missing Ccs to patches.

Dionna Glaze (2):
  kvm: sev: Add SEV-SNP guest request throttling
  kvm: sev: If ccp is busy, report busy to guest

 arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 25 insertions(+)

-- 
2.50.0.rc0.642.g800a2b2222-goog


