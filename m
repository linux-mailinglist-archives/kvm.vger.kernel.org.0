Return-Path: <kvm+bounces-21084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3434C929CBD
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3670280E1B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 07:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E311D52D;
	Mon,  8 Jul 2024 07:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLrJ65gf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D2018EB0
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 07:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720422301; cv=none; b=DO+jNdF340Xh+HhkJsJYRD8cPxkDbuh1k5bBSAAusSQgEgjnJCOdI84bj8IpIIpxEqQ0uGt3yCJKKPNcI2cEu3NoenickvXbCnopj/pUibko+5eM2f6s4m9BQo5snyBaI7edG7HrkZJm1qxI3capKhcf+3Kgp9HNlS8Rj46ogS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720422301; c=relaxed/simple;
	bh=Lyh+OGU1qSqkgNUOSt3XboZ5A/fxDtSPgkO065fsa0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pearnKVhxfcGOTSfDbtx1uwE/BpLH6pwB4duIF7bPWfJGuI14s2zG6hiFkc0Kn56XljmQ0VzLMNOoI6STI2JFrtEmQpWG7AxOoxajtIc6XcL951zeMmHETvwGhloKhzO/c/mvwZlndrDbv70/wlAG9xdB7em4bvACBPPOASCNdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLrJ65gf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720422298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuevZFB7MKI/Lq5uYauYhSH0Qsz8j07xL7h/7QL0zAQ=;
	b=ZLrJ65gff+mZmEwoNdn5O+vgCEESu5tJKtGqZqt8O++xR+j4F1B6+8n88IF3d6HAsrIwW1
	CmII1AYpjVcI4H1lgGEHsEf80toz5uMZc3K5sIhhC/xzjdIr9muSvcijzPt6AXKQpbqDlP
	5+z/nyBXJY3rC87sRNuv8RgZRYqNbxU=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-e7-VWz17Nz2B5CAZU7zqGA-1; Mon, 08 Jul 2024 03:04:55 -0400
X-MC-Unique: e7-VWz17Nz2B5CAZU7zqGA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-490109b0a74so190775137.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 00:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720422294; x=1721027094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuevZFB7MKI/Lq5uYauYhSH0Qsz8j07xL7h/7QL0zAQ=;
        b=jUvLX2yVzDgS25FxSpmqBlcHg2mJ5IWIzacX9yO45BLQ5/vYOATWAxMnNSzoPGR7WY
         /Z6nFZ54w951TAwBsHpreeFec8zDv4nlNsDApHU48zi74GP4RFjbpVX0UIskVQRzsuCB
         e7uz9nAmFWWB5biv3VsOvq0EKTEPlrlSYj8/1TvEl6+7t2aOeBwSbzF6PSngSztKHO3y
         SGq7CZhX+GxrzkAxRzyoSFBgWDm1QUXHzo8bKcmor1ydNXvdwYgyCKtM7Hw2t6MYo4K+
         Mm3dLU9HrqLqYGSM38M9g2jWLEIa+5Dma/uRfJJ2geo21TUOOtKz2msdAqvyByKzLXCm
         1KdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNdmzHJ6FAcWGy/psyUcRfxpvzqn5KA8g7aEn/7iESARgM6P+SOru8b/oT5CGpWOXaXTPvUXzbGjBarHscX8bHxvK7
X-Gm-Message-State: AOJu0YxnE7+zlRn2XE6pZnfOgriOthl/s+18/w2mk+XCLiAUjNXD11zs
	u3wlcV6087+xdL3LUoiuq3WaVp1zCyXRU52Dk6IfKYCgVTw62neEHd/7JD1BKzCmrK4p3j/scI7
	bsQg1uyasvOvouxH0K1cCQKrj9fZDpKlY9TXXn5QGNgdVOHysyrcNMELKmAnMZoIaAVBnD8BieG
	cL1E4RQLHXR9gDYLCSbiG1snTO
X-Received: by 2002:a67:fd99:0:b0:48c:376f:fbfe with SMTP id ada2fe7eead31-48fee6dcb3cmr8108041137.14.1720422294483;
        Mon, 08 Jul 2024 00:04:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgNBSM7bOK3sbqftf/T7VmMO3M7PHhmrjnMZg1tK5qooR3N3OIZ0nrg5Mz/+IAvFBjtZftOxhqa1SVHpbqFvk=
X-Received: by 2002:a67:fd99:0:b0:48c:376f:fbfe with SMTP id
 ada2fe7eead31-48fee6dcb3cmr8108021137.14.1720422294089; Mon, 08 Jul 2024
 00:04:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708064820.88955-1-lulu@redhat.com> <20240708064820.88955-2-lulu@redhat.com>
In-Reply-To: <20240708064820.88955-2-lulu@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 8 Jul 2024 15:04:35 +0800
Message-ID: <CACGkMEvm59kNPvivACZt8mAZsZyp7O7FO5NUF6abB9XS_SwaEw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] vdpa: support set mac address from vdpa tool
To: Cindy Lu <lulu@redhat.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 2:48=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> Add new UAPI to support the mac address from vdpa tool
> Function vdpa_nl_cmd_dev_attr_set_doit() will get the
> new MAC address from the vdpa tool and then set it to the device.
>
> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
>
> Here is example:
> root@L1# vdpa -jp dev config show vdpa0
> {
>     "config": {
>         "vdpa0": {
>             "mac": "82:4d:e9:5d:d7:e6",
>             "link ": "up",
>             "link_announce ": false,
>             "mtu": 1500
>         }
>     }
> }
>
> root@L1# vdpa dev set name vdpa0 mac 00:11:22:33:44:55
>
> root@L1# vdpa -jp dev config show vdpa0
> {
>     "config": {
>         "vdpa0": {
>             "mac": "00:11:22:33:44:55",
>             "link ": "up",
>             "link_announce ": false,
>             "mtu": 1500
>         }
>     }
> }
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


