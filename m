Return-Path: <kvm+bounces-71509-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOLoCH2QnGnRJQQAu9opvQ
	(envelope-from <kvm+bounces-71509-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:38:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FED17AEAC
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D848305247F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8593321C7;
	Mon, 23 Feb 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iptasx/g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iDTKiXfj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01F331219
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771868266; cv=none; b=hc5i1tbiyM6CCGR/j64W/WOoDt/aXCbbzL7Uk6IxQR1L60xKGTKmQ5J5bn7wnhfbhKcoAUepnVaexbDzwDBDCsisCInIP8mi8PqtFBlnsxPG3Yyv5PrrfklimVoI4swIOg2demIijYmOSA0dv0xJ8f36wP/aQdXUnaDZ15/UdJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771868266; c=relaxed/simple;
	bh=oWIaFeSTVYHhmmVMs/TNZX8WjVt8s3g8Avgtx8RWuEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avcfN69fH4eBaDrMQVrHbDjWih59KgRsro+Q3w96JKAoH192sos69JdolnW3N6UAl+G5If7hqoviCAVl3DkLbZ3+VfT1mDg5s+Lg0GauP5dlmYoZybV6/8xwtgGAb3ouaofO8fWW5cX9J0ny/nzk9Bjk3RmEPpdrnuBYpWpYAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iptasx/g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iDTKiXfj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771868263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2RB6w5qBp9bxCdc9Z/nzSE6UzRNqy37VnyUtnjmBblA=;
	b=iptasx/glmOfZCMDvhFmT0EblIn5fbO+2pY+pfpd8FgyQKnbfnrFyj1TGExy/7aRhBa1EZ
	OmgLznEjx8GF8VlRwHyQ7n4m2grJvFLJwZumNiwyUD86G7qTE5MZb5QXzllgOaJYWHHl29
	J9L00lAYUgC4PgOZ17+zbYTtQJyZIdM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-AiNZ9maQPIq98ib5dmM6ag-1; Mon, 23 Feb 2026 12:37:42 -0500
X-MC-Unique: AiNZ9maQPIq98ib5dmM6ag-1
X-Mimecast-MFC-AGG-ID: AiNZ9maQPIq98ib5dmM6ag_1771868261
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8954ac30d79so605918846d6.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 09:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771868261; x=1772473061; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2RB6w5qBp9bxCdc9Z/nzSE6UzRNqy37VnyUtnjmBblA=;
        b=iDTKiXfjj4ISnHoVshXvIlrv0IRGtPKTkUjlaJxGmipyOsVZHlDQT/2d/cnl1Wedfe
         to6P//rIF3jhskOhD3y3EFSuv0BR1PDSg/fJsj7nFcc24vr93l/NemZps+kQXFHUmIIo
         BZUTLzLu23T23K4RGFgmWtoaDZvl7sYUm0uh7/LnZElPkYgR3ZkcJQTR7wBPhOoeAXBN
         r2Qao9JfKQk6QjcLz1mA3uxs4rbnhPSicgJnt1JuI9VCVRUjn9B2VyvbGu0Asf6lrL8P
         Gq5YUiyDqc9TKNeeYgOL77qli4y/sjI5abGI61dIJhm2dezLlnDXOUHJtrUFgMLso4v/
         aBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771868261; x=1772473061;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2RB6w5qBp9bxCdc9Z/nzSE6UzRNqy37VnyUtnjmBblA=;
        b=SyVnJ4oQBwRdUeXLYYlv2RYauUvQV8LRLgeUVK8pexp4XzPHmuQDoQgVZXthwQY3k3
         QzLizCxjuHzO1UXXsXPk6Bf9QYbFAon/jfAzDRzxad++5aVtS8a+E9vE+dGOjwmqf3jq
         zy3Etxd6jnMgv8CHldJgzrQjFvobsRmUsBpAnxHc41CRpU0E3BqZTrWTh9U05hOg7BzK
         YsbSFZeISrxJuKXQdbg4w72Iqfrv+OweeCBENiLJ4rSYb1pQ9rHWR5wtgsy39qXdrvww
         BlPv2bnXVlNz3fb7/EBLqT5Y5KEBCvrUAgXf7+eJxB9UseJR5VtAOWdR/uroQlGvhu+A
         fsqA==
X-Forwarded-Encrypted: i=1; AJvYcCWGOHesZUznLestQQBHq0Kj7XG77RRzfg8wfVBzDGakHMMo9omV2Y6mkaxiLWGyChsASfw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLiu5mzwSrT+axzaFQO0eHYHB3sxpb/UFuP5NXRRAqrHSUW088
	dsRznchEMSW2w/Lo0CfdVqsg3TNCvbpliRX71KRCEO/MZuePvzwlAfui9OzRZOefZrbHyyPnrIq
	VW8DQJH0EOuHppsDLHxzG/c4uCUlRVLa8zJYh5qDvAXoArNbPB+zM2Q==
X-Gm-Gg: ATEYQzzUO3AiuPQpaev9gu9EQvZQ17WVxtQXcuAjsuc3yWjmFSr6nHz4YmbOnkUM0Mq
	84fkmJNnvHHbmEWe19MxegfLsiEN0hmlmah7SjtDEftF8qkK9+CVBqI7fDD3YM3wbqtt0Bz2Hju
	9avLa0HMaR8anNsIWF0xK+yB0peXft7EtgPPthqvOiWJdpCpSE61iJ7u9GhZcQltlNz3bJ/G9fk
	EGC/zGg+SorD4KYrZHebqiRHUnZNihOyYJoV2ynxo9scBlznj3CdVqHp/rBa+9t5bJwvA1Kr6gp
	BRz3DRUfW5dGZZJOZD0ttkgSJThmMJdM7yhXmAZouTTNMHhlYELlH5Z9vHonrQwS+8NhVKea+fB
	H7QRjHAPugQ2Z6Q==
X-Received: by 2002:a05:6214:f03:b0:890:8285:e1a3 with SMTP id 6a1803df08f44-89979f35c62mr140897906d6.63.1771868261046;
        Mon, 23 Feb 2026 09:37:41 -0800 (PST)
X-Received: by 2002:a05:6214:f03:b0:890:8285:e1a3 with SMTP id 6a1803df08f44-89979f35c62mr140897456d6.63.1771868260576;
        Mon, 23 Feb 2026 09:37:40 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997c8adf68sm69016986d6.20.2026.02.23.09.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 09:37:40 -0800 (PST)
Date: Mon, 23 Feb 2026 12:37:28 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: qemu-devel@nongnu.org,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Fabiano Rosas <farosas@suse.de>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH 06/10] system/memory: split RamDiscardManager into source
 and manager
Message-ID: <aZyQWOQeKeT5yzIv@x1.local>
References: <20260204100708.724800-1-marcandre.lureau@redhat.com>
 <20260204100708.724800-7-marcandre.lureau@redhat.com>
 <aZdnDrs9ivLctEIj@x1.local>
 <CAMxuvax5uYVr0V3qKFV3t63BLkdqJco5thx23EKggH_dbKsAdQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxuvax5uYVr0V3qKFV3t63BLkdqJco5thx23EKggH_dbKsAdQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71509-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 99FED17AEAC
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 09:28:23PM +0100, Marc-André Lureau wrote:
> Do you mean that we could drop replay_populated/replay_discarded from
> the source? I think we could. replay_by_populated_state() already
> handles the aggregation logic by using is_populated() alone. There
> isn't much gain in the above implementation narrowing the iteration
> from the first source replay.

Yes, then we can also get rid of special casing the first source (where we
may invoke other sources' hooks within the 1st source's cb functions), and
the skip_source logics.

Thanks,

-- 
Peter Xu


