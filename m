Return-Path: <kvm+bounces-42485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1008A79273
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E19123B5EBC
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AEB1991C1;
	Wed,  2 Apr 2025 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qg8nrOnp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E331946C7
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743609008; cv=none; b=bOVac0ra3OI698lAHfwylSrxxRA6cUCbIamtM6nX3IOpZ5yumFMNO5j/mTL7Uyo1J4hUttPjvWHmOzWpwBSU6u2yFwMKhR3mTKOvHeBd6OY+LSdq+J0ASKbsVZgqg8iMvmkHMDHgWDedQzsimGDLRgMA0egvJZ0lhDMsDKsuoQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743609008; c=relaxed/simple;
	bh=7FZs7KOtsgZRrCr7LswoNfmk0+i8mmK66xmXmP7wrJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNO9Nm++9l0hkG1QsY++AlTgOuaQhsZecKM/yql+o5qYX1jFpE8kVuPhxmuljJuTZReykOwinJHYdq5rWh1rxxBVN7DV2tgyJuzcSYz3ifK5YMaS88eMxYAjdlgMF5YPxfFuP/hO13mw+xoAaXR9/zs/MjqHChXmZNqRd1ftUXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qg8nrOnp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743609005;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ycRpxBBOz/moeCjj4EOVJDYjmoGxZMbGSzE5TMq1L+8=;
	b=Qg8nrOnpuuWCs1X7/bZqbFFgMY3zh+gc0w1hc3QxE+mKOLREWszco44plwJRM6aOEosDR1
	9Gr3gAz4nGT9osFobPbuWnquGwrhFhAX2ZB7+xpqMA2YQunbfwHlb3MThfCQmWRUIDpJT5
	6OuLzAjVeVFwqvr/Lg9Hy+8iygvqwJM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-mRWqA1LBNiGdJByK7IJmpw-1; Wed,
 02 Apr 2025 11:50:02 -0400
X-MC-Unique: mRWqA1LBNiGdJByK7IJmpw-1
X-Mimecast-MFC-AGG-ID: mRWqA1LBNiGdJByK7IJmpw_1743608999
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30FFD180AF74;
	Wed,  2 Apr 2025 15:49:58 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AC0A19541A5;
	Wed,  2 Apr 2025 15:49:50 +0000 (UTC)
Date: Wed, 2 Apr 2025 16:49:47 +0100
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
Message-ID: <Z-1cm6cEwNGs9NEu@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
 <Zv7dtghi20DZ9ozz@redhat.com>
 <0e15f14b-cd63-4ec4-8232-a5c0a96ba31d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e15f14b-cd63-4ec4-8232-a5c0a96ba31d@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Apr 02, 2025 at 11:26:11PM +0800, Xiaoyao Li wrote:
> Sorry for the late response.
> 
> KVM part of TDX attestation support is submitting again. QEMU part will
> follow and we need to settle dowm this topic before QEMU patches submission.
> 
> On 10/4/2024 2:08 AM, Daniel P. Berrangé wrote:
> > On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Add property "quote-generation-socket" to tdx-guest, which is a property
> > > of type SocketAddress to specify Quote Generation Service(QGS).
> > > 
> > > On request of GetQuote, it connects to the QGS socket, read request
> > > data from shared guest memory, send the request data to the QGS,
> > > and store the response into shared guest memory, at last notify
> > > TD guest by interrupt.
> > > 
> > > command line example:
> > >    qemu-system-x86_64 \
> > >      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
> > >      -machine confidential-guest-support=tdx0
> > > 
> > > Note, above example uses vsock type socket because the QGS we used
> > > implements the vsock socket. It can be other types, like UNIX socket,
> > > which depends on the implementation of QGS.
> > > 
> > > To avoid no response from QGS server, setup a timer for the transaction.
> > > If timeout, make it an error and interrupt guest. Define the threshold of
> > > time to 30s at present, maybe change to other value if not appropriate.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > 
> > > diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> > > index 49f94d9d46f4..7dfda507cc8c 100644
> > > --- a/target/i386/kvm/tdx.c
> > > +++ b/target/i386/kvm/tdx.c
> > 
> > > +static int tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
> > > +{
> > > +    struct tdx_generate_quote_task *task;
> > > +    struct tdx_get_quote_header hdr;
> > > +    hwaddr buf_gpa = vmcall->in_r12;
> > > +    uint64_t buf_len = vmcall->in_r13;
> > > +
> > > +    QEMU_BUILD_BUG_ON(sizeof(struct tdx_get_quote_header) != TDX_GET_QUOTE_HDR_SIZE);
> > > +
> > > +    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
> > > +
> > > +    if (buf_len == 0) {
> > > +        return 0;
> > > +    }
> > > +
> > > +    /* GPA must be shared. */
> > > +    if (!(buf_gpa & tdx_shared_bit(cpu))) {
> > > +        return 0;
> > > +    }
> > > +    buf_gpa &= ~tdx_shared_bit(cpu);
> > > +
> > > +    if (!QEMU_IS_ALIGNED(buf_gpa, 4096) || !QEMU_IS_ALIGNED(buf_len, 4096)) {
> > > +        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
> > > +        return 0;
> > > +    }
> > > +
> > > +    if (address_space_read(&address_space_memory, buf_gpa, MEMTXATTRS_UNSPECIFIED,
> > > +                           &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> > > +        error_report("TDX: get-quote: failed to read GetQuote header.\n");
> > > +        return -1;
> > > +    }
> > > +
> > > +    if (le64_to_cpu(hdr.structure_version) != TDX_GET_QUOTE_STRUCTURE_VERSION) {
> > > +        return 0;
> > > +    }
> > > +
> > > +    /*
> > > +     * Paranoid: Guest should clear error_code and out_len to avoid information
> > > +     * leak.  Enforce it.  The initial value of them doesn't matter for qemu to
> > > +     * process the request.
> > > +     */
> > > +    if (le64_to_cpu(hdr.error_code) != TDX_VP_GET_QUOTE_SUCCESS ||
> > > +        le32_to_cpu(hdr.out_len) != 0) {
> > > +        return 0;
> > > +    }
> > > +
> > > +    /* Only safe-guard check to avoid too large buffer size. */
> > > +    if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
> > > +        le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
> > > +        return 0;
> > > +    }
> > > +
> > > +    vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
> > > +    if (!tdx_guest->quote_generator) {
> > > +        hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
> > > +        if (address_space_write(&address_space_memory, buf_gpa,
> > > +                                MEMTXATTRS_UNSPECIFIED,
> > > +                                &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> > > +            error_report("TDX: failed to update GetQuote header.\n");
> > > +            return -1;
> > > +        }
> > > +        return 0;
> > > +    }
> > > +
> > > +    qemu_mutex_lock(&tdx_guest->quote_generator->lock);
> > > +    if (tdx_guest->quote_generator->num >= TDX_MAX_GET_QUOTE_REQUEST) {
> > > +        qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
> > > +        vmcall->status_code = TDG_VP_VMCALL_RETRY;
> > > +        return 0;
> > > +    }
> > > +    tdx_guest->quote_generator->num++;
> > > +    qemu_mutex_unlock(&tdx_guest->quote_generator->lock);
> > > +
> > > +    /* Mark the buffer in-flight. */
> > > +    hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_IN_FLIGHT);
> > > +    if (address_space_write(&address_space_memory, buf_gpa,
> > > +                            MEMTXATTRS_UNSPECIFIED,
> > > +                            &hdr, TDX_GET_QUOTE_HDR_SIZE) != MEMTX_OK) {
> > > +        error_report("TDX: failed to update GetQuote header.\n");
> > > +        return -1;
> > > +    }
> > > +
> > > +    task = g_malloc(sizeof(*task));
> > > +    task->buf_gpa = buf_gpa;
> > > +    task->payload_gpa = buf_gpa + TDX_GET_QUOTE_HDR_SIZE;
> > > +    task->payload_len = buf_len - TDX_GET_QUOTE_HDR_SIZE;
> > > +    task->hdr = hdr;
> > > +    task->quote_gen = tdx_guest->quote_generator;
> > > +    task->completion = tdx_get_quote_completion;
> > > +
> > > +    task->send_data_size = le32_to_cpu(hdr.in_len);
> > > +    task->send_data = g_malloc(task->send_data_size);
> > > +    task->send_data_sent = 0;
> > > +
> > > +    if (address_space_read(&address_space_memory, task->payload_gpa,
> > > +                           MEMTXATTRS_UNSPECIFIED, task->send_data,
> > > +                           task->send_data_size) != MEMTX_OK) {
> > > +        g_free(task->send_data);
> > > +        return -1;
> > > +    }
> > 
> > In this method we've received "struct tdx_get_quote_header" from
> > the guest OS, and the 'hdr.in_len' field in that struct tells us
> > the payload to read from guest memory. This payload is treated as
> > opaque by QEMU and sent over the UNIX socket directly to QGS with
> > no validation of the payload.
> > 
> > The payload is supposed to be a raw TDX report, that QGS will turn
> > into a quote.
> > 
> > Nothing guarantees that the guest OS has actually given QEMU a
> > payload that represents a TDX report.
> > 
> > The only validation done in this patch is to check the 'hdr.in_len'
> > was not ridiculously huge:
> > 
> >       #define TDX_GET_QUOTE_MAX_BUF_LEN       (128 * 1024)
> > 
> >       #define TDX_GET_QUOTE_HDR_SIZE          24
> > 
> >       ...
> >       /* Only safe-guard check to avoid too large buffer size. */
> >       if (buf_len > TDX_GET_QUOTE_MAX_BUF_LEN ||
> >           le32_to_cpu(hdr.in_len) > buf_len - TDX_GET_QUOTE_HDR_SIZE) {
> >           return 0;
> >       }
> > 
> > IOW, hdr.in_len can be any value between 0 and 131048, and
> > the payload data read can contain arbitrary bytes.
> > 
> > 
> > Over in the QGS code, QGS historically had a socket protocol
> > taking various messages from the libtdxattest library which
> > were defined in this:
> > 
> >    https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs_msg_lib/inc/qgs_msg_lib.h
> > 
> >    typedef enum _qgs_msg_type_t {
> >      GET_QUOTE_REQ = 0,
> >      GET_QUOTE_RESP = 1,
> >      GET_COLLATERAL_REQ = 2,
> >      GET_COLLATERAL_RESP = 3,
> >      GET_PLATFORM_INFO_REQ = 4,
> >      GET_PLATFORM_INFO_RESP = 5,
> >      QGS_MSG_TYPE_MAX
> >    } qgs_msg_type_t;
> > 
> >    typedef struct _qgs_msg_header_t {
> >      uint16_t major_version;
> >      uint16_t minor_version;
> >      uint32_t type;
> >      uint32_t size;              // size of the whole message, include this header, in byte
> >      uint32_t error_code;        // used in response only
> >    } qgs_msg_header_t;
> > 
> > such messages are processed by the 'get_resp' method in QGS:
> > 
> >    https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_ql_logic.cpp#L78
> > 
> > The 1.21 release of DCAP introduced a new "raw" mode in QGS which
> > just receives the raw 1024 byte packet from the client which is
> > supposed to be a raw TDX report.  This is what this QEMU patch
> > is relying on IIUC.
> > 
> > 
> > The QGS daemon decides whether a client is speaking the formal
> > protocol, or "raw" mode, by trying to interpret the incoming
> > data as a 'qgs_msg_header_t' struct. If the header size looks
> > wrong & it has exactly 1024 bytes, then QGS assumes it has got
> > a raw TDX report:
> > 
> >    https://github.com/intel/SGXDataCenterAttestationPrimitives/blob/main/QuoteGeneration/quote_wrapper/qgs/qgs_server.cpp#L165
> > 
> > This all works if the data QEMU gets from the guest is indeed a
> > 1024 byte raw TDX report, but what happens if we face a malicious
> > guest ?
> > 
> > AFAICT, the guest OS is able to send a "qgs_msg_header_t" packet
> > to QEMU, which QEMU blindly passes on to QGS. This allows the
> > guest OS to invoke any of the three QGS commands - GET_QUOTE_REQ,
> > GET_COLLATERAL_REQ, or GET_PLATFORM_INFO_REQ. Fortunately I think
> > those three messages are all safe to invoke, but none the less,
> > this should not be permitted, as it leaves a wide open door for
> > possible future exploits.
> > 
> > As mentioned before, I don't know why this raw mode was invented
> > for QGS, when QEMU itself could just take the guest report and
> > pack it into the 'GET_QUOTE_REQ' message format and send it to
> > QGS. This prevents the guest OS from being able to exploit QEMU
> > to invoke arbirtary QGS messages.
> 
> I guess the raw mode was introduced due to the design was changed to let
> guest kernel to forward to TD report to host QGS via TDVMCALL instead of
> guest application communicates with host QGS via vsock, and Linux TD guest
> driver doesn't integrate any QGS protocol but just forward the raw TD report
> data to KVM.
> 
> > IMHO, QEMU should be made to pack & unpack the TDX report from
> > the guest into the GET_QUOTE_REQ / GET_QUOTE_RESP messages, and
> > this "raw" mode should be removed to QGS as it is inherantly
> > dangerous to have this magic protocol overloading.
> 
> There is no enforcement that the input data of TDVMCALL.GetQuote is the raw
> data of TD report. It is just the current Linux tdx-guest driver of tsm
> implementation send the raw data. For other TDX OS, or third-party driver,
> they might encapsulate the raw TD report data with QGS message header. For
> such cases, if QEMU adds another layer of package, it leads to the wrong
> result.

If I look at the GHCI spec 

  https://cdrdv2-public.intel.com/726790/TDX%20Guest-Hypervisor%20Communication%20Interface_1.0_344426_006%20-%2020230311.pdf

In "3.3 TDG.VP.VMCALL<GetQuote>", it indicates the parameter is a
"TDREPORT_STRUCT". IOW, it doesn't look valid to allow the guest to
send arbitrary other data as QGS protocol messages.

> If we are going to pack the input data of GETQUOTE in QEMU, it becomes a
> hard requirement from QEMU that the input data of GETQUOTE must be raw data
> of TD report.

AFAICT it must be a raw TDREPORT_STRUCT per the spec and thus QEMU must not
allow anything different, as that exposes a significantly larger security
attack surface on the QGS daemon.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


