Return-Path: <kvm+bounces-41028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B273A60BA0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC15C7AED21
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 08:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135431A0739;
	Fri, 14 Mar 2025 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RnlE6T7d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nhnKOBav";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RnlE6T7d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nhnKOBav"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A9F1885BE
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741941094; cv=none; b=m6LNzi11zWEFKSLmdpsc3irURVy8Dp5QLoEcy2g23ztMdoJXiBqINxGlJBu2RJOjjdu4vPN7GFNflP0h4U7z+in4usiZcwblB3l3MW5YZFUG1QRH5I+iF9frjGNbPpTfsmmROJi6kYSMXu1+v10LvDGZen43VtiSgs33Ic0CmKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741941094; c=relaxed/simple;
	bh=vhD7XEJyD42/OfyBrKfM/Cz2B3dA+jqJ1jHm+dZ6Sw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bvEbQAVlYHq9SYSm09F6i/B/nnik/UEzPZoR9Pp14QHMY0EF9K3GvqmfawX1RpjIgWyQrnMnfK6WnDFLiv5RU5sSEg2+gDcx6t2bScv75xwNLMbQ+LTu/OomBCFkoRyf3zE4ZQrGTh8mr77pfh7TUVN7+2aDuR3yNA0iW5Oo92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RnlE6T7d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nhnKOBav; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RnlE6T7d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nhnKOBav; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C129221184;
	Fri, 14 Mar 2025 08:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741941084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM4mfqJ+j6Bu50tGy78bObN2ma9GftqWMTVUMvckJs=;
	b=RnlE6T7dsPAs0tyw61oIG0CUnJYV+Tvm4epf5fW9s0zWMNMktLnpLIq01RxzseTcn+Eo8X
	opYwhSlezewRvRWtut0zPzFkGDLBCxuk1mbr0ZQ+DKz1XKs4RpmReLZGwAMaiKwR59x/O+
	zGR+19D7cqOSj6noXU8mxU5JQPFUNL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741941084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM4mfqJ+j6Bu50tGy78bObN2ma9GftqWMTVUMvckJs=;
	b=nhnKOBavGgVjZQVv9QqxIURT+mTVzeXVvym1qek8NuEd7OfTYxJP7uw8VQaPfiu4Dcmk/b
	qj/B4CTEFYDJrGBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RnlE6T7d;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nhnKOBav
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741941084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM4mfqJ+j6Bu50tGy78bObN2ma9GftqWMTVUMvckJs=;
	b=RnlE6T7dsPAs0tyw61oIG0CUnJYV+Tvm4epf5fW9s0zWMNMktLnpLIq01RxzseTcn+Eo8X
	opYwhSlezewRvRWtut0zPzFkGDLBCxuk1mbr0ZQ+DKz1XKs4RpmReLZGwAMaiKwR59x/O+
	zGR+19D7cqOSj6noXU8mxU5JQPFUNL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741941084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=siM4mfqJ+j6Bu50tGy78bObN2ma9GftqWMTVUMvckJs=;
	b=nhnKOBavGgVjZQVv9QqxIURT+mTVzeXVvym1qek8NuEd7OfTYxJP7uw8VQaPfiu4Dcmk/b
	qj/B4CTEFYDJrGBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 563CF13A31;
	Fri, 14 Mar 2025 08:31:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AM8cE1zp02d3PwAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 14 Mar 2025 08:31:24 +0000
Message-ID: <d6df4f45-8cef-423d-af7d-1df19cdef010@suse.de>
Date: Fri, 14 Mar 2025 09:31:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] nvmet: Add NVMe target mdev/vfio driver
To: Mike Christie <michael.christie@oracle.com>,
 Christoph Hellwig <hch@lst.de>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, sagi@grimberg.me,
 joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
 kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
 mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313064743.GA10198@lst.de>
 <d1104f67-30e3-4397-bee0-5d8e81439fc3@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <d1104f67-30e3-4397-bee0-5d8e81439fc3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C129221184
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 3/13/25 18:17, Mike Christie wrote:
> On 3/13/25 1:47 AM, Christoph Hellwig wrote:
>> On Thu, Mar 13, 2025 at 12:18:01AM -0500, Mike Christie wrote:
>>>
>>> If we agree on a new virtual NVMe driver being ok, why mdev vs vhost?
>>> =====================================================================
>>> The problem with a vhost nvme is:
>>>
>>> 2.1. If we do a fully vhost nvmet solution, it will require new guest
>>> drivers that present NVMe interfaces to userspace then perform the
>>> vhost spec on the backend like how vhost-scsi does.
>>>
>>> I don't want to implement a windows or even a linux nvme vhost
>>> driver. I don't think anyone wants the extra headache.
>>
>> As in a nvme-virtio spec?  Note that I suspect you could use the
>> vhost infrastructure for something that isn't virtio, but it would> be a fair amount of work.
> 
> Yeah, for this option 2.1 I meant a full nvme-virtio spec.
> 
> (forgot to cc Hannes's so cc'ing him now)
> 
And it really is a bit pointless. A nvme-virtio spec would, in the end 
of the day, result in a virtio pci driver in the guest. Which then 
speaks nvme over the virtio protocol.

But we already _have_ a nvme-pci driver, so the benefits of that
approach would be ... questionable.
OTOH, virtio-nvme really should be a fabrics driver, as it's running
nvme over another transport protocol.
Then you could do proper SGL mapping etc.
_But_ you would need another guest driver for that, which brings it's
own set of problems. Not to mention the problem that you would have
to update the spec for that, as you need another transport identifier.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

