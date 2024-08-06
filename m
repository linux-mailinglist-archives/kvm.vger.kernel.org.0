Return-Path: <kvm+bounces-23401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53C8A949538
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83EEF1C2267A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24CB6BFC7;
	Tue,  6 Aug 2024 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="elOECrkR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899785B1FB
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 16:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722960195; cv=none; b=r2AkQlM6tjgv4EcQAwU1S8LET2C3Bt80/K4XskDAOdSKgoFb9+YDJnnZmKvXv8Zq+Mj1ft728wKkG6Z7+E90asiU4KlId1JZkFM+BvaFTxpW+MKNMRwOasSrJlrTzkFedK/wcdO4q4P5ImMHBOB6QryTqJ5hSXa/UD/e83/2ePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722960195; c=relaxed/simple;
	bh=43yeeiIiZFKYpAy3bcKhNqjIFKXSyZwk1IBrH5PPY1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q4vvsgX39P3HCj+y2rjbdmuqNTyirC3jVoFZNbDn+lqUHbbCayPWO2Z5DR7edhwwuuqK1Nwk7brOJ8jkOByxz24gGBQZ7GKoZgBozoJFRmQgE7Z/YfswPJZYZKXaCqDQ+0TPS6MGi56K6zLD1LH4nWUQ0nOp3e0/+Sy8aG0wPNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=elOECrkR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso803926a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 09:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722960193; x=1723564993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5x970cBb4Gt09saGc7/5e2TfD9MZRQZ7bFJIpYheVN4=;
        b=elOECrkRjDemFrJEJWFRBH2KI06GL/E13C7g6c54cPjx3RHGqoZJUZ48twEmWEEa2r
         nDBg91ZMjAIrOhwbuojM67Uv+1JTnS5hwiU6TvmJs9uDQCagTebJE6J4ggBN9QxzzvBv
         nHymWBTEtdKvvo6L9fKUbqK7GoSF679YBT6ou6JwxtWrPUfW1rJMuZaekMT52iO9PE4d
         UfcQsKJlkk/QYsNtSl8Y5m+j2TMLZSsgavp5edMrgRQy1zx12GfxJaI32AjiSoC/+vyQ
         xvruFyyClC03nNm2LgIKK6E1itG148EaBzKw6T8F+ijl/CgKve7sIFXIoIJzb8rNwC/W
         U2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722960193; x=1723564993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5x970cBb4Gt09saGc7/5e2TfD9MZRQZ7bFJIpYheVN4=;
        b=traN1hsYyt9CEr5v673UcJhIiF2iFtqfpHLqGTkCCggF+Iu8u7yQB5lPl+ErK+PvzK
         x19RDVTTQzL18+tei2p4ERJlTAF7xaFC6GEIlu15tXGR8kKn7RndYRUTJZSicL4DGsWR
         aoAaH4Dp4a0nlSConL5BKjcG6BujsbFq/d2eP+XjGVjR8d+i7+c0IOuAyTuT8LZczQyl
         p3GMi5S4zx4LVQcG5HVzS0p/M0peJHrglZq9TwH1PsMX9Fl/C1xhdjGxkm56UfVJZVCq
         aLoKwkXk6I78/WnkIGD8PL0hO8FtwfSw93uE08MbfXQ+4qyhtRfjmwGrECbr0rbLLjO2
         VMRA==
X-Forwarded-Encrypted: i=1; AJvYcCWYDNPqbHANpA7J7w8trNvzYQx6hIgs5Bc6Bc0cV8wDCPI06mc2sNgAY10cD1V96U+4Gqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWZvlzjxZWy8o7deqMPiJPc1m9JyvO0tr1G/j/hu7ROIIvtfJN
	1fwsEuLYOIW7pWohxEJ0/gxl1mi4WWNNeeYyW3VkTb+tG1rT9a0UDfjucys3q/42aVxIA1fpTZa
	PEA==
X-Google-Smtp-Source: AGHT+IHTNuWpWRY7BmO0c2MHuby8OLeZt8sdzczcLTmrzOtwuDa67oo9Qld+B40ZFlCG/uXjMK+8QCqiZS4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3dcd:0:b0:7a1:6a6b:4a5b with SMTP id
 41be03b00d2f7-7b6beb104e9mr41173a12.2.1722960192610; Tue, 06 Aug 2024
 09:03:12 -0700 (PDT)
Date: Tue, 6 Aug 2024 09:03:11 -0700
In-Reply-To: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
Message-ID: <ZrJJPwX-1YjichNB@google.com>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on SPR/EMR
From: Sean Christopherson <seanjc@google.com>
To: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc: chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, vkuznets@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jon@nutanix.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 06, 2024, Eiichi Tsukata wrote:
> Running multiple Windows VMs with VP Assis and APICv causes KVM internal
> error on Spapphire Rpaids and Emerald Rapids as is reported in [1].
> Here Qemu outputs:
> 
>   KVM internal error. Suberror: 3
>   extra data[0]: 0x000000008000002f
>   extra data[1]: 0x0000000000000020
>   extra data[2]: 0x0000000000000582
>   extra data[3]: 0x0000000000000006
>   RAX=0000000000000000 RBX=0000000000000000 RCX=0000000040000070
>   RDX=0000000000000000
>   RSI=fffffa8001e3db60 RDI=fffffa8002bc8aa0 RBP=fffff88005a91670
>   RSP=fffff88005a915c8
>   R8 =0000000000000009 R9 =000000000000000b R10=fffff8000264b000
>   R11=fffff88005a91750
>   R12=fffff88002e40180 R13=fffffa8001e3dc68 R14=fffffa8001e3dc68
>   R15=0000000000000002
>   RIP=fffff8000271722c RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>   ES =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>   CS =0010 0000000000000000 00000000 00209b00 DPL=0 CS64 [-RA]
>   SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>   DS =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>   FS =0053 00000000fff9a000 00007c00 0040f300 DPL=3 DS   [-WA]
>   GS =002b fffff88002e40000 ffffffff 00c0f300 DPL=3 DS   [-WA]
>   LDT=0000 0000000000000000 ffffffff 00c00000
>   TR =0040 fffff88002e44ec0 00000067 00008b00 DPL=0 TSS64-busy
>   GDT=     fffff88002e4b4c0 0000007f
>   IDT=     fffff88002e4b540 00000fff
>   CR0=80050031 CR2=00000000002e408e CR3=000000001c6f5000 CR4=000406f8
>   DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>   DR3=0000000000000000
>   DR6=00000000fffe07f0 DR7=0000000000000400
>   EFER=0000000000000d01
>   Code=25 a8 4b 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30
>   5a 58 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 cc cc cc cc cc cc
>   66 66 0f 1f
> 
> As is noted in [1], this issue is considered to be a microcode issue
> specific to SPR/EMR.

I don't think we can claim that without a more explicit statement from Intel.
And I would really like Intel to clarify exactly what is going on, so that (a)
it can be properly documented and (b) we can implement a precise, targeted
workaround in KVM.

Chao?

> Disable APICv when guest tries to enable VP Assist page only when it's
> running on those problematic CPU models.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218267 [1]
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---

