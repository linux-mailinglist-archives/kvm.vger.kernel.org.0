Return-Path: <kvm+bounces-6161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E93D082C658
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 21:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80617285D51
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB988168A4;
	Fri, 12 Jan 2024 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XqjvDXAE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c+Wl162U";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KD4RU5Hn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6pI6985H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D0416408;
	Fri, 12 Jan 2024 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 482C61FCE8;
	Fri, 12 Jan 2024 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705091267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3HZdlUOpp8hqp5kkH50U1gvSbJXr0EkR5CiO7uJ5Bo=;
	b=XqjvDXAESEoED/GxVyl76H3g3dEIog8jVndW2K0atDj+8mC4aP8G7wiR+/6kazHZKB6XuU
	KWYqaeNyVuip583KceuYvSKPthEXx11bSNcZ+wdWokCSp5fYlAzjPJ7v8zE7Q9hS3iZ0Yo
	t/qgF3E2gYVsYkTLhI/EXhhzUWfiNkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705091267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3HZdlUOpp8hqp5kkH50U1gvSbJXr0EkR5CiO7uJ5Bo=;
	b=c+Wl162UZcJ7GFS100RcrMYBULVzDNA35vwem9fOrK1g++F4R7bQxU/Jj0LhpR1n7WmI3k
	IpLf9iPhDLqZr6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705091266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3HZdlUOpp8hqp5kkH50U1gvSbJXr0EkR5CiO7uJ5Bo=;
	b=KD4RU5HnqQTllTTeFhkd42GxQ1p6pnytJRa77cY7f/Pty+gouCgfc2FZJz8tsGke/cJFcy
	+9rVUuObcFm6ZLR/cM3odQ47IhgZCgqnwa1PNHlx8eAW0oYqGIKFK8VBjW6BsBCK02vO9a
	MiLVD9WQeDOXNgBwBsgCt7ThLYI/OoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705091266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3HZdlUOpp8hqp5kkH50U1gvSbJXr0EkR5CiO7uJ5Bo=;
	b=6pI6985HznZHcmxFVZiB+UZNtYi0j27rwz1nFMh6tHx5yuPVBWfdu8qae9/Yy+xz3KsT8z
	seqO6XK28FWD+FCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED9E113782;
	Fri, 12 Jan 2024 20:27:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +bhPOcGgoWVWYwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Jan 2024 20:27:45 +0000
Message-ID: <f0f44280-799a-4bf8-bf88-d423a2bd41ec@suse.cz>
Date: Fri, 12 Jan 2024 21:27:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
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
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-0.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[20.32%];
	 MIME_GOOD(-0.10)[text/plain];
	 R_RATELIMIT(0.00)[to_ip_from(RL81e5qggtdx371s8ik49ru6xr)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[39];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.09

On 1/12/24 21:07, Borislav Petkov wrote:
> On Fri, Jan 12, 2024 at 12:00:01PM -0800, Dave Hansen wrote:
>> On 12/30/23 08:19, Michael Roth wrote:
>> > If the kernel uses a 2MB directmap mapping to write to an address, and
>> > that 2MB range happens to contain a 4KB page that set to private in the
>> > RMP table, that will also lead to a page-fault exception.
>> 
>> I thought we agreed long ago to just demote the whole direct map to 4k
>> on kernels that might need to act as SEV-SNP hosts.  That should be step
>> one and this can be discussed as an optimization later.
> 
> What would be the disadvantage here? Higher TLB pressure when running
> kernel code I guess...

Yeah and last LSF/MM we concluded that it's not as a big disadvantage as we
previously thought https://lwn.net/Articles/931406/

