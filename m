Return-Path: <kvm+bounces-33895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF4F9F3F45
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6371890C57
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEE82557A;
	Tue, 17 Dec 2024 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nUAQSvwk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303D71DA53
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 00:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734396083; cv=none; b=dKHUeFNt0CnM48ZUEFVT63ylNGn2BLmLHjqhyDE/lTTdM7HVPYT0veHaashn/nliokfH+mcihaRVXbCLuYbr51AZGcZ2Abt88d/yvtVuTAWrY+3rVtGBqTgn3xoBXfR1fofhojuet9/RM7pbaZ3cTV7JVwGdFcmCiSxdqGigS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734396083; c=relaxed/simple;
	bh=TIrEvm9eCLPEeAmjEw4NIDu5yd1DyCHtbm9pQstqZTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gb7fqvxib4fUmUirRzMenWFaHzYdChCKUAaZhvqmIZj0+NW20Vl81xN+//D9RgulWjzaOu0g4TC0yJkvIRy/fnpw48k6k+IKMfUu2duW4PGV1nEydzZn0J8xa2al+PWSkd+eBKW+YoX5w35BrdVuDAfcFrLK5AYYVLoumVejc9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nUAQSvwk; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fd3c241975so4681309a12.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 16:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734396081; x=1735000881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SVZE8ww7hlxXIAgiO38dFZnYzWTiCGe7yyX71jozgqI=;
        b=nUAQSvwkCU+gUPGff1wlDPXFx/C7latUyv0qU2QmnSrGivbCr98dFznHdTLnrfAqgW
         Ozu0pfBlHejPcgbj5VEbhsLcoN6eADcWhNt1M2nFJvTrCLINiBNJxw77K1oR/9C3+MCK
         IqMA88XQM2ikammbiRv6rKRZ/fd7DU3ZbEq5o9xLLtlKNzAnYhMRQltiiJN9irRVqFMy
         AiZSdxR1++HJOFQL/dYg+jhB7iepZUjxU/KZo5dKcmnsM6PLhhhRdVdP4MpL2lZLe03B
         pmMojhsJJokmEMpu5zrh2mrnSxVCac9p5tWJ1IKJHY30qtjkcjbsLeZNPVHd/LTsqdZQ
         YPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734396081; x=1735000881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVZE8ww7hlxXIAgiO38dFZnYzWTiCGe7yyX71jozgqI=;
        b=tAUlukGnyEJHjmu0wzs0zELrZIZ+53A+aRqGJit7B4CUXpw9fokYEt5uTYJEA2UwMp
         yC1ZvfC9SoecvS+Fp0meihDuuoI/MW+66hQwWsjCTz68RFe48i5aKU2BFqDm6i8+4Nju
         jsjtbWVBYmgmpL17+i083w0NZrQnIMQK0uYzgq8J6hTw4paqx5lAKEnBE3jujnAOq5dD
         AWBe8z3V9xpdR1/Pv7sQU6eO7bs29oTp+CnxmR/fMVaADv01AlZtgh39j6sNV7AAFFVj
         LnTzMAq1WyMIenap/qKT3AjBbUeZM2EPe9ZgxzjDwZX/bXj0TgWKt6Ex4Y9Iv/eIrTa3
         BklQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4fzIMwsInZ6CD2dq4D6Eq3r2+JQzAX/EDXlCsOpC7hQeuLYoIdc6n2768p1nkC2Xhxdw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7E7FLT2+5YiLqFkjDq02yC5mbCyPvqaYqW5NBjvAYegmMg//v
	oAxifpZO6w3Lzr0loIh5G5BBEaU4slUBKh6dmgpMaItXNQSdLXVzSs64Avf0W6A12fEM/ByqC4v
	HGQ==
X-Google-Smtp-Source: AGHT+IHW1a+Hg5MKGxBMSOoxx7zV4eOyFes0F4KwkjEBriafCpzRCcvlXIeQi9ilKpK0TbR6J7H3aIaPLiI=
X-Received: from pjf3.prod.google.com ([2002:a17:90b:3f03:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c105:b0:2ee:5c9b:35c0
 with SMTP id 98e67ed59e1d1-2f2d880e0bemr2010019a91.9.1734396081493; Mon, 16
 Dec 2024 16:41:21 -0800 (PST)
Date: Mon, 16 Dec 2024 16:41:19 -0800
In-Reply-To: <20241206221257.7167-2-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241206221257.7167-1-huibo.wang@amd.com> <20241206221257.7167-2-huibo.wang@amd.com>
Message-ID: <Z2DIrxpwg1dUdm3y@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Convert plain error code numbers to defines
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Dhaval Giani <dhaval.giani@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 06, 2024, Melody Wang wrote:
> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
> 
> No functionality changed.
> 
> Signed-off-by: Melody Wang <huibo.wang@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>  arch/x86/kvm/svm/svm.c            |  2 +-
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 98726c2b04f8..01d4744e880a 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -209,6 +209,14 @@ struct snp_psc_desc {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/*
> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
> + * communicated back to the guest
> + */
> +#define GHCB_HV_RESP_SUCCESS		0

Somewhat of a nit, but I don't think "SUCCESS" is appropriate due to the bizarre
return codes for Page State Change (PSC) requests.  For unknown reasons (really,
why!?!?), PSC requests apparently always get back '0', but then put a bunch of
errors into SW_EXITINFO2, including cases that are clearly not "success".

FWIW, "no action" isn't much better, because it too directly conflicts with
the documentation for PSC:

  The page state change request was interrupted, retry the request.
                                                 ^^^^^^^^^^^^^^^^^
I'm all for having svm_vmgexit_success(), but I think the macro needs to be
NO_ACTION (even though it too is flawed), because I strongly suspect that patch 2
deliberately avoided SUCCESS in snp_handle_guest_req() and snp_complete_psc()
specifically because you knew SUCCESS would be misleading.

> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> +#define GHCB_HV_RESP_MALFORMED_INPUT	2

Where is '2' actually documented?  I looked all over the GHCB and the only ones
I can find are '0' and '1'.

  0x0000
    o No action requested by the hypervisor.
  0x0001
    o The hypervisor has requested an exception be issued

And again, somewhat of a nit, but PSC ruins all the fun once more, because it
quite clearly has multiple "malformed input" responses.  So if PSC can get rejected
with "bad input", why on earth would it not use GHCB_HV_RESP_MALFORMED_INPUT?

  o SW_EXITINFO2[31:0] == 0x00000001
    The page_state_change_header structure is not valid

  o SW_EXITINFO2[31:0] == 0x00000002
    The page_state_change_entry structure, identified by
    page_state_change_header.cur_entry, is not valid.

