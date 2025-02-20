Return-Path: <kvm+bounces-38670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD6FA3D8AC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A29B2188D841
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679FB1F2361;
	Thu, 20 Feb 2025 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FKaCqLpu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rlFD5gzh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="APqZHmmf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CiwI10S6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27DE1F12F6
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740050926; cv=none; b=Ud454QPKapwVnAo0TrgFbtQly9hS2yCYeA/hvMXFTHiV32e0+XiCywhPS/vLwT3eshiCtQuWgt3YjLP+qWg/xa2IA18wLmdr+QeBfkw7589Ne7A8B3zGV+HzSi94jLDGsNtBtrigaoGdEHCMK0cQROcwgayb7yfJj3s4BK1I+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740050926; c=relaxed/simple;
	bh=qihenk4qWKP7Cq+VhiW80eiRrmGZPftz6N5Y2L8QVbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0bCTk9483m2OQz+/NY317Nqn+eVSEVnZSsg/gZ8x6XZVl8GsQSD0wiPS9NM7AqQBNYIDRYvkqZJU1ziJbVWQEABm2qxDuUQ6imgpZYgJcBZ881dWJCYlNK581x4qzapFLHHtCcV5143IUiI5/rMzqwRpR5hdAoWD4/m9LD6cTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FKaCqLpu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rlFD5gzh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=APqZHmmf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CiwI10S6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D954C1F38F;
	Thu, 20 Feb 2025 11:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740050923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=piqxfvLXdbGusjFDiJqlKR9OqlTBD0wfyNhdz+Y8Rdo=;
	b=FKaCqLpupK+EyUHi0f5GBjf/hHx6IevA2tQAnj9epH03L4XgghXSqARmt2pRcN6MdFUepq
	eHoZ7/GqmGDWWcEgeXSjTON2/vZ4yBYdmcR58pRV/61cc3Pyn/TAHu8q6VxTrqlD3ck/53
	6FieLDeWaRrFFlqO7zMGUONAIFKW254=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740050923;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=piqxfvLXdbGusjFDiJqlKR9OqlTBD0wfyNhdz+Y8Rdo=;
	b=rlFD5gzhMdEsIryvM5UjJumhGYqjRqi/q+pBy7fszYOU0vXWNJKu6Xo3ICiqyrFKD7IEX5
	JBBQMXJTJPBdQVDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=APqZHmmf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CiwI10S6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740050922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=piqxfvLXdbGusjFDiJqlKR9OqlTBD0wfyNhdz+Y8Rdo=;
	b=APqZHmmf3yd7nneZMwYZZPy8tKLoW6KyOuei3flSDhzzrcaFGr8Zk/dVEwiLuXBCQwX+Yi
	7L5j3necD2oexkK6n7KK8UqJ/JLPI5iRMdwCo1OG0+5LDoq4jSFRTCqxFqnqdhW5cadvt9
	eFm3b1SoH70/NubZvEi51XF/Q758vr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740050922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=piqxfvLXdbGusjFDiJqlKR9OqlTBD0wfyNhdz+Y8Rdo=;
	b=CiwI10S6vS7UlpiQa6s/xEdu6SWaatdK6ULi6/FNojnSrLByr9xGKnQvsiW0PlQI9//8N0
	gn6DpRvV1wLDvQCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB16D13A42;
	Thu, 20 Feb 2025 11:28:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TXtIK+kRt2d4HQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 20 Feb 2025 11:28:41 +0000
Message-ID: <5746ef9f-92da-4f83-bdf8-96169b090cff@suse.cz>
Date: Thu, 20 Feb 2025 12:28:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-3-tabba@google.com>
 <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 EP+ylKVEKb0Q2A==
In-Reply-To: <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D954C1F38F
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,kernel.org,ellerman.id.au,brainfault.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,zeniv.linux.org.uk,infradead.org,linux-foundation.org,intel.com,linux.intel.com,digikod.net,maciej.szmigiero.name,amd.com,oracle.com,gmail.com,arm.com,quicinc.com,huawei.com,linux.dev,amazon.co.uk,nvidia.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[60];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 2/20/25 12:25, David Hildenbrand wrote:
> On 11.02.25 13:11, Fuad Tabba wrote:
>> Before transitioning a guest_memfd folio to unshared, thereby
>> disallowing access by the host and allowing the hypervisor to
>> transition its view of the guest page as private, we need to be
>> sure that the host doesn't have any references to the folio.
>> 
>> This patch introduces a new type for guest_memfd folios, which
>> isn't activated in this series but is here as a placeholder and
>> to facilitate the code in the next patch. This will be used in
>> the future to register a callback that informs the guest_memfd
>> subsystem when the last reference is dropped, therefore knowing
>> that the host doesn't have any remaining references.
>> 
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
> 
> [...]
> 
>>   static const char *page_type_name(unsigned int page_type)
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 47bc1bb919cc..241880a46358 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -38,6 +38,10 @@
>>   #include <linux/local_lock.h>
>>   #include <linux/buffer_head.h>
>>   
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +#include <linux/kvm_host.h>
>> +#endif
>> +
>>   #include "internal.h"
>>   
>>   #define CREATE_TRACE_POINTS
>> @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
>>   	case PGTY_hugetlb:
>>   		free_huge_folio(folio);
>>   		return;
>> +#endif
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +	case PGTY_guestmem:
>> +		kvm_gmem_handle_folio_put(folio);
>> +		return;
> 
> Hm, if KVM is built as a module, will that work? Or would we need the 

Good catch, I guess not?

> core-mm guest_memfd shim that would always be compiled into the core and 
> decouple KVM from guest_memfd ("library")?

That could also help avoid exporting the mpol symbols in the NUMA mempolicy
series?


