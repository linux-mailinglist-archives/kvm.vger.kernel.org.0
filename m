Return-Path: <kvm+bounces-5831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8A38271B7
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 989D2284138
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1224343140;
	Mon,  8 Jan 2024 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STZ2noGZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836738DC5
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704725063;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jv+eiYFKWIvKB/NA82payv2oFkXWk5n2COx/m/9slT4=;
	b=STZ2noGZsWU6M/26CrE2peiA0xg3iKw/f8FG0OuE2/moGdn1Lvt6zYOImRB0fnt+6rStjX
	EovHmA6L1ggmCwTSq/8+sr2Sq2eBYZKHII63scv5xP8XBBwbOJH7t6yjW2B3TzSW2LG7Ln
	TyDpbxYE07s/E/mzEdaMNrcij1nNEq4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-RfIQ38MkNqaRWDG8T6W6Bg-1; Mon,
 08 Jan 2024 09:44:20 -0500
X-MC-Unique: RfIQ38MkNqaRWDG8T6W6Bg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 898CD1C05132;
	Mon,  8 Jan 2024 14:44:19 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.90])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 014BA2166B35;
	Mon,  8 Jan 2024 14:44:14 +0000 (UTC)
Date: Mon, 8 Jan 2024 14:44:12 +0000
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
Message-ID: <ZZwKPH3fVHo9EyBy@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-53-xiaoyao.li@intel.com>
 <ZVUGtpZDTW27F8Um@redhat.com>
 <db4330cf-d25a-48d3-b681-cf2326c16912@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db4330cf-d25a-48d3-b681-cf2326c16912@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Fri, Dec 29, 2023 at 10:30:15AM +0800, Xiaoyao Li wrote:
> On 11/16/2023 1:58 AM, Daniel P. Berrangé wrote:
> > On Wed, Nov 15, 2023 at 02:15:01AM -0500, Xiaoyao Li wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > For GetQuote, delegate a request to Quote Generation Service.
> > > Add property "quote-generation-socket" to tdx-guest, whihc is a property
> > > of type SocketAddress to specify Quote Generation Service(QGS).
> > > 
> > > On request, connect to the QGS, read request buffer from shared guest
> > > memory, send the request buffer to the server and store the response
> > > into shared guest memory and notify TD guest by interrupt.
> > > 
> > > command line example:
> > >    qemu-system-x86_64 \
> > >      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"2","port":"1234"}}' \
> > >      -machine confidential-guest-support=tdx0
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > > Changes in v3:
> > > - rename property "quote-generation-service" to "quote-generation-socket";
> > > - change the type of "quote-generation-socket" from str to
> > >    SocketAddress;
> > > - squash next patch into this one;
> > > ---
> > >   qapi/qom.json         |   5 +-
> > >   target/i386/kvm/tdx.c | 430 ++++++++++++++++++++++++++++++++++++++++++
> > >   target/i386/kvm/tdx.h |   6 +
> > >   3 files changed, 440 insertions(+), 1 deletion(-)
> > > 
> > > +static void tdx_handle_get_quote_connected(QIOTask *task, gpointer opaque)
> > > +{
> > > +    struct tdx_get_quote_task *t = opaque;
> > > +    Error *err = NULL;
> > > +    char *in_data = NULL;
> > > +    MachineState *ms;
> > > +    TdxGuest *tdx;
> > > +
> > > +    t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_ERROR);
> > > +    if (qio_task_propagate_error(task, NULL)) {
> > > +        t->hdr.error_code = cpu_to_le64(TDX_VP_GET_QUOTE_QGS_UNAVAILABLE);
> > > +        goto error;
> > > +    }
> > > +
> > > +    in_data = g_malloc(le32_to_cpu(t->hdr.in_len));
> > > +    if (!in_data) {
> > > +        goto error;
> > > +    }
> > > +
> > > +    if (address_space_read(&address_space_memory, t->gpa + sizeof(t->hdr),
> > > +                           MEMTXATTRS_UNSPECIFIED, in_data,
> > > +                           le32_to_cpu(t->hdr.in_len)) != MEMTX_OK) {
> > > +        goto error;
> > > +    }
> > > +
> > > +    qio_channel_set_blocking(QIO_CHANNEL(t->ioc), false, NULL);
> > 
> > You've set the channel to non-blocking, but....
> > 
> > > +
> > > +    if (qio_channel_write_all(QIO_CHANNEL(t->ioc), in_data,
> > > +                              le32_to_cpu(t->hdr.in_len), &err) ||
> > > +        err) {
> > 
> > ...this method will block execution of this thread, by either
> > sleeping in poll() or doing a coroutine yield.
> > 
> > I don't think this is in coroutine context, so presumably this
> > is just blocking.  So what was the point in marking the channel
> > non-blocking ?
> 
> Hi Dainel,
> 
> First of all, I'm not good at socket or qio channel thing. Please correct me
> and teach me when I'm wrong.
> 
> I'm not the author of this patch. My understanding is that, set it to
> non-blocking is for the qio_channel_write_all() to proceed immediately?

The '_all' suffixed methods are implemented such that they will
sleep in poll(), or a coroutine yield when seeing EAGAIN. 

> If set non-blocking is not needed, I can remove it.
> 
> > You are setting up a background watch to wait for the reply
> > so we don't block this thread, so you seem to want non-blocking
> > behaviour.
> 
> Both sending and receiving are in a new thread created by
> qio_channel_socket_connect_async(). So I think both of then can be blocking
> and don't need to be in another background thread.
> 
> what's your suggestion on it? Make both sending and receiving blocking or
> non-blocking?

I think the code /should/ be non-blocking, which would mean
using   qio_channel_write, instead of qio_channel_write_all,
and using a .

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


