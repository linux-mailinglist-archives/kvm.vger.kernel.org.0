Return-Path: <kvm+bounces-9144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 898B685B66E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACEE01C23CDA
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF20260DE7;
	Tue, 20 Feb 2024 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVZ2Dl1e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C465197
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 08:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419498; cv=none; b=cB0GgvRmt+1UqRN+F+VD9s4GbLOxcjlgdI6BeslNzJXTAb7xQkRXa7voyO4Ivw7ueXjooH4uKiSjTbeGjC3bfxI7HWcEm16ayPK5g8518RlvEn5Ny15HvRW+S78JR4kQP+LB5iS4t3sMgYE4B+ZlKALedGlsy/bD+jVU8AhiasY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419498; c=relaxed/simple;
	bh=/7Q4SlC11F1MC6yWuxqF4/X18E+TV7I+qjFZAZs/5QU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QLga3gcXLzBC2xUdM6JqnAdIV7QZHEBcu4fYfnoClyz3/5ID2EnKKagpIC/pU2o7TkLMVshqy2ehx82/GHCUJorsQFKu5074S76HHSiYRHb7RBVAJpirDhQyFgS75BxKTZSD7fpPBGPT+hHA2ny2NIodM0Yi0YW+pmbP+w5uUJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVZ2Dl1e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708419494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:  references:references;
	bh=PywWiBmxcb8yvjCgJbUBCRZXDUktOG9Db5gcFJ2aPrA=;
	b=QVZ2Dl1emhjW42jaP6U8foAiShEgbUwswtTUhdndO86uw7HFkF/tQx4GGyfzAtM3qskH/p
	mo784GwzpftEj3TvQhah0WEDuvAnP3VIWYhNBZjXDOwaoq9D52RPsneGtKyty9xuntuOwo
	CFFE+BMdVv2mF34IxaH24g9+wnirm1w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-Dzio1G3aNh62As3DZMy7aw-1; Tue, 20 Feb 2024 03:58:11 -0500
X-MC-Unique: Dzio1G3aNh62As3DZMy7aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF03E10651F0;
	Tue, 20 Feb 2024 08:58:10 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.55])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A5A12166AEA;
	Tue, 20 Feb 2024 08:58:10 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id A09F121E66D0; Tue, 20 Feb 2024 09:58:09 +0100 (CET)
Resent-To: michael.roth@amd.com, isaku.yamahata@gmail.com,
 marcel.apfelbaum@gmail.com, seanjc@google.com, chenyi.qiang@intel.com,
 xiaoyao.li@intel.com, philmd@linaro.org, richard.henderson@linaro.org,
 qemu-devel@nongnu.org, cfontana@suse.de, kvm@vger.kernel.org
Resent-From: Markus Armbruster <armbru@redhat.com>
Resent-Date: Tue, 20 Feb 2024 09:58:09 +0100
Resent-Message-ID: <87ttm3cy1q.fsf@pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  David Hildenbrand <david@redhat.com>,  Igor Mammedov
 <imammedo@redhat.com>,  "Michael S . Tsirkin" <mst@redhat.com>,  Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Peter Xu <peterx@redhat.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Cornelia Huck
 <cohuck@redhat.com>,
  Eric Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  Michael Roth
 <michael.roth@amd.com>,  Sean Christopherson <seanjc@google.com>,  Claudio
 Fontana <cfontana@suse.de>,  Gerd Hoffmann <kraxel@redhat.com>,  Isaku
 Yamahata <isaku.yamahata@gmail.com>,  Chenyi Qiang
 <chenyi.qiang@intel.com>
Subject: Re: [PATCH v4 50/66] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
In-Reply-To: <ZdNPpcNiGcY4Jefi@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Mon, 19 Feb 2024 12:55:01 +0000")
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
	<20240125032328.2522472-51-xiaoyao.li@intel.com>
	<87zfvwehyz.fsf@pond.sub.org> <ZdNPpcNiGcY4Jefi@redhat.com>
Date: Mon, 19 Feb 2024 15:41:49 +0100
Message-ID: <8734tojz2q.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Lines: 106
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Mon, Feb 19, 2024 at 01:50:12PM +0100, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>=20
>> > From: Isaku Yamahata <isaku.yamahata@intel.com>
>> >
>> > Add property "quote-generation-socket" to tdx-guest, which is a proper=
ty
>> > of type SocketAddress to specify Quote Generation Service(QGS).
>> >
>> > On request of GetQuote, it connects to the QGS socket, read request
>> > data from shared guest memory, send the request data to the QGS,
>> > and store the response into shared guest memory, at last notify
>> > TD guest by interrupt.
>> >
>> > command line example:
>> >   qemu-system-x86_64 \
>> >     -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-soc=
ket":{"type": "vsock", "cid":"1","port":"1234"}}' \
>> >     -machine confidential-guest-support=3Dtdx0
>> >
>> > Note, above example uses vsock type socket because the QGS we used
>> > implements the vsock socket. It can be other types, like UNIX socket,
>> > which depends on the implementation of QGS.
>> >
>> > To avoid no response from QGS server, setup a timer for the transactio=
n.
>> > If timeout, make it an error and interrupt guest. Define the threshold=
 of
>> > time to 30s at present, maybe change to other value if not appropriate.
>> >
>> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> > Codeveloped-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> > Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> > ---
>> > Changes in v4:
>> > - merge next patch "i386/tdx: setup a timer for the qio channel";
>> >
>> > Changes in v3:
>> > - rename property "quote-generation-service" to "quote-generation-sock=
et";
>> > - change the type of "quote-generation-socket" from str to
>> >   SocketAddress;
>> > - squash next patch into this one;
>> > ---
>> >  qapi/qom.json                         |   6 +-
>> >  target/i386/kvm/meson.build           |   2 +-
>> >  target/i386/kvm/tdx-quote-generator.c | 170 ++++++++++++++++++++
>> >  target/i386/kvm/tdx-quote-generator.h |  95 +++++++++++
>> >  target/i386/kvm/tdx.c                 | 216 ++++++++++++++++++++++++++
>> >  target/i386/kvm/tdx.h                 |   6 +
>> >  6 files changed, 493 insertions(+), 2 deletions(-)
>> >  create mode 100644 target/i386/kvm/tdx-quote-generator.c
>> >  create mode 100644 target/i386/kvm/tdx-quote-generator.h
>> >
>> > diff --git a/qapi/qom.json b/qapi/qom.json
>> > index 15445f9e41fc..c60fb5710961 100644
>> > --- a/qapi/qom.json
>> > +++ b/qapi/qom.json
>> > @@ -914,13 +914,17 @@
>> >  #     e.g., specific to the workload rather than the run-time or OS.
>> >  #     base64 encoded SHA384 digest.
>> >  #
>> > +# @quote-generation-socket: socket address for Quote Generation
>> > +#     Service(QGS)
>>=20
>> Space between "Service" and "(QGS)", please.
>>=20
>> The description feels too terse.  What is the "Quote Generation
>> Service", and why should I care?
>
> The "Quote Generation Service" is a daemon running on the host.
> The reference implementation is at
>
>   https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master=
/QuoteGeneration/quote_wrapper/qgs
>
> If you don't provide this, then quests won't bet able to generate
> quotes needed for attestation. So although this is technically
> optional, in practice for a sane deployment, an admin should always
> provide this

Thanks.  Care to work some of this information into the doc comment?

>> > +#
>> >  # Since: 9.0
>> >  ##
>> >  { 'struct': 'TdxGuestProperties',
>> >    'data': { '*sept-ve-disable': 'bool',
>> >              '*mrconfigid': 'str',
>> >              '*mrowner': 'str',
>> > -            '*mrownerconfig': 'str' } }
>> > +            '*mrownerconfig': 'str',
>> > +            '*quote-generation-socket': 'SocketAddress' } }
>> >=20=20
>> >  ##
>> >  # @ThreadContextProperties:
>>=20
>> [...]
>>=20
>
> With regards,
> Daniel


