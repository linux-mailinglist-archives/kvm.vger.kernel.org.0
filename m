Return-Path: <kvm+bounces-37149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AC34A2633C
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 20:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F345E188587B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E040F1D799D;
	Mon,  3 Feb 2025 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xvzktvkg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19221CAA80
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738609246; cv=none; b=bkOahot3f+5bXkDZxYe3AO7Exs7KfbrRCUxQzu/wl3mXY2DXmhPXhPaEygKuqs4UV7GyWC0oF9rfZXztsMiAxcg+oixrAnx660XqZb6T5NSd+4piVp0wF17X1GBjDLVtD0qQpNirl5NacdHytGej3UvR1/KAAs0h/4nPa912ZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738609246; c=relaxed/simple;
	bh=9cXUO3RIP4TKi4q63Ja7PqV58GXISr92c5Qsiu0+lNQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=pb2tx54C98YT5IA95rjDQis6PMrHAhmEZB5ZS/14IyHSEELPltFB3MWrbcxuyrKd4xiNE7kJ4fnXgXiyoeKwMlhhx4KzMta+Q/Mydg7T8NF3xGO5aMZBlmq4SaT16C7c94fiIskFrmEx/2Ys9zs6rWI5R0YdM7kWE4Dn8x+2FZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xvzktvkg; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21625b4f978so12185ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 11:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738609244; x=1739214044; darn=vger.kernel.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TweO5N8E3NyLdVTYhZfFMYeKnPVXDpgi+/BBc44GEQU=;
        b=xvzktvkgj0QgE+kkJtWVMIndoFZu63r8zHmsjouA5loE9I2ZWgdRWbo/4fdyX1g0DQ
         nU1QxVE5O+2eZuqKwbsHTsg9+slyI3f5n/bi4IpW+LAjwMWxtp3z+WKynSH4nFPI4jCQ
         KRDz9U+UK9t4Wh+AcB9Pdl9QJmdJAhOk8mzSREBgYPYo4hGoTHWzXYii0DmOPI2ue13I
         hXU9Y/jk2y9GuyioUXh2bEl610W2xOm0odneejEe5UzJ/6RLJZCdkSkk+z6v8OLwDyUi
         g5tIXlkRkgDjbYrxeTILEYii6vx460PnVb+b+mcChQk3kKHEOUkeRYTN+cQUosO9H6cz
         HyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738609244; x=1739214044;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TweO5N8E3NyLdVTYhZfFMYeKnPVXDpgi+/BBc44GEQU=;
        b=Gjlb9oEfUYowQxZmmjrIU4Mqz4ChcrU821DoW5as0gvoXvLKMb6vpiVma4fZ0ujTfe
         IvTsZg3v/fHu5WxsV/rAzjdrClrTAtn3v2pJKoxolmVPD2M4dGMte4/MQ8sq+WBD0DDx
         KhJPm7nTZILlhT2iu0Ri5wQJFu4TPGE8ODZgBa5qXXL7E8qVeeUsDHEfNgAWiaVyt2Ga
         RNm7Nw2q44fSh4SxR1qL7RDwWw+LoSjwxcgsEFiTPHfCF4iGylAcc4X28FaE2ow5qE1C
         7KPNs9JJZrk6vjsyBCdXXzQ4UoDzjGRnQWA9ZfXxT8EyJePyNV2BfVDa1cbsQ21pQiz6
         G9og==
X-Forwarded-Encrypted: i=1; AJvYcCX62/i5SQN8S1OI/zYEvIxe1bYJNkO+3zJCQ1nugPU68uEi4eavoVai7oiuxADC5c0TUN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLf5M/2Skh2Im7ek0PSzsudzC3X5cuMYY3TA+2x0FMLmhH5IQ
	mzlobi/Y6wnVjDOu575sfy/Cxj5gXJQswU3mNWoyfrH9QngZMf9b6FOJsdDuNQ==
X-Gm-Gg: ASbGnctDkVugb1NMUv9mCgTMGfeZ4naibUvKHPwEiaQwdJHEUcMzFE+ym5/GQoxCo1i
	7qwoAr1B/mtKD+cCS4Djc0U5iki2RohAFvUykyhIntLTuRvdcwLQcEMBd3dksh0FMTQrqVyl2nl
	79sWMPAaI13NeinjA5pqtS4fWzbsA3S/r9K/w0UjHI61ZQJ2SDspiUY1CNcAL0nXLEhdsJue4qx
	scOPIrapeODBrG/h0naeqfDyr+9VOdYpgoo/D48ko4bBo/EhKgp3cSLZq0kNwZf3nOj0m2bfzLL
	issGE0tIKInPOu3M7NOuIU7/Ptea8Jmg9doLKw24RsSRrSIm+XVTdZSZt16MGvZCmG6/nep8sjK
	RgS2yZk3Myw==
X-Google-Smtp-Source: AGHT+IFAMNePECMAev1wmu5g+raGDqVSZavJZDJNvxySCVo94DpCPUp386nMpFgdi1DuOs+0axBqnQ==
X-Received: by 2002:a17:902:d9ce:b0:216:6dab:8042 with SMTP id d9443c01a7336-21f00398aa0mr165025ad.12.1738609243375;
        Mon, 03 Feb 2025 11:00:43 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:b5a5:2927:5d40:5264] ([2a00:79e0:2eb0:8:b5a5:2927:5d40:5264])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de33205c0sm79978325ad.235.2025.02.03.11.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 11:00:41 -0800 (PST)
Date: Mon, 3 Feb 2025 11:00:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
    Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Peter Xu <peterx@redhat.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, Patrick Bellasi <derkling@google.com>, 
    Brendan Jackman <jackmanb@google.com>, Junaid Shahid <junaids@google.com>, 
    Reiji Watanabe <reijiw@google.com>, Yosry Ahmed <yosryahmed@google.com>
cc: linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [Invitation] Linux MM Alignment Session on ASI on Wednesday
Message-ID: <df59bf1f-3e34-114d-f0e2-1afa07c1aab9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi everybody,

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, February 5 * 9:00 - 10:00am PST (UTC-8)
https://meet.google.com/csb-wcds-xya
backup: (US) +1 347-682-5874 PIN: 356 962 072#
international: https://tel.meet/csb-wcds-xya?pin=1301132214803

This week's topic will be Address Space Isolation (ASI) led by Brendan 
Jackman.  See the latest proposal at 
https://lore.kernel.org/lkml/20250110-asi-rfc-v2-v2-0-8419288bc805@google.com/

Also: if anybody has ideas for future topics, please let me know and I'll
try to organize them.  We'd love to have volunteers to lead future topics
as well as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PST (UTC-8)		9:00am
MST (UTC-7)		10:00am
CST (UTC-6)		11:00am
EST (UTC-5)		12:00pm
Rio de Janeiro (UTC-3)	2:00pm
London (UTC)		5:00pm
Berlin (UTC+1)		6:00pm
Moscow (UTC+3)		8:00pm
Dubai (UTC+4)		9:00pm
Mumbai (UTC+5:30)	10:30pm
Singapore (UTC+8)	1:00am Thursday
Beijing (UTC+8)		1:00am Thursday
Tokyo (UTC+9)		2:00am Thursday
Sydney (UTC+11)		4:00am Thursday
Auckland (UTC+13)	6:00am Thursday

