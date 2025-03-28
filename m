Return-Path: <kvm+bounces-42210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3683BA7514F
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 21:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3CB93ADA89
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 20:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0981E835E;
	Fri, 28 Mar 2025 20:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUONP/VP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB48319AA5D;
	Fri, 28 Mar 2025 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743192813; cv=none; b=hWQM32VGx4Xh38mr/EPu9WQOijWPbVd6YbjLPCT63ooUreX7ssb5Yq54oMz2CdXOxzhPsoSipoWKIFHkFHoSlAOWYAaiGewDH2OtWmZlJ66XsJfVBlVeVnjoZDtcoYGi6/YrtSR7iuUAR5k5RNzW4+VoEXloko976u0O4gduaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743192813; c=relaxed/simple;
	bh=OB3VnTMKOv3NvHsPD/ooOu7eM5k0ehHaCnOgt0T5Jaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXxb3FQf2l4+8mvAKWT0Avzp4JH/00o5XbD9PHCGFqWXewKv0PPUUc4RlnAu0ii/8LpT3AwNdcyMZdfkaKV8BaXpW744aATZhX1ViP3z8Sj+cQrDGdWLRanwmQ6108aIDdChSLEunZfyKoKwbf2WtI1lYvAG3gr7PdQS08rlyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUONP/VP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-227cf12df27so40014415ad.0;
        Fri, 28 Mar 2025 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743192811; x=1743797611; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t9FbjKIWjSUx83a1FAFt0nY/L0eU4FihK1314GKPDwM=;
        b=iUONP/VPl1Un05u3aNig5qJS2qIEoWw0jBz/08nNdy04zwSTqe0VgUGbVhEvLSmhR1
         oM56XW3m6tgtEWImpPl8wAQct2LAcxLPyiTbY8cFjRt728isr2DgsR/SRn8DKDUDkoDp
         Ngmfd6Xw0EMq4RymdJVu/9krCTEpCtcmUxKKzlgJJYab6e1Q2lC4Q7E4jzqn2H1aNdwV
         rC2LqjgFxh5nfUZbxrK9nmYk1rAZJ/qe4cUKzasakVAOL1Mu96QoKWSap1fKgQ2taK0p
         F2uN0OJSqgeuo033Q07DksacxfpFR/Bt4HPPkh5mzCoL4uAcoVhPzvOmAN0S2ms2Bdbf
         4K3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743192811; x=1743797611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9FbjKIWjSUx83a1FAFt0nY/L0eU4FihK1314GKPDwM=;
        b=o2W/KN/E/Jsy+X1OQEtzSRCQaUXiqyLJ/5KzUk3BRkP0D3oMPyYYYg0I+IWTl54VGn
         6aoiZdkxPkurRBly+8FAxytfkVVutfJO8HXnLq1Ie0CL8yeu7RZrWLOB7BW9CqvjExWb
         Fg1k+n+pEN+a+DDWTXbzkF4V7QwhTBZCJ8DxUH0Me5tbyWLZnEo99VHOqAs2b1Sm6OFq
         1gbI493JdspEOQ+kn24n1YwapKtxukgTp2WQMM6QgYroxeq8s+LVhagGPhutRobTVTiG
         v8G6aBJONc3c45CKstFEc7mlYe/w7WO+vzZoNPhPgxvXd6Vzw2wFEt4mVzDjtXXaV3Y0
         lYkw==
X-Forwarded-Encrypted: i=1; AJvYcCUZcoljFB07JbNdKMtqeEAccIRchwiq0tz8ptDVPJEGgy27JHbb1ZeL5L7lnIGVLGK2mkqx4DBg@vger.kernel.org, AJvYcCVbYlcg2c10K4KYEMYTc1ch02pC0QEw2Le8H/FuRxXzDqGxdxdoO5RHJ/9bnR1rFYumobhPUSQ7td0K9gOH@vger.kernel.org, AJvYcCVoF5M0etQ/j7h4vyAT3BgXMxxzxkz1UUOZBxq1e9m9wAUQ4RtRpTDhd9H4WoMZxHpmkbPq4n/l0HKE+IoC@vger.kernel.org, AJvYcCWzlgDXlYltG+STeEm1bdmeSHH6tM0rtO4odE0ifzcZ33MfB0gI07CF9YFHd3omWy2qdug=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNxRL3TIK4zg+/cH3ct8xH7IQNEkGHQqTG1L9fbLJV6Z3pqKxW
	1NUK97E9skWZT7RVmGFbtuG1TmEqoRx5ub67jtZYoj5s5DmNQEEbvCzmdJck
X-Gm-Gg: ASbGncvO7C+BHY0uQSvTLuT1W83niSY8+L0bCgG99KcmKFydAI7+7IS0xMxHlZg1Z8J
	RUkqDWwl4WE5CycDBeV5kFXllPvcP/x1yPdRrWzW2Wu6nxFerB1+o8DDAKMNiiN8hcJLVhdyrZt
	yxAh/WErAernLJPzOkckNDfJWEgyN3XvodK45tDXWUhk10n3xORXT1Q5DvBxFTCZPQ9p2QL0xGT
	BfRtNbyWsPKT9SqkKDsPduCFUiCQ3e64ObRHTxqxt+eZ3y0pOtfMCmThLQ8lmBg2ay18OBbWV5Y
	v/ud8rmz3/fV2zSLPjFHnjUgoM7jUNXYC7qG2/PtVkiHcmMfDPCCuU7exiM1NY77cg==
X-Google-Smtp-Source: AGHT+IEVlsZyvNY4r63OPSrnhwbvzQpJ4Z//xsphK1YGE1Hs7KUnQ3mWfMpJsygRPArflHFRx+tdAA==
X-Received: by 2002:a17:903:228c:b0:221:751f:cfbe with SMTP id d9443c01a7336-2292eefd76amr13290585ad.19.1743192810734;
        Fri, 28 Mar 2025 13:13:30 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291eec53easm22919495ad.24.2025.03.28.13.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 13:13:29 -0700 (PDT)
Date: Fri, 28 Mar 2025 13:13:27 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Daniel =?iso-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <Z+cC5+ngu1nMKmFe@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>

On Fri, Mar 28, 2025 at 06:03:19PM +0100, Stefano Garzarella wrote:
> CCing Daniel
> 
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
> I was talking about this feature with Daniel and he pointed out something
> interesting (Daniel please feel free to correct me):
> 
>     If we have a process in the host that does a listen(AF_VSOCK) in a
> namespace, can this receive connections from guests connected to
> /dev/vhost-vsock in any namespace?
> 
>     Should we provide something (e.g. sysctl/sysfs entry) to disable
> this behaviour, preventing a process in a namespace from receiving
> connections from the global vsock address space (i.e.      /dev/vhost-vsock
> VMs)?
> 
> I understand that by default maybe we should allow this behaviour in order
> to not break current applications, but in some cases the user may want to
> isolate sockets in a namespace also from being accessed by VMs running in
> the global vsock address space.
> 

Adding this strict namespace mode makes sense to me, and I think the
sysctl/sysfs approach works well to minimize application changes. The
approach we were taking was to only allow /dev/vhost-vsock-netns (no
global /dev/vhost-vsock mixed in on the system), but adding the explicit
system-wide option I think improves the overall security posture of g2h
connections.

> Indeed in this series we have talked mostly about the host -> guest path (as
> the direction of the connection), but little about the guest -> host path,
> maybe we should explain it better in the cover/commit
> descriptions/documentation.
> 

Sounds good!

Best,
Bobby

