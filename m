Return-Path: <kvm+bounces-56697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1707B42907
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D20E3B1F04
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF61369322;
	Wed,  3 Sep 2025 18:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="QeU2wHM0"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79821C861A;
	Wed,  3 Sep 2025 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925397; cv=none; b=NSmd464Rgaw6S85dXdEDTnyQq+8bvj1W/fFerFp+qG4ZLN+iiZNNFayIuYWVf1Lu9lQYfcTiWldThI8cCSmo/xPThytcnlAF22Y9+c54HW84TcNI2GT5s28stiUjfWVv9Ngd3AOEeTdQqP8Tz9zBry0dMW7Nip2n5ScjZiNywak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925397; c=relaxed/simple;
	bh=MC/9g9J5h0rJG0IaIej7NVOiWmMnKIKb77QUuLRncks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZANIzmumKWkR9RnHKPVkj+rKoy0Qj2CAX9WQLPj2FusH5D4ByOkGnx0lqj5ByX8o/BRZTX/4XpWtVyetmVdUExx/j/CnH6HxPCTdDvFNpQUie4OwJHjNo1Fy7fWxiTCuN4xOlKa+dCCbK1z/kuhQUi5u4gboycGCkRZd/rCSxYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=QeU2wHM0; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583InqQq023656
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:49:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756925392;
	bh=MC/9g9J5h0rJG0IaIej7NVOiWmMnKIKb77QUuLRncks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QeU2wHM0YGEjN5c9wxIwJeiSob3h05kF7NR4ycdgeSGy7cid/W6tW0Im+LXAloyll
	 FZiZYNq9Pb6M1Jbmp1lQ+XjLXAsrgbx4mitWOUZOfgahWiMsdJft/a5UiepGKQUPHZ
	 X24BwLVg5jp1tY8BzQkNaNA5hCh1hmK2xrvIuPVc=
Message-ID: <75a65d7c-9f09-40ff-b984-83a9c1cda7a5@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:49:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 2/4] netdev queue flow control for TUN
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-3-simon.schippers@tu-dortmund.de>
 <20250903091235-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250903091235-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2025 at 10:09:55AM +0200, Simon Schippers wrote:
>> The netdev queue is stopped in tun_net_xmit after inserting an SKB into
>> the ring buffer if the ring buffer became full because of that. If the
>> insertion into the ptr_ring fails, the netdev queue is also stopped and
>> the SKB is dropped. However, this never happened in my testing. To ensure
>> that the ptr_ring change is available to the consumer before the netdev
>> queue stop, an smp_wmb() is used.
> 
> I think the stop -> wake bounce involves enough barriers already,
> no need for us to get cute.
>

Yes, you and Jason are correct, it seems to be unnecessary. I just removed
the barriers, and it tests fine!

