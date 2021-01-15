Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990B52F7C89
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbhAON0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:26:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbhAON0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610717108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqVraxmBxo/QEMnN9aS1B5uOZPCcZuh8wG8HP5EzsXo=;
        b=AIWBNR68l0EeMp6wvKGEVA/3OLnWaM90sun5551UvUXpC9c1aa5kfv/2fCSJyjJE41bhJc
        ankk2arQc01XT1LvXUYf+pPtSK1vvzfgqEICVXhdYl+bUMVvf9OYcpwgVFauEcoxXUqEDI
        oeCX/UdWkrrxcNSjO1PNlAyT5FQI2tQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-ptmG1eohN56WS8l6Cr87RQ-1; Fri, 15 Jan 2021 08:25:04 -0500
X-MC-Unique: ptmG1eohN56WS8l6Cr87RQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15EBACE665;
        Fri, 15 Jan 2021 13:25:02 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22FF06F44C;
        Fri, 15 Jan 2021 13:24:27 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:24:25 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 08/13] confidential guest support: Move SEV
 initialization into arch specific code
Message-ID: <20210115142425.540b6126.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-9-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-9-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:06 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> While we've abstracted some (potential) differences between mechanisms for
> securing guest memory, the initialization is still specific to SEV.  Given
> that, move it into x86's kvm_arch_init() code, rather than the generic
> kvm_init() code.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c   | 14 --------------
>  accel/kvm/sev-stub.c  |  4 ++--
>  target/i386/kvm/kvm.c | 12 ++++++++++++
>  target/i386/sev.c     |  7 ++++++-
>  4 files changed, 20 insertions(+), 17 deletions(-)
> 

(...)

> @@ -2135,6 +2136,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      uint64_t shadow_mem;
>      int ret;
>      struct utsname utsname;
> +    Error *local_err = NULL;
> +
> +    /*
> +     * if memory encryption object is specified then initialize the
> +     * memory encryption context (no-op otherwise)
> +     */
> +    ret = sev_kvm_init(ms->cgs, &local_err);

Maybe still leave a comment here, as the code will still need to be
modified to handle non-SEV x86 mechanisms?

> +    if (ret < 0) {
> +        error_report_err(local_err);
> +        return ret;
> +    }
>  
>      if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
>          error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 3d94635397..aa79cacabe 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -664,13 +664,18 @@ sev_vm_state_change(void *opaque, int running, RunState state)
>  
>  int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  {
> -    SevGuestState *sev = SEV_GUEST(cgs);
> +    SevGuestState *sev
> +        = (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);

This looks a bit ugly; maybe we want the generic code to generate a
separate version of the cast macro that doesn't assert? Just cosmetics,
though.

>      char *devname;
>      int ret, fw_error;
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
>  
> +    if (!sev) {
> +        return 0;
> +    }
> +
>      ret = ram_block_discard_disable(true);
>      if (ret) {
>          error_report("%s: cannot disable RAM discard", __func__);

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

