Return-Path: <kvm+bounces-27856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F30798F5D5
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 20:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EFCB283174
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 18:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739991AB50D;
	Thu,  3 Oct 2024 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MosxyD+c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A1C1AAE2B
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727978954; cv=none; b=sg0y5tV5NTUQRvAwnNxT4EdgoPRU9DlQMm3BpHjn/FTAR7EesVrHjMJ6rs2GyoucLQBF68+05Frn5f8ha9+ZOPI9W1PkfZ4V9w3K3rrMLkluVH3bipwxRIcN5pFRIfwBZM01L+XvcfZjZcNY1KAQh3/iM+x9+eiZTDkcckhvA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727978954; c=relaxed/simple;
	bh=N4FwwlT4tpKcM6zF07yAQXzi3kt6VKGayBqy8h7FPAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oRCmBrRs6Z1HsZCHBnjIi7ms6KGyJgTZZpY+pPyh8Evy/+UjbtXwGrTwr6YCz0s34cRS5qTVTr/ToKToX7eo8k1WK3S23i8Z1GI5Fx1dSEfMmDy63gyEu5T8BDW6p673qU53v1+0x4wI9MCpFmHjFzNEGSFXUmNKdW8ulk4+bQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MosxyD+c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727978950;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=HdfQSiNpKH6YUJZr0b3w0Vcyi9pcKWYGidksMEsmzEc=;
	b=MosxyD+cnN9x2g/Std/eDUhrzCYOLwRphPXGKO9eMjjgT67C7ptZHqlpJlhoWQOhYqfg2Q
	hf9VM1IibbRV/nHh8Jy5ja0SE4KKg38TOiAbxXGXHR2Dm+pR+0SGhgb+F2ZLiB/kOWGum+
	6rNXtxWLNe07BkR7OxnB0XirDHZqqt8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-NU1-EI0fP-WuMXkf6DyNOQ-1; Thu,
 03 Oct 2024 14:09:07 -0400
X-MC-Unique: NU1-EI0fP-WuMXkf6DyNOQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D42341955F42;
	Thu,  3 Oct 2024 18:09:04 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DFDA1955E8C;
	Thu,  3 Oct 2024 18:08:57 +0000 (UTC)
Date: Thu, 3 Oct 2024 19:08:54 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <Zv7dtghi20DZ9ozz@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240229063726.610065-50-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add property "quote-generation-socket" to tdx-guest, which is a property
> of type SocketAddress to specify Quote Generation Service(QGS).
> 
> On request of GetQuote, it connects to the QGS socket, read request
> data from shared guest memory, send the request data to the QGS,
> and store the response into shared guest memory, at last notify
> TD guest by interrupt.
> 
> command line example:
>   qemu-system-x86_64 \
>     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>     -machine confidential-guest-support=tdx0
> 
> Note, above example uses vsock type socket because the QGS we used
> implements the vsock socket. It can be other types, like UNIX socket,
> which depends on the implementation of QGS.
> 
> To avoid no response from QGS server, setup a timer for the transaction.
> If timeout, make it an error and interrupt guest. Define the threshold of
> time to 30s at present, maybe change to other value if not appropriate.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>


> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 49f94d9d46f4..7dfda507cc8c 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c

> +static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
> +{
> +    struct tdx_generate_quote_task *task;
> +    struct tdx_get_quote_header hdr;
> +    hwaddr buf_gpa = vmcall->in_r12;
> +    uint64_t buf_len = vmcall->in_r13;
> +
> +    QEMU_BUILD_BUG_ON(sizeof(struct tdx_get_quote_header) != TDX_GET_QUOTE_HDR_SIZE);
> +
> +    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
> +
> +    if (buf_len == 0) {
> +        return 0;
> +    }
> +
> +    /* GPA must be shared. */
> +    if (!(buf_gpa & tdx_shared_bit(cpu))) {
> +        return 0;
> +    }
> +    buf_gpa &= ~tdx_shared_bit(cpu);
> +
> +    if (!QEMU_IS_ALIGNED(buf_gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
> +        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
> +        return 0;
> +    }
> +
> +    if (address_space_read(&address_space_memory, buf_gpa, MEMTXATTRS_UNSPECIFIED,
> +                           &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> +        error_report("TDX: get-quote: failed to read GetQuote header.\n");
> +        return -1;
> +    }
> +
> +    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
> +        return 0;
> +    }
> +
> +    /*
> +     * Paranoid: Guest should clear error_code and out_len to avoid information
> +     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
> +     * process the request.
> +     */
> +    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
> +        le32_to_cpu(hdr.out_len) != 0) {
> +        return 0;
> +    }
> +
> +    /* Only safe-guard check to avoid too large buffer size. */
> +    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
> +        le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
> +        return 0;
> +    }
> +
> +    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
> +    if (!tdx_guest->quote_generator) {
> +        hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
> +        if (address_space_write(&address_space_memory, buf_gpa,
> +                                MEMTXATTRS_UNSPECIFIED,
> +                                &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> +            error_report("TDX: failed to update GetQuote header.\n");
> +            return -1;
> +        }
> +        return 0;
> +    }
> +
> +    qemu_mutex_lock(&tdx_guest->quote_generator->lock);
> +    if (tdx_guest->quote_generator->num >= TDX_MAX_GET_QUOTE_REQUEST) {
> +        qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
> +        vmcall->status_code = TDG_VP_VMCALL_RETRY;
> +        return 0;
> +    }
> +    tdx_guest->quote_generator->num++;
> +    qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
> +
> +    /* Mark the buffer in-flight. */
> +    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
> +    if (address_space_write(&address_space_memory, buf_gpa,
> +                            MEMTXATTRS_UNSPECIFIED,
> +                            &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> +        error_report("TDX: failed to update GetQuote header.\n");
> +        return -1;
> +    }
> +
> +    task = g_malloc(sizeof(*task));
> +    task->buf_gpa = buf_gpa;
> +    task->payload_gpa = buf_gpa + TDX_GET_QUOTE_HDR_SIZE;
> +    task->payload_len = buf_len - TDX_GET_QUOTE_HDR_SIZE;
> +    task->hdr = hdr;
> +    task->quote_gen = tdx_guest->quote_generator;
> +    task->completion = tdx_get_quote_completion;
> +
> +    task->send_data_size = le32_to_cpu(hdr.in_len);
> +    task->send_data = g_malloc(task->send_data_size);
> +    task->send_data_sent = 0;
> +
> +    if (address_space_read(&address_space_memory, task->payload_gpa,
> +                           MEMTXATTRS_UNSPECIFIED, task->send_data,
> +                           task->send_data_size) != MEMTX_OK) {
> +        g_free(task->send_data);
> +        return -1;
> +    }

In this method we've received "struct tdx_get_quote_header" from
the guest OS, and the 'hdr.in_len' field in that struct tells us
the payload to read from guest memory. This payload is treated as
opaque by QEMU and sent over the UNIX socket directly to QGS with
no validation of the payload.

The payload is supposed to be a raw TDX report, that QGS will turn
into a quote.

Nothing guarantees that the guest OS has actually given QEMU a
payload that represents a TDX report.

The only validation done in this patch is to check the 'hdr.in_len'
was not ridiculously huge:

     #define TDX_GET_QUOTE_MAX_BUF_LEN       (128 * 1024)

     #define TDX_GET_QUOTE_HDR_SIZE          24

     ...
 
     /* Only safe-guard check to avoid too large buffer size. */
     if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
         le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
         return 0;
     }

IOW, hdr.in_len can be any value between 0 and 131048, and
the payload data read can contain arbitrary bytes.


Over in the QGS code, QGS historically had a socket protocol
taking various messages from the libtdxattest library which
were defined in this:

  https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs_msg_lib/inc/qgs_msg_lib.h

  typedef enum _qgs_msg_type_t {
    GET_QUOTE_REQ = 0,
    GET_QUOTE_RESP = 1,
    GET_COLLATERAL_REQ = 2,
    GET_COLLATERAL_RESP = 3,
    GET_PLATFORM_INFO_REQ = 4,
    GET_PLATFORM_INFO_RESP = 5,
    QGS_MSG_TYPE_MAX
  } qgs_msg_type_t;

  typedef struct _qgs_msg_header_t {
    uint16_t major_version;
    uint16_t minor_version;
    uint32_t type;
    uint32_t size;              // size of the whole message, include this header, in byte
    uint32_t error_code;        // used in response only
  } qgs_msg_header_t;

such messages are processed by the 'get_resp' method in QGS:

  https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_ql_logic.cpp#L78

The 1.21 release of DCAP introduced a new "raw" mode in QGS which
just receives the raw 1024 byte packet from the client which is
supposed to be a raw TDX report.  This is what this QEMU patch
is relying on IIUC.


The QGS daemon decides whether a client is speaking the formal
protocol, or "raw" mode, by trying to interpret the incoming
data as a 'qgs_msg_header_t' struct. If the header size looks
wrong & it has exactly 1024 bytes, then QGS assumes it has got
a raw TDX report:

  https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L165

This all works if the data QEMU gets from the guest is indeed a
1024 byte raw TDX report, but what happens if we face a malicious
guest ?

AFAICT, the guest OS is able to send a "qgs_msg_header_t" packet
to QEMU, which QEMU blindly passes on to QGS. This allows the
guest OS to invoke any of the three QGS commands - GET_QUOTE_REQ,
GET_COLLATERAL_REQ, or GET_PLATFORM_INFO_REQ. Fortunately I think
those three messages are all safe to invoke, but none the less,
this should not be permitted, as it leaves a wide open door for
possible future exploits.

As mentioned before, I don't know why this raw mode was invented
for QGS, when QEMU itself could just take the guest report and
pack it into the 'GET_QUOTE_REQ' message format and send it to
QGS. This prevents the guest OS from being able to exploit QEMU
to invoke arbirtary QGS messages.

IMHO, QEMU should be made to pack & unpack the TDX report from
the guest into the GET_QUOTE_REQ / GET_QUOTE_RESP messages, and
this "raw" mode should be removed to QGS as it is inherantly
dangerous to have this magic protocol overloading.

Below is a patch on top of this one that illustrates how QEMU
could use the GET_QUOTE_REQ / GET_QUOTE_RESP messages and avoid
the "raw" mode of QGS.

> +
> +    task->receive_buf = g_malloc0(task->payload_len);
> +    task->receive_buf_received = 0;
> +
> +    tdx_generate_quote(task);
> +
> +    return 0;
> +}

--- qemu-9.0.0-rc3/target/i386/kvm/tdx-quote-generator.c	2024-10-02 11:05:31.328003392 -0400
+++ qemu-9.0.0/target/i386/kvm/tdx-quote-generator.c	2024-10-03 13:46:25.744775539 -0400
@@ -24,6 +24,61 @@
 
 OBJECT_DEFINE_TYPE(TdxQuoteGenerator, tdx_quote_generator, TDX_QUOTE_GENERATOR, OBJECT)
 
+const uint32_t QGS_MSG_LIB_MAJOR_VER = 1;
+const uint32_t QGS_MSG_LIB_MINOR_VER = 1;
+
+typedef enum _qgs_msg_type_t {
+    GET_QUOTE_REQ = 0,
+    GET_QUOTE_RESP = 1,
+    GET_COLLATERAL_REQ = 2,
+    GET_COLLATERAL_RESP = 3,
+    GET_PLATFORM_INFO_REQ = 4,
+    GET_PLATFORM_INFO_RESP = 5,
+    QGS_MSG_TYPE_MAX
+} qgs_msg_type_t;
+
+typedef struct _qgs_msg_header_t {
+    uint16_t major_version;
+    uint16_t minor_version;
+    uint32_t type;
+    uint32_t size;              // size of the whole message, include this header, in byte
+    uint32_t error_code;        // used in response only
+} qgs_msg_header_t;
+
+typedef struct _qgs_msg_get_quote_req_t {
+    qgs_msg_header_t header;    // header.type = GET_QUOTE_REQ
+    uint32_t report_size;       // cannot be 0
+    uint32_t id_list_size;      // length of id_list, in byte, can be 0
+} qgs_msg_get_quote_req_t;
+
+typedef struct _qgs_msg_get_quote_resp_s {
+    qgs_msg_header_t header;    // header.type = GET_QUOTE_RESP
+    uint32_t selected_id_size;  // can be 0 in case only one id is sent in request
+    uint32_t quote_size;        // length of quote_data, in byte
+    uint8_t id_quote[];         // selected id followed by quote
+} qgs_msg_get_quote_resp_t;
+
+const unsigned HEADER_SIZE = 4;
+
+static uint32_t decode_header(const char *buf, size_t len) {
+    if (len < HEADER_SIZE) {
+        return 0;
+    }
+    uint32_t msg_size = 0;
+    for (uint32_t i = 0; i < HEADER_SIZE; ++i) {
+        msg_size = msg_size * 256 + (buf[i] & 0xFF);
+    }
+    return msg_size;
+}
+
+static void encode_header(char *buf, size_t len, uint32_t size) {
+    assert(len >= HEADER_SIZE);
+    buf[0] = ((size >> 24) & 0xFF);
+    buf[1] = ((size >> 16) & 0xFF);
+    buf[2] = ((size >> 8) & 0xFF);
+    buf[3] = (size & 0xFF);
+}
+
 static void tdx_quote_generator_finalize(Object *obj)
 {
 }
@@ -70,9 +125,86 @@
             goto end;
         }
     }
+    
+    if (ret == 0) {
+        error_report("End of file before reply received");
+        task->status_code = TDX_VP_GET_QUOTE_ERROR;
+        goto end;
+    }
 
     task->receive_buf_received += ret;
-    if (ret == 0 || task->receive_buf_received == task->payload_len) {
+    if (task->receive_buf_received >= HEADER_SIZE) {
+        uint32_t len = decode_header(task->receive_buf,
+                                     task->receive_buf_received);
+        if (len == 0 ||
+            len > (task->payload_len - HEADER_SIZE)) {
+            error_report("Message len %u must be non-zero & less than %zu",
+                         len, (task->payload_len - HEADER_SIZE));
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+
+        /* Now we know the size, shrink to fit */
+        task->payload_len = HEADER_SIZE + len;
+        task->receive_buf = g_renew(char,
+                                    task->receive_buf,
+                                    task->payload_len);
+    }
+    
+    if (task->receive_buf_received >= (sizeof(qgs_msg_header_t) + HEADER_SIZE)) {
+        qgs_msg_header_t *hdr = (qgs_msg_header_t *)(task->receive_buf + HEADER_SIZE);
+        if (hdr->major_version != QGS_MSG_LIB_MAJOR_VER ||
+            hdr->minor_version != QGS_MSG_LIB_MINOR_VER) {
+            error_report("Invalid QGS message header version %d.%d\n",
+                         hdr->major_version,
+                         hdr->minor_version);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+        if (hdr->type != GET_QUOTE_RESP) {
+            error_report("Invalid QGS message type %d\n",
+                         hdr->type);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+        if (hdr->size > (task->payload_len - HEADER_SIZE)) {
+            error_report("QGS message size %d exceeds payload capacity %zu",
+                         hdr->size, task->payload_len);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+        if (hdr->error_code != 0) {
+            error_report("QGS message error code %d",
+                         hdr->error_code);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+    }
+    if (task->receive_buf_received >= (sizeof(qgs_msg_get_quote_resp_t) + HEADER_SIZE)) {
+        qgs_msg_get_quote_resp_t *msg = (qgs_msg_get_quote_resp_t *)(task->receive_buf + HEADER_SIZE);
+        if (msg->selected_id_size != 0) {
+            error_report("QGS message selected ID was %d not 0",
+                         msg->selected_id_size);
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+
+        if ((task->payload_len - HEADER_SIZE - sizeof(qgs_msg_get_quote_resp_t)) !=
+            msg->quote_size) {
+            error_report("QGS quote size %d should be %zu",
+                         msg->quote_size,
+                         (task->payload_len - sizeof(qgs_msg_get_quote_resp_t)));
+            task->status_code = TDX_VP_GET_QUOTE_ERROR;
+            goto end;
+        }
+    }
+
+    if (task->receive_buf_received == task->payload_len) {
+        size_t strip = HEADER_SIZE + sizeof(qgs_msg_get_quote_resp_t);
+        memmove(task->receive_buf,
+                task->receive_buf + strip,
+                task->receive_buf_received - strip);
+        task->receive_buf_received -= strip;
         task->status_code = TDX_VP_GET_QUOTE_SUCCESS;
         goto end;
     }
@@ -158,6 +290,29 @@
 {
     struct TdxQuoteGenerator *quote_gen = task->quote_gen;
     QIOChannelSocket *sioc;
+    qgs_msg_get_quote_req_t msg;
+
+    /* Prepare a QGS message prelude */
+    msg.header.major_version = QGS_MSG_LIB_MAJOR_VER;
+    msg.header.minor_version = QGS_MSG_LIB_MINOR_VER;
+    msg.header.type = GET_QUOTE_REQ;
+    msg.header.size = sizeof(msg) + task->send_data_size;
+    msg.header.error_code = 0;
+    msg.report_size = task->send_data_size;
+    msg.id_list_size = 0;
+
+    /* Make room to add the QGS message prelude */
+    task->send_data = g_renew(char,
+                              task->send_data,
+                              task->send_data_size + sizeof(msg) + HEADER_SIZE);
+    memmove(task->send_data + sizeof(msg) + HEADER_SIZE,
+            task->send_data,
+            task->send_data_size);
+    memcpy(task->send_data + HEADER_SIZE,
+           &msg,
+           sizeof(msg));
+    encode_header(task->send_data, HEADER_SIZE, task->send_data_size + sizeof(msg));
+    task->send_data_size += sizeof(msg) + HEADER_SIZE;
 
     sioc = qio_channel_socket_new();
     task->sioc = sioc;


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


