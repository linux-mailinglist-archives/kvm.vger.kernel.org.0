Return-Path: <kvm+bounces-48179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1665CACB8AD
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25C037A7D09
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 15:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BAE221FCF;
	Mon,  2 Jun 2025 15:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P7tkeqWE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C7175BF
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748879022; cv=none; b=Ff4dvu2lL2LWye6C+btBh4B+45FTYPbVqn0Sp1nJKG26iLGBNrI41S90ajhi6j/U4j0chrnXHsC9u5d/2A9RtOgIQxjfkH3macN9flj76XA/LLJqv2c9n9/6iphr9RcpzrLAHB+9n2tbGrPhnx5MMiCswZhw85ICsJbh+wiAjUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748879022; c=relaxed/simple;
	bh=vnDj3LDoE6fvOnpQxqV5cUhV0MzIRWUbuJRW8FXHgy0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RrpQrfNAYJ9yDGv6pmoL0j9yqjliA4OWWVaaX5XBmvcKMAbAHlo8e05Nhi/6w5HKx2EX/zyzjqU1Jh+yuQcT8vE9HQA9bM0aX9zSyz79xScSZb5qami4BVnk/MLjCVA1YzwnsauglM/sQOxOqcvPIxwdbXd85AZ4UKKRrL1hsHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P7tkeqWE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748879019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEnNPOQQYinKhtyFPbtNahXJ+hfo2zYwElH9phszy/s=;
	b=P7tkeqWE/eviUGFQ2tFRn0vaAR5amhUK7C1xVw8jFKV0xUhXhhJyDYrBVWaC3/mnFqdkth
	nkomeKNNIzLcYs4pTt+M1xJsRSqQ6YJGexHnan5n5jE0sGqiITnIyHphgPfPULJe50FBOs
	2/fp3mwzbxA2TemFG7bEk7JR4wBDOHc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-_XD-W5IIM_-tgME7EoEncQ-1; Mon, 02 Jun 2025 11:43:38 -0400
X-MC-Unique: _XD-W5IIM_-tgME7EoEncQ-1
X-Mimecast-MFC-AGG-ID: _XD-W5IIM_-tgME7EoEncQ_1748879018
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cfa0cb1eeso25860539f.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 08:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748879018; x=1749483818;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEnNPOQQYinKhtyFPbtNahXJ+hfo2zYwElH9phszy/s=;
        b=Xp0jbTVumbKbS7qnLjMdSb/t7+3mOgxFh2k2UYzopG/NLbZGDljy5T+HdEwZdqu6tF
         bb5M+gECnI3xh3Ev7XXg89lOlL7HPwSZES8pZHJOjFAusr+PKm6y4r+Ah/Nd8yLE42IR
         oHxINLlxgmHN6vlMnhyJvu8kIuwiE2mhIkbX8cCmfSxPGQJ4cCnLlHDG+nkUKw+3BYA2
         owJZ6mg31rFO5d3nD2qah6ulbKib8st0KLD2LXcQmkmCB7BoflOCTvsLKrUphCceTzD5
         hxjT02VInB3x0wGdO8fgPzP5sZG7pCsYVTAjBuLSiuu3+j7HCi1UelIjuNLKC84/BXGr
         04Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVAuExlAziFICnJzm5b8RCZU9LP3cTCpaBnN+35P08xHGE4l92v6ctLYRJG34e61Pkj7BY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgpt5601G0k/d4KEqHnIY7uvD++9obU/fnrv8TQnnPjzPwOybK
	84G+mrq6qBc2wmjJ/AWBy5NLSzdTfUzSbT44Ee7YfGXkwSENqPDu7QkYZkJ3EQeIwgJpO1++SPa
	ATL+a2ib4N27o8UnNwh83bEn+iB5io3wTOlk2HIsDQCc1E+o+pFUm5Q==
X-Gm-Gg: ASbGncvXth+rMqHTDr3OWEug4zLFwptCLBlC0Gyy90Cht1Oeq47H/mjnN6TkQ3xIUPQ
	ErDYaXgfWjUAyMV6XGpXrJwYO36Dit5tqcx6Be3EX1G2eCR2MxPvEy/tbH8cePgv8onf+6NFhKr
	uDhUJ8iMV+f+aQoB3L6osX78qDIT4FXVrf2OY826jw0L5qfUgU6pdD50uAZAUfMaxhffymuk7D0
	rdFghc7N+m6bKbuK7ogIvFGAH//eyrgxhCfsskg4XqJxLgsxar+EGDs800qA6q90StgcX1cQHp0
	vbWKEMNALAnoBqs=
X-Received: by 2002:a05:6602:1507:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-86d025f5633mr430894039f.2.1748879017936;
        Mon, 02 Jun 2025 08:43:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxt5m7iXx5A9r4eTEAWC0Vws511DwnI/2T8V+mtgy7cCEIe9lBpfzRQFP+WGCTj9UR0FmfLg==
X-Received: by 2002:a05:6602:1507:b0:85b:3f28:ff99 with SMTP id ca18e2360f4ac-86d025f5633mr430892039f.2.1748879017486;
        Mon, 02 Jun 2025 08:43:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7dfe4a5sm1808088173.16.2025.06.02.08.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 08:43:36 -0700 (PDT)
Date: Mon, 2 Jun 2025 09:43:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, KVM ML <kvm@vger.kernel.org>, KERNEL ML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] samples: vfio-mdev: mtty.c: delete MODULE_VERSION
Message-ID: <20250602094334.4995ea23.alex.williamson@redhat.com>
In-Reply-To: <20250531161836.102346-1-xose.vazquez@gmail.com>
References: <20250531161836.102346-1-xose.vazquez@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 31 May 2025 18:18:36 +0200
Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> Reminiscence of ancient times when modules were developed outside the kernel.

s/Reminiscence/Reminiscent/

I think there are likely better arguments that could be made for
removal though, ex. citing specific policies or discussions.

> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: KVM ML <kvm@vger.kernel.org>
> Cc: KERNEL ML <linux-kernel@vger.kernel.org>

Signed-off-by?

See Developer's Certificate of Origin:
Documentation/process/submitting-patches.rst

Thanks,
Alex

> ---
>  samples/vfio-mdev/mtty.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 59eefe2fed10..f9f7472516c9 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -35,7 +35,6 @@
>   * #defines
>   */
>  
> -#define VERSION_STRING  "0.1"
>  #define DRIVER_AUTHOR   "NVIDIA Corporation"
>  
>  #define MTTY_CLASS_NAME "mtty"
> @@ -2057,5 +2056,4 @@ module_exit(mtty_dev_exit)
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");
> -MODULE_VERSION(VERSION_STRING);
>  MODULE_AUTHOR(DRIVER_AUTHOR);


