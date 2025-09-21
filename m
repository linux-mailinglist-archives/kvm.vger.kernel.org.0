Return-Path: <kvm+bounces-58344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACEEB8E68B
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 23:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F32B2189A47E
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 21:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04352C2348;
	Sun, 21 Sep 2025 21:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fmbX3g0L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635CE23E334
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 21:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490816; cv=none; b=X9E7MDc78CRWVjoi4nJqxxgfuBU+wltMj+FY+5QfICVtkqxSNjYtrsHzql8MxMsZjZEOBeSkzf2uBc2LVrFD7xLyas1ayw7wtGm0Kz31rLxKz5y/4JbbDEK3B4bCI8/FVoMBy1w3THDS39A6lxdIkykn2SwN67NColJttAZnOik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490816; c=relaxed/simple;
	bh=mYlu1Cb8XJxVfGYYbOwNf+5SlCKDDhSJhlXNvH2HuoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8IEXj25llkALzb1Afq0biXEdDAbLKWbzcWgWPcUB1UDJqgDy+FNpSt5HTQEeGxjwoSSrv8joYX/7QP55NU+3Tl0as2yE4OwB5I0WJivLoQIiuy8YStLPOfaLSq8cKeeH4tqKL71ZARHUKZq5bCGU25Kpa3q0anpvS4xp81Kir8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fmbX3g0L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758490813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjWDsw8BL0wSRiGtGTApSm/QghMD5iCMDJieH5fCE5Y=;
	b=fmbX3g0LYVdj3LODXZsP6RKTR71SmSyQrGorhCOS7HNBnvgqsulaEE27n6GMFkI2qib+Qw
	nVtQYdLI8VngIZqQP7FQD6HQ3XIu5oKcERZY50VrOH4w8qXH+6spi0gn/T1koi/MsYPtoC
	GjUa4YUa9aUuwIDG6Yp3I/oXc1t7q2s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-6AvESm-ONsm-Fq6IALhWWg-1; Sun, 21 Sep 2025 17:40:05 -0400
X-MC-Unique: 6AvESm-ONsm-Fq6IALhWWg-1
X-Mimecast-MFC-AGG-ID: 6AvESm-ONsm-Fq6IALhWWg_1758490805
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso1419068f8f.3
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 14:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758490804; x=1759095604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjWDsw8BL0wSRiGtGTApSm/QghMD5iCMDJieH5fCE5Y=;
        b=mrDbX9TSuocOAibVmdxUuocku6MwwrxIGVtlNlQ5kDX5QBr2g9yGJwHPa6dGxFOkaS
         OH1wQvs0JqFqi1Ov/mCY+qvv4edLXE89zhP/NkIorn2+x7WnFSJUcShTsEZau74RPeW0
         g5GTUPm6gITHQBKpEklrlzRey9uXSScgHs6w6Lh4uTx1X6ofw9TscLYsKvH2MGS5hm/O
         wx7oJwur+5DZy3qFxe/lgwXexAZoSSHupCDnrDH//yqScWbRvKDY87U13Q3MhoVjaqBd
         FY62mBnDUQ8d6Geb7M1WDEbx7jatrsEI5Cstg8hBgUsT/Rt7cK4aj6B9ENku0qIvuJ97
         GmbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvUQErn4B9PbnWUIh79crE/wKuYd09Z5BEEGkUXXUbJE5DLvziffU9mM2iysXGQm69jpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YynxkNC2s2s+ei/8DsfJGuSpkELALeSwd5Ys8PgDNsY8o3kMznk
	rRM51GcTTfQUXPqgKYApHVFDq4I+c3TG8ct2NkuPHEB+AfqfzN1yr4qSQOwZkJpdD2esHQNF/mO
	hsVcb9VFWkVrOJeELFA4srzsFmyLcQkEBBjbnEgpgrnuhKCPSPBzMSQ==
X-Gm-Gg: ASbGncsPKSmMfKHc349EgvO1RbE5yYGvGFkn4lyqWEY0sDLLmKXE53hr/tm7Cxw+/y7
	DuRTtqUQkV9KpeN8F/jL38Mzw5JYRSS3DhP3kJMpVDYXljkB2PnhNCWOLdcdcMN8AlrusgIW1kA
	F02l4rVIGJAqY1+cLOnep7lAWwiG/nFcnbG8YbIUEdhyx6Z2qNTBm27SsX1Ybjm+R+P+z7fD36y
	cmBQ2GoMad9atPIB2NeB2mN2sQaO0CFY/bUIW3QbTPZKK31+Tjt4BIy6nNX4WKAYlKfzPJkaGmc
	yvrJ/InvWubZjwzS6vnOn606DAjHpROW5IA=
X-Received: by 2002:a05:6000:2285:b0:3ed:a43b:f173 with SMTP id ffacd0b85a97d-3ee8585e3d7mr9640220f8f.42.1758490804607;
        Sun, 21 Sep 2025 14:40:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW4yYuHu/iRIBuAiq3TYquYa/BUUV5VnlAcln8dUtQI5Bcq9TDf+qyoforvTHvt2Z+XzLrWw==
X-Received: by 2002:a05:6000:2285:b0:3ed:a43b:f173 with SMTP id ffacd0b85a97d-3ee8585e3d7mr9640208f8f.42.1758490804220;
        Sun, 21 Sep 2025 14:40:04 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbfedd6sm17304749f8f.60.2025.09.21.14.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 14:40:03 -0700 (PDT)
Date: Sun, 21 Sep 2025 17:40:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Take a reference on the task that is reference in
 struct vhost_task.
Message-ID: <20250921173934-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
 <20250918120607-mutt-send-email-mst@kernel.org>
 <20250918181144.Ygo8BZ-R@linutronix.de>
 <20250921165538-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921165538-mutt-send-email-mst@kernel.org>

On Sun, Sep 21, 2025 at 04:56:20PM -0400, Michael S. Tsirkin wrote:
> Subject: that is reference -> that is referenced

to note i fixed it for now. just dropped "that is referenced"
completely. shorter.

> On Thu, Sep 18, 2025 at 08:11:44PM +0200, Sebastian Andrzej Siewior wrote:
> > vhost_task_create() creates a task and keeps a reference to its
> > task_struct. That task may exit early via a signal and its task_struct
> > will be released.
> > A pending vhost_task_wake() will then attempt to wake the task and
> > access a task_struct which is no longer there.
> > 
> > Acquire a reference on the task_struct while creating the thread and
> > release the reference while the struct vhost_task itself is removed.
> > If the task exits early due to a signal, then the vhost_task_wake() will
> > still access a valid task_struct. The wake is safe and will be skipped
> > in this case.
> > 
> > Fixes: f9010dbdce911 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
> > Reported-by: Sean Christopherson <seanjc@google.com>
> > Closes: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com/
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  kernel/vhost_task.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> > index bc738fa90c1d6..27107dcc1cbfe 100644
> > --- a/kernel/vhost_task.c
> > +++ b/kernel/vhost_task.c
> > @@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
> >  	 * freeing it below.
> >  	 */
> >  	wait_for_completion(&vtsk->exited);
> > +	put_task_struct(vtsk->task);
> >  	kfree(vtsk);
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_task_stop);
> > @@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
> >  		return ERR_CAST(tsk);
> >  	}
> >  
> > -	vtsk->task = tsk;
> > +	vtsk->task = get_task_struct(tsk);
> >  	return vtsk;
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_task_create);
> > -- 
> > 2.51.0


