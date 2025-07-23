Return-Path: <kvm+bounces-53270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A00FB0F784
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:53:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5517E1C86078
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1C11E3787;
	Wed, 23 Jul 2025 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yC54PZn2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xvyNXEcW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="i1ULbYev";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="njKeaHth"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA59D28DB3
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753286005; cv=none; b=cviOo6FmlwMlJjeLIjGSe8tiMaM4E3AZI4jv+hrslVun6RN2JrIXpk+U+4UNRGnJtZt2PDzrrB/d36NJk2sEvPShOy+SRhETrd1btV1RVKJY8noswLiswoQ5j1sBED4XrRuid93DzBbRY4JlQWrfNs8H7rdw0oGKW7XScwfmLNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753286005; c=relaxed/simple;
	bh=8mu32A9PIG6JIuYr7dTG0N7nJR6Zn7N0gJ4iiPavlQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/24Kp02Uh/5nj1dW+rSKgM8QgA7co8ox3VIepH9iIFw1GAjQqjxWho83RQxnCjnUPYFHTYVweQjSNt5N4EwAPy0OFsfKpWXP55sFVqWfqTabf+6VW/d+di2XcbbPhigf3rffEMX6k+cYKxKZGIxsyW2OwtgR/golYt5aMRbAi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yC54PZn2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xvyNXEcW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=i1ULbYev; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=njKeaHth; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF58E1F78C;
	Wed, 23 Jul 2025 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753286001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=11Dxp1tfrq8Q9aC+e+RtFCxo0VHeUEc3DhhTdpcNBZQ=;
	b=yC54PZn2p+qEwWRc9qWXEmO6ztl+1UhK3eteqZr9sUNccsthH5jNR27Oh0B0I1CCZFHHsi
	kT+mv9N44a+KcIk93iyZvsrNQkSQ8PuQ2yl8SpJcgK0H2MrZDJt2X0UxOqoesQhUZhNsSF
	azw6bovVnKR0L+IfUkYTU+Q+yO5HtSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753286001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=11Dxp1tfrq8Q9aC+e+RtFCxo0VHeUEc3DhhTdpcNBZQ=;
	b=xvyNXEcWLJ0PPb9YAhkMxXRXTg/xB3YUP8J5NaCETlUIO6KsQeVc37dV/rmPQ9P8a+1JVV
	LfdoBC2yDAmLtUDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i1ULbYev;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=njKeaHth
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753286000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=11Dxp1tfrq8Q9aC+e+RtFCxo0VHeUEc3DhhTdpcNBZQ=;
	b=i1ULbYevXyePknDq6jjszkmpRNebzYMikx8jh9djo35UsZeMFi/G0BP73sNb1/ke/+nL8Q
	TKNashOnKLJvEj2vllaNRjitkf70ONhgSNA5mzyvJ6dvDR84alJkPhSCGEkkzTNyjR3ltj
	2iG+bqKtkgS8+h/R6tlZhhTsKMY2CS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753286000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=11Dxp1tfrq8Q9aC+e+RtFCxo0VHeUEc3DhhTdpcNBZQ=;
	b=njKeaHtheJUha9sjQjpaSMwLDZm21OO+9hsYAtqcqogYhRLt7N/lJrJ6iJEKbq+yiYetum
	xyUxlIQgcdEjmpBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D16F813ABE;
	Wed, 23 Jul 2025 15:53:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NADRMnAFgWgDTQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 15:53:20 +0000
Message-ID: <276a28fa-c0a2-4ab7-8391-2c20831469e1@suse.cz>
Date: Wed, 23 Jul 2025 17:53:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: arm64: Config driven dependencies for
 TCR2/SCTLR/MDCR
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20250714115503.3334242-1-maz@kernel.org>
 <175268446558.2457435.12236491763380805714.b4-ty@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <175268446558.2457435.12236491763380805714.b4-ty@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: EF58E1F78C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -4.51

On 7/16/25 18:47, Oliver Upton wrote:
> On Mon, 14 Jul 2025 12:54:58 +0100, Marc Zyngier wrote:
>> Here's a very short (and hopefully not too controversial) series
>> converting a few more registers to the config-driven sanitisation
>> framework (this is mostly a leftover from the corresponding 6.16
>> monster series).
>> 
>> Patches on top of -rc3.
>> 
>> [...]
> 
> Applied to next, thanks!

The following merge commit creates a ./diff file. Found out because I had
some local leftover one which prevented git checkout of current next.

commit 811ec70dcf9cc411e4fdf36db608dc9bcffb7a06
Merge: 5ba04149822c 3096d238ec49
Author: Oliver Upton <oliver.upton@linux.dev>
Date:   Tue Jul 15 20:40:59 2025 -0700

    Merge branch 'kvm-arm64/config-masks' into kvmarm/next

    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>


> [1/5] arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
>       https://git.kernel.org/kvmarm/kvmarm/c/a3ed7da911c1
> [2/5] KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
>       https://git.kernel.org/kvmarm/kvmarm/c/001e032c0f3f
> [3/5] KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
>       https://git.kernel.org/kvmarm/kvmarm/c/6bd4a274b026
> [4/5] KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
>       https://git.kernel.org/kvmarm/kvmarm/c/cd64587f10b1
> [5/5] KVM: arm64: Tighten the definition of FEAT_PMUv3p9
>       https://git.kernel.org/kvmarm/kvmarm/c/3096d238ec49
> 
> --
> Best,
> Oliver
> 


