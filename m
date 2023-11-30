Return-Path: <kvm+bounces-2989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 834DA7FF8D4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 480F728175C
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6713F584E4;
	Thu, 30 Nov 2023 17:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVgBPyJq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A8106
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701366702;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=M7lfFxuqZ+h3vKtFJPLptNi2PR7iKDJ9znY3iu1jhAM=;
	b=eVgBPyJqUbze3TojYujoMMAZj/3mPPboum8Am9ndUiskIjxr/+kyIJR8f3FXN20W6T8h96
	6esJwxpsl/HNoAcG3D7rdy3UWx6Eosyey3jRI6VC7yPf2RudSNEy159l4N/87NmfMAh6Zi
	KDMuDQgtV9u9gU4V8W1yoXZ5iQiWPYs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-Ls3VJd3dMV-lQzMhbRKwmw-1; Thu,
 30 Nov 2023 12:51:39 -0500
X-MC-Unique: Ls3VJd3dMV-lQzMhbRKwmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78EFF2801A6A;
	Thu, 30 Nov 2023 17:51:38 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.74])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5274610E46;
	Thu, 30 Nov 2023 17:51:34 +0000 (UTC)
Date: Thu, 30 Nov 2023 17:51:31 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 03/70] RAMBlock/guest_memfd: Enable
 KVM_GUEST_MEMFD_ALLOW_HUGEPAGE
Message-ID: <ZWjLo57peucZMQIh@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
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
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, Nov 30, 2023 at 05:54:26PM +0100, David Hildenbrand wrote:
> On 30.11.23 17:01, Sean Christopherson wrote:
> > On Thu, Nov 30, 2023, David Hildenbrand wrote:
> > > On 30.11.23 08:32, Xiaoyao Li wrote:
> > > > On 11/20/2023 5:26 PM, David Hildenbrand wrote:
> > > > > 
> > > > > > > ... did you shamelessly copy that from hw/virtio/virtio-mem.c ? ;)
> > > > > > 
> > > > > > Get caught.
> > > > > > 
> > > > > > > This should be factored out into a common helper.
> > > > > > 
> > > > > > Sure, will do it in next version.
> > > > > 
> > > > > Factor it out in a separate patch. Then, this patch is get small that
> > > > > you can just squash it into #2.
> > > > > 
> > > > > And my comment regarding "flags = 0" to patch #2 does no longer apply :)
> > > > > 
> > > > 
> > > > I see.
> > > > 
> > > > But it depends on if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE will appear together
> > > > with initial guest memfd in linux (hopefully 6.8)
> > > > https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com/
> > > > 
> > > 
> > > Doesn't seem to be in -next if I am looking at the right tree:
> > > 
> > > https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
> > 
> > Yeah, we punted on adding hugepage support for the initial guest_memfd merge so
> > as not to rush in kludgy uABI.  The internal KVM code isn't problematic, we just
> > haven't figured out exactly what the ABI should look like, e.g. should hugepages
> > be dependent on THP being enabled, and if not, how does userspace discover the
> > supported hugepage sizes?
> 
> Are we talking about THP or hugetlb? They are two different things, and
> "KVM_GUEST_MEMFD_ALLOW_HUGEPAGE" doesn't make it clearer what we are talking
> about.
> 
> This patch here "get_thp_size()" indicates that we care about THP, not
> hugetlb.
> 
> 
> THP lives in:
> 	/sys/kernel/mm/transparent_hugepage/
> and hugetlb in:
> 	/sys/kernel/mm/hugepages/
> 
> THP for shmem+anon currently really only supports PMD-sized THP, that size
> can be observed via:
> 	/sys/kernel/mm/transparent_hugepage/hpage_pmd_size
> 
> hugetlb sizes can be detected simply by looking at the folders inside
> /sys/kernel/mm/hugepages/. "tools/testing/selftests/mm/vm_util.c" in the
> kernel has a function "detect_hugetlb_page_sizes()" that uses that interface
> to detect the sizes.
> 
> 
> But likely we want THP support here. Because for hugetlb, one would actually
> have to instruct the kernel which size to use, like we do for memfd with
> hugetlb.

Would we not want both ultimately ?

THP is good because it increases performance vs non-HP out of the box
without the user or mgmt app having to make any decisions.

It does not give you deterministic performance though, because it has
to opportunistically assign huge pages basd on what is available and
that may differ each time a VM is launched.  Explicit admin/mgmt app
controlled huge page usage gives determinism, at the cost of increased
mgmt overhead.

Both are valid use cases depending on the tradeoff a deployment and/or
mgmt app wants to make.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


