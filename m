Return-Path: <kvm+bounces-24449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0FAE9552E2
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 23:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 106261C24300
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013871C689B;
	Fri, 16 Aug 2024 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="koeDU4vt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F001C57A2
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845505; cv=none; b=beZdKUlsXDiNwpq0I1R48QTxrw/jFgeZekEYcJ92TvbM8Lam2G7LFMN0rQocERMC/NvRpZST9IIcvvkgpmL5SU2oHQxJ9wrMkDRnPjXn/zIVtVA+OT1/BtwLCV0QXUdPkSXv20N7PTctSPH07Q1PtSUPun7sCijTsOFfyrIxOQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845505; c=relaxed/simple;
	bh=g0F/sd95+BjyUwrTk3+Pt47OK1/UutxibFLk9BmEr4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Em/gUQ5MzpfvycRg2qRX7d73/eiwnE0Rm8mUcdvN1RNvIloOist2OXgVIvq09RpF76g/Q9OPveFhwBY1WLnNf20Zmm44MbyIEiqrAwptVWIMWAmJTen6rjMz81ONMrLZ85nF7MLnJ8UdHXl8hygeKgijLSce7/Da3zeiD3MGSYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=koeDU4vt; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53310b07267so3217729e87.3
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 14:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723845502; x=1724450302; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vyAQI0mLIme3ritjMf52b0imeC+VEqOt65MTNAtgvRU=;
        b=koeDU4vtFjFAzmg85sfLbDsSsDJuS1N7hiONdxc3UN3H9G9YYGisDKL+pDNF+HqKf2
         kPo9AD81AMT5gQRO3V21mww3llQZHQKJhXCCH7dp0BD5tQX4/0tM4vLIDweczKzU16KB
         eGlTBfOYs/SyhasP+LVwX4fqFHyOLQgtuB75Zkn9cX58Rva4cmq4yDakrRi/9raY02EV
         XBZExrCs7wCHfdxjSh/OkZM9qHkC/Nb59QZ+079ZMbhiDEuDRNJnshh7wMh2xZF1wKZI
         qLl6uLf/PVJ1RlI7wxSgEJO+V07wDV1Jm3MyRKelniCgCpB35tusqmQ4gENT9F0az3SF
         wVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723845502; x=1724450302;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyAQI0mLIme3ritjMf52b0imeC+VEqOt65MTNAtgvRU=;
        b=XHhGPzktd0vm/4QDvPyD03XWzpH/GzKvJCQw95aC8d9tI4eh+XutqF7ORPZYUeIeNH
         twfxSPIpZNXHFjVrwZL3BdKIp0ucGbUgZSnoGUQhFX2jUFZfjot0d6RE+zgsgFc4k1cv
         AHtS0UMq4T35VsPvnGAxSjTXYLbHO3kY+mSCbLpXhYVJMtNQq8FI3QvpcmCjH8c9+vWO
         oriAYQFOzvIQfso/wxISfOX9m95iog5fSyeELQe5uz25d74CXpgX7CjLiZl41wnpWTbQ
         mOY9IH+PetVpAopmvN8zhkzwkCHB0bkyxdXEcsig7temCH2r5A+sAJhWXkYI+3cVjQ/3
         4OdA==
X-Forwarded-Encrypted: i=1; AJvYcCWwqmGJZZYeu38uqn1eR/nh13K5i+KD7RkPD44CVAA57TuP76REyVRKY6XdFS1B1653llrTlZwfK4y43xGasu7RbZ49
X-Gm-Message-State: AOJu0YxEizPzkgFkGTCjp6cEw1oWRTIV1g0gNP28Ur86nGGom96ves9L
	0+/h/zUWYjeQvuWuF7zWb2OzucxkiNt5LjOmh8VyY/GRa39hYIqXT0t2MeF++Coh9sOPzEmCOE8
	dmq7uGt4tGxzFggiofuYHs7m+YLboU1ETyuhb
X-Google-Smtp-Source: AGHT+IE3OGYvE2Lmfx5P1zwYegVYlgr1AuU2FCcSFUysvWMVPGL4hd0/zjoroW1fldq0JWzGDaAIAmG9Jq4zoll+/tc=
X-Received: by 2002:a05:6512:238f:b0:52e:9808:3f48 with SMTP id
 2adb3069b0e04-5331c6aee2cmr3903167e87.21.1723845501250; Fri, 16 Aug 2024
 14:58:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZkN25BPuLtTUmDKk@google.com> <20240515012552.801134-1-michael.roth@amd.com>
 <CAAH4kHb03Una2kcvyC3W=1ZfANBWF_7a7zsSmWhr_r9g3rCDZw@mail.gmail.com>
In-Reply-To: <CAAH4kHb03Una2kcvyC3W=1ZfANBWF_7a7zsSmWhr_r9g3rCDZw@mail.gmail.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 16 Aug 2024 14:58:10 -0700
Message-ID: <CAAH4kHaCGraqmD8Zi6CtFzYFBvg5vgaQEc_DYJ7PayONp22B-w@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Replace KVM_EXIT_VMGEXIT with KVM_EXIT_SNP_REQ_CERTS
To: Michael Roth <michael.roth@amd.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="UTF-8"

> How do we avoid this?
> 1. We can advise that the guest parses the certificate and the
> attestation report to determine if their TCBs match expectations and
> retry if they're different because of a bad luck data race.
> 2. We can add a new global lock that KVM holds from CCP similar to
> sev_cmd_lock to sequentialize req_certs, attestation reports, and
> SNP_COMMIT. KVM releases the lock before returning to the guest.
>   SNP_COMMIT must now hold this lock before attempting to grab the sev_cmd_lock.
>
> I think probably 2 is better.
>

Actually no, we shouldn't hold a global lock and only release it if
user space returns to KVM in a specific way, unless we can ensure it
will be unlocked safely on fd close.

-- 
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

