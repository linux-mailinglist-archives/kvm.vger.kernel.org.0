Return-Path: <kvm+bounces-58223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 593CEB8B734
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:11:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18C707C2936
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9F72D46B5;
	Fri, 19 Sep 2025 22:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxSDVPG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B032BE7AA
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319883; cv=none; b=pKHuHBQzSBL9BZ64KbIhkLkIGVk+LFPV1fCeRRWh0BGDVdIn5QcHtMP0bwF3FXe0wESNwvWkbp4DWIB/3oO+JzIME4YCx7FYIlTo8ixsIWIKN2b21AlKfJJY/F8Qem+6QOM239JDg+OI1OFYY3i4k8Dkit+NLxftkIHEABJY7zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319883; c=relaxed/simple;
	bh=W0X6Mhm7wS8fcpKTCZiYFQOzjq2PAz99VFyTZFOC08k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FTXZ7PY7giaJkb1sFyET90cqkFZJArfIR3LByq+3riUuFIZvIgDBCNTVdaVrAfWDyraDvRTOi7U4bn8bUfUJUqFOQTcUYBZMygGDr5EkvsywdEFgWusb1elNxxD+bY2kSWGGItukt2EPSppEeDk9v3nj3JG5jcacnYPhfb7cPM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxSDVPG8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so2477771a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758319881; x=1758924681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtooCHjprRGWJDpmHrwAkRKW/eZFKp/kjai25858VaA=;
        b=fxSDVPG8JnR2VLFT70zTAqQy/C6eAK+iQK8rHSDk9sKUqZqIljK7luoqFYOwuLPeQx
         UkFosrvfGgwc6UWhDWpp3XHEuGETVwqF94dNrRuLAAEUg0xdV2BzOTmk+aYtFJiErDIl
         4BTRYalrgeXfGtl4PQlOtel6COcUc+Ku3G3RDpnfvMiskm/mcwmQjctoParU6Hn9n396
         mHr2Rq3X/qn5DyLDhwSiujYLOPKvG/0YpDMgGbS6Kk+bpTNtPtvkZFjHCUobkx7xJR1R
         sR2liyjuY9BFbDhlmEfJrh8DiGksX4+/iyEa6GlsCG6N02g1DuXlUt3ePTct0dr6Gn6l
         zxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319881; x=1758924681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtooCHjprRGWJDpmHrwAkRKW/eZFKp/kjai25858VaA=;
        b=Ei9H/ChtbiBZyTU7D/C9fhAZS+cVncG8g48OpV33AEvXxI8cp1YKBjn1dBWPwLhMiq
         GyyMfHIGHKUJ/LYa6/cmmQV1UOVZAFEQ16dI6ujzsy1YAi4Xv7RSjup7ngfeQTAh6oWr
         nOUp54Jun+Eei5Xqhc9zKXPDyzLyXwKAjnd13kcPgUEQg0JDlXERoP9AtYNxz4vc9DrW
         apL53VlqcxQ9s8OFwxUZnWkoA9jw5vbUSta0W42mFethzuSOj3rPytuh6TldSiDzye09
         ei5FYVWNlg7TgG/OmRPf2HTw4i41AuP4VTmRfk7lWIa4+Ih7/aytmKevpG4jacu7HecK
         WxdA==
X-Forwarded-Encrypted: i=1; AJvYcCX+QhfxR/Cwpy8LljCh8zNyY8ZwMqrNEbzD9HfMBfa9k/hEnub/aCsFYXulg5zSSqWMZ6g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh0AC2Vnz5UNIk7AKBzR5TESHNIVWeNS4NKv3/vLfZP20Vhv0T
	8Gg0Rq9X+lBr+3Sd6sIDKmBGoCx3bOm//Wv0TBa6V7EeuU0kslJ0RVedo1LZtDZrCv+mTuFSN2s
	8UxbPCw==
X-Google-Smtp-Source: AGHT+IEEeeVSif0fn4CCkYFDfSXy3qALrL675gG1rH9irmCC+LZWwFQ7hk0JYzvlmgkTNPObdwsCgxTAvo8=
X-Received: from pjbsv5.prod.google.com ([2002:a17:90b:5385:b0:32d:a0b1:2b14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e12:b0:32d:fcd8:1a9
 with SMTP id 98e67ed59e1d1-33098385bd1mr5008198a91.32.1758319881426; Fri, 19
 Sep 2025 15:11:21 -0700 (PDT)
Date: Fri, 19 Sep 2025 15:11:20 -0700
In-Reply-To: <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-15-seanjc@google.com>
 <5afee11a-c4e9-4f44-85b8-006ab1b1433f@intel.com>
Message-ID: <aM3VCPaq8apAJLoW@google.com>
Subject: Re: [PATCH v15 14/41] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Xiaoyao Li wrote:
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Add emulation interface for CET MSR access. The emulation code is split
> > into common part and vendor specific part. The former does common checks
> > for MSRs, e.g., accessibility, data validity etc., then passes operation
> > to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
> > 
> > SSP can only be read via RDSSP. Writing even requires destructive and
> > potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
> > SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
> > for the GUEST_SSP field of the VMCS.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Tested-by: Mathias Krause <minipli@grsecurity.net>
> > Tested-by: John Allen <john.allen@amd.com>
> > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > [sean: drop call to kvm_set_xstate_msr() for S_CET, consolidate code]
> 
> Is the change/update of "drop call to kvm_set_xstate_msr() for S_CET" true
> for this patch?

Yes?  My comment there is stating what I did relative to the patch Chao sent.
It's not relative to any existing code.

