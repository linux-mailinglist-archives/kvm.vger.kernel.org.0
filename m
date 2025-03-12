Return-Path: <kvm+bounces-40853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BCCA5E477
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 20:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17A8C189DECE
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 19:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FE2258CD6;
	Wed, 12 Mar 2025 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IP+TzMmJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374019C54B
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741807960; cv=none; b=q9L2B58G/knrkIZ4iufIbJQ/4VUvIdqxiummvd87s4zct0GhbtWetJBhmnP16R33ffKmVrPXGWp+C4qIl7UD8a/M1H5/XYBLEnjIhMbQPW1mKwn3EmT8U9G7vLbYJcg9GmFRQRa+691vPL7SVvsnbsRJYDKgIMI5m+aIWNoI7Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741807960; c=relaxed/simple;
	bh=xgBdBBk7i8LAgh8FiRTW2kFqQf8f3xZuiFRK09preGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=coc/hfPq7G7DB9mwPHZTgwbskguxPjFylJu7ahLOvkf/UeBrx65TT1qDKI5NY24s+VSgQIpm4eK5426Gamwbqwb0ZECh8GURHwym3trCyhmHomQ81BBy1wAfBHtdJGqaTkpAU5SsGiR7Gyd60qfoEqHVv8UzvhUMQw4qCkMWFx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IP+TzMmJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741807957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cXwwCzq0XPmqyi1BVWI5psFQo3FiUiCtEITxNLAbSss=;
	b=IP+TzMmJokXKq77MHj5JXFqHP5sucf+nA6ivBKa5bA28SaQVpw1GHLaFEP+JBCIJuC3eY0
	GtkBQCqt1B+SpPWuLL/+sAK8ZaYOIU/Gcb18h25jUlnWn0UthAFVbVc2XR+yd8Wa2WKagL
	moqfwhsiYdqbeH4e01vx3a2BHLyObOA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-n6LsEearMvOVjnvfhwhW4A-1; Wed, 12 Mar 2025 15:32:36 -0400
X-MC-Unique: n6LsEearMvOVjnvfhwhW4A-1
X-Mimecast-MFC-AGG-ID: n6LsEearMvOVjnvfhwhW4A_1741807956
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c3b8b95029so20875985a.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 12:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741807956; x=1742412756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXwwCzq0XPmqyi1BVWI5psFQo3FiUiCtEITxNLAbSss=;
        b=lQ09cajM5l5AN4LI8nQfUay9Ik2snJkEtJJZyYJGHu1hysa521qCqY0dK6Ts1vXAY8
         TN++Nxu/02puhH1bYlQuMO6xLF5lAn1BFVuZKVs17oq/mBdVm0w5YJ4kAhnlT1Gn4DGV
         YQSVBeAYvUWSFHn5brk83eXNYKbVVKztOz8gNNKc4yPr3p16T+DHYB1jNrq99JWydfrG
         akwYHWYckY63k05FT+NskKaFf14QBuMs/XPmMzZLlzrsKelB9J5AFjSj/4bBowmdbrJc
         MJXIi+CRx7dE1j5VMoU0bTrMbZLW7cRVdbt0vwu83WUeGqqvHp8ZRIWckPmQSs8V4Vgs
         70Qg==
X-Forwarded-Encrypted: i=1; AJvYcCX7g2Hi81rSZq5RqJqU5odeTZx48L797rc8mFWokcU/erW4uqtOialWVsY+YYSt8Mhz6fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqGAyFxVURU4zX1jd6EQOpzMSWzRHys8He+khInuJNeIuDq0X
	6w07KzsFK23ZpV/XUejs5ggwdzWBvKG36H6HzQLvCf1qBrYUoscygePc8b/3t1QaA2fBDqhbh3/
	OE0htXN7S6N+wLkq4ZIjUyMwsnu/PT1A7e7i+UNj9dt5wbxHcWw==
X-Gm-Gg: ASbGncuZ7lqU/4Yq1ETMgW3u0T0PE06+JQzjhUyBqQB1fH4KE68Y12raoIGiZxTGucS
	ML5V4rssuc1VCh61KewZwfZhLoChkwjGmuyzs7BOxrPkpakgkXKvpH+MsbK0oOw3ClgS3LOVN2t
	8Xc9U8FAnfvxZIOemLJ9nsD/lqcXUPF2jVzuC2i2+DIJr1K9ndmONTosGGQHOX8zTWm0bmy9OoC
	QsbfdZ9FKo3j3adJ4uzAB4r8vQ7bS+NrhOYVedXClAnlFx41tHGGFSgCQRovw5HdLYpU7XOkkMm
	CKbbN5k=
X-Received: by 2002:a05:620a:268e:b0:7c5:55f9:4bbf with SMTP id af79cd13be357-7c555f94e37mr2089059085a.7.1741807954925;
        Wed, 12 Mar 2025 12:32:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG21UoB4UhW6J7OnJXCWJmtkS+rArAGv2lRBmFk4GlTGcEtlkmQsqJSDwW+31DKN2CBG4Usgw==
X-Received: by 2002:a05:620a:268e:b0:7c5:55f9:4bbf with SMTP id af79cd13be357-7c555f94e37mr2089054185a.7.1741807954664;
        Wed, 12 Mar 2025 12:32:34 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c54c8f99absm570901185a.117.2025.03.12.12.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 12:32:33 -0700 (PDT)
Date: Wed, 12 Mar 2025 15:32:30 -0400
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: James Houghton <jthoughton@google.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z9HhTjEWtM58Zfxf@x1.local>
References: <20250303133011.44095-1-kalyazin@amazon.com>
 <Z8YfOVYvbwlZST0J@x1.local>
 <CADrL8HXOQ=RuhjTEmMBJrWYkcBaGrqtXmhzPDAo1BE3EWaBk4g@mail.gmail.com>
 <Z8i0HXen8gzVdgnh@x1.local>
 <fdae95e3-962b-4eaf-9ae7-c6bd1062c518@amazon.com>
 <Z89EFbT_DKqyJUxr@x1.local>
 <9e7536cc-211d-40ca-b458-66d3d8b94b4d@amazon.com>
 <Z9GsIDVYWoV8d8-C@x1.local>
 <7c304c72-1f9c-4a5a-910b-02d0f1514b01@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c304c72-1f9c-4a5a-910b-02d0f1514b01@amazon.com>

On Wed, Mar 12, 2025 at 05:07:25PM +0000, Nikita Kalyazin wrote:
> However if MISSING is not registered, the kernel will auto-populate with a
> clear page, ie there is no way to inject custom content from userspace.  To
> explain my use case a bit more, the population thread will be trying to copy
> all guest memory proactively, but there will inevitably be cases where a
> page is accessed through pgtables _before_ it gets populated.  It is not
> desirable for such access to result in a clear page provided by the kernel.

IMHO populating with a zero page in the page cache is fine. It needs to
make sure all accesses will go via the pgtable, as discussed below in my
previous email [1], then nobody will be able to see the zero page, not
until someone updates the content then follow up with a CONTINUE to install
the pgtable entry.

If there is any way that the page can be accessed without the pgtable
installation, minor faults won't work indeed.

> 
> > as long as the content can only be accessed from the pgtable (either via
> > mmap() or GUP on top of it), then afaiu it could work similarly like
> > MISSING faults, because anything trying to access it will be trapped.

[1]

-- 
Peter Xu


