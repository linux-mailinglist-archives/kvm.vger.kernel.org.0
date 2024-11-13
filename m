Return-Path: <kvm+bounces-31717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B999C6951
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:33:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57712283E93
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF7C17C7C9;
	Wed, 13 Nov 2024 06:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJvX/sq9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB26176233
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479579; cv=none; b=tQDejJE46ra7xO/pPWiRRIDFpZa4RCRKd6QwvfmsXYJqYXfeEwJmErrea+MDO2olQaIMb/CgMjbL7JSvLe7dlW+Cs7h+GqcuIHgHMnn7aOFqYbeBL+wmR4Hm+ZN2euz1pTC50Tp8+Th/7Zk3qBdp6MDcmoVjg0Nk8RSRjT+pIOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479579; c=relaxed/simple;
	bh=Lw3nK/L1jm7SkFLesz8RoI/vr7mkD5mxfPU6EoBK83s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBeQSTPsDgDZ1/z7fxP9uYq0N9u+4ZciHrSxV/4SQP0RSmEed1iC1Dv8ux1ZcvSv4docQReQKfqhdHxLPi+4lk62ZxfnJLx/r4HqHX47ChLDeVkSP5rno0+0tVPJ4iF8ojnibKRhTEjTsn/AiWDTnLkUAkcAPbnq6r5CHLCjkNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJvX/sq9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731479576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rufpVhFdmb4VBRTafDBR2fxnE3o2Ggdk6Fw5zg77oVc=;
	b=bJvX/sq9xPX0I76untdvn83vcG+f2Fjq2GS18mfz40Nz0NFfQwRMysVABxQplGFEW6hASp
	odLgxWdUFRMJTYN50bH4sFLwLAPb2txv0Frb7t9VnGhj2ion+pHr2ZXv+kZ1DXvmn6LBW7
	njZgqaEyrNlKXriMvN4fA6EJFtLHIrk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-oZFA5EKCPV-VmGmp-uSF9A-1; Wed, 13 Nov 2024 01:32:53 -0500
X-MC-Unique: oZFA5EKCPV-VmGmp-uSF9A-1
X-Mimecast-MFC-AGG-ID: oZFA5EKCPV-VmGmp-uSF9A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315a0f25afso50812905e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:32:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479572; x=1732084372;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rufpVhFdmb4VBRTafDBR2fxnE3o2Ggdk6Fw5zg77oVc=;
        b=OCTcI9w0k4vtaI4B8MwUFnHI2b7Szp/pcf6ryW6VlnnOZkF3FIjCSeoseM5rshkKSy
         X5w/UeXnRcAmqmE0HhQWreDKwzVtUV1h6amcXMh/y36D53dHyUcu19cD1ce301a6Xvgy
         pTyH0KGWxi3LbF6DBz9mFUB6Apng96JANIhmXB5v09Px2TPjHrySO5w2WSeZ8MUk+yNm
         I9sDzE+rNbsaMa1AUqDEPY8YPcgoQzNE2hvXWQ3xF1Pm/mubzTKFrwrhp8LoCQhlFNPV
         3DfE53prfm50WmlH5GwwFQySIevMGonSXo2lc+7Q4iiOg80d+hywwzeNKEPDCJfgt1/H
         ymBg==
X-Forwarded-Encrypted: i=1; AJvYcCUBzTqJUmi/9jJvSX4/+mgEXqc8K2SVE0WVDJ636K3zbZYc2GHhR/SnReyt66jpkdUypfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0tvPtJBtZhaXG0jgXSpwSjIFj3P2cT5qkWrtVSrfMphz3qARA
	yRXVRWz6b3ANZAhI0j3FqABlkx2haOpqM3GaYr2YmD8SK7xLVqFZui/ueeDtgX1HcoAn1Xyz61u
	cGa1PADSJCGmA2CqDICsBvPI+GTkVujclpPTG8FH9UxtM8E49IQ==
X-Received: by 2002:a05:600c:5124:b0:42c:b995:2100 with SMTP id 5b1f17b1804b1-432b74faa3bmr153588285e9.6.1731479572323;
        Tue, 12 Nov 2024 22:32:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvSivPbOF1a3z2KjRJHfbTayaTS2MPjyFeMmHN0IJchZdRUqbmt8NJD00TQs1TXCkMviDiyA==
X-Received: by 2002:a05:600c:5124:b0:42c:b995:2100 with SMTP id 5b1f17b1804b1-432b74faa3bmr153588185e9.6.1731479571999;
        Tue, 12 Nov 2024 22:32:51 -0800 (PST)
Received: from redhat.com ([2a02:14f:17b:c70e:bfc8:d369:451b:c405])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d5541832sm12580005e9.30.2024.11.12.22.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 22:32:51 -0800 (PST)
Date: Wed, 13 Nov 2024 01:32:44 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, virtualization@lists.linux.dev,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 0/2] vdpa/mlx5: Iova mapping related fixes
Message-ID: <20241113013105-mutt-send-email-mst@kernel.org>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <8e93cd9e-7237-4863-a5a7-a6561d5ca015@nvidia.com>
 <CACGkMEtALWqmoyOBu8vywnk=SuU=N1zKt7sxwueKkYQi3LB0MQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtALWqmoyOBu8vywnk=SuU=N1zKt7sxwueKkYQi3LB0MQ@mail.gmail.com>

On Wed, Nov 13, 2024 at 09:45:22AM +0800, Jason Wang wrote:
> On Mon, Nov 11, 2024 at 4:58 PM Dragos Tatulea <dtatulea@nvidia.com> wrote:
> >
> >
> >
> > On 21.10.24 15:40, Dragos Tatulea wrote:
> > > Here are 2 fixes from Si-Wei:
> > > - The first one is an important fix that has to be applied as far
> > >   back as possible (hence CC'ing linux-stable).
> > > - The second is more of an improvement. That's why it doesn't have the
> > >   Fixes tag.
> > >
> > > I'd like to thank Si-Wei for the effort of finding and fixing these
> > > issues. Especially the first issue which was very well hidden and
> > > was there since day 1.
> > >
> > > Si-Wei Liu (2):
> > >   vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
> > >   vdpa/mlx5: Fix suboptimal range on iotlb iteration
> > >
> > >  drivers/vdpa/mlx5/core/mr.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > >
> > Gentle nudge for a review. The bug fixed by the first patch is a very
> > serious and insidious one.
> 
> I think I've acked to those patches, have you received that?
> 
> Thanks

I saw your acks Jason, thanks!
Patch 1 is now upstream. Patch 2 is queued but I asked a question about
it.


> >
> > Thanks,
> > Dragos
> >
> >


