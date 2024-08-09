Return-Path: <kvm+bounces-23683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA3294CC34
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 10:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D86441F2378F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F24C18DF9E;
	Fri,  9 Aug 2024 08:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XWUIFakO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o/UhUNnC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XWUIFakO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o/UhUNnC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFCA177981
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723192200; cv=none; b=YpGWCej0sJ9VC/vFvOPupelcBVwYFxnbBMrBFrAMgkNyJe085TqMnwuwmAmKMtdons87FtcyilFUJnH+JtJJ6oN/eHmqd2Zq58srtPmBse348Ep3jvkM79dkefxBOQJEtMoanID3GcP7oQOvaDKjAJaIn92gql+k6XwaFdvFxAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723192200; c=relaxed/simple;
	bh=u02H8kdsGrDV6/YXs6M02qCTYUuSDQpJHb/LNOOU2V4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=g7UmmMSJC+8ooBSrxeDh8GfMYS84fKItxhyatnGnf1zp3MX2lhBFOCp8KGoka9LScHRz7pl4+6E7XQq09su5/O6xVMP4qksXB0eCn4xn3ZLblWQNbdpCbkU7jHOV9OPr1dK9Cktcx4EHbV/VbXqs2ZdOp0nM4thwEk6T9OZsXYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XWUIFakO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o/UhUNnC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XWUIFakO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o/UhUNnC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13F4D21EC7;
	Fri,  9 Aug 2024 08:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723192197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8crL4hgpZsCfvMZI3nwmKCZuw+Wu1EjFQmOb/3okYt4=;
	b=XWUIFakOsiauGCI3ASvBCQ/d5Qn3zOQuucywsCol2RN9P55NiXZmmdIugkXMqt63z6qvO7
	73IPbw61tb83b3o7xw0ioQCMOb6xZ7llnGa0TnncYrHypBj5UKIkQ1dZROw1EF6JCYFfJv
	URdkEJDmX//UMWTMPJ1SZSQr71+afcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723192197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8crL4hgpZsCfvMZI3nwmKCZuw+Wu1EjFQmOb/3okYt4=;
	b=o/UhUNnClsR0FMXDLJ6+bwsHSMpEegpP9y9V0VpKupqSs1vTMx6520lb2WuvwyKvNyfb+q
	nMZ/YogCpa5ll9Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XWUIFakO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="o/UhUNnC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723192197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8crL4hgpZsCfvMZI3nwmKCZuw+Wu1EjFQmOb/3okYt4=;
	b=XWUIFakOsiauGCI3ASvBCQ/d5Qn3zOQuucywsCol2RN9P55NiXZmmdIugkXMqt63z6qvO7
	73IPbw61tb83b3o7xw0ioQCMOb6xZ7llnGa0TnncYrHypBj5UKIkQ1dZROw1EF6JCYFfJv
	URdkEJDmX//UMWTMPJ1SZSQr71+afcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723192197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8crL4hgpZsCfvMZI3nwmKCZuw+Wu1EjFQmOb/3okYt4=;
	b=o/UhUNnClsR0FMXDLJ6+bwsHSMpEegpP9y9V0VpKupqSs1vTMx6520lb2WuvwyKvNyfb+q
	nMZ/YogCpa5ll9Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E321113A7D;
	Fri,  9 Aug 2024 08:29:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ro+RNYTTtWauJAAAD6G6ig
	(envelope-from <cfontana@suse.de>); Fri, 09 Aug 2024 08:29:56 +0000
Message-ID: <e05e62da-e765-4d99-9095-989c774615fc@suse.de>
Date: Fri, 9 Aug 2024 10:29:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kvm_stat issue running in the background
From: Claudio Fontana <cfontana@suse.de>
To: Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
References: <f21ffdee-1f29-4d89-9237-470dad9b0ef9@suse.de>
 <20240807133727.GB131475@fedora.redhat.com>
 <afd29a7a-c944-4cf8-b8e1-082e9b0cb74e@suse.de>
Content-Language: en-US
In-Reply-To: <afd29a7a-c944-4cf8-b8e1-082e9b0cb74e@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -6.50
X-Rspamd-Queue-Id: 13F4D21EC7
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO

On 8/7/24 17:46, Claudio Fontana wrote:
> Hi,
> 
> On 8/7/24 15:37, Stefan Hajnoczi wrote:
>> On Sat, Aug 03, 2024 at 11:23:21AM +0200, Claudio Fontana wrote:
>>> Hello Stefan,
>>>
>>> did not know where to report this, but the man page mentions you specifically so here I am.
>>
>> Hi Claudio,
>> I wrote the man page for kvm_stat(1) but am not the maintainer of the
>> tool. I have CCed the KVM mailing list although it's possible that no
>> one actively maintains the tool :).
>>
>>>
>>>
>>> There seems to be an issue when kvm_stat is run with:
>>>
>>> kvm_stat -p xxx -d -t -s yy -c -L FILENAME.csv &
>>>
>>> specifically due to the ampersand (&), thus running in the background.
>>>
>>>
>>> It seems that kvm_stat gets the interrupt signal (SIGINT), and does write as a result the output to disk,
>>> but then instead of terminating, it just hangs there forever.
>>
>> That is strange. The only signal handler installed by kvm_stat is for
>> SIGHUP, so Python should perform the default behavior for SIGINT and
>> terminate. I'm not sure why the process would hang.
>>
>>>
>>> So to avoid ending up with a large number of kvm_stat processes lingering on the system,
>>> we needed to put a random sleep, and then send a SIGTERM to terminate the kvm_stat processes.
>>>
>>> Just sending a SIGTERM (without the SIGINT) does terminate the kvm_stat processes, but NO DATA is written to disk (the files show as 0 size).
>>
>> That makes sense since kvm_stat does not handle SIGTERM. The default
>> SIGTERM behavior is to terminal and any output in Python's I/O buffers
>> may not have been written to the file.
>>
>> Maybe kvm_stat should catch SIGINT and SIGTERM. That would give it a
>> chance to write out the log before terminating. Do you want to try
>> implementing that?I 
> 
> I think SIGINT would be enough, sure I can give it a try,

It seemed to make sense to process SIGINT and SIGTERM the same way in the end.

I sent a patch to the mailing list, Paolo and you:

https://marc.info/?l=kvm&m=172305139224516&w=2


There was some local problem with email, so the email might have reached the list but not you specifically also.

Thanks,

Claudio


> 
> Thanks,
> 
> C
> 
>>
>>>
>>> This is the workaround script that we currently have:
>>>
>>> ----
>>>
>>> #! /bin/bash                                                                                                            
>>>
>>> VM_PIDS=`pgrep qemu-system-`
>>>
>>> for VM_PID in ${VM_PIDS} ; do
>>>     # warning: kvm_stat is very fragile, change with care                                                               
>>>     kvm_stat -p ${VM_PID} -d -t -s 1 -c -L kvm_stat_${VM_PID}.csv &
>>> done
>>>
>>> if test "x${VM_PID}" != "x" ; then
>>>     echo "launched kvm_stat processes, capturing 10 seconds..."
>>>     sleep 10
>>>     echo "signaling all kvm_stat processes to write to disk..."
>>>     pkill -INT -P $$
>>>     sleep 5
>>>     sync
>>>     echo "signaling all kvm_stat processes to die..."
>>>     pkill -TERM -P $$
>>>     echo "waiting for kvm_stat processes to exit..."
>>>     while pgrep -P $$ > /dev/null; do
>>>     sleep 2
>>>     echo "still waiting for kvm_stat processes to exit..."
>>>     done
>>> fi
>>>
>>> echo "Done."
>>>
>>> ----
>>>
>>> Feel free to forward to the appropriate mailing list if needed,
>>>
>>> thanks!
>>>
>>> Claudio
>>>
>>> -- 
>>> Claudio Fontana
>>> Engineering Manager Virtualization, SUSE Labs Core
>>>
>>> SUSE Software Solutions Italy Srl
>>>
> 


