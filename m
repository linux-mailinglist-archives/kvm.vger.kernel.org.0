Return-Path: <kvm+bounces-72873-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mC/fK527qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72873-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:21:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 25ED6216131
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE936322C685
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2983E3DB1;
	Thu,  5 Mar 2026 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDQQu8hj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2093E3D90
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730808; cv=none; b=YI1ufU4bXwB23FcF8V7pQA2zDDSiL+Er/qpIqCR5XgYKA6m1vRO047pDQDS6IRSJtdcvFzSqJVPtWE5tcyGRjije21pTNo81PmBrlbmhewg8RIYKNTQw5lfV8024WbbFbv1sUJYIVKJIPzxcvJDEWzCp+MgrXaGLTJYD4pd88ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730808; c=relaxed/simple;
	bh=GkN45TVqrhUQeX1DWvKJoDQBy2vQvG2wh+ti7nKc0O0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=levcOywLqPnN0ADnB/Emxz39l2Ra9CtfzRc3RidZipOUxiizQvPSRZUsQ7LWyU9XdhCAPOOFtKtqs/6NoWi0pDVwRSBrwVf8oxJNhPrauQjbMpt2E+ZdVZc4KKl7zPlalB7qXqNNcgt19dIfW2HIfVAd2qqQg7PgDx9JKIHLB3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDQQu8hj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4f27033cso47274215ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730807; x=1773335607; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LxmGGqlfBLY4cR5sL2/SllMMZhbAuarw/hcpalBZUhc=;
        b=iDQQu8hjcIAnYRujXcsY7M2zAM0NGr+JzzbcVF5TEbw5QgsIPCtcwMdOwzDkgQBt9v
         JcmL1C2qrB8nW+ysJWPvZi3uxVvrDomhM6Wvf+/DM7aHEGvohVA8ELykrB0D4dSzkbpT
         znvoLI6cifDDqtRX5zuH7r93TVg8yZxEx9zdbdqw6KOUEP/28Xquctg+KgrU4gaUx/Au
         qBZN8owKklRVLV0hoUlQx+zPadIpaYxkGqqvK7v1X7tL0+51FJtL/eG1ednXVr9Yc8Cj
         WQ3JUYZqcZEzO1InpL9GvBP2BDTnjpoeJO4jpk4/u08CdWNVNder06qkaMkgaHgOLixx
         RdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730807; x=1773335607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxmGGqlfBLY4cR5sL2/SllMMZhbAuarw/hcpalBZUhc=;
        b=Q14lvsq6cH8hBu81mvGCAUUoclw0KmaUl13HFGj/ci6fhU+6k129rDwWFwcJeNyL0M
         YuBGvBKk3b+RuwM2b5Efc94k1fOMCwIFAlxARKE5jgdYqmWBiEOAG6vq8j0xy3fvWIpB
         vE2PAx4Bs0bstRuHeLKfWd3yw3KOzs/QdT4KtORr4BL+nnUXwc4O3g+d1Zo0py6H/pfS
         VFmGbkToS43/m0zxjXj9N3w0+cLt1llGPf0+9u+Jr+Ux6zopCwjmOoUdwTZYHbKOsvjK
         I9ABRSJdoc7B7di3ylGjkBh7mkywALZlMkmmExAADbqsavf/PaR+B5h0orlRJB/hOA39
         DE9w==
X-Gm-Message-State: AOJu0YwGuSllZER2uYeWaZHmobZkP+L6EgrytFTC+f8a2EhwKgC5He9P
	xkpr9+eBaFOBQZlzcpptYOqsZxRRjWG+Hy72gH98W0OuQ59IPFOS7CyERf4aAaLM6BWX0eBIYbn
	sJeb8Og==
X-Received: from plbke7.prod.google.com ([2002:a17:903:3407:b0:2ae:4e73:c915])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea03:b0:2ae:506e:4711
 with SMTP id d9443c01a7336-2ae8022c9d7mr3584205ad.31.1772730806533; Thu, 05
 Mar 2026 09:13:26 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:35 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272530597.1533400.17444607390212617280.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: SVM: Fix and clean up OSVW handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 25ED6216131
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72873-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 13 Nov 2025 15:14:15 -0800, Sean Christopherson wrote:
> Fix a long-standing bug where KVM could clobber its OS-visible workarounds
> handling (not that anyone would notice), and then clean up the code to make
> it easier understand and maintain (I didn't even know what "osvw" stood for
> until I ran into this code when trying to moving actual SVM pieces of
> svm_enable_virtualization_cpu() out of KVM (for TDX purposes)).
> 
> Tested by running in a VM and generating unique per-vCPU MSR values in the
> host (see below), and verifying KVM ended up with the right values.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/5] KVM: SVM: Serialize updates to global OS-Visible Workarounds variables
      https://github.com/kvm-x86/linux/commit/f35043d0f973
[2/5] KVM: SVM: Skip OSVW MSR reads if KVM is treating all errata as present
      https://github.com/kvm-x86/linux/commit/089af84641b5
[3/5] KVM: SVM: Extract OS-visible workarounds setup to helper function
      https://github.com/kvm-x86/linux/commit/c65106af8393
[4/5] KVM: SVM: Skip OSVW variable updates if current CPU's errata are a subset
      https://github.com/kvm-x86/linux/commit/3b7a320e491c
[5/5] KVM: SVM: Skip OSVW MSR reads if current CPU doesn't support the feature
      https://github.com/kvm-x86/linux/commit/a56444d5e738

--
https://github.com/kvm-x86/linux/tree/next

