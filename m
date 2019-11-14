Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F095FC6F6
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfKNNKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:10:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60023 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbfKNNKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 08:10:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573736999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yyZbS56I4tAONF7KcICPVxNVSf4T1PDtqDFeQbrNXM=;
        b=bqepkPiZI7D7bkRnJGRZ7mjwZH/QlkpxoQZvJTekYFs/BEVTvpWaHyh6HJO20wRU8hXKh/
        2Px3UUzMTCNG+rmzAP8yQ/6Eo3xGm1ksH9kUrWuFaLYpWPzkTfDcQTBTUiLq1XOcaJuJMp
        DQG1SXkzBGsc/2JLhEL5oa5fkMibMes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-gDdAxXV3MQGUwrIzoj9RUA-1; Thu, 14 Nov 2019 08:09:55 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0120B1006805;
        Thu, 14 Nov 2019 13:09:54 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3A9575E51;
        Thu, 14 Nov 2019 13:09:48 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:09:46 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 11/37] DOCUMENTATION: protvirt: Interrupt injection
Message-ID: <20191114140946.7bca2350.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-12-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-12-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: gDdAxXV3MQGUwrIzoj9RUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:33 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Interrupt injection has changed a lot for protected guests, as KVM
> can't access the cpus' lowcores. New fields in the state description,
> like the interrupt injection control, and masked values safeguard the
> guest from KVM.
>=20
> Let's add some documentation to the interrupt injection basics for
> protected guests.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/s390-pv.txt | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/Documentation/virtual/kvm/s390-pv.txt b/Documentation/virtua=
l/kvm/s390-pv.txt
> index 86ed95f36759..e09f2dc5f164 100644
> --- a/Documentation/virtual/kvm/s390-pv.txt
> +++ b/Documentation/virtual/kvm/s390-pv.txt
> @@ -21,3 +21,30 @@ normally needed to be able to run a VM, some changes h=
ave been made in
>  SIE behavior and fields have different meaning for a PVM. SIE exits
>  are minimized as much as possible to improve speed and reduce exposed
>  guest state.
> +
> +
> +Interrupt injection:
> +
> +Interrupt injection is safeguarded by the Ultravisor and, as KVM lost
> +access to the VCPUs' lowcores, is handled via the format 4 state
> +description.
> +
> +Machine check, external, IO and restart interruptions each can be
> +injected on SIE entry via a bit in the interrupt injection control
> +field (offset 0x54). If the guest cpu is not enabled for the interrupt
> +at the time of injection, a validity interception is recognized. The
> +interrupt's data is transported via parts of the interception data
> +block.

"Data associated with the interrupt needs to be placed into the
respective fields in the interception data block to be injected into
the guest."

?

> +
> +Program and Service Call exceptions have another layer of
> +safeguarding, they are only injectable, when instructions have
> +intercepted into KVM and such an exception can be an emulation result.

I find this sentence hard to parse... not sure if I understand it
correctly.

"They can only be injected if the exception can be encountered during
emulation of instructions that had been intercepted into KVM."

?

> +
> +
> +Mask notification interceptions:
> +As a replacement for the lctl(g) and lpsw(e) interception, two new
> +interception codes have been introduced. One which tells us that CRs
> +0, 6 or 14 have been changed and therefore interrupt masking might
> +have changed. And one for PSW bit 13 changes. The CRs and the PSW in

Might be helpful to mention that this bit covers machine checks, which
do not get a separate bit in the control block :)

> +the state description only contain the mask bits and no further info
> +like the current instruction address.

"The CRs and the PSW in the state description only contain the bits
referring to interrupt masking; other fields like e.g. the current
instruction address are zero."

?

