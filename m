Return-Path: <kvm+bounces-72502-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KqzOSGCpmmIQgAAu9opvQ
	(envelope-from <kvm+bounces-72502-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:39:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE0D1E9B3B
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61250301690D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 06:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC4238552A;
	Tue,  3 Mar 2026 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yz8uIYjS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzEJqzOc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F4E30DEB5
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 06:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772519952; cv=pass; b=bZzNgu+Aj1xve1DjSV2T7vQqbCYkyKIBtrT7VhUK0IX8I98dc5HOpmcE82VOOgRIEMfv8oEe2w4sPGdW+KonPYZHGAbL9B2c/hmmpIGBl8MPBWmvsJTZA2QVcbYEZhvFD61GoXvPtXmkskyELKMmDg3B21DdWssDL2LsVEwUUjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772519952; c=relaxed/simple;
	bh=ip6BoVTn8aXO52ewkK8IVXmRFEEwBoj5bvSXeM7zmPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ENe4RF7/u9aBKDSwSvtEP7eak2DMsU75xJwmB/D20+HJZfcPHu2WgFdjAgzKZ7XIfxd8RTnAGGX9XxVWZkmV+qvLELS8M7Zo1M4upuZP/3Yv1K3nQWQ99BfPx4TzQNW9UbM5BqRwxmeWtQKrAJEH1VgknkPQJxRTPduoxgKDAng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yz8uIYjS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JzEJqzOc; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772519950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ip6BoVTn8aXO52ewkK8IVXmRFEEwBoj5bvSXeM7zmPQ=;
	b=Yz8uIYjSnjLxAp17Jlo5JNnBB3DFjZv7GN5NetT25TF3qT1WnBQb2sdorImy4EnyY7vgmP
	xvu+wutuRG6TqU47fA0xQyuSVBVpuORYBDsP0A1vIeb2ieSybq2dZ8BlpTJYt5OTxoYkBp
	QyybUMrgnz5OwcRs3+voWefdVJLeiKA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-YAFUpyXaPWG8iKhFNwswaQ-1; Tue, 03 Mar 2026 01:39:09 -0500
X-MC-Unique: YAFUpyXaPWG8iKhFNwswaQ-1
X-Mimecast-MFC-AGG-ID: YAFUpyXaPWG8iKhFNwswaQ_1772519948
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-359918118ebso4098507a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 22:39:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772519948; cv=none;
        d=google.com; s=arc-20240605;
        b=G69p1BHy4S9MkZmoZs/Ao2sL2gJSXsIciY6u1dAMz0RmC8UzmKU5gubaO5H28qnGrW
         2ftvFfWfg0tpVnzQFyIZSAdRv5mjq+dKMF6ic8rqSpQ3fVaZAoIFYAPe/P0oE4LS5e7Q
         kmpQayVtT90n0jv2CM9QgTUGb53wi/gjWfrAY6TVZsDmZagkg5e6WqGn/f9ZDLbEpHt+
         I/zLP3+0/1XGZ0DKXx6wsILNlS7c11ajm0zlSftFQxW4n9HCPu2vOGmnjzijRlCi1MuG
         6eBlyh2zVdq6PBiS3p9FqjGI2BHRfTKQj9bCZakekgtxDPWgOkwixfX+aKHYWAtPYbw1
         MeVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ip6BoVTn8aXO52ewkK8IVXmRFEEwBoj5bvSXeM7zmPQ=;
        fh=inkS5hdHrdyKjbbIehVDqd8pOvCjcM1klDBnGhoIqlc=;
        b=IKLjvogDwmJrXF4XGIzBGdRZCgaABNEWv52+OPqx+RR9HGFcSo8MjehN8dPPhs18G/
         9IXQVE7jNgL6H6VxaZib+X1JhlrVxJd+Q7DcgmtZQ3q4ty87zHUjTrdqLAEUr8Ajk6Vb
         n00YAyv7gzPLvSVIcYXy7dlr5DT0+6xtZVCMIJ70ioMD+MQmi7laFREsZlsxZu3G6pQ3
         WHl2EBe0a/QkTZnJTw4p2salv69d7xQJ8OlFGA+C6CaMY9wQtATwbG8CuWTxyvSH0dvC
         +qXRHPHOFDMWn/dAo7EqS43E9EmfW0MWs4NzBuBluymBQLf6MxsV7eNcmbDZiQp7mg4j
         53qQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772519948; x=1773124748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ip6BoVTn8aXO52ewkK8IVXmRFEEwBoj5bvSXeM7zmPQ=;
        b=JzEJqzOcM4o9WYFZaMlMkDEdSbLocU9+Y4of0nyv0ijlGr81d7fLXf8ZiIILO3IrBG
         PnWqPvEdctNIB+P8QBRsfdxMCw6IAOBspWbSl+LuQq7qVCZBrJFsocRoSFnYyvu5CeO3
         F3ulol7Wesm4tpaeUSQg/EsyK2w1UCm69OKpJNq9MxTubc15e5DTUiAsqx7BtyTew6xt
         L36LslzTOBXrA08OphLQpxSCHMBSaRbvP9kezAjD9GMha6cureIjPKY9XC2gOkudEgXo
         S0QBC2BRt/ZIrzL6cnB/9KPwy8Oj99UphdmGJp81w/yzebWGK6+LtEtJh+3zjuQ7X+1J
         LpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772519948; x=1773124748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ip6BoVTn8aXO52ewkK8IVXmRFEEwBoj5bvSXeM7zmPQ=;
        b=WzW2X+oUxNbVuj7lL+VUa6wnnzVIkz3hpp0W8KNhlKdKME4GicI0ZsXGozNkdOnMDo
         wn3NUB8y0UgX0IbZI5GqkeSSWbyjhn7hkOKPQtADxca3RtptlpXHeUe+fADE5pUWtP89
         pwzbIjNYuKRwXqsZqmlRIVFbVzhWVsg+oalhjBu7xv5TT4xnCrkR/3p1Yn/2RSL/7H1z
         fdOFC17UK5TBZApQ6U8FghxmMmlxiWIZCgvVD/5sL1fPaKFc9dkLizvgQDAZ1HJDWZkA
         DSvG3OA5MRl2p2cSGDxtm50t0Gn+qXePMVP6zhw+CvFQ/JOJu7qMjCD3HhvRloIK1iJt
         eMOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxRS2U/ND6mz8BgHCDpjIcHNHfbUBK7hVdSo9AlAHwkfvAK++/YvUN/YCsP+5n6u/MKUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlQ09mI8WRMiQBifoCJQC+3v38YcKHMq1nfeb6h5h6u1hUSZPV
	McyofYEpNybR1dJkCkBuRN3czo5k+5Lff1IThjbCBBlCxrTtJvKF6y7YjDPwMP2bBZPgIA1Wt44
	ez/56a0nkoJUwlG2FaaO3UzBgJ5fnLL4SJ+CCbHwdyOj4yAfYgBRwnnFhr95MQV0ji0ckbkDeMW
	Isvg3McWN8ilKnL+Dga0iXBcznM9GO
X-Gm-Gg: ATEYQzxES3zOJk0IvcraWyR3nA3Y1Ia9SHBK1bAk2HUtUgAtYcERpOsLGf7dYbG2DVh
	eYRPij3yjT01gMVFxIYmVAR7eKbW8/dB7+jmND77NGI1gmd18EvmjmkqdVLKMh+xB2fU/pmRXjN
	9LNzjng6lGlq2XHYvGxeC0m/gVxd70RLnE0bex84TY+GOrP4kOxxw8CLe6TGx6B/ssh0ZyqfP+T
	wulW7HF
X-Received: by 2002:a17:90b:57cc:b0:356:2872:9c5d with SMTP id 98e67ed59e1d1-35965cc5651mr14849377a91.24.1772519948012;
        Mon, 02 Mar 2026 22:39:08 -0800 (PST)
X-Received: by 2002:a17:90b:57cc:b0:356:2872:9c5d with SMTP id
 98e67ed59e1d1-35965cc5651mr14849355a91.24.1772519947540; Mon, 02 Mar 2026
 22:39:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
In-Reply-To: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 3 Mar 2026 14:38:56 +0800
X-Gm-Features: AaiRm53r9FNVJrff6gYF6SVhADQXXQkuO9R5pefHXa-qJopdw_5-5yvB1l-6tnI
Message-ID: <CACGkMEtWvsB0CcZCC9iB9GePROH37CuLFZMcdNs1DjXSx6uQiw@mail.gmail.com>
Subject: Re: [PATCH RFC] vhost: fix vhost_get_avail_idx for a non empty ring
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, ShuangYu <shuangyu@yunyoo.cc>, 
	Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4DE0D1E9B3B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72502-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jasowang@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yunyoo.cc:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 4:51=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> vhost_get_avail_idx is supposed to report whether it has updated
> vq->avail_idx. Instead, it returns whether all entries have been
> consumed, which is usually the same. But not always - in
> drivers/vhost/net.c and when mergeable buffers have been enabled, the
> driver checks whether the combined entries are big enough to store an
> incoming packet. If not, the driver re-enables notifications with
> available entries still in the ring. The incorrect return value from
> vhost_get_avail_idx propagates through vhost_enable_notify and causes
> the host to livelock if the guest is not making progress, as vhost will
> immediately disable notifications and retry using the available entries.
>
> The obvious fix is to make vhost_get_avail_idx do what the comment
> says it does and report whether new entries have been added.
>
> Reported-by: ShuangYu <shuangyu@yunyoo.cc>
> Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


