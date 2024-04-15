Return-Path: <kvm+bounces-14625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A7E8A4887
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D710C1F22F18
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5916E22339;
	Mon, 15 Apr 2024 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTLWNF0d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3515A224D4
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713164301; cv=none; b=X16BirBhVUIl0tsHx/r9ep0HDigQpFNf989201XIpadQ5taWe5JhzbVMsHdz1DbKPIkm6lpisOProODV1H5S0IZzBf6743NPIiTsAq4I/yLmfg3eHkqWnPFHC4dQdR0f0Sm2jkiFcB94o3ScWXJvszXaJA5YrsQ+0NH36Fg822U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713164301; c=relaxed/simple;
	bh=8zRocQO/rRgL1qKa5DTF7pfCxE7+mgM0HcYZDkfYtek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ik82ZsviDYB25uykb6ULhFN/F5xRB7ySRNLnvqIXmCcmOPuj3VFaYyYppzjnqy/ewWV6QOi8tbqZcEAy7dDWYaq8h0eiifq7Q25tX48AGc+xSVmZWc2LSaAqaDcGEQ+FFg+Ss7R6ftnDZG4C+Qzcd671vTQ15bUvz+Oi0O44C5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTLWNF0d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713164299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zRocQO/rRgL1qKa5DTF7pfCxE7+mgM0HcYZDkfYtek=;
	b=KTLWNF0dAahSHGxN+rWuXJcXreNmT2asKEMj4CThb2iNbYOLXROHrI9daAa0FveabApnqg
	Hxjgw0O3xyb+hp/gn80Ol+UXwFJt9TsmbhI5Xqg2rrKLmokRCNlfIsGEFPe5+HtGZ7aRo5
	oi0nh0pSU/8X30opbhn3si6lt6fTOL8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-krnmRvboPKiWt5_hTbgngw-1; Mon, 15 Apr 2024 02:58:17 -0400
X-MC-Unique: krnmRvboPKiWt5_hTbgngw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5f034b4db5bso1560824a12.0
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 23:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713164296; x=1713769096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zRocQO/rRgL1qKa5DTF7pfCxE7+mgM0HcYZDkfYtek=;
        b=eOAyrp6I+ah6WCRvxKkrvgbEScjZ09TIssQP8ezXFPLhfnLLA7c+MsUwHv6X4zPEp/
         PVJX56wx+3WEkPdHsgq6478PckaP0g0UpH4Tw4TAY1MUKFk8HlnbVcEYMa2Q1UqZAngx
         Jyf980xrlsSgp5g1r1udaTf6wk3JxiAL/35yLy7m7KzuNoanDnNIttYaq5KUFRMWhszE
         f0NCSLEWWPEmvvklgP9G6A3CEm2SFtlqzg0fl777Jbyci900gOG7hOd3ZuoV5m3h+HO6
         naZy8+oQtIux8K12Fkq+6SKXpxhyeNc/3qEn77PSwgEDwDNz9J4fetDdkbjh3aWCTQbb
         PBnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFDg834C401Kn1EJhdVClHhZj70ZM8WH4RnEx0qYhgVMpEJr7ZO6IJTUD1kNDExehc++T9SOODAOJO0uozXBkuytT2
X-Gm-Message-State: AOJu0YwEDgtUakGbrcXLqt7/joSbit5f6n5fnyYDy8QQlboHuPP/r5EW
	8X/DmyZgxkKtbmkLunObAIYwRv31rzQGYXlO3ij9PN3Ll57yIrdUMs+n9Chj7ti6KjgYgLD2LUs
	8txJctrJ/S9VoIkaL+4bW9BSBVhIfxCzP2AvTjvLhqE6tW3P2NfAW0hqtQUGTdiQJPwyOa99fzT
	N24K45FoItprk/kJai6hM+BbhTM4jYSKvw
X-Received: by 2002:a05:6a21:191:b0:1a9:6d96:c700 with SMTP id le17-20020a056a21019100b001a96d96c700mr8932585pzb.48.1713164296245;
        Sun, 14 Apr 2024 23:58:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfCe10Cxttrxe8F4OkPc7KjxC+SFTe/Z0SKvR0xbdRbE8/iQQiMdWF3kDr6DPf/3wtsnu4W5Rb/yh0o2uaUZk=
X-Received: by 2002:a05:6a21:191:b0:1a9:6d96:c700 with SMTP id
 le17-20020a056a21019100b001a96d96c700mr8932578pzb.48.1713164295965; Sun, 14
 Apr 2024 23:58:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67c2edf49788c27d5f7a49fc701520b9fcf739b5.1713088999.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <67c2edf49788c27d5f7a49fc701520b9fcf739b5.1713088999.git.christophe.jaillet@wanadoo.fr>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 Apr 2024 14:58:04 +0800
Message-ID: <CACGkMEtufa6MqWkcsZqHW8eQzj4b2wCh8zFMSAuHkxpWowLmdQ@mail.gmail.com>
Subject: Re: [PATCH v2] vhost-vdpa: Remove usage of the deprecated
 ida_simple_xx() API
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, Simon Horman <horms@kernel.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 14, 2024 at 6:04=E2=80=AFPM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> ida_alloc() and ida_free() should be preferred to the deprecated
> ida_simple_get() and ida_simple_remove().
>
> Note that the upper limit of ida_simple_get() is exclusive, but the one o=
f
> ida_alloc_max() is inclusive. So a -1 has been added when needed.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <horms@kernel.org>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


