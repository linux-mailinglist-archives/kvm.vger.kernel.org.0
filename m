Return-Path: <kvm+bounces-43151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ABC2A85A16
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20BBF1BA242A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0613822129B;
	Fri, 11 Apr 2025 10:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fDpMayJk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF288221261
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 10:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744367564; cv=none; b=qnMgUeax8eUQRnnabPIMGtyPDm777m6l1OVvYPflXo2Dkesaf1zkKCz4VD38UnuTMzLzC+7CGUXTjOCI3ByZvXeIN8kVq+ip3ALgyRYK016oxpT5kJyLNPrDBtt/cPmn0ZggdiCAgLzwQ8h4z70L80yBB3oqV+hK58bQkuIv4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744367564; c=relaxed/simple;
	bh=dZAp+0aFkf7MK8MICOzGUOv26hrZwzczT8o2iMxm/5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cg+4O4I/CLYAXiaYSGPS+O/TxNdIlrArcEUwQ6peslXc55fO9jgi7tVYS+hEchzhjbEdyHLjp3b/uVCWWpFwTYdocP3ecOaQ27nwsaFMVeVtV4gEydHYUyHMvbpvfO15RrLbETMfPopepcdTzlfUGofaI4BIWfH3xDaUnSihEVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fDpMayJk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744367561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Y+9d61eT9fS3Nx5t35n8P/kCjRV2k1+1b7KNobnOYs=;
	b=fDpMayJkSg33a8nNW13J6HEbmekXc+ztNSfeKx7/lV4VTPzhxgnTkj6lO4smChmDb8jag2
	tcRy9tmC8bE/OBUTAHNSN0waJndHnlfwajHhq18QGfeTEV28OTn7a4I/a7YCM920eDDg5y
	7tLSwWn3nkum1WuQNTiwcrKKLyGimpw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-MWEYP4RRN62b5fVGVo1FYg-1; Fri, 11 Apr 2025 06:32:38 -0400
X-MC-Unique: MWEYP4RRN62b5fVGVo1FYg-1
X-Mimecast-MFC-AGG-ID: MWEYP4RRN62b5fVGVo1FYg_1744367557
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e82ed0f826so1776807a12.0
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 03:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744367557; x=1744972357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Y+9d61eT9fS3Nx5t35n8P/kCjRV2k1+1b7KNobnOYs=;
        b=TD41M9B56G71cY9uofHf42d4hlq3GZmi++c1MgQ/A1xM+NbgcwzPGEZy+0/mCS2ODo
         Mkz7U+v3j/DIgSZD2GDUz+JoYGJl3sxuqGEtdrEeWBxd2b4/ZILMqPf+DBalwoxtI+Dp
         RpDyAr5Ur8I+nGUApAMZAszMob6H34lmyKL7upfG2J0ueyf1laQj2h1Spt+Kr/qWsAt7
         2xC43kaVCNZHywW7Yr5hyiHV4TmUQiRyDo7zYoFKEa+Yggl2b2A2tV+adrFuN1Nm9G0F
         Eza+uYNKBVc23xT2AU8oul+zUu8kFuFrJxP3W93lhUOU9STTZnT2FLaxBLljcnaSRRxu
         pksA==
X-Forwarded-Encrypted: i=1; AJvYcCWvSMPiyeR0ZBGK+h+XHYiHTzRbIVa+xAL+BNunMm33cSmvCLshDWovyMZME794N88uwuI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx17R/uTRA34kz41+U/L2r/eMoTtzElczGVXfi+ivSXin18twWi
	MJbJHMduYLY3vHxhL2LXoXr5+T/IFX8iFmLSrTvbX6xovMWqv5poSpfUJ44HGyyADYpCw9Nlf2n
	KfP2NtRUNPLx3R4/+95LnrjICkmd4gmQp/MYs46ty4/2RuhsESw==
X-Gm-Gg: ASbGnctJLDRlKy3g8a/xBGjXRRSK45pJ+mA+A8FUg2mcgW/FXctmi2UIjnNgjIgrc7J
	MRtE7mV0yx0ByQgQvfCnOMe2nJA+C8NStkw3vfq0kgmNR+BFlivnxvGmoZ7n3sWrnwhmBGlFfNH
	5fbL7PlpLBqDE34pR+LPO55+ciHuKQb9CFUKg+CBEY5djBhIvK0nPkqgWSG6c+XKqLe/BGxqSAq
	Ufp6AC35N1KtoH6E4up+fnHpCRXoF/t+FY3JNkbDAFemMz6CbKY1xHvNv1w1fk+3P9RxTqcCEAb
	vhoOUbwKCSpzxmbdunisi046eUC3XQdIwtfmTPfJiDCdZKyMqac9PhqXNC2K
X-Received: by 2002:a05:6402:5106:b0:5ec:cd52:27c9 with SMTP id 4fb4d7f45d1cf-5f370298d8dmr1508119a12.31.1744367557263;
        Fri, 11 Apr 2025 03:32:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+YAD1Ckz71pvCMRdEbnpWp0EQ9xGd4Ocngq4UiSw7duGE/YHv0R0ZgCt/NsMlKk+AEHR8Kw==
X-Received: by 2002:a05:6402:5106:b0:5ec:cd52:27c9 with SMTP id 4fb4d7f45d1cf-5f370298d8dmr1508083a12.31.1744367556669;
        Fri, 11 Apr 2025 03:32:36 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-213.retail.telecomitalia.it. [79.53.30.213])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36ee54e11sm789475a12.2.2025.04.11.03.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 03:32:36 -0700 (PDT)
Date: Fri, 11 Apr 2025 12:32:31 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Michal Luczaj <mhal@rbox.co>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
Message-ID: <hu4kfdobwdhrvlm5egbbfzxjiyi6q32666hpdinywi2fd5kl5j@36dvktqp753a>
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
 <22ad09e7-f2b3-48c3-9a6b-8a7b9fd935fe@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <22ad09e7-f2b3-48c3-9a6b-8a7b9fd935fe@redhat.com>

On Thu, Apr 10, 2025 at 12:51:48PM +0200, Paolo Abeni wrote:
>On 4/7/25 8:41 PM, Michal Luczaj wrote:
>> Change the behaviour of a lingering close(): instead of waiting for all
>> data to be consumed, block until data is considered sent, i.e. until worker
>> picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.
>
>I think it should be better to expand the commit message explaining the
>rationale.
>
>> Do linger on shutdown() just as well.
>
>Why? Generally speaking shutdown() is not supposed to block. I think you
>should omit this part.

I thought the same, but discussing with Michal we discovered this on
socket(7) man page:

   SO_LINGER
          Sets or gets the SO_LINGER option.  The argument is a
          linger structure.

              struct linger {
                  int l_onoff;    /* linger active */
                  int l_linger;   /* how many seconds to linger for */
              };

          When enabled, a close(2) or shutdown(2) will not return
          until all queued messages for the socket have been
          successfully sent or the linger timeout has been reached.
          Otherwise, the call returns immediately and the closing is
          done in the background.  When the socket is closed as part
          of exit(2), it always lingers in the background.

In AF_VSOCK we supported SO_LINGER only on close(), but it seems that 
shutdown must also do it from the manpage.

Thanks,
Stefano


