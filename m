Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF24D4349
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 10:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbiCJJSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 04:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiCJJSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 04:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BEA0133958
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 01:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646903867;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=K1oHDE2zEJ3OzOLvIxaERL60v91ZzjYYqlVixsRYN5Q=;
        b=XfQ3V7RA5vrRhAHkVgHnS6biJQvmpRvk6YKTsRxUSJhZjRU1frKD32AJp1ChToGCtNgyBW
        vBH87xd7X+1bQXMgDa6eKsokDEkkCKtD2gV5VsWdIR5UFGCf7BcvfqVL65vrPZNKma5FtR
        QoY4sGWB7SGsnT9TFKlDQZUpM8teY8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-mlJUzm46PZekj6cxtm8mIA-1; Thu, 10 Mar 2022 04:17:44 -0500
X-MC-Unique: mlJUzm46PZekj6cxtm8mIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8605B801AB2;
        Thu, 10 Mar 2022 09:17:43 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39B6A7FCF2;
        Thu, 10 Mar 2022 09:17:21 +0000 (UTC)
Date:   Thu, 10 Mar 2022 09:17:19 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH 2/2] i386: Add notify VM exit support
Message-ID: <YinCH/GbShwG1fRF@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220310090205.10645-1-chenyi.qiang@intel.com>
 <20220310090205.10645-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220310090205.10645-3-chenyi.qiang@intel.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 05:02:05PM +0800, Chenyi Qiang wrote:
> There are cases that malicious virtual machine can cause CPU stuck (due
> to event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
> IRQ) can be delivered. It leads the CPU to be unavailable to host or
> other VMs. Notify VM exit is introduced to mitigate such kind of
> attacks, which will generate a VM exit if no event window occurs in VM
> non-root mode for a specified amount of time (notify window).
> 
> A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
> so that the user can query the capability and set the expected notify
> window when creating VMs.
> 
> If notify VM exit happens with VM_INVALID_CONTEXT, hypervisor should
> exit to user space with the exit reason KVM_EXIT_NOTIFY to inform the
> fatal case. Then user space can inject a SHUTDOWN event to the target
> vcpu. This is implemented by defining a new bit in flags field of
> kvm_vcpu_event in KVM_SET_VCPU_EVENTS ioctl.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  hw/i386/x86.c         | 24 ++++++++++++++++++
>  include/hw/i386/x86.h |  3 +++
>  target/i386/kvm/kvm.c | 58 ++++++++++++++++++++++++++++---------------
>  3 files changed, 65 insertions(+), 20 deletions(-)
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index b84840a1bb..25e6c50b1e 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -1309,6 +1309,23 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
>      qapi_free_SgxEPCList(list);
>  }
>  
> +static void x86_machine_get_notify_window(Object *obj, Visitor *v,
> +                                const char *name, void *opaque, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +    int32_t notify_window = x86ms->notify_window;
> +
> +    visit_type_int32(v, name, &notify_window, errp);
> +}
> +
> +static void x86_machine_set_notify_window(Object *obj, Visitor *v,
> +                               const char *name, void *opaque, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +
> +    visit_type_int32(v, name, &x86ms->notify_window, errp);
> +}
> +
>  static void x86_machine_initfn(Object *obj)
>  {
>      X86MachineState *x86ms = X86_MACHINE(obj);
> @@ -1319,6 +1336,7 @@ static void x86_machine_initfn(Object *obj)
>      x86ms->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
>      x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>      x86ms->bus_lock_ratelimit = 0;
> +    x86ms->notify_window = -1;
>  }

IIUC from the kernel patch, this negative value leaves the protection
disabled, and thus the host remains vulnerable to the CVE. I would
expect this ought to set a suitable default value to fix the flaw.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

