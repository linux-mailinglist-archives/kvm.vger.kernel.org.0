Return-Path: <kvm+bounces-16246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC598B7F70
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D3D01C236A8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50F918412D;
	Tue, 30 Apr 2024 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qv+kOX9G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B11B181B8D
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714500406; cv=none; b=KQ9EGdEGoLAMX1cW7ACD/YGVnDJUG2YZj5plPUqOfrDTaUOR52npm1vwAwjTJmobQK6cUybFpPmCcimhF4eFl040tzKllVomCFrq+HvYApsx/6Y9GBWcFlQrP+Xn29/Ns905/JlUMrt1dfoGqX1DZv0HQ8zJPClA2iD8ee4POX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714500406; c=relaxed/simple;
	bh=qJioFQM6gatzhNfw88pAwDEH8AUYC7rqX3dJnAvMfM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+yn1beMyK6sgwUkHlRNWnMWKRzaqHPZXxeKccTgfXB/62sS51WW02vLJpf3nmYF9aL1t0AIimYAvIVGCX1Cy6g9HNOAsxNG4KxmgowMTVf9/fvY6GsyrAaOpfOuV5LQTgGYoNtvu5B057C+Y1/BVL0kcbHkLuPns99nDSiwGns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qv+kOX9G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714500402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5zx7cpE5g24SyrILpVbFuVBHG+ow92d4f3RUXTPOCU=;
	b=Qv+kOX9G/hX1VU0NvIFhavWeqMZRKyJto7tJy74t39zBiLpiL2ArPnvBmAzax6MkhYlm5V
	TEwxPEbFifiIEvRSF6AmGDfmveMvnjTKKn0t6vuxPYS3r53eogjWRRGarOpN/7RS3svr7c
	z4U6HfKuAmK4DBvkAbySq5/Ri4Rv/UY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-HmG9dAEzN3eUpMkRlEF1ow-1; Tue, 30 Apr 2024 14:06:40 -0400
X-MC-Unique: HmG9dAEzN3eUpMkRlEF1ow-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-57287ec26a8so1064536a12.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 11:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714500399; x=1715105199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5zx7cpE5g24SyrILpVbFuVBHG+ow92d4f3RUXTPOCU=;
        b=nLk2swSSfbwxJf3wGZtdWtBRNsbm1MvyCqMUyk62Xjk9S8QwG1OECGBE4TpWnbOsbh
         5HzGqmfCK7E93474WR3wmdKuuSAO5uKFT8ONWVvbG4fQZcgxaCH66t8ATeJkiodsDHw9
         FOtqP0jncFS24Z/E2OtnxzJt+VpDH6BrWzW09MhE7/YgTgm2fTephEQMBxFvc+HqXiLi
         0KxNQvE3KwiEww3gvlLHYmqtnFCZ9Dp8I4EyE4sMrH7mp4qShxVDJV3NnVZPL7BneMJp
         gtpwRV1O2uETD4K4OhFJQ3aafActex5Vdf3aPVBRbIu2MLoiwegiFY6+fXwlUysNY+79
         4Ezg==
X-Forwarded-Encrypted: i=1; AJvYcCUzYgxRFkJm3DtlPR9Uq+LGEvKUlpR7VtgZSBIK6mmNaF7fNRdDrmm8DcImgzzRqPadQAfbiIgZLze09jeWV1tPv+Q1
X-Gm-Message-State: AOJu0YzstjLzDI0X6K8rXh+iVuKlB5EdWZdIhbqK4EdRCWy+dal2/qdO
	3XNWOFU16X5rYZDdr3S7ObLTCyA6NJYkXFT6MeJt/0Am14lXdlWy7lChHkjP6jXZ1rCDGNupLkQ
	Vpve/0mtUdtstrw5VKIxDeKxUufmQMpj/sH+yOLEmkc58dtWRsw==
X-Received: by 2002:a17:906:dffa:b0:a58:bd8e:f24 with SMTP id lc26-20020a170906dffa00b00a58bd8e0f24mr301829ejc.39.1714500399312;
        Tue, 30 Apr 2024 11:06:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAMU+eVyJELNlfDZqGybmwpL1icWgq7FgiEnNy2tDXnkcVLH1RcMMycitIzluk5myVZUO69Q==
X-Received: by 2002:a17:906:dffa:b0:a58:bd8e:f24 with SMTP id lc26-20020a170906dffa00b00a58bd8e0f24mr301804ejc.39.1714500398788;
        Tue, 30 Apr 2024 11:06:38 -0700 (PDT)
Received: from redhat.com ([2.55.56.94])
        by smtp.gmail.com with ESMTPSA id cd19-20020a170906b35300b00a4673706b4dsm15347234ejb.78.2024.04.30.11.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 11:06:38 -0700 (PDT)
Date: Tue, 30 Apr 2024 14:06:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	jasowang@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not
 be accessed in vhost_task_fn
Message-ID: <20240430140613-mutt-send-email-mst@kernel.org>
References: <000000000000a9613006174c1c4c@google.com>
 <tencent_4271296B83A6E4413776576946DAB374E305@qq.com>
 <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>

On Tue, Apr 30, 2024 at 11:23:04AM -0500, Mike Christie wrote:
> On 4/30/24 8:05 AM, Edward Adam Davis wrote:
> >  static int vhost_task_fn(void *data)
> >  {
> >  	struct vhost_task *vtsk = data;
> > @@ -51,7 +51,7 @@ static int vhost_task_fn(void *data)
> >  			schedule();
> >  	}
> >  
> > -	mutex_lock(&vtsk->exit_mutex);
> > +	mutex_lock(&exit_mutex);
> >  	/*
> >  	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
> >  	 * When the vhost layer has called vhost_task_stop it's already stopped
> > @@ -62,7 +62,7 @@ static int vhost_task_fn(void *data)
> >  		vtsk->handle_sigkill(vtsk->data);
> >  	}
> >  	complete(&vtsk->exited);
> > -	mutex_unlock(&vtsk->exit_mutex);
> > +	mutex_unlock(&exit_mutex);
> >  
> 
> Edward, thanks for the patch. I think though I just needed to swap the
> order of the calls above.
> 
> Instead of:
> 
> complete(&vtsk->exited);
> mutex_unlock(&vtsk->exit_mutex);
> 
> it should have been:
> 
> mutex_unlock(&vtsk->exit_mutex);
> complete(&vtsk->exited);
> 
> If my analysis is correct, then Michael do you want me to resubmit a
> patch on top of your vhost branch or resubmit the entire patchset?

Resubmit all please.

-- 
MST


