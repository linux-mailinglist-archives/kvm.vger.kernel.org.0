Return-Path: <kvm+bounces-39358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 267E4A46A91
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33CDB3AC83F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25C1D2376F2;
	Wed, 26 Feb 2025 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q62ayx/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D177021E096
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596642; cv=none; b=Qvv9hHxaRGnxjwf1BB5bSmRnm3Fp5nCdoJcCxb1iw75nfCrjZ+pU3qm5+1h+AtCpmpsMTOAm08QWEr89YWKXIo9sKtbMYI0lHkEPi3xg15j8GrozXL09zUhMv6NNbezFoOdvfb31XqQpWyJQIA3UzT44KEXzx9NB4ier1DY6lP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596642; c=relaxed/simple;
	bh=CP1ZQTGcS1XGDk8705yrsyn1P0HHQp7ZwLXpNdZVTts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EC+8L3tH2o0FpnMsAveMY8h0Z1S4xUyJuIXnILKHjOQLDzZj7TlTHReOz7oQBm63vIEj7JDD9tN4DY22cVkY/uBedeXO/hyKuECMrvHgGdjt9e+ozYxFsvm38LutKXzNv/93Nx5H4Uj4j55kYX3jVGOnE1ntw7Wo7/1iV/RsgZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q62ayx/6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740596639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIunKPS4UZCFjPvS7Od7AUtu0dxUhH3F4cLQKO6l55Y=;
	b=Q62ayx/6LKdVu0I4f+gULfekrfEKVRMrrfWnrH2CCOZyahyZLuveulxqbXDaMPAi14pRbn
	vFkvxVVYkNdwQDrJTRdv5Iam+gc3ze8opA+olT0HtUhCVvy178n7V0tQAPKDzk3oKKLJJQ
	9IBMMLMqhEIzy21fvuPOo3c5RrpBbXs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-ITJtCnapMwyKxZSD11cetQ-1; Wed,
 26 Feb 2025 14:03:58 -0500
X-MC-Unique: ITJtCnapMwyKxZSD11cetQ-1
X-Mimecast-MFC-AGG-ID: ITJtCnapMwyKxZSD11cetQ_1740596637
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B2AD1800874;
	Wed, 26 Feb 2025 19:03:57 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2D49E1800352;
	Wed, 26 Feb 2025 19:03:53 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 26 Feb 2025 20:03:27 +0100 (CET)
Date: Wed, 26 Feb 2025 20:03:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
Message-ID: <20250226190322.GL8995@redhat.com>
References: <20250126142034.GA28135@redhat.com>
 <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com>
 <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com>
 <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner>
 <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
 <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
 <20250226-portieren-staudamm-10823e224307@brauner>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226-portieren-staudamm-10823e224307@brauner>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Sorry, didn't have time to actually read this patch, but after a quick
glance...

On 02/26, Christian Brauner wrote:
>
> @@ -3949,7 +3955,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
>  	tid = (int)(intptr_t)file->private_data;
>  	file->private_data = NULL;
>  	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
> -	     task;
> +	     task && !(task->flags & PF_USER_WORKER);

unless I am totally confused this looks "obviously wrong".

proc_task_readdir() should not stop if it sees a PF_USER_WORKER task, this
check should go into first_tid/next_tid.

Oleg.


