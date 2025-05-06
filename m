Return-Path: <kvm+bounces-45602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9622FAAC7D4
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27F191C42AAA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 14:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B493283123;
	Tue,  6 May 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1anhYLmF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D374428137C
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746541475; cv=none; b=cdACmPnSLvFoS8RImut1fDYTYmEbALAkBIgPLUK/vRB68XkD/QLqNJVdS6Emypagv0PkyYTi1hXhiyJdlgt5y2Vfhkdp0yXKcjumIJDwgKHkXrTHqxMkx/wwEB1JNfM6GYodqAioNGpcm0k6oMko4KsPWymMPNHsjIRJ+lC/VVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746541475; c=relaxed/simple;
	bh=uzGnvzipjJmvydYRycycUL4dqtdvUfmsqIjQ4aKIEHU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CqCXJ9Tu88jX/u/HBqg3Q+WHugtTSQywfuJ5xNj7VXYZPkyJWtPuzR87EgmtDR8xJPauUB2TdiaHTXz56dw1+/p3gbli4QHHJAcnwYnBCLWfnga53alKv/8bvE7mdI7+Ic/3GsHf3oN3aToCEF7LkmoiImzyTDPJtT3oBzE5iHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1anhYLmF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af8d8e0689eso5765871a12.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 07:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746541473; x=1747146273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GvQ0P+wUKfaLn/ATwLSuvFKy87onNqdIa1sjwEnWlHA=;
        b=1anhYLmFXvFTtqII7wywKetk0UHFM6DC90GPVFRZm8Eewiv4IJTTcmQMt7/mgjR3yM
         u7BX//fjGh9uMQTjItuGfliy0Z+4jjrXZ1hCMXNYeemmBS5ULkzirqBQlLAAWtym5u5H
         BUTtNx8B6R4GlGy0rXf2goMVSFbav965WhSu8szua6qoBY29bxF9av7A1qUUXeHhNEeu
         ujJF8d47ImvOb4XB0iFzjvpCuHRHIBx3wDzYodcT69wuZwEkQCDd6Y8WVf8X0ZSsQcac
         ggsGHK91n6cC/pLVVgd6NbyxOO21OMXAbPlzy4mw4tPhzrIpGmUejU8CSG/qnMUtqs8W
         JyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746541473; x=1747146273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvQ0P+wUKfaLn/ATwLSuvFKy87onNqdIa1sjwEnWlHA=;
        b=EYhDasKgz0La+V9yHQvRcO5o72x7VZMQvUyev1S/kGQ1Us0I9qJKTCzXO8v5lhjNAv
         UiIVQ32RVWLfUooGd/gd8nAwIsg1stpo0T6qWAP9VJGsf5gsi6ChMJcEOKiy2uhrdiGA
         uZnRLRvVee1d9RjERAQZNV6RQMId6LEzzrdO/cwWQzdwHmhzCXr2k8YHunZ6ochYHnjM
         6k44hggxRAn/k1lv5GKGpJxhAf7ZCQU8lVPiZycFLLV3PSwIzpt1udZqB0LayxoYrrW2
         12bBxk2McwS3ZH5pdy9lxEGgS0Au/Ptju2k457Z5QwIMlNxrJCSL7HsTDYDNZPjjZK25
         wUqg==
X-Forwarded-Encrypted: i=1; AJvYcCVbwo3E4SnbfRIJqUcgQJ5FTrIBscRyHxOmsFw8Gt1LPErmLZwWWiS2UZ+cyZhRTIrFvgI=@vger.kernel.org
X-Gm-Message-State: AOJu0YweDvpYVIPPyjww5flPJDlLsgyduKphV0oHFQPmdp4Jkai27by5
	XTgJ2OzhpovuPf4HWPXq7KmIew1mMj97UAPPidlxfOttddGkib7WU9Bl+ob/J0lX8W20emQSfHJ
	jmw==
X-Google-Smtp-Source: AGHT+IG+tb6DAqfEkF2OtffXMj0e0GMqYjoEo/yCNWTnFNMEaweQ67wd6DzOO6xB801yCXPJlU9wA/n2y+w=
X-Received: from pfay24.prod.google.com ([2002:a05:6a00:1818:b0:736:b2a2:5bfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cf42:b0:227:e709:f71
 with SMTP id d9443c01a7336-22e1ea822aemr186821615ad.29.1746541472989; Tue, 06
 May 2025 07:24:32 -0700 (PDT)
Date: Tue, 6 May 2025 07:24:31 -0700
In-Reply-To: <20250506092015.1849-4-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506092015.1849-1-jgross@suse.com> <20250506092015.1849-4-jgross@suse.com>
Message-ID: <aBobn8kaiDVCEqK4@google.com>
Subject: Re: [PATCH 3/6] x86/msr: minimize usage of native_*() msr access functions
From: Sean Christopherson <seanjc@google.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-hyperv@vger.kernel.org, 
	kvm@vger.kernel.org, xin@zytor.com, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 06, 2025, Juergen Gross wrote:
> In order to prepare for some MSR access function reorg work, switch
> most users of native_{read|write}_msr[_safe]() to the more generic
> rdmsr*()/wrmsr*() variants.
> 
> For now this will have some intermediate performance impact with
> paravirtualization configured when running on bare metal, but this
> is a prereq change for the planned direct inlining of the rdmsr/wrmsr
> instructions with this configuration.

Oh the horror, KVM's probing of errata will be marginally slower :-)

> The main reason for this switch is the planned move of the MSR trace
> function invocation from the native_*() functions to the generic
> rdmsr*()/wrmsr*() variants. Without this switch the users of the
> native_*() functions would lose the related tracing entries.
> 
> Note that the Xen related MSR access functions will not be switched,
> as these will be handled after the move of the trace hooks.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

