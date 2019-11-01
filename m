Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F124EC844
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfKASJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfKASJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:09:28 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25B35C057EC6
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 18:09:28 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id m3so5388457wrs.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=moDkDlUhxfJhmtHJeueY/UnIk6Z5ALI8m+SrJOHk+eI=;
        b=nM1fd610x6AD/LKMTiDu127ddycG0KMRJGGPXwqcATtXdnnAB9OEl/Ph4sUzs6Eahq
         oqtObVTG5HyqYkl11cnxO2ZxpzZOG4Pd/uwIwxDMjIg3C55iah5+s32HKv5XQ3plzwGF
         yjMCvVcij1tDPIOV0zFUSFs9vO76O/p30as0sEqAbxs6ORWgFjmfViBVZdhT5/iOgVT8
         VFB3YFglw+wbJ7cnB/Jx2ZFCmYYoopcqKr73n/Oa4b9RH1O3lFUBprXVjIpWULTv2FGT
         H03JEY7qoXG6xoMTlhw+nfmEhk4Kon2hQwWdMRTpbejjToSoh3UaCdBH5zt9Ne8myikL
         S5Xg==
X-Gm-Message-State: APjAAAVfe28a3OBtoTDRC18foZ3iLQj8NBAn7SiswjRaqvfO823P1xJ6
        Vm2dq4a4cf3ClkZ1sMoZdC+5rBoVsgfN2IEx0c8GSMkcopWgiHT0eR2v2FeLTFxRGdrUSmUp84/
        I0duJLiqT+/aC
X-Received: by 2002:adf:f905:: with SMTP id b5mr11795769wrr.122.1572631766868;
        Fri, 01 Nov 2019 11:09:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxiDGch/xVNxtqV43qVHrL6TwudUG5rxeu9lr80qXRYAZbkhvjpjLsf7yZBWkwy1mt5fm8TPw==
X-Received: by 2002:adf:f905:: with SMTP id b5mr11795760wrr.122.1572631766712;
        Fri, 01 Nov 2019 11:09:26 -0700 (PDT)
Received: from xz-x1.metropole.lan (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id u7sm8313190wre.59.2019.11.01.11.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 11:09:25 -0700 (PDT)
Date:   Fri, 1 Nov 2019 19:09:23 +0100
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 06/22] hw/pci: modify pci_setup_iommu() to set
 PCIIOMMUOps
Message-ID: <20191101180923.GG8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-7-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:27AM -0400, Liu Yi L wrote:
> This patch modifies pci_setup_iommu() to set PCIIOMMUOps instead of only
> setting PCIIOMMUFunc. PCIIOMMUFunc is previously used to get an address
> space for a device in vendor specific way. The PCIIOMMUOps still offers
> this functionality. Use PCIIOMMUOps leaves space to add more iommu related
> vendor specific operations.
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
