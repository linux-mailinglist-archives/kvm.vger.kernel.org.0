Return-Path: <kvm+bounces-41738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACCCFA6C6CD
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 02:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 184A17A9871
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 01:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F9722092;
	Sat, 22 Mar 2025 01:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bM2ii8/v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD03FFD;
	Sat, 22 Mar 2025 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742605489; cv=none; b=WIMocauNBQYalgbPc1A1IAR6rW9K0QOVQa1lXYYoe7YVgU2fHxeclLcRAThMIWWlb11aR5bn7cHm4W2Mxl9SlJ3kuM/nKwZhRYc1mW5JzH3ebMCAe+GoQ7R3uKPcqmvTLRpP5UdZV0bgKgFKJwl81xUbwF1kNb92ElZaP98tkf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742605489; c=relaxed/simple;
	bh=aHWEoyZwm8s25Ueay7Kinp+YHcLq+mIXDmffZMu7ec4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKXRfHnbnmEljceZBb2nlOc+qR1DA1Q1t/5QJ2RWrqq/lkLCaRkqq+K+cqUsKIqlJVQeL5+/IskwytAr/YaMy4lDS2PljSxQDKpz/USk4+RUdUI3Bytn44Wk1w+7lQFOagk6TPW9rSwv2gT3KASe2ohXMazeFMC4MBtSmJ5FNXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bM2ii8/v; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-301cda78d48so5006618a91.0;
        Fri, 21 Mar 2025 18:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742605488; x=1743210288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c35jq7Zk6VAC2p9swunNZp8j09umIQmd2y6i+B5qS2c=;
        b=bM2ii8/vJWB0gLrAznOtXHI6euVpy5PmqNvuO5KNr+l362UKUEKmsR8mxSmEElbGhd
         G/vemuZ/p6zW8XQr3Gu/uHGYkK2I8f9QCBmepI9OpIqpIp5gEWcdnMfG+p4uFiacfWc2
         Fx1jJOuwu1lLeM23tpavP5lbZn4mAP9CGFNFC8Ek5tY2mdVUGrV9taS/WwgtnMr30JHp
         QMFDsiwRxFaDJYpUXYzY1UKaNjMaUSdypNC2D2+h3DxlpMJTcbILDh78nuTLlVLpugvC
         GVXGMHU6zZnLBCk05dPG8gdOObLolcZiXAHJyeUKGa3vjvG7tT42cV5GgllnRDXIT+9c
         tyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742605488; x=1743210288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c35jq7Zk6VAC2p9swunNZp8j09umIQmd2y6i+B5qS2c=;
        b=b97ukrpPBmGQgiyobWAEeSiI6gtFG5D3aeRhAyUz4H9g2dyL+g8dezhmJDnYZjgkH+
         IO2TrfcVP9DLn8mAla6UNmHvcMcelrZnqakDrHO3H5CLFV71CGKab77q3dbWfx6iGF4P
         3nRp7/IFNmojH90KDwlz99jHbDopf8M8TZAow/gpoZKqoS747U1jZpTwOUybCaXwwr+g
         MjzsAI6UP5i4cW6Fl4SvxABfSBMbhgonsru4gFA1jlkGKyiodNobtT7dvVDScGnZ2zc0
         blmVFafgj+d/GE7uqhmgB/fsZkI4fevpPs2XsH2vs0MYELbUIA2dfFP+KeR1sTD81kM0
         oRBA==
X-Forwarded-Encrypted: i=1; AJvYcCUWqSoelCwhqtEC8zu5D0qHFg7AIX3Nau263lnQ1rpev8odoXnCyspgeqb/gtdxrps2y1SvxZCWPVmg0aqb@vger.kernel.org, AJvYcCVmFqtyH0W2i0AAHZk+6SH6tNRNUAHhXZO3RXRvc4/5Zo/0MoE+Jchgwj6i4HXOAHel0hdUWEgCj9/r6NHM@vger.kernel.org, AJvYcCVsa+S9418uOtjMNNvOuELb4J0YxtGbSnrWCriS69Q4TmaAFXOtnEbmWPFmbI1KtNmqghrI13xW@vger.kernel.org, AJvYcCXZbhka5rMRCRZXnnuj7Du0eQdsTyKmdXtq0zESIwAZTs9W0OLvSK3HEPGKqgjAeKlYImc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyAKgIYS6yskE78EAuVgyJThoMay3TCCfDf0HV0qcmLqjUU0PL
	w8+QUBP9gDGH3P0C7tHwnNvRT2wWai8+oHv8fNDEqD0jWYWVX2f24YFL5YEe
X-Gm-Gg: ASbGncsveYS/J1rYUvBsHkX1bXxSs6TJhg5ySTGa8phepOLRQzv9dpPWXQ3obSznWS6
	arHaJgYefw8MXfP0u9ExYDbAWpPZXFxV/x/pbhpipNF8fgEQVoYmPwmT8nTEsQFzZq+B6GI6c09
	nOwRdJeCY4UO5z2j0hL4vUXkwP5w6vJZ2yqX+IojYHpf/gjqfR6WwidhcyN5GlyS8pfJSfvffMo
	mTGZMZ8GUl0sAqJkPH1SG+QRMeQDe14gEnLwX7bC+OpWy6iBh/SKOzG+pQ1JXSQzmLmz/UosvQn
	9Ov3o7GZMqyT5OjUaz87sbmOSwb8A3g9eNKgV8ESm3MsaFQIje6yLCO2D4ftPBrVIQ==
X-Google-Smtp-Source: AGHT+IGwgm/iem66z0f29AU0aiEjc4aN+XSZ83V3BdggHxqxoQdD5aHTSOOQXyr9ICwMM4Rwy4qg6g==
X-Received: by 2002:a17:90b:1f86:b0:2ee:c291:765a with SMTP id 98e67ed59e1d1-3030fe83c21mr8500288a91.8.1742605487804;
        Fri, 21 Mar 2025 18:04:47 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811b2aefsm24515665ad.109.2025.03.21.18.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 18:04:46 -0700 (PDT)
Date: Fri, 21 Mar 2025 18:04:44 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
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
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z94MrEM/wM3G72pf@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250321154922-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321154922-mutt-send-email-mst@kernel.org>

On Fri, Mar 21, 2025 at 03:49:38PM -0400, Michael S. Tsirkin wrote:
> On Wed, Mar 12, 2025 at 01:59:34PM -0700, Bobby Eshleman wrote:
> > Picking up Stefano's v1 [1], this series adds netns support to
> > vhost-vsock. Unlike v1, this series does not address guest-to-host (g2h)
> > namespaces, defering that for future implementation and discussion.
> > 
> > Any vsock created with /dev/vhost-vsock is a global vsock, accessible
> > from any namespace. Any vsock created with /dev/vhost-vsock-netns is a
> > "scoped" vsock, accessible only to sockets in its namespace. If a global
> > vsock or scoped vsock share the same CID, the scoped vsock takes
> > precedence.
> > 
> > If a socket in a namespace connects with a global vsock, the CID becomes
> > unavailable to any VMM in that namespace when creating new vsocks. If
> > disconnected, the CID becomes available again.
> 
> 
> yea that's a sane way to do it.
> Thanks!
> 

Sgtm, thank you!

Best,
Bobby

