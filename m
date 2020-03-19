Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D4718BDFE
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgCSR1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:27:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:46905 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727816AbgCSR1n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584638861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nLOauL8M9FVaEJHiI8vrCSN5L9Q/vL8MaYK0pNPq4Zs=;
        b=UyacAYpCoavE0GRvLqfBXEGbcGLl0u5N82RTZk9uoxq1d3sDbgvGgiuWaWc46TXtPYQOwY
        3CRCqtyhUksesayaAbX54kdlE3KvgMTxG157lM2E4jbPzz3/5W3vBap7sYggop0OMkDl7Q
        KAW40SJkV1Fl8yR4/7rSamkmC2QyaUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-Ykp0k2vZNi68gU2utY-ppQ-1; Thu, 19 Mar 2020 13:27:40 -0400
X-MC-Unique: Ykp0k2vZNi68gU2utY-ppQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DED41857BE0;
        Thu, 19 Mar 2020 17:27:38 +0000 (UTC)
Received: from gondolin (ovpn-113-188.ams2.redhat.com [10.36.113.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F5D760BF1;
        Thu, 19 Mar 2020 17:27:33 +0000 (UTC)
Date:   Thu, 19 Mar 2020 18:27:30 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, kevin.tian@intel.com
Subject: Re: [PATCH v3 3/7] vfio/pci: Introduce VF token
Message-ID: <20200319182730.16f4c476.cohuck@redhat.com>
In-Reply-To: <158396393244.5601.10297430724964025753.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
        <158396393244.5601.10297430724964025753.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 15:58:52 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> If we enable SR-IOV on a vfio-pci owned PF, the resulting VFs are not
> fully isolated from the PF.  The PF can always cause a denial of service
> to the VF, even if by simply resetting itself.  The degree to which a PF
> can access the data passed through a VF or interfere with its operation
> is dependent on a given SR-IOV implementation.  Therefore we want to
> avoid a scenario where an existing vfio-pci based userspace driver might
> assume the PF driver is trusted, for example assigning a PF to one VM
> and VF to another with some expectation of isolation.  IOMMU grouping
> could be a solution to this, but imposes an unnecessarily strong
> relationship between PF and VF drivers if they need to operate with the
> same IOMMU context.  Instead we introduce a "VF token", which is
> essentially just a shared secret between PF and VF drivers, implemented
> as a UUID.
> 
> The VF token can be set by a vfio-pci based PF driver and must be known
> by the vfio-pci based VF driver in order to gain access to the device.
> This allows the degree to which this VF token is considered secret to be
> determined by the applications and environment.  For example a VM might
> generate a random UUID known only internally to the hypervisor while a
> userspace networking appliance might use a shared, or even well know,
> UUID among the application drivers.
> 
> To incorporate this VF token, the VFIO_GROUP_GET_DEVICE_FD interface is
> extended to accept key=value pairs in addition to the device name.  This
> allows us to most easily deny user access to the device without risk
> that existing userspace drivers assume region offsets, IRQs, and other
> device features, leading to more elaborate error paths.  The format of
> these options are expected to take the form:
> 
> "$DEVICE_NAME $OPTION1=$VALUE1 $OPTION2=$VALUE2"
> 
> Where the device name is always provided first for compatibility and
> additional options are specified in a space separated list.  The
> relation between and requirements for the additional options will be
> vfio bus driver dependent, however unknown or unused option within this
> schema should return error.  This allow for future use of unknown
> options as well as a positive indication to the user that an option is
> used.
> 
> An example VF token option would take this form:
> 
> "0000:03:00.0 vf_token=2ab74924-c335-45f4-9b16-8569e5b08258"
> 
> When accessing a VF where the PF is making use of vfio-pci, the user
> MUST provide the current vf_token.  When accessing a PF, the user MUST
> provide the current vf_token IF there are active VF users or MAY provide
> a vf_token in order to set the current VF token when no VF users are
> active.  The former requirement assures VF users that an unassociated
> driver cannot usurp the PF device.  These semantics also imply that a
> VF token MUST be set by a PF driver before VF drivers can access their
> device, the default token is random and mechanisms to read the token are
> not provided in order to protect the VF token of previous users.  Use of
> the vf_token option outside of these cases will return an error, as
> discussed above.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         |  198 +++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |    8 +
>  2 files changed, 205 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

