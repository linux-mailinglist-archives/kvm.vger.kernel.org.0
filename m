Return-Path: <kvm+bounces-71277-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WP9RAY0wlmktcAIAu9opvQ
	(envelope-from <kvm+bounces-71277-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:35:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7EF15A2AE
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 49143300A59C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F112F1FF1;
	Wed, 18 Feb 2026 21:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmM8Sl+1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQH1vMmO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4812D94BB
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450494; cv=none; b=NQV2UBKa1Ne9+ivMJGWwVoaGCM4w2Tg3CGADJDuBwecNCmolm3TbkOw64w2Cvi2KBzz1+pNJlwDkY/MvxJzOr/M9XJ7ENE4afOHME8zgFEjW9fJwxsObyTV37qzO6q/2ZWCLSISRSPKHROZvThdnPRKeTXwXsTbU6gIwb2EIgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450494; c=relaxed/simple;
	bh=d4J2Wwfy4bpwp/Wyy0MXG87xaedJ9FKZnZIYp3QGksk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlBgnDvZxu5Y51IYiKLEB0rU+mVrqCXhgido2l+w8nnxTuGOCh8nnJ7icnHbcAWxLty8qaqd1i/5rHCSbhvzyg42cxGsjbkjxFPWmwLi4U5CHs4DNrslKw9n5oQyL/sj+TNy3ELhUeuEPdTatjwcbNY1WQ8i9OC4BiL5ke6Aogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SmM8Sl+1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQH1vMmO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771450492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
	b=SmM8Sl+14Wdjxgu3mAmGm21IIQvAyEy/imsgePRxyNrM0BbVfk9ZQxlaxlO/BxaEgrNVAi
	LGFW0RlUvSk43Lo+yACKGL98YqyUZVDqv5W8q6iwid05yeAaOOTWe7RdSDzPOG7ymvHcuY
	oUnOf4QoLSzOEy6VVefkeUaqnSooaxY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-E0uM_UyCPNmWs0Q_kHAI2A-1; Wed, 18 Feb 2026 16:34:49 -0500
X-MC-Unique: E0uM_UyCPNmWs0Q_kHAI2A-1
X-Mimecast-MFC-AGG-ID: E0uM_UyCPNmWs0Q_kHAI2A_1771450489
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cb3d11b913so158868485a.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 13:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771450489; x=1772055289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
        b=fQH1vMmOuW628h3FmpNScVNoEADTuMRtRsIqM7M8138UwfBHQ7a3ixvuIF4TLFiCiJ
         2S4RQv7o3XG4OMm6JaCDDn/btPK55b9StfHxiEByI+8msCMAobLZXL86ix9qihDWfO+x
         MJ2wbAoXxYbOC/TOhGqE82f90lte1FYP7nxuoZ0ypG0IJ68KgzG6DbzSYXmXXXYgKzh4
         Y+AaKJIGM1r129i47KCWGyzu9qD3PCGPenAwbYKZoAHNhOcK0UF0Fg6by4y+Crm2fIgJ
         883VWurq5tT4wkTvJwayrexZZum+LqMTp07BKuYuKfaBe6HZUGM0mVRopqdX/qtQvfd1
         es0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771450489; x=1772055289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD658ZwKuP2PF9xMpkydfrRh56szUrbMAmGplK3iBZk=;
        b=cHfRRuh/Vx4pwetgZGYiVVoIx7C3oRWUca8yb8LdgIxbdPiYx231azyCvw8SJ8flP9
         cROSK8k84XtQrLYzXxqPmEIDW8fTYCWd5VC6MXpkh+qIbPaHhCOPX690ElBmBQq/IXMp
         ZLZX9rb/QeSN09zYmGCEjpJMFhxxCpOUSNfSRTSOzbsgyyKG1Ki4pRoy2+PJOc+a8l0w
         cTuy3jhFpf/b/HFisG/X/gLi9GXsGrEuirK9iS1HZ0T+nnCnbzjGWEc6mWtN/ZuOKsGn
         u8cuyHIw58HUueV8fg9x8kmhldKn7PzSN6iQspxreaP7LoekrJ0BzEI+S0ayBNRN9mLK
         hO9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEBxYfsCo7l2jZmSrfUEC49qp+0SXGH9EsVrfh2Ouk9HPi3RI6SSLTJSZy0FiJJvz+Zrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSH6adeBRNAKbIcC5c3QXwJSDervw339YAbenXfbmoGvFxjfLl
	VxP04IUzSdfKhlsRMAZetTlssx1hJ5hgnPd+iE63iYKIqtqQ2+pGcrmf8GwiQLiQVBsILJBxmWR
	yvpBh018r1g9pA5TbvxDkeyQnZxqfP/FVKk7pFBUCLULKvx2+vaXm5Q==
X-Gm-Gg: AZuq6aKEb+agyAzdYFyTA1Ht2Wa9NixZh8ZNo/Qc6Yno8rfuueWZ6POqbUDE/j9yQnY
	ScprmkqC/d8o9StlVtKvAW2wH1SrTqbhHX1co9eoU8BTjUExLdoEedPizA/BZ2x7652x5iB/LKw
	p+aDNTqu1nR4u8wTxaaPXMM/H6DCX21TVKQb5iUZk6qAbSIn96aiVUFgWFBA/ShFevX3RnAENED
	9nZWiH6xlsQBhmkVy0xSvNfY4VH1229HddY+LEosj4b+gS9yKSlOg7hlEDKMF3bCKFB58MiYYoC
	rgiMFO0Zu82m1Xf6RRm9kQ5LVRSELgo4475qyCGIZuEA6lb/3koKI07HkON+AsmGHgmKdWrcMmU
	kYF9mRUSdx+le9A==
X-Received: by 2002:a05:6214:ccb:b0:896:f588:b2e0 with SMTP id 6a1803df08f44-899580c41a0mr45451416d6.48.1771450488607;
        Wed, 18 Feb 2026 13:34:48 -0800 (PST)
X-Received: by 2002:a05:6214:ccb:b0:896:f588:b2e0 with SMTP id 6a1803df08f44-899580c41a0mr45451066d6.48.1771450488156;
        Wed, 18 Feb 2026 13:34:48 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b218258sm1888631685a.47.2026.02.18.13.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 13:34:47 -0800 (PST)
Date: Wed, 18 Feb 2026 16:34:22 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aZYwXq-x8vMSPorg@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
 <aYhh2XzyFsJbohll@kernel.org>
 <aYzZ-zBipYQ2OA_n@x1.local>
 <aZIGp0F7uuS9qYVZ@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZIGp0F7uuS9qYVZ@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71277-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 4C7EF15A2AE
X-Rspamd-Action: no action

On Sun, Feb 15, 2026 at 07:47:19PM +0200, Mike Rapoport wrote:
> I agree. Will move the check for the markers back into userfaultfd.c

Thank you!

-- 
Peter Xu


