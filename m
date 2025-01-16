Return-Path: <kvm+bounces-35689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 810B3A142FB
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 21:20:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94D121636BC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33CF236EA5;
	Thu, 16 Jan 2025 20:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj069CJa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8B01993B2
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058800; cv=none; b=KoXqiQskHp32BeP4hZJ18C2pFWLt9HY86RXCIMSDMLZC+dtyQGYcGMOarbXy2pxZz1uMxYjOE0RXumMYEbg3rNt8agxGabBL9WTLvDHKpJTSBIbJlW5SD0Xjfjs9xg/sVzHbdpdyKYHgl7JBUT6bRbQUFjYrMLqU8Z5om7+ggeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058800; c=relaxed/simple;
	bh=nNoBF4UfWoe23a1lrQ7UdZ6UWanGe/SAkh9O53HaEmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cv4xqJ6Z2lmIunYAppG34mc+NoIZhaIm77XfpgGCZ6MdxpcyFsulFof3RcaADskKSl2ulFGiGPkj63bUWz/4QCzR8kJ6cjVS0X51MlvfsAc+6YlGUPBFHjKzX3H2RXA8+k6h6wfd38xdWSblZSyMGdcJpX/LJY6vlzjZako+WaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj069CJa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737058798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hxyx17H16LTaCMPogGfVhxD8KdAjR1MUqsEp+1MdmBk=;
	b=Gj069CJa4nUwP9pKLTx2K5xZxYQESBVIoikqa9aC/KEUu5iNOYUOCzLH/zic+lmPFyOIga
	G9zjhhgA69K46lgaCiVTQoh4F4qJ0+/ow4VSS3XpEB5sBDmXlFB8f3YoEKIAyKnTUoTcOJ
	7AkXARApq90qXGCo36r3AybiBSQqNPQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-fHPyotw-NMyQzjzOCDaB3g-1; Thu, 16 Jan 2025 15:19:56 -0500
X-MC-Unique: fHPyotw-NMyQzjzOCDaB3g-1
X-Mimecast-MFC-AGG-ID: fHPyotw-NMyQzjzOCDaB3g
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2164861e1feso23830605ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 12:19:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737058795; x=1737663595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxyx17H16LTaCMPogGfVhxD8KdAjR1MUqsEp+1MdmBk=;
        b=lRKfGHEuqjSBhjtnihkIm398QaX3d+p6HVn91Gb/4Xe+RkEz0OIumZp4wXCBWuXL2P
         EVzD99oTzi43FNIR4tpCZ7tR1Q6+7Yj0uHnZAYTFSessouDvSyXwsNrsqPilxFtmTXtx
         qMiN9S5bgRO94BpHjR7tyf9fsgK53oJJe4un5ER8r7AG1DeC9mugAQdqU/Dy1GL2WUgs
         vbf/mR6oDSZg89CX8yY/X6EkHa0RsaIEttDjzP/Ez26+bfwZJkcBwAyoBXsrL3u7+WZj
         cCs6gX52OOrPTbXkR3CBD8taVLtKrf/suFCXeDJbJOw8in4x5l5C8S45uRFMjsuP8UpY
         yMUg==
X-Forwarded-Encrypted: i=1; AJvYcCVY16EW7hMZoaSevPp4x81SsU6JNiXdEk+Ba5bqR52asDTzC01iK2rrux6vhCJ35Uv4Plg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHUnSEwrHD70E/sMBgxFUWlKQOA9MHSF78HtWihUzK0X+lSWuT
	UdDQLDDtHvsbdfc/bXB/P6//W1PHSCR75bWeUieBJ3Ex9tNgNKqf/zh6Tk6aAygruNa+uUpEV0j
	3CHN+BdVyOm9a9m7gu5Y/p46hijwzGGjeSv/gM8j+JCrVPNlWtA==
X-Gm-Gg: ASbGncu8cxkyln+kY2eUAEoe91efGwigFC2y5mwb/bMhIX9I0DZIat3P2yx3+qoZOeZ
	k2Yb8IRiZwsFFxo3W/iUT3qJ4y81Tnf3FdgEWcFs6ULPi0dYnZGnZNr1lL9SxRXXW33m3F/ULm4
	ag/wjbpUguI0vsTIliCWOAXHmXNkTsSLLGtkA5ffln7t7e1X3ldxibXV087pEphpnUdXXcLpgYH
	fkbKT86GTljtmwZQ90ySHvuv1KtS/zkF5APWzi6Rou5Pyz0ufOlgRzStnnU6tO7K/yZ5eVKvzhr
	SV6SiX1NDhDlQQPpKQ==
X-Received: by 2002:a17:903:1105:b0:216:6f1a:1c81 with SMTP id d9443c01a7336-21c352c77eamr1589175ad.2.1737058795385;
        Thu, 16 Jan 2025 12:19:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCdUZtxdruuZ9dhKBDB1S+oAh8pcb12HPEW8IyTWaMSLHmWxJL1Esm0PAWT5jrhgt1RJfKYw==
X-Received: by 2002:a17:903:1105:b0:216:6f1a:1c81 with SMTP id d9443c01a7336-21c352c77eamr1588855ad.2.1737058795018;
        Thu, 16 Jan 2025 12:19:55 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d3ac3e2sm3791465ad.139.2025.01.16.12.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 12:19:54 -0800 (PST)
Date: Thu, 16 Jan 2025 15:19:49 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>,
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
Message-ID: <Z4lp5QzdOX0oYGOk@x1n>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <Z2simHWeYbww90OZ@x1n>
 <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>

James,

Sorry for a late reply.

I still do have one or two pure questions, but nothing directly relevant to
your series.

On Thu, Jan 02, 2025 at 12:53:11PM -0500, James Houghton wrote:
> So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
> worth the extra/duplicated complexity. And at LPC, Paolo and Sean
> indicated that this direction was indeed wrong. I have another way to
> make this work in mind. :)

Do you still want to share it, more or less? :)

> 
> For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
> replacing it. And as of right now anyway, KVM Userfault *does* provide
> a complete post-copy system for gmem.
> 
> When gmem pages can be mapped into userspace, for post-copy to remain
> functional, userspace-mapped gmem will need userfaultfd integration.
> Keep in mind that even after this integration happens, userfaultfd
> alone will *not* be a complete post-copy solution, as vCPU faults
> won't be resolved via the userspace page tables.

Do you know in context of CoCo, whether a private page can be accessed at
all outside of KVM?

I think I'm pretty sure now a private page can never be mapped to
userspace.  However, can another module like vhost-kernel access it during
postcopy?  My impression of that is still a yes, but then how about
vhost-user?

Here, the "vhost-kernel" part represents a question on whether private
pages can be accessed at all outside KVM.  While "vhost-user" part
represents a question on whether, if the previous vhost-kernel question
answers as "yes it can", such access attempt can happen in another
process/task (hence, not only does it lack KVM context, but also not
sharing the same task context).

Thanks,

-- 
Peter Xu


