Return-Path: <kvm+bounces-16298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFAB8B8579
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 08:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A2241F23B84
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 06:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C974C624;
	Wed,  1 May 2024 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajEg7ubJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2BB4AEC6
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 06:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714543293; cv=none; b=SPzdaYi0gTdJGYI0ocmUmjbDlq4ou/t6JVpOreBuroWE+a2t4Ehh2Fo9oZLwmS8KGvsTsoR084z5TXwHWZ66XYToFbI5qDFUToVSQnuMjXY820QOftcwXJEYVNxEsOFQM1/JNen92R30EaRdLyYpvSOMdBmbTAGSH2aG2d3RMZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714543293; c=relaxed/simple;
	bh=826e6puMm6zzTrxffD62gEQ3vdQCaEKJUlUGOq1Xpv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTQtAjtctQrfMxARKjLANuIEqy4g23DhmkvqSYpq+f4vcgy84vb5pFcdpAWaMQIgD7seR/YX9147dA1xWA16qk+tmqM4x6ommSeXbpYD86h1rJuZ44TKNmCDkWAC7h7MKvDjr0Fgr22grm6NJY7Znuu9cawQYY7KSLphKOxjcwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajEg7ubJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714543289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ACs9fP8UeUOFIH6gYeB8LpBxm1NZNbq1XOuqsdPyK04=;
	b=ajEg7ubJC1R8JoNBH/k+PrEQTuLplizrn5KCfr9FmJG5+4jYyjVSOHai6rZtuLQxJr8RJj
	Lcq7Z8NdnFpUfmFna1TYuY2t5qRSGRZQYtF/SvjjMgegQybcyA4J6FBiBXUATCjUZAwrP3
	eFwcSHi+di81pSsOeAPlRlzwQWAgHF8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-Aw4wx58oNJGIQUuucI5JZg-1; Wed, 01 May 2024 02:01:28 -0400
X-MC-Unique: Aw4wx58oNJGIQUuucI5JZg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a590fa4a117so134982866b.1
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 23:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714543286; x=1715148086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACs9fP8UeUOFIH6gYeB8LpBxm1NZNbq1XOuqsdPyK04=;
        b=OFrU1kfydkNBJZ3KuQ2G51RTu0bINa+L157drrmT+vPMH9/v/b0+NI1k3oaux3NBen
         B1hCfKVnfFr0yjp1A3w1JG/SHZWpi7+w1G1cCOgS3YtM+n0WJZxNkL69N+Q8fjL1qEe+
         8toMqB7U7VDnziBjI/ufkG+AX7tgYNYWOaXnQtaLpvHjauKSLG4No9lGpMeVYCZGl7I+
         2O13stMsLw2nYkxSKNiQn69TueokTySyHvb/OTeUiPRqQ9MVWkl4CkxkdAwcaUtXzYUA
         qDCNkHD2ffOruv9krDkrUbAj5zk92smFKgAT9ne/sR8x/AGq2JChT9p+O9Al3EXSq8hL
         c57g==
X-Forwarded-Encrypted: i=1; AJvYcCX1FikE9Wvfx4TTsNO0LBtKyVI9Pqdx0+HPdMUJMT3lxudhRw2yO+Bjf8NnHLN2DFw/lyw/MtzByZAdDBsbkMVe0Gyn
X-Gm-Message-State: AOJu0YwBuZkNZU46JJY5q5rMXWApWZPhaPGIr4oKIf42ArrMc9uIiXMQ
	Vb7Wj3+6WCY1zEAwlp3TKY3KTlu+cV4JDjg0pgv7u/ehVhiItivAwqOyHyjZ1xsv36wPjz/XQ0I
	uwKzDxXSxQswl1fSBb5GpuMB12wMM2mCFER0x8ompmaeEMnlmCw==
X-Received: by 2002:a17:906:e219:b0:a58:f186:192 with SMTP id gf25-20020a170906e21900b00a58f1860192mr1224411ejb.0.1714543286590;
        Tue, 30 Apr 2024 23:01:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSlMxEoUZ88OBzUnW9OSy6mbDeqVmGiKA+13uWDb7mOt6quE44mzfAWkhW9+s6sFw1/mZ2+A==
X-Received: by 2002:a17:906:e219:b0:a58:f186:192 with SMTP id gf25-20020a170906e21900b00a58f1860192mr1224363ejb.0.1714543285807;
        Tue, 30 Apr 2024 23:01:25 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:6a42:bb79:449b:3f0b:a228])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906249400b00a5910978816sm2187459ejb.121.2024.04.30.23.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 23:01:25 -0700 (PDT)
Date: Wed, 1 May 2024 02:01:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Mike Christie <michael.christie@oracle.com>,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
Message-ID: <20240501020057-mutt-send-email-mst@kernel.org>
References: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
 <20240501001544.1606-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501001544.1606-1-hdanton@sina.com>

On Wed, May 01, 2024 at 08:15:44AM +0800, Hillf Danton wrote:
> On Tue, Apr 30, 2024 at 11:23:04AM -0500, Mike Christie wrote:
> > On 4/30/24 8:05 AM, Edward Adam Davis wrote:
> > >  static int vhost_task_fn(void *data)
> > >  {
> > >  	struct vhost_task *vtsk = data;
> > > @@ -51,7 +51,7 @@ static int vhost_task_fn(void *data)
> > >  			schedule();
> > >  	}
> > >  
> > > -	mutex_lock(&vtsk->exit_mutex);
> > > +	mutex_lock(&exit_mutex);
> > >  	/*
> > >  	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
> > >  	 * When the vhost layer has called vhost_task_stop it's already stopped
> > > @@ -62,7 +62,7 @@ static int vhost_task_fn(void *data)
> > >  		vtsk->handle_sigkill(vtsk->data);
> > >  	}
> > >  	complete(&vtsk->exited);
> > > -	mutex_unlock(&vtsk->exit_mutex);
> > > +	mutex_unlock(&exit_mutex);
> > >  
> > 
> > Edward, thanks for the patch. I think though I just needed to swap the
> > order of the calls above.
> > 
> > Instead of:
> > 
> > complete(&vtsk->exited);
> > mutex_unlock(&vtsk->exit_mutex);
> > 
> > it should have been:
> > 
> > mutex_unlock(&vtsk->exit_mutex);
> > complete(&vtsk->exited);
> 
> JFYI Edward did it [1]
> 
> [1] https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/

and then it failed testing.

> > 
> > If my analysis is correct, then Michael do you want me to resubmit a
> > patch on top of your vhost branch or resubmit the entire patchset?


