Return-Path: <kvm+bounces-59795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F88BCEADA
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 00:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 968EF4F4F68
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 22:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B388527146A;
	Fri, 10 Oct 2025 22:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wvcq7pVB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9705E26B97E
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 22:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760134312; cv=none; b=f6DYEsiA3+UBpLlOs7Fa+AjSiCAXv8LT0So8x+0J9exyIw+gspSC6gvWi6cvD25uHA87o79fSPcqsRvp0GL+KZ1WWPjP0aEZ9vofKZQOa1+lkDa4U9+XOr+NDAaAEvf2/8f7CySSBTVJo1SphpUPDM3XWGjTVsxeLMFXQH65MjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760134312; c=relaxed/simple;
	bh=OvwE6536qJTPNbEdVMU8lrBXHJm3oc58O4QL6qpjGlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PgGH6HzRYn1qRxX/AC9e1uelatgfSn8Mv40yZDZD9UyYk5Wy2miprwK85Z2/WZz0tDxAzyRWZxhM7K3v7aVyUVcP0KwQoal0NERV8G5j6hQpfyaWVFgMWboJfjvnHQVWAGR5BWiXYadDv1+R1QHwpnDjgJXtEugkKph4RNR4Z+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wvcq7pVB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57c2371182so6114348a12.1
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760134311; x=1760739111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsGM3Vvqi7Jw7i+T3f4D5/+jU4naDXyzda2rNALXGHk=;
        b=wvcq7pVBE28ccIsZksQXypsPRyBqUehvzxGhsiryXlWUYyHtzXf29cPHsvSLX8haIA
         vUEA/S/SwwO6ARzcqkgMEztDIfDljOFUKwJJYCfb+/qRzR9SrIBPcZhXH1AMVOtWUslF
         hclxL/k8agVytTYI6Gt43AwJmhL/us8uwuR3B4Wi1eZ8NkWYf0jnh/LhNUyQPxFWuVFj
         d0t//CHzhnAJK+mw7mcHpLNdgUDxx9mjLWZkEUamXKbRA5kTb1Iu/U5Z3cIUPJFvIQCy
         QgIZW3T/MJ4lCeoUpxg3A6cIeuttqUCNNbn5On9Wy0xvw1lVyffIwibjeBKFUC0aNnKD
         zDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134311; x=1760739111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsGM3Vvqi7Jw7i+T3f4D5/+jU4naDXyzda2rNALXGHk=;
        b=mAVIK1dWuDI4O/cIutdRn73zQOj6Z1hs3jhZpncgLnr68qjpgkjYc6q2Nr4xjlYEOl
         k07+vJIgGbHerxvnsG8fwSfjdlz8kabC7TMH8kH1ZubZNPz9hxPT81kYzwwv6TzhBKuW
         pBoxuZFXSK7wcttPXkzec0GhhhD87C5jy6U+6hIYys+y35BpCw5w0foGk1P/VSztGFP9
         3gbQIBif+ecchxIbizS0kJCYWsRUy5OBiCC1cZC/gA6X0EIIGQGxCVd3Wv438oGQUDjs
         GVjvyDuRqtMZ3NUp/+3dhmycTnSIHAOBmku3oo/cogowGiW6OkxzCtDuOhlWwAVBg3Xd
         IGOA==
X-Forwarded-Encrypted: i=1; AJvYcCU4fjCRWR9mkzgBEVEljbfyK8lMrf7/9HrVXu/RmvARp26Afj0stJkTruzGR4CMV4mq9b4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQvOeEEKanqaGsbUQVbmLiEmFysa9/lxMG0CAJktPmjuPgTWgd
	HFOEh/9+XqJDgxkSs/mcNWVCj6lxM/QQeKeS4jygRX1rVJCxQRS8bg4frIl6Nrj/AjEZfORx6zA
	QAugOhw==
X-Google-Smtp-Source: AGHT+IFenC+Mrk91YZKniRHtOPi6sCMsCmTjdEzSwur6Lz9eCcJ6uSs2AJYWWqNdymTHXhX3NPlq6N0kfX0=
X-Received: from pjbbx22.prod.google.com ([2002:a17:90a:f496:b0:330:a006:a384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d05:b0:32e:96b1:fb70
 with SMTP id 98e67ed59e1d1-33b51118904mr19833208a91.12.1760134310888; Fri, 10
 Oct 2025 15:11:50 -0700 (PDT)
Date: Fri, 10 Oct 2025 15:11:49 -0700
In-Reply-To: <diqza51zhc4m.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007222733.349460-1-seanjc@google.com> <diqza51zhc4m.fsf@google.com>
Message-ID: <aOmEpZw7DXnuu--l@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 09, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Drop the local "int err" that's buried in the middle guest_memfd's user
> > fault handler to avoid the potential for variable shadowing, e.g. if an
> > "err" variable were also declared at function scope.
> >
> 
> Is the takeaway here that the variable name "err", if used, should be
> defined at function scope?

Generally speaking, for generic variables like "err", "r", and "ret", yes, because
the danger of shadowing is high, while the odds of _wanting_ to contain a return
code are low.

But as a broad rule, there's simply no "right" answer other than "it depends".
As Paolo put it, damned if you do, damned if you don't.  See this thread for more:

https://lore.kernel.org/all/YZL1ZiKQVRQd8rZi@google.com

> IOW, would this code have been okay if any other variable name were
> used, like if err_folio were used instead of err?

Probably not?  Because that has it's own problems.  E.g. then you can end up
introducing bugs like this:

	int err;

	err = blah();
	if (err)
		goto fault_err;

        folio = kvm_gmem_get_folio(inode, vmf->pgoff);
        if (IS_ERR(folio)) {
		int folio_err = PTR_ERR(folio);

		if (folio_err == -EAGAIN)
                        return VM_FAULT_RETRY;

		goto fault_err;
        }

	...

fault_err:
	return vmf_error(err);

