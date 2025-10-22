Return-Path: <kvm+bounces-60786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB73BF9717
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 02:18:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A8DA3B32CA
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C273919E82A;
	Wed, 22 Oct 2025 00:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEYxaRC6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BB72631
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 00:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761092322; cv=none; b=gIK9CTOOckcejrsA0rkmc+ZQLW99ghsH720A+brmzt7mjZ6K7A3g21zGetwQ1a8uoutQZwdnUC/FkiyZj6Yj71Nu1GybJ5dI3Zk5hjGMtVS3NX5u4U+CT8uuhAzRTp0bZ4eG9p6wf9yl1amJ6nx9eyPls6Fi0IBXsyKPA5e6yqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761092322; c=relaxed/simple;
	bh=e7zZqGzrVyuJ5QFyUVE7eGJWKcfl4COyVHk9MxNeNKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHWyRRWRK5QJia3bOt8E1dtZrrhk6xUtgcDlhVufdlj1Y+rQGNVSNRWuvNpjOJcPMODrUTaOp8MTD6yN2b5tLv7Rb7BeRbIYE1HQ3D+Nn5sEdtRen+7B+bJlpCy/AOV3oPtJtvV3S67Xqb6PJgriHEVpCFUVehvGJzg/5/niZ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LEYxaRC6; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-784826b75a4so44030227b3.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 17:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761092320; x=1761697120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/VVHhrbKGyn2rHkoA+yo5pqhCOh1qQTtBCOhpEVSIKI=;
        b=LEYxaRC6RrM323rjsaoom5Qmq/bAc2SaTJQX8GJ41fF9wS6dF+ydCMuObV/5vRa9eB
         SYzYEkaIUsxJnYJGDOSck7f5EU9vx9otxlhq1x+6sXovUgcPoHhzkS1/sr+MeTTofOqm
         kaqUIhe3CEayD/uRA/QRjxQKOf5/hfvNSSFokoiA062H/g1f6d4cgxhk8wQ2qHOqAWA1
         eVHfFwRFvzlDceNZFLxCxEXtyF1o/6x4+magzUtAbYoQ1/0Hwm2zFzVNHt/0gaLM4WR/
         +Bg6rdX7+JB7kTTKBRV1FQh/ebFcOfaNMgNs1sN5dVUKU0p7jMbVBrQMcaEqRjUmbe0p
         fT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761092320; x=1761697120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VVHhrbKGyn2rHkoA+yo5pqhCOh1qQTtBCOhpEVSIKI=;
        b=VCOuyg/7BsxO8+tnV9JHd8s1e0SYqTtCxNFJMxHIDxLafWM+sAdg0sw6uhWT7nCV8m
         57j6tKk1hu6zDRl/pKrWGYy44Kxd/Y3N+2wYCtSaFblRlKAlWWsKsFLvES6+0msZcNjG
         kb/tE7y9RjflnMDTme/BP5eJagefZXa8dO6bnb5ThAFbwHJBlV+BKGBx7JTkdOrz8Gy9
         mHXhxWdfdB4Wny4aUqtqE1kKR8mtMT+aur7gqdUfc43mAJaISY4eINsyUt27nXm5Ujmm
         K8IxkdGMSJ92Xanp/VERpi0mduHUkmQZga7cpf+j4cP9Koy1IPCHwgl6ZVqib26v6IYM
         JypA==
X-Forwarded-Encrypted: i=1; AJvYcCXBkH9obwNNI+ugu9xHOoO8kjMVNOuHZnjRqq6XciENiHq4RfTaC3EYc6aYhFSAx6+vAlA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4iEdA+6eas2rEKEurwl0HVLElJo+Xv/YDzKbiJRFrTc94eWbt
	70DU5GHrp00pTAAH86XmsUurTz98Z4KlFmJ+wQn4FCkvhBWGZNGJk/si
X-Gm-Gg: ASbGncuxjFHTcHMRyGIFsOZpnyrqCr7TXiGG3idJ4plE/Fv2A4hi6W5hO+6tX2XxdZ5
	PfPceNmNmnjRoPQjMvFpNhi3GhacFLIEmfa4ftre/92CuMzS5l2ziGWvUg2mKgb+MAULwqHqJx8
	/wTDAG4GJFHkTva28JIDOmvWdyUeseMirINsQdBcOyel7b02LpN2lv6NzQipJ9KipEApp3+g6aS
	eVl6im22jmIHKL0oQ/1jYcvlVAxf76wG9qQ0b1Lbj5I22J4la98imW/0AoKFBgbRkM51a/0/NVK
	vijyVKGy/S+Wz6KR5LzqgpNR6FwKHvLEcfOnccTwrjgsEJCQ6s5MPLAkpHVn1wsIPx+ttc53dAf
	+mtPNYbwOtQwXngaXYuwd8hopUTVDCQX1U1k+v6JmRzjQE9xnTE2Nl980ExTzbrlO69etS1G7+B
	OhEz1PttEpAShhC0NIgdy1/zV7dQ8aW7N9g5tzItxVVmo8wsU=
X-Google-Smtp-Source: AGHT+IEqYiiuWqadmrSa+ocB1xo5kZsyd7pE12wgODlf319TseLh48deAbNiLMyHfUUvkPdfF1Gc1A==
X-Received: by 2002:a05:690c:45c3:b0:783:7266:58ef with SMTP id 00721157ae682-7837266619dmr152519147b3.5.1761092320133;
        Tue, 21 Oct 2025 17:18:40 -0700 (PDT)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:59::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7846a6cc14bsm32765777b3.60.2025.10.21.17.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:18:39 -0700 (PDT)
Date: Tue, 21 Oct 2025 17:18:38 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v7 08/26] selftests/vsock: improve logging in
 vmtest.sh
Message-ID: <aPgi3vSJGGfBovRf@devvm11784.nha0.facebook.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
 <20251021-vsock-vmtest-v7-8-0661b7b6f081@meta.com>
 <20251021170147.7c0d96b2@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021170147.7c0d96b2@kernel.org>

On Tue, Oct 21, 2025 at 05:01:47PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Oct 2025 16:46:51 -0700 Bobby Eshleman wrote:
> > Improve usability of logging functions. Remove the test name prefix from
> > logging functions so that logging calls can be made deeper into the call
> > stack without passing down the test name or setting some global. Teach
> > log function to accept a LOG_PREFIX variable to avoid unnecessary
> > argument shifting.
> > 
> > Remove log_setup() and instead use log_host(). The host/guest prefixes
> > are useful to show whether a failure happened on the guest or host side,
> > but "setup" doesn't really give additional useful information. Since all
> > log_setup() calls happen on the host, lets just use log_host() instead.
> 
> And this cannot be posted separately / before the rest? I don't think
> this series has to be 26 patches long.
> 
> I'm dropping this from PW, please try to obey the local customs :(

Sorry about that, since these selftest changes were all part of one
messier patch in the previous rev, I wasn't sure if the custom was to
keep them in the original series or break them out into another series.

I'll break them out and resend.

