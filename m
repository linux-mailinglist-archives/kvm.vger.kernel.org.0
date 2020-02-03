Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ACF150A94
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 17:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgBCQNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 11:13:48 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727253AbgBCQNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 11:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580746426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rh12wnJgzOR40bsCZ8JX3hD/ou6m3rwjUqvviSvYo3E=;
        b=bVohKrRMGpgXUqStOEXTdMihfP9KX+iqwQt/fh9CxOPjHdMY/nMKp+EJwYq4jeQ6agB/5q
        d3iDEFuKPdfQQOYwJV7Osui10mnkez0rImGheabwa3NOmIlBNPS0ZOR4DilJas8I5mVhU8
        /WCRTXDrm+eECLwOTOmhSMLBUMmOLCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-T9MgW3sHMO6-RZipxzIWRg-1; Mon, 03 Feb 2020 11:13:41 -0500
X-MC-Unique: T9MgW3sHMO6-RZipxzIWRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 957F9107ACCC;
        Mon,  3 Feb 2020 16:13:40 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7783119C58;
        Mon,  3 Feb 2020 16:13:36 +0000 (UTC)
Date:   Mon, 3 Feb 2020 17:13:33 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 29/37] DOCUMENTATION: protvirt: Diag 308 IPL
Message-ID: <20200203171333.6be61670.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-30-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-30-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:49 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Description of changes that are necessary to move a KVM VM into
> Protected Virtualization mode.

Maybe move this up to the top of the series, so that new reviewers can
get a quick idea about the architecture as a whole? It might also make
sense to make the two documents link to each other...

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virt/kvm/s390-pv-boot.rst | 64 +++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
> 
> diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
> new file mode 100644
> index 000000000000..431cd5d7f686
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390-pv-boot.rst
> @@ -0,0 +1,64 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +=========================
> +Boot/IPL of Protected VMs
> +=========================

...especially as the reader will have no idea what a "Protected VM" is,
unless they have read the other document before.


> +
> +Summary
> +-------
> +Protected VMs are encrypted while not running. On IPL a small
> +plaintext bootloader is started which provides information about the
> +encrypted components and necessary metadata to KVM to decrypt it.

s/it/the PVM/ ?

> +
> +Based on this data, KVM will make the PV known to the Ultravisor and

I think the other document uses 'PVM'... probably better to keep that
consistent.

> +instruct it to secure its memory, decrypt the components and verify

Too many it and its here... maybe use the abbreviations instead?

> +the data and address list hashes, to ensure integrity. Afterwards KVM
> +can run the PV via SIE which the UV will intercept and execute on
> +KVM's behalf.
> +
> +The switch into PV mode lets us load encrypted guest executables and
> +data via every available method (network, dasd, scsi, direct kernel,
> +...) without the need to change the boot process.
> +
> +
> +Diag308
> +-------
> +This diagnose instruction is the basis for VM IPL. The VM can set and
> +retrieve IPL information blocks, that specify the IPL method/devices
> +and request VM memory and subsystem resets, as well as IPLs.
> +
> +For PVs this concept has been continued with new subcodes:

s/continued/extended/ ?

> +
> +Subcode 8: Set an IPL Information Block of type 5.

"type 5" == information block for PVMs? Better spell that out.

> +Subcode 9: Store the saved block in guest memory
> +Subcode 10: Move into Protected Virtualization mode
> +
> +The new PV load-device-specific-parameters field specifies all data,
> +that is necessary to move into PV mode.
> +
> +* PV Header origin
> +* PV Header length
> +* List of Components composed of
> +   * AES-XTS Tweak prefix
> +   * Origin
> +   * Size
> +
> +The PV header contains the keys and hashes, which the UV will use to
> +decrypt and verify the PV, as well as control flags and a start PSW.
> +
> +The components are for instance an encrypted kernel, kernel cmd and

s/kernel cmd/kernel command line/ ?

> +initrd. The components are decrypted by the UV.
> +
> +All non-decrypted data of the non-PV guest instance are zero on first
> +access of the PV.

"non-PV guest" == "the guest before it switches to protected
virtualization mode" ?

> +
> +
> +When running in a protected mode some subcodes will result in

s/in a/in/

> +exceptions or return error codes.
> +
> +Subcodes 4 and 7 will result in specification exceptions.

"Subcodes 4 and 7, which would not clear the guest memory, ..." ?

> +When removing a secure VM, the UV will clear all memory, so we can't
> +have non-clearing IPL subcodes.
> +
> +Subcodes 8, 9, 10 will result in specification exceptions.
> +Re-IPL into a protected mode is only possible via a detour into non
> +protected mode.

In general, this looks like a good overview about how the guest can
move into protected virt mode.

Some information I'm missing in this doc: Where do the keys come from?
I assume from the machine... is there one key per CEC? Can keys be
transferred? Can an image be introspected to find out if it is possible
to run it on a given system?

(Not sure if there is a better resting place for that kind of
information.)

