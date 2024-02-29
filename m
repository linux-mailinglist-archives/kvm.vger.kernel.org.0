Return-Path: <kvm+bounces-10460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBF586C42E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10B2C289B0A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E7C54BFF;
	Thu, 29 Feb 2024 08:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="URgn+RvK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12DC54F84
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709196693; cv=none; b=H1P6fhy03du4bu2+qv12zg3jEHt4fghmx4X1tNLPfcYXQAugd46tSrj3eps/U6oQfT3bk8AQ5HSWz7lMlFWvJ3fSMDLdwDEjv4mCGIGtnjQjsInbFQqRRpUud+GbaSEVIuMbvnpxib2r5/Xp7sm8CVw3m+v818URUA5BOh+oL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709196693; c=relaxed/simple;
	bh=iybzTDvN2IxrTgJuQVgumevy/8vximnQzYeJxPzO3sE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WdhTP1Mizk+HdVeaHt6eT9RT+yiE/OkR/tTWBPcro0gwpZC5igDXUbG/8u9QeBS0jDlK5ta09Rkw4S8Mq6wxRfnvZKzTHckVva+LIMo3K0FrVL/zzfJVV6z9IcnP9W2ha5hi4afXO/jpwjURsBDB3h6DjXAoUl9JAToE9QtZ4p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=URgn+RvK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709196690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyg6CutsuLQmtFSTU/FvNmgrRpHcjvx7pf+fPUH+dPY=;
	b=URgn+RvKvDtjnHYTDSVUlv+jJu6qLH6m2dsYUyO769k33onJMCnyvyXZGtsQOK0Wogqzv+
	cXgA/psIMo6czkmfGT6SssaIYpF9cgq9jQoDvfVFAJX/bRGSw4wfVMlnQg45DqVeFCWpeZ
	XCqnRs3S40bbdzEQHEfiPaA6f5T/4nI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-HPgFOnXVM_WFkxdbxaey9g-1; Thu, 29 Feb 2024 03:51:24 -0500
X-MC-Unique: HPgFOnXVM_WFkxdbxaey9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1B1A863066;
	Thu, 29 Feb 2024 08:51:23 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75B8D1C060AF;
	Thu, 29 Feb 2024 08:51:23 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4B20C21E6740; Thu, 29 Feb 2024 09:51:22 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  Igor Mammedov <imammedo@redhat.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  "Michael S. Tsirkin" <mst@redhat.com>,  Richard
 Henderson <richard.henderson@linaro.org>,  Ani Sinha
 <anisinha@redhat.com>,  Peter Xu <peterx@redhat.com>,  Cornelia Huck
 <cohuck@redhat.com>,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eric
 Blake <eblake@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,
  kvm@vger.kernel.org,  qemu-devel@nongnu.org,  Michael Roth
 <michael.roth@amd.com>,  Claudio Fontana <cfontana@suse.de>,  Gerd
 Hoffmann <kraxel@redhat.com>,  Isaku Yamahata <isaku.yamahata@gmail.com>,
  Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v5 52/65] i386/tdx: Wire TDX_REPORT_FATAL_ERROR with
 GuestPanic facility
In-Reply-To: <20240229063726.610065-53-xiaoyao.li@intel.com> (Xiaoyao Li's
	message of "Thu, 29 Feb 2024 01:37:13 -0500")
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
	<20240229063726.610065-53-xiaoyao.li@intel.com>
Date: Thu, 29 Feb 2024 09:51:22 +0100
Message-ID: <874jdr1wmt.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Integrate TDX's TDX_REPORT_FATAL_ERROR into QEMU GuestPanic facility
>
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v5:
> - mention additional error information in gpa when it presents;
> - refine the documentation; (Markus)
>
> Changes in v4:
> - refine the documentation; (Markus)
>
> Changes in v3:
> - Add docmentation of new type and struct; (Daniel)
> - refine the error message handling; (Daniel)
> ---
>  qapi/run-state.json   | 31 +++++++++++++++++++++--
>  system/runstate.c     | 58 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 +++++++++++++++++-
>  3 files changed, 110 insertions(+), 3 deletions(-)
>
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index dd0770b379e5..b71dd1884eb6 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -483,10 +483,12 @@
>  #
>  # @s390: s390 guest panic information type (Since: 2.12)
>  #
> +# @tdx: tdx guest panic information type (Since: 9.0)
> +#
>  # Since: 2.9
>  ##
>  { 'enum': 'GuestPanicInformationType',
> -  'data': [ 'hyper-v', 's390' ] }
> +  'data': [ 'hyper-v', 's390', 'tdx' ] }
>=20=20
>  ##
>  # @GuestPanicInformation:
> @@ -501,7 +503,8 @@
>   'base': {'type': 'GuestPanicInformationType'},
>   'discriminator': 'type',
>   'data': {'hyper-v': 'GuestPanicInformationHyperV',
> -          's390': 'GuestPanicInformationS390'}}
> +          's390': 'GuestPanicInformationS390',
> +          'tdx' : 'GuestPanicInformationTdx'}}
>=20=20
>  ##
>  # @GuestPanicInformationHyperV:
> @@ -564,6 +567,30 @@
>            'psw-addr': 'uint64',
>            'reason': 'S390CrashReason'}}
>=20=20
> +##
> +# @GuestPanicInformationTdx:
> +#
> +# TDX Guest panic information specific to TDX, as specified in the
> +# "Guest-Hypervisor Communication Interface (GHCI) Specification",
> +# section TDG.VP.VMCALL<ReportFatalError>.
> +#
> +# @error-code: TD-specific error code
> +#
> +# @message: Human-readable error message provided by the guest. Not
> +#     to be trusted.
> +#
> +# @gpa: guest-physical address of a page that contains more verbose
> +#     error information, as zero-terminated string.  Present when the
> +#     "GPA valid" bit (bit 63) is set in @error-code.

Uh, peeking at GHCI Spec section 3.4 TDG.VP.VMCALL<ReportFatalError>, I
see operand R12 consists of

    bits    name                        description
    31:0    TD-specific error code      TD-specific error code
                                        Panic =E2=80=93 0x0.
                                        Values =E2=80=93 0x1 to 0xFFFFFFFF
                                        reserved.
    62:32   TD-specific extended        TD-specific extended error code.
            error code                  TD software defined.
    63      GPA Valid                   Set if the TD specified additional
                                        information in the GPA parameter
                                        (R13).

Is @error-code all of R12, or just bits 31:0?

If it's all of R12, description of @error-code as "TD-specific error
code" is misleading.

If it's just bits 31:0, then 'Present when the "GPA valid" bit (bit 63)
is set in @error-code' is wrong.  Could go with 'Only present when the
guest provides this information'.

> +#
> +#

Drop one of these two lines, please.

> +# Since: 9.0
> +##
> +{'struct': 'GuestPanicInformationTdx',
> + 'data': {'error-code': 'uint64',
> +          'message': 'str',
> +          '*gpa': 'uint64'}}
> +
>  ##
>  # @MEMORY_FAILURE:
>  #


