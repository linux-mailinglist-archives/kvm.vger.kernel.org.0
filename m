Return-Path: <kvm+bounces-23563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC1394AD59
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 413F7B31F22
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9411369BB;
	Wed,  7 Aug 2024 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x2gOGiDN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PHEUpQ/O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x2gOGiDN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PHEUpQ/O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEA4328B6
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723045618; cv=none; b=At0aRnHPnUePdhaiZ6KVwp4PI2IQLoL4u6I0joRKrSb0GYWeYqDUTNYbYD8cJg9FXy8mXHUui4QhM5PE+/r60RGzDobxFl6BBOWoz66GU53u9UzEZWuC8wCGU3KGww6gT57a+q2gpWIKKGERs4X9CSR3wAY1DUOLo8MFEXIp6wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723045618; c=relaxed/simple;
	bh=9rwgNVf+sdadXBJdh3nN0WCPG91t59m5ynmAayirLqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMFuPQD03NmzB6UkZ+ry04nOQ3/cDInr8Ipu2W8+8HLmvQa25+9/mE8w2deWrceXPQUfLwK/rPBzQEOLiS8whiohft/T5Wc+wXdTnnbpPjFOqYylqLw8BOI8Hl8i4kWTgc7tDktCmTuHoWp1W+hSY88CVqlJtPAqQZ8zCgCRb0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x2gOGiDN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PHEUpQ/O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x2gOGiDN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PHEUpQ/O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46D561FB8D;
	Wed,  7 Aug 2024 15:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723045614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baB1LujUNqyMj5NWzeN+yd2c34Xwt3hcJ4ZBa7qjBGw=;
	b=x2gOGiDNkNG5u6WgjW8JkwJFwgNmJrSUscfFu1ZAhN1GFO8AbCRJF0wLZ4udJDwIMMTQiI
	Sy9OJSdcHmcMAlrsz05eykcksTNQ2tZSPPlFpnjf1UxQyogDPHjQy7VhgkGx2Sm24omNP3
	azDFBuTEfF8n5m3NDjEIZxpEJDrv+Yg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723045614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baB1LujUNqyMj5NWzeN+yd2c34Xwt3hcJ4ZBa7qjBGw=;
	b=PHEUpQ/OPWyAgWj6s3iI3RrvkJ21wpMwggtAI2Al+5mJ+eCiqoCNCfg4QQXZGFJpiFlSgu
	H3NIl+DMNAMKETCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723045614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baB1LujUNqyMj5NWzeN+yd2c34Xwt3hcJ4ZBa7qjBGw=;
	b=x2gOGiDNkNG5u6WgjW8JkwJFwgNmJrSUscfFu1ZAhN1GFO8AbCRJF0wLZ4udJDwIMMTQiI
	Sy9OJSdcHmcMAlrsz05eykcksTNQ2tZSPPlFpnjf1UxQyogDPHjQy7VhgkGx2Sm24omNP3
	azDFBuTEfF8n5m3NDjEIZxpEJDrv+Yg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723045614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baB1LujUNqyMj5NWzeN+yd2c34Xwt3hcJ4ZBa7qjBGw=;
	b=PHEUpQ/OPWyAgWj6s3iI3RrvkJ21wpMwggtAI2Al+5mJ+eCiqoCNCfg4QQXZGFJpiFlSgu
	H3NIl+DMNAMKETCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D64613A7D;
	Wed,  7 Aug 2024 15:46:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +BCECe6Ws2YNBAAAD6G6ig
	(envelope-from <cfontana@suse.de>); Wed, 07 Aug 2024 15:46:54 +0000
Message-ID: <afd29a7a-c944-4cf8-b8e1-082e9b0cb74e@suse.de>
Date: Wed, 7 Aug 2024 17:46:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kvm_stat issue running in the background
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: kvm@vger.kernel.org
References: <f21ffdee-1f29-4d89-9237-470dad9b0ef9@suse.de>
 <20240807133727.GB131475@fedora.redhat.com>
Content-Language: en-US
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20240807133727.GB131475@fedora.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Flag: NO
X-Spam-Level: 

Hi,

On 8/7/24 15:37, Stefan Hajnoczi wrote:
> On Sat, Aug 03, 2024 at 11:23:21AM +0200, Claudio Fontana wrote:
>> Hello Stefan,
>>
>> did not know where to report this, but the man page mentions you specifically so here I am.
> 
> Hi Claudio,
> I wrote the man page for kvm_stat(1) but am not the maintainer of the
> tool. I have CCed the KVM mailing list although it's possible that no
> one actively maintains the tool :).
> 
>>
>>
>> There seems to be an issue when kvm_stat is run with:
>>
>> kvm_stat -p xxx -d -t -s yy -c -L FILENAME.csv &
>>
>> specifically due to the ampersand (&), thus running in the background.
>>
>>
>> It seems that kvm_stat gets the interrupt signal (SIGINT), and does write as a result the output to disk,
>> but then instead of terminating, it just hangs there forever.
> 
> That is strange. The only signal handler installed by kvm_stat is for
> SIGHUP, so Python should perform the default behavior for SIGINT and
> terminate. I'm not sure why the process would hang.
> 
>>
>> So to avoid ending up with a large number of kvm_stat processes lingering on the system,
>> we needed to put a random sleep, and then send a SIGTERM to terminate the kvm_stat processes.
>>
>> Just sending a SIGTERM (without the SIGINT) does terminate the kvm_stat processes, but NO DATA is written to disk (the files show as 0 size).
> 
> That makes sense since kvm_stat does not handle SIGTERM. The default
> SIGTERM behavior is to terminal and any output in Python's I/O buffers
> may not have been written to the file.
> 
> Maybe kvm_stat should catch SIGINT and SIGTERM. That would give it a
> chance to write out the log before terminating. Do you want to try
> implementing that?I 

I think SIGINT would be enough, sure I can give it a try,

Thanks,

C

> 
>>
>> This is the workaround script that we currently have:
>>
>> ----
>>
>> #! /bin/bash                                                                                                            
>>
>> VM_PIDS=`pgrep qemu-system-`
>>
>> for VM_PID in ${VM_PIDS} ; do
>>     # warning: kvm_stat is very fragile, change with care                                                               
>>     kvm_stat -p ${VM_PID} -d -t -s 1 -c -L kvm_stat_${VM_PID}.csv &
>> done
>>
>> if test "x${VM_PID}" != "x" ; then
>>     echo "launched kvm_stat processes, capturing 10 seconds..."
>>     sleep 10
>>     echo "signaling all kvm_stat processes to write to disk..."
>>     pkill -INT -P $$
>>     sleep 5
>>     sync
>>     echo "signaling all kvm_stat processes to die..."
>>     pkill -TERM -P $$
>>     echo "waiting for kvm_stat processes to exit..."
>>     while pgrep -P $$ > /dev/null; do
>>     sleep 2
>>     echo "still waiting for kvm_stat processes to exit..."
>>     done
>> fi
>>
>> echo "Done."
>>
>> ----
>>
>> Feel free to forward to the appropriate mailing list if needed,
>>
>> thanks!
>>
>> Claudio
>>
>> -- 
>> Claudio Fontana
>> Engineering Manager Virtualization, SUSE Labs Core
>>
>> SUSE Software Solutions Italy Srl
>>


