Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF7F19BD9F
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgDBIdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:33:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58482 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728455AbgDBIdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585816415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vF5jPTjMAXWG5nK+NfmmXnNhmeLxxH3USCdZc5XlsGU=;
        b=GwsdPZsVvbtujt7kO1djmf42wZyOpDGq32vWoHbPoC9IC6cJuAmuhOItIYIQcnm8Tx+CgE
        w54XV/wMtWwIi6tB0MppSA6g92jt2vV7ZsPWUdmEzWcWocwOrSgLUFtmeZ3gvNjzZny0Dl
        wPnbZgcq5LRqSUKqPBID42Zfxd6gfrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-sX4YZp29N12m13l0esWiOQ-1; Thu, 02 Apr 2020 04:33:29 -0400
X-MC-Unique: sX4YZp29N12m13l0esWiOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A5C310CE7AC;
        Thu,  2 Apr 2020 08:33:27 +0000 (UTC)
Received: from [10.72.13.209] (ovpn-13-209.pek2.redhat.com [10.72.13.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAA7F261D5;
        Thu,  2 Apr 2020 08:33:04 +0000 (UTC)
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VMs
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com,
        kvm@vger.kernel.org, mst@redhat.com, jun.j.tian@intel.com,
        eric.auger@redhat.com, yi.y.sun@intel.com, pbonzini@redhat.com,
        hao.wu@intel.com, david@gibson.dropbear.id.au
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <984e6f47-2717-44fb-7ff2-95ca61d1858f@redhat.com>
Date:   Thu, 2 Apr 2020 16:33:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/3/30 =E4=B8=8B=E5=8D=8812:24, Liu Yi L wrote:
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance securit=
y.
>
> This QEMU series is intended to expose SVA usage to VMs. i.e. Sharing
> guest application address space with passthru devices. This is called
> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> changes.
>
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
>
>      .-------------.  .---------------------------.
>      |   vIOMMU    |  | Guest process CR3, FL only|
>      |             |  '---------------------------'
>      .----------------/
>      | PASID Entry |--- PASID cache flush -
>      '-------------'                       |
>      |             |                       V
>      |             |                CR3 in GPA
>      '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>        v        v                          v
> Host
>      .-------------.  .----------------------.
>      |   pIOMMU    |  | Bind FL for GVA-GPA  |
>      |             |  '----------------------'
>      .----------------/  |
>      | PASID Entry |     V (Nested xlate)
>      '----------------\.------------------------------.
>      |             ||SL for GPA-HPA, default domain|
>      |             |   '------------------------------'
>      '-------------'
> Where:
>   - FL =3D First level/stage one page tables
>   - SL =3D Second level/stage two page tables
>
> The complete vSVA kernel upstream patches are divided into three phases=
:
>      1. Common APIs and PCI device direct assignment
>      2. IOMMU-backed Mediated Device assignment
>      3. Page Request Services (PRS) support
>
> This QEMU patchset is aiming for the phase 1 and phase 2. It is based
> on the two kernel series below.
> [1] [PATCH V10 00/11] Nested Shared Virtual Address (SVA) VT-d support:
> https://lkml.org/lkml/2020/3/20/1172
> [2] [PATCH v1 0/8] vfio: expose virtual Shared Virtual Addressing to VM=
s
> https://lkml.org/lkml/2020/3/22/116
>
> There are roughly two parts:
>   1. Introduce HostIOMMUContext as abstract of host IOMMU. It provides =
explicit
>      method for vIOMMU emulators to communicate with host IOMMU. e.g. p=
ropagate
>      guest page table binding to host IOMMU to setup dual-stage DMA tra=
nslation
>      in host IOMMU and flush iommu iotlb.
>   2. Setup dual-stage IOMMU translation for Intel vIOMMU. Includes
>      - Check IOMMU uAPI version compatibility and VFIO Nesting capabili=
ties which
>        includes hardware compatibility (stage 1 format) and VFIO_PASID_=
REQ
>        availability. This is preparation for setting up dual-stage DMA =
translation
>        in host IOMMU.
>      - Propagate guest PASID allocation and free request to host.
>      - Propagate guest page table binding to host to setup dual-stage I=
OMMU DMA
>        translation in host IOMMU.
>      - Propagate guest IOMMU cache invalidation to host to ensure iotlb
>        correctness.
>
> The complete QEMU set can be found in below link:
> https://github.com/luxis1999/qemu.git: sva_vtd_v10_v2


Hi Yi:

I could not find the branch there.

Thanks

