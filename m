Return-Path: <kvm+bounces-35640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86057A13887
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F0A31672D3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907381DE3CA;
	Thu, 16 Jan 2025 11:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnQ86GrV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AD91DD525
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 11:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737025440; cv=none; b=BtDoUCbJ+CVDpOVmuffdBMtjdfwBDwfyW41DwpCAOvzuDg08WQukORLpWOZJWpW4Ee0F30MC71nlWtrTdp+VfhCH3wdrSa2TiEY11owwYdjvTOrPjQcuHdFBLsWhI0zo1MIgn+GfiQT3usrVKHEM3Z39ss92e/NVKV/0nGhjS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737025440; c=relaxed/simple;
	bh=C45cCeDrG8vfRtk2jN2h8nbwhRujnplBzaJGVNw8sas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQagndgEnabXSupVuDbLTBdIjVlrtKc6aHdMt6f/DzffTVWbiWraaTTPpcGQMyt08ifZBOsbDmGGszGbLMdyp8FPjvWPmGe2xgTEyJmI2JO7Ia0ehaBonjXk9DCvNnRUow0PkePYk2dvrAOwA0h35JHHljHb7Ai9e5c7iutA0WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HnQ86GrV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737025437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C45cCeDrG8vfRtk2jN2h8nbwhRujnplBzaJGVNw8sas=;
	b=HnQ86GrVIYCk+YP+T++wY52ZbeguEjDvMLddO/m9kOz4BXK2P/BZtIX963qRNCkqA20SuH
	Mag9xN+nJ8RT67cRVoeU3TzCqJuMhdapEz63HHX7O7XagTlWxSDfHR+QO3CW5RkTDaY0Z1
	JYxptnzfx6W/aEvHX2eMntqf/LsbCdA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-7itw328cPbeInsjLT3qTPQ-1; Thu, 16 Jan 2025 06:03:54 -0500
X-MC-Unique: 7itw328cPbeInsjLT3qTPQ-1
X-Mimecast-MFC-AGG-ID: 7itw328cPbeInsjLT3qTPQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e03f54d0so365660f8f.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 03:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737025433; x=1737630233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C45cCeDrG8vfRtk2jN2h8nbwhRujnplBzaJGVNw8sas=;
        b=hdYw9/w5gFkESsFOlRYKU9eU8pgvPmFO/tJxba48qZyMFn6HoIX8bu7Nz/LrU49r26
         hdlxJePh5KEXjHm4zdQHtnh0RtHPpaswQpzpOxdXkiF7llYKtnG88Z7TqwDGSnSi2PoA
         oz+/PQ8aZnHx7yKbLtCL98bliHruqlCxA+R5zIp9rSB/BbFrNzx/ZsXK0J7ajxYqN9xq
         cFQcUF6VtO1wVrtr+0U1IwFFSrPeRWOZdlNv3ioyaYZqj/vlO8TRRXOVHrpnBQHOBAwW
         OviaSG2ieEoLuZfNO8zEhFAYeeaedl7FX06y8/SAZfkGbUX1s1O2HCNMUfvo1w4g79jH
         f3Lw==
X-Forwarded-Encrypted: i=1; AJvYcCX86ACzByLIQ2fOmRK+exDNjZ80PESTx7wYBtavDRSHu7trWtb1ZINp560k0TXzAkcPN04=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHQHHyijGjEJB4cTKt3saRrRl5VqkDlnqYu9ENT+DygoCUL0uy
	RwMmdxOPdhjSfeOvlLsusCg8ujQE3HGKNdkxf5p6xaKN9THjKgwQamBxTxzbS8YDFiOEOGIAQ+R
	iTBAMQWQKKtBWIeYqLyfq5pHp4wBCG1Tl3Y9YEKqu4Qwy3qicSLRZGhdrr4KtIr8SHjDWdaxDsr
	CRxyFU8BeDsDhPBP1QJ/edcnSV
X-Gm-Gg: ASbGnctThrf7F3FiSo/cG+MS0m8UFPotJV9QiAoSo7ARZDBD7o2QuBL6iWJnQX+Dwpb
	y3scVma1tUpCJE+GYrNV9M2yCCRZPnuQteAed1G8=
X-Received: by 2002:a05:6000:18ab:b0:385:f349:ffe7 with SMTP id ffacd0b85a97d-38a872f6d5fmr29339049f8f.2.1737025432963;
        Thu, 16 Jan 2025 03:03:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaNTt1vHhOZzZWy4NQcmShM6eO4SuWbFunAa3Ot9r5t6bktaZBjgEMxn1TBFCcRt0yTKBP7igJNQ0at2y85dU=
X-Received: by 2002:a05:6000:18ab:b0:385:f349:ffe7 with SMTP id
 ffacd0b85a97d-38a872f6d5fmr29339017f8f.2.1737025432599; Thu, 16 Jan 2025
 03:03:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
 <9c04640c-9739-4d5f-aba0-1c12c4c38497@linux.ibm.com> <CA+i-1C3ncij1HLKGOdTC2FtpBY2Gajp8_3E3UrvNBYhs9Hu0dQ@mail.gmail.com>
 <20250116102733.7207-B-hca@linux.ibm.com>
In-Reply-To: <20250116102733.7207-B-hca@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 16 Jan 2025 12:03:40 +0100
X-Gm-Features: AbW1kvYQEtwKNgsMaPFq8rJ4dvHM4rkUCrmKlPmsDFTXQmB104PnitEc_s71utI
Message-ID: <CABgObfYj3ou7Lc7Fmehz84DsFbNrKJNBd+yYZkLm72HWZpQf8A@mail.gmail.com>
Subject: Re: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Brendan Jackman <jackmanb@google.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 11:27=E2=80=AFAM Heiko Carstens <hca@linux.ibm.com>=
 wrote:
> On Thu, Jan 16, 2025 at 11:06:56AM +0100, Brendan Jackman wrote:
> > Hi Heiko/Vasily/Alexander,
> >
> > I don't see any obvious choice for a maintainer who would merge this.
> >
> > On Thu, 9 Jan 2025 at 13:46, Christian Borntraeger
> > <borntraeger@linux.ibm.com> wrote:
> > > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> >
> > Given that Christian acked it, and it's pretty low-stakes and unlikely
> > to conflict, would you perhaps take it through the S390 tree?
>
> Given that this is kvm specific I would prefer if this goes via a kvm
> specific tree. E.g. kvm-s390 :) Which means Christian, Janosch, or
> Claudio should pick this up.

I will apply it to the main KVM tree.

Paolo


