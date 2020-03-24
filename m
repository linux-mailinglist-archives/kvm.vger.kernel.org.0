Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043311918B6
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 19:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCXSNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 14:13:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47951 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727333AbgCXSNn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 14:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6QLK33i849af4hEmu/J5wDSq8WslN7JUyycX0ysPho=;
        b=Xg4zLK3HqOIAOGnM57q1UdQ4c86P4x2bROFP0L2+nad61ovV6V0nverlXh6P+BimYudlMN
        KabWcshLHQzKCOX7gOtOXQSifsaY8QTzUvvKHZAlI7BJ4Il2VI9uJg3oJLUslJKpEJ/8cB
        FCfG++k440b2MIUEhaP8ouBsI8xn5Xo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-catrZUcHO3K6sgr5JFIfXg-1; Tue, 24 Mar 2020 14:13:35 -0400
X-MC-Unique: catrZUcHO3K6sgr5JFIfXg-1
Received: by mail-wr1-f69.google.com with SMTP id d17so9529396wrs.7
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 11:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z6QLK33i849af4hEmu/J5wDSq8WslN7JUyycX0ysPho=;
        b=AcbZnfj11ZcoS2I+ujwJDir7/U/LQ068htabi2lsXnK4qzmPtSyPQIWwGenKU0AcE/
         C5FwlKCILa3HIcUsrgSrjRiOyeBv+tjSJScYnTMhPx6xbtsS6e43oXse/jpRFsa9dnUj
         CvJAIvyOk4QJhNeiPcA4dLlLDeu6uNl1FxgnCaFspcw+BgKdmq2Y2n9HSb2acgzqoEt5
         IxoH3eWyx/e9upkPfr6q/Y4UoLkMOS/9HpgwTYB43tImcm+zXLxwLPlVTkPXnIgXuGFj
         NabKi55vI63fpIacbEo3keM30MQ52RUxnhQNp8JsOFdEvEfs+vjV60OoE0lDZYeY3BRy
         Zakg==
X-Gm-Message-State: ANhLgQ2wJwSGmioRlqAzSNCAkd91daLJ+HOeRla7zKf+INq2J6G5tEB5
        muXNRf9+4vTzEO+HVM0t0jbv/lvpSh7OoepULn+7hjNGpd27bB+FQXMD6vAaZ3i1ubqsycN3kls
        gmjSgsDaBAiCH
X-Received: by 2002:a5d:5447:: with SMTP id w7mr9724223wrv.299.1585073613838;
        Tue, 24 Mar 2020 11:13:33 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vutjFibWsKyOpF1Og+qU3JJjjdCrScHYPPtGzcpKNpj4B7DycBDMcVXBCXiqossd0yd7z0fGQ==
X-Received: by 2002:a5d:5447:: with SMTP id w7mr9724175wrv.299.1585073613529;
        Tue, 24 Mar 2020 11:13:33 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k204sm5490292wma.17.2020.03.24.11.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:13:32 -0700 (PDT)
Date:   Tue, 24 Mar 2020 14:13:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v1 17/22] intel_iommu: do not pass down pasid bind for
 PASID #0
Message-ID: <20200324181326.GB127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-18-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-18-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:14AM -0700, Liu Yi L wrote:
> RID_PASID field was introduced in VT-d 3.0 spec, it is used
> for DMA requests w/o PASID in scalable mode VT-d. It is also
> known as IOVA. And in VT-d 3.1 spec, there is definition on it:
> 
> "Implementations not supporting RID_PASID capability
> (ECAP_REG.RPS is 0b), use a PASID value of 0 to perform
> address translation for requests without PASID."
> 
> This patch adds a check against the PASIDs which are going to be
> bound to device. For PASID #0, it is not necessary to pass down
> pasid bind request for it since PASID #0 is used as RID_PASID for
> DMA requests without pasid. Further reason is current Intel vIOMMU
> supports gIOVA by shadowing guest 2nd level page table. However,
> in future, if guest IOMMU driver uses 1st level page table to store
> IOVA mappings, then guest IOVA support will also be done via nested
> translation. When gIOVA is over FLPT, then vIOMMU should pass down
> the pasid bind request for PASID #0 to host, host needs to bind the
> guest IOVA page table to a proper PASID. e.g PASID value in RID_PASID
> field for PF/VF if ECAP_REG.RPS is clear or default PASID for ADI
> (Assignable Device Interface in Scalable IOV solution).
> 
> IOVA over FLPT support on Intel VT-d:
> https://lkml.org/lkml/2019/9/23/297
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 1e0ccde..b007715 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -1886,6 +1886,16 @@ static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
>      struct iommu_gpasid_bind_data *g_bind_data;
>      int ret = -1;
>  
> +    if (pasid < VTD_MIN_HPASID) {
> +        /*
> +         * If pasid < VTD_HPASID_MIN, this pasid is not allocated

s/VTD_HPASID_MIN/VTD_MIN_HPASID/.

> +         * from host. No need to pass down the changes on it to host.
> +         * TODO: when IOVA over FLPT is ready, this switch should be
> +         * refined.

What will happen if without this patch?  Is it a must?

> +         */
> +        return 0;
> +    }
> +
>      vtd_dev_icx = vtd_bus->dev_icx[devfn];
>      if (!vtd_dev_icx) {
>          return -EINVAL;
> -- 
> 2.7.4
> 

-- 
Peter Xu

