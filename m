Return-Path: <kvm+bounces-19003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B488FE32D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 11:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03023B275AB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A7F152E0C;
	Thu,  6 Jun 2024 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DndqkAT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wDTpVDr1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DndqkAT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wDTpVDr1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A81E146A85;
	Thu,  6 Jun 2024 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717666805; cv=none; b=DCy4xEP6shXRqNHt3NDUcWiAzVPc0PGRsSjd6ij6TtIMsXWeju3XJp+GUrrP1DHQ3mDt/aIaXufz+fW05s+xE02uZlNmCAbtFQnC3ulBV3BFlH57gSuK3D0yhAmEk2+kDPKia39oJOvI1+eIgGHZZQ7Q/dWS7SYXhCK0ooprvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717666805; c=relaxed/simple;
	bh=CrDpUO2rON715u+0HzYAeYwMgZVfaEAK1m120nVUyns=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Jv2y/DcEHD9oCWgYSRXxUmRBKN9hzzHzGOlRGpvo17Q9yaZUs9BrymuOMTXJGbxH/SrRFq6wsOWKbD6e0yGmup5ZiH18FtCJdSWervYLNi3hEn96I5J96FrDFbG9+GsGEnyflCpoblzlqTQU0hcBqJrZA//VHLF4FEFERoXZMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DndqkAT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wDTpVDr1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DndqkAT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wDTpVDr1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from hawking.nue2.suse.org (unknown [IPv6:2a07:de40:a101:3:10:168:4:11])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0BA9D1F8BD;
	Thu,  6 Jun 2024 09:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717666802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/emRcecuEPEWjtJsdbqSVkHQav4CDEjorhc3/XLD1hQ=;
	b=1DndqkATBhtrBaxrwi/9LPU4XCDIVMVqaB1mkhPzF18IqNIihZZbtg8qm254BR32pfoq9E
	tXB4uJZbcs+7KMP/+1GSmFaKEX4AcGffHu5IjfVSQ4U/R8ZiQCO6Sxetnq7G6mY2WlRvO4
	O4nZ0ymAV+7kTHPYZYtKFyE5zE2jdNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717666802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/emRcecuEPEWjtJsdbqSVkHQav4CDEjorhc3/XLD1hQ=;
	b=wDTpVDr1+qpCkDVANUi/xfu8TTwhQddk6RfhBRfaLCFz3rsk7xuwgJqHe2fYhtV16sbwsn
	v9IRVfNhVKsNP3Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1DndqkAT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wDTpVDr1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717666802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/emRcecuEPEWjtJsdbqSVkHQav4CDEjorhc3/XLD1hQ=;
	b=1DndqkATBhtrBaxrwi/9LPU4XCDIVMVqaB1mkhPzF18IqNIihZZbtg8qm254BR32pfoq9E
	tXB4uJZbcs+7KMP/+1GSmFaKEX4AcGffHu5IjfVSQ4U/R8ZiQCO6Sxetnq7G6mY2WlRvO4
	O4nZ0ymAV+7kTHPYZYtKFyE5zE2jdNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717666802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/emRcecuEPEWjtJsdbqSVkHQav4CDEjorhc3/XLD1hQ=;
	b=wDTpVDr1+qpCkDVANUi/xfu8TTwhQddk6RfhBRfaLCFz3rsk7xuwgJqHe2fYhtV16sbwsn
	v9IRVfNhVKsNP3Cw==
Received: by hawking.nue2.suse.org (Postfix, from userid 17005)
	id 71E5B4A0552; Thu,  6 Jun 2024 11:40:01 +0200 (CEST)
From: Andreas Schwab <schwab@suse.de>
To: Shenlin Liang <liangshenlin@eswincomputing.com>
Cc: anup@brainfault.org,  atishp@atishpatra.org,  paul.walmsley@sifive.com,
  palmer@dabbelt.com,  aou@eecs.berkeley.edu,  kvm@vger.kernel.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  peterz@infradead.org,  mingo@redhat.com,
  acme@kernel.org,  namhyung@kernel.org,  mark.rutland@arm.com,
  alexander.shishkin@linux.intel.com,  jolsa@kernel.org,
  irogers@google.com,  adrian.hunter@intel.com,
  linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
In-Reply-To: <20240422080833.8745-3-liangshenlin@eswincomputing.com> (Shenlin
	Liang's message of "Mon, 22 Apr 2024 08:08:33 +0000")
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
	<20240422080833.8745-3-liangshenlin@eswincomputing.com>
X-Yow: Uh-oh --  WHY am I suddenly thinking of a VENERABLE religious leader
 frolicking on a FORT LAUDERDALE weekend?
Date: Thu, 06 Jun 2024 11:40:01 +0200
Message-ID: <mvmr0das93i.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: *
X-Spamd-Result: default: False [1.77 / 50.00];
	BAYES_HAM(-2.99)[99.96%];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	ONCE_RECEIVED(1.20)[];
	RDNS_NONE(1.00)[];
	HFILTER_HELO_IP_A(1.00)[hawking.nue2.suse.org];
	NEURAL_HAM_LONG(-1.00)[-0.998];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[hawking.nue2.suse.org];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_NO_TLS_LAST(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	NEURAL_HAM_SHORT(-0.03)[-0.147];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DIRECT_TO_MX(0.00)[Gnus/5.13 (Gnus v5.13)];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	R_RATELIMIT(0.00)[from(RLajr16mudzow8bnf6sy)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: 1.77
X-Spamd-Bar: +
X-Rspamd-Queue-Id: 0BA9D1F8BD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Apr 22 2024, Shenlin Liang wrote:

> \ No newline at end of file

Please fix that.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

