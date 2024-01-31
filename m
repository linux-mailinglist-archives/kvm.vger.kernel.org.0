Return-Path: <kvm+bounces-7603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8B9844ACD
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:15:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24F22B21D6A
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482E839FE5;
	Wed, 31 Jan 2024 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qbtjbIzz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F449383A4
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 22:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706739312; cv=none; b=UsrtJneA1IH40G4fSJm+aGcgOY7RgIgop/gp5Kbcc75uU0ZOtzO5/3CHTxwx9e9/w9qgNSEJkW5TzZJMnIHf3rUgMe8YjerYBath/ntsdA5DCqoOsDbULHU3/UwaQLze/ERfnwd2WjrUwnfoautk8owrD8VabYXapkCtawj8GxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706739312; c=relaxed/simple;
	bh=LbAU2QOSUO4G2w7KXKLwqZIy9v04ComU9ZUQlJty5nc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y7LIl5IKIwn/hVmtXF9TDaz2Z93Q7xV9OOz3XONJgV3y8upz3Vs8YT4wFwgIzw9qO84+yzV2Dv90q9h1+wNGYdEhGqz7WDhCQJxaj8X+2yLULmTUnptP/452fmMwwlQZsQ1axhaiWl2tb5FRmwb5pOJ6sMJiIE8/ItK++T1mcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qbtjbIzz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso261398a12.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 14:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706739310; x=1707344110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bw10OTGUzfIt3yMJ/JYelZQmmsijYp7LFaUSBetq8KM=;
        b=qbtjbIzzKii+/LAwUeXZSONTG5ZfHFFBCPyYAEb3jsnWHFp5nkZc83JEtdtQAumK+F
         AcyBMzj12DfcmUECL0wqomwpO41E5xqeektYLCl+hrLvA7n9PATZtMuUEWOdDFS9eMbN
         jQk4GpQO67+WdxjgDadjEbb5AvY0f90tgFmerVSXCtdD2xCqdgepEfVLgAQRUZVwPqZX
         XCEm/90s2cbMFBOqcRHi3xMcZQIUaVhFzrcmCEtEMnmxv1B6xTw0ls8MaSzseybEa5up
         8IE1TLUA9rIUtKx8tmN1m85mA1AD+n0Me2FygwkfwwfRWM7Vx960CUG4Qc6cMCa9+NlM
         W4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706739310; x=1707344110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bw10OTGUzfIt3yMJ/JYelZQmmsijYp7LFaUSBetq8KM=;
        b=p1zleesJcXwnSKvl/cfMB6IICiZ/XEOki0X8q/3iLFFTkSMJ62qJ5WwCHs8KOFxhjO
         97OVaFlJrGShlHVZV4GbWkB4UTzrZrYHQQDo65Fs+QBcbSn+J++afzt/5xmR+V+THgPd
         CZbZmMPvD81EIsxqEEC45VzHXbOE8hFcaOHOqXqNQvLyFvB8sDbfO9y6pWE6B3yZ+Tox
         9m4apXYQ+lD5DUVnc/FBgwo5atHr7XdQUSMEiTqGq67JW0wtRG6HkRabhhjuHtDo0s5p
         HY0LxK5fZP/nV95FMOSE2pkElQJ9VKrYvDc1pWo83aCxQ6TWGvmiEMhfq31jRR5hqn1e
         tE0Q==
X-Gm-Message-State: AOJu0YyDOXff0CAeu6XCeHmz6Zf8WzUbkgykT6uiTZywIhoPAiWdbI63
	XzX6dbS+tLW6uO6lnmz3eZ9Jni0SLgFENxiNW5ZIno3pjV0VhdiDRZxEnJgvExsjtYs/kBhXP2+
	h8g==
X-Google-Smtp-Source: AGHT+IE+Vo3GXPRreNgaVd3lwX5nZFPepIKP7aB/TwetnDkyydFJ1AKzRBneBfh6gsYeBkB6ujDvtkFrTvI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:68d3:0:b0:5d8:be91:930d with SMTP id
 k19-20020a6568d3000000b005d8be91930dmr18124pgt.0.1706739310357; Wed, 31 Jan
 2024 14:15:10 -0800 (PST)
Date: Wed, 31 Jan 2024 14:15:08 -0800
In-Reply-To: <20240104190520.62510-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104190520.62510-1-Ashish.Kalra@amd.com>
Message-ID: <ZbrGbLLvdwRfMun5@google.com>
Subject: Re: [PATCH v3] x86/sev: Add support for allowing zero SEV ASIDs.
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	joro@8bytes.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 04, 2024, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Some BIOSes allow the end user to set the minimum SEV ASID value
> (CPUID 0x8000001F_EDX) to be greater than the maximum number of
> encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
> in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.
> 
> The SEV support, as coded, does not handle the case where the minimum
> SEV ASID value can be greater than the maximum SEV ASID value.
> As a result, the following confusing message is issued:
> 
> [   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)
> 
> Fix the support to properly handle this case.
> 
> Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 40 ++++++++++++++++++++++++----------------

This should be ~3 patches:

 1. Convert ASID variables/params to unsigned integers.
 2. Return -EINVAL instead of -EBUSY
 3. The actual fix here

E.g if #2 breaks userspace (extremely unlikely) then bisection should point at
exactly that, not at a commit with a whole pile of unrelated things going on.

I'll send a v4, #1 should also be accompanied by a cleanup of sev_asid_new() to
not multiplex the ASID with the return code.  It can simply set sev->asid directly,
which as a bonus makes sev_asid_new() and sev_asid_free() more symmetric.

