Return-Path: <kvm+bounces-58341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 948F6B8E5B5
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 22:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4853189B344
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 20:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA5D2951A7;
	Sun, 21 Sep 2025 20:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAslvgJG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1E12264B2
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758488185; cv=none; b=UsNo7Ccsh3CJ+AMX+ic18T9fqfz6U79iKxnhxpfOyobahGniE7x0IQtGqTsa8fiOjGCYTsQLsV9pVK+bbZOwMwaNh68i85+USe0UE2WoTVeQOFADW2cHBwBHk9xLaI8sNo7vbNfsscGm04WBvxjzEqiHM3eqMKhEs5dFxtRe694=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758488185; c=relaxed/simple;
	bh=vcRE+eOSUt9r7QlljmvLF/beKVSKoUFncXZuFjVkhlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPl8R2AxHBrEFoPzZB2cLPUsj0MyfkNVftNH80VPRQy92/QcoYhcTsC0ccU5OFviJu8DlNkW9JrLtrtUaN2s20xUFEhSMPJQqbMI2TEftasA0nuNiNC4ycAMS7UtzZtC3TU2LIyjj2zsSbjbd2I5ZJ6UdvdJNJdid24UkFZvDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAslvgJG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758488183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YZa+gvlnzJbu0CdEMidkqaQp0dZ4QxQQFlF/kZd1gcw=;
	b=GAslvgJGUAlX1NEgbQWj2UGtjOrgCTZ9QeJySs8CrmzjcAIVmWKhpytKreeuyy/m/Xftve
	Ek/GQLUjOd6pE3e7QMvIqPxEPQuxdb58smWEW3CmGwEX5JxS1vMpTVh4PPuwE/nTgOoUr+
	rB5/Ee15RdCVI4F1TPNgduscIPg2NKM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-TFoI1kTZPgupS_tdoLYBZg-1; Sun, 21 Sep 2025 16:56:21 -0400
X-MC-Unique: TFoI1kTZPgupS_tdoLYBZg-1
X-Mimecast-MFC-AGG-ID: TFoI1kTZPgupS_tdoLYBZg_1758488180
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so22765595e9.3
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 13:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758488180; x=1759092980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZa+gvlnzJbu0CdEMidkqaQp0dZ4QxQQFlF/kZd1gcw=;
        b=Ez1R88jYihm2Y3kAHQIr9A5s1IH8LuZ1hU7EZZalMdVe/ICjTPdH71NL1dyqVti5KV
         NyU6YFvYDFR1Nl2R+IcRnw/hiAYQT+Z5HcnueCdhOxGmenpdET1CKF92azCAK9gRNN2m
         y1V6Dd6DNgtojNAedQKovjm2toTnlgMf5yf3NYLtiVsEqzu1L6po36P6tgqq2/Ou34+f
         Cq1Qw2OjlDsiBQinwImA75SZ9gjfEC2jzOG4sBZTWIWq/z9ulOHe5F0xgc13TpZ4ZBE8
         ek4Gl5sRP7l6phQ3awHzlQgHdEb5OL+oGLILzueEllT5wPbhLOUgiCteKK22kHltbTVk
         F+OQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7ZgPrKkGrCOPSgnFU7XE4McV7F8h/wqKMGgbjYu09evN5h8WB3U00E0qA46MSe9FkYao=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjlRCYTaZHW+Sa1SCGG+dFYhJBHIHCg3seVrNQaUw0DWrG/zBU
	+IUQiXeC+0z89P8VVrzWKaU+JLueIcB5YooIX5+VjJlWY4P+9WIUT4bg2K69/RnXrjcf62azeam
	upxqD/KID5wACI7SlhpO9n6ku769eY3lS5dLTt1QAPL+GnDKnD/Bhqg==
X-Gm-Gg: ASbGncu0xZy66szCSTyLMK5ZDL62ONoPgKwVtFs8CEpOsdyoQFeMULb1JONs7pHyzRY
	avw3E9Snqo6zwXz5S+HaSyvPnRl/b44bU0CPMkXfzlZUyzKOrSU/eBCuf/8ce14FMd5Y8+d1De5
	aB2m8tIYVa0M8lAYxKnSXgeEzczxKVsvnnnx9uV8cVfJuV5ryjIuRWxdZkyuL9GWCoVWxDaS0dc
	KKJE+EDVCgIQtu19391GfdA0V842dshQv4oBRTTC1lYR/XN/g/iDq9K9opoYcmBNcdmb8ZmMK4u
	PPV98WT9TQ2dgzyzoN++JD4mOjUZj+56zoE=
X-Received: by 2002:a05:600c:9a5:b0:46c:e3df:529e with SMTP id 5b1f17b1804b1-46ce3df54dfmr9206415e9.19.1758488180275;
        Sun, 21 Sep 2025 13:56:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnqwMssDCjhijdZ/zRsJjF/aux8aMPTu3vT6tEWO8ityPhOqzUTeSFi2aStyrPs+FMZNaF1Q==
X-Received: by 2002:a05:600c:9a5:b0:46c:e3df:529e with SMTP id 5b1f17b1804b1-46ce3df54dfmr9206345e9.19.1758488179887;
        Sun, 21 Sep 2025 13:56:19 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f321032a1sm131335005e9.2.2025.09.21.13.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 13:56:19 -0700 (PDT)
Date: Sun, 21 Sep 2025 16:56:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Take a reference on the task that is reference in
 struct vhost_task.
Message-ID: <20250921165538-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
 <20250918120607-mutt-send-email-mst@kernel.org>
 <20250918181144.Ygo8BZ-R@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918181144.Ygo8BZ-R@linutronix.de>

Subject: that is reference -> that is referenced

On Thu, Sep 18, 2025 at 08:11:44PM +0200, Sebastian Andrzej Siewior wrote:
> vhost_task_create() creates a task and keeps a reference to its
> task_struct. That task may exit early via a signal and its task_struct
> will be released.
> A pending vhost_task_wake() will then attempt to wake the task and
> access a task_struct which is no longer there.
> 
> Acquire a reference on the task_struct while creating the thread and
> release the reference while the struct vhost_task itself is removed.
> If the task exits early due to a signal, then the vhost_task_wake() will
> still access a valid task_struct. The wake is safe and will be skipped
> in this case.
> 
> Fixes: f9010dbdce911 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Closes: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com/
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/vhost_task.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index bc738fa90c1d6..27107dcc1cbfe 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
>  	 * freeing it below.
>  	 */
>  	wait_for_completion(&vtsk->exited);
> +	put_task_struct(vtsk->task);
>  	kfree(vtsk);
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_stop);
> @@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  		return ERR_CAST(tsk);
>  	}
>  
> -	vtsk->task = tsk;
> +	vtsk->task = get_task_struct(tsk);
>  	return vtsk;
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_create);
> -- 
> 2.51.0


