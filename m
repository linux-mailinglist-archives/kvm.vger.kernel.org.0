Return-Path: <kvm+bounces-43110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDABA84F7A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AFE19C2D5A
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2519720F063;
	Thu, 10 Apr 2025 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="buw4eI0E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1051E47B7
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744322679; cv=none; b=S1Gn+sMIQrd6Wa7NZX3dSNQZoNj7AZIAfjgszf3VCZvY3Qid0z3uf6D5lRO6Buwa6arz0FoNdEbawlZu8vsz7VAn1000Z1Vd11xicxtN91SBRR2KCZAPj11pQERBdLw2LzhPmw26udiWLHteY9OUGF0xwXJeReeRSnusE6C7r04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744322679; c=relaxed/simple;
	bh=3uMBL4NPv3raozz5zKjQqEnw2j9SO97i6WwFa10I4Pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tu1reDUJvHR9PvDlClEVx5h0aAF5sfrA85o/IzJ6UlSyWZ4YBoJGHRGO9S/5FirvZuBLGCJX+vnBLUE1Qm+KAgb5pefYOMRzvd5RrkBW+GWxmTtguUmWQUesfuzypCUryuHDysRdOqvTUCf290CzsqKPCOeefxPpXZveiGgFYco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=buw4eI0E; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2265a09dbfcso20089835ad.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744322676; x=1744927476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7eShhCni2AeN9U5Jc2b4WOHTyOiv0aqWO9tX2xSw/mU=;
        b=buw4eI0Ew8YyxYMlNAw2MV0sDnSI9Jt4cME7hQ7K6ri8ObB78VB2nPmP8AEUifrX5Q
         y8I3j/isiLBhVq0GGAfoozJQ8fyS+o87LIV3f5g0AUSu9X/rSBh8ax2cqoSz+kXECdvB
         skYi+omBcOZKf+gAC3CsA1XlURcw3wCxBb67HMZGL67kZgWI6wg2WyZPVsYXHUZupmej
         D2lRthryU/drznbrggBKdcmCj+q8pCgkmKiH8h+BaQ+1mP3renvwzQszGk9YEoho4Kwj
         bF8Zx/EMcZ2IaPRoG/PBvYbIuKs2aZpnVwMFdtd1tXcEQ1W7DKiDPPYT4wfENJLAd/Qd
         nnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744322676; x=1744927476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7eShhCni2AeN9U5Jc2b4WOHTyOiv0aqWO9tX2xSw/mU=;
        b=YrKzsqZe3uk05YdCyHBS20ev+ikqKyfRGd3y6vE/fG2b3lePCIc2whM3eKt2HKfYfw
         MnhhoUNkK93onE5MkFtd8DTmh45B6nZKCzbZG9bYywQFXrNzfVeDd7JwpNfc55bzceXr
         aS/yCOG262DZ5N/GU3wlCtGgxcsrqO4p2Bkxa1tHb4oiSpDiMCDcov4bm8BFj6dqyGoj
         BhP/QkXZ8tweATc1ujKuGsR0XIzCSBf/cntw8bUkp+Ep9eP88Bp53VkUv/ft/Rz1DZ92
         RMkg+f/v8XuH8NkyskfqXhP80coD2ETz6lCBXF5Plt4/HqMSGh36Xcv5b5/gSJNXDHRV
         5FuA==
X-Forwarded-Encrypted: i=1; AJvYcCVaoDO8bKvyye0QGX3jmg72Oi4mHr0c29hjiqUmLoip7x5Wk+j3LmenGODuA4wSgmF/CZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwicGL+5x8pQ4MKc8OiCxcZYgv1Gl5oQ73NQmRg3TbamBOLp01t
	92TT6JwjC783vjc8lhU6m00lSjqZ1HmyQE93YYLwULqwh3fowZIXdfbHtQdJPvhLvD+DqJJr/3K
	+1Q==
X-Google-Smtp-Source: AGHT+IE/nhiyEmsRhP2rb2VCXmUB28XKf+JD6SxynR/MURcWw+q3szzXjCCZ52+kyzlA5ipAqMNlMQqrrE8=
X-Received: from pltj8.prod.google.com ([2002:a17:902:76c8:b0:223:3f96:a29c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d481:b0:220:f59b:6e6
 with SMTP id d9443c01a7336-22bea495687mr4890535ad.8.1744322676625; Thu, 10
 Apr 2025 15:04:36 -0700 (PDT)
Date: Thu, 10 Apr 2025 15:04:35 -0700
In-Reply-To: <20250410152846.184e174f.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404211449.1443336-1-seanjc@google.com> <20250404211449.1443336-4-seanjc@google.com>
 <20250410152846.184e174f.alex.williamson@redhat.com>
Message-ID: <Z_hAc3rfMhlyQ9zd@google.com>
Subject: Re: [PATCH 3/7] irqbypass: Take ownership of producer/consumer token tracking
From: Sean Christopherson <seanjc@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Alex Williamson wrote:
> On Fri,  4 Apr 2025 14:14:45 -0700
> Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> > index 9bdb2a781841..379725b9a003 100644
> > --- a/include/linux/irqbypass.h
> > +++ b/include/linux/irqbypass.h
> > @@ -10,6 +10,7 @@
> >  
> >  #include <linux/list.h>
> >  
> > +struct eventfd_ctx;
> >  struct irq_bypass_consumer;
> >  
> >  /*
> > @@ -18,20 +19,20 @@ struct irq_bypass_consumer;
> >   * The IRQ bypass manager is a simple set of lists and callbacks that allows
> >   * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
> >   * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
> > - * via a shared token (ex. eventfd_ctx).  Producers and consumers register
> > - * independently.  When a token match is found, the optional @stop callback
> > - * will be called for each participant.  The pair will then be connected via
> > - * the @add_* callbacks, and finally the optional @start callback will allow
> > - * any final coordination.  When either participant is unregistered, the
> > - * process is repeated using the @del_* callbacks in place of the @add_*
> > - * callbacks.  Match tokens must be unique per producer/consumer, 1:N pairings
> > - * are not supported.
> > + * via a shared eventfd_ctx).  Producers and consumers register independently.
> > + * When a producer and consumer are paired, i.e. a token match is found, the
> > + * optional @stop callback will be called for each participant.  The pair will
> > + * then be connected via the @add_* callbacks, and finally the optional @start
> > + * callback will allow any final coordination.  When either participant is
> > + * unregistered, the process is repeated using the @del_* callbacks in place of
> > + * the @add_* callbacks.  Match tokens must be unique per producer/consumer,
> > + * 1:N pairings are not supported.
> >   */
> >  
> >  /**
> >   * struct irq_bypass_producer - IRQ bypass producer definition
> >   * @node: IRQ bypass manager private list management
> > - * @token: opaque token to match between producer and consumer (non-NULL)
> > + * @token: IRQ bypass manage private token to match producers and consumers
> 
> The "token" terminology seems a little out of place after all is said
> and done in this series.  

Ugh, yeah, good point.  I don't know why I left it as "token".

> Should it just be an "index" in anticipation of the usage with xarray and
> changed to an unsigned long?  Or at least s/token/eventfd/ and changed to an
> eventfd_ctx pointer?

My strong vote is for "struct eventfd_ctx *eventfd;"

