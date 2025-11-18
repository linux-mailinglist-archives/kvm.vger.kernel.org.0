Return-Path: <kvm+bounces-63596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D6536C6BB0C
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5A3833644A5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 21:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8E230BB89;
	Tue, 18 Nov 2025 21:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="fRiA4H3Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126771DF261
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 21:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763500287; cv=none; b=sbm7uGqdDmsVEfNKNKgUiVzX9ezpkpLgddLUjI5BYIckqKvrkCUGWS+l1viPu7tJmrekn6YjdDmrkIKP3bVsZQutUxlEmLBX9iITedtJfFMpbm3uq/k5WvuG6mCGzpWViWmzXVWUVPQaAG9Z0YlGyMKWZTnrsFsNctwF8Of4jE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763500287; c=relaxed/simple;
	bh=EhBpJI4JH2gTI2QL5yBXKSGagoOf0lN/AIcf17SoRPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tt7wdeBLlCoxjxAbg6g2STwMQzqGrRR00wHWGVZdPQYW+Jmf75PtkqR2UsXz/BXR0l3+aATxqkpSZ+B0TxNaBX5lfu2J7MSk1R6AXHqwRuzpnULXNym2grBd00wg2/6NwGqmilk9Cl2LLgpcZZK1vQIgQ1UgCJOOXoLyoOLvyOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=fRiA4H3Q; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-340bb45e37cso1054746a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 13:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1763500285; x=1764105085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPhkAuWM2DyUy/YU4ZRQNyTfFr9mrQ9L/0ysPca6Z6s=;
        b=fRiA4H3Qt+Ep8cy6gugaph+4mb7/1kYAfBRVnAggC2rSlbVScrO4dzWz/rwZvcdJip
         vz/gbriEE/+MsmIruP977K/la7jMeVVIkZmuuz17fzbH+FSVPzSYTFb4oPHNGWWDZYCY
         ytm+9cuhixCDmpoWEe+jflpaGeEyvHHVo5iqUpOUg059Nef+AUVInGNkV8ZNKSf78Hux
         SWocVd8P0GRTgpqSfTIELBDfalImeDC2H/XMTgb4YbVrsJjv685uNOkMxyfoU1yimPiw
         hPvLQlfSSS6M/oe/DJAx3PDDtc7bstTZN1KFMGHQQNKRDwExOmS17gTtLEjl6uESV9WU
         EInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763500285; x=1764105085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPhkAuWM2DyUy/YU4ZRQNyTfFr9mrQ9L/0ysPca6Z6s=;
        b=hNOoZRagTmT5b6lKScGeAGsL8DQOoPBTa+qusRfGlo/FrEtVq5DDTB8s3Bdo+km/7c
         6uuKntkfid/iAfOMHv03lHRk33UMhxYv/XrxnfqXxmLPcbtDlJR62kUOfL6qebe7lVBw
         hgrEWDId0SJsXk/5HRLuV0jQLgxTeq46YsMrHW7+6Y0Q47LWk4cnsZlnxPYzhYe+cd7a
         qLWGNrSyhzu27YAbP/5e9hqC9UB6Ubsto+eJ1vvnAr69qqHvdEHBYpn6m9gVHL3NKpL0
         zhBpBnGW35xGqgQaZpLBdQBDs/gtJVugvDZLuIqzl2O2d0ctK46MFwYVqha36kcTI9Qv
         47zw==
X-Forwarded-Encrypted: i=1; AJvYcCUCyU12aSDlGOwWo1VWKv3hfXIbmucqgqFMGaIWOVok8o1Kfqlx1c0BSdms1TbjGq0eyUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhQKI/RHLm9lLcr88irs0h1Q/kqjeTSWMz3XDs/E0bc/7fpx0N
	k/j5+oMAIieWlHa4Oi4lio+tpNdKGeGQAsyb7C2ZOEqnRkwB0tmPW7HSxmh0DT99Kx8BgW94PfX
	UMpcy
X-Gm-Gg: ASbGncuoi7ieMfMpUiv6WyJu8TmBqVelkgnDy8D24TDoXai/R0KJ0DQHwLUzvH6Zzxx
	oMR9av2e3Z+211FtY0AmeK+0VK9vj2e3VKunpifP0JGYFTHKMZyiWxdaIQcuhEzxNLlaRbsYLYw
	Ib8Nmgc00wduiUrGzAsbE4xKaO3Taq4oGekwbtkisAcUS1NRO5EA8BSzLkSl4MVLOeYZZYh4wN7
	JimRUl6G/MFnP5YcvW4mrL50TX4uhpropvIsUjzXxnf+2M9YHusbLda1HzFZOffDhnqAFLGggSB
	Mn7grKiMwQwkrs5SSMVDtqboAjVOxTaGSLDyJPmjpJ+LS0sGzM7bIsvU8gEyUrLphzDAFnXyOoU
	Hefv2as0gsT9rJwOB0sAEJI3GhbZrg80CegY4KquasjII0JE1eNPuAU9dlij22ySPH260i6IM1O
	ESPD11YRdN8I6Y8mQs3k3eHLFH
X-Google-Smtp-Source: AGHT+IELA9r6q5kdbx6peemr00Z0mlb6MvpgDp9N3DmezNpflw+yIcsIM0kJbrnokxRLUwzU+MQ46w==
X-Received: by 2002:a17:90b:33ca:b0:343:6a63:85d1 with SMTP id 98e67ed59e1d1-345af40a7b6mr2818253a91.6.1763500285190;
        Tue, 18 Nov 2025 13:11:25 -0800 (PST)
Received: from telecaster ([2601:602:9200:4a00::ec1a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345bbfc8eefsm391513a91.4.2025.11.18.13.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 13:11:24 -0800 (PST)
Date: Tue, 18 Nov 2025 13:11:23 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Subject: Re: [PATCH v3] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
Message-ID: <aRzg-3XWu7nM5yWS@telecaster>
References: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>

On Tue, Nov 04, 2025 at 09:55:26AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
> instruction, discard the exception and retry the instruction if the code
> stream is changed (e.g. by a different vCPU) between when the CPU
> executes the instruction and when KVM decodes the instruction to get the
> next RIP.
> 
> As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
> INT3/INTO instead of retrying the instruction"), failure to verify that
> the correct INTn instruction was decoded can effectively clobber guest
> state due to decoding the wrong instruction and thus specifying the
> wrong next RIP.
> 
> The bug most often manifests as "Oops: int3" panics on static branch
> checks in Linux guests.  Enabling or disabling a static branch in Linux
> uses the kernel's "text poke" code patching mechanism.  To modify code
> while other CPUs may be executing that code, Linux (temporarily)
> replaces the first byte of the original instruction with an int3 (opcode
> 0xcc), then patches in the new code stream except for the first byte,
> and finally replaces the int3 with the first byte of the new code
> stream.  If a CPU hits the int3, i.e. executes the code while it's being
> modified, then the guest kernel must look up the RIP to determine how to
> handle the #BP, e.g. by emulating the new instruction.  If the RIP is
> incorrect, then this lookup fails and the guest kernel panics.
> 
> The bug reproduces almost instantly by hacking the guest kernel to
> repeatedly check a static branch[1] while running a drgn script[2] on
> the host to constantly swap out the memory containing the guest's TSS.
> 
> [1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
> [2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b
> 
> Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> Cc: stable@vger.kernel.org
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Changes from v2 (https://lore.kernel.org/all/6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com/):
> 
> - Fixed EMULTYPE_SET_SOFT_INT_VECTOR -> EMULTYPE_GET_SOFT_INT_VECTOR
>   typo.
> - Added explicit u32 cast to EMULTYPE_SET_SOFT_INT_VECTOR to make it
>   clear that it won't overflow.
> - Rebased on Linus's tree as of c9cfc122f03711a5124b4aafab3211cf4d35a2ac.
> 
>  arch/x86/include/asm/kvm_host.h |  9 +++++++++
>  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
>  arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
>  3 files changed, 43 insertions(+), 11 deletions(-)

Ping, does this need any more updates?

Thank you,
Omar

