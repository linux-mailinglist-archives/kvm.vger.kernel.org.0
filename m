Return-Path: <kvm+bounces-41599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEF7A6AF79
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 21:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC4DF171071
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D4222A81C;
	Thu, 20 Mar 2025 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kw4+33ct"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9308622A4FC;
	Thu, 20 Mar 2025 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742504220; cv=none; b=sR2HZFgIB8xl8fizzXbag6Ce23wMINDdVCOb1Azaa2T8lOpzeIGiKrmKi9XqLioEjZGRXpE+zQXVKNJnKsDmthEM8mbe5WwKKSXffqiWQQMbDUmAqaORTAhE3fHnaA4xGX0Lk6NmEK7tlsAH6Cmk+QaYvpG1FHDeb0As9ALE0GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742504220; c=relaxed/simple;
	bh=YbkcEp08crIyVSJNAbnRj22WAOqP2FQy1uoUXoMkAOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFxZjPQKHQKd+xHdOXHAy9ATPqpgWUfr+l72Gl9k4TRZ4QdXzUhnyOa99E34jcxSRl5yREodsAx1gdilUJM/1am2gEA1tFndri8qN6HF0MEirDqiH1UDFr3+nN45X8tN0l+495D2PEw9NWVUfE7dk2/ms6MSwO21cmecdwr9za8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kw4+33ct; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224191d92e4so25755745ad.3;
        Thu, 20 Mar 2025 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742504218; x=1743109018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eHYP+FzwYtTkT6zfxoUjmlhsBz/CXrX0uDvDDrwF0V0=;
        b=kw4+33ct51EfPlJhCcKqO5g922PQ7DCcJE+qjcHH4XADKRxFO8mmv7Tbmx2GJ1Hk7t
         90KNXfrL9yhX7Ksp3/ttuF7Ej5bQYQGSj2Bvfiip3hjlPIjFPzS7KojPb/PsrTggpmNW
         GIvC1NvulLYHaCa0jv2EZlBw6MWwn9cPShSAmq5MuEtUeGUEymEasjERCIu8HUt4s/27
         vPQIMFBNgLnqMa7FJplHci4uT4/zuhQjP+QSwIxk2VDgFcH48D1UwzkoSdKw1vxr1iQL
         ZTfTN9MO657w5eUTKrXffwzR66TL9xzyTcYCFlGU/8DJ/3cYj+AOVjnlnlj56HbojR+F
         Y6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742504218; x=1743109018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHYP+FzwYtTkT6zfxoUjmlhsBz/CXrX0uDvDDrwF0V0=;
        b=VORLGq+yuwGGmDr8EFgFh/vDbD6F3vOVaU9y5APoFFdhrHWEln4ctJ7dISyhhkbbGR
         ZeWLxEOqL++13SyJKq+EUJxAytmeSsZmFq8WamiRtBNLLqrbMOGCRTMOd6/e9nixX7PI
         K58NaCJXaWP+0Ni+CJ7pul9c09QAVGrTyj0phWoU/hsy40AyJQSJWmdzXUmdktmDy8Vd
         n9SYEKbywHsSH0aos9j6oElQg9mrOokXQ/7JgttjxTjgaNzqAmhm8zZwSgrE+0I9yjtj
         xYTRU17DUoOB6Wf7ABi8JbHPzeCCO5hMW4xyDwJUgpoX+7EwVseqtEOTT2kCoj8rZWFQ
         ca+A==
X-Forwarded-Encrypted: i=1; AJvYcCUCgYmK3atSICMkxV8B2YAAJsJk6l2TTJzgF7clsk5Vx7irE4V+6ZJhceGsh2ZwuPgDOdHpIBXj+/0lZVLJ@vger.kernel.org, AJvYcCUem1CM3RchU9EBYR3NrOOvTJW4g4oi5Xmxm2pCGGzNqtbeuEXjDa6F+OjpMuvPFFQ+ExSFrF6RvswgnLki@vger.kernel.org, AJvYcCVTWwrI2MSd8XwiaAmsT5+uPNkg1Ap/qg8nVY7yr7GleWVVFLuq4QAi0V7+3jSRiBwiKsw=@vger.kernel.org, AJvYcCXVUzcJCrjQFBt+ATAT9sBIDmP3s/oDKML5mVG7xlwjWYxPut3qDQMVX5ZMIS/4efaVdAZW79MH@vger.kernel.org
X-Gm-Message-State: AOJu0YxQq1lcGs/yASX9JIUYDs86sPx8rHLXBgWmRt0iOeOdbsY2P2SD
	QYHwoPccITu53LmctBKlJ4/6z2dcKSh4iru+fNX1G700iGzmrxzA
X-Gm-Gg: ASbGncsK2LmMuJYEVUvpNR4qf/Vf9G1N9HqdfFPwPOMirnG+M0TFGdgHaY1EtOktMh3
	wbheGtW6ZFMnTy1wdybOyV7tdPdpD1oPKiHCck8DK5r6qoQ9CJQ0ZTGp+7aUDj8klA3QbQOkhO1
	xAc+MTT8EGXYjv17+fpc/BV18lkVJYuMI0z+9sgJDcMnuEsr0PadxMvc9+dJwgiom6qslUlomqW
	tBvTstnJi4y6jFnwcOazplv0WiuyACn13hi4oHcGRyCdx2ZydvYCsLnD1l9bQJE3moI7HBr+eJF
	/OB5++oOSLALxznMJ2Nlx/7I2UGC74kSgWtCbwjI8OXE2w3QR4Ao+j5mmrr50b0pQA==
X-Google-Smtp-Source: AGHT+IFObV1UYBWVHJijbUkAFQ5WtUBQhMfiBb9p0afEFRGISPI3ams4CTR87ewzq5lhgqlJcABDfw==
X-Received: by 2002:a17:902:d48a:b0:223:2cae:4a96 with SMTP id d9443c01a7336-22780e3fb29mr9391595ad.42.1742504217670;
        Thu, 20 Mar 2025 13:56:57 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2278120981fsm2384085ad.250.2025.03.20.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 13:56:56 -0700 (PDT)
Date: Thu, 20 Mar 2025 13:56:54 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vsock: add network namespace support
Message-ID: <Z9yBFrmGLdKzfgBd@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-1-84bffa1aa97a@gmail.com>
 <sqvqvlovlxpfo2tlkazugkocwmlhc7iay2kvq7b75bgwk7vhfw@tvgfe5fj3mw6>
 <Z9sUVs1Tq3SN83MQ@devvm6277.cco0.facebook.com>
 <sarbzv7tqaljonkuerlmirulq25ouk6mwyfbr4oaqfzfry2kcm@efbhpxgpxikk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sarbzv7tqaljonkuerlmirulq25ouk6mwyfbr4oaqfzfry2kcm@efbhpxgpxikk>

On Thu, Mar 20, 2025 at 09:57:57AM +0100, Stefano Garzarella wrote:
> On Wed, Mar 19, 2025 at 12:00:38PM -0700, Bobby Eshleman wrote:
> > On Wed, Mar 19, 2025 at 02:02:32PM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 12, 2025 at 01:59:35PM -0700, Bobby Eshleman wrote:
> > > > From: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > BTW, I was unsure about just making NULL a macro (e.g.,
> > VIRTIO_VSOCK_GLOBAL_NET?) instead of a function. I just used a function
> > because A) I noticed in the prior rev that the default net was a
> > function instead of some macro to &init_net, and B) the function seemed
> > a little more flexible for future changes. What are your thoughts here?
> 
> Inline function in the header should be fine IMHO.
> 
> Thanks,
> Stefano
> 

Got it, thanks!

Best,
Bobby

