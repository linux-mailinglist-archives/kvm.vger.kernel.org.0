Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A3ECFBA
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 17:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfKBQVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 12:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfKBQVB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 12:21:01 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E61AD51462
        for <kvm@vger.kernel.org>; Sat,  2 Nov 2019 16:21:00 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id e25so7484199wra.9
        for <kvm@vger.kernel.org>; Sat, 02 Nov 2019 09:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wuMCUxRP1lAk5GwvAKDfq7V0e1MiDqG1nrYNKrrSOq4=;
        b=sV4oI0TSWxvDBHyJGWx2UOZC8nBtupcU7vAq9jQTITM6bKfoWNlTDhLY9FldRXS2kq
         r9aLERO0LVTJzeNCPTby/ZO7KeFtjDUTCpmLs6X7g5OmiPx+lx1EDOTq6g/BUJemSchV
         CsmMc9Zl/TqnaNKEhbVCFOkEAocxjNaCveyoFKYwLWRDc8KMc75rOTN+yWFVSxDe35QH
         ANdQB9smktGXTzRnG8ajJqkFnyOOvfjtRlvEpWM6lf0PHavL47hNs/woiIFeUI7We3Tl
         jRiQ2+xpxmxsGoyHSEU/Pf9W+IkFSlPfEOPBxw0TgrHO9iFSCJHsvE3hGHFCENOHS+Pl
         EMXw==
X-Gm-Message-State: APjAAAU+YDGrrgcz1YeF/87CfMVI59S6nv1nKv5MM/EyucXjOoFFmI3/
        VY2pbF1DgiVV8r2BV+DaADDwlRhRaIGDDGNZ+ZBFnJfWrwQZ8z1PyNmXXziSARDRdKN4R/GmxK5
        qpJ07MA02SDnS
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr14992062wma.1.1572711659677;
        Sat, 02 Nov 2019 09:20:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzfhyyPavGiH1PSwta220GyIdOGae10Ml8kC20xVSyBWiCtsTuFFqHxTXvVnlBq8+5fwV41+A==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr14992049wma.1.1572711659527;
        Sat, 02 Nov 2019 09:20:59 -0700 (PDT)
Received: from xz-x1.metropole.lan ([213.58.148.146])
        by smtp.gmail.com with ESMTPSA id v9sm9606220wrs.95.2019.11.02.09.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 09:20:58 -0700 (PDT)
Date:   Sat, 2 Nov 2019 16:20:51 +0000
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 12/22] intel_iommu: add present bit check for pasid
 table entries
Message-ID: <20191102162051.GB26023@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-13-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-13-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:33AM -0400, Liu Yi L wrote:
> The present bit check for pasid entry (pe) and pasid directory
> entry (pdire) were missed in previous commits as fpd bit check
> doesn't require present bit as "Set". This patch adds the present
> bit check for callers which wants to get a valid pe/pdire.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu
