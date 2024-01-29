Return-Path: <kvm+bounces-7344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FD38409E3
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DD1D1F27EE9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36F3154445;
	Mon, 29 Jan 2024 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IqJ9FeBb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="buBCJSoE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wra20jGo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QGF3yu+y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51862155A2A;
	Mon, 29 Jan 2024 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706541974; cv=none; b=mamgvph2yGTGPDdwOguUn75MZTGSxXoShjZkSiKpqM2G7boaAySuH0iq7ADwmHvl+jP/DNeBryFKLZBxZyvCkFpVt8UL64wVspLBFSqFmpg+kvAi7KVmHOKlhYm/x/+eTNcg6Hryat95qihBU4DzMEkutObRqjV3V+WQEfM65Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706541974; c=relaxed/simple;
	bh=2krepP86f5+8aMs2Z47cms8u797SS21OCKmTKGRnVBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNHNNoQjoP6GBuOO4HBOBooR+4GXNAH37MuV5yuqZCDTLvAGro9Ky2Mlwg80L4tyVa5a9o9cdX5aLHcBSv8FKnXTJfsVraW+RI/JVcYrJBiY+YA+vaZoV0IbpqkoE6OkX5swC/s2bB5JR8frhjvNJuOP3Wzr4OITnQ0VrvLjxfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IqJ9FeBb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=buBCJSoE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wra20jGo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QGF3yu+y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B26A01F7EF;
	Mon, 29 Jan 2024 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706541963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jh9pQCHiNrOIgT4Qx0ZOIp8ky/ddjw+KrmlzKD3GTFA=;
	b=IqJ9FeBbPT86udoxla6bPHyxwjxJzWqX7LKUgjJK80R5KnYwWbAAOHeWSivRHKTim9jS4C
	AGd8isc43iGspBrV087KRzqkHx8cDtcjOGfxumSF+UmpfzhTsaGPVyd4WF8uG3cjFqYFIq
	LvI6iAgggiWgMe7TcwdX8ZurFxm3emA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706541963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jh9pQCHiNrOIgT4Qx0ZOIp8ky/ddjw+KrmlzKD3GTFA=;
	b=buBCJSoENZMrlJF3gAtTCcP9YbSkzSTmYZPOMOHmNSfSKzKJyT1yHabOIKQWMQHSFjiKmM
	VXdS65hxh/BSTgDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706541961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jh9pQCHiNrOIgT4Qx0ZOIp8ky/ddjw+KrmlzKD3GTFA=;
	b=wra20jGo4/gxClPMQNEDxg3qKNEOScanFSiG/ETsrUypOo2JjVxnSwInEkTN/6LLJK8vVk
	lr0dEOzA4BY/h9s6rmQy5uO24sZFxM4CfUUU/8H/5uZXweZKJ7QtHpxtCVrjufuWVnL4al
	7ChaBUZLjJahSiWbJ1BTuv9XGk79JKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706541961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jh9pQCHiNrOIgT4Qx0ZOIp8ky/ddjw+KrmlzKD3GTFA=;
	b=QGF3yu+yO4l0N6y9I54yuTV433cHTbnUtte7rHsiobjlibNuPusNpVGfX31J18kGHt/OrC
	c9YEFnT6c3ldgqDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6548013647;
	Mon, 29 Jan 2024 15:26:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dcSQF4nDt2U4RAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Jan 2024 15:26:01 +0000
Message-ID: <2068cfca-b99b-4cf0-addc-43376c2681cb@suse.cz>
Date: Mon, 29 Jan 2024 16:26:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
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
 pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
 <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
 <20240126184340.GEZbP9XA13X91-eybA@fat_crate.local>
 <20240126235420.mu644waj2eyoxqx6@amd.com>
 <20240127114207.GBZbTsDyC3hFq8pQ3D@fat_crate.local>
 <20240127154506.v3wdio25zs6i2lc3@amd.com>
 <20240127160249.GDZbUpKW_cqRzdYn7Z@fat_crate.local>
 <20240129115928.GBZbeTIJUYivEMSonh@fat_crate.local>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20240129115928.GBZbeTIJUYivEMSonh@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-3.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[36];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.09

On 1/29/24 12:59, Borislav Petkov wrote:
> On Sat, Jan 27, 2024 at 05:02:49PM +0100, Borislav Petkov wrote:
>> This function takes any PFN it gets passed in as it is. I don't care
>> who its users are now or in the future and whether they pay attention
>> what they pass into - it needs to be properly defined.
> 
> Ok, we solved it offlist, here's the final version I have. It has
> a comment explaining what I was asking.
> 
> ---
> From: Michael Roth <michael.roth@amd.com>
> Date: Thu, 25 Jan 2024 22:11:11 -0600
> Subject: [PATCH] x86/sev: Adjust the directmap to avoid inadvertent RMP faults
> 
> If the kernel uses a 2MB or larger directmap mapping to write to an
> address, and that mapping contains any 4KB pages that are set to private
> in the RMP table, an RMP #PF will trigger and cause a host crash.
> 
> SNP-aware code that owns the private PFNs will never attempt such
> a write, but other kernel tasks writing to other PFNs in the range may
> trigger these checks inadvertently due to writing to those other PFNs
> via a large directmap mapping that happens to also map a private PFN.
> 
> Prevent this by splitting any 2MB+ mappings that might end up containing
> a mix of private/shared PFNs as a result of a subsequent RMPUPDATE for
> the PFN/rmp_level passed in.
> 
> Another way to handle this would be to limit the directmap to 4K
> mappings in the case of hosts that support SNP, but there is potential
> risk for performance regressions of certain host workloads.
> 
> Handling it as-needed results in the directmap being slowly split over
> time, which lessens the risk of a performance regression since the more
> the directmap gets split as a result of running SNP guests, the more
> likely the host is being used primarily to run SNP guests, where
> a mostly-split directmap is actually beneficial since there is less
> chance of TLB flushing and cpa_lock contention being needed to perform
> these splits.
> 
> Cases where a host knows in advance it wants to primarily run SNP guests
> and wishes to pre-split the directmap can be handled by adding
> a tuneable in the future, but preliminary testing has shown this to not
> provide a signficant benefit in the common case of guests that are
> backed primarily by 2MB THPs, so it does not seem to be warranted
> currently and can be added later if a need arises in the future.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/20240126041126.1927228-12-michael.roth@amd.com

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

