Return-Path: <kvm+bounces-53753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 431FAB167B7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 22:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6B621AA796E
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F6722068F;
	Wed, 30 Jul 2025 20:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Stc3/T/o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4EA21480B
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 20:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908027; cv=none; b=nvXoWLrZZQ8Czva8MXoLitx1ZYWfqmwDoZSgD8vSS/CLkpi6T6WTitkLLWEYhjne+s7HKKV7OUgzISxE9me86P48QoxRVItzT8Xj5+0xTZPLxzljeX7TfAOSK6yy8HbErTT3fEXhyuB56GYb0RXI6yN8PfV/4GS5afBHtBf6hUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908027; c=relaxed/simple;
	bh=71z9nz1SazSbnGETgS/q1QZ4Nh8tsA4x2VL4V/UunFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DiHyeeMQG6z9PhP73mkpiUgX+lVqEGg64YtJ51ftB2sOpdzv6tJF/LaKH7G0tWUawYOlgMnNF+Y2ZePVEAqDecwTb41Ef2ImbZlDgC0rEXYIxf3KsDz3NoOaQhJs6BkONX2HhfsIt9WWUD3IhZ+yhzjoQ+7VR7qXYPmPDb5jMCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Stc3/T/o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753908025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7voUKJEziP4gYQC4nbgcda7fc7MAe7oj208rMHgMhl0=;
	b=Stc3/T/oY6oWIrM7WVQQycEXIU0PsBXC4J/TgCohQFU6s/l9OLgKl8oQbl5ZbMUcjhiC+y
	uWDr/WqJR4KBBWeZ68GlgZRK7lAMNy+z4DjoLFJcIfHLC2X/8BJZ6vy4vFIvDuoQ98yktC
	ioX0czOkPaMwOKOSbYTGSt6vzkil+XA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-VpFreBR-M-qc7wkiGmLqkA-1; Wed, 30 Jul 2025 16:40:23 -0400
X-MC-Unique: VpFreBR-M-qc7wkiGmLqkA-1
X-Mimecast-MFC-AGG-ID: VpFreBR-M-qc7wkiGmLqkA_1753908023
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7e623a209e0so40892185a.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 13:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908023; x=1754512823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7voUKJEziP4gYQC4nbgcda7fc7MAe7oj208rMHgMhl0=;
        b=mPik9/AYety/mpPGF+PsZUtP0yP0F9/ghD+2ykqs4aav1SGbvw1TMLm25/saOAMqse
         nYXNWl31NVpjTXG5KSOHmQiIEDoAsWeIfVTq0en7MywwpeesgHoI8h+W0mWGFtUqQEA4
         lx393ZCfkSRtg6c8TaqezfaDYtMUiwT8EdT3rcgXWhCWuh/NPUquGkKHxZ9RoHbo7ukS
         fm6KAHzAigRZkMwAMGoFwbVeH2IViTwHhjXEL09qafQcPGbBwJ8LeyBfoOYIlGB1teNk
         Lnw4yelMpCPVssi7kTbWAEwZ8V2110E1cqWKIxrWVv/YXnFQCJwRTB1fKffNYEfCOcUr
         6gNw==
X-Gm-Message-State: AOJu0Yy7LR6g4gSITIMQRYzrIv4AoRFqOKSAz6OJ2c3ALZKs9fAcPt76
	3gTlxemVJc5082xaZ3KmNYi1+whUq6vYnnc4HrVD+VK2kP928JYiVwIDSY8QLuJD4rJwYzluD4D
	7kq6mFgaqu+sgMp0R2J7VKz9lVR8AgBwunRHCHBWiitMZA5UF6Vwb9A==
X-Gm-Gg: ASbGnctet7thAyhPZWPbVbmK8P5XxNXYwT+4vA6CGw/ReerKVeX6rkEqIr6BbkWqp3E
	FRGLo0XMWd7uhfmkRkydZJnRnzY6nR0IMQNdnHTAeW78aQZ8lN1uinrClWLdQ3q4pmiRWJesIzh
	WOaQZ9K+NiwsPZ7ZGYwO9S7wfA9McqXvhYwOKwuN5xFT8q87PcSeg9FvczvqOOfY3vligv+tmWE
	+nomLIsl29w5hnSCkBscb/wkZHadAkAcB9PkWuGTaT6FUTXW1Ljp+cGkjLBo+egFsjwzmZWwTYl
	RWPvcABT7nTI7/tgJHkP7SZA3xrlKeL4
X-Received: by 2002:a05:620a:192a:b0:7e3:47f2:1057 with SMTP id af79cd13be357-7e66efdc94amr595223885a.28.1753908022952;
        Wed, 30 Jul 2025 13:40:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn9SKs+cnnyfHQ2ScuL+V7W/OU+J4uSzVHsL7404gmVb8UjRY5LeDXZuKkfDU4b7/kdOGDCg==
X-Received: by 2002:a05:620a:192a:b0:7e3:47f2:1057 with SMTP id af79cd13be357-7e66efdc94amr595220785a.28.1753908022541;
        Wed, 30 Jul 2025 13:40:22 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f5b52f2sm2528185a.24.2025.07.30.13.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 13:40:22 -0700 (PDT)
Date: Wed, 30 Jul 2025 16:40:10 -0400
From: Peter Xu <peterx@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 2/5] x86: fix APs with APIC ID more
 that 255 not showing in id_map
Message-ID: <aIqDKsAvt322aj-G@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
 <20250725095429.1691734-3-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725095429.1691734-3-imammedo@redhat.com>

On Fri, Jul 25, 2025 at 11:54:26AM +0200, Igor Mammedov wrote:
> save_id() is called too early and uses xapic ops, which is fine
> up to 2566 cpus.
> However with that any CPU with APIC ID more than 255 will set
> wrong bit in online_cpus (since xapic ops only handle 8bit IDs,
> thus losing all higher bit x2apic might have).
> As result CPUs with id higher than 255 are not registered
> (they will trumple over elements in range 0-255 instead).
> 
> To fix it move save_id() after the point where APs have
> switched to x2apic ops, to get non-truncated ID.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


