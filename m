Return-Path: <kvm+bounces-49695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB8CADCB9A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 285D4163EB0
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 12:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BFA2DF3FE;
	Tue, 17 Jun 2025 12:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEuXmsMX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A00238175
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750163481; cv=none; b=LKvPrI0BvkpfTxv+aKkGoLFfX3mBvenooSQJ9kDugQ2bVob22LleK0IXmHpKeX7hfMlcRcpZMLSG4GwCdQbk8dBqiU9kyOzLg0qtU4acOFo7G2Duczy1IPzRSc3VBOksedndDixtASrAzoT2V6tc9qM7Gf8RbdW259oUtuhkAGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750163481; c=relaxed/simple;
	bh=3dUl3FwynBQpWRnlP8tcB6RIntT52auTEx8Ov42iq/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DOzoLiJIz9jV7yejK6qmdyrhv/VV1Ki4/KFqmbsbkZZ8hMmXhvanmQtXb+uVt31XWlZPVwz3TEGUj76Lu/HoH93UmvxlVTO1ablyFxdg/vwmXCOETwMSZ9rFWxm0Pa2kbIe3uUpSUvu5RkeFNUP64H7AZUvvDU87Vv9goFazVFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEuXmsMX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750163479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KShC4QJThQfwPAvgTMBPmuZLHMXp5DkJgcjKi26gyHI=;
	b=bEuXmsMXetGmAXWjKAnEbfYCYV+1e6zYzCkWjKAqIFPCCN1mQqBdcYx9+scmRLas+lmlqo
	QvNqBr0TtyY17blElFegYjyvwWkNNE8Wz8IGLBezL+Sn1TagY4D7jdIOz9FFUd0/O+0wp9
	L15ZowCApdxwWiLesEFDzwqLuavmyu8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-JTLbmeP4NQCEe52vRdmC5w-1; Tue, 17 Jun 2025 08:31:18 -0400
X-MC-Unique: JTLbmeP4NQCEe52vRdmC5w-1
X-Mimecast-MFC-AGG-ID: JTLbmeP4NQCEe52vRdmC5w_1750163477
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b2f4c436301so4134435a12.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 05:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750163476; x=1750768276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KShC4QJThQfwPAvgTMBPmuZLHMXp5DkJgcjKi26gyHI=;
        b=FxrdBlmH9eqdWQT8WtqzuahTzQY1T72zA6iLaADpFLBUfaBUWPYQRGHqjSIcYVJLAi
         3YmDIiip/kaPK71hfFQMhWPzoRVVJIeJPhskjBxXVpUuxtQLql6g00PEiUl2pDg1/ddr
         OvHkPTeDUpkGBM+MXh7hw5OIzHLUfXm71w1oRvvJoXQFAXk7/8DNMhE+jMRDaJU6hBKJ
         lnnitxKNwsgNl5vp6NjQolMlO5Nc0uzhsaytAuQmAjEkIB5P0zSjxvOs2SwRAjSmUXwS
         UP35cgz/RwY6HenDXuYYTkbnT+J46v2e6UTrJqTFfSg5rZJZdW1oYVtaxUMOslharP7f
         RvVg==
X-Forwarded-Encrypted: i=1; AJvYcCXxnRNl8IkfewWDDbq5hc52Jr6STIRsshO1Tki9deGAhaifgZiTIM4fHUkhReHzW4N6Nz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSA6wetdV8s4C51+QfhFkTEN1kzTSvl2cPaQjDWJpDetL8oHSo
	5sjC+yxZCXf+iSLre5vveKyxuYP15pTQAn7ksHt2RFM1bVmpd0fjn8T60aJdTW67onpL8vLzNkf
	6icmiYguS3WfV8O6Xwnz/wwPOkAVmT+SlxhSx80bp8T7PuqEvo+fsZcaPw+4ClcyiBghBiMNXV7
	BdYDIJiC8MjQt9GApOzIHsJq4yj4N6RX8K6+b3h5uCuA==
X-Gm-Gg: ASbGncveWC7E4VrubzvJ3VmXJMwlkQM53tuKliwu2Cr77TIzG2th2RQNARpp1PUyENa
	7AztpiFOv7HzRTGE18hTjmDcnt+q2nx6lxjLmJc8r/cibA77tgF052P9jZ4I9YlgOr3tw+Rh+yw
	evyg==
X-Received: by 2002:a05:6a21:4006:b0:21d:98c:12c9 with SMTP id adf61e73a8af0-21fbc7fb787mr20024576637.21.1750163476470;
        Tue, 17 Jun 2025 05:31:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7HH4JHZZHWGn7WxI2rGQ/OeijPwRemStRDBDlQeXn02r9gXZyhyGGRph8cab5dQyPSJpmb9OnGFTrO6w4wWg=
X-Received: by 2002:a05:6a21:4006:b0:21d:98c:12c9 with SMTP id
 adf61e73a8af0-21fbc7fb787mr20024532637.21.1750163476107; Tue, 17 Jun 2025
 05:31:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617001838.114457-1-linux@treblig.org>
In-Reply-To: <20250617001838.114457-1-linux@treblig.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 17 Jun 2025 14:30:39 +0200
X-Gm-Features: AX0GCFtjoUlasDEXuV4xySiG1s47WSqTu3IKcqaRn-XCjq44bSF-f3FN4m8jITk
Message-ID: <CAJaqyWfD1xy+Y=fn1x8uXTMQuq8ewVV9MsttzCxLACJJZg2A2Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] vringh small unused functions
To: linux@treblig.org
Cc: mst@redhat.com, horms@kernel.org, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 2:18=E2=80=AFAM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> Hi,
>   The following pair of patches remove a bunch of small functions
> that have been unused for a long time.
>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!


