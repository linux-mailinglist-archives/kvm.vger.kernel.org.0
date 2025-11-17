Return-Path: <kvm+bounces-63413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A98DC65FF8
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 45B7C3529BC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E48E1330323;
	Mon, 17 Nov 2025 19:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fHRYNkvo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="geEMxhT6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A54A32E6BB
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 19:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763408357; cv=none; b=tX7ExIAgQJ6G3dtHsEnfO5rLMFKbdQZLiW1YsroEALRILmbW38aWT/ug5R4fHslTNSbRFGGp99PS31CoccvfOA8AkuCiT35oF0UIUrlkGFj0T7/AIuyRfV67xbQguq0KbD2OKy+S5/1f86LmfI6sMiO+aaQkX6RfwCpmyZtO0J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763408357; c=relaxed/simple;
	bh=29tvvpCD+qGhy6fyzBHvXQq3vnNQo5h2KbSk1H50wjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4slfAFhve5m0lohDcgeKZmR01HWlqRF8YieFtYbkI+IF6ryCVnJSdVHC7K3Mq3oH500Ha1jOgVGmkMZMXE+WpU0nvqAHT1pCoVXXucjBzBji9R6qb78firJynhmsjsa7pC1D4Dgf0jnTDAYznkPDLcVe62CnMyH3OAtTSpymfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fHRYNkvo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=geEMxhT6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763408354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
	b=fHRYNkvovEOwI19aLegWFDshRutfapMMWpr+zNIKsZMAEDmBKi0+Wzu5v/FBTAJ5PnB+g5
	Uo4G2LzV0/F4Bk4gQpZFgT/npYU92dB+7mj/lqanh8Kcq2wpDsTD0pemGeJRUlWu/53Bl3
	OrrI7OleWh88XM10CZhxwwueZnE4/8I=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-xMLx9ACeNvaoNcSzSZTU6g-1; Mon, 17 Nov 2025 14:39:11 -0500
X-MC-Unique: xMLx9ACeNvaoNcSzSZTU6g-1
X-Mimecast-MFC-AGG-ID: xMLx9ACeNvaoNcSzSZTU6g_1763408351
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8804b991a54so144703296d6.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 11:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763408351; x=1764013151; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
        b=geEMxhT6OC9PKaHjaYOkGjoxff60Ds5axjcfCP5UxrqV/LYE60W8sffaN3UKg0mRWZ
         mB7a4hNuIdAenpAvNxobzQ0/fo7qabyj8K73rHE2xwK4vDz+rq1ri67wV81EYSyca40v
         RmKMKKp+c/rhK4tUuA4qIPTGcAwv2oueXK/cGCujbsY3vjWrRUBR0tyvBPn+YBPFoWrH
         dfQ4DVsHcGp9X0/hQ0OZT4SJ0DRBmwURbdPQEFnUuef1ldAU+9wLRDyF71rr7k3zbTla
         Zbi4HApC5h8+whMNHHQSR8qbrTvJWPiRYAIuFjP2GTtLgpOVWmh3/kdcoA/fMOZ+s5Ph
         gZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763408351; x=1764013151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
        b=kmEi2xBmfljD5MdXnYPaXtF5fkee+1LmARIUl23atq2dg1orFgi7nCYMqBpnb/E+9T
         Av0XCBbX0VLzPY9yVtx/+wZvp06By/rQcBAfd2CPIFxkVC4MLtINYgFiSyM8c/d7EjHR
         6c/vdIaaWNiw+jaG0zQyPgSc0fWMNiP+4kwtKB9kLv5gvumCLSZ9GpjxgZovTNdiruwb
         IaB3cu1Pb9zyfB84aUnUzie4lRaN5sd2MSflg2zx7VhMvVUEEvgwYOtxYKPJxNHiFJW4
         ewfCEwwyuBElDdQEyUkLEA2QQYUXyGpsZrNVIwsAxHAo3l0DJf39g8WX4nkBwNxq5MGQ
         oNDg==
X-Forwarded-Encrypted: i=1; AJvYcCX+BGkKx3Mwo8B96sYY78xsQyZZ46vLj0H8XLVGzHwj//rlMpD1hQn/SgUca9fXgQgHf8w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3QMQj22SEzecKqIQwP9M6Q2WFF2Pe8bIkTUroqIbpbKmZn1tz
	dKfPwwAvTIN7K+wbRAJ56bzxxrEWNd5a4NMZsSzmonIebRqqSEuNvlSDtDWIQiTbHT5cpz4o9lt
	7PH0/aTc0m42aOFra1/sm03ixBcDh5LTTne+7ejt95MlH6HhRr4tKBQ==
X-Gm-Gg: ASbGncsEAYjImZ4GKAmBnFP9MgIyo/Eamuzgqofut55hK04qzCC+0pbUfYxwulEuPyX
	jY2/luZJ1mrHvsctvV/8QQLwGQmkPRzSm8aoY2XBzT2Y0w/uGfb5ombdSl1YfqCf4XN9kmPwSt/
	qshlck6FKsjlMFA9C8RwkavGAxxHjiJzWPpDsTg1QF+JzjkHu3AZ+tSBlEZSuHu1UMnklvURvyE
	UV3/4FLoNefojoD6G0TsNP62Uj5/V69x4TJAzJmQhWHI3kmFcC7kujS6D3Xf6iub6SI0dEeFfzR
	bubDQ1Iz3qamb4WXTHNFcqrWJu/UUU4vFsoaszHwHEr3N6NPEoPiLRQAlcjc+7/7oz9KZFgwohi
	7mw==
X-Received: by 2002:a05:6214:c28:b0:802:a79d:3132 with SMTP id 6a1803df08f44-8829267c1c6mr192021196d6.47.1763408351074;
        Mon, 17 Nov 2025 11:39:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdehJMTGS035Eb/OzG7cG5rRd+07wCiKuKE4YM34HxqUOjomc6mUNHGC8OLoiF8h+l5gT9Zw==
X-Received: by 2002:a05:6214:c28:b0:802:a79d:3132 with SMTP id 6a1803df08f44-8829267c1c6mr192020686d6.47.1763408350619;
        Mon, 17 Nov 2025 11:39:10 -0800 (PST)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828658ae99sm97099586d6.48.2025.11.17.11.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 11:39:10 -0800 (PST)
Date: Mon, 17 Nov 2025 14:39:06 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] mm, kvm: add guest_memfd support for uffd minor
 faults
Message-ID: <aRt52tDCh72ytIp1@x1.local>
References: <20251117114631.2029447-1-rppt@kernel.org>
 <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com>

On Mon, Nov 17, 2025 at 05:55:46PM +0000, Nikita Kalyazin wrote:
> In our use case, Firecracker snapshot-restore using UFFD [1], we will use
> UFFD minor/continue to respond to guest_memfd faults in user mappings
> primarily due to VMM accesses that are required for PV (virtio) device
> emulation and also KVM accesses when decoding MMIO operations on x86.

I'm curious if firecracker plans to support live snapshot save.  When with
something like ioctls_supported flags, guest-memfd can declare support for
wr-protect support easily too, and synchronous userfaultfd wr-protect traps
will be an efficient way to do live save.

I'm guessing it's not an immediate demand now or it would have been asked
already supporting both MINOR and WP, but I just want to raise this
question.  Qemu already supports live snapshot save, so it'll always be
good gmem can also support wp at some point, but it can be done later too.

Thanks,

-- 
Peter Xu


