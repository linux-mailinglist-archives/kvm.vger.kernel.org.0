Return-Path: <kvm+bounces-8237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3708A84CDF5
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3543B26002
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06687F7FF;
	Wed,  7 Feb 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pzeLMjQ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AED7F46D
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319607; cv=none; b=iZLGtp1+DK0mDy4Og04wIcbArMUhGl3IkQpLd/BJdS68/4Oj1bqEgi1Zuon5IerS4yjMmC+n8QvIU2NvSjEcqKNOvr4jtrGNDIVt8JLwAVDmrdhAlhp9l8uMMaUgdQWlMuwbP4arGUiuXw8639dompTL8/VmT3jEUgmLNesyto0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319607; c=relaxed/simple;
	bh=nBf9bw3jxqBF5jqhtpbO9vc/13Y/GXDtSQyt+7JsL4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G1+UJ+Gpe8/cEfo1plmiqtrBvkoT3yGa6RXhaSLjPx7LrPqgK8aR3bHoO71U6yk6zDOSfUfxn5f4vQHV51xbxNbHU7upJctpCUWT9b/M8B4KwrH1l44kZoETYPwZZx8QIPP+JYOYWCL4SF0zWt9xD16CfhWLQmj7alrC2wqaKxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pzeLMjQ/; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60482420605so11227077b3.3
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319604; x=1707924404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IrStt23DMMWYh0ENRShJKd9wb4dk+ZyCGtr69LJbA0I=;
        b=pzeLMjQ/OBW9+7aCDunyAB0Yj8UcIfJ//apjG04vWrKKJpgvX/WMJIbI0hJMQU69Ch
         TaaDFCRXBbzOJnVuw++QnER/wca53XlbLgHccJuDtIyW2pb3jnQafRM/g4wK1es1lp6p
         kRkUCNKtcX6OBk45zcBnhUjn2noEfGML9uHeqpNHTkUPa8xXZnyoUW9c/994tAq/85Ip
         K0gF/Is7cyMMgBPrtel72XoUB+pTAga7mbXn2TtB3v/2HaEZcVhHKCf8tqr2qHG7ATKq
         sxsEn6Ba0hwnuDjqO3Chf7tRoyfU5kB4tbpLd0Q5MlJ4hf0FFBqlv21wMrayGcv65Qsy
         sGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319604; x=1707924404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrStt23DMMWYh0ENRShJKd9wb4dk+ZyCGtr69LJbA0I=;
        b=UPzGhBO3gsahUHzzmI0Qe+WGJwCW4j0dXEozgYVirGl0RCGq9ZgeKX7o6FB0ZGk3ZH
         q1lR1Xh9yYtWpQjYIoFTxAiLyQw/TmJZLVrP91BOrKjPbSsIb+ABnNtA2WylQpUgGyog
         Zof3ZD153C2vmRWxhN4Hwd/uT6ZtZrZ3Vd6yCVbY93ZVvMf0c5MwBUjJSW82aidCaz2u
         +vrKO82oHCUGsWid8CyRub8jU2nEr4Dc+qn/vguH5H3hXHSEe6jd2smksBO1m2lgK17z
         K5VlKM+iMaMy754sbI98aISB/nQ59QcgwoAhZiPDoXYpFZsRS6K0sedhiN2uy5Ib6dxU
         x6Ag==
X-Gm-Message-State: AOJu0YwThczN+N95ZEaTFjyWATtcmffXHTgXqK8/ewUWwrgFeXfRyNDe
	uTxNQH3A7fImsRP6juHed5sfS4mRuSlyFeNGvkIZKkBUh/ObEXXi2Sp/9WBEZrlCFsjkU7nt6TU
	FQQ==
X-Google-Smtp-Source: AGHT+IEprpVLHFnvzBSR1ktlp4D+f+yjpL3NKCZ0oafSWw9HVwyAwVcOgf6rQxEKnnysFCmQ3AbY38khA0s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9b87:0:b0:604:a0e:f659 with SMTP id
 s129-20020a819b87000000b006040a0ef659mr878219ywg.6.1707319604705; Wed, 07 Feb
 2024 07:26:44 -0800 (PST)
Date: Wed, 7 Feb 2024 07:26:43 -0800
In-Reply-To: <20231109210325.3806151-2-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-2-amoorthy@google.com>
Message-ID: <ZcOhM5wPguyNC0j5@google.com>
Subject: Re: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

This is not a Documentation change.  The comment might make its way to generated
docs, but this is not Documentation/ and I most definitely did not expect a change
to kvm_main.c based on the scope.

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> The current docstring can be read as "atomic -> allowed to sleep," when
> in fact the intended statement is "atomic -> NOT allowed to sleep." Make
> that clearer in the docstring.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9170a61ea99f..687374138cfd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2983,7 +2983,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>  /*
>   * Pin guest page in memory and return its pfn.
>   * @addr: host virtual address which maps memory to the guest
> - * @atomic: whether this function can sleep
> + * @atomic: whether this function is forbidden from sleeping
>   * @interruptible: whether the process can be interrupted by non-fatal signals
>   * @async: whether this function need to wait IO complete if the
>   *         host page is not in the memory
> -- 
> 2.42.0.869.gea05f2083d-goog
> 

