Return-Path: <kvm+bounces-20414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7C99156ED
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 21:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D983B1C2340C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 19:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76ABB19F468;
	Mon, 24 Jun 2024 19:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSVkwK5H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1975D107A0
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 19:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719256128; cv=none; b=YQ8DDTI3YpglQkox3LcdDUukELbwoLtLIdnHJDqqyhJ5Zmr6IkX9I4k14Jc7eQrk7fyCWmDevTE29ZBrLH+iFQGFeAcciX4C6y576bhNCVaCnlkSuggNKQtWoGD8Ylnf1wNBej2XH3QZFck6Co67MNvsKIzhaqa6YITcfiw2J7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719256128; c=relaxed/simple;
	bh=JjaVG4VYl/zHGY1rd8Mwj6b8I9ALgvhWKKFX67QJIx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHexdM0fBrjQk406rAfTWBLnY2U3RRDwuGZMa/IBwCj8/vFJf3FpXZRDqyn34P8ApacvWa7yr+fn4glgmiotrRwWnni8c3xTABgSc6EZqki/e5kZs8pzUfjl/JVOotWyBUqnw3IfxhmSOIFWW94sWQJHFEU7oIK9mnIScm/mM4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSVkwK5H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719256125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5NbdlxVDsDJNiLI0hi7LNVf7vYEbAEAD6zDxIr15Ueo=;
	b=MSVkwK5H901Ts5avCp1tBWxSAsXNWNS+8hUAitXqJdG7ZkqybIgQfM2RSsrF2NU6UA/qs8
	WC/0K7RuZFrktakqG1oKudPFwluoB08i1ajXb9Eh0jaHWJgoI+aTl+XV9FBcNdxtbUCgMK
	9wiMWMbONcbxyBw2ZPkvtRvipgjkaLA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-zw9IcGhPOwG_7UfJe_sUEw-1; Mon, 24 Jun 2024 15:08:44 -0400
X-MC-Unique: zw9IcGhPOwG_7UfJe_sUEw-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6f908f002c2so921816a34.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 12:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719256123; x=1719860923;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NbdlxVDsDJNiLI0hi7LNVf7vYEbAEAD6zDxIr15Ueo=;
        b=waD68tzNVKfhu0bfcn4r7SqxhwBk7+/feqvYL4wUacBjdtMqxNHOK4v4Fjk03awyf3
         cku6cL32OdBv3Uivf7qawS6J8DaWv7N8WPEKDFmMjElAH3pG0YOmUQRu2J3SFQKSaAwL
         iHehK82XLQWMXncTFUZzpglBn+sDeRarF+5R4+NLSCqJx1RY8x166NvDiNiUrf7fUwKv
         w2a09KAGXv8jbDItSLPYvBxKAPVtE6RkN3DY60or4x6AiR3Dvm+OHIETksLyQ2hrR6Yd
         L1/vilqVDBRHDnu7i2alLEyCKjVTMldQ8hvtLI3hycjSfM5QEVh2VbWtXU1v3E7kVJvq
         AdaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPLrXR4yVt17pw1F1kReEdF5TsBCMwPPuf25k2iCdq/zWsitAlNgsgQgqXbbWTdef/YRofp4rXefXA763WDn8iJWXr
X-Gm-Message-State: AOJu0YwqkU4YwNO2oSCywVHDmCgv8OLiz1ed0v1zmSR7aIEX7jqUXfDO
	0F5deoicvIOGwJt2clZ10iFNVk+WjOtlHYvJxeVLlO6OblRy4YObWft3iS35/lpVMBTElNXENz7
	kzK/y3MvENn62eTtbCTGgBbAV2gtGIuWxks+gS570pNoOIjBoPA==
X-Received: by 2002:a05:6830:461e:b0:6f9:7760:522e with SMTP id 46e09a7af769-700a8f34d5cmr7234223a34.1.1719256123472;
        Mon, 24 Jun 2024 12:08:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYbURRoiDZVM4JlbuHnHRwsvKTN4Lm3lmzkoYnqE+znABiUKIk/UWEHozU+pkJQhjE83FP1w==
X-Received: by 2002:a05:6830:461e:b0:6f9:7760:522e with SMTP id 46e09a7af769-700a8f34d5cmr7234204a34.1.1719256123025;
        Mon, 24 Jun 2024 12:08:43 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79bce8b2ba2sm339923085a.49.2024.06.24.12.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 12:08:42 -0700 (PDT)
Date: Mon, 24 Jun 2024 15:08:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Shota Imamura <cosocaf@gmail.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	"open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] migration: Implement dirty ring
Message-ID: <ZnnEOJSSsjG0D009@x1n>
References: <20240620094714.871727-1-cosocaf@gmail.com>
 <20240620094714.871727-2-cosocaf@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240620094714.871727-2-cosocaf@gmail.com>

Hi, Shota,

On Thu, Jun 20, 2024 at 06:47:13PM +0900, Shota Imamura wrote:
> This commit implements the dirty ring as an alternative dirty tracking
> method to the dirty bitmap.
> 
> While the dirty ring has already been implemented in accel/kvm using KVM's
> dirty ring, it was designed to set bits in the ramlist and ramblock bitmap.
> This commit introduces a new dirty ring to replace the bitmap, allowing the
> use of the dirty ring even without KVM. When using KVM's dirty ring, this
> implementation maximizes its effectiveness.

It looks like this patch will introduce a ring but still it keeps the
bitmaps around.

Could you elaborate your motivation of this work?  It'll be interesting to
know whether you did any kind of measurement around it.

> 
> To enable the dirty ring, specify the startup option
> "-migration dirty-logging=ring,dirty-ring-size=N". To use the bitmap,
> either specify nothing or "-migration dirty-logging=bitmap". If the dirty
> ring becomes full, it falls back to the bitmap for that round.

I remember adding such option is not suggested.  We may consider using
either QMP to setup a migration parameter, or something else.

Thanks,

-- 
Peter Xu


