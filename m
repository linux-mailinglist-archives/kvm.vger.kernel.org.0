Return-Path: <kvm+bounces-70921-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNJ1Jw98jWng3AAAu9opvQ
	(envelope-from <kvm+bounces-70921-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:06:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0866E12ADAD
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B0273019B9D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C012BE05B;
	Thu, 12 Feb 2026 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SSY9YT75";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ru1QU+Z3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1A52BD5BB
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770879994; cv=none; b=AOyUilpdl4Dtwqs49yxbCJhIS6u1j7fdnJOy5Yu7qFyvHIqEmFfXtFYCRwrm3tEG2j/XZ/r9D+2aIw+7694RaMIBSarqj4Te0dxBimdURyOwt3vVkA74psjyDeknM3Sd7h6HzaZxQMvJe8e3gAQW27DKYvnW1PDxO0YGCbGpET0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770879994; c=relaxed/simple;
	bh=g9HYPhHqcbaoctrpbQtbxiphE+OHyOHOP6Q7Eyep2RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/8xnO538POiJ9xRgMulWsy19TG4vA066JxL3pUC052HWm6HlgkIpd/qqWVJZFL0xre+7nLAPHIH6zNTWo+QA+2JyCkUAwsjNUPndGU2zWh/1+XdbNY4rUCmmWUDIPc7uP17Uz7Pgt35RycgjhD0B8Ak+aZlP54kb1pazk9bpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SSY9YT75; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ru1QU+Z3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770879992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DSQGsAVLVUl/sL3M3UFHxDkkSBw9IH75zh0vjPlYmyg=;
	b=SSY9YT75E7oW1kJxapaPJN9qUUFDs5FC56spzlBzWMF+nuCXdw9DEB2W4SP6inj5Npa8/j
	x8VSulgopJvuNqmp2xeFYlqTWnp3ReDToDeJEfJDnZUOhkjNzTPI3go48hjGPJHyEPLBO2
	c7LjW8OIwDsVVUDWusSvrsiHjlT7r9A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-DFvbrgLMOIaUDMMJ4WZ25A-1; Thu, 12 Feb 2026 02:06:30 -0500
X-MC-Unique: DFvbrgLMOIaUDMMJ4WZ25A-1
X-Mimecast-MFC-AGG-ID: DFvbrgLMOIaUDMMJ4WZ25A_1770879990
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-483129eb5ccso36452665e9.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 23:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770879990; x=1771484790; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DSQGsAVLVUl/sL3M3UFHxDkkSBw9IH75zh0vjPlYmyg=;
        b=Ru1QU+Z32Ry+YK19KEb0TQxpvy62NUucbz7IJ3SCETEi2Dfhq0/F0NOtoTz0NjJvQv
         Y1AEeEwzwCJh187E9YxmuRjJWoJ5ZFltdxYvGx2j1nuf5oEa7ZuDWyDGgRcL3nr/SHeB
         NDlTzqg+KnCoZyDaS92JRq/hIOUzrGtuo/m27hZcCT6B6H4pWcNAXFpiHkquIKGGQpPx
         1mFEWE55/8mLQP85j/Wh78czheq4Lr61i4FWFrsi/xVGi/bhfvny9P5lh0f1jEQNHsWZ
         3Kacb+W+g0kIS7SDJBAXL3vRXFxYweJLVHLYw2urWWlz0ArsU9hLqW4OjTQ0RihH+ILB
         P09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770879990; x=1771484790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSQGsAVLVUl/sL3M3UFHxDkkSBw9IH75zh0vjPlYmyg=;
        b=woPVi5un0r58eNdpC3piz/wDc6IDtza+3yGlBzRo8JPGAVwX6K5E4ZkII4vNuqwAxF
         C8WmFCzJkM+15dVtnJU9jyndyepqxhQyU0OeFMLiiWNfXjQftmOCWVYyT8coHP++YC9u
         Oo7eA6rVUq/XC87tNY1KCVEd6hRxP0g17SKRgofoE6gboQ+9AIp9fzNKNJCadbrZnOvQ
         DA2aMkEmA21K8st1AAuHSGykEy6iJS0M5IXvnvcBmY5KqOcayowq8vDPZloCGcDEUEnq
         HNgaP8GfyrD6bVb4n7Isn45W70cHpWHtfVTLe50mHXFDvHW2jTRbObNrByxhmvQa+S79
         /jdA==
X-Forwarded-Encrypted: i=1; AJvYcCUc5cmrTwnyYKt/oVnFwLjfHO9zsLVlFV6avTW2y+yJnFmZL0Y6m66gLnUVGWPhH+qAOdE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx42gT3piHuTDNQgIOANl6MMx/vukoSraZfQ5q4SZGKRATGJAoQ
	3YMe/2aeKGemJtPfh60dUqOAbb5hXIVaQAJSHyEKozKAtxcrall7FKT7eXSE6ENLcjRirHVU0a8
	V4LimSWpIwHAPU5A9t06h2zqaCy4hzI7q6cfzb8R2NNsUyXEqScbCng==
X-Gm-Gg: AZuq6aJYEmg7OrCKYeyS9QczAncp768VbrS6qPYY3xdXCnn7Gw9IQdVvwui1aPUy6a7
	hNa8wWqxpB+Zz9UUynuuP6NKifhs6pplGmTqe/GyL11D+KugaK9uCzHMLR3IQt1mXSsAA6MDbl+
	fDYtvR/ggyr2IUv7/JOT94CN9G3wLkxJ2QIQOs/wu7oBTvjE3H8+OEHZdzMB0OJibWQI9c9oo0w
	SQRtCp8mETq8xCADH5QKjCQhYuA68wnz15WIZEwWugClPOKJcszh4OPIC/bzvweh66PBlkOC5Tg
	tfv9CygnPwg9nJUpQpFCr/3x3cQdI+WoKZQzbWVGp/uN+Trs+T39d97Yo14fbz0DIQRuKd8sLS6
	yvLe/1wZ2kw+mMyoi6h8iPEaVCLx8unhj/hDBeGtGLEJp+A==
X-Received: by 2002:a05:600c:4e02:b0:479:1b0f:dfff with SMTP id 5b1f17b1804b1-4836710d797mr16270735e9.10.1770879989523;
        Wed, 11 Feb 2026 23:06:29 -0800 (PST)
X-Received: by 2002:a05:600c:4e02:b0:479:1b0f:dfff with SMTP id 5b1f17b1804b1-4836710d797mr16270405e9.10.1770879989104;
        Wed, 11 Feb 2026 23:06:29 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5d78cfsm251666615e9.1.2026.02.11.23.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:06:28 -0800 (PST)
Date: Thu, 12 Feb 2026 02:06:25 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper
 with netdev queue wakeup
Message-ID: <20260212020317-mutt-send-email-mst@kernel.org>
References: <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de>
 <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
 <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <60157111-219d-4fb3-a01a-6df9a83eae7e@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60157111-219d-4fb3-a01a-6df9a83eae7e@tu-dortmund.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70921-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0866E12ADAD
X-Rspamd-Action: no action


Simon is there a reason you drop "Re: " subject prefix when
replying? Each time I am thinking it's a new version
only to find out it's this endless thread where people quote
>1000 lines of context to add 2 lines at the end.

-- 
MST


