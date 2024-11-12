Return-Path: <kvm+bounces-31689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CE99C65D5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6406B2D049
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEE121C18A;
	Tue, 12 Nov 2024 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HoIzRvBg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21314230997
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731454249; cv=none; b=nn+7++EcIGRRAJfkufQS05affndy006gDm0L5kKEkiGLTUskkNrKnikbo9ESP193VvxFv9M0a70Nw9dfMRRxYmkV+xz++Di53ByFTBPymbYtflzs1fyfZQco27vIHdIOzmnLhwIQTy0z0rDl5EmXP8h3nq5bIJMSKCCIrOLsBBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731454249; c=relaxed/simple;
	bh=QPZOFakwbsms/8IqUz2OaUZCjNqpmAIZnLYHPR78u4M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PGaSAbFBGEQmfZ8K7DvTE6mqQxUths+9n/nbXgd5xeTceOOAlmSqfcENIOfRtOqp0a2AYTuW7BophoIOIaW3fguz8X2/GU/YbcDXDI/0S4rFXdLGgHWka45Tp5opTJyRlgPGlb5iuOtT1Elwni1oYyzWkFNR5zsq91U/VocWRV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HoIzRvBg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731454246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=pahYg5ShvYI1JYFWF5WGQMVXj9AMRp+maWU01U95G10=;
	b=HoIzRvBg+IFws7rUo/HZgj6MrkSA4WBfKdpd4/2nkkmbJSh/2xIrFt5u/22UrJmAKhXF5V
	a//D86x4uCMRK43GUyYnShFNI4+VXSVtyBsRr/b5YRXcmLSbnol0/tsB1LsHsdHfbAXD7C
	/IWxJa9s4jmInUbgy7CrGbrY0736MfA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-8X_LGGxrNZWfPvAqp97tXA-1; Tue, 12 Nov 2024 18:30:43 -0500
X-MC-Unique: 8X_LGGxrNZWfPvAqp97tXA-1
X-Mimecast-MFC-AGG-ID: 8X_LGGxrNZWfPvAqp97tXA
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2fb4c35f728so46112371fa.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 15:30:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731454242; x=1732059042;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pahYg5ShvYI1JYFWF5WGQMVXj9AMRp+maWU01U95G10=;
        b=bjQgcHYqQVdjbhQKqEh7Zwi7Uf5Cj+dh1Xe5vE5j+Mb8eW/Tyl+XG8QiTbeac5STUt
         B7h96h+YdPGr00vcoOfHkS6Z5j8uOkW4V7HjlXpKw77zK/NpFkDTFAew2WGUDa0P0EdP
         syGLE/2IYD0nUmUnMqRuH1Vw7gAsuFszkNYSbGUDrRJUAgy25Fgj0AMPmCYeRrzv/gbM
         mgdUrC/QTquuBjD3eipnELz5EtyweuHTmS9jcI3ZD3VyjtXqGp/AMdNb4+07Ef0RnWeW
         FVp3ctizZjRLtG5O8+V6D3XJ/q1WKhqWjYiGDRPkP9RILvywrZ1/auT4ejGEgILHDpcN
         SfRw==
X-Gm-Message-State: AOJu0YwkY6Z7abxvx5FNsf94+BCHBL6yu8axGn7sUSwfimQFo8LdKBxk
	pnUjZIn+UKmg1B042/awZN33n+tsl0kqrLc0/iNxxSKws0FvSJR6UU4YL3df/myGWUtHpbF2RMy
	UQag+PuxqmQvv7BRSrG3Da2v51pPmlK9elCm/e+6q4OYRQEW0KA==
X-Received: by 2002:a2e:b896:0:b0:2fa:fdd1:be23 with SMTP id 38308e7fff4ca-2ff2028aadamr130045321fa.28.1731454242086;
        Tue, 12 Nov 2024 15:30:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZ8235xoIzEDFqX8Iqts1f1b/TTKzRbzsKbik0jYFi7YnSriOxnAuUaNNRZk63pcxv8z4I2w==
X-Received: by 2002:a2e:b896:0:b0:2fa:fdd1:be23 with SMTP id 38308e7fff4ca-2ff2028aadamr130045111fa.28.1731454241621;
        Tue, 12 Nov 2024 15:30:41 -0800 (PST)
Received: from redhat.com ([31.187.78.204])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a17662sm796178366b.28.2024.11.12.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 15:30:40 -0800 (PST)
Date: Tue, 12 Nov 2024 18:30:37 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dtatulea@nvidia.com, jasowang@redhat.com, mst@redhat.com,
	si-wei.liu@oracle.com
Subject: [GIT PULL] virtio: bugfix
Message-ID: <20241112183037-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 83e445e64f48bdae3f25013e788fcf592f142576:

  vdpa/mlx5: Fix error path during device add (2024-11-07 16:51:16 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 29ce8b8a4fa74e841342c8b8f8941848a3c6f29f:

  vdpa/mlx5: Fix PA offset with unaligned starting iotlb map (2024-11-12 18:05:04 -0500)

----------------------------------------------------------------
virtio: bugfix

A last minute mlx5 bugfix

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Si-Wei Liu (1):
      vdpa/mlx5: Fix PA offset with unaligned starting iotlb map

 drivers/vdpa/mlx5/core/mr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


