Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB7561490
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 10:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiF3IR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 04:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbiF3IQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 04:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68F7A42A35
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 01:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656576875;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=sHOROkkDPVycREOjaX84DcrqMqdz1IXTlosFpoNNS6s=;
        b=gVbW3vg6S54Zl0R6379xEnL4E9KfELuVmpjr0OaIM3QKoNY5i4xHd7gTMe32mDUx/B3CXn
        wJeBnFxJE6+cef7OAKyzCl7+lU7RTjiJaGoyNVMwK5nHxbWHqfwOVC6698V3UFC0AZSHXm
        wzifd/485dVPaW8my08v22IPPDiugtc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-fylKwONuN0SX24-oFzDzeQ-1; Thu, 30 Jun 2022 04:14:31 -0400
X-MC-Unique: fylKwONuN0SX24-oFzDzeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A06F1C00131;
        Thu, 30 Jun 2022 08:14:31 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9FDB2026D64;
        Thu, 30 Jun 2022 08:14:28 +0000 (UTC)
Date:   Thu, 30 Jun 2022 09:14:26 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Dionna Glaze <dionnaglaze@google.com>
Cc:     qemu-devel@nongnu.org, Xu@google.com, Min M <min.m.xu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Gerd Hoffman <kraxel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] target/i386: Add unaccepted memory configuration
Message-ID: <Yr1bYiA1w/lMX76k@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220629193701.734154-1-dionnaglaze@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629193701.734154-1-dionnaglaze@google.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 07:37:01PM +0000, Dionna Glaze wrote:
> For SEV-SNP, an OS is "SEV-SNP capable" without supporting this UEFI
> v2.9 memory type. In order for OVMF to be able to avoid pre-validating
> potentially hundreds of gibibytes of data before booting, it needs to
> know if the guest OS can support its use of the new type of memory in
> the memory map.

This talks about something supported for SEV-SNP, but....

>  static void
>  sev_guest_class_init(ObjectClass *oc, void *data)
>  {
> @@ -376,6 +401,14 @@ sev_guest_class_init(ObjectClass *oc, void *data)
>                                     sev_guest_set_kernel_hashes);
>      object_class_property_set_description(oc, "kernel-hashes",
>              "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_enum(oc, "accept-all-memory",
> +                                   "MemoryAcceptance",
> +                                   &memory_acceptance_lookup,
> +        sev_guest_get_accept_all_memory, sev_guest_set_accept_all_memory);
> +    object_class_property_set_description(
> +        oc, "accept-all-memory",
> +        "false: Accept all memory, true: Accept up to 4G and leave the rest unaccepted (UEFI"
> +        " v2.9 memory type), default: default firmware behavior.");
>  }

..this is adding a property to the 'sev-guest' object, which only
targets SEV/SEV-ES currently AFAIK.

The most recent patches I recall for SEV-SNP introduced a new
'sev-snp-guest' object instead of overloading the existing
'sev-guest' object:

  https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04757.html



With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

