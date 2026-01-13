Return-Path: <kvm+bounces-67949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFDA7D19F0C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA319308FEAC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F6A39341B;
	Tue, 13 Jan 2026 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbolqtDY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cV0YLU1q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A664393404
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318210; cv=none; b=uitXhKnTCbrtLrQAyd5XqKIkSwlCzi3/PIAlAGAdaA2rI/O0cb91I0xqZGBbHFcM9nYck8Em44JpeaJfEKMAsIp/Bc3TAsF+e9xeEX+fGN2lig1bsxoOoGt9Wv2fuAkZkJ2/SY60Y2bain18TCX6NRokgsB7EIlPWI6qw5oREaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318210; c=relaxed/simple;
	bh=hNuRIypnQQ+01BoUezpIGEppam+IQ5ZOaCciQB2jycA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chBUGG5pPf9KuhufSpL2DuqP09Bf6MNGGb1d4on9KcIuPP+JxTsheWX4WlJu4oMn4xtIaXdKD+a1JI/Y1Opqvr6W+0jJW3L02RGaA8LoxgqLIJK4saLCLUuxsd7heQrOVfHGn32qHmVqoE+Ljud741JWYRjXLv6sQd8uU5HEHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbolqtDY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cV0YLU1q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768318207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qz3VmyYWi3AhF6/Je/tiOgzVdeSqGzdCIhZvINzrSEc=;
	b=gbolqtDYSB+8VlkjrUgFIuPB37oF2iYS0E+vmTvbLLLFg5idyn0v2wdcAXUXRFOzxVwl89
	bTU7PymxIIJfuNWEpwXQ1jQG8Vl4PjftRSdKI3nvuRoIPhKGtLOLS32446acXnyox7b/QB
	wBB8S5jy721tqXwUHQF0ST9UxsJDzxE=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-W29y17cAPueVKIcTypU7wg-1; Tue, 13 Jan 2026 10:30:06 -0500
X-MC-Unique: W29y17cAPueVKIcTypU7wg-1
X-Mimecast-MFC-AGG-ID: W29y17cAPueVKIcTypU7wg_1768318206
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-93f568048ccso10245325241.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 07:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768318206; x=1768923006; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qz3VmyYWi3AhF6/Je/tiOgzVdeSqGzdCIhZvINzrSEc=;
        b=cV0YLU1qMixE8qIUEHxWJwqObPJXipOLRuIxDrYGdIB5lpzCN/VBEkrzONobYBUgfw
         QuLpOEedWinuXlUXK+AyKnLSFQeHns5lzAO7S1+HlNji3+lqIUsHWAHOfex4enb2/2zZ
         uOoCD3pLQE3+oMzpPkegeZsXV5iiw/3eYkXR0L2l1WTKn2g10ZAq7oE6v0Y7d+bOA0Yc
         WlF1JMOoyWY+R3COVwOlJP8uM4rcDZx3Cqlhb4KrIZsosxnQIEqjpc79ytZX/4aNbEcI
         itdUIbp4/WFQGDFu57IiMjfggHSYNaCC49rwoW8T755PyY5vrtib+6uDOpbwD7ISjW4w
         ZVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768318206; x=1768923006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qz3VmyYWi3AhF6/Je/tiOgzVdeSqGzdCIhZvINzrSEc=;
        b=pe3yPqsENnQvktujsYMnIVBRjyIrmb7r52fiZemIJtZhAB6Xp6JjBPLf8abDLWn+45
         4iCjxvuMXVzQPdK2Ym3isGXvVF5J2zwHd1sW/iNpsxXDQGn8NXJ8a1A3ulEtjnIj45f2
         9bJMbRtJk2TL5SwV3ZSt2w74DgsWPJkVLslcKqdl43ScrzIa1lfajPLSXr2bJVwFNZdZ
         pEDDBv39aZvqzEXKeW+Hte7TPfOPcTyzYu2mk1EKqnqDRG6UiJuC1lGm0PHdDINUPCNG
         azh4PXt6nn8RqM8+0cohoLecHyAS9LhikM8aybQtMv0YuTt4pPrOT4lVyb/nzqOnaTVE
         B8IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsvPRDxcW0dRULViEVd7WdkhMED0SEVlYKZ7iVjjqIW6LS4SuYym8JE6KqlEW8n95jl+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgQJvKp5YqZ1LHm5nXoOhF8EbmuT6APyL0ixsoNHdkc6uqudPD
	qTUSBQFSwt/69xdCGc/v7xhbn1FX0eNKEuYNzWNntjV+8TeqcktabUCQy9/taFCkoQGgGoVJzM6
	mUQKIpy1+ajTLhO92dWsXl6dkjCV6IkMIj6VysmdzCIVHZ4FNnut79w==
X-Gm-Gg: AY/fxX4YSQIucxpndoezfKGFMM2tVvcRU0xZoNpMFSFL3dudXvX+0yedoOtttDhZvUm
	qyTsbn5VO6cClmCWWaqpX6DMKyanQCKPACC7t4e4Mq5Hf86MM6R3dvHB3oS9uifTqfW6Ol6fH3n
	zl+YXFa7uPf8+OyxVMFpv0WPYXqIS2wu4I/NqzJq7rsp2Cr38HibobrRn/Ml4EhGSUg6lcVK7oF
	xTuEuRMkN3+lffExBlbPwNuGJZzez4xzidUvUZm7y3xEmqZjK8BYHn1OkokL36L6c6O4It8ImLa
	Ii0klqoEwlip+ttCwHIlzHZXWe7oiuTpR9NjWeBwDSTHYe5yuSTCchUKdNfUgDJYpk6/ik/BSJK
	qel0=
X-Received: by 2002:a05:6102:2ac3:b0:5ef:7220:bca6 with SMTP id ada2fe7eead31-5ef7220c52dmr5778864137.33.1768318204249;
        Tue, 13 Jan 2026 07:30:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGb21i8wbXldhw9xlGcMduETSeDqTwoLzXJxR0H8CmAOHE8xGD0URpboYFAQJNeOmYUoC8R0A==
X-Received: by 2002:a05:6102:2ac3:b0:5ef:7220:bca6 with SMTP id ada2fe7eead31-5ef7220c52dmr5778814137.33.1768318202381;
        Tue, 13 Jan 2026 07:30:02 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5ecdaf1bab4sm20087598137.2.2026.01.13.07.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 07:30:01 -0800 (PST)
Date: Tue, 13 Jan 2026 10:29:50 -0500
From: Peter Xu <peterx@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Marco Cavenati <Marco.Cavenati@eurecom.fr>,
	Fabiano Rosas <farosas@suse.de>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aWZk7udMufaXPw-E@x1.local>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>

On Mon, Jan 05, 2026 at 04:47:22PM -0500, Stefan Hajnoczi wrote:
> Dear QEMU and KVM communities,
> QEMU will apply for the Google Summer of Code internship
> program again this year. Regular contributors can submit project
> ideas that they'd like to mentor by replying to this email by
> January 30th.

There's one idea from migration side that should be self-contained, please
evaluate if this suites for the application.

I copied Marco who might be interested on such project too at least from an
user perspective on fuzzing [1].

[1] https://lore.kernel.org/all/193e5a-681dfa80-3af-701c0f80@227192887/

Thanks,

=== Fast Snapshot Load ===

'''Summary:''' Fast loadvm process based on postcopy approach

We have two common ways to load snapshots: (1) QMP "snapshot-load", or QMP
"migrate_incoming" with a "file:" URI. The idea to be discussed here should
apply to either form of loadvm, however here we will focus on "file:"
migration only, because it should be the modern and suggested way of using
snapshots nowadays.

Load snapshot currently requires all VM data (RAM states and the rest
device states) to be loaded into the QEMU instance before VM starts.

It is not required, though, to load guest memory to start the VM. For
example, in a postcopy live migration process, QEMU uses userfaultfd to
allow VM run without all of the guest memory migrated. A similar technique
can also be used in a loadvm process to make loadvm very fast, starting the
VM almost immediately right after the loadvm command.

The idea is simple: we can start the VM right after loading device states
(but without loading the guest memory), then QEMU can start the VM. In the
background, the loadvm process should keep loading all the VM data in an
atomically way. Meanwhile, the vCPUs may from time to time access a missing
guest page. QEMU needs to trap these accesses with userfaultfd, and resolve
the page faults.

After loading all the RAM state, the whole loadvm procedure is completed.

This feature needs to depend on mapped-ram feature, which allows offsetting
into the snapshots to find whatever page being asked by the guest vCPUs at
any point in time.

This feature may not be very help in VM suspend / resume use cases, because
in those cases the VM was down previously, normally it's fine waiting for
the VM to be fully loaded. However, it might be useful in some other cases
(like, frequently loading snapshots).

'''Links:'''
* https://wiki.qemu.org/ToDo/LiveMigration#Fast_load_snapshot

'''Details:'''
* Skill level: advanced
* Language: C
* Mentor: Peter Xu <peterx@redhat.com>, peterx (on #qemu IRC)

-- 
Peter Xu


