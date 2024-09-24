Return-Path: <kvm+bounces-27374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 512AF984698
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 15:14:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B86F282142
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619371A726B;
	Tue, 24 Sep 2024 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqHgtlbJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1340A1A725D
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727183676; cv=none; b=r71eK4qDRWkJqWDg7RW9wzuCcoLMEjasuz5wJSJA3531MFJf8sz4nyVR7aWLf9h/UKzA0PPz0mdDIBMvWhF/juNdlcqEsp8a5xCnThiOXkT4TIAZ8c37vlsQ/xSprdokCbo3cCUIOCgqpPAJn6fagTC7lCBSknZg/uZqMBfEg4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727183676; c=relaxed/simple;
	bh=oNCt++NdyweqJTH4BJjb6mwsYgnFbRrfE06b0vNa9hs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfy79UPmM5o6iyscomgFzj4ycW8q3W8kmrba+YhmMp+civ8cmEZ/rnIsd2CPaad0Rng0+8UentePzq6hIDZYIlYbiB8aIuRFDq5P/r88GvnBm9MsWE3IRlR3SwtpBOlYfX176eARpVVdXV4kqbZDWfEivXNEGdxqeYCqHUVmcQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqHgtlbJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727183673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnqnOjUIPUpooUWJE3Ky/GdGjOl8rnVXhYBy8Sl0MF8=;
	b=cqHgtlbJQefK+loSz/6OZAe02FU8xaN70LMlOQumuU3xluW6Mb9qrdstKv6PhhGx7ngTfy
	9oH/9qK1hPiT7js6YiduGu8JxeUToWccOHgAQkijXnt5Ii0ds9Jl347BddAcoEWf98lzjS
	PIzXNagkUA20Ais4n6Zok7nfWHg6qU8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-jAUCEKKRNaaISZc8IRCb0w-1; Tue, 24 Sep 2024 09:14:32 -0400
X-MC-Unique: jAUCEKKRNaaISZc8IRCb0w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42e611963c2so36466555e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 06:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727183671; x=1727788471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnqnOjUIPUpooUWJE3Ky/GdGjOl8rnVXhYBy8Sl0MF8=;
        b=b2lS8LLwikw46RR4zJTjktANf7WwgxKrMcQWgWLgxvZczukbRIFt+bLCU4Gvc7YLK7
         VXPTR3nyJWnqKk1lCqWXWl/3oHtHrfYuF/zppUNMosfpkom3fufl2RZfDe9ruNh3uYrb
         jiJg5HWKtRsyUaBsDOn4TC+JRxHNpyAib/eTcJjbCoz+8PK8cGNEvAkqMJ08iSmg7391
         I26ZH3zwTrRnp19InBbDsQhUqkIBS+SBi6T+z/WcAeyszihATHn/Wz7PKBDZL/tcoBNI
         oJXpbVKCHCxCOwc+OPM6JaxPd3Fkri9WFDdS7zwjTgy6cU4wKy0PoC1yQAWUEEAUEpAv
         viLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3Q2ig/6Q6saQCTVa/ISvjn8jkteJ0reaKXMrA93A98Xx+608xe1sKdiPD5lpz2BKTuLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4nBDRdn46LiLaBMizt9cpiJ01EtgL6lam0REvGcClz4PrlVUu
	kDgI7pAtOhECc9zncgBg8bCr26P/Vyy/R79uyWqfyRgnXVPnvvwWYru4FU0zfPiEhWeSOKtFfMm
	xFJzKFC7sBWzd7iN6V+30SH9mvRlLqWbYc0b465dP8btYfe3pyw==
X-Received: by 2002:a05:600c:3d93:b0:42c:b4f1:f281 with SMTP id 5b1f17b1804b1-42e7add23b6mr116891225e9.34.1727183671467;
        Tue, 24 Sep 2024 06:14:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH02yYDg2GnwV59jQ/z5MRMzf+D+n23jjMcw2cOcouZAwzlFZRBg0waUfsQ0V7QZ7qLA1mz1w==
X-Received: by 2002:a05:600c:3d93:b0:42c:b4f1:f281 with SMTP id 5b1f17b1804b1-42e7add23b6mr116890835e9.34.1727183670954;
        Tue, 24 Sep 2024 06:14:30 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e902b65d5sm22006755e9.38.2024.09.24.06.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:14:30 -0700 (PDT)
Date: Tue, 24 Sep 2024 15:14:29 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Shiju Jose
 <shiju.jose@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eric Blake <eblake@redhat.com>, John Snow
 <jsnow@redhat.com>, Markus Armbruster <armbru@redhat.com>, Michael Roth
 <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Shannon Zhao <shannon.zhaosl@gmail.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v10 00/21] Add ACPI CPER firmware first error injection
 on ARM emulation
Message-ID: <20240924151429.3e758b38@imammedo.users.ipa.redhat.com>
In-Reply-To: <20240924150058.4879abe9@foz.lan>
References: <cover.1726293808.git.mchehab+huawei@kernel.org>
	<20240917141519.57766bb6@imammedo.users.ipa.redhat.com>
	<20240924150058.4879abe9@foz.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Sep 2024 15:00:58 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Em Tue, 17 Sep 2024 14:15:19 +0200
> Igor Mammedov <imammedo@redhat.com> escreveu:
> 
> > I'm done with this round of review.
> > 
> > Given that the series accumulated a bunch of cleanups,
> > I'd suggest to move all cleanups/renamings not related
> > to new HEST lookup and new src id mapping to the beginning
> > of the series, so once they reviewed they could be split up into
> > a separate series that could be merged while we are ironing down
> > the new functionality.   
> 
> I've rebased the series placing the preparation stuff (cleanups
> and renames) at the beginning. So, what I have now is:
> 
> 1) preparation patches:
> 
> 41709f0898e1 acpi/ghes: get rid of ACPI_HEST_SRC_ID_RESERVED
> 5409daa41c78 acpi/ghes: simplify acpi_ghes_record_errors() code
> 2539f1f662b9 acpi/ghes: better handle source_id and notification
> 3f19400549c1 acpi/ghes: Remove a duplicated out of bounds check
> f0b06ecede46 acpi/ghes: Change the type for source_id
> 9f08301ac195 acpi/ghes: Prepare to support multiple sources on ghes
> 2426cd76e868 acpi/ghes: make the GHES record generation more generic
> 3fb7ec864700 acpi/ghes: better name GHES memory error function
> 1a22dad3211e acpi/ghes: don't crash QEMU if ghes GED is not found
> 726968d4ee20 acpi/ghes: rename etc/hardware_error file macros
> f562380da7ce docs: acpi_hest_ghes: fix documentation for CPER size

> 69850f550f99 acpi/generic_event_device: add an APEI error device
this one doesn't belong to clean ups, I think.
Lets move this to #3 part

> 
> Patches were changed to ensure that they won't be add any new
> new features. They are just code shift in order to make the diff
> of the next patches smaller.
> 
> There is a small point here: the logic was simplified to only
> support a single source ID (I added an assert() to enforce it) and
> simplified the calculus in preparation for the HEST and migration
> series.
> 
> 
> 2) add a BIOS pointer to HEST, using it. The migration stuff
> will be along those:
> 
> c24f1a8708e3 acpi/ghes: add a firmware file with HEST address
> 853dce23ec39 acpi/ghes: Use HEST table offsets when preparing GHES records
> c148716fd7c8 acpi/generic_event_device: Update GHES migration to cover hest addr
> 
> Up to that, still no new features, but the offset calculus will be
> relative to HEST table and will use the bios pointers stored there;
> 
> 3) Add support for generic error inject:
> 
> f5ec0d197d82 acpi/ghes: add a notifier to notify when error data is ready
> f5e015537209 arm/virt: Wire up a GED error device for ACPI / GHES
> 3b6692dbf473 qapi/acpi-hest: add an interface to do generic CPER error injection
> 620a5a49f218 scripts/ghes_inject: add a script to generate GHES error inject
> 
> 4) MPIDR property:
> 2dd6e3aae450 target/arm: add an experimental mpidr arm cpu property object
> 02c88cd4daa2 scripts/arm_processor_error.py: retrieve mpidr if not filled
> 
> I'm still testing if the rebase didn't cause any issues. So, the above
> may still change a little bit. I also need to address your comments to the
> cleanup patches and work at the migration, but just want to double check if
> this is what you want.
> 
> If OK to you, my plan is to submit you the cleanup patches after I
> finish testing the hole series.
> 
> The migration logic will require some time, and I don't want to bother
> with the cleanup stuff while doing it. So, perhaps while I'm doing it,
> you could review/merge the cleanups.
> 
> We can do the same for each of the 4 above series of patches, as it
> makes review simpler as there will be less patches to look into on
> each series.
> 
> Would it work for you?

other than nit above, LGTM

> 
> Thanks,
> Mauro
> 


