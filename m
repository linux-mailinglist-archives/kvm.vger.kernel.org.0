Return-Path: <kvm+bounces-40805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6A1A5D2CB
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 23:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C46A97A6966
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 22:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D1923535A;
	Tue, 11 Mar 2025 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jYtoE6uI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jR9e7HS/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jYtoE6uI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jR9e7HS/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D611EE7CB
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 22:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741733732; cv=none; b=f5jnwVrKMu2UbODvkMX9F7DGSwQ8tdb7eJYtHJurt3g2ueeFs+c/I7/p6PDynmMqN8IDL7sKUSKyHPp64iQFlgadYpHYuEG9B75QUQfj582Pp2t65SoRgyHVvGNetYcVuV6fvUmhpNS/wdNDDJ6bgoOAV/UjOrn4/mTWG43Q2yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741733732; c=relaxed/simple;
	bh=xEcI83u0PhS5nHJHrflERHHZF3yAAWOjkPzYpwfzNeE=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=POYOh2ePhd6I02DR8P9X7SDxlPDl6B0SpCVZjSoeRmPe5rEQlygODU/zRx9FdmgK0SWnV480EsyZv+h2GfP1XOxxj/OuphHdd9BNvF96fIRDvZbO1prOuDSpGSJYMn6rc7wR/A64zUXv3hagWjSwUb/TiWpcCq5Xufb8QNPAf0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jYtoE6uI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jR9e7HS/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jYtoE6uI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jR9e7HS/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 225FA1F388;
	Tue, 11 Mar 2025 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741733728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ab13EvIK2DPk+TBDxxWWO5yYyOOgqUiN0tHfZ4wqv0g=;
	b=jYtoE6uIP2QmHhlIevBJBy94LG/dhVBif5XAHK02z7vMO1n1PR7yXi+ccMMo1XZ3ZPUQ0G
	hMSYEN7fZzB1vqcZbeZdivDAZmrB06jnJFlEM9HeDbQYBny9TG1I5PfYZWQvNUAjeUmjhi
	coztQJYmMIrhjK+Edi1yDiuULs3R618=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741733728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ab13EvIK2DPk+TBDxxWWO5yYyOOgqUiN0tHfZ4wqv0g=;
	b=jR9e7HS/sosD5H1RhhkjMoj2AuTPAQpY8bmxSIybhptRMzYQt3Fpxhu8Q9h1mc63D+eBky
	sIuBv7xJik9Rq6DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jYtoE6uI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="jR9e7HS/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741733728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ab13EvIK2DPk+TBDxxWWO5yYyOOgqUiN0tHfZ4wqv0g=;
	b=jYtoE6uIP2QmHhlIevBJBy94LG/dhVBif5XAHK02z7vMO1n1PR7yXi+ccMMo1XZ3ZPUQ0G
	hMSYEN7fZzB1vqcZbeZdivDAZmrB06jnJFlEM9HeDbQYBny9TG1I5PfYZWQvNUAjeUmjhi
	coztQJYmMIrhjK+Edi1yDiuULs3R618=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741733728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ab13EvIK2DPk+TBDxxWWO5yYyOOgqUiN0tHfZ4wqv0g=;
	b=jR9e7HS/sosD5H1RhhkjMoj2AuTPAQpY8bmxSIybhptRMzYQt3Fpxhu8Q9h1mc63D+eBky
	sIuBv7xJik9Rq6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15FD9132CB;
	Tue, 11 Mar 2025 22:55:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ADdaLlG/0GevaQAAD6G6ig
	(envelope-from <neilb@suse.de>); Tue, 11 Mar 2025 22:55:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Gao Xiang" <hsiangkao@linux.alibaba.com>
Cc: "Yunsheng Lin" <linyunsheng@huawei.com>,
 "Yunsheng Lin" <yunshenglin0825@gmail.com>,
 "Dave Chinner" <david@fromorbit.com>, "Yishai Hadas" <yishaih@nvidia.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Alex Williamson" <alex.williamson@redhat.com>, "Chris Mason" <clm@fb.com>,
 "Josef Bacik" <josef@toxicpanda.com>, "David Sterba" <dsterba@suse.com>,
 "Gao Xiang" <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>,
 "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>,
 "Sandeep Dhavale" <dhavale@google.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Chuck Lever" <chuck.lever@oracle.com>,
 "Jeff Layton" <jlayton@kernel.org>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Luiz Capitulino" <luizcap@redhat.com>,
 "Mel Gorman" <mgorman@techsingularity.net>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
In-reply-to: <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
References: <>, <316d62c1-0e56-4b11-aacf-86235fba808d@linux.alibaba.com>
Date: Wed, 12 Mar 2025 09:55:10 +1100
Message-id: <174173371062.33508.12685894810362310394@noble.neil.brown.name>
X-Rspamd-Queue-Id: 225FA1F388
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[huawei.com,gmail.com,fromorbit.com,nvidia.com,ziepe.ca,intel.com,redhat.com,fb.com,toxicpanda.com,suse.com,kernel.org,linux.alibaba.com,google.com,linux-foundation.org,linaro.org,davemloft.net,oracle.com,talpey.com,techsingularity.net,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[from(RLewrxuus8mos16izbn),to_ip_from(RLodizb9et8yqpuyyezexhwnjp)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Mon, 10 Mar 2025, Gao Xiang wrote:
> 
>   - Your new api covers narrow cases compared to the existing
>     api, although all in-tree callers may be converted
>     properly, but it increases mental burden of all users.
>     And maybe complicate future potential users again which
>     really have to "check NULL elements in the middle of page
>     bulk allocating" again.

I think that the current API adds a mental burden for most users.  For
most users, their code would be much cleaner if the interface accepted
an uninitialised array with length, and were told how many pages had
been stored in that array.

A (very) few users benefit from the complexity.  So having two
interfaces, one simple and one full-featured, makes sense.

Thanks,
NeilBrown

