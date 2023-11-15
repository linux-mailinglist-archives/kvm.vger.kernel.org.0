Return-Path: <kvm+bounces-1812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9FA7EC0D3
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E64D5281315
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F7414F9B;
	Wed, 15 Nov 2023 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMS1Wtd9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB2FBFC
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:38:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A7109
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 02:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700044700;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=rcG7n1tgHsaIQSQt+tUDuJ97KkMlvUzZyKbsQC5/QQw=;
	b=YMS1Wtd9lj1WnFnL2jij8XO/QfrHMNFt9bR/RXMLvpidY66SMQ/KZplOk/1+SqxXWqCuQ4
	svChp3GtYifORynqaTnwyZwVTEEsxqLAiZUuGQa3ewn0jvE5k9dE8b5M/09DQ2PNCGGH1g
	xQ742Kt/DUROjx05Y+sACA0PvMxaBHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-AhCX-E2_MXGcuAz137XuOg-1; Wed, 15 Nov 2023 05:38:17 -0500
X-MC-Unique: AhCX-E2_MXGcuAz137XuOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7864101A53B;
	Wed, 15 Nov 2023 10:38:16 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8AC22166B28;
	Wed, 15 Nov 2023 10:38:12 +0000 (UTC)
Date: Wed, 15 Nov 2023 10:38:10 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
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
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Message-ID: <ZVSfkgidWqUYHHSO@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-7-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Wed, Nov 15, 2023 at 02:14:15AM -0500, Xiaoyao Li wrote:
> Introduce the helper functions to set the attributes of a range of
> memory to private or shared.
> 
> This is necessary to notify KVM the private/shared attribute of each gpa
> range. KVM needs the information to decide the GPA needs to be mapped at
> hva-based shared memory or guest_memfd based private memory.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>  include/sysemu/kvm.h |  3 +++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 69afeb47c9c0..76e2404d54d2 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -102,6 +102,7 @@ bool kvm_has_guest_debug;
>  static int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
>  static bool kvm_guest_memfd_supported;
> +static uint64_t kvm_supported_memory_attributes;
>  static hwaddr kvm_max_slot_size = ~0;
>  
>  static const KVMCapabilityInfo kvm_required_capabilites[] = {
> @@ -1305,6 +1306,44 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
>      kvm_max_slot_size = max_slot_size;
>  }
>  
> +static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
> +{
> +    struct kvm_memory_attributes attrs;
> +    int r;
> +
> +    attrs.attributes = attr;
> +    attrs.address = start;
> +    attrs.size = size;
> +    attrs.flags = 0;
> +
> +    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
> +    if (r) {
> +        warn_report("%s: failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
> +                     __func__, start, size, attr, strerror(errno));

This is an error condition rather than an warning condition.

Also again I think __func__ is generally not required in an error message,
if the error message text is suitably descriptive - applies to other
patches in this series too.

> +    }
> +    return r;
> +}
> +
> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
> +{
> +    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
> +        return -EINVAL;
> +    }
> +
> +    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +}
> +
> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
> +{
> +    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +        error_report("KVM doesn't support PRIVATE memory attribute\n");
> +        return -EINVAL;
> +    }
> +
> +    return kvm_set_memory_attributes(start, size, 0);
> +}
> +
>  /* Called with KVMMemoryListener.slots_lock held */
>  static void kvm_set_phys_mem(KVMMemoryListener *kml,
>                               MemoryRegionSection *section, bool add)
> @@ -2440,6 +2479,9 @@ static int kvm_init(MachineState *ms)
>  
>      kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
>  
> +    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
> +    kvm_supported_memory_attributes = ret > 0 ? ret : 0;
> +
>      if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>          g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
>                                                              "kvm-type",
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index fedc28c7d17f..0e88958190a4 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -540,4 +540,7 @@ bool kvm_dirty_ring_enabled(void);
>  uint32_t kvm_dirty_ring_size(void);
>  
>  int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
> +
> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
>  #endif
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


