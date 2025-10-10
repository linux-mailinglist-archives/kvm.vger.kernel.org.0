Return-Path: <kvm+bounces-59796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54748BCEB26
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 00:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05E523AAB6E
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 22:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF9527465C;
	Fri, 10 Oct 2025 22:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fv8sx2Qo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91C80604
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760135643; cv=none; b=h2MQs4GF/IEHqczg6rKk6tO8j5pxO67PT3WfV3s9mX59UNXTqiaPYmZ8+O6AowxE+UQAw170m4rAb/p9JmUMEJ6eJu5NUqmIKyGJ5ADNyf7MrEoPC+olFcacmAmMypae7dVgu5N6d6zhDlUo2Qa5Wj/yNkl6GHeO6VwvRYDivBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760135643; c=relaxed/simple;
	bh=I/cP/AoCDjjIwt2MtAJcP1otDSu5TbDmKw2vzr+vPcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3XjSlv9ShNz0Jf3hWWMOX+PdS8oyo2g4L3hB4SQ+6CMiRQVbeo0xL1RX/1WbBymDs9YmSGCzg/8JI1fAjw4VTC73h2NQDHzM5kSi5dLwCCs0DxEmjjk89u9adkA48ygRj1IUD7Kl07yQFtpNlPe6pWQTytQpimsxvuN1gK0O5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fv8sx2Qo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-268149e1c28so75745165ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760135641; x=1760740441; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxXT6Zb58W33V3XDCfganTpzZzUvadE/827Eg8uHBz0=;
        b=Fv8sx2QoEJcgZo0qO1GKlKzzSqL2Y9NFKRiqcD3Ey9XsgBgNLKCr41pYKrRwzzBb4J
         3VXoQyqehwsDziccGriCxavrfTWzs6A/+aoFrj+8OMcCOLgfJkkt1vDg/3hDwxJ+pK5S
         AYZIwvTupsQHV+lalpjslxDYRfHEqztwvc/19YmrLbINkZdJt1Hr7t8gVPVxqrwZByGY
         nU2SEfVypCp9Msw/x7OxrQtxx9waVaRSdKgsjH2oESzgkefNUDphabl7nX4+OzIQTirX
         soS0HwkKUbRg3XyGUW4FuOzDooD6by802rStVCSepZEyzHRGjs7+X/1K4mZZcRQlvQXS
         06IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760135641; x=1760740441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SxXT6Zb58W33V3XDCfganTpzZzUvadE/827Eg8uHBz0=;
        b=Sl+Vk2J22qmInrlXURTpv/QKeiHK4ScjNUh+nwiWQaVgoE0CyRsxDJBEmwqYQZP+DW
         7TR4vcbFb1loEYx/4ILbPLm6l/rlECqg06O9j7sReo3eDzPn91XsN3UJhbrkLXU5ddYp
         +tk0Bc13pK4OYGE2hl+jruoWP6Sqyn1C/je4dfcy8HZCeGZrOOOGEhduyxTp0rVE84m7
         CiOjwPJP1omLFLWhzT6ooyYKnRjQJ4FbmQgpX3eWWhHXWruBHHDuLeFqRrzJ3xSTzt36
         1RraW4vny6cw9USmFL/XYxMhnS3Zbm9Ma+H7pwuTKpZSEEWuR4iRIZMeJ6fiSG5SCpVe
         d9LA==
X-Forwarded-Encrypted: i=1; AJvYcCVlHAhUcTTLkmO26ZuAowY+pdXo+0abHriiBvABqMeIRAKdxc59fCZpWiWYKP9NIXp20GU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRTbI3dTPw3y9bpKUC0/QPTiCnfIEMRfywoNEQdGAyXo2hGtcl
	6CiI4N82z/r4Iw9o6fhPXz8s9Ea1xNWegWHzusQrf8gdKSo0FMhAXL3bzxwevpy4I+KfCWfbarm
	Y6Ahy3wWrw+KwXz6LcWrao4uIgw==
X-Google-Smtp-Source: AGHT+IEHEsB7HplgKyiQY18CC50MOfISsxalHVWSfMxRYomdKvktQFnfgJPyfQJLdMMBANaenW2wtgALNKQ1B+fF2Q==
X-Received: from pjto23.prod.google.com ([2002:a17:90a:c717:b0:33b:51fe:1a8b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1648:b0:32d:f352:f764 with SMTP id 98e67ed59e1d1-33b51105d58mr17850554a91.2.1760135641187;
 Fri, 10 Oct 2025 15:34:01 -0700 (PDT)
Date: Fri, 10 Oct 2025 15:33:59 -0700
In-Reply-To: <aOmEpZw7DXnuu--l@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007222733.349460-1-seanjc@google.com> <diqza51zhc4m.fsf@google.com>
 <aOmEpZw7DXnuu--l@google.com>
Message-ID: <diqzsefqfktk.fsf@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Oct 09, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > Drop the local "int err" that's buried in the middle guest_memfd's user
>> > fault handler to avoid the potential for variable shadowing, e.g. if an
>> > "err" variable were also declared at function scope.
>> >
>> 
>> Is the takeaway here that the variable name "err", if used, should be
>> defined at function scope?
>
> Generally speaking, for generic variables like "err", "r", and "ret", yes, because
> the danger of shadowing is high, while the odds of _wanting_ to contain a return
> code are low.
>
> But as a broad rule, there's simply no "right" answer other than "it depends".
> As Paolo put it, damned if you do, damned if you don't.  See this thread for more:
>
> https://lore.kernel.org/all/YZL1ZiKQVRQd8rZi@google.com
>
>> IOW, would this code have been okay if any other variable name were
>> used, like if err_folio were used instead of err?
>
> Probably not?  Because that has it's own problems.  E.g. then you can end up
> introducing bugs like this:
>
> 	int err;
>
> 	err = blah();
> 	if (err)
> 		goto fault_err;
>
>         folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>         if (IS_ERR(folio)) {
> 		int folio_err = PTR_ERR(folio);
>
> 		if (folio_err == -EAGAIN)
>                         return VM_FAULT_RETRY;
>
> 		goto fault_err;
>         }
>
> 	...
>
> fault_err:
> 	return vmf_error(err);

This is true too. Thanks, I see why it depends.

