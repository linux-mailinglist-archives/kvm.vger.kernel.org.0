Return-Path: <kvm+bounces-12040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D0487F371
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ABD7282AD3
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1E15B210;
	Mon, 18 Mar 2024 22:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ERpHChNg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829655A7BF
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802732; cv=none; b=M3Y4fazvjSY+oKpDXJx1TahO1O0/RlzUKE9CgFEncE0UKo0BxtvkPGzWtciNMHKiOlB/EF1NsJx9Xhj+rjqA7hOt6ruT7bVUfgmYoKrUE35/t0SS8Oq0hmqNAN0oCpzgtJq/dYYjK0rRVbPAs84UiGrxHpIatIafkvGmjGT74CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802732; c=relaxed/simple;
	bh=XpG2kSRofAl3NkOaIeuLvJRqhwJ9TaXGDO0v2jaOGZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q+/ibkSNnRfDzsf/hkouemWihpvuLEhFdPce3sZzXJutXWFhOB8TN2lPQVeVId+++N+1nYw8qYjZ9oNbMCr0nCKwKs6KlP/To0Vsb+vOkfuXK3uJnXM2CLwxXg/RInhIwTN/H3yUCc1dQVP1TqVTS8q7qO7OzsrQQ5xJlBUU/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ERpHChNg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso3312779a12.2
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710802731; x=1711407531; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0sJMOtFGq7WkF8rVYfo/qr9MADE42xQ88HW95MgGMw8=;
        b=ERpHChNg8DUytQFfECbnUohdiK6rrJ+aDhfIDMF7fW0NTlLXslEzSP6xmONJfOgouh
         xh90p565kIgBZQS8TFt2ALlvP5ezfycuuBGBlfKsYLfLwcEVUu0YwMwFEoBGheDCwver
         zLMAAqtrKVlQdi35FQzPzFX/3rBGWg8DHcL/Mr6AOryKdW1xlmQa0qLmWIjTXP0vCJX9
         POPqmephQBDkSrFA3hoA6iJPZtqtJs0oqw0DIZfvCM6+zW+uaW5a/obc0L/D0lGC4EKY
         yd3XgRntYXpkncILe6vAgTKDaWrbhsrXAzejWHrTU/o9vVC5w92Auhs8Vo59wwJjoOTL
         JvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802731; x=1711407531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0sJMOtFGq7WkF8rVYfo/qr9MADE42xQ88HW95MgGMw8=;
        b=YiECIpV2VRHEDDX+HThgDIzrqvs5+zOXeAWrunblCarIbTMer1F9xv3x9mR1LEy9yu
         438kT+Q2SqjXDxHVBnaDEtuEbQBOWFElOvx4KKKh9Y0pJ8JVoNERUMT95fjmP1yvI4ZW
         0BXNNVTERfQQsU9BjXFGbe3kRl0JBAuqfjZ5nhxCq25mhht2eKodZlzGg57q07kX/71g
         IeMIYU7XD0iA9uLL56IhHr5qfQvWmtlr6MsTBEsMU+DQAPs1XZdgbbpzzaRvsJDV+6CC
         U7+fLu+Ilsvd29oyyDTqjJi4earMGh07DGMORR/1Odg2o6eDSD2zCd13nb+XnsFu1Gdw
         aF/g==
X-Forwarded-Encrypted: i=1; AJvYcCXpWSlqPfxIYnX1k7/e/KHeL11rBGTy5aZJmImg3ykQ0E64wwL7CTu7N8ycp/DFzn/7Hd6SggmrLgG/d2yBp+r8qT9j
X-Gm-Message-State: AOJu0YzRECzwfx0/RAQleIisgR4c6kybfoGFBU2I9IjM4GROxkFS9ydV
	RmOHmVp91yF8imbGWUL2iiL6t5YnEpFXP0mfjHCfxjl+9XpFe4FpzapvrI+7L+9z++4thnLv8Aj
	ADw==
X-Google-Smtp-Source: AGHT+IFngwIyErUsM4r9Kqyfs0aknFLxhEci+pydGzsloeh1G6wncRzgE3yzA2vPrEWmTDMy5X92pZcBpzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4546:0:b0:5e8:3853:d260 with SMTP id
 x6-20020a654546000000b005e83853d260mr18547pgr.11.1710802730721; Mon, 18 Mar
 2024 15:58:50 -0700 (PDT)
Date: Mon, 18 Mar 2024 15:58:49 -0700
In-Reply-To: <20240318221002.2712738-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240318221002.2712738-1-pbonzini@redhat.com>
Message-ID: <ZfjHKdx3PNqQfkne@google.com>
Subject: Re: [PATCH 0/7] KVM: SEV fixes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 18, 2024, Paolo Bonzini wrote:
> A small bugfix and documentation extract of my SEV_INIT2 series, plus
> 4 patches from Ashish and Sean that I thought would be in the 6.9 pull
> requests.

Heh, they were in the 6.9 pull requests, but I sent the SVM PR early[1].  Looks
like another small PR for an async #PF ABI cleanup[2] got missed too.

[1] https://lore.kernel.org/all/20240227192451.3792233-1-seanjc@google.com
[2] https://lore.kernel.org/all/20240223211621.3348855-3-seanjc@google.com

