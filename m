Return-Path: <kvm+bounces-32569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD659DABD4
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DBB72810A0
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA591FF61F;
	Wed, 27 Nov 2024 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OmHTS6kZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pG7tCZNt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OmHTS6kZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pG7tCZNt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4528370
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725024; cv=none; b=l+8sm+w8lcBbmYXFVikC3L8e+5SpYy0wGDlOeg3qSre5WoLDgITYvlFOSCSgP83VP4Gp4uYc3JStlF23ttyKzqCRlj9uymoSjdmfOxo0GMGnPk7f/GFyaOsup/ZhW+v4RRZyMx4URgs8Y2p74rRCFbW+h60oajxzr+HDEdWuDfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725024; c=relaxed/simple;
	bh=FcwkYtLRMYBRrFcxCgWo0YgegLGHfGEsFW7K/VBUQ1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5eMK9yQZj5or7SVXrE158pUTwN0cnEH7syf0gUt0B6XzAn7yCWNHwL7t0Lv5EFRQiQaIYnPa3ENtW6OvxbAtrDK19cASVcsWa6R5NnoMEpT5P+YflKeO6gdHnL8ximI4+cKtczF5kqGtoDL214Z/hEz9bTdgu39j5cBu9jLeBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OmHTS6kZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pG7tCZNt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OmHTS6kZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pG7tCZNt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 53D1F21180;
	Wed, 27 Nov 2024 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732725020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR/CEsKT6+KX3t/laZSyu5DCHcUSKv+4bmcdhnY+aXU=;
	b=OmHTS6kZ6yFjvjqdJE7HhH/26/LXjSk+FgCDPYGz5l2t7/exjUTUQtZs4U++Zzxtj74Fxg
	X3hZtFuUs6mCQBehtPjafETQbfPe/WkiCSY6rE8Vonp4QCyZirAmcVaAIR/Kwj3djSpoqV
	fStRxuUUPynaH519qcbSpaCgMcyXdhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732725020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR/CEsKT6+KX3t/laZSyu5DCHcUSKv+4bmcdhnY+aXU=;
	b=pG7tCZNt9TG74kRObJj1yc6bOtX1GnQM3Gc36S4HH6wTboCCK8SJ2f6WyULjmkNYiYlZS0
	yQxJ4+ozvEYqWuAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OmHTS6kZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pG7tCZNt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732725020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR/CEsKT6+KX3t/laZSyu5DCHcUSKv+4bmcdhnY+aXU=;
	b=OmHTS6kZ6yFjvjqdJE7HhH/26/LXjSk+FgCDPYGz5l2t7/exjUTUQtZs4U++Zzxtj74Fxg
	X3hZtFuUs6mCQBehtPjafETQbfPe/WkiCSY6rE8Vonp4QCyZirAmcVaAIR/Kwj3djSpoqV
	fStRxuUUPynaH519qcbSpaCgMcyXdhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732725020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR/CEsKT6+KX3t/laZSyu5DCHcUSKv+4bmcdhnY+aXU=;
	b=pG7tCZNt9TG74kRObJj1yc6bOtX1GnQM3Gc36S4HH6wTboCCK8SJ2f6WyULjmkNYiYlZS0
	yQxJ4+ozvEYqWuAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7BBD139AA;
	Wed, 27 Nov 2024 16:30:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yX63NRtJR2fbQAAAD6G6ig
	(envelope-from <cfontana@suse.de>); Wed, 27 Nov 2024 16:30:19 +0000
Message-ID: <634dd49d-94cb-4892-856d-15e83c44c805@suse.de>
Date: Wed, 27 Nov 2024 17:30:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
To: Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
 Dario Faggioli <dfaggioli@suse.com>, Fabiano Rosas <farosas@suse.de>
References: <20240807172334.1006-1-cfontana@suse.de>
 <e6461e14-ca65-4322-a818-88b66b58c5c1@suse.com>
Content-Language: en-US
From: Claudio Fontana <cfontana@suse.de>
In-Reply-To: <e6461e14-ca65-4322-a818-88b66b58c5c1@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 53D1F21180
X-Spam-Score: -1.83
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.83 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	BAYES_HAM(-0.32)[75.62%];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi, according to MAINTAINERS file:

M:  Paolo Bonzini <pbonzini@redhat.com>
L:  kvm@vger.kernel.org
F:  tools/kvm/

Paolo, is kvm_stat something you still care about, or should it be set to unmaintained?
In this case I think someone at SUSE could pick it up.

Ciao,

Claudio


On 10/21/24 15:26, Juergen Gross wrote:
> Any reason not to commit this patch? It has got a Reviewed-by: tag from
> Stefan more than 2 months ago...
> 
> On 07.08.24 19:23, Claudio Fontana wrote:
>> For the -l and -L options (logging mode), replace the use of the
>> KeyboardInterrupt exception to gracefully terminate in favor
>> of handling the SIGINT and SIGTERM signals.
>>
>> This allows the program to be run from scripts and still be
>> signaled to gracefully terminate without an interactive terminal.
>>
>> Before this change, something like this script:
>>
>> kvm_stat -p 85896 -d -t -s 1 -c -L kvm_stat_85896.csv &
>> sleep 10
>> pkill -TERM -P $$
>>
>> would yield an empty log:
>> -rw-r--r-- 1 root root     0 Aug  7 16:17 kvm_stat_85896.csv
>>
>> after this commit:
>> -rw-r--r-- 1 root root 13466 Aug  7 16:57 kvm_stat_85896.csv
>>
>> Signed-off-by: Claudio Fontana <cfontana@suse.de>
>> Cc: Dario Faggioli <dfaggioli@suse.com>
>> Cc: Fabiano Rosas <farosas@suse.de>
>> ---
>>   tools/kvm/kvm_stat/kvm_stat     | 64 ++++++++++++++++-----------------
>>   tools/kvm/kvm_stat/kvm_stat.txt | 12 +++++++
>>   2 files changed, 44 insertions(+), 32 deletions(-)
>>
>> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
>> index 15bf00e79e3f..2cf2da3ed002 100755
>> --- a/tools/kvm/kvm_stat/kvm_stat
>> +++ b/tools/kvm/kvm_stat/kvm_stat
>> @@ -297,8 +297,6 @@ IOCTL_NUMBERS = {
>>       'RESET':       0x00002403,
>>   }
>>   
>> -signal_received = False
>> -
>>   ENCODING = locale.getpreferredencoding(False)
>>   TRACE_FILTER = re.compile(r'^[^\(]*$')
>>   
>> @@ -1598,7 +1596,19 @@ class CSVFormat(object):
>>   
>>   def log(stats, opts, frmt, keys):
>>       """Prints statistics as reiterating key block, multiple value blocks."""
>> -    global signal_received
>> +    signal_received = defaultdict(bool)
>> +
>> +    def handle_signal(sig, frame):
>> +        nonlocal signal_received
>> +        signal_received[sig] = True
>> +        return
>> +
>> +
>> +    signal.signal(signal.SIGINT, handle_signal)
>> +    signal.signal(signal.SIGTERM, handle_signal)
>> +    if opts.log_to_file:
>> +        signal.signal(signal.SIGHUP, handle_signal)
>> +
>>       line = 0
>>       banner_repeat = 20
>>       f = None
>> @@ -1624,39 +1634,31 @@ def log(stats, opts, frmt, keys):
>>       do_banner(opts)
>>       banner_printed = True
>>       while True:
>> -        try:
>> -            time.sleep(opts.set_delay)
>> -            if signal_received:
>> -                banner_printed = True
>> -                line = 0
>> -                f.close()
>> -                do_banner(opts)
>> -                signal_received = False
>> -            if (line % banner_repeat == 0 and not banner_printed and
>> -                not (opts.log_to_file and isinstance(frmt, CSVFormat))):
>> -                do_banner(opts)
>> -                banner_printed = True
>> -            values = stats.get()
>> -            if (not opts.skip_zero_records or
>> -                any(values[k].delta != 0 for k in keys)):
>> -                do_statline(opts, values)
>> -                line += 1
>> -                banner_printed = False
>> -        except KeyboardInterrupt:
>> +        time.sleep(opts.set_delay)
>> +        # Do not use the KeyboardInterrupt exception, because we may be running without a terminal
>> +        if (signal_received[signal.SIGINT] or signal_received[signal.SIGTERM]):
>>               break
>> +        if signal_received[signal.SIGHUP]:
>> +            banner_printed = True
>> +            line = 0
>> +            f.close()
>> +            do_banner(opts)
>> +            signal_received[signal.SIGHUP] = False
>> +        if (line % banner_repeat == 0 and not banner_printed and
>> +            not (opts.log_to_file and isinstance(frmt, CSVFormat))):
>> +            do_banner(opts)
>> +            banner_printed = True
>> +        values = stats.get()
>> +        if (not opts.skip_zero_records or
>> +            any(values[k].delta != 0 for k in keys)):
>> +            do_statline(opts, values)
>> +            line += 1
>> +            banner_printed = False
>>   
>>       if opts.log_to_file:
>>           f.close()
>>   
>>   
>> -def handle_signal(sig, frame):
>> -    global signal_received
>> -
>> -    signal_received = True
>> -
>> -    return
>> -
>> -
>>   def is_delay_valid(delay):
>>       """Verify delay is in valid value range."""
>>       msg = None
>> @@ -1869,8 +1871,6 @@ def main():
>>           sys.exit(0)
>>   
>>       if options.log or options.log_to_file:
>> -        if options.log_to_file:
>> -            signal.signal(signal.SIGHUP, handle_signal)
>>           keys = sorted(stats.get().keys())
>>           if options.csv:
>>               frmt = CSVFormat(keys)
>> diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
>> index 3a9f2037bd23..4a99a111a93c 100644
>> --- a/tools/kvm/kvm_stat/kvm_stat.txt
>> +++ b/tools/kvm/kvm_stat/kvm_stat.txt
>> @@ -115,6 +115,18 @@ OPTIONS
>>   --skip-zero-records::
>>           omit records with all zeros in logging mode
>>   
>> +
>> +SIGNALS
>> +-------
>> +when kvm_stat is running in logging mode (either with -l or with -L),
>> +it handles the following signals:
>> +
>> +SIGHUP - closes and reopens the log file (-L only), then continues.
>> +
>> +SIGINT - closes the log file and terminates.
>> +SIGTERM - closes the log file and terminates.
>> +
>> +
>>   SEE ALSO
>>   --------
>>   'perf'(1), 'trace-cmd'(1)
> 


