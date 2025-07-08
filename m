Return-Path: <kvm+bounces-51740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9AADAFC3C7
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C5A4A05B8
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8FC259CA1;
	Tue,  8 Jul 2025 07:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPD77ooU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442A21B905
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958733; cv=none; b=FObI5AR59CBH3s1DbDX34vP+paTs7UXIvRXBYI5eStpp1/SRmjSfjjwKngLep/1QhBAmZXeW8tke8pgFvUsSDGQHXuL2mmsN+thTdxb882QNtWIDQIcRoKCsLWgYz2VBhIop9N9cBRiFLEra+aPuzpFJm9itRM0YrQ5Fku/yRW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958733; c=relaxed/simple;
	bh=5lwDy8ZYNMTW4ldI2+BzIqOokv8FO+QSb76sSEuZo+U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bUBOaQ0NA582Z6/VTUBsRTTQNeIYyGhUNWRZpd/UlTZhdh6IfiRyzB3T7M0Vbd3qo/ncR9sckTpv4AV/DWXAvGwMsoXnbPWYknUHHHXSoF7GBF6lA81WzylveuujikL4TTeucyVmrBO57f5DO/Q2L1A6bkrcRfOxmm/ajVyUyF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPD77ooU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6al2WSZTd7CdtJL8s2F8tIL0jpPencH2sAuuH9551kk=;
	b=jPD77ooU7phFiE5STtPKn0Xyd+sK3S85WODUOXRIiH2C19IFUUIJNJ+NYQpIJM54OdR21J
	I/B02ppqwpADDHnScNlBFjRiHRcJcEqIU70LS9D5kJDlwEMXfALXgT5s6xWhPRSA+4XvI9
	700EfV/o8TZ9LXgSqPUUMQkAUbsa+oQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-hZwCcSHjOUa6aY7T9gZPww-1; Tue, 08 Jul 2025 03:12:07 -0400
X-MC-Unique: hZwCcSHjOUa6aY7T9gZPww-1
X-Mimecast-MFC-AGG-ID: hZwCcSHjOUa6aY7T9gZPww_1751958726
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4e9252ba0so2112129f8f.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 00:12:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751958726; x=1752563526;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6al2WSZTd7CdtJL8s2F8tIL0jpPencH2sAuuH9551kk=;
        b=KuIEfeHMyOHJQcjxnqqQD5Huh7f2+Sh4XUbz1uvCsn+06LWbOxXoGt8MqHvKEEiXHt
         XdeALOFVIPMvYCPrTwgXnqAMU0mmiOrJDDDkHN+IuF++oMssdPDvYcvzt+xL3yFv7t9p
         e4+MJZqCtWBBAGAXc/3nax0ulCponDqvMlVfZMcImAr/+RQQ+d2yKkvc9olJH627ixmT
         CxqkorhuZkWK17lybiBu6t84UqDHDOQPhu/prcwV+ye0q4XrIt2YuEmIKSXBn8cB9oIF
         M0Y3bd/871FrTsL09UKS8ZwzdgJpClGwZPclaJYYCMcKk1qyXOBDatCkfam0Ke2BeTm4
         EE4g==
X-Forwarded-Encrypted: i=1; AJvYcCUDvXa++/cwFVh4x6T23yt/W6RhQ8pElOl8oP/uoKCHtiotwAo/D3otrnDqzrVxZebfpZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Zh+72wUpQcqc7TG3IK57xuLR9Ik4te9gWyiOEITuYGO3KfKM
	nWkBmiC/b9PFdHuirkv2fVrW6hArqkZuAmJrsI6iTU30Q4nePWx1oOUYAlgLujX6RlDsOORi5O5
	cKiH/0MvYmMDmGFW/jqLWUC7uz3HHqD6tmnnLfLRm1zzQQot4TSe6gg==
X-Gm-Gg: ASbGncsGBWjnszpTfnAQgfOWPnKb3TReePgPLMR3kIpZG9NU5KthffEhgsCVY7AcFHM
	zMNoB+MaaPi0cONG9IUlNtVos6wnCwUHGla/sFeuAVsbJrM55stSnCTUUfpTU8nHa6PQbugUWHw
	Dy0MonmAkcr0YLwO2ysAkeDwX6sLMelQFB21ub+VQKv9DGa7LC0d020FiTz97qcnHkAc1hNxoko
	xdf+W6IhEMoBzpYYg/CbmuBX1oDzjANpEEcBZxaNI6HG6InU3eqfhvtwntrXIUhsz7ZPa9T5ZSA
	wZx0+CMA1ZH5nCFh4e6AszRoE1SEjYwvLhknDYv/ecBFZVjzNldC4J4fEb7oUBR+H1OWDQ==
X-Received: by 2002:a05:6000:2289:b0:3a5:2ec5:35a3 with SMTP id ffacd0b85a97d-3b49661da34mr13442614f8f.45.1751958726394;
        Tue, 08 Jul 2025 00:12:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUa0YAy1NBgIDOiXc5gNSB+BOVkjsJ3ZjAZUt++LCSItxzDjYj+HoOIwwZ6aldycNJxaG+/w==
X-Received: by 2002:a05:6000:2289:b0:3a5:2ec5:35a3 with SMTP id ffacd0b85a97d-3b49661da34mr13442567f8f.45.1751958725979;
        Tue, 08 Jul 2025 00:12:05 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2717:8910:b663:3b86:247e:dba2? ([2a0d:3344:2717:8910:b663:3b86:247e:dba2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cd4938ffsm12723525e9.21.2025.07.08.00.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 00:12:05 -0700 (PDT)
Message-ID: <41eb8d72-bfa3-4063-88af-1ec23593b0f8@redhat.com>
Date: Tue, 8 Jul 2025 09:12:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 net-next 0/9] virtio: introduce GSO over UDP tunnel
From: Paolo Abeni <pabeni@redhat.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1750753211.git.pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <cover.1750753211.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/25 4:09 PM, Paolo Abeni wrote:
> Some virtualized deployments use UDP tunnel pervasively and are impacted
> negatively by the lack of GSO support for such kind of traffic in the
> virtual NIC driver.
> 
> The virtio_net specification recently introduced support for GS over
> UDP tunnel, this series updates the virtio implementation to support
> such a feature.
> 
> Currently the kernel virtio support limits the feature space to 64,
> while the virtio specification allows for a larger number of features.
> Specifically the GSO-over-UDP-tunnel-related virtio features use bits
> 65-69.
> 
> The first four patches in this series rework the virtio and vhost
> feature support to cope with up to 128 bits. The limit is set by
> a define and could be easily raised in future, as needed.
> 
> This implementation choice is aimed at keeping the code churn as
> limited as possible. For the same reason, only the virtio_net driver is
> reworked to leverage the extended feature space; all other
> virtio/vhost drivers are unaffected, but could be upgraded to support
> the extended features space in a later time.
> 
> The last four patches bring in the actual GSO over UDP tunnel support.
> As per specification, some additional fields are introduced into the
> virtio net header to support the new offload. The presence of such
> fields depends on the negotiated features.
> 
> New helpers are introduced to convert the UDP-tunneled skb metadata to
> an extended virtio net header and vice versa. Such helpers are used by
> the tun and virtio_net driver to cope with the newly supported offloads.
> 
> Tested with basic stream transfer with all the possible permutations of
> host kernel/qemu/guest kernel with/without GSO over UDP tunnel support.
> 
> This is also are available in the Git repository at:
> 
> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_24_06_2025
> 
> Ideally both the net-next tree and the vhost tree could pull from the
> above.

As Michael prefers to hide the warning in patch 4/9 and this series in
the current form has now conflicts with the current net-next tree, I
just shared a v7, with a more detailed merge plan in the cover letter.

Thanks,

Paolo


