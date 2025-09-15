Return-Path: <kvm+bounces-57643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B10EB587E2
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05C151898FE2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9DB2D6E74;
	Mon, 15 Sep 2025 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4yGV0iu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2582B2D7
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976803; cv=none; b=CiKJooebnYLjfqEpZ1PZyNBha34afdX1NZjBnawsHibLewzdTFMjrAN/Mzo2ETRtvfmmBiorDMdq3vIAl4imIKsgMZHBATdwfXPxW+s/a2pFrPSMqAw14nHJPAGvZ+pnnDz1Y5IaY/J7KLX/wn3S07kJ4xiBzJcRgnY8M+SNRUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976803; c=relaxed/simple;
	bh=e+HXCa7VYi3lvi/EAzq6e56QEJtWPCBJFmihJ/rpT74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YzJoLUpQYaP756ND0wsSnPRd4SM/7UrupJYXWTJSq3A4Q6LzsImbBIeg2KjZusK9GlJ1lQ6d1DaJGTgbCBpR6Nr4qR1An6OELNIPxtlR6nw7jPgCe5AeNKDxlIaVqV3EdobILekp5yUMlMR5OBaSENlLt2VO31/LxwZRpd3hfTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4yGV0iu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b52047b3f21so2578929a12.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757976801; x=1758581601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JikzfQFWgQeduDyXCm2JMgQmYY8ml9ms/3oBnzR8mvg=;
        b=W4yGV0iu4tuzfm7iR1wrTVgEn0CtkOwL42YY7lvqIWu9uVek063C6V1b+LDPY6Nxbh
         FFsGQXIw252qNa4LNuRsRtHdye3TT2VLObFpHOUhJopH14gA53c6EKGSbcjWsOLWnmEg
         jwWOUdGPSz4AKTUisOVC/Zw+j1xo2Fc4HMX73KSKwjw9BB8dEpHDDodX2f3iUj8rujKf
         gcNdvCQA0BCb+D8kbhtG45SrL+/J6hMo5pCEtMqg1C8tO1SM/90L1vYPqB4iyppBqx+J
         Im8b6jfZqbD1+d4ThCHACt3v0h+Jd3K3u9K6/SQ+2XfhqZrVIxVGpxYi08RLjJi7vibN
         w58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757976801; x=1758581601;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JikzfQFWgQeduDyXCm2JMgQmYY8ml9ms/3oBnzR8mvg=;
        b=rP/+DdX7g5XjB5NB8SGe3QfIBa2qsR9x+rNs+pgPSd4AdGAaUZPxHlwA3Ti08+huVV
         8fje/X2h6Vyh7ex0GKDclFeZFg9TWWgDi6k+8QwamQYZltXL7iUf8HXU/WM7ioWzs8AQ
         c7DVeO9TWZX1rqcs/4gYQuaUBYcuA/iUylls5f8f+6g/W6KN3uMrgBlCsgYT8q0nwVVP
         gFQsgLPJ1syrLYnt45ZIll4/3Dnly8eTrVK8i483sPyYUY973a4bWWBvbkwtN9X9BFmC
         qQCMIIPrVqrlSpQ+M1Q31jsC6MRWst+gCWSc0MuYQwg37LJWofL1rPVV3Gn3g2pnwcw7
         lx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVZ6P5hHEjJ8u+reYyv6QmnohqBeYEq/PRG5IjA86MwqxW3LZm9GjZocqNiZVLK2ZpqVR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQcJAGHc9sV216HRSZgiKRrywVQDDsYRHWs17L2UuKe7z5SO3g
	pQxg0n3Llt+ikCZS2+/U+rddHs9OfQujV4bkwSNI9JE1FGnF6UZKgf0cdHn+lWhFKEpAe9NHR+D
	w4fPZ9Q==
X-Google-Smtp-Source: AGHT+IF6fmo4ZuDF1SY2WduqV3+Y7eHb/5fudxw3qedXSzd0nAWyGRz+M2eoYLTbH647s6e1hajYeV4JIwg=
X-Received: from pjd16.prod.google.com ([2002:a17:90b:54d0:b0:323:25d2:22db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:32c:2cd:4d67
 with SMTP id 98e67ed59e1d1-32de4ece85dmr14822120a91.13.1757976800678; Mon, 15
 Sep 2025 15:53:20 -0700 (PDT)
Date: Mon, 15 Sep 2025 15:53:18 -0700
In-Reply-To: <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <46b11506a6cf566fd55d3427020c0efea13bfc6a.1756993734.git.naveen@kernel.org>
Message-ID: <aMiY3nfsxlJb2TiD@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: SVM: Enable AVIC by default from Zen 4
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> AVIC and x2AVIC are fully functional since Zen 4, with no known hardware
> errata. Enable it by default on those processors, but allow users to
> continue passing 'avic' module parameter to explicitly enable/disable
> AVIC.
> 
> Convert 'avic' to an integer to be able to identify if the user has
> asked to explicitly enable or disable AVIC. By default, 'avic' is
> initialized to -1 and AVIC is enabled if Zen 4+ processor is detected
> (and other dependencies are satisfied).
> 
> So as not to break existing usage of 'avic' which was a boolean, switch
> to using module_param_cb() and use existing callbacks which expose this
> field as a boolean (so users can still continue to pass 'avic=on' or
> 'avic=off') but sets an integer value.
> 
> Finally, stop warning about missing HvInUseWrAllowed on SNP-enabled
> systems if trying to enable AVIC by default so as not to spam the kernel
> log.

Printing once on a module load isn't spam.

> Users who specifically care about AVIC

Which we're trying to make "everyone" by enabling AVIC by default (even though
it's conditional).  The only thing that should care about the "auto" behavior is
the code that needs to resolve "auto", everything else should act as if "avic" is
a pure boolean.

> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 9fe1fd709458..6bd5079a01f1 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1095,8 +1095,13 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
>   */
>  void avic_hardware_setup(bool force_avic)
>  {
> +	bool default_avic = (avic == -1);

We should treat any negative value as "auto", otherwise I think the semantics get
a bit weird, e.g. -1 == auto, but -2 == on, which isn't very intuitive.

>  	bool enable = false;
>  
> +	/* Enable AVIC by default from Zen 4 */
> +	if (default_avic)
> +		avic = boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4);
> +
>  	if (!avic || !npt_enabled)
>  		goto out;

