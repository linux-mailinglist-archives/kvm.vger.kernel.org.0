Return-Path: <kvm+bounces-54011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68406B1B5E2
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E5CC188905A
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F0B278768;
	Tue,  5 Aug 2025 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QdUonT76"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2883D2701D6
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402212; cv=none; b=p2J0VYV4XaDGnKAibLP2OUlSFZPWzUKzNerazqNuw0fpRdGgG58v5EV5wIlTtP1blz/hG7eRgfcCn67qnxJCvgZNQQ1TKZ7OL2RCnGa6/H3fYTMS70rIc70V4Uf7a3h/qgisaP3Za06t+Wc+DDoUdmuC3atqJN7IgWg5UBA1dkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402212; c=relaxed/simple;
	bh=eoFCgXdGIVxRjeQjBXDlNhKB7oEq1Kg7CeUl/maXvoM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CcwQhrPZRTJlKSbgV3FIhF1+vNde5tU2D9hhpliG72N/BGn/gAEjFxLwJnJnZk650VZSaWCvOn2UTcs0t5jUcHEM+evaoyKplfcWkePB2QOeqzsfATzeXW2KeMMxUecwY+4htOPu6lbBUQ93/PDIPIXPWkDVgesKLfO8VwHGFFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QdUonT76; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754402209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sBMImFvtQXx0KH1LSSaJTNDkjVr8byYsITswFaLSx6U=;
	b=QdUonT76mZWvLqTpIUi0x7DvcI9vxFvuD88bgQzdyFwGKalOyJMMhW9KFTLQo8pta/FUEA
	9PeQ/DKUBdD2wUsWKox0YdAd/VSqETakxrbMUqBm/sZaoIAwYkfcff07V7vRlCbc/LAs+M
	Qo/Fxd88DincWoPogXqZvE5BmlZTnsw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-4RdMU3AWOMu9nLI6OVhUyQ-1; Tue, 05 Aug 2025 09:56:48 -0400
X-MC-Unique: 4RdMU3AWOMu9nLI6OVhUyQ-1
X-Mimecast-MFC-AGG-ID: 4RdMU3AWOMu9nLI6OVhUyQ_1754402207
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e3fdfa4b39so6998665ab.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402206; x=1755007006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBMImFvtQXx0KH1LSSaJTNDkjVr8byYsITswFaLSx6U=;
        b=g2OwEMxRVPkM+bMH3YpbAXgPONp0vZimBHoEVN7JeHSCjzP2kciNisv+eH3P+/ogOd
         ZF5Egjr30wBhSBG2lt/143+mEk8oWrLDnS8BEzxsH3yRHn2OMUSO3CpJxGdBUsNW5wOo
         wSqFKSCottByzdUi1QBvwmiY6A2iUWJ83k8dFIDEX6SJDnwrloX3Sbvmg1v8mLNgZZUy
         JFZCsCQEwzOhvCeZplS4X9xOBUIXxxVBonWALXQsA5pB3wk3g4TtjlUFTx3TeVoYs0z1
         gTlzDeKqFpqvAAAUKOGr3E1oWk+UNcFe1K5jLnT+QA+j1T+3Etlz5M/lKA5JaZKjJZ4x
         JmWA==
X-Gm-Message-State: AOJu0YxpsXpLGt5NMIj4ex2d+53Pq6ObNhG3g8zPKhQsZ2FAepyIuspe
	7heQqO9+oKsgp2aVlJadMRchWcpS1cb3gPglaQqo75qVZtbo+KmhjPSlPscfvD3YvqOPUcTIc+H
	oeDAQ627sk4ta+/kUb3oHbIfu+LS//7q4I1qf4cLvHy2XpknKQltrgbXGG9pJFg==
X-Gm-Gg: ASbGncvitEwEE2NzD94ePDdeRllAMk/tAK5OMHdtbbxwt4/ynEOJQMy+iuVtrhVvd9D
	MvG3P8CWEJy3sO8WdjO3gsNP/UrGfo3sBxME87UUJb2HVKum43coOV3v/9JMAA15r6TSBHXk+hM
	00dOgaSFhfQW/YNfSUJvxyJANOHjUFKrRiyKOWTYsqD1P5cJdxrQ8M/1ZXh5dogTc8mi1438hH+
	FvJ64oX3vjdFKzD+2QTb6FD1jwCIJeJJixLJeDguC0HLiAXU9mI88kjh0QIAGM/1URiVp9IAFik
	sk1kfldW3UnVetw3LsjFO2pKD6h8f94PPvxJaAffAG0=
X-Received: by 2002:a05:6e02:350d:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e4161b80cdmr67834955ab.5.1754402206047;
        Tue, 05 Aug 2025 06:56:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC4E/a+7cOr41YYeYvjQP6gDXmGehmjFaTcbUIxfyQw93bvVJzea43bqXWabl+S9LaNr1cmg==
X-Received: by 2002:a05:6e02:350d:b0:3dd:c947:b3a7 with SMTP id e9e14a558f8ab-3e4161b80cdmr67834845ab.5.1754402205576;
        Tue, 05 Aug 2025 06:56:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e402b34532sm51639715ab.56.2025.08.05.06.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 06:56:44 -0700 (PDT)
Date: Tue, 5 Aug 2025 07:56:43 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Li Zhe
 <lizhe.67@bytedance.com>
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Message-ID: <20250805075643.53aad06f.alex.williamson@redhat.com>
In-Reply-To: <7e03b04a-33da-46a9-a320-448bc80f3128@redhat.com>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
	<7e03b04a-33da-46a9-a320-448bc80f3128@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Aug 2025 15:27:35 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 05.08.25 03:24, Alex Williamson wrote:
> > Objections were raised to adding this helper to common code with only a
> > single user and dubious generalism.  Pull it back into subsystem code.
> > 
> > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Li Zhe <lizhe.67@bytedance.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---  
> 
> So, we might have a version that Linus should be happy with, that we 
> could likely place in mm/util.c.
> 
> Alex, how would you want to proceed with that?

Still reading the thread overnight, but if there's a better solution
that Linus won't balk at then let's do it.  Thanks,

Alex


