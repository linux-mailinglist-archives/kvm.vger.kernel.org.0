Return-Path: <kvm+bounces-2987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3487FF8BA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E0DA1C210B5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F64584F2;
	Thu, 30 Nov 2023 17:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvTOw9Te"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79835170B
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701366415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=36I5dLdDPjWyeCL12KYtafeS98q0dzJu36IdMWUqn0o=;
	b=HvTOw9Te/tsB5B2gyZRSAw/MMzsEigbmUMCaLE7DJztwZduu5TCs19JPgD/FmoG9Uar1wn
	2u8SpVaUUopTA3VN9omv8K9/a/ycIBqXFevPD71f8aLAkdOmCZdmqo7kWvbZb4rsDFJt+F
	nXm5rh3EZvQcbLeRlyrGWUG7Vv78ljk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-0KZvH79SPp-U2-4yG3NDjw-1; Thu, 30 Nov 2023 12:46:52 -0500
X-MC-Unique: 0KZvH79SPp-U2-4yG3NDjw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-67a05428cceso3666656d6.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701366411; x=1701971211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36I5dLdDPjWyeCL12KYtafeS98q0dzJu36IdMWUqn0o=;
        b=Jq7/hNYs1pGqGs0ifkWcsblgWEQlzUJhvo9Dy39x0dr91igfx4WFy8BZpxK+/IIwgx
         jE8lE0fFXIpCLgBntswTKoNNPBvxWNZ1l5MkgOuiFuFs56+V/xLvCOPF+d/nMZ6EibFV
         u69uuBCsSyGbc6KxBZEzPrIgdOTY8iUAXAeEa5UeQxEBp6TzRRwfZrzx99fyUAt6Lqyd
         Vh7gV+ujAr4Yd4KjwX+s/IWZB88WmrLv9o4bJcRb/JacwUkpiNp0m32Y4a3X77hadjIV
         D0GhNcHqSYD8DFmQyVhFt6wrizwtVavbEBoOFrWIiwxqboB1Liq8k7uAT8/heIU/VwkY
         qDfQ==
X-Gm-Message-State: AOJu0YxgBz1HbrZLtUHdk3yzsb1QZkgamzkwW9A2I6VwVNELylUr2OWY
	4vePHlnfv1xrxnHogM9NLufmdiunz0g1EIVDFTGZW4V89tipYvgBCjz/2yvmhQAGK1sB2oO4lgw
	dsWGWA+fwq0j9
X-Received: by 2002:ad4:4085:0:b0:67a:1673:fec4 with SMTP id l5-20020ad44085000000b0067a1673fec4mr23023347qvp.2.1701366411716;
        Thu, 30 Nov 2023 09:46:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrwAfPkyoM5agFa8bqH8//SMn/Txut1an3SMNcAFFZOVZCrPk5A8jIwhA4JHR7Kt/V7x+pIQ==
X-Received: by 2002:ad4:4085:0:b0:67a:1673:fec4 with SMTP id l5-20020ad44085000000b0067a1673fec4mr23023320qvp.2.1701366411412;
        Thu, 30 Nov 2023 09:46:51 -0800 (PST)
Received: from x1n (cpe688f2e2cb7c3-cm688f2e2cb7c0.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id ka7-20020a05622a440700b00423f1cc1227sm681028qtb.43.2023.11.30.09.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:46:50 -0800 (PST)
Date: Thu, 30 Nov 2023 12:46:48 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Message-ID: <ZWjKiDy3UMq3cRkD@x1n>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-4-xiaoyao.li@intel.com>
 <bc84fa4f-4866-4321-8f30-1388eed7e64f@redhat.com>
 <05f0e440-36a2-4d3a-8caa-842b34e50dce@intel.com>
 <0fbfc413-7c74-4b2a-bade-6f3f04ca82c2@redhat.com>
 <4708c33a-bb8d-484e-ac7b-b7e8d3ed445a@intel.com>
 <45d28654-9565-46df-81b9-6563a4aef78c@redhat.com>
 <ZWixXm-sboNZ-mzG@google.com>
 <d6bfd8be-7e8c-4a95-9e27-31775f8e352e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6bfd8be-7e8c-4a95-9e27-31775f8e352e@redhat.com>

On Thu, Nov 30, 2023 at 05:54:26PM +0100, David Hildenbrand wrote:
> But likely we want THP support here. Because for hugetlb, one would actually
> have to instruct the kernel which size to use, like we do for memfd with
> hugetlb.

I doubt it, as VM can still leverage larger sizes if possible?

IIUC one of the major challenges of gmem hugepage is how to support
security features while reusing existing mm infrastructures as much as
possible.

Thanks,

-- 
Peter Xu


