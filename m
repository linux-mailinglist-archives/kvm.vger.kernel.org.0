Return-Path: <kvm+bounces-54030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7B1B1B9E0
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7110D17155D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 18:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D0E2586CA;
	Tue,  5 Aug 2025 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d+B9R2L4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2F19E98C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754417768; cv=none; b=n81oNQCt6MoeJ5IjqnWjHRyDGTX8uG2D/FQ6wBcTrA/g4/bBNHqHdIUp0nbq6fbdF7O+0q4jJF9xzQjw9gvrbZl7KAo8rUf0QaHXPdgJ+c366eP9pCcKG/eGfy0EB2fyVzQnm9mCf8cYnX+z5g8+/48BU2gPEq67gSGEuSS/NFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754417768; c=relaxed/simple;
	bh=k0vddngSC0JTZhapVZmL2+tGW3OQDkZKJYRHs3ah30I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqsrgaUonQOZbp1QJVSBEkSDGiY8/NWdKbX1wkUoB6zHnv2pcfEoULDEisVDuFDNpmYhjrc2XIbVrAqQMDV1mrkJ4bWULnFGAJxEsS278wiTHbIJkHwsuboV2PjDE/e3B0vKN906vQRQ34z0gayqy3/aoPVY6qJCTiaoOdRW0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d+B9R2L4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754417764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6hyg0BtDicrl7ftl4yTxmeNIhdy88dmYYEQOEIA7b8=;
	b=d+B9R2L42Sd//lhX0GICj24TNv/c4W9Dxy/vTFS0CKtHfYL1z9soQBQ9KHrDqw2w1I08xR
	bY/n8gciK+8CQdDZKBEYC4cRasDRUnkuYBypLeUclymPURlaBxUc9Isj1uY24bIMUBVWaR
	01fRCiiLG/hdbEeLZhXlU2J0skfLgOU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-w_xXzeo9PZCYjV6BuWhwQA-1; Tue, 05 Aug 2025 14:16:02 -0400
X-MC-Unique: w_xXzeo9PZCYjV6BuWhwQA-1
X-Mimecast-MFC-AGG-ID: w_xXzeo9PZCYjV6BuWhwQA_1754417762
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e51241f25eso1947475ab.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 11:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754417761; x=1755022561;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g6hyg0BtDicrl7ftl4yTxmeNIhdy88dmYYEQOEIA7b8=;
        b=txz+D/HFGyrpkhbZeVb3pd/c1Qg41mtKxedldA2TVFNfoqBkgsl7t/F84/ViFJOZfB
         2Ed9bh8/vGKEk1FxxGRU1MLKHZT36CruM/3JljrP6qo7NmZDoVLeubAixIrMRa8O5d5e
         wSos1Xyyrjsx+9v9DR+PcoI8s+HC1tWfw8LkdONw5U4LnVljOXHhh870uZ5rLFBV1shj
         iZIjVLWXmqbunm3AoXlV/xIt8gEayMxTP5zs8rgO3RmrX0PnOvWy3lG6SBxNStGF54RC
         CfXSLpLiKkyuDOI4e3XLl0B1VNCMw+LWXJuii6e10rysUoJxQ7f/iDsR52GUP58z5cSx
         olqA==
X-Gm-Message-State: AOJu0YwLoh1AKHT9aZiqsFW1vrKphXLwuS1tyavqVcGmPKVJSlFswE8Y
	6+fKcdGuu0zpSXJNI6l0hxTDrdVZEousZJqKVrtHq2NUoENUDns0Zggl0fN3Ri6lKSBv2ggAa30
	VaDSeGN8iunKp7mGEE+oi0G+ocH5adeuYik0sX/LKuzv5J8UsbWW1upjVWLFt/Q==
X-Gm-Gg: ASbGncsWhewDfFVbsIlQUGMUe22UhlpIrQ2QmIjZAZtBfn0U7tn//yHpUgBy8780rn8
	ZZfy25MC0/kYlfUWJRuqvVsNopee/q9MEqZ9JN11PfLOQP/CNi+WCLbCoWbt1z3GyYnoOe3uSCb
	gdTlImzjHcJV1gcwx55Gk+cC1I/ABsfa6Ex/77bUQIQyUUAabhQbgD4jPM741vOvJ2WLdgiPnr9
	0vpfzw4EeXQ/NCJv0B9dQd3jrOpg2GzyfBQrUQeWHbVRDvCYoAhJlueEtpOJuYUSlIjHMhT05zw
	iMeyG3z45616EyaZtKmuaAkUf32y4HRweWWz3t822f8=
X-Received: by 2002:a92:ca45:0:b0:3e2:9275:60dc with SMTP id e9e14a558f8ab-3e4161ccbe6mr81349515ab.7.1754417761372;
        Tue, 05 Aug 2025 11:16:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVhk8I3P0372EAqZr8kz+L+EGpago5dhn4wr8y4oz+JBaOPqG5y8NS/4HcQnxFZoR5tD7tfg==
X-Received: by 2002:a92:ca45:0:b0:3e2:9275:60dc with SMTP id e9e14a558f8ab-3e4161ccbe6mr81349325ab.7.1754417760901;
        Tue, 05 Aug 2025 11:16:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e50f2451f6sm12548915ab.43.2025.08.05.11.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 11:15:59 -0700 (PDT)
Date: Tue, 5 Aug 2025 12:15:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Li Zhe
 <lizhe.67@bytedance.com>
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Message-ID: <20250805121558.5f86b5ac.alex.williamson@redhat.com>
In-Reply-To: <20250805075643.53aad06f.alex.williamson@redhat.com>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
	<7e03b04a-33da-46a9-a320-448bc80f3128@redhat.com>
	<20250805075643.53aad06f.alex.williamson@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 Aug 2025 07:56:43 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 5 Aug 2025 15:27:35 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
> > On 05.08.25 03:24, Alex Williamson wrote:  
> > > Objections were raised to adding this helper to common code with only a
> > > single user and dubious generalism.  Pull it back into subsystem code.
> > > 
> > > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > > Cc: Li Zhe <lizhe.67@bytedance.com>
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---    
> > 
> > So, we might have a version that Linus should be happy with, that we 
> > could likely place in mm/util.c.
> > 
> > Alex, how would you want to proceed with that?  
> 
> Still reading the thread overnight, but if there's a better solution
> that Linus won't balk at then let's do it.  Thanks,

How soon were you thinking of sending an alternate proposal?  I don't
want to make this any messier, but this patch gives us some breathing
room for the merge window.  Thanks,

Alex


