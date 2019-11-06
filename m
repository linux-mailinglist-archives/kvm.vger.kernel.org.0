Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0FEF1B9E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 17:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbfKFQtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 11:49:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25313 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728462AbfKFQtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 11:49:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573058948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y3J2bTTmOsm3d0BAKb6B0gbVdRBPy0F4WDWyUAlOHcU=;
        b=O7cYDDycYmYLVuh/J/BXugBqWpqIR2c6QCmJqj8bHqyBPonkACE7vt2uqxD8dWCcn02bhO
        zOf0WbdhTSvV+xFFyL6+fdbuivV8JZKE504O6GgGsuqweO6Jda2H3CGScIt8YyRdS+IOMF
        JA5W+BC1M2Dl2O0rnRC3ZOTg/K3+GGY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-cjq_llWXMLqIfbsPfkmCPA-1; Wed, 06 Nov 2019 11:49:04 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE5FD1800D53;
        Wed,  6 Nov 2019 16:49:02 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE13D60872;
        Wed,  6 Nov 2019 16:48:57 +0000 (UTC)
Date:   Wed, 6 Nov 2019 17:48:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 30/37] DOCUMENTATION: protvirt: Diag 308 IPL
Message-ID: <20191106174855.13a50f42.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-31-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-31-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: cjq_llWXMLqIfbsPfkmCPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:52 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Description of changes that are necessary to move a KVM VM into
> Protected Virtualization mode.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/s390-pv-boot.txt | 62 ++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/s390-pv-boot.txt
>=20
> diff --git a/Documentation/virtual/kvm/s390-pv-boot.txt b/Documentation/v=
irtual/kvm/s390-pv-boot.txt
> new file mode 100644
> index 000000000000..af883c928c08
> --- /dev/null
> +++ b/Documentation/virtual/kvm/s390-pv-boot.txt
> @@ -0,0 +1,62 @@
> +Boot/IPL of Protected VMs
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Summary:
> +
> +Protected VMs are encrypted while not running. On IPL a small
> +plaintext bootloader is started which provides information about the
> +encrypted components and necessary metadata to KVM to decrypt it.
> +
> +Based on this data, KVM will make the PV known to the Ultravisor and
> +instruct it to secure its memory, decrypt the components and verify
> +the data and address list hashes, to ensure integrity. Afterwards KVM
> +can run the PV via SIE which the UV will intercept and execute on
> +KVM's behalf.
> +
> +The switch into PV mode lets us load encrypted guest executables and
> +data via every available method (network, dasd, scsi, direct kernel,
> +...) without the need to change the boot process.
> +
> +
> +Diag308:
> +
> +This diagnose instruction is the basis vor VM IPL. The VM can set and

s/vor/for/

> +retrieve IPL information blocks, that specify the IPL method/devices
> +and request VM memory and subsystem resets, as well as IPLs.
> +
> +For PVs this concept has been continued with new subcodes:
> +
> +Subcode 8: Set an IPL Information Block of type 5.
> +Subcode 9: Store the saved block in guest memory
> +Subcode 10: Move into Protected Virtualization mode
> +
> +The new PV load-device-specific-parameters field specifies all data,
> +that is necessary to move into PV mode.
> +
> +* PV Header origin
> +* PV Header length
> +* List of Components composed of:
> +  * AES-XTS Tweak prefix
> +  * Origin
> +  * Size
> +
> +The PV header contains the keys and hashes, which the UV will use to
> +decrypt and verify the PV, as well as control flags and a start PSW.
> +
> +The components are for instance an encrypted kernel, kernel cmd and
> +initrd. The components are decrypted by the UV.
> +
> +All non-decrypted data of the non-PV guest instance are zero on first
> +access of the PV.
> +
> +
> +When running in a protected mode some subcodes will result in
> +exceptions or return error codes.
> +
> +Subcodes 4 and 7 will result in specification exceptions.
> +When removing a secure VM, the UV will clear all memory, so we can't
> +have non-clearing IPL subcodes.
> +
> +Subcodes 8, 9, 10 will result in specification exceptions.
> +Re-IPL into a protected mode is only possible via a detour into non
> +protected mode.

So... what do we IPL from? Is there still a need for the bios?

(Sorry, I'm a bit confused here.)

