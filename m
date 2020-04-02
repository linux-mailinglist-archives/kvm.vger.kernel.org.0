Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F005419C2EB
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgDBNqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:46:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56192 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726425AbgDBNqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 09:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585835170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9A3CnEsiXSDPqkUmIOaIkmymme/2Og0VecqbFgiZyxU=;
        b=GmCP4Xlt4C2KnIZlmoMX+bpvEaFIZhS7csuG2PVI71hrbp7Z0z/LZRBR1E5c7tkEPBELIX
        lJsRHJppZCJX/QnUKUDPOQO2ac2EJYFfTTqz2g+rxS0D3HyMkhRMfMCRZ3sMkjEmSNS8+S
        KqtulxM3oEbUe7TQd5FaEzBjju620tc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-l5KILIX_NDq6BvMCbfnx_Q-1; Thu, 02 Apr 2020 09:46:07 -0400
X-MC-Unique: l5KILIX_NDq6BvMCbfnx_Q-1
Received: by mail-wr1-f69.google.com with SMTP id e10so1504973wru.6
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 06:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9A3CnEsiXSDPqkUmIOaIkmymme/2Og0VecqbFgiZyxU=;
        b=UTSNAP5dmA+iEEg81TI4o+BjG98NxRMgfcLzfcDh8LNADyYXLlBAnOCUUmqCGesSOA
         NNJcjoBmu/E8MK4/CdVXMDTY88Vxhf/1cWN8e3RcNFKRmwRcJ1SKTflgI8dbOhPJZc9C
         L/1fyf1HOMynrR2R1sTdFfXgBmrKghUZDWydegxp2VeQ5NqXeHDQlNWNF1ni2e2X2kAo
         HPxzAzbclA8pOdJ6OwXqlNrresE28FHsSSD4wkTdVQ6sOpbBmSlM5nal3aqEunatnPcL
         0wA8x7Cbp1+Ly8jMpWKlCtuhEvgdF5+lOzRtTfBZqXadIrdMckAl3Td/gyQBDJvcr3wk
         QMbw==
X-Gm-Message-State: AGi0PuaLKpSmIPZWPyCBpUQEFDrrhWezP5zrP1eKUVgOKTxFy4Gzh6Xx
        ppIzcWjWtUwyfzAEWwHR6IWSkTW0npvGzPIfItck+SCfp9h+V2VoWGWVl1vNLjjlL3TR3W43w8K
        bHPfYyFk6RrnR
X-Received: by 2002:adf:ea83:: with SMTP id s3mr3918074wrm.25.1585835166200;
        Thu, 02 Apr 2020 06:46:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypJZChRwPcgHJam48Q8buWnfLkcBSM2myx23vHYz3rJj5PGDm/NVXjc+sk4Us05VYvFGWrOXZw==
X-Received: by 2002:adf:ea83:: with SMTP id s3mr3918048wrm.25.1585835165988;
        Thu, 02 Apr 2020 06:46:05 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a82sm9404955wmh.0.2020.04.02.06.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 06:46:05 -0700 (PDT)
Date:   Thu, 2 Apr 2020 09:46:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, jean-philippe@linaro.org,
        kevin.tian@intel.com, kvm@vger.kernel.org, mst@redhat.com,
        jun.j.tian@intel.com, eric.auger@redhat.com, yi.y.sun@intel.com,
        pbonzini@redhat.com, hao.wu@intel.com, david@gibson.dropbear.id.au
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Message-ID: <20200402134601.GJ7174@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <984e6f47-2717-44fb-7ff2-95ca61d1858f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <984e6f47-2717-44fb-7ff2-95ca61d1858f@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 04:33:02PM +0800, Jason Wang wrote:
> > The complete QEMU set can be found in below link:
> > https://github.com/luxis1999/qemu.git: sva_vtd_v10_v2
> 
> 
> Hi Yi:
> 
> I could not find the branch there.

Jason,

He typed wrong... It's actually (I found it myself):

https://github.com/luxis1999/qemu/tree/sva_vtd_v10_qemu_v2

-- 
Peter Xu

