Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B5213BE1F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 12:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgAOLDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 06:03:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27775 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730066AbgAOLDN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 06:03:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579086191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kIPIuogeyAYrg89WQev5yF8VWAACc+O4YaYZpb1gn0E=;
        b=VPc7ElSLL4HcB9Pn29Pr3LJVX9zddwMexITMD8zR01jDLaPBXsOcREcmkXK4xQWDEz+kDC
        /7YONRgBJAQ3oCK9AxoScmU8qur18ES+NDKLW4pS59TFz8OW6qovyXM0bOB8BZ8MHhVDsI
        q8IXmv+nEOLUoRrSRbqT9Ba4Z6/9oo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-ZgxqKH6bOs2G1of-EpJ_1g-1; Wed, 15 Jan 2020 06:03:10 -0500
X-MC-Unique: ZgxqKH6bOs2G1of-EpJ_1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42357107ACE3;
        Wed, 15 Jan 2020 11:03:09 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1567811E0;
        Wed, 15 Jan 2020 11:03:02 +0000 (UTC)
Date:   Wed, 15 Jan 2020 12:03:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 05/12] vfio_pci: duplicate vfio_pci.c
Message-ID: <20200115120300.24874a37.cohuck@redhat.com>
In-Reply-To: <1578398509-26453-6-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-6-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:42 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch has no code change, just a file copy. In following patches,
> vfio_pci_common.c will be modified to only include the common functions
> and related static functions in original vfio_pci.c. Meanwhile, vfio_pci.c
> will be modified to only include vfio-pci module specific codes.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_common.c | 1708 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 1708 insertions(+)
>  create mode 100644 drivers/vfio/pci/vfio_pci_common.c

This whole procedure of "let's copy the file and rip out unneeded stuff
later" looks very ugly to me, especially if I'd come across it in the
future, e.g. during a bisect. This patch only adds a file that is not
compiled, and later changes will be "rip out unwanted stuff from
vfio_pci_common.c" instead of the more positive "move common stuff to
vfio_pci_common.c". I think refactoring/moving interfaces/code that it
makes sense to share makes this more reviewable, both now and in the
future.

