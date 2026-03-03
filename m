Return-Path: <kvm+bounces-72562-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NxKJDEvp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72562-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:57:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B2E11F58A9
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94DC530071EF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC13372682;
	Tue,  3 Mar 2026 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OrYRt2Dv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LCjZ4259"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E379C372675
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564270; cv=none; b=T40DQG7Kxo4SfJRbx8PTn/SAFvZwc0u1UWKI3UxslJl2JVa4TFYLQNMqQ97DzeXQeecXwZErpmDz6dGJtwT7cpi0tv8/F0W6DJ7zII/GIHCBhDYBbXcnqDk7uJ6PpDYfXPR582l4EXiTq0/CleyChVdl+sz2Xy6pR92ghEdbBKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564270; c=relaxed/simple;
	bh=eM/HAkH3j5YVwzsQqGIrbYLgOW92Iawk8dw2TXCja3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3iW/bFTvrcUq0o4RTEVl0q2FZ2U/nCp9QzP4+1kgj9hO1NCm2LI0qz7GmyFYCWp/6Lkdfk5IPL0WSiVZHNNi6Qx6czh6ixlglXziy6fqYs7F1Wua/TZ/ZZ3f6xNqhNisdrIROwZdm27DSF/ZiuYjPl1+ijonF3F276eciBHfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OrYRt2Dv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LCjZ4259; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UQOsChU7m9iCKe33t/K1RZDUR4id0Q+WNCyialfJOE4=;
	b=OrYRt2Dvf7FOwHYIClpoagdU92JUE3tBKFrDcmKWkcMvlWnV3bSAlm0lFJ8UUMiRyzpv71
	3Cp2MxbMCZUyIEWk6/LIawnnmX4N6TH4eEDTQcfD5tw/zl8QX2nAzb2p41YS6aK8dYjicX
	XSuq/Jw9Ia3vuPT20FrcwerCB72jkkI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-IljPSxl5P_2TrO1bLgIlJw-1; Tue, 03 Mar 2026 13:57:47 -0500
X-MC-Unique: IljPSxl5P_2TrO1bLgIlJw-1
X-Mimecast-MFC-AGG-ID: IljPSxl5P_2TrO1bLgIlJw_1772564266
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89a0796368eso90072536d6.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772564266; x=1773169066; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQOsChU7m9iCKe33t/K1RZDUR4id0Q+WNCyialfJOE4=;
        b=LCjZ4259BXZ+KkeB1xKkpHAR+jxiWqE8lphOFZSoQKsxpesHlp/HYzOr36u7hyasTA
         Qsb4KVJlulcN5Y/ogbts1Q7maoh23rblM1wTtgQQE3P251kpn5fhKZYPBBKIDimhVKTg
         8yUbWC/ES75d0Ilb1mTrOCjvBloUE8bD2+dkoJgFl/e2i2SzfyDB+BCVAiesppROvQrw
         Vj0FE0As0UMkBFtB/6DPP1HoYAoMwQNUN91S/lF++bgVY0JCVSLkUEA4tFgra9NX2SNm
         eoLNnpGVFUhyITqhbr2ad0NPAphZRIe6ZgBLZikKQ5TTR7aRSamBv3CYMju9PMHK/jm+
         BjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564266; x=1773169066;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQOsChU7m9iCKe33t/K1RZDUR4id0Q+WNCyialfJOE4=;
        b=RsrU3S9rZxp8SUwDL9/zsq7RBGjEsaAw8yIqgfYzYb1aoy/juaK1PPlrhy7fn1utlm
         YhAPzgwuxwS649OFonWcS3gIgP56pPXj5vv5LoaBxwpOX/gcmlOR/H48lhAO2jZX6VdU
         vS2pzRvdn3BBfS/d5GAK7EgJiDRIaQpLUbLsHD5pvrIF9h239zQzb9aEikfhRlK+sutu
         MeF0iv/Fb/EgQQ5IcqJ4A7M3bLkaFhmoTI4CKU1SS5OkMW5zzU2uzi3Q1HztcrXtGk8f
         HVf5YXE5l4JFWMpMA05yFoh41slrEq4jAlOe21N5fqwXPBV1VTRC2d1rkG6F+4dHiWyK
         h93Q==
X-Forwarded-Encrypted: i=1; AJvYcCUn88ZDeZMc0PKAQoMplfWzATG4zFj4eqtga2ipSzkJ9/Y3gMCLR7BfcLOwwbpS6u+WjUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdJDZfHUXa9d0rnzuh4+SxPZgcL+2VylcuUGIOAzjlJ/DJ3pUi
	iHnNYGSsGWQH9xCduRArN4L/0PRXF9tbngHcIQxMuG/w1wuE52n9fYphTbHtWCbEPyCePgifp3N
	XKe3YO0DHBgyKNTdMOjlfz+jolZ/mAcnKODXPCQB+snzb8jiSa6wRig==
X-Gm-Gg: ATEYQzwZunQ6md89HWVwo64nUopirIcbjB/l5rmcIE61cdtaAS5AzhoKHZgFeQ8zjYo
	mD3Eqm9dg+G/GXwsewjFv2uRkWtxJKY/qcQ0HIH++x8FkyXl1uYrOB2a45Sx6ljgrYq58+vhQRz
	4jVyRrQ4OvJHLANY00jYsp7ZOlW4IRxZUbRzkyo1rGj76k/8U0kKlypyAdM1MJ6GOIHVZ8TkIbT
	5eASoDoU0TB2lXBt2pfF3qgl1zXZg6PWf/36DkFqI1GLgNnF1JzGWB1LQEOuAhMxbinPrN9ujuE
	3siZvDwPV7M83DqSgbk0diPegkKwqPFeYZVnUHFeLFfZeQV+yulXfwlye0bGQa/orb0BddP913R
	N7z0JoR7hSvPqiA==
X-Received: by 2002:a05:6214:f67:b0:899:f5d3:321c with SMTP id 6a1803df08f44-899f5d33666mr120445446d6.10.1772564266282;
        Tue, 03 Mar 2026 10:57:46 -0800 (PST)
X-Received: by 2002:a05:6214:f67:b0:899:f5d3:321c with SMTP id 6a1803df08f44-899f5d33666mr120444946d6.10.1772564265700;
        Tue, 03 Mar 2026 10:57:45 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a056b7b7csm43713926d6.20.2026.03.03.10.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:57:45 -0800 (PST)
Date: Tue, 3 Mar 2026 13:57:34 -0500
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
Subject: Re: [PATCH v3 01/15] system/rba: use DIV_ROUND_UP
Message-ID: <aacvHhRpKsIuTif2@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-2-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-2-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 3B2E11F58A9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72562-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:46PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Mostly for readability.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


