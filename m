Return-Path: <kvm+bounces-49715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D8CADD035
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E22E03A84B9
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 14:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D8E205E3E;
	Tue, 17 Jun 2025 14:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dd0L0RU9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4215D1AA1DB
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171178; cv=none; b=tOcd0CBEim01Cl+p01IX2/AEOn8FE2m0ARzfVlKY0+GlOqlPJzZa3XBJ/is4gBb7FA4xkongufyP6T+PEZn5pwWDIEwgGrVaPezSFLuMbYdqhkMKFhqPpixhAq7RQC2ooJEF+TAJczkiQ42eD2E2fc2HJxhyyKbSGt1pJTVqLSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171178; c=relaxed/simple;
	bh=P0TmBh/SuinKvkwSU9wHk7cmF2i1xnwgWli/nKJV0Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8KYNa414FsPA4K6Nz1iBV/yK+NSzmGhSzdcg/veDVaKRSVwd/50PgifDBMGYlmzot+/voGZLDZt0+R0g9fGR6g1qO2dqDWFtXRUXo7xj+dm2dVrqr8x03Du4VSdCVUqYmjUmI2d2g1f+oYVQZEnHdGZV1XTiBms+xRO58BA7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dd0L0RU9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750171174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iPUJBR9Qf9kVxYZQYZ6+G9JwWB7GoNLWWQDEXWeJq2c=;
	b=Dd0L0RU9WSfnIGyKWY/8gz92slapCugP0zHXjwsN+Gpg2aSkiHPJvJ/jtwoPWjDjGJ4MT5
	hL4gCzj4PCbyYNJcPiH+72TYVX0PwCFncQ7rWWirghFB+qDzrpXaX+ZP0HySmI2nygoY+/
	BhfHJauwIR023Slt4qoiMC1jR0eRevQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-hSQA8FuyPdKIa6I1uEhjwA-1; Tue, 17 Jun 2025 10:39:33 -0400
X-MC-Unique: hSQA8FuyPdKIa6I1uEhjwA-1
X-Mimecast-MFC-AGG-ID: hSQA8FuyPdKIa6I1uEhjwA_1750171171
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d244bfabso47536285e9.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 07:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171171; x=1750775971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPUJBR9Qf9kVxYZQYZ6+G9JwWB7GoNLWWQDEXWeJq2c=;
        b=G4qg9IOI0qr87gpOzOmqnm/8W+rsJVuOFjqfGCZJiz56qV9zuNcHyyPuQwNMdI6Owi
         dIY4RDVtZPs+8A60r2GXQ5cMUPlzyVw3nrF6mNq4J+Ivqs4sscvssd9+EFPvmL+uTt7r
         1ogjk8IWH/Qj2oOomtubEmhfL4Ix8h41lPotT4GdxxDfwGaRFyrnB5I7iZvLVq07gH5i
         B+/O3fv+RslxEzQ/fO0zTnzVbzvfycTZyS7BJaMc2b1oDtz5+vjDP1tF5cfmV7FxqHI+
         LQo6gtfv0uc/QQTwVYIwKnDsIzRiJBjJP0Nt2Ed4g38HrsdvKH1tW/MQ0F89TLbqiln3
         VQtA==
X-Forwarded-Encrypted: i=1; AJvYcCXzMzW/NyvXWf8Ch/GURpcBoplbRUQ83eAzfItlfH8hv8ECW61XWQKa5wBXrCXIzmwbN0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzamXO5HreNYUxFgqg8OovgsOiz7VyzpaJAY8vazOKmwK/xSaCi
	YfSPomTGGq7stOE23bNPJ7WQ9tQgx3eqj2eWSo9kGYHyu644vshvNtRKml2O9CUv2/FgCYERYur
	dGCxBGh0fzKfeqWarEeyVcVCGqnm69GPdHy1fcKTy4FzW6KDgaiJh3w==
X-Gm-Gg: ASbGnctQ6kBdi+pVA1fS7/VpLAdZRY9BdsNHJWN218WrqlPrVkn5uG1Nm17M+83Og9g
	xw56pNeHR5Bxd/X6JxC0C/RuFd4//t2rriJ8t3RHNLDS4giqmqYbVx4SPGn2NUrTQzwvGkDC0R0
	PRUViWLG9VhGAICDdpVkMyX5f6yoTDEKgtNydJzjC9xm4VnCsei6AZcowJmvuvOQb51SO3y7F3E
	dIKE4gaNUmM1XgU/KKno56M2g0BuJTRDdch9VwEI4e6Q/HM6ZdKTHm9uOlzHCPqOYAkCMMPSg0p
	QalfHKk7+gYZXB7YsV73rLDCgCEr
X-Received: by 2002:a05:600d:13:b0:453:c39:d0c6 with SMTP id 5b1f17b1804b1-45344d8f6d6mr71096345e9.32.1750171171561;
        Tue, 17 Jun 2025 07:39:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNxFUr/RsjSCEdxIvQ1nYZxg2/GHtiJcbK0+y2FBpHGRW3fR6k2TfEm1PQ2vYeyp/yl4Cmrg==
X-Received: by 2002:a05:600d:13:b0:453:c39:d0c6 with SMTP id 5b1f17b1804b1-45344d8f6d6mr71095955e9.32.1750171171029;
        Tue, 17 Jun 2025 07:39:31 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.200.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e241b70sm175740145e9.18.2025.06.17.07.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:39:30 -0700 (PDT)
Date: Tue, 17 Jun 2025 16:39:25 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	leonardi@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Message-ID: <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
 <20250617045347.1233128-2-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250617045347.1233128-2-niuxuewei.nxw@antgroup.com>

CCin hyper-v maintainers and list since I have a question about hyperv 
transport.

On Tue, Jun 17, 2025 at 12:53:44PM +0800, Xuewei Niu wrote:
>Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
>socket. The value is obtained from `vsock_stream_has_data()`.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
> 1 file changed, 22 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 2e7a3034e965..bae6b89bb5fb 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
> 	vsk = vsock_sk(sk);
>
> 	switch (cmd) {
>+	case SIOCINQ: {
>+		ssize_t n_bytes;
>+
>+		if (!vsk->transport) {
>+			ret = -EOPNOTSUPP;
>+			break;
>+		}
>+
>+		if (sock_type_connectible(sk->sk_type) &&
>+		    sk->sk_state == TCP_LISTEN) {
>+			ret = -EINVAL;
>+			break;
>+		}
>+
>+		n_bytes = vsock_stream_has_data(vsk);

Now looks better to me, I just checked transports: vmci and virtio/vhost 
returns what we want, but for hyperv we have:

	static s64 hvs_stream_has_data(struct vsock_sock *vsk)
	{
		struct hvsock *hvs = vsk->trans;
		s64 ret;

		if (hvs->recv_data_len > 0)
			return 1;

@Hyper-v maintainers: do you know why we don't return `recv_data_len`?
Do you think we can do that to support this new feature?

Thanks,
Stefano

>+		if (n_bytes < 0) {
>+			ret = n_bytes;
>+			break;
>+		}
>+		ret = put_user(n_bytes, arg);
>+		break;
>+	}
> 	case SIOCOUTQ: {
> 		ssize_t n_bytes;
>
>-- 
>2.34.1
>


