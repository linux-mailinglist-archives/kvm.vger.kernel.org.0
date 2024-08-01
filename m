Return-Path: <kvm+bounces-22995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4CC94546E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 00:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DA0EB22C3E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 22:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682B714C5A3;
	Thu,  1 Aug 2024 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWC2XevP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1980E14B956
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722550351; cv=none; b=CdJNH/jghi/aqgIP6UK0MF4xfqMq8/HvlnvqoGNUpqGa9mipaboexPqfsU9rwyByRxVIQjv8kg1lZ5z989wcoQFekvoEB2rkwsrj0Xfg/tdSnHHBKGxaF+3g36MZpzIOpK8RkYzWUqmfnHun/IMg9IBWndvWxJ0g47jqQlhf980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722550351; c=relaxed/simple;
	bh=0UTEUABwLl9nPHyasmA3Zw/bHjsSB/lUKnDNzfoDXeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlVBLPNAMUiwVL963ry0hfmMpucqROMmvjzXd2P0hgkVC6RxzYqk6QrAa9XKUjYVj6yPHQ9AzggTHzBg4J52sEBFtKF/VIm0VnnMT7of49yZ5FEygGAueP1zxbyEtLpzBzhLl28BLqA+UxX9q1dd0TRNCsuFlaDDDVWH9iq9AyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MWC2XevP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722550349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEkakUjv0oShqAlgA+JoFFoT773rpEPOk5LHphGKBXA=;
	b=MWC2XevPWxNDw4qHj4RffqWocP21wC3ik63MipWViTP9C6o5TbEGIjsvw9iPXyxMX7AEca
	gtZbob4SnkGUsEMYy/IWagT1nwxgDzsdkVsfLv1/wWMGMI3dr3Xw8ZbumLyHzvZNUZqbFs
	nX0CCY97dfgrktqxacWmXQaz2w+U7Ww=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-AloWJt_7PI-HHRQEBc4W0w-1; Thu, 01 Aug 2024 18:12:27 -0400
X-MC-Unique: AloWJt_7PI-HHRQEBc4W0w-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b79c5c972eso9487976d6.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 15:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722550347; x=1723155147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEkakUjv0oShqAlgA+JoFFoT773rpEPOk5LHphGKBXA=;
        b=oMHqEIyZ1YIwkpsSZabHRTpyL/v/WI5fruuVJ2xX9JDmoYMWj1mxaOpMe9X/0E6P9n
         dtYFzL0QXw57D0eXiVIbu9yY4kyS74BmWLaXhCDmMsZwcYWkrgA9+I0easoc4xByk4Ss
         m7Sn140pXBxLMWILNHjyTB9NVtATn9Y4ApSLaHeCN8n6uVWDYqXyJFFtnKFUhL+K9bXv
         Y4nwSxfoYtHkmeczqKKjXy2EC8UBj0+YBhrS9ZNW9WyWGN87b0ZJDWgBRGwzxmoT4GpD
         5HA388nzJgqhies22kQ/WZ+Gwwq7CA4v0bjhzG9Amv6QIYxZR8xNcS59M5N4aJp4SU5z
         S4fg==
X-Forwarded-Encrypted: i=1; AJvYcCUIeXx/ygGlh2WZuPVaL04k0PT4YWwwa71u7uhcTHslC4hEyIdBO6ohnBItLKyTCnNMx6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCSjICoM6jnBJIYFfUHm5r8fFaUs5bSFKuedifSP8gFbVMh0db
	5U3m53fHNV2aG9hJFkSoG6zKfjgskNCbiLvX3oN1PpJnZu4gnm7wQPUG9dm/VgTzbyFaxpcjapG
	DA37rxy28b1SYSbgZ6dzbFzV14qjSwGeYaanGHSAzKV6eose+TA==
X-Received: by 2002:a05:6214:c48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bb98477071mr10740576d6.8.1722550347294;
        Thu, 01 Aug 2024 15:12:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYiPlQnhQgnszBxOlYnmcmzkuBRtiLsO/YtZH3gTULjwGEVWYGXNe4E6cY2VjLct5v9IMvig==
X-Received: by 2002:a05:6214:c48:b0:6b7:586c:2cf9 with SMTP id 6a1803df08f44-6bb98477071mr10740356d6.8.1722550346938;
        Thu, 01 Aug 2024 15:12:26 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c77099asm1039296d6.12.2024.08.01.15.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 15:12:26 -0700 (PDT)
Date: Thu, 1 Aug 2024 18:12:23 -0400
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Message-ID: <ZqwIR8HW0d0cXAhq@x1n>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>

On Wed, Jul 10, 2024 at 04:48:36PM -0700, James Houghton wrote:
> Ah, I put the wrong email for Peter! I'm so sorry!

So I have a pure (and even stupid) question to ask before the rest of
details.. it's pure question because I know little on guest_memfd,
especially on the future plans.

So.. Is there any chance guest_memfd can in the future provide 1G normal
(!CoCo) pages?  If yes, are these pages GUP-able, and mapp-able?

Thanks,

-- 
Peter Xu


