Return-Path: <kvm+bounces-72563-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8HEjKuMvp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72563-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:00:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D2B1F5948
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 347D23112B3C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E44372675;
	Tue,  3 Mar 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7yIKFQQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLY1PtQd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18038372689
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564291; cv=none; b=AJSENtTXFRdz7u786aNKR45uLfloCzK9ZadBz/EuzHfY/4p2nRvfs6aVN+9iJJ65DuOxW/uAitVp93qGE+62uNg+IixtYGKAVOSNzpOA4DDx9eOwGLwcIiJj+kvJH2hs+HkgSkI6146po2qZT7i1HlJUozVhjKbRT+GjGyS1EIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564291; c=relaxed/simple;
	bh=GyZEnavLKk722R1n9e1HrGENut8gasVvdUUFw6Ivvhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPZ6DZckLJEKwvgxrGIOT3Fpxf3Z7pGh+am7ykVg1lTk2FRrtCPG2sEn7nSywYsl8R+B1zxid86D1LGepfP/YBa2vWusUbmBe+xyV3uby2Xp7InHzI68il4/+UyZUwIrihgOGBCU9aiHE3Fq0IzK++/2ph+sU0ND30vkkizITp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G7yIKFQQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLY1PtQd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3jWJfd2By77YPm0nmu1FQRueQci0+HVf3IZ76mjdZI=;
	b=G7yIKFQQDf9h+Yyy9kMqR9bWnWej2skKu9nYivDcJmSIPdNVFwYSv1V7AQY/ryp5ViVmab
	XRWpb9pivQ1cvwr3ch4vpiOINsUUBiFrMy0/6YPni+8imuiYdAWbCSXmsYqFl7lBZQS+VP
	TDH48EfAt3Jq/4HkX9kwjmYZHZWTZx8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-02NLmaw-NiODcr8gB48_Lg-1; Tue, 03 Mar 2026 13:58:07 -0500
X-MC-Unique: 02NLmaw-NiODcr8gB48_Lg-1
X-Mimecast-MFC-AGG-ID: 02NLmaw-NiODcr8gB48_Lg_1772564287
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c70b6a5821so3331954385a.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772564287; x=1773169087; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h3jWJfd2By77YPm0nmu1FQRueQci0+HVf3IZ76mjdZI=;
        b=hLY1PtQdtVU8KMjX4nJnitI+3RUKsgFVco7I2mQUChNCfehBrJ0slVwNtP8P77zMZH
         tJSG2B3rfE7RnAQ6etLT4XdOdFMD5b9MSczrRE+Prv/+BSKDP0ApSRRKPb6Vrmm3pDWj
         iVMWhgizeS5zKiFtNIEkMyP4qP0UpWoiwdbO4yh1lxCPeGtMLBt+514pC0XPlRnz0VPS
         UTChfz724dqN4/QHD01r/9ObzgQZNXTVL4ns4jUkJn7PPWvPvI5NgYrcE7AsXbrYOiMV
         B92B5euzC6yCj/sXrIdNM2aZLURnvE21NsXSvakLahOnYPEDM5MpulJjszA3ticgPGj0
         tkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564287; x=1773169087;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h3jWJfd2By77YPm0nmu1FQRueQci0+HVf3IZ76mjdZI=;
        b=H3mki91I2lr13NY9vfgEVAlc9tyZJzr20XHZx8OaZN8A6F9BsWah3k5098Wvn24e9a
         GsfHejE/6zbBeht0fbc79WyvK1rwAouke8LGnyZoquDXrxtwD2GHg4Hlt2ocfpJYhU7S
         EL2RZybki+ILEiZ/FtApW5VO5trTnpZfyfamvvF2t2wDFDkzqBxpmO7C/kLxVahTa7OY
         3spB2c45WBba7zf7BGkjBaUIl3mBVqGxZIgrx/kCbJuOyTFG3tnpTogS5IQR3dj+7nK5
         7HRbcT8irEI+ENBdPNUpU2qCSNsUg+vQmK4B/c/S3NDlNaOhCD+nHWKObmrIS1cOcZEM
         PD2g==
X-Forwarded-Encrypted: i=1; AJvYcCVqmZ+hINoyxV9ROYGkghcIrDH1SwvBw8HofzChZ+SYkhKhLjzijcYS8uQ8NGaqfikMBns=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK7nY69wECkICXQ0uhf3GKEsEhwyjdVJwvzpVu+rs8zbSiVJ3i
	Kzqfd6ZaMb9iG5pNc6Lwp8oBOh9Xd7BDxlqOxLuuaSej9xlfKIE9Ug/nk2xnDE6PDr3DGANl8sy
	fVJ03oU8Ev2GfKD4C9VJQEOkXielOsDL9R38nQpZKiu2yx1iaNsX+CA==
X-Gm-Gg: ATEYQzwgffU670C4SjnlaYMGZaW3ORmk6w53mRakAj/AbkzMvzYx9LgyIP86RMQaRbk
	2R3CS481ZW+pu8+xf0yNl0lRsaHCe6P93V+V3DamVqT8lj0fCTwPWs3wLbTCTHudmESZsdyCWw6
	37YaR5AykgNaVlL2cKeOqxtphXbk9eC8PHRBpgpcUiWhor94LRZWA+rrSRkVojHlFcEJcLf/o9O
	ERgXwMiifjhDVYO9Htknq5uPMkSPHszNPHzf9lMWwTKRcbZ3zGpyy7WMFPENe28xpXaOGSfCZLB
	LOb8g5ic0/tR/FBiO5UO6rWAkR9g8rRb32W2SLWDoLzQvh3N34saK97g5K3whIU3IKYkzIXG+yp
	YBMNL8jNcFBCUvQ==
X-Received: by 2002:a05:620a:450e:b0:8c6:b14e:6569 with SMTP id af79cd13be357-8cbc8e3099bmr2268501685a.79.1772564287162;
        Tue, 03 Mar 2026 10:58:07 -0800 (PST)
X-Received: by 2002:a05:620a:450e:b0:8c6:b14e:6569 with SMTP id af79cd13be357-8cbc8e3099bmr2268497085a.79.1772564286636;
        Tue, 03 Mar 2026 10:58:06 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf71ac86sm1449210785a.40.2026.03.03.10.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:58:06 -0800 (PST)
Date: Tue, 3 Mar 2026 13:57:55 -0500
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 02/15] memory: drop
 RamDiscardListener::double_discard_supported
Message-ID: <aacvM1v_2lBR8FSq@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-3-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-3-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 07D2B1F5948
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72563-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:47PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> This was never turned off, effectively some dead code.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


