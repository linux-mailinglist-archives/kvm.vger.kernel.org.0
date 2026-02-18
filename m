Return-Path: <kvm+bounces-71279-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJKMAnUzlmktcAIAu9opvQ
	(envelope-from <kvm+bounces-71279-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:47:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E04B15A635
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12A0F30398BD
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2DF329376;
	Wed, 18 Feb 2026 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cI1I/25U";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qpOr8LHH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C3C2FD66D
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771451180; cv=none; b=tnDudn6s+I5qzyJfeEuw6ZWGzBKn51w3sU8VwKhpjRU1jD8cuNj49WbzzKEnuE2NasFQsGtq23nJOSdKxTM7Ah0gBMJK8sQZzA01jOuy3XbIoZlGY0adY6NcKg/1e9PfkzugOJB4etjx/fB4BzKTMusv8NxObOSu3+qZVNrPY8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771451180; c=relaxed/simple;
	bh=xmblt6armlTF8R46mNJYp4dI9Ge2TRJhwdNSQ517qBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cu1ZU3lTDtO/fYjlqqLnog4mnP5oV8w4y6UCkUMjgxbfkfew2TlhfCsE55apBF8mO9KO3Af3mThtjKKPDIxMz5dnbbFgV+LaKfObsMXXDBEtsSgLYFO6k6A9kN3yO7c1leyxsqavEUBJ0Yao5meglh5Q3FyiVhEPtCEUpwet2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cI1I/25U; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qpOr8LHH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771451178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
	b=cI1I/25U4ihis2C/hMR6fY2VLctxQpFVRUuOaAdzZW95obn6BPG3rTGtfvUl3wMM9OvfZa
	anC9OpQ4YU0sVpEEcciULiY7jItzqttMeAk6dtrG1mcwGBFRjkcCZZ5Sy+R3ROC/4LeKJF
	o9jCKOduAT1lHwNTA62V5j0zR32Yi/Q=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-YefR8dt2PtuUR9nvfhZ8fw-1; Wed, 18 Feb 2026 16:46:17 -0500
X-MC-Unique: YefR8dt2PtuUR9nvfhZ8fw-1
X-Mimecast-MFC-AGG-ID: YefR8dt2PtuUR9nvfhZ8fw_1771451176
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-506bfa0441aso31082901cf.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 13:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771451176; x=1772055976; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
        b=qpOr8LHHK8sHR7IaDQQ/h/ai5uyQjBYdFe2eg5jqDHi2XzlV1tBedcr7f5fwlaK2W0
         UoDCVkZ70PsOdUFeUBqM26eK73Vm7Bon2vH8VcN3gvESP0IfM9XXjalLqGMWxTdknqsH
         6h3o7K+O0ONnevOrCSQcvwHpmRuwmyXz8hXV22mScpdwwXq8VKwpJNvukOsVdoc0uhS2
         DF70HN1IznmxwkHscgUFNe4yXz3n6f09heL/s75U7ETp3rylHrHWvTTvJdhbLDa9nggd
         3elUL7NvHLEA+n+Lt0GMCVFpbnYhWkMjDHN1Py2sZaLs9gwYuVgy9txKn/nu+/1gGqOM
         gScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771451176; x=1772055976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7/VoI5q20qGTQoXj49vRdypgNZ/BrCMYvuD6UKnpJI=;
        b=o0UAgWnshgxmdBy+86FQTBb5ANVVge+pjDaqIZA0Ak4ptFqF52nYiFMrGoc67A4CC0
         hCtq1/J4nKSrGjFcWzhlaczfFbbeQNnagE5TzfQ5aA/FlMfAHT9Yt/rlREBjN0gOyeyr
         eJWT8equzsTLpbJe50Q0kXO48Td4gClrkLGQcf53v9IWkEqwM8rhF6rsy8YiK/BIP+qD
         8vpRXd4laOthv76wMbgwgGBwKocIM/2yy5zEMAUb8dM+XtIWqQdbJQTHsCEZ/5O9PjDO
         JgLDepbQj+EISDtg7BlrW/wId7JHt4FkQXGs3omK72KnD9QYV2dMN8IMwr4kDPTpFdru
         ZoBg==
X-Forwarded-Encrypted: i=1; AJvYcCUUg5kUMTjMD29eIGm11/HyH8oBM3cDhOC6I8XtWYW4YFxjwgyo4Odfm3iFibMOHRvoYvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWZuxr+jCuPiQqs2+yKhTtLxfecJuI4DmR7iBVYvN6nbnvXZGK
	m3dcuPjupoY/o05OiQolwWBIPvy4t31CGOqg9y6ZdnaqCHCFm9YT/KsvWAumHW8Opl+v99EOe+1
	Y0p9oR2PIEeLz7C3QzgVMZQyNcQyNgkKCFTkC3E2J7YbjwWae/mHWxg==
X-Gm-Gg: AZuq6aLV7gt9lSTnD4KyHEpszZV8H5cWjQRbqZ8Vq5x4EvZ5VTpI2nnD+6k4s3iPcJs
	RNQanlPZs6iXCX1oY4yiWSU9cdODUmHKriYCf0b3a9mBFATQ0yV+5T2JFLDvOPNpYy+xtYeq55s
	q9SF0SDVvy6bonAw/BTBLlSzGhRt6yCF4ztqCA0QANbhht/aWZIW6cd1OQmlL8uI+PHY8cDW/is
	8sp7ZLO7ZXa5Wv60Hjt6X/eoGu/Cd7WHAGwzz3JxVfEMK1dbj9xKVPlhopAuZJAoD51s8/83eoF
	rsbBNKGMzuweLfVSV5eGEsikpszRDCDsC0VI1+6WDfegvVXcXEg3ghEjzE1FlKw1I9r6E3u8+uU
	RuCQ1n+uosTCxcA==
X-Received: by 2002:a05:622a:190b:b0:4e8:b446:c01b with SMTP id d75a77b69052e-506b4020625mr201996531cf.61.1771451176354;
        Wed, 18 Feb 2026 13:46:16 -0800 (PST)
X-Received: by 2002:a05:622a:190b:b0:4e8:b446:c01b with SMTP id d75a77b69052e-506b4020625mr201996241cf.61.1771451175893;
        Wed, 18 Feb 2026 13:46:15 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdbf972sm195151676d6.44.2026.02.18.13.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 13:46:15 -0800 (PST)
Date: Wed, 18 Feb 2026 16:45:50 -0500
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
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aZYzDhi7mvgucP9V@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
 <aYzf-hS4pUY9ulss@x1.local>
 <aZIGIH9--qOamaMe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZIGIH9--qOamaMe@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71279-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 7E04B15A635
X-Rspamd-Action: no action

On Sun, Feb 15, 2026 at 07:45:04PM +0200, Mike Rapoport wrote:
> On Wed, Feb 11, 2026 at 03:00:58PM -0500, Peter Xu wrote:
> > On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > > > +				       struct vm_area_struct *vma)
> > > > > +{
> > > > > +	struct inode *inode = file_inode(vma->vm_file);
> > > > > +
> > > > > +	filemap_remove_folio(folio);
> > > > > +	shmem_recalc_inode(inode, 0, 0);
> > > > >  	folio_unlock(folio);
> > > > > -	folio_put(folio);
> > > > > -out_unacct_blocks:
> > > > > -	shmem_inode_unacct_blocks(inode, 1);
> > > > 
> > > > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> > > 
> > > This is handled by shmem_recalc_inode(inode, 0, 0).
> > 
> > IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
> > possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
> > accounting in the failure paths here.
> > 
> > OTOH, we still need to maintain accounting for the rest things with
> > correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
> > testing this series against either shmem quota support (since 2023, IIUC
> > it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
> > "size" mount option), etc.  Any of those should reflect a difference if my
> > understanding is correct.
> > 
> > So IIUC we still need the unacct_blocks(), please kindly help double check.
> 
> I followed shmem_get_folio_gfp() error handling, and unless I missed
> something we should have the same sequence with uffd.
> 
> In shmem_mfill_filemap_add() we increment both i_mapping->nrpages and
> info->alloced in shmem_add_to_page_cache() and 
> shmem_recalc_inode(inode, 1, 0) respectively.
> 
> Then in shmem_filemap_remove() the call to filemap_remove_folio()
> decrements i_mapping->nrpages and shmem_recalc_inode(inode, 0, 0) will see
> freed=1 and will call shmem_inode_unacct_blocks().

You're correct.  I guess I was misleaded by the comments above
shmem_recalc_inode() when reading this part assuming it's only for the
cases where nrpages changed behind the hood.. :)

I believe we need shmem_recalc_inode(inode, 0, 0) to make sure
info->alloced is properly decremented, so shmem_inode_unacct_blocks()
explicit calls will miss that otherwise due to the reordering of shmem
accounting in this patch.

It's slightly tricky on using these functions, I wonder if we want to
mention them in the commit log, but I'm OK either way.

Thanks for double checking!

-- 
Peter Xu


