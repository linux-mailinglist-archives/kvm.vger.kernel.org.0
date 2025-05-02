Return-Path: <kvm+bounces-45262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D0EAA7B98
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 983279A4B67
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4729421A428;
	Fri,  2 May 2025 21:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kIbEv27K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA920E703
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222709; cv=none; b=mwdcil8PHvsm4ARP3q4C6ac0Twv3tJdkyXxsxhMMB1jFSBV7h1Hk4kON70w3xARgaVYMuAM2tvCuymLW7ttH06dcYGhTkpgNbqer73Y7KBk8xKNgKBV3MpEX1ic4cB8xIOUFlvwkpXE5+i3PJIvnYpVLnPdPbPS1/6djRheNaCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222709; c=relaxed/simple;
	bh=cxIvd5OE8zvjpL5lkuZvXfEwGqMAz1/ZxLm947jF3lc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hUxC/TIX5N2mSQRxI4DWdFIpTTSlUeUIIOtRqI+dhdtAsYm1L42jWR0g8E4XRJRFZLtSEfhsEv4FzEPbhqyHLHTyCo+qyQWbJsflIARSCtaC7i/juSe0ZZ3tJVtLDUweZtcxKxKlFW3DJUwbzgRoCxMjaPQl/IAPpLCh0efGA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kIbEv27K; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff52e1c56fso3733430a91.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222707; x=1746827507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lqA+OjYWd50BoxBzqsGWFpZpdamv6joRxqjx+f01kFA=;
        b=kIbEv27KPO83ZtzzUlQkxrD+Lub46YSnTqTBxtvDN5jarttWkxJqxsPX4DveedZK8Z
         rn1Zmz29fxWgzevQ/v+YHbhFlxNpAPCdQl8Dvq06T1MdaPerDd9+MGH0Qg+DCpzmK0Q9
         U8UZM4n3O4K/sKWfgONXWgGqk/u8BgSAc/A0U2f/1HOupUhIYaL4tJy+lHZTjIFQz0Zg
         xcm8UxA/laS/djBPkI0dVTGeB9H/rp4ZZ0nOJ3sFmHupPTkajmFjlIY1GR0pxYC+3eOt
         MlW3t+0SNVDsZnbEPwboXL2VAa9qWPLUzuR4+9NsfVLo9Vj2wPr4vx+ekYgRNYiewQ3t
         J3xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222707; x=1746827507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqA+OjYWd50BoxBzqsGWFpZpdamv6joRxqjx+f01kFA=;
        b=NGwhKMtLES3jlV1ZYvqXRxth5Od8Tljgl0txU2zXVwGfZHWZauArSlythVv91Vl6M8
         hR0ydAbkZvaV327ebUVeOufHUpl9Zcmn7gOmPhHM8md/iMvx24sCcBhevdea9xY8fci9
         YC85GcqrTgIFqhdJ3rSlJskIfc9q6wj3/GSxGM6fEMDDjzdMq4Z2lq0Ov/lqjom9euGS
         aERAYdGXiyahJDbfGYbp7DIfdZ9SYlFuw1euPyMVA7aqLGiogo2XWhhyCA4WmDOtXNCG
         Tvuu5KLt6czWIl7aBepJ+cJMmrjT1DOw9r1WHlNE2ineNmllSnkCPXccA8/Mp/L4EmEw
         HqUg==
X-Forwarded-Encrypted: i=1; AJvYcCUVf+WGUBLAVxEoKq1piS4Te3NsZHXruP/9yUbo2+LHJdrM6fSDqk4mXX4qt4fU3mlb6tI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAZEd3+UIBuSSGQUGtE586iBu7f40I0HZxp4tdEThnX1F2dhHb
	qoeFgbI1oA3aL5F3iig3/t4IlxhF/WxQDKJEaIBtOMBwsKGkBWH9FEws3X8w2N4AvQC87Kwd8KA
	zSg==
X-Google-Smtp-Source: AGHT+IF7GVKpEPpszl3Lnl1tx1yBLORLBZNrTCEOJ/q8W/bFUFsYqv0Z3klOw9bVvvU4wrEO3W0JSS7J6lc=
X-Received: from pjbsc16.prod.google.com ([2002:a17:90b:5110:b0:2ff:5df6:7e03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e183:b0:2ff:6ac2:c5a5
 with SMTP id 98e67ed59e1d1-30a5aeb6e06mr1083512a91.26.1746222707171; Fri, 02
 May 2025 14:51:47 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:57 -0700
In-Reply-To: <20250305230000.231025-1-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250305230000.231025-1-prsampat@amd.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622216534.881262.8086472919667553138.b4-ty@google.com>
Subject: Re: [PATCH v8 00/10] Basic SEV-SNP Selftests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	"Pratik R. Sampat" <prsampat@amd.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="utf-8"

On Wed, 05 Mar 2025 16:59:50 -0600, Pratik R. Sampat wrote:
> This patch series extends the sev_init2 and the sev_smoke test to
> exercise the SEV-SNP VM launch workflow.
> 
> Primarily, it introduces the architectural defines, its support in the
> SEV library and extends the tests to interact with the SEV-SNP ioctl()
> wrappers.
> 
> [...]

Applied 2-9 to kvm-x86 selftests.  AIUI, the KVM side of things should already
be fixed.  If KVM isn't fixed, I want to take that discussion/patch to a
separate thread.

I made minor changes along the way (some details in the commits' []), please
holler if you disagree with the end result.

[01/10] KVM: SEV: Disable SEV-SNP support on initialization failure
        (no commit info)
[02/10] KVM: selftests: SEV-SNP test for KVM_SEV_INIT2
        https://github.com/kvm-x86/linux/commit/68ed692e3954
[03/10] KVM: selftests: Add vmgexit helper
        https://github.com/kvm-x86/linux/commit/c4e1a848d721
[04/10] KVM: selftests: Add SMT control state helper
        https://github.com/kvm-x86/linux/commit/acf064345018
[05/10] KVM: selftests: Replace assert() with TEST_ASSERT_EQ()
        https://github.com/kvm-x86/linux/commit/f694f30e81c4
[06/10] KVM: selftests: Introduce SEV VM type check
        https://github.com/kvm-x86/linux/commit/4a4e1e8e92eb
[07/10] KVM: selftests: Add library support for interacting with SNP
        https://github.com/kvm-x86/linux/commit/3bf3e0a52123
[08/10] KVM: selftests: Force GUEST_MEMFD flag for SNP VM type
        https://github.com/kvm-x86/linux/commit/b73a30cd9caa
[09/10] KVM: selftests: Abstractions for SEV to decouple policy from type
        https://github.com/kvm-x86/linux/commit/a5d55f783fb7
[10/10] KVM: selftests: Add a basic SEV-SNP smoke test
        https://github.com/kvm-x86/linux/commit/ada014f5fc67

--
https://github.com/kvm-x86/linux/tree/next

