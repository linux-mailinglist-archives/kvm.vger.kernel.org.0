Return-Path: <kvm+bounces-9553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 881DF861892
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 325121F251F9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5590712A154;
	Fri, 23 Feb 2024 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAgxXDZG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20198387
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708707529; cv=none; b=ZgQ7382Ax6GCHrLUgBJbWUxweIXYUgez5gOdyIqZ6GDujLBryA/0c/mkmrGYbRjd4PvFdT59TruZX9bKNOg0q+gmq9PA68BzB0Dc523ognAkn4LODpCFehgPRk/BkakPqcp2DxvHGkDj/dymzKFS4AuHxRhw9JzQhfSfx5tbdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708707529; c=relaxed/simple;
	bh=/qCYSqlO9DNszGUQz3vCGxRHgLhruOfrybgzCU6DVXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NADBzuUw5BzCnVcGIuYA7VXesAKTSwaUJdSjZT4VuCDAOREQPIidMG7KjcE5rG3EeZYs4n8djHYjaQevJyZ+h7CEbunKEIT6eynenJx9zGqmeNjfx9AVX5QMeFnqwuVsVz/7x3KbVd1g8ZF3mCKpW1A4BqxfgWbKsTEwuQ/RLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAgxXDZG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6082ad43ca1so17078477b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708707527; x=1709312327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oc3Qq6lAIDsi/q5F7XRr3cp32P8qkiyEnUPLih6Y/wY=;
        b=IAgxXDZGMqLfSlz96LIdeX51FWRb2z2mPqCH+Rq76KcHLn3hrtiS1bY5ttltIRB3Fv
         JzOsWlUBO/1CAaXouuHE/6SRDm0J6Frg9AMzyRnHr4LbwXNR+fD7mO2VynOiDjHh76ZM
         ++7WmX+7RS1LrUQudStQnQ2RYk8L5rdfWojJlcn1l3kOR78L9BtcJRoV5wOecOdbTSpf
         yfC68QWjX6zA3UJE86HOyNN78OT78NIPsVbLbFpKqZrKnRWoO1CPtH5f6XlCcNeDaEZJ
         FQoSR1ev+9YOdTGylgYYzb7GBq86tDgHGVtZQgXZnIvGtntvsKf3lD7XcErMpaxhIjpK
         vYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708707527; x=1709312327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oc3Qq6lAIDsi/q5F7XRr3cp32P8qkiyEnUPLih6Y/wY=;
        b=jF3ae3yPBBdSikNrnvuArmnN5Q8RZEXidMUy89fQnFBd3k+6YRvWHiBEcBmvikQKxV
         00k7DOd/pFCqZJgT7jAeZ8x27ZRtYQUnjKbncLkyBOat/f92K8pF2EBRoztJS4VWLTwt
         3rtc41kzdrTpTlaKWDqKwt6Ys+smf0Gxjjh/HLQLy+IpAsN1Bhg+Mz0g1phdh7dUGAmd
         mXDQm9zQnU6tNDH8skMK9xUoTkDWj8UCMYs9jB+uQleB6fxMOHCtEoE5dzUp7X34cSK9
         6fj5GcvUj/CeIOEZz2Bv5W3xLSlxyIOmhXuTZZTiZaVMC0frKV04kg71R/msWQ1oyuJN
         dDVA==
X-Forwarded-Encrypted: i=1; AJvYcCW0jbetoHP+QNYPsHLy4rYCZJErbXKJTBCNzN2OLY5Bz1WgGxeeYWB1F81+gG5Q0TxbatsHC8MgIEVH92C/7YLE6mVD
X-Gm-Message-State: AOJu0Yx8BvJrkSjCAR6LqLG6MUrVJlgV9U89C07el4GlCxgEExTQfndd
	Zgosz/tvCpOt2e2Gdi0ErsYMcLZy6/unSgiNKa72IYw2147R7OehIdlqGiRpuA+ONwnQWE1bxrE
	n2A==
X-Google-Smtp-Source: AGHT+IG+gq17ikIqA8XdmP9ANQ3WUhP5iYW2W+seOy/2+HGUIAfb6gwraEplyOYx/xpz0xfx0noUaIPphmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9e13:0:b0:607:83bd:bea3 with SMTP id
 m19-20020a819e13000000b0060783bdbea3mr64043ywj.10.1708707527179; Fri, 23 Feb
 2024 08:58:47 -0800 (PST)
Date: Fri, 23 Feb 2024 08:58:45 -0800
In-Reply-To: <20240223104009.632194-11-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-11-pbonzini@redhat.com>
Message-ID: <ZdjOxe1BHyn9KDrY@google.com>
Subject: Re: [PATCH v2 10/11] KVM: SEV: introduce KVM_SEV_INIT2 operation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 12cf6f3b367e..f6c13434fa31 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -683,6 +683,9 @@ enum sev_cmd_id {
>  	/* Guest Migration Extension */
>  	KVM_SEV_SEND_CANCEL,
>  
> +	/* Second time is the charm; improved versions of the above ioctls.  */
> +	KVM_SEV_INIT2,

Heh, I was just laughing in a team meeting yesterday that it took me an
embarrassingly long time to realize that KVM_SET_CPUID2 was version 2, not for
setting two CPUID entries.  :-)

> +	if (copy_from_user(&data, (void __user *)(uintptr_t)argp->data, sizeof(data)))

u64_to_user_ptr()

