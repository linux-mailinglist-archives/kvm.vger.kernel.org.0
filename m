Return-Path: <kvm+bounces-70893-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDfCIBvgjGkSugAAu9opvQ
	(envelope-from <kvm+bounces-70893-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:01:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 247451274F2
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70306301FFBD
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E53356A12;
	Wed, 11 Feb 2026 20:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MDrx83Rt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pbxeNqX1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2782D1F4E
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 20:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770840076; cv=none; b=Gy6VmopkRp3M6Pd3sygBCpC2Ro1s9Mruu4jLBthDW7W5NZd2ubwjEUkJ/STf+vA0eNngP9c4uriTZ/+iiJDzPJ4/7vxtlyDrQQlaE2Q0ACrrj3FQHZvcMnfN4VCnTdIlohAEc52HoJTh0SLbndQ8t8T2iVICOSjbdiFMHLZ214A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770840076; c=relaxed/simple;
	bh=gbzTFzf1qwsOloZwMfBXvRhqudV/HFNb7Pt4vdjNQPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0gyAgNyVWS7VVDhk3xPmH7jHga8uU+/lyDWw4Fm4zpwqvHh0K9y/f6tE9Ecbirla4q04WJH5hxDDhjxBeYvChYJ538gKkNnlw+/y2KTijJ1ZTkMksO7ea+I4Vc8FxtmFEFhypr6O/VfMvtigNJrUw9NfAthK2rcIY7b7kLfWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MDrx83Rt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pbxeNqX1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770840074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
	b=MDrx83RtDHkuL4df5fdy5aAiBAMNwzxs3OdlAfoHfazW9pjKma8+lP6eNrHVgL0cVlOhh+
	bp1IrG4tflYYQmKk7LEK2B3hgqzuZntuA3xepfRBHF9+Pq8PMYffRcKFBezeUksMTqhfL6
	2kfm64sLI/QDhhQ7y4tR2PqySDDNoSQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-Ap1IlD8JNp2uqCMBmCiN2w-1; Wed, 11 Feb 2026 15:01:12 -0500
X-MC-Unique: Ap1IlD8JNp2uqCMBmCiN2w-1
X-Mimecast-MFC-AGG-ID: Ap1IlD8JNp2uqCMBmCiN2w_1770840071
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-894727de401so51872276d6.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 12:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770840071; x=1771444871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
        b=pbxeNqX1hoGg/ZAcgDD3OklffhD62DiYXOVyNCYZQdQSt8SNGdVUA1BRbRl/XYhyVL
         9xwxDHB3gQZZ5aHgZbV9lvmEdzM4nvBbWYydpKIra8C2gHKKcv0mfySwNQx9KESvmRhk
         eeTY1a4aDv9vT6tL6aR2/tol9E/gt9uCSo4RZzN9Gru79hhBSsZ6+7vNEYRuzn8EwFu7
         4i5SqQAVswR4ILyyufbq3jRxflHUj9uTe1WxgWp78AWFBeQad+fLlYEayW83iW49BlO7
         Vb43GDr702qXAPENOlu+dr/0iXCOm0CWZA9c+8v9JQcQoWeVnrRDR7H2BFcHL+QURCzM
         BUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770840071; x=1771444871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unlAZpu0DMR9ibJFuP5Oyxh4e+3VDJDkStDVQDwwXng=;
        b=kBCzpB7q72kV8Fa3RXkT+JKedajbMtYkAI2Z6QnCqvxffv2KNWz7yPp+clz3f1Wfgx
         jaB48Z2w6IWuweQifPA+IPir5OiBMUxh1c9ii5LwahyYjZV1ceEzVbPT9BVsBcLiWUhX
         p8exTOx4nrZRQbhmecAzij5qaHjxQeS9NiHJUA80CZLvZ9xV7Q2NRg3BtlQZ9NTkBIo7
         lC7QI7coyuVsyf/oro+l6yUwdrgM44hdQj1Xtq5JpzB/tPi8ZtX9BHObniUQ0PXMiV06
         2ulZQK6ooGVHniX8Lv4iMPqTPT06jWtErV/lb1sSDy2emO9SAkiGJx1Sq6cWzJ+MXdxS
         KADw==
X-Forwarded-Encrypted: i=1; AJvYcCUxQRaXaOw7SdBvO0ojZ1V7TgJETUOij5wxe+mKgSrlUs+RXT0lRKWIJGWFUACIak/9xHw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgv5i/xfpdhRAwDEZlXzl77mSMF49Ngqp/Khiyu1uQtwenTFfo
	6IIdfSw8o+aHttn3xzHLvbEW/wySrLrtFw+4qlEU9otUeCzUtu5+v2+y0tDKbo9wRCx6uU+BPvw
	1s0UUQVUeO57ZhJwglkUk6KcXg5acqNQVEzjSxhNxKtF+szONiJTOpA==
X-Gm-Gg: AZuq6aJ3OrXLFDsiblpwBsQZidAg+rQQAJWlTglr8mW5dpxm6reReHh7Mh1cu9b9I2k
	9t8GpPCPOYi5Z1iu4UL1a940HAdzRyPobLY6C3iyMvVP1RDed33pVeU92qx/spR939sWqlE1bgc
	t8bYPYrBleKmFf8yd8HejLeSUYXFu8/wOQvQQn3QYOs1U4Q9UF+jddJ1iO2XHsUTanRYRz5igUq
	4ufF9lqjH6ei+BYMPtY3Cdup7KXBFeTQrUxwtuufxVbohQ43NjWp5nsSvTe0EKsvGR9uSwoKLal
	2S1eld4SFke0stfOm4L/UVlI8p1c6ylQRUUEwlp1NxZOoMN4NuEbGTDgc5M4RJEl46HCjm+PG7g
	YOcR9gI1a6/0M4peygU2RZdbD6kuOqXuYq0+Ym1EH6h70IeGjebdCiNHYtlx9ZXJAnbT5hdj/SW
	tOcvZbeA==
X-Received: by 2002:ad4:5aa4:0:b0:894:71fe:89f4 with SMTP id 6a1803df08f44-89728d939c3mr2000416d6.11.1770840071460;
        Wed, 11 Feb 2026 12:01:11 -0800 (PST)
X-Received: by 2002:ad4:5aa4:0:b0:894:71fe:89f4 with SMTP id 6a1803df08f44-89728d939c3mr1999556d6.11.1770840070818;
        Wed, 11 Feb 2026 12:01:10 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506920071c4sm3288501cf.1.2026.02.11.12.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 12:01:10 -0800 (PST)
Date: Wed, 11 Feb 2026 15:00:58 -0500
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
Message-ID: <aYzf-hS4pUY9ulss@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
 <aYhm_4difwN5XXxe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYhm_4difwN5XXxe@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70893-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[x1.local:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 247451274F2
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 12:35:43PM +0200, Mike Rapoport wrote:
> > > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > > +				       struct vm_area_struct *vma)
> > > +{
> > > +	struct inode *inode = file_inode(vma->vm_file);
> > > +
> > > +	filemap_remove_folio(folio);
> > > +	shmem_recalc_inode(inode, 0, 0);
> > >  	folio_unlock(folio);
> > > -	folio_put(folio);
> > > -out_unacct_blocks:
> > > -	shmem_inode_unacct_blocks(inode, 1);
> > 
> > This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?
> 
> This is handled by shmem_recalc_inode(inode, 0, 0).

IIUC shmem_recalc_inode() only does the fixup of shmem_inode_info over
possiblly changing inode->i_mapping->nrpages.  It's not for reverting the
accounting in the failure paths here.

OTOH, we still need to maintain accounting for the rest things with
correctly invoke shmem_inode_unacct_blocks().  One thing we can try is
testing this series against either shmem quota support (since 2023, IIUC
it's relevant to "quota" mount option), or max_blocks accountings (IIUC,
"size" mount option), etc.  Any of those should reflect a difference if my
understanding is correct.

So IIUC we still need the unacct_blocks(), please kindly help double check.

Thanks,

-- 
Peter Xu


