Return-Path: <kvm+bounces-16291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B28F58B83A2
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 02:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D75FAB21276
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 00:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91394C66;
	Wed,  1 May 2024 00:15:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail114-241.sinamail.sina.com.cn (mail114-241.sinamail.sina.com.cn [218.30.114.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399B625
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.114.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522557; cv=none; b=AhjIMt8G6dBUWOtkfX3mRC70PqgMxU0PKt/7MWA+BJP8YjTa7bZR1UiwgI7P3j1lCe9XvMK0KHZGF4/a4hoFRVZVmJSa8rTRzeN9GANJvuxCo1W4n3T4BdULBK+iIRvzB0/EeoR6dfWJJS7KpNKU78YmhqH7xp1v7dvi436C6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522557; c=relaxed/simple;
	bh=nL5c8XNclkvqZv1Vzc756f7bzufCJeq11kAFTQAbigI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uALABpT8/Lv7B9rtg/nL7qvouVXMO9apk0DXdXZ1RKsUbsEp6HfEFFfuEF9/vNiK27aVlg6Layt0VqRIL3mQPUCzcrv+xat40U06yviYFFZ30+TngqgloLGhAT0PtyNciUs5WNpn50dtFd49bavv8zhWf5Q7LsHPAfQcpjjLFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=218.30.114.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([116.24.11.115])
	by sina.com (172.16.235.24) with ESMTP
	id 663189AB00000C1A; Wed, 1 May 2024 08:15:42 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 72843945089313
X-SMAIL-UIID: 7A00621F2F04402EAA292C9DDB7F6377-20240501-081542-1
From: Hillf Danton <hdanton@sina.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev
Subject: Re: [PATCH next] vhost_task: after freeing vhost_task it should not be accessed in vhost_task_fn
Date: Wed,  1 May 2024 08:15:44 +0800
Message-Id: <20240501001544.1606-1-hdanton@sina.com>
In-Reply-To: <b959b82a-510f-45c0-9e06-acf526c2f4a1@oracle.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

JFYI Edward did it [1]

[1] https://lore.kernel.org/lkml/tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com/
> 
> If my analysis is correct, then Michael do you want me to resubmit a
> patch on top of your vhost branch or resubmit the entire patchset?

