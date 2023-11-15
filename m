Return-Path: <kvm+bounces-1839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A788E7ECA1F
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 18:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 236651F28040
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 17:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CCF3DB8F;
	Wed, 15 Nov 2023 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MT5dkelq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF75E1A8
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700071105;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=QDScL5roc4g5L03ZAfMhXcakH3uxr6va8ZZ65BPJ5b0=;
	b=MT5dkelqLlJzLuF2kSjMBiICdjCMhA3SU0YnArE5K3cz6XJkzPw0S32xf79a6iq4di8scz
	Df7OMucwMkeBUMERLJ7OrHrmlDeqsh/RGw6AO0lDdJVzDnna3RCD6L54kJ7BnBLtoVhkS6
	UJ81jXkN8FW7IvNFOVliWHHq6H1cSJA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-HoHciA5eOoGhwPH7ZN57IQ-1; Wed, 15 Nov 2023 12:58:22 -0500
X-MC-Unique: HoHciA5eOoGhwPH7ZN57IQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88E96101A529;
	Wed, 15 Nov 2023 17:58:21 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2020236EE;
	Wed, 15 Nov 2023 17:58:16 +0000 (UTC)
Date: Wed, 15 Nov 2023 17:58:14 +0000
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
Subject: Re: [PATCH v3 52/70] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <ZVUGtpZDTW27F8Um@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-53-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For GetQuote, delegate a request to Quote Generation Service.
> Add property "quote-generation-socket" to tdx-guest, whihc is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
> 
> On request, connect to the QGS, read request buffer from shared guest
> memory, send the request buffer to the server and store the response
> into shared guest memory and notify TD guest by interrupt.
> 
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
>     -machine confidential-guest-support=tdx0
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
> - rename property "quote-generation-service" to "quote-generation-socket";
> - change the type of "quote-generation-socket" from str to
>   SocketAddress;
> - squash next patch into this one;
> ---
>  qapi/qom.json         |   5 +-
>  target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h |   6 +
>  3 files changed, 440 insertions(+), 1 deletion(-)
> 
> +static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
> +{
> +    struct tdx_get_quote_task *t = opaque;
> +    Error *err = NULL;
> +    char *in_data = NULL;
> +    MachineState *ms;
> +    TdxGuest *tdx;
> +
> +    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
> +    if (qio_task_propagate_error(task, NULL)) {
> +        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
> +        goto error;
> +    }
> +
> +    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
> +    if (!in_data) {
> +        goto error;
> +    }
> +
> +    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
> +                           MEMTXATTRS_UNSPECIFIED, in_data,
> +                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
> +        goto error;
> +    }
> +
> +    qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);

You've set the channel to non-blocking, but....

> +
> +    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
> +                              le32_to_cpu(t->hdr.in_len), &err) ||
> +        err) {

...this method will block execution of this thread, by either
sleeping in poll() or doing a coroutine yield.

I don't think this is in coroutine context, so presumably this
is just blocking.  So what was the point in marking the channel
non-blocking ?

You are setting up a background watch to wait for the reply
so we don't block this thread, so you seem to want non-blocking
behaviour.

Given this, you should not be using qio_channel_write_all()
most likely. I think you need to be using qio_channel_add_watch
to get notified when it is *writable*, to send 'in_data'
incrementally & non-blocking. When that is finished then create
another watch to wait for the reply.


> +        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
> +        goto error;
> +    }
> +
> +    g_free(in_data);
> +    qemu_set_fd_handler(t->ioc->fd, tdx_get_quote_read, NULL, t);
> +
> +    return;
> +error:
> +    t->hdr.out_len = cpu_to_le32(0);
> +
> +    if (address_space_write(
> +            &address_space_memory, t->gpa,
> +            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
> +        error_report("TDX: failed to update GetQuote header.\n");
> +    }
> +    tdx_td_notify(t);
> +
> +    qio_channel_close(QIO_CHANNEL(t->ioc), &err);
> +    object_unref(OBJECT(t->ioc));
> +    g_free(t);
> +    g_free(in_data);
> +
> +    /* Maintain the number of in-flight requests. */
> +    ms = MACHINE(qdev_get_machine());
> +    tdx = TDX_GUEST(ms->cgs);
> +    qemu_mutex_lock(&tdx->lock);
> +    tdx->quote_generation_num--;
> +    qemu_mutex_unlock(&tdx->lock);
> +    return;
> +}
> +
> +static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
> +{
> +    hwaddr gpa = vmcall->in_r12;
> +    uint64_t buf_len = vmcall->in_r13;
> +    struct tdx_get_quote_header hdr;
> +    MachineState *ms;
> +    TdxGuest *tdx;
> +    QIOChannelSocket *ioc;
> +    struct tdx_get_quote_task *t;
> +
> +    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
> +
> +    /* GPA must be shared. */
> +    if (!(gpa & tdx_shared_bit(cpu))) {
> +        return;
> +    }
> +    gpa &= ~tdx_shared_bit(cpu);
> +
> +    if (!QEMU_IS_ALIGNED(gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
> +        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
> +        return;
> +    }
> +    if (buf_len == 0) {
> +        return;
> +    }
> +
> +    if (address_space_read(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
> +                           &hdr, sizeof(hdr)) != MEMTX_OK) {
> +        return;
> +    }
> +    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
> +        return;
> +    }
> +    /*
> +     * Paranoid: Guest should clear error_code and out_len to avoid information
> +     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
> +     * process the request.
> +     */
> +    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
> +        le32_to_cpu(hdr.out_len) != 0) {
> +        return;
> +    }
> +
> +    /* Only safe-guard check to avoid too large buffer size. */
> +    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
> +        le32_to_cpu(hdr.in_len) > TDX_GET_QUOTE_MAX_BUF_LEN ||
> +        le32_to_cpu(hdr.in_len) > buf_len) {
> +        return;
> +    }
> +
> +    /* Mark the buffer in-flight. */
> +    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
> +    if (address_space_write(&address_space_memory, gpa, MEMTXATTRS_UNSPECIFIED,
> +                            &hdr, sizeof(hdr)) != MEMTX_OK) {
> +        return;
> +    }
> +
> +    ms = MACHINE(qdev_get_machine());
> +    tdx = TDX_GUEST(ms->cgs);
> +    ioc = qio_channel_socket_new();
> +
> +    t = g_malloc(sizeof(*t));
> +    t->apic_id = tdx->event_notify_apic_id;
> +    t->gpa = gpa;
> +    t->buf_len = buf_len;
> +    t->out_data = g_malloc(t->buf_len);
> +    t->out_len = 0;
> +    t->hdr = hdr;
> +    t->ioc = ioc;
> +
> +    qemu_mutex_lock(&tdx->lock);
> +    if (!tdx->quote_generation ||
> +        /* Prevent too many in-flight get-quote request. */
> +        tdx->quote_generation_num >= TDX_MAX_GET_QUOTE_REQUEST) {
> +        qemu_mutex_unlock(&tdx->lock);
> +        vmcall->status_code = TDG_VP_VMCALL_RETRY;
> +        object_unref(OBJECT(ioc));
> +        g_free(t->out_data);
> +        g_free(t);
> +        return;
> +    }
> +    tdx->quote_generation_num++;
> +    t->event_notify_interrupt = tdx->event_notify_interrupt;
> +    qio_channel_socket_connect_async(
> +        ioc, tdx->quote_generation, tdx_handle_get_quote_connected, t, NULL,
> +        NULL);
> +    qemu_mutex_unlock(&tdx->lock);
> +
> +    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
> +}
> +
>  static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
>                                                      struct kvm_tdx_vmcall *vmcall)
>  {
> @@ -1005,6 +1432,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
>      }
>  
>      switch (vmcall->subfunction) {
> +    case TDG_VP_VMCALL_GET_QUOTE:
> +        tdx_handle_get_quote(cpu, vmcall);
> +        break;
>      case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
>          tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
>          break;
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index 4a8d67cc9fdb..4a989805493e 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -5,8 +5,10 @@
>  #include CONFIG_DEVICES /* CONFIG_TDX */
>  #endif
>  
> +#include <linux/kvm.h>
>  #include "exec/confidential-guest-support.h"
>  #include "hw/i386/tdvf.h"
> +#include "io/channel-socket.h"
>  #include "sysemu/kvm.h"
>  
>  #define TYPE_TDX_GUEST "tdx-guest"
> @@ -47,6 +49,10 @@ typedef struct TdxGuest {
>      /* runtime state */
>      int event_notify_interrupt;
>      uint32_t event_notify_apic_id;
> +
> +    /* GetQuote */
> +    int quote_generation_num;
> +    SocketAddress *quote_generation;
>  } TdxGuest;
>  
>  #ifdef CONFIG_TDX
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


