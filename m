Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91F362FBE
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 06:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfGIErt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 00:47:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38569 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGIErt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 00:47:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so1950366plb.5
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 21:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QNbrzB+/bPBWg3QE0yjGSY8stZC5Z6uXlKMCTpdJeVg=;
        b=PvsjoXv+O+clv6m03ym0T6rYe2SXkueGX2Q5RsZGF5rpNdcLm5q/0I+nefE839dX5f
         P8d45ZSGIRsEVTrt8ijzIP4vmk2918M4532ja913PvhbbF8hXFouHIM6JtsmzdStMwlx
         88S1vlE/EYT5eBXwWojioRJJx8v51N+s0kjAm14xCMNKiegot1W7l3cpITgbhCWbAd43
         ibxu+jYYqgNKmXsc+S+6iVI75isatMwPuYDt9XPnBcr4CEMpqwthhjzELtmE5xA1TS4/
         qsfzRmDJqWzlneLijvRZSthFC02iK9CPEGXp2H3KiOohnx6OliNQf2DRLiYjzEVjJHzQ
         t6dw==
X-Gm-Message-State: APjAAAUsq+p8dFAtFo8EzW+QaU/OQWiPe6HAr4elQGeFguHE2ES/01cG
        z0dflGXWTEMGZJdpnu31WheyGA==
X-Google-Smtp-Source: APXvYqyejTegq1bLYU9a0KpYiBvfYeKowVQ1I1tWM5iBqpvuejXSJdcQ31i84YJASz8aoU1UQHxxNw==
X-Received: by 2002:a17:902:e210:: with SMTP id ce16mr29869188plb.335.1562647668752;
        Mon, 08 Jul 2019 21:47:48 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o24sm14302620pfp.135.2019.07.08.21.47.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 21:47:48 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 12:47:37 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 09/18] intel_iommu: process pasid cache invalidation
Message-ID: <20190709044737.GE5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-10-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-10-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:42PM +0800, Liu Yi L wrote:
> +static bool vtd_process_pasid_desc(IntelIOMMUState *s,
> +                                   VTDInvDesc *inv_desc)
> +{
> +    if ((inv_desc->val[0] & VTD_INV_DESC_PASIDC_RSVD_VAL0) ||
> +        (inv_desc->val[1] & VTD_INV_DESC_PASIDC_RSVD_VAL1) ||
> +        (inv_desc->val[2] & VTD_INV_DESC_PASIDC_RSVD_VAL2) ||
> +        (inv_desc->val[3] & VTD_INV_DESC_PASIDC_RSVD_VAL3)) {
> +        trace_vtd_inv_desc("non-zero-field-in-pc_inv_desc",
> +                            inv_desc->val[1], inv_desc->val[0]);

The first parameter of trace_vtd_inv_desc() should be the type.

Can use error_report_once() here.

> +        return false;
> +    }
> +
> +    switch (inv_desc->val[0] & VTD_INV_DESC_PASIDC_G) {
> +    case VTD_INV_DESC_PASIDC_DSI:
> +        break;
> +
> +    case VTD_INV_DESC_PASIDC_PASID_SI:
> +        break;
> +
> +    case VTD_INV_DESC_PASIDC_GLOBAL:
> +        break;
> +
> +    default:
> +        trace_vtd_inv_desc("invalid-inv-granu-in-pc_inv_desc",
> +                            inv_desc->val[1], inv_desc->val[0]);

Here too.

> +        return false;
> +    }
> +
> +    return true;
> +}

Regards,

-- 
Peter Xu
