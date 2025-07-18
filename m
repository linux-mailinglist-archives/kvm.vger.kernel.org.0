Return-Path: <kvm+bounces-52874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4F5B0A000
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76CDE188C39C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 09:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D8E299AAF;
	Fri, 18 Jul 2025 09:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ay3N3eBF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFAB298CC7
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 09:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752831856; cv=none; b=o6zvgVyp4vbrYnLdTEwOHp/8k2m94jTxMb4NEbeoeMj3/5SLuf1BY2S/G3FCtzBT/kEzZ0IxkO0vy4blnE6iBoJQyJr04jpIzJLhZBI05Vr1VGf5OC1U2W8T5qCfXD/D5Y3hYKGVBXlccL9GCCB/N4i8/rglrCRgURRDw027VDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752831856; c=relaxed/simple;
	bh=T53jj+uGYaYf52lKowm0CpjH/Cq7fLwZZogKpiquQjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lulSKxade3WgTyQ4P0nQdr9sS5onPcOjE5HCaaqT6TcVlGVvARDaOUkaK8lGUxP+K0LnGAIVe6z3T8OZWkBd7VpL1Qv1rU1NbKJjRGIAsV0Fh2yJpDUPwYrtfC03MtDe0IPma5T6BlynYpIqZ18QzIumJe2sL5ZXf5ccfgj7CbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ay3N3eBF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752831853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T53jj+uGYaYf52lKowm0CpjH/Cq7fLwZZogKpiquQjg=;
	b=Ay3N3eBFesABuQCUTL+iAbg5xX2Fco53b5u87XHFHAu0NqQst1a24IUKzNW/5mBpSDi9qK
	CY1Aa0bzBGEcCX1z3JvWBx56WAfmmVGv9hxbUX/kc6k6GA9cJdOxsKo2qhiYwMJ5auS2jh
	WA7s/CByaVwCibnMLDLvdWLZFM/cRdc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-mWHWGXOaOcWY-RRZhhv_1A-1; Fri, 18 Jul 2025 05:44:11 -0400
X-MC-Unique: mWHWGXOaOcWY-RRZhhv_1A-1
X-Mimecast-MFC-AGG-ID: mWHWGXOaOcWY-RRZhhv_1A_1752831850
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a523ce0bb2so835547f8f.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 02:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752831850; x=1753436650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T53jj+uGYaYf52lKowm0CpjH/Cq7fLwZZogKpiquQjg=;
        b=RnTIo16qmR+M8knNxDbteS22/+ZdrkMxguz5A+HSmBieiWXWF8bRk7TjuycLGVQ39v
         RZ2ytbNlyaWFuwKp8jxDeIExiOLwRSTD9cTccZ3sqG9t6H0Gz4hJzyx4mLcywvnFEP1e
         w4d6C68u7TtdkhuFsWvxwRrQTinFQSi07jY5TEPaSX5KOaHsemiGLILJ0j0zVO9C0IYB
         o3e1EX2BSxaP3jsXHNtaAbUoCXBFQ501+u0ynxxpPnOwp2x/CfkwWzW4bbwSg6ywKXSJ
         A68qIWB1Bnl+ldWQHU0+2pfUB8TMHiZRzyj+BGxkR6k/wAmcpuyGDp5UVXBm/BnhccMh
         C+Uw==
X-Forwarded-Encrypted: i=1; AJvYcCV6tT2XKj0wcnmJrvKvYrfbjb3Ex2/2RHEkWC4zinFV6Sb0A4t/JBXOapk9kiXVct5ZGjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlGMMF+dXeg5LovsWbB7Uf+k1UxSyIE7/usFBzQ9CLZYclGM6H
	edpGSzA5Hj75T8Is5pz5v0RLtSfE9R6yofRwKo96NUguZIS4nvUSpnufhfMTI8QK8hAVi8N4Ax9
	oLXyf8c81oCOimo3imE/smATsiT68gDVW9bCq2hYrNPz3wcD1u6YLag==
X-Gm-Gg: ASbGncsSWKyvI/7c5/uEVGVIyIhJmce/A5OrJ/AoQnL7H0Ymym576y8Ir0VzfPrS3/7
	VY8a7SrVOeqmpScZLVRS1kN1r/MXX2r/eH4SXPbKNQe+FA4ODdtZdvZqYiiu2L5zFouHA3yF4oC
	8aG3B7qcN+KwaBMYaEqt1SGQ+xqIG7xpDRaLmPtVInRtiNB4GrCQaTtfp5orilbxC3OwBYzsp9H
	Hzio0EWogaFOJ5YzbI5EHzrE1NnCDbdnJanqmeZHpHXVfs9WwHeL07dAEVeUjjuouDg677DP+pT
	8JsAmYzSwwUdT2us+kXZGZHdF/S6aYhmg29JHGkqdZFIUPPf1VBJ7pwMVXJEoG6ohra2iXMo4pE
	thrHC4EtaPcM=
X-Received: by 2002:a05:6000:2485:b0:3a4:eb92:39b6 with SMTP id ffacd0b85a97d-3b60e5188a9mr7814167f8f.54.1752831849695;
        Fri, 18 Jul 2025 02:44:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwyvbO1naMxXvga0v2Mf459n4z6Zb+LqD86VjK+yx3D7c4jUHgFpj1B2IMb4iTSN7BmDYzvA==
X-Received: by 2002:a05:6000:2485:b0:3a4:eb92:39b6 with SMTP id ffacd0b85a97d-3b60e5188a9mr7814146f8f.54.1752831849175;
        Fri, 18 Jul 2025 02:44:09 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca487a5sm1334017f8f.42.2025.07.18.02.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 02:44:08 -0700 (PDT)
Message-ID: <3fe2d2e6-993c-4344-8fb3-ff6625aa91f7@redhat.com>
Date: Fri, 18 Jul 2025 11:44:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 eperezma@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
References: <20250714084755.11921-1-jasowang@redhat.com>
 <20250716170406.637e01f5@kernel.org>
 <CACGkMEvj0W98Jc=AB-g8G0J0u5pGAM4mBVCrp3uPLCkc6CK7Ng@mail.gmail.com>
 <20250717015341-mutt-send-email-mst@kernel.org>
 <CACGkMEvX==TSK=0gH5WaFecMY1E+o7mbQ6EqJF+iaBx6DyMiJg@mail.gmail.com>
 <bea4ea64-f7ec-4508-a75f-7b69d04f743a@redhat.com>
 <CACGkMEv3gZLPgimK6=f0Zrt_SSux8ssA5-UeEv+DHPoeSrNBQQ@mail.gmail.com>
 <7aeff791-f26c-4ae3-adaa-c25f3b98ba56@redhat.com>
 <20250718052747-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250718052747-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 11:29 AM, Michael S. Tsirkin wrote:
> Paolo I'm likely confused. That series is in net-next, right?
> So now it would be work to drop it from there, and invalidate
> all the testing it got there, for little benefit -
> the merge conflict is easy to resolve.

Yes, that series is in net-next now.

My understanding of the merge plan was to pull such series in _both_ the
net-next and the vhost tree.

Pulling from a stable public branch allows constant commit hashes in
both trees, avoids conflicts with later vhost patches in the vhost tree
and with later virtio_net/tun/tap patches in net-next and also avoid
conflicts at merge window time.

We do (in net-next) that sort of hashes sharing from time to time for
cross-subtrees changes, like this one.

But not a big deal if you didn't/don't pull the thing in the vhost tree.
At this point, merging it will be likely quite complex and there will be
likely no gains on vhost tree management side.

Perhaps we could use this schema next time.

Thanks,

Paolo




