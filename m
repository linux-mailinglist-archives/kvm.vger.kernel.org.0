Return-Path: <kvm+bounces-72566-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLGMKHAwp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72566-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:03:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5B11F599D
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76BC3309C29C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F79175A86;
	Tue,  3 Mar 2026 19:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QWRT7xJP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5MLNC7N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D323264F6
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564415; cv=none; b=bP3R3YBcMgyByXm0+zdp4gy1biyZ6uJeFH2roqp3Rrrz/dnHEvVPuiX3Pbta/VRtdU0e5Rws4IQUYqrYWQJQR1suo7n+UyYPpi5VjiJ1bzNpPiRwhaZcvXu6xvtcXSrbKmBP9pX3LzPJaNoho4i3sF8kVzIqPUxv3LhKnv+D2dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564415; c=relaxed/simple;
	bh=tCPH7oOC7FSuYqzdGayGkye3CfSxNGdMJAmJ3KAsQo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPfLlumJAnE2OflaTT51QBBmxGQlk+9rPNOqAsMPQp0UASrIPQ65o80CoR/Cg80WaSEFuVdEPkCa4uo6CyhzQejTgIOsNRD1gQGVdul/Ke9adMv8W30tkryvI5ZNj0rMts184+bkd2dAnblH9/HFydSS3FAe+6FTNoWPbVFYxtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QWRT7xJP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5MLNC7N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/+HIjwU2bq3jhg1CvjUzjoo9A1v9LPZDGHrJumMhbQ=;
	b=QWRT7xJP/Pj7qOTUx/d9OtM47VuCiL846pt8vChwfOAEdJCw05U3Ellbw/RTZX+5JSb1uO
	IvkhSUsuo51nJaMHg5ShCFidDAIcoJQvLi/YQCTu8Iugvsho+VX4y+a5Ar2jNpb1qRDxXc
	Wu+mxzVA7vy73Ypq6B7Lm1OvrE1nYw0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-HBH-AGoTP7a1cT6BtrbeSA-1; Tue, 03 Mar 2026 14:00:09 -0500
X-MC-Unique: HBH-AGoTP7a1cT6BtrbeSA-1
X-Mimecast-MFC-AGG-ID: HBH-AGoTP7a1cT6BtrbeSA_1772564409
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb5359e9d3so4300501985a.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772564409; x=1773169209; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/+HIjwU2bq3jhg1CvjUzjoo9A1v9LPZDGHrJumMhbQ=;
        b=G5MLNC7Nl6sNdwJNnX2dgHigpe56T9H73/myzxAF5RZOHNj78b8QBzu7hBRDOcl1ai
         vS1i+l3G44KXmPEOl6Hvrh6XXbEQHQ/oNsSEN9OUI4WTxBA+vbhbt9FDIFW9E4Nkl5LI
         vAOstTi2+jwFvk0nQ5T9kUS39UUd5c3P4dZooCu5lIE2hvNuGvwRCEwRae4eQemEraD+
         gtOYKgRNGSOC/UF3/zZ/T64Yfk4flmCyvbVzmH2aRRu3uBAy1lD0RxBdkNVEG1rlWa6n
         Za3t9/bEjh6FZSR3V4EH3Q6l2DeVxayC89x8XgA9xMnsfVKLh/Z/ns97UgI5vZsmp0ne
         kFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564409; x=1773169209;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/+HIjwU2bq3jhg1CvjUzjoo9A1v9LPZDGHrJumMhbQ=;
        b=pn7srXCdwbh6Z9iu5M3z3PaT+pQ6d1zM+ATIJxyTPsEiwfdVUs8N2l5yPrkDNw0VMe
         VjC/YXl4V/PCDyptVrUTKrmvXwz7Jp5CoQDOmqIsWNtecVHDy9CytgBqfLJXw89kZG9o
         JR+EV9so2oeczv6Ur3EgNU6nlOIaegO4SWjl29csxlaYdQjzmtqpCNE4dMFVy58iKc0c
         zMbTHIAvNzo0ov6PivLuEnaHeifSOKQf/4LBk8Z33AUUIqTi98W/QpeKvAhcownbuH12
         cF07W04H/Ke9s4ehzGTvDGuf/HhfIpufkHQA/XQuQt2/4dm6e+9oFJwGngS8bVWtz45U
         xEjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7zdKY5hwDC+8mFzz5ND4kzjsPaoIgzM2jLgaoW6CQZPoPmrjiLv1QpMFeu+jc5t7N0G8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcnN3G3qWitYFhyS+DSeH4ayAM6Y1J6pxeftXHvhBCTin4HoTA
	e3UmytKoTHP50Vi5hrupzfc7AICxKyHxhV3RzjNDUCS1AuyBUnrMeiZwm4cv2BLxqP++MLAiGGN
	ktW7m8JBoIO5h37/FHAvSe/M2ysNprGBh306Wq3rLeVa1NLaRUiNP/g==
X-Gm-Gg: ATEYQzykuwvYGek9C74jjQLncV1v2SxEwlTpcmX6wsz1MaeUqp2M4ksyTdTQb2zYVob
	AsApA1y851IR7Owc1eUHEViwLo2KbUahIs0v36M/51uxpSJLJjGgr/KCh82o5JuQyCGLNuxVXZD
	GqDRv3yfMsQ8Ivdq0RHq2UcfREszAYpjBimRGJkqyN2l4i67BvQQz3rELdviYroTdeb/ekRXGZi
	np95Rbycu8h5PTV1EdrXJ59J3o1dOD/ovgSHpadU63oPXPLBGg25+qSYzZixgNQzZ7RqiRoqqQD
	xim7EFq0uxgBVUG1bfw8OhI9O7cGXtJxpnELaUNN09/O1qWMjW/4xLVD+xy8LT8TezhHNYgYfFD
	1FyZBQTqNAhCgYA==
X-Received: by 2002:a05:620a:190b:b0:8b2:e9e1:400f with SMTP id af79cd13be357-8cbc8dc28bcmr2048401885a.4.1772564408700;
        Tue, 03 Mar 2026 11:00:08 -0800 (PST)
X-Received: by 2002:a05:620a:190b:b0:8b2:e9e1:400f with SMTP id af79cd13be357-8cbc8dc28bcmr2048392085a.4.1772564408097;
        Tue, 03 Mar 2026 11:00:08 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf66f325sm1446922085a.16.2026.03.03.11.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:00:07 -0800 (PST)
Date: Tue, 3 Mar 2026 13:59:56 -0500
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
Subject: Re: [PATCH v3 05/15] kvm: replace RamDicardManager by the
 RamBlockAttribute
Message-ID: <aacvrMdONqbDD_nP@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-6-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-6-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: EE5B11F599D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72566-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[x1.local:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:50PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> No need to cast through the RamDiscardManager interface, use the
> RamBlock already retrieved. Makes it more direct and readable, and allow
> further refactoring to make RamDiscardManager an aggregator object in
> the following patches.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


