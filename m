Return-Path: <kvm+bounces-6210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FBC82D5A1
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4524C1C213AA
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D3BC2D2;
	Mon, 15 Jan 2024 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WzPYgiJp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6G5cl+sS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WzPYgiJp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6G5cl+sS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF48FE549;
	Mon, 15 Jan 2024 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B057122121;
	Mon, 15 Jan 2024 09:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705310084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHTwtWRUMbzJbkPU8ujlV+TwJJ5tFpEqWRiuHnBIR/0=;
	b=WzPYgiJp7tAFqYBECaA+5RH558zK6vDVc6wzspSy1oNXvm5UCJi5N/3j0bSrCZUgWrcc4Y
	0iufOnBKVwmLowDk1c5EBh+M2X3U1HGVbyc3HcUNlhYle4LSUN+zuJ+aNz928lOrtrv5uE
	6Y99oKVdt6RivVr7s6/1NH9ORr/K5To=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705310084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHTwtWRUMbzJbkPU8ujlV+TwJJ5tFpEqWRiuHnBIR/0=;
	b=6G5cl+sSsgMtJMDdfHYqYFwcWbKFLCnnyDDMtH0GeV5dpIu0r20bVfSwLfusmqppaoVeT0
	EW6vmvKcZu4LPCDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705310084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHTwtWRUMbzJbkPU8ujlV+TwJJ5tFpEqWRiuHnBIR/0=;
	b=WzPYgiJp7tAFqYBECaA+5RH558zK6vDVc6wzspSy1oNXvm5UCJi5N/3j0bSrCZUgWrcc4Y
	0iufOnBKVwmLowDk1c5EBh+M2X3U1HGVbyc3HcUNlhYle4LSUN+zuJ+aNz928lOrtrv5uE
	6Y99oKVdt6RivVr7s6/1NH9ORr/K5To=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705310084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHTwtWRUMbzJbkPU8ujlV+TwJJ5tFpEqWRiuHnBIR/0=;
	b=6G5cl+sSsgMtJMDdfHYqYFwcWbKFLCnnyDDMtH0GeV5dpIu0r20bVfSwLfusmqppaoVeT0
	EW6vmvKcZu4LPCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6158013712;
	Mon, 15 Jan 2024 09:14:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /dHXFIT3pGWtEAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Jan 2024 09:14:44 +0000
Message-ID: <4b8b38cd-f5c1-43e8-8b38-90f69d8d2b6d@suse.cz>
Date: Mon, 15 Jan 2024 10:14:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
To: Borislav Petkov <bp@alien8.de>, Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Michael Roth <michael.roth@amd.com>,
 x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>
 <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20240115090639.GAZaT1nx4C4xJuF8IA@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-0.11 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.02)[54.29%];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[40];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.11

On 1/15/24 10:06, Borislav Petkov wrote:
> On Fri, Jan 12, 2024 at 09:27:45PM +0100, Vlastimil Babka wrote:
>> Yeah and last LSF/MM we concluded that it's not as a big disadvantage as we
>> previously thought https://lwn.net/Articles/931406/
> 
> How nice, thanks for that!
> 
> Do you have some refs to Mike's tests so that we could run them here too
> with SNP guests to see how big - if any - the fragmentation has.

Let me Cc him...

> Thx.
> 


