Return-Path: <kvm+bounces-71251-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFgGD1DglWneVgIAu9opvQ
	(envelope-from <kvm+bounces-71251-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:52:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 732CF157821
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 739CD3009E25
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 15:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B76343D77;
	Wed, 18 Feb 2026 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJYreQvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364B1342CA5
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771429955; cv=pass; b=XeGZJNDou606V/K2UOlvsJ9qOoqJeRmxuChy2hA2J9KUSqq3LMhI951Bgjev7CZuUm+N5WVeOhEKj3o6c0O3ZGjcNbvIK8LmZzb4uUpNCP35CeWZf7O8amnPeFhTcSAPZ23n5yFALMQQ/zBVHM3bPmc8QfV1pRBJdf4MGniYrMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771429955; c=relaxed/simple;
	bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsehNRozU5ISFZImVvXfhWH8FKWlfvTxjoMaBlkOvg6DFScwEEWaG7MkJlyx2H2uPqkmF7/sz3aKZLSR4M7s1WOTbZDgIjJkNBDT3yt74dWcD5z946zp6zkxkxU/MAtSx3TWRkN1gUSvpz9zKAlDY4J9zB2AkHA+wAPJ47cynp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJYreQvG; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a355aedfso579101cf.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 07:52:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771429953; cv=none;
        d=google.com; s=arc-20240605;
        b=kEfmLzfXsALqAqYsDm1drw1deazKdsTTrJQLQM/6+ECItRT7ZlKwpLu343UGtfa799
         65ipDx3PMd44pMBkNebDWIBeW5PP1zpA0HN0KuM1Lt/KImKB5DbOJVCHdFqLyWqASWd/
         vnQB2hD3YerdLGl5LeMT5fmrbD7gUyT0mhaTulsXhkLgSbUV4KNJbCEEMy50twjU9W4h
         8RLi3nWqSAtVkBFBx3En6vf7KQh3uGdRt1NzVytJTnEjaZm/h1a3hlnLO/XQ8o+8wNxL
         4tB6gRgzawmRnlNf9rtLu5Ox9THHlC0xBJ9CeEgjVNQCVs/BqJagvzFB7i/GTed1sgBh
         Bacw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        fh=Id3rY82sOiSnbvn96+6yylhNu+SNuS/GD/03itzH/98=;
        b=Ti5HjaAVO6UxhUvixp+Cn+A2Ce6+XJ0mdD4BGTuTZTiCTziTuomE3W0p6saAAxzQ3p
         r1euE2BcRdjpwAiqEUDPjM5ujavNyAVICcb6MK8BOawrYDRQTkBgu3WgL+6tKCZBdtZg
         iT3y1TtC6MYmUkCpWlA+ZNuAFWDiztvqfGJXI9mpZTLLjkiFMoMFsPtcJ+3WML7cnL/6
         nKxmNzZ/DWSBBSVLQtKhZxRTeXQurn6EsUEFjvk+6mRTHzx/B3y8JDt6m3xO36OPHM4f
         oR1iATOzIOCv9Gzyohs2HkKa/kHLAGm9tjYUzj54vn19GsTKPQsvhT+MxS5CE9hAHauQ
         52LA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771429953; x=1772034753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        b=pJYreQvGc11f+23nG817BPXzvEIbCxPXmlHrQL+Q7iDJSZrmuD1EQr54Bf7/eNFHIV
         TCFdDo+YKkVlb6FIEixx91j/yNWCu8upI3ZPUnyeg9xOyoL0rqnK5KuLOzvtZTVI9aFj
         /HUCl0r08w9OFhSX1dtMMziMtrsD9z8BP6/JeWaRzDtL/ibJphnofQWY1s6f1WQhBqum
         xxhkWczX4jl+DcXoAefa+x+M53tsbjlVdOJFPukRtZcgwWivhTcc4KqfhwuNsG4sTXDW
         8+y6rmrGia0dypTOhfDEx1OAvAqqWlNKJuX59cx5FjHHwQcKpQu74nVTwtCh/dJIXhkn
         fx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771429953; x=1772034753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K/8JkWJqRGjG1Au+HIiW6y70F8UXIF6b3iEb+LfAizM=;
        b=YbelM4pvXcIg4W4dNyfcrXfE4avAZblGtYTzJtdA+ihqt+wCa5quevfgdCcP/6oJ0j
         qdqxTzMUSg1iiV28o02sgFN8iJZ3dwg3trDX3X3rjxmPPjiJoBTUVcJ9vbqWSwZjZZ4i
         JQgJSu+iQc9zpvIOLl1XqR9tbw+YA+ZBYWE+fBvN0fvtwpkDtB6uYp3YcGsk8lUkDbzE
         W2czoGttz8B5YXIZZ9lv9TNUvYC0Db9E1kQ0YoiydHBYgY9jT5OC492/HJo1cqxe5V3g
         45+Lx2oVcIVFKJ0IuvaYbdfUYv2kf8PdrQW5h3hwyI7X3jsE89vx+L/T+ni9UH2+WKsP
         wNag==
X-Forwarded-Encrypted: i=1; AJvYcCXNPF1mjlqjQkCl0ZAcC+Dz5MbDZSgcTtaeDG5eAiixv36Xvfnn+jh+sDJ+8guI6olAxwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVzb7jMwH+eCSWpUX3SqHIxSFIXXPzzJ0esPeI+bRONvGWYoPP
	VGk0GVTaGUIirB5fB+hbpD+1TGPp3dzgeYEAfBrGwcmy3dv+p+OcDdJ8v8CRTD6+XkV3XA9mP++
	Fv/a/aFHkgRDsicNJrPsfXmP0sR5lzo69g38Aoix6
X-Gm-Gg: AZuq6aLTKd9mO59AF3U2NiEykaj03Y7oo75IHT2KG1Cu0g2CQAc3wvsEG+sYU+mtygB
	oLLMGspd2HGYz7JlqdqeY3IBw5opnH96m2sD9dSZvhNqALWDGPJk+ghuxdy5bmzpojbHkrhDviR
	nit6AFTpgS7wbURTo1nlw16ZZc/rmU9DlGr7qYD9gmwUUn85E9cyqFjOtxxzo5IGLaFqdxWwqQw
	2KYJHulvaDfoT5YD6qdDc12dWlIwoV/sDZWWZv2qjio0Fj5WlqIrHJ0mGsNouOZjZYW1ZU7GJOA
	VaZidkGE3g08HRiS06onzqDXN6o/HwIjRNw=
X-Received: by 2002:ac8:5848:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-506eac6b96dmr6584461cf.8.1771429952470; Wed, 18 Feb 2026
 07:52:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com> <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
 <aZW5i4cqU1qUy3aa@casper.infradead.org>
In-Reply-To: <aZW5i4cqU1qUy3aa@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Feb 2026 15:52:20 +0000
X-Gm-Features: AaiRm53m6s_G40CJP3vmJv4jXAYSm18GE46B6GFp27WgSQ5QeI3l-eaZ79M4lt4
Message-ID: <CAJuCfpH6c9q=W9ynrjV+UEpsoBpdoAw7ADchW2Wvnx+WYkaN6Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Matthew Wilcox <willy@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71251-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[42];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[linux.ibm.com,linux-foundation.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 732CF157821
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 1:07=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> > Hmm. My patchset is based on mm-new. I guess the code was modified in
> > some other tree. Could you please provide a link to that patchset so I
> > can track it? I'll probably remove this patch from my set until that
> > one is merged.
>
> mm-new is a bad place to be playing; better to base off mm-unstable.

Ah, I see. I'll redo my patchset on top of that then. Thanks for the tip!

