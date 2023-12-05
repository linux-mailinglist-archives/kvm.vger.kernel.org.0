Return-Path: <kvm+bounces-3449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A39580485C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 05:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F131C20D4B
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 04:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C5FCA4C;
	Tue,  5 Dec 2023 04:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cI9NHSlZ"
X-Original-To: kvm@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B478EC6
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 20:01:34 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-111-98.bstnma.fios.verizon.net [173.48.111.98])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3B541QQg005624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 Dec 2023 23:01:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1701748888; bh=iMt6plIOdydoTjRUmeuSfjGpniL3yUwo2Kv3zO9lBqU=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cI9NHSlZxtu7EhzJVbO/rLOm6G+OYSj6FJD/S0zeHe4QSb1VfXx9nudPtv+xKxla3
	 UvrN/V8Czn3WOCdLuxG8SlVFODPln3FspDTpwx4h6SbVhX/XQJn7KQagRXdCyO9lPf
	 8pc+I+cqWxQV79MO1+JFt0buw5/3Jcf5mRoZTNIkTIJlJNRQZn2+dPt0KRxvxvqnKT
	 BQV/Eh2MgJ441OBCfGvQPRW0R4IeYj3vNDCi4zetzoTe5Q8kyfKY0vEMyhWJ8XxuXK
	 pm+IIFNk0Irb9dLc2orgGAINsadwKm9/FeTS790cV4maUxkVesTMo8uDMb51aguxfj
	 wH9rp7jPgd0vw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 24DA915C02E0; Mon,  4 Dec 2023 23:01:26 -0500 (EST)
Date: Mon, 4 Dec 2023 23:01:26 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: Converting manpages from asciidoc to rst2man ?
Message-ID: <20231205040126.GF509422@mit.edu>
References: <CADWks+Z=kLTohq_3pk_PdXs54B6tLn25u6avn_Q1FyXN2-sVDQ@mail.gmail.com>
 <87fs0iujaj.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs0iujaj.fsf@meer.lwn.net>

On Mon, Dec 04, 2023 at 07:36:04AM -0700, Jonathan Corbet wrote:
> 
> In general we don't have a lot of man pages in the kernel, so it's not
> something we've put a lot of thought into.  Ideally, I suppose, it would
> be nice to get all of those man pages integrated into the RST docs
> build, but it's not something that is likely to inspire any great sense
> of urgency.

These manpages (at least the perf ones) are actually translated into
nroff/troff's -man macro format using asciidoctor so that things like
"man perf": For example, from Debian testing's "linux-perf" package:

% gunzip < /usr/share/man/man1/perf.1.gz | head
'\" t
.\"     Title: perf
.\"    Author: [see the "AUTHOR(S)" section]
.\" Generator: Asciidoctor 2.0.20
.\"      Date: 2023-11-03
.\"    Manual: perf Manual
.\"    Source: perf
.\"  Language: English
.\"
.TH "PERF" "1" "2023-11-03" "perf" "perf Manual"

% dpkg -S /usr/share/man/man1/perf.1.gz
diversion by linux-perf from: /usr/share/man/man1/perf.1.gz
diversion by linux-perf to: /usr/share/man/man1/perf.wrapper.1.gz
linux-perf: /usr/share/man/man1/perf.1.gz

I guess we could try to use rst2man to do the same thing, but it's a
lot more than just "make it look nice" when rendered into HTML and pdf
when processfing the .rst file.  We need to make sure that after the
rst file is turned into a -man text file, that it looks good when
postsprocess via "groff -man -T utf8" *and* "groff -man -T pdf".

It would also mean that python3-docutils would have to be installed
when building kernel docs (to provide the rst2man command), but then
again, it would remove the need to have asciidoctor installed....

Cheers,

					- Ted

