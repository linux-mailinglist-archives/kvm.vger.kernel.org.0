Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD42FC9A3
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfKNPPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:15:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbfKNPPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573744553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nm7qa9QDVub7198Yoayd+jd7gSzFXSMeqbfa75+yNE=;
        b=SwtKux8UNX7z16wwgFfhFJS/4E32LKcJrm0wykSKsRu3swGvm/bpCA8wzKn3o5BwupyhH8
        WYtLzyHXttqRKnbsFG2mM4VmQnVGQ/92uJ5utNp+YGPYl4HtIvLpGUQCfl0vldx2zjfY+b
        m6JirT3ZzyYGpGPqXzLiZFPOz8aleVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-ZiS27w5VPQysJLVQ7ZBBuw-1; Thu, 14 Nov 2019 10:15:50 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A923CDBCC;
        Thu, 14 Nov 2019 15:15:48 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54C96364A;
        Thu, 14 Nov 2019 15:15:28 +0000 (UTC)
Date:   Thu, 14 Nov 2019 16:15:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 17/37] DOCUMENTATION: protvirt: Instruction emulation
Message-ID: <20191114161526.1100f4fe.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-18-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-18-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ZiS27w5VPQysJLVQ7ZBBuw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:39 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> As guest memory is inaccessible and information about the guest's
> state is very limited, new ways for instruction emulation have been
> introduced.
>=20
> With a bounce area for guest GRs and instruction data, guest state
> leaks can be limited by the Ultravisor. KVM now has to move
> instruction input and output through these areas.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/s390-pv.txt | 47 +++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>=20
> diff --git a/Documentation/virtual/kvm/s390-pv.txt b/Documentation/virtua=
l/kvm/s390-pv.txt
> index e09f2dc5f164..cb08d78a7922 100644
> --- a/Documentation/virtual/kvm/s390-pv.txt
> +++ b/Documentation/virtual/kvm/s390-pv.txt
> @@ -48,3 +48,50 @@ interception codes have been introduced. One which tel=
ls us that CRs
>  have changed. And one for PSW bit 13 changes. The CRs and the PSW in
>  the state description only contain the mask bits and no further info
>  like the current instruction address.
> +
> +
> +Instruction emulation:
> +With the format 4 state description the SIE instruction already

s/description/description,/

> +interprets more instructions than it does with format 2. As it is not
> +able to interpret all instruction, the SIE and the UV safeguard KVM's

s/instruction/instructions/

> +emulation inputs and outputs.
> +
> +Guest GRs and most of the instruction data, like IO data structures

Hm, what 'IO data structures'?

> +are filtered. Instruction data is copied to and from the Secure
> +Instruction Data Area. Guest GRs are put into / retrieved from the
> +Interception-Data block.
> +
> +The Interception-Data block from the state description's offset 0x380
> +contains GRs 0 - 16. Only GR values needed to emulate an instruction
> +will be copied into this area.
> +
> +The Interception Parameters state description field still contains the
> +the bytes of the instruction text but with pre-set register
> +values. I.e. each instruction always uses the same instruction text,
> +to not leak guest instruction text.
> +
> +The Secure Instruction Data Area contains instruction storage
> +data. Data for diag 500 is exempt from that and has to be moved
> +through shared buffers to KVM.

I find this paragraph a bit confusing. What does that imply for diag
500 interception? Data is still present in gprs 1-4?

(Also, why only diag 500? Because it is the 'reserved for kvm' diagnose
call?)

> +
> +When SIE intercepts an instruction, it will only allow data and
> +program interrupts for this instruction to be moved to the guest via
> +the two data areas discussed before. Other data is ignored or results
> +in validity interceptions.
> +
> +
> +Instruction emulation interceptions:
> +There are two types of SIE secure instruction intercepts. The normal
> +and the notification type. Normal secure instruction intercepts will
> +make the guest pending for instruction completion of the intercepted
> +instruction type, i.e. on SIE entry it is attempted to complete
> +emulation of the instruction with the data provided by KVM. That might
> +be a program exception or instruction completion.
> +
> +The notification type intercepts inform KVM about guest environment
> +changes due to guest instruction interpretation. Such an interception

'interpretation by SIE' ?

> +is recognized for the store prefix instruction and provides the new
> +lowcore location for mapping change notification arming. Any KVM data
> +in the data areas is ignored, program exceptions are not injected and
> +execution continues on next SIE entry, as if no intercept had
> +happened.

