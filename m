Return-Path: <kvm+bounces-36189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CBBA18651
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 22:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 410737A23FB
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB27C1F869D;
	Tue, 21 Jan 2025 21:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0VRsz5C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34E1AF0A6
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737493201; cv=none; b=QyFh3ia69jsdx4OCaW3Z6Wld89mCTLPpxoN/E0EGsrJraq2lTLtRx8Uv6mKbHOOhNkVTpQL99hu5cGS5jZrWjFWT4Bn5h3auGyzHfLNsiKJH4HAcfQhSFcfTjsGlCcp+JWIM7ZONAA4CdB9awDBrRB0lRJNobbvvaggeUxY2dfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737493201; c=relaxed/simple;
	bh=KCZJK3f6XJEiBtzOuCPeJqy2fWty9ozBAUwyNSH0wII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j54L7+aRECqF57DMa//ium/uYMLCP5bpdCfmlLWlznArNZ4wLu31zW4+qIoDuo4+WeSM0GDloKPtFp/z0x3AfV4Y954QN0ZfTa57E/h2E8iCnc6iiffN11cMITkzKdS30gGk4t/oPjlKadhvfD7ebJUOUlXumYac9LqCxvEU8JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0VRsz5C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737493198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6J7gV8pbKI/HEoHJpV5G2tPVyfFbSww6v2htxofYJWU=;
	b=E0VRsz5CBVwC0oYJtwL6MjXSEzBvQJPH777iWD/AE50FDU7moNh8UFM+jM2369zPEaKEuu
	Yvm+rm44pCiKNNSy5C6kpOyXOKixnBXIoYFYObaPNvOALTXGXAi5jl3i9+hNtSRoZj87+M
	MzLG3DAk3gTRrYNvlhwRebMOW76l8ug=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-2coXBQZIOo6LenOXZKixzg-1; Tue, 21 Jan 2025 15:59:57 -0500
X-MC-Unique: 2coXBQZIOo6LenOXZKixzg-1
X-Mimecast-MFC-AGG-ID: 2coXBQZIOo6LenOXZKixzg
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-467b645935fso106102311cf.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:59:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737493197; x=1738097997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6J7gV8pbKI/HEoHJpV5G2tPVyfFbSww6v2htxofYJWU=;
        b=hVKhyz00etvCPBLidio1rtcz2xmre4Fn0BcMPogszUDqQWp4oswJ9NHg0pX6Y489Km
         kz+cic2xae1abZgvbkSiYfDRf9wHdH4tDErBpZRtnpWd/jfyRUzd6yU3Rp7gf3i2EE9E
         ZTeFwjBWSRIsktvk8qzD39g0HBudvIVOQe3QGP7EgpbwMTiCF78XQTHSDMsH4sYz7k6v
         3vO/z1Tt7keWbzZDbhoKxr0WLo2J8Wa81sDuLU3PNh5657OwXtwq5rO7Zo1iTnVb3qOK
         wLuXO90ssW0nuGZFKM1bOpBDt+9FIP+VdyTaSFPu1PPec0DhCEyY6xygx3Jk92RumadF
         4Biw==
X-Forwarded-Encrypted: i=1; AJvYcCU5MEUxYfOEzdLKfPyvxsUu/EDmTHSDFTpr1D94xvg1AdPmdT8/ObYZycqteR5lO1e8wMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPvzjHBM3mc/4gT+ANO0L3hsNt7uJKO91+Xxk0tJm4c2y/NWyk
	jK2zqSdaejajK0WfzL8DBn4Z/pH2ZoSOYlaYzWdUA3kgvlQSCnS1lzaHO6FQpb5BB6AVQi4UBbK
	dEZ7PC4jZWdDwtC8LaKOsfE0fpZKLqrZnxg8L6knEKAmkO7ThiQ==
X-Gm-Gg: ASbGnctSIFPOBTzt38aC4ZTS4XyAXoX9YoGsi+hoXALwTiIsi7jtBqDy1tUkC01ytei
	mTHPIw6uKffIyagZgh4I07XDkghFmNgGt9Jih4OUaf/s7nMwutx1dVeUz1zClbFClv0H/Evo/Ok
	TYXRpSQUF4JLjtzGwFQab+OSMB1f4qXVoz3bFRhypIElbIZzVgHS3gUWMaAnAxb105PEJyaAosH
	FCN4MDkEq6+S/2c0sX50dA24+aZlneXtuM2bkJ8deOOGWqtTgrVKxa5AZG1Km4iBeGmyi6u3FWx
	qO4415ASw1S/t+2p7WyDCV50Df9tEjs=
X-Received: by 2002:ac8:57c2:0:b0:467:774b:f04b with SMTP id d75a77b69052e-46e12a93d06mr276678731cf.22.1737493197120;
        Tue, 21 Jan 2025 12:59:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEn1pBbzR5EeQZWdv4Re19JYbM8VMdhJer89dpcnaMlygc/VA0W2DHABOVvJv5pcI6iVJ8Knw==
X-Received: by 2002:ac8:57c2:0:b0:467:774b:f04b with SMTP id d75a77b69052e-46e12a93d06mr276678471cf.22.1737493196858;
        Tue, 21 Jan 2025 12:59:56 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e1030dffesm57967601cf.41.2025.01.21.12.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 12:59:56 -0800 (PST)
Date: Tue, 21 Jan 2025 15:59:53 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest
 memfd via MachineState
Message-ID: <Z5AKycFhAX523qzl@x1n>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com>
 <Z4_b3Lrpbnyzyros@x1n>
 <fa29f4ef-f67d-44d7-93f0-753437cf12cb@redhat.com>
 <Z5AB3SlwRYo19dOa@x1n>
 <bc0b4372-d8ca-4d5c-aee8-6e2521ebb2ec@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bc0b4372-d8ca-4d5c-aee8-6e2521ebb2ec@redhat.com>

On Tue, Jan 21, 2025 at 09:41:55PM +0100, David Hildenbrand wrote:
> So far my understanding is that Google that does shared+private guest_memfd
> kernel part won't be working on QEMU patches. I raised that to our
> management recently, that this would be a good project for RH to focus on.
> 
> I am not aware of real implementations of the guest_memfd backend (yet).

I see, thanks, those are pretty useful information to me.

I think I have a rough picture now.  Since I've already had some patches
going that direction, I'll give it a shot.  I'll keep you updated if I get
something.

-- 
Peter Xu


