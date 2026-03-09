Return-Path: <kvm+bounces-73303-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPw3N7jXrmlhJAIAu9opvQ
	(envelope-from <kvm+bounces-73303-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:22:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C8B23A748
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B54263164B64
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9D53D3307;
	Mon,  9 Mar 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="syI7mnKv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA53BE153
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773065878; cv=none; b=Cw5LSl2S8/HWZSR4QvcbjA7tdZoozZ2TU/w4rcR2W20tGo4CooHmJJJ1vMbzJ/zgW5TpOXdibLyyu1kZlBBWg55kvpnI7xxS1+I9qDeP/akOkvS/UETPQLA6Zru0W4rPK77V6gfaZyUtMCPBsbvP/nfMLMW5cyYLwllzGizyi6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773065878; c=relaxed/simple;
	bh=JP00T/68OJ4fw7VmMlRaHDEELtwQraenjhzJKPVQkgo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ClxJqPdAst7ESubUGsjTfc/UDuL5DbqaMXkdBaB1U1KBZwOcA3b4Bxxa9z+T2k5LlM0n8invkbQMmrx2nsHC0C4iMEZmkulthQkFy/kedlc07TymeRJgx2+Au60K9ypmdx1rfTJ7R7meqbAobKcT4MZV/w14EnzDrsNnVUc1gTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=syI7mnKv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3597b55adebso5927804a91.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 07:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773065876; x=1773670676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PIXhTxwjRpwa5TAse999ohZvv684PvyRrjqn0wkysxg=;
        b=syI7mnKvmm9TMan062RW2Eoblm7KU0IBKbxptcfIWh9y0fZ9u+xdKIAlbw++cP3kNL
         PU45WQKwrzRdsD38YCMRTssTPiEvJxGR07ZR+xgmnHSgBro7yQgsGofam6TAdgQlqm34
         YaSu0lVdyDXVJvl7HJEbm1zYQXDjlo4B7TvEHbl4zDwt63UwxuO+lQE132FsYK+zKA6J
         zvdWb41SJ9BmVbnVUk3s55+NhcHA34teau+viv7N4S7lTLM+KyvBeFZB5WbjNe0PiEkQ
         /mAUDDUXgRqs7/ewmXFGTqFSrVpu7JhXU+rSvKDMh3m4sN3wv2jNQ3kIdzmSiryGwQwO
         FbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773065876; x=1773670676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIXhTxwjRpwa5TAse999ohZvv684PvyRrjqn0wkysxg=;
        b=pausz2IFx23VdfLmzsDl6WwQUTUoPkrkcyYlglL0qzABYvrFHrEHNyql9u3ZnsYxdb
         5ojXYZg1h76EGUiOUrbqztfNSHHwXga/TTx+VfPH7VODGq6uiXzqyS558OmouzLdeoM5
         4sK/gIuZ0B1m7q2j34t7HqBPf1QhbyANuZUXR2qBsWqm2QIKaDjX7LRWlEqTJEggjorF
         t3vGvC3lgC8wIvCE/pyYJRi31hsirxRqs9IM4B6JxcO/Gf77KiiAKk7OIva+VFRQme3x
         jh1pREXuwslV+43aGJ/3npSeatPcv3VwZ90vvQJZxiAgv81Ufu1QDQoNotKfj68W6Jzn
         4XGA==
X-Gm-Message-State: AOJu0Yx9M/uiLPA+Z1B7HDYLt+NKPwAq4gmAd1bpo2PPCb0CBW9+Xnb3
	2hsHsL+Iid6HuLKCp/u6UmwErvkdLCVxtH6mtoz8DV1bpIIaT/bd3/llvurdAuL7ShQcesCapQi
	0iMljVA==
X-Received: from pgww1.prod.google.com ([2002:a05:6a02:2c81:b0:c51:8b09:2a32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939f:b0:398:7c6b:889e
 with SMTP id adf61e73a8af0-3987c6b90ccmr6465889637.52.1773065875983; Mon, 09
 Mar 2026 07:17:55 -0700 (PDT)
Date: Mon, 9 Mar 2026 07:17:48 -0700
In-Reply-To: <cover.1749672978.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1749672978.git.afranji@google.com>
Message-ID: <aa7WjPHTUDCgsO-U@google.com>
Subject: Re: [RFC PATCH v2 00/10] Add TDX intra-host migration support
From: Sean Christopherson <seanjc@google.com>
To: Ryan Afranji <afranji@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	sagis@google.com, bp@alien8.de, chao.p.peng@linux.intel.com, 
	dave.hansen@linux.intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, tglx@linutronix.de, zhi.wang.linux@gmail.com, 
	ackerleytng@google.com, andrew.jones@linux.dev, david@redhat.com, 
	hpa@zytor.com, kirill.shutemov@linux.intel.com, 
	linux-kselftest@vger.kernel.org, tabba@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 41C8B23A748
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73303-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,google.com,alien8.de,linux.intel.com,intel.com,redhat.com,linutronix.de,gmail.com,linux.dev,zytor.com];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.988];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Jun 11, 2025, Ryan Afranji wrote:
> Hello,
> 
> This is RFC v2 for the TDX intra-host migration patch series. It
> addresses comments in RFC v1 [1] and is rebased onto the latest kvm/next
> (v6.16-rc1).
> 
> This patchset was built on top of the latest TDX selftests [2] and gmem
> linking [3] RFC patch series.

In case someone is feeling necromantic, don't bother reviewing this series.  I've
provided a pile of feedback off-list (I forgot this on-list RFC existed), and the
next version should be have significant changes.

