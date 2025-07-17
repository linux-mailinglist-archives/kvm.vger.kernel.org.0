Return-Path: <kvm+bounces-52687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FAF4B082B8
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 04:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 480B758435A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 02:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1340E1EA7E9;
	Thu, 17 Jul 2025 02:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtSbdefn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53121CAA79
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 02:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752717797; cv=none; b=JhhIgaNdJz8ufReWqFZ1rGvy22qM0zm15A7r+xti0Nu0rqDLdEwdn5UwQOIoT15qtMBgqnJcBkZRJIf4JLlu0l+zKD9ZT4rC+8mEsTLgsAKPf3h98xB5uN+ijZGEBQQ+fhdSjrI9AxkgdjlrXEL0sylSTm7aOyYf0Jvg+fqp2DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752717797; c=relaxed/simple;
	bh=nk+vMLXGoyUcWn2gdQ0TtZDnbeL6g7uxU6L7y4/AI3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wh2OuePPtrP8hFKQwyuJi/04I3W6SceyM44yNONQHtc9I/xuwKRgXLlIV5yvwoYVO2/ZOEYkrjgG5XrdPtWXdJJVjsEBAiPKvay4t9aaylOM0E/NOaNxaJuDskmO1WNqE91UNo1MJvp+ZpfjRLw8o26KpMc4nfsQkTagU8wf62Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PtSbdefn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752717794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nk+vMLXGoyUcWn2gdQ0TtZDnbeL6g7uxU6L7y4/AI3A=;
	b=PtSbdefnu9UH02yhsvHlbfjeiyqG3WsRKPWxZbilyCMkYzB8FmToWbhjhpjtNLtMRHcAkS
	Qzo7/sV02f154kgtpNiyEyXXMTs6q1ab/1DU3uj9zYO1AAzxd3eckDjyTThRfCP7ntOd/D
	heYxYak4hvt4GFa0Wg1PRZdlsxG8SSE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-1y_LZ_ahNwKTbEtImAjtoA-1; Wed, 16 Jul 2025 22:03:13 -0400
X-MC-Unique: 1y_LZ_ahNwKTbEtImAjtoA-1
X-Mimecast-MFC-AGG-ID: 1y_LZ_ahNwKTbEtImAjtoA_1752717792
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-31215090074so758623a91.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 19:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752717792; x=1753322592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nk+vMLXGoyUcWn2gdQ0TtZDnbeL6g7uxU6L7y4/AI3A=;
        b=XnUdTJxyAUwFK4taDt1/EcBjl71gkDUqT/D08SWTSRZMA6Of2pyV7DMaGQQV17JKOF
         39yXplYUaA7TFm+zysklDvAFABbzSBu3A9RBNKxfkEa32cdyW3xCeq2/6D8ELMsnPVUD
         7V4X8owGM7GjEZ6dAFL+WqmuEMnwKNR34PDicGF22tA+jyPHBWtBa863JmxIGg/6Aijy
         fJFqTQjFr6P0WEY3fic/nQLawX5lC5wrFs/j019idTWHUu8YMCwLmQMeDx66/6y+vOVb
         W07DqVtPu0jhJITnS+O8chu6p801LDOw+JH3rPqC7F6lOrjR5w2fEyB01xhBRBs/1DuM
         Hb2g==
X-Forwarded-Encrypted: i=1; AJvYcCVe3YcVzrTEIeYMwVFv1lT1GytJkMuwEEMc50R71/IgftdNb0EVU9EPTssu95pIkS6dkuk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7CxSw5blmSIgFynC1kDl5Lr+Ul0DaKCb7P8caB9y1URvkuK8s
	VS64Tr7KcBrWEDIN18vm4nlbTGQUvZbKumOLaCzmgUpmt7aQaJ3EEBXXi9zDHNbq+wCghHqwU26
	XwJvIFWnQ5h/lUj5P1G0EMyQh00DI5K09+4AMGl1rBMe7g6rAGXxOHKKnZVwln6ZmrMVEduVS7t
	N+qbJzZGfmOUNV/dNuXEV4ZmVPvAYT
X-Gm-Gg: ASbGncvMt9r4lm3FdEUQDnqtdDbqx7ovjUkAw4pHiQX7oV6eyrPOX1/yXVYmrTT3zsc
	P3KGjNS7aXIXic2AiBxU41QBTbTRVN/Y6/DTVMoUwgHZSNVbY3cNCAQHOyHkM8/HwpHAInhlr+x
	yWxPbTWYdwYVmPEPXeRH6r
X-Received: by 2002:a17:90b:55cb:b0:312:959:dc41 with SMTP id 98e67ed59e1d1-31c9f43747emr6022345a91.27.1752717791905;
        Wed, 16 Jul 2025 19:03:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPKGtWTF3J+7pKYaN1LISu1DbprEzZA/aztw/7OAnQNJPFUO3gk780cKvvzbWsO46X8xOSSRM1m2KLbEldd7Y=
X-Received: by 2002:a17:90b:55cb:b0:312:959:dc41 with SMTP id
 98e67ed59e1d1-31c9f43747emr6022312a91.27.1752717791421; Wed, 16 Jul 2025
 19:03:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250714084755.11921-1-jasowang@redhat.com> <20250716170406.637e01f5@kernel.org>
In-Reply-To: <20250716170406.637e01f5@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 17 Jul 2025 10:03:00 +0800
X-Gm-Features: Ac12FXyE_9vIZMY_ERg2TY_jtWvI4UypN_DhHze9LSPtUt7pnoEDW84dnljw5VE
Message-ID: <CACGkMEvj0W98Jc=AB-g8G0J0u5pGAM4mBVCrp3uPLCkc6CK7Ng@mail.gmail.com>
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: Jakub Kicinski <kuba@kernel.org>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2025 at 8:04=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
> > This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
> > feature is designed to improve the performance of the virtio ring by
> > optimizing descriptor processing.
> >
> > Benchmarks show a notable improvement. Please see patch 3 for details.
>
> You tagged these as net-next but just to be clear -- these don't apply
> for us in the current form.
>

Will rebase and send a new version.

Thanks


