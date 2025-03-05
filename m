Return-Path: <kvm+bounces-40197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61251A53E9C
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82FC11891B41
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 23:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689B7207E0B;
	Wed,  5 Mar 2025 23:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YjCN5sm0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SeO+07Dw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YjCN5sm0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SeO+07Dw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5D207673
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 23:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218110; cv=none; b=dzGV23ocrqpl3+ZFLaB//z9pbZKiBJl7EuYqqQbtzOtVArqw7roA1oYA8rSqQ8OLzWmUe/nAJh3BGWYmDmmy7DThNycW3PTzqFgERgFL+3ltifRDLU71ekcz/7LP+SHdnPk5qk78xq1DqZ2CP/nJ1gwJNrOCLf21YDL3nQtkElU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218110; c=relaxed/simple;
	bh=79A9Xcxf22LN1wRxVN/wCq4MVv4De/k36OytnK/R+PU=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=aygVdK5QXbob8KaoIdybqtphyw2a8wqGccj2t9njJi7rzQcs8AOtv2kgFyebSqnPO7K1PIDvoxe0jH/Jc7k1wnzTooFTNC+jrR9za/z3xXh4QITfH3MIIcTBo/xcE3uEbEMCR/MfV+65Br4sj1V8psgtGdfS7wcwjl6aSAWbPD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YjCN5sm0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SeO+07Dw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YjCN5sm0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SeO+07Dw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7C171F385;
	Wed,  5 Mar 2025 23:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741218106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evnk/GxliDTjNMMgAFyfCNZGfvqVt47nI9LnubvMvxc=;
	b=YjCN5sm09/Vik1hnIVgY/KAn9Bl+M9/Qo0xPTOFQNF8Y/8QdKDvee6BGLO7x9pn9iJ9kyi
	n5vDga3YY2IqVkMq8j71+tXA/lQqxgbYINFt4chYC7lsJ2wAc09oTXOcOZ0cfwMxqE/8JT
	f5K7ko5CR+elv4J6T28XRXDqa8DqvvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741218106;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evnk/GxliDTjNMMgAFyfCNZGfvqVt47nI9LnubvMvxc=;
	b=SeO+07DwVmMuxGIdJ6uBjWre+ET8YmfEvWdD+64YO1xDmbJOxMvVwYwNFQ+y51t6511CM8
	Xk9d1WRKq6le82BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741218106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evnk/GxliDTjNMMgAFyfCNZGfvqVt47nI9LnubvMvxc=;
	b=YjCN5sm09/Vik1hnIVgY/KAn9Bl+M9/Qo0xPTOFQNF8Y/8QdKDvee6BGLO7x9pn9iJ9kyi
	n5vDga3YY2IqVkMq8j71+tXA/lQqxgbYINFt4chYC7lsJ2wAc09oTXOcOZ0cfwMxqE/8JT
	f5K7ko5CR+elv4J6T28XRXDqa8DqvvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741218106;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=evnk/GxliDTjNMMgAFyfCNZGfvqVt47nI9LnubvMvxc=;
	b=SeO+07DwVmMuxGIdJ6uBjWre+ET8YmfEvWdD+64YO1xDmbJOxMvVwYwNFQ+y51t6511CM8
	Xk9d1WRKq6le82BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E44A013939;
	Wed,  5 Mar 2025 23:41:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zc4kJSzhyGdbdAAAD6G6ig
	(envelope-from <neilb@suse.de>); Wed, 05 Mar 2025 23:41:32 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Yunsheng Lin" <linyunsheng@huawei.com>
Cc: "Qu Wenruo" <wqu@suse.com>, "Yishai Hadas" <yishaih@nvidia.com>,
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
 "Mel Gorman" <mgorman@techsingularity.net>,
 "Dave Chinner" <david@fromorbit.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
In-reply-to: <18c68e7a-88c9-49d1-8ff8-17c63bcc44f4@huawei.com>
References: <>, <18c68e7a-88c9-49d1-8ff8-17c63bcc44f4@huawei.com>
Date: Thu, 06 Mar 2025 10:41:24 +1100
Message-id: <174121808436.33508.1242845473359255682@noble.neil.brown.name>
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,nvidia.com,ziepe.ca,huawei.com,intel.com,redhat.com,fb.com,toxicpanda.com,kernel.org,gmail.com,linux.alibaba.com,google.com,linux-foundation.org,linaro.org,davemloft.net,oracle.com,talpey.com,techsingularity.net,fromorbit.com,vger.kernel.org,lists.linux.dev,lists.ozlabs.org,kvack.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	R_RATELIMIT(0.00)[from(RLewrxuus8mos16izbn),to_ip_from(RL4q5k5kyydt8nhc3xa4shdp4c)]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 05 Mar 2025, Yunsheng Lin wrote:
> 
> For the existing btrfs and sunrpc case, I am agreed that there
> might be valid use cases too, we just need to discuss how to
> meet the requirements of different use cases using simpler, more
> unified and effective APIs.

We don't need "more unified".

If there are genuinely two different use cases with clearly different
needs - even if only slightly different - then it is acceptable to have
two different interfaces.  Be sure to choose names which emphasise the
differences.

Thanks,
NeilBrown

