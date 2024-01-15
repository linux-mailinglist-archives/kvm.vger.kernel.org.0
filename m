Return-Path: <kvm+bounces-6213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3924F82D5C7
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 10:23:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 408181C2142D
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 09:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64FBCA7A;
	Mon, 15 Jan 2024 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DwSRoxEo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kA3Crk0x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DwSRoxEo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kA3Crk0x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66885F4E4;
	Mon, 15 Jan 2024 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 989B722150;
	Mon, 15 Jan 2024 09:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705310598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cAvAmgb/jPWg9AlkaccrOmdOwRCSsdippzeZcx291nI=;
	b=DwSRoxEoiZW4TfXc4fF+UH6GBBSvPVkAmEhT07+0QAIj26qFIMksxaCur1+5JSJLMCy7B9
	v/+ZtmjzRhoLXPTBMYfF7KkuOR4oUwo4FvTnzlWfoZYjRVF/+xJDTtAu0wCtGtMrm6GudZ
	TGjumFbt6AdFGn0Zl8gyqMwqvWBBzVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705310598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cAvAmgb/jPWg9AlkaccrOmdOwRCSsdippzeZcx291nI=;
	b=kA3Crk0xZEfgJb4J6mqAN5ZS7yw5zCilj6ACcSSlpobTV6Exuk6q44u8bK9neKpLGTIakg
	UM2XD+NvPvgehlAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705310598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cAvAmgb/jPWg9AlkaccrOmdOwRCSsdippzeZcx291nI=;
	b=DwSRoxEoiZW4TfXc4fF+UH6GBBSvPVkAmEhT07+0QAIj26qFIMksxaCur1+5JSJLMCy7B9
	v/+ZtmjzRhoLXPTBMYfF7KkuOR4oUwo4FvTnzlWfoZYjRVF/+xJDTtAu0wCtGtMrm6GudZ
	TGjumFbt6AdFGn0Zl8gyqMwqvWBBzVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705310598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cAvAmgb/jPWg9AlkaccrOmdOwRCSsdippzeZcx291nI=;
	b=kA3Crk0xZEfgJb4J6mqAN5ZS7yw5zCilj6ACcSSlpobTV6Exuk6q44u8bK9neKpLGTIakg
	UM2XD+NvPvgehlAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DD7713712;
	Mon, 15 Jan 2024 09:23:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OHGxEob5pGXdEwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Jan 2024 09:23:18 +0000
Message-ID: <91f54c39-a8f4-4186-9a5b-83dcbc5c929c@suse.cz>
Date: Mon, 15 Jan 2024 10:23:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, tobin@ibm.com, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DwSRoxEo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kA3Crk0x
X-Spamd-Result: default: False [-2.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[34.26%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_DKIM_ARC_DNSWL_HI(-1.00)[];
	 R_RATELIMIT(0.00)[to_ip_from(RLisu716frudqkg98kczdd9eac)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWELVE(0.00)[39];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_IN_DNSWL_HI(-1.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 989B722150
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO

On 1/12/24 21:37, Dave Hansen wrote:
> On 1/12/24 12:28, Tom Lendacky wrote:
>> I thought there was also a desire to remove the direct map for any pages
>> assigned to a guest as private, not just the case that the comment says.
>> So updating the comment would probably the best action.
> 
> I'm not sure who desires that.
> 
> It's sloooooooow to remove things from the direct map.  There's almost
> certainly a frequency cutoff where running the whole direct mapping as
> 4k is better than the cost of mapping/unmapping.
> 
> Actually, where _is_ the TLB flushing here?

Hm yeah it seems to be using the _noflush version? Maybe the RMP issues this
avoids are only triggered with actual page tables and a stray outdated TLB
hit doesn't trigger it? Needs documenting though if that's the case.

