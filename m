Return-Path: <kvm+bounces-3971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55B5F80AE7B
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12F54281AF3
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D015731B;
	Fri,  8 Dec 2023 21:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RW0cUlbv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70CD1716
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 13:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702069377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnR71ERwB0xpUeMudALkEkT2aBnLdTFV83wSZKWUuyk=;
	b=RW0cUlbvT+L5mN9LJXfJjm3V6x/Ol/6/NaTJ3wPdhENgihLDtVe4f1yHVWatyHVDgThfEp
	IyuvLTLQj6Pv89NEd0SR53wk/pFl7c+QhcJ3b9FDf2xKsvOmnWR26jV0JQUv5Fuj/ZPtAe
	+2dKG3rGCDXM5F3htL2qFly/fqFqcTk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-vTj1zwMgPhi0Yw__e65TDw-1; Fri, 08 Dec 2023 16:02:56 -0500
X-MC-Unique: vTj1zwMgPhi0Yw__e65TDw-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-589ce3eb26cso2712768eaf.2
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 13:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702069375; x=1702674175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wnR71ERwB0xpUeMudALkEkT2aBnLdTFV83wSZKWUuyk=;
        b=OscFyADODThomnzLt2WF4bvuU84wg1QCYZ0xgPjV6NDtvcofWRdJGEDa9ha6sEoKAW
         OnW2ItZoxTR4hAlL1udTiZF+hfM8cjFZbZz50S9oDxxuCXEdXKBvWtx+v3Rgt5oeFRy+
         m8D1aQmbLw0NagZ4ZtxdJnIC1nUeTrZj4kTc6CmYLYjHkv3WYAzbDc0haWUmNK3tHIA/
         pfdv2BUhM4DUBH7cM+VaTCC2Ypo1Qr6DVPKevfehB1UJDh1f3iqzeyuyswxjaZB14H+J
         zn01zlISr8lP6n4qo32U+iKDHrQ0i1odvhUejk9UB0olmPAdIuJPEsijRM/LbcOkDpG+
         MeLg==
X-Gm-Message-State: AOJu0YzLEIfucU+IMQXQk6+hc3DPFdosKK5LTGrEzQ1ptdqRq4ExLxMS
	A6/z4y3ZPpt0XO7M2RLppcu899sM0dD+GJZW2SeA9tK2ZZ+ukX85oKX7hQBFOudLJ7i1Z2SgZbV
	ZVN8wqtzpio6NUTQsTJfny4i5biGA
X-Received: by 2002:a05:6871:5812:b0:1fa:6f5:7b11 with SMTP id oj18-20020a056871581200b001fa06f57b11mr831748oac.36.1702069375681;
        Fri, 08 Dec 2023 13:02:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG70CYCSZWB6DKvr4hrnjBebC5sVpU0c4XwqZCNGpXXRnlou5CpzlriTsL34en/4bO5Edgmdws7P7mWyGAfy2s=
X-Received: by 2002:a05:6871:5812:b0:1fa:6f5:7b11 with SMTP id
 oj18-20020a056871581200b001fa06f57b11mr831732oac.36.1702069375461; Fri, 08
 Dec 2023 13:02:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231115125111.28217-1-imbrenda@linux.ibm.com> <CABgObfYt3VH-zPwT1whA0N7uE2ioq9GznTt-QhnES8B5tX76jQ@mail.gmail.com>
In-Reply-To: <CABgObfYt3VH-zPwT1whA0N7uE2ioq9GznTt-QhnES8B5tX76jQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 22:02:43 +0100
Message-ID: <CABgObfYVfNsfjy36iBeq7qiV_m3smRKCyOSWQRV2E0OMH1bqAA@mail.gmail.com>
Subject: Re: [GIT PULL v1 0/2] KVM: s390: two small but important fixes
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, 
	hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 7:13=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
> >       KVM: s390/mm: Properly reset no-dat

A small question on this one, would it make sense to clear _all_
gmap-related bits, including _PGSTE_GPS_ZERO?

Paolo


