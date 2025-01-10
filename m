Return-Path: <kvm+bounces-34976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DC2A085EE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87ADF7A281E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 03:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3E3205AAE;
	Fri, 10 Jan 2025 03:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LAMEy2WH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C9E1C75E2
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736479650; cv=none; b=sdxZ1VyvXRRKOnq6jqaYw3d1qOAmvKKDlP+wayDmzeLeIrDFYBLn2mMWIBj6oLjWNpevtWb/qJnkMBT044b2UFnz5JJrzxiLFTXc5Iwud4fgsL+iRBkYo1mZPZ541DnANFavPaClO/kj7QGxroLeuyLs3OQDzBiN0FYi4k56fys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736479650; c=relaxed/simple;
	bh=7uR8vN0M0CFh5qpZV7D1vSWR3xVu4IYzXqUeioDmijc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kFS0ObBMqTfVAEFItRGl5loM2Zh1xIDLUM16O7LhoRGIFG3Ttaw1rmYUCUK/bRgn4PtsHV4mgKZYGSLO4jaK1OJwlZM866xSkVchEdCYJsCDbPnxZ0HzYTHXRufEmX76pshY88GHB0FSPGmiME6kHXcVof5NWbibFspJk8YAOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LAMEy2WH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736479648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uR8vN0M0CFh5qpZV7D1vSWR3xVu4IYzXqUeioDmijc=;
	b=LAMEy2WHIppx4eDngWDwKFjhKXrx5SjLgw2Ri96nV+Se8CAk/1DjSBpIcP7gglTZ1VaWbW
	+tJnTdI6NypDGTirlITf6bl+HKofFIgthUh99UuVJXQLTB8/mcTwGYCh26iY4gwfuu2DDr
	hwZJtSm5qdSRbR0ZH0+9a409jOwOJc4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-B3LqVj9NNo2eDIii0OEkKg-1; Thu, 09 Jan 2025 22:27:27 -0500
X-MC-Unique: B3LqVj9NNo2eDIii0OEkKg-1
X-Mimecast-MFC-AGG-ID: B3LqVj9NNo2eDIii0OEkKg
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so2863432a91.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 19:27:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736479646; x=1737084446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uR8vN0M0CFh5qpZV7D1vSWR3xVu4IYzXqUeioDmijc=;
        b=NFC8IVjr0UPNVxPhaJ9aT2sFrqsSwSKptYf6oGtrRfq726TDNrj9kYI2uREmVLEaWy
         AZMdanBsKB3Zjr7l7kMharY1VtKz5ztFsybRRKKZBX7ZcrDmZmvlenCbSGKzChQVy/Mo
         Wd4X1rHzAg9wSGju4K/IqzkVBgKb9s4cjY7wvTpeMAEwRa/30o3KOmjm0ONq8BdLSKER
         RaTwY/hTH2K/zFS0hgpJsqSbaBAlRhd3gclCxd4dEcNAm5IqQtIrqrMmXuDiaUIRiI3s
         GLXS0+++pm4/AfhLR0ANjvbU8Lp92+dlRPmQCbhkUi2ZehC0YHk/l1UFJxaj8LcJmxc5
         9itQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDHAJ+UqpwKzFRBNrjOQtoFkExR1wSdyoNOk5+UXlHgwpuLmX9Lz2RiABhR9DU76AVPzM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+N3003nRbpF01bjQJPuMQtAkacig82bm0AQgYippt/AxS7QIu
	Y5rB+RNJsF8ntHcnxSB4Y4VL91nd6yMQ2wwgft5V8lgqvAZlXLhWLW6F2pQq2B8v0Gh+KELp4EQ
	baype8xKDSQ01SKk7mWH0Kp6VHVR0Fs84XaM7n5UFUe1RRBuD6FqQXL8r+FYCoQft3ZTM7MHqJf
	1phy1Gbl8H8RBoHE55iKledHWm
X-Gm-Gg: ASbGncuCj6k8o/eztmHbsibfewDoN9efgdb8jTak597kzP+liivenI1t6mlJNqNftiN
	7Gq7xpSqu2KlIk4+Sr9XBjVobpYbM31yBOLEtQL8=
X-Received: by 2002:a17:90b:2f0e:b0:2ea:59e3:2d2e with SMTP id 98e67ed59e1d1-2f548eb9e0emr14161333a91.10.1736479645904;
        Thu, 09 Jan 2025 19:27:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGr6qt6YqI8gxH2NjDJ69HLIEFDu0/JDwyZCE+11GxsqEEXtLHHfTQDNxjuhLS8NYQPmojHsZtINe9boq5qSYU=
X-Received: by 2002:a17:90b:2f0e:b0:2ea:59e3:2d2e with SMTP id
 98e67ed59e1d1-2f548eb9e0emr14161300a91.10.1736479645509; Thu, 09 Jan 2025
 19:27:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-3-388d7d5a287a@daynix.com>
In-Reply-To: <20250109-tun-v2-3-388d7d5a287a@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2025 11:27:13 +0800
X-Gm-Features: AbW1kvZyiy6igQIYtcT2bEIGGuMlsgd6CYsI8IZapQaNgu__KkmEtAKFahTJbko
Message-ID: <CACGkMEsm5DCb+n3NYeRjmq3rAANztZz5QmV8rbPNo+cH-=VzDQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] tun: Set num_buffers for virtio 1.0
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix.=
com> wrote:
>
> The specification says the device MUST set num_buffers to 1 if
> VIRTIO_NET_F_MRG_RXBUF has not been negotiated.

Have we agreed on how to fix the spec or not?

As I replied in the spec patch, if we just remove this "MUST", it
looks like we are all fine?

Thanks


