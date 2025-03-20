Return-Path: <kvm+bounces-41536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 389C5A69DBB
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 02:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C8D03BEF95
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 01:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3C5BA34;
	Thu, 20 Mar 2025 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWNhaXnc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B121D8E07
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 01:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742434969; cv=none; b=NN/aKLC5PwTTXKXPMCXNw3txaxCUYmPMmQFME5+H9plK3VUzAejM3bg533cwsM1w/BMZXP0mqejP4MYuwKLFDI/pmbiortpmfv8WKNrrPA7PWmgRnxXmLMckQqRNDxatOHPl/5rzH0xptpYVSZBn1XKvrYsA3JaihzLrXg60cx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742434969; c=relaxed/simple;
	bh=SGrH1u360HKGfwUkB5OQl0M0A4QLRKrf61IPTLVqChc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWUdEtzTSJ8mRQO3mYN2rSlKFtihkQBdkCnKQQ9GSwBR35Ykw/4FsOBwlkDq51INncn+tQhXFaovnAzldxAHAxaW9OZvSnMW1noas1YRvtqJjEBFE0U4EZzecLMRmvZkMtHjaQcLYJw1IAKNqsQXw88tg9JmvycgN6JEgSWkM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWNhaXnc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742434965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGrH1u360HKGfwUkB5OQl0M0A4QLRKrf61IPTLVqChc=;
	b=UWNhaXnc4lDmBX9+sqyYsRQkAfSX9qThVpsPoWhjdXsehtsHz/TwlYPE8o3+BYszSO8gw1
	GqFKs44AZ5en7anpdO9goNkHjpYH7oLNTX/99D2/uy+9EJgrjoLhs0ffmsURnsb6475xoT
	pVmpmcJrygVkWBrv+U65qiCS1H0cs6c=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-oDjeylpcOk6HwzyV7H14CQ-1; Wed, 19 Mar 2025 21:42:42 -0400
X-MC-Unique: oDjeylpcOk6HwzyV7H14CQ-1
X-Mimecast-MFC-AGG-ID: oDjeylpcOk6HwzyV7H14CQ_1742434962
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so379188a91.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 18:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742434961; x=1743039761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SGrH1u360HKGfwUkB5OQl0M0A4QLRKrf61IPTLVqChc=;
        b=oH8sbCbQDf6yLUCPLa6KpUNQxHVlmZRoXO+XPJnhUH41XMhlUr9q/EhNi8tU5cQhkP
         0cEV3mNldv0t+QTTSeroYHxN4CRx4SmymZdf8oJAO7eHZ+CFIIlTzRYRL2WoliZFzLKY
         a0OhpduMtsw/B464D61Mu537KDzLUpjMuu/0t3LAs6wka5crxDY09cNDGxdFhbDGgNsw
         RTi4lsB3gC0lPHBvk1szLjQfw396YDHOETvXlYqAMa3CDqM5+e5yn1Y8b6GInj1CxE61
         KYhleHA8NEZO6pmCYADjZ8l1o2WzH57XvIp9xjIC/vEARADbCkEwbwAAmGXw8wUybx8X
         WWsg==
X-Forwarded-Encrypted: i=1; AJvYcCVNFYOFPdPKDf+ZrLUOE9iCFK3sT7OnORsRk3o3mQRlJcUtun2d7F+69zQuMmqX7UNs8y0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNNXAHN9xWzd3ApsIFr+ZUiO6q8CtgFN/CtufTJT2h6dv1NJCa
	CLnAMnVxDrMlESbUZu7EMkb8NUjC2sPzIbQBmeB0WRSA7OhwDS62fiqVyU3lmao9INJF4zVitGR
	FVeI0To1oXfyF/FnC0KMMbsx0GbVgA2cXpCC/HhZ0j92m6fAvI7xo1K/W7JC3upwO4brWm9HsJP
	i/Vnq+jw0MDY12I1rFPlDk4CDR
X-Gm-Gg: ASbGnctKBi/EJBce97UcNMxWJSv9lYlnFzsChmmd02+sFwqzi3dJtnmFuGt6DzPDquF
	jJkTyg5ntc43dHlLk0OuGJ7sRVJGbtl+YRHj5fViHH4pi9xQY570EeWPaaOCGCkvQO0w9NBA5ag
	==
X-Received: by 2002:a17:90b:3b8d:b0:2ff:702f:7172 with SMTP id 98e67ed59e1d1-301be22004bmr8335519a91.33.1742434961586;
        Wed, 19 Mar 2025 18:42:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHL8OOunCev/pL9yVKVD54yPvvXy/UMUfGTvOvKDcF+K+NIjug+q9W+WWL+a2DVKRNK9ypCK2PuGfDdKa5c2c=
X-Received: by 2002:a17:90b:3b8d:b0:2ff:702f:7172 with SMTP id
 98e67ed59e1d1-301be22004bmr8335480a91.33.1742434961230; Wed, 19 Mar 2025
 18:42:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-4-dongli.zhang@oracle.com> <CACGkMEsG4eR3dErdSKsLxQgDqBV55NUyf=Lo-UUVj1tqQ-T8QA@mail.gmail.com>
 <f3939e10-3953-4be4-bd92-2ae891f6d67e@oracle.com>
In-Reply-To: <f3939e10-3953-4be4-bd92-2ae891f6d67e@oracle.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 20 Mar 2025 09:42:29 +0800
X-Gm-Features: AQ5f1Jog19Stpw5ZwXnl2LZ0a3rRd5bIs46de4Ks1-qbsvRNWnVK_fE3aiW_X5c
Message-ID: <CACGkMEs3O2B0fAifAki9GdDiP-SX4pMviEOjqCsAkkzCyx90gg@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] vhost-scsi: Fix vhost_scsi_send_status()
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com, 
	pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com, 
	joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 1:54=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
> Hi Jason,
>
> On 3/17/25 5:48 PM, Jason Wang wrote:
> > On Tue, Mar 18, 2025 at 7:52=E2=80=AFAM Dongli Zhang <dongli.zhang@orac=
le.com> wrote:
> >>
> >> Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
> >> signaled by the commit 664ed90e621c ("vhost/scsi: Set
> >> VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
> >> vhost_scsi_send_bad_target() still assumes the response in a single
> >> descriptor.
> >>
> >> Similar issue in vhost_scsi_send_bad_target() has been fixed in previo=
us
> >> commit.
> >>
> >> Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failu=
re handling")
> >
> > And
> >
> > 6dd88fd59da84631b5fe5c8176931c38cfa3b265 ("vhost-scsi: unbreak any
> > layout for response")
> >
>
> Would suggest add the commit to Fixes?
>
> vhost_scsi_send_status() has been introduced by the most recent patch.
>
> It isn't related to that commit. That commit is to fix
> vhost_scsi_complete_cmd_work()
>
> Or would you suggest mention it as part of "Similar issue has been fixed =
in
> previous commit."?

I'm fine with either, they are all fixes for any header layout anyhow.

Thanks

>
> Thank you very much!
>
> Dongli Zhang
>


