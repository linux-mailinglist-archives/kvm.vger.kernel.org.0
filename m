Return-Path: <kvm+bounces-23867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D3D94F192
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03825282DAF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4B9184522;
	Mon, 12 Aug 2024 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QT1gXLiP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129EE15C127
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 15:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723476287; cv=none; b=BQrnq1DRUFWnMqk1D6wEpsEF+R3hdtmmGjws7juFyTMzVf+2RrBU/B3/aSc6EOrj5BJMPwE3eRLd143bFPkHpGFQk0BIiX+FYv0pYSUlnqXjqwWmTyi0cp+AmHiih+27dUp5oGcYJe6crF2gAnYDVX1SQ7+atJxQxk0NcEojoLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723476287; c=relaxed/simple;
	bh=isci/s8Rp6k7733oXOuN/icyGOh/MDoaBbr8cppuWjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4U4qmQ/eZWgUsMVoCZ7RiF/9WWlNh/mo/dfoVIGjr8i/auneAhvbmeBz/mlNkUgIkIA5Z9XtpPxv6oz/58+do15su7QsUVocCNi09zIFw7nqkAmPQPLvOXbIMHtvVBRTZ6D6CyjOYOCzJBcygeK8FomX9oqplH4rLwZBwC8yMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QT1gXLiP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723476285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0G8nniO0W4Joc9T/59AnRTYYBY/vndqQxuJm8W02Kw=;
	b=QT1gXLiPCgv2EYJtHbeTH/KoD1iuKhXLK6rBs/lDBlaDq53ECoD7oFS9HEE3M9eK8q2vQ8
	5vfOzs+gnEj/DESRU4Cn6dQ/RTTIH7cHcxIxObYTkSkmkEACOig8NjT6i5v9MhOarCL0F9
	Z8fDA12LiytN9mIsyWLYTRPSpKio0ZM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-tQNZGVxVNMW8CyhRqOF2nw-1; Mon, 12 Aug 2024 11:24:43 -0400
X-MC-Unique: tQNZGVxVNMW8CyhRqOF2nw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44fea369811so5689281cf.0
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 08:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723476283; x=1724081083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0G8nniO0W4Joc9T/59AnRTYYBY/vndqQxuJm8W02Kw=;
        b=Te6d6vs1jBRX1ru9GlLZA6NpDcQLTYfFGXVEKQjp7vaXoonO0adOKNzz6Hwl9J224x
         l/JVqnaf3QPX4TNBOmW+krj8K1/dcB79RHtsZTKpHeEABmjufj2AIdvlMPFinCvdsbUR
         rQe2IJhmkmF1w5V4UNJsrdPrRKQnDDFkQNzSjVwmHgheW+VGfjRR30OFhmOZe7C1igOt
         CJMee1yvVhXp+Gc2WXgBxcavjeB1z84Dgwnalyxr+WWVJp3iLpEY+gtAVB8XDd5ygH8S
         qzrwcSA1CFwrRRIHkX9iXf4zV/Kx0ndHWI4EWZkUPpe8HShvrBkXI7KTvcRyV4rJou9E
         m8PA==
X-Forwarded-Encrypted: i=1; AJvYcCWHhFks4PNCiBFLnN4co0gNfdxeOO8TOr1DHsxLxtQWUhTV76OJd2314StlqWRX65iHQc84YHSzm+KDoS3IsuMkk5cr
X-Gm-Message-State: AOJu0YzbXNveFegQAOFrruInqAYtgoebIOC3jp8iWipwdaJFVCHRA1hF
	bE/vdfzusPsH8VQAQKATo7foKyJYKqKrs9W8g6wv5oPqA4DF/ZKP3HupRgdlaX+tip5FqFZjGsV
	zaP0MsqjqRHdY2UVrgN6U6DsQyfRnfjxthVrPfHSKgaVCtlIuBQ==
X-Received: by 2002:a05:620a:3ece:b0:7a4:e206:a97d with SMTP id af79cd13be357-7a4e206a9e7mr18695785a.0.1723476283376;
        Mon, 12 Aug 2024 08:24:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYTEAFfpLzjuAQHij27kFr73YainEyUsOtaltqhSvPe0FyPuHQH8ZXYdrcb2vH99sGj94uEQ==
X-Received: by 2002:a05:620a:3ece:b0:7a4:e206:a97d with SMTP id af79cd13be357-7a4e206a9e7mr18695485a.0.1723476283042;
        Mon, 12 Aug 2024 08:24:43 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d8b8e1sm254723985a.69.2024.08.12.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 08:24:42 -0700 (PDT)
Date: Mon, 12 Aug 2024 11:24:40 -0400
From: Peter Xu <peterx@redhat.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Matlack <dmatlack@google.com>,
	Anish Moorthy <amoorthy@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Message-ID: <ZropOA2IQqOP9_7X@x1n>
References: <20240801224349.25325-1-seanjc@google.com>
 <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
 <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com>
 <DS0PR11MB6373A1908092810E99F387F7DCBA2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZrZoQZEfTffvVT75@google.com>
 <DS0PR11MB63734864431AD2783C229C57DC852@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63734864431AD2783C229C57DC852@DS0PR11MB6373.namprd11.prod.outlook.com>

On Mon, Aug 12, 2024 at 02:12:29PM +0000, Wang, Wei W wrote:
> In the example above, both UFFDIO_COPY and KVM_USERFAULT_COPY need to be
> invoked, e.g.:
> #1 invoke KVM_USERFAULT_COPY
> #2 invoke UFFDIO_COPY
> 
> This requires that UFFDIO_COPY does not conflict with KVM_USERFAULT_COPY. Current
> UFFDIO_COPY will fail (thus not waking up the threads on the waitq) when it fails to
> install the PTE into the page table (in the above example the PTE has already been
> installed into the page table by KVM_USERFAULT_COPY at #1).

Indeed, maybe we can fix that with an explicit UFFDIO_WAKE upon UFFDIO_COPY
failures iff -EEXIST (in this case, it should fall into "page cache exists"
category, even if pgtable can still be missing).

I assume OTOH a racy KVM_USERFAULT_COPY in whatever form doesn't need
anything but to kick the vcpu, irrelevant of whether the copy succeeded or
not.

Thanks,

-- 
Peter Xu


