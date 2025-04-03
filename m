Return-Path: <kvm+bounces-42586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A89A7A519
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 16:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FEA13B4070
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3402024EAAC;
	Thu,  3 Apr 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E4MXQzaZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0j5P8dCE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E4MXQzaZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0j5P8dCE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DD424BCF9
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743690275; cv=none; b=GwsAPWKUK8mf7lCEnkAa+e4i75cl/AeMMjqUMuGtxaXEUcbidYPS3XVxL3mNsWEPYC6QQO8wBFqgyOParsnEg5SwoRd5zN9ZANmkmOJgwe3jrmczp+C00JjQ8LgoHku/Wpyi19EAklvLiRzYbj42WzZFedWSpBJ78o4KBiCTVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743690275; c=relaxed/simple;
	bh=XTSK2/KK7abmhg3od/EDYC1PEUq5iHlyndAsSYz9IX4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OtclO96Fzt+tH7+zxGa321NrafCQQKP0GKWSlSpqxhCVIQfkynNvcOSeQzPeXBEtO//Gy5SldND8st3OTNWaTmCQno/wzOHusrm1KRHHkRLVe4/E6SP+RbNUqK/Qq+072uFM43WJ7i8+6YLnn4AqIjxu9Uib1LvncgAubjPCvNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E4MXQzaZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0j5P8dCE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E4MXQzaZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0j5P8dCE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92CF121171;
	Thu,  3 Apr 2025 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743690271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWyyizaHx1Koa0jiDzMmVUAXdC21yt2g/ujbxcUhfj8=;
	b=E4MXQzaZp/3KxWKVHwHg6llVVLy9/OrZO9WNipQDKPYRWfszRTIPY04B1kHqSZzmkLm9ME
	LRZm9aS7C+X4Eh69+Hr/jn5Vt+39chjgFm7mcP3SvHDqbOr8qfSCi0uIYa2B05KyxSxdLr
	A+YJAineWVN3Lod/FvF2exToKfhEQXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743690271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWyyizaHx1Koa0jiDzMmVUAXdC21yt2g/ujbxcUhfj8=;
	b=0j5P8dCEqUV7uxtdeV2+tSnEJT6v0CqsOls+/NgpZnl8JiDPlHDO3YAaiM1qCRTs77WfkA
	dYGZBv6TJeDktxBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743690271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWyyizaHx1Koa0jiDzMmVUAXdC21yt2g/ujbxcUhfj8=;
	b=E4MXQzaZp/3KxWKVHwHg6llVVLy9/OrZO9WNipQDKPYRWfszRTIPY04B1kHqSZzmkLm9ME
	LRZm9aS7C+X4Eh69+Hr/jn5Vt+39chjgFm7mcP3SvHDqbOr8qfSCi0uIYa2B05KyxSxdLr
	A+YJAineWVN3Lod/FvF2exToKfhEQXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743690271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWyyizaHx1Koa0jiDzMmVUAXdC21yt2g/ujbxcUhfj8=;
	b=0j5P8dCEqUV7uxtdeV2+tSnEJT6v0CqsOls+/NgpZnl8JiDPlHDO3YAaiM1qCRTs77WfkA
	dYGZBv6TJeDktxBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 345341392A;
	Thu,  3 Apr 2025 14:24:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1yWSCR+a7mfsVAAAD6G6ig
	(envelope-from <cfontana@suse.de>); Thu, 03 Apr 2025 14:24:31 +0000
Message-ID: <f9118414-2153-497a-8804-5bd67e14180f@suse.de>
Date: Thu, 3 Apr 2025 16:24:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
From: Claudio Fontana <cfontana@suse.de>
To: Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
 Dario Faggioli <dfaggioli@suse.com>, Fabiano Rosas <farosas@suse.de>
References: <20240807172334.1006-1-cfontana@suse.de>
 <e6461e14-ca65-4322-a818-88b66b58c5c1@suse.com>
 <634dd49d-94cb-4892-856d-15e83c44c805@suse.de>
 <e7e94ff8-d7d9-4807-9e53-8d5406ba39ab@suse.de>
Content-Language: en-US
In-Reply-To: <e7e94ff8-d7d9-4807-9e53-8d5406ba39ab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

(and my offer to maintain this script remains) - Thanks. C

On 4/3/25 16:01, Claudio Fontana wrote:
> Gentle ping,
> 
> we currently need to carry this downstream, could you include this fix?
> 
> Thanks,
> 
> CLaudio
> 
> On 11/27/24 17:30, Claudio Fontana wrote:
>> Hi, according to MAINTAINERS file:
>>
>> M:  Paolo Bonzini <pbonzini@redhat.com>
>> L:  kvm@vger.kernel.org
>> F:  tools/kvm/
>>
>> Paolo, is kvm_stat something you still care about, or should it be set to unmaintained?
>> In this case I think someone at SUSE could pick it up.
>>
>> Ciao,
>>
>> Claudio
>>
>>
>> On 10/21/24 15:26, Juergen Gross wrote:
>>> Any reason not to commit this patch? It has got a Reviewed-by: tag from
>>> Stefan more than 2 months ago...
>>>
>>> On 07.08.24 19:23, Claudio Fontana wrote:
>>>> For the -l and -L options (logging mode), replace the use of the
>>>> KeyboardInterrupt exception to gracefully terminate in favor
>>>> of handling the SIGINT and SIGTERM signals.
>>>>
>>>> This allows the program to be run from scripts and still be
>>>> signaled to gracefully terminate without an interactive terminal.
>>>>
>>>> Before this change, something like this script:
>>>>
>>>> kvm_stat -p 85896 -d -t -s 1 -c -L kvm_stat_85896.csv &
>>>> sleep 10
>>>> pkill -TERM -P $$
>>>>
>>>> would yield an empty log:
>>>> -rw-r--r-- 1 root root     0 Aug  7 16:17 kvm_stat_85896.csv
>>>>
>>>> after this commit:
>>>> -rw-r--r-- 1 root root 13466 Aug  7 16:57 kvm_stat_85896.csv
>>>>
>>>> Signed-off-by: Claudio Fontana <cfontana@suse.de>
>>>> Cc: Dario Faggioli <dfaggioli@suse.com>
>>>> Cc: Fabiano Rosas <farosas@suse.de>
>>>> ---
>>>>   tools/kvm/kvm_stat/kvm_stat     | 64 ++++++++++++++++-----------------
>>>>   tools/kvm/kvm_stat/kvm_stat.txt | 12 +++++++
>>>>   2 files changed, 44 insertions(+), 32 deletions(-)
>>>>
>>>> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
>>>> index 15bf00e79e3f..2cf2da3ed002 100755
>>>> --- a/tools/kvm/kvm_stat/kvm_stat
>>>> +++ b/tools/kvm/kvm_stat/kvm_stat
>>>> @@ -297,8 +297,6 @@ IOCTL_NUMBERS = {
>>>>       'RESET':       0x00002403,
>>>>   }
>>>>   
>>>> -signal_received = False
>>>> -
>>>>   ENCODING = locale.getpreferredencoding(False)
>>>>   TRACE_FILTER = re.compile(r'^[^\(]*$')
>>>>   
>>>> @@ -1598,7 +1596,19 @@ class CSVFormat(object):
>>>>   
>>>>   def log(stats, opts, frmt, keys):
>>>>       """Prints statistics as reiterating key block, multiple value blocks."""
>>>> -    global signal_received
>>>> +    signal_received = defaultdict(bool)
>>>> +
>>>> +    def handle_signal(sig, frame):
>>>> +        nonlocal signal_received
>>>> +        signal_received[sig] = True
>>>> +        return
>>>> +
>>>> +
>>>> +    signal.signal(signal.SIGINT, handle_signal)
>>>> +    signal.signal(signal.SIGTERM, handle_signal)
>>>> +    if opts.log_to_file:
>>>> +        signal.signal(signal.SIGHUP, handle_signal)
>>>> +
>>>>       line = 0
>>>>       banner_repeat = 20
>>>>       f = None
>>>> @@ -1624,39 +1634,31 @@ def log(stats, opts, frmt, keys):
>>>>       do_banner(opts)
>>>>       banner_printed = True
>>>>       while True:
>>>> -        try:
>>>> -            time.sleep(opts.set_delay)
>>>> -            if signal_received:
>>>> -                banner_printed = True
>>>> -                line = 0
>>>> -                f.close()
>>>> -                do_banner(opts)
>>>> -                signal_received = False
>>>> -            if (line % banner_repeat == 0 and not banner_printed and
>>>> -                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
>>>> -                do_banner(opts)
>>>> -                banner_printed = True
>>>> -            values = stats.get()
>>>> -            if (not opts.skip_zero_records or
>>>> -                any(values[k].delta != 0 for k in keys)):
>>>> -                do_statline(opts, values)
>>>> -                line += 1
>>>> -                banner_printed = False
>>>> -        except KeyboardInterrupt:
>>>> +        time.sleep(opts.set_delay)
>>>> +        # Do not use the KeyboardInterrupt exception, because we may be running without a terminal
>>>> +        if (signal_received[signal.SIGINT] or signal_received[signal.SIGTERM]):
>>>>               break
>>>> +        if signal_received[signal.SIGHUP]:
>>>> +            banner_printed = True
>>>> +            line = 0
>>>> +            f.close()
>>>> +            do_banner(opts)
>>>> +            signal_received[signal.SIGHUP] = False
>>>> +        if (line % banner_repeat == 0 and not banner_printed and
>>>> +            not (opts.log_to_file and isinstance(frmt, CSVFormat))):
>>>> +            do_banner(opts)
>>>> +            banner_printed = True
>>>> +        values = stats.get()
>>>> +        if (not opts.skip_zero_records or
>>>> +            any(values[k].delta != 0 for k in keys)):
>>>> +            do_statline(opts, values)
>>>> +            line += 1
>>>> +            banner_printed = False
>>>>   
>>>>       if opts.log_to_file:
>>>>           f.close()
>>>>   
>>>>   
>>>> -def handle_signal(sig, frame):
>>>> -    global signal_received
>>>> -
>>>> -    signal_received = True
>>>> -
>>>> -    return
>>>> -
>>>> -
>>>>   def is_delay_valid(delay):
>>>>       """Verify delay is in valid value range."""
>>>>       msg = None
>>>> @@ -1869,8 +1871,6 @@ def main():
>>>>           sys.exit(0)
>>>>   
>>>>       if options.log or options.log_to_file:
>>>> -        if options.log_to_file:
>>>> -            signal.signal(signal.SIGHUP, handle_signal)
>>>>           keys = sorted(stats.get().keys())
>>>>           if options.csv:
>>>>               frmt = CSVFormat(keys)
>>>> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
>>>> index 3a9f2037bd23..4a99a111a93c 100644
>>>> --- a/tools/kvm/kvm_stat/kvm_stat.txt
>>>> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
>>>> @@ -115,6 +115,18 @@ OPTIONS
>>>>   --skip-zero-records::
>>>>           omit records with all zeros in logging mode
>>>>   
>>>> +
>>>> +SIGNALS
>>>> +-------
>>>> +when kvm_stat is running in logging mode (either with -l or with -L),
>>>> +it handles the following signals:
>>>> +
>>>> +SIGHUP - closes and reopens the log file (-L only), then continues.
>>>> +
>>>> +SIGINT - closes the log file and terminates.
>>>> +SIGTERM - closes the log file and terminates.
>>>> +
>>>> +
>>>>   SEE ALSO
>>>>   --------
>>>>   'perf'(1), 'trace-cmd'(1)
>>>
>>
> 


