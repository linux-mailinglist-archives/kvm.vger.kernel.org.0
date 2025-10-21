Return-Path: <kvm+bounces-60715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E624BF8D76
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 595D34E911B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D76283CB0;
	Tue, 21 Oct 2025 20:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zl08H+V2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Lxmwkk15";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pfsvATfO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sU2ngF7A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2445126AAAB
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 20:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761080255; cv=none; b=VoLLh07s1cblAoUMiBmt5IWJigvjxbYZLKvTa9pyviIrZyhyWAtv/vZa+D9yuVaNO7L3ahDTqlO/jKvWRwQCOjdqNMXGcbx0TlYl6YkOK68x5HlToAx9axtzox52u67xN770gouy4B0Si4jEM6SEHew3TKHVGUBHOoiw+nTLC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761080255; c=relaxed/simple;
	bh=C8NgEsvKHw4S/0o9XZLFVi0wqJV4aLQ5QpnfJp2smIw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MkLO2XiZMcXNqWepmfmsQhRcCO1zvmyfp2sIxaBrxPF0d6EzSEy35Bqa0k4Y1tRea9FO/SWi4NjtcmZNLt+cgFaIFyRlpP3g3IyAv7Mdk8UgUQqAVxJ//lZF8GPQhHgd/SUDbscnId2aFu+hIxXeqwKF6aWYg5T51xjLJS2p5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zl08H+V2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Lxmwkk15; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pfsvATfO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sU2ngF7A; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F064D21187;
	Tue, 21 Oct 2025 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761080248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NgEsvKHw4S/0o9XZLFVi0wqJV4aLQ5QpnfJp2smIw=;
	b=zl08H+V2b9H/odq9By+hsSd0SyjiAxMLGUMbgdWFgIAO4ivPMDY3Q6cO9AwSrkD6bOnH6B
	p3WTBBYNbDaS8SowUl2lyVn/9fvgaWOc5hj9tyUjEc8DbQxqptqh6WRBQyESuLHc5ZzeJ4
	MLX/Yf5CQFloWgsAhmVu8PpPyEpIJuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761080248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NgEsvKHw4S/0o9XZLFVi0wqJV4aLQ5QpnfJp2smIw=;
	b=Lxmwkk15+oyCtIe5tuK+g+bNdbZGbDTQAo8oCM74YQqO2P64ym3Z20FMm9KVpu8c7rzov+
	PObXePgy6BuySoBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pfsvATfO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sU2ngF7A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761080243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NgEsvKHw4S/0o9XZLFVi0wqJV4aLQ5QpnfJp2smIw=;
	b=pfsvATfOr9yXC6KGsBRsRphA7jv7d2FkHeTgsKyWjSssuJ4I5g4OPB2MyhoCBGQY6C+ce1
	KDXj0TxAEYtkDVDPzU7FLiw/o24PCtSuvclM/InZYDd5zmhMlJ7+kJKWjjHjTCiA8d8d5x
	VTO4R3RxSV7IvxozCVGqv9mXu+dMTIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761080243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8NgEsvKHw4S/0o9XZLFVi0wqJV4aLQ5QpnfJp2smIw=;
	b=sU2ngF7AGrXZ23O04cXcj96A2vxU/7Gcry2UpvfN+MtV7Fklk+cgQlMKLG8EXrPv+nr8fK
	K9hFHqgobgMvAnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 688E9139D2;
	Tue, 21 Oct 2025 20:57:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SYMMC7Pz92hUXAAAD6G6ig
	(envelope-from <farosas@suse.de>); Tue, 21 Oct 2025 20:57:23 +0000
From: Fabiano Rosas <farosas@suse.de>
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>, Eduardo Habkost
 <eduardo@habkost.net>, John Snow <jsnow@redhat.com>, Laurent Vivier
 <laurent@vivier.eu>, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>,
 qemu-trivial@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Sunil Muthuswamy
 <sunilmut@microsoft.com>, Marcelo Tosatti <mtosatti@redhat.com>, Michael
 Tokarev <mjt@tls.msk.ru>, Richard Henderson
 <richard.henderson@linaro.org>, qemu-block@nongnu.org, Paolo Bonzini
 <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Bernhard Beschow
 <shentey@gmail.com>
Subject: Re: [PATCH 8/8] tests/qtest/ds1338-test: Reuse from_bcd()
In-Reply-To: <20251017113338.7953-9-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
 <20251017113338.7953-9-shentey@gmail.com>
Date: Tue, 21 Oct 2025 17:57:20 -0300
Message-ID: <87ikg8t1lb.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: F064D21187
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-2.79)[99.09%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FREEMAIL_TO(0.00)[gmail.com,nongnu.org];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vivier.eu,vger.kernel.org,intel.com,nongnu.org,gmail.com,microsoft.com,tls.msk.ru,linaro.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80

Bernhard Beschow <shentey@gmail.com> writes:

> from_bcd() is a public API function which can be unit-tested. Reuse it to avoid
> code duplication.
>
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@suse.de>

