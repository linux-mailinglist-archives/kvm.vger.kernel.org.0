Return-Path: <kvm+bounces-54000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30960B1B4E1
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3DD7189B715
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D17B274B22;
	Tue,  5 Aug 2025 13:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJ+26LC3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168711400C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754400462; cv=none; b=npLBdJjhwPCZU+dFbIlnJ13jDFkQEgbtSSWjTZ0K4WHak4X2K6HVUEbMBrIHAl+4HroXZ7YauMnt771MK8p1cniFOfnI6Iq97g1WqjblLkWqWcZK/ThzZKHU+vWJtt2ItsQiHVQfjVHFg28q2QFwk+9xbfjt8XSUlFDtaReIU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754400462; c=relaxed/simple;
	bh=CXLeuRxuUjMghD7mM/MdwwgXlGhq5ZSsjlOgGGsBOlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STAfUs1ECO9uLwdEzJEHlJAR8WjRQJrvcXp5s7HgYUVwj+ye+eCXBUh0oiArMYSSiyIi9OCe0CRjPodqObE04rSdrcVV4gr1Q34mcRCI9+HY5Bs1cZ2wu+h4lPh4lGJ+Oe37D2R1GFLZKKHeHL2cA8PA0oxwl5niXIgerJiJrME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJ+26LC3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754400460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aYlHhtSBieYXdciV+xf4xNTN27jL64xJTyutUDVE124=;
	b=JJ+26LC3/KWd9gw2tZBlUx6672gKPrM1uJid/xRyV1kD2Prd6nJzKUWSivcG+1sBME8Xro
	ooYScjch0uq2ucYUAOx8y84ndlp3IfW7g87JxCxaXbU41SfnVMDhp5p93Vvljc0vRT8X9X
	wNvquFu3K6e3P4YYaHUr06EhbhOFwKw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-THBXJZ9EPaasyXmQQQNxBA-1; Tue, 05 Aug 2025 09:27:38 -0400
X-MC-Unique: THBXJZ9EPaasyXmQQQNxBA-1
X-Mimecast-MFC-AGG-ID: THBXJZ9EPaasyXmQQQNxBA_1754400457
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459db6e35c3so15055725e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754400457; x=1755005257;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aYlHhtSBieYXdciV+xf4xNTN27jL64xJTyutUDVE124=;
        b=knrdNzYdrmN7D0cuhUvFlFB4btLanhS4RCMUzR+UB/QAUs1NeL3aHpiBieqySMWH31
         JAfYj9afoGYeIjq+ddvMivQNUejGApg5RIwNuZmRJSx9beOau0jSVhuAoSdUYSqFfYmG
         xQqIV5+75lwphde2NqDbogQ7Bo57bsSkPZJasI364dFND6gyNkNOXHz0nsZRV0Fz0P9p
         Rbl0q+xPpW4kFEFw+S5RjVyCiNnQ6UsmoDxAU9Ilt/l5ibxfzgneRJCJkACwUyhuyehs
         Vbnq/xOElqhqSm47QL5Mpl7t3ls+gd5Kbt6eobGAMjbcLw+uEUNYWFEMw0O4PWIw6uca
         xZ9g==
X-Forwarded-Encrypted: i=1; AJvYcCVLhFeWvnLLEns2Tcs4fbCJOb7qF1iRwC58hP+g+yDyjua9O/1PGAn+R2WHLVOXT51Ay/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX0+X3phvCrI11/NmEASF6jLvj57tNJ8RWqxamNCI7q9TPY4WC
	zfpsoJ9mQ+4KOxZRt/hrvOzPyJ1QFL74tWaRUeNrLfzBhJcl1vniubIOOzQEZZsy+dxdTPkfLeS
	Un/X7qdYH6rbYkbUoGUz0pOHaUUjYIQx5EGP8SjPt5Yz/JIhCydOOWw==
X-Gm-Gg: ASbGncuV56FchNnTsGrP743vA1y87/H9pFLmxisaqnzym/jfdbLjcVx4IeaJ9zk+/lA
	suaLweYqx9ye+YSxKJrIPJhy6M5s5BH9OIWy03C0aFPacbxN+AxhGvBXK4X53gMhLSVn8z1F/fR
	RiuWowjtcekxv5mjPyN0JemwBau5KXaPSgO6DxydIK3bbWiTAfejCF7isCsETjPeG7xiWjBl3P8
	6DZaAdvpzD1u/J5QOkRH1pIGZs3eeHaUOmLg+0Rk7MgYJIwmMY2VorKGGTg8WrlDcwn1EO0pvEy
	e6qIvV+4vTQFvJXCqcw/VzGw3Y6JKOCZLFpOqAJNBdg/Gyc/Hn10WXiJmCrsCoEW8at81uztPFz
	OKhC0J6sOuKEWdsDlAc2y7dBTTHQP1GqVnfgCiXRoVVs4TUaHT66HkSGzXSBv385OqO4=
X-Received: by 2002:a05:600c:1ca8:b0:456:13d8:d141 with SMTP id 5b1f17b1804b1-458b9bf7ec2mr96853185e9.27.1754400457276;
        Tue, 05 Aug 2025 06:27:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwUoY4/yST9IaOxv5m12yfx1ZltcfLPJ+gBaYuYTbdqa8xUSqwSCuu4utbISEaivDpz3Q0OQ==
X-Received: by 2002:a05:600c:1ca8:b0:456:13d8:d141 with SMTP id 5b1f17b1804b1-458b9bf7ec2mr96852955e9.27.1754400456853;
        Tue, 05 Aug 2025 06:27:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ad803sm19118805f8f.6.2025.08.05.06.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:27:36 -0700 (PDT)
Message-ID: <7e03b04a-33da-46a9-a320-448bc80f3128@redhat.com>
Date: Tue, 5 Aug 2025 15:27:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
To: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Li Zhe <lizhe.67@bytedance.com>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805012442.3285276-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 03:24, Alex Williamson wrote:
> Objections were raised to adding this helper to common code with only a
> single user and dubious generalism.  Pull it back into subsystem code.
> 
> Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

So, we might have a version that Linus should be happy with, that we 
could likely place in mm/util.c.

Alex, how would you want to proceed with that?

-- 
Cheers,

David / dhildenb


