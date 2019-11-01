Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAFEC847
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKASJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfKASJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:09:54 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38463C00EB16
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 18:09:54 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id b4so5898320wrn.8
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8jUfco7qh0pcrSjrShTOcaIDt+470HVcOI3AOAmvFn8=;
        b=Akz06xXFA4CwHQ0LZjmPbxr1/85IbIUpMsBPNiCrBUL8uLuzN5fhNRGlQSM2sP9X0v
         +wB+LXKHZiYjNoIbzttZrs24M+ybl46i0rKnGktavgsXdm+p2GlA2IV7SNjEfm3JGc32
         FuWsfRO05NNndVTn8JH11O7eQVNtdyi90uG5MHLhj0ZYR18CXbZdIvgMb8kQOYGuePO1
         351hqfwyVdvMqqsBvEnA8WF26vsJ3d9yuEizrgD+z3W9QXivDnAZI5XFLxOQt1lkq7US
         8XESzU8GgaRKD2S0A6tIPTQsklRii0Xxtw+gFEx6gNVduiYwCrbKK7OufMKzma3RVYlL
         FoMA==
X-Gm-Message-State: APjAAAVOg8s/iZJ/IJpju7V9eSlUHKseQbJIFbZiU8kteESmn2LoT41J
        GjrTW9NMbj6fcR9UwmhVLnpW/vMjiM8DtfRQm8fV/cPFrVwC9DiCH0Y8W2+KNRYI66QT2j19lb0
        SA5kCGTV12UWX
X-Received: by 2002:a5d:5444:: with SMTP id w4mr10145406wrv.164.1572631792983;
        Fri, 01 Nov 2019 11:09:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy4NENz4o79PqRKSRVv5SOg7yKO+WfQ2dEggLZBDl7qe74/tZGua7zuZfCFnPpCCMW320O/gQ==
X-Received: by 2002:a5d:5444:: with SMTP id w4mr10145398wrv.164.1572631792803;
        Fri, 01 Nov 2019 11:09:52 -0700 (PDT)
Received: from xz-x1.metropole.lan (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id p15sm8829146wrs.94.2019.11.01.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 11:09:51 -0700 (PDT)
Date:   Fri, 1 Nov 2019 19:09:49 +0100
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 07/22] hw/pci: introduce pci_device_iommu_context()
Message-ID: <20191101180949.GH8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-8-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-8-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:28AM -0400, Liu Yi L wrote:
> This patch adds pci_device_iommu_context() to get an iommu_context
> for a given device. A new callback is added in PCIIOMMUOps. Users
> who wants to listen to events issued by vIOMMU could use this new
> interface to get an iommu_context and register their own notifiers,
> then wait for notifications from vIOMMU. e.g. VFIO is the first user
> of it to listen to the PASID_ALLOC/PASID_BIND/CACHE_INV events and
> propagate the events to host.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu
