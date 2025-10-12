Return-Path: <kvm+bounces-59843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B243BD0046
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 09:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E411434878C
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 07:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C03221FB2;
	Sun, 12 Oct 2025 07:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdmKOPcL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BE120B7E1
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 07:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760253990; cv=none; b=YyuEHE73xLQAkGi7cmHuviXPdjmdZ6xdbRdBE9sxfXBVdmUYPqFX0rRmRNp1FGiKcD/LVl0f0nZFUmM4im5cbdyWGXwV1XKPjMUGYqVeuJHBLSrjSrTmkFCavVd1cHKEILmMXLF9eM8/ayNeX0X+jvU3tPTq7ayg3dxmksuuwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760253990; c=relaxed/simple;
	bh=UEv2x/Lmp84MhY9spkwvdA5qI6xvme3Kk+89d41lEWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFq6y6sWksPwKlbdizI3ZEYdiU3WpE/OPAwco4goubCPomd1OTQyJ9ij7n7d67MNlXzbbmln/FfK00U1eYrO6V76KF5sQrNI80b18SAgNQp+nOOAvM5C5FukUxh0JiTipfV5sRwf9L/OmeehIzqpr6EuyPFc/uhuOztWXe4Fc1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdmKOPcL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760253988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mg3HCPvWm6jwVlci7BHs0yCEk+Zd1iOvD/o3EJNM9JE=;
	b=BdmKOPcLGmHQBCuih3yJFx7ptznKkA1R7ar72zjy/HdeU79B4j3gBOG4qmW1b2cZ9yQjGO
	1k44Qsh750Ox2XutuhHIGl8sj//CN9znl0zcIjsEGRVHc2S6ZfzeWRUwpNjQZEzhx9FheX
	j9TmfmDgkoECLvNBBxPAcLsqrwnoJpA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-DHNnLtvFPgWcFGJg0E0WBA-1; Sun, 12 Oct 2025 03:26:26 -0400
X-MC-Unique: DHNnLtvFPgWcFGJg0E0WBA-1
X-Mimecast-MFC-AGG-ID: DHNnLtvFPgWcFGJg0E0WBA_1760253985
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso17584265e9.2
        for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 00:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760253985; x=1760858785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mg3HCPvWm6jwVlci7BHs0yCEk+Zd1iOvD/o3EJNM9JE=;
        b=rMvrgXiPwXcje44F1UoGBOpKQVI0RbcEVLJb6PKy1WrgxsCXmaFC0FAcKInU1IABAL
         Huik5tZuncDpqndVsv5MhDp8hgelhd8C7bO+1D5B0p0zFDODOGj7J0+zZSuXiAOLebuc
         e8yG3pH/CuNCaxYWVVYUw6vP3+Y4Tz2ZjxSAHVlE+0kKKBleZ0vQq5U0bhJZMCVIIcne
         CvEybovkLq/Q+l2Is+ByBPKpAtnsRd21vLP7+HLsEwROw5BnyDPyhjA/fz15GpsdM3Ir
         BDBq5JZcFqbte3BYWeRRyoLbKeLpOR1BYqoQjwS64alwDaB4AJNpxGmZ315MD1VBLXnl
         8t9w==
X-Forwarded-Encrypted: i=1; AJvYcCUuTrlS6QQ4lcaXEcbuxZ2QqOz3inu7caJoE7fxw5ZrdgChF5tftHxjwA7LdOJgZYjIUek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzm+RO1v5Aponwly9+eWPYbofUphjZv1fv6xqwBpyPjCZrjqyB
	DpOhPuSlKQZ9I+fdgfUnyGxcAsAp1CRMBtaS9vn4ce/8g2KvfjerrAA7xtQtDxWZzBbk6sSYwKC
	4QK/5yuN7ppgonqtiD6+zqKKi6B7gqLEm+Uvq0ovL8r6H/3dXAPP+5g==
X-Gm-Gg: ASbGncuGicHBkLMTmMQFHWAJmcgxY8P1Vi3DwsjtqEM6VIutCeJDQcX+VnB4mOZ3jXC
	YZGp2OnMiIZY9sN5up7Ue2rQ/hisismILcUS21UcI0rgrvdBmNtm5H98O/Ca08Nu9Jxxlujrgl8
	xTkL2UJSvgRjm00HzeTnJYDfZ6MxKo9/SLhgEfiLjQP7o0xCezkdaSSOqFnzhDysN5yWPFUOOvE
	CeYaueaNJDv8FUSjqKE1de9BJq1OvY5GJAHaHaWCNOvcPlWSmoa5JgftQchWTWggwIfZQeX1a4s
	ezcrQ0BTbvsNjNKRYanyEDp6XBeSMFRB2w==
X-Received: by 2002:a05:600c:1c96:b0:46f:c0c9:6961 with SMTP id 5b1f17b1804b1-46fc0e7f6e7mr21553995e9.14.1760253985224;
        Sun, 12 Oct 2025 00:26:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3gaXMtNNYza81JdpwSjq/QqGvQLh5iun4C2wC9jv6BcMxYyPNrpdbHApBSwlfgxaXbiFriA==
X-Received: by 2002:a05:600c:1c96:b0:46f:c0c9:6961 with SMTP id 5b1f17b1804b1-46fc0e7f6e7mr21553775e9.14.1760253984757;
        Sun, 12 Oct 2025 00:26:24 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb483bcf9sm127107785e9.6.2025.10.12.00.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Oct 2025 00:26:24 -0700 (PDT)
Date: Sun, 12 Oct 2025 03:26:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <20251012031758-mutt-send-email-mst@kernel.org>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
 <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
 <20251011134052-mutt-send-email-mst@kernel.org>
 <c4aa4304-b675-4a60-bb7e-adcf26a8694d@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4aa4304-b675-4a60-bb7e-adcf26a8694d@lunn.ch>

On Sat, Oct 11, 2025 at 08:52:18PM +0200, Andrew Lunn wrote:
> > That's not spec, that's linux driver. The spec is the source of truth.
> 
> Right, lets follow this.
> 
> I'm looking at
> 
> https://docs.oasis-open.org/virtio/virtio/v1.3/csd01/virtio-v1.3-csd01.html
> 
> Is that correct?
> 
> That document does not have a definition of word. However, what is
> interesting is section "4.2.2 MMIO Device Register Layout"
> 
> DeviceFeaturesSel 0x014
> 
> Device (host) features word selection.
> Writing to this register selects a set of 32 device feature bits accessible by reading from DeviceFeatures.
> 
> and
> 
> DriverFeaturesSel 0x024
> 
> Activated (guest) features word selection
> Writing to this register selects a set of 32 activated feature bits accessible by writing to DriverFeatures.
> 
> I would interpret this as meaning a feature word is a u32. Hence a
> DWORD is a u64, as the current code uses.
> 
> 	Andrew


Hmm indeed.
At the same time, pci transport has:

         u8 padding[2];  /* Pad to full dword. */

and i2c has:

The \field{padding} is used to pad to full dword.

both of which use dword to mean 32 bit.

This comes from PCI which also does not define word but uses it
to mean 16 bit.




I don't have the problem changing everything to some other
wording completely but "chunk" is uninformative, and
more importantly does not give a clean way to refer to
2 chunks and 4 chunks.
Similarly, if we use "word" to mean 32 bit there is n clean
way to refer to 16 bits which we use a lot.


using word as 16 bit has the advantage that you
can say byte/word/dword/qword and these do not
cause too much confusion.


So I am still inclined to align everything on pci terminology
but interested to hear what alternative you suggest.


-- 
MST


